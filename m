Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D514494D4B
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 12:43:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231969AbiATLnJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 06:43:09 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:46764 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231917AbiATLnG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 06:43:06 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20K95NJP010655;
        Thu, 20 Jan 2022 11:42:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=8KpIfaUV1V83wTyXH6nruUoLhygLaTvbNRKodASm1Fs=;
 b=KmFSRHmFECktxshVCMLpkB5yU+tqwunJhQsYFhLEDzpdc5cG1Wvod8j8vX4V+7bgpH1r
 +/LZRnGZS3jxHqWflADw4YB8TCqD/i68VxbzZ5t/5k+KJKeapF1lAhuhJppix4pXoKVf
 1rcNRDTbpG21z5kPuB1jrbZQ4GD05oPuDttmspKAwOP+u9d6KalGiQ36w7UF10+sZAG6
 tyEiBQxCJdon5uatwgbHKHNwOfvLOOT6077e5iTLRdEbbMi3j4fg6r1sfaK/sV2RJpbJ
 h0hJwOqFbe5KHCmMbpvW6YjBj2dUCrhpntl8XuntYs6dHLGrsKSQu1ndkTYBQAM1DYaV Bg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dnc5302fm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Jan 2022 11:42:51 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20KBaB34151224;
        Thu, 20 Jan 2022 11:42:49 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by userp3020.oracle.com with ESMTP id 3dkqqs9385-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Jan 2022 11:42:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tsdc9uksMLx2l/tY1kWIspRxkT4e/Y+IUp8mkRm0KdQJCMmo4vsBFMP5FO2Zhd/KEBCLufhrA7BInq/wgZu1ZxL+fRQ9najoiMgIbSsu1e4k16gbckUCuXBQNGVtPE/QvNuGGimtmv3LRnZcHggaGmQYI4/uwlmhb85aByfiCRo1+SAIZUIawBT+7NAogUvQSlV4uG42uDjuFNKAEjdw4lTYkSeTlHrd7CaKOUjFlbneoE5GVz4c4iG4lKXkhuRUDVdsn5Bgr0DYyzokhODQqfJj99AKOquqAUyUX1+H9Av3vheR9d3PEnoB82wrg+JIefXgVw17yQyQu2IgMVjhdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8KpIfaUV1V83wTyXH6nruUoLhygLaTvbNRKodASm1Fs=;
 b=Yk2sExb+zWzXMPZ63fRREuS4qaBJgQKcYHf7RHPJhiAbu3ObetKrp4xKB3uIM17lQg6A0wo+1YlYC6kK5SBh8Q4AP35x2AlkSGkIVszrEkdw+e/ywnXeJPdaPKq2TM2nsgsjRcN4CR3HfnjD0UcUol0X8nTXIaqzeZAyzuY/21NbdOIgfWmx/BJq5wz01gJydY4//Pam/2oD4luMXBjkyQjsmuQSLsac0dxQQTGB/2WXwTa7aN+xWn0GDVsPTOLAr0cYjARhY/a55xxUOgKlGCy9zKWncW0WrnqkpcYJL04JEo3Jd7wS5SDnBScJNvoyF+vN4sH+7X1WmzylVQikgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8KpIfaUV1V83wTyXH6nruUoLhygLaTvbNRKodASm1Fs=;
 b=r8DE+8wyG+kE2Xxgd4MDGNV/IfvO9Hqt0wEO+ZfrkIVFo1B5cfm8iuP2aJYzc157fbfWZFMyYW7GQhOqe5y3MFpinOUMwYaI7STSOHUl7wmNVLhWlpMUiVp5tW7f5J/KuZ6mlqQifNAD/j/XnEsajZmnKTu09aBXrz0Jd6DPVXw=
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by DM6PR10MB2923.namprd10.prod.outlook.com (2603:10b6:5:70::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.7; Thu, 20 Jan
 2022 11:42:45 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::49df:513e:bdbb:33a6]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::49df:513e:bdbb:33a6%4]) with mapi id 15.20.4909.010; Thu, 20 Jan 2022
 11:42:45 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, jolsa@kernel.org,
        sunyucong@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [RFC bpf-next 3/3] selftests/bpf: add tests for u[ret]probe attach by name
Date:   Thu, 20 Jan 2022 11:42:30 +0000
Message-Id: <1642678950-19584-4-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1642678950-19584-1-git-send-email-alan.maguire@oracle.com>
References: <1642678950-19584-1-git-send-email-alan.maguire@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0358.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18d::21) To BLAPR10MB5267.namprd10.prod.outlook.com
 (2603:10b6:208:30e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f5e53557-660e-45b0-0163-08d9dc09f753
X-MS-TrafficTypeDiagnostic: DM6PR10MB2923:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB29239A9E4209B063B9D825FAEF5A9@DM6PR10MB2923.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:234;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j5qmzOafIqsZIWNT2xlCz5xj0XLDA7G+VFsoz4qfJWuMiVQyZvgx1wXrlKtdyyjKgWHCsmKBpnhR/FIq9HyZYL51hqT0aoYOyzFskUaWjMiDdRuFsU/l8IuUpcu6RrPMNefhmkeH+vUA+6o84ksGKFX3Gg1lkkT7yBzlhGOY25IGdpplyuYfFNFPLgsPLPjzKbcKpg2bzdYAd9Gq60ClwKAWF4DIveTB7kCIwLfjqSVjfCm0dtGYmZUcXTazTaPFxs164p82mXH2iK3SgWKKTMyiVRktrtMSp9lcIaa+uW/bSn3OtOIUN0J/s0DCqGplXYAXIRHh9TCvDdneVrd+gmathbspHStR/HxKNKK9gIkW7FBC1rxRHXvgbqpiQr+kzmZEAxQ6UbaaM49BUzh8C31uzlFiFx17Gwd4ckCQQ79Qwhx/RYhK2ZGITzU96B+/bpD5vlyFPi27oCsY62aqGr4O2KAhuNVueqE3o37IL1s/+GnNt1c+MWw170Cd7eRW3/zZ05j1/Kou8jU3f13wLYfX5TsKQT4/zaXLuMGbySeauKpiLaoOJArBv+dbLdfjlL5FfCInHg+bP4pNPtw6xeSprvSVutfjRzhHnhndG4MlGBDYGOiOTZ+lyQasMRWFNtpXiXo89DqzL7kOLOpjC/S0ymyPezsnqBqmriF1C3lRIfGo8pu/TFmjl9/3zm/LaBF6WZe9QYWjcVP/BrXJlQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(316002)(2616005)(8936002)(186003)(86362001)(6666004)(6506007)(2906002)(44832011)(8676002)(26005)(107886003)(508600001)(36756003)(83380400001)(66476007)(66556008)(66946007)(52116002)(38350700002)(38100700002)(4326008)(6486002)(6512007)(5660300002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4KczZzymyz8bhsQhWou2MXWSgVibLNJB9mGBskbv4B07dchfJ/ZqZswTpnhm?=
 =?us-ascii?Q?WHovZ6/DmqiAA2H4jR5gE1U3SyV8nHXaNx9PgagL891g4U0PftkZUSVbL10j?=
 =?us-ascii?Q?qbKRCwHuqGFx0/ufvZTzIsZQG66sliMoIedUMFkXqQsmfnR1SAnKTUDpiUOs?=
 =?us-ascii?Q?QK5Voi2bmCB55XjfyIesjMpTuSjF/2PZxieVKeBzCzt9VxIE54nvgU8bC6Db?=
 =?us-ascii?Q?6WYA5vd12IdSWDNoP7nZqrqwW1EqjRNIGtPhCF6YTt0mfATwyaMKZqQzj3pu?=
 =?us-ascii?Q?3CMkjt6s4UMiWLkdABO/Enptac3Alj1dhvn1RzxGTrq2r+MyKmGRYjEAr3Rv?=
 =?us-ascii?Q?NLliiu9L3RTef4e0Ch/LSaFe5CLuVsD9uhz2d5KjNibBZduUvHJs3kl2YSyP?=
 =?us-ascii?Q?12akpJlWUMjzwCDZqiujSOCiireVU4RB3/GDWCWu2ZbZwC/uHffEL6bmJ3cn?=
 =?us-ascii?Q?8IL7xRixGC3xiMUF8DUePtX1smzGZP7+1EOcUUIzhmGZnvyllgVT+a6t6u6v?=
 =?us-ascii?Q?s2b5VZD2ScxvYrnoAUG7wxJ5qywymncsJe3k36YxMPljMa4QtKTvb7iuDZGg?=
 =?us-ascii?Q?Flk9ZJhQHOMUbbRNirxdMY6mnemVbgpnrCW3RClyOntOSAj4DUvOh3SM/Icp?=
 =?us-ascii?Q?qTWwYAwE00Z4Dx/382eG5pD8OwUJNZ4mIpW7nIBZrz2LV2RxWYN4ToCucDID?=
 =?us-ascii?Q?AHcasRi94JBO1uiIsrIwXqWrVaiO7Cl4aY0hddUl1XXPiqnsn4XQY1gnNtqQ?=
 =?us-ascii?Q?M+6vl0zsAv2b7PhJCHcbbQQRzIsN3EDmjHrQt1hGjyXsH7E5AIeHzt1zzh6V?=
 =?us-ascii?Q?glpudJ2wO5bso2fGHCoU7H3qo3gUCZFaShmpWFiBr5G4kzjgyEK6vUyZexsV?=
 =?us-ascii?Q?b9L8whkpzkimc/6h4QkuC9twJ5pFjJozdmrTjOYz9FjXPiO7MM3UZs7GIv8l?=
 =?us-ascii?Q?Gwj9rYZr77iOxpRo07tQO6vpbnmOHbZ/oPCiIbszT37qMEBU8fwPzucnQoSy?=
 =?us-ascii?Q?SAgVvF4qOBUjILReqJWLY9gf9C8jOhhlchdvLvnoHFKFpqNh1fUywitHOu80?=
 =?us-ascii?Q?vrtXMHqmeUcpwuFP5GLmmlqhnomnwSbKj5w5Q4Tr6Aq6VASAxa+h3GZgOZ2f?=
 =?us-ascii?Q?thpuVZY7/glWzqJkuLZv3sILu61HKTAKn9xEwPKMczTsvT3ddrWnNZBKcVaS?=
 =?us-ascii?Q?jMVzYXnoDV5MrY3Fdv6V4O2fiBHWew2H//U+KkWmskyfnTNPHr9/7tCikSGF?=
 =?us-ascii?Q?7TV4xn9V1+cYi8JeHItGENlx6TSXqb9i2zpBQ26TCuzy/SB7hVG64f/kod43?=
 =?us-ascii?Q?CZsp1GqovRz0QDpShjIRBZPnjtSNyEp+i8EO0Llvtn5OasTRpI8X+YFEsWLO?=
 =?us-ascii?Q?woGpMheA0eDzBQLNxeBKYEgE7xDVmb4JxNxY0bPxYmjKJTYJ2P3gP4Ir9jSQ?=
 =?us-ascii?Q?NnCGugkJSsiMk5olz+rFtKw2ksXcNiH7mbgrMRP+xURfbLPhKb1GA9H0aA7B?=
 =?us-ascii?Q?Ewey7v9HnM3uL/rIjXX7hWlq1F2Q/RsZ1VcwQ+hLEmSmh05T0QsPpUPERiaa?=
 =?us-ascii?Q?2QGkFJdcOQEc6DlRqvN23XD4OAgTmkEZNWEiX/8EAm38y0ZrPt8SZDdB+EH4?=
 =?us-ascii?Q?1wj3b9MPz3eLjdgshlvgmSk=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5e53557-660e-45b0-0163-08d9dc09f753
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2022 11:42:41.3114
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M70sImw3SeaAQroovMcOP7H2JYxfuuXnQ7831AL0OwOlKWWlIvhYV/H8TneFzlpWojFRakIj2OF+MQtKkJSTlw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2923
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10232 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201200059
X-Proofpoint-GUID: edEbTGD_MfCsFd-Yw1AWBKa8dE3mYJqb
X-Proofpoint-ORIG-GUID: edEbTGD_MfCsFd-Yw1AWBKa8dE3mYJqb
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

add tests that verify attaching by name for local functions in
a program and library functions in a shared object succeed for
uprobe and uretprobes using new "func_name" option for
bpf_program__attach_uprobe_opts().  Also verify auto-attach
works where uprobe, path to binary and function name are
specified.

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 .../selftests/bpf/prog_tests/attach_probe.c        | 114 ++++++++++++++++++---
 .../selftests/bpf/progs/test_attach_probe.c        |  33 ++++++
 2 files changed, 130 insertions(+), 17 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/attach_probe.c b/tools/testing/selftests/bpf/prog_tests/attach_probe.c
index d0bd51e..1bfb09e 100644
--- a/tools/testing/selftests/bpf/prog_tests/attach_probe.c
+++ b/tools/testing/selftests/bpf/prog_tests/attach_probe.c
@@ -10,16 +10,24 @@ static void method(void) {
 	return ;
 }
 
+/* attach point for byname uprobe */
+static void method2(void)
+{
+}
+
 void test_attach_probe(void)
 {
 	DECLARE_LIBBPF_OPTS(bpf_uprobe_opts, uprobe_opts);
 	int duration = 0;
 	struct bpf_link *kprobe_link, *kretprobe_link;
-	struct bpf_link *uprobe_link, *uretprobe_link;
+	struct bpf_link *uprobe_link[3], *uretprobe_link[3];
 	struct test_attach_probe* skel;
 	size_t uprobe_offset;
 	ssize_t base_addr, ref_ctr_offset;
+	char libc_path[256];
 	bool legacy;
+	char *mem;
+	FILE *f;
 
 	/* Check if new-style kprobe/uprobe API is supported.
 	 * Kernels that support new FD-based kprobe and uprobe BPF attachment
@@ -69,14 +77,14 @@ void test_attach_probe(void)
 
 	uprobe_opts.retprobe = false;
 	uprobe_opts.ref_ctr_offset = legacy ? 0 : ref_ctr_offset;
-	uprobe_link = bpf_program__attach_uprobe_opts(skel->progs.handle_uprobe,
-						      0 /* self pid */,
-						      "/proc/self/exe",
-						      uprobe_offset,
-						      &uprobe_opts);
-	if (!ASSERT_OK_PTR(uprobe_link, "attach_uprobe"))
+	uprobe_link[0] = bpf_program__attach_uprobe_opts(skel->progs.handle_uprobe,
+							 0 /* self pid */,
+							 "/proc/self/exe",
+							 uprobe_offset,
+							 &uprobe_opts);
+	if (!ASSERT_OK_PTR(uprobe_link[0], "attach_uprobe"))
 		goto cleanup;
-	skel->links.handle_uprobe = uprobe_link;
+	skel->links.handle_uprobe = uprobe_link[0];
 
 	if (!legacy)
 		ASSERT_GT(uprobe_ref_ctr, 0, "uprobe_ref_ctr_after");
@@ -84,17 +92,79 @@ void test_attach_probe(void)
 	/* if uprobe uses ref_ctr, uretprobe has to use ref_ctr as well */
 	uprobe_opts.retprobe = true;
 	uprobe_opts.ref_ctr_offset = legacy ? 0 : ref_ctr_offset;
-	uretprobe_link = bpf_program__attach_uprobe_opts(skel->progs.handle_uretprobe,
-							 -1 /* any pid */,
+	uretprobe_link[0] = bpf_program__attach_uprobe_opts(skel->progs.handle_uretprobe,
+							    -1 /* any pid */,
+							    "/proc/self/exe",
+							    uprobe_offset, &uprobe_opts);
+	if (!ASSERT_OK_PTR(uretprobe_link[0], "attach_uretprobe"))
+		goto cleanup;
+	skel->links.handle_uretprobe = uretprobe_link[0];
+
+	uprobe_opts.func_name = "method2";
+	uprobe_opts.retprobe = false;
+	uprobe_opts.ref_ctr_offset = 0;
+	uprobe_link[1] = bpf_program__attach_uprobe_opts(skel->progs.handle_uprobe_byname,
+							 0 /* this pid */,
 							 "/proc/self/exe",
-							 uprobe_offset, &uprobe_opts);
-	if (!ASSERT_OK_PTR(uretprobe_link, "attach_uretprobe"))
+							 0, &uprobe_opts);
+	if (!ASSERT_OK_PTR(uprobe_link[1], "attach_uprobe_byname"))
+		goto cleanup;
+	skel->links.handle_uprobe_byname = uprobe_link[1];
+
+	/* verify auto-attach works */
+	uretprobe_link[1] = bpf_program__attach(skel->progs.handle_uretprobe_byname);
+	if (!ASSERT_OK_PTR(uretprobe_link[1], "attach_uretprobe_byname"))
+		goto cleanup;
+	skel->links.handle_uretprobe_byname = uretprobe_link[1];
+
+	/* test attach by name for a library function, using the library
+	 * as the binary argument.  To do this, find path to libc used
+	 * by test_progs via /proc/self/maps.
+	 */
+	f = fopen("/proc/self/maps", "r");
+	if (!ASSERT_OK_PTR(f, "read /proc/self/maps"))
+		goto cleanup;
+	while (fscanf(f, "%*s %*s %*s %*s %*s %[^\n]", libc_path) == 1) {
+		if (strstr(libc_path, "libc-"))
+			break;
+	}
+	fclose(f);
+	if (!ASSERT_NEQ(strstr(libc_path, "libc-"), NULL, "find libc path in /proc/self/maps"))
+		goto cleanup;
+
+	uprobe_opts.func_name = "malloc";
+	uprobe_opts.retprobe = false;
+	uprobe_link[2] = bpf_program__attach_uprobe_opts(skel->progs.handle_uprobe_byname2,
+							  0 /* this pid */,
+							  libc_path,
+							  0, &uprobe_opts);
+	if (!ASSERT_OK_PTR(uprobe_link[2], "attach_uprobe_byname2"))
 		goto cleanup;
-	skel->links.handle_uretprobe = uretprobe_link;
+	skel->links.handle_uprobe_byname2 = uprobe_link[2];
 
-	/* trigger & validate kprobe && kretprobe */
+	uprobe_opts.func_name = "free";
+	uprobe_opts.retprobe = true;
+	uretprobe_link[2] = bpf_program__attach_uprobe_opts(skel->progs.handle_uretprobe_byname2,
+							    -1 /* any pid */,
+							    libc_path,
+							    0, &uprobe_opts);
+	if (!ASSERT_OK_PTR(uretprobe_link[2], "attach_uretprobe_byname2"))
+		goto cleanup;
+	skel->links.handle_uretprobe_byname2 = uretprobe_link[2];
+
+	/* trigger & validate kprobe && kretprobe && uretprobe by name */
 	usleep(1);
 
+	/* trigger & validate shared library u[ret]probes attached by name */
+	mem = malloc(1);
+	free(mem);
+
+	/* trigger & validate uprobe & uretprobe */
+	method();
+
+	/* trigger & validate uprobe attached by name */
+	method2();
+
 	if (CHECK(skel->bss->kprobe_res != 1, "check_kprobe_res",
 		  "wrong kprobe res: %d\n", skel->bss->kprobe_res))
 		goto cleanup;
@@ -102,9 +172,6 @@ void test_attach_probe(void)
 		  "wrong kretprobe res: %d\n", skel->bss->kretprobe_res))
 		goto cleanup;
 
-	/* trigger & validate uprobe & uretprobe */
-	method();
-
 	if (CHECK(skel->bss->uprobe_res != 3, "check_uprobe_res",
 		  "wrong uprobe res: %d\n", skel->bss->uprobe_res))
 		goto cleanup;
@@ -112,6 +179,19 @@ void test_attach_probe(void)
 		  "wrong uretprobe res: %d\n", skel->bss->uretprobe_res))
 		goto cleanup;
 
+	if (CHECK(skel->bss->uprobe_byname_res != 5, "check_uprobe_byname_res",
+		  "wrong uprobe byname res: %d\n", skel->bss->uprobe_byname_res))
+		goto cleanup;
+	if (CHECK(skel->bss->uretprobe_byname_res != 6, "check_uretprobe_byname_res",
+		  "wrong uretprobe byname res: %d\n", skel->bss->uretprobe_byname_res))
+		goto cleanup;
+	if (CHECK(skel->bss->uprobe_byname2_res != 7, "check_uprobe_byname2_res",
+		  "wrong uprobe byname2 res: %d\n", skel->bss->uprobe_byname2_res))
+		goto cleanup;
+	if (CHECK(skel->bss->uretprobe_byname2_res != 8, "check_uretprobe_byname2_res",
+		  "wrong uretprobe byname2 res: %d\n", skel->bss->uretprobe_byname2_res))
+		goto cleanup;
+
 cleanup:
 	test_attach_probe__destroy(skel);
 	ASSERT_EQ(uprobe_ref_ctr, 0, "uprobe_ref_ctr_cleanup");
diff --git a/tools/testing/selftests/bpf/progs/test_attach_probe.c b/tools/testing/selftests/bpf/progs/test_attach_probe.c
index 8056a4c..c176c89 100644
--- a/tools/testing/selftests/bpf/progs/test_attach_probe.c
+++ b/tools/testing/selftests/bpf/progs/test_attach_probe.c
@@ -10,6 +10,10 @@
 int kretprobe_res = 0;
 int uprobe_res = 0;
 int uretprobe_res = 0;
+int uprobe_byname_res = 0;
+int uretprobe_byname_res = 0;
+int uprobe_byname2_res = 0;
+int uretprobe_byname2_res = 0;
 
 SEC("kprobe/sys_nanosleep")
 int handle_kprobe(struct pt_regs *ctx)
@@ -39,4 +43,33 @@ int handle_uretprobe(struct pt_regs *ctx)
 	return 0;
 }
 
+SEC("uprobe/trigger_func_byname")
+int handle_uprobe_byname(struct pt_regs *ctx)
+{
+	uprobe_byname_res = 5;
+	return 0;
+}
+
+/* use auto-attach format for section definition. */
+SEC("uretprobe/proc/self/exe/method2")
+int handle_uretprobe_byname(struct pt_regs *ctx)
+{
+	uretprobe_byname_res = 6;
+	return 0;
+}
+
+SEC("uprobe/trigger_func_byname2")
+int handle_uprobe_byname2(struct pt_regs *ctx)
+{
+	uprobe_byname2_res = 7;
+	return 0;
+}
+
+SEC("uretprobe/trigger_func_byname2")
+int handle_uretprobe_byname2(struct pt_regs *ctx)
+{
+	uretprobe_byname2_res = 8;
+	return 0;
+}
+
 char _license[] SEC("license") = "GPL";
-- 
1.8.3.1

