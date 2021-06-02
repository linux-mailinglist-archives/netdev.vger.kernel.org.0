Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C45FC398944
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 14:18:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbhFBMUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 08:20:12 -0400
Received: from mail-bn8nam11on2049.outbound.protection.outlook.com ([40.107.236.49]:32993
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230053AbhFBMT6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 08:19:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RW6Vk64kZkqnEa8PWm8DY7nHvH6WSxlq94FJ6otxG219fHc5AR76zjgDBnmASaEpGlbbP5czBnjIcUgodyRYHg15n9YuhiNOjNum0lGIZnrZVkxCvcSL+wkfa8XLP6BRzFuD3qejm6hXMEkp1gcpAT7u3rUYfap5nm+7D1TWkQbDL5OGc9PNpifapWtlYo7iVupIOdQoUG+WwDOcgMVO4gAHAhLxG6vyKgXlYNriiWo8VmCTRHEw08BiOqrM0nzQmHOFuSv2kOUPnCnN5YZQ83/ExqxYZg+JuTeLzggPCXew9ifh86RoUgmZA2LekfbEKZ54faz9lO6nRQCtjT/QvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jnnFqLUahqxi0XB2bKWKqZjExAF4o79lAwiKxxC8aoQ=;
 b=FWhmM7+Kz3w1bOA9hf1ULfXErqqhht6doYy+tQvHjkukGP929sh5oX3Z9e28VncVtJs5tcTzAxOjKz9p5z97x316VdMcOo1aEvjEZB9yVD1f2/2q8jpwd637NBLzt4q4s2q+in965dAS/sbA4Pd0k6mzzBZWf0bbLVE3WVKC5xLsMUzM7fKqmAyBq5aMQTyYRtmnXuk3xn+QorMuJeHyPVLowzVFNaHjeByqZf0HP9iZmfJsXQfHAXtFJV0rA8R6FfqU7tI887blTVgfAkQgTDZxXx4qJHioKXaoPAPwrhGmuEdjRwNilhoJlmL4JwmDoWyNSTAhK51+gJyKvYp4gA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jnnFqLUahqxi0XB2bKWKqZjExAF4o79lAwiKxxC8aoQ=;
 b=G823e3BFxy2mnqAKAxwMSsVtXGQcVN37ylHw1pAq9TybTYNQrO6ix+8AeC5I9aoMRddu1nIRmrE8WzyX5B9C5dPZ6SNwiccW4VGTdOLyac5CNTqf2bYMUAiEi3iQNHXSH8VUmwE1MXZclXIcUW1NjQKdcU2vxAlEbsNwh6LbNa4BaoKTnbKXvbGmmylKdc+Y5WFt/BKWQAcJ8PcHs7EZQQPRwOFzhVoF364bxXWxNzrt/1//3WWhSww8LzGm384UxLJ00VOpBkL9lxwV9fdGCJEifILcjF1aOgRZrKjHIgLKsHR7RQtH2ETIM7XHfzWDMcVeUWTTVdyGk8+18WxY1g==
Received: from MWHPR03CA0023.namprd03.prod.outlook.com (2603:10b6:300:117::33)
 by BYAPR12MB2727.namprd12.prod.outlook.com (2603:10b6:a03:71::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.24; Wed, 2 Jun
 2021 12:18:13 +0000
Received: from CO1NAM11FT018.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:117:cafe::28) by MWHPR03CA0023.outlook.office365.com
 (2603:10b6:300:117::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend
 Transport; Wed, 2 Jun 2021 12:18:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 CO1NAM11FT018.mail.protection.outlook.com (10.13.175.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4150.30 via Frontend Transport; Wed, 2 Jun 2021 12:18:13 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 2 Jun
 2021 12:18:12 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 2 Jun 2021 05:18:09 -0700
From:   <dlinkin@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <stephen@networkplumber.org>, <dsahern@gmail.com>,
        <vladbu@nvidia.com>, <parav@nvidia.com>, <huyn@nvidia.com>,
        Dmytro Linkin <dlinkin@nvidia.com>
Subject: [PATCH RESEND net-next v3 13/18] netdevsim: Implement support for devlink rate nodes
Date:   Wed, 2 Jun 2021 15:17:26 +0300
Message-ID: <1622636251-29892-14-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1622636251-29892-1-git-send-email-dlinkin@nvidia.com>
References: <1622636251-29892-1-git-send-email-dlinkin@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2049d7b1-cf00-4300-7dff-08d925c07e45
X-MS-TrafficTypeDiagnostic: BYAPR12MB2727:
X-Microsoft-Antispam-PRVS: <BYAPR12MB27271A691D6419718D81CC35CB3D9@BYAPR12MB2727.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:326;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AYvOwqfpPm+5qbiRuJKCoBeHOncbXJkvoMQ+2xkVdeM9aZsmjmLcY8+o39HJSNqCTgcl7UrERacYyWuZywY7ggOfkDwhewWAiJRaYMQviGrq5BEq0sxxhJQaqULxUtXzFXQKj7XnvDMxLYF/Lr+vMmNqoaGQFDwFu1Bdwic0B70PMcW0FAOmi/b/wmI4z5sCTuZnBYFCIWBUDufdB1ZXUJ+AAU/WEgGKD1dc7zREL7bRWSXIFq3IO7YBB7utjPHiQHbL7Lnq6MxJD0EMY8easlWVlrdvTVYAjL/xLwI5Ihr9xF6LWV47y886sWW5ALkYMrND0PrcQKp6C/7+iDAjQCyjW0K3/rjZuav3BApJq6JkDzlpEUqBu+bgpnvNBMg3aanbdFyDRZXj0JIJkEeaj+08As2NgjDPVTl0kMyPMDYQvbGd5siS617h3n00n6h4wISx8Lrc9dg6f3PifCck3LaiXTLK1SGqmpOiPsip8WhkguKHlUzYw0S8KQxBlI+yOh0zHOoYBVhaaF30sRmSH3bAvHoW9wM4lPwjZLmOwoXPPZ/bll8OVWh4boR4c2O0a5f9ZbqbxHI+E9HhLln00ERVa3AWVhMQwoOpM33CiE/ckELU47AzRdfF2so/7+1liMjoM6KhTM2qLNxK6+G+Zg==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(396003)(39860400002)(346002)(376002)(46966006)(36840700001)(2876002)(86362001)(26005)(47076005)(70586007)(83380400001)(6916009)(2906002)(186003)(70206006)(7636003)(82740400003)(36860700001)(2616005)(426003)(336012)(478600001)(8676002)(82310400003)(356005)(7696005)(8936002)(36756003)(5660300002)(54906003)(6666004)(4326008)(316002)(107886003)(36906005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 12:18:13.1118
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2049d7b1-cf00-4300-7dff-08d925c07e45
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT018.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2727
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

