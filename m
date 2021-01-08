Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0F042EEA50
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 01:22:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729614AbhAHAVw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 19:21:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729606AbhAHAVv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 19:21:51 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BB79C061290
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 16:20:42 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id x16so12195389ejj.7
        for <netdev@vger.kernel.org>; Thu, 07 Jan 2021 16:20:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=meTylZFARcPbxEW3GSHXjGIBqIRE9e2IDdJ7zvdKW/4=;
        b=GJLPsHUifWEt3LdEAcOgtDD5OrlFR6/LGdFh2XTlDrFReUW+TRfMaXuQICmeyldk6i
         vVLdDr7guP8V/hr79lSm04cGgGoJgH9tkGmRfiobCy9hEto3qDUE53DZp5ZFaDD6GDvq
         pMefxn2v0hkgqdW+uMuWdNsPBxo8J9DTUQGvx+UscBw3e1x46GDtnnDeaC7gcg6hChXH
         OprhwAxk34gMTDdwND8iw6hEc8CgoY5PMkyUlV4rr6RiwVHf0vdycnY2yQez1QK5QOue
         PYkLoHLNI6hNTpoTMBeXUj613gWr/85rZ0j5I/A/dBinqEFjfWoNsVEt+misq87KYZW7
         5gKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=meTylZFARcPbxEW3GSHXjGIBqIRE9e2IDdJ7zvdKW/4=;
        b=d1DKBof9RKW8bpS38OUBqSOe3/WDMMT6vWiSpz2p1w7Sw70+DvmTLSSOj2I1jhXqiO
         gR82ARdBk748UN5P7l0iDVLkD+o1Ya6yMv0VtSeBC9biaqo5YvW4vo5e3wXXHciiMoSm
         1r6PebXc0ocGeY3kPoqKsrDVE797YOHUA4lXhpH7KLms6zpQDq85lzx1pQuDL2pp3H53
         7QgAHVf33lFKAFICDeNwKIrjvvaCes7wJTeg2+0VsXrmlTwvcDuqCFRyq7VIf9Ml9/6m
         FYhmURIXE9XASQpl9W42itPyTqhmYrGQpIXCK1DK9NPyEAH3D0RHYjs+bMGBiBJFtAB6
         d32w==
X-Gm-Message-State: AOAM531lrvEDyzeEKmj5sO64uM7FjNgryBDgddF1+Yjgo9DEQ/O4tPMV
        qXkNYfAHta9gD17PvXCHWXoIc/Epue0=
X-Google-Smtp-Source: ABdhPJziguR3hAf+ZY1qgU5KD5hYYNAQytbCmA3GkDaE0eyESfflxMN74txgZs5CK7KdB83x2YPVAQ==
X-Received: by 2002:a17:906:39d5:: with SMTP id i21mr876709eje.339.1610065240884;
        Thu, 07 Jan 2021 16:20:40 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id rk12sm2981691ejb.75.2021.01.07.16.20.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 16:20:40 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Eric Dumazet <edumazet@google.com>,
        George McCollister <george.mccollister@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Arnd Bergmann <arnd@arndb.de>, Taehee Yoo <ap420073@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>, Florian Westphal <fw@strlen.de>
Subject: [PATCH v4 net-next 12/18] net: propagate errors from dev_get_stats
Date:   Fri,  8 Jan 2021 02:19:59 +0200
Message-Id: <20210108002005.3429956-13-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210108002005.3429956-1-olteanv@gmail.com>
References: <20210108002005.3429956-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

dev_get_stats can now return error codes. Take the remaining call sites
where those errors can be propagated, which are all trivial, and convert
them to look at that error code and stop processing.

The effects of simulating a kernel error (returning -EOPNOTSUPP) upon
existing programs or kernel interfaces:

- cat /proc/net/dev prints up until the interface that failed, and there
  it returns:
cat: read error: Operation not supported

- ifstat simply returns this and prints nothing:
Error: Buffer too small for object.
Dump terminated

- ip -s -s link show behaves the same as ifstat.

- ifconfig prints only the info for the interfaces whose statistics did
  not fail.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v4:
Patch is new (Eric's suggestion).

 drivers/net/bonding/bond_main.c     | 15 +++++++++++++--
 drivers/parisc/led.c                |  7 ++++++-
 drivers/usb/gadget/function/rndis.c |  4 +++-
 net/8021q/vlanproc.c                |  7 +++++--
 net/core/net-procfs.c               | 16 ++++++++++++----
 net/core/net-sysfs.c                |  4 +++-
 net/core/rtnetlink.c                |  9 +++++++--
 7 files changed, 49 insertions(+), 13 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 5a3178b3dba3..8361278979d6 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1757,7 +1757,12 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 
 	slave_dev->priv_flags |= IFF_BONDING;
 	/* initialize slave stats */
-	dev_get_stats(new_slave->dev, &new_slave->slave_stats);
+	res = dev_get_stats(new_slave->dev, &new_slave->slave_stats);
+	if (res) {
+		slave_err(bond_dev, slave_dev, "dev_get_stats returned %d\n",
+			  res);
+		goto err_close;
+	}
 
 	if (bond_is_lb(bond)) {
 		/* bond_alb_init_slave() must be called before all other stages since
@@ -2094,7 +2099,13 @@ static int __bond_release_one(struct net_device *bond_dev,
 	bond_sysfs_slave_del(slave);
 
 	/* recompute stats just before removing the slave */
-	bond_get_stats(bond->dev, &bond->bond_stats);
+	err = bond_get_stats(bond->dev, &bond->bond_stats);
+	if (err) {
+		slave_info(bond_dev, slave_dev, "dev_get_stats returned %d\n",
+			   err);
+		unblock_netpoll_tx();
+		return err;
+	}
 
 	bond_upper_dev_unlink(bond, slave);
 	/* unregister rx_handler early so bond_handle_frame wouldn't be called
diff --git a/drivers/parisc/led.c b/drivers/parisc/led.c
index cc6108785323..d17d0fbf878d 100644
--- a/drivers/parisc/led.c
+++ b/drivers/parisc/led.c
@@ -370,7 +370,12 @@ static __inline__ int led_get_net_activity(void)
 
 		in_dev_put(in_dev);
 
-		dev_get_stats(dev, &stats);
+		retval = dev_get_stats(dev, &stats);
+		if (retval) {
+			netif_lists_unlock(&init_net);
+			return retval;
+		}
+
 		rx_total += stats.rx_packets;
 		tx_total += stats.tx_packets;
 	}
diff --git a/drivers/usb/gadget/function/rndis.c b/drivers/usb/gadget/function/rndis.c
index 7ec29e007ae9..bec474819c3d 100644
--- a/drivers/usb/gadget/function/rndis.c
+++ b/drivers/usb/gadget/function/rndis.c
@@ -198,7 +198,9 @@ static int gen_ndis_query_resp(struct rndis_params *params, u32 OID, u8 *buf,
 	resp->InformationBufferOffset = cpu_to_le32(16);
 
 	net = params->dev;
-	dev_get_stats(net, &stats);
+	retval = dev_get_stats(net, &stats);
+	if (retval)
+		return retval;
 
 	switch (OID) {
 
diff --git a/net/8021q/vlanproc.c b/net/8021q/vlanproc.c
index 3a6682d79630..d89b75804834 100644
--- a/net/8021q/vlanproc.c
+++ b/net/8021q/vlanproc.c
@@ -244,12 +244,15 @@ static int vlandev_seq_show(struct seq_file *seq, void *offset)
 	const struct vlan_dev_priv *vlan = vlan_dev_priv(vlandev);
 	static const char fmt64[] = "%30s %12llu\n";
 	struct rtnl_link_stats64 stats;
-	int i;
+	int err, i;
 
 	if (!is_vlan_dev(vlandev))
 		return 0;
 
-	dev_get_stats(vlandev, &stats);
+	err = dev_get_stats(vlandev, &stats);
+	if (err)
+		return err;
+
 	seq_printf(seq,
 		   "%s  VID: %d	 REORDER_HDR: %i  dev->priv_flags: %hx\n",
 		   vlandev->name, vlan->vlan_id,
diff --git a/net/core/net-procfs.c b/net/core/net-procfs.c
index 64666ba7ccab..ee19c35f6e00 100644
--- a/net/core/net-procfs.c
+++ b/net/core/net-procfs.c
@@ -78,11 +78,14 @@ static void dev_seq_stop(struct seq_file *seq, void *v)
 	netif_lists_unlock(net);
 }
 
-static void dev_seq_printf_stats(struct seq_file *seq, struct net_device *dev)
+static int dev_seq_printf_stats(struct seq_file *seq, struct net_device *dev)
 {
 	struct rtnl_link_stats64 stats;
+	int err;
 
-	dev_get_stats(dev, &stats);
+	err = dev_get_stats(dev, &stats);
+	if (err)
+		return err;
 
 	seq_printf(seq, "%6s: %7llu %7llu %4llu %4llu %4llu %5llu %10llu %9llu "
 		   "%8llu %7llu %4llu %4llu %4llu %5llu %7llu %10llu\n",
@@ -101,6 +104,8 @@ static void dev_seq_printf_stats(struct seq_file *seq, struct net_device *dev)
 		    stats.tx_window_errors +
 		    stats.tx_heartbeat_errors,
 		   stats.tx_compressed);
+
+	return 0;
 }
 
 /*
@@ -109,6 +114,8 @@ static void dev_seq_printf_stats(struct seq_file *seq, struct net_device *dev)
  */
 static int dev_seq_show(struct seq_file *seq, void *v)
 {
+	int err = 0;
+
 	if (v == SEQ_START_TOKEN)
 		seq_puts(seq, "Inter-|   Receive                            "
 			      "                    |  Transmit\n"
@@ -116,8 +123,9 @@ static int dev_seq_show(struct seq_file *seq, void *v)
 			      "compressed multicast|bytes    packets errs "
 			      "drop fifo colls carrier compressed\n");
 	else
-		dev_seq_printf_stats(seq, v);
-	return 0;
+		err = dev_seq_printf_stats(seq, v);
+
+	return err;
 }
 
 static u32 softnet_backlog_len(struct softnet_data *sd)
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 5d89c85b42d4..6f789e178e92 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -588,7 +588,9 @@ static ssize_t netstat_show(const struct device *d,
 	if (dev_isalive(dev)) {
 		struct rtnl_link_stats64 stats;
 
-		dev_get_stats(dev, &stats);
+		ret = dev_get_stats(dev, &stats);
+		if (ret)
+			return ret;
 
 		ret = sprintf(buf, fmt_u64, *(u64 *)(((u8 *)&stats) + offset));
 	}
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index bb0596c41b3e..4c0b2ef3a17c 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1201,6 +1201,7 @@ static noinline_for_stack int rtnl_fill_stats(struct sk_buff *skb,
 {
 	struct rtnl_link_stats64 *sp;
 	struct nlattr *attr;
+	int err;
 
 	attr = nla_reserve_64bit(skb, IFLA_STATS64,
 				 sizeof(struct rtnl_link_stats64), IFLA_PAD);
@@ -1208,7 +1209,9 @@ static noinline_for_stack int rtnl_fill_stats(struct sk_buff *skb,
 		return -EMSGSIZE;
 
 	sp = nla_data(attr);
-	dev_get_stats(dev, sp);
+	err = dev_get_stats(dev, sp);
+	if (err)
+		return err;
 
 	attr = nla_reserve(skb, IFLA_STATS,
 			   sizeof(struct rtnl_link_stats));
@@ -5135,7 +5138,9 @@ static int rtnl_fill_statsinfo(struct sk_buff *skb, struct net_device *dev,
 			goto nla_put_failure;
 
 		sp = nla_data(attr);
-		dev_get_stats(dev, sp);
+		err = dev_get_stats(dev, sp);
+		if (err)
+			goto nla_put_failure;
 	}
 
 	if (stats_attr_valid(filter_mask, IFLA_STATS_LINK_XSTATS, *idxattr)) {
-- 
2.25.1

