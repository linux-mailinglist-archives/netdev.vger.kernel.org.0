Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE95B63B5D6
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 00:28:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234670AbiK1X2E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 18:28:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233914AbiK1X2D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 18:28:03 -0500
Received: from mail-oa1-f48.google.com (mail-oa1-f48.google.com [209.85.160.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13479303E7;
        Mon, 28 Nov 2022 15:28:02 -0800 (PST)
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-14279410bf4so15031256fac.8;
        Mon, 28 Nov 2022 15:28:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Tkm1rZJjYKH+0e9XPZ9u8/k0fPDDDPFuGFSeOnuxztc=;
        b=a48QLAhy9596GHqxirjRR600UZtVmJgk717cAI5ueGLBZiTlDzzGNfjqbySuRQmgBE
         gopBJSWHPJKX5z9N3SAJqFkPvkDjM2r8eixh6jBsobnNotoI3e03dWYydPN7y2Bss6bC
         +XJWuteHpwDDyZZq02xjsCHWSvBhal7d8ALjI0YWkbfg02z285NCcChzR1i2X8Af3749
         JBeI1IGTWHRqVw2cXxZ3rIMEGa1Wb7L8ZTggZrcYBqk7/0F46P8+wa5LiQW8otoYxBWa
         FXwYusDUkd9fcyNYOHXznlE/LmevhqJhT8liJUUWUZ8LvFPajN/Cfa9uMYzBH0n6T30I
         i+uA==
X-Gm-Message-State: ANoB5pluewewhbuCvqeGfDwycaeBUWyY7Vp3ZObDDiXCpStTERIUPBci
        8ibSkD64qe+kL7er3A61vA==
X-Google-Smtp-Source: AA0mqf6qF068jOcZq5Clqc6PLJt0qCSUkbx+Op8bIK1f/R2Musri8+9p2qalTkmaXTGmtt/SSb+sHw==
X-Received: by 2002:a05:6871:438a:b0:13b:a9ac:ad64 with SMTP id lv10-20020a056871438a00b0013ba9acad64mr21826598oab.290.1669678081277;
        Mon, 28 Nov 2022 15:28:01 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id b5-20020a056870d1c500b00143776f70d3sm5043217oac.29.2022.11.28.15.27.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Nov 2022 15:28:00 -0800 (PST)
Received: (nullmailer pid 1691394 invoked by uid 1000);
        Mon, 28 Nov 2022 23:27:59 -0000
Date:   Mon, 28 Nov 2022 17:27:59 -0600
From:   Rob Herring <robh@kernel.org>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     linux-renesas-soc@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        John Crispin <john@phrozen.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Marek Vasut <marex@denx.de>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        =?UTF-8?B?bsOnIMOcTkFM?= <arinc.unal@arinc9.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        UNGLinuxDriver@microchip.com,
        Woojung Huh <woojung.huh@microchip.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        George McCollister <george.mccollister@gmail.com>
Subject: Re: [PATCH v3 net-next 04/10] dt-bindings: net: dsa: allow
 additional ethernet-port properties
Message-ID: <20221128232759.GB1513198-robh@kernel.org>
References: <20221127224734.885526-1-colin.foster@in-advantage.com>
 <20221127224734.885526-5-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221127224734.885526-5-colin.foster@in-advantage.com>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 27, 2022 at 02:47:28PM -0800, Colin Foster wrote:
> Explicitly allow additional properties for both the ethernet-port and
> ethernet-ports properties. This specifically will allow the qca8k.yaml
> binding to use shared properties.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---
> 
> v2 -> v3
>   * No change
> 
> v1 -> v2
>   * New patch
> 
> ---
>  Documentation/devicetree/bindings/net/dsa/dsa.yaml | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/dsa.yaml b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
> index bd1f0f7c14a8..87475c2ab092 100644
> --- a/Documentation/devicetree/bindings/net/dsa/dsa.yaml
> +++ b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
> @@ -38,6 +38,8 @@ patternProperties:
>        '#size-cells':
>          const: 0
>  
> +    additionalProperties: true
> +

Where then do we restrict adding properties to ethernet-ports nodes?

>      patternProperties:
>        "^(ethernet-)?port@[0-9]+$":
>          type: object
> @@ -45,7 +47,7 @@ patternProperties:
>  
>          $ref: dsa-port.yaml#
>  
> -        unevaluatedProperties: false
> +        unevaluatedProperties: true

Same question for ethernet-port nodes.

>  
>  oneOf:
>    - required:
> -- 
> 2.25.1
> 
> 
