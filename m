Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2BA82AE35D
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 23:28:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732327AbgKJW2B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 17:28:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732432AbgKJW2B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 17:28:01 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A02DDC0613D1;
        Tue, 10 Nov 2020 14:28:00 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id f20so14187ejz.4;
        Tue, 10 Nov 2020 14:28:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IDwqcl49mFRj/GQI1sIJo5TSDn2DCgIJIB4tlo20bkQ=;
        b=NFxx6otCj2aPXrKIQ10imsjVP+bu3Ha8B8pCjqD7c/YYYL6VjsGsg+53t0mqr3fq0B
         RuoDT4ebf6LgEL3U9BIUAS2OBwTzvo5j88HOJK70B1nbKOSDB1UJ3cp6j8gvi2oF9701
         ImgGKDgSjI58Qwyb43wv7Hx7s3w7fUDNLLwnMhenIQtDqCw9WdmVoSA8MHc3r/GQHWvX
         krUrD9kcICk3hfSgqyytYgdsxfguZ8uCcKYAQKDS8fOJaNc3FcEM5C3SHFr0wsTSILJ/
         Qw3y5/HALBizYwW4uGyDKF/ctXaq9Y4dTcixxyY2u0umFDqfXi4ABp6nYGdEFeAaosDb
         nm2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IDwqcl49mFRj/GQI1sIJo5TSDn2DCgIJIB4tlo20bkQ=;
        b=c/+XtRzMng0MW7Y66YRUA2jm2sa+NT8j52ymIdmwUAsMlag8W5Ng9RFWST2qH4Y8Pz
         orJO45G62TNiTQsdQ43NT1WFOO0q+rTPyjkogWy5yCMUFyWZi/8nOnY4JhBPFXXa1Cwg
         KJUs3vP0hm6TU+hug6tzQb3WrqCgvpmV15BM7RqNyxv7ByDisPNDHeH/UdlHRJ1xVXWP
         7wWJFFR1GPOlLXHqLbYLxKZDk4q9/zVspkgTmdRM2sGGdDauBao2NeCn4OkZzrgCuxxK
         yvNxW6xy2B6rVrMxUuO0M/CBYHm0Iwg6Azegvly0XbYv0MgP90VYG8Fewv6NouJJlJUk
         tdLQ==
X-Gm-Message-State: AOAM531wecw//lsLDrUhgcA5tWCz6aTlFBH0hatR3vnO8Gf5dIltg8Vc
        Xl0tubnEIvph/tfb/39vZCSqJZDvX/Q=
X-Google-Smtp-Source: ABdhPJwPwGVQoQGrKxgHqOIurAWewCfL99Qo9IkQWt4sYsTPmrTmPBMocc7mlyvbgMxk1dcZOzK64A==
X-Received: by 2002:a17:906:3a4e:: with SMTP id a14mr21936517ejf.140.1605047279356;
        Tue, 10 Nov 2020 14:27:59 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id b24sm16440edt.68.2020.11.10.14.27.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2020 14:27:58 -0800 (PST)
Date:   Wed, 11 Nov 2020 00:27:56 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        "maintainer:BROADCOM IPROC ARM ARCHITECTURE" 
        <bcm-kernel-feedback-list@broadcom.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:BROADCOM IPROC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        Kurt Kanzenbach <kurt@kmk-computers.de>
Subject: Re: [PATCH 07/10] ARM: dts: NSP: Fix Ethernet switch SGMII register
 name
Message-ID: <20201110222756.alaii5mr6fcwq4lx@skbuf>
References: <20201110033113.31090-1-f.fainelli@gmail.com>
 <20201110033113.31090-8-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201110033113.31090-8-f.fainelli@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 09, 2020 at 07:31:10PM -0800, Florian Fainelli wrote:
> The register name should be "sgmii_config", not "sgmii", this is not a
> functional change since no code is currently looking for that register
> by name (or at all).
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---

I.e. no one calls devm_platform_ioremap_resource(pdev, 2), and even if
it did, the register name wouldn't matter.
...but at least it's documented that it should be called "sgmii_config".
And the address is the same as the one that's documented for the SGMII
register base in SoCs with "brcm,nsp-srab", so even without
documentation, it is pretty clear to me that it was a mistake calling it
simply "sgmii". And if that address is incorrect anyways, at least that
would be a separate issue.

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

>  arch/arm/boot/dts/bcm-nsp.dtsi | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/boot/dts/bcm-nsp.dtsi b/arch/arm/boot/dts/bcm-nsp.dtsi
> index e7d08959d5fe..09fd7e55c069 100644
> --- a/arch/arm/boot/dts/bcm-nsp.dtsi
> +++ b/arch/arm/boot/dts/bcm-nsp.dtsi
> @@ -390,7 +390,7 @@ srab: ethernet-switch@36000 {
>  			reg = <0x36000 0x1000>,
>  			      <0x3f308 0x8>,
>  			      <0x3f410 0xc>;
> -			reg-names = "srab", "mux_config", "sgmii";
> +			reg-names = "srab", "mux_config", "sgmii_config";
>  			interrupts = <GIC_SPI 95 IRQ_TYPE_LEVEL_HIGH>,
>  				     <GIC_SPI 96 IRQ_TYPE_LEVEL_HIGH>,
>  				     <GIC_SPI 97 IRQ_TYPE_LEVEL_HIGH>,
> -- 
> 2.25.1
> 
