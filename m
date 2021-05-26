Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 098243916F0
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 14:01:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233201AbhEZMDT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 08:03:19 -0400
Received: from mail-dm6nam11on2059.outbound.protection.outlook.com ([40.107.223.59]:36058
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233111AbhEZMDL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 May 2021 08:03:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MmGVO8egJfBeRPuuf1vJ0IDqo8htx05K10BwuXXtHYPtCnq3g18J76IMDphaKQZNJlVfBF5hNz7XPAW/8udi9oDf4xr7/LeBFZml3nu5ppz3I8Ny4nVEjbLROm93zK1YtZrPeVFneCZKALleQlDE/HPCqRts/vPCkycChmfCbzqvlvQbBV+T4h+iHtt5naXetLP3WyZNWRdrifGnm1hGAV9RtvForK50oeXTZBtm3sDFDGlQf32od2SnuOe3VTL6sWyDRLPtFEi5hH2yQn2NXnK4HA7r00i7Zvmh6L4yE37z2kKOe10nXJpa1uTck2nLB5xu5f4jafp7/L3IXaj57g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pb5rOyXCWA4y7OrW2JBMT1Cbso6REtZqTl3fzfq51BM=;
 b=LbrkX7D+bdQ5N6AGrLtC0pEZ6I8Vx6uuICWQtMafZYrbs8gTJW83O0FdRrH+BCfCGaFGOnZ4mu+6hxkTu+/8ADmHPQqH1fDkgZFPlCK+XG2AwP2ZV/+Xdz8HQGItDdSvQXThMHcmc7hytN1R56G/0oe+vUMn2RJNGZH6PiNYIynI2uzJRRM3z8dO2ooTcjN70EO3SUfWvBrFPyWuQFmw91wzH5vYOESRbHeur/qE8InLSJxTpU1qyydDrJi0S1V5TYzmEqEDnJFUo2OuwxAcT31rLZ9pzPAyULye8HeAOjR4xxG3Zev1jN/cVFtQkgeJSC1bb+ik05p28VnMK23blQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pb5rOyXCWA4y7OrW2JBMT1Cbso6REtZqTl3fzfq51BM=;
 b=pH8Uz9li5Kbd1OIXZStGTJvyvPJIqL00/TGRIqZuPEtYZI3gsRnqLeeArT6qShVtRuaep0bRNCdRCDWMhHYtND2Tu/FQyfWjVEaFuWoKXnzLWiGUPPvTp0nsZfnbw6xTyfKj+ILn8zfriYAp5QXNJRzbF+ZhLGmZJ8I2uQJB8+tTwEge6pBxREYZzgL41gx314d0ni4l1AucjMWGrhgtnSkJTRfK1Ugkw3oo0FBDEtPbp2/p52CcQ9HySLwlLIdjO9Mm0X4ZipuI0HKOTmNTaSqUFKxmWtRAYmm0mvwXAmSRVo1VDW77JlxOEWOvjbqzai4Wsq2DV15ZdWqvn9l+1Q==
Received: from DM6PR02CA0154.namprd02.prod.outlook.com (2603:10b6:5:332::21)
 by BY5PR12MB5509.namprd12.prod.outlook.com (2603:10b6:a03:1d7::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26; Wed, 26 May
 2021 12:01:38 +0000
Received: from DM6NAM11FT040.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:332:cafe::d3) by DM6PR02CA0154.outlook.office365.com
 (2603:10b6:5:332::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend
 Transport; Wed, 26 May 2021 12:01:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT040.mail.protection.outlook.com (10.13.173.133) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Wed, 26 May 2021 12:01:37 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 26 May
 2021 12:01:26 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 26 May 2021 12:01:23 +0000
From:   <dlinkin@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <stephen@networkplumber.org>, <dsahern@gmail.com>,
        <vladbu@nvidia.com>, <parav@nvidia.com>, <huyn@nvidia.com>,
        Dmytro Linkin <dlinkin@nvidia.com>
Subject: [PATCH RFC net-next v3 04/18] netdevsim: Implement VFs
Date:   Wed, 26 May 2021 15:00:56 +0300
Message-ID: <1622030470-21434-5-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1622030470-21434-1-git-send-email-dlinkin@nvidia.com>
References: <1622030470-21434-1-git-send-email-dlinkin@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 89f957f3-e8a7-4ede-c111-08d9203e042e
X-MS-TrafficTypeDiagnostic: BY5PR12MB5509:
X-Microsoft-Antispam-PRVS: <BY5PR12MB55094B925B156D34E5DA6D24CB249@BY5PR12MB5509.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2512;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hFpM4Wjlv/VNzNXRBMyI5roSpc4e8lhG7yRPc9XCkE16+/umwFJYIZKlvFGiI3btuw2a8/gTSy5/k8zWYJd23aT1dHzhKUK490MphJU1svhdXcEceLMixhPxI3Qfot7BOobZT+ZnNb3SmTmhtZY1cO5UQAsGwQDPNEnRQkhyySueTx6+LP3PeTGximx3qpHkRUnAAG+foi1MuTolglXvy83sNydp/raQKOLkY24YXCJOeXf79OUWlvBKr+X/4Q5fMgB2/op0KE1CIkR/Eo1RAORmhXSV8GYnA6wepzJHQZiQFmwjZLVxtWtRokkCJFVbtnHUhYqstcrZPHOM/Mh600R/5cluUdPtuzP1qGAjkMdJn9zjhe829l03rwXSR8IYjgivY7T2TFfbIAfyUu6cTyjl+dM5WqrxXXmzUci5VAXpiDToUtSUXUIfZFZ/ik2zkBVMbw9u1ETVpldsBhJtjy7fdTE5R/Fer7irl/7Be7WyvgAONk8MdlUU0ZQfAEs2eGZKZxGtHBrSbeUsGPK49p6zmf/uQbTxb9q32fRcfLB8ISdRyX38NFoZiYlBNt1GY8A/NVZPd8p9qxlHEfxZXBr69YpnH9lbAWMUdBphvbv2o30HgDSthMh5ifvpAQqDFiS6QcWgEBc9kU/3AdUO3w==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(136003)(39850400004)(376002)(346002)(36840700001)(46966006)(316002)(7696005)(186003)(47076005)(6666004)(6916009)(36860700001)(82740400003)(36756003)(426003)(36906005)(86362001)(4326008)(83380400001)(478600001)(70586007)(336012)(8676002)(2906002)(26005)(82310400003)(5660300002)(107886003)(8936002)(70206006)(356005)(7636003)(54906003)(2876002)(2616005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2021 12:01:37.8630
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 89f957f3-e8a7-4ede-c111-08d9203e042e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT040.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB5509
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

