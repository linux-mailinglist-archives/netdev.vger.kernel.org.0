Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C15EB30DF60
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 17:13:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234619AbhBCQNR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 11:13:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234867AbhBCQJ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 11:09:27 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1BA0C061788
        for <netdev@vger.kernel.org>; Wed,  3 Feb 2021 08:08:46 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id s3so181966edi.7
        for <netdev@vger.kernel.org>; Wed, 03 Feb 2021 08:08:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yVEV5yA64KZmsVdfewbWP3ONZJXynUGtQcE4N5nGklE=;
        b=uy0FIy33iXo8HyTsOf9ptA+t/vYKFPGYTIvhzfMfBSc6pHSkNKbZBS3JawPLXBSteq
         c0gmh8+A97f0SWGe4ZSFbTpFolR7wMnUlZGHp+/xDkLoLwDxjmdk0pnjYc6g4QeIxlE9
         JPJTruE4bqKks70dz/bia0Uy5s2zrb/OHEhwtVaM1Y6ulH8C/fi0/u11H5Y8vwTPFYCh
         JdnA17CdNwO59MOCuNLMVAX2dEY0/ixglIwmwXh4lAt+bvgesG6PZmbqziJdbFRt98ZA
         VcFX/DXk2Lm7Zv+Rf3pnypTDtzVBxy/0eAgqu+f2W1UsjYLjIsaKDfGgBVUvQX505fIm
         9QRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yVEV5yA64KZmsVdfewbWP3ONZJXynUGtQcE4N5nGklE=;
        b=pBsk8soFiWMBIsJs9s9mtI12MroSxZ6H78A8ohx1C2INCftWWnqLnlAHJhEak6B0l+
         bUfMEPJMoksMPGoHs9KFGAlMT087F73NhFLNbH6fhKW2gVc/eIyd5+zZOXa29x/z0YNw
         q+GpTNIrpJnlS9yocKocZyskZ8TfTTflDgF+IiGVW7hLkUv+DAcEfXTYSPTUOg6h5zvm
         wr8BfPkkzgTrdqEWDdcxG37lUAr8MyBVWCt5nrWuHjqKL+W2UksIoz+QJrvZLos4ThL0
         vAJ8bNB7xUJZMinocxBQ8xLJe/9GG00TwLs3mcx5Nv9+FHcD7tKVpsoQCEo7ptNafaf1
         5LAA==
X-Gm-Message-State: AOAM532HuPR44dmcc92HUsBUuv1Rv5l1ep14a1Tp5iW7lcb1yueoRpvF
        D6FyVdBbuwX/RII5xgQnNbQ=
X-Google-Smtp-Source: ABdhPJyUBikQdgsBW4Zs2HJeKtSGpN/BNNhSuCzrHeCmMQUeX2SAEMqTqVHFEZq/opl3Kg6eAyTeZA==
X-Received: by 2002:aa7:c7d8:: with SMTP id o24mr3730822eds.121.1612368525495;
        Wed, 03 Feb 2021 08:08:45 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id u16sm1085589eds.71.2021.02.03.08.08.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 08:08:44 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Subject: [PATCH v2 net-next 4/4] Revert "net: ipv4: handle DSA enabled master network devices"
Date:   Wed,  3 Feb 2021 18:08:23 +0200
Message-Id: <20210203160823.2163194-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210203160823.2163194-1-olteanv@gmail.com>
References: <20210203160823.2163194-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This reverts commit 728c02089a0e3eefb02e9927bfae50490f40e72e.

Since 2015 DSA has gained more integration with the network stack, we
can now have the same functionality without explicitly open-coding for
it:
- It now opens the DSA master netdevice automatically whenever a user
  netdevice is opened.
- The master and switch interfaces are coupled in an upper/lower
  hierarchy using the netdev adjacency lists.

In the nfsroot example below, the interface chosen by autoconfig was
swp3, and every interface except that and the DSA master, eth1, was
brought down afterwards:

[    8.714215] mscc_felix 0000:00:00.5 swp0 (uninitialized): PHY [0000:00:00.3:10] driver [Microsemi GE VSC8514 SyncE] (irq=POLL)
[    8.978041] mscc_felix 0000:00:00.5 swp1 (uninitialized): PHY [0000:00:00.3:11] driver [Microsemi GE VSC8514 SyncE] (irq=POLL)
[    9.246134] mscc_felix 0000:00:00.5 swp2 (uninitialized): PHY [0000:00:00.3:12] driver [Microsemi GE VSC8514 SyncE] (irq=POLL)
[    9.486203] mscc_felix 0000:00:00.5 swp3 (uninitialized): PHY [0000:00:00.3:13] driver [Microsemi GE VSC8514 SyncE] (irq=POLL)
[    9.512827] mscc_felix 0000:00:00.5: configuring for fixed/internal link mode
[    9.521047] mscc_felix 0000:00:00.5: Link is Up - 2.5Gbps/Full - flow control off
[    9.530382] device eth1 entered promiscuous mode
[    9.535452] DSA: tree 0 setup
[    9.539777] printk: console [netcon0] enabled
[    9.544504] netconsole: network logging started
[    9.555047] fsl_enetc 0000:00:00.2 eth1: configuring for fixed/internal link mode
[    9.562790] fsl_enetc 0000:00:00.2 eth1: Link is Up - 1Gbps/Full - flow control off
[    9.564661] 8021q: adding VLAN 0 to HW filter on device bond0
[    9.637681] fsl_enetc 0000:00:00.0 eth0: PHY [0000:00:00.0:02] driver [Qualcomm Atheros AR8031/AR8033] (irq=POLL)
[    9.655679] fsl_enetc 0000:00:00.0 eth0: configuring for inband/sgmii link mode
[    9.666611] mscc_felix 0000:00:00.5 swp0: configuring for inband/qsgmii link mode
[    9.676216] 8021q: adding VLAN 0 to HW filter on device swp0
[    9.682086] mscc_felix 0000:00:00.5 swp1: configuring for inband/qsgmii link mode
[    9.690700] 8021q: adding VLAN 0 to HW filter on device swp1
[    9.696538] mscc_felix 0000:00:00.5 swp2: configuring for inband/qsgmii link mode
[    9.705131] 8021q: adding VLAN 0 to HW filter on device swp2
[    9.710964] mscc_felix 0000:00:00.5 swp3: configuring for inband/qsgmii link mode
[    9.719548] 8021q: adding VLAN 0 to HW filter on device swp3
[    9.747811] Sending DHCP requests ..
[   12.742899] mscc_felix 0000:00:00.5 swp1: Link is Up - 1Gbps/Full - flow control rx/tx
[   12.743828] mscc_felix 0000:00:00.5 swp0: Link is Up - 1Gbps/Full - flow control off
[   12.747062] IPv6: ADDRCONF(NETDEV_CHANGE): swp1: link becomes ready
[   12.755216] fsl_enetc 0000:00:00.0 eth0: Link is Up - 1Gbps/Full - flow control rx/tx
[   12.766603] IPv6: ADDRCONF(NETDEV_CHANGE): swp0: link becomes ready
[   12.783188] mscc_felix 0000:00:00.5 swp2: Link is Up - 1Gbps/Full - flow control rx/tx
[   12.785354] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   12.799535] IPv6: ADDRCONF(NETDEV_CHANGE): swp2: link becomes ready
[   13.803141] mscc_felix 0000:00:00.5 swp3: Link is Up - 1Gbps/Full - flow control rx/tx
[   13.811646] IPv6: ADDRCONF(NETDEV_CHANGE): swp3: link becomes ready
[   15.452018] ., OK
[   15.470336] IP-Config: Got DHCP answer from 10.0.0.1, my address is 10.0.0.39
[   15.477887] IP-Config: Complete:
[   15.481330]      device=swp3, hwaddr=00:04:9f:05:de:0a, ipaddr=10.0.0.39, mask=255.255.255.0, gw=10.0.0.1
[   15.491846]      host=10.0.0.39, domain=(none), nis-domain=(none)
[   15.498429]      bootserver=10.0.0.1, rootserver=10.0.0.1, rootpath=
[   15.498481]      nameserver0=8.8.8.8
[   15.627542] fsl_enetc 0000:00:00.0 eth0: Link is Down
[   15.690903] mscc_felix 0000:00:00.5 swp0: Link is Down
[   15.745216] mscc_felix 0000:00:00.5 swp1: Link is Down
[   15.800498] mscc_felix 0000:00:00.5 swp2: Link is Down

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v2:
None.

 net/ipv4/ipconfig.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/ipconfig.c b/net/ipv4/ipconfig.c
index 3cd13e1bc6a7..f9ab1fb219ec 100644
--- a/net/ipv4/ipconfig.c
+++ b/net/ipv4/ipconfig.c
@@ -61,7 +61,6 @@
 #include <linux/export.h>
 #include <net/net_namespace.h>
 #include <net/arp.h>
-#include <net/dsa.h>
 #include <net/ip.h>
 #include <net/ipconfig.h>
 #include <net/route.h>
@@ -218,9 +217,9 @@ static int __init ic_open_devs(void)
 	last = &ic_first_dev;
 	rtnl_lock();
 
-	/* bring loopback and DSA master network devices up first */
+	/* bring loopback device up first */
 	for_each_netdev(&init_net, dev) {
-		if (!(dev->flags & IFF_LOOPBACK) && !netdev_uses_dsa(dev))
+		if (!(dev->flags & IFF_LOOPBACK))
 			continue;
 		if (dev_change_flags(dev, dev->flags | IFF_UP, NULL) < 0)
 			pr_err("IP-Config: Failed to open %s\n", dev->name);
@@ -305,6 +304,9 @@ static int __init ic_open_devs(void)
 	return 0;
 }
 
+/* Close all network interfaces except the one we've autoconfigured, and its
+ * lowers, in case it's a stacked virtual interface.
+ */
 static void __init ic_close_devs(void)
 {
 	struct ic_device *d, *next;
@@ -313,9 +315,20 @@ static void __init ic_close_devs(void)
 	rtnl_lock();
 	next = ic_first_dev;
 	while ((d = next)) {
+		bool bring_down = (d != ic_dev);
+		struct net_device *lower_dev;
+		struct list_head *iter;
+
 		next = d->next;
 		dev = d->dev;
-		if (d != ic_dev && !netdev_uses_dsa(dev)) {
+
+		netdev_for_each_lower_dev(ic_dev->dev, lower_dev, iter) {
+			if (dev == lower_dev) {
+				bring_down = false;
+				break;
+			}
+		}
+		if (bring_down) {
 			pr_debug("IP-Config: Downing %s\n", dev->name);
 			dev_change_flags(dev, d->flags, NULL);
 		}
-- 
2.25.1

