Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9A1565CDD5
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 08:47:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233736AbjADHr2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 02:47:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229970AbjADHrX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 02:47:23 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA3FBE36
        for <netdev@vger.kernel.org>; Tue,  3 Jan 2023 23:47:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iVVvJfSSnk4LVAHad6CuzsyGmyHtcOq2CZDQlxGMlr2w4Nv/GHn6UdebbBVw3EOshrID1c5DeO3MPqEjNdbdSwf6EHg0dYjlpZkULKnpkSRBecNJqNzbc9qG2vjGkQLVFPLqUp1G0rXg5xWFUMx2A+GPTMtTFc24eMMnhWb0uk4eh45FRiet9gvFFoKKLqB7vyeICv9B6jyBKy/J1CeIUxoTiIFQY1OavhOo7oot5qfdR8IOFppPLsvi9usfm8T+qwpR7Ktm3E8QcKJ8JcZW0LsYbzegb3v3hS5F5/R9tFc08N8usis0ZodTGKLQ8NTEk48sp0PRQbtXvqCMyG6qmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GOuEtyjZ+pqHDePK+LilzNj+v7zkd7Tjx3bTgbiplaw=;
 b=GZ1nqV8b9XiTEfEhbswMkP2TbET6i7triwdSnuey8QdXTTuls1nU0l/jzdgMU/Li93bE4f2ioBHz6cGBDRCQ5jGYX7n9qR9tXAcGnirob7zlCnOUIJwnnwfoBYjZg+5qu9KLdwB8Pgk4KlY7xrRV4bmRPoOEGeBmPEvjoaiblHtdZDaJxuMBwqCwsK3uusONg0wcdUO1zaZWwOfrp6iu15kC9UfzhwrvR9U7XUHTmU4fvT0OIRAdVCaqRgRjj6pQQQowRRZxzrc9XoeW2z+jH/zTuHwX+QSjiQlar9IAvcCIdATQrhLoa77/cpA43JM9CgKRdE+fOHGXt1inNyRIBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GOuEtyjZ+pqHDePK+LilzNj+v7zkd7Tjx3bTgbiplaw=;
 b=lNH0t4z/elgg1Mt519fDi/85DvLnIg4LcrsDv2yowCoHKNGG3jQ4CO3waFN8QKgtvyutUGfpxsvz0NGceo7M0U5I5/eYFGCHRJjFVHmzEP12zYeaHdf+QqE2z7noViRtCCDwK78GY+PUgqUdi8qP7dp2l4KkNtNB7prYq29vZHo2yEipsQ0TLQiUM1pAeGhkQPz+Rv0DkmSU3iQMdjPdTR7mb+m1fcfk6oO6wc+RQLyq/5r+OIygEzVroQYcdV7Jqu5bFy2ysCmWM87gmLQw6YBfgdaJvvKKdooNjU3tqXYhQrm5V1mt4NydlnDR+xT+DxB4DaDRzIJQwa/ooe9eqQ==
Received: from BN9PR03CA0331.namprd03.prod.outlook.com (2603:10b6:408:f6::6)
 by MN2PR12MB4405.namprd12.prod.outlook.com (2603:10b6:208:26d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Wed, 4 Jan
 2023 07:47:20 +0000
Received: from BN8NAM11FT081.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f6:cafe::31) by BN9PR03CA0331.outlook.office365.com
 (2603:10b6:408:f6::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.14 via Frontend
 Transport; Wed, 4 Jan 2023 07:47:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN8NAM11FT081.mail.protection.outlook.com (10.13.177.233) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5944.17 via Frontend Transport; Wed, 4 Jan 2023 07:47:19 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 3 Jan 2023
 23:47:09 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Tue, 3 Jan 2023 23:47:09 -0800
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.126.190.180)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Tue, 3 Jan
 2023 23:47:07 -0800
From:   <ehakim@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <raeds@nvidia.com>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <sd@queasysnail.net>,
        <atenart@kernel.org>, Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH net-next 2/2] macsec: dump IFLA_MACSEC_OFFLOAD attribute as part of macsec dump
Date:   Wed, 4 Jan 2023 09:46:51 +0200
Message-ID: <20230104074651.6474-2-ehakim@nvidia.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20230104074651.6474-1-ehakim@nvidia.com>
References: <20230104074651.6474-1-ehakim@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT081:EE_|MN2PR12MB4405:EE_
X-MS-Office365-Filtering-Correlation-Id: 92524237-f1ed-4b91-9eaa-08daee27e890
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8fd1Gbjm3I1HevTqAbQoHtaJPyV+Mbmcc5K5yIjl2FrovJKKtH1IMXnVZwEY0kTLfmNFq/Q5sZxIO52xgG2xKmjnvXb3+Bwshffjvg1moJARE/xfRKN843TRvjPF4pVDN0C+bLs0/vDz1IiWChCtywSeWB25u+o7D53yf41YVscmt8ozcC8XSiKyW+ltGejnNAEvj5yDmohz5SPSQ+2dIOYPdUkp8tArA4L5pGMOBCpTDoFWAzrUeWRciP3Y9b35k54kszNx0in+i88ORKB/w8ceb4+IFLuPOkn7FEKTMCIdlQQtzLKZ+2IgC+Ogcm+mjN2fYBXR7pB9GS3gzKjwOOf8P5hWEsOvVLILWKOXr7cF1dDynqQ11mlfMUIfg1VOVlTBOC2yNGh8Fgp96z/04cp7v5Tucnc7be+M3RtlX8LYxwBWpdvsuDxe1nlVy9mCSOdfYiIn2/Cv4hDCxW9KD69s1NzKcTYJqw5xlyfPsxLMqAO+lgD51q0ezP5BEQf1rxlS+9eTE4BcWXNjN9Aq/NPvhWJxUjSZdM1bXuXHm+70XRAmOfDB9t4NGrwOoewVpy6yAMlH7CKTzQvILqvpu5zs3tROh4ydsZvgL+o2YLb3PE9aLzzUpNxXAXK+wlqOx1MDzjUZbqo9U69lcNzFdfjpULD+vdUPmJ0EnmRqR7xemBsV20WjNTeDiUwo7HwiMerm8QWGaHQczwtx56KoZg==
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(376002)(396003)(39860400002)(451199015)(46966006)(36840700001)(40470700004)(6666004)(7696005)(36860700001)(107886003)(82310400005)(2876002)(336012)(36756003)(478600001)(86362001)(7636003)(40480700001)(82740400003)(40460700003)(356005)(2616005)(1076003)(47076005)(186003)(26005)(426003)(83380400001)(70206006)(4326008)(8936002)(70586007)(8676002)(5660300002)(316002)(2906002)(6916009)(54906003)(41300700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2023 07:47:19.7242
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 92524237-f1ed-4b91-9eaa-08daee27e890
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT081.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4405
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

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
---
 drivers/net/macsec.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 1974c59977aa..0cff5083e661 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -4238,16 +4238,22 @@ static size_t macsec_get_size(const struct net_device *dev)
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
@@ -4272,6 +4278,7 @@ static int macsec_fill_info(struct sk_buff *skb,
 	    nla_put_u8(skb, IFLA_MACSEC_SCB, tx_sc->scb) ||
 	    nla_put_u8(skb, IFLA_MACSEC_REPLAY_PROTECT, secy->replay_protect) ||
 	    nla_put_u8(skb, IFLA_MACSEC_VALIDATION, secy->validate_frames) ||
+	    nla_put_u8(skb, IFLA_MACSEC_OFFLOAD, macsec->offload) ||
 	    0)
 		goto nla_put_failure;
 
-- 
2.21.3

