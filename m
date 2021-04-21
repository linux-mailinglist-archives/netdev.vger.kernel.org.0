Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CD34366F81
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 17:54:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244167AbhDUPym (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 11:54:42 -0400
Received: from mail-bn7nam10on2078.outbound.protection.outlook.com ([40.107.92.78]:37984
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244218AbhDUPyY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 11:54:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=msyA6dLn7cp57wQVC9t7z/a/AY7REneImo26USfuo0yqKVk0gIgFRCHCVHAyWRR5hUuQvfcw3MQdnqeyyaoD0bTcwIpQTANpVDOiESKrytpT/gnFtjN9NeAv3VG2zNlIApHwcZNXJXZjqYBwhDIxSWZ5ms4fq9mQPPkVKr6AhrZvkz0VzJh5twtAOR9IvAGZpX3JcldJOf2UuEgs1+6WkJOEwpteXoZbq+YvKBCwurj7kaiXxd5W86on68hgCwMEI6X+5yGf/SGzSCVAePqW/s65pYVmnytHwI0n8sQUmlsCYS437pcFqjgbwPmAXBnF+txmkseswTAO10ggLEA0Fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bap1HI+o+6GKH57AXZk8EaqK6K+XpH9o5t8BYypoYRs=;
 b=OnA5Nt9j8QvYTg+8O1Wzo8hxZXVveSZjbwNmn7sKUfstuA6G9PqRTUeGIMgFaru7S8012jdXiDrRGIkUyYDOZjKolLR7/ukCxujZlRGoG7ENsLBFwYxGlLb+T+ZOTS/isXe2BWSQ/W/mw/cwwU3ESPZPdI/nX5zHZubLKyqJqWo9pBhYWZ2Fy+VfQQE2KyDURpTxUX1R9CUaSX3pCBAGivQMQOWjk5vQNOxHaUV1BochkEQAeioZ7x8Jx/BdyNniR3MjXOjTxv9EWW/PSWZDA0jLgrU7ysTskboOt9YdyB+MNwXXsza5vKSmSpF/rXZZ7kL9Kh/8/K5r5q9U10zwkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bap1HI+o+6GKH57AXZk8EaqK6K+XpH9o5t8BYypoYRs=;
 b=eR1+LfslqwhZ6W1BJXijCf7nZLxetwFe/XtATyOgrkpzHl3eRah/WRlzgyETF7GIBb0mMN2fEw9FURuzQvhoXzDeZ68ex7OcoBu6Oh1jQPzKzYqD/paB1EaRq8tqVtP6IaQWxEjpqEuTylqTxMNF7hJdv/kLkYCGrcn5QEjYihpezqdZq3mXwUIqSS5bZ7H4jB5D4NcovJnwaPRbn+y9YtjLVB7hswm+/fmxSkfxS031/a8YKuImEwMS6oLJvqMUABCTyOhwfv1hxOsgqum4B0rqo8WPllFxZ6TSj/5ZLJyREBFumLq/kBzYuO52z91TiYYEtnFgxPS1zDw8Zq8hnQ==
Received: from BN6PR20CA0049.namprd20.prod.outlook.com (2603:10b6:404:151::11)
 by DM6PR12MB3433.namprd12.prod.outlook.com (2603:10b6:5:38::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.24; Wed, 21 Apr
 2021 15:53:49 +0000
Received: from BN8NAM11FT046.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:151:cafe::5f) by BN6PR20CA0049.outlook.office365.com
 (2603:10b6:404:151::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21 via Frontend
 Transport; Wed, 21 Apr 2021 15:53:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 BN8NAM11FT046.mail.protection.outlook.com (10.13.177.127) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4065.21 via Frontend Transport; Wed, 21 Apr 2021 15:53:48 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 21 Apr
 2021 15:53:48 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 21 Apr 2021 15:53:45 +0000
From:   <dlinkin@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <stephen@networkplumber.org>, <dsahern@gmail.com>,
        <vladbu@nvidia.com>, Dmytro Linkin <dlinkin@nvidia.com>
Subject: [PATCH RESEND-2 RFC net-next 16/18] netdevsim: Allow setting parent node of rate objects
Date:   Wed, 21 Apr 2021 18:53:03 +0300
Message-ID: <1619020385-20220-17-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1619020385-20220-1-git-send-email-dlinkin@nvidia.com>
References: <1619020385-20220-1-git-send-email-dlinkin@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4d7b6677-473a-4f8b-32d3-08d904dda72e
X-MS-TrafficTypeDiagnostic: DM6PR12MB3433:
X-Microsoft-Antispam-PRVS: <DM6PR12MB34337473BEFC79BD5820563FCB479@DM6PR12MB3433.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:506;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bo7pASKEffhWzNTh6mIrD8ZynCQ3TF9aAt+Ajng8xnQxBWUwEEkNuo+yHAgAyHPX4a+cazAwc73Dpy+mdg9fOyZNbTR8C0K/8OjgvA+wQgqgbqhJio04fYtRcZ1LmTCkQOsveRLvyFFxHA82xQGgO7D6OKO82OeRa1eH89JMh0EbHErycWpmSOpsuJUF+Z/cGr30XHW+af3+jUV/ml3YhpZy047qvxDYTam4juUH9omaR9XhzikIQ9iVcXulMpIf0lwx0bazNBjmn7cGEQcO4DwzyA6xQTEbjcDssmvPGiUHMy2/fby7sjg/Ruzese53xl7pvOAoMMnt2aPUBtZweXxaRLneLU7sb8i3XQMmjgF+IErcaubDu52dMI/wbt1usgzZf6HcehEwSWE279J0Xadj2SsuQJhf1yWy+IRgwLEtgJl7z1SiGeR/UvtopbpP2nyDwuJTxovAwYf7qnoooZw8iT/z8CYsikPVHroRl05MlWm2qbfjqg0tzN8DWKtZZdPSbHVb1PGWDsSUmDyOijY5+XhSoWiRnn5mDpIwhEF24AAw8RUdIOp/KxvNrrFn59An+h/0FT63vNJdhcOABCYmDhG3Gl1fMmiiJxIjUylLkXzKeEvoc7rVId2TAJCyTT6S5SGTLDrOluCL7uH2LA==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(39860400002)(346002)(136003)(396003)(46966006)(36840700001)(86362001)(107886003)(47076005)(8936002)(36906005)(2876002)(6666004)(82740400003)(7636003)(186003)(336012)(54906003)(82310400003)(5660300002)(2906002)(26005)(4326008)(36860700001)(478600001)(356005)(6916009)(2616005)(83380400001)(70206006)(7696005)(8676002)(70586007)(316002)(426003)(36756003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2021 15:53:48.6903
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d7b6677-473a-4f8b-32d3-08d904dda72e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT046.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3433
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
index febc1b5..959d9a7 100644
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
 
@@ -1065,6 +1099,8 @@ static int nsim_leaf_tx_max_set(struct devlink_rate *devlink_rate, void *priv,
 
 struct nsim_rate_node {
 	struct dentry *ddir;
+	struct dentry *rate_parent;
+	char *parent_name;
 	u16 tx_share;
 	u16 tx_max;
 };
@@ -1102,6 +1138,7 @@ static int nsim_rate_node_new(struct devlink_rate *node, void **priv,
 {
 	struct nsim_dev *nsim_dev = devlink_priv(node->devlink);
 	struct nsim_rate_node *nsim_node;
+	int err;
 
 	if (!nsim_esw_mode_is_switchdev(nsim_dev)) {
 		NL_SET_ERR_MSG_MOD(extack, "Node creation allowed only in switchdev mode.");
@@ -1114,13 +1151,28 @@ static int nsim_rate_node_new(struct devlink_rate *node, void **priv,
 
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
@@ -1128,11 +1180,40 @@ static int nsim_rate_node_del(struct devlink_rate *node, void *priv,
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
@@ -1154,6 +1235,8 @@ static int nsim_rate_node_del(struct devlink_rate *node, void *priv,
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

