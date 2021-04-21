Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5190366F7A
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 17:53:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244149AbhDUPy0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 11:54:26 -0400
Received: from mail-dm6nam10on2058.outbound.protection.outlook.com ([40.107.93.58]:43073
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244145AbhDUPyI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 11:54:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GYG93RMQUoVjjmNyiOG8tvjj38GnpvUXK0CPwaNfpr2DZkmQ91wzuAqF4cWicm5UZin65zyklqYPfz8HMNOAVgitOgENzr/hKprDXpl3IRen3aaAcAq+d3AL+z5yIpPh8WRVAsvQKcxrGfWuLVqJGr56dTKzVC30jcf2yES0661SP6kdtMAfIll+v3kpcFFVdMA1Djop0TB0KQy4vZldkQpzasQGzHWizMJnAUOsEvwa+X6s7uwFweOMTqL4Aur+EmKdAQDoObX3iyeNWSd9m4sMixbvNAULTSS96Q2LY560s5nyPe3yARrmsMj3NdC5ZXdt/KxsQ/JiHywNi+LWJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kWTUfPTVm3cY2HauZ6y1Th9I7kIjXvHznCS2MTCToXI=;
 b=mmA8rxV0t5bzqRynILlMx6x9JHMTui+JBKlg7Y3v/qlAcdOB2zl6re5A0r9wCppsTPv2gfjEi2WnwEx4nDjQE/jCva0EnBCjmIs3wstGRBxSP9chULhwF32iwlXE04YE0Cu90EPcJ2Tw3gSv5dglEqe3JqmXgpZpwm5Bo7rETqshUW5BdWvdtfNuseProu3kNeGYBG/n8sFV27foHdgTaRrRTwOOVeVNwLxMHZTVKDw4Zy7Uv93JPdS+npu6VDRqf+oilXyKB525/qEVbIt0osNi6kdfSqDDXdmywl4AuhODe0Jc/YIxuO723Opge/jUk0rkKjoXdIYNlv8BE9e/4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kWTUfPTVm3cY2HauZ6y1Th9I7kIjXvHznCS2MTCToXI=;
 b=TvlCEtD/s5yDrIyDgO6yHA6hJi15ArbXK5azu/hRJzRtIprmUtbfd+vlPg7enoB4xCchnSx9Z/isX/XIcWMJmwAPUfHJkWbpMWqZCHxf4YogP2m59WgszmKA6AtOL8ug5d4Wvur2LKoZl51J+KuN6KcIAQvf09aJbIUOYdIyXXbqXSfnm3kAojIAX34oOyERfhIsO1uHTyOZGk7iQQEI8w+vvoe++AMjQBzUS2Hvm8DF4X733+tdd0FPeioPsaff56QfGO2EAjlIKYdHeM81QluiX/vXzCpsEZ2iCUhsCL3Zt0cI1SS4jwDtkQVz5neATMKGlPPq3tLQj8tAiPoBwg==
Received: from BN9PR03CA0132.namprd03.prod.outlook.com (2603:10b6:408:fe::17)
 by SN6PR12MB2685.namprd12.prod.outlook.com (2603:10b6:805:67::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.18; Wed, 21 Apr
 2021 15:53:32 +0000
Received: from BN8NAM11FT005.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fe:cafe::61) by BN9PR03CA0132.outlook.office365.com
 (2603:10b6:408:fe::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21 via Frontend
 Transport; Wed, 21 Apr 2021 15:53:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 BN8NAM11FT005.mail.protection.outlook.com (10.13.176.69) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4065.21 via Frontend Transport; Wed, 21 Apr 2021 15:53:31 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 21 Apr
 2021 15:53:30 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 21 Apr 2021 15:53:28 +0000
From:   <dlinkin@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <stephen@networkplumber.org>, <dsahern@gmail.com>,
        <vladbu@nvidia.com>, Dmytro Linkin <dlinkin@nvidia.com>
Subject: [PATCH RESEND-2 RFC net-next 09/18] devlink: Allow setting tx rate for devlink rate leaf objects
Date:   Wed, 21 Apr 2021 18:52:56 +0300
Message-ID: <1619020385-20220-10-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1619020385-20220-1-git-send-email-dlinkin@nvidia.com>
References: <1619020385-20220-1-git-send-email-dlinkin@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fd403598-1386-4467-57bf-08d904dd9cfe
X-MS-TrafficTypeDiagnostic: SN6PR12MB2685:
X-Microsoft-Antispam-PRVS: <SN6PR12MB2685BBAA8FB368E262866890CB479@SN6PR12MB2685.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8sKGUmQJ+oovtF19nFI1AW2TiznCq8m85un314sElQkHxqYUYu+0OOLSxNqyW0/+FItdQgN+tvn58yJJsiJfTZGv9n2GD3EdBfwfW6Onu385a1fsq548iKIINyb0MO1B98kBzUWGqd8LtZwyKJ3K163Usf72b1ZHcbgDBVlsD/9i3kZm8c1l3bMhVE9q+ZB4u5q5H8+8T6QdSFxT08oj3Rf8q/0wbANzoGgEm+73Vyw/HQO70rCcMjmV+ULPZlw4QqwFeQ7atDn7DTVIVai/0oAZXbaRTBSTY3df3pPo9p9PyVirEgbIqREhOyXk2irIp+pdOXvHUcwrWKPner2gyJJHWXN/PP92SZ+LLfonjmmGSNCy9y+XE1xY2NzOP7u0y8VvpiGMRRcZtlU2buf5tPNyBOPqq1dpSsMKM1aHWoAgH9QxBHP3bQGTILUStq9j2dn+PLsWW7nE4goce666mndvpFDqD30+a+07Y7n0b691vHwdDUOXTWQ6JPNMwYBIX5wZFBWP5BZSSUWTiue1OL3DhokcAKUxNz+qtR4XXCDl9pj2FdLFywJW9reLmlfDvHlKuQ0xhk//ZBqhoHu65wFU/G+bSKD9Vrg9v5dFDVOpbu2B0/AZmhrg8wdKXBYlZo5XJX0/ydPdZRBpRXkkzh0EIU/kNTkOiye3SV9DhPg=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(396003)(39860400002)(36840700001)(46966006)(7636003)(47076005)(83380400001)(107886003)(2906002)(70206006)(8676002)(356005)(316002)(70586007)(478600001)(82310400003)(26005)(8936002)(186003)(2616005)(36906005)(426003)(36756003)(5660300002)(6666004)(2876002)(82740400003)(4326008)(7696005)(6916009)(336012)(86362001)(36860700001)(54906003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2021 15:53:31.6044
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fd403598-1386-4467-57bf-08d904dd9cfe
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT005.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2685
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmytro Linkin <dlinkin@nvidia.com>

Implement support for DEVLINK_CMD_RATE_SET command with new attributes
DEVLINK_ATTR_RATE_TX_{SHARE|MAX} that are used to set devlink rate
shared/max tx rate values. Extend devlink ops with new callbacks
rate_leaf_tx_{share|max}_set() to allow supporting drivers to implement
rate control through devlink.

New attributes are optional. Driver implementations are allowed to
support either or both of them.

Shared rate example:

$ devlink port func rate set netdevsim/netdevsim10/0 tx_share 10mbit

$ devlink port func rate show netdevsim/netdevsim10/0
netdevsim/netdevsim10/0: type leaf tx_share 10mbit

Max rate example:

$ devlink port func rate set netdevsim/netdevsim10/0 tx_max 100mbit

$ devlink port func rate show netdevsim/netdevsim10/0
netdevsim/netdevsim10/0: type leaf tx_max 100mbit

Co-developed-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Dmytro Linkin <dlinkin@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 include/net/devlink.h        | 10 ++++++
 include/uapi/linux/devlink.h |  2 ++
 net/core/devlink.c           | 86 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 98 insertions(+)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 073bc66..cbfa456 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -137,6 +137,8 @@ struct devlink_rate {
 	enum devlink_rate_type type;
 	struct devlink *devlink;
 	void *priv;
+	u64 tx_share;
+	u64 tx_max;
 
 	struct devlink_port *devlink_port;
 };
@@ -1463,6 +1465,14 @@ struct devlink_ops {
 				 struct devlink_port *port,
 				 enum devlink_port_fn_state state,
 				 struct netlink_ext_ack *extack);
+
+	/**
+	 * Rate control callbacks.
+	 */
+	int (*rate_leaf_tx_share_set)(struct devlink_rate *devlink_rate, void *priv,
+				      u64 tx_share, struct netlink_ext_ack *extack);
+	int (*rate_leaf_tx_max_set)(struct devlink_rate *devlink_rate, void *priv,
+				    u64 tx_max, struct netlink_ext_ack *extack);
 };
 
 static inline void *devlink_priv(struct devlink *devlink)
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index 0c27b45..ae94cd2 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -545,6 +545,8 @@ enum devlink_attr {
 	DEVLINK_ATTR_PORT_PCI_SF_NUMBER,	/* u32 */
 
 	DEVLINK_ATTR_RATE_TYPE,			/* u16 */
+	DEVLINK_ATTR_RATE_TX_SHARE,		/* u64 */
+	DEVLINK_ATTR_RATE_TX_MAX,		/* u64 */
 	/* add new attributes above here, update the policy in devlink.c */
 
 	__DEVLINK_ATTR_MAX,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 7acff15..4f0412e 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -803,6 +803,14 @@ static int devlink_nl_rate_fill(struct sk_buff *msg,
 			goto nla_put_failure;
 	}
 
+	if (nla_put_u64_64bit(msg, DEVLINK_ATTR_RATE_TX_SHARE,
+			      devlink_rate->tx_share, DEVLINK_ATTR_PAD))
+		goto nla_put_failure;
+
+	if (nla_put_u64_64bit(msg, DEVLINK_ATTR_RATE_TX_MAX,
+			      devlink_rate->tx_max, DEVLINK_ATTR_PAD))
+		goto nla_put_failure;
+
 	genlmsg_end(msg, hdr);
 	return 0;
 
@@ -1495,6 +1503,76 @@ static int devlink_nl_cmd_port_del_doit(struct sk_buff *skb,
 	return devlink->ops->port_del(devlink, port_index, extack);
 }
 
+static int devlink_nl_rate_set(struct devlink_rate *devlink_rate,
+			       const struct devlink_ops *ops,
+			       struct genl_info *info)
+{
+	struct nlattr **attrs = info->attrs;
+	u64 rate;
+	int err;
+
+	if (attrs[DEVLINK_ATTR_RATE_TX_SHARE]) {
+		rate = nla_get_u64(attrs[DEVLINK_ATTR_RATE_TX_SHARE]);
+		err = ops->rate_leaf_tx_share_set(devlink_rate, devlink_rate->priv,
+						  rate, info->extack);
+		if (err)
+			return err;
+		devlink_rate->tx_share = rate;
+	}
+
+	if (attrs[DEVLINK_ATTR_RATE_TX_MAX]) {
+		rate = nla_get_u64(attrs[DEVLINK_ATTR_RATE_TX_MAX]);
+		err = ops->rate_leaf_tx_max_set(devlink_rate, devlink_rate->priv,
+						rate, info->extack);
+		if (err)
+			return err;
+		devlink_rate->tx_max = rate;
+	}
+
+	return 0;
+}
+
+static bool devlink_rate_set_ops_supported(const struct devlink_ops *ops,
+					   struct genl_info *info,
+					   enum devlink_rate_type type)
+{
+	struct nlattr **attrs = info->attrs;
+
+	if (type == DEVLINK_RATE_TYPE_LEAF) {
+		if (attrs[DEVLINK_ATTR_RATE_TX_SHARE] && !ops->rate_leaf_tx_share_set) {
+			NL_SET_ERR_MSG_MOD(info->extack, "TX share set isn't supported for the leafs");
+			return false;
+		}
+		if (attrs[DEVLINK_ATTR_RATE_TX_MAX] && !ops->rate_leaf_tx_max_set) {
+			NL_SET_ERR_MSG_MOD(info->extack, "TX max set isn't supported for the leafs");
+			return false;
+		}
+	} else {
+		WARN_ON("Unknown type of rate object");
+		return false;
+	}
+
+	return true;
+}
+
+static int devlink_nl_cmd_rate_set_doit(struct sk_buff *skb,
+					struct genl_info *info)
+{
+	struct devlink_rate *devlink_rate = info->user_ptr[1];
+	struct devlink *devlink = devlink_rate->devlink;
+	const struct devlink_ops *ops = devlink->ops;
+	int err;
+
+	if (!ops || !devlink_rate_set_ops_supported(ops, info, devlink_rate->type))
+		return -EOPNOTSUPP;
+
+	err = devlink_nl_rate_set(devlink_rate, ops, info);
+
+	if (!err)
+		devlink_rate_notify(devlink_rate, DEVLINK_CMD_RATE_NEW);
+	return err;
+}
+
 static int devlink_nl_sb_fill(struct sk_buff *msg, struct devlink *devlink,
 			      struct devlink_sb *devlink_sb,
 			      enum devlink_command cmd, u32 portid,
@@ -7958,6 +8036,8 @@ static int devlink_nl_cmd_trap_policer_set_doit(struct sk_buff *skb,
 	[DEVLINK_ATTR_PORT_PCI_SF_NUMBER] = { .type = NLA_U32 },
 	[DEVLINK_ATTR_PORT_CONTROLLER_NUMBER] = { .type = NLA_U32 },
 	[DEVLINK_ATTR_RATE_TYPE] = { .type = NLA_U16 },
+	[DEVLINK_ATTR_RATE_TX_SHARE] = { .type = NLA_U64 },
+	[DEVLINK_ATTR_RATE_TX_MAX] = { .type = NLA_U64 },
 };
 
 static const struct genl_small_ops devlink_nl_ops[] = {
@@ -7991,6 +8071,12 @@ static int devlink_nl_cmd_trap_policer_set_doit(struct sk_buff *skb,
 		/* can be retrieved by unprivileged users */
 	},
 	{
+		.cmd = DEVLINK_CMD_RATE_SET,
+		.doit = devlink_nl_cmd_rate_set_doit,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = DEVLINK_NL_FLAG_NEED_RATE,
+	},
+	{
 		.cmd = DEVLINK_CMD_PORT_SPLIT,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_port_split_doit,
-- 
1.8.3.1

