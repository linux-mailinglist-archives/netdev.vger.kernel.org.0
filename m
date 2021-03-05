Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E29E832DECB
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 02:08:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229503AbhCEBIt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 20:08:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbhCEBIt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 20:08:49 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88741C061574;
        Thu,  4 Mar 2021 17:08:48 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id hs11so308528ejc.1;
        Thu, 04 Mar 2021 17:08:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=i5ilfQ3XxtvOpn+7UySt0qW9UnnudtCvGN/KPLL7gsM=;
        b=NP4XsYjV7qBjLGubsMlArvr3jto1NKIrembYpGQ3AhzrOV6n6crt/pcAuRtNh1tmaK
         wekz4LZgPhyVKj2RUCm5BXNvzJXZFwJ06v9XR09qM3JhzGsEaQ+P9ARcwNS76ukgSo0T
         jR7bJSP2RPJyxajx/OHwL6TAuO6/BJCKSL3jELQlgKaR5aZ+acbuZ9INItWKZ3vOrI6S
         xNLaB6Z1LPObRYR4hApNCfCBiyP2VjJZdQ3h9etaIKvb3/DHo5WgXCDQFukkN7mBFQjz
         L0HSRNBTIxH3lkRUBBHU3SIPrhWi/cz9CIoBW9yK5c6+hRytSKnux07/DerDNRMOJrZf
         OliA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=i5ilfQ3XxtvOpn+7UySt0qW9UnnudtCvGN/KPLL7gsM=;
        b=bOdIU8oVZs36dPwviXE7HuSrALf6WnigSDAS5634VObvwBWHp3dA2T9kVOfbqRH7Rk
         +PcuGiLPZ2gWxAqJe9hFqLK2ABV58xILXnbbmY93xc0w8omA4BRmggnZIMmZP18CKOFi
         uotHGgXzpJh/xjd8Cyxtdh51Mu5BH3zwIhFiDbNhuVNHU+dE/vTQQbZ4BQpF5HvYHVpy
         bDfi7X8WjiqJkXltJxDodY8FGSVZ0DZ8Q07pYHRZn+pHVQ4nu51jA9yG1PsF9I/a2nvJ
         HwjNwttiA8PyNZ//oJU/QPd5ZSvj1AX1p2y40pdQM3Hv0gHSzVpEnpB0cGwrFJJPUeDH
         rseA==
X-Gm-Message-State: AOAM53198BwSOf1QtRS0/H7PlitgplbiMyn2VkrLC2IcUe5fOeH6EChz
        sHTujOn0Q+PMm2qKBSiuFO8=
X-Google-Smtp-Source: ABdhPJwh/zP+w8eR27g3jgWHhAQrKVWQBfAufeyaCb534OdG9sEhqz8a3XIUcSZiiW3cuPMOGD+3Mg==
X-Received: by 2002:a17:907:aa2:: with SMTP id bz2mr182538ejc.239.1614906527189;
        Thu, 04 Mar 2021 17:08:47 -0800 (PST)
Received: from skbuf ([188.25.219.167])
        by smtp.gmail.com with ESMTPSA id 35sm628326edp.85.2021.03.04.17.08.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 17:08:46 -0800 (PST)
Date:   Fri, 5 Mar 2021 03:08:45 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Chan <mchan@broadcom.com>,
        "open list:BROADCOM ETHERNET PHY DRIVERS" 
        <bcm-kernel-feedback-list@broadcom.com>,
        open list <linux-kernel@vger.kernel.org>, michael@walle.cc
Subject: Re: [PATCH net-next v2 3/3] net: phy: broadcom: Allow BCM54210E to
 configure APD
Message-ID: <20210305010845.blqccudijh6ezm6a@skbuf>
References: <20210213034632.2420998-1-f.fainelli@gmail.com>
 <20210213034632.2420998-4-f.fainelli@gmail.com>
 <20210213104245.uti4qb2u2r5nblef@skbuf>
 <4e1c1a4c-d276-c850-8e97-16ef1f08dcff@gmail.com>
 <99e28317-e93d-88fa-f43f-d1d072b61292@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <99e28317-e93d-88fa-f43f-d1d072b61292@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 02, 2021 at 07:37:34PM -0800, Florian Fainelli wrote:
> Took a while but for the 54210E reference board here are the numbers,
> your mileage will vary depending on the supplies, regulator efficiency
> and PCB design around the PHY obviously:
> 
> BMCR.PDOWN:			86.12 mW
> auto-power down:		77.84 mW

Quite curious that the APD power is lower than the normal BMCR.PDOWN
value. As far as my understanding goes, when in APD mode, the PHY even
wakes up from time to time to send pulses to the link partner?

> auto-power-down, DLL disabled:  30.83 mW

The jump from simple APD to APD with DLL disabled is pretty big.
Correct me if I'm wrong, but there's an intermediary step which was not
measured, where the CLK125 is disabled but the internal DLL (Delay
Locked Loop?) is still enabled. I think powering off the internal DLL
also implies powering off the CLK125 pin, at least that's how the PHY
driver treats things at the moment. But we don't know if the huge
reduction in power is due just to CLK125 or the DLL (it's more likely
it's due to both, in equal amounts).

Anyway, it's great to have some results which tell us exactly what is
worthwhile and what isn't. In other news, I've added the BCM5464 to the
list of PHYs with APD and I didn't see any issues thus far.

> IDDQ-low power:			 9.85 mW (requires a RESETn toggle)
> IDDQ with soft recovery:	10.75 mW
> 
> Interestingly, the 50212E that I am using requires writing the PDOWN bit
> and only that bit (not a RMW) in order to get in a correct state, both
> LEDs keep flashing when that happens, fixes coming.
> 
> When net-next opens back up I will submit patches to support IDDQ with
> soft recovery since that is clearly much better than the standard power
> down and it does not require a RESETn toggle.

Iddq must be the quiescent supply current, isn't it (but in that case,
I'm a bit confused to not see a value in mA)? Is it an actual operating
mode (I don't see anything about that mentioned in the BCM5464 sheet)
and if it is, what is there exactly to support?
