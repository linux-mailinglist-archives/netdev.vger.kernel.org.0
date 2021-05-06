Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ED50375331
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 13:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231271AbhEFLtR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 07:49:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231216AbhEFLtN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 07:49:13 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC298C061574;
        Thu,  6 May 2021 04:48:14 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id s5-20020a7bc0c50000b0290147d0c21c51so2877405wmh.4;
        Thu, 06 May 2021 04:48:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AA7rwHKkDu014cTKd9NxKCpVNUL0Wnr6JWgERveJ2WY=;
        b=OqewioGX7zUn70JN2xPh43HBNTI/Zv48ATFcJW+HdY108QarLQEAfZcJL2NWwOIEQP
         HOuUgmAd3XhlL2UmAm7S1l3XGK/VyhFl+hFZST0ED6bQviLfefBPZkHXxC14J7kv2vhD
         D1+ArsYl3QaMlW1es1TH8qxPfKmykvOVL4mgmX7U3O0gJ2ILQ4VwgoTzNQxB5nR9BNOU
         lrRFITF0Ov3j7NqZX6/LvtH/kNJZqsNgzr+zwyQh2aiGaa0q9tLXq+Bk581Y8jpQLAkf
         OIVp3K6RxZHojjokGLMJxWf9QCdevtAogfaiEP1y4FjgZkr1F86xoW6S6uJ+XMhgUnBb
         hHjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AA7rwHKkDu014cTKd9NxKCpVNUL0Wnr6JWgERveJ2WY=;
        b=QFdZeXbZqkrYxKXKrddLJAwfEKnpu8IuUaycSaaic/ChAmYxInlM8o/HMto2/kGzkF
         Ry2Xk1w9oRSeEJyMDdAUKUYRqOitKwkP983Jg+jmgfn4Do03APgdEYeBlYivoWkhy9qu
         tprM1Ex4F/jE6owMxTHff4pcrbYZqwKmclLJ1hFw5PsZyezH/8bpdqnEu88MelIyX69i
         NAYsnQwTTQgKw2yExqr+3SJhm7Dkk/l+Wv0atzicvCfQ8d8z6zSGpxt1O7fD2XvtNQNb
         FI5tE+sYN0dSVMywcoUNj2YspMwyb2Mj2qUz7R6TsGzTe7qZbM/m7EEU2xDcisjK5cUO
         S2zQ==
X-Gm-Message-State: AOAM531yg0nz1rkc2oGbmho3Xk752hmRBMN9gGSOyU+ndmZoJy8qUpjM
        1BX7vomaG8XUMCPvfCO50oqhu9Bo9LU=
X-Google-Smtp-Source: ABdhPJxWaOHqxEYLD/SeMJjnnTA8VEuB+Mq8RR2XPlYvqhDNgJxpc53CtcIuVCbo8xpCa0OA9pxV7Q==
X-Received: by 2002:a05:600c:4f4d:: with SMTP id m13mr3610259wmq.4.1620301693518;
        Thu, 06 May 2021 04:48:13 -0700 (PDT)
Received: from skbuf ([86.127.41.210])
        by smtp.gmail.com with ESMTPSA id u5sm3797210wrt.38.2021.05.06.04.48.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 May 2021 04:48:13 -0700 (PDT)
Date:   Thu, 6 May 2021 14:48:11 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Sean Wang <sean.wang@mediatek.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-staging@lists.linux.dev, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, Weijie Gao <weijie.gao@mediatek.com>,
        Chuanhong Guo <gch981213@gmail.com>,
        =?utf-8?B?UmVuw6k=?= van Dorst <opensource@vdorst.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH net-next 4/4] staging: mt7621-dts: enable MT7530
 interrupt controller
Message-ID: <20210506114811.zkj7klujcqn54zun@skbuf>
References: <20210429062130.29403-1-dqfext@gmail.com>
 <20210429062130.29403-5-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210429062130.29403-5-dqfext@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 29, 2021 at 02:21:30PM +0800, DENG Qingfang wrote:
> Enable MT7530 interrupt controller in the MT7621 SoC.
> 
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>
> ---
> RFC v4 -> PATCH v1:
> - No changes.
> 
>  drivers/staging/mt7621-dts/mt7621.dtsi | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/staging/mt7621-dts/mt7621.dtsi b/drivers/staging/mt7621-dts/mt7621.dtsi
> index 16fc94f65486..0f7e487883a5 100644
> --- a/drivers/staging/mt7621-dts/mt7621.dtsi
> +++ b/drivers/staging/mt7621-dts/mt7621.dtsi
> @@ -447,6 +447,10 @@ switch0: switch0@0 {
>  				mediatek,mcm;
>  				resets = <&rstctrl 2>;
>  				reset-names = "mcm";
> +				interrupt-controller;
> +				#interrupt-cells = <1>;
> +				interrupt-parent = <&gic>;
> +				interrupts = <GIC_SHARED 23 IRQ_TYPE_LEVEL_HIGH>;
>  
>  				ports {
>  					#address-cells = <1>;
> -- 
> 2.25.1
> 

I don't remember if I mentioned this before, but a short-hand way of
expressing this is using:

	interrupts-extended = <&gic GIC_SHARED 23 IRQ_TYPE_LEVEL_HIGH>;

but the entire drivers/staging/mt7621-dts/mt7621.dtsi file uses
interrupt-parent, so this is fine.

Also, I panicked for a second thinking that this is the ARM GIC which
supports the GIC_SHARED flag, but I see that mt7621 is MIPS.

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
