Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F05837C0AE
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 16:50:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231189AbhELOvm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 10:51:42 -0400
Received: from mail-bn7nam10on2064.outbound.protection.outlook.com ([40.107.92.64]:29377
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231591AbhELOut (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 May 2021 10:50:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZkYVxeow/gHBNh39+p6hMJMp2ZgXSyrQzwSeBIUGDLlqmJVvQPL4kdwwb2ypQ8KaqlrKuJ/y1CN0AOhoc++1A/Pdgl0L6NQYvIf5yAHf72h3sxD7HIDe2Dah7inpUHcY3ThQB/1VNfYoKTegdcRPVU0Eu+32bSlI+d3AaP8D3Ya4j/edkDsmX42aMwtUEGYckLkbrKqLdO/+kWU5UJ2ZX0YHyeXOjBbteBRKaGRdTz3Ikp+KRZJPZBXSEjMMB0VSm3QbajZfLAiidZMa8LDzngSCRzL2SzW+fKtSOZUUw2ZT7A14TteC6f6T67R1LU5StSbSAeNPkhFhhHhU7aaApQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BzhK1+elo0golEADMOitqMy0eghzDS/xgGuWjqEflH0=;
 b=PCw+eftpeev6exMycswrjAMq+rZ/TtNOur//QXUNqUln7jxrNLqMsh5mCJlVo1d813y8zBOzJnsKXhz9LeL7j+bkDe8rSV2XhDkFBc5esSz4x0oStnfHHUrETdoEZhYQYImM57LKZdhNZgfsR8bgKqGDkv9kTnLQIZxDRdM2juKZQZgC4B7WsZwSNluI6WZJ/uzr3orUzZ8ToiZ/qX2SXb7JMvVb/Y6HMJsA+0Rixmw3fuT/sZnu4gg4Afj6Nq/jT5wwGJYiAeHdHgUE33t9YP6kzEVY5YV1c8R6yv+MgjEQ3tk0l6YxU0e/Yga6ihsE1dLcr9dAs6OoPwLEj2m72w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BzhK1+elo0golEADMOitqMy0eghzDS/xgGuWjqEflH0=;
 b=FR4sNIahZp7ZAkK+MT4H49f4Pv+kNHv+Nq7PQEDnFm/T9OWXmQE02vI59kl/+MkJYmWThUb2MFZO38099g0PgOfa00sq0ptuF4Q4GnS39mEogehArowcx9Wm86TtScO3tUgLFtfdpfehtozxQSD9hB9quVMPoTNxr2c40o3N0z2ztXSJijcobU4IimBr+bqE+yfEKjrv+RldsVC+FPUt9m95IvCjUxJKZyKAdvAeXlOk3QSG6cQU5jmig1o7tQWBu5qsBH5NfGEv7/8TnyWhUeorHtH41Ie7MN09NYN+owoM/rHCho+9c4H1hFeF05D5ovUUYw7gj0B3MIzZv4vYTA==
Received: from BN6PR17CA0055.namprd17.prod.outlook.com (2603:10b6:405:75::44)
 by BYAPR12MB2775.namprd12.prod.outlook.com (2603:10b6:a03:6b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Wed, 12 May
 2021 14:49:39 +0000
Received: from BN8NAM11FT047.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:75:cafe::41) by BN6PR17CA0055.outlook.office365.com
 (2603:10b6:405:75::44) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend
 Transport; Wed, 12 May 2021 14:49:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT047.mail.protection.outlook.com (10.13.177.220) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Wed, 12 May 2021 14:49:38 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 12 May
 2021 07:49:37 -0700
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 12 May
 2021 14:49:37 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 12 May 2021 14:49:34 +0000
From:   <dlinkin@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <stephen@networkplumber.org>, <dsahern@gmail.com>,
        <vladbu@nvidia.com>, <parav@nvidia.com>, <huyn@nvidia.com>,
        Dmytro Linkin <dlinkin@nvidia.com>
Subject: [PATCH RFC net-next v2 16/18] netdevsim: Allow setting parent node of rate objects
Date:   Wed, 12 May 2021 17:48:45 +0300
Message-ID: <1620830927-11828-17-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1620830927-11828-1-git-send-email-dlinkin@nvidia.com>
References: <1620830927-11828-1-git-send-email-dlinkin@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dd2376e4-091b-445f-9092-08d915552b0e
X-MS-TrafficTypeDiagnostic: BYAPR12MB2775:
X-Microsoft-Antispam-PRVS: <BYAPR12MB27753D34A58ED7E418BEA346CB529@BYAPR12MB2775.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:506;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JN9QFv7VkZ5pZRQEpE9nx9LlYrnq2I+jFCxXqYE4ZmSCoXiv+f5O7bEAeazWSUmxXQEMqxNTmHKdbHdC7Vfh0YM1EimN5kandiB//vhjYxgZpoUWDdoaLWMVUS5I3q//ySwFP8IK71DRMxQCLq82t0L21eT667+eo617ruBN9mhehXLPfPMtT9RlB2gp/1AkXkZbnYXtcFIpZT4pQ73N5WCOd3lgW9tv++3Y+1e8GodE94ZwuQqW6uKCc2kTEWYEexT9ASfo2N7v9JEr4LDpZlD4IAUlVESs6+NGNAHCkikZ9X0ctW16CzbNBwYS15PW2d121xrSEV3kyjd+KyILMoc9rQSC9chcZNYhxLf/1zVb3yJbauexR+gUB56A/KLxTbOCPl45pZtSJDrP83mp44wqxZzh0XITCxtchHGVCoMmQRyfoguoqmKsMW0E+Bc7p4IlwIsHUHxOQB/eoj2HhAEJykZgrcuuWUoKlQgB5Dso0EfxSFRHsp3BxwvqgZQkc2v6Zau4AZvyJSC3U4AKGVbSituBN65hCw2HYlkt5gtyQrIYGWU/39vVYskH3l3umfuTvgpeu9u7De8JBFUJhdQrIqCsUg8fyDIrdHXBfaPuAXRIJL9lQRgAMFJvDh4MSENoKDbi70iElDQFYs/zPg==
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(39860400002)(136003)(346002)(396003)(36840700001)(46966006)(2616005)(36756003)(82740400003)(82310400003)(36860700001)(26005)(7696005)(336012)(5660300002)(54906003)(70206006)(86362001)(70586007)(426003)(186003)(47076005)(316002)(107886003)(4326008)(2906002)(356005)(83380400001)(6916009)(6666004)(478600001)(8676002)(2876002)(7636003)(8936002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2021 14:49:38.6705
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dd2376e4-091b-445f-9092-08d915552b0e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT047.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2775
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
index 0346457..bd1a823 100644
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
 
@@ -1066,6 +1100,8 @@ static int nsim_leaf_tx_max_set(struct devlink_rate *devlink_rate, void *priv,
 
 struct nsim_rate_node {
 	struct dentry *ddir;
+	struct dentry *rate_parent;
+	char *parent_name;
 	u16 tx_share;
 	u16 tx_max;
 };
@@ -1103,6 +1139,7 @@ static int nsim_rate_node_new(struct devlink_rate *node, void **priv,
 {
 	struct nsim_dev *nsim_dev = devlink_priv(node->devlink);
 	struct nsim_rate_node *nsim_node;
+	int err;
 
 	if (!nsim_esw_mode_is_switchdev(nsim_dev)) {
 		NL_SET_ERR_MSG_MOD(extack, "Node creation allowed only in switchdev mode.");
@@ -1115,13 +1152,28 @@ static int nsim_rate_node_new(struct devlink_rate *node, void **priv,
 
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
@@ -1129,11 +1181,40 @@ static int nsim_rate_node_del(struct devlink_rate *node, void *priv,
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
@@ -1155,6 +1236,8 @@ static int nsim_rate_node_del(struct devlink_rate *node, void *priv,
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

