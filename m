Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 810A1391702
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 14:03:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234687AbhEZMEn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 08:04:43 -0400
Received: from mail-bn1nam07on2072.outbound.protection.outlook.com ([40.107.212.72]:42978
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234688AbhEZMDn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 May 2021 08:03:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IInmjGleY9c6lMgImctEEe/rJ/iO+QpZaBbkSLENSnz8yWwaVpMOPE4rUH4WdGyFAQWKwjMetRsPXpZJuOrZ99VAqgSs6HOSwsGHXduoY4P2LCfSAle0jFP2Ro6xPxHio7Fp4kYat2IK/oMDOl+PgP/BFPvOJ2CXVhfGOJ4mtfNneDGqK5lzn37OGJAh9KNJNZnbH2/CHgOAnwAsqrWJ31+vJRI452J4QpAF3JSkm5HvW/DcvGRvBVWHbG7VDDshXDEAfrc8TkOPkvWf+2xdsJBvTF4WBGpNuC0d/MJXnuNMNbVY3qb8rAKEJVfIk7/wjlQJ6pDxqTezb535fWbNYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yc4oij1qguvE2qTc64DTBA8PoMiHrA3p6D6Wziql+uE=;
 b=A1+mN8zw33/9PUiG2yKvjCqKf0lQKRNFNYZQCrOPZIvOXyzkM5DNkJE/Ld5x83YYpTxYNK0eZrSaZEseeJ3o1WiTkFmFMgQHcbZRfiOx+ir7I2DSDl4J5/itrTvvRceJDNsp+bGyDF5gjiNB+Z4kwHrW0CmzaRyuNgILfnO2lRcKlYyFJrGqYGzmwDhebT6SBsH7+bG9j2kmH6VlzRgmPIOFQcWMT7F0NWNtbKQYxzZAiwKoRkDs+PGWaLWGcuXrT82yvQyeOO1iFuuYOVPaIYBDIdXZOezsWUOmZvYYsdbyej65l98G+/HwE08pg8QBDU+0hJHLDhechXL38PBN7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yc4oij1qguvE2qTc64DTBA8PoMiHrA3p6D6Wziql+uE=;
 b=RatVm9VFQg7U+JSz4Js3g6WG8DzjYlY/YwCr2cfYhYlnIDrnkEL1BmE+y2H0NaKyYrVtY1QC4v5T9KYG9InHHqHu4LTKw3LuTQHZTL2ELkuKMAAe+2C1c5LAM5AhMiUGdW7kdxIWxjV60xtDHj8mdtJdW5CaEVWQbmih8XzsIoUNTUqiGRiiSVJYTnl09Nq1Jny8F+EMOBp2J+ukDj3JHTm+90pcvhrsk10BIbNMpCnJii43XKrI4u12itcbVk/x5Oywej0IGLQTtLnRmC5tBRlUPZvP7jS12VKGKDvdN9OdQwpn1Zv/8eea3ZEaN/aahJZxraZ94TtF0UGrfOPc7A==
Received: from DM6PR13CA0044.namprd13.prod.outlook.com (2603:10b6:5:134::21)
 by BL1PR12MB5380.namprd12.prod.outlook.com (2603:10b6:208:314::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.28; Wed, 26 May
 2021 12:02:09 +0000
Received: from DM6NAM11FT048.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:134:cafe::6c) by DM6PR13CA0044.outlook.office365.com
 (2603:10b6:5:134::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.11 via Frontend
 Transport; Wed, 26 May 2021 12:02:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT048.mail.protection.outlook.com (10.13.173.114) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Wed, 26 May 2021 12:02:09 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 26 May
 2021 12:02:00 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 26 May 2021 12:01:58 +0000
From:   <dlinkin@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <stephen@networkplumber.org>, <dsahern@gmail.com>,
        <vladbu@nvidia.com>, <parav@nvidia.com>, <huyn@nvidia.com>,
        Dmytro Linkin <dlinkin@nvidia.com>
Subject: [PATCH RFC net-next v3 16/18] netdevsim: Allow setting parent node of rate objects
Date:   Wed, 26 May 2021 15:01:08 +0300
Message-ID: <1622030470-21434-17-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1622030470-21434-1-git-send-email-dlinkin@nvidia.com>
References: <1622030470-21434-1-git-send-email-dlinkin@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 90160648-d1d4-4cc4-0441-08d9203e1722
X-MS-TrafficTypeDiagnostic: BL1PR12MB5380:
X-Microsoft-Antispam-PRVS: <BL1PR12MB53804BDCB25835008C191F0ECB249@BL1PR12MB5380.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:506;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rfGtwsvjJQ337jTml2l87VWMaJfgLI7PqWvNKw9SiUjFCLG0M20iKFaNFqBTffCqTgkYuTahsvNnWZ6IgtEo3Y9dFUjfRfu7vvbh1TGjQWNF2yuIFTDnUkVH/cEleGNrQyLft9ENtW3ZsMppi37KSfaQ1n0+unBj+Qt+raNPhNWEGPpoeeRciUZidn0sGmhtzmcTps8S/fgW18Om7D15zkL+qYdYwjTpdyq1EDeLb0pQAnRT3NxslkWWFzt8G/WBHMKGrS8mqsRcvIgiMZTH2+pdN/742dyJI2bOOKxXrUxk9rFN6ziKx3v6cTJJB2e4bqmNAgd58LyWgEBM3TfkDLT0YurRt3jd8Es1MPx3t3+zyPH6owYiNPtBWuNeYuWoWNohSQlbK4z0/De4vEomkhlgV1pLgIYmNFZ0E4y1XInvF3CIJFsbxHUN7edQJko5pTwv4Pboig3vAWGHrEuikEjaPxZPk9De+ovDJxlfh0oXgB4Ptmu8zULhudLisgFlIxTJ+CVsODAtLZ6rp3bdIM+NNq7qgHandacRu8M0mNd/77lMKoTnv2Yr4DNvYWYxv0+DVSr7WvctX5hqd9/tLN2Ju4GLAg7hukoahd+t4Stu1CMyOPhK0UzzL8UsxdFr+tQZDt/8tvf4YaiyU16j9w==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(346002)(396003)(39860400002)(376002)(46966006)(36840700001)(426003)(2906002)(2616005)(186003)(36860700001)(478600001)(7696005)(83380400001)(8936002)(47076005)(86362001)(54906003)(6666004)(82740400003)(70206006)(2876002)(107886003)(4326008)(7636003)(70586007)(82310400003)(36906005)(5660300002)(8676002)(336012)(36756003)(26005)(6916009)(316002)(356005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2021 12:02:09.6622
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 90160648-d1d4-4cc4-0441-08d9203e1722
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT048.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5380
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmytro Linkin <dlinkin@nvidia.com>

Implement new devlink ops that allow setting rate node as a parent for
devlink port (leaf) or another devlink node through devlink API.
Expose parent names to netdevsim debugfs in read only mode.

Co-developed-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Dmytro Linkin <dlinkin@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/netdevsim/dev.c       | 91 +++++++++++++++++++++++++++++++++++++--
 drivers/net/netdevsim/netdevsim.h |  2 +
 2 files changed, 89 insertions(+), 4 deletions(-)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 9f01b6c..527b019 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -222,6 +222,7 @@ static ssize_t nsim_dev_trap_fa_cookie_write(struct file *file,
 static int nsim_dev_debugfs_init(struct nsim_dev *nsim_dev)
 {
 	char dev_ddir_name[sizeof(DRV_NAME) + 10];
+	int err;
 
 	sprintf(dev_ddir_name, DRV_NAME "%u", nsim_dev->nsim_bus_dev->dev.id);
 	nsim_dev->ddir = debugfs_create_dir(dev_ddir_name, nsim_dev_ddir);
@@ -264,10 +265,17 @@ static int nsim_dev_debugfs_init(struct nsim_dev *nsim_dev)
 						nsim_dev->nsim_bus_dev,
 						&nsim_dev_max_vfs_fops);
 	nsim_dev->nodes_ddir = debugfs_create_dir("rate_nodes", nsim_dev->ddir);
-	if (IS_ERR(nsim_dev->nodes_ddir))
-		return PTR_ERR(nsim_dev->nodes_ddir);
+	if (IS_ERR(nsim_dev->nodes_ddir)) {
+		err = PTR_ERR(nsim_dev->nodes_ddir);
+		goto err_out;
+	}
 	nsim_udp_tunnels_debugfs_create(nsim_dev);
 	return 0;
+
+err_out:
+	debugfs_remove_recursive(nsim_dev->ports_ddir);
+	debugfs_remove_recursive(nsim_dev->ddir);
+	return err;
 }
 
 static void nsim_dev_debugfs_exit(struct nsim_dev *nsim_dev)
@@ -277,6 +285,27 @@ static void nsim_dev_debugfs_exit(struct nsim_dev *nsim_dev)
 	debugfs_remove_recursive(nsim_dev->ddir);
 }
 
+static ssize_t nsim_dev_rate_parent_read(struct file *file,
+					 char __user *data,
+					 size_t count, loff_t *ppos)
+{
+	char **name_ptr = file->private_data;
+	size_t len;
+
+	if (!*name_ptr)
+		return 0;
+
+	len = strlen(*name_ptr);
+	return simple_read_from_buffer(data, count, ppos, *name_ptr, len);
+}
+
+static const struct file_operations nsim_dev_rate_parent_fops = {
+	.open = simple_open,
+	.read = nsim_dev_rate_parent_read,
+	.llseek = generic_file_llseek,
+	.owner = THIS_MODULE,
+};
+
 static int nsim_dev_port_debugfs_init(struct nsim_dev *nsim_dev,
 				      struct nsim_dev_port *nsim_dev_port)
 {
@@ -299,6 +328,11 @@ static int nsim_dev_port_debugfs_init(struct nsim_dev *nsim_dev,
 				   &nsim_bus_dev->vfconfigs[vf_id].min_tx_rate);
 		debugfs_create_u16("tx_max", 0400, nsim_dev_port->ddir,
 				   &nsim_bus_dev->vfconfigs[vf_id].max_tx_rate);
+		nsim_dev_port->rate_parent = debugfs_create_file("rate_parent",
+								 0400,
+								 nsim_dev_port->ddir,
+								 &nsim_dev_port->parent_name,
+								 &nsim_dev_rate_parent_fops);
 	}
 	debugfs_create_symlink("dev", nsim_dev_port->ddir, dev_link_name);
 
@@ -1068,6 +1102,8 @@ static int nsim_leaf_tx_max_set(struct devlink_rate *devlink_rate, void *priv,
 
 struct nsim_rate_node {
 	struct dentry *ddir;
+	struct dentry *rate_parent;
+	char *parent_name;
 	u16 tx_share;
 	u16 tx_max;
 };
@@ -1105,6 +1141,7 @@ static int nsim_rate_node_new(struct devlink_rate *node, void **priv,
 {
 	struct nsim_dev *nsim_dev = devlink_priv(node->devlink);
 	struct nsim_rate_node *nsim_node;
+	int err;
 
 	if (!nsim_esw_mode_is_switchdev(nsim_dev)) {
 		NL_SET_ERR_MSG_MOD(extack, "Node creation allowed only in switchdev mode.");
@@ -1117,13 +1154,28 @@ static int nsim_rate_node_new(struct devlink_rate *node, void **priv,
 
 	nsim_node->ddir = debugfs_create_dir(node->name, nsim_dev->nodes_ddir);
 	if (!nsim_node->ddir) {
-		kfree(nsim_node);
-		return -ENOMEM;
+		err = -ENOMEM;
+		goto err_node;
 	}
 	debugfs_create_u16("tx_share", 0400, nsim_node->ddir, &nsim_node->tx_share);
 	debugfs_create_u16("tx_max", 0400, nsim_node->ddir, &nsim_node->tx_max);
+	nsim_node->rate_parent = debugfs_create_file("rate_parent", 0400,
+						     nsim_node->ddir,
+						     &nsim_node->parent_name,
+						     &nsim_dev_rate_parent_fops);
+	if (IS_ERR(nsim_node->rate_parent)) {
+		err = PTR_ERR(nsim_node->rate_parent);
+		goto err_ddir;
+	}
+
 	*priv = nsim_node;
 	return 0;
+
+err_ddir:
+	debugfs_remove_recursive(nsim_node->ddir);
+err_node:
+	kfree(nsim_node);
+	return err;
 }
 
 static int nsim_rate_node_del(struct devlink_rate *node, void *priv,
@@ -1131,11 +1183,40 @@ static int nsim_rate_node_del(struct devlink_rate *node, void *priv,
 {
 	struct nsim_rate_node *nsim_node = priv;
 
+	debugfs_remove(nsim_node->rate_parent);
 	debugfs_remove_recursive(nsim_node->ddir);
 	kfree(nsim_node);
 	return 0;
 }
 
+static int nsim_rate_leaf_parent_set(struct devlink_rate *child,
+				     struct devlink_rate *parent,
+				     void *priv_child, void *priv_parent,
+				     struct netlink_ext_ack *extack)
+{
+	struct nsim_dev_port *nsim_dev_port = priv_child;
+
+	if (parent)
+		nsim_dev_port->parent_name = parent->name;
+	else
+		nsim_dev_port->parent_name = NULL;
+	return 0;
+}
+
+static int nsim_rate_node_parent_set(struct devlink_rate *child,
+				     struct devlink_rate *parent,
+				     void *priv_child, void *priv_parent,
+				     struct netlink_ext_ack *extack)
+{
+	struct nsim_rate_node *nsim_node = priv_child;
+
+	if (parent)
+		nsim_node->parent_name = parent->name;
+	else
+		nsim_node->parent_name = NULL;
+	return 0;
+}
+
 static const struct devlink_ops nsim_dev_devlink_ops = {
 	.eswitch_mode_set = nsim_devlink_eswitch_mode_set,
 	.eswitch_mode_get = nsim_devlink_eswitch_mode_get,
@@ -1157,6 +1238,8 @@ static int nsim_rate_node_del(struct devlink_rate *node, void *priv,
 	.rate_node_tx_max_set = nsim_node_tx_max_set,
 	.rate_node_new = nsim_rate_node_new,
 	.rate_node_del = nsim_rate_node_del,
+	.rate_leaf_parent_set = nsim_rate_leaf_parent_set,
+	.rate_node_parent_set = nsim_rate_node_parent_set,
 };
 
 #define NSIM_DEV_MAX_MACS_DEFAULT 32
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index d62a138..cdfdf2a 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -211,6 +211,8 @@ struct nsim_dev_port {
 	unsigned int port_index;
 	enum nsim_dev_port_type port_type;
 	struct dentry *ddir;
+	struct dentry *rate_parent;
+	char *parent_name;
 	struct netdevsim *ns;
 };
 
-- 
1.8.3.1

