Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E796F333A3D
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 11:41:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232456AbhCJKlT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 05:41:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbhCJKks (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 05:40:48 -0500
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02FA6C06174A
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 02:40:48 -0800 (PST)
Received: by mail-lj1-x22a.google.com with SMTP id t9so24929082ljt.8
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 02:40:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=w9hm4pHE4UP4xKp1GqpHNQHSeNm2vomB46i/MTGuUK0=;
        b=WHW6WAZ8wUn0z1ZUdVU4GgnJCG4Vw+eGIt3oNGUVteKcXvgTichojYoUDAzeQZua7o
         XZt2flSit0zVuq28eQtZQHiDLIvcXldvvMmikXiyOYDgGwxLK3gfZqKhbsweWxt8TLhQ
         Ykr0dg1wMl+XUl/yAFTRQ7zRMbHLCqon8WnWgq1NZBxwOk5uwuVSsXJA3+kw/+HZ53iq
         It8Cpvp43IO0iLuxWCHYiqKq3St885W1UyWVi7VuDH0W7PrgqggPyPQ1PqQ4n8PF3iHl
         ZZ0+b/B9NFVWq3dCQBDpMJC04YZRbGVxXloE/ARVaam4GdGTNpzLJZopKOgaRbbbST/U
         GCJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=w9hm4pHE4UP4xKp1GqpHNQHSeNm2vomB46i/MTGuUK0=;
        b=UVMjxovXTXVsGTP58kxbFR/MQjRG7ef1bb+SDFzBNlD+euGZFh8+yILnUl0DkrgPi2
         OQqNhqC6tUybVa/78aZEpFCJeoQCYbL2jmWrw9CvNyfvi8/tuAIZTq/Go1QQDjIwnYc/
         DyZc/e+oJD3nws6BO2z9xywX++KGfpkn5VSMVXV7R4/hekziL7Kj7uYyx5+OAoO6pFlD
         hTeTcQGSyvRM7QSdYv6IlhfSwTt7GCYivnVdTXB29+Vuk1F3zsd1QC6kEHQpWB8vpYCe
         Ares4vAR1N7x8dhaX8Cpmv0v6Hm12rPI9IMmc+0c5utcdS7GoS0enA84JKX7/x8OCL8L
         V1Fg==
X-Gm-Message-State: AOAM530vbPYMEjXBf7twK54v+l5j9OdjcbemeLFLuFZCgKQbV31Qwi6g
        4pZAjFsZD+IdT6MJU6zyTf8=
X-Google-Smtp-Source: ABdhPJzzFdYai3cub0p74eZh1vvGWuqohVr2CC5bWtvd8Un/vh3hCRrBqACybazyemNo/E06GL2xbA==
X-Received: by 2002:a2e:5747:: with SMTP id r7mr1431655ljd.227.1615372846529;
        Wed, 10 Mar 2021 02:40:46 -0800 (PST)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id o20sm2757212lfu.286.2021.03.10.02.40.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 02:40:46 -0800 (PST)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH] net: dsa: bcm_sf2: enable GPHY for switch probing
Date:   Wed, 10 Mar 2021 11:40:19 +0100
Message-Id: <20210310104019.24586-1-zajec5@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

GPHY needs to be enabled to successfully probe & setup switch port
connected to it. Otherwise hardcoding PHY OUI would be required.

This prevents unimac_mdio_read() from getting MDIO_READ_FAIL.

Before:
brcm-sf2 80080000.switch lan4 (uninitialized): PHY [800c05c0.mdio--1:08] driver [Generic PHY] (irq=POLL)
brcm-sf2 80080000.switch lan3 (uninitialized): PHY [800c05c0.mdio--1:09] driver [Generic PHY] (irq=POLL)
brcm-sf2 80080000.switch lan2 (uninitialized): PHY [800c05c0.mdio--1:0a] driver [Generic PHY] (irq=POLL)
brcm-sf2 80080000.switch lan1 (uninitialized): PHY [800c05c0.mdio--1:0b] driver [Generic PHY] (irq=POLL)
brcm-sf2 80080000.switch wan (uninitialized): error -5 setting up PHY for tree 0, switch 0, port 7

After:
brcm-sf2 80080000.switch lan4 (uninitialized): PHY [800c05c0.mdio--1:08] driver [Generic PHY] (irq=POLL)
brcm-sf2 80080000.switch lan3 (uninitialized): PHY [800c05c0.mdio--1:09] driver [Generic PHY] (irq=POLL)
brcm-sf2 80080000.switch lan2 (uninitialized): PHY [800c05c0.mdio--1:0a] driver [Generic PHY] (irq=POLL)
brcm-sf2 80080000.switch lan1 (uninitialized): PHY [800c05c0.mdio--1:0b] driver [Generic PHY] (irq=POLL)
brcm-sf2 80080000.switch wan (uninitialized): PHY [800c05c0.mdio--1:0c] driver [Generic PHY] (irq=POLL)

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
Below you can see backtrace after adding
WARN(1, "MDIO_READ_FAIL\n");
to the unimac_mdio_read() for the (cmd & MDIO_READ_FAIL) condition.

[    0.584058] brcm-sf2 80080000.switch: found switch: BCM4908, rev 0
[    0.596214] brcm-sf2 80080000.switch lan4 (uninitialized): PHY [800c05c0.mdio--1:08] driver [Generic PHY]
[    0.612212] brcm-sf2 80080000.switch lan3 (uninitialized): PHY [800c05c0.mdio--1:09] driver [Generic PHY]
[    0.628216] brcm-sf2 80080000.switch lan2 (uninitialized): PHY [800c05c0.mdio--1:0a] driver [Generic PHY]
[    0.644215] brcm-sf2 80080000.switch lan1 (uninitialized): PHY [800c05c0.mdio--1:0b] driver [Generic PHY]
[    0.656212] ------------[ cut here ]------------
[    0.660884] MDIO_READ_FAIL
[    0.663685] WARNING: CPU: 0 PID: 128 at unimac_mdio_read+0x98/0xb8
[    0.670016] Modules linked in:
[    0.673156] CPU: 0 PID: 128 Comm: kworker/0:2 Not tainted 5.4.99 #0
[    0.679603] Hardware name: Netgear R8000P (DT)
[    0.684185] Workqueue: events deferred_probe_work_func
[    0.689462] pstate: 60400005 (nZCv daif +PAN -UAO)
[    0.694389] pc : unimac_mdio_read+0x98/0xb8
[    0.698690] lr : unimac_mdio_read+0x98/0xb8
[    0.702989] sp : ffffffc0108d3840
[    0.706394] x29: ffffffc0108d3840 x28: 0000000000000000
[    0.711860] x27: ffffff801e8a8850 x26: ffffff801e8a8840
[    0.717325] x25: ffffff801f257000 x24: 0000000000000000
[    0.722790] x23: 0000000000002001 x22: 0000000000000001
[    0.728256] x21: ffffff801f257000 x20: 0000000000001000
[    0.733723] x19: ffffff801f34a080 x18: 000000000000000e
[    0.739188] x17: 0000000000000001 x16: 0000000000000019
[    0.744653] x15: 0000000000000033 x14: ffffffc01079daa0
[    0.750119] x13: 0000000000000000 x12: ffffffc01079d000
[    0.755584] x11: ffffffc010767000 x10: 0000000000000010
[    0.761049] x9 : 0000000000000000 x8 : 0000000000000000
[    0.766516] x7 : 0000000000000007 x6 : 000000000000006e
[    0.771981] x5 : 0000000000000006 x4 : 0000000000000000
[    0.777446] x3 : 0000000000000000 x2 : 00000000ffffffff
[    0.782912] x1 : ffffffc010767158 x0 : 000000000000000e
[    0.788379] Call trace:
[    0.790890]  unimac_mdio_read+0x98/0xb8
[    0.794831]  __mdiobus_read+0x40/0x58
[    0.798594]  mdiobus_read+0x48/0x70
[    0.802177]  genphy_read_abilities+0x84/0x158
[    0.806657]  phy_probe+0x160/0x1d8
[    0.810153]  phy_attach_direct+0x210/0x2c0
[    0.814368]  of_phy_attach+0x40/0x80
[    0.818042]  phylink_of_phy_connect+0x6c/0x120
[    0.822611]  dsa_slave_create+0x2b8/0x408
[    0.826728]  dsa_register_switch+0x888/0xa60
[    0.831120]  b53_switch_register+0x1c4/0x300
[    0.835510]  bcm_sf2_sw_probe+0x50c/0x640
[    0.839631]  platform_drv_probe+0x50/0xa0
[    0.843752]  really_probe+0xcc/0x2e0
[    0.847425]  driver_probe_device+0x54/0xe8
[    0.851637]  __device_attach_driver+0x80/0xb8
[    0.856118]  bus_for_each_drv+0x68/0xa8
[    0.860059]  __device_attach+0xcc/0x140
[    0.864001]  device_initial_probe+0x10/0x18
[    0.868303]  bus_probe_device+0x90/0x98
[    0.872245]  deferred_probe_work_func+0x6c/0xa0
[    0.876907]  process_one_work+0x1fc/0x390
[    0.881026]  worker_thread+0x278/0x4d0
[    0.884882]  kthread+0x120/0x128
[    0.888195]  ret_from_fork+0x10/0x1c
[    0.891868] ---[ end trace 918e8c44c53d6f7b ]---
---
 drivers/net/dsa/bcm_sf2.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index 70626547ffb3..6159d0a69870 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -1432,10 +1432,14 @@ static int bcm_sf2_sw_probe(struct platform_device *pdev)
 	rev = reg_readl(priv, REG_PHY_REVISION);
 	priv->hw_params.gphy_rev = rev & PHY_REVISION_MASK;
 
+	bcm_sf2_gphy_enable_set(priv->dev->ds, true);
+
 	ret = b53_switch_register(dev);
 	if (ret)
 		goto out_mdio;
 
+	bcm_sf2_gphy_enable_set(priv->dev->ds, false);
+
 	dev_info(&pdev->dev,
 		 "Starfighter 2 top: %x.%02x, core: %x.%02x, IRQs: %d, %d\n",
 		 priv->hw_params.top_rev >> 8, priv->hw_params.top_rev & 0xff,
-- 
2.26.2

