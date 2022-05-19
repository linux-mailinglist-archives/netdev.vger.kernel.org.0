Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4723352DCC2
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 20:28:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243909AbiESS2b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 14:28:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243885AbiESS2R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 14:28:17 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17441C6E79;
        Thu, 19 May 2022 11:28:16 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id y13so10803793eje.2;
        Thu, 19 May 2022 11:28:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=1sDcNbgzxstYFS1dCzzCYng8q+gbAciBWtOhDHr35lY=;
        b=Qs068JdV71v2mLkWZADWIvNoA1hKeNDw694CzcnIbE5aoHv7lctOcj8yQGD2Zdp1kZ
         lANiJLLPG3z92YN1RjSOR2GcIGFyfij/ngDjp2qPmj1U8eBWhRfYZlPqKUh5nA6mdv7N
         V1EudqXB83vYPlhgMoskMW56c8DD9sWnkYOQ5CYZQDJJJzpCKy0sIZXOffIVgUZiSuEk
         /hHxSQCth7cK//2VrlSsdYy72uD6tn6OP4FRNg1VZ3MmwfIPTMngEJ85eZ3zNjbm8/Ks
         OOaBDj/US9MMPJU/jI/1OfBhlVhty6vXCvyCGLSnmkOkcitSFVj4Tyz6i98VKh/2QrzX
         YnMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=1sDcNbgzxstYFS1dCzzCYng8q+gbAciBWtOhDHr35lY=;
        b=kX53wh1Mh8zP4HmcdcXVxziw55am1xvDUJQkBRKCm6HYfC1ZMrjg/Qpmp7fwQlAzs2
         L5tdmb94x20a9pQZ3F3lapj9Kia+aFS6tO8OyzKgI5X+KNUjaz+uxKNlVzRLeL1R0duz
         IQPy5Lj4GWh365qUA+S27c+hDX388h0rQOIP4uIe0GEkrUQYbo5RIAdqFj71zAqRuhc6
         C9dhAEFVWxAnCgOMq2Shlb0Y6kJEHFka5Llrgs+kCGkO2TNF0OIk3VRfpmBcMXAsAc95
         Fiyl0H4+3EXpPfDejVqCSF2H307kUcCmURbb8fdkMDNeDnLt/NYw2iNo+q0dcXKz1lP9
         yeNA==
X-Gm-Message-State: AOAM530sy8L7DWG5VYPHQj4kve3oEqsQ1eTyj94bllGd0FHpbxpGKhFm
        1ebwKVShfeB7OGFU4BWbR0o=
X-Google-Smtp-Source: ABdhPJxLX2HTJhx/MNiPan0SKInfK85r5Zi6aqFuFnQoZBbncjAdDbtmhjNjxDP+kVf3c4hgBhLGUw==
X-Received: by 2002:a17:906:dc8b:b0:6fe:920b:61ff with SMTP id cs11-20020a170906dc8b00b006fe920b61ffmr5609038ejc.565.1652984894651;
        Thu, 19 May 2022 11:28:14 -0700 (PDT)
Received: from skbuf ([188.25.255.186])
        by smtp.gmail.com with ESMTPSA id yl15-20020a17090693ef00b006f3ef214e69sm2321301ejb.207.2022.05.19.11.28.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 May 2022 11:28:14 -0700 (PDT)
Date:   Thu, 19 May 2022 21:28:12 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?utf-8?Q?Miqu=C3=A8l?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v5 12/13] ARM: dts: r9a06g032: describe switch
Message-ID: <20220519182812.lmp2gp6m47jt742y@skbuf>
References: <20220519153107.696864-1-clement.leger@bootlin.com>
 <20220519153107.696864-13-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220519153107.696864-13-clement.leger@bootlin.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 19, 2022 at 05:31:06PM +0200, Clément Léger wrote:
> Add description of the switch that is present on the RZ/N1 SoC.
> 
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>
> ---
>  arch/arm/boot/dts/r9a06g032.dtsi | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/r9a06g032.dtsi b/arch/arm/boot/dts/r9a06g032.dtsi
> index 31c4b2e2950a..20d3dce632ce 100644
> --- a/arch/arm/boot/dts/r9a06g032.dtsi
> +++ b/arch/arm/boot/dts/r9a06g032.dtsi
> @@ -255,6 +255,15 @@ mii_conv5: mii-conv@5 {
>  			};
>  		};
>  
> +		switch: switch@44050000 {
> +			compatible = "renesas,r9a06g032-a5psw", "renesas,rzn1-a5psw";
> +			reg = <0x44050000 0x10000>;
> +			clocks = <&sysctrl R9A06G032_HCLK_SWITCH>,
> +				 <&sysctrl R9A06G032_CLK_SWITCH>;
> +			clock-names = "hclk", "clk";
> +			status = "disabled";

Does the switch port count depend on anything? If it doesn't, maybe you
could add the "ethernet-ports" node and all the ports here, with status
= "disabled", so that board files don't need to spell them out each time?
I'm also thinking you could define the fixed-link and phy-mode = "internal"
property of the CPU port with this occasion. That surely isn't a
per-board thing.

> +		};
> +
>  		gic: interrupt-controller@44101000 {
>  			compatible = "arm,gic-400", "arm,cortex-a7-gic";
>  			interrupt-controller;
> -- 
> 2.36.0
> 
