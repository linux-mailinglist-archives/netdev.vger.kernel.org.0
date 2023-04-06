Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46C886D933C
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 11:50:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236491AbjDFJuK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 05:50:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236982AbjDFJts (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 05:49:48 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D400561AE;
        Thu,  6 Apr 2023 02:48:16 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1pkMCs-0000AJ-2t;
        Thu, 06 Apr 2023 11:47:03 +0200
Date:   Thu, 6 Apr 2023 10:46:59 +0100
From:   Daniel Golle <daniel@makrotopia.org>
To:     arinc9.unal@gmail.com
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH 3/7] dt-bindings: net: dsa: mediatek,mt7530: add port
 bindings for MT7988
Message-ID: <ZC6VE2C5KAza8U8r@makrotopia.org>
References: <20230406080141.22924-1-arinc.unal@arinc9.com>
 <20230406080141.22924-3-arinc.unal@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230406080141.22924-3-arinc.unal@arinc9.com>
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 06, 2023 at 11:01:37AM +0300, arinc9.unal@gmail.com wrote:
> From: Arınç ÜNAL <arinc.unal@arinc9.com>
> 
> The switch on MT7988 has got only port 6 as a CPU port. The only phy-mode
> to be used is internal. Add this.
> 
> Some bindings are incorrect for this switch now, so move them to more
> specific places.
> 
> Address the incorrect information of which ports can be used as a user
> port. Any port can be used as a user port.
> 
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>

Acked-by: Daniel Golle <daniel@makrotopia.org>

> ---
>  .../bindings/net/dsa/mediatek,mt7530.yaml     | 63 ++++++++++++++-----
>  1 file changed, 46 insertions(+), 17 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> index 7045a98d9593..605888ce2bc6 100644
> --- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> +++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> @@ -160,22 +160,6 @@ patternProperties:
>        "^(ethernet-)?port@[0-9]+$":
>          type: object
>  
> -        properties:
> -          reg:
> -            description:
> -              Port address described must be 5 or 6 for CPU port and from 0 to 5
> -              for user ports.
> -
> -        allOf:
> -          - if:
> -              required: [ ethernet ]
> -            then:
> -              properties:
> -                reg:
> -                  enum:
> -                    - 5
> -                    - 6
> -
>  required:
>    - compatible
>    - reg
> @@ -186,9 +170,21 @@ $defs:
>        "^(ethernet-)?ports$":
>          patternProperties:
>            "^(ethernet-)?port@[0-9]+$":
> +            properties:
> +              reg:
> +                description:
> +                  Port address described must be 5 or 6 for the CPU port. User
> +                  ports can be 0 to 6.
> +
>              if:
>                required: [ ethernet ]
>              then:
> +              properties:
> +                reg:
> +                  enum:
> +                    - 5
> +                    - 6
> +
>                if:
>                  properties:
>                    reg:
> @@ -212,9 +208,21 @@ $defs:
>        "^(ethernet-)?ports$":
>          patternProperties:
>            "^(ethernet-)?port@[0-9]+$":
> +            properties:
> +              reg:
> +                description:
> +                  Port address described must be 5 or 6 for the CPU port. User
> +                  ports can be 0 to 6.
> +
>              if:
>                required: [ ethernet ]
>              then:
> +              properties:
> +                reg:
> +                  enum:
> +                    - 5
> +                    - 6
> +
>                if:
>                  properties:
>                    reg:
> @@ -235,6 +243,27 @@ $defs:
>                        - 2500base-x
>                        - sgmii
>  
> +  mt7988-dsa-port:
> +    patternProperties:
> +      "^(ethernet-)?ports$":
> +        patternProperties:
> +          "^(ethernet-)?port@[0-9]+$":
> +            properties:
> +              reg:
> +                description:
> +                  Port address described must be 6 for the CPU port. User ports
> +                  can be 0 to 3, and 6.
> +
> +            if:
> +              required: [ ethernet ]
> +            then:
> +              properties:
> +                reg:
> +                  const: 6
> +
> +                phy-mode:
> +                  const: internal
> +
>  allOf:
>    - $ref: dsa.yaml#/$defs/ethernet-ports
>    - if:
> @@ -285,7 +314,7 @@ allOf:
>          compatible:
>            const: mediatek,mt7988-switch
>      then:
> -      $ref: "#/$defs/mt7530-dsa-port"
> +      $ref: "#/$defs/mt7988-dsa-port"
>        properties:
>          gpio-controller: false
>          mediatek,mcm: false
> -- 
> 2.37.2
> 
