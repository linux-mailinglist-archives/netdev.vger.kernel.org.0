Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D19A20C445
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 23:19:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbgF0VTP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jun 2020 17:19:15 -0400
Received: from mail-eopbgr60076.outbound.protection.outlook.com ([40.107.6.76]:16519
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725916AbgF0VTN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 27 Jun 2020 17:19:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IZ1IMC6umRLHLID3+wZJPtRdpZJM93RVVtz+UBFU/s1EUg7h4/y2jqvQicCAAwUQ7VHqr+ih80kGG5uVgUyel55hCoqE8s+kIbJR6FZ07Dg8E/baKyDimv9LCTDI/CfBxPaBWxHBgk64Zq0tON+d9vAQ0SyW+AF26cZVR/jd31/0+4OoxY1kzFFIw8ZYves7MgX+y+c0N00oMv9gZggrFU+7+eEaZYTd+GdTTpI70REbQ2TbJdKb8n5UfUU/5jbCea/3IOgI30wPo6ARs8FPN0fMiZMCYKPQxsftEdt71f9Nt9FORq4Ai2HZFAIwTfaZwQl3szYFpA4QsblmrX1oCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=11U0Wzn5YnOsqnyB/WwZylV16agrSaYo4uoTLZB69zg=;
 b=ZZs9RZupjHpfcTufhvwHhVQP+/oXT/fx7F2caGWuGw7BwuPvvj6DU5kNRxmno9fhk+wa2gZ8LQMa+QBTx3vL5MrCemURTJrffRfUY6+NhSJVZc45w28N6uw08st/XXRWXETUX7Kr6ewJxcpZcTC+yFfzwdC5OAMZYCH/b0gCfUTk2ey15b4p8UHuYyqfBBbCGY2EliJEWiYpSaIwluOCwhX7I47dplkmlmcnJiQ/cysTa+3hse7ir+dsc63cdXhvtABBQqN6jTA3F57d/ftCMRWOz9X2nzj76VbCGkPGAS6VXEbDsWkyoFZ5vw4iY9gT0017avNz1o5hpKEnQ70oEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=11U0Wzn5YnOsqnyB/WwZylV16agrSaYo4uoTLZB69zg=;
 b=RYzJFev40f4Xqa9btpIwJljoZ0aO0fo3sNx8RLcJiL58O/laAsutcjvLsClKiuHaJ670L5jiQWeX4eMAHG5MWlgtnjtiAmHghBxgjmSQJL1hQmP2C/v2YI3uYXcsen1IK/dbByLFcq0UURJirvQYGnW6W03hFgoAIF+2ZIZOMm4=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5134.eurprd05.prod.outlook.com (2603:10a6:803:ad::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21; Sat, 27 Jun
 2020 21:18:56 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3131.026; Sat, 27 Jun 2020
 21:18:56 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Boris Pismenny <borisp@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 09/15] Revert "net/tls: Add force_resync for driver resync"
Date:   Sat, 27 Jun 2020 14:17:21 -0700
Message-Id: <20200627211727.259569-10-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200627211727.259569-1-saeedm@mellanox.com>
References: <20200627211727.259569-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0017.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::27) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR03CA0017.namprd03.prod.outlook.com (2603:10b6:a03:1e0::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21 via Frontend Transport; Sat, 27 Jun 2020 21:18:54 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: bea5ec3c-0397-4db9-b2f1-08d81adfb31b
X-MS-TrafficTypeDiagnostic: VI1PR05MB5134:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB51347DFFAD133571A382C2A0BE900@VI1PR05MB5134.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:364;
X-Forefront-PRVS: 0447DB1C71
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5HPKQB3ZEq17BhLHjgfdd7r0oX2Hln0qLJaDN2ipkpEaVmlTgnSNlpX72WiCSXLii0fImiGjMNeGQYEmNiPoxvLSuepQtn2wfexzIDAGRQp63Vsa1N34dnJ4oiDVOIw9+9wj+aWuxQw22BwckDlUj0pR6xZIkz9gCxsOfz2KLUyLsyM9vDGGewnBoCHGqBD3wdZKqWA9d+W+ZueT1ADyPRO5IRUNStXtROgtJ5EenBF7IGwOY8Qby+7DkEF8JDT+0iCU3iJYr0VyQ3kVeHwGX3S4/NnFBAkyltZ+IpBHIy18TMIheigCCu2aVTFkbRMrFZqSA+fOhaYIUXclF1NFG9/hTSFfvbVlMMJzXmo/ce+sggVCLt5zfeCirvNhko9r
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(376002)(136003)(39850400004)(346002)(396003)(66476007)(107886003)(54906003)(478600001)(4326008)(316002)(6512007)(16526019)(6506007)(2616005)(1076003)(6486002)(956004)(6666004)(66556008)(8936002)(52116002)(86362001)(36756003)(5660300002)(66946007)(26005)(8676002)(83380400001)(2906002)(186003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: NIDeV7OyCCNLekFJfGz2bj0QNZfKUklQU3DJdz7GGlUkY2iOmgQNtPHnDxRU2I56mUBtnlYOAEjF45QfH7iLFdRlv3gABLh9VkHKvlbh1CtR1AN1+baDuZxR07gc5STtlxciVjryn/VPHgF1goERMUyrtFlD7LNMmJOtYOaY+fTxh1gnrJBGehu3ILGx88wkbZUJk3X/eo1DNuDrhhSGhHPx+15mnuq8v4Bse4UFmhbXdljSrONxDDRNGI1epsxUPi1y6N4GtFzhyNKNX/uFSmLYkab+ikkJ635yWn8RYekPJjCjQcr+EzR4+SLRtkMqpGBSvd+ntiT5P47RaWNY03TFQgmj7ewIsaR50AjLAwJ7rcZ67lOE9tr6nP1QRwdpmgd8K56Cne5yXU8F02uVl4+ljRLyzXseCdJN3YMN9sbttsgWD+zO8jOdspOkHLSALVewQ1au8E8T+nzSuFAGh3Qpp7KYFUFCsz4zLDC8Z5M=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bea5ec3c-0397-4db9-b2f1-08d81adfb31b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2020 21:18:56.0140
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FoSUx54c3qyUXf7vkIJQDCF+uStMeOv+JDJW+ReEFg4M+O3vqQ+AHguSlcanS72MW4BDt2URhRrOnL5V0jvhhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5134
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Boris Pismenny <borisp@mellanox.com>

This reverts commit b3ae2459f89773adcbf16fef4b68deaaa3be1929.
Revert the force resync API.
Not in use. To be replaced by a better async resync API downstream.

Signed-off-by: Boris Pismenny <borisp@mellanox.com>
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 include/net/tls.h    | 12 +-----------
 net/tls/tls_device.c |  9 +++------
 2 files changed, 4 insertions(+), 17 deletions(-)

diff --git a/include/net/tls.h b/include/net/tls.h
index 3212d3c214a9..ca5f7f437289 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -607,22 +607,12 @@ tls_driver_ctx(const struct sock *sk, enum tls_offload_ctx_dir direction)
 #endif
 
 /* The TLS context is valid until sk_destruct is called */
-#define RESYNC_REQ (1 << 0)
-#define RESYNC_REQ_FORCE (1 << 1)
 static inline void tls_offload_rx_resync_request(struct sock *sk, __be32 seq)
 {
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	struct tls_offload_context_rx *rx_ctx = tls_offload_ctx_rx(tls_ctx);
 
-	atomic64_set(&rx_ctx->resync_req, ((u64)ntohl(seq) << 32) | RESYNC_REQ);
-}
-
-static inline void tls_offload_rx_force_resync_request(struct sock *sk)
-{
-	struct tls_context *tls_ctx = tls_get_ctx(sk);
-	struct tls_offload_context_rx *rx_ctx = tls_offload_ctx_rx(tls_ctx);
-
-	atomic64_set(&rx_ctx->resync_req, RESYNC_REQ | RESYNC_REQ_FORCE);
+	atomic64_set(&rx_ctx->resync_req, ((u64)ntohl(seq) << 32) | 1);
 }
 
 static inline void
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 0e55f8365ce2..a562ebaaa33c 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -694,11 +694,10 @@ void tls_device_rx_resync_new_rec(struct sock *sk, u32 rcd_len, u32 seq)
 {
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	struct tls_offload_context_rx *rx_ctx;
-	bool is_req_pending, is_force_resync;
 	u8 rcd_sn[TLS_MAX_REC_SEQ_SIZE];
+	u32 sock_data, is_req_pending;
 	struct tls_prot_info *prot;
 	s64 resync_req;
-	u32 sock_data;
 	u32 req_seq;
 
 	if (tls_ctx->rx_conf != TLS_HW)
@@ -713,11 +712,9 @@ void tls_device_rx_resync_new_rec(struct sock *sk, u32 rcd_len, u32 seq)
 		resync_req = atomic64_read(&rx_ctx->resync_req);
 		req_seq = resync_req >> 32;
 		seq += TLS_HEADER_SIZE - 1;
-		is_req_pending = resync_req & RESYNC_REQ;
-		is_force_resync = resync_req & RESYNC_REQ_FORCE;
+		is_req_pending = resync_req;
 
-		if (likely(!is_req_pending) ||
-		    (!is_force_resync && req_seq != seq) ||
+		if (likely(!is_req_pending) || req_seq != seq ||
 		    !atomic64_try_cmpxchg(&rx_ctx->resync_req, &resync_req, 0))
 			return;
 		break;
-- 
2.26.2

