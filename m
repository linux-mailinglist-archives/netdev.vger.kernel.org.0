Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4230E48C822
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 17:20:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355167AbiALQUO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 11:20:14 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:5354 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1355064AbiALQTW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 11:19:22 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20CGEQjM015186;
        Wed, 12 Jan 2022 16:19:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=QMZQyE0n1W2ZW+XIn7A0LzylfKOc5TG2wnSwt58nmfs=;
 b=Nm9bgW0WiQ9CTCR4a03JysbarquS3UbTEq1aLiXy6duBUlUpSxphCgY44m+Q4syxBTJ1
 QVezU4hO8a2sSlZcgFqQfanogmZEOmfmNG9jyTMeoxFZdU/J8cV5nDBca6S1g9wWLDxS
 QOI+6pbKwZ8E3rRjQyes+YTKowOH6Ne/lopWi1lfSbgoljB3snSuK99DU8u1GC6do0/S
 I1NAlpDQezK1VN+aLWlDMnbpFeBg4sF+IPn9P3cERfrExX7B/e8upxcp6HzKT9+hgbWA
 p8psKR9GquZB2RqScFcxYzQIdbCsPp7tNS2TZn3LtkUIJ1FOOC6BX6dbGKlUt7kSQIf1 0g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dgjtgf4bu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Jan 2022 16:19:06 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20CFuAVJ018162;
        Wed, 12 Jan 2022 16:19:03 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2106.outbound.protection.outlook.com [104.47.70.106])
        by aserp3020.oracle.com with ESMTP id 3df2e6fut0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Jan 2022 16:19:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jhS59WoZeOqfjFo5tDklSzWz3o4TsGb2DjQGNojVqNQ8wEa5KhfGDu8WjhMBm6Gf5vJiMbd/05wXo6rTnMEJFADBGKEtqFrWWdmsQs3uHIJSPXHHb3+HdXCfpIjw43w3cf64e5dUrACej+OhbSlvTJ0fSogIPE2R50nwwbale+pkXin2LdAYAUMUwLr6oyXwVIOBDTVsOOs6CQZtFZNv4mTq7k1pgnuLnGB1/xtaKLfFG95GKmNUPXxpCGssYGPTjqIP4Ko6j3qUeZMgoira6i8RHreUDRmEQk4rZYZeSTGO56Q3kJgsprjin0bSLOuSBu8ANtpsLFDLJTWddf4mUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QMZQyE0n1W2ZW+XIn7A0LzylfKOc5TG2wnSwt58nmfs=;
 b=feRxDu3YZqhL4wGebnVJ7KS3iE7okyEe+J9sCaLNH4s9ECz1JhZVHSQq6nS1oM+L1fHTGCfF8Uic3yi69v7juLbRWAAMklS8meXnS6OVO2LVPEhaabk0fv9tc/+/ydHcJEtlMse4aeoUGM5dWEFOuDLXZ8qtDnmo3eBeLuu01lyvfdFF1qg9xgHgqSuYhwZUIgO3IkjZIvgjgC4hoMu0S9ebe/NEGOwhxBezyPCFAk12RwH9BEbQw41OAJuQEEM3aMfiS6b4xH/jGNkhOeuqDxOMorGF8J1PpfCg8aBr0szi/WcX9p20ws2jyyT8yBd9uYZAs2B0oVUPCxYLAKLquQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QMZQyE0n1W2ZW+XIn7A0LzylfKOc5TG2wnSwt58nmfs=;
 b=iP2BVMEKkWLpX8dHylTAf7jBwf+ZwwkECqAwWTNPy43aYf/YcTYZj9JqPbFwe94KMpeMFfUUyXBjvgnO3GPzfxIJT4Q4TiWwkTt2jZ+RUlnV5lcld6hA9jLu09qBI5nz9Q6p9jhl2U3pvgzUgiS6F8iTyLW5HWohipUPrC79NxI=
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by MN2PR10MB3103.namprd10.prod.outlook.com (2603:10b6:208:128::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.9; Wed, 12 Jan
 2022 16:19:01 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::31c1:e20b:33a1:ba8c]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::31c1:e20b:33a1:ba8c%5]) with mapi id 15.20.4888.009; Wed, 12 Jan 2022
 16:19:01 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, jolsa@kernel.org,
        sunyucong@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [RFC bpf-next 3/4] selftests/bpf: add tests for u[ret]probe attach by name
Date:   Wed, 12 Jan 2022 16:18:48 +0000
Message-Id: <1642004329-23514-4-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1642004329-23514-1-git-send-email-alan.maguire@oracle.com>
References: <1642004329-23514-1-git-send-email-alan.maguire@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: LO2P123CA0080.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:138::13) To BLAPR10MB5267.namprd10.prod.outlook.com
 (2603:10b6:208:30e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4ca9fb68-3dbc-4f36-f180-08d9d5e73e32
X-MS-TrafficTypeDiagnostic: MN2PR10MB3103:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB310342F92B07538446EA1965EF529@MN2PR10MB3103.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:93;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cmTBGrhwMi4i6yZgF9BzBtR8mo9V6i3NW9FiCq5ef/rrXM2P6Q9zEIdeY5B3WMYWnGwyaWfG8tsDbuN9SLvqeBYsWjZn2Vup47X18P72alovvubFedLEVvEujQvL1xvzKT/oTiIFdFRdg3+hOwyZEUZoRlPStAgxsm1HMBHmCeW0JXwF/3+7tbS4ML0v9HMUzdQLdoaaW8LPmJd80RK4YsXEejFhXp/31X7YYeS5DIxuVKPbfBDoOCdmNTfpthes+jYbvvicOQ+r9TDdVcdV7vy4vNV6An0v7DbJKFRljyQuuXYJwZ6TdVbJA6YXmfxkEN/TSeV6Ddq8HTcdUajDMvFyMJ82X+JfuwjZG659u7NE+W6xnKHrglI16Q7AVtvyxRPbHUVRyJOleBRZp6GDcej5rLtId5BX+8TbomFZ+GBppAGvOpQjau3DLwWBSmZZALEN2CSB8ZjfB7vBs9jKHIFZJxGg+E/fq0VgaJIvqJxRF6vT4uLOdT8MMzw7I1WyMWqwQ9lPSOtAA0IpD8k5ub0XFCWKa4sHsIZWFzY4jcDvJC+2OLGzwlIZHnkh/nsTMIp0Zp0WgboBG4VonnADd5GfeJt7jOYqiX7REtsE3JfHAgnL43XO6gaI0Vcp+jsvT5Io3S6/zGTf7/HqtvY+ocrEtdKIGtg/jCI5Ug+VwYptRK+FthzrmwyLyURUETjJfu5a5M1g64ETkqafqv1cZA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6666004)(2906002)(86362001)(508600001)(6486002)(6512007)(66556008)(66476007)(66946007)(52116002)(5660300002)(7416002)(2616005)(38350700002)(38100700002)(8676002)(44832011)(83380400001)(36756003)(186003)(26005)(6506007)(4326008)(107886003)(316002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KFrwUUQo/MIxoDhKVAxknpHpeWxiN8p4fvSh+yX4GOkrIs4SggKUL0/7mpvK?=
 =?us-ascii?Q?qPzxmvvDvIHxW7xBDpnF6qyy/gJiw5yGuJ5qIq41Xc5lp7Uk57sRomjkrLdE?=
 =?us-ascii?Q?tQBjouJM6oqALkV6yTAFJMDTIvk46ErWmYE4TfJydhFz/7mEc8tAwrO/Sok+?=
 =?us-ascii?Q?d+ISxWgh6J82mT8CsoukbYlN4SYuXx770cy0h6jdBwdw+lD2UOBGGhJFX6Ld?=
 =?us-ascii?Q?LxhdlfGHhDtQUkXRSL49VwvG2TlVDu/QjLqTlv25QU8Ue049Kz5UGQ70Komn?=
 =?us-ascii?Q?uZXkF3+5hXj6+ZX/TsaXZYCFF5SMNXnGtGs366I+ujwN61W9wzJO0dL76zm/?=
 =?us-ascii?Q?779EotyOPtjCAsnD04gZj0a72tvhuJ8t9IMh1TOj4BlBtlIeSrUQ8317bS8m?=
 =?us-ascii?Q?9JyVRydfOZI8SfmNCHWyqWsHYbLrKUiWznzux+dt1y+mkrv20Cw66Hzn92i5?=
 =?us-ascii?Q?SsP2RD2ZvZpMhp4FFerjKa3hqU59MivWBguvpYFECt3Ia0K8YasHDP47uF5K?=
 =?us-ascii?Q?tC8Lo1D3drw1KrvRbYZefmG87X4olJzkKvRInTbm1IlYwVq+MFDPgqeXq2+A?=
 =?us-ascii?Q?Rp9uMPJaWd9OSOYxh9gPwxPG/RyAh1l/ncbFiA8DeAVDdKJ2WAzgvhY6ZKIn?=
 =?us-ascii?Q?gG7BpRZa1vLc4aBJsSRo1nuiHix5axGPBsEifOdug9WGP2pqCpGWhqtWV8PG?=
 =?us-ascii?Q?OA9QRI6m7pZB3BKFIXjGfvf0CXTQ3xRL5w1r82bifaDHQK/6RO5hPXg+gJh2?=
 =?us-ascii?Q?cB5ug8msmZCXZ9DFEFMAmIxhdeye+HNziRQ5zN1ckgp6PrmwJUnlUv9yFcWY?=
 =?us-ascii?Q?aZQWtgMNcud1V4zVK5XFXTqTaWuqLBtqf6nvYHpndcx0RF5zr6s7yG1hFMbv?=
 =?us-ascii?Q?tNUCj7E7zmWp87hotcf2cNOZ8t4AIY6KiS4Mppm0imEz3kA0L44vTq6LluHE?=
 =?us-ascii?Q?lH+KhApJtHSebO/GoBSVVvhdOlyfuL6/00515CR5Dd4B7qwKuaQNy8wkgLgz?=
 =?us-ascii?Q?z8xvBYrchTsHtciwS6qeulEEMYrTvMX/adpGpPD/WcsahfCJyDrs89KUixZ5?=
 =?us-ascii?Q?0zv1+nhSNuS6DzXj9HvCTHUlLtk9+JFQRAgZoDYt6Qq1Z5NIlxb9Oam0uS7v?=
 =?us-ascii?Q?tgaGHT/cNrpJRzByOzJA1AX84tShoJO8+CwJORp3dQrI6gDBfevQf8DXDqZ3?=
 =?us-ascii?Q?8jyBvvWE7YU0uuzBsEEi+87chqCjeFRJMwlOJXosl8q6UHsout23+xkoUSN2?=
 =?us-ascii?Q?8JKobjqePQ9zHSHX3EdnMHykeBTbwe8N1Le6hRAV6eH8Qzr+bM5diZDRD82c?=
 =?us-ascii?Q?nygHpFlBlB7+L1ttvzfTuIAk7ZAXm1wYoKoLEnD5RszEZ16hymKrdNz/C5wS?=
 =?us-ascii?Q?SV4yfMKDeWlIa4mQBQbuftP9tPs/hNEpuVNgRbfC3EAJmWWLYf03wiIS3+tz?=
 =?us-ascii?Q?mhNicA/9LO7SSnPiVrYwizdXo/YoNzme3CSOu1e1FAzTPPDSMaau8d1pBvYz?=
 =?us-ascii?Q?MtOUmpD5RGjkRoGQJvPtlLgAamLKmjFPh8NnNFua9CD1dDUHuVa0xB5Kv8Gr?=
 =?us-ascii?Q?Oz+6woYVshliVbOa69us/Adv/3wVc6DToCzq9DcuPTmq0lGOazWmRzkfIyEG?=
 =?us-ascii?Q?JItvcqj7I9cE112T/2zGm4E=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ca9fb68-3dbc-4f36-f180-08d9d5e73e32
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2022 16:19:01.2010
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G5cCEri1qG/h+SyzfM++k6vDXJs3VnecKy+TUeQJzqYSKMRmfC0pOTfXu8x0WPptAVVaXe8j+A3sirbRgo/gAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3103
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10225 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201120102
X-Proofpoint-GUID: 2Y-4iVZeqFwsRTVwtjIGeso6YaPqtsGA
X-Proofpoint-ORIG-GUID: 2Y-4iVZeqFwsRTVwtjIGeso6YaPqtsGA
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

add tests that verify attaching by name for a local and library
function succeed for uprobe and uretprobe using new "func_name"
option for bpf_program__attach_uprobe_opts().

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 .../selftests/bpf/prog_tests/attach_probe.c        | 41 +++++++++++++++++++++-
 .../selftests/bpf/progs/test_attach_probe.c        | 16 +++++++++
 2 files changed, 56 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/attach_probe.c b/tools/testing/selftests/bpf/prog_tests/attach_probe.c
index d0bd51e..521d7bd 100644
--- a/tools/testing/selftests/bpf/prog_tests/attach_probe.c
+++ b/tools/testing/selftests/bpf/prog_tests/attach_probe.c
@@ -10,12 +10,18 @@ static void method(void) {
 	return ;
 }
 
+/* attach point for byname uprobe */
+static void method2(void) {
+	return;
+}
+
 void test_attach_probe(void)
 {
 	DECLARE_LIBBPF_OPTS(bpf_uprobe_opts, uprobe_opts);
 	int duration = 0;
 	struct bpf_link *kprobe_link, *kretprobe_link;
 	struct bpf_link *uprobe_link, *uretprobe_link;
+	struct bpf_link *uprobe_byname_link, *uretprobe_byname_link;
 	struct test_attach_probe* skel;
 	size_t uprobe_offset;
 	ssize_t base_addr, ref_ctr_offset;
@@ -92,7 +98,30 @@ void test_attach_probe(void)
 		goto cleanup;
 	skel->links.handle_uretprobe = uretprobe_link;
 
-	/* trigger & validate kprobe && kretprobe */
+	uprobe_opts.func_name = "method2";
+	uprobe_opts.retprobe = false;
+	uprobe_opts.ref_ctr_offset = 0;
+	uprobe_byname_link = bpf_program__attach_uprobe_opts(skel->progs.handle_uprobe_byname,
+							     0 /* this pid */,
+							     "/proc/self/exe",
+							     0, &uprobe_opts);
+	if (!ASSERT_OK_PTR(uprobe_byname_link, "attach_uprobe_byname"))
+		goto cleanup;
+	skel->links.handle_uprobe_byname = uprobe_byname_link;
+
+	/* test attach by name for a library function */
+	uprobe_opts.func_name = "usleep";
+	uprobe_opts.retprobe = true;
+	uprobe_opts.ref_ctr_offset = 0;
+	uretprobe_byname_link = bpf_program__attach_uprobe_opts(skel->progs.handle_uretprobe_byname,
+								0 /* this pid */,
+								"/proc/self/exe",
+								0, &uprobe_opts);
+	if (!ASSERT_OK_PTR(uretprobe_byname_link, "attach_uretprobe_byname"))
+		goto cleanup;
+	skel->links.handle_uretprobe_byname = uretprobe_byname_link;
+
+	/* trigger & validate kprobe && kretprobe && uretprobe by name */
 	usleep(1);
 
 	if (CHECK(skel->bss->kprobe_res != 1, "check_kprobe_res",
@@ -105,6 +134,9 @@ void test_attach_probe(void)
 	/* trigger & validate uprobe & uretprobe */
 	method();
 
+	/* trigger & validate uprobe attached by name */
+	method2();
+
 	if (CHECK(skel->bss->uprobe_res != 3, "check_uprobe_res",
 		  "wrong uprobe res: %d\n", skel->bss->uprobe_res))
 		goto cleanup;
@@ -112,6 +144,13 @@ void test_attach_probe(void)
 		  "wrong uretprobe res: %d\n", skel->bss->uretprobe_res))
 		goto cleanup;
 
+	if (CHECK(skel->bss->uprobe_byname_res != 5, "check_uprobe_byname_res",
+		  "wrong uprobe byname res: %d\n", skel->bss->uprobe_byname_res))
+		goto cleanup;
+	if (CHECK(skel->bss->uretprobe_byname_res != 6, "check_uretprobe_byname_res",
+		  "wrong uretprobe byname res: %d\n", skel->bss->uretprobe_byname_res))
+		goto cleanup;
+
 cleanup:
 	test_attach_probe__destroy(skel);
 	ASSERT_EQ(uprobe_ref_ctr, 0, "uprobe_ref_ctr_cleanup");
diff --git a/tools/testing/selftests/bpf/progs/test_attach_probe.c b/tools/testing/selftests/bpf/progs/test_attach_probe.c
index 8056a4c..efa56bd 100644
--- a/tools/testing/selftests/bpf/progs/test_attach_probe.c
+++ b/tools/testing/selftests/bpf/progs/test_attach_probe.c
@@ -10,6 +10,8 @@
 int kretprobe_res = 0;
 int uprobe_res = 0;
 int uretprobe_res = 0;
+int uprobe_byname_res = 0;
+int uretprobe_byname_res = 0;
 
 SEC("kprobe/sys_nanosleep")
 int handle_kprobe(struct pt_regs *ctx)
@@ -39,4 +41,18 @@ int handle_uretprobe(struct pt_regs *ctx)
 	return 0;
 }
 
+SEC("uprobe/trigger_func_byname")
+int handle_uprobe_byname(struct pt_regs *ctx)
+{
+	uprobe_byname_res = 5;
+	return 0;
+}
+
+SEC("uretprobe/trigger_func_byname")
+int handle_uretprobe_byname(struct pt_regs *ctx)
+{
+	uretprobe_byname_res = 6;
+	return 0;
+}
+
 char _license[] SEC("license") = "GPL";
-- 
1.8.3.1

