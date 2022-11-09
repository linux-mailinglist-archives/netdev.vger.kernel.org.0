Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B02DC623776
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 00:30:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231892AbiKIXaP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 18:30:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231843AbiKIXaO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 18:30:14 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A307E03F;
        Wed,  9 Nov 2022 15:30:13 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id w14so28113865wru.8;
        Wed, 09 Nov 2022 15:30:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Yd53OIp69atYo/xq3UTNLVEYNs18PHuXNa5tnT/NW9k=;
        b=HjI7n8jwrI1i9d0mghiBrQ8cNkDGiVdP5rlGYlbuCL5hzabhIzTU1GaXCbCIDdmzCJ
         taRsFNF8weRKi3lPSbm9yOyzDEYAkCvrP0TJFkvGGsDZ9P85EoKXVlejtNkMfAgrOher
         IK46/G4gNPm55e/0WPialtNWy/+jt+S16UBlNeYPst1vMbB0J9L7XyU/HqZtAxYGCgQC
         Wa/iRrKfzGaMrH22mZ9+AYnX4aZjADE55HttXdH/m7uZ7zLYM9qldTqu+rJ8KKDsHdB2
         RiNZUD+Byzl5eRjjk51ene6p5Q3a38n2zNkauNZmx9cGVKpIzV/y0Dg4PBbEtBend8s1
         wzyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Yd53OIp69atYo/xq3UTNLVEYNs18PHuXNa5tnT/NW9k=;
        b=J4Ud9XWLdisU4L7BHmSVEwS1ZDkDqViCxVXPHNYA58Q+407L7eUM1X0dvkCoH9+c9/
         McFtmGo4bsR9cfPcs4SofJTUCaAzx566OsQH7a7wdmVMM+Ii3romMjEaXEn42CDW4iXn
         RRQEO7i3iLtHwQow0PAzQUm9dIwkCUBB7e5vnG/xw9D6acPqhr/SVq1BzAk5AO8gtLQb
         QHOq7oLc6uns05jR/4iAGl08jIz8+zLPxiVEO+J3zEfJTIeh0KAyQqtCmTtJf9iEYqxm
         FZJ45pfgGcYqFapjrnUUCdCvyQYAEbGT7HLUTKlXrvy9jUdEs/yoZWsCMfvcqWldD3ej
         ll3w==
X-Gm-Message-State: ACrzQf1LbS6p0Zw9/0kgEZrgCWjMBTL7DXysl6y88XDPeBf7ErBPgm2b
        ldtLNQGZ+Zek6JyVni7DSEU=
X-Google-Smtp-Source: AMsMyM7IHFxlRJdSaiea1qynaJTdSS1ofJAQcfFdlfMvly3FeETbIZYli4VVuBjOfWQXY3W6Av+NqA==
X-Received: by 2002:a05:6000:118d:b0:236:f075:dccd with SMTP id g13-20020a056000118d00b00236f075dccdmr27367367wrx.37.1668036611828;
        Wed, 09 Nov 2022 15:30:11 -0800 (PST)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id m23-20020a05600c3b1700b003cf47556f21sm3351289wms.2.2022.11.09.15.30.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 15:30:11 -0800 (PST)
Date:   Thu, 10 Nov 2022 01:30:08 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
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
        =?utf-8?B?bsOnIMOcTkFM?= <arinc.unal@arinc9.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH v2 net-next 4/6] dt-bindings: net: add generic
 ethernet-switch
Message-ID: <20221109233008.bsu2zl4bixsz44mi@skbuf>
References: <20221104045204.746124-1-colin.foster@in-advantage.com>
 <20221104045204.746124-1-colin.foster@in-advantage.com>
 <20221104045204.746124-5-colin.foster@in-advantage.com>
 <20221104045204.746124-5-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221104045204.746124-5-colin.foster@in-advantage.com>
 <20221104045204.746124-5-colin.foster@in-advantage.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 03, 2022 at 09:52:02PM -0700, Colin Foster wrote:
> diff --git a/Documentation/devicetree/bindings/net/ethernet-switch.yaml b/Documentation/devicetree/bindings/net/ethernet-switch.yaml
> new file mode 100644
> index 000000000000..fbaac536673d
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/ethernet-switch.yaml
> @@ -0,0 +1,49 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/ethernet-switch.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Ethernet Switch Device Tree Bindings

I vaguely remember Krzysztof saying during other reviews that "Device
Tree Bindings" in the title is superfluous. Suggest: "Generic Ethernet
Switch".

> +
> +maintainers:
> +  - Andrew Lunn <andrew@lunn.ch>
> +  - Florian Fainelli <f.fainelli@gmail.com>
> +  - Vivien Didelot <vivien.didelot@gmail.com>
> +
> +description:
> +  This binding represents Ethernet Switches which have a dedicated CPU
> +  port. That port is usually connected to an Ethernet Controller of the
> +  SoC. Such setups are typical for embedded devices.

This description was taken from the DSA switch schema and not adapted
for the generic Ethernet switch schema.

Suggest instead:

  Ethernet switches are multi-port Ethernet controllers. Each port has
  its own number and is represented as its own Ethernet controller.
  The minimum required functionality is to pass packets to software.
  They may or may not be able to forward packets autonomously between
  ports.

(this should also clarify if it's okay to reference ethernet-switch.yaml
from drivers which don't speak switchdev, which I believe it is).

(my suggestion is open to further comments for improvement)

> +
> +select: false
> +
> +properties:
> +  $nodename:
> +    pattern: "^(ethernet-)?switch(@.*)?$"
> +
> +patternProperties:
> +  "^(ethernet-)?ports$":
> +    type: object
> +    properties:
> +      '#address-cells':
> +        const: 1
> +      '#size-cells':
> +        const: 0
> +
> +    patternProperties:
> +      "^(ethernet-)?port@[0-9]+$":
> +        type: object
> +        description: Ethernet switch ports
> +
> +        $ref: /schemas/net/dsa/dsa-port.yaml#

I wonder if you actually meant dsa-port.yaml and not ethernet-controller.yaml?

> +
> +oneOf:
> +  - required:
> +      - ports
> +  - required:
> +      - ethernet-ports
> +
> +additionalProperties: true
> +
> +...
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 3106a9f0567a..3b6c3989c419 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -14326,6 +14326,7 @@ M:	Florian Fainelli <f.fainelli@gmail.com>
>  M:	Vladimir Oltean <olteanv@gmail.com>
>  S:	Maintained
>  F:	Documentation/devicetree/bindings/net/dsa/
> +F:	Documentation/devicetree/bindings/net/ethernet-switch.yaml
>  F:	drivers/net/dsa/
>  F:	include/linux/dsa/
>  F:	include/linux/platform_data/dsa.h
> -- 
> 2.25.1
> 

