Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4CDE41D770
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 12:15:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349862AbhI3KQ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 06:16:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349814AbhI3KQ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 06:16:57 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CA71C06176A
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 03:15:14 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id y26so23089039lfa.11
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 03:15:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rmpL1PjWpUSvJ15WGXzAyeyBQS/zh6kaK1ccoCL8nBU=;
        b=BB2ZSdGPFKTmVOnDniBsuScC8WEy6UY7sLPtbD3Pol3aKimP4c9Hsx11JgWSg8N24K
         4G9lP3xMu8q8Q5QbS883GunF0wgM94dAQKoRNXAaLa1jEXNAaJyHm78gXFzuDGp8gudr
         qovFwVj/rMYl/3ilL3Z5kWqz+WMy3/2puZLt9zQSZurYz/ZMhOMfRKCYaMhlNwuE6lA/
         DY2Mq3gTF/lSt2z7IN+Hopi5aeyp/LBq3p7RxMho906Jy4cFV3UvHgriVXN5XM2Olqo1
         yN5Nu8fGjI56bjqKOxba2eHHkZtIY5r3TS9kNoOQbtLzhyx0/rekUw4xpWPMH2VbozNb
         rCPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rmpL1PjWpUSvJ15WGXzAyeyBQS/zh6kaK1ccoCL8nBU=;
        b=VzTE5xgp0wug6vLOJC8z873cCWhtC2FBk7BsZ0BcUaHML4MlRhXfksCFA8Yytn1vCY
         cfHHY96T+hCzH1EmIA1bzn6hHu7revyuYuFeoGR4gEwTx9V1vs2hAd2KYaJ3XT9f80h7
         WFre2SkhJVGP3reTgNASZ6SSFbRjuDMaswPTqdZIyveVUDwR7gMTHUAojzgVkgRS+J3J
         U4OOFPoYxUSmqjdVIynNbqJDtvhiwE1fG7yG4xE+s3coiwoIFeXjLamDcQ1ci0GIgycU
         P+HlZmPNCAlGfREHZdgCj3gUgf/2V+nIlnjni2FxXCQ4hK25+Q/MHp526iYNNAOjKgyZ
         1UxA==
X-Gm-Message-State: AOAM532kNHB2na+OdHU+hMId5NjwYp5sRsLiBvEEgpWiIzfevjJUG2W/
        /YkD2Ik/4mX2i1JRAlfu8B8=
X-Google-Smtp-Source: ABdhPJxKNnu7P8MW3n7S149Jrd0+S33NYkS2yiNRbGlk3wOdLc2i7QP5sA68R23pt6tq/xLskJLRZw==
X-Received: by 2002:a05:6512:b0f:: with SMTP id w15mr5164251lfu.164.1632996912824;
        Thu, 30 Sep 2021 03:15:12 -0700 (PDT)
Received: from localhost.localdomain (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.googlemail.com with ESMTPSA id m25sm289113lji.52.2021.09.30.03.15.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Sep 2021 03:15:12 -0700 (PDT)
Subject: Re: Lockup in phy_probe() for MDIO device (Broadcom's switch)
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Network Development <netdev@vger.kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        BCM Kernel Feedback <bcm-kernel-feedback-list@broadcom.com>,
        Vivek Unune <npcomplete13@gmail.com>
References: <2b1dc053-8c9a-e3e4-b450-eecdfca3fe16@gmail.com>
Message-ID: <e865300d-9e9f-d972-19c6-fd5e070baa9c@gmail.com>
Date:   Thu, 30 Sep 2021 12:15:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <2b1dc053-8c9a-e3e4-b450-eecdfca3fe16@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30.09.2021 11:58, Rafał Miłecki wrote:
> I've just received a report of kernel lockup after switching OpenWrt
> platform from kernel 5.4 to kernel 5.10:
> https://bugs.openwrt.org/index.php?do=details&task_id=4055
> 
> The problem is phy_probe() and its:
> mutex_lock(&phydev->lock);
> 
> It seems to me that "lock" mutex doesn't get initalized. It seems
> phy_device_create() doesn't get called for an MDIO device.

dmesg without debugging diff but with CONFIG_DEBUG_MUTEXES=y

[    6.227101] libphy: Fixed MDIO Bus: probed
[    6.231599] libphy: iProc MDIO bus: probed
[    6.235746] iproc-mdio 18003000.mdio: Broadcom iProc MDIO bus registered
[    6.243141] libphy: mdio_mux: probed
[    6.247559] libphy: mdio_mux: probed
[    6.251517] ------------[ cut here ]------------
[    6.256192] WARNING: CPU: 1 PID: 1 at kernel/locking/mutex.c:951 __mutex_lock.constprop.0+0x744/0x848
[    6.265439] DEBUG_LOCKS_WARN_ON(lock->magic != lock)
[    6.265442] Modules linked in:
[    6.273470] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 5.10.64 #0
[    6.279488] Hardware name: BCM5301X
[    6.283001] [<c0108410>] (unwind_backtrace) from [<c0104bc4>] (show_stack+0x10/0x14)
[    6.290775] [<c0104bc4>] (show_stack) from [<c03dc6a8>] (dump_stack+0x94/0xa8)
[    6.298024] [<c03dc6a8>] (dump_stack) from [<c01183e8>] (__warn+0xb8/0x114)
[    6.305004] [<c01183e8>] (__warn) from [<c01184ac>] (warn_slowpath_fmt+0x68/0x78)
[    6.312509] [<c01184ac>] (warn_slowpath_fmt) from [<c065deec>] (__mutex_lock.constprop.0+0x744/0x848)
[    6.321759] [<c065deec>] (__mutex_lock.constprop.0) from [<c04b8d80>] (phy_probe+0x48/0x198)
[    6.330229] [<c04b8d80>] (phy_probe) from [<c0457120>] (really_probe+0xfc/0x4e0)
[    6.337646] [<c0457120>] (really_probe) from [<c0455378>] (bus_for_each_drv+0x74/0x98)
[    6.345583] [<c0455378>] (bus_for_each_drv) from [<c04576b8>] (__device_attach+0xcc/0x120)
[    6.353868] [<c04576b8>] (__device_attach) from [<c0456300>] (bus_probe_device+0x84/0x8c)
[    6.362067] [<c0456300>] (bus_probe_device) from [<c04529ac>] (device_add+0x300/0x77c)
[    6.370008] [<c04529ac>] (device_add) from [<c04ba38c>] (mdio_device_register+0x24/0x48)
[    6.378121] [<c04ba38c>] (mdio_device_register) from [<c04c1ab8>] (of_mdiobus_register+0x198/0x2fc)
[    6.387188] [<c04c1ab8>] (of_mdiobus_register) from [<c04c233c>] (mdio_mux_init+0x178/0x2c0)
[    6.395647] [<c04c233c>] (mdio_mux_init) from [<c04c2618>] (mdio_mux_mmioreg_probe+0x138/0x1fc)
[    6.404375] [<c04c2618>] (mdio_mux_mmioreg_probe) from [<c0458ee4>] (platform_drv_probe+0x34/0x70)
[    6.413352] [<c0458ee4>] (platform_drv_probe) from [<c0457120>] (really_probe+0xfc/0x4e0)
[    6.421550] [<c0457120>] (really_probe) from [<c0457b04>] (device_driver_attach+0xe4/0xf4)
[    6.429837] [<c0457b04>] (device_driver_attach) from [<c0457b90>] (__driver_attach+0x7c/0x110)
[    6.438471] [<c0457b90>] (__driver_attach) from [<c04552d8>] (bus_for_each_dev+0x64/0x90)
[    6.446669] [<c04552d8>] (bus_for_each_dev) from [<c04564f8>] (bus_add_driver+0xf8/0x1e0)
[    6.454861] [<c04564f8>] (bus_add_driver) from [<c045819c>] (driver_register+0x88/0x118)
[    6.462974] [<c045819c>] (driver_register) from [<c01017e4>] (do_one_initcall+0x54/0x1e8)
[    6.471180] [<c01017e4>] (do_one_initcall) from [<c0801118>] (kernel_init_freeable+0x23c/0x290)
[    6.479904] [<c0801118>] (kernel_init_freeable) from [<c065acf0>] (kernel_init+0x8/0x118)
[    6.488100] [<c065acf0>] (kernel_init) from [<c0100128>] (ret_from_fork+0x14/0x2c)
[    6.495680] Exception stack(0xc1035fb0 to 0xc1035ff8)
[    6.500739] 5fa0:                                     00000000 00000000 00000000 00000000
[    6.508938] 5fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[    6.517128] 5fe0: 00000000 00000000 00000000 00000000 00000013 00000000
[    6.523776] ---[ end trace 3cbdf5abbf86c3cc ]---
[    6.528422] 8<--- cut here ---
[    6.531479] Unable to handle kernel NULL pointer dereference at virtual address 00000180
[    6.539599] pgd = 1f10e6e2
[    6.542306] [00000180] *pgd=00000000
[    6.545896] Internal error: Oops: 805 [#1] SMP ARM
[    6.550698] Modules linked in:
[    6.553755] CPU: 1 PID: 1 Comm: swapper/0 Tainted: G        W         5.10.64 #0
[    6.561167] Hardware name: BCM5301X
[    6.564663] PC is at __mutex_add_waiter+0x34/0x60
[    6.569376] LR is at __mutex_add_waiter+0x24/0x60
[    6.574085] pc : [<c01595cc>]    lr : [<c01595bc>]    psr: 80000013
[    6.580360] sp : c1035c40  ip : 00000000  fp : c1038000
[    6.585591] r10: c090530c  r9 : c06f56f4  r8 : c1035c74
[    6.590823] r7 : c09b24ac  r6 : c13b9490  r5 : c13b949c  r4 : c1035c74
[    6.597360] r3 : 00000180  r2 : c1038000  r1 : c1035c74  r0 : c13b9490
[    6.603897] Flags: Nzcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
[    6.611043] Control: 10c5387d  Table: 0000404a  DAC: 00000051
[    6.616796] Process swapper/0 (pid: 1, stack limit = 0xde2e9975)
[    6.622811] Stack: (0xc1035c40 to 0xc1036000)
[    6.627174] 5c40: c13b9490 c13b948c 00000004 c065da94 c06f56e0 c0763cc8 c1034000 00000002
[    6.635372] 5c60: c0982e64 c13b9494 c13cc000 c02da7f4 00000000 c13b949c 00000180 11111111
[    6.643571] 5c80: 11111111 c1035c74 00000000 c13b9200 c0982e64 00000000 c13b9490 00000000
[    6.651770] 5ca0: c0982e64 00000000 c0751344 c04b8d80 c13b9200 c09c0880 00000000 c09c0870
[    6.659969] 5cc0: 00000000 c0457120 00000000 00000000 c1035d08 c04578ec c12cf578 00000000
[    6.668161] 5ce0: c097eb54 00000000 c0751344 c0455378 c119ab70 c127f5b8 c13b9200 00000001
[    6.676360] 5d00: c13b9244 c04576b8 c13b9200 00000001 c13b9200 c13b9200 c098284c c0456300
[    6.684559] 5d20: c13b9200 00000000 c09c0740 c04529ac 00000000 00000000 00000000 c03e23c8
[    6.692757] 5d40: c13b9200 0a3031d0 00000000 00000000 c13b9200 c6973ddc 00000000 00000000
[    6.700949] 5d60: c13b9200 c04ba38c c6973ef8 c12cf000 c6973ddc c04c1ab8 00000000 0000003d
[    6.709148] 5d80: ffffff0f 00000001 00000000 c12cf578 c0755054 c0753064 00000000 00000000
[    6.717347] 5da0: c6973974 c11f67c0 c11f6540 c6973ddc 00000000 c1153410 c6973974 c0751344
[    6.725545] 5dc0: c0755c60 c04c233c 00000200 c04de78c c0755c54 c11f64c0 c1035e18 00000200
[    6.733736] 5de0: 00000200 00000000 c11f64c0 c6973974 c0751344 c1153400 c1153410 00000000
[    6.741927] 5e00: c0839bc8 c04c2618 c11f64c0 c12cb000 00000000 00000004 18003000 18003003
[    6.750126] 5e20: c69739cc 00000200 00000000 00000000 00000000 00000000 c0984350 c1153410
[    6.758325] 5e40: c0984350 00000000 c09c0870 00000000 c0984350 c0458ee4 c1153410 c09c0880
[    6.766516] 5e60: 00000000 c0457120 00000000 c1153410 00000000 c1153454 c0984350 c0831854
[    6.774715] 5e80: c0831834 c08003e4 c0839bc8 c0457b04 00000000 c0984350 c1153410 c097ee50
[    6.782914] 5ea0: c0831854 c0457b90 00000000 c0984350 c0457b14 c04552d8 c100e35c c114c534
[    6.791113] 5ec0: c0984350 c11f6400 00000000 c04564f8 c0755df0 ffffe000 00000000 c0984350
[    6.799312] 5ee0: 00000000 ffffe000 00000000 c045819c c098e010 c081b88c ffffe000 c01017e4
[    6.807502] 5f00: c108cb00 c108cb15 c07ac224 00000000 0000005f c013593c 00000dc0 c07abacc
[    6.815692] 5f20: c0730bbc 00000006 00000006 c07002b0 c06f4888 c06f483c c108cb15 00000000
[    6.823884] 5f40: 00000000 00000007 c108cb00 0a3031d0 c098e020 00000007 c108cb00 c07abacc
[    6.832082] 5f60: c098e020 c0801118 00000006 00000006 00000000 c08003e4 00000000 0000005f
[    6.840273] 5f80: 00000000 00000000 c065ace8 00000000 00000000 00000000 00000000 00000000
[    6.848464] 5fa0: 00000000 c065acf0 00000000 c0100128 00000000 00000000 00000000 00000000
[    6.856662] 5fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[    6.864853] 5fe0: 00000000 00000000 00000000 00000000 00000013 00000000 00000000 00000000
[    6.873051] [<c01595cc>] (__mutex_add_waiter) from [<c065da94>] (__mutex_lock.constprop.0+0x2ec/0x848)
[    6.882378] [<c065da94>] (__mutex_lock.constprop.0) from [<c04b8d80>] (phy_probe+0x48/0x198)
[    6.890841] [<c04b8d80>] (phy_probe) from [<c0457120>] (really_probe+0xfc/0x4e0)
[    6.898252] [<c0457120>] (really_probe) from [<c0455378>] (bus_for_each_drv+0x74/0x98)
[    6.906189] [<c0455378>] (bus_for_each_drv) from [<c04576b8>] (__device_attach+0xcc/0x120)
[    6.914475] [<c04576b8>] (__device_attach) from [<c0456300>] (bus_probe_device+0x84/0x8c)
[    6.922675] [<c0456300>] (bus_probe_device) from [<c04529ac>] (device_add+0x300/0x77c)
[    6.930614] [<c04529ac>] (device_add) from [<c04ba38c>] (mdio_device_register+0x24/0x48)
[    6.938727] [<c04ba38c>] (mdio_device_register) from [<c04c1ab8>] (of_mdiobus_register+0x198/0x2fc)
[    6.947794] [<c04c1ab8>] (of_mdiobus_register) from [<c04c233c>] (mdio_mux_init+0x178/0x2c0)
[    6.956255] [<c04c233c>] (mdio_mux_init) from [<c04c2618>] (mdio_mux_mmioreg_probe+0x138/0x1fc)
[    6.964978] [<c04c2618>] (mdio_mux_mmioreg_probe) from [<c0458ee4>] (platform_drv_probe+0x34/0x70)
[    6.973958] [<c0458ee4>] (platform_drv_probe) from [<c0457120>] (really_probe+0xfc/0x4e0)
[    6.982157] [<c0457120>] (really_probe) from [<c0457b04>] (device_driver_attach+0xe4/0xf4)
[    6.990444] [<c0457b04>] (device_driver_attach) from [<c0457b90>] (__driver_attach+0x7c/0x110)
[    6.999079] [<c0457b90>] (__driver_attach) from [<c04552d8>] (bus_for_each_dev+0x64/0x90)
[    7.007276] [<c04552d8>] (bus_for_each_dev) from [<c04564f8>] (bus_add_driver+0xf8/0x1e0)
[    7.015467] [<c04564f8>] (bus_add_driver) from [<c045819c>] (driver_register+0x88/0x118)
[    7.023574] [<c045819c>] (driver_register) from [<c01017e4>] (do_one_initcall+0x54/0x1e8)
[    7.031775] [<c01017e4>] (do_one_initcall) from [<c0801118>] (kernel_init_freeable+0x23c/0x290)
[    7.040493] [<c0801118>] (kernel_init_freeable) from [<c065acf0>] (kernel_init+0x8/0x118)
[    7.048690] [<c065acf0>] (kernel_init) from [<c0100128>] (ret_from_fork+0x14/0x2c)
[    7.056269] Exception stack(0xc1035fb0 to 0xc1035ff8)
[    7.061327] 5fa0:                                     00000000 00000000 00000000 00000000
[    7.069519] 5fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[    7.077709] 5fe0: 00000000 00000000 00000000 00000000 00000013 00000000
[    7.084335] Code: e5953004 e5854004 e5845000 e5843004 (e5834000)
[    7.090456] ---[ end trace 3cbdf5abbf86c3cd ]---
[    7.095086] Kernel panic - not syncing: Fatal exception
[    7.100325] CPU0: stopping
[    7.103038] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G      D W         5.10.64 #0
[    7.110450] Hardware name: BCM5301X
[    7.113951] [<c0108410>] (unwind_backtrace) from [<c0104bc4>] (show_stack+0x10/0x14)
[    7.121716] [<c0104bc4>] (show_stack) from [<c03dc6a8>] (dump_stack+0x94/0xa8)
[    7.128953] [<c03dc6a8>] (dump_stack) from [<c0106c80>] (do_handle_IPI+0xf8/0x12c)
[    7.136542] [<c0106c80>] (do_handle_IPI) from [<c0106ccc>] (ipi_handler+0x18/0x20)
[    7.144140] [<c0106ccc>] (ipi_handler) from [<c0162ae4>] (__handle_domain_irq+0x84/0xd8)
[    7.152256] [<c0162ae4>] (__handle_domain_irq) from [<c03f4fc8>] (gic_handle_irq+0x80/0x94)
[    7.160624] [<c03f4fc8>] (gic_handle_irq) from [<c0100aec>] (__irq_svc+0x6c/0x90)
[    7.168124] Exception stack(0xc0901f48 to 0xc0901f90)
[    7.173183] 1f40:                   00083bd6 00000000 00083bd8 c010e540 c0900000 00000000
[    7.181374] 1f60: c0904f14 c0904f54 c0831a34 413fc090 10c5387d 00000000 00000000 c0901f98
[    7.189572] 1f80: c0102644 c0102648 60000013 ffffffff
[    7.194631] [<c0100aec>] (__irq_svc) from [<c0102648>] (arch_cpu_idle+0x38/0x3c)
[    7.202058] [<c0102648>] (arch_cpu_idle) from [<c0143d54>] (do_idle+0xc0/0x138)
[    7.209385] [<c0143d54>] (do_idle) from [<c0144048>] (cpu_startup_entry+0x18/0x1c)
[    7.216976] [<c0144048>] (cpu_startup_entry) from [<c0800e74>] (start_kernel+0x4f8/0x50c)
[    7.225174] [<c0800e74>] (start_kernel) from [<00000000>] (0x0)
[    7.231111] Rebooting in 1 seconds..
