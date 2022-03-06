Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A0FD4CE9D5
	for <lists+netdev@lfdr.de>; Sun,  6 Mar 2022 07:56:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbiCFG5g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 01:57:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiCFG5d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 01:57:33 -0500
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01olkn2023.outbound.protection.outlook.com [40.92.99.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3269231DC7
        for <netdev@vger.kernel.org>; Sat,  5 Mar 2022 22:56:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jJ/Npwu1SMR9adxwbCj+Dl+uFeGTxSEREqa2wJHMuPKE4WFtSQMJtMVpqrpZNi969CIVZTb7mJTYmzzNcGWY7yrChafxrTt1nZwhqqUU/hzFBc7c3A2cixVThGRRqPPlWMttyaJPj3F64dfAVSPkFTonNACRMHx/r0v4qRCgkXbOChJf2xPGQbvA/VmqXQXCUd/TBIGj6nODFFmCXKM+xgIi4QEl9ayTwffKfXEVy71wec6up4k2PSUtFcIvW891cLM4e0fIx4EP4JRC0Md//BsC1ytJ+wmzcz9DRVYZLa5y5RuxnbRk9va4oCo/ljgwilWBSTgq22BWLOhHxUaCPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J+OG4MmHoN8kTXmaPbg6kjZYyOGpZozT2HJPYa1DmeE=;
 b=dQMk+Bpu78kHTU560LXacim7fpruVTIl0PxKfllMKUaLWUpPeVSuel2FRlc/vifXGQZ+gmmumJ2v8X9+XCzH7XgOur++FsaI+uKK+YdMikncIXnSeSKEHACbGtk+TRYmcW6KWeHEp+p3FCuq/4LhjtjwgbZsKr1cxJghcEgIJ92S0VNhH2dn9F282xrUE3hpTWag7C3CW7cIBz6W2aFdTIkDNuGkR1Y6LtjMVFrPNSaAkLQY60rIh44SGwt3ugZUh72Brd54EQd22BYDRD1S8CdYoPPNaLTgESNV7ldqwOwLGCzHK4md/8JSBajtTTkr69Nzk8pg1H14bctX7sW5ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J+OG4MmHoN8kTXmaPbg6kjZYyOGpZozT2HJPYa1DmeE=;
 b=Uf/r+TCQjEkttotOrxVT4LDsGa+eSJaMHJmn3n26UvIjYW4rKNP1+2Q5jr2e+KDEVAmYTiETwlz9752KOqUD7D6odM2GdoukTYEO6+4BiR0efPbLr8wczPITXTGSp37VGHxrZkbqTa1BEYPl93CVtmzhCwKUUqAeRfbbAqC39FWXw4Tyrh2DvP0Pm5WXqGnKugji/KWlezXnTIXvDYt4CV4dNx0vmSbQX1U1bEFGqjCuQMyDVsI1M27VaFCr4M+S4JNGgKqnhX6P7o62rR++h8Ku5x8SoN/nvozKrpPd7fr0WKK5A8MCR6KHf7W39MiD+V6+fNj3Q1wYcr5Fb7WYYw==
Received: from OSAPR01MB7567.jpnprd01.prod.outlook.com (2603:1096:604:147::9)
 by OSBPR01MB2632.jpnprd01.prod.outlook.com (2603:1096:604:15::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Sun, 6 Mar
 2022 06:56:38 +0000
Received: from OSAPR01MB7567.jpnprd01.prod.outlook.com
 ([fe80::ed12:bc41:7a3b:ea5d]) by OSAPR01MB7567.jpnprd01.prod.outlook.com
 ([fe80::ed12:bc41:7a3b:ea5d%6]) with mapi id 15.20.5038.026; Sun, 6 Mar 2022
 06:56:38 +0000
From:   Shangyan Zhou <sy.zhou@hotmail.com>
To:     leon@kernel.org
Cc:     netdev@vger.kernel.org, Shangyan Zhou <sy.zhou@hotmail.com>
Subject: [PATCH v4] rdma: Fix the logic to print unsigned int.
Date:   Sun,  6 Mar 2022 14:56:06 +0800
Message-ID: <OSAPR01MB75671B497B8A1A66AC2BE743E3079@OSAPR01MB7567.jpnprd01.prod.outlook.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <OSAPR01MB7567AF3E28F7D2D72FFA876BE3059@OSAPR01MB7567.jpnprd01.prod.outlook.com>
References: <OSAPR01MB7567AF3E28F7D2D72FFA876BE3059@OSAPR01MB7567.jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN:  [DAC7w+2O1CEnj8kmN+9T81VgaaEl8xVs]
X-ClientProxiedBy: HK2PR04CA0044.apcprd04.prod.outlook.com
 (2603:1096:202:14::12) To OSAPR01MB7567.jpnprd01.prod.outlook.com
 (2603:1096:604:147::9)
X-Microsoft-Original-Message-ID: <20220306065606.3583-1-sy.zhou@hotmail.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4bc4a5f1-d106-49be-ba6f-08d9ff3e7602
X-MS-Exchange-SLBlob-MailProps: mBy7Mai7yE6rPrTdfAAm9c0tZLt2TkJ3l3b7Evi/AgS5sOII8BXG7G3RdxeM+kdx/ROvbC81ovw5D8A4nBq01jn93+D2MHip6SVqQMRVXbY0cO1vBtFQPhqGtEAhRfmZ1eyDqDHwip6z3dsdd04icYjAvGgbz863J8nmsyMdkuHcLbQApiboPEPay/k3WSN2ceOL5Mvv9x/VPWSx2vMFAdD3klwg5kgi8CjJbAGAAs/GUV2fE2w+gcu4cEKk5YbQI6HeCp27xJIQ4cOtN8uWK/dNbWbq6GPmU4+SAuzmL9F8OzOk2g4XCAsqHkH2awCnBpW83jcnueP+epUl6KcrvibaUSijDHdinJkZjbxWw9PShppxb/PeL6I8jQ2CgVTy+cR+dKiznqKbQIE+gSKssvtw+AZoQ6q//BOczYWHpSExBrgO/Hm9krvr67NKGXVkB4Xq4rf5eOn9HHc7wDAUqTZGrAOMLidp6sdQ768OpCWK2b/pBM7a6os9Ybl9GxfFatAmDhG5V7tyN7dMaLB442F2cmKDQPr59vdYD3AqdekbMp09AGVFkxKtC3gNU31F+rNsiFzAXMiWeUN7Ad+deZsHdvCN6j7eE8SUKyXDSqU0lpx3pLMHDTTn5hWpZgivG21dRe7JRHv3fJvp1t6MFRPWS4v+rzSAu6q1WZxeOdWLOPmz0lrzGEgDQuM+rYmHialXYHl/4IuFs494W/HE6N8KpA1+udXF
X-MS-TrafficTypeDiagnostic: OSBPR01MB2632:EE_
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lACBybf26DXA19x/i6l32oHhnPIa6pzkGnuJrzbHh/G3HhyHj1xq27GH8AMkVQ+zhWayga95F84x2UDICz9+XBWOphEQiXcZ3tQIi4HJYnKs6e923eD11/DpL08i9HRFgvAGK9917hRITqL/tD0uiMMbSfnfHskDWEkCjgSJbC9K79GKWk4sjmXowCeU33WcIomPUMnz6bvfiCbuMIBOrg4lXvYeNjaTMCwSCGxuMbDOtobg6ynUkS5SxUWKVM7gRtAc5LnYvvbL6Jzv9PrX7k7XudeNulSxUGY6HT8fEKRofts/ogxPI9bI/LNsukmE3QpcJWPyAJtLrPs2qigLumJuVsHcRKc751+Vtcypa/Nzz3LgJvJ2VFqczCuIsrstxQXMqZAjngokmYGtY0xGkOPS+6qm5xWSHyQEehBDRt11TPc9O6Kg63fxdiuhoMmtqeN+iVihUVFodPz1ifepUN9YIef7avQASIdhrJpP8PcgmjJKZxyEiQDgT8m1E0XN7+tzGRYjWHC35NsvdupcdFrVreYPBmIRqsOXAqpTdvpiGowuySP+VoMz2gnj751HIl8IFDeWPx5qCyDwpLfshg==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?huHe+WUf5BrLG58tEAynkr4kIt2TFonsfe/vEt3+FR7iD1QtEAWmlyh4H9AS?=
 =?us-ascii?Q?FIxSS4f0/QwXj4ajsAVyjmEAqDF3E0vZ28BUakOpmn4mn7wqE1C4cPHvEvFT?=
 =?us-ascii?Q?HSmvWo0KoWSOgDriVpnAu352P+2USZHptfuycX8wRIRcQpkX/ClUL+/3j+Ft?=
 =?us-ascii?Q?VZjfsxq5stUTOEuH1QKU90/1jmRa8dVXynmvotGWbAgn+ljlecYmfyS4f9PI?=
 =?us-ascii?Q?pLczuXCqESq+YcFgcSkxYFdd+GGDJwUN8PAWSlgBmujIqqf0+k7MeiE34BnM?=
 =?us-ascii?Q?1b81NrhW44KRnboKkcw7L81RrI01eOoZyFhbu7ZSzTLqLhc/gzk+G7aOjMcl?=
 =?us-ascii?Q?XVy9+yUIN1Sy66qKAZ4Kp6ICGOIUCLIyWW5dtpWUwtM41L5xLT9lRcUVPHUh?=
 =?us-ascii?Q?b1OPhMLOjT3X2NJbFDPuPaPx5cSafLMx5WIy9ThrptKgk/EgwS7zBI10xY1k?=
 =?us-ascii?Q?NpXVydj4MrXFs3FuXlxfCQpzqcaYsKQhSc+SO26NXVQbMc2O1E/dqvZ12ETC?=
 =?us-ascii?Q?9GuNIaaEH/QVNlLX9kw085iuCu4BIy50SgLOuG1HPBufWYAfGCyL0Qa6UtHW?=
 =?us-ascii?Q?gVFEDryGGZ7+TdTzXa7zShF8PAitsE3PTq+gYT1lpU74xp6CvhXRhu4wvdKB?=
 =?us-ascii?Q?0ItMdy1ZNfB+FMx5tgR6cx4cr1Y61OcJtEPR6nlFq/LEQJA6GMxP1fPDNNbs?=
 =?us-ascii?Q?7KbAcXAW3lMHs7WWlkaX8z9mqWxADJbN1Ev9xRqoUZgU8lqgiUHAqJeUIYCO?=
 =?us-ascii?Q?SZ/IP3BkYhay4knRtUR2kswLHLaOiDXn6g8PRDoeHZEnnPEPUSN+djtff9Mg?=
 =?us-ascii?Q?FQ5MD3HHl2TziCzUd6mLWXOgyliktvBgtwwzX7MJEanNAWdc8ryBGXUB/6zE?=
 =?us-ascii?Q?ICHhu/daAYZWCovHRna/0a9gG7JDIhTpWwYBzKyLw0sal+shCvqyTkn+5/Ry?=
 =?us-ascii?Q?GIf0SzaJ9rhcxqh+GLDBug=3D=3D?=
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-9cf38.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bc4a5f1-d106-49be-ba6f-08d9ff3e7602
X-MS-Exchange-CrossTenant-AuthSource: OSAPR01MB7567.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2022 06:56:38.4612
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB2632
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the corresponding function and fmt string to print unsigned int32
and int64.

Signed-off-by: Shangyan Zhou <sy.zhou@hotmail.com>
---
 rdma/res-cmid.c |  6 +++---
 rdma/res-cq.c   | 10 +++++-----
 rdma/res-ctx.c  |  4 ++--
 rdma/res-mr.c   |  8 ++++----
 rdma/res-pd.c   |  8 ++++----
 rdma/res-qp.c   |  8 ++++----
 rdma/res-srq.c  |  8 ++++----
 rdma/res.c      | 15 ++++++++++++---
 rdma/res.h      |  4 +++-
 rdma/stat-mr.c  |  2 +-
 rdma/stat.c     |  4 ++--
 11 files changed, 44 insertions(+), 33 deletions(-)

diff --git a/rdma/res-cmid.c b/rdma/res-cmid.c
index bfaa47b5..fd57dbb7 100644
--- a/rdma/res-cmid.c
+++ b/rdma/res-cmid.c
@@ -181,14 +181,14 @@ static int res_cm_id_line(struct rd *rd, const char *name, int idx,
 
 	open_json_object(NULL);
 	print_link(rd, idx, name, port, nla_line);
-	res_print_uint(rd, "cm-idn", cm_idn,
+	res_print_u32(rd, "cm-idn", cm_idn,
 		       nla_line[RDMA_NLDEV_ATTR_RES_CM_IDN]);
-	res_print_uint(rd, "lqpn", lqpn, nla_line[RDMA_NLDEV_ATTR_RES_LQPN]);
+	res_print_u32(rd, "lqpn", lqpn, nla_line[RDMA_NLDEV_ATTR_RES_LQPN]);
 	if (nla_line[RDMA_NLDEV_ATTR_RES_TYPE])
 		print_qp_type(rd, type);
 	print_cm_id_state(rd, state);
 	print_ps(rd, ps);
-	res_print_uint(rd, "pid", pid, nla_line[RDMA_NLDEV_ATTR_RES_PID]);
+	res_print_u32(rd, "pid", pid, nla_line[RDMA_NLDEV_ATTR_RES_PID]);
 	print_comm(rd, comm, nla_line);
 
 	if (nla_line[RDMA_NLDEV_ATTR_RES_SRC_ADDR])
diff --git a/rdma/res-cq.c b/rdma/res-cq.c
index 9e7c4f51..818e1d0c 100644
--- a/rdma/res-cq.c
+++ b/rdma/res-cq.c
@@ -110,14 +110,14 @@ static int res_cq_line(struct rd *rd, const char *name, int idx,
 
 	open_json_object(NULL);
 	print_dev(rd, idx, name);
-	res_print_uint(rd, "cqn", cqn, nla_line[RDMA_NLDEV_ATTR_RES_CQN]);
-	res_print_uint(rd, "cqe", cqe, nla_line[RDMA_NLDEV_ATTR_RES_CQE]);
-	res_print_uint(rd, "users", users,
+	res_print_u32(rd, "cqn", cqn, nla_line[RDMA_NLDEV_ATTR_RES_CQN]);
+	res_print_u32(rd, "cqe", cqe, nla_line[RDMA_NLDEV_ATTR_RES_CQE]);
+	res_print_u64(rd, "users", users,
 		       nla_line[RDMA_NLDEV_ATTR_RES_USECNT]);
 	print_poll_ctx(rd, poll_ctx, nla_line[RDMA_NLDEV_ATTR_RES_POLL_CTX]);
 	print_cq_dim_setting(rd, nla_line[RDMA_NLDEV_ATTR_DEV_DIM]);
-	res_print_uint(rd, "ctxn", ctxn, nla_line[RDMA_NLDEV_ATTR_RES_CTXN]);
-	res_print_uint(rd, "pid", pid, nla_line[RDMA_NLDEV_ATTR_RES_PID]);
+	res_print_u32(rd, "ctxn", ctxn, nla_line[RDMA_NLDEV_ATTR_RES_CTXN]);
+	res_print_u32(rd, "pid", pid, nla_line[RDMA_NLDEV_ATTR_RES_PID]);
 	print_comm(rd, comm, nla_line);
 
 	print_driver_table(rd, nla_line[RDMA_NLDEV_ATTR_DRIVER]);
diff --git a/rdma/res-ctx.c b/rdma/res-ctx.c
index 30afe97a..ea5faf18 100644
--- a/rdma/res-ctx.c
+++ b/rdma/res-ctx.c
@@ -40,8 +40,8 @@ static int res_ctx_line(struct rd *rd, const char *name, int idx,
 
 	open_json_object(NULL);
 	print_dev(rd, idx, name);
-	res_print_uint(rd, "ctxn", ctxn, nla_line[RDMA_NLDEV_ATTR_RES_CTXN]);
-	res_print_uint(rd, "pid", pid, nla_line[RDMA_NLDEV_ATTR_RES_PID]);
+	res_print_u32(rd, "ctxn", ctxn, nla_line[RDMA_NLDEV_ATTR_RES_CTXN]);
+	res_print_u32(rd, "pid", pid, nla_line[RDMA_NLDEV_ATTR_RES_PID]);
 	print_comm(rd, comm, nla_line);
 
 	print_driver_table(rd, nla_line[RDMA_NLDEV_ATTR_DRIVER]);
diff --git a/rdma/res-mr.c b/rdma/res-mr.c
index 1bf73f3a..25eaa056 100644
--- a/rdma/res-mr.c
+++ b/rdma/res-mr.c
@@ -73,13 +73,13 @@ static int res_mr_line(struct rd *rd, const char *name, int idx,
 			nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME]);
 	open_json_object(NULL);
 	print_dev(rd, idx, name);
-	res_print_uint(rd, "mrn", mrn, nla_line[RDMA_NLDEV_ATTR_RES_MRN]);
+	res_print_u32(rd, "mrn", mrn, nla_line[RDMA_NLDEV_ATTR_RES_MRN]);
 	print_key(rd, "rkey", rkey, nla_line[RDMA_NLDEV_ATTR_RES_RKEY]);
 	print_key(rd, "lkey", lkey, nla_line[RDMA_NLDEV_ATTR_RES_LKEY]);
 	print_key(rd, "iova", iova, nla_line[RDMA_NLDEV_ATTR_RES_IOVA]);
-	res_print_uint(rd, "mrlen", mrlen, nla_line[RDMA_NLDEV_ATTR_RES_MRLEN]);
-	res_print_uint(rd, "pdn", pdn, nla_line[RDMA_NLDEV_ATTR_RES_PDN]);
-	res_print_uint(rd, "pid", pid, nla_line[RDMA_NLDEV_ATTR_RES_PID]);
+	res_print_u64(rd, "mrlen", mrlen, nla_line[RDMA_NLDEV_ATTR_RES_MRLEN]);
+	res_print_u32(rd, "pdn", pdn, nla_line[RDMA_NLDEV_ATTR_RES_PDN]);
+	res_print_u32(rd, "pid", pid, nla_line[RDMA_NLDEV_ATTR_RES_PID]);
 	print_comm(rd, comm, nla_line);
 
 	print_driver_table(rd, nla_line[RDMA_NLDEV_ATTR_DRIVER]);
diff --git a/rdma/res-pd.c b/rdma/res-pd.c
index df538010..2932eb98 100644
--- a/rdma/res-pd.c
+++ b/rdma/res-pd.c
@@ -62,15 +62,15 @@ static int res_pd_line(struct rd *rd, const char *name, int idx,
 
 	open_json_object(NULL);
 	print_dev(rd, idx, name);
-	res_print_uint(rd, "pdn", pdn, nla_line[RDMA_NLDEV_ATTR_RES_PDN]);
+	res_print_u32(rd, "pdn", pdn, nla_line[RDMA_NLDEV_ATTR_RES_PDN]);
 	print_key(rd, "local_dma_lkey", local_dma_lkey,
 		  nla_line[RDMA_NLDEV_ATTR_RES_LOCAL_DMA_LKEY]);
-	res_print_uint(rd, "users", users,
+	res_print_u64(rd, "users", users,
 		       nla_line[RDMA_NLDEV_ATTR_RES_USECNT]);
 	print_key(rd, "unsafe_global_rkey", unsafe_global_rkey,
 		  nla_line[RDMA_NLDEV_ATTR_RES_UNSAFE_GLOBAL_RKEY]);
-	res_print_uint(rd, "ctxn", ctxn, nla_line[RDMA_NLDEV_ATTR_RES_CTXN]);
-	res_print_uint(rd, "pid", pid, nla_line[RDMA_NLDEV_ATTR_RES_PID]);
+	res_print_u32(rd, "ctxn", ctxn, nla_line[RDMA_NLDEV_ATTR_RES_CTXN]);
+	res_print_u32(rd, "pid", pid, nla_line[RDMA_NLDEV_ATTR_RES_PID]);
 	print_comm(rd, comm, nla_line);
 
 	print_driver_table(rd, nla_line[RDMA_NLDEV_ATTR_DRIVER]);
diff --git a/rdma/res-qp.c b/rdma/res-qp.c
index a38be399..9218804a 100644
--- a/rdma/res-qp.c
+++ b/rdma/res-qp.c
@@ -161,19 +161,19 @@ static int res_qp_line(struct rd *rd, const char *name, int idx,
 
 	open_json_object(NULL);
 	print_link(rd, idx, name, port, nla_line);
-	res_print_uint(rd, "lqpn", lqpn, nla_line[RDMA_NLDEV_ATTR_RES_LQPN]);
+	res_print_u32(rd, "lqpn", lqpn, nla_line[RDMA_NLDEV_ATTR_RES_LQPN]);
 	print_rqpn(rd, rqpn, nla_line);
 
 	print_type(rd, type);
 	print_state(rd, state);
 
 	print_rqpsn(rd, rq_psn, nla_line);
-	res_print_uint(rd, "sq-psn", sq_psn,
+	res_print_u32(rd, "sq-psn", sq_psn,
 		       nla_line[RDMA_NLDEV_ATTR_RES_SQ_PSN]);
 
 	print_pathmig(rd, path_mig_state, nla_line);
-	res_print_uint(rd, "pdn", pdn, nla_line[RDMA_NLDEV_ATTR_RES_PDN]);
-	res_print_uint(rd, "pid", pid, nla_line[RDMA_NLDEV_ATTR_RES_PID]);
+	res_print_u32(rd, "pdn", pdn, nla_line[RDMA_NLDEV_ATTR_RES_PDN]);
+	res_print_u32(rd, "pid", pid, nla_line[RDMA_NLDEV_ATTR_RES_PID]);
 	print_comm(rd, comm, nla_line);
 
 	print_driver_table(rd, nla_line[RDMA_NLDEV_ATTR_DRIVER]);
diff --git a/rdma/res-srq.c b/rdma/res-srq.c
index 3038c352..c6df454a 100644
--- a/rdma/res-srq.c
+++ b/rdma/res-srq.c
@@ -216,12 +216,12 @@ static int res_srq_line(struct rd *rd, const char *name, int idx,
 
 	open_json_object(NULL);
 	print_dev(rd, idx, name);
-	res_print_uint(rd, "srqn", srqn, nla_line[RDMA_NLDEV_ATTR_RES_SRQN]);
+	res_print_u32(rd, "srqn", srqn, nla_line[RDMA_NLDEV_ATTR_RES_SRQN]);
 	print_type(rd, type);
 	print_qps(qp_str);
-	res_print_uint(rd, "pdn", pdn, nla_line[RDMA_NLDEV_ATTR_RES_PDN]);
-	res_print_uint(rd, "cqn", cqn, nla_line[RDMA_NLDEV_ATTR_RES_CQN]);
-	res_print_uint(rd, "pid", pid, nla_line[RDMA_NLDEV_ATTR_RES_PID]);
+	res_print_u32(rd, "pdn", pdn, nla_line[RDMA_NLDEV_ATTR_RES_PDN]);
+	res_print_u32(rd, "cqn", cqn, nla_line[RDMA_NLDEV_ATTR_RES_CQN]);
+	res_print_u32(rd, "pid", pid, nla_line[RDMA_NLDEV_ATTR_RES_PID]);
 	print_comm(rd, comm, nla_line);
 
 	print_driver_table(rd, nla_line[RDMA_NLDEV_ATTR_DRIVER]);
diff --git a/rdma/res.c b/rdma/res.c
index 21fef9bd..854f21c7 100644
--- a/rdma/res.c
+++ b/rdma/res.c
@@ -51,7 +51,7 @@ static int res_print_summary(struct rd *rd, struct nlattr **tb)
 
 		name = mnl_attr_get_str(nla_line[RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY_NAME]);
 		curr = mnl_attr_get_u64(nla_line[RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY_CURR]);
-		res_print_uint(
+		res_print_u64(
 			rd, name, curr,
 			nla_line[RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY_CURR]);
 	}
@@ -208,13 +208,22 @@ void print_key(struct rd *rd, const char *name, uint64_t val,
 	print_color_hex(PRINT_ANY, COLOR_NONE, name, " 0x%" PRIx64 " ", val);
 }
 
-void res_print_uint(struct rd *rd, const char *name, uint64_t val,
+void res_print_u32(struct rd *rd, const char *name, uint32_t val,
 		    struct nlattr *nlattr)
 {
 	if (!nlattr)
 		return;
 	print_color_uint(PRINT_ANY, COLOR_NONE, name, name, val);
-	print_color_uint(PRINT_FP, COLOR_NONE, NULL, " %d ", val);
+	print_color_uint(PRINT_FP, COLOR_NONE, NULL, " %" PRIu32 " ", val);
+}
+
+void res_print_u64(struct rd *rd, const char *name, uint64_t val,
+		    struct nlattr *nlattr)
+{
+	if (!nlattr)
+		return;
+	print_color_u64(PRINT_ANY, COLOR_NONE, name, name, val);
+	print_color_u64(PRINT_FP, COLOR_NONE, NULL, " %" PRIu64 " ", val);
 }
 
 RES_FUNC(res_no_args,	RDMA_NLDEV_CMD_RES_GET,	NULL, true, 0);
diff --git a/rdma/res.h b/rdma/res.h
index 58fa6ad1..70e51acd 100644
--- a/rdma/res.h
+++ b/rdma/res.h
@@ -188,7 +188,9 @@ void print_link(struct rd *rd, uint32_t idx, const char *name, uint32_t port,
 		struct nlattr **nla_line);
 void print_key(struct rd *rd, const char *name, uint64_t val,
 	       struct nlattr *nlattr);
-void res_print_uint(struct rd *rd, const char *name, uint64_t val,
+void res_print_u32(struct rd *rd, const char *name, uint32_t val,
+		    struct nlattr *nlattr);
+void res_print_u64(struct rd *rd, const char *name, uint64_t val,
 		    struct nlattr *nlattr);
 void print_comm(struct rd *rd, const char *str, struct nlattr **nla_line);
 const char *qp_types_to_str(uint8_t idx);
diff --git a/rdma/stat-mr.c b/rdma/stat-mr.c
index f39526b4..2ba6cb07 100644
--- a/rdma/stat-mr.c
+++ b/rdma/stat-mr.c
@@ -22,7 +22,7 @@ static int stat_mr_line(struct rd *rd, const char *name, int idx,
 
 	open_json_object(NULL);
 	print_dev(rd, idx, name);
-	res_print_uint(rd, "mrn", mrn, nla_line[RDMA_NLDEV_ATTR_RES_MRN]);
+	res_print_u32(rd, "mrn", mrn, nla_line[RDMA_NLDEV_ATTR_RES_MRN]);
 
 	if (nla_line[RDMA_NLDEV_ATTR_STAT_HWCOUNTERS]) {
 		ret = res_get_hwcounters(
diff --git a/rdma/stat.c b/rdma/stat.c
index adfcd34a..c7da2922 100644
--- a/rdma/stat.c
+++ b/rdma/stat.c
@@ -210,7 +210,7 @@ int res_get_hwcounters(struct rd *rd, struct nlattr *hwc_table, bool print)
 		v = mnl_attr_get_u64(hw_line[RDMA_NLDEV_ATTR_STAT_HWCOUNTER_ENTRY_VALUE]);
 		if (rd->pretty_output && !rd->json_output)
 			newline_indent(rd);
-		res_print_uint(rd, nm, v, hw_line[RDMA_NLDEV_ATTR_STAT_HWCOUNTER_ENTRY_NAME]);
+		res_print_u64(rd, nm, v, hw_line[RDMA_NLDEV_ATTR_STAT_HWCOUNTER_ENTRY_NAME]);
 	}
 
 	return MNL_CB_OK;
@@ -283,7 +283,7 @@ static int res_counter_line(struct rd *rd, const char *name, int index,
 	print_color_uint(PRINT_ANY, COLOR_NONE, "cntn", "cntn %u ", cntn);
 	if (nla_line[RDMA_NLDEV_ATTR_RES_TYPE])
 		print_qp_type(rd, qp_type);
-	res_print_uint(rd, "pid", pid, nla_line[RDMA_NLDEV_ATTR_RES_PID]);
+	res_print_u64(rd, "pid", pid, nla_line[RDMA_NLDEV_ATTR_RES_PID]);
 	print_comm(rd, comm, nla_line);
 	res_get_hwcounters(rd, hwc_table, true);
 	isfirst = true;
-- 
2.30.2

