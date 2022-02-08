Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 017FA4ACF1B
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 03:46:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345703AbiBHCp7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 21:45:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345508AbiBHCp6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 21:45:58 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28916C061355
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 18:45:58 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id d9-20020a17090a498900b001b8bb1d00e7so1227580pjh.3
        for <netdev@vger.kernel.org>; Mon, 07 Feb 2022 18:45:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=twiV/EQ8g+xiOBVGoUCBDJc1MfUBbNr5d6aQ+w8tQD4=;
        b=Bou1t73WV0QyVn0uQd1mVhnP1fvvsH0V9cuLEYpjaJt4LsKIb7YSbtoDTRVayCpJ82
         +UvtBuYZhAStzbYE4Gn6+v31KlyPOSx+y9YdMv+ubCFp8CDm6x+yAdrJ79Feta32SFBS
         EG3Z7HalY+gdaSML/aNMo2GcusBLHnSMU6Izva4h7Wn+N50nkTAnU6NtGAiWhBwcaIF9
         DsnQYWs/jvvSDcBKDoVs0UOohAK0f56/Rmlxd3xmwxPJq9ak2x2P5zpQGVkibuwz6uoH
         Sk+BPkxJ0BR8cMhMg8vvx3p3tGt72+E8DYOIgnvHZpdzgCeACKq2pQgM+puNzyf5lTuS
         UKMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=twiV/EQ8g+xiOBVGoUCBDJc1MfUBbNr5d6aQ+w8tQD4=;
        b=xW814RAc+z3aULmBziRceeGuZ8WWMvRX+lGhh/JWPitrmce4/DFnCZe82lQmBsX6bF
         2w7mxPoF1UZXUv0nEv6Aa52c681RbnfhfM9QU46ROLrw5EWfRTCLDXvQwBbB516SDr1V
         WqPguNmUiZv2evFmAEhmRhsG5zRL3oWzX6Y1D8lEVR4hTNN5wxNpLAJbnOB4ilfy54Tr
         SC8s6A53MrWrGvPqI070G0KQomZQyiEl9JqQdm1YhNmRcrLAvY3bHzDvR5a8GiGpTwzH
         eXVmCpigFGcsa/lyluI8b/sLxKGSFg3doyvT+aIFgvl/QSDAxbkXKQ+9gAxTxtdV1BxG
         +6Og==
X-Gm-Message-State: AOAM533o0NMtM7ZXtr/Sh142imAm2zOU0LYSEYvOpB3jSHITmAv0OOfm
        T6Pvqqj9SEM8k0COVO5WhH8=
X-Google-Smtp-Source: ABdhPJzu+xuoX4RGzFi8SccKb0RBXjw3jW8ySVxek6rNdZYGicKYwt4rMr+u7WjRiUQScmZe206pFw==
X-Received: by 2002:a17:902:d4cd:: with SMTP id o13mr2486609plg.170.1644288357568;
        Mon, 07 Feb 2022 18:45:57 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id lj14sm675322pjb.48.2022.02.07.18.45.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Feb 2022 18:45:56 -0800 (PST)
Message-ID: <4e01c056-0cc5-837d-c8c9-18bcdbc513e1@gmail.com>
Date:   Mon, 7 Feb 2022 18:45:54 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH net 1/7] net: dsa: mv88e6xxx: don't use devres for mdiobus
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Oleksij Rempel <linux@rempel-privat.de>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Rafael Richter <rafael.richter@gin.de>,
        Daniel Klauer <daniel.klauer@gin.de>
References: <20220207161553.579933-1-vladimir.oltean@nxp.com>
 <20220207161553.579933-2-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220207161553.579933-2-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/7/2022 8:15 AM, Vladimir Oltean wrote:
> As explained in commits:
> 74b6d7d13307 ("net: dsa: realtek: register the MDIO bus under devres")
> 5135e96a3dd2 ("net: dsa: don't allocate the slave_mii_bus using devres")
> 
> mdiobus_free() will panic when called from devm_mdiobus_free() <-
> devres_release_all() <- __device_release_driver(), and that mdiobus was
> not previously unregistered.
> 
> The mv88e6xxx is an MDIO device, so the initial set of constraints that
> I thought would cause this (I2C or SPI buses which call ->remove on
> ->shutdown) do not apply. But there is one more which applies here.
> 
> If the DSA master itself is on a bus that calls ->remove from ->shutdown
> (like dpaa2-eth, which is on the fsl-mc bus), there is a device link
> between the switch and the DSA master, and device_links_unbind_consumers()
> will unbind the Marvell switch driver on shutdown.
> 
> systemd-shutdown[1]: Powering off.
> mv88e6085 0x0000000008b96000:00 sw_gl0: Link is Down
> fsl-mc dpbp.9: Removing from iommu group 7
> fsl-mc dpbp.8: Removing from iommu group 7
> ------------[ cut here ]------------
> kernel BUG at drivers/net/phy/mdio_bus.c:677!
> Internal error: Oops - BUG: 0 [#1] PREEMPT SMP
> Modules linked in:
> CPU: 0 PID: 1 Comm: systemd-shutdow Not tainted 5.16.5-00040-gdc05f73788e5 #15
> pc : mdiobus_free+0x44/0x50
> lr : devm_mdiobus_free+0x10/0x20
> Call trace:
>   mdiobus_free+0x44/0x50
>   devm_mdiobus_free+0x10/0x20
>   devres_release_all+0xa0/0x100
>   __device_release_driver+0x190/0x220
>   device_release_driver_internal+0xac/0xb0
>   device_links_unbind_consumers+0xd4/0x100
>   __device_release_driver+0x4c/0x220
>   device_release_driver_internal+0xac/0xb0
>   device_links_unbind_consumers+0xd4/0x100
>   __device_release_driver+0x94/0x220
>   device_release_driver+0x28/0x40
>   bus_remove_device+0x118/0x124
>   device_del+0x174/0x420
>   fsl_mc_device_remove+0x24/0x40
>   __fsl_mc_device_remove+0xc/0x20
>   device_for_each_child+0x58/0xa0
>   dprc_remove+0x90/0xb0
>   fsl_mc_driver_remove+0x20/0x5c
>   __device_release_driver+0x21c/0x220
>   device_release_driver+0x28/0x40
>   bus_remove_device+0x118/0x124
>   device_del+0x174/0x420
>   fsl_mc_bus_remove+0x80/0x100
>   fsl_mc_bus_shutdown+0xc/0x1c
>   platform_shutdown+0x20/0x30
>   device_shutdown+0x154/0x330
>   kernel_power_off+0x34/0x6c
>   __do_sys_reboot+0x15c/0x250
>   __arm64_sys_reboot+0x20/0x30
>   invoke_syscall.constprop.0+0x4c/0xe0
>   do_el0_svc+0x4c/0x150
>   el0_svc+0x24/0xb0
>   el0t_64_sync_handler+0xa8/0xb0
>   el0t_64_sync+0x178/0x17c
> 
> So the same treatment must be applied to all DSA switch drivers, which
> is: either use devres for both the mdiobus allocation and registration,
> or don't use devres at all.
> 
> The Marvell driver already has a good structure for mdiobus removal, so
> just plug in mdiobus_free and get rid of devres.
> 
> Fixes: ac3a68d56651 ("net: phy: don't abuse devres in devm_mdiobus_register()")
> Reported-by: Rafael Richter <Rafael.Richter@gin.de>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
