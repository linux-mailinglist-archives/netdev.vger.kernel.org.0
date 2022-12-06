Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9760E643F2A
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 09:58:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234372AbiLFI6i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 03:58:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231474AbiLFI6g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 03:58:36 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2082.outbound.protection.outlook.com [40.107.94.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75A58FD1F;
        Tue,  6 Dec 2022 00:58:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EetaZhRXFY4S1m9NMgNmjhkCkPfGzLgScDhGcrElvc5THNxrC+QWmTXL5HeFGPL+3xcP6rwbSfPtFz5/SW2kNbR6lC3gy/1XVw73Gv5IKIWpgWiQAqMmgwHK4JP0LuN2RdtWySRQ9Vd0ilSxxo6bo9KLE/iYx6K98WAV6cec1AxHKv01150BLPLzEYhQjlDSIkqLOoubVMq5VEHMAsAs7gx3ZG5P0LfgfLIJLa/F56UNFJ/txkSP/WkrfHcHhuD8ro0EncsWuenxd0TjcUZeJzK6TpY5UchLRCHDptVTI8WyKyMB+gENPF5Qfrt41s2ZR2rZ+0Y5yD62QuHcD67orQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1r3Cnjmi+2Qkra5KbOAy8W1PS7xFr0DxxGDNFr8fgw0=;
 b=dpiUCAh1CltzsW7UBZq2+8Ngdtp+4khl+UIqZ90IRznn9H/nU/VG7w9sn81Tv3N3+onxBEnwIUXNqR7u4t3rpzGp2+2WRdgHeuRkYaUfVAO0OM9p/HivkH2JL9vwPlBJWvvl41O9TL6XrTD19kWmNB6/QB80zTPY9t0vsHevNTKYvk84eZSMOS+cOl3p25iNnaXToGnalMNwHnfOayzYFmLIwytSNAaPIa31xrSLnxjSvCOvUr8S7psipJXwoMt6NmGpTWrxpFrKJWP1gGWSKpQXkCfFpppJgPUgUxsH2PCpUgOZBFaGLH8nf69LNGjWs7vlbDN7phYGfdnt3FWlYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1r3Cnjmi+2Qkra5KbOAy8W1PS7xFr0DxxGDNFr8fgw0=;
 b=eQ0oXJMZ63vPxlmMIpkLpFSYYUSL9c5AWc8qS7zRv1KLXiQ/L4nqqvON3p4/YHgH1nI3OYxp7ybieHhyh8zXVxjFFOmfn4tOW1NBPfN5lbSNJD4Zn3ykfkJHfhUCxv+xZ3HkosTTOrGDQHuHMqgoeFT6o+4Qui5qQlAYXakw6gtgtkK/9Po8vU7Pm9JmHgX2zShvnCtYpXiW9tM5DewzO9aJCcgiaQd+rEnxmgOAgEc9M4IdVscUBziDckxp8oJqRu7TDZP0LQYEqhvQUTxBXAxzUZD7/mOd3cD1P3MSj+KkgeUpzNMkSMAAqu44ESxvaf97NcZNWHwG92FhOkVkNA==
Received: from BN9PR03CA0765.namprd03.prod.outlook.com (2603:10b6:408:13a::20)
 by PH8PR12MB7158.namprd12.prod.outlook.com (2603:10b6:510:22a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.13; Tue, 6 Dec
 2022 08:58:34 +0000
Received: from BN8NAM11FT092.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13a:cafe::7c) by BN9PR03CA0765.outlook.office365.com
 (2603:10b6:408:13a::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14 via Frontend
 Transport; Tue, 6 Dec 2022 08:58:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT092.mail.protection.outlook.com (10.13.176.180) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5901.14 via Frontend Transport; Tue, 6 Dec 2022 08:58:33 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 6 Dec 2022
 00:58:16 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 6 Dec 2022
 00:58:16 -0800
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Tue, 6 Dec
 2022 00:58:13 -0800
From:   <ehakim@nvidia.com>
To:     <linux-kernel@vger.kernel.org>
CC:     <raeds@nvidia.com>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <sd@queasysnail.net>, Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH net-next v2] macsec: Add support for IFLA_MACSEC_OFFLOAD in the netlink layer
Date:   Tue, 6 Dec 2022 10:57:57 +0200
Message-ID: <20221206085757.5816-1-ehakim@nvidia.com>
X-Mailer: git-send-email 2.21.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT092:EE_|PH8PR12MB7158:EE_
X-MS-Office365-Filtering-Correlation-Id: 56257b41-5c2d-491c-dbb3-08dad7680deb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u30ao1f5JjBRUdMIWdQvVLMcJDHkvJlaenwjEVe6giU4T6iDEyoLZULaK4Pe2STZnzKofz48m/Jj7p523wNDAOMY/Z5dinusKCbvZFBY/YwcIfPiAk5B0Wk119dTEFpnmV8FJY0vFYbKWts/biLECHUH6NiynJ+eYuUhJiqqGnZsLgvrfn8nkAbLDcBVC5g1X9C2NeuMpUj1dmF5eM/XNlOVUlriaKTV78HhqP7kiC6IsPp/3pm1OchpIoF/+/Fo0B9ps9MqeMi9yPAnXWdMgoBWXkUGhIjTmAsDoWIHWDKIkiGjV4hmvXLZhdh9fsADiQ8TarSeb0kghwJB9XZ5X+JT64EwnGj3fKbX0jZ9zJm+AH/qs3hGSs/fY0xbipYll8A3GsJidwQ88XrpLlJj2Lhdk4uLCE6ctZ8ABCuSdUARIJXs2l+S0iJnvSYPK1yrSInxbBe1RqQT8paSSytOzX57Pj+l1Pqr9/Eh56SwiDmyvvw206J9hKP60kZxaCcTa55iAi26R4QRq7/KBucTEIJ5Ux+U88LHCbrgtPw21GwSkZKesyKtelwRlt7H0e7F5ERRm3pCkp8oRTLJgEmyvvK8du6YJgogRtkkqdah2rS2tEx2opX2A7yjySqdWG6p9XOZhMGYX0UNZJw88Big77pkhtGfQKSG1/Qrbvxqtm2di0YAeO4nVcnnOBMWf97nxJOwUbdc0eLaaKSOL9tMqQ==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(39860400002)(346002)(136003)(451199015)(46966006)(36840700001)(40470700004)(6916009)(41300700001)(8676002)(70586007)(2906002)(2876002)(70206006)(4326008)(316002)(54906003)(186003)(6666004)(1076003)(7636003)(40480700001)(356005)(36756003)(478600001)(426003)(2616005)(26005)(7696005)(83380400001)(336012)(82310400005)(82740400003)(5660300002)(107886003)(8936002)(86362001)(40460700003)(47076005)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2022 08:58:33.4447
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 56257b41-5c2d-491c-dbb3-08dad7680deb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT092.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7158
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Emeel Hakim <ehakim@nvidia.com>

This adds support for configuring Macsec offload through the
netlink layer by:
- Considering IFLA_MACSEC_OFFLOAD in macsec_fill_info.
- Handling IFLA_MACSEC_OFFLOAD in macsec_changelink.
- Adding IFLA_MACSEC_OFFLOAD to the netlink policy.
- Adjusting macsec_get_size.

The handling in macsec_changlink is similar to
macsec_upd_offload.
Update macsec_upd_offload to use a common helper function
to avoid duplication.

Example for setting offload for a macsec device
    ip link set macsec0 type macsec offload mac

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
---
V1 -> V2: Add common helper to avoid duplicating code
 drivers/net/macsec.c | 114 ++++++++++++++++++++++++++++---------------
 1 file changed, 74 insertions(+), 40 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index d73b9d535b7a..afd6ff47ba56 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -2583,16 +2583,45 @@ static bool macsec_is_configured(struct macsec_dev *macsec)
 	return false;
 }
 
+static int macsec_update_offload(struct macsec_dev *macsec, enum macsec_offload offload)
+{
+	enum macsec_offload prev_offload;
+	const struct macsec_ops *ops;
+	struct macsec_context ctx;
+	int ret = 0;
+
+	prev_offload = macsec->offload;
+
+	/* Check if the device already has rules configured: we do not support
+	 * rules migration.
+	 */
+	if (macsec_is_configured(macsec))
+		return -EBUSY;
+
+	ops = __macsec_get_ops(offload == MACSEC_OFFLOAD_OFF ? prev_offload : offload,
+			       macsec, &ctx);
+	if (!ops)
+		return -EOPNOTSUPP;
+
+	macsec->offload = offload;
+
+	ctx.secy = &macsec->secy;
+	ret = (offload == MACSEC_OFFLOAD_OFF) ? macsec_offload(ops->mdo_del_secy, &ctx) :
+		      macsec_offload(ops->mdo_add_secy, &ctx);
+
+	if (ret)
+		macsec->offload = prev_offload;
+
+	return ret;
+}
+
 static int macsec_upd_offload(struct sk_buff *skb, struct genl_info *info)
 {
 	struct nlattr *tb_offload[MACSEC_OFFLOAD_ATTR_MAX + 1];
-	enum macsec_offload offload, prev_offload;
-	int (*func)(struct macsec_context *ctx);
 	struct nlattr **attrs = info->attrs;
-	struct net_device *dev;
-	const struct macsec_ops *ops;
-	struct macsec_context ctx;
+	enum macsec_offload offload;
 	struct macsec_dev *macsec;
+	struct net_device *dev;
 	int ret;
 
 	if (!attrs[MACSEC_ATTR_IFINDEX])
@@ -2629,39 +2658,7 @@ static int macsec_upd_offload(struct sk_buff *skb, struct genl_info *info)
 
 	rtnl_lock();
 
-	prev_offload = macsec->offload;
-	macsec->offload = offload;
-
-	/* Check if the device already has rules configured: we do not support
-	 * rules migration.
-	 */
-	if (macsec_is_configured(macsec)) {
-		ret = -EBUSY;
-		goto rollback;
-	}
-
-	ops = __macsec_get_ops(offload == MACSEC_OFFLOAD_OFF ? prev_offload : offload,
-			       macsec, &ctx);
-	if (!ops) {
-		ret = -EOPNOTSUPP;
-		goto rollback;
-	}
-
-	if (prev_offload == MACSEC_OFFLOAD_OFF)
-		func = ops->mdo_add_secy;
-	else
-		func = ops->mdo_del_secy;
-
-	ctx.secy = &macsec->secy;
-	ret = macsec_offload(func, &ctx);
-	if (ret)
-		goto rollback;
-
-	rtnl_unlock();
-	return 0;
-
-rollback:
-	macsec->offload = prev_offload;
+	ret = macsec_update_offload(macsec, offload);
 
 	rtnl_unlock();
 	return ret;
@@ -3698,6 +3695,7 @@ static const struct nla_policy macsec_rtnl_policy[IFLA_MACSEC_MAX + 1] = {
 	[IFLA_MACSEC_SCB] = { .type = NLA_U8 },
 	[IFLA_MACSEC_REPLAY_PROTECT] = { .type = NLA_U8 },
 	[IFLA_MACSEC_VALIDATION] = { .type = NLA_U8 },
+	[IFLA_MACSEC_OFFLOAD] = { .type = NLA_U8 },
 };
 
 static void macsec_free_netdev(struct net_device *dev)
@@ -3803,6 +3801,29 @@ static int macsec_changelink_common(struct net_device *dev,
 	return 0;
 }
 
+static int macsec_changelink_upd_offload(struct net_device *dev, struct nlattr *data[])
+{
+	enum macsec_offload offload;
+	struct macsec_dev *macsec;
+
+	macsec = macsec_priv(dev);
+	offload = nla_get_u8(data[IFLA_MACSEC_OFFLOAD]);
+
+	if (macsec->offload == offload)
+		return 0;
+
+	/* Check if the offloading mode is supported by the underlying layers */
+	if (offload != MACSEC_OFFLOAD_OFF &&
+	    !macsec_check_offload(offload, macsec))
+		return -EOPNOTSUPP;
+
+	/* Check if the net device is busy. */
+	if (netif_running(dev))
+		return -EBUSY;
+
+	return macsec_update_offload(macsec, offload);
+}
+
 static int macsec_changelink(struct net_device *dev, struct nlattr *tb[],
 			     struct nlattr *data[],
 			     struct netlink_ext_ack *extack)
@@ -3831,6 +3852,12 @@ static int macsec_changelink(struct net_device *dev, struct nlattr *tb[],
 	if (ret)
 		goto cleanup;
 
+	if (data[IFLA_MACSEC_OFFLOAD]) {
+		ret = macsec_changelink_upd_offload(dev, data);
+		if (ret)
+			goto cleanup;
+	}
+
 	/* If h/w offloading is available, propagate to the device */
 	if (macsec_is_offloaded(macsec)) {
 		const struct macsec_ops *ops;
@@ -4231,16 +4258,22 @@ static size_t macsec_get_size(const struct net_device *dev)
 		nla_total_size(1) + /* IFLA_MACSEC_SCB */
 		nla_total_size(1) + /* IFLA_MACSEC_REPLAY_PROTECT */
 		nla_total_size(1) + /* IFLA_MACSEC_VALIDATION */
+		nla_total_size(1) + /* IFLA_MACSEC_OFFLOAD */
 		0;
 }
 
 static int macsec_fill_info(struct sk_buff *skb,
 			    const struct net_device *dev)
 {
-	struct macsec_secy *secy = &macsec_priv(dev)->secy;
-	struct macsec_tx_sc *tx_sc = &secy->tx_sc;
+	struct macsec_tx_sc *tx_sc;
+	struct macsec_dev *macsec;
+	struct macsec_secy *secy;
 	u64 csid;
 
+	macsec = macsec_priv(dev);
+	secy = &macsec->secy;
+	tx_sc = &secy->tx_sc;
+
 	switch (secy->key_len) {
 	case MACSEC_GCM_AES_128_SAK_LEN:
 		csid = secy->xpn ? MACSEC_CIPHER_ID_GCM_AES_XPN_128 : MACSEC_DEFAULT_CIPHER_ID;
@@ -4265,6 +4298,7 @@ static int macsec_fill_info(struct sk_buff *skb,
 	    nla_put_u8(skb, IFLA_MACSEC_SCB, tx_sc->scb) ||
 	    nla_put_u8(skb, IFLA_MACSEC_REPLAY_PROTECT, secy->replay_protect) ||
 	    nla_put_u8(skb, IFLA_MACSEC_VALIDATION, secy->validate_frames) ||
+	    nla_put_u8(skb, IFLA_MACSEC_OFFLOAD, macsec->offload) ||
 	    0)
 		goto nla_put_failure;
 
-- 
2.21.3

