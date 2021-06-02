Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D77D239893E
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 14:18:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbhFBMTx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 08:19:53 -0400
Received: from mail-dm3nam07on2058.outbound.protection.outlook.com ([40.107.95.58]:11617
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229996AbhFBMTr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 08:19:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G+R7Ai3ymiqa682baomdl5lgRBqMNjbuP8fHOdFB58RnFxu19jMtZXxLToWjsqjZrZTNiC34CY2c0v8QBypq9tqODPNJmoseuhox+pYKeKD/V8jvVQkaE5VOZ1UtZEod+yVUPWuIUrEvbsAVLwSCSe5lg3fbrgap2/UUe3eVjmc5bibdn9ITdNvuYD67/LrilH2yF0Ddd1iSpehMftMc4l0jBIzbB9/UZfAw5mxvKF7k4qMi656g8ISY3hPqixjBLayMnB9ZaBeNHHgw9n/HFMweFbrR4U683AeH+Hp1HwtfT20a3+ouV1dwJ426A0NBjsCSkv7n8lB03eC6dsF6ZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cL3ZnTn3qGmr3iiNyXJS/cppuUvMhX78ihky9vnlb/w=;
 b=X5bidnka2pAsRX5ZjDyD8wQt6v7wWxnG6x6BnPR86B/ENTNqHM0WRvqQqZi8q4iZ6j8/QfrFDNiNVnx37f9BkjAt2HEircMD9FZleq9GNqN2Xx7Z/UHmz3Twc+xWVeRXxGbkZBr/EA6v3iwi2hYn2Tfb+/pF8/0fX10QJ/wHBk9rPjtJN2uTbg5UhJGeRc0j5Zq2vgvxnz75T4ym6eJpeHo7ZrH4ldz2eit6n7Z+ywMGimWwcBe53OYYy839rZJKgWkGCTkS+YtvzU2HyzDsVVKwlN69Yy6Q4lnedIQYaPAorUE7TnE7nHzdvvnOCyaAlBgQqRs/9vZs4KSSivyvRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cL3ZnTn3qGmr3iiNyXJS/cppuUvMhX78ihky9vnlb/w=;
 b=S1+czehs4WUb/i99zouKLFykrd+pjow/dwi/e2lGjAAbggyo8dLg39qFkfPnapo5mK8bAMX5/fXeJKcliXevJVSxXB9VwLbsKA5hw39WBTKmUISEPhJ4vykNzoPOsHGhW7kfbp/kCvw7MNPTXJWJpR7BwgF+UUrBgTCWMPE0KXitchCWF2cjOKXv3vLZhdDlTXXaVrvF1Q63NbrSKNlqv+HMsA09HLGcxA3FBGKtg0pTFw8Gu3R1z+Fif+m0iJubkDCFpm7BTsZFWTeAjI4ZgL3jadu1K2SFr88XDyacGVjfRx2dOy3F/LyA7bBDnt9N+oaFSFTa/xCg75Ugmvh4DA==
Received: from BN7PR02CA0012.namprd02.prod.outlook.com (2603:10b6:408:20::25)
 by MN2PR12MB4125.namprd12.prod.outlook.com (2603:10b6:208:1d9::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Wed, 2 Jun
 2021 12:18:03 +0000
Received: from BN8NAM11FT028.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:20:cafe::de) by BN7PR02CA0012.outlook.office365.com
 (2603:10b6:408:20::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.15 via Frontend
 Transport; Wed, 2 Jun 2021 12:18:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT028.mail.protection.outlook.com (10.13.176.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4150.30 via Frontend Transport; Wed, 2 Jun 2021 12:18:02 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 2 Jun
 2021 05:18:00 -0700
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 2 Jun 2021 05:17:58 -0700
From:   <dlinkin@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <stephen@networkplumber.org>, <dsahern@gmail.com>,
        <vladbu@nvidia.com>, <parav@nvidia.com>, <huyn@nvidia.com>,
        Dmytro Linkin <dlinkin@nvidia.com>
Subject: [PATCH RESEND net-next v3 09/18] devlink: Allow setting tx rate for devlink rate leaf objects
Date:   Wed, 2 Jun 2021 15:17:22 +0300
Message-ID: <1622636251-29892-10-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1622636251-29892-1-git-send-email-dlinkin@nvidia.com>
References: <1622636251-29892-1-git-send-email-dlinkin@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dbf2fda0-06c7-4f25-6f9f-08d925c077c0
X-MS-TrafficTypeDiagnostic: MN2PR12MB4125:
X-Microsoft-Antispam-PRVS: <MN2PR12MB41252583788D90692523404ECB3D9@MN2PR12MB4125.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:935;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9OBiGLhTgCDnQZR8zeb6O1ChgS6scdmbuvnp0p9COSulkMtvbYkjB+nCsWADvKXi38gwj2bHuRFgSOtuB1yOOekaLBI1BPGKEvbEOfl7GIIgYzhonew98JmPg3RPaHZ2K08E4ea1GtbztLRTAJriDxiaewJwi3rIfort73Vw5P+tBDvSc6a6ekBC5CT498HKV53PWqdDA/34l/lUOA9mC3sz8hP54m5vgz5vfLNZiC1ST2HlK+BLFFW64iUO24faPSnJE4a7eJZtj/OxDR36MQCGx8Ofn5jW3uUqobtgS2XltsfZr7RKa0eF9KPHwjjb1zjER0M5xLlQ7wFPgwQtsrjTrP5LBYpyasaLeknM3W8CeGoWtjzBB9HGr9AqXJVosf6B/EDJobKRG03zV6n27sP+ZcBNW1Vg8OqUHkarnUUK+7CWL1H8r5UE5wS6cUSfqU8jYTnD2XmTWoY0BFbyQOVqRXYPrJWDL8ktibza0l2dG1unlKK4Vwozl1bh2SLHh5txux9SgHbzL3sp3iDCYAc6BrRHAAACVWA+J1RjLvjp8ASwF73k8HG3ayqdf8dxkEBUbw0sCrPNoIeHsgNmvPFhozmprEpnhK825F3N+xZ1yiaYVyAMQtAGnhi0oTagSuIzFzmWwMDnA4YBozV1snvCc9K4ha1ESA+m/RyuPTg=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(376002)(396003)(346002)(39860400002)(46966006)(36840700001)(54906003)(70586007)(70206006)(8676002)(8936002)(356005)(7696005)(2876002)(82310400003)(336012)(2906002)(2616005)(86362001)(426003)(36860700001)(36756003)(107886003)(478600001)(6916009)(5660300002)(186003)(47076005)(26005)(82740400003)(6666004)(7636003)(316002)(4326008)(83380400001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 12:18:02.0945
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dbf2fda0-06c7-4f25-6f9f-08d925c077c0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT028.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4125
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

