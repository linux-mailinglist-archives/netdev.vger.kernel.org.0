Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0EDF37C0A2
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 16:49:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231421AbhELOu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 10:50:28 -0400
Received: from mail-co1nam11on2050.outbound.protection.outlook.com ([40.107.220.50]:48928
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231419AbhELOuM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 May 2021 10:50:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZOZ6VyflKLh8K/QxMWZHPlKl5RJ1ThR57t2sFmp14JiBA3PnG8VnZILMygdW7XmZ5sPEyaEkY9OueNrjsB7JMPfTjBHpRk2roTy6dHiJYN9wo7IDraDmnSmv1UJWAMGEk65wbRTxvT+0LD1Q6ijoUrwjM+YPrVdMNnE+w4EIo1Dlv9o1XarSI6BZeBFU/FcxrgsR7gsxtM1NvouJ2OIRU1xB8dkQQJ2PQYsi5c6AHVPsn+iKHMc0qCT1gLfl09QWXv9iB6jVKBzzauK2ka606b0ji399xrwuaYyYdP5rAPYLkLzBv1r9dmPMIojXSiLvExe8t1NeYepQ7Olaj2KOjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pb5rOyXCWA4y7OrW2JBMT1Cbso6REtZqTl3fzfq51BM=;
 b=mbZ8/ULA/mbJo/6fnr4n4yaRXqzj0wLgibAVKvMenOiPMEMAqsHKMt7667HYbENk1wrJdzwyas4xccYigTq/ee3P8snVR/gnt0WqrcrGdSIOPKJY9qidkJOp2OOW9Xm4PuFWDzQ0aQYgWr+PtbXsmn/F8LjTDl/KLpI5esrInMfLuIUcXXFXi9XfLFdtRpYqXwoVeoL3pry1PM+Ni6tPlSiN4uHOi7vrnn9Llyxg4rsnvXixKG5ahIiDqH7+ZCJ+koRd6jEWrooPhiRIExjB/h6Ca9fJWYyIpe6iipxxcss+ggWb8/Jt9R7fqB46IkUdtHx7Ts98u7DJ1VJstanfaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pb5rOyXCWA4y7OrW2JBMT1Cbso6REtZqTl3fzfq51BM=;
 b=Up5vR7KnKpPw8YvZ2jOZAgugJBOZGrCNvfF/5Uhc2Queio64nsHqh5/H28XPpyNQHnhrnXzuw5h8rOtpZazCRTfgarTGGr210F3itaDt9a4/DAmUuYD+LFcOEf+hgUW/qavmQioq7EyNO5NLdbuSk8z47l7bOacenGQmpFDlShMQNPMpJ4sBnu9YfE4QZky53FfsgCj+l85ZFzsj+xY2HMgY/sKrtYZjWhAJfIJg3PyQZKKu8LpgwLHDAyRbjYGmbe8LnMwCSROK+lcU7wjjUQHosQ1RJDAeJ4F5sJFCzMi5Za2OKba7ZPnrhTDNFGofjgqemSO/0NYQaCDdFQMsdw==
Received: from BN9PR03CA0328.namprd03.prod.outlook.com (2603:10b6:408:112::33)
 by BL1PR12MB5142.namprd12.prod.outlook.com (2603:10b6:208:312::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.30; Wed, 12 May
 2021 14:49:03 +0000
Received: from BN8NAM11FT060.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:112:cafe::12) by BN9PR03CA0328.outlook.office365.com
 (2603:10b6:408:112::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend
 Transport; Wed, 12 May 2021 14:49:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT060.mail.protection.outlook.com (10.13.177.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Wed, 12 May 2021 14:49:03 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 12 May
 2021 07:49:02 -0700
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 12 May 2021 14:49:00 +0000
From:   <dlinkin@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <stephen@networkplumber.org>, <dsahern@gmail.com>,
        <vladbu@nvidia.com>, <parav@nvidia.com>, <huyn@nvidia.com>,
        Dmytro Linkin <dlinkin@nvidia.com>
Subject: [PATCH RFC net-next v2 04/18] netdevsim: Implement VFs
Date:   Wed, 12 May 2021 17:48:33 +0300
Message-ID: <1620830927-11828-5-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1620830927-11828-1-git-send-email-dlinkin@nvidia.com>
References: <1620830927-11828-1-git-send-email-dlinkin@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 886d14e9-f2d1-4e96-0f9b-08d915551617
X-MS-TrafficTypeDiagnostic: BL1PR12MB5142:
X-Microsoft-Antispam-PRVS: <BL1PR12MB51429996EC638937E176415DCB529@BL1PR12MB5142.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2512;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1cJOSsMH18JSvkhELo6LGLywPBxygqb8z3gO1JZsT2fLpkclT6uDBTrrNqXo/kh4ITEM+cBh4J6C0y78Ec3V6Tpnf1QzqdsDfjDdte6fnybrQLgqYdAn4UGQ4RAukXn2gKfD9Lan5sox6oY/F00rHBEc4A/YQ6gONVLhlqKt5LMcxvoSxfMq0dbtDghYnQrtxgO57dtcn2MAnnqR11gM3AgRMExs4MW175jqHdT+TI7mW1sQ0+ZbK9C+Yf5B6DRQjiUyGdh4jJ87AGrg4KDaKjNgdqytyRZc+NqazfuYepTAE5lHCX40gqS+3mGXLnklReSQbTuUp/XLVHyiAAS9uVn81qVrM6welJsStLOArLV8wC0gzfQpd/UlrQPSj0cgRVuISpa6R3/PnXtn1kF7UXBRq5iLMT5fhWL3fgkNOVmV4zUXLJ2wZXUEg6lTH82OPu09GDIw6T6uDIIk/JcnAo+WhGi9NzBGzqaI3D4REwbRk5IZwG2DNyh6W3S2V2L3Cu45jKMbzzsVxjzKpvB29dkLLogAKQN/rsDsl9Xt67+xr58+o8eruP7m9IVEDP9FsciGtdrmqoh2dHWpz4v5XpE86i5J1ZUqxoxe0ZKSchCRt3nJLP2cFP35wNosk68+l/d77kDOnHX9Q2Ptz+gokQ==
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(346002)(39860400002)(136003)(396003)(46966006)(36840700001)(2906002)(82740400003)(7636003)(36860700001)(5660300002)(316002)(336012)(82310400003)(4326008)(426003)(7696005)(8676002)(186003)(47076005)(8936002)(54906003)(70586007)(356005)(6916009)(6666004)(83380400001)(2876002)(2616005)(478600001)(107886003)(70206006)(26005)(86362001)(36756003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2021 14:49:03.4870
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 886d14e9-f2d1-4e96-0f9b-08d915551617
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT060.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5142
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

