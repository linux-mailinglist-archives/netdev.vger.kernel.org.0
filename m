Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1674E366F85
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 17:54:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237429AbhDUPyy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 11:54:54 -0400
Received: from mail-eopbgr770051.outbound.protection.outlook.com ([40.107.77.51]:19818
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236609AbhDUPxx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 11:53:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JAU11JJanzQxDiqln2PPMF01wMtBn9pToToERUcb5Yp6C7f8RXXaZk8lhYiB+Vdi2UGJTNWe4VcG2uQv9pmg2cm9wEDCDehbcUzKq+8Yb0qvkVX+2eJuSNKdXWznHW1E59PI8oi/nQwdTjoqzxbTvLMX2qQ5wDH+jBcetfuQ1ZMgkSnDwMb3b8caAqYEt53B+WMIG2gMX28Ov2rQRfkttOr1pq6ZuQeLY57MCpWLlORLw7Rpo5yurjD17um3aPZx1ky2yGuWAL8CKE73Qe2SjcTNZL5Wh8rQTVLq8Xs78xZ/ftwrfq33WWhzO0AM4lD6eVKP0fgQYvqSgR6iTQ57AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pb5rOyXCWA4y7OrW2JBMT1Cbso6REtZqTl3fzfq51BM=;
 b=aImosJ7mPjAGhDaWVaRbfN8GNl0JHndgDhQzrhp2X/Rt71+agdx7xty3osNU2EXh+ePDIjOUDM9pD1KqBLTz/OXbTSJp6FcMP6094Yypj4mUaoYg1S8f9PKzVQ4LcG4b0bWh9vNsupTzXdD0RuYjjgVI0KayJbLI4+OlYxk8VaYbA3RvQmFUtxwFHOLtW31yrGo5iqUv4TnjEflKv58sOzxvcLZcOCgF0vgDJoM1Sgago+pDrhNeNBi6ydUEbaIA4Iy7lnlNvj/q1Y1MXw4hv2+WybVVWO4iixvZCg5n2pzHtLo33C7A17SPILW5aYW2v43cO1LP7nDAYbkoXSnWAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pb5rOyXCWA4y7OrW2JBMT1Cbso6REtZqTl3fzfq51BM=;
 b=oVwQ0yi3X1N02Gl1Fq/p/o66YMxnIOvsXgtt1FJ90KHmiHx4Wqn6majGP+IiqviDOpX+ivjM8mFhy7YUN1jWse4wlu6qvfZkrtDoUwPEY2oAsQf6kXpfIDFV2cvAGdNzaPOUpoTyyahfLHIYouPxaF0szpek7hYSEsBMBnj7RSqmVXJFzFvf/NOw63lXTc8XcJwXF7/gqdJcvlqoDrwXKhjrh9bfYL4yRTiXQ8+yyCNtE8OL+n/qiNsHkUGaBccZA+O4OHTasVfDX1sVhY/MdMEdsY9ewPvpqw4XwswLd6DAZq4HbHniEdKN1fnH7eExkgFS4s7ChStbIkfVgWpgsg==
Received: from CO1PR15CA0070.namprd15.prod.outlook.com (2603:10b6:101:20::14)
 by BL0PR12MB2467.namprd12.prod.outlook.com (2603:10b6:207:4c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20; Wed, 21 Apr
 2021 15:53:19 +0000
Received: from CO1NAM11FT009.eop-nam11.prod.protection.outlook.com
 (2603:10b6:101:20:cafe::b9) by CO1PR15CA0070.outlook.office365.com
 (2603:10b6:101:20::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend
 Transport; Wed, 21 Apr 2021 15:53:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 CO1NAM11FT009.mail.protection.outlook.com (10.13.175.61) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4065.21 via Frontend Transport; Wed, 21 Apr 2021 15:53:18 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 21 Apr
 2021 08:53:18 -0700
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 21 Apr 2021 15:53:16 +0000
From:   <dlinkin@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <stephen@networkplumber.org>, <dsahern@gmail.com>,
        <vladbu@nvidia.com>, Dmytro Linkin <dlinkin@nvidia.com>
Subject: [PATCH RESEND-2 RFC net-next 04/18] netdevsim: Implement VFs
Date:   Wed, 21 Apr 2021 18:52:51 +0300
Message-ID: <1619020385-20220-5-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1619020385-20220-1-git-send-email-dlinkin@nvidia.com>
References: <1619020385-20220-1-git-send-email-dlinkin@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ecf76293-3432-4a8f-f997-08d904dd957f
X-MS-TrafficTypeDiagnostic: BL0PR12MB2467:
X-Microsoft-Antispam-PRVS: <BL0PR12MB2467B1332B2831B6D2FD30EACB479@BL0PR12MB2467.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2512;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /R5JUhqzfCgGUtOOyz2uXKdgi1YMrudoTX5yHm8uzhyHQy9WxJnkBi23QPDWWsM7woewTM8T4es9Ld0jLp4Y8BhSumD307Pdp7dmX8Z6mb4ZTDZO0qSjVn92/WBk52/uwdZuJ8THCBBe8kE73II+Hi7xsaDjNJJlzadcT8F/eqmHQF2cggp4N6Qvr88pEnq3tpPhoDF7MfSHBrzv4k60e2nHxJ6pNDaMYFX7njXEIIVwwO9pxXqskRQQlbD5OSw0pX0J2U/njGPPcrLemIdM8wT4ztDhJHiqkiyyT8ja5bcsNPXZ4wVIjqtDpzUJGGqdItAQqM7ys62NCz64AJxq9icyrnkVOJm45QlChUkcCEdpQ7xm25w+kia2BkuPKWH4G7IjRZg/Fn2kf3Ku3NIP1oHx20qjbOTvc1SrbXWP5JlnvgojoNSe7Uzmwv3AdmRSJ3sKelkdb8ljspFyKTOblzQQU09p5gYVTSIe5fqNeAIkSggGjHvdc65AqhqgErw9UTjFxyE2uaOhlx3olzt0FgVuNmWnZMZxFfiKYx26XTvLMzkaeXb/2kh7HnoA0/KkGV9JLbHu25/9wk/vuHdHw4iRjVXwPesAJDX3D1fMpYRjsWjxhjnI5HCoF9AU1djKU24uw3dyiLSPU88imfghDw==
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(376002)(346002)(136003)(396003)(46966006)(36840700001)(2876002)(6666004)(26005)(316002)(2906002)(186003)(478600001)(54906003)(356005)(8936002)(82310400003)(7696005)(82740400003)(5660300002)(2616005)(107886003)(70206006)(4326008)(70586007)(8676002)(6916009)(36860700001)(7636003)(86362001)(83380400001)(426003)(336012)(36756003)(47076005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2021 15:53:18.9802
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ecf76293-3432-4a8f-f997-08d904dd957f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT009.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB2467
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

