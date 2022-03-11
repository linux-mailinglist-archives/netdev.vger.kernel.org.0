Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C07114D6153
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 13:12:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348522AbiCKMMp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 07:12:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243342AbiCKMMk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 07:12:40 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85E5E188A07;
        Fri, 11 Mar 2022 04:11:36 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22BBj56b011326;
        Fri, 11 Mar 2022 12:11:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=FT7SMbPO1INVUF/yRTWt5h2zstuOkZoZ8gcrTSqKgHs=;
 b=zQGRDdj5Uxg9BXhp4Km4ZJIYFULJ+sXh3Dqp6jAwB7aOopYzLo+HjC//Li8HilhOv2Y8
 MrZ9BbmzhyHggILEfuAK9CX6RZE3G106yUZIAPi8XcH5F4/u51Et7lVHARZXhayMAiaz
 IJMBXiWVFj36UGV+wIZjr8IijL3raRRA83z6tPPccuKQXhbxY9pYMn6aPIwVOXq25mzP
 /PpymsqyW/Oesu+55U4fheZGE7yN/5A9K2bi+hzqq8SR90e+AGGTxRweAjhprEVmKGjy
 FrwTnhRWAexDv+3VFzFDCzJ0KrRdVbtLindx1cI7JKbPLkQr+FsOsv+nmxwoKZ2OML10 RA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ekxf10mtj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Mar 2022 12:11:17 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22BCBBJK123780;
        Fri, 11 Mar 2022 12:11:15 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by userp3020.oracle.com with ESMTP id 3envvp44yk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Mar 2022 12:11:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UJkGkOZIw4Q17C888U6tY4bC6jmtZwYkgFqc3KJLQDhsLuJIdtMCe7IN7lgKZhs2b9PZq6fJU0l4bRDMdS35VkiFtp7QrB0VJWzvAxJchc7L6xOpOeGCcvn/V1fxgKt87tHxAojHaGR0cmuLjXVk4l5hb0chGQoEqiycs+N7t83bJKrxM1rB5wNfzobr7QiqbBOOhGtzMedekGYDyD47Pm8vJ6vFIXpxgiA+U6Wp5SqajQps4hOUKVycuVw8WtJ/Er7Aby3tZAOYwy8w0/f/eG+3DI9yr8C1T4ZJAcCte2S6VIHd4I98gFv2ZuNzee9nZiCa4CGGN/Kw++SDnBrdhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FT7SMbPO1INVUF/yRTWt5h2zstuOkZoZ8gcrTSqKgHs=;
 b=GEobsctf8Euwndz/txIn6n+reGLYdSvHok0G7AbVOBuLAUAYO8Wsdu8oHSvR/LKJOdSRmJlw30XPainsUlHCtx1VtSADtHVpVzsf55LQwm6GvzX95gzLBiYm2lYfZ3q86YJPY6yF+R/U8kqdvex+e5MlpzEzbv1i5GG+FcpdpWsxw41xkh5yxqIdwiRGDPd8ug1KrwUaT0uJDKKjmNNX+Dzu5aWMknxqKdgQprkjp2+kq1yXzyLcBpJj1lThWzMumizI954OFOESaPmCG2fzitsIrdRuQCx61cUtSwn/NJyz16gLsbCMnhdlMQWA0aKfHoeTMS8LtqYkVBB6McUBew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FT7SMbPO1INVUF/yRTWt5h2zstuOkZoZ8gcrTSqKgHs=;
 b=GaExePgszMhLMOHzmaI73XRcRNR6zyunHi5Uqj3ayui2JLZ9QqaBF1Ug0+NByM/V2KiRujS6O40mRQbTVf5wpJ76j1/a1qYJpGWtdo7hDeipAOCUG2ql0OkzyE5421q2+Ht/vjU29uyC0TMbQqGXjByDl/IlWiw8FXEr4n9G6uo=
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by SJ0PR10MB4784.namprd10.prod.outlook.com (2603:10b6:a03:2d4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Fri, 11 Mar
 2022 12:11:13 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::517b:68:908d:b931]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::517b:68:908d:b931%3]) with mapi id 15.20.5061.024; Fri, 11 Mar 2022
 12:11:13 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, toke@redhat.com,
        sunyucong@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH v4 bpf-next 5/5] selftests/bpf: add tests for uprobe auto-attach via skeleton
Date:   Fri, 11 Mar 2022 12:10:58 +0000
Message-Id: <1647000658-16149-6-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1647000658-16149-1-git-send-email-alan.maguire@oracle.com>
References: <1647000658-16149-1-git-send-email-alan.maguire@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0335.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18c::16) To BLAPR10MB5267.namprd10.prod.outlook.com
 (2603:10b6:208:30e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 02e1ad76-608c-4d74-9753-08da03583c66
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4784:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4784AB0D0853A9D9FBBA0C84EF0C9@SJ0PR10MB4784.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m9nBKVo2tdqtN2hSlqpweG5yx2fkHhBC/apqlz+8PgMzTLOL2k3VSejDc2HvT5HbG9nZAoNOrAfsqW1QTl9BsjTrhg9LvTEBfau6NjV53NcwJXVi1uVmuJH7eiIEze7G1V5Gfkuiv3X0a+0zyikWvecSGUssoMakUZAfGn7CMsjEJlUqw/bokmdKBnk+1fuLLhat+FqxXUWvvX7QoYOV9Fcsn5mdGUsDKRuhti+IRRKxYQ6hjnCS8a2YRq+1EqSE02nFkneYqwuCJuxh56hLK7jIpfN1L33jwwa7kfTI2UnheRjOofPDdIHkM3FgSTEFkikJp/VxG/wOLvrDer3prL5VzO+HIvog0TVXT0Q/jNCmEVFN3GwFCz9IDgV1DszYdUBPKUHMn5JlMMZiAbXyc9SbIluyOsvk8jI3hWgyukpU4txkaTES8j3Sn2RAEfrdDiMxc/Ewp206334DvWRP3O3zLSl9UKbhWy68eg0C1pw/+WorqPN2LILGpeMbxXvynpdVga2JfNRPiYbehJl61xmjWmrPfZV1jLY4ze6kEbgU9mjB+H5f9dbVmbZbKHDLE6tZkmVsLHpLOVyh9RaYbjwhJvBKtwPhgCCib44jcGOo7EZONPkGIW/Dhc6ktwGluwGAoR2DtYPHgT9vEcz/6P5pwPR6IEsRl75FKIOy/Hfkhxz1lAsE0QueGHzwvKr3oYVDxhqu9nfz8is64fCo+g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38350700002)(2616005)(66946007)(36756003)(7416002)(83380400001)(316002)(38100700002)(6666004)(86362001)(508600001)(5660300002)(44832011)(6506007)(8936002)(52116002)(26005)(6512007)(186003)(2906002)(107886003)(66476007)(8676002)(4326008)(6486002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GJX7JYSloYU4gGL0sSDdHnI9oUYw6lpZtsHYSJMStAa4gOGQHfWtrmpdMVAa?=
 =?us-ascii?Q?HxZ8+cLsRU0IIAhaa6WccXoVZ0sBvU24aASRqAi39XSHRVEGenfvMOv4y23d?=
 =?us-ascii?Q?fypKntAG5hrphRbtvqkafOtzWBLNiVfM6Yxdm77aNuReCmzgghw9QM2iLbZb?=
 =?us-ascii?Q?GM8XPW7ixj6fhw1vnTrUEz6SIGwDmjmKHqAEPpAqlUi+eW9lLXSEFV31EK95?=
 =?us-ascii?Q?HSS89cfVHBk5/0Nwvxk8RmrwVpQlYBP+EvvluAld19bH6kaOAZm5pmV8FvmF?=
 =?us-ascii?Q?Fh8vDpYNCBIBOgzQgwSLTd4SLi64ONNmublYq7aRj9zSbimyloWuOEx2PZUU?=
 =?us-ascii?Q?vDlkczJQfxZ6lWlGuG/DxFi3CdVfbyCUvFc2Ydp4YGufqhE729tNVQXPvWyP?=
 =?us-ascii?Q?Z2IwRS8ps8q5qGGxlEexxpiGv2YxxdTWfBSo5oS3QdOgPidUBGSZCY70rvN7?=
 =?us-ascii?Q?YdIRH+1OUz0D0waGHb7lCpv82Y+Bfaopc2SzJEmbx/EiWoydEpO9Ldc7mypJ?=
 =?us-ascii?Q?7GmREIYeBFWSIitcSd99rC/ecx7FBDWWELtA0vn0P0Aptq1x6ceW7NcwbpuC?=
 =?us-ascii?Q?My6I8qmplLLgS37cZ/KUefnmZsDYlBDqVZOmI1C2ivnxzTOoAtukxM93ZAV3?=
 =?us-ascii?Q?Zas6mpCms/rXChsLmwrqxvd+FTjK4ITxNQ4Q5nwyfzHOmSStaJHDtMW59XMP?=
 =?us-ascii?Q?Rqivq1XV1n/QrQujgW0ASsiRnBEs45phEKPWQ4+Ai2rnn5i4/tIePtpfWj13?=
 =?us-ascii?Q?0erXs60Ii9vBHNFKtR+DSc0SxsEHrGRSHjW4G6JwiDkbUxwEW++1u4JKKqyi?=
 =?us-ascii?Q?3lAJJ9J3LUEY/HKJxxIMi1MU/k4W2YKMyuty5wIaNdf7Ovy+1YOOQ7LDRiVJ?=
 =?us-ascii?Q?KF/xtv7rFbqTOmUNPyzMMzAyFkJRZt62XwnuJQeriQi04Y6jZI5c2YkPXfje?=
 =?us-ascii?Q?LxhiC388eHA/T6eLu7wN0btaDb+/J/pz1kvX2oQuYG3tdLYQh9e29GN2EGwv?=
 =?us-ascii?Q?r8R5okceDRPBrLyfqcKsLEeD20G2blI5sUTJE1ZqwEorN1jS06Fkz774YyD6?=
 =?us-ascii?Q?x4x5wqLrqHCrVxDfpAAUn1BoIk/ATMCH/R0+3mFHI8nAa1VtyHiEyzvw/2eH?=
 =?us-ascii?Q?j2Knv5EpoeVdeZdu1Z67TO1ezITDoC/r9q8yAX95DWMep1Bwbxxi56ooVvNg?=
 =?us-ascii?Q?Bi4/37iwdBYXSMh9rrqDwDfofnpF6MyGVL/0VS4exTATHdfWArq2tzjtjZp9?=
 =?us-ascii?Q?BbmAQvWITkHrqDSxxabl6eBc9/hpi5As6DRmmBR9DltB8+C0wnv7dldYnAzi?=
 =?us-ascii?Q?hFbLu6HNeCoRGgRNKIODMRg2+Xfyr+59sY3wkRosbVtPyKet+P2RKht4y0LC?=
 =?us-ascii?Q?op61N95vYImalS1tMxQCNFPRlNXQYvAcCRhKTV23jBm9AbJvw0AzD8rZa16g?=
 =?us-ascii?Q?tEc3VJ/XyhLVGO7KqEjGtY+IVsX4Ci0mSUmFn2XReP3VXJ4CnYPYcKYa4iPn?=
 =?us-ascii?Q?6VeA9etSH2fE2Wxgu/BsEvRllr/ZdsrWqYBi6nX9OP4EfWQGErkJnQp0w9hZ?=
 =?us-ascii?Q?cUoJIVK096vDVmFGYOJlIve2jqQVHLaqiaitk8Q42j3jd3g0mEASjdK6xhg9?=
 =?us-ascii?Q?V/7pHTxEeALPZcaLSmWC0aE=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02e1ad76-608c-4d74-9753-08da03583c66
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2022 12:11:13.3895
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xkAnJn0Q55DV4gVa2TdXSvXgXkGifGlSvf/t+WJrnHfueZFli+i8sOaQw48sHWwm1ADEMV9CoGDDAKeorVHPlw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4784
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10282 signatures=692556
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 bulkscore=0
 phishscore=0 malwarescore=0 suspectscore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203110060
X-Proofpoint-ORIG-GUID: u7A6CWQ0ke3TJjK5jdDPejj7sGSbm2eC
X-Proofpoint-GUID: u7A6CWQ0ke3TJjK5jdDPejj7sGSbm2eC
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tests that verify auto-attach works for function entry/return for
local functions in program, library functions in program and library
functions in library.

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 .../selftests/bpf/prog_tests/uprobe_autoattach.c   | 48 +++++++++++++++
 .../selftests/bpf/progs/test_uprobe_autoattach.c   | 69 ++++++++++++++++++++++
 2 files changed, 117 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/uprobe_autoattach.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_uprobe_autoattach.c

diff --git a/tools/testing/selftests/bpf/prog_tests/uprobe_autoattach.c b/tools/testing/selftests/bpf/prog_tests/uprobe_autoattach.c
new file mode 100644
index 0000000..57ed636
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/uprobe_autoattach.c
@@ -0,0 +1,48 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2022, Oracle and/or its affiliates. */
+
+#include <test_progs.h>
+#include "test_uprobe_autoattach.skel.h"
+
+/* uprobe attach point */
+static void autoattach_trigger_func(void)
+{
+	asm volatile ("");
+}
+
+void test_uprobe_autoattach(void)
+{
+	struct test_uprobe_autoattach *skel;
+	char *mem;
+
+	skel = test_uprobe_autoattach__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "skel_open"))
+		return;
+	if (!ASSERT_OK_PTR(skel->bss, "check_bss"))
+		goto cleanup;
+
+	if (!ASSERT_OK(test_uprobe_autoattach__attach(skel), "skel_attach"))
+		goto cleanup;
+
+	/* trigger & validate uprobe & uretprobe */
+	autoattach_trigger_func();
+
+	/* trigger & validate shared library u[ret]probes attached by name */
+	mem = malloc(1);
+	free(mem);
+
+	if (!ASSERT_EQ(skel->bss->uprobe_byname_res, 1, "check_uprobe_byname_res"))
+		goto cleanup;
+	if (!ASSERT_EQ(skel->bss->uretprobe_byname_res, 2, "check_uretprobe_byname_res"))
+		goto cleanup;
+	if (!ASSERT_EQ(skel->bss->uprobe_byname2_res, 3, "check_uprobe_byname2_res"))
+		goto cleanup;
+	if (!ASSERT_EQ(skel->bss->uretprobe_byname2_res, 4, "check_uretprobe_byname2_res"))
+		goto cleanup;
+	if (!ASSERT_EQ(skel->bss->uprobe_byname3_res, 5, "check_uprobe_byname3_res"))
+		goto cleanup;
+	if (!ASSERT_EQ(skel->bss->uretprobe_byname3_res, 6, "check_uretprobe_byname3_res"))
+		goto cleanup;
+cleanup:
+	test_uprobe_autoattach__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_uprobe_autoattach.c b/tools/testing/selftests/bpf/progs/test_uprobe_autoattach.c
new file mode 100644
index 0000000..a808bcf
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_uprobe_autoattach.c
@@ -0,0 +1,69 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2022, Oracle and/or its affiliates. */
+
+#include <linux/ptrace.h>
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+int uprobe_byname_res = 0;
+int uretprobe_byname_res = 0;
+int uprobe_byname2_res = 0;
+int uretprobe_byname2_res = 0;
+int uprobe_byname3_res = 0;
+int uretprobe_byname3_res = 0;
+
+/* This program cannot auto-attach, but that should not stop other
+ * programs from attaching.
+ */
+SEC("uprobe/no_autoattach")
+int handle_uprobe_noautoattach(struct pt_regs *ctx)
+{
+	return 0;
+}
+
+SEC("uprobe//proc/self/exe:autoattach_trigger_func")
+int handle_uprobe_byname(struct pt_regs *ctx)
+{
+	uprobe_byname_res = 1;
+	return 0;
+}
+
+SEC("uretprobe//proc/self/exe:autoattach_trigger_func")
+int handle_uretprobe_byname(struct pt_regs *ctx)
+{
+	uretprobe_byname_res = 2;
+	return 0;
+}
+
+
+SEC("uprobe//proc/self/exe:malloc")
+int handle_uprobe_byname2(struct pt_regs *ctx)
+{
+	uprobe_byname2_res = 3;
+	return 0;
+}
+
+SEC("uretprobe//proc/self/exe:malloc")
+int handle_uretprobe_byname2(struct pt_regs *ctx)
+{
+	uretprobe_byname2_res = 4;
+	return 0;
+}
+
+
+SEC("uprobe/libc.so.6:free")
+int handle_uprobe_byname3(struct pt_regs *ctx)
+{
+	uprobe_byname3_res = 5;
+	return 0;
+}
+
+SEC("uretprobe/libc.so.6:free")
+int handle_uretprobe_byname3(struct pt_regs *ctx)
+{
+	uretprobe_byname3_res = 6;
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
1.8.3.1

