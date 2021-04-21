Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EC2B366F7E
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 17:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244178AbhDUPyg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 11:54:36 -0400
Received: from mail-bn8nam11on2041.outbound.protection.outlook.com ([40.107.236.41]:16993
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244191AbhDUPyR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 11:54:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jAPPJ5ECz+eHoMxh6AFS5hKw3JypiXMKIAFXKnZHSbcq8/okAvMLokwIUkZ1oJEasiMwJkR53xqAZm3A8cLDAgbEURSdUmhvogmTQ7MJhexxpv464g3zVhYtuVkLS3phCOwEJb2OzJQ4jgLqvCMzmRy7wGnXEy7LEow+OSWXvutpvh1c8IpzLeTdftl8qrSLDHA7dblJXkqxymP7z7liuX1QqlKL40iEjfuwYmihMwjLzDJX09qGKhikf6F2nS0JuQYwWLZZpZuccdSBpgYiuOXaSSARCX/v5luzLbWRznJfZToXwXlP++ZDzTdGYBsDVx8ceJQets/ZuXqyD8PraQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LvfJ9BTjswVJ69GOoWSZkkSjJl5vSfDtzn/ICu0u6wE=;
 b=mE1cQ121GG0ths2k5TbVzeK8yaw4azvz3INK0Ff4xlqiU6anSo6xPjIvjwAdd66HWU2NdwSmq7Ln5m62p1usgS2UcHG5AEZsB6Fgo/c7WKncduX15zmHCnGosGAWVcXo4RGAZd+T+dA77JOMZU7XAwx93DshKAEQcHfJITMcLDUL1oTIx++FdG4LULZNgWLsFCVIGxIW75jbWYv8vq9Yc9i6zbsR1zXx2AyFiGbDuK7fxNewzxppwTiNviubGfuJmQVCLlRq+J8ZtCO9Vu2IWMNqkiBWi/Va1roKFy9Y1SR9hrr+b+tXWu+ZTDXNaRMDrzoc+HobDV1zZU+SWjugcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LvfJ9BTjswVJ69GOoWSZkkSjJl5vSfDtzn/ICu0u6wE=;
 b=nxm9MwtKSciRxnXjph0dj1dIsbTxcJZwlH7kcfu4I3NyPMsPbd5v/lEYWdEQ4htWeVd78GBmy0fSzpsj8XjS1TV2wrO9t6lcv4Jyn4P82xtK382R2Wt5/qYlyvmOQOwnQ98+HDj4A29QrE9wgx+8TbWlTnvkx47n1hViqqG805EwaxDqVcKDCxCaw52NLNoil4QEyhW+yQU6vvKKNQeE6ruq0Fg6VyFI6gCFsZEQ069Ow81s2Z+0x7771d10A4InCgEvgOzDM1XTSRFnqO7CH8j7OQkkQRHTnxPOO4OGuBSXkrdyAceapRNOXqC5x6jd68GqHkOCKlLoHoTHhHe13Q==
Received: from BN6PR20CA0071.namprd20.prod.outlook.com (2603:10b6:404:151::33)
 by BYAPR12MB4695.namprd12.prod.outlook.com (2603:10b6:a03:a4::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.21; Wed, 21 Apr
 2021 15:53:42 +0000
Received: from BN8NAM11FT046.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:151:cafe::a6) by BN6PR20CA0071.outlook.office365.com
 (2603:10b6:404:151::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend
 Transport; Wed, 21 Apr 2021 15:53:41 +0000
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
 15.20.4065.21 via Frontend Transport; Wed, 21 Apr 2021 15:53:41 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 21 Apr
 2021 15:53:40 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 21 Apr 2021 15:53:38 +0000
From:   <dlinkin@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <stephen@networkplumber.org>, <dsahern@gmail.com>,
        <vladbu@nvidia.com>, Dmytro Linkin <dlinkin@nvidia.com>
Subject: [PATCH RESEND-2 RFC net-next 13/18] netdevsim: Implement support for devlink rate nodes
Date:   Wed, 21 Apr 2021 18:53:00 +0300
Message-ID: <1619020385-20220-14-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1619020385-20220-1-git-send-email-dlinkin@nvidia.com>
References: <1619020385-20220-1-git-send-email-dlinkin@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 03f7ac22-8185-4988-ecf3-08d904dda2cf
X-MS-TrafficTypeDiagnostic: BYAPR12MB4695:
X-Microsoft-Antispam-PRVS: <BYAPR12MB46957A58A622B1E6EAB37DB0CB479@BYAPR12MB4695.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1148;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yYhGiY/IB0V0JxFD9SWph7utu5AgJnPxE6k630OoNdV4PvzXZKPUI05EZBSKSXMOgbciHYToJZxEWaBOG5zW7wVQOKRQGdFlxUOn5kJyovzN3V4W4ZmwOdGrdr2Yid2rnwFiWrhdLF3zjzCYx7hzmZ3PsICuYv8DYEPxCcjfW8FDMbsmgQ8tHBTfBb+oJjogxIFCe3f0IvBGCQbfla3ckGOa816bV6zzN4Ets+Yo3me/on0945R0doZVlyUj7KeQ6xcCAUlYVUmOo1bDMMVWC3R7aYe/obwNMI8ptJCQA8q+G494FTxi82MUCBM9TfUG3/jHeo9/4x/wER0ki44ekyVwcfsUvf4WxGSg4XXVBmzlfEg6jzKCfbxL0CN9ypo2AAbeRG9bvz25WocTs6psm+OrolLu7n1iIWpWK9J2Oy9W/QuJMBYLbX/472AanO8UrF2klHCxdLTO0HFrqVAXLwBj1u/qMv6dn73dmMaKpcmr9VcZwIctuZAiQK4n7FVO8Jri+QiAegEn1o+R6lJliFX4RhBRoLwF7i+ILINXUttE5Rv1KC9El0WtEZYv5hdmT7ZV9625YrXpnKDv03PsMFf4wdg1dRC5mURYOPU87mqH88pubW2jID4lfwGvLeydqwGcLuYB6g2YQplUztS9Wg==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(39860400002)(346002)(136003)(396003)(46966006)(36840700001)(8676002)(107886003)(6916009)(7696005)(70586007)(7636003)(82310400003)(54906003)(2876002)(47076005)(478600001)(83380400001)(6666004)(26005)(336012)(36756003)(5660300002)(8936002)(36860700001)(2906002)(356005)(70206006)(86362001)(186003)(82740400003)(316002)(2616005)(426003)(4326008)(36906005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2021 15:53:41.3636
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 03f7ac22-8185-4988-ecf3-08d904dda2cf
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT046.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB4695
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmytro Linkin <dlinkin@nvidia.com>

Implement new devlink ops that allow creation, deletion and setting of
shared/max tx rate of devlink rate nodes through devlink API.
Expose rate node and it's tx rates to netdevsim debugfs.

Co-developed-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Dmytro Linkin <dlinkin@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/netdevsim/dev.c       | 78 +++++++++++++++++++++++++++++++++++++++
 drivers/net/netdevsim/netdevsim.h |  1 +
 2 files changed, 79 insertions(+)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index a6dfa6b6..febc1b5 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -263,12 +263,16 @@ static int nsim_dev_debugfs_init(struct nsim_dev *nsim_dev)
 						nsim_dev->ddir,
 						nsim_dev->nsim_bus_dev,
 						&nsim_dev_max_vfs_fops);
+	nsim_dev->nodes_ddir = debugfs_create_dir("rate_nodes", nsim_dev->ddir);
+	if (IS_ERR(nsim_dev->nodes_ddir))
+		return PTR_ERR(nsim_dev->nodes_ddir);
 	nsim_udp_tunnels_debugfs_create(nsim_dev);
 	return 0;
 }
 
 static void nsim_dev_debugfs_exit(struct nsim_dev *nsim_dev)
 {
+	debugfs_remove_recursive(nsim_dev->nodes_ddir);
 	debugfs_remove_recursive(nsim_dev->ports_ddir);
 	debugfs_remove_recursive(nsim_dev->ddir);
 }
@@ -1059,6 +1063,76 @@ static int nsim_leaf_tx_max_set(struct devlink_rate *devlink_rate, void *priv,
 	return 0;
 }
 
+struct nsim_rate_node {
+	struct dentry *ddir;
+	u16 tx_share;
+	u16 tx_max;
+};
+
+static int nsim_node_tx_share_set(struct devlink_rate *devlink_rate, void *priv,
+				  u64 tx_share, struct netlink_ext_ack *extack)
+{
+	struct nsim_rate_node *nsim_node = priv;
+	int err;
+
+	err = nsim_rate_bytes_to_units("tx_share", &tx_share, extack);
+	if (err)
+		return err;
+
+	nsim_node->tx_share = tx_share;
+	return 0;
+}
+
+static int nsim_node_tx_max_set(struct devlink_rate *devlink_rate, void *priv,
+				u64 tx_max, struct netlink_ext_ack *extack)
+{
+	struct nsim_rate_node *nsim_node = priv;
+	int err;
+
+	err = nsim_rate_bytes_to_units("tx_max", &tx_max, extack);
+	if (err)
+		return err;
+
+	nsim_node->tx_max = tx_max;
+	return 0;
+}
+
+static int nsim_rate_node_new(struct devlink_rate *node, void **priv,
+			      struct netlink_ext_ack *extack)
+{
+	struct nsim_dev *nsim_dev = devlink_priv(node->devlink);
+	struct nsim_rate_node *nsim_node;
+
+	if (!nsim_esw_mode_is_switchdev(nsim_dev)) {
+		NL_SET_ERR_MSG_MOD(extack, "Node creation allowed only in switchdev mode.");
+		return -EOPNOTSUPP;
+	}
+
+	nsim_node = kzalloc(sizeof(*nsim_node), GFP_KERNEL);
+	if (!nsim_node)
+		return -ENOMEM;
+
+	nsim_node->ddir = debugfs_create_dir(node->name, nsim_dev->nodes_ddir);
+	if (!nsim_node->ddir) {
+		kfree(nsim_node);
+		return -ENOMEM;
+	}
+	debugfs_create_u16("tx_share", 0400, nsim_node->ddir, &nsim_node->tx_share);
+	debugfs_create_u16("tx_max", 0400, nsim_node->ddir, &nsim_node->tx_max);
+	*priv = nsim_node;
+	return 0;
+}
+
+static int nsim_rate_node_del(struct devlink_rate *node, void *priv,
+			      struct netlink_ext_ack *extack)
+{
+	struct nsim_rate_node *nsim_node = priv;
+
+	debugfs_remove_recursive(nsim_node->ddir);
+	kfree(nsim_node);
+	return 0;
+}
+
 static const struct devlink_ops nsim_dev_devlink_ops = {
 	.eswitch_mode_set = nsim_devlink_eswitch_mode_set,
 	.eswitch_mode_get = nsim_devlink_eswitch_mode_get,
@@ -1076,6 +1150,10 @@ static int nsim_leaf_tx_max_set(struct devlink_rate *devlink_rate, void *priv,
 	.trap_policer_counter_get = nsim_dev_devlink_trap_policer_counter_get,
 	.rate_leaf_tx_share_set = nsim_leaf_tx_share_set,
 	.rate_leaf_tx_max_set = nsim_leaf_tx_max_set,
+	.rate_node_tx_share_set = nsim_node_tx_share_set,
+	.rate_node_tx_max_set = nsim_node_tx_max_set,
+	.rate_node_new = nsim_rate_node_new,
+	.rate_node_del = nsim_rate_node_del,
 };
 
 #define NSIM_DEV_MAX_MACS_DEFAULT 32
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index 13a0042..d62a138 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -222,6 +222,7 @@ struct nsim_dev {
 	struct dentry *ports_ddir;
 	struct dentry *take_snapshot;
 	struct dentry *max_vfs;
+	struct dentry *nodes_ddir;
 	struct bpf_offload_dev *bpf_dev;
 	bool bpf_bind_accept;
 	bool bpf_bind_verifier_accept;
-- 
1.8.3.1

