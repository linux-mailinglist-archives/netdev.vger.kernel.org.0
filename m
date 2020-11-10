Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD8DF2AE27F
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 23:06:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731992AbgKJWGy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 17:06:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726688AbgKJWGx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 17:06:53 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CA06C0613D1;
        Tue, 10 Nov 2020 14:06:52 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id l5so81419edq.11;
        Tue, 10 Nov 2020 14:06:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ScC75wP02JgAQnoPoluzDISIKUTt7c3WoT6HKef6yH0=;
        b=dBFVI7ErZs51pKrmKb7dNp8ZBJxmYF/Rccih1C0hZ1zsNz1gioisKEuTMnAGxOnSCn
         OYidsTp1BF3trdMOWLxITc0kW9J70RVjbXeE3OOrOeJatH7qVDNxz+CMCgJNncRikhL7
         1PXHVZTTXzQxWU2jqWWnILlYr9zoXfnjKuHa2g05ZWyyQnYAriZmMnpDa52jiJHkeIPd
         ww3fTgqod9+5UQmP4FSGk9hLZ4fsmB3woK1GzhnGvmOQMUyehTPU5Dc4wldm5ZocQBYy
         Nsk/Anr5MOyUKqyJr3yTsldPMGpeuDzgi3qtX048qywDxs7xmoZzxkLull1C5lvLu4Tz
         u0kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ScC75wP02JgAQnoPoluzDISIKUTt7c3WoT6HKef6yH0=;
        b=UIS1zFidPp7XC8psdJ8mEdx4iPJTJLIiSXeuX9tgJ1zynjqpeLDsoADhkysOZ/rNwz
         Y0lykcaTRSRgNQBN2lKFCWsYu2lZR6WZPqqpFe9cYRGPqAiq6YVSvHn6Q9F6KzCRFMjb
         KCtSkc0d9JGS5jP/kQ8EI8O9uyxXdIjAJX3sZc9xeDUnqNRNkpx+YnqSSmIG59fju3Qf
         DrLBzvQdD3C7R9aJ8gavrX3JcC8Kd5Lg2ci7aJvHXDRq2UOskhFAWOA8S4G+vwA3D3Qu
         XLVTo9ONvZp8izk4BnPfx/a/5DD4zss++hPeD1BAhmMde6/99HUN0ZAIXweb6jajTt6q
         zygA==
X-Gm-Message-State: AOAM530UuPcmH0lMtpyZREQnuh1M1Q2mmfWnq5N9AevoRhA+977Z5yBH
        CuBCZMPOn2xVXIwDoJLqoXs=
X-Google-Smtp-Source: ABdhPJysXoRimH8cY1wEZy+FFZd4ZuxG/cdTeDnWFdxCkTtNate9qgKVA/sLEyqkLNZg6AaZ1rkzRA==
X-Received: by 2002:a05:6402:783:: with SMTP id d3mr23728408edy.168.1605046010782;
        Tue, 10 Nov 2020 14:06:50 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id x20sm45449ejv.66.2020.11.10.14.06.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2020 14:06:50 -0800 (PST)
Date:   Wed, 11 Nov 2020 00:06:47 +0200
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
Subject: Re: [PATCH 04/10] ARM: dts: BCM5301X: Add a default compatible for
 switch node
Message-ID: <20201110220647.r5ol44etxa7xxql3@skbuf>
References: <20201110033113.31090-1-f.fainelli@gmail.com>
 <20201110033113.31090-5-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201110033113.31090-5-f.fainelli@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 09, 2020 at 07:31:07PM -0800, Florian Fainelli wrote:
> Provide a default compatible string which is based on the 53010 SRAB
> compatible, this allows us to have sane defaults and silences the
> following warnings:
> 
> arch/arm/boot/dts/bcm4708-asus-rt-ac56u.dt.yaml:
> ethernet-switch@18007000: compatible: 'oneOf' conditional failed, one
> must be fixed:
>         ['brcm,bcm5301x-srab'] is too short
>         'brcm,bcm5325' was expected
>         'brcm,bcm53115' was expected
>         'brcm,bcm53125' was expected
>         'brcm,bcm53128' was expected
>         'brcm,bcm5365' was expected
>         'brcm,bcm5395' was expected
>         'brcm,bcm5389' was expected
>         'brcm,bcm5397' was expected
>         'brcm,bcm5398' was expected
>         'brcm,bcm11360-srab' was expected
>         'brcm,bcm5301x-srab' is not one of ['brcm,bcm53010-srab',
> 'brcm,bcm53011-srab', 'brcm,bcm53012-srab', 'brcm,bcm53018-srab',
> 'brcm,bcm53019-srab']
>         'brcm,bcm5301x-srab' is not one of ['brcm,bcm11404-srab',
> 'brcm,bcm11407-srab', 'brcm,bcm11409-srab', 'brcm,bcm58310-srab',
> 'brcm,bcm58311-srab', 'brcm,bcm58313-srab']
>         'brcm,bcm5301x-srab' is not one of ['brcm,bcm58522-srab',
> 'brcm,bcm58523-srab', 'brcm,bcm58525-srab', 'brcm,bcm58622-srab',
> 'brcm,bcm58623-srab', 'brcm,bcm58625-srab', 'brcm,bcm88312-srab']
>         'brcm,bcm5301x-srab' is not one of ['brcm,bcm3384-switch',
> 'brcm,bcm6328-switch', 'brcm,bcm6368-switch']
>         From schema:
> Documentation/devicetree/bindings/net/dsa/b53.yaml
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---

Nice, I didn't know DSA supported the switch inside this device. In the
default AsusWRT, the switch is well hidden from the kernel :)

Not that it makes any difference as far as I can see, but how do you
know this a BCM53010 SRAB specifically?

>  arch/arm/boot/dts/bcm5301x.dtsi | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/boot/dts/bcm5301x.dtsi b/arch/arm/boot/dts/bcm5301x.dtsi
> index ee23c0841699..807580dd89f5 100644
> --- a/arch/arm/boot/dts/bcm5301x.dtsi
> +++ b/arch/arm/boot/dts/bcm5301x.dtsi
> @@ -483,7 +483,7 @@ thermal: thermal@1800c2c0 {
>  	};
>  
>  	srab: ethernet-switch@18007000 {
> -		compatible = "brcm,bcm5301x-srab";
> +		compatible = "brcm,bcm53010-srab", "brcm,bcm5301x-srab";
>  		reg = <0x18007000 0x1000>;
>  
>  		status = "disabled";
> -- 
> 2.25.1
> 
