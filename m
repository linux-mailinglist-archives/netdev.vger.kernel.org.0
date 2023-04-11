Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6FDF6DE3DC
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 20:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbjDKS1e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 14:27:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbjDKS1b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 14:27:31 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2055.outbound.protection.outlook.com [40.107.220.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09F7B46BB
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 11:27:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W5QNjp41g3rECI8d1cx/P2lmU92XCuo/GqCS4CRdNP7n3jyXRnpG7fftRJ+baa56Gutw/bCNLfSzmS4BI7KUzz8zsjUelUa6XvVpzRwjUHC3mAmuhqHuZMFUw3BtbGRX81858WzSuHzhmjhSqHMn9G+iIOzsMhYzxnMlWN/dhY7FKkGQVLDJq/Z0DfpFYCRi1dcIfDZrGGVy1gEw3QCETPr7J1B/5dY6aEwcQXUspCnV7uLsECiPCuGEWl1oYaoBJWQgxyQt+paqTl8pp0M2WKWQqyDkCc27WzQfcx2NoSH77+Lt1/IABsLViAl4oH8amZlooFQ/6rjD/CuiBKLU/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ysWSIOuN6Y4oAbixs4Whwt1wQMfdBH+3i09ZT+3ex8I=;
 b=P8VdAbA5IUO+owN7sCAmL5j4ePLphJ8VX88yqGhFsF1POlpvoj/R91KkUiwDjfKMmpxG7McbH9KmT98uyfDzLI6zJqIgUiMaG8ghCbRRTX2dmQcqilb8GvjnqvqlPKot+haoEKJdsu1r0ktlmuWg6hYObto3ulANYBgJxheOb9UZwaKM1NfCJ+0pT4VWJraq5tZRp6qhHV+wa1KFZoHNgJ2v3qRusPcKLwGR3rAVw6YQIhfKrf7ypKbK81BMBGrTizMFRDJZAQcBUs0CwNVpqXem08y7uxbHxp/svAfkVVBFzrJNuDWed5VqsL98ie0CPYUZt3y+Kv9XqsUo6J226A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ysWSIOuN6Y4oAbixs4Whwt1wQMfdBH+3i09ZT+3ex8I=;
 b=AGLoB0SuDoXj5LvlHyO9bnM/UaDe8a7yW8d/CY2KOvtC9pBAnHeQrqKJ1ZRZSu+ItZw4n4ina16ObZe6MQpZbRPCTNFqv5Yfkx54/iVi3+kGjca2u/vHsQ1HTyowwVAD5RB52g3JvGWTmyiF0PGhPvbcMlyJhal4YRBNNEhbrms=
Received: from DM5PR07CA0083.namprd07.prod.outlook.com (2603:10b6:4:ad::48) by
 SJ0PR12MB7005.namprd12.prod.outlook.com (2603:10b6:a03:486::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.36; Tue, 11 Apr
 2023 18:27:24 +0000
Received: from DM6NAM11FT104.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:ad:cafe::76) by DM5PR07CA0083.outlook.office365.com
 (2603:10b6:4:ad::48) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38 via Frontend
 Transport; Tue, 11 Apr 2023 18:27:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT104.mail.protection.outlook.com (10.13.173.232) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6298.29 via Frontend Transport; Tue, 11 Apr 2023 18:27:23 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 11 Apr
 2023 13:27:22 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34 via Frontend
 Transport; Tue, 11 Apr 2023 13:27:21 -0500
From:   <edward.cree@amd.com>
To:     <linux-net-drivers@amd.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@google.com>
CC:     Edward Cree <ecree.xilinx@gmail.com>, <netdev@vger.kernel.org>,
        <habetsm.xilinx@gmail.com>, <sudheer.mogilappagari@intel.com>
Subject: [RFC PATCH v2 net-next 1/7] net: move ethtool-related netdev state into its own struct
Date:   Tue, 11 Apr 2023 19:26:09 +0100
Message-ID: <7437d841fe416119199104ec334bf07cd285c9b5.1681236653.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1681236653.git.ecree.xilinx@gmail.com>
References: <cover.1681236653.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT104:EE_|SJ0PR12MB7005:EE_
X-MS-Office365-Filtering-Correlation-Id: 1481b062-d0bb-4b34-d82d-08db3aba64e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bC70tqsFGrZ7IHVuSuwjOC8D193aXz1rF06C3eVt7TMaa+bgBdiu/0FBeMp4gE9ZbfB3DC3JisJBHSrv1fQcPSR3tJUd6qFXAcLCIDNDCVar8lwbsCfnxhrH+BOLyp1M6VW3O7kxC9aJTnXFBlyXfElp9TRW7GJrRdZ28F+gwrgJDPXXfIyPFMTDBkVi9nAhKT2kNy8Oey7cP8hFGTCo58nDp1z7Ew7gGKvpGJKh14S4rFGeRox9h6ofNnrkXGKZv/xQnW+AvS7Zwus0MS3xR12Hys9f6T//WtDYg2gFyBEDPib7D1DRv0YUGpEr1hKtmJdm5/U2KxxA8vq/CpzNf/esZ0MgLx5epM7Kisx20xLMCOfmp5t0tc+cTHZc6pzHnI23IQZInW76E9ICS3rb5wLAQcxhUonU4I0LxFx/tVm7vwi0xQDwWDnrvuDnU4rPIO24CHtKOZzGgaytGlymgRm3T6v6OoBhHhE2d2XpV6yKMgM1m2Rpp5fZnUGC6nhMVdAZ3+bGfsI3wwcbjAFXQ1PYqzJI90kwkOvE6pIe22IAvBnJagPHNqBKsqgOGZLi1TWVK1dYerFBYajIDmrY3axs6aoVszgl42QvLe25ew2WuRAApyhYwRkuJv/r2HqFAdAgCsecG0AOVB3LFxKqPp1+mVCA0rJ3mr/i/hws5pYlYRPVT5iApQlXwchAfoVMCxZgYmflJ090bfoxMgU1pKedojazFrZcfzn9i8mL0T8zzHcf47+XPtUpyfhHm7Ab
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(376002)(39860400002)(136003)(451199021)(36840700001)(40470700004)(46966006)(55446002)(2906002)(86362001)(36756003)(82310400005)(2876002)(40480700001)(6666004)(336012)(36860700001)(83380400001)(47076005)(426003)(186003)(26005)(9686003)(478600001)(81166007)(70586007)(4326008)(70206006)(110136005)(40460700003)(82740400003)(316002)(41300700001)(356005)(8676002)(8936002)(54906003)(5660300002)(36900700001)(309714004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 18:27:23.3650
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1481b062-d0bb-4b34-d82d-08db3aba64e9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT104.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7005
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree.xilinx@gmail.com>

net_dev->ethtool is a pointer to new struct ethtool_netdev_state, which
 currently contains only the wol_enabled field.

Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
Changes in v2: New patch.
---
 drivers/net/ethernet/realtek/r8169_main.c | 4 ++--
 drivers/net/phy/phy.c                     | 2 +-
 drivers/net/phy/phy_device.c              | 4 ++--
 drivers/net/phy/phylink.c                 | 2 +-
 include/linux/ethtool.h                   | 8 ++++++++
 include/linux/netdevice.h                 | 7 ++++---
 net/core/dev.c                            | 4 ++++
 net/ethtool/ioctl.c                       | 2 +-
 net/ethtool/wol.c                         | 2 +-
 9 files changed, 24 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 9f8357bbc8a4..356f43fac74f 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -1451,7 +1451,7 @@ static void __rtl8169_set_wol(struct rtl8169_private *tp, u32 wolopts)
 
 	if (tp->dash_type == RTL_DASH_NONE) {
 		rtl_set_d3_pll_down(tp, !wolopts);
-		tp->dev->wol_enabled = wolopts ? 1 : 0;
+		tp->dev->ethtool->wol_enabled = wolopts ? 1 : 0;
 	}
 }
 
@@ -5330,7 +5330,7 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		rtl_set_d3_pll_down(tp, true);
 	} else {
 		rtl_set_d3_pll_down(tp, false);
-		dev->wol_enabled = 1;
+		dev->ethtool->wol_enabled = 1;
 	}
 
 	jumbo_max = rtl_jumbo_max(tp);
diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 0c0df38cd1ab..2d8307e9c351 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -1245,7 +1245,7 @@ static irqreturn_t phy_interrupt(int irq, void *phy_dat)
 		if (netdev) {
 			struct device *parent = netdev->dev.parent;
 
-			if (netdev->wol_enabled)
+			if (netdev->ethtool->wol_enabled)
 				pm_system_wakeup();
 			else if (device_may_wakeup(&netdev->dev))
 				pm_wakeup_dev_event(&netdev->dev, 0, true);
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 917ba84105fc..535002e75dc5 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -281,7 +281,7 @@ static bool mdio_bus_phy_may_suspend(struct phy_device *phydev)
 	if (!netdev)
 		goto out;
 
-	if (netdev->wol_enabled)
+	if (netdev->ethtool->wol_enabled)
 		return false;
 
 	/* As long as not all affected network drivers support the
@@ -1859,7 +1859,7 @@ int phy_suspend(struct phy_device *phydev)
 
 	/* If the device has WOL enabled, we cannot suspend the PHY */
 	phy_ethtool_get_wol(phydev, &wol);
-	if (wol.wolopts || (netdev && netdev->wol_enabled))
+	if (wol.wolopts || (netdev && netdev->ethtool->wol_enabled))
 		return -EBUSY;
 
 	if (!phydrv || !phydrv->suspend)
diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index f7da96f0c75b..c332d8950f01 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -2005,7 +2005,7 @@ void phylink_suspend(struct phylink *pl, bool mac_wol)
 {
 	ASSERT_RTNL();
 
-	if (mac_wol && (!pl->netdev || pl->netdev->wol_enabled)) {
+	if (mac_wol && (!pl->netdev || pl->netdev->ethtool->wol_enabled)) {
 		/* Wake-on-Lan enabled, MAC handling */
 		mutex_lock(&pl->state_mutex);
 
diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 798d35890118..c73b28df301c 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -934,6 +934,14 @@ int ethtool_virtdev_set_link_ksettings(struct net_device *dev,
 				       const struct ethtool_link_ksettings *cmd,
 				       u32 *dev_speed, u8 *dev_duplex);
 
+/**
+ * struct ethtool_netdev_state - per-netdevice state for ethtool features
+ * @wol_enabled:	Wake-on-LAN is enabled
+ */
+struct ethtool_netdev_state {
+	unsigned		wol_enabled:1;
+};
+
 struct phy_device;
 struct phy_tdr_config;
 struct phy_plca_cfg;
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index a740be3bb911..1915a6221096 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -77,6 +77,7 @@ struct udp_tunnel_nic;
 struct bpf_prog;
 struct xdp_buff;
 struct xdp_md;
+struct ethtool_netdev_state;
 
 void synchronize_net(void);
 void netdev_set_default_ethtool_ops(struct net_device *dev,
@@ -2015,8 +2016,6 @@ enum netdev_ml_priv_type {
  *			switch driver and used to set the phys state of the
  *			switch port.
  *
- *	@wol_enabled:	Wake-on-LAN is enabled
- *
  *	@threaded:	napi threaded mode is enabled
  *
  *	@net_notifier_list:	List of per-net netdev notifier block
@@ -2028,6 +2027,7 @@ enum netdev_ml_priv_type {
  *	@udp_tunnel_nic_info:	static structure describing the UDP tunnel
  *				offload capabilities of the device
  *	@udp_tunnel_nic:	UDP tunnel offload state
+ *	@ethtool:	ethtool related state
  *	@xdp_state:		stores info on attached XDP BPF programs
  *
  *	@nested_level:	Used as a parameter of spin_lock_nested() of
@@ -2385,7 +2385,6 @@ struct net_device {
 	struct sfp_bus		*sfp_bus;
 	struct lock_class_key	*qdisc_tx_busylock;
 	bool			proto_down;
-	unsigned		wol_enabled:1;
 	unsigned		threaded:1;
 
 	struct list_head	net_notifier_list;
@@ -2397,6 +2396,8 @@ struct net_device {
 	const struct udp_tunnel_nic_info	*udp_tunnel_nic_info;
 	struct udp_tunnel_nic	*udp_tunnel_nic;
 
+	struct ethtool_netdev_state *ethtool;
+
 	/* protected by rtnl_lock */
 	struct bpf_xdp_entity	xdp_state[__MAX_XDP_MODE];
 
diff --git a/net/core/dev.c b/net/core/dev.c
index 7ce5985be84b..93960861a11f 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10676,6 +10676,9 @@ struct net_device *alloc_netdev_mqs(int sizeof_priv, const char *name,
 	dev->real_num_rx_queues = rxqs;
 	if (netif_alloc_rx_queues(dev))
 		goto free_all;
+	dev->ethtool = kzalloc(sizeof(*dev->ethtool), GFP_KERNEL_ACCOUNT);
+	if (!dev->ethtool)
+		goto free_all;
 
 	strcpy(dev->name, name);
 	dev->name_assign_type = name_assign_type;
@@ -10726,6 +10729,7 @@ void free_netdev(struct net_device *dev)
 		return;
 	}
 
+	kfree(dev->ethtool);
 	netif_free_tx_queues(dev);
 	netif_free_rx_queues(dev);
 
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 59adc4e6e9ee..0effaca4ff9e 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -1449,7 +1449,7 @@ static int ethtool_set_wol(struct net_device *dev, char __user *useraddr)
 	if (ret)
 		return ret;
 
-	dev->wol_enabled = !!wol.wolopts;
+	dev->ethtool->wol_enabled = !!wol.wolopts;
 	ethtool_notify(dev, ETHTOOL_MSG_WOL_NTF, NULL);
 
 	return 0;
diff --git a/net/ethtool/wol.c b/net/ethtool/wol.c
index a4a43d9e6e9d..820578b70073 100644
--- a/net/ethtool/wol.c
+++ b/net/ethtool/wol.c
@@ -136,7 +136,7 @@ ethnl_set_wol(struct ethnl_req_info *req_info, struct genl_info *info)
 	ret = dev->ethtool_ops->set_wol(dev, &wol);
 	if (ret)
 		return ret;
-	dev->wol_enabled = !!wol.wolopts;
+	dev->ethtool->wol_enabled = !!wol.wolopts;
 	return 1;
 }
 
