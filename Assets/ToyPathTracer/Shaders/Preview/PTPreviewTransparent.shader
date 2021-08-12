Shader "PathTracer/Preview/PTPreview Transparent"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
        [HDR]_EmissionColor("Emission", color) = (0,0,0,0)
        [Toggle] _UseTexture("UseTexture", float) = 0
        _Texture("Texture", 2D) = "white" {}
        _NormalTexture("Normal", 2D) = "bump" {}
        _MroTexture("MRO", 2D) = "black" {}
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows alpha

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        struct Input
        {
            float3 worldPos;
            float2 uv_Texture;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;
        float4 _EmissionColor;
        float _UseTexture;
        sampler2D _Texture;

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            float3 albedoColor = _Color.rgb;
            if (_UseTexture > 0.5)
            { 
                albedoColor = tex2D(_Texture, IN.uv_Texture).rgb;
                float2 c = floor(IN.worldPos.xz) * 0.5;
                albedoColor = lerp(0.5, 1, frac(c.x + c.y) * 2) * albedoColor;
            }
            o.Albedo = albedoColor;
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Emission = _EmissionColor;
            o.Alpha = _Color.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
