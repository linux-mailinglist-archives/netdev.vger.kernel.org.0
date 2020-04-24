Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 237E31B7F4A
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 21:46:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729412AbgDXTqP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 15:46:15 -0400
Received: from mail-eopbgr70047.outbound.protection.outlook.com ([40.107.7.47]:44128
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729389AbgDXTqP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Apr 2020 15:46:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DpuV0QTtTjIBLTh8vPC4juCqNuOBHXePImzu64Z+/WauYC3DfLUDqpCf14YlyUAMSNOi1y3cwsAoZAGsr/ZtU6A3mDTtS3t8O02b+NoWz4kZEeTczl/eye25iIgQZ4hd+Q4Zl/U9g5qEqcOaetyY0BnfdKusQKWqix0CWyXlRO3WUsZ2xKJ/ZSrULNpwcGaO2V3BG8B4BDkj0UKSYTt3Ge7Qc6TXT/BocJw9KGWDQA2cpiZ07k7CslMjubQnGV9m33S/ufc5q44aFFVu1PlfLXq7Q2xR9afl6WBVrFZDGfazXEFafZ0zYek6hoygvUMurXaQiyTksyEeFrb5NAX0lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8cVfc70a0WP2X/neLjKcF1OOT1y9XUbAfiAEafxI7SM=;
 b=lN0BxBeuHv92N6Esnx+Q2Xp7hw5dT75VdlD7SJmgthXEi5HUFQl4TxTt8ZxyECGSZBaYPoNZAso0yqgoo8JqwOPi6ov7EOaY0aTs1rTIFAoGqNfRKNnN3inUwYwaizYcOsMbNsauHu8S9zGanFWsJQ9e9fVmpV2O7wgz1w2bfwE8+T1t0EWEcFt8yo+Ko10hlQgX7AgoTm5PKUx9ciyeFZkfFQx0+57QUQHDq5xjsvhpvcOZNb+W3M0IZyU5Z0GK2Sk30fV3ykuGqYKu43CC+/awnHnEYuNfejciq99++nFj90WaKp4n+Jen48D755awRarLjzQ8Cg4aBZPvU7YZIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8cVfc70a0WP2X/neLjKcF1OOT1y9XUbAfiAEafxI7SM=;
 b=jwKOBEqOf5aou0RHp9jLCSptqYvzdvBpFv/YL6tUtExlv1N9dB2MLdflVVRpn1AeruvyjdZ/c8HgkXWhyLvXJXS+bZLLYXbgLqZtskA3JWmunQbtLP9wYiot5JtUEVNBn7ECqZs/bFnfvBHbmiiRvwt2BiSxwz3g2ou7e7rd3QM=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5072.eurprd05.prod.outlook.com (2603:10a6:803:61::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Fri, 24 Apr
 2020 19:45:55 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2937.020; Fri, 24 Apr 2020
 19:45:54 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Tariq Toukan <tariqt@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Boris Pismenny <borisp@mellanox.com>
Subject: [PATCH mlx5-next 7/9] net/mlx5: Introduce TLS RX offload hardware bits
Date:   Fri, 24 Apr 2020 12:45:08 -0700
Message-Id: <20200424194510.11221-8-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <20200424194510.11221-1-saeedm@mellanox.com>
References: <20200424194510.11221-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0016.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::29) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR06CA0016.namprd06.prod.outlook.com (2603:10b6:a03:d4::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Fri, 24 Apr 2020 19:45:52 +0000
X-Mailer: git-send-email 2.25.3
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: bc7e9a3c-328c-4c26-5291-08d7e8881991
X-MS-TrafficTypeDiagnostic: VI1PR05MB5072:|VI1PR05MB5072:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB5072C2E7C857AA14AF8C9D0ABED00@VI1PR05MB5072.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:454;
X-Forefront-PRVS: 03838E948C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(39860400002)(136003)(396003)(376002)(366004)(346002)(6506007)(26005)(2616005)(8936002)(8676002)(316002)(6636002)(36756003)(6666004)(66946007)(66556008)(52116002)(81156014)(478600001)(107886003)(66476007)(6512007)(956004)(5660300002)(110136005)(4326008)(1076003)(54906003)(16526019)(186003)(2906002)(6486002)(86362001)(450100002)(54420400002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3OJscuoONR3yEh5reRJfW01kMStytryb/K0bJsDjNDJk2HyrPxdthBJwCW0rcvFKuVS3L5mOw0MEFDHM7qVepGBQ9prMp23fjz8z24SKgCoqhOr34vhm8zVRnxelx558I5gNWdOKiyhLxvYJvyzAWUzLKJusJiGXfoN3BDbfziV7wI6ufWrxVc/7x8MXZ0MGaOgttfvCSDVmsL/GzA5IJhQPn415z/VXR3hD3gduAr/FLvvUDqk4bOe67+TfgmuVJFcozU+H+KmpgZg6lBoSnJGCK3nnkZ2gGarZBL3kdhQyqJgJXZk2RIEE3KZAJt+OkBOd0U2SYytZPgMw8zo3ypX8y4BAWGz0G4IF7/y6SlJwepeRE8p/WTHOZ7vL81dqBrH6kVJCe+63ncxRk/wWEnLHVhu3wUUBuye77pFLvdH8AxWGLsJ7REuWfj3Fpy9FQpBnSVuH9Z4HVsnnCxSml7ZbysqiO8uAFybByQBXPIvkont/hViZ6tuwrq1Hxmy0
X-MS-Exchange-AntiSpam-MessageData: iiyQLcp8JhRndnwiUHJtyEOr85HVdRbU3LY7AR2EG2i1WUFKPoog8fQnpGjga2cQX/+xAVbuJ21bq58tTwJVoAZreNe55o67AKYI4dCtL8xwo5QPmbZOSKxvBLoJNeJRJ4fstRagBWj/zU/CStbzwg==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc7e9a3c-328c-4c26-5291-08d7e8881991
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2020 19:45:54.1013
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UGsuiqzcmOq+nutqJ6Qa5J73hkYZ2eYrFRQWcuTqb8XhyA75x6Jsot9RUm4GQO5Df3zg8Od3UTVA9Oqb3ztTiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5072
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

Add TLS RX offload related IFC hardware fields and enumerations.

Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Boris Pismenny <borisp@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 include/linux/mlx5/device.h   | 18 ++++++++++++++++--
 include/linux/mlx5/mlx5_ifc.h |  5 +++--
 2 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index de93f0b67973..1bc27aca648b 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -450,10 +450,12 @@ enum {
 
 enum {
 	MLX5_OPC_MOD_TLS_TIS_STATIC_PARAMS = 0x1,
+	MLX5_OPC_MOD_TLS_TIR_STATIC_PARAMS = 0x2,
 };
 
 enum {
 	MLX5_OPC_MOD_TLS_TIS_PROGRESS_PARAMS = 0x1,
+	MLX5_OPC_MOD_TLS_TIR_PROGRESS_PARAMS = 0x2,
 };
 
 enum {
@@ -764,7 +766,7 @@ struct mlx5_err_cqe {
 };
 
 struct mlx5_cqe64 {
-	u8		outer_l3_tunneled;
+	u8		tls_outer_l3_tunneled;
 	u8		rsvd0;
 	__be16		wqe_id;
 	u8		lro_tcppsh_abort_dupack;
@@ -854,7 +856,12 @@ static inline u8 get_cqe_l3_hdr_type(struct mlx5_cqe64 *cqe)
 
 static inline bool cqe_is_tunneled(struct mlx5_cqe64 *cqe)
 {
-	return cqe->outer_l3_tunneled & 0x1;
+	return cqe->tls_outer_l3_tunneled & 0x1;
+}
+
+static inline u8 get_cqe_tls_offload(struct mlx5_cqe64 *cqe)
+{
+	return (cqe->tls_outer_l3_tunneled >> 3) & 0x3;
 }
 
 static inline bool cqe_has_vlan(struct mlx5_cqe64 *cqe)
@@ -942,6 +949,13 @@ enum {
 	CQE_L4_OK	= 1 << 2,
 };
 
+enum {
+	CQE_TLS_OFFLOAD_NOT_DECRYPTED		= 0x0,
+	CQE_TLS_OFFLOAD_DECRYPTED		= 0x1,
+	CQE_TLS_OFFLOAD_RESYNC			= 0x2,
+	CQE_TLS_OFFLOAD_ERROR			= 0x3,
+};
+
 struct mlx5_sig_err_cqe {
 	u8		rsvd0[16];
 	__be32		expected_trans_sig;
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 058ded202b65..6a6bb5dc7916 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1491,7 +1491,7 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 
 	u8         reserved_at_480[0x1];
 	u8         tls_tx[0x1];
-	u8         reserved_at_482[0x1];
+	u8         tls_rx[0x1];
 	u8         log_max_l2_table[0x5];
 	u8         reserved_at_488[0x8];
 	u8         log_uar_page_sz[0x10];
@@ -3136,7 +3136,8 @@ struct mlx5_ifc_tirc_bits {
 	u8         reserved_at_0[0x20];
 
 	u8         disp_type[0x4];
-	u8         reserved_at_24[0x1c];
+	u8         tls_en[0x1];
+	u8         reserved_at_25[0x1b];
 
 	u8         reserved_at_40[0x40];
 
-- 
2.25.3

