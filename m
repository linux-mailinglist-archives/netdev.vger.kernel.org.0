Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CDD9334514
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 18:24:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232387AbhCJRYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 12:24:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230525AbhCJRX5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 12:23:57 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A982FC061760
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 09:23:57 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id s7so8809207plg.5
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 09:23:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uOn+Mb8ATpBhqi2VDNIVamAN3s3Druai5eAph0Sl2oE=;
        b=WUPXxFuGhgPSpnamRUwaWRtY3ffj2y0Ilb0ag9VDNEyJiMizvZ5wT+pJUX04+XQ10y
         yU377qMnPQmTlKuf0CoJSgY+cFwyGMdvdN5bX91Q/hUieg5DDYiFw++/2faZypLI/eKR
         mUx1VhLifZa/zVRhyUWbfsGZEf/J3gOTEZBRR+YA6vZpyhlVwzJd8bm8OD5XyIBKBL4Z
         2hnZ6+JKIyeae7amlrMedRSWX629DCqnZpAv9cONWOIKq0MOPNkeh9R8CgzftOysqQhz
         nUULrNH64d863j5grnnCbbUbFiosHZd8bOF/PdELRHjVA5j/G3tSbQbvQ4ZUNgApmZw+
         0hNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uOn+Mb8ATpBhqi2VDNIVamAN3s3Druai5eAph0Sl2oE=;
        b=uaNyEn0r38Qjzu7QTePjA9Ki+OX8MGGIrxSn9D4kGQ8D7MinEWtnvO4QnYBxQwktXL
         vFO6EJ9o6hL0CwoZchT4AFvzHrsriHn/A7Ju1XeCLR4HyzyqYlMM0yiGGkm88z/ZD+oP
         CoJv5Ht2JWASZxuN5TyxkrCZbIat1qv5J4nq7hWz6gGMUXoFq5bjXY+vO9wJiTxzcfG4
         PoKzunxUDOYDVy0AGSLNxoXMIPSn5+U1AfMhigCST5ghokNTRSpWK3pY1abQLjs4hCml
         pULuhBkFwhXh2Xpid+skL7+BDgmSohQmu/flU4s2hKsJk3SHUmDjrdmquwzNLR6KN0Zu
         8HKQ==
X-Gm-Message-State: AOAM531WC76qkw+9LqJapHg/N15p2N90NEgRaI/mlwryT1VQP4ctA3Vq
        p1d5B4qKPQhiXXY4uTkj6Wc=
X-Google-Smtp-Source: ABdhPJy2pReSr5bQCZ+wckjAq2CrsRbNpN2L0Gx7dkUt1Ymr9K9NkX7nezteovJQY9JcbpxWmOpImg==
X-Received: by 2002:a17:90a:9318:: with SMTP id p24mr4497241pjo.23.1615397036982;
        Wed, 10 Mar 2021 09:23:56 -0800 (PST)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id js16sm33981pjb.21.2021.03.10.09.23.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Mar 2021 09:23:56 -0800 (PST)
To:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
References: <20210310104019.24586-1-zajec5@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH] net: dsa: bcm_sf2: enable GPHY for switch probing
Message-ID: <28aed0bf-f0ea-2734-6c04-fd6f594a64a5@gmail.com>
Date:   Wed, 10 Mar 2021 09:23:54 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210310104019.24586-1-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/10/21 2:40 AM, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> GPHY needs to be enabled to successfully probe & setup switch port
> connected to it. Otherwise hardcoding PHY OUI would be required.
> 
> This prevents unimac_mdio_read() from getting MDIO_READ_FAIL.
> 
> Before:
> brcm-sf2 80080000.switch lan4 (uninitialized): PHY [800c05c0.mdio--1:08] driver [Generic PHY] (irq=POLL)
> brcm-sf2 80080000.switch lan3 (uninitialized): PHY [800c05c0.mdio--1:09] driver [Generic PHY] (irq=POLL)
> brcm-sf2 80080000.switch lan2 (uninitialized): PHY [800c05c0.mdio--1:0a] driver [Generic PHY] (irq=POLL)
> brcm-sf2 80080000.switch lan1 (uninitialized): PHY [800c05c0.mdio--1:0b] driver [Generic PHY] (irq=POLL)
> brcm-sf2 80080000.switch wan (uninitialized): error -5 setting up PHY for tree 0, switch 0, port 7
> 
> After:
> brcm-sf2 80080000.switch lan4 (uninitialized): PHY [800c05c0.mdio--1:08] driver [Generic PHY] (irq=POLL)
> brcm-sf2 80080000.switch lan3 (uninitialized): PHY [800c05c0.mdio--1:09] driver [Generic PHY] (irq=POLL)
> brcm-sf2 80080000.switch lan2 (uninitialized): PHY [800c05c0.mdio--1:0a] driver [Generic PHY] (irq=POLL)
> brcm-sf2 80080000.switch lan1 (uninitialized): PHY [800c05c0.mdio--1:0b] driver [Generic PHY] (irq=POLL)
> brcm-sf2 80080000.switch wan (uninitialized): PHY [800c05c0.mdio--1:0c] driver [Generic PHY] (irq=POLL)
> 
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> ---
> Below you can see backtrace after adding
> WARN(1, "MDIO_READ_FAIL\n");
> to the unimac_mdio_read() for the (cmd & MDIO_READ_FAIL) condition.
> 
> [    0.584058] brcm-sf2 80080000.switch: found switch: BCM4908, rev 0
> [    0.596214] brcm-sf2 80080000.switch lan4 (uninitialized): PHY [800c05c0.mdio--1:08] driver [Generic PHY]
> [    0.612212] brcm-sf2 80080000.switch lan3 (uninitialized): PHY [800c05c0.mdio--1:09] driver [Generic PHY]
> [    0.628216] brcm-sf2 80080000.switch lan2 (uninitialized): PHY [800c05c0.mdio--1:0a] driver [Generic PHY]
> [    0.644215] brcm-sf2 80080000.switch lan1 (uninitialized): PHY [800c05c0.mdio--1:0b] driver [Generic PHY]
> [    0.656212] ------------[ cut here ]------------
> [    0.660884] MDIO_READ_FAIL
> [    0.663685] WARNING: CPU: 0 PID: 128 at unimac_mdio_read+0x98/0xb8
> [    0.670016] Modules linked in:
> [    0.673156] CPU: 0 PID: 128 Comm: kworker/0:2 Not tainted 5.4.99 #0
> [    0.679603] Hardware name: Netgear R8000P (DT)
> [    0.684185] Workqueue: events deferred_probe_work_func
> [    0.689462] pstate: 60400005 (nZCv daif +PAN -UAO)
> [    0.694389] pc : unimac_mdio_read+0x98/0xb8
> [    0.698690] lr : unimac_mdio_read+0x98/0xb8
> [    0.702989] sp : ffffffc0108d3840
> [    0.706394] x29: ffffffc0108d3840 x28: 0000000000000000
> [    0.711860] x27: ffffff801e8a8850 x26: ffffff801e8a8840
> [    0.717325] x25: ffffff801f257000 x24: 0000000000000000
> [    0.722790] x23: 0000000000002001 x22: 0000000000000001
> [    0.728256] x21: ffffff801f257000 x20: 0000000000001000
> [    0.733723] x19: ffffff801f34a080 x18: 000000000000000e
> [    0.739188] x17: 0000000000000001 x16: 0000000000000019
> [    0.744653] x15: 0000000000000033 x14: ffffffc01079daa0
> [    0.750119] x13: 0000000000000000 x12: ffffffc01079d000
> [    0.755584] x11: ffffffc010767000 x10: 0000000000000010
> [    0.761049] x9 : 0000000000000000 x8 : 0000000000000000
> [    0.766516] x7 : 0000000000000007 x6 : 000000000000006e
> [    0.771981] x5 : 0000000000000006 x4 : 0000000000000000
> [    0.777446] x3 : 0000000000000000 x2 : 00000000ffffffff
> [    0.782912] x1 : ffffffc010767158 x0 : 000000000000000e
> [    0.788379] Call trace:
> [    0.790890]  unimac_mdio_read+0x98/0xb8
> [    0.794831]  __mdiobus_read+0x40/0x58
> [    0.798594]  mdiobus_read+0x48/0x70
> [    0.802177]  genphy_read_abilities+0x84/0x158
> [    0.806657]  phy_probe+0x160/0x1d8
> [    0.810153]  phy_attach_direct+0x210/0x2c0
> [    0.814368]  of_phy_attach+0x40/0x80
> [    0.818042]  phylink_of_phy_connect+0x6c/0x120
> [    0.822611]  dsa_slave_create+0x2b8/0x408
> [    0.826728]  dsa_register_switch+0x888/0xa60
> [    0.831120]  b53_switch_register+0x1c4/0x300
> [    0.835510]  bcm_sf2_sw_probe+0x50c/0x640
> [    0.839631]  platform_drv_probe+0x50/0xa0
> [    0.843752]  really_probe+0xcc/0x2e0
> [    0.847425]  driver_probe_device+0x54/0xe8
> [    0.851637]  __device_attach_driver+0x80/0xb8
> [    0.856118]  bus_for_each_drv+0x68/0xa8
> [    0.860059]  __device_attach+0xcc/0x140
> [    0.864001]  device_initial_probe+0x10/0x18
> [    0.868303]  bus_probe_device+0x90/0x98
> [    0.872245]  deferred_probe_work_func+0x6c/0xa0
> [    0.876907]  process_one_work+0x1fc/0x390
> [    0.881026]  worker_thread+0x278/0x4d0
> [    0.884882]  kthread+0x120/0x128
> [    0.888195]  ret_from_fork+0x10/0x1c
> [    0.891868] ---[ end trace 918e8c44c53d6f7b ]---
> ---
>  drivers/net/dsa/bcm_sf2.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
> index 70626547ffb3..6159d0a69870 100644
> --- a/drivers/net/dsa/bcm_sf2.c
> +++ b/drivers/net/dsa/bcm_sf2.c
> @@ -1432,10 +1432,14 @@ static int bcm_sf2_sw_probe(struct platform_device *pdev)
>  	rev = reg_readl(priv, REG_PHY_REVISION);
>  	priv->hw_params.gphy_rev = rev & PHY_REVISION_MASK;
>  
> +	bcm_sf2_gphy_enable_set(priv->dev->ds, true);
> +
>  	ret = b53_switch_register(dev);
>  	if (ret)
>  		goto out_mdio;
>  
> +	bcm_sf2_gphy_enable_set(priv->dev->ds, false);

This change got me thinking some more about how to deal with that, and I
believe that we do have a possible problem with your change. Past
b53_switch_register() we will call dsa_register_switch() which will be
publishing the network devices which makes them immediately visible to
notifiers and user-space for use. This means that we could be racing
with a process opening the port, and the bcm_sf2_gphy_enable_set() call
and have a port with the PHY disabled with no idea why.

The ideal way to solve this would be to have a hook before we call
dsa_slave_create() and one after such that we could turn on the internal
PHY just for probing, and then disable it immediately after in case the
network port was never used so we could continue to save power.

There is the dsa_switch_ops::get_phy_flags() that we could use for that
purpose, but we have no way to balance it.

I have been down the road of trying to solve these chicken and egg
problems with integrated PHYs that need clocks/power to be turned on and
really the best and easiest way was just to do what you have mentioned
which is to use a compatible string with the full OUI included within.
This solves a whole lot of problems for free. Given that you control how
the Device Trees are generated and loaded with the kernel is there a
strong reason not to do that?
-- 
-- 
Florian
