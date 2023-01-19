Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED410674375
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 21:21:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbjASUVW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 15:21:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229971AbjASUVV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 15:21:21 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F08F99B125;
        Thu, 19 Jan 2023 12:21:18 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id az20so8782397ejc.1;
        Thu, 19 Jan 2023 12:21:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=eAfTheDsldomxpbKQZ8yWFgF6bHzEWGRuW3vjcWnsNM=;
        b=JJCXOq1C+hmjwU4fORTcgiCmsy+ngUNCFQJFV9RR3gCr6eAaQojwJmDpJoi+LDViHG
         FhajC2KB2N/Abkw54H33t7xi1IyWmdFyae9MWHUvgLgyk4eQlCEGBVED5J4iFm7QOO7g
         gMQMd4Q9h8ciwQNbqOCB/xxoOoBN6LrM1X8ecVmxyEJPq6m4Py33vEUVlRRNBSjImkfv
         NqqGG0LSRbaGnGmY8ybIKc2XZ8/S/8ayA91MU+/dA2AssgYGr1imxcqcAdMNTAi5OnMU
         +bh21bpcBSY4Dl4uyaFNRj+SdpjnsiwHu0fyhvzKte9odVf+hai4ijSrUsM8anCPQQGa
         VfWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eAfTheDsldomxpbKQZ8yWFgF6bHzEWGRuW3vjcWnsNM=;
        b=rKaJUYLk/F/h5FuXf1K36BKbELg04Ouol8ZTjDL+KTmZzgxm8eWA86YrosOfNt73L8
         4/Gjzc9ciMW1anOKo6+u6NbgJFDNogweMxLAh5uxxpE2U3FRNjv7fooLrPjPRPkRi6Rq
         jOFDck2XJKQimvaTwfXuVaRKAQpQqAcKEuBWP2K2uXEc1pW0iLcB37ECg0X4x2mLwEHl
         Ed+ekPJOba+fyvD6daBHOM2Yv9wVq82u+57++9xPhPS6IKbqx42o7Zkf2wWz4UVWRKmc
         ic6z5qZIdAFhF2dzuEQAOQ+ImX1Po7y7fqLd+tED1N/PcuKgOrFcvWkj4tTO5Z7L3vT0
         6daQ==
X-Gm-Message-State: AFqh2kolVjRtMLCptYTAjOs+wOJ75YxGQO/gEUhL9z0xhYjjh6hhVyWN
        EuBA2seGZ/wmI4pV/NHGjCI=
X-Google-Smtp-Source: AMrXdXuSzXeG0cdCgOgjlXU1Z8dWIkeXhCadD+6AZLkyNyriCTGYq6qQEw60qTSp2BLPjhDm5jkiYg==
X-Received: by 2002:a17:907:8c17:b0:871:38cc:7b3a with SMTP id ta23-20020a1709078c1700b0087138cc7b3amr3009149ejc.75.1674159677371;
        Thu, 19 Jan 2023 12:21:17 -0800 (PST)
Received: from skbuf ([188.27.185.85])
        by smtp.gmail.com with ESMTPSA id e20-20020a170906249400b0084d4cb00f0csm14025115ejb.99.2023.01.19.12.21.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jan 2023 12:21:16 -0800 (PST)
Date:   Thu, 19 Jan 2023 22:21:13 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Lee Jones <lee@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH v3 net-next 12/14] dt-bindings: net: dsa: ocelot: add
 ocelot-ext documentation
Message-ID: <20230119202113.lwya43hjvosjk77a@skbuf>
References: <455e31be-dc87-39b3-c7fe-22384959c556@linaro.org>
 <Yz2mSOXf68S16Xg/@colin-ia-desktop>
 <28b4d9f9-f41a-deca-aa61-26fb65dcc873@linaro.org>
 <20221008000014.vs2m3vei5la2r2nd@skbuf>
 <c9ce1d83-d1ca-4640-bba2-724e18e6e56b@linaro.org>
 <20221010130707.6z63hsl43ipd5run@skbuf>
 <d27d7740-bf35-b8d4-d68c-bb133513fa19@linaro.org>
 <20221010174856.nd3n4soxk7zbmcm7@skbuf>
 <Y8hylFFOw4n5RH83@MSI.localdomain>
 <Y8hylFFOw4n5RH83@MSI.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y8hylFFOw4n5RH83@MSI.localdomain>
 <Y8hylFFOw4n5RH83@MSI.localdomain>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Colin,

On Wed, Jan 18, 2023 at 12:28:36PM -1000, Colin Foster wrote:
> Resurrecting this conversation for a quick question / feedback, now that
> steps 1-7 are essentially done with everyone's help.
> 
> I don't want to send out a full RFC / Patch, since I can't currently
> test on hardware this week. But I'd really like feedback on the
> documentation change that is coming up. And I also don't want to
> necessarily do a separate RFC for just this patch.
> 
> What happens here is interrupts and interrupt-names work as expected.
> They're required for the 7514, and optional for the 7512. Fantastic.
> 
> I'm not sure if the "$ref: ethernet-switch.yaml" and
> "$ref: /schemas/net/dsa/dsa.yaml#" have an effect, since removing that
> line outright doesn't seem to have an effect on dt_bindings_check.
> 
> The "fdma" doesn't make sense for the 7512, and seems to be handled
> correctly by way of maxItems for the two scenarios.
> 
> 
> The big miss in this patch is ethernet-switch-port vs dsa-port in the
> two scenarios. It isn't working as I'd hoped, where the 7514 pulls in
> ethernet-switch-port.yaml and the 7512 pulls in dsa-port.yaml. To squash
> errors about the incorrect "ethernet" property I switched this line:
> 
> -        $ref: ethernet-switch-port.yaml#
> +        $ref: /schemas/net/dsa/dsa-port.yaml#
> 
> ... knowing full well that the correct solution should be along the
> lines of "remove this, and only reference them in the conditional". That
> doesn't seem to work though...
> 
> Is what I'm trying to do possible? I utilized
> Documentation/devicetree/bindings/net/dsa/*.yaml and
> Documentation/devicetree/bindings/net/*.yaml and found examples to get
> to my current state.
> 
> 
> diff --git a/Documentation/devicetree/bindings/net/mscc,vsc7514-switch.yaml b/Documentation/devicetree/bindings/net/mscc,vsc7514-switch.yaml
> index 5ffe831e59e4..f012c64a0da3 100644
> --- a/Documentation/devicetree/bindings/net/mscc,vsc7514-switch.yaml
> +++ b/Documentation/devicetree/bindings/net/mscc,vsc7514-switch.yaml
> @@ -18,13 +18,50 @@ description: |
>    packets using CPU. Additionally, PTP is supported as well as FDMA for faster
>    packet extraction/injection.
>  
> -$ref: ethernet-switch.yaml#
> +allOf:
> +  - if:
> +      properties:
> +        compatible:
> +          const: mscc,vsc7514-switch
> +    then:
> +      $ref: ethernet-switch.yaml#
> +      required:
> +        - interrupts
> +        - interrupt-names
> +      properties:
> +        reg:
> +          minItems: 21
> +        reg-names:
> +          minItems: 21
> +        ethernet-ports:
> +          patternProperties:
> +            "^port@[0-9a-f]+$":
> +              $ref: ethernet-switch-port.yaml#
> +
> +  - if:
> +      properties:
> +        compatible:
> +          const: mscc,vsc7512-switch
> +    then:
> +      $ref: /schemas/net/dsa/dsa.yaml#
> +      properties:
> +        reg:
> +          maxItems: 20
> +        reg-names:
> +          maxItems: 20
> +        ethernet-ports:
> +          patternProperties:
> +            "^port@[0-9a-f]+$":
> +              $ref: /schemas/net/dsa/dsa-port.yaml#
>  
>  properties:
>    compatible:
> -    const: mscc,vsc7514-switch
> +    enum:
> +      - mscc,vsc7512-switch
> +      - mscc,vsc7514-switch
>  
>    reg:
> +    minItems: 20
>      items:
>        - description: system target
>        - description: rewriter target
> @@ -49,6 +86,7 @@ properties:
>        - description: fdma target
>  
>    reg-names:
> +    minItems: 20
>      items:
>        - const: sys
>        - const: rew
> @@ -100,7 +138,7 @@ properties:
>      patternProperties:
>        "^port@[0-9a-f]+$":
>  
> -        $ref: ethernet-switch-port.yaml#
> +        $ref: /schemas/net/dsa/dsa-port.yaml#
>  
>          unevaluatedProperties: false

I'm not sure at all why this chunk (is sub-schema the right word) even
exists, considering you have the other one?!

>  
> @@ -108,13 +146,12 @@ required:
>    - compatible
>    - reg
>    - reg-names
> -  - interrupts
> -  - interrupt-names
>    - ethernet-ports
>  
>  additionalProperties: false

This should be "unevaluatedProperties: false" I guess? Maybe this is why
deleting the ethernet-switch.yaml or dsa.yaml schema appears to do nothing?

The following delta compared to net-next works for me, I think:

diff --git a/Documentation/devicetree/bindings/net/mscc,vsc7514-switch.yaml b/Documentation/devicetree/bindings/net/mscc,vsc7514-switch.yaml
index 5ffe831e59e4..dc3319ea40b9 100644
--- a/Documentation/devicetree/bindings/net/mscc,vsc7514-switch.yaml
+++ b/Documentation/devicetree/bindings/net/mscc,vsc7514-switch.yaml
@@ -18,13 +18,52 @@ description: |
   packets using CPU. Additionally, PTP is supported as well as FDMA for faster
   packet extraction/injection.
 
-$ref: ethernet-switch.yaml#
+allOf:
+  - if:
+      properties:
+        compatible:
+          const: mscc,vsc7514-switch
+    then:
+      $ref: ethernet-switch.yaml#
+      required:
+        - interrupts
+        - interrupt-names
+      properties:
+        reg:
+          minItems: 21
+        reg-names:
+          minItems: 21
+        ethernet-ports:
+          patternProperties:
+            "^port@[0-9a-f]+$":
+              $ref: ethernet-switch-port.yaml#
+              unevaluatedProperties: false
+
+  - if:
+      properties:
+        compatible:
+          const: mscc,vsc7512-switch
+    then:
+      $ref: /schemas/net/dsa/dsa.yaml#
+      properties:
+        reg:
+          maxItems: 20
+        reg-names:
+          maxItems: 20
+        ethernet-ports:
+          patternProperties:
+            "^port@[0-9a-f]+$":
+              $ref: /schemas/net/dsa/dsa-port.yaml#
+              unevaluatedProperties: false
 
 properties:
   compatible:
-    const: mscc,vsc7514-switch
+    enum:
+      - mscc,vsc7512-switch
+      - mscc,vsc7514-switch
 
   reg:
+    minItems: 20
     items:
       - description: system target
       - description: rewriter target
@@ -49,6 +88,7 @@ properties:
       - description: fdma target
 
   reg-names:
+    minItems: 20
     items:
       - const: sys
       - const: rew
@@ -86,35 +126,16 @@ properties:
       - const: xtr
       - const: fdma
 
-  ethernet-ports:
-    type: object
-
-    properties:
-      '#address-cells':
-        const: 1
-      '#size-cells':
-        const: 0
-
-    additionalProperties: false
-
-    patternProperties:
-      "^port@[0-9a-f]+$":
-
-        $ref: ethernet-switch-port.yaml#
-
-        unevaluatedProperties: false
-
 required:
   - compatible
   - reg
   - reg-names
-  - interrupts
-  - interrupt-names
   - ethernet-ports
 
-additionalProperties: false
+unevaluatedProperties: false
 
 examples:
+  # VSC7514 (Switchdev)
   - |
     switch@1010000 {
       compatible = "mscc,vsc7514-switch";
@@ -154,6 +175,7 @@ examples:
           reg = <0>;
           phy-handle = <&phy0>;
           phy-mode = "internal";
+          ethernet = <&mac_sw>; # fails validation as expected
         };
         port1: port@1 {
           reg = <1>;
@@ -162,5 +184,51 @@ examples:
         };
       };
     };
+  # VSC7512 (DSA)
+  - |
+    ethernet-switch@1{
+      compatible = "mscc,vsc7512-switch";
+      reg = <0x71010000 0x10000>,
+            <0x71030000 0x10000>,
+            <0x71080000 0x100>,
+            <0x710e0000 0x10000>,
+            <0x711e0000 0x100>,
+            <0x711f0000 0x100>,
+            <0x71200000 0x100>,
+            <0x71210000 0x100>,
+            <0x71220000 0x100>,
+            <0x71230000 0x100>,
+            <0x71240000 0x100>,
+            <0x71250000 0x100>,
+            <0x71260000 0x100>,
+            <0x71270000 0x100>,
+            <0x71280000 0x100>,
+            <0x71800000 0x80000>,
+            <0x71880000 0x10000>,
+            <0x71040000 0x10000>,
+            <0x71050000 0x10000>,
+            <0x71060000 0x10000>;
+            reg-names = "sys", "rew", "qs", "ptp", "port0", "port1",
+            "port2", "port3", "port4", "port5", "port6",
+            "port7", "port8", "port9", "port10", "qsys",
+            "ana", "s0", "s1", "s2";
+
+            ethernet-ports {
+            #address-cells = <1>;
+            #size-cells = <0>;
+
+          port@0 {
+            reg = <0>;
+            ethernet = <&mac_sw>;
+            phy-handle = <&phy0>;
+            phy-mode = "internal";
+          };
+          port@1 {
+            reg = <1>;
+            phy-handle = <&phy1>;
+            phy-mode = "internal";
+          };
+        };
+      };
 
 ...

Of course this is a completely uneducated attempt on my part.
