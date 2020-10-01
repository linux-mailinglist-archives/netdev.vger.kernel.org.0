Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E13A727FD74
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 12:33:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732184AbgJAKdY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 06:33:24 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:7481 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732082AbgJAKdI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 06:33:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1601548386; x=1633084386;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=162a3UNv+BipaT+Z/XV9LNVNZ1Zg0SmHmASYsU4DRCY=;
  b=cHwwiEaR/ARp7TlBf/dUc2c/KvdmH6wvdSBePqM6m4l1tsFh9uadETPZ
   YQNkdxAMGgX4HVxg2Jc7gOsNwicJm3R7kPhJmWnYSl8xEsm7DSBUPrRSH
   IbVbGE9MbKljc+L0R6A9H+vVavhSOtNplUV94ndugcHD1GU3oS5aRCe+I
   elKWnKyEkp/vXjTvgUTsMub+91XBMRjKQGxTZMTOTKtzq4O1l4w+rhoXL
   sezBpr9C3Enz/4E/cYzemOOBv866VxxZbppr40evVAgEB+f2/fimBEzwU
   oAZaMJLa4kDqgE/rJ4AaOm+xTUz3FP0e/BuygmDTtX2056LVlMKCmApGc
   g==;
IronPort-SDR: EuH6L9e0ywr0C3M84szSDevG2GWEmlY57LfK0VJlQdLJNXV/JgBc8Uy8gX1o6LK/bsIH+MnyVZ
 rVGXou7OCqWrFo84dc0o4zFqL7DcdMka7bV7Zf8PtHLx49bQ98wtOZA/62iYqZhNTV2DwghsR4
 qKa+3BqsCsaW/C+EJvtLl6WdgPBNQBpiN/vTtNCe/n7YvCP1gE+rMKrifU9QKTm96b60ePdSa8
 qtK4KMIomGWzxoLJVYAIEkdJs3rpA1EijU0rRs+BnAbyX5NbRnBL0n8ttc8MsV/bu+VTKc6XGk
 dlA=
X-IronPort-AV: E=Sophos;i="5.77,323,1596524400"; 
   d="scan'208";a="93863871"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Oct 2020 03:33:04 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 1 Oct 2020 03:33:04 -0700
Received: from soft-test08.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Thu, 1 Oct 2020 03:32:36 -0700
From:   Henrik Bjoernlund <henrik.bjoernlund@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <roopa@nvidia.com>,
        <nikolay@nvidia.com>, <jiri@mellanox.com>, <idosch@mellanox.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>, <UNGLinuxDriver@microchip.com>
CC:     Henrik Bjoernlund <henrik.bjoernlund@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [net-next v2 11/11] bridge: cfm: Added CFM switchdev utilization.
Date:   Thu, 1 Oct 2020 10:30:19 +0000
Message-ID: <20201001103019.1342470-12-henrik.bjoernlund@microchip.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201001103019.1342470-1-henrik.bjoernlund@microchip.com>
References: <20201001103019.1342470-1-henrik.bjoernlund@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The CFM kernel implementation is now trying to offload functionallity
in HW by utilizing the switchdev interface.

MEP instances are created/deleted and CCM frames are transmitted in HW.
Also handling of received CCM frames and the defect calculation is dome
in HW.

Reviewed-by: Horatiu Vultur  <horatiu.vultur@microchip.com>
Signed-off-by: Henrik Bjoernlund  <henrik.bjoernlund@microchip.com>
---
 net/bridge/Makefile           |   2 +-
 net/bridge/br_cfm.c           | 270 ++++++++++++++++++++++++++++++----
 net/bridge/br_cfm_netlink.c   |  51 +++----
 net/bridge/br_cfm_switchdev.c | 203 +++++++++++++++++++++++++
 net/bridge/br_private_cfm.h   |  63 +++++++-
 5 files changed, 530 insertions(+), 59 deletions(-)
 create mode 100644 net/bridge/br_cfm_switchdev.c

diff --git a/net/bridge/Makefile b/net/bridge/Makefile
index 4702702a74d3..5d0a399825ef 100644
--- a/net/bridge/Makefile
+++ b/net/bridge/Makefile
@@ -28,4 +28,4 @@ obj-$(CONFIG_NETFILTER) += netfilter/
 
 bridge-$(CONFIG_BRIDGE_MRP)	+= br_mrp_switchdev.o br_mrp.o br_mrp_netlink.o
 
-bridge-$(CONFIG_BRIDGE_CFM)	+= br_cfm.o br_cfm_netlink.o
+bridge-$(CONFIG_BRIDGE_CFM)	+= br_cfm_switchdev.o br_cfm.o br_cfm_netlink.o
diff --git a/net/bridge/br_cfm.c b/net/bridge/br_cfm.c
index fc8268cb76c1..bfaee33acffb 100644
--- a/net/bridge/br_cfm.c
+++ b/net/bridge/br_cfm.c
@@ -184,9 +184,11 @@ static struct sk_buff *ccm_frame_build(struct br_cfm_mep *mep,
 	}
 	skb->dev = b_port->dev;
 	rcu_read_unlock();
-	/* The device cannot be deleted until the work_queue functions has
-	 * completed. This function is called from ccm_tx_work_expired()
-	 * that is a work_queue functions.
+	/* This function is called from ccm_tx_work_expired that
+	 * is a work_queue function.
+	 * It is also called from br_cfm_cc_rdi_set and br_cfm_cc_ccm_tx
+	 * that has the RTNL.
+	 * Due to this the device cannot be deleted.
 	 */
 
 	skb->protocol = htons(ETH_P_CFM);
@@ -500,6 +502,7 @@ int br_cfm_mep_create(struct net_bridge *br,
 {
 	struct net_bridge_port *p;
 	struct br_cfm_mep *mep;
+	int swd_ret;
 
 	ASSERT_RTNL();
 
@@ -546,6 +549,11 @@ int br_cfm_mep_create(struct net_bridge *br,
 		}
 	}
 
+	/* Try create MEP in Switchdev */
+	swd_ret = br_cfm_switchdev_mep_create(br, instance, create, extack);
+	if (swd_ret && swd_ret != -EOPNOTSUPP)
+		return swd_ret;
+
 	mep = kzalloc(sizeof(*mep), GFP_KERNEL);
 	if (!mep)
 		return -ENOMEM;
@@ -555,20 +563,21 @@ int br_cfm_mep_create(struct net_bridge *br,
 	rcu_assign_pointer(mep->b_port, p);
 
 	INIT_HLIST_HEAD(&mep->peer_mep_list);
-	INIT_DELAYED_WORK(&mep->ccm_tx_dwork, ccm_tx_work_expired);
-
-	if (hlist_empty(&br->mep_list))
+	if ((swd_ret == -EOPNOTSUPP) && hlist_empty(&br->mep_list))
 		br_add_frame(br, &cfm_frame_type);
-
 	hlist_add_tail_rcu(&mep->head, &br->mep_list);
 
+	INIT_DELAYED_WORK(&mep->ccm_tx_dwork, ccm_tx_work_expired);
+
 	return 0;
 }
 
-static void mep_delete_implementation(struct net_bridge *br,
-				      struct br_cfm_mep *mep)
+static int mep_delete_implementation(struct net_bridge *br,
+				     struct br_cfm_mep *mep,
+				     struct netlink_ext_ack *extack)
 {
 	struct br_cfm_peer_mep *peer_mep;
+	int swd_ret;
 
 	ASSERT_RTNL();
 
@@ -579,14 +588,23 @@ static void mep_delete_implementation(struct net_bridge *br,
 		kfree_rcu(peer_mep, rcu);
 	}
 
-	cancel_delayed_work_sync(&mep->ccm_tx_dwork);
-
 	RCU_INIT_POINTER(mep->b_port, NULL);
 	hlist_del_rcu(&mep->head);
-	kfree_rcu(mep, rcu);
 
+	/* Try delete MEP in Switchdev */
+	swd_ret = br_cfm_switchdev_mep_delete(br, mep, extack);
+	if (swd_ret != -EOPNOTSUPP)
+		goto free;
+
+	swd_ret = 0;
 	if (hlist_empty(&br->mep_list))
 		br_del_frame(br, &cfm_frame_type);
+	cancel_delayed_work_sync(&mep->ccm_tx_dwork);
+
+free:
+	kfree_rcu(mep, rcu);
+
+	return swd_ret;
 }
 
 int br_cfm_mep_delete(struct net_bridge *br,
@@ -604,9 +622,7 @@ int br_cfm_mep_delete(struct net_bridge *br,
 		return -ENOENT;
 	}
 
-	mep_delete_implementation(br, mep);
-
-	return 0;
+	return mep_delete_implementation(br, mep, extack);
 }
 
 int br_cfm_mep_config_set(struct net_bridge *br,
@@ -615,6 +631,7 @@ int br_cfm_mep_config_set(struct net_bridge *br,
 			  struct netlink_ext_ack *extack)
 {
 	struct br_cfm_mep *mep;
+	int swd_ret;
 
 	ASSERT_RTNL();
 
@@ -637,6 +654,11 @@ int br_cfm_mep_config_set(struct net_bridge *br,
 		return -ENOENT;
 	}
 
+	/* Try configure MEP in Switchdev */
+	swd_ret = br_cfm_switchdev_mep_config_set(br, mep, config, extack);
+	if (swd_ret && swd_ret != -EOPNOTSUPP)
+		return swd_ret;
+
 	mep->config = *config;
 
 	return 0;
@@ -649,6 +671,7 @@ int br_cfm_cc_config_set(struct net_bridge *br,
 {
 	struct br_cfm_peer_mep *peer_mep;
 	struct br_cfm_mep *mep;
+	int swd_ret;
 
 	ASSERT_RTNL();
 
@@ -663,6 +686,19 @@ int br_cfm_cc_config_set(struct net_bridge *br,
 	if (memcmp(config, &mep->cc_config, sizeof(*config)) == 0)
 		return 0;
 
+	/* Try configure CC in Switchdev */
+	swd_ret = br_cfm_switchdev_cc_config_set(br, mep, config, extack);
+	if (swd_ret && swd_ret != -EOPNOTSUPP)
+		return swd_ret;
+
+	mep->cc_config = *config;
+	mep->ccm_rx_snumber = 0;
+	mep->ccm_tx_snumber = 1;
+
+	/* Return if switchdev. CCM is not transmitted or received here */
+	if (!swd_ret)
+		return 0;
+
 	if (config->enable && !mep->cc_config.enable)
 		/* CC is enabled */
 		hlist_for_each_entry(peer_mep, &mep->peer_mep_list, head)
@@ -673,10 +709,6 @@ int br_cfm_cc_config_set(struct net_bridge *br,
 		hlist_for_each_entry(peer_mep, &mep->peer_mep_list, head)
 			cc_peer_disable(peer_mep);
 
-	mep->cc_config = *config;
-	mep->ccm_rx_snumber = 0;
-	mep->ccm_tx_snumber = 1;
-
 	return 0;
 }
 
@@ -686,6 +718,7 @@ int br_cfm_cc_peer_mep_add(struct net_bridge *br, const u32 instance,
 {
 	struct br_cfm_peer_mep *peer_mep;
 	struct br_cfm_mep *mep;
+	int swd_ret;
 
 	ASSERT_RTNL();
 
@@ -709,19 +742,29 @@ int br_cfm_cc_peer_mep_add(struct net_bridge *br, const u32 instance,
 		return -EEXIST;
 	}
 
+	/* Try add peer MEP in Switchdev */
+	swd_ret = br_cfm_switchdev_cc_peer_mep_add(br, mep, mepid, extack);
+	if (swd_ret && swd_ret != -EOPNOTSUPP)
+		return swd_ret;
+
 	peer_mep = kzalloc(sizeof(*peer_mep), GFP_KERNEL);
 	if (!peer_mep)
 		return -ENOMEM;
 
 	peer_mep->mepid = mepid;
 	peer_mep->mep = mep;
+
+	hlist_add_tail_rcu(&peer_mep->head, &mep->peer_mep_list);
+
+	/* Return if switchdev. CCM is not transmitted or received here */
+	if (!swd_ret)
+		return 0;
+
 	INIT_DELAYED_WORK(&peer_mep->ccm_rx_dwork, ccm_rx_work_expired);
 
 	if (mep->cc_config.enable)
 		cc_peer_enable(peer_mep);
 
-	hlist_add_tail_rcu(&peer_mep->head, &mep->peer_mep_list);
-
 	return 0;
 }
 
@@ -731,6 +774,7 @@ int br_cfm_cc_peer_mep_remove(struct net_bridge *br, const u32 instance,
 {
 	struct br_cfm_peer_mep *peer_mep;
 	struct br_cfm_mep *mep;
+	int swd_ret;
 
 	ASSERT_RTNL();
 
@@ -748,18 +792,42 @@ int br_cfm_cc_peer_mep_remove(struct net_bridge *br, const u32 instance,
 		return -ENOENT;
 	}
 
+	hlist_del_rcu(&peer_mep->head);
+
+	/* Try remove peer MEP in Switchdev */
+	swd_ret = br_cfm_switchdev_cc_peer_mep_remove(br, mep, mepid, extack);
+	if (swd_ret != -EOPNOTSUPP)
+		goto free;
+
+	swd_ret = 0;
 	cc_peer_disable(peer_mep);
 
-	hlist_del_rcu(&peer_mep->head);
+free:
 	kfree_rcu(peer_mep, rcu);
 
-	return 0;
+	return swd_ret;
+}
+
+static int swd_ccm_tx(struct net_bridge *br, struct br_cfm_mep *mep,
+		      struct netlink_ext_ack *extack)
+{
+	struct sk_buff *skb;
+
+	skb = ccm_frame_build(mep, &mep->cc_ccm_tx_info);
+	if (!skb)
+		return -ENOMEM;
+	return br_cfm_switchdev_cc_ccm_tx(br, mep, skb,
+					  mep->cc_ccm_tx_info.period,
+					  mep->cc_config.exp_interval,
+					  extack);
 }
 
 int br_cfm_cc_rdi_set(struct net_bridge *br, const u32 instance,
 		      const bool rdi, struct netlink_ext_ack *extack)
 {
 	struct br_cfm_mep *mep;
+	bool rdi_changed;
+	int swd_ret;
 
 	ASSERT_RTNL();
 
@@ -770,8 +838,18 @@ int br_cfm_cc_rdi_set(struct net_bridge *br, const u32 instance,
 		return -ENOENT;
 	}
 
+	rdi_changed = (mep->rdi != rdi) ? true : false;
 	mep->rdi = rdi;
 
+	if (mep->ccm_tx_swd && rdi_changed) {
+		/* Transmitting using Switchdev is ongoing.
+		 * Restart with new RDI status
+		 */
+		swd_ret = swd_ccm_tx(br, mep, extack);
+		if (swd_ret && swd_ret != -EOPNOTSUPP)
+			return swd_ret;
+	}
+
 	return 0;
 }
 
@@ -780,6 +858,7 @@ int br_cfm_cc_ccm_tx(struct net_bridge *br, const u32 instance,
 		     struct netlink_ext_ack *extack)
 {
 	struct br_cfm_mep *mep;
+	int swd_ret;
 
 	ASSERT_RTNL();
 
@@ -792,11 +871,21 @@ int br_cfm_cc_ccm_tx(struct net_bridge *br, const u32 instance,
 
 	if (memcmp(tx_info, &mep->cc_ccm_tx_info, sizeof(*tx_info)) == 0) {
 		/* No change in tx_info. */
+
 		if (mep->cc_ccm_tx_info.period == 0)
 			/* Transmission is not enabled - just return */
 			return 0;
 
-		/* Transmission is ongoing, the end time is recalculated */
+		/* Transmission is ongoing */
+
+		if (mep->ccm_tx_swd) {
+			/* Switchdev transmission started. Re-start transmission */
+			swd_ret = swd_ccm_tx(br, mep, extack);
+			if (swd_ret && swd_ret != -EOPNOTSUPP)
+				return swd_ret;
+		}
+
+		/* The period end time is recalculated */
 		mep->ccm_tx_end = jiffies +
 				  usecs_to_jiffies(tx_info->period * 1000000);
 		return 0;
@@ -807,9 +896,16 @@ int br_cfm_cc_ccm_tx(struct net_bridge *br, const u32 instance,
 		goto save;
 
 	if (tx_info->period != 0 && mep->cc_ccm_tx_info.period != 0) {
-		/* Some change in info and transmission is ongoing
-		 * The end time is recalculated
-		 */
+		/* Some change in info and transmission is ongoing */
+
+		if (mep->ccm_tx_swd) {
+			/* Switchdev transmission started. Re-start transmission */
+			swd_ret = swd_ccm_tx(br, mep, extack);
+			if (swd_ret && swd_ret != -EOPNOTSUPP)
+				return swd_ret;
+		}
+
+		/* The period end time is recalculated */
 		mep->ccm_tx_end = jiffies +
 				  usecs_to_jiffies(tx_info->period * 1000000);
 
@@ -817,12 +913,31 @@ int br_cfm_cc_ccm_tx(struct net_bridge *br, const u32 instance,
 	}
 
 	if (tx_info->period == 0 && mep->cc_ccm_tx_info.period != 0) {
+		/* Stop transmission */
+
+		/* Try stop transmission in Switchdev */
+		(void)br_cfm_switchdev_cc_ccm_tx(br, mep, NULL, 0, 0, extack);
+
 		cancel_delayed_work_sync(&mep->ccm_tx_dwork);
 		goto save;
 	}
 
-	/* Start delayed work to transmit CCM frames. It is done with zero delay
-	 * to send first frame immediately
+	/* Try start transmitting using Switchdev */
+	swd_ret = swd_ccm_tx(br, mep, extack);
+	if (swd_ret && swd_ret != -EOPNOTSUPP)
+		return swd_ret;
+	if (!swd_ret) {
+		/* Switchdev transmission started */
+		mep->ccm_tx_swd = true;
+		goto save;
+	}
+
+	/* Switchdev CCM tx is not supported */
+	swd_ret = 0;
+	mep->ccm_tx_swd = false;
+
+	/* Start delayed work to transmit CCM frames. It is done with zero
+	 *  delay to send first frame immediately.
 	 */
 	mep->ccm_tx_end = jiffies + usecs_to_jiffies(tx_info->period * 1000000);
 	queue_delayed_work(system_wq, &mep->ccm_tx_dwork, 0);
@@ -830,6 +945,78 @@ int br_cfm_cc_ccm_tx(struct net_bridge *br, const u32 instance,
 save:
 	mep->cc_ccm_tx_info = *tx_info;
 
+	return swd_ret;
+}
+
+int br_cfm_mep_status_get(struct net_bridge *br, const u32 instance,
+			  bool clear, struct br_cfm_mep_status *const status,
+			  struct netlink_ext_ack *extack)
+{
+	struct br_cfm_mep *mep;
+	int swd_ret;
+
+	memset(status, 0, sizeof(*status));
+
+	mep = br_mep_find(br, instance);
+	if (!mep) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "MEP instance does not exists");
+		return -ENOENT;
+	}
+
+	/* Try get MEP status in Switchdev */
+	swd_ret = br_cfm_switchdev_mep_status_get(br, mep, clear, status, extack);
+	if (swd_ret != -EOPNOTSUPP)
+		return swd_ret;
+
+	*status = mep->status;
+	if (clear) {
+		mep->status.opcode_unexp_seen = false;
+		mep->status.version_unexp_seen = false;
+		mep->status.rx_level_low_seen = false;
+	}
+
+	return 0;
+}
+
+int br_cfm_cc_peer_status_get(struct net_bridge *br, const u32 instance,
+			      u32 mepid, bool clear,
+			      struct br_cfm_cc_peer_status *const status,
+			      struct netlink_ext_ack *extack)
+{
+	struct br_cfm_peer_mep *peer_mep;
+	struct br_cfm_mep *mep;
+	int swd_ret;
+
+	memset(status, 0, sizeof(*status));
+
+	mep = br_mep_find(br, instance);
+	if (!mep) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "MEP instance does not exists");
+		return -ENOENT;
+	}
+
+	peer_mep = br_peer_mep_find(mep, mepid);
+	if (!peer_mep) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Peer MEP-ID does not exists");
+		return -ENOENT;
+	}
+
+	/* Try get Peer MEP status in Switchdev */
+	swd_ret = br_cfm_switchdev_cc_peer_status_get(br, mep, mepid, clear,
+						      status, extack);
+	if (swd_ret != -EOPNOTSUPP)
+		return swd_ret;
+
+	*status = peer_mep->cc_status;
+	if (clear) {
+		peer_mep->cc_status.seen = false;
+		peer_mep->cc_status.tlv_seen = false;
+		peer_mep->cc_status.seq_unexp_seen = false;
+	}
+
 	return 0;
 }
 
@@ -878,5 +1065,28 @@ void br_cfm_port_del(struct net_bridge *br, struct net_bridge_port *port)
 
 	hlist_for_each_entry(mep, &br->mep_list, head)
 		if (mep->create.ifindex == port->dev->ifindex)
-			mep_delete_implementation(br, mep);
+			(void)mep_delete_implementation(br, mep, NULL);
+}
+
+/* Notification function called from CFM driver */
+void br_cfm_notification(struct net_device *dev, const struct br_cfm_notif_info *const notif_info)
+{
+	struct net_bridge *br = netdev_priv(dev);
+	struct br_cfm_peer_mep *peer_mep;
+	struct net_bridge_port *b_port;
+	struct br_cfm_mep *mep;
+
+	mep = br_mep_find(br, notif_info->instance);
+	if (!mep)
+		return;
+
+	peer_mep = br_peer_mep_find(mep, notif_info->peer_mep);
+	if (!peer_mep)
+		return;
+
+	rcu_read_lock();
+	b_port = rcu_dereference(mep->b_port);
+	if (b_port)
+		br_cfm_notify(RTM_NEWLINK, b_port);
+	rcu_read_unlock();
 }
diff --git a/net/bridge/br_cfm_netlink.c b/net/bridge/br_cfm_netlink.c
index 5f81262c9caa..3d8561e59ace 100644
--- a/net/bridge/br_cfm_netlink.c
+++ b/net/bridge/br_cfm_netlink.c
@@ -622,42 +622,40 @@ int br_cfm_status_fill_info(struct sk_buff *skb,
 			    struct net_bridge *br,
 			    bool getlink)
 {
-	struct nlattr *tb;
-	struct br_cfm_mep *mep;
+	struct br_cfm_cc_peer_status cc_peer_status;
+	struct br_cfm_mep_status mep_status;
 	struct br_cfm_peer_mep *peer_mep;
+	struct br_cfm_mep *mep;
+	struct nlattr *tb;
 
 	hlist_for_each_entry_rcu(mep, &br->mep_list, head) {
 		tb = nla_nest_start(skb, IFLA_BRIDGE_CFM_MEP_STATUS_INFO);
 		if (!tb)
 			goto nla_info_failure;
 
+		if (br_cfm_mep_status_get(br, mep->instance, getlink,
+					  &mep_status, NULL))
+			goto nla_info_failure;
+
 		if (nla_put_u32(skb, IFLA_BRIDGE_CFM_MEP_STATUS_INSTANCE,
 				mep->instance))
 			goto nla_put_failure;
 
 		if (nla_put_u32(skb,
 				IFLA_BRIDGE_CFM_MEP_STATUS_OPCODE_UNEXP_SEEN,
-				mep->status.opcode_unexp_seen))
+				mep_status.opcode_unexp_seen))
 			goto nla_put_failure;
 
 		if (nla_put_u32(skb,
 				IFLA_BRIDGE_CFM_MEP_STATUS_VERSION_UNEXP_SEEN,
-				mep->status.version_unexp_seen))
+				mep_status.version_unexp_seen))
 			goto nla_put_failure;
 
 		if (nla_put_u32(skb,
 				IFLA_BRIDGE_CFM_MEP_STATUS_RX_LEVEL_LOW_SEEN,
-				mep->status.rx_level_low_seen))
+				mep_status.rx_level_low_seen))
 			goto nla_put_failure;
 
-		/* Only clear if this is a GETLINK */
-		if (getlink) {
-			/* Clear all 'seen' indications */
-			mep->status.opcode_unexp_seen = false;
-			mep->status.version_unexp_seen = false;
-			mep->status.rx_level_low_seen = false;
-		}
-
 		nla_nest_end(skb, tb);
 
 		hlist_for_each_entry_rcu(peer_mep, &mep->peer_mep_list, head) {
@@ -666,6 +664,12 @@ int br_cfm_status_fill_info(struct sk_buff *skb,
 			if (!tb)
 				goto nla_info_failure;
 
+			if (br_cfm_cc_peer_status_get(br, mep->instance,
+						      peer_mep->mepid,
+						      getlink,
+						      &cc_peer_status, NULL))
+				goto nla_info_failure;
+
 			if (nla_put_u32(skb,
 					IFLA_BRIDGE_CFM_CC_PEER_STATUS_INSTANCE,
 					mep->instance))
@@ -678,45 +682,38 @@ int br_cfm_status_fill_info(struct sk_buff *skb,
 
 			if (nla_put_u32(skb,
 					IFLA_BRIDGE_CFM_CC_PEER_STATUS_CCM_DEFECT,
-					peer_mep->cc_status.ccm_defect))
+					cc_peer_status.ccm_defect))
 				goto nla_put_failure;
 
 			if (nla_put_u32(skb, IFLA_BRIDGE_CFM_CC_PEER_STATUS_RDI,
-					peer_mep->cc_status.rdi))
+					cc_peer_status.rdi))
 				goto nla_put_failure;
 
 			if (nla_put_u8(skb,
 				       IFLA_BRIDGE_CFM_CC_PEER_STATUS_PORT_TLV_VALUE,
-				       peer_mep->cc_status.port_tlv_value))
+				       cc_peer_status.port_tlv_value))
 				goto nla_put_failure;
 
 			if (nla_put_u8(skb,
 				       IFLA_BRIDGE_CFM_CC_PEER_STATUS_IF_TLV_VALUE,
-				       peer_mep->cc_status.if_tlv_value))
+				       cc_peer_status.if_tlv_value))
 				goto nla_put_failure;
 
 			if (nla_put_u32(skb,
 					IFLA_BRIDGE_CFM_CC_PEER_STATUS_SEEN,
-					peer_mep->cc_status.seen))
+					cc_peer_status.seen))
 				goto nla_put_failure;
 
 			if (nla_put_u32(skb,
 					IFLA_BRIDGE_CFM_CC_PEER_STATUS_TLV_SEEN,
-					peer_mep->cc_status.tlv_seen))
+					cc_peer_status.tlv_seen))
 				goto nla_put_failure;
 
 			if (nla_put_u32(skb,
 					IFLA_BRIDGE_CFM_CC_PEER_STATUS_SEQ_UNEXP_SEEN,
-					peer_mep->cc_status.seq_unexp_seen))
+					cc_peer_status.seq_unexp_seen))
 				goto nla_put_failure;
 
-			if (getlink) { /* Only clear if this is a GETLINK */
-				/* Clear all 'seen' indications */
-				peer_mep->cc_status.seen = false;
-				peer_mep->cc_status.tlv_seen = false;
-				peer_mep->cc_status.seq_unexp_seen = false;
-			}
-
 			nla_nest_end(skb, tb);
 		}
 	}
diff --git a/net/bridge/br_cfm_switchdev.c b/net/bridge/br_cfm_switchdev.c
new file mode 100644
index 000000000000..d7441d57d113
--- /dev/null
+++ b/net/bridge/br_cfm_switchdev.c
@@ -0,0 +1,203 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#include <net/switchdev.h>
+
+#include "br_private_cfm.h"
+
+int br_cfm_switchdev_mep_create(struct net_bridge *br,
+				const u32 instance,
+				struct br_cfm_mep_create *const create,
+				struct netlink_ext_ack *extack)
+{
+	struct switchdev_obj_cfm_mep cfm_obj;
+	struct net_bridge_port *port;
+	bool found = false;
+
+	list_for_each_entry(port, &br->port_list, list)
+		if (port->dev->ifindex == create->ifindex) {
+			found = true;
+			break;
+		}
+	if (!found)
+		return -EINVAL;
+
+	cfm_obj.obj.orig_dev = br->dev;
+	cfm_obj.obj.id = SWITCHDEV_OBJ_ID_MEP_CFM;
+	cfm_obj.obj.flags = 0;
+	cfm_obj.domain = create->domain;
+	cfm_obj.direction = create->direction;
+	cfm_obj.port = port->dev;
+
+	return switchdev_port_obj_add(br->dev, &cfm_obj.obj, extack);
+}
+
+int br_cfm_switchdev_mep_delete(struct net_bridge *br,
+				struct br_cfm_mep *mep,
+				struct netlink_ext_ack *extack)
+{
+	struct switchdev_obj_cfm_mep cfm_obj = {
+		.obj.orig_dev = br->dev,
+		.obj.id = SWITCHDEV_OBJ_ID_MEP_CFM,
+		.obj.flags = 0,
+		.domain = 0,
+		.direction = 0,
+		.port = NULL,
+	};
+
+	return switchdev_port_obj_del(br->dev, &cfm_obj.obj);
+}
+
+int br_cfm_switchdev_mep_config_set(struct net_bridge *br,
+				    struct br_cfm_mep *mep,
+				    const struct br_cfm_mep_config *const config,
+				    struct netlink_ext_ack *extack)
+{
+	struct switchdev_obj_cfm_mep_config_set cfm_obj = {
+		.obj.orig_dev = br->dev,
+		.obj.id = SWITCHDEV_OBJ_ID_MEP_CONFIG_CFM,
+		.obj.flags = 0,
+		.instance = mep->instance,
+		.unicast_mac = config->unicast_mac,
+		.mdlevel = config->mdlevel,
+		.mepid = config->mepid,
+	};
+
+	return switchdev_port_obj_add(br->dev, &cfm_obj.obj, extack);
+}
+
+int br_cfm_switchdev_cc_config_set(struct net_bridge *br,
+				   struct br_cfm_mep *mep,
+				   const struct br_cfm_cc_config *const config,
+				   struct netlink_ext_ack *extack)
+{
+	struct switchdev_obj_cfm_cc_config_set cfm_obj = {
+		.obj.orig_dev = br->dev,
+		.obj.id = SWITCHDEV_OBJ_ID_CC_CONFIG_CFM,
+		.obj.flags = 0,
+		.instance = mep->instance,
+		.interval = config->exp_interval,
+		.maid = config->exp_maid,
+		.enable = config->enable,
+	};
+
+	return switchdev_port_obj_add(br->dev, &cfm_obj.obj, extack);
+}
+
+int br_cfm_switchdev_cc_peer_mep_add(struct net_bridge *br,
+				     struct br_cfm_mep *mep,
+				     u32 peer_mep_id,
+				     struct netlink_ext_ack *extack)
+{
+	struct switchdev_obj_cfm_cc_peer_mep cfm_obj = {
+		.obj.orig_dev = br->dev,
+		.obj.id = SWITCHDEV_OBJ_ID_CC_PEER_MEP_CFM,
+		.obj.flags = 0,
+		.instance = mep->instance,
+		.peer_mep_id = peer_mep_id,
+	};
+
+	return switchdev_port_obj_add(br->dev, &cfm_obj.obj, extack);
+}
+
+int br_cfm_switchdev_cc_peer_mep_remove(struct net_bridge *br,
+					struct br_cfm_mep *mep,
+					u32 peer_mep_id,
+					struct netlink_ext_ack *extack)
+{
+	struct switchdev_obj_cfm_cc_peer_mep cfm_obj = {
+		.obj.orig_dev = br->dev,
+		.obj.id = SWITCHDEV_OBJ_ID_CC_PEER_MEP_CFM,
+		.obj.flags = 0,
+		.instance = mep->instance,
+		.peer_mep_id = peer_mep_id,
+	};
+
+	return switchdev_port_obj_del(br->dev, &cfm_obj.obj);
+}
+
+int br_cfm_switchdev_cc_ccm_tx(struct net_bridge *br,
+			       struct br_cfm_mep *mep,
+			       struct sk_buff *skb,
+			       u32 period,
+			       enum br_cfm_ccm_interval interval,
+			       struct netlink_ext_ack *extack)
+{
+	struct switchdev_obj_cfm_cc_ccm_tx cfm_obj = {
+		.obj.orig_dev = br->dev,
+		.obj.id = SWITCHDEV_OBJ_ID_CC_CCM_TX_CFM,
+		.obj.flags = 0,
+		.instance = mep->instance,
+		.skb = skb,
+		.interval = interval,
+		.period = period,
+	};
+
+	return switchdev_port_obj_add(br->dev, &cfm_obj.obj, extack);
+}
+
+int br_cfm_switchdev_mep_status_get(struct net_bridge *br,
+				    struct br_cfm_mep *mep,
+				    bool   clear,
+				    struct br_cfm_mep_status *const status,
+				    struct netlink_ext_ack *extack)
+{
+	struct switchdev_obj_cfm_mep_status_get cfm_obj = {
+		.obj.orig_dev = br->dev,
+		.obj.id = SWITCHDEV_OBJ_ID_MEP_STATUS_CFM,
+		.obj.flags = 0,
+		.instance = mep->instance,
+		.clear = clear,
+		.opcode_unexp_seen = false,
+		.version_unexp_seen = false,
+		.rx_level_low_seen = false,
+	};
+	int err;
+
+	err = switchdev_port_obj_get(br->dev, &cfm_obj.obj, extack);
+	if (err)
+		return err;
+
+	status->opcode_unexp_seen = cfm_obj.opcode_unexp_seen;
+	status->version_unexp_seen = cfm_obj.version_unexp_seen;
+	status->rx_level_low_seen = cfm_obj.rx_level_low_seen;
+
+	return 0;
+}
+
+int br_cfm_switchdev_cc_peer_status_get(struct net_bridge *br,
+					struct br_cfm_mep *mep,
+					u32 peer_mep_id,
+					bool clear,
+					struct br_cfm_cc_peer_status *const status,
+					struct netlink_ext_ack *extack)
+{
+	struct switchdev_obj_cfm_cc_peer_status_get cfm_obj = {
+		.obj.orig_dev = br->dev,
+		.obj.id = SWITCHDEV_OBJ_ID_PEER_MEP_STATUS_CFM,
+		.obj.flags = 0,
+		.instance = mep->instance,
+		.clear = clear,
+		.port_tlv_value = 0,
+		.if_tlv_value = 0,
+		.ccm_defect = false,
+		.rdi = false,
+		.seen = false,
+		.tlv_seen = false,
+		.seq_unexp_seen = false,
+	};
+	int err;
+
+	err = switchdev_port_obj_get(br->dev, &cfm_obj.obj, extack);
+	if (err)
+		return err;
+
+	status->port_tlv_value = cfm_obj.port_tlv_value;
+	status->if_tlv_value = cfm_obj.if_tlv_value;
+	status->ccm_defect = cfm_obj.ccm_defect;
+	status->rdi = cfm_obj.rdi;
+	status->seen = cfm_obj.seen;
+	status->tlv_seen = cfm_obj.tlv_seen;
+	status->seq_unexp_seen = cfm_obj.seq_unexp_seen;
+
+	return 0;
+}
diff --git a/net/bridge/br_private_cfm.h b/net/bridge/br_private_cfm.h
index 6a2294c0ea79..a91d0b59c27f 100644
--- a/net/bridge/br_private_cfm.h
+++ b/net/bridge/br_private_cfm.h
@@ -6,6 +6,7 @@
 #include "br_private.h"
 #include <uapi/linux/cfm_bridge.h>
 
+/* br_cfm.c */
 struct br_cfm_mep_create {
 	enum br_cfm_domain domain; /* Domain for this MEP */
 	enum br_cfm_mep_direction direction; /* Up or Down MEP direction */
@@ -55,13 +56,13 @@ int br_cfm_cc_config_set(struct net_bridge *br,
 int br_cfm_cc_peer_mep_add(struct net_bridge *br, const u32 instance,
 			   u32 peer_mep_id,
 			   struct netlink_ext_ack *extack);
+
 int br_cfm_cc_peer_mep_remove(struct net_bridge *br, const u32 instance,
 			      u32 peer_mep_id,
 			      struct netlink_ext_ack *extack);
 
 /* Transmitted CCM Remote Defect Indication status set.
  * This RDI is inserted in transmitted CCM PDUs if CCM transmission is enabled.
- * See br_cfm_cc_ccm_tx() with interval != BR_CFM_CCM_INTERVAL_NONE
  */
 int br_cfm_cc_rdi_set(struct net_bridge *br, const u32 instance,
 		      const bool rdi, struct netlink_ext_ack *extack);
@@ -96,6 +97,10 @@ struct br_cfm_mep_status {
 	bool rx_level_low_seen; /* Rx of OAM PDU with level low */
 };
 
+int br_cfm_mep_status_get(struct net_bridge *br, const u32 instance,
+			  bool clear, struct br_cfm_mep_status *const status,
+			  struct netlink_ext_ack *extack);
+
 struct br_cfm_cc_peer_status {
 	/* This CCM related status is based on the latest received CCM PDU. */
 	u8 port_tlv_value; /* Port Status TLV value */
@@ -114,6 +119,11 @@ struct br_cfm_cc_peer_status {
 	bool seq_unexp_seen;
 };
 
+int br_cfm_cc_peer_status_get(struct net_bridge *br, const u32 instance,
+			      u32 mepid, bool clear,
+			      struct br_cfm_cc_peer_status *const status,
+			      struct netlink_ext_ack *extack);
+
 struct br_cfm_mep {
 	/* list header of MEP instances */
 	struct hlist_node		head;
@@ -131,6 +141,7 @@ struct br_cfm_mep {
 	u32				ccm_rx_snumber;
 	struct br_cfm_mep_status	status;
 	bool				rdi;
+	bool				ccm_tx_swd;
 	struct rcu_head			rcu;
 };
 
@@ -144,4 +155,54 @@ struct br_cfm_peer_mep {
 	struct rcu_head			rcu;
 };
 
+/* br_cfm_switchdev.c */
+int br_cfm_switchdev_mep_create(struct net_bridge *br,
+				const u32 instance,
+				struct br_cfm_mep_create *const create,
+				struct netlink_ext_ack *extack);
+
+int br_cfm_switchdev_mep_delete(struct net_bridge *br,
+				struct br_cfm_mep *mep,
+				struct netlink_ext_ack *extack);
+
+int br_cfm_switchdev_mep_config_set(struct net_bridge *br,
+				    struct br_cfm_mep *mep,
+				    const struct br_cfm_mep_config *const config,
+				    struct netlink_ext_ack *extack);
+
+int br_cfm_switchdev_cc_config_set(struct net_bridge *br,
+				   struct br_cfm_mep *mep,
+				   const struct br_cfm_cc_config *const config,
+				   struct netlink_ext_ack *extack);
+
+int br_cfm_switchdev_cc_peer_mep_add(struct net_bridge *br,
+				     struct br_cfm_mep *mep,
+				     u32 peer_mep_id,
+				     struct netlink_ext_ack *extack);
+
+int br_cfm_switchdev_cc_peer_mep_remove(struct net_bridge *br,
+					struct br_cfm_mep *mep,
+					u32 peer_mep_id,
+					struct netlink_ext_ack *extack);
+
+int br_cfm_switchdev_cc_ccm_tx(struct net_bridge *br,
+			       struct br_cfm_mep *mep,
+			       struct sk_buff *skb,
+			       u32 period,
+			       enum br_cfm_ccm_interval interval,
+			       struct netlink_ext_ack *extack);
+
+int br_cfm_switchdev_mep_status_get(struct net_bridge *br,
+				    struct br_cfm_mep *mep,
+				    bool   clear,
+				    struct br_cfm_mep_status *const status,
+				    struct netlink_ext_ack *extack);
+
+int br_cfm_switchdev_cc_peer_status_get(struct net_bridge *br,
+					struct br_cfm_mep *mep,
+					u32 peer_mep_id,
+					bool clear,
+					struct br_cfm_cc_peer_status *const status,
+					struct netlink_ext_ack *extack);
+
 #endif /* _BR_PRIVATE_CFM_H_ */
-- 
2.28.0

