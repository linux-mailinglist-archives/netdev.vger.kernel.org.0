Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B9664D88D9
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 17:09:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242906AbiCNQKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 12:10:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242900AbiCNQKh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 12:10:37 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 409A241325
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 09:09:22 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id c15so6042679ljr.9
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 09:09:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:organization:mime-version
         :content-disposition;
        bh=PdN83f/KTzIJ4Tg+tYGqivJwbqAMJnVElhYC32WRhoE=;
        b=ZMSpyxHuiQrsgKB8TkZwO1LQB4VMMfWaZbaKgQ4ufMwF6P0DQRFo+3elmmNQ/X3t5q
         g8HrYfTMo0Zx9lWG8grDX5Jx9Nq7lR+ddh0Ybv3gKByCpGXX9ndZBicCIz0kKK7z/mII
         8vTX0f056/1bqSM96U4Lys32PfkrCKghYvV2GYgulLXMYQFlsZ9E014PfntLY/2JPsuc
         VhW4M9QstvUvI7qcWagxwnzFF9eotzRtRfn+gHHrjI08qaZSMsIsjgzNvmYxXQFgDrOD
         U8zNiyZeZ8P9R5MV/kbA+PfCOFdI2JWU6GnjfC+iAEgvirAgCu6ZJBnltDT546aqnmhN
         TsYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:organization
         :mime-version:content-disposition;
        bh=PdN83f/KTzIJ4Tg+tYGqivJwbqAMJnVElhYC32WRhoE=;
        b=LxXQ+jHfxcKT2j2boAiV4MKq95lZu4ZdlMBuHXaZYQ29psygd8EY50TxmmZ/siF9N+
         HaVpxuXN+iAq0eFW/RHud8aRzlhquImxFgdldOvjoVq258++5GGy7P7tQXRK5wORG7FM
         s4dK58Kh1KeypbCbW8eS8LEZZSC4SQxQeHVR9UMBLbx2/+V9qTOv9YcKcBI56Sgv1rvE
         5JvMK8asVez2yKu0YjZwW6GasMRpEPHwodnLBeCjlKpPvjxEOuUuQPvahvbi2NRusKQe
         ZHdi3cVea/GSmlG5PpjQnHIUTwtbWv8T3ntBBaBqX2NB82UeoTkT6grZOIRmHGRRgxKm
         R/Mw==
X-Gm-Message-State: AOAM531lVyT1AdJDEZfL2lB2jOdzHHPyjYbuSizQ1yohNDoH91IKR9th
        3M/ffD0EBhDz+oST7HeNF9aPH+WZQpXhJg==
X-Google-Smtp-Source: ABdhPJzXM8JMbKFntG37d7t6Scw0rVlXyAiqrQ1pYW98dk39WlBcI9ypJpBhAkmW2LxZhN6bGozU0w==
X-Received: by 2002:a2e:9d58:0:b0:246:4c6b:e9c8 with SMTP id y24-20020a2e9d58000000b002464c6be9c8mr14538461ljj.182.1647274159708;
        Mon, 14 Mar 2022 09:09:19 -0700 (PDT)
Received: from wse-c0155 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id l11-20020a2e99cb000000b00247b6e80f53sm4051119ljj.27.2022.03.14.09.09.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 09:09:19 -0700 (PDT)
Date:   Mon, 14 Mar 2022 17:09:18 +0100
From:   Casper Andersson <casper.casan@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org
Subject: [PATCH net-next] net: sparx5: Use Switchdev fdb events for managing
 fdb entries
Message-ID: <20220314160918.4rfrrfgmbsf2pxl3@wse-c0155>
Organization: Westermo Network Technologies AB
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changes the handling of fdb entries to use Switchdev events,
instead of the previous "sync_bridge" and "sync_port" which
only run when adding or removing VLANs on the bridge.

Signed-off-by: Casper Andersson <casper.casan@gmail.com>
---
 .../microchip/sparx5/sparx5_mactable.c        | 11 ++-
 .../ethernet/microchip/sparx5/sparx5_main.h   |  3 +-
 .../microchip/sparx5/sparx5_switchdev.c       | 91 +++++--------------
 3 files changed, 33 insertions(+), 72 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_mactable.c b/drivers/net/ethernet/microchip/sparx5/sparx5_mactable.c
index 9a8e4f201eb1..82b1b3c9a065 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_mactable.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_mactable.c
@@ -286,7 +286,8 @@ static void sparx5_fdb_call_notifiers(enum switchdev_notifier_type type,
 }
 
 int sparx5_add_mact_entry(struct sparx5 *sparx5,
-			  struct sparx5_port *port,
+			  struct net_device *dev,
+			  u16 portno,
 			  const unsigned char *addr, u16 vid)
 {
 	struct sparx5_mact_entry *mact_entry;
@@ -302,14 +303,14 @@ int sparx5_add_mact_entry(struct sparx5 *sparx5,
 	 * mact thread to start the frame will reach CPU and the CPU will
 	 * add the entry but without the extern_learn flag.
 	 */
-	mact_entry = find_mact_entry(sparx5, addr, vid, port->portno);
+	mact_entry = find_mact_entry(sparx5, addr, vid, portno);
 	if (mact_entry)
 		goto update_hw;
 
 	/* Add the entry in SW MAC table not to get the notification when
 	 * SW is pulling again
 	 */
-	mact_entry = alloc_mact_entry(sparx5, addr, vid, port->portno);
+	mact_entry = alloc_mact_entry(sparx5, addr, vid, portno);
 	if (!mact_entry)
 		return -ENOMEM;
 
@@ -318,13 +319,13 @@ int sparx5_add_mact_entry(struct sparx5 *sparx5,
 	mutex_unlock(&sparx5->mact_lock);
 
 update_hw:
-	ret = sparx5_mact_learn(sparx5, port->portno, addr, vid);
+	ret = sparx5_mact_learn(sparx5, portno, addr, vid);
 
 	/* New entry? */
 	if (mact_entry->flags == 0) {
 		mact_entry->flags |= MAC_ENT_LOCK; /* Don't age this */
 		sparx5_fdb_call_notifiers(SWITCHDEV_FDB_ADD_TO_BRIDGE, addr, vid,
-					  port->ndev, true);
+					  dev, true);
 	}
 
 	return ret;
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
index 33892dfc3b2f..df68a0891029 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
@@ -305,7 +305,8 @@ bool sparx5_mact_getnext(struct sparx5 *sparx5,
 int sparx5_mact_forget(struct sparx5 *sparx5,
 		       const unsigned char mac[ETH_ALEN], u16 vid);
 int sparx5_add_mact_entry(struct sparx5 *sparx5,
-			  struct sparx5_port *port,
+			  struct net_device *dev,
+			  u16 portno,
 			  const unsigned char *addr, u16 vid);
 int sparx5_del_mact_entry(struct sparx5 *sparx5,
 			  const unsigned char *addr,
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c b/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
index dacb87f49552..2d5de1c06fab 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
@@ -16,6 +16,7 @@ struct sparx5_switchdev_event_work {
 	struct work_struct work;
 	struct switchdev_notifier_fdb_info fdb_info;
 	struct net_device *dev;
+	struct sparx5 *sparx5;
 	unsigned long event;
 };
 
@@ -247,31 +248,34 @@ static void sparx5_switchdev_bridge_fdb_event_work(struct work_struct *work)
 	struct switchdev_notifier_fdb_info *fdb_info;
 	struct sparx5_port *port;
 	struct sparx5 *sparx5;
+	bool host_addr;
 
 	rtnl_lock();
-	if (!sparx5_netdevice_check(dev))
-		goto out;
-
-	port = netdev_priv(dev);
-	sparx5 = port->sparx5;
+	if (!sparx5_netdevice_check(dev)) {
+		host_addr = true;
+		sparx5 = switchdev_work->sparx5;
+	} else {
+		host_addr = false;
+		sparx5 = switchdev_work->sparx5;
+		port = netdev_priv(dev);
+	}
 
 	fdb_info = &switchdev_work->fdb_info;
 
 	switch (switchdev_work->event) {
 	case SWITCHDEV_FDB_ADD_TO_DEVICE:
-		if (!fdb_info->added_by_user)
-			break;
-		sparx5_add_mact_entry(sparx5, port, fdb_info->addr,
-				      fdb_info->vid);
+		if (host_addr)
+			sparx5_add_mact_entry(sparx5, dev, PGID_CPU,
+					      fdb_info->addr, fdb_info->vid);
+		else
+			sparx5_add_mact_entry(sparx5, port->ndev, port->portno,
+					      fdb_info->addr, fdb_info->vid);
 		break;
 	case SWITCHDEV_FDB_DEL_TO_DEVICE:
-		if (!fdb_info->added_by_user)
-			break;
 		sparx5_del_mact_entry(sparx5, fdb_info->addr, fdb_info->vid);
 		break;
 	}
 
-out:
 	rtnl_unlock();
 	kfree(switchdev_work->fdb_info.addr);
 	kfree(switchdev_work);
@@ -283,15 +287,18 @@ static void sparx5_schedule_work(struct work_struct *work)
 	queue_work(sparx5_owq, work);
 }
 
-static int sparx5_switchdev_event(struct notifier_block *unused,
+static int sparx5_switchdev_event(struct notifier_block *nb,
 				  unsigned long event, void *ptr)
 {
 	struct net_device *dev = switchdev_notifier_info_to_dev(ptr);
 	struct sparx5_switchdev_event_work *switchdev_work;
 	struct switchdev_notifier_fdb_info *fdb_info;
 	struct switchdev_notifier_info *info = ptr;
+	struct sparx5 *spx5;
 	int err;
 
+	spx5 = container_of(nb, struct sparx5, switchdev_nb);
+
 	switch (event) {
 	case SWITCHDEV_PORT_ATTR_SET:
 		err = switchdev_handle_port_attr_set(dev, ptr,
@@ -307,6 +314,7 @@ static int sparx5_switchdev_event(struct notifier_block *unused,
 
 		switchdev_work->dev = dev;
 		switchdev_work->event = event;
+		switchdev_work->sparx5 = spx5;
 
 		fdb_info = container_of(info,
 					struct switchdev_notifier_fdb_info,
@@ -333,54 +341,6 @@ static int sparx5_switchdev_event(struct notifier_block *unused,
 	return NOTIFY_BAD;
 }
 
-static void sparx5_sync_port_dev_addr(struct sparx5 *sparx5,
-				      struct sparx5_port *port,
-				      u16 vid, bool add)
-{
-	if (!port ||
-	    !test_bit(port->portno, sparx5->bridge_mask))
-		return; /* Skip null/host interfaces */
-
-	/* Bridge connects to vid? */
-	if (add) {
-		/* Add port MAC address from the VLAN */
-		sparx5_mact_learn(sparx5, PGID_CPU,
-				  port->ndev->dev_addr, vid);
-	} else {
-		/* Control port addr visibility depending on
-		 * port VLAN connectivity.
-		 */
-		if (test_bit(port->portno, sparx5->vlan_mask[vid]))
-			sparx5_mact_learn(sparx5, PGID_CPU,
-					  port->ndev->dev_addr, vid);
-		else
-			sparx5_mact_forget(sparx5,
-					   port->ndev->dev_addr, vid);
-	}
-}
-
-static void sparx5_sync_bridge_dev_addr(struct net_device *dev,
-					struct sparx5 *sparx5,
-					u16 vid, bool add)
-{
-	int i;
-
-	/* First, handle bridge address'es */
-	if (add) {
-		sparx5_mact_learn(sparx5, PGID_CPU, dev->dev_addr,
-				  vid);
-		sparx5_mact_learn(sparx5, PGID_BCAST, dev->broadcast,
-				  vid);
-	} else {
-		sparx5_mact_forget(sparx5, dev->dev_addr, vid);
-		sparx5_mact_forget(sparx5, dev->broadcast, vid);
-	}
-
-	/* Now look at bridged ports */
-	for (i = 0; i < SPX5_PORTS; i++)
-		sparx5_sync_port_dev_addr(sparx5, sparx5->ports[i], vid, add);
-}
-
 static int sparx5_handle_port_vlan_add(struct net_device *dev,
 				       struct notifier_block *nb,
 				       const struct switchdev_obj_port_vlan *v)
@@ -392,7 +352,9 @@ static int sparx5_handle_port_vlan_add(struct net_device *dev,
 			container_of(nb, struct sparx5,
 				     switchdev_blocking_nb);
 
-		sparx5_sync_bridge_dev_addr(dev, sparx5, v->vid, true);
+		/* Flood broadcast to CPU */
+		sparx5_mact_learn(sparx5, PGID_BCAST, dev->broadcast,
+				  v->vid);
 		return 0;
 	}
 
@@ -438,7 +400,7 @@ static int sparx5_handle_port_vlan_del(struct net_device *dev,
 			container_of(nb, struct sparx5,
 				     switchdev_blocking_nb);
 
-		sparx5_sync_bridge_dev_addr(dev, sparx5, vid, false);
+		sparx5_mact_forget(sparx5, dev->broadcast, vid);
 		return 0;
 	}
 
@@ -449,9 +411,6 @@ static int sparx5_handle_port_vlan_del(struct net_device *dev,
 	if (ret)
 		return ret;
 
-	/* Delete the port MAC address with the matching VLAN information */
-	sparx5_mact_forget(port->sparx5, port->ndev->dev_addr, vid);
-
 	return 0;
 }
 
-- 
2.30.2

