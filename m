Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C9F3398939
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 14:17:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbhFBMTf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 08:19:35 -0400
Received: from mail-bn8nam08on2040.outbound.protection.outlook.com ([40.107.100.40]:29857
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229938AbhFBMTc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 08:19:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DMzDrZICNoiD5+sgtp9e7y4OMxzvn/zyOZGV8VJ+2p9aCDx38c7uvQBbj4/KwffqIAFmLMRGEP9Am1haRsZEYyUzoMoPpSt80FRdCh55LOqsoWYikK/wSLY+0tuh9FabEtwvmIDiMfo1VS16DJzw7ZEj8N81vsD0Ye6RpVha894Za96VaXttwfJzFLACNHUuPGggViEydagZKWkxEaDp0tq3M5ayfY7HLiKueZ6p1V1N4Eos4fYm1ZkG5BttrNFGOO9Ov+KRJ1ccRS7nnVCn0Bm9VFbp2Ms1pF7YnnQ0YNuUMLJ8ZN0OkrI+e2RXSsmTkjfSlSZF/RN3GMy/fKjtTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pb5rOyXCWA4y7OrW2JBMT1Cbso6REtZqTl3fzfq51BM=;
 b=EW959ovj90po9mXObE6QnK0LTjH0O2J2gFyBsMNjF/xzAujq8r8nuVb/aWsBM/VcvqUEBaupYe1ufokmCM19glXXEJqx935nv5zOFOZroNcxLgfgAh/1lxZGlbeMeY7RXUrfYG85DNZf7g290zMI2wPTVGReNPYYLHE+Ih37PXY0wjfsw78gxSy5NtIF8W5G5/+eRp8qoJeHw3HGxtu0rBDBY2zJE9gD8vmTvOzqOu+Qrj4NRCSWo778Bey12p2XKqD6Ih1P9+Lmshve2B3OChu00oXrJfjVKkR39VtqDOkBrr7W6jEc0wEkWRiM+EpbufCk6yfXQinETq5Q0ajyjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pb5rOyXCWA4y7OrW2JBMT1Cbso6REtZqTl3fzfq51BM=;
 b=KhJcxLMWqoSJu+qm0EyOfP6xoD40E23jvTJk3O4lWL8l83dv6jEivRIYzD9pt0/PON/jcrmDgUpsZjIhyXQpzvZUHiN6ig1KyKPr3jXGi/BQmG9hqAM/YBkcO0xR3TvThBm31il3t/lim3PJqOu8c6MAjy+74Z5CXJvUjOPP3WIcXGELYnkzhMiPX0rsPaPe5AOQvoCm/WES3o8dXeI3J4pJNnHbgTpVjShxT6IZPhGz8GmpRsJ11dctPUiCuTr/HsmiePDtSBcoIqZqfTqNrHPsD9S/8DIHzy1O5c2PsTtliUUgw0kgPdvzMY6P6M5c39s52ao5RoI43JYZiOUFhg==
Received: from MW4PR04CA0340.namprd04.prod.outlook.com (2603:10b6:303:8a::15)
 by CY4PR12MB1191.namprd12.prod.outlook.com (2603:10b6:903:44::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Wed, 2 Jun
 2021 12:17:48 +0000
Received: from CO1NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8a:cafe::6) by MW4PR04CA0340.outlook.office365.com
 (2603:10b6:303:8a::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22 via Frontend
 Transport; Wed, 2 Jun 2021 12:17:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 CO1NAM11FT010.mail.protection.outlook.com (10.13.175.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4150.30 via Frontend Transport; Wed, 2 Jun 2021 12:17:47 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 2 Jun
 2021 12:17:47 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 2 Jun
 2021 12:17:46 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 2 Jun 2021 05:17:44 -0700
From:   <dlinkin@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <stephen@networkplumber.org>, <dsahern@gmail.com>,
        <vladbu@nvidia.com>, <parav@nvidia.com>, <huyn@nvidia.com>,
        Dmytro Linkin <dlinkin@nvidia.com>
Subject: [PATCH RESEND net-next v3 04/18] netdevsim: Implement VFs
Date:   Wed, 2 Jun 2021 15:17:17 +0300
Message-ID: <1622636251-29892-5-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1622636251-29892-1-git-send-email-dlinkin@nvidia.com>
References: <1622636251-29892-1-git-send-email-dlinkin@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e673534a-aaeb-4006-c3d9-08d925c06f2c
X-MS-TrafficTypeDiagnostic: CY4PR12MB1191:
X-Microsoft-Antispam-PRVS: <CY4PR12MB11911D17E2995113F3CEC104CB3D9@CY4PR12MB1191.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2512;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ro+faKVJ92TvNAAkiMQKBhQ6TJ7XjPE6H+SRy08LFuzbwmojMl/L4eU/RoS1PPJLl++5LdUuVJZZvzFJMOk06Dr5pJ2DdqnrSlBv7w5iTLvTkrwd2UXEV/DBmZQd5/Rw1lzHVFKpovY2w/OmB0X+sHBD6ilaErhsBomz+VWUWbnlbasa+y3/5uJiMJaJ+bhpxriTChRZMiOXpOiv2DFNMllimhtoFgzJNMtFJdRDM7TixT2HldE+A4ktGjN+WL9HWAEucaZctHNKQ+TSUmIXJIf/MiLfGxV9HJix6jWkA4CEe2Lh1DANABanDigzVOsmmZk7iLEDEvBKzhxULY6AzyMm6355ySHNs5Qjli+B9ohi0m4p0v9xdcAwJa8FE77gaXyxc2ARAP6qO4u2SLlFlXFt3bJ5V03bKeUpJ0XdQHMUPN6jDcX1DYJHzSxB41xliPrr/+VEN7jK36qoxVMdrziwVMfpUhCglPT55q/usXP5OevUps1SArXwdKZVeaxMwxwMSqYb/ep3B2MOw6GayffAo+7tduWnA3tf3/QczaN5CV3zEmijOO8gznyErI3pmh4vm3dsFwR689xrag1NeFWHTLDBXqLAXbIs5Syr2Y833bdzFCTe+XOKE/9FHFD9OhoMZtvwIp4bt++OtTQK/A==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(39860400002)(376002)(346002)(136003)(36840700001)(46966006)(6916009)(2906002)(2876002)(186003)(86362001)(47076005)(36756003)(36860700001)(356005)(7636003)(82740400003)(6666004)(54906003)(4326008)(82310400003)(36906005)(8676002)(5660300002)(107886003)(8936002)(426003)(2616005)(26005)(70206006)(70586007)(83380400001)(478600001)(316002)(336012)(7696005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 12:17:47.7749
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e673534a-aaeb-4006-c3d9-08d925c06f2c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1191
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmytro Linkin <dlinkin@nvidia.com>

Allow creation of netdevsim ports for VFs along with allocations of
corresponding net devices and devlink ports.
Add enums and helpers to distinguish PFs' ports from VFs' ports.

Ports creation/deletion debugfs API intended to be used with physical
ports only.
VFs instantiation will be done in one of the next patches.

Signed-off-by: Dmytro Linkin <dlinkin@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/netdevsim/dev.c    | 14 ++++++-
 drivers/net/netdevsim/netdev.c | 90 ++++++++++++++++++++++++++++++------------
 2 files changed, 77 insertions(+), 27 deletions(-)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 93d6f3d..8bd7654 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -945,11 +945,15 @@ static int nsim_dev_devlink_trap_init(struct devlink *devlink,
 static int __nsim_dev_port_add(struct nsim_dev *nsim_dev, enum nsim_dev_port_type type,
 			       unsigned int port_index)
 {
+	struct nsim_bus_dev *nsim_bus_dev = nsim_dev->nsim_bus_dev;
 	struct devlink_port_attrs attrs = {};
 	struct nsim_dev_port *nsim_dev_port;
 	struct devlink_port *devlink_port;
 	int err;
 
+	if (type == NSIM_DEV_PORT_TYPE_VF && !nsim_bus_dev->num_vfs)
+		return -EINVAL;
+
 	nsim_dev_port = kzalloc(sizeof(*nsim_dev_port), GFP_KERNEL);
 	if (!nsim_dev_port)
 		return -ENOMEM;
@@ -957,8 +961,14 @@ static int __nsim_dev_port_add(struct nsim_dev *nsim_dev, enum nsim_dev_port_typ
 	nsim_dev_port->port_type = type;
 
 	devlink_port = &nsim_dev_port->devlink_port;
-	attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
-	attrs.phys.port_number = port_index + 1;
+	if (nsim_dev_port_is_pf(nsim_dev_port)) {
+		attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
+		attrs.phys.port_number = port_index + 1;
+	} else {
+		attrs.flavour = DEVLINK_PORT_FLAVOUR_PCI_VF;
+		attrs.pci_vf.pf = 0;
+		attrs.pci_vf.vf = port_index;
+	}
 	memcpy(attrs.switch_id.id, nsim_dev->switch_id.id, nsim_dev->switch_id.id_len);
 	attrs.switch_id.id_len = nsim_dev->switch_id.id_len;
 	devlink_port_attrs_set(devlink_port, &attrs);
diff --git a/drivers/net/netdevsim/netdev.c b/drivers/net/netdevsim/netdev.c
index 659d3dc..9352e18 100644
--- a/drivers/net/netdevsim/netdev.c
+++ b/drivers/net/netdevsim/netdev.c
@@ -261,6 +261,18 @@ static struct devlink_port *nsim_get_devlink_port(struct net_device *dev)
 	.ndo_get_devlink_port	= nsim_get_devlink_port,
 };
 
+static const struct net_device_ops nsim_vf_netdev_ops = {
+	.ndo_start_xmit		= nsim_start_xmit,
+	.ndo_set_rx_mode	= nsim_set_rx_mode,
+	.ndo_set_mac_address	= eth_mac_addr,
+	.ndo_validate_addr	= eth_validate_addr,
+	.ndo_change_mtu		= nsim_change_mtu,
+	.ndo_get_stats64	= nsim_get_stats64,
+	.ndo_setup_tc		= nsim_setup_tc,
+	.ndo_set_features	= nsim_set_features,
+	.ndo_get_devlink_port	= nsim_get_devlink_port,
+};
+
 static void nsim_setup(struct net_device *dev)
 {
 	ether_setup(dev);
@@ -280,6 +292,49 @@ static void nsim_setup(struct net_device *dev)
 	dev->max_mtu = ETH_MAX_MTU;
 }
 
+static int nsim_init_netdevsim(struct netdevsim *ns)
+{
+	int err;
+
+	ns->netdev->netdev_ops = &nsim_netdev_ops;
+
+	err = nsim_udp_tunnels_info_create(ns->nsim_dev, ns->netdev);
+	if (err)
+		return err;
+
+	rtnl_lock();
+	err = nsim_bpf_init(ns);
+	if (err)
+		goto err_utn_destroy;
+
+	nsim_ipsec_init(ns);
+
+	err = register_netdevice(ns->netdev);
+	if (err)
+		goto err_ipsec_teardown;
+	rtnl_unlock();
+	return 0;
+
+err_ipsec_teardown:
+	nsim_ipsec_teardown(ns);
+	nsim_bpf_uninit(ns);
+err_utn_destroy:
+	rtnl_unlock();
+	nsim_udp_tunnels_info_destroy(ns->netdev);
+	return err;
+}
+
+static int nsim_init_netdevsim_vf(struct netdevsim *ns)
+{
+	int err;
+
+	ns->netdev->netdev_ops = &nsim_vf_netdev_ops;
+	rtnl_lock();
+	err = register_netdevice(ns->netdev);
+	rtnl_unlock();
+	return err;
+}
+
 struct netdevsim *
 nsim_create(struct nsim_dev *nsim_dev, struct nsim_dev_port *nsim_dev_port)
 {
@@ -299,33 +354,15 @@ struct netdevsim *
 	ns->nsim_dev_port = nsim_dev_port;
 	ns->nsim_bus_dev = nsim_dev->nsim_bus_dev;
 	SET_NETDEV_DEV(dev, &ns->nsim_bus_dev->dev);
-	dev->netdev_ops = &nsim_netdev_ops;
 	nsim_ethtool_init(ns);
-
-	err = nsim_udp_tunnels_info_create(nsim_dev, dev);
+	if (nsim_dev_port_is_pf(nsim_dev_port))
+		err = nsim_init_netdevsim(ns);
+	else
+		err = nsim_init_netdevsim_vf(ns);
 	if (err)
 		goto err_free_netdev;
-
-	rtnl_lock();
-	err = nsim_bpf_init(ns);
-	if (err)
-		goto err_utn_destroy;
-
-	nsim_ipsec_init(ns);
-
-	err = register_netdevice(dev);
-	if (err)
-		goto err_ipsec_teardown;
-	rtnl_unlock();
-
 	return ns;
 
-err_ipsec_teardown:
-	nsim_ipsec_teardown(ns);
-	nsim_bpf_uninit(ns);
-err_utn_destroy:
-	rtnl_unlock();
-	nsim_udp_tunnels_info_destroy(dev);
 err_free_netdev:
 	free_netdev(dev);
 	return ERR_PTR(err);
@@ -337,10 +374,13 @@ void nsim_destroy(struct netdevsim *ns)
 
 	rtnl_lock();
 	unregister_netdevice(dev);
-	nsim_ipsec_teardown(ns);
-	nsim_bpf_uninit(ns);
+	if (nsim_dev_port_is_pf(ns->nsim_dev_port)) {
+		nsim_ipsec_teardown(ns);
+		nsim_bpf_uninit(ns);
+	}
 	rtnl_unlock();
-	nsim_udp_tunnels_info_destroy(dev);
+	if (nsim_dev_port_is_pf(ns->nsim_dev_port))
+		nsim_udp_tunnels_info_destroy(dev);
 	free_netdev(dev);
 }
 
-- 
1.8.3.1

