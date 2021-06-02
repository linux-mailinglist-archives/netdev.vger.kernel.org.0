Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7137398949
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 14:19:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbhFBMUc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 08:20:32 -0400
Received: from mail-bn8nam12on2074.outbound.protection.outlook.com ([40.107.237.74]:30145
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229932AbhFBMUG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 08:20:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hoz3XEwAE/KPJkn19rwkhopUG6hcHEjewgdkuVpEaWLHjvNnOIYB3Hl2knS+bGJ9WlrI1Zuxyn6CdxC5dx2zPBg/PrU3En9eS6NnAq50M90fVlgMWvanlcNiOrVD4DZzhBq6VxcXhdwtFdc4g78jD9BuBzVYztTl28ksAe+VW8OUKaArXPnMCYdyamYRMATKVX7VXBL2GfWImmodd3U1wXH/3g/7uRU9KP4/pppFeCGk6HaqmYlhjFODXz0D0C+23Z8OrCZ3ZhbUhXRf0yikrnIY588VTOM3P2ZuRiEZQuVagqBazODOQujGKzfaiwYgGGXquYzM1pb4Lt/F8yOKCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yc4oij1qguvE2qTc64DTBA8PoMiHrA3p6D6Wziql+uE=;
 b=KkO71HIXWJCmH5TIDL1cCnd7utfE6QTTRwt2M6l4bYmXemkqKjTvX/8AD6aWAHnz225Pd10FnUAKCVEY1V0p3oBJtnQuhVKPY6xTM5P7Z/ByXTTr0zl2hWoU+btu01aze3s+YoBPVWDOS3qJGLGfmBjzoK7EemePwzgplq8tf3FBgIG6mHn6s6kj17Vq35pYPoVgxiXyzFd+awveeyPFTbCO0tIbASH/UwwdVDlWFpE9EXnPAjU28ikP3W3Ve/O7SAr5m4MynP8fsBOhsCIhVa5KlL4y6qNSUbtCwFahw9VU9VmtatFA23jey46CAoZsJbscdheSVw5IdOgzVZZRqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yc4oij1qguvE2qTc64DTBA8PoMiHrA3p6D6Wziql+uE=;
 b=eCd8cXpvjS/87mvPSElv2l8XjBVgKYeeoNuQEYbdxuqQ50QLF8aMwePpkftbs+HnJ0GYFhfw2HcKVd7giBF1J1B3/lIB1y4bFS3OSFug8iQ+m32lxgoZ1oUxcNRObo2JRWilxfpfkkv10ZZzLyEBEE65z3Irp+rKROfhiL5pEWDF6xmh8n5VIlU5N0750a0SrryCfGIxdX2EL4xdbU73V/zfI+qLLz2HsAqESwcN2rA3QrvMExj/a7qX4my6PT8V/SuJ0roaLTlexm5HMJay4y/RaxubnVBtvS0I/N4hs/PNiDmu6LUsmE4CL7SyPWEzKa+Im/knK0kfJCkI/r8F/g==
Received: from MW4PR04CA0247.namprd04.prod.outlook.com (2603:10b6:303:88::12)
 by MW2PR12MB2395.namprd12.prod.outlook.com (2603:10b6:907:3::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Wed, 2 Jun
 2021 12:18:22 +0000
Received: from CO1NAM11FT060.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:88:cafe::bd) by MW4PR04CA0247.outlook.office365.com
 (2603:10b6:303:88::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.21 via Frontend
 Transport; Wed, 2 Jun 2021 12:18:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 CO1NAM11FT060.mail.protection.outlook.com (10.13.175.132) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4150.30 via Frontend Transport; Wed, 2 Jun 2021 12:18:22 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 2 Jun
 2021 12:18:21 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 2 Jun
 2021 12:18:21 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 2 Jun 2021 05:18:18 -0700
From:   <dlinkin@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <stephen@networkplumber.org>, <dsahern@gmail.com>,
        <vladbu@nvidia.com>, <parav@nvidia.com>, <huyn@nvidia.com>,
        Dmytro Linkin <dlinkin@nvidia.com>
Subject: [PATCH RESEND net-next v3 16/18] netdevsim: Allow setting parent node of rate objects
Date:   Wed, 2 Jun 2021 15:17:29 +0300
Message-ID: <1622636251-29892-17-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1622636251-29892-1-git-send-email-dlinkin@nvidia.com>
References: <1622636251-29892-1-git-send-email-dlinkin@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f2fe7d36-0c54-4f26-b6fe-08d925c0839f
X-MS-TrafficTypeDiagnostic: MW2PR12MB2395:
X-Microsoft-Antispam-PRVS: <MW2PR12MB23950D92B13EB73D46F164DECB3D9@MW2PR12MB2395.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:506;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bs+96gkp2sccDZYP9aDyhKNBMGtQ/TQuVvGdkUTY2PSoMeS2lur3+oHxoo2kthfUferw0BvfldSMeVsL/5n6YwTcHGyztAGb5mbqGM6j4ctoKefZmWwnlV+cydDkwr7ts8DhE5h1AkHfBNXi3LpecmcmNnq6Ilt0Yq/Q/K0mnOw8ZRqZrDF64Y6S1be4BoVnUE6G4uggcaz7H4irBCfbfxCRq3Mv4IUqqhegSY9zF1/K1JqUIqsvWYnZfgGSz8cVUZvsOELBzAIQOy659MlbX190yY4qlti0KiIIIyrVS4w9Q4AqYaZtZQKHYrzjtDuBDcc6cnXLy52fcGeH9y/J80L7ewkAJXasU5KifmyqoHqtszQAycialx551UFFPuonIfaB80mMnLc5+RduDbcHPi6JbGKtp+hydOVB4AeewDKXscsEjRFtjdDgnk3C82zjPnhjmu7rP1XL3+6XMZhfGglUIDfGuTAgPoaZ8/7qC5Gwkju0MiBiG37nNCzNQL8pevyGeA5/yBHyteCei22AKHXceoRjxhHPwh/YsqQuL54mWgbc4UzmooBPQNaOeMOycQMh5XPN0UNA40egQsYBVWRi2n/VqV+0QNsEVsKPrDh53wNdh/KkDAIDaFVlViTDO16Y49/T3Cca8GeR508myg==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(136003)(396003)(39860400002)(346002)(36840700001)(46966006)(7696005)(36906005)(2616005)(26005)(5660300002)(36756003)(336012)(36860700001)(478600001)(426003)(47076005)(70206006)(83380400001)(4326008)(8676002)(82310400003)(2906002)(86362001)(82740400003)(2876002)(316002)(54906003)(186003)(6666004)(8936002)(356005)(6916009)(70586007)(107886003)(7636003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 12:18:22.0877
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f2fe7d36-0c54-4f26-b6fe-08d925c0839f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT060.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR12MB2395
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

