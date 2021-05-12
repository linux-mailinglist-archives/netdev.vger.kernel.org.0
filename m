Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC8FF37C0A7
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 16:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231558AbhELOvM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 10:51:12 -0400
Received: from mail-bn8nam12on2088.outbound.protection.outlook.com ([40.107.237.88]:10848
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231455AbhELOu2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 May 2021 10:50:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K2hll0fGZIfFc5dIJbXP4eqSeBbCJLXzk0U09sGxzYxwhI7yhZ/wxRleMlUfG+zmGVtI4yozL6U+izlrHSZe8CdGy4SIlbw25KpuWlRfwZFokSJa42h6kjF/7PaPlhF0Ssb/1TASR0yY+I22tG6/TXb4Fpu36o5JhLPwlIeMruphDoPpLp6KIXvDaW+vq7pASNguK+lWsPLnHqBiM/HXBUBQlp3UevJmp+VQwz4HPNhpvIbPesgv4TfdJTB4xXqCf9CQ1rU75D1r6K+6SHkc+DPwytLnv7/mTRgGEhEsUeKj5SYSSmnX7yJZJVcA3fo8h/qwodBvs4OMVHeUoSErKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cL3ZnTn3qGmr3iiNyXJS/cppuUvMhX78ihky9vnlb/w=;
 b=Ly5nAykIoUfYp6jQn5wFGchQAHDjLrLi3yw9s8ydxo2d+4Yj5pJE5zsTBrJPRkagktCTBk6XlOyzxF539qLSqQNoudBfcj1IfNIN8BH/1AzUV/x7Dj3vbgzq2WljG3MmkdM9N158oF0JYs08oiJpXZNd4/DCzktvWOqkyp8Slo2bRdMU4FRcuf2pkLXDqH+Icy9YZ1FA+zqQnzEmjhMxe4bxmQdjb9ZWmY4HsqTn+us8G85xZ7Oz/6k9eC4XGBq+5bLo9dhQCz6Bsuu3edZymGdGBrWNhc8PFKpX+3i061fadU38G4FsWsTC1ZS72OzmHJW7GTz67JE/65ES+NxL4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cL3ZnTn3qGmr3iiNyXJS/cppuUvMhX78ihky9vnlb/w=;
 b=X4pAmW6S6+xh72xc6H00yhDxy57KbgavlzUSjaaCxxd82Jji0CfIWm7A8/n6vrJ6ywIyxZg5/ekY6z340txzlC4XesADZ1SHpUOvrPm/v0hUL4rd2KIJkyE4ZP27dmaMikTUk0zGR6EDrAo1wDnzunmpinlJejJDpZuIf4+bXijW6HHHIdNbKpKWhJyaSlNB4wx9Rad8cA/7Z7zuzqtZuxdRLLCzdGZtmSEr6OpvtotzBjMiFXarFJdkT3zDtuw7yoPze5y0nYpM3fqtvPnBe5ic2tmb/xWAVg4xft41TbTvDilVAhVATIFsxfXUBImaTEyRejxEsIRWzLNCJtErjg==
Received: from BN0PR04CA0053.namprd04.prod.outlook.com (2603:10b6:408:e8::28)
 by MN2PR12MB4285.namprd12.prod.outlook.com (2603:10b6:208:1d7::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.27; Wed, 12 May
 2021 14:49:19 +0000
Received: from BN8NAM11FT015.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e8:cafe::e0) by BN0PR04CA0053.outlook.office365.com
 (2603:10b6:408:e8::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.24 via Frontend
 Transport; Wed, 12 May 2021 14:49:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT015.mail.protection.outlook.com (10.13.176.90) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Wed, 12 May 2021 14:49:18 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 12 May
 2021 14:49:17 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 12 May
 2021 14:49:17 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 12 May 2021 14:49:14 +0000
From:   <dlinkin@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <stephen@networkplumber.org>, <dsahern@gmail.com>,
        <vladbu@nvidia.com>, <parav@nvidia.com>, <huyn@nvidia.com>,
        Dmytro Linkin <dlinkin@nvidia.com>
Subject: [PATCH RFC net-next v2 09/18] devlink: Allow setting tx rate for devlink rate leaf objects
Date:   Wed, 12 May 2021 17:48:38 +0300
Message-ID: <1620830927-11828-10-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1620830927-11828-1-git-send-email-dlinkin@nvidia.com>
References: <1620830927-11828-1-git-send-email-dlinkin@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 005e4d0d-0a5c-485b-b305-08d915551f51
X-MS-TrafficTypeDiagnostic: MN2PR12MB4285:
X-Microsoft-Antispam-PRVS: <MN2PR12MB42850C26AA8015CA077E3C3FCB529@MN2PR12MB4285.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:935;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3tsBfUpwyoyA12bsVDNyxAYGoE0OI8BcEfTz5mnLbkE1Hyri5QTe+ZxPi2Q91e4tHeVknaRBOaoqldaiF7x1xrilJciGlmw4iuNrWis9nd8YW73VA9at9yz8aWQ5Bb21+ZQOZRf6w7MHXWaJGpSXo4jWIBEQfhJdtc936+qAMy/SF1DgF8BtEPi1rjUuk39OCWyT2GoFmn1Q/c3F0OMQsiJDKOHP/lcM6uHXSYtRYo/fgdYWg5D9jpydv1iiymXWY4+F9L8o4Wexa+k2N4I+fisCcTdg5YgbOJ9BeIQdqn5lMTS8dgvcHXpIdFY3HXzBI2LJPXveQUWPY9w3HccldvPj4bIy9POFB/S/yZ/YMBb+HrkrhiWP5Ero5OAgnX3eA7QV/qf6WgCNxxjq3YnxlWUpLwI7IDGTENn8YjjKISlgMJbMIAKAu3S52HXUU8z7sC3E2VLcxirzwGAe18b9Ds47RSs47HYXjIabRpIEdt+GOdWUy8cwOCgVvTpi3xhaYwa3YLEX0Ii+p+LALJF7oCf74/uVzbt5PNmBOgsTzbXKD5uOGVPE2fvBIn4cMhbjO/vPufqXYYIKlrYLwUdsEQSSAE8janwzwZeSqqPbmgfyDgT0b85NoTRexwShKu/003JPV1pUVGu4tDTNaF7swvYYtgWl7yvRMcb4Upadbzw=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(376002)(346002)(39860400002)(136003)(36840700001)(46966006)(8676002)(2906002)(26005)(36756003)(7696005)(86362001)(36860700001)(82310400003)(8936002)(70586007)(186003)(70206006)(107886003)(426003)(54906003)(2876002)(6916009)(4326008)(82740400003)(316002)(36906005)(2616005)(7636003)(5660300002)(47076005)(478600001)(83380400001)(6666004)(356005)(336012);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2021 14:49:18.8978
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 005e4d0d-0a5c-485b-b305-08d915551f51
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT015.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4285
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

$ devlink port function rate set netdevsim/netdevsim10/0 tx_share 10mbit

$ devlink port function rate show netdevsim/netdevsim10/0
netdevsim/netdevsim10/0: type leaf tx_share 10mbit

Max rate example:

$ devlink port function rate set netdevsim/netdevsim10/0 tx_max 100mbit

$ devlink port function rate show netdevsim/netdevsim10/0
netdevsim/netdevsim10/0: type leaf tx_max 100mbit

Co-developed-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Dmytro Linkin <dlinkin@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---

Notes:
    v1->v2:
    - s/func/function/ in devlink commands of commit message

 include/net/devlink.h        | 10 ++++++
 include/uapi/linux/devlink.h |  2 ++
 net/core/devlink.c           | 86 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 98 insertions(+)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 2f5954d..46d5535 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -139,6 +139,8 @@ struct devlink_rate {
 	enum devlink_rate_type type;
 	struct devlink *devlink;
 	void *priv;
+	u64 tx_share;
+	u64 tx_max;
 
 	struct devlink_port *devlink_port;
 };
@@ -1465,6 +1467,14 @@ struct devlink_ops {
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
index 28b2490..eea1f88 100644
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

