Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E45B25913E6
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 18:32:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239340AbiHLQcW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 12:32:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236015AbiHLQcV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 12:32:21 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D41614004;
        Fri, 12 Aug 2022 09:32:20 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id c20so1143959qtw.8;
        Fri, 12 Aug 2022 09:32:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=cNGrR3RyPsi1qg212lkUW9pPCHtk24ontw8JUS/4MTI=;
        b=bonu48aD/aC/n0nC9OTKaC1aGAdcvxtnzQs2y4FRiobC32MQAwO+TpcTkf4OKpii9c
         Sue+3UKkZ4pbWTgD/e69hTI3N+43ingZHxovFwr8hLfDBcgEBkJ9eSNL8ZBRo9cCAZ8F
         DewFTmAp/qbcGQU5xUSP/+BHetSFENIaTxcca4d4UbpaZql+gjCWpAgNumg7wActQvQb
         6u4fA6C3BNnT02WFTYErDV6gXzbJzU25I4zuPJEokCBdtZvq+t1qghCVv71Bpi4cXU2x
         DgVkyt97kd0iSmOTNbWu2faz9ke5cfVmsHiF6q8OBrJnY7Lu3MPRD98TiMXK8YAhtot+
         31dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=cNGrR3RyPsi1qg212lkUW9pPCHtk24ontw8JUS/4MTI=;
        b=0RyyUYnmfbLwwDD/wIeWDdJ5WPfkSXyL/nlPjIBo5HeHuZ393eBoPIeMTndRgbZu/I
         tzY9ws4wWf8a32dk4Hd9vUVBXBAMYEHFVFR/2u4thAHRAPFJT3KPY+3Q7XHGRQsj6+Bc
         nRTaHImvYQNKrRC29mQj/g8DUtVR17YmqCM2OHIAYqaJwCHBm6/2Adzo28tVhoABKTgc
         n9OPxxdtlDKVLmlyn5GDfnttq82W+SjMTaUq0MnTtzlYUH888a7/gnwL0PQAfaNgQeZY
         S3CQUJLvsOFVe05UhrAdLrNFSrfBaChzixNDiMbxWY77S74AR2Dz5fTEwvFxiGzM/sQB
         nFaQ==
X-Gm-Message-State: ACgBeo2yOGe0mn1Z0onGqBU5UYyBrskK+bBhTuPAAqt/JKgzCEqJBk1z
        tPcODEPVNbvXLYysqwl/3D5VBzn9Rrs=
X-Google-Smtp-Source: AA6agR6Z1ODU4ne5NnxfFxhYi/JwhieX8HzrzxvkFVFBYZcil2ZZ2spnUfSjTAHl2+yTUyQEnz0F3Q==
X-Received: by 2002:a05:622a:1b9e:b0:31f:2417:895d with SMTP id bp30-20020a05622a1b9e00b0031f2417895dmr4451109qtb.184.1660321939473;
        Fri, 12 Aug 2022 09:32:19 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id bq18-20020a05620a469200b006b59ddb4bc5sm2020023qkb.84.2022.08.12.09.32.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Aug 2022 09:32:18 -0700 (PDT)
Message-ID: <8c21e530-8e8f-ce2a-239e-9d3a354996cf@gmail.com>
Date:   Fri, 12 Aug 2022 09:32:15 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net] net: phy: Warn about incorrect mdio_bus_phy_resume()
 state
Content-Language: en-US
To:     Marek Szyprowski <m.szyprowski@samsung.com>,
        netdev@vger.kernel.org,
        Steve Glendinning <steve.glendinning@shawell.net>
Cc:     opendmb@gmail.com, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
References: <20220801233403.258871-1-f.fainelli@gmail.com>
 <CGME20220812111948eucas1p2bf97e7f4558eb024f419346367a87b45@eucas1p2.samsung.com>
 <27016cc0-f228-748b-ea03-800dda4e5f0c@samsung.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <27016cc0-f228-748b-ea03-800dda4e5f0c@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/12/22 04:19, Marek Szyprowski wrote:
> Hi All,
> 
> On 02.08.2022 01:34, Florian Fainelli wrote:
>> Calling mdio_bus_phy_resume() with neither the PHY state machine set to
>> PHY_HALTED nor phydev->mac_managed_pm set to true is a good indication
>> that we can produce a race condition looking like this:
>>
>> CPU0						CPU1
>> bcmgenet_resume
>>    -> phy_resume
>>      -> phy_init_hw
>>    -> phy_start
>>      -> phy_resume
>>                                                   phy_start_aneg()
>> mdio_bus_phy_resume
>>    -> phy_resume
>>       -> phy_write(..., BMCR_RESET)
>>        -> usleep()                                  -> phy_read()
>>
>> with the phy_resume() function triggering a PHY behavior that might have
>> to be worked around with (see bf8bfc4336f7 ("net: phy: broadcom: Fix
>> brcm_fet_config_init()") for instance) that ultimately leads to an error
>> reading from the PHY.
>>
>> Fixes: fba863b81604 ("net: phy: make PHY PM ops a no-op if MAC driver manages PHY PM")
>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> 
> This patch, as probably intended, triggers a warning during system
> suspend/resume cycle in the SMSC911x driver. I've observed it on ARM
> Juno R1 board on the kernel compiled from next-202208010:
> 
>    ------------[ cut here ]------------
>    WARNING: CPU: 1 PID: 398 at drivers/net/phy/phy_device.c:323
> mdio_bus_phy_resume+0x34/0xc8
>    Modules linked in: smsc911x cpufreq_powersave cpufreq_conservative
> crct10dif_ce ip_tables x_tables ipv6 [last unloaded: smsc911x]
>    CPU: 1 PID: 398 Comm: rtcwake Not tainted 5.19.0+ #940
>    Hardware name: ARM Juno development board (r1) (DT)
>    pstate: 80000005 (Nzcv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
>    pc : mdio_bus_phy_resume+0x34/0xc8
>    lr : dpm_run_callback+0x74/0x350
>    ...
>    Call trace:
>     mdio_bus_phy_resume+0x34/0xc8
>     dpm_run_callback+0x74/0x350
>     device_resume+0xb8/0x258
>     dpm_resume+0x120/0x4a8
>     dpm_resume_end+0x14/0x28
>     suspend_devices_and_enter+0x164/0xa60
>     pm_suspend+0x25c/0x3a8
>     state_store+0x84/0x108
>     kobj_attr_store+0x14/0x28
>     sysfs_kf_write+0x60/0x70
>     kernfs_fop_write_iter+0x124/0x1a8
>     new_sync_write+0xd0/0x190
>     vfs_write+0x208/0x478
>     ksys_write+0x64/0xf0
>     __arm64_sys_write+0x14/0x20
>     invoke_syscall+0x40/0xf8
>     el0_svc_common.constprop.3+0x8c/0x120
>     do_el0_svc+0x28/0xc8
>     el0_svc+0x48/0xd0
>     el0t_64_sync_handler+0x94/0xb8
>     el0t_64_sync+0x15c/0x160
>    irq event stamp: 24406
>    hardirqs last  enabled at (24405): [<ffff8000090c4734>]
> _raw_spin_unlock_irqrestore+0x8c/0x90
>    hardirqs last disabled at (24406): [<ffff8000090b3164>] el1_dbg+0x24/0x88
>    softirqs last  enabled at (24144): [<ffff800008010488>] _stext+0x488/0x5cc
>    softirqs last disabled at (24139): [<ffff80000809bf98>]
> irq_exit_rcu+0x168/0x1a8
>    ---[ end trace 0000000000000000 ]---
> 
> I hope the above information will help fixing the driver.

Yes this is catching an actual issue in the driver in that the PHY state 
machine is still running while the system is trying to suspend. We could 
go about fixing it in a different number of ways, though I believe this 
one is probably correct enough to work and fix the warning:

diff --git a/drivers/net/ethernet/smsc/smsc911x.c 
b/drivers/net/ethernet/smsc/smsc911x.c
index 3bf20211cceb..e9c0668a4dc0 100644
--- a/drivers/net/ethernet/smsc/smsc911x.c
+++ b/drivers/net/ethernet/smsc/smsc911x.c
@@ -1037,6 +1037,8 @@ static int smsc911x_mii_probe(struct net_device *dev)
                 return ret;
         }

+       /* Indicate that the MAC is responsible for managing PHY PM */
+       phydev->mac_managed_pm = true;
         phy_attached_info(phydev);

         phy_set_max_speed(phydev, SPEED_100);
@@ -2587,6 +2589,8 @@ static int smsc911x_suspend(struct device *dev)
         if (netif_running(ndev)) {
                 netif_stop_queue(ndev);
                 netif_device_detach(ndev);
+               if (!device_may_wakeup(dev))
+                       phy_suspend(dev->phydev);
         }

         /* enable wake on LAN, energy detection and the external PME
@@ -2628,6 +2632,8 @@ static int smsc911x_resume(struct device *dev)
         if (netif_running(ndev)) {
                 netif_device_attach(ndev);
                 netif_start_queue(ndev);
+               if (!device_may_wakeup(dev))
+                       phy_resume(dev->phydev);
         }

         return 0;

-- 
Florian
