Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAB401E5074
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 23:26:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387536AbgE0V0H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 17:26:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387412AbgE0V0G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 17:26:06 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AF8EC05BD1E
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 14:26:06 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id bh7so3746683plb.11
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 14:26:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rKyBTbYLux2rT/4XsCE8CwSfqhIVXh6egEt7QbP7Zok=;
        b=QSDb1LJbpmAsIMKyvz7BU7imGQ4mKyEDKQ4JfC1bp8Hcaeoadsl4RrZrBs/GfkuHxK
         AWIb29F9mWV0gaZd1eqQQasmLFzM2SdPBTf2a1p4s0K63lXyqht5KicjyQk1f7ykSiBw
         PkWMZ/UTKYH6oDy1Bnxt2nvpMvcJYZAR4Xr9M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rKyBTbYLux2rT/4XsCE8CwSfqhIVXh6egEt7QbP7Zok=;
        b=V2GJwcbYkfnuEicsQC6mnZ7Ywny87Tzd5g2VWjN8NXK3GualIIihUnFxJ6FxHfafgz
         HTfZv4ccigeXtAvfalVlfs//LgILEbv8q0zEfUw3CC/PpUx0gAaPsNujOk32YmS9vWpi
         sGzY44ERc1SavHDHHghiNtk08Htak1G9iumDvLqpQLgDWzsWCpOizIudHiXwQEx0Rohf
         oyQ3Ow3GYFsD20ZJVODc9RZVXlIEkkCYpgH2YWMhVLsSiYR2MEQvbDE8OxgdhyEjEzzx
         rySl3O4duToXYnV92S7FNYeQjSrHCvFVXKz4rK3OFDebECmrvXM/sOCn7wXHJb7wOpzi
         RWWg==
X-Gm-Message-State: AOAM530Tv78jpnnmgGncnLC22I2sWyG6ZbSaAK7TJrOL7ybI2xGLEGS9
        Iie9YiP32u5L4Rlkyxpv1TjgMsJCGvG88WbaiOS/w0PAg57tpBPIoOLZOlHNNA4Gupg01dcNOTV
        3uSSBL9roVJwBAE63PLAmxOznMLKr2ZQIHyKWFUoC87s3URM5dX5L0QWNlE122OupCPBa9Fav
X-Google-Smtp-Source: ABdhPJyDU5AumOJVNYGmQyd5586o/ydUuIzsaj3TbQlUwe6CUmiHUjvq+IbmjWOAbfcJPOLw682U1w==
X-Received: by 2002:a17:90b:358e:: with SMTP id mm14mr329135pjb.175.1590614765427;
        Wed, 27 May 2020 14:26:05 -0700 (PDT)
Received: from localhost.localdomain ([2600:8802:202:f600::ddf])
        by smtp.gmail.com with ESMTPSA id c4sm2770344pfb.130.2020.05.27.14.26.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2020 14:26:05 -0700 (PDT)
From:   Edwin Peer <edwin.peer@broadcom.com>
To:     netdev@vger.kernel.org
Cc:     Edwin Peer <edwin.peer@broadcom.com>, edumazet@google.com,
        linville@tuxdriver.com, shemminger@vyatta.com,
        mirq-linux@rere.qmqm.pl, jesse.brandeburg@intel.com,
        jchapman@katalix.com, david@weave.works, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, sridhar.samudrala@intel.com,
        jiri@mellanox.com, geoff@infradead.org, mokuno@sm.sony.co.jp,
        msink@permonline.ru, mporter@kernel.crashing.org,
        inaky.perez-gonzalez@intel.com, jwi@linux.ibm.com,
        kgraul@linux.ibm.com, ubraun@linux.ibm.com,
        grant.likely@secretlab.ca, hadi@cyberus.ca, dsahern@kernel.org,
        shrijeet@gmail.com, jon.mason@intel.com, dave.jiang@intel.com,
        saeedm@mellanox.com, hadarh@mellanox.com, ogerlitz@mellanox.com,
        allenbh@gmail.com, michael.chan@broadcom.com
Subject: [RFC PATCH net-next 08/11] net: distribute IFF_NO_VLAN_ROOM into aggregate devs
Date:   Wed, 27 May 2020 14:25:09 -0700
Message-Id: <20200527212512.17901-9-edwin.peer@broadcom.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200527212512.17901-1-edwin.peer@broadcom.com>
References: <20200527212512.17901-1-edwin.peer@broadcom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VLANs layered above aggregate devices such as bonds and teams should
inherit the MTU limitations of the devices underlying the aggregate.
If any one of the slave devices is constrained by IFF_NO_VLAN_ROOM,
then so must the aggregate as a whole.

Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
---
 drivers/net/bonding/bond_main.c |  3 +++
 drivers/net/net_failover.c      | 12 ++++++++++++
 drivers/net/team/team.c         |  5 +++++
 3 files changed, 20 insertions(+)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 4c45f1692934..3002ba879d14 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1147,6 +1147,7 @@ static void bond_compute_features(struct bonding *bond)
 	vlan_features &= NETIF_F_ALL_FOR_ALL;
 	mpls_features &= NETIF_F_ALL_FOR_ALL;
 	bond_dev->priv_flags |= IFF_XMIT_DST_RELEASE;
+	bond_dev->priv_flags &= ~IFF_NO_VLAN_ROOM;
 
 	bond_for_each_slave(bond, slave, iter) {
 		vlan_features = netdev_increment_features(vlan_features,
@@ -1162,6 +1163,8 @@ static void bond_compute_features(struct bonding *bond)
 
 		bond_dev->priv_flags &= slave->dev->priv_flags |
 					~IFF_XMIT_DST_RELEASE;
+		bond_dev->priv_flags |= slave->dev->priv_flags &
+					IFF_NO_VLAN_ROOM;
 
 		if (slave->dev->hard_header_len > max_hard_header_len)
 			max_hard_header_len = slave->dev->hard_header_len;
diff --git a/drivers/net/net_failover.c b/drivers/net/net_failover.c
index 436945e0a4c1..a085d292b4cf 100644
--- a/drivers/net/net_failover.c
+++ b/drivers/net/net_failover.c
@@ -211,6 +211,16 @@ static void net_failover_get_stats(struct net_device *dev,
 	spin_unlock(&nfo_info->stats_lock);
 }
 
+static void net_failover_constrain_vlan(struct net_device *dev,
+					struct net_device *primary,
+					struct net_device *standby)
+{
+	dev->priv_flags &= ~IFF_NO_VLAN_ROOM;
+	dev->priv_flags |= IFF_NO_VLAN_ROOM &
+			   ((primary ? primary->priv_flags : 0) |
+			    (standby ? standby->priv_flags : 0));
+}
+
 static int net_failover_change_mtu(struct net_device *dev, int new_mtu)
 {
 	struct net_failover_info *nfo_info = netdev_priv(dev);
@@ -235,6 +245,7 @@ static int net_failover_change_mtu(struct net_device *dev, int new_mtu)
 	}
 
 	dev->mtu = new_mtu;
+	net_failover_constrain_vlan(dev, primary_dev, standby_dev);
 
 	return 0;
 }
@@ -427,6 +438,7 @@ static void net_failover_compute_features(struct net_device *dev)
 	dev->hw_enc_features = enc_features | NETIF_F_GSO_ENCAP_ALL;
 	dev->hard_header_len = max_hard_header_len;
 
+	net_failover_constrain_vlan(dev, primary_dev, standby_dev);
 
 	netdev_change_features(dev);
 }
diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index 5987fc2db031..3e18d1de036d 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -990,6 +990,7 @@ static void __team_compute_features(struct team *team)
 	unsigned short max_hard_header_len = ETH_HLEN;
 
 	team->dev->priv_flags |= IFF_XMIT_DST_RELEASE;
+	team->dev->priv_flags &= ~IFF_NO_VLAN_ROOM;
 
 	list_for_each_entry(port, &team->port_list, list) {
 		vlan_features = netdev_increment_features(vlan_features,
@@ -1002,6 +1003,8 @@ static void __team_compute_features(struct team *team)
 
 		team->dev->priv_flags &= port->dev->priv_flags |
 					 ~IFF_XMIT_DST_RELEASE;
+		team->dev->priv_flags |= port->dev->priv_flags &
+					 IFF_NO_VLAN_ROOM;
 
 		if (port->dev->hard_header_len > max_hard_header_len)
 			max_hard_header_len = port->dev->hard_header_len;
@@ -1808,6 +1811,7 @@ static int team_change_mtu(struct net_device *dev, int new_mtu)
 	 */
 	mutex_lock(&team->lock);
 	team->port_mtu_change_allowed = true;
+	dev->priv_flags &= ~IFF_NO_VLAN_ROOM;
 	list_for_each_entry(port, &team->port_list, list) {
 		err = dev_set_mtu(port->dev, new_mtu);
 		if (err) {
@@ -1815,6 +1819,7 @@ static int team_change_mtu(struct net_device *dev, int new_mtu)
 				   port->dev->name);
 			goto unwind;
 		}
+		dev->priv_flags |= port->dev->priv_flags & IFF_NO_VLAN_ROOM;
 	}
 	team->port_mtu_change_allowed = false;
 	mutex_unlock(&team->lock);
-- 
2.26.2

