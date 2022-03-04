Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AE914CD472
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 13:47:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbiCDMsB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 07:48:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234070AbiCDMrx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 07:47:53 -0500
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01olkn2041.outbound.protection.outlook.com [40.92.98.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AAA31B3A7E
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 04:47:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BvWw84JBDUZDnK2iWXjIk+JrWaEuQZaaeXtJbANWpkPXA5BAVDJDoVmmrj1MPv8wBnyJs1cfbeF9am6b0nzjsSCfvUgiAP8R6C7pOxulDrSvogMMOF9ClzwKZNURgPJ73Ya4XoK5O/2+mwZxxzYjOGkjV7r0q3UZo7McZq3mn5Q+EGakE0tGOjuaa6HdqFiF8JXjF2ip5R2l63OGCQiDNpdKG6UPnI2SHshmq+DaAWs99M3CnvJItmuBTDW4eUGqZjRZ3GsY4lpTqyi6sYGaTQMKonz9WlLx+C/NEtX53eZ4fFHIzA+H9sUyiqxzFKrwQKGQsGLkCouHrFPHny8u3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d5nA6fsgzzV9zNg7FS6qMZPh42yAYxE2crc4hd/2nuY=;
 b=isjI83YvDq9Y3P1OYGBXBLnaFGwPe20z0qWowto+7aSXrb5OonM7y5BFvhsTU5q5Dsb0xFqzLqfiqbAtQy2zJlnVVe92E9IJOrf5n1izvZdWj5kSC8rDWK9atG2/AMm0+gzovaw/C0F8vsmLr0U/1Pyen/DkjteQdt8/eV8REXttQLtvlpuEV4nRjGxezzFCmvA+7cZPn3hcJY8cogef+oLqln08lQ5ZwA8gEJdTxEFQH+O2Pb8Hf/HDucKHvxPZhBHmLitE0t5fYAOFvs8fHxz1DXQVjeuWECEjYX1IJLUs8cz+9KDsTFQV8KpoRKmtib/a5R1RTLg28rumf1y3DQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d5nA6fsgzzV9zNg7FS6qMZPh42yAYxE2crc4hd/2nuY=;
 b=n/1yJsS1FBwdmYyA24zGgYSzN8fFeM8gaTghgEzjMg1tYvKbJ0ha2nP6IuXKMztDSBT/q06C3/OWrYzQA6KV5RpqK8Yahd332HtGH6W2ACf7wopaZ2J1u6ZbS2TyY0fAyDGR6yFzJH1rO3eVg7C/i7dwuhpHz87h6PDf1YtAstCQYPXA1Uwg6qxJalgdjZO9JzwpR5XxmtkNOEEnqrp1+V6VSm9nTKOt3/2aX/CgsKhdiGRgVPgnGUhhhwM02DXhzZaUMQt5FTnRUydcBnvtevAFMJMKkadfBjFRlWlfoNEukgELE8O5sAQuTj4g1m7LXD+CtlNVPY4jRB2q0/+QyA==
Received: from OSAPR01MB7567.jpnprd01.prod.outlook.com (2603:1096:604:147::9)
 by TY2PR01MB3435.jpnprd01.prod.outlook.com (2603:1096:404:d6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.16; Fri, 4 Mar
 2022 12:47:02 +0000
Received: from OSAPR01MB7567.jpnprd01.prod.outlook.com
 ([fe80::ed12:bc41:7a3b:ea5d]) by OSAPR01MB7567.jpnprd01.prod.outlook.com
 ([fe80::ed12:bc41:7a3b:ea5d%6]) with mapi id 15.20.5038.016; Fri, 4 Mar 2022
 12:47:02 +0000
From:   Shangyan Zhou <sy.zhou@hotmail.com>
To:     leon@kernel.org
Cc:     netdev@vger.kernel.org, Shangyan Zhou <sy.zhou@hotmail.com>
Subject: [PATCH v3] rdma: Fix res_print_uint() and add res_print_u64()
Date:   Fri,  4 Mar 2022 20:46:37 +0800
Message-ID: <OSAPR01MB7567AF3E28F7D2D72FFA876BE3059@OSAPR01MB7567.jpnprd01.prod.outlook.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <OSAPR01MB75677A8532242F986A967C9DE3059@OSAPR01MB7567.jpnprd01.prod.outlook.com>
References: <OSAPR01MB75677A8532242F986A967C9DE3059@OSAPR01MB7567.jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN:  [3aib1yOGM18D9Ow/XpxWxY73ftkZioDz]
X-ClientProxiedBy: HK0PR03CA0113.apcprd03.prod.outlook.com
 (2603:1096:203:b0::29) To OSAPR01MB7567.jpnprd01.prod.outlook.com
 (2603:1096:604:147::9)
X-Microsoft-Original-Message-ID: <20220304124637.1304-1-sy.zhou@hotmail.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 70361a33-3049-4674-8298-08d9fddd14b8
X-MS-Exchange-SLBlob-MailProps: Zv/SX2iM+5W1hGIRq8GIYM8L/wQyb+0HFoZ4lLC+VHKYg5kMJhX+mI0ihIETgzHern5ul1JEOlAPZVf9+VDq+p2ZQ44CRg1roGQis4WyUNW/YLuUvsor7HSjvk+ZBOwPmQzDIB+hZZ4JoYdAlYtgGGtONkOmFaQMMk88CGmyZm8eAE+ppsTmVHg+/jHtERCcAoqSSYs7wBDcIPWLKg8Q0PlHjQUmrmfGrC1kESTpAn+pjKqAzMzjjiO0J+q0rAn2jccHbYNOm987rRSoqDQeTl7rIPJK3w/rAn708d45eN9zXKHI+1O7OFKmeTtf6KQXzLuhe1YYi0dXI8O+8PFlXr1587IR8X04R9a6ytyTZyd/W8VM8uFpiFokTR3G4O90z3dpjVH0T0+bUBplkak76LVzHnc5mATSi6dSj/flucckpyQyz/ivQz1StgjzTcQD41T207RW/oLMH1hOTLXkfCVQ92YRSjkTZh1PUnZbLATdSEWFR9RB+nnJlOgUgq+244xFGL/y/oiB7rd9IYm+yunbHY8OlncHa98l5ncVTB+ZHL35+aX0spz+4qox0uygqBSrCzVqFNjJY0u63Lzjv6Xj2onaPOo49y2Jm9UAvVunEUvHgo336gqiEFYfU617VwEmASTv1UkbtJCVlNF6ukn2P497/soGs8z8eipg13uTkx+P8m1IPtNZicJhHMxA+Z67E5wkKOI=
X-MS-TrafficTypeDiagnostic: TY2PR01MB3435:EE_
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9WZXaoq/V7KfRi3OrzebYTS4XrY5U4tzNjjeFZMq5EWjXyWDX37Jywa2HDNYIJiCwrsIhjhNOUrVfricasAWCmy+1frjw2ILqzaHISXHmmhfRHL5qL4px3W6cVPVr4gwaJrjq+Bis/Ue3n3vj6btw6WxTsWCqx/7FpElgHVRMDkpKGlVx4lKVDYtrTJtEcPt1oEfL6hcugEhj4MVxdUohLKUExH8ka6NQyBuS6QXjJ8tVZOzIEzEGJpic5qCJd3hzw7hHyzxbJsIr1KSZweqN62JaAWR8WOYrG3Q0oeneJKXHIs+eTEpTeSllZjR1wA8gxDg/hsiw8plNJs+8cgyTXR7lLpZeFuROIHt0bM5RGCACEhgyGNXEq3FfQnY+CclPSo90GdcypO0Fgky30jX469+lc0QatZT384S2BKoFPxUEAmoO+yJLEoLVl9lpZ9ahrDfo6QzTgeCO+aworeli0I/ref8RG2cG609qrheZ15V4VygnyNMTT6aUR6Ex1qs+gJcVGmjeUNDudWRGA8O7BLkaCo3Pofl1JchfRltuvt1Fih7r4+wBZai3XGVmdXlpUNVl1nk30sbUmQqvu4veQ==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?B4Zl4cBYya1fJdCy4Q3NnMkLGToLTqiypAbNcYis7A4wPKKAcOTeqpTZwiai?=
 =?us-ascii?Q?Kalh9padOuqoVPXHO7IdnmePCqVW4IF4KzSxJBjm+Am25rIHe1htQtuUKXnz?=
 =?us-ascii?Q?X5Rwyk0yEEgK2DzM34w/DluQlmzSfoZUI7FPxN0pldDg4Zx6+HmpH1Vxxa7c?=
 =?us-ascii?Q?cc1aRgtnuMTBcgvKirLYNiu48+DOx+AK0iTCteSw6FsMuG8vaPrYuHZtjvi2?=
 =?us-ascii?Q?u79KvVSiD9MRzcX3TjpN1m54Fs2wDCLay/HR+SHexDElRHGne+fGg3KoW53c?=
 =?us-ascii?Q?GnXEHk1aNXtMN6U+qXwzalZbS1FphlISxXgzHta9oHlxtz4mEvjXQcm+6Rdf?=
 =?us-ascii?Q?R5dMMaFniziWk4QPzBQgsb9wJZIadycOmuNaOdAoIZnhb4UoY0JBG7x1lt/H?=
 =?us-ascii?Q?5adIf1KNPHVkmT0T14xxZqBAEpGPCJLlUcL2KG5u0EdUdJID0Y+eQL85yJHV?=
 =?us-ascii?Q?ToBELWnbot9uocy/DvBRBUGcXdfd8XJQZ90Siw2qG3xOlggC0HmdgGUuAcA8?=
 =?us-ascii?Q?uR+2Uq6ug2W6D5w1TsCWAJ0NUfDdxRKZUt49dFyC8Th0EO8wbLHwhIitwo4R?=
 =?us-ascii?Q?HAk1RNWu6ybbZ+tthAz4T4T1uW6jugLJQstD8gEl8PEJEqku2AdBOhqq0ujw?=
 =?us-ascii?Q?rYkRIDOFWC/76dBqQYDSB+pMvA5RRhWCvouMFxQBnNg0si2i02EwEVYlSlcu?=
 =?us-ascii?Q?nfZkz103b4NPXG+Nv2Lyb1rmDEyp6KXvcS+pIPr4qtGSvbbTxTVu4Bq1DtRK?=
 =?us-ascii?Q?VaLilUxrgaaXFZTLCkHcSbbibtSvo83lC3FuLXFKx6Elwotj5kGQ7SgErugk?=
 =?us-ascii?Q?miXNLm7FWn4mM6PiCSORUHLNXAr7VDquCxOiYmd22+fRB+VeCxLrsY3gZ9X1?=
 =?us-ascii?Q?/tvmjLhWt0OhvXTkfOvuHsgxLSr/zEQpcAcgA54gcTAC6eWCX+ioprNfZglO?=
 =?us-ascii?Q?CAxBk2IphnI8Q9BQAnmmcA=3D=3D?=
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-9cf38.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 70361a33-3049-4674-8298-08d9fddd14b8
X-MS-Exchange-CrossTenant-AuthSource: OSAPR01MB7567.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2022 12:47:02.9215
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY2PR01MB3435
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
 rdma/res-cq.c |  2 +-
 rdma/res-mr.c |  2 +-
 rdma/res-pd.c |  2 +-
 rdma/res.c    | 15 ++++++++++++---
 rdma/res.h    |  4 +++-
 rdma/stat.c   |  4 ++--
 6 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/rdma/res-cq.c b/rdma/res-cq.c
index 9e7c4f51..475179c8 100644
--- a/rdma/res-cq.c
+++ b/rdma/res-cq.c
@@ -112,7 +112,7 @@ static int res_cq_line(struct rd *rd, const char *name, int idx,
 	print_dev(rd, idx, name);
 	res_print_uint(rd, "cqn", cqn, nla_line[RDMA_NLDEV_ATTR_RES_CQN]);
 	res_print_uint(rd, "cqe", cqe, nla_line[RDMA_NLDEV_ATTR_RES_CQE]);
-	res_print_uint(rd, "users", users,
+	res_print_u64(rd, "users", users,
 		       nla_line[RDMA_NLDEV_ATTR_RES_USECNT]);
 	print_poll_ctx(rd, poll_ctx, nla_line[RDMA_NLDEV_ATTR_RES_POLL_CTX]);
 	print_cq_dim_setting(rd, nla_line[RDMA_NLDEV_ATTR_DEV_DIM]);
diff --git a/rdma/res-mr.c b/rdma/res-mr.c
index 1bf73f3a..a5b1ec5d 100644
--- a/rdma/res-mr.c
+++ b/rdma/res-mr.c
@@ -77,7 +77,7 @@ static int res_mr_line(struct rd *rd, const char *name, int idx,
 	print_key(rd, "rkey", rkey, nla_line[RDMA_NLDEV_ATTR_RES_RKEY]);
 	print_key(rd, "lkey", lkey, nla_line[RDMA_NLDEV_ATTR_RES_LKEY]);
 	print_key(rd, "iova", iova, nla_line[RDMA_NLDEV_ATTR_RES_IOVA]);
-	res_print_uint(rd, "mrlen", mrlen, nla_line[RDMA_NLDEV_ATTR_RES_MRLEN]);
+	res_print_u64(rd, "mrlen", mrlen, nla_line[RDMA_NLDEV_ATTR_RES_MRLEN]);
 	res_print_uint(rd, "pdn", pdn, nla_line[RDMA_NLDEV_ATTR_RES_PDN]);
 	res_print_uint(rd, "pid", pid, nla_line[RDMA_NLDEV_ATTR_RES_PID]);
 	print_comm(rd, comm, nla_line);
diff --git a/rdma/res-pd.c b/rdma/res-pd.c
index df538010..6fec787c 100644
--- a/rdma/res-pd.c
+++ b/rdma/res-pd.c
@@ -65,7 +65,7 @@ static int res_pd_line(struct rd *rd, const char *name, int idx,
 	res_print_uint(rd, "pdn", pdn, nla_line[RDMA_NLDEV_ATTR_RES_PDN]);
 	print_key(rd, "local_dma_lkey", local_dma_lkey,
 		  nla_line[RDMA_NLDEV_ATTR_RES_LOCAL_DMA_LKEY]);
-	res_print_uint(rd, "users", users,
+	res_print_u64(rd, "users", users,
 		       nla_line[RDMA_NLDEV_ATTR_RES_USECNT]);
 	print_key(rd, "unsafe_global_rkey", unsafe_global_rkey,
 		  nla_line[RDMA_NLDEV_ATTR_RES_UNSAFE_GLOBAL_RKEY]);
diff --git a/rdma/res.c b/rdma/res.c
index 21fef9bd..62599095 100644
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
+void res_print_uint(struct rd *rd, const char *name, uint32_t val,
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
index 58fa6ad1..90c02513 100644
--- a/rdma/res.h
+++ b/rdma/res.h
@@ -188,7 +188,9 @@ void print_link(struct rd *rd, uint32_t idx, const char *name, uint32_t port,
 		struct nlattr **nla_line);
 void print_key(struct rd *rd, const char *name, uint64_t val,
 	       struct nlattr *nlattr);
-void res_print_uint(struct rd *rd, const char *name, uint64_t val,
+void res_print_uint(struct rd *rd, const char *name, uint32_t val,
+		    struct nlattr *nlattr);
+void res_print_u64(struct rd *rd, const char *name, uint64_t val,
 		    struct nlattr *nlattr);
 void print_comm(struct rd *rd, const char *str, struct nlattr **nla_line);
 const char *qp_types_to_str(uint8_t idx);
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

