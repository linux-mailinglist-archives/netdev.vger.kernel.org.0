Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 708C71B7F43
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 21:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729361AbgDXTqG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 15:46:06 -0400
Received: from mail-eopbgr70047.outbound.protection.outlook.com ([40.107.7.47]:44128
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729198AbgDXTqG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Apr 2020 15:46:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O/3y9xrtZArRlNv5JoNYjf4WWBR6KBaa7FHwc0MpghLaWu8ZEUEm7BKnTRdqxr35ZNnX0M9pPdIxlINJwQJMKryJiO82NF79FoibD/g38ehe8qM0ZjJU3qSU64tLLLEYlKd+Ywsbte963P92im8BmEnqYSDOUOvY99qjM1lG9SCcOqrkSoNDLORk1NAAxiFKJna0646vSZnbnprCXhEgj8UFYrcF7fS4Q3mSD42208VLe4GhJ+iKhDgNJO/5tI2gXQ17JbwvnpY7TZb+ptSOLaWQdNocVTY9vp9hsuc6yioVwH6B67txHlq/Kc1N53T5m2cYFm1eygU1k3tMGWLMyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OEJrN/PGhkkaW7cznEmpb9iFURoRRIwSXxuJC9jmBYg=;
 b=UTTWTvFoITpdKa6hQ/Cr0s35nAnh/0omoKMfKHDZaAuiP1qiRWbkFHG+I32JJy7Fg2xckgfEeUCAbsuwvCWKclFF64ZDitGWnvhNiNhx/zf3kxxtp9wyQN1eMgSPn5cz+ZMRK3EhA6mvdpoTjADjkqFB2NR4HgrOS2Z1wLbYKf+rMeUKyfWLEhw0Gu08izNrVqS7zKVGQ/pohDatpg/lgdmu9PHxE/hnA0nVli9vp+xXgi5LELquk+e5dfzpPnjTudDGjXVJz4mkiNWt02UBmC8UUpAMqKndxY6gXfIPsBawlHcAGhn9BrjKyWXLPikdLL9gne4a9I6XZN6KliCZNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OEJrN/PGhkkaW7cznEmpb9iFURoRRIwSXxuJC9jmBYg=;
 b=hK/ufS9uHG7yoBgHDyZWSvg3RHs5zP+g8TrQu8X0Q+EYwBHqSAhNCqhZ5FoJgeH0BuJSXGHJnMGSJ2O58nCxT29rtYS7ZJdBICtSSQ8PqcQSXyg1G3H9rkg9rGFt0PEj3qA0rFxx0rg0//1beccS9xkd7cpjirbykkoaXEidpPw=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5072.eurprd05.prod.outlook.com (2603:10a6:803:61::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Fri, 24 Apr
 2020 19:45:50 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2937.020; Fri, 24 Apr 2020
 19:45:50 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Raed Salem <raeds@mellanox.com>,
        Huy Nguyen <huyn@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: [PATCH mlx5-next 4/9] net/mlx5: Refactor imm_inval_pkey field in cqe struct
Date:   Fri, 24 Apr 2020 12:45:05 -0700
Message-Id: <20200424194510.11221-5-saeedm@mellanox.com>
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
Received: from smtp.office365.com (73.15.39.150) by BYAPR06CA0016.namprd06.prod.outlook.com (2603:10b6:a03:d4::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Fri, 24 Apr 2020 19:45:41 +0000
X-Mailer: git-send-email 2.25.3
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 521f87ba-a410-4561-a483-08d7e888130e
X-MS-TrafficTypeDiagnostic: VI1PR05MB5072:|VI1PR05MB5072:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB5072AD7491316C8DF39905EBBED00@VI1PR05MB5072.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-Forefront-PRVS: 03838E948C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(39860400002)(136003)(396003)(376002)(366004)(346002)(6506007)(26005)(2616005)(8936002)(8676002)(316002)(6636002)(36756003)(6666004)(66946007)(66556008)(52116002)(81156014)(478600001)(107886003)(66476007)(6512007)(956004)(5660300002)(110136005)(4326008)(1076003)(54906003)(16526019)(186003)(2906002)(6486002)(86362001)(450100002)(54420400002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ImGWngsCg17ScigdB0oITEz5wFvOomdO2XDaKbH9TGDQTJj4qrXP4HWY8cOi0rkGMcLzZG728lggr20wshs4S2pBOcFcakeGR0ebg+boJTVvmii6fL3hfud5k36/LWFgloEuaMsZ1kINTjtG+RbR2ydON+M2tVI0jRkYrbcFgftsI/8xg9LdS6MGTIrkuLgZRryerN8KKeMYosaKr2rb5fLduaUdqAIz7hj56rQ6L8Lskxu5mnqc9i9R4dw4VUBVME7mDK3NaF41VtRhO33D55eTmrqI8dKz6IatLYW9xpP9vv7FkIB2oCBL3XkRPiVpiv06d5/nUyZ8j0UFasf6KZVjPSKAcmxZCfFMcnvSa0JAw4rEwi8sbtMaElc6Kj0+MHn87yPZMg0UFtEmDfVlVNmfgrHDdYWO3PHmO7FD2Q7eZifF7WUuWgqc5NJ4RK4DalLjdmtQZrOfx4bMlJ4O/BuqUJZu2xIZLZ7JuLeECs3JAYGwvr0Oc/aCcrBwnm3m
X-MS-Exchange-AntiSpam-MessageData: No2y8KXFJlOy9TIlEkypLil0pePM3daiMQAIlHe1sqkuYF4fhKfUlRTp6b+jDhugqK28pHCukYTStdQGOq9AUggs8j/7QLosJrtCwVYbxpvSGsq53E6AgNrQR5eZeGH0ospAQpStBw9SUgJGaagfTw==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 521f87ba-a410-4561-a483-08d7e888130e
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2020 19:45:43.7462
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NB99qC6BGLWoKHTyQMuoYzlKbJnCD4bfAjXqBQM2JzPPz9DYBQRBoQWrGn21ysuMl3a5DZ+/ShS04AO0g/vAGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5072
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Raed Salem <raeds@mellanox.com>

The imm_inval_pkey field can hold four different types of data,
depends on the usage, the data could be one of the below:
- Immediate field of the received message
- Invalidate rkey
- Pkey of the packet
- Flow table metadata

Current implementation doesn't reflect the intended usage of the
field at usage time.

Reflect the different types by replace this field with a union,
modify code where this field is used to reflect its intended
usage.

Signed-off-by: Raed Salem <raeds@mellanox.com>
Reviewed-by: Huy Nguyen <huyn@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/infiniband/hw/mlx5/cq.c                 | 8 ++++----
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 2 +-
 include/linux/mlx5/device.h                     | 7 ++++++-
 3 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index 32c05730dfe9..0c18cb6a2f14 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -202,7 +202,7 @@ static void handle_responder(struct ib_wc *wc, struct mlx5_cqe64 *cqe,
 	case MLX5_CQE_RESP_WR_IMM:
 		wc->opcode	= IB_WC_RECV_RDMA_WITH_IMM;
 		wc->wc_flags	= IB_WC_WITH_IMM;
-		wc->ex.imm_data = cqe->imm_inval_pkey;
+		wc->ex.imm_data = cqe->immediate;
 		break;
 	case MLX5_CQE_RESP_SEND:
 		wc->opcode   = IB_WC_RECV;
@@ -214,12 +214,12 @@ static void handle_responder(struct ib_wc *wc, struct mlx5_cqe64 *cqe,
 	case MLX5_CQE_RESP_SEND_IMM:
 		wc->opcode	= IB_WC_RECV;
 		wc->wc_flags	= IB_WC_WITH_IMM;
-		wc->ex.imm_data = cqe->imm_inval_pkey;
+		wc->ex.imm_data = cqe->immediate;
 		break;
 	case MLX5_CQE_RESP_SEND_INV:
 		wc->opcode	= IB_WC_RECV;
 		wc->wc_flags	= IB_WC_WITH_INVALIDATE;
-		wc->ex.invalidate_rkey = be32_to_cpu(cqe->imm_inval_pkey);
+		wc->ex.invalidate_rkey = be32_to_cpu(cqe->inval_rkey);
 		break;
 	}
 	wc->src_qp	   = be32_to_cpu(cqe->flags_rqpn) & 0xffffff;
@@ -227,7 +227,7 @@ static void handle_responder(struct ib_wc *wc, struct mlx5_cqe64 *cqe,
 	g = (be32_to_cpu(cqe->flags_rqpn) >> 28) & 3;
 	wc->wc_flags |= g ? IB_WC_GRH : 0;
 	if (unlikely(is_qp1(qp->ibqp.qp_type))) {
-		u16 pkey = be32_to_cpu(cqe->imm_inval_pkey) & 0xffff;
+		u16 pkey = be32_to_cpu(cqe->pkey) & 0xffff;
 
 		ib_find_cached_pkey(&dev->ib_dev, qp->port, pkey,
 				    &wc->pkey_index);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 12c5ca5b93ca..5b632434866f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4891,7 +4891,7 @@ bool mlx5e_tc_rep_update_skb(struct mlx5_cqe64 *cqe,
 	reg_c0 = (be32_to_cpu(cqe->sop_drop_qpn) & MLX5E_TC_FLOW_ID_MASK);
 	if (reg_c0 == MLX5_FS_DEFAULT_FLOW_TAG)
 		reg_c0 = 0;
-	reg_c1 = be32_to_cpu(cqe->imm_inval_pkey);
+	reg_c1 = be32_to_cpu(cqe->ft_metadata);
 
 	if (!reg_c0)
 		return true;
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index 7b57877e501e..746e17473d72 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -767,7 +767,12 @@ struct mlx5_cqe64 {
 	u8		l4_l3_hdr_type;
 	__be16		vlan_info;
 	__be32		srqn; /* [31:24]: lro_num_seg, [23:0]: srqn */
-	__be32		imm_inval_pkey;
+	union {
+		__be32 immediate;
+		__be32 inval_rkey;
+		__be32 pkey;
+		__be32 ft_metadata;
+	};
 	u8		rsvd40[4];
 	__be32		byte_cnt;
 	__be32		timestamp_h;
-- 
2.25.3

