Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 806B23916FD
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 14:03:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234717AbhEZMD6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 08:03:58 -0400
Received: from mail-mw2nam12on2064.outbound.protection.outlook.com ([40.107.244.64]:6881
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234579AbhEZMD0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 May 2021 08:03:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P+BT7iuXqJnP6dc1Qf36WsSbi3z1KzhyGbCTqqaJ3peNLG0VWZc7Z2ffhpuL3F2h0RN+HxNtNxtWfspsndyzf1mY0Hu2K78lcdRFC0Ok6oIn+clU+FiiqYtT9DS9bNXmdABrG5pAfkoTUCDzZ2mI72iyCufbdAQWlQOHZDcN83FpkW+VOxlgOHipW2CX+M1NcSEqbJRIj3yEjkCPiV0Yen0QVOyVYNuS+XaGj7icbYHg6gngaD11keHY+/zAfIu6wwhlzUewfTmF69lTqGAbmXQqUb3GktODx3kqGPQwxn3uvJSbf33pcMt2zZ79CmpAOswA+NMbnoWiMYt4d6OnLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cL3ZnTn3qGmr3iiNyXJS/cppuUvMhX78ihky9vnlb/w=;
 b=FPVshRGRd+FieVQaWFGDSyQBzYBB/sC21Gz0mMzOgh3PNM87o8rd/PfAZyNvO/KsjUQRodmo11qC4ntlzMqwRgeCSA51HqW9MrIVuLUa2EqO8OUkMU1Vz+8Bq8xrxZqYUmN4XGfRqi4O8IcaJqY5O9cfe9uhf0FV2ukfJPj3WGgoXWihJFhJjJtKUdTPJGECDcGLdZEb4NJKbzpFQfnVVbtlXj4NriyDGfHFHLjO9wN/NcAj12f6ese65aUO2VvRrubE54Z21nhxGJnWJELsSulY/QCozpgC7NgJilU9uIyVSbJ4WuAEVy3cj5A53JvcA6gh7bc+fk+80WpqOWgJyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cL3ZnTn3qGmr3iiNyXJS/cppuUvMhX78ihky9vnlb/w=;
 b=f0kcoSLjBBXc3+yCVnfiyoG40yRmS8BcEvMMQRY4whyLbaFkwYpKNNHdZUB2SYxYjYsOVndjFzh1ivvCpL8uIs174wAgPOmDiU146T8u3x+DWbPp5vpyjYWb17bM7jCOYe4tdcdBckqJb/v7KoRehk5HjfiYyEk/BQ15UAtraC/8gwgtzLOyNdrGSVW9I8jKvoTDPHwxLfu1lJlJEuA0MoaiWAnxEFIkDMhaAj2vQS2HuRnigAah6DYNO/NUPJMzzn3o0OOQ0b1f99CDW4Ij1Qx7i4vx+wN2pLiI24sAArW84HweUTRIDgpcoeA8FN/XEEIl1+UYqOpbV3Js26/THw==
Received: from DM6PR05CA0054.namprd05.prod.outlook.com (2603:10b6:5:335::23)
 by BYAPR12MB2918.namprd12.prod.outlook.com (2603:10b6:a03:13c::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26; Wed, 26 May
 2021 12:01:54 +0000
Received: from DM6NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:335:cafe::d4) by DM6PR05CA0054.outlook.office365.com
 (2603:10b6:5:335::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.12 via Frontend
 Transport; Wed, 26 May 2021 12:01:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT010.mail.protection.outlook.com (10.13.172.222) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Wed, 26 May 2021 12:01:53 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 26 May
 2021 12:01:40 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 26 May 2021 12:01:38 +0000
From:   <dlinkin@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <stephen@networkplumber.org>, <dsahern@gmail.com>,
        <vladbu@nvidia.com>, <parav@nvidia.com>, <huyn@nvidia.com>,
        Dmytro Linkin <dlinkin@nvidia.com>
Subject: [PATCH RFC net-next v3 09/18] devlink: Allow setting tx rate for devlink rate leaf objects
Date:   Wed, 26 May 2021 15:01:01 +0300
Message-ID: <1622030470-21434-10-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1622030470-21434-1-git-send-email-dlinkin@nvidia.com>
References: <1622030470-21434-1-git-send-email-dlinkin@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f9ceecde-9973-48ff-02a5-08d9203e0dc1
X-MS-TrafficTypeDiagnostic: BYAPR12MB2918:
X-Microsoft-Antispam-PRVS: <BYAPR12MB2918DF8D086706520A60D8EACB249@BYAPR12MB2918.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:935;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MdcqF4ZQ1qbaJTen+j6bn0w2eSYSdXkwV1kKlvJCOcOhhi1nmW0jYKShXFixYkyWz0NiPzegrkOQ4SWYjlTLR6XKnDcJLg6u05jRJkEKqkl/hSFJ9XM/UYj6NXZ2XVYn7mf7y11deyQ4GVxx9uVKrGTtBLshyYlDP7F6fdvX9aeOJM7Kg7UJMoU9TR8Ors4IPtZ6uBztuBF4SwMR9/HUP2qnMsdUIa/9jqPafUCCnFjephFrdZ6rDNUdzjzSQ2saxxvIN+aBn9T47nzncLuEG8WKk4yOcrppI1hFNrb7k2S1NgMB81gxGKTtT/V4avhVXOQyiIhzwq9h9I/6o64GUaoyASjntKhhL5tizHDkiDWXsx8JjwiqZTmVCImPrVL37cddBz3G5wtxpGVXGx8h36wksY/VnMjJTGOjTcKqd7higakkuAq3W3x9fE3NHY6qBzUH1K0z8JuZbjjrbFM7hsfofkeFxc6KIyPiQZgpgW8woCEcPIDhGwwfXphADDG04kyZUq/VvlNyj8NTGIcoZiNN7tvXV7aT6peMCfs+DaOF1SSeRp2WWE4PsXtr5xYkYpo4vwGrmCQCQpXmyjn51LiCVxC7AaezK6xzP76ADO5hbd9q7pKxo6uMLAHvAb5SUcwgXaHKDHDZX1j9mZfeintliRESNrSfJ4jDHi2vppc=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(39850400004)(346002)(376002)(396003)(36840700001)(46966006)(2876002)(36860700001)(6916009)(8936002)(7636003)(82740400003)(7696005)(54906003)(82310400003)(5660300002)(8676002)(426003)(2616005)(86362001)(36906005)(186003)(83380400001)(316002)(70586007)(70206006)(356005)(47076005)(4326008)(336012)(36756003)(478600001)(26005)(6666004)(107886003)(2906002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2021 12:01:53.9240
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f9ceecde-9973-48ff-02a5-08d9203e0dc1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2918
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

