Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37D553916F8
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 14:02:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234705AbhEZMDw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 08:03:52 -0400
Received: from mail-co1nam11on2085.outbound.protection.outlook.com ([40.107.220.85]:30432
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234566AbhEZMDZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 May 2021 08:03:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oB2pdURtUKPq/Wf3PM+YPkI3+gTpficKPq/QVV+1AV7pcl3Oc5bvZlgyFvyaMiVunVk5ZNmQSjYkoyWpXULqrIbb+Ac/vZUTkPwJyqHcp7oDa0rlb38vlVfmGUXwq3twdnTlpv5mBuhO/GnBTTwn2lXHO28f5BhCFiaoR3SNW9FxbMFFhRpF5Pij8jrEV7r2kAbkFKiq2Thr/1FpG9PQdKz+92tM5uKJtRmiat5zZ39WyLpvxvgOywlXU6Dr1zmoelh+pFPvqw6+tZ42uHn+ywOgiQaFLJPNKlFI3DKh3forhFUzXMSvS9csGYo0j9wnTo/EeJ+w8bv7wcuzHKs9Fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jnnFqLUahqxi0XB2bKWKqZjExAF4o79lAwiKxxC8aoQ=;
 b=k/WAj1J2/guaqB9xQXmxKjifHYwo2bnYUnCYOdLL0GxqJOKJjomZD0cBVFBLnH6iiiTUcEeN4LzZrez9PLdFBo5s8s0RlXiFPRHW2bzmt8OYi4dP7eNzj+K5U/8VSe3TJsAi8525vnYQww0yPkI0/FBMcoa6O11dPrzxaBzXjoaC0gOtCO/jug+67nc/sl6WdcZkAypeaRaQ3z8hNC/dC+tcEyUuT/MWYsCD0Cfx6oz0uwXn/JzZhnQEPlg/5vcTOn4qGs/GbKpnLMWHXC1ryYakx8sk6Zizk2qAmxXbSxxNM8PMnpngYys9Kha4VmxJG0tPhK/KFNe5UyqgcybPNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jnnFqLUahqxi0XB2bKWKqZjExAF4o79lAwiKxxC8aoQ=;
 b=TGaqBAig5Cas6UuDuAfYQWUsyFFShY+mm8fAlmQEoFeTnHIQl2TWp5GnCvPJfoXbrgpUYcuzMgz8T+1RoAK4xKYjV3Dnt1atN+MAMgP44dgf/EnzlNBdgHfREPcbdIFovHj6emC/Ujh9NbRklf+iPGV7rg5g0uYnNCHf+/CMVuE3hYGI2Cl/UUCykBGzHd3B/O/2Bur/ifckgeLkBBntwVwedfhNcK4el6ijpKq62cgjtdpJoQxCvi7+B67IK1lDRL7yKvfSynpvbhfEKsLC85bnKkuQbk+csZIkqd47ydb658Mry7uGytLlsNxVvkNkkTaFCNkbgsFuB6u5Wmm46Q==
Received: from DM6PR11CA0006.namprd11.prod.outlook.com (2603:10b6:5:190::19)
 by MWHPR12MB1165.namprd12.prod.outlook.com (2603:10b6:300:d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27; Wed, 26 May
 2021 12:01:52 +0000
Received: from DM6NAM11FT052.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:190:cafe::50) by DM6PR11CA0006.outlook.office365.com
 (2603:10b6:5:190::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend
 Transport; Wed, 26 May 2021 12:01:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT052.mail.protection.outlook.com (10.13.172.111) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Wed, 26 May 2021 12:01:52 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 26 May
 2021 12:01:52 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 26 May 2021 12:01:49 +0000
From:   <dlinkin@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <stephen@networkplumber.org>, <dsahern@gmail.com>,
        <vladbu@nvidia.com>, <parav@nvidia.com>, <huyn@nvidia.com>,
        Dmytro Linkin <dlinkin@nvidia.com>
Subject: [PATCH RFC net-next v3 13/18] netdevsim: Implement support for devlink rate nodes
Date:   Wed, 26 May 2021 15:01:05 +0300
Message-ID: <1622030470-21434-14-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1622030470-21434-1-git-send-email-dlinkin@nvidia.com>
References: <1622030470-21434-1-git-send-email-dlinkin@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fc33a3a5-c88c-44e5-8263-08d9203e0cff
X-MS-TrafficTypeDiagnostic: MWHPR12MB1165:
X-Microsoft-Antispam-PRVS: <MWHPR12MB1165C989C99353B966AD955FCB249@MWHPR12MB1165.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:326;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FgShMbOMmiPS7vTD+BfPziTBp2Qe5j+8CL4i2KnRyrXr92L0oVxvbBmZumGwcBAtZ8ezFw47ZPp4I1PDHZY6754uG3yy1o9c0dAFrVoJg3CYbEBEqksIposhkAUxKspF8q+MrS5IW9YnAkWPCgc0uLmaoTj6nm49QN4hcEW6/7+T9si37xH6QHxIj8KETkjEEah885RPnXSrqXpUU/veFtoxjx+QrPoUtu0Nma4ylL0jSd6ifBkEiPnKhopgKrLGqz205vv8akzirQPlbRnbr/FDp1QrP7eDFvTDc88olWMHAeWOngdx4M9DybejaxZC2Fp/q15/6H2VCDaL9l9jxpGV0UWlJJV8F4sMETXPMIf/y2RgIc9+FYrb+o/er1JeCjVlD6DLjiBTiStsjIuMfgVEoxV4dVo2sTuNvQfEQ9P+jsovnmG0JpKS5tgggL27leOco7UQl3JDOLkDq4hoEdsyQnbmKNMTvhcP+3VGS/oDXNusd4/MW+SC1OJT2UAIkxzC+mH0Gm5f6BlJBXIdkoRdnivGTGoZ4pu90err5QZo+mSka/ZfQiVGFDcjaWy1/d21Mp1F8bkBp+Y3wjadqklXgJKFkIQQ5wfDL/GlfcEz7bz0DKkprKEGAJ8tR8omcwZouQ/sN7ztvx0TitndyQ==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(136003)(396003)(376002)(346002)(46966006)(36840700001)(2876002)(86362001)(70586007)(26005)(70206006)(7636003)(6916009)(8676002)(54906003)(6666004)(107886003)(82310400003)(478600001)(186003)(36860700001)(36906005)(7696005)(47076005)(316002)(2616005)(36756003)(356005)(5660300002)(82740400003)(426003)(2906002)(83380400001)(4326008)(8936002)(336012);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2021 12:01:52.6659
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fc33a3a5-c88c-44e5-8263-08d9203e0cff
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT052.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1165
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

Notes:
    v2->v3:
    - added devlink_rate_nodes_destroy() call

 drivers/net/netdevsim/dev.c       | 80 +++++++++++++++++++++++++++++++++++++++
 drivers/net/netdevsim/netdevsim.h |  1 +
 2 files changed, 81 insertions(+)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 5be6f7e..9f01b6c 100644
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
@@ -451,8 +455,10 @@ static void nsim_dev_dummy_region_exit(struct nsim_dev *nsim_dev)
 static void __nsim_dev_port_del(struct nsim_dev_port *nsim_dev_port);
 int nsim_esw_legacy_enable(struct nsim_dev *nsim_dev, struct netlink_ext_ack *extack)
 {
+	struct devlink *devlink = priv_to_devlink(nsim_dev);
 	struct nsim_dev_port *nsim_dev_port, *tmp;
 
+	devlink_rate_nodes_destroy(devlink);
 	mutex_lock(&nsim_dev->port_list_lock);
 	list_for_each_entry_safe(nsim_dev_port, tmp, &nsim_dev->port_list, list)
 		if (nsim_dev_port_is_vf(nsim_dev_port))
@@ -1060,6 +1066,76 @@ static int nsim_leaf_tx_max_set(struct devlink_rate *devlink_rate, void *priv,
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
@@ -1077,6 +1153,10 @@ static int nsim_leaf_tx_max_set(struct devlink_rate *devlink_rate, void *priv,
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

