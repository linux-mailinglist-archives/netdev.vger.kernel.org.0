Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F71F6620E3
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 10:04:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234697AbjAIJDz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 04:03:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237050AbjAIJDa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 04:03:30 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C794613F8D
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 00:56:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MjT1RuiQlOIxzDl6at4Zp6lzDlkzzs7Q5jBhLkf3igOjPE//81sS8QQ4tm47ETI1nGi0r7dh3NORcmdKSlsnvXkUozzxEhsZhY7E4DjP3rUmFTdUGB+UJYonM+ZdlVJSi6gLWS8qnrr0PL+7Pnj+DgkoAu0O4N6xBRglp8HuENK5v5cHpYBR850L68egY98hA89bD3ZJA5wT5v4Qqsk7GNHon4QW5QEFSXXPU+N6zT+eDONedoL4xDPKTVr/yz1T6mVY6ndBR2YFq3mEu2sm2cVV8Z9gQ/xQjLDOfweA6/wuvLyVZ7N6Hh5gSorALw+uTVtuVBO1pGfxHWb0d2g14Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0tLiXwGq+LeIG+n9cyKqFUhD1bOpAFUkGikyoBtzUGE=;
 b=JFptVb/GxkES1WF5Sl0i9AR0Os3iscr3YE7AMq5cBNLZGdism/X0OsNBPhwLD/bUsmADPiI2b4xZP0q0+Cl6I2OzmiRvpKOpUcW3Sb2aATxufKpRZaDprP4aYvkFc4b4RaANElOjAtpYjxK7YhHQiGQiNePmNb7kTyCNuK8riZRFhLy4reINcSaDWHMgx/fmrcBUjEEdqnWVIK0J4nXfFMrLwETpT2wLzfG/qzTLh0omQ8LPq75PxO8K4BHpDMb9jqhkBWKhSo8WoZ+UEGmr1BLn0WfNjLVopYgE3DxL0ZygG/M327OhrC7T4b5e1I6h7N5YckcNP4HViW5kEh8XEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0tLiXwGq+LeIG+n9cyKqFUhD1bOpAFUkGikyoBtzUGE=;
 b=KycL0uBhbIJ7nLDv0QxttuEIaBHMWdxvTdLz7YPWkP1H7qq2dYTCnGoWer9zycq7LyLCgIsdPn/WijozSkNh/r64W5xwyUAyqKA3I10YndcLkAJLAWN+xxdiYPiSoQaSBxTwqwSmv1p8X5pfA69gMyPyBiA1kzf50yOx4xeC6QQbzlYLHOho5MxsxLvi7YeBmmXjg5lMT5foSctRsFvlxcyt5VDAz8yv5sUeRygTXOFOKqlR88pF6gltS8qeVL5cA7RsuX0FsUXdKEVBBsFSni4Gdp+ZkFeBSvghiVIFXnObopg5Vs35H9cHGmxg9LR+oAURcugOnyxqLj4VB2U6qg==
Received: from DS7PR03CA0048.namprd03.prod.outlook.com (2603:10b6:5:3b5::23)
 by PH0PR12MB5404.namprd12.prod.outlook.com (2603:10b6:510:d7::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Mon, 9 Jan
 2023 08:56:42 +0000
Received: from DS1PEPF0000E653.namprd02.prod.outlook.com
 (2603:10b6:5:3b5:cafe::75) by DS7PR03CA0048.outlook.office365.com
 (2603:10b6:5:3b5::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18 via Frontend
 Transport; Mon, 9 Jan 2023 08:56:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS1PEPF0000E653.mail.protection.outlook.com (10.167.18.9) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.11 via Frontend Transport; Mon, 9 Jan 2023 08:56:41 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 9 Jan 2023
 00:56:27 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 9 Jan 2023
 00:56:27 -0800
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Mon, 9 Jan
 2023 00:56:24 -0800
From:   <ehakim@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <raeds@nvidia.com>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <sd@queasysnail.net>,
        <atenart@kernel.org>, Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH net-next v7 2/2] macsec: dump IFLA_MACSEC_OFFLOAD attribute as part of macsec dump
Date:   Mon, 9 Jan 2023 10:55:57 +0200
Message-ID: <20230109085557.10633-3-ehakim@nvidia.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20230109085557.10633-1-ehakim@nvidia.com>
References: <20230109085557.10633-1-ehakim@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E653:EE_|PH0PR12MB5404:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a090e73-0b2d-401c-bf64-08daf21f6d2d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QQ2UonkQl417veqt2pHf28ZYJL4McllUjPFmoP7kFfRjOCRswLFa0133UFrsSS94EoDa1PQMm3Wzt8bnKrBF7KVIJ/WdQQOFmFOuLfQpmjXkbO3dXFoclMYUaJ2oeRsbPGyONfslOCfyAtUQWccr1XsmOdy5OMhkXW5W8eatoh5Unsk1EfxHxuYLJXbhDnI+Y9pu2aW6FmIBuPFj5ew1lJnwYKjY4RWg83fwbHbuJmVP7Sogwa+KeuLyXCNONE1WOSqHkYHSyukJ9QRfLjiv/4InK/cx73rmyjv8iUCDOoBDPyTFCOmw7msj9u0brlVvpkAzG/2kAHYgST2ccwzWUZ+3CS/CkhFK5GqiKCls/bEZDRNzgXGual4OLsB50Lnv6AwWI3sHIUcYlAYGYLyro9F+uKi1ykjvOQQXWja/awA1O+zqqFwG/sOSdv4uHzSexJed6K7GCgxl1Hl4XpuFz3WtJp3mBPloB5JDGQSmow8QT0hPs5O/KrwBlwgWgV4/wdRlVQzC1k6Bl3h8ZWE9tT/gO7ZgVUxPioid7gEQgZhIll7KJUyR5/+ZBZ+xsZmDIcF8WXZx7Vqc1uHDybBpaLZvfvC95at7s6K0qsOW7GlZDvFGZ8+bb67iDElLfbjbOYHHKGbAG1/nwd97ni2OOeSlPe260M+0oVRPqpVEP1YA4/HTjOb8U+NHhnrelSNEJG/2+9duGJjlCtlrrd/R8w==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(376002)(136003)(39860400002)(451199015)(46966006)(40470700004)(36840700001)(36860700001)(82740400003)(107886003)(6666004)(7636003)(2876002)(356005)(2906002)(478600001)(2616005)(1076003)(7696005)(26005)(186003)(5660300002)(316002)(40480700001)(83380400001)(8936002)(82310400005)(36756003)(86362001)(41300700001)(426003)(40460700003)(47076005)(70586007)(70206006)(8676002)(336012)(6916009)(54906003)(4326008);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2023 08:56:41.4406
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a090e73-0b2d-401c-bf64-08daf21f6d2d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E653.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5404
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Emeel Hakim <ehakim@nvidia.com>

Support dumping offload netlink attribute in macsec's device
attributes dump.
Change macsec_get_size to consider the offload attribute in
the calculations of the required room for dumping the device
netlink attributes.

Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
---
V1 -> V2: Update commit message
 drivers/net/macsec.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 687d4480b7b3..18dabb4840cb 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -4241,16 +4241,22 @@ static size_t macsec_get_size(const struct net_device *dev)
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
@@ -4275,6 +4281,7 @@ static int macsec_fill_info(struct sk_buff *skb,
 	    nla_put_u8(skb, IFLA_MACSEC_SCB, tx_sc->scb) ||
 	    nla_put_u8(skb, IFLA_MACSEC_REPLAY_PROTECT, secy->replay_protect) ||
 	    nla_put_u8(skb, IFLA_MACSEC_VALIDATION, secy->validate_frames) ||
+	    nla_put_u8(skb, IFLA_MACSEC_OFFLOAD, macsec->offload) ||
 	    0)
 		goto nla_put_failure;
 
-- 
2.21.3

