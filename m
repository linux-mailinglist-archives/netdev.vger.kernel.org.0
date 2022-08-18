Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53081597E8A
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 08:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243619AbiHRGVD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 02:21:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243477AbiHRGVB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 02:21:01 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2044.outbound.protection.outlook.com [40.107.223.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7543F9E119;
        Wed, 17 Aug 2022 23:21:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DyVanlHyqgEwGmUDGWncTr4tZDuC0iw5j6QPm3RpHVHue8sv0NA2j2EXOHvuBNRuoxxX0UN+JACvmRZTyImH4BS/j8GoUmcdfgaQ1Xayju8eknmgBj7XOYKjCxoiJWYDf8UrvdaB57Sa8kL5WhZ/1yaZ2Fs+sTU4l8/h6ZUsV4/yMvNcNJMlT/zr7vO93kpGENdchaRhzvJ2u0VYjAJnvA7SI/ryBhWZE4cskW9LJ5MYgiJt+N6w/3T0d+nKbuPQOlzdu6zik+5A730wpQByD0rcJG+8tInOpckeZ6Wk8iuG/ifPi5I8QnEiOBx1TFtlgPMjd2XwYNm6acIh9cz51w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9F6C3l/WxpG2/eOFv8ywXdy6+inr8QKYW+D6GkzJU5g=;
 b=lvjYdEope0cpfbM5plbqNn2gpk2eTxjt/xRd9wXh+Wx4y8+eBRDqucdxubrURcnGJ6kl6qKekiNGprU0l3ss2BXZbDxGgAFoPxLiasoURCAZW51NLndi+l8DP56kHo8TjgW//0OTH1Bl286V4tkyJUpsreBMsg7Q1VS9FEqry2Lt5Yvwd1cc4Wav0U7z+B47CbYfqsdly/rMggnGnx+6344xmlcHE5F6yoJNbNU1d9j5dSnlb//wGUeHNkkSuhTTzPBeuqY1BZeKd7nOsUpJMRgwP1ARGByfjvGYnpGv78zbXozvGRVRyDztY4nT8UFUQo8OjB+QdMGa3x2ZE94UwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9F6C3l/WxpG2/eOFv8ywXdy6+inr8QKYW+D6GkzJU5g=;
 b=GptSZQB5RlqTzA39YFCQhuKHawjNS2k0V7nZ2005aqJHBijXm4Fpj4Yztxx8lHN/XLVVrXVMOdISxjn1fvz9PlUk0rK/odDQsg6OilZYE4N9WL2cZJg/vnHhMdP07xPBXAEW4fE5v131ZaF9QTSZbG9+XSSLPUzg0Odbk+sni3PqzfkI4VTPLbGZjAPakMnLA3C6JyLgqjLyr6zZD1fsSV1myuD8ob0IY7z5P94lTIy8azaptV7EGaVDsAF5DOd789tTvGo643BTByN/DN1eBEdwoUX6wY4VGhOiWIhxIgoq80Tue4xE+IdwOjxIZWiL7dUt4R96T3dUw8WNsplEUQ==
Received: from MW3PR05CA0002.namprd05.prod.outlook.com (2603:10b6:303:2b::7)
 by DM6PR12MB4073.namprd12.prod.outlook.com (2603:10b6:5:217::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.10; Thu, 18 Aug
 2022 06:20:59 +0000
Received: from CO1NAM11FT053.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:2b:cafe::49) by MW3PR05CA0002.outlook.office365.com
 (2603:10b6:303:2b::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.4 via Frontend
 Transport; Thu, 18 Aug 2022 06:20:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT053.mail.protection.outlook.com (10.13.175.63) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5546.15 via Frontend Transport; Thu, 18 Aug 2022 06:20:58 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Thu, 18 Aug
 2022 06:20:58 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Wed, 17 Aug
 2022 23:20:57 -0700
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.29 via Frontend Transport; Wed, 17 Aug
 2022 23:20:54 -0700
From:   Emeel Hakim <ehakim@nvidia.com>
To:     <edumazet@google.com>, <mayflowerera@gmail.com>
CC:     <kuba@kernel.org>, <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Emeel Hakim <ehakim@nvidia.com>,
        Raed Salem <raeds@nvidia.com>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH net-next v2 1/1] net: macsec: Expose MACSEC_SALT_LEN definition to user space
Date:   Thu, 18 Aug 2022 09:20:34 +0300
Message-ID: <20220818062034.8308-1-ehakim@nvidia.com>
X-Mailer: git-send-email 2.21.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8eccd9d6-9252-4b92-7799-08da80e1d0e7
X-MS-TrafficTypeDiagnostic: DM6PR12MB4073:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UkiGsbqfvX2nnYpjbCI5NjLq3p7iDuA22D3tHgUMY84WgYZyVO5tjCZS8+qWmJ+B+R5PzdAWDdyjyX1/YkwUjl3tsy5Q/WCBwbCPbsVlzKn71DUjL+gVu3Wh5ij1gYVFaUn8axelOtWpyoLS21r5eHJIspgkeY+KZN6a3NuzGjZDXuDhDg08QKtfiOkNQYXd08q1+W0NdRihNPyLyF5w9NNO8+zum06LFt+7jq/XgG7Nn6LGybpp54BkuauVJXdjywvqjKBLUT3Qe50g+3db3SgJqMcS5y6s589VqUQfvkr5lXRgGVBjHl5CrCkkG4a3ebqXih9OXpMfq5/pm98aa/FezEeRSq9AGhZHs1Ice5oYr0h+idsAep+Krzqs658keYUL0Vf79jSz/FguFxBK3X5PW+TRD7ImQ++IVHJZYvpvf98KZJj8++FgnZ71FlDJMCmaMa/nD7c5fZ3Fvt0a/WSuyzf7tscGBjNZG+9hMr9AgzkkyFpim1Csc6Z62/TrqC4yeZtnd3q32YjvDA699uYTwGI6cCZGvJ/Ak1hmwOMHGAuiXLesfVNXFSihwfNNwjeHaj5KW6eSiV0c0uKDFHuFwGwvmqPm1C/jHUtfpCmsfNlC0ycmXFSLjGqU/qjbQVtnJkvJkcvYAKV1T36EbVc5BFBleO/zMaYF25geQZ5g86lzVuLAQc81t98o/rRjmtS3A4Nciprlda5U0rYmT1RGvx5GJHbRDyS3eTlxrGlGAmm6i7DWPzFU/M53H/TxYnTnOXyC+0M/brCWhnW23OPH1rSGRgsKOsfA77UTVBIGw/EDNvtCNhyS/gxz5C/U
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(136003)(376002)(396003)(40470700004)(36840700001)(46966006)(6666004)(47076005)(2616005)(36756003)(110136005)(8936002)(5660300002)(478600001)(86362001)(70586007)(40460700003)(426003)(1076003)(36860700001)(316002)(40480700001)(186003)(83380400001)(336012)(81166007)(54906003)(7696005)(4326008)(8676002)(2906002)(82310400005)(82740400003)(70206006)(41300700001)(356005)(26005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 06:20:58.6392
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8eccd9d6-9252-4b92-7799-08da80e1d0e7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT053.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4073
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Expose MACSEC_SALT_LEN definition to user space to be
used in various user space applications such as iproute.
iprotue will use this as part of adding macsec extended
packet number support.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
---
 include/net/macsec.h           | 1 -
 include/uapi/linux/if_macsec.h | 2 ++
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/net/macsec.h b/include/net/macsec.h
index d6fa6b97f6ef..73780aa73644 100644
--- a/include/net/macsec.h
+++ b/include/net/macsec.h
@@ -14,7 +14,6 @@
 #define MACSEC_DEFAULT_PN_LEN 4
 #define MACSEC_XPN_PN_LEN 8
 
-#define MACSEC_SALT_LEN 12
 #define MACSEC_NUM_AN 4 /* 2 bits for the association number */
 
 typedef u64 __bitwise sci_t;
diff --git a/include/uapi/linux/if_macsec.h b/include/uapi/linux/if_macsec.h
index 3af2aa069a36..d5b6d1f37353 100644
--- a/include/uapi/linux/if_macsec.h
+++ b/include/uapi/linux/if_macsec.h
@@ -22,6 +22,8 @@
 
 #define MACSEC_KEYID_LEN 16
 
+#define MACSEC_SALT_LEN 12
+
 /* cipher IDs as per IEEE802.1AE-2018 (Table 14-1) */
 #define MACSEC_CIPHER_ID_GCM_AES_128 0x0080C20001000001ULL
 #define MACSEC_CIPHER_ID_GCM_AES_256 0x0080C20001000002ULL
-- 
2.21.3

