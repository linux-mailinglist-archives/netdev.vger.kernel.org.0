Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82FC9300709
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 16:21:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729052AbhAVPVO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 10:21:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726633AbhAVPUs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 10:20:48 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3384BC061786;
        Fri, 22 Jan 2021 07:20:01 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id y187so4654804wmd.3;
        Fri, 22 Jan 2021 07:20:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:subject:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=43Pf87vNh1BvVz9DEmjXXzc9gq+Qi8n2DU1ll5dE4h8=;
        b=i5zdWF/damgIZSl6VfswKyzA/dRnZIaqifNgsR9dMVjZqVELlN4hN93a6oKLXdO1Te
         alkAkf02l2i/Z/4nrfHUSptjpkEw2GCTxwn9XWQrpmg3elyP0AZcbK8PBLeqwd5f+x7F
         uEunOoeZ/ETsB4X7b/nb2oEDi8M/hN9ZuAciVJY5aeCvqqCeEbtTuE95uRqgD10G81VJ
         HMTXTN//l9r5e30Hp+KwBGbUffEPgc6u5uGkxePFDPUmdVvUI5h17OQ05kCYTQBbMkmv
         iebT8idPfduCJxzYvkfQXZVL0Gt7pWeoHx+bFInFOpsrvj2gyOXV+DMIoivHwZGwneyE
         hvYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=43Pf87vNh1BvVz9DEmjXXzc9gq+Qi8n2DU1ll5dE4h8=;
        b=BsMqeXXCbBVrO+oTlkX/YwoUoCpB1OZuaKDZJ7McxJEAlmbi/QUZjziAQk756XtNVW
         Xxw2k2MVkgx4YTiIRna+fRxQNhVk12ALn6ZQqeF+MZBF39ziXIUz5yasGfXj0dvmsSYL
         z/SpEgCTllQddrrrWcPG0jJRuzvJlAL4NYai0Kdbk41bLKdEujYmi7IvWKgOREY3x2U/
         RDJ/H99ebP+r22xPWxUcxWRXnPYl+jq9nMblTJaBCzaL3KAu/CxXtrKUfjgh5siy36hn
         TaCsQCDZ1gu6dgd1VNeMf4fJQ1hNgxMeZLAAvYir7VpuIhMQGhoQN1vNsefwQfVjGpJH
         tcFg==
X-Gm-Message-State: AOAM531MfQGtz70vWKQEJ88NEDJDpqU4vkmlVnhNOu6952EbNo6q25cA
        +IMoFJEuQoYdHsd753iGyyPfLjDVjOw=
X-Google-Smtp-Source: ABdhPJzK+wfxaCGNbQHGVi1Lblygm7ZeaXOmpWcAQTDfVRSRyDmBR8SLGRHj+ALwnpzA+LiYVf0YQg==
X-Received: by 2002:a1c:5686:: with SMTP id k128mr4459219wmb.189.1611328799500;
        Fri, 22 Jan 2021 07:19:59 -0800 (PST)
Received: from ?IPv6:2003:ea:8f06:5500:5c9d:dd78:3e40:95d? (p200300ea8f0655005c9ddd783e40095d.dip0.t-ipconnect.de. [2003:ea:8f06:5500:5c9d:dd78:3e40:95d])
        by smtp.googlemail.com with ESMTPSA id d199sm11736696wmd.1.2021.01.22.07.19.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Jan 2021 07:19:59 -0800 (PST)
To:     Laurent Badel <laurentbadel@eaton.com>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Pavel Machek <pavel@ucw.cz>, linux-pm@vger.kernel.org
References: <20210122143524.14516-1-laurentbadel@eaton.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net 0/1] net: phy: Fix interrupt mask loss on resume from
 hibernation
Message-ID: <32cbb60d-67f3-765a-d51e-48d74c0785d6@gmail.com>
Date:   Fri, 22 Jan 2021 16:19:51 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210122143524.14516-1-laurentbadel@eaton.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22.01.2021 15:35, Laurent Badel wrote:
> ﻿Some PHYs such as SMSC LAN87xx clear the interrupt mask register on
> software reset. Since mdio_bus_phy_restore() calls phy_init_hw() which
> does a software reset of the PHY, these PHYs will lose their interrupt 
> mask configuration on resuming from hibernation.

The (optional) software reset is done via soft_reset callback.
So if the PHY in question needs special treatment after a soft reset,
why not add it to the soft_reset callback?

> 
> I initially reconfigured only the PHY interrupt mask using 
> phydev->config_intr(), which worked fine with PM_DEBUG/test_resume, but
> there seems to be an issue when resuming from a real hibernation, by which
> the interrupt type is not set appropriately (in this case 
> IRQ_TYPE_LEVEL_LOW). Calling irq_set_irq_type() directly from sysfs 

This sounds to me like a lower level driver (e.g. for GPIO / interrupt
controller) not resuming properly from hibernation. Supposedly things
like edge/level high/low/both are stored per interrupt line in a register
of the interrupt controller, and the controller would have to restore
the register value on resume from hibernation. You may want to have
a look at that driver.

> restored the PHY functionality immediately suggesting that everything is
> otherwise well configured. Therefore this patch suggests freeing and
> re-requesting the interrupt, to guarantee proper interrupt configuration.
> 
> Laurent Badel (1):
>   net: phy: Reconfigure PHY interrupt in mdio_bus_phy_restore()
> 
>  drivers/net/phy/phy_device.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 

