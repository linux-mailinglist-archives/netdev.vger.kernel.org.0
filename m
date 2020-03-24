Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBE5B191C51
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 22:53:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728350AbgCXVx2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 17:53:28 -0400
Received: from mail-vi1eur05on2072.outbound.protection.outlook.com ([40.107.21.72]:6069
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728227AbgCXVx1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Mar 2020 17:53:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UC26NPgIYaisMwouv0rSjjIV2G73RPQ5m3zJu7sd2xkTcP5HO+ocFBbzd3IS33SlXKBPZB9dNTV4t+SSqkCtEDv6jvrwWh2vAqhlbhpjBk+m3a/CR6AyZSp/JubFoPtChfb1B8Uxj5OYQrMSl1XGxQze6plCREjzA8aRX6UXnheFbq/bHDMK77xvTPGyloBcW4dSzJcPJAICJUlE5ujQaqyYdUjE9x2rHeHHd+jaIDA0KNgKHBqiYg77DpjgYSewE4poWmoGiATaV0ijGsjw9GAgOPDDHKAEKNtF9/Dp23otqeUhI8lwK2rM6dHTfIlGDF3rQlMkJzvFQXKFPY/fMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vu5vHPsOHAJ9GFq5fuwgfDJQdDyGzH3uLUscy50AYkc=;
 b=G9LLHI55DqqrzNHLPZ+LmYQfaADVFtxIZhYiZ/FHKgOTyZjKhdod2eDZPPfJQBzsPqTnPT1glgmKlBMZzU5U2Jj25g8lhVEeFTu9CJLlr0y8r2ekaaTpb0fUybdn/Qsx0wVAGw0smf+Wx9T3DuAgb2fCX4l+074F4Xv38aHtSgbySiAM35o+5WIZe9ORr3cyDtd3h2W9KB4r+gkG5UVCJ53bY2jZHKQVwVIEVUeR+96lhmuHXbP4uDgJyimQb5yK/AqQRi2OPvZH8+8izkss3ApEOS2P1uqOU87tR+0cweQpSma9zORS+FZkGr7DEvwAMH98ojRHvniJ2OTMFu/QuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vu5vHPsOHAJ9GFq5fuwgfDJQdDyGzH3uLUscy50AYkc=;
 b=tGfQcLpKZR8fjMISwsbbQMKjvMKEheBfcI7XfMSo9QX8vfXPIjU55amESvDW1qALXGk8NnLByJPmpdvF7/Djy6P41SnDx1jhaRwGY1Cp9kMEVnBtO0piDvQKVpcLWBoT9uUG5mx+AQ9AmPltOF4Se2lgq8ovJUaJGisMI5epPww=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4973.eurprd05.prod.outlook.com (20.177.52.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.20; Tue, 24 Mar 2020 21:53:24 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2835.023; Tue, 24 Mar 2020
 21:53:24 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        Aya Levin <ayal@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 2/5] net/mlx5e: Enhance ICOSQ WQE info fields
Date:   Tue, 24 Mar 2020 14:52:54 -0700
Message-Id: <20200324215257.150911-3-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200324215257.150911-1-saeedm@mellanox.com>
References: <20200324215257.150911-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0049.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::26) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR06CA0049.namprd06.prod.outlook.com (2603:10b6:a03:14b::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.19 via Frontend Transport; Tue, 24 Mar 2020 21:53:22 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b827c766-71d6-404e-3bb2-08d7d03dc6a0
X-MS-TrafficTypeDiagnostic: VI1PR05MB4973:|VI1PR05MB4973:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB49734FCF1536B15628EED52FBEF10@VI1PR05MB4973.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 03524FBD26
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(136003)(39860400002)(346002)(366004)(396003)(6666004)(107886003)(54906003)(8936002)(2616005)(16526019)(8676002)(81156014)(86362001)(956004)(36756003)(6486002)(81166006)(186003)(66946007)(6512007)(52116002)(2906002)(5660300002)(6916009)(66476007)(66556008)(316002)(26005)(6506007)(478600001)(4326008)(1076003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4973;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BPbTRJXlGQ+rI+f0pQXlLoQt/N2BpV45RbSyNjBK1RJ/nOc3QFbECGnkwbIQtqdQVP/vfOTv4JKeiDv9Ix98YD7BrDIzu96C5HNoFJQ4R003PKadtGAGkEhQ3C+TnY7NZ9nXnLMehAhxMshSuEUteY6zzlv3mxsYQflQ8qwdKXO8NUuUUe/svplvZH/qNVzq4NH6awt5boA3/tkreUq9uMeoocwLOtfNhq7+ACMC9H/GGSN5I59X5v04fLURoDrKwNxreLFmqJgDC6dcyUBZUuPAJCCcv3auL1FtO1szIY6kd7FwMVMLOtK9mhI/G7Oqg/l4WvEi2rFpfM17yvXYx9B3WdwndOhhtfBnYoGNm+OtsZsju7kCvA4Jqz6/wpfoEuS8n2b+vSbeE1bEZcJoLlKSLX63+RJEPCE0Jl53ftOFQFtK3Y5tY/pS9/CyBpbgIZ7Jb3DgzDTH8LcVPHhtewKiwVhC/pkZ4CQQZ2HaasQK/HJwmkRZ1E+/sLcoWB/MaWDsH6+ox1iTfDUSJ9656ubYfzWjeRwADSTX15N/B3w=
X-MS-Exchange-AntiSpam-MessageData: 0wO+zaJK8/Jb5U8CDElhSFauHM+dViakU4ZtH7ADLe9FWEcnw1tbMqyQxzTdICbx5w9urSg7Pc0iddwNsE0WVn5iaTeVmQlf24RLANEPjce3uS7Q+WZfnsHQIIvxdv6iCIl01Z2YGGngI7ssaZ56ig==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b827c766-71d6-404e-3bb2-08d7d03dc6a0
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2020 21:53:24.1865
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: syJ/gduH3/SlPjGQdj8ICfK6EgLi/3KluQojoem/usmy3ntE8jpcnBnZnMWTSPk91pHrInWPMxl8Uug3u9sOiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4973
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Add number of WQEBBs (WQE's Basic Block) to WQE info struct. Set the
number of WQEBBs on WQE post, and increment the consumer counter (cc)
on completion.

In case of error completions, the cc was mistakenly not incremented,
keeping a gap between cc and pc (producer counter). This failed the
recovery flow on the ICOSQ from a CQE error which timed-out waiting for
the cc and pc to meet.

Fixes: be5323c8379f ("net/mlx5e: Report and recover from CQE error on ICOSQ")
Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h      |  1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c   | 11 +++++------
 drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c |  1 +
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 220ef9f06f84..571ac5976549 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -371,6 +371,7 @@ enum {
 
 struct mlx5e_sq_wqe_info {
 	u8  opcode;
+	u8 num_wqebbs;
 
 	/* Auxiliary data for different opcodes. */
 	union {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 1c3ab69cbd96..312d4692425b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -477,6 +477,7 @@ static inline void mlx5e_fill_icosq_frag_edge(struct mlx5e_icosq *sq,
 	/* fill sq frag edge with nops to avoid wqe wrapping two pages */
 	for (; wi < edge_wi; wi++) {
 		wi->opcode = MLX5_OPCODE_NOP;
+		wi->num_wqebbs = 1;
 		mlx5e_post_nop(wq, sq->sqn, &sq->pc);
 	}
 }
@@ -525,6 +526,7 @@ static int mlx5e_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
 	umr_wqe->uctrl.xlt_offset = cpu_to_be16(xlt_offset);
 
 	sq->db.ico_wqe[pi].opcode = MLX5_OPCODE_UMR;
+	sq->db.ico_wqe[pi].num_wqebbs = MLX5E_UMR_WQEBBS;
 	sq->db.ico_wqe[pi].umr.rq = rq;
 	sq->pc += MLX5E_UMR_WQEBBS;
 
@@ -621,6 +623,7 @@ void mlx5e_poll_ico_cq(struct mlx5e_cq *cq)
 
 			ci = mlx5_wq_cyc_ctr2ix(&sq->wq, sqcc);
 			wi = &sq->db.ico_wqe[ci];
+			sqcc += wi->num_wqebbs;
 
 			if (last_wqe && unlikely(get_cqe_opcode(cqe) != MLX5_CQE_REQ)) {
 				netdev_WARN_ONCE(cq->channel->netdev,
@@ -631,16 +634,12 @@ void mlx5e_poll_ico_cq(struct mlx5e_cq *cq)
 				break;
 			}
 
-			if (likely(wi->opcode == MLX5_OPCODE_UMR)) {
-				sqcc += MLX5E_UMR_WQEBBS;
+			if (likely(wi->opcode == MLX5_OPCODE_UMR))
 				wi->umr.rq->mpwqe.umr_completed++;
-			} else if (likely(wi->opcode == MLX5_OPCODE_NOP)) {
-				sqcc++;
-			} else {
+			else if (unlikely(wi->opcode != MLX5_OPCODE_NOP))
 				netdev_WARN_ONCE(cq->channel->netdev,
 						 "Bad OPCODE in ICOSQ WQE info: 0x%x\n",
 						 wi->opcode);
-			}
 
 		} while (!last_wqe);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
index 257a7c9f7a14..800d34ed8a96 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
@@ -78,6 +78,7 @@ void mlx5e_trigger_irq(struct mlx5e_icosq *sq)
 	u16 pi = mlx5_wq_cyc_ctr2ix(wq, sq->pc);
 
 	sq->db.ico_wqe[pi].opcode = MLX5_OPCODE_NOP;
+	sq->db.ico_wqe[pi].num_wqebbs = 1;
 	nopwqe = mlx5e_post_nop(wq, sq->sqn, &sq->pc);
 	mlx5e_notify_hw(wq, sq->pc, sq->uar_map, &nopwqe->ctrl);
 }
-- 
2.25.1

