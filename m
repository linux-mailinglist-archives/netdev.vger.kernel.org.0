Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B44537C0AB
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 16:50:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231553AbhELOvh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 10:51:37 -0400
Received: from mail-dm6nam08on2041.outbound.protection.outlook.com ([40.107.102.41]:29121
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231549AbhELOuk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 May 2021 10:50:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mmr9AhJ1/sq4nouPy5f8FQocrlzv/bQtIXrFsatSOHTAiHPJ9+CW4boWgoBGLd4DpkVVDxWgPCox7u3KSTNXu+uxs1mErNfvSPmKOLu0KmnMl31BEYCj0GTjsQJj5JLC8thrr1wVo2Uxz4t8VsZnF2UCq1vU+S6xuCbfO7jcJo7hyjqchF+9qij+MdAPFAGQsCSjTx2cqQdEa64813+5XdiGkdBCii0ssn1qDDtNp3w33Pp1tOssUBR/LkvBYeq3rqtyjzkZQoP6CLKkflOYT+xcGcOcWaYaTy6Tn//A9Vjvc0ErNr4y4418jZ+StKPVAP1gtmHsyIAN/Dw9AA7VjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CJqsj1J9WYSG8X83qEN61c3p9shjFqdxYD2tBpKx+kw=;
 b=XzNrX8YFAJCBxtOT76xQmdzV3DW9uUoclI/4Twf/C7sm10oCXQTysPWTcY2QKcN/7ac1nlmb463jg88bZXOM51iOHeEfYCV/NAorSok5lFLZsO2ytF1JT7velJXvM+YuvdupomS7MdcEaIz6dIHweWAeQ/UA4uRO6OnXyRLRk3VZtLmBsqHlIYWZ9B6WG6/vV3C7Wdb+SfJnqTrt+M+fiITyq9xZbVaSja5m37JE6oPvSbPYwZzhbHOMZtWaKhIMvga8PorDussixR2HE5vYCoVd07M42OLvacjHviEnx5HP++Ix2IN2+asJe5+55pVqohZ/j0Uf2mdjtZgv6Zdwmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CJqsj1J9WYSG8X83qEN61c3p9shjFqdxYD2tBpKx+kw=;
 b=ZhIam06Vts/9ZtyqnWjmL4y1tcSEBhgoUI3gc/vIy7yPMtl046Q/2QmQ7tYtd9e7SJnrdWS/JP0+mT96xlBZzLoq5LDJlV3nIqdIcBBPxkNNp9dXvJaqFYBhfXCWaiq28bL1RyBSyQdsspEak1wWfsAjsEGpUfGGFWdjyqwHfzJTG24WXu5wE/ykO1/UpeqWHfPTyXmFeOX2E5DwQbPudHP0tS62fLGxPO/Glv7r/x18UoCwEeWWpb361Xv1oDTqABw0P8KMAzx+RbE4JoX8SVzzEp7KuoF25OoImeZpptyl/4Oh2AVO9dtPYibZL4ngjtjapDIcD7j5fDFvK3HyWQ==
Received: from BN6PR13CA0012.namprd13.prod.outlook.com (2603:10b6:404:10a::22)
 by BYAPR12MB3318.namprd12.prod.outlook.com (2603:10b6:a03:df::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Wed, 12 May
 2021 14:49:30 +0000
Received: from BN8NAM11FT031.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:10a:cafe::cf) by BN6PR13CA0012.outlook.office365.com
 (2603:10b6:404:10a::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.11 via Frontend
 Transport; Wed, 12 May 2021 14:49:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT031.mail.protection.outlook.com (10.13.177.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Wed, 12 May 2021 14:49:30 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 12 May
 2021 14:49:29 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 12 May 2021 14:49:26 +0000
From:   <dlinkin@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <stephen@networkplumber.org>, <dsahern@gmail.com>,
        <vladbu@nvidia.com>, <parav@nvidia.com>, <huyn@nvidia.com>,
        Dmytro Linkin <dlinkin@nvidia.com>
Subject: [PATCH RFC net-next v2 13/18] netdevsim: Implement support for devlink rate nodes
Date:   Wed, 12 May 2021 17:48:42 +0300
Message-ID: <1620830927-11828-14-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1620830927-11828-1-git-send-email-dlinkin@nvidia.com>
References: <1620830927-11828-1-git-send-email-dlinkin@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d676353e-339f-4a1e-aefd-08d9155525ea
X-MS-TrafficTypeDiagnostic: BYAPR12MB3318:
X-Microsoft-Antispam-PRVS: <BYAPR12MB33180775D0490038DAF23DACCB529@BYAPR12MB3318.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1148;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 75xEGtMIu3Nv6cgAm7j3X3QVAf/hAnG45yPDODN1w7gWkgGYpD4cnnUSvFwheGqSVyQbbMxsT/l1nSspzZiMvFnJSCsMHOtL7g2U6dHpb5e9AHpDENfmaiUrdqiKngmT7sGidurpXKJ6lTDgJurHekYUGMnFw6Vc3RhElN//BIFRATaIyde90wh4xWAUHQhtESKdKk3JfDzZd1btNkZsdCH/aHSPFjG+VqttbBAEfnBvliPNzWCB1pSJTOzkKFy/gSt7EUMAA0kFGxACJ2e6MTftDqlVE5AO/srE0pWlB+XCDmySGe1IfZDI6HRO5qnvBjbNdB6lL6xVaY0rc11tqaI7xy+APM5tJLpn5P81bWbcQVNaO3Fx8CU4NkWQ0h3N6CyJsCqhEVaO8ySlaD2sK1IUEWkhie+Dt/NBRMhU7Y66XTE/aqQXWmZrmK1b3oolRpbBYB4Hg4SjEDh1+G27MKuK7KJEcBZUaUMs7IeL86KXBzcELbFKGpVZ6qbFIy8WXKCp0V7tkapSJ5FNeJWesuhAnuJxCk+BAiUhnS7lgKuMsxScWYdHAYozi9PQeGtqxzTiZcM1N27rbFWmfFyQGaQ7v0zTb/igocSDor8SPafcO73wBHtUD13sKoyrmSCDF+DSohJcZaQpJcc8LJeqVw==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(136003)(346002)(39860400002)(396003)(36840700001)(46966006)(478600001)(36906005)(2876002)(54906003)(2906002)(4326008)(316002)(107886003)(5660300002)(336012)(2616005)(426003)(70586007)(82740400003)(47076005)(70206006)(186003)(6916009)(7636003)(86362001)(82310400003)(8676002)(83380400001)(36860700001)(8936002)(6666004)(7696005)(26005)(36756003)(356005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2021 14:49:30.0387
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d676353e-339f-4a1e-aefd-08d9155525ea
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT031.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3318
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
index 5be6f7e..0346457 100644
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
@@ -1060,6 +1064,76 @@ static int nsim_leaf_tx_max_set(struct devlink_rate *devlink_rate, void *priv,
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
@@ -1077,6 +1151,10 @@ static int nsim_leaf_tx_max_set(struct devlink_rate *devlink_rate, void *priv,
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

