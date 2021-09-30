Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9044141D8CA
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 13:29:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350456AbhI3LbW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 07:31:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350303AbhI3LbT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 07:31:19 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3BCDC06176A
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 04:29:36 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id z24so23775377lfu.13
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 04:29:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YN/uRzD63mjY6PH4dnIQBaiQpenlAB6ihXMiMRwFnNc=;
        b=dC7X0V4k6b0NyccnB9eb/xky7r/lPWDiSfORgZy1h+IiK2Lik64DCSQmQvZv9GX4Kp
         d2QOPKy9GWc8eBLaQmhtjbQf+VWT0H2MMjzfkxcmIclsTtPzODE225ubb8Frmg/TLvK5
         8deB98uQSfMW6PHWwRSDTMpI5Iy6LyOV84KBuEwBdr6Kw6ctg1/fkb+/oSnXiZ7v0Ino
         5EEKpGI/SdFyHPB7mIRXBGWeFbWAff+dXkJKAntbhdUgSbF23aSeYKEj/jWsTYevygea
         zP6jzqG8fdpe6PhTyWsmf4OLBPeJ1BvU8P3dQ+NH3nx4oconb7W/gEY0mFj2GYwNMCok
         K+bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YN/uRzD63mjY6PH4dnIQBaiQpenlAB6ihXMiMRwFnNc=;
        b=c4Jx+x0YNGnE5LGFMcKM5EeBo/zDt1zSnjJ7eGNFODto5PXnlbFQoLDK+AEd3IrxGW
         wwMzZOPZ29x4vrnMDdQRNzYayb92dpIzTH5A2ItrK2a5+j1ZVr9cQmUXVKv97T8AuTX3
         IV1ebolQnO3w83NQLT9IMKHkcyIx8UwE7XI4oLXxZs/7z7ZnTFzmb1FtyNOrosqJ0jE/
         Zokx2CqfL6O9q/sQKmPjuGpJ/yJJE+ejKH7ZUZQxRPca8H7G/FT2EavuBIPiFxc26p7M
         3R6THMmWryvTTrswPu98KWF+9U3jEgRDeLEk4bukKmqRa+MXYSos+vMdCt5ielhw8xJR
         UzlA==
X-Gm-Message-State: AOAM5324eTRmcqZjKoJU9bOiCZJ8K2CokTXr/d/ci/XTVZvIRrGRKclB
        RQyl5hsgzdCJb35U7yPFbLU=
X-Google-Smtp-Source: ABdhPJzYb2ENRrOx9XKQi+v2jGhPwO6W+yw9zBWtZyYwLnJ1zpWjrdwHnvaJ8NFApwWZSBMGJqVjjQ==
X-Received: by 2002:a2e:bf1a:: with SMTP id c26mr5745520ljr.88.1633001375161;
        Thu, 30 Sep 2021 04:29:35 -0700 (PDT)
Received: from localhost.localdomain (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.googlemail.com with ESMTPSA id x7sm341137lfr.109.2021.09.30.04.29.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Sep 2021 04:29:34 -0700 (PDT)
Subject: Re: Lockup in phy_probe() for MDIO device (Broadcom's switch)
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        BCM Kernel Feedback <bcm-kernel-feedback-list@broadcom.com>,
        Vivek Unune <npcomplete13@gmail.com>
References: <2b1dc053-8c9a-e3e4-b450-eecdfca3fe16@gmail.com>
 <YVWOp/2Nj/E1dpe3@shell.armlinux.org.uk>
 <5715f818-a279-d514-dcac-73a94c1d30ef@gmail.com>
 <YVWUKwEXrd39t8iw@shell.armlinux.org.uk>
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <1e4e40ba-23b8-65b4-0b53-1c8393d9a834@gmail.com>
Date:   Thu, 30 Sep 2021 13:29:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <YVWUKwEXrd39t8iw@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30.09.2021 12:40, Russell King (Oracle) wrote:
> In phy_probe, can you add:
> 
> 	WARN_ON(!(phydev->mdio.flags & MDIO_DEVICE_FLAG_PHY));
> 
> just to make sure we have a real PHY device there please? Maybe also
> print the value of the flags argument.
> 
> MDIO_DEVICE_FLAG_PHY is set by phy_create_device() before the mutex is
> initialised, so if it is set, the lock should be initialised.
> 
> Maybe also print mdiodev->flags in mdio_device_register() as well, so
> we can see what is being registered and the flags being used for that
> device.
> 
> Could it be that openwrt is carrying a patch that is causing this
> issue?

I don't think there is any OpenWrt patch affecting that.

MDIO_DEVICE_FLAG_PHY seems to be missing.

[    5.593833] libphy: Fixed MDIO Bus: probed
[    5.598383] libphy: iProc MDIO bus: probed
[    5.602510] iproc-mdio 18003000.mdio: Broadcom iProc MDIO bus registered
[    5.609918] libphy: mdio_mux: probed
[    5.613533] mdio_bus 0.0:10: flags: 0x00000000
[    5.618816] libphy: mdio_mux: probed
[    5.622440] mdio_bus 0.200:00: flags: 0x00000000
[    5.627479] Broadcom B53 (2) 0.200:00: flags: 0x00000000
[    5.632811] ------------[ cut here ]------------
[    5.637475] WARNING: CPU: 0 PID: 1 at drivers/net/phy/phy_device.c:2828 phy_probe+0x40/0x1d4
[    5.645946] Modules linked in:
[    5.649011] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.10.64 #0
[    5.655030] Hardware name: BCM5301X
[    5.658543] [<c0108410>] (unwind_backtrace) from [<c0104bc4>] (show_stack+0x10/0x14)
[    5.666316] [<c0104bc4>] (show_stack) from [<c03dc6a8>] (dump_stack+0x94/0xa8)
[    5.673565] [<c03dc6a8>] (dump_stack) from [<c01183e8>] (__warn+0xb8/0x114)
[    5.680546] [<c01183e8>] (__warn) from [<c01184ac>] (warn_slowpath_fmt+0x68/0x78)
[    5.688050] [<c01184ac>] (warn_slowpath_fmt) from [<c04b8d78>] (phy_probe+0x40/0x1d4)
[    5.695909] [<c04b8d78>] (phy_probe) from [<c0457120>] (really_probe+0xfc/0x4e0)
[    5.703325] [<c0457120>] (really_probe) from [<c0455378>] (bus_for_each_drv+0x74/0x98)
[    5.711262] [<c0455378>] (bus_for_each_drv) from [<c04576b8>] (__device_attach+0xcc/0x120)
[    5.719548] [<c04576b8>] (__device_attach) from [<c0456300>] (bus_probe_device+0x84/0x8c)
[    5.727747] [<c0456300>] (bus_probe_device) from [<c04529ac>] (device_add+0x300/0x77c)
[    5.735687] [<c04529ac>] (device_add) from [<c04ba3dc>] (mdio_device_register+0x38/0x5c)
[    5.743801] [<c04ba3dc>] (mdio_device_register) from [<c04c1b08>] (of_mdiobus_register+0x198/0x2fc)
[    5.752868] [<c04c1b08>] (of_mdiobus_register) from [<c04c238c>] (mdio_mux_init+0x178/0x2c0)
[    5.761328] [<c04c238c>] (mdio_mux_init) from [<c04c2668>] (mdio_mux_mmioreg_probe+0x138/0x1fc)
[    5.770054] [<c04c2668>] (mdio_mux_mmioreg_probe) from [<c0458ee4>] (platform_drv_probe+0x34/0x70)
[    5.779032] [<c0458ee4>] (platform_drv_probe) from [<c0457120>] (really_probe+0xfc/0x4e0)
[    5.787230] [<c0457120>] (really_probe) from [<c0457b04>] (device_driver_attach+0xe4/0xf4)
[    5.795516] [<c0457b04>] (device_driver_attach) from [<c0457b90>] (__driver_attach+0x7c/0x110)
[    5.804149] [<c0457b90>] (__driver_attach) from [<c04552d8>] (bus_for_each_dev+0x64/0x90)
[    5.812340] [<c04552d8>] (bus_for_each_dev) from [<c04564f8>] (bus_add_driver+0xf8/0x1e0)
[    5.820540] [<c04564f8>] (bus_add_driver) from [<c045819c>] (driver_register+0x88/0x118)
[    5.828652] [<c045819c>] (driver_register) from [<c01017e4>] (do_one_initcall+0x54/0x1e8)
[    5.836863] [<c01017e4>] (do_one_initcall) from [<c0801118>] (kernel_init_freeable+0x23c/0x290)
[    5.845583] [<c0801118>] (kernel_init_freeable) from [<c065ad40>] (kernel_init+0x8/0x118)
[    5.853781] [<c065ad40>] (kernel_init) from [<c0100128>] (ret_from_fork+0x14/0x2c)
[    5.861367] Exception stack(0xc1035fb0 to 0xc1035ff8)
[    5.866425] 5fa0:                                     00000000 00000000 00000000 00000000
[    5.874618] 5fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[    5.882816] 5fe0: 00000000 00000000 00000000 00000000 00000013 00000000
[    5.889473] ---[ end trace f28513567c7daf95 ]---
[    5.894105] ------------[ cut here ]------------
[    5.898743] WARNING: CPU: 0 PID: 1 at kernel/locking/mutex.c:951 __mutex_lock.constprop.0+0x744/0x848
[    5.907983] DEBUG_LOCKS_WARN_ON(lock->magic != lock)


diff --git a/drivers/net/phy/mdio_device.c b/drivers/net/phy/mdio_device.c
index 0837319a5..910149c8d 100644
--- a/drivers/net/phy/mdio_device.c
+++ b/drivers/net/phy/mdio_device.c
@@ -83,6 +83,8 @@ int mdio_device_register(struct mdio_device *mdiodev)
         if (err)
                 return err;

+       dev_info(&mdiodev->dev, "flags: 0x%08x\n", mdiodev->flags);
+
         err = device_add(&mdiodev->dev);
         if (err) {
                 pr_err("MDIO %d failed to add\n", mdiodev->addr);
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 950277e4d..02c06e6d5 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -2824,6 +2824,9 @@ static int phy_probe(struct device *dev)
         struct phy_driver *phydrv = to_phy_driver(drv);
         int err = 0;

+       dev_info(dev, "flags: 0x%08x\n", phydev->mdio.flags);
+       WARN_ON(!(phydev->mdio.flags & MDIO_DEVICE_FLAG_PHY));
+
         phydev->drv = phydrv;

         /* Disable the interrupt if the PHY doesn't support it
