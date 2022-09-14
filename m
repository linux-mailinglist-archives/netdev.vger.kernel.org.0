Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C1265B8495
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 11:15:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230525AbiINJPN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 05:15:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231687AbiINJOD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 05:14:03 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2089.outbound.protection.outlook.com [40.107.92.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97594786E6
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 02:06:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oTwFPmkPsSqKNZEGLR5+EBjKCOi28UzRppC+Kl6C3ElVUdCjFMJ4Q/gRRp9pRDLg5a9dv6jzb8briWdTJSTecUyq+ibTdQW0ersivFPjiDPmgiuszMcJ0afX6a7STOLaur7yUkWMiLzuQkOOVtp7Tz6y2zjmZydgawxU7/T4HBtxVjb1cL955ZBzZWG9cZGqkmVQdAa4PJTq36RhrnS/AzTfKDmRZGk3B3D+1cDaekmWdelf02cgjQcQ5e9FBTfKmhargENm+5Q/Fe+6jlxAyQM+qQH6lEHx1iVtXKk5zl8ohMuXYSLSY1qHN3cXGsSBP1AZ/Dk5r6iy2+jQj1wmZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tAtE0ppbxJ2sGHK8dxQwJBqWmOlQi996S3WEEA55CJI=;
 b=HBBbjWPCo7J0nrlouCDxbfKcX+3HPtHR6gQjJZoL5VPNROoU8bB7QPMZvR2wbO+OnV3WkcCu8s7yS47zUzA3n3deXmS7+myGnuJdW3hvXB1VJWmqoCsV2LwZBP6ZiNqzRsT6Kffnwu+PbV/eOkUl2RzG8XcsRUwHMmfB9LDVt+eTM1Rcp1VYsJU1bjj5f1kv+Xw5SjysQEGCEFvU33KMIq5gcPmYrt/NoiKZzyLYJ2PeuyLKWqYKOxjTffv2IAGU+6HsWL6GSCHT6lQgiuopFjC7zql6BGm0Xy5nyfySHc5oPPxpUNT9s3BbK63GZxrgRp1YdRLJvUuRN210LW7RJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tAtE0ppbxJ2sGHK8dxQwJBqWmOlQi996S3WEEA55CJI=;
 b=kxs26n7sHRLlxHPbUBu/4EL8k4voiM1eos/i38uaYpwSHnnv9LE4WP5uXw3kFd4iQq4UQvPOTIIhJtu8jC35xb32SwIjLMY+AnPrV3Ip6vKibgHxjJ5GNCXDlF9l35p8EnGdGxZrvvGDcv2UiAHmMhhefZD+21zSVW0mTAGvtKlSxQ76A2pRITrkDbDm642aZO0Mr4jgi42GSHjyxXishsqc/IbDWkCx+PWeVOcMD5hO2hqtpHiSQwqkIj+HhXcBnRQGvPuvFioPRHUK622AYRNlOTM5oYFU2kaC4B/ZnD9OFhbhCLSBFSp5QTi9U0IaMePAiBmpozXMC5g/JAWZqQ==
Received: from BN9PR03CA0074.namprd03.prod.outlook.com (2603:10b6:408:fc::19)
 by DM4PR12MB7528.namprd12.prod.outlook.com (2603:10b6:8:110::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.19; Wed, 14 Sep
 2022 09:05:46 +0000
Received: from BN8NAM11FT013.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fc:cafe::d0) by BN9PR03CA0074.outlook.office365.com
 (2603:10b6:408:fc::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14 via Frontend
 Transport; Wed, 14 Sep 2022 09:05:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT013.mail.protection.outlook.com (10.13.176.182) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5632.12 via Frontend Transport; Wed, 14 Sep 2022 09:05:45 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Wed, 14 Sep
 2022 02:05:28 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 rnnvmail203.nvidia.com (10.129.68.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Wed, 14 Sep 2022 02:05:28 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Wed, 14 Sep 2022 02:05:27 -0700
Received: from vdi.nvidia.com (10.127.8.11) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.29 via Frontend
 Transport; Wed, 14 Sep 2022 02:05:25 -0700
From:   Gal Pressman <gal@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>, Gal Pressman <gal@nvidia.com>
Subject: [PATCH net-next 1/4] net/tls: Describe ciphers sizes by const structs
Date:   Wed, 14 Sep 2022 12:05:17 +0300
Message-ID: <20220914090520.4170-2-gal@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220914090520.4170-1-gal@nvidia.com>
References: <20220914090520.4170-1-gal@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT013:EE_|DM4PR12MB7528:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b67d4c2-4cf2-4e6f-c87f-08da96304ef6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OYb48a0M4tXpSL2Hzn7CVPz3xVnn+7Kyug0oW/hWaQzhaQiwJN0D9l1tQCAWpfO/JQ5pI0E6jGE0vqnPROV1NM71UEZ6dB75xE//BNE9+CQ2MURod1eByuMHA0ljVp7zy9b906rxDTe+qiyXJPWIjT+wt55Ugorhwy2AK5/8AGyRHCB976nYN7KoYzFv+VSJUfNN771Ka0Gz41g7FuH3mDnc64/mee0KQ51tJw936xOCXZyry2GDtJttgfLnUyBv2d8/yvFnMr6QBTjf6UVuoqSn5XRsuiKzhe15JhUpNBo0hRB0YPzJGsLI6XHQD4rVncSb/0qhEERhKcOGLP+P8V2ym/NKpQdDZctQO4Q7LXXMYo/uLCukHNd9hmvhLYAQnUFQ9ibNHISKXA1/aLu/iP+QsQlTNyfIiKft1lhHDlijiyTWUMwRhMzXRpCViUV3OBOClWgTJqYg6eOPYL6+DcVXPpA3wnXnD/iO9oaVQdNx1tXq3WhAtt8eSckkawA0M0GQVTEyTsuX6bCpbQzpti9auLZZdVNjeP3g1pWg9LftCmZLNtHycuu0EKcTpDtjvYDTGqnxkduk+84Atc8fVbXYRWHzImp/T9fbPZ14U7PEBKrUwkvoSdGsMYpgMA0p2Ppf96QsgrV/7+yJctB/Hd2MJt9HNfK26VIPgSI22CIUcOfuK8vVnwEHts9gENo++dDxO1zqpf3TA3LsPQWZXE0HkaHvoiPbP8fPBt7wEIEN5PbrmoHL1d16EHxsB/U+YJog2cVibrqKTZpuarA09g==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(136003)(346002)(396003)(451199015)(46966006)(36840700001)(40470700004)(2616005)(107886003)(86362001)(82740400003)(4326008)(47076005)(478600001)(336012)(40460700003)(6666004)(8676002)(26005)(5660300002)(186003)(54906003)(41300700001)(7696005)(40480700001)(356005)(70586007)(426003)(82310400005)(36860700001)(36756003)(8936002)(1076003)(70206006)(7636003)(110136005)(316002)(2906002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2022 09:05:45.1708
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b67d4c2-4cf2-4e6f-c87f-08da96304ef6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT013.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7528
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

Introduce cipher sizes descriptor. It helps reducing the amount of code
duplications and repeated switch/cases that assigns the proper sizes
according to the cipher type.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Gal Pressman <gal@nvidia.com>
---
 include/net/tls.h  | 10 ++++++++++
 net/tls/tls_main.c | 17 +++++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/include/net/tls.h b/include/net/tls.h
index cb205f9d9473..154949c7b0c8 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -51,6 +51,16 @@
 
 struct tls_rec;
 
+struct tls_cipher_size_desc {
+	unsigned int iv;
+	unsigned int key;
+	unsigned int salt;
+	unsigned int tag;
+	unsigned int rec_seq;
+};
+
+extern const struct tls_cipher_size_desc tls_cipher_size_desc[];
+
 /* Maximum data size carried in a TLS record */
 #define TLS_MAX_PAYLOAD_SIZE		((size_t)1 << 14)
 
diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index 08ddf9d837ae..97630def210d 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -58,6 +58,23 @@ enum {
 	TLS_NUM_PROTS,
 };
 
+#define CIPHER_SIZE_DESC(cipher) [cipher] { \
+	.iv = cipher ## _IV_SIZE, \
+	.key = cipher ## _KEY_SIZE, \
+	.salt = cipher ## _SALT_SIZE, \
+	.tag = cipher ## _TAG_SIZE, \
+	.rec_seq = cipher ## _REC_SEQ_SIZE, \
+}
+
+const struct tls_cipher_size_desc tls_cipher_size_desc[] = {
+	CIPHER_SIZE_DESC(TLS_CIPHER_AES_GCM_128),
+	CIPHER_SIZE_DESC(TLS_CIPHER_AES_GCM_256),
+	CIPHER_SIZE_DESC(TLS_CIPHER_AES_CCM_128),
+	CIPHER_SIZE_DESC(TLS_CIPHER_CHACHA20_POLY1305),
+	CIPHER_SIZE_DESC(TLS_CIPHER_SM4_GCM),
+	CIPHER_SIZE_DESC(TLS_CIPHER_SM4_CCM),
+};
+
 static const struct proto *saved_tcpv6_prot;
 static DEFINE_MUTEX(tcpv6_prot_mutex);
 static const struct proto *saved_tcpv4_prot;
-- 
2.25.1

