Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70B6C641C4F
	for <lists+netdev@lfdr.de>; Sun,  4 Dec 2022 11:07:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbiLDKHR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 05:07:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbiLDKHQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 05:07:16 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2075.outbound.protection.outlook.com [40.107.244.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E83215734;
        Sun,  4 Dec 2022 02:07:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jl5TUl24/h+F8qVLSjekWHQlJHSmSeH7STGo+R3eoNnwEEm9WPvVaOO9S9Ki0EjdGImPqd4SPnHtDMo7GUss8GIejQN8RKOeyODp580NlCMj5zzAFah+CKrgRFrRa9FKV47KD74RwMVOJtz0l5lklWQrPEnJMuCqoZX8TS4di+Hl8u0sGQ4CisOSMMKDCzB3cm2Uc6XOCFTGwwdqpPd0Ct/mqUh/O4TqjI22CiEhJtcsrRYhJIrfGH+x5XKuyJYCYOxns8qks0qtR0a2sQe8mS7K2wTzDlqZl7/A/SVf1BP16mkOBcciPrIK3R7ivFj53rpE1f1CigmWmmawAwwDag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6MCUdlxziN/aGWfDR6PHfn74jF/sSy/hpu1Zp6aHKs4=;
 b=MQE7NVYmPRDxoUEG7v0/qDHBH8o7xwbzWUVvJG52pPg5hHr9zFxqEotJXYCaOkpnDJp9oZow3mFzQixE/BJUIAx0YVFVvc4ROHvrCPLkZwt2UJtLvV+KjfsZ2ZsVix2XnxSbmsJIplSrvCHZs2Z4VINGCqXy/YQvNoXp9Wg9sOV2ubkxPsAtZptzgnxwfWEqvABXHShn1Ll/g0kcJxUk/ihg9TXqP2HX7+1XppqWqTTN6l5AvU5em6Jx8/NWFxZjQQEOSE8wTrnk2QEw8p/AFbZD6gKdsdHg3Aw4jL+IWeAszSNYo6XCsZP0UfH+8gCXmoObn5qI+70AA66BhKkxfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6MCUdlxziN/aGWfDR6PHfn74jF/sSy/hpu1Zp6aHKs4=;
 b=bZud1Ca2akl3RrectN7VkHFr+vfgqj83yh5oVluLTnYgL0sEWQrsK+qwAHjqqhdmlrUY1UyQum94pvRILzeV+pWpPUfIgEY97sQla/5MmULjWNP0PGNmptX1BEJ6Y+rWIDkQPn5m5m82O7ddvIJ5a17/yBZ5XpaMp1rHEkiiBRPIYWV0kl/nMt3ucQWXkr6lL8kr3Rha08zNGAUU0W58P+r2xgz5UHNFWtHnfpvlb80karBmCz8gHSXq2k5lfhEb8xG6sFsQVngFbfAKb/Q1chC7vyruKwRCw8BlGPXwcgXmDxXt3lqDLVOhdfD+IFrOBnbmSX0AcLwb+64BI5DwKQ==
Received: from MW4PR03CA0045.namprd03.prod.outlook.com (2603:10b6:303:8e::20)
 by MN2PR12MB4359.namprd12.prod.outlook.com (2603:10b6:208:265::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.13; Sun, 4 Dec
 2022 10:07:11 +0000
Received: from CO1NAM11FT049.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8e:cafe::8d) by MW4PR03CA0045.outlook.office365.com
 (2603:10b6:303:8e::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.11 via Frontend
 Transport; Sun, 4 Dec 2022 10:07:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1NAM11FT049.mail.protection.outlook.com (10.13.175.50) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.13 via Frontend Transport; Sun, 4 Dec 2022 10:07:11 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 4 Dec 2022
 02:07:06 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 4 Dec 2022
 02:07:05 -0800
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Sun, 4 Dec
 2022 02:07:02 -0800
From:   <ehakim@nvidia.com>
To:     <linux-kernel@vger.kernel.org>
CC:     <raeds@nvidia.com>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <sd@queasysnail.net>, Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH net-next] macsec: Add support for IFLA_MACSEC_OFFLOAD in the netlink layer
Date:   Sun, 4 Dec 2022 12:06:53 +0200
Message-ID: <20221204100653.19019-1-ehakim@nvidia.com>
X-Mailer: git-send-email 2.21.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT049:EE_|MN2PR12MB4359:EE_
X-MS-Office365-Filtering-Correlation-Id: 54ed6388-5999-46ec-4878-08dad5df4f74
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WGnDs6CMlFiRwmz5RB4LP+3mNv8kSKim9Qb4TPP4TgnVXLHtg9NMT8S06HCSRJ9yixP0UdWFASvJEweR1nqiEZWOveY6pnGZ1DsV0TSE9Tpp/5kSO1A0YGQgtE8hEXDP8gJuEB9sDtL08gp70TweriJusDNYP9uysEudvkUsFOp8VkKwGTpM/LSu9PFvyW0DXsm8c3Zfvn59Ud4OWh9Kk6+B0FY2NBftTmgK1hnZz1ED+//M7+HESjDsuCh/gEb/kYikUhOM20PJIYaBDKL41VfOG3A2vFFs8lJDBVKLHlWXrQlavQuQT0w9C+HQRFj5D78aHL6oJtwkMZz4od63dcs5+Y9jiwV9QKuEKFXkmQkbVHd4YaMqAhlGznQCEO0B5Qv35KIVDYsI2pWR+XpJEKi9MtTHCOTmRQmsEpBApIRfyuBeRXrfk+OhRfYFlXoSh+cQdZsSy4E6+ab7tgsQog7YKKXPF1JTSC0on+vy5aCnz2G+Pm6nXFaPpaF3TQ2RRaUD6lvOa9LbSMOgLAKoKHQC4CHqgIOzaF2Lf47m1uYUYoAigjbA/sFoVlJyOgBAnhHMn3nS8lmUb5xoX50f+LCcmwCGjPWYhC0ufGqlDkxnIfe1DNjj6xNTBNMeeniFvhw/ut2hWids6N7oNpyMDhE9xJgFsfZ+2oZ7zXdCs8O8bONfBw51YkWOTwMrG9x1WCfARmlzkATevKK1s6Uf+g==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(396003)(376002)(346002)(451199015)(40470700004)(36840700001)(46966006)(40480700001)(36756003)(40460700003)(86362001)(478600001)(7696005)(26005)(186003)(107886003)(6666004)(5660300002)(8676002)(4326008)(2876002)(316002)(8936002)(41300700001)(54906003)(2906002)(6916009)(70206006)(70586007)(36860700001)(82310400005)(82740400003)(356005)(7636003)(2616005)(1076003)(336012)(83380400001)(47076005)(426003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2022 10:07:11.2228
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 54ed6388-5999-46ec-4878-08dad5df4f74
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT049.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4359
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

Example for setting offload for a macsec device
    ip link set macsec0 type macsec offload mac

Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
---
 drivers/net/macsec.c | 66 ++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 64 insertions(+), 2 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index d73b9d535b7a..d27b737a6deb 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -3698,6 +3698,7 @@ static const struct nla_policy macsec_rtnl_policy[IFLA_MACSEC_MAX + 1] = {
 	[IFLA_MACSEC_SCB] = { .type = NLA_U8 },
 	[IFLA_MACSEC_REPLAY_PROTECT] = { .type = NLA_U8 },
 	[IFLA_MACSEC_VALIDATION] = { .type = NLA_U8 },
+	[IFLA_MACSEC_OFFLOAD] = { .type = NLA_U8 },
 };
 
 static void macsec_free_netdev(struct net_device *dev)
@@ -3803,6 +3804,54 @@ static int macsec_changelink_common(struct net_device *dev,
 	return 0;
 }
 
+static int macsec_changelink_upd_offload(struct net_device *dev, struct nlattr *data[])
+{
+	enum macsec_offload offload, prev_offload;
+	const struct macsec_ops *ops;
+	struct macsec_context ctx;
+	struct macsec_dev *macsec;
+	int ret = 0;
+
+	macsec = macsec_priv(dev);
+	offload = nla_get_u8(data[IFLA_MACSEC_OFFLOAD]);
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
+	if (macsec->offload == offload)
+		return 0;
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
 static int macsec_changelink(struct net_device *dev, struct nlattr *tb[],
 			     struct nlattr *data[],
 			     struct netlink_ext_ack *extack)
@@ -3831,6 +3880,12 @@ static int macsec_changelink(struct net_device *dev, struct nlattr *tb[],
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
@@ -4231,16 +4286,22 @@ static size_t macsec_get_size(const struct net_device *dev)
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
@@ -4265,6 +4326,7 @@ static int macsec_fill_info(struct sk_buff *skb,
 	    nla_put_u8(skb, IFLA_MACSEC_SCB, tx_sc->scb) ||
 	    nla_put_u8(skb, IFLA_MACSEC_REPLAY_PROTECT, secy->replay_protect) ||
 	    nla_put_u8(skb, IFLA_MACSEC_VALIDATION, secy->validate_frames) ||
+	    nla_put_u8(skb, IFLA_MACSEC_OFFLOAD, macsec->offload) ||
 	    0)
 		goto nla_put_failure;
 
-- 
2.21.3

