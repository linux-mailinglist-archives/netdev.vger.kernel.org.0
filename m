Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A998D3A153D
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 15:13:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233399AbhFINPk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 09:15:40 -0400
Received: from mail-wr1-f41.google.com ([209.85.221.41]:44691 "EHLO
        mail-wr1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231675AbhFINPj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 09:15:39 -0400
Received: by mail-wr1-f41.google.com with SMTP id f2so25397493wri.11;
        Wed, 09 Jun 2021 06:13:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ug4bqe6qvzNGA5IxYXAl8I2lP/38bi+1b3Lc/PKtaME=;
        b=kI2rSvueSpqgWt/LkjiShyt4ws1od3PhKmlIidUMBFQxvVjayUfg7yLQbofJQNx4zQ
         ffnPp3jZokqvSuWSju+pFumz5FPGRsovnHdTIoL0AlxVeFIu5uQ8gU1mqPKUdY7PhSmq
         gDmQOvWK8Q64iiwTMu6UUHC/FyrVzHL696NMAQ9C5iSWs2BbMp3VXSBbiJj8PSL9b9K2
         zA9YXMxyDYCMDO6nk0o0iiJb3+/ccoHWK7F6L3yg5Spy863zxeMIB47DG0Q6RPlJrPwA
         B4eKlfZbLw2itB/zKsv3eZ3CjqLOOUkonyODNI6QFs1chutlNuCTg8u/2TpCUymXc5em
         5fSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ug4bqe6qvzNGA5IxYXAl8I2lP/38bi+1b3Lc/PKtaME=;
        b=eUD2hR5JLNM+fTcDE2RXvhdoLxem0ZF7jkr5/MPZzKPu/JCraA/4pKgt2Gxn106qaI
         x2lRUe21nvydtk10Tb0bF3TM1a4gTBKAbT+k9TfiwiYwdau5elPXJh8Hw8p0y0IPKydh
         7SGCZatMJ4ExS6fXck3RyMBnTo5ssLtYWjCiZhdhUjCpMX0g+xHSvZ/DAAHhwS4zQ8EJ
         U1DqosNBsZ2IJV/+AR3tjyKlbg3ZEJW7ItRehmE00hn+4iyerVToxE2YvdCso7SD2WM/
         kIMDxFNLRB9Ffq72LW0i3a14y3Qzh6xieyvu863dD/V5CrMvd6npKq4590YMq28yfLzy
         EBLg==
X-Gm-Message-State: AOAM531YGC/RS3KED7fz1zRoKZp9tbbRKEQsYUAwfoeeXJtZbRRvhUwd
        M/5QtX99zChtV2TyiGkp6nMimNY7KEI=
X-Google-Smtp-Source: ABdhPJxeibi26DmI2L70M6SFaFlV7pzTMHiAmpHHp9KjCnUeMq22p7QMiT24oUwZN+Rbbj1AjV+dyA==
X-Received: by 2002:adf:ee50:: with SMTP id w16mr28075757wro.187.1623244364090;
        Wed, 09 Jun 2021 06:12:44 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:3800:a9b1:fb24:eb4f:c8ac? (p200300ea8f293800a9b1fb24eb4fc8ac.dip0.t-ipconnect.de. [2003:ea:8f29:3800:a9b1:fb24:eb4f:c8ac])
        by smtp.googlemail.com with ESMTPSA id u14sm6115300wmc.41.2021.06.09.06.12.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Jun 2021 06:12:43 -0700 (PDT)
Subject: Re: [PATCH net-next v2 4/8] net: usb: asix: ax88772: add phylib
 support
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
References: <20210607082727.26045-1-o.rempel@pengutronix.de>
 <20210607082727.26045-5-o.rempel@pengutronix.de>
 <CGME20210609095923eucas1p2e692c9a482151742d543316c91f29802@eucas1p2.samsung.com>
 <84ff1dab-ab0a-f27c-a948-e1ebdf778485@samsung.com>
 <20210609124609.zngg6sfcu6cj4p2m@pengutronix.de>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <44a16219-0575-49ee-758b-be6fe9971962@gmail.com>
Date:   Wed, 9 Jun 2021 15:12:37 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210609124609.zngg6sfcu6cj4p2m@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09.06.2021 14:46, Oleksij Rempel wrote:
> Hi Marek,
> 
> On Wed, Jun 09, 2021 at 11:59:23AM +0200, Marek Szyprowski wrote:
>> Hi Oleksij,
>>
>> On 07.06.2021 10:27, Oleksij Rempel wrote:
>>> To be able to use ax88772 with external PHYs and use advantage of
>>> existing PHY drivers, we need to port at least ax88772 part of asix
>>> driver to the phylib framework.
>>>
>>> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
>>
>> This patch landed recently in linux-next as commit e532a096be0e ("net: 
>> usb: asix: ax88772: add phylib support"). I found that it causes some 
>> warnings on boards with those devices, see the following log:
>>
>> root@target:~# time rtcwake -s10 -mmem
>> rtcwake: wakeup from "mem" using /dev/rtc0 at Wed Jun  9 08:16:41 2021
>> [  231.226579] PM: suspend entry (deep)
>> [  231.231697] Filesystems sync: 0.002 seconds
>> [  231.261761] Freezing user space processes ... (elapsed 0.002 seconds) 
>> done.
>> [  231.270526] OOM killer disabled.
>> [  231.273557] Freezing remaining freezable tasks ... (elapsed 0.002 
>> seconds) done.
>> [  231.282229] printk: Suspending console(s) (use no_console_suspend to 
>> debug)
>> ...
>> [  231.710852] Disabling non-boot CPUs ...
>> ...
>> [  231.901794] Enabling non-boot CPUs ...
>> ...
>> [  232.225640] usb usb3: root hub lost power or was reset
>> [  232.225746] usb usb1: root hub lost power or was reset
>> [  232.225864] usb usb5: root hub lost power or was reset
>> [  232.226206] usb usb6: root hub lost power or was reset
>> [  232.226207] usb usb4: root hub lost power or was reset
>> [  232.297749] usb usb2: root hub lost power or was reset
>> [  232.343227] asix 3-1:1.0 eth0: Failed to write reg index 0x0000: -22
>> [  232.343293] asix 3-1:1.0 eth0: Failed to enable software MII access
>> [  232.344486] asix 3-1:1.0 eth0: Failed to read reg index 0x0000: -22
>> [  232.344512] asix 3-1:1.0 eth0: Failed to write reg index 0x0000: -22
>> [  232.344529] PM: dpm_run_callback(): mdio_bus_phy_resume+0x0/0x78 
>> returns -22
>> [  232.344554] Asix Electronics AX88772C usb-003:002:10: PM: failed to 
>> resume: error -22
>> [  232.563712] usb 1-1: reset high-speed USB device number 2 using 
>> exynos-ehci
>> [  232.757653] usb 3-1: reset high-speed USB device number 2 using xhci-hcd
>> [  233.730994] OOM killer enabled.
>> [  233.734122] Restarting tasks ... done.
>> [  233.754992] PM: suspend exit
>>
>> real    0m11.546s
>> user    0m0.000s
>> sys     0m0.530s
>> root@target:~# sleep 2
>> root@target:~# time rtcwake -s10 -mmem
>> rtcwake: wakeup from "mem" using /dev/rtc0 at Wed Jun  9 08:17:02 2021
>> [  241.959608] PM: suspend entry (deep)
>> [  241.963446] Filesystems sync: 0.001 seconds
>> [  241.978619] Freezing user space processes ... (elapsed 0.004 seconds) 
>> done.
>> [  241.989199] OOM killer disabled.
>> [  241.992215] Freezing remaining freezable tasks ... (elapsed 0.005 
>> seconds) done.
>> [  242.003979] printk: Suspending console(s) (use no_console_suspend to 
>> debug)
>> ...
>> [  242.592030] Disabling non-boot CPUs ...
>> ...
>> [  242.879721] Enabling non-boot CPUs ...
>> ...
>> [  243.145870] usb usb3: root hub lost power or was reset
>> [  243.145910] usb usb4: root hub lost power or was reset
>> [  243.147084] usb usb5: root hub lost power or was reset
>> [  243.147157] usb usb6: root hub lost power or was reset
>> [  243.147298] usb usb1: root hub lost power or was reset
>> [  243.217137] usb usb2: root hub lost power or was reset
>> [  243.283807] asix 3-1:1.0 eth0: Failed to write reg index 0x0000: -22
>> [  243.284005] asix 3-1:1.0 eth0: Failed to enable software MII access
>> [  243.285526] asix 3-1:1.0 eth0: Failed to read reg index 0x0000: -22
>> [  243.285676] asix 3-1:1.0 eth0: Failed to read reg index 0x0004: -22
>> [  243.285769] ------------[ cut here ]------------
>> [  243.286011] WARNING: CPU: 2 PID: 2069 at drivers/net/phy/phy.c:916 
>> phy_error+0x28/0x68
>> [  243.286115] Modules linked in: cmac bnep mwifiex_sdio mwifiex 
>> sha256_generic libsha256 sha256_arm cfg80211 btmrvl_sdio btmrvl 
>> bluetooth s5p_mfc uvcvideo s5p_jpeg exynos_gsc v
>> [  243.287490] CPU: 2 PID: 2069 Comm: kworker/2:5 Not tainted 
>> 5.13.0-rc5-next-20210608 #10443
>> [  243.287555] Hardware name: Samsung Exynos (Flattened Device Tree)
>> [  243.287609] Workqueue: events_power_efficient phy_state_machine
>> [  243.287716] [<c0111920>] (unwind_backtrace) from [<c010d0cc>] 
>> (show_stack+0x10/0x14)
>> [  243.287807] [<c010d0cc>] (show_stack) from [<c0b62360>] 
>> (dump_stack_lvl+0xa0/0xc0)
>> [  243.287882] [<c0b62360>] (dump_stack_lvl) from [<c0127960>] 
>> (__warn+0x118/0x11c)
>> [  243.287954] [<c0127960>] (__warn) from [<c0127a18>] 
>> (warn_slowpath_fmt+0xb4/0xbc)
>> [  243.288021] [<c0127a18>] (warn_slowpath_fmt) from [<c0734968>] 
>> (phy_error+0x28/0x68)
>> [  243.288094] [<c0734968>] (phy_error) from [<c0735d6c>] 
>> (phy_state_machine+0x218/0x278)
>> [  243.288173] [<c0735d6c>] (phy_state_machine) from [<c014ae08>] 
>> (process_one_work+0x30c/0x884)
>> [  243.288254] [<c014ae08>] (process_one_work) from [<c014b3d8>] 
>> (worker_thread+0x58/0x594)
>> [  243.288333] [<c014b3d8>] (worker_thread) from [<c0153944>] 
>> (kthread+0x160/0x1c0)
>> [  243.288408] [<c0153944>] (kthread) from [<c010011c>] 
>> (ret_from_fork+0x14/0x38)
>> [  243.288475] Exception stack(0xc4683fb0 to 0xc4683ff8)
>> [  243.288531] 3fa0:                                     00000000 
>> 00000000 00000000 00000000
>> [  243.288587] 3fc0: 00000000 00000000 00000000 00000000 00000000 
>> 00000000 00000000 00000000
>> [  243.288641] 3fe0: 00000000 00000000 00000000 00000000 00000013 00000000
>> [  243.288690] irq event stamp: 1611
>> [  243.288744] hardirqs last  enabled at (1619): [<c01a6ef0>] 
>> vprintk_emit+0x230/0x290
>> [  243.288830] hardirqs last disabled at (1626): [<c01a6f2c>] 
>> vprintk_emit+0x26c/0x290
>> [  243.288906] softirqs last  enabled at (1012): [<c0101768>] 
>> __do_softirq+0x500/0x63c
>> [  243.288978] softirqs last disabled at (1007): [<c01315b4>] 
>> irq_exit+0x214/0x220
>> [  243.289055] ---[ end trace eeacda95eb7db60a ]---
>> [  243.289345] asix 3-1:1.0 eth0: Failed to write reg index 0x0000: -22
>> [  243.289466] asix 3-1:1.0 eth0: Failed to write Medium Mode mode to 
>> 0x0000: ffffffea
>> [  243.289540] asix 3-1:1.0 eth0: Link is Down
>> [  243.482809] usb 1-1: reset high-speed USB device number 2 using 
>> exynos-ehci
>> [  243.647251] usb 3-1: reset high-speed USB device number 2 using xhci-hcd
>> [  244.847161] OOM killer enabled.
>> [  244.850221] Restarting tasks ... done.
>> [  244.861372] PM: suspend exit
>>
>> real    0m13.050s
>> user    0m0.000s
>> sys     0m1.152s
>> root@target:~#
>>
>> It looks that some kind of system suspend/resume integration for phylib 
>> is not implemented.
> 
> Probably it is should be handled only by the asix driver. I'll take a
> look in to it. Did interface was able to resume after printing some
> warnings?
> 
> Regards,
> Oleksij
> 

Maybe it's a use case for the new mac_managed_pm flag, see
fba863b81604 ("net: phy: make PHY PM ops a no-op if MAC driver manages PHY PM")
