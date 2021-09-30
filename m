Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8632F41D7BE
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 12:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349952AbhI3Kck (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 06:32:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349927AbhI3Kcj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 06:32:39 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 984A5C06176A
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 03:30:56 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id g41so23227625lfv.1
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 03:30:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EU7gN5UDAZ5irOOkb/ODmTenNvxaf7stYRGdSn+YSDc=;
        b=ai3AiJ1HwsWZU3LxBXL4cTWeikgi66jkOec+jxNVNmNsoPoLgmzLB+lhDbPlG0w8lP
         v2zf0VJiwlC1GZQNVTwkoSnI60Dz12muY3s6BatTxQg9g6+bDdzpxDCwWt/L+U4FdnF/
         dOPBLJ3LwLOnWHyNFlJPqO6rNO2sw4wuhSOCIK7KjFAn1jCZ8UIpWtQNOLggDHZst5ga
         WGc7428TUIdw552Schc+gxHTHjL3I2N29UPeB12PhOF4C0ZA/oFCsjXumEoUTVpU+cUw
         TG0B0GUYIrnKclIu/VIr6scSWc5zop3NO9wJsQ9vcDNADfC1fDJcOOWtJQaR7tOrLx0q
         cfQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EU7gN5UDAZ5irOOkb/ODmTenNvxaf7stYRGdSn+YSDc=;
        b=roCHSfoZxqKk7E0npCiimVGULx/Kp6CoYvkAqIoUDAkxexBXsSDgVq9Yc+bAelxA36
         OhChYc1nlMnyNerJiRcUQMI8n6PBJMhZdrQSLBqi9P3yUUPgVKng5Z+PL2r6pKh4QFiX
         7mrFnU8evfWBN4rYfXVlHIjJ4yZQ8W5E22MMxoT/zrRyAxVODmZLcClqSYtb72y3+eEs
         2RMesNsWG6aerVR83syFnBCrxoAinmI0pznmoz4biV+h2FiZQkRSue33jjQGOo1xNbrw
         cAwbHzGdlIy0o5Kauqd1QKFO2LtBzqF0VYuNCTvkDf/mJ2XFKMMSb2nbkU+7hHUWvdlt
         Op0g==
X-Gm-Message-State: AOAM5327Vq1aANq6IC5vlf/arId4EqstXpRZz/LxvNr3ctTbLfKWKIDr
        WBmkmhqX+Zp88eVD5fFDZr9+FsDBryM=
X-Google-Smtp-Source: ABdhPJy6t0ENr8AuSKTwRSDUhDjfwmY6r5iyD2j9d2DVhlsoOk1tdRfA9Cc7crtO1sr+3aqwCoXJGw==
X-Received: by 2002:a2e:a787:: with SMTP id c7mr3200163ljf.264.1632997854810;
        Thu, 30 Sep 2021 03:30:54 -0700 (PDT)
Received: from localhost.localdomain (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.googlemail.com with ESMTPSA id r139sm323606lff.161.2021.09.30.03.30.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Sep 2021 03:30:54 -0700 (PDT)
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
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <5715f818-a279-d514-dcac-73a94c1d30ef@gmail.com>
Date:   Thu, 30 Sep 2021 12:30:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <YVWOp/2Nj/E1dpe3@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30.09.2021 12:17, Russell King (Oracle) wrote:
> On Thu, Sep 30, 2021 at 11:58:21AM +0200, Rafał Miłecki wrote:
>> This isn't necessarily a PHY / MDIO regression. It could be some core
>> change that exposed a PHY / MDIO bug.
> 
> I think what's going on is that the switch device is somehow being
> probed by phylib. It looks to me like we don't check that the mdio
> device being matched in phy_bus_match() is actually a PHY (by
> checking whether mdiodev->flags & MDIO_DEVICE_FLAG_PHY is true
> before proceeding with any matching.)
> 
> We do, however, check the driver side. This looks to me like a problem
> especially when the mdio bus can contain a mixture of PHY devices and
> non-PHY devices. However, I would expect this to also be blowing up in
> the mainline kernel as well - but it doesn't seem to.
> 
> Maybe Andrew can provide a reason why this doesn't happen - maybe we've
> just been lucky with out-of-bounds read accesses (to the non-existent
> phy_device wrapped around the mdio_device?)

I'll see if I can use buildroot to test unmodified kernel.


> If my theory is correct, this patch should solve your issue:
> 
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index ba5ad86ec826..dac017174ab1 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -462,7 +462,8 @@ static int phy_bus_match(struct device *dev, struct device_driver *drv)
>   	const int num_ids = ARRAY_SIZE(phydev->c45_ids.device_ids);
>   	int i;
>   
> -	if (!(phydrv->mdiodrv.flags & MDIO_DEVICE_IS_PHY))
> +	if (!(phydrv->mdiodrv.flags & MDIO_DEVICE_IS_PHY) ||
> +	    !(phydev->mdio.flags & MDIO_DEVICE_FLAG_PHY))
>   		return 0;
>   
>   	if (phydrv->match_phy_device)
> 

Unfortunately this doesn't seem to help

[    6.219828] libphy: Fixed MDIO Bus: probed
[    6.224376] libphy: iProc MDIO bus: probed
[    6.228506] iproc-mdio 18003000.mdio: Broadcom iProc MDIO bus registered
[    6.235906] libphy: mdio_mux: probed
[    6.240298] libphy: mdio_mux: probed
[    6.244316] ------------[ cut here ]------------
[    6.248969] WARNING: CPU: 1 PID: 1 at kernel/locking/mutex.c:951 __mutex_lock.constprop.0+0x744/0x848
[    6.258223] DEBUG_LOCKS_WARN_ON(lock->magic != lock)
[    6.258226] Modules linked in:
[    6.266265] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 5.10.64 #0
[    6.272278] Hardware name: BCM5301X
[    6.275791] [<c0108410>] (unwind_backtrace) from [<c0104bc4>] (show_stack+0x10/0x14)
[    6.283564] [<c0104bc4>] (show_stack) from [<c03dc6a8>] (dump_stack+0x94/0xa8)
[    6.290812] [<c03dc6a8>] (dump_stack) from [<c01183e8>] (__warn+0xb8/0x114)
[    6.297794] [<c01183e8>] (__warn) from [<c01184ac>] (warn_slowpath_fmt+0x68/0x78)
[    6.305298] [<c01184ac>] (warn_slowpath_fmt) from [<c065defc>] (__mutex_lock.constprop.0+0x744/0x848)
[    6.314549] [<c065defc>] (__mutex_lock.constprop.0) from [<c04b8d8c>] (phy_probe+0x48/0x198)
[    6.323017] [<c04b8d8c>] (phy_probe) from [<c0457120>] (really_probe+0xfc/0x4e0)
[    6.330434] [<c0457120>] (really_probe) from [<c0455378>] (bus_for_each_drv+0x74/0x98)
[    6.338372] [<c0455378>] (bus_for_each_drv) from [<c04576b8>] (__device_attach+0xcc/0x120)
[    6.346657] [<c04576b8>] (__device_attach) from [<c0456300>] (bus_probe_device+0x84/0x8c)
[    6.354856] [<c0456300>] (bus_probe_device) from [<c04529ac>] (device_add+0x300/0x77c)
[    6.362797] [<c04529ac>] (device_add) from [<c04ba398>] (mdio_device_register+0x24/0x48)
[    6.370911] [<c04ba398>] (mdio_device_register) from [<c04c1ac4>] (of_mdiobus_register+0x198/0x2fc)
[    6.379978] [<c04c1ac4>] (of_mdiobus_register) from [<c04c2348>] (mdio_mux_init+0x178/0x2c0)
[    6.388436] [<c04c2348>] (mdio_mux_init) from [<c04c2624>] (mdio_mux_mmioreg_probe+0x138/0x1fc)
[    6.397163] [<c04c2624>] (mdio_mux_mmioreg_probe) from [<c0458ee4>] (platform_drv_probe+0x34/0x70)
[    6.406142] [<c0458ee4>] (platform_drv_probe) from [<c0457120>] (really_probe+0xfc/0x4e0)
[    6.414339] [<c0457120>] (really_probe) from [<c0457b04>] (device_driver_attach+0xe4/0xf4)
[    6.422626] [<c0457b04>] (device_driver_attach) from [<c0457b90>] (__driver_attach+0x7c/0x110)
[    6.431260] [<c0457b90>] (__driver_attach) from [<c04552d8>] (bus_for_each_dev+0x64/0x90)
[    6.439459] [<c04552d8>] (bus_for_each_dev) from [<c04564f8>] (bus_add_driver+0xf8/0x1e0)
[    6.447658] [<c04564f8>] (bus_add_driver) from [<c045819c>] (driver_register+0x88/0x118)
[    6.455772] [<c045819c>] (driver_register) from [<c01017e4>] (do_one_initcall+0x54/0x1e8)
[    6.463978] [<c01017e4>] (do_one_initcall) from [<c0801118>] (kernel_init_freeable+0x23c/0x290)
[    6.472701] [<c0801118>] (kernel_init_freeable) from [<c065ad00>] (kernel_init+0x8/0x118)
[    6.480899] [<c065ad00>] (kernel_init) from [<c0100128>] (ret_from_fork+0x14/0x2c)
[    6.488486] Exception stack(0xc1035fb0 to 0xc1035ff8)
[    6.493545] 5fa0:                                     00000000 00000000 00000000 00000000
[    6.501736] 5fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[    6.509934] 5fe0: 00000000 00000000 00000000 00000000 00000013 00000000
[    6.516581] ---[ end trace b8ef68dd409e132c ]---
[    6.521227] 8<--- cut here ---
[    6.524303] Unable to handle kernel NULL pointer dereference at virtual address 00000180
[    6.532409] pgd = 4c4edbcc
[    6.535130] [00000180] *pgd=00000000
[    6.538720] Internal error: Oops: 805 [#1] SMP ARM
[    6.543521] Modules linked in:
[    6.546579] CPU: 1 PID: 1 Comm: swapper/0 Tainted: G        W         5.10.64 #0
[    6.553992] Hardware name: BCM5301X
[    6.557486] PC is at __mutex_add_waiter+0x34/0x60
[    6.562201] LR is at __mutex_add_waiter+0x24/0x60
[    6.566909] pc : [<c01595cc>]    lr : [<c01595bc>]    psr: 80000013
[    6.573184] sp : c1035c40  ip : c134e040  fp : c1038000
[    6.578416] r10: c090530c  r9 : c06f56f4  r8 : c1035c74
[    6.583646] r7 : c09b24ac  r6 : c123b290  r5 : c123b29c  r4 : c1035c74
[    6.590184] r3 : 00000180  r2 : c1038000  r1 : c1035c74  r0 : c123b290
[    6.596720] Flags: Nzcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
[    6.603867] Control: 10c5387d  Table: 0000404a  DAC: 00000051
[    6.609621] Process swapper/0 (pid: 1, stack limit = 0xf3633140)
[    6.615634] Stack: (0xc1035c40 to 0xc1036000)
[    6.619999] 5c40: c123b290 c123b28c 00000004 c065daa4 c06f56e0 c0763cc8 c1034000 00000002
[    6.628197] 5c60: c0982e64 c123b294 c138d000 c02da7f4 00000000 c123b29c 00000180 11111111
[    6.636396] 5c80: 11111111 c1035c74 00000000 c123b000 c0982e64 00000000 c123b290 00000000
[    6.644595] 5ca0: c0982e64 00000000 c0751344 c04b8d8c c123b000 c09c0880 00000000 c09c0870
[    6.652786] 5cc0: 00000000 c0457120 00000000 00000000 c1035d08 c04578ec c121f578 00000000
[    6.660985] 5ce0: c097eb54 00000000 c0751344 c0455378 c119ab70 c12885b8 c123b000 00000001
[    6.669183] 5d00: c123b044 c04576b8 c123b000 00000001 c123b000 c123b000 c098284c c0456300
[    6.677374] 5d20: c123b000 00000000 c09c0740 c04529ac 00000000 00000000 00000000 c03e23c8
[    6.685573] 5d40: c123b000 0a3031d0 00000000 00000000 c123b000 c6973ddc 00000000 00000000
[    6.693773] 5d60: c123b000 c04ba398 c6973ef8 c121f000 c6973ddc c04c1ac4 00000000 0000003d
[    6.701972] 5d80: ffffff0f 00000001 00000000 c121f578 c0755054 c0753064 00000000 00000000
[    6.710171] 5da0: c6973974 c129c7c0 c129c540 c6973ddc 00000000 c1153410 c6973974 c0751344
[    6.718370] 5dc0: c0755c60 c04c2348 00000200 c04de798 c0755c54 c129c4c0 c1035e18 00000200
[    6.726570] 5de0: 00000200 00000000 c129c4c0 c6973974 c0751344 c1153400 c1153410 00000000
[    6.734769] 5e00: c0839bc8 c04c2624 c129c4c0 c121b000 00000000 00000004 18003000 18003003
[    6.742968] 5e20: c69739cc 00000200 00000000 00000000 00000000 00000000 c0984350 c1153410
[    6.751167] 5e40: c0984350 00000000 c09c0870 00000000 c0984350 c0458ee4 c1153410 c09c0880
[    6.759366] 5e60: 00000000 c0457120 00000000 c1153410 00000000 c1153454 c0984350 c0831854
[    6.767564] 5e80: c0831834 c08003e4 c0839bc8 c0457b04 00000000 c0984350 c1153410 c097ee50
[    6.775755] 5ea0: c0831854 c0457b90 00000000 c0984350 c0457b14 c04552d8 c100e35c c114c534
[    6.783945] 5ec0: c0984350 c129c400 00000000 c04564f8 c0755df0 ffffe000 00000000 c0984350
[    6.792137] 5ee0: 00000000 ffffe000 00000000 c045819c c098e010 c081b88c ffffe000 c01017e4
[    6.800335] 5f00: c108cb00 c108cb15 c07ac224 00000000 0000005f c013593c 00000dc0 c07abacc
[    6.808535] 5f20: c0730bbc 00000006 00000006 c07002b0 c06f4888 c06f483c c108cb15 00000000
[    6.816733] 5f40: 00000000 00000007 c108cb00 0a3031d0 c098e020 00000007 c108cb00 c07abacc
[    6.824924] 5f60: c098e020 c0801118 00000006 00000006 00000000 c08003e4 00000000 0000005f
[    6.833114] 5f80: 00000000 00000000 c065acf8 00000000 00000000 00000000 00000000 00000000
[    6.841305] 5fa0: 00000000 c065ad00 00000000 c0100128 00000000 00000000 00000000 00000000
[    6.849496] 5fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[    6.857694] 5fe0: 00000000 00000000 00000000 00000000 00000013 00000000 00000000 00000000
[    6.865891] [<c01595cc>] (__mutex_add_waiter) from [<c065daa4>] (__mutex_lock.constprop.0+0x2ec/0x848)
[    6.875220] [<c065daa4>] (__mutex_lock.constprop.0) from [<c04b8d8c>] (phy_probe+0x48/0x198)
[    6.883682] [<c04b8d8c>] (phy_probe) from [<c0457120>] (really_probe+0xfc/0x4e0)
[    6.891093] [<c0457120>] (really_probe) from [<c0455378>] (bus_for_each_drv+0x74/0x98)
[    6.899031] [<c0455378>] (bus_for_each_drv) from [<c04576b8>] (__device_attach+0xcc/0x120)
[    6.907317] [<c04576b8>] (__device_attach) from [<c0456300>] (bus_probe_device+0x84/0x8c)
[    6.915516] [<c0456300>] (bus_probe_device) from [<c04529ac>] (device_add+0x300/0x77c)
[    6.923456] [<c04529ac>] (device_add) from [<c04ba398>] (mdio_device_register+0x24/0x48)
[    6.931568] [<c04ba398>] (mdio_device_register) from [<c04c1ac4>] (of_mdiobus_register+0x198/0x2fc)
[    6.940636] [<c04c1ac4>] (of_mdiobus_register) from [<c04c2348>] (mdio_mux_init+0x178/0x2c0)
[    6.949096] [<c04c2348>] (mdio_mux_init) from [<c04c2624>] (mdio_mux_mmioreg_probe+0x138/0x1fc)
[    6.957820] [<c04c2624>] (mdio_mux_mmioreg_probe) from [<c0458ee4>] (platform_drv_probe+0x34/0x70)
[    6.966800] [<c0458ee4>] (platform_drv_probe) from [<c0457120>] (really_probe+0xfc/0x4e0)
[    6.974999] [<c0457120>] (really_probe) from [<c0457b04>] (device_driver_attach+0xe4/0xf4)
[    6.983285] [<c0457b04>] (device_driver_attach) from [<c0457b90>] (__driver_attach+0x7c/0x110)
[    6.991919] [<c0457b90>] (__driver_attach) from [<c04552d8>] (bus_for_each_dev+0x64/0x90)
[    7.000118] [<c04552d8>] (bus_for_each_dev) from [<c04564f8>] (bus_add_driver+0xf8/0x1e0)
[    7.008310] [<c04564f8>] (bus_add_driver) from [<c045819c>] (driver_register+0x88/0x118)
[    7.016423] [<c045819c>] (driver_register) from [<c01017e4>] (do_one_initcall+0x54/0x1e8)
[    7.024624] [<c01017e4>] (do_one_initcall) from [<c0801118>] (kernel_init_freeable+0x23c/0x290)
[    7.033343] [<c0801118>] (kernel_init_freeable) from [<c065ad00>] (kernel_init+0x8/0x118)
[    7.041541] [<c065ad00>] (kernel_init) from [<c0100128>] (ret_from_fork+0x14/0x2c)
[    7.049128] Exception stack(0xc1035fb0 to 0xc1035ff8)
[    7.054187] 5fa0:                                     00000000 00000000 00000000 00000000
[    7.062377] 5fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[    7.070567] 5fe0: 00000000 00000000 00000000 00000000 00000013 00000000
[    7.077192] Code: e5953004 e5854004 e5845000 e5843004 (e5834000)
[    7.083321] ---[ end trace b8ef68dd409e132d ]---
[    7.087956] Kernel panic - not syncing: Fatal exception
[    7.093195] CPU0: stopping
[    7.095907] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G      D W         5.10.64 #0
[    7.103318] Hardware name: BCM5301X
[    7.106820] [<c0108410>] (unwind_backtrace) from [<c0104bc4>] (show_stack+0x10/0x14)
[    7.114592] [<c0104bc4>] (show_stack) from [<c03dc6a8>] (dump_stack+0x94/0xa8)
[    7.121829] [<c03dc6a8>] (dump_stack) from [<c0106c80>] (do_handle_IPI+0xf8/0x12c)
[    7.129418] [<c0106c80>] (do_handle_IPI) from [<c0106ccc>] (ipi_handler+0x18/0x20)
[    7.137017] [<c0106ccc>] (ipi_handler) from [<c0162ae4>] (__handle_domain_irq+0x84/0xd8)
[    7.145132] [<c0162ae4>] (__handle_domain_irq) from [<c03f4fc8>] (gic_handle_irq+0x80/0x94)
[    7.153502] [<c03f4fc8>] (gic_handle_irq) from [<c0100aec>] (__irq_svc+0x6c/0x90)
[    7.161000] Exception stack(0xc0901f48 to 0xc0901f90)
[    7.166060] 1f40:                   000841a2 00000000 000841a4 c010e540 c0900000 00000000
[    7.174251] 1f60: c0904f14 c0904f54 c0831a34 413fc090 10c5387d 00000000 00000000 c0901f98
[    7.182448] 1f80: c0102644 c0102648 60000013 ffffffff
[    7.187508] [<c0100aec>] (__irq_svc) from [<c0102648>] (arch_cpu_idle+0x38/0x3c)
[    7.194934] [<c0102648>] (arch_cpu_idle) from [<c0143d54>] (do_idle+0xc0/0x138)
[    7.202262] [<c0143d54>] (do_idle) from [<c0144048>] (cpu_startup_entry+0x18/0x1c)
[    7.209853] [<c0144048>] (cpu_startup_entry) from [<c0800e74>] (start_kernel+0x4f8/0x50c)
[    7.218050] [<c0800e74>] (start_kernel) from [<00000000>] (0x0)
[    7.223986] Rebooting in 1 seconds..
