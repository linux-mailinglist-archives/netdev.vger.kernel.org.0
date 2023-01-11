Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 476CB665EA6
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 16:03:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234352AbjAKPCy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 10:02:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235195AbjAKPCr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 10:02:47 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D29941D2
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 07:02:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FnD//tLIyw4rjzce+7EJZjwVEDVuB2sr5bdV9KE3aDtEE1BW629dIXJ6LMwprKpPmvQ27d7TkOSepwrW0r1lWwt1t4weyKePppF/0rurAfVUWWl45VMKCYflnFYBsONRXcZqtDiLEImmVSaRWMkHQqmiSAAiA95hvDWFFr57+gyAS1R1r9bkrvdUUDcndt5U3NhuPcJUSWaQoHqPeMFtaYU3V8HhxkAK6zvRhCi5gdoSO3z7ZxfyEkmzXjJOGCvOrup4xDdIeqc56UYdqhmZSFdlZZyj8AnlT2fvtzsnGZWFsm0//2G0C8oU9xtFq5fcuS0ZOC4dtWuigZXvv+jUmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3uAJm2qwHOGSghixDKAvqdphif8L0zT39nbwtg4m+iE=;
 b=S2rFi7nTeQbYyvSErnIjj60JK5GaqFEs4ZtqBKalc0xfQtg/tFnmamGm7E1T2xjSqg89GIM7a6c8XW9+pxtycu998ag/U8dZXmdUNS2PISwFqP3xVBK0mNlj9YTfAJRYNadEUzzrgUy55MDCTdEYRr65t/stElFQLOoLPFYTv0i/g6UbD0drR95UF/dGfq8PwCZC41HxyAOODU2Ol0O15i/TuF5aC7YvGJWT9udS0p9xsPvv/Vesf6fdyQCHdPG8RCPmBBt1qSS2DHS3gAV9FxON7kwyR02YX5dk+MXzOXvBisonKEmtmjJkCZxOpWiT4FaiGSo90FA8X24+hbK5XA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3uAJm2qwHOGSghixDKAvqdphif8L0zT39nbwtg4m+iE=;
 b=Y4iau+l00XyT7xkGd4Nezd3O1QV2iXk0pgwYDSdrOWTlTR9aIiUdvypqPjlHi3WvKvN1mKrbyZ3AJUZOxMhemmmSPsfYrC46erwgf9teFxZSePyrvMa2gp2LafWNDg+Hb969JcjQ/RyfoaNiM8GcFRyDu+8UranY2gk5ikHCYrtQ5A1n9p7Ydi+p6tCTPLsaDPLiZq6qkbPnqiHq7E4vH5at7TFUQu4iZNU6bVUGY/fpeeuIevk/3GoWHaO4oulJKU+ZGCTGp6D9WLIKA3vQyTXkjkKf/rKKLHsiCr9SwJ7XWmZfgRl/end3N5pLniZd37yh4hcBfHhXKHu+sd+mpw==
Received: from BN9PR03CA0982.namprd03.prod.outlook.com (2603:10b6:408:109::27)
 by MW4PR12MB6707.namprd12.prod.outlook.com (2603:10b6:303:1ee::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Wed, 11 Jan
 2023 15:02:41 +0000
Received: from BN8NAM11FT027.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:109:cafe::ef) by BN9PR03CA0982.outlook.office365.com
 (2603:10b6:408:109::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18 via Frontend
 Transport; Wed, 11 Jan 2023 15:02:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT027.mail.protection.outlook.com (10.13.177.96) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.13 via Frontend Transport; Wed, 11 Jan 2023 15:02:41 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 11 Jan
 2023 07:02:30 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 11 Jan
 2023 07:02:29 -0800
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Wed, 11 Jan
 2023 07:02:27 -0800
From:   <ehakim@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <raeds@nvidia.com>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <sd@queasysnail.net>,
        <atenart@kernel.org>, Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH net-next v9 2/2] macsec: dump IFLA_MACSEC_OFFLOAD attribute as part of macsec dump
Date:   Wed, 11 Jan 2023 17:02:10 +0200
Message-ID: <20230111150210.8246-3-ehakim@nvidia.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20230111150210.8246-1-ehakim@nvidia.com>
References: <20230111150210.8246-1-ehakim@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT027:EE_|MW4PR12MB6707:EE_
X-MS-Office365-Filtering-Correlation-Id: 9837f8fd-1192-4dce-1c35-08daf3e4e328
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /jpigSJnSpYR41ldIN39sDRXDg5wCVN1Y7Dvhax0+iLAnDdLNFtM4MCpeRP6pbG+gBX+vH3CP22HhuRyH6ur14GpeRKSer++N437oGS2vbmCCuUnnjOsnmbPxaTSvAPExGizMo15i7CRKs1xm554BomSjES+h6gxbK+VWkbWoEm2eyg5s8jUtffVN+dVIKxirfxP06HiyBW8TYjzYclCAV/seg5rl3ZfMfRGwwnryMq47H2+cV3B1SqjE8TnD3GNHeGzZwbOANMSvij45VeAoju3yA7FPPI34ZUizFO97JpfSvWuo2N8brqsPGT26Aqlkagh2xaVn0C9dWKUFc3G603uCmgl99fPZE7no3Q+Aky6h0zadWm7OzVizO2DXuGipf94iUS8d/orpRWkdzzeHpsxSFJ8wwqEUQs1sdZIhHWx8XMfb48JgIXRd8ZfbPar16CEcoei7kJKSf4ZrwmIt5qwVUrUGoFUlA6UGRleKI0+BHzHzj/6SsatJ6RNcnl0r5p4G74bIZk0MnB3x9KIPLq7rWXGFIztOgCVnIyRmAcROn+ccDtlHO13L4ftf3Id+IETwlisrwILX6lgC8MVkIzX4UB9MOehY99NyyjnLB/Yj14SxZuCxUrDlz3huC9yPDi9ynoaI4jRK6q6tKvupjYjLK4Y5kv3PB1LFMnPEwppBOwIhIVJHXJ5LuEl215yn8mjwvqPAXKekUKdjxcF+w==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(396003)(39860400002)(346002)(451199015)(40470700004)(36840700001)(46966006)(478600001)(82740400003)(426003)(356005)(47076005)(41300700001)(7636003)(1076003)(40460700003)(86362001)(54906003)(316002)(2616005)(7696005)(40480700001)(70586007)(26005)(336012)(82310400005)(186003)(8676002)(4326008)(6916009)(36756003)(70206006)(5660300002)(6666004)(107886003)(36860700001)(2906002)(2876002)(83380400001)(8936002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2023 15:02:41.3465
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9837f8fd-1192-4dce-1c35-08daf3e4e328
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT027.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6707
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

Support dumping offload netlink attribute in macsec's device
attributes dump.
Change macsec_get_size to consider the offload attribute in
the calculations of the required room for dumping the device
netlink attributes.

Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
---
V1 -> V2: - Update commit message.
 drivers/net/macsec.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 4ba6712d5831..877cdbdaaf6b 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -4247,16 +4247,22 @@ static size_t macsec_get_size(const struct net_device *dev)
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
@@ -4281,6 +4287,7 @@ static int macsec_fill_info(struct sk_buff *skb,
 	    nla_put_u8(skb, IFLA_MACSEC_SCB, tx_sc->scb) ||
 	    nla_put_u8(skb, IFLA_MACSEC_REPLAY_PROTECT, secy->replay_protect) ||
 	    nla_put_u8(skb, IFLA_MACSEC_VALIDATION, secy->validate_frames) ||
+	    nla_put_u8(skb, IFLA_MACSEC_OFFLOAD, macsec->offload) ||
 	    0)
 		goto nla_put_failure;
 
-- 
2.21.3

