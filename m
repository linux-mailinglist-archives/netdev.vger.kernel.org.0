Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD2E460D612
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 23:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231903AbiJYVVS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 17:21:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230345AbiJYVVR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 17:21:17 -0400
Received: from mail-oo1-f42.google.com (mail-oo1-f42.google.com [209.85.161.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85CB656B95;
        Tue, 25 Oct 2022 14:21:14 -0700 (PDT)
Received: by mail-oo1-f42.google.com with SMTP id r11-20020a4aa2cb000000b004806f49e27eso2053568ool.7;
        Tue, 25 Oct 2022 14:21:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=deetLSjfSLw9NGtsLyl5oAnaBu5KwyE7PmCTC5CrpT4=;
        b=f137sr7tyDGBEB9TIbhKG85JgRx3aBMWnAghATpWvVCcG1udzWQQujiotbU4bu1qQ0
         aLWZ0gRAUPMl/KNdoySQtNJyuc0BZVCyvUmVRM0wAf+8s1bKwmPA9h0XKLBRXLsW+Iz3
         zaw+eYy0+qAzlVKTGdWTcwCTY8PB/zGh2yLN+eXhImC8V/WAsUjbnCSHnZlvboOU00jJ
         aFUP4C6hhLMbbKE8wBwTMKeCeo39IioeKdFQ+MCBMz8LFoK/IEyCjlrB3KDFC88nHXT+
         ptA6WJoOl3Ce/TWhtVWtAsONGgDBfKtOCPOgJxqoBZ9y2n5rwiFbi03x4E8uojY0nURt
         vMIA==
X-Gm-Message-State: ACrzQf2pHYYVnnYJtjymyJCy/OD4Aq+gWvL4RJ22MZvqbKuA0fVwRN96
        5iIh6XwKk6wjx75JBCD7guAmOfMMGw==
X-Google-Smtp-Source: AMsMyM7B0w6ukcpx4u+vNpmoWkDfOMj27vFI0GB9Idy7Se4NJx5Z1z15XHQVQGmHzX5VFVzePHTM/w==
X-Received: by 2002:a4a:a387:0:b0:480:9a7a:4e99 with SMTP id s7-20020a4aa387000000b004809a7a4e99mr17647401ool.4.1666732873594;
        Tue, 25 Oct 2022 14:21:13 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id c31-20020a9d27a2000000b006622d085a7fsm1449429otb.50.2022.10.25.14.21.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 14:21:13 -0700 (PDT)
Received: (nullmailer pid 3335003 invoked by uid 1000);
        Tue, 25 Oct 2022 21:21:14 -0000
Date:   Tue, 25 Oct 2022 16:21:14 -0500
From:   Rob Herring <robh@kernel.org>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        =?iso-8859-1?Q?n=E7_=DCNAL?= <arinc.unal@arinc9.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Lee Jones <lee@kernel.org>
Subject: Re: [PATCH v1 net-next 3/7] dt-bindings: net: dsa: qca8k: utilize
 shared dsa.yaml
Message-ID: <20221025212114.GA3322299-robh@kernel.org>
References: <20221025050355.3979380-1-colin.foster@in-advantage.com>
 <20221025050355.3979380-4-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221025050355.3979380-4-colin.foster@in-advantage.com>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 24, 2022 at 10:03:51PM -0700, Colin Foster wrote:
> The dsa.yaml binding contains duplicated bindings for address and size
> cells, as well as the reference to dsa-port.yaml. Instead of duplicating
> this information, remove the reference to dsa-port.yaml and include the
> full reference to dsa.yaml.

I don't think this works without further restructuring. Essentially, 
'unevaluatedProperties' on works on a single level. So every level has 
to define all properties at that level either directly in 
properties/patternProperties or within a $ref.

See how graph.yaml is structured and referenced for an example how this 
has to work.

> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> Suggested-by: Vladimir Oltean <olteanv@gmail.com>
> ---
>  .../devicetree/bindings/net/dsa/qca8k.yaml         | 14 +++-----------
>  1 file changed, 3 insertions(+), 11 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.yaml b/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
> index 978162df51f7..7884f68cab73 100644
> --- a/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
> +++ b/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
> @@ -66,22 +66,16 @@ properties:
>                   With the legacy mapping the reg corresponding to the internal
>                   mdio is the switch reg with an offset of -1.
>  
> +$ref: "dsa.yaml#"
> +
>  patternProperties:
>    "^(ethernet-)?ports$":
>      type: object
> -    properties:
> -      '#address-cells':
> -        const: 1
> -      '#size-cells':
> -        const: 0
> -
>      patternProperties:
>        "^(ethernet-)?port@[0-6]$":
>          type: object
>          description: Ethernet switch ports
>  
> -        $ref: dsa-port.yaml#
> -
>          properties:
>            qca,sgmii-rxclk-falling-edge:
>              $ref: /schemas/types.yaml#/definitions/flag
> @@ -104,8 +98,6 @@ patternProperties:
>                SGMII on the QCA8337, it is advised to set this unless a communication
>                issue is observed.
>  
> -        unevaluatedProperties: false
> -

Dropping this means any undefined properties in port nodes won't be an 
error. Once I fix all the issues related to these missing, there will be 
a meta-schema checking for this (this could be one I fixed already).

>  oneOf:
>    - required:
>        - ports
> @@ -116,7 +108,7 @@ required:
>    - compatible
>    - reg
>  
> -additionalProperties: true

This should certainly be changed though. We should only have 'true' for 
incomplete collections of properties. IOW, for common bindings.

> +unevaluatedProperties: false
>  
>  examples:
>    - |
> -- 
> 2.25.1
> 
> 
