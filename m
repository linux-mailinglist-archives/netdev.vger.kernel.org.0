Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 729E7559EC8
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 18:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbiFXQqI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 12:46:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbiFXQp6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 12:45:58 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B2E34DF67;
        Fri, 24 Jun 2022 09:45:57 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25OFYI2w004195;
        Fri, 24 Jun 2022 16:45:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=3HCiqpwJy3Y0NvcXu4dw+pH81U/5AfQMqOEVw9MtyWI=;
 b=Mzuy2GB0GLqQ1OovTI6pvd4OIYAYk3bbJSqacttZCMEW1IbJ8uOZ2cT/cZMZXuh0vJH0
 gG7efDQKcZUALXrwXvsBRI4G0a0qeaYvs2Tgcnspt5aNb5dan2NkP1KO+ETntBqgTuoe
 nqocH5gu8aZ6jHQJ3i9Bc+BwTM8rCdQBy20FdgvpEMjFKUB08ZBkqo1uCTDekgmhf+UR
 U3dV9CLARoLxgK2eBslnUqAfYOX0pqGPXVaMawPSSlhfwwaz8r6AIPrl1LPqAq2wZ/B0
 3qP8y4KBZRlbUMtveg+CKJV/RIxjZJcOT1rxLYzH0J3A0yY+D3hR6B5segpr03+GqWgx UA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gs78u6add-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jun 2022 16:45:32 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25OGV6Yn023811;
        Fri, 24 Jun 2022 16:45:32 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gtf5frqfa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jun 2022 16:45:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VeNfLSdGGe9FI8ZOOvwN8WTV3e5Af1G9P2Ds9QQO81NRr0GgzE8qxKCEQ+bMo7iHNI9cFlmqCcFn5pJBfXqKen3v1XKlsTEWlBc1VGFNqorJBFzXaIk4sw8FrKJnw5u/omenZDI++oAZH9p3MWYxDDIFptTbcu4pGRz4FY4855w2KFCVb1jOMUqlgVsMnhveAUAInVA9AuuJSSZ6D2019gkwvuELd2+CJ1hnQpXcebeRskXI4ZuQ09txPqQppZdSqxHt0JFQIH/NLXQ9xvE83bfmgKI7J4R9f8Mijv1mODfQwsdGtZtYLm0NvIS00UfRozyGIGUKPGuxjuDR9kqzyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3HCiqpwJy3Y0NvcXu4dw+pH81U/5AfQMqOEVw9MtyWI=;
 b=aLAmanjWojAh90qYkt4BRpSAYe48dOVqMWiRSo3fbT1ewCNDhPJxaFEHEhHzt09Y7Rq/rEndhQ5hB6pwo/1jBodCRFz2eCy7Rp1ftlqeSo/ohl/Aponetc9fVHdtkJpibpttmz/b6WQiW/pf2QXqVM9A4M69TCVWQHUQw4gVesDbHtdNp7QwTPpgYGsGxdl+R08+X99qesmK9a8f/Sir5lrdFd8Pv2WpMGe/Y3+L310xV+k5ZmkU+/3e7yaQsS0gAWaln6oNa1piMr3ANfUg0VEkFdW6KlMzKWkYolDHTVe8MkktzN26v4n7rFrLRpcD5Ok5K7EwNp7/zunijuRuMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3HCiqpwJy3Y0NvcXu4dw+pH81U/5AfQMqOEVw9MtyWI=;
 b=uQPjjEx+gKg904bri3lj+XwN73X28/IwZ50Or+UUYUiRHryodKeyRZ5VDs6wFzR+yyPtvBblb7C9AatAJ8Ql6DBa6vXD864q1nfvqohOEt0df85rV7xq6/+LIR2YgA66Wsm/Xs9UvuE1xDesoUiM6IwjTINMXBJ6w8rQEmKgM7M=
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by CH0PR10MB5115.namprd10.prod.outlook.com (2603:10b6:610:c4::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.15; Fri, 24 Jun
 2022 16:45:29 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::a080:c357:962c:eb5]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::a080:c357:962c:eb5%5]) with mapi id 15.20.5373.017; Fri, 24 Jun 2022
 16:45:29 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        jolsa@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, mhiramat@kernel.org,
        akpm@linux-foundation.org, void@manifault.com, swboyd@chromium.org,
        ndesaulniers@google.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [RFC bpf-next 2/2] selftests/bpf: add a kallsyms iter subtest
Date:   Fri, 24 Jun 2022 17:45:18 +0100
Message-Id: <1656089118-577-3-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1656089118-577-1-git-send-email-alan.maguire@oracle.com>
References: <1656089118-577-1-git-send-email-alan.maguire@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0396.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18f::23) To BLAPR10MB5267.namprd10.prod.outlook.com
 (2603:10b6:208:30e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 28f339d6-520d-4eae-effe-08da5600f292
X-MS-TrafficTypeDiagnostic: CH0PR10MB5115:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w0W3dnVn8LqwGMmtXVrlrzkSgT46Yd96f4CifaaOYHLxEWgGITGlEtxtN5RW+RT7/sFVWRhA3HSfL+ekzK8XWLtqb9bCtWNZ0xMHkRWYNFr55I9vdFZNBznwzWHbEX+pwOFIG9TT8wpUjzALtW+u+4Ui433AE7FPpC9ilnWu5GivdVPn5SJh3pKaUe3B7mPVW75YCHTLtwIkWyr5lqvrPADpk78Y6ef7/M/QQpyQR8DBl2o+Haj8wNvdZ9gX7vYKpZS/S/F38+0byYHI+QjGqkxPDRtS5yznUlNEHkL9DxPe8ASJ1xdypRuST4ZTk+KVmXkR8TfqWxFFXZYXcbnSf3oWuyZzT6VOqGdc0M6twDhUxXhgFyWMdJHrAvFaP/llNPUEf/NFVUXI38szsvURD/Ma7jw/57b5Wm4U/c4wKRymbYXrcFJphuyBK3uXO/cHubPotWPEMOzoD/LaB69Axql91y/2x29WcBQsfpLv1H/scAaPNau4+/eyu88FC+tk524TpG//DyUQhnEQsObZRN898df9lhiSaNoiOmNhd4WMpetTNq/rD9F28/xVgQIyfIJThCYTZT/3tzWRiLaR3q7qt+Cx4WcevPULeR8m+1sZxfkkIyoFvCTb6qzMiN91yuN38KdnsxXMb68R/FWdhLmd2zplpjh7HONjx672srLjfnRPZr3CZO5hQhPSVj8j0i3Qg6Du2w61AFnnVNFPCBeWviYWvPvxWHJ1lUegCroVElQseynu80XM/rbh07Zn8awTNgosNFcR9ht7mYiHLVAnWqsIKIF9VBNB11esy44=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(366004)(396003)(376002)(346002)(136003)(4326008)(8676002)(186003)(83380400001)(44832011)(478600001)(66476007)(5660300002)(2906002)(66556008)(38100700002)(7416002)(66946007)(8936002)(6506007)(107886003)(52116002)(2616005)(41300700001)(6512007)(26005)(6666004)(316002)(36756003)(38350700002)(86362001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/71vQTuK5It4uNb8XvgQRIPQTQ0XJdYBKLcypboDP9V6VVxihUvytsS/DfOz?=
 =?us-ascii?Q?WA+Cm7a9ZP26FP1TTEZpVKLKgjNzUyxuZVjKN1adKk0BSraov+rFNWY/bP7a?=
 =?us-ascii?Q?icSsvAdNiXS/ZkhxR4TPrZfhvlldseHPrWTsFckjNPC5NQT0RKK7Lf2haIpa?=
 =?us-ascii?Q?iTMYS3XPZXko0mwobZQ+hZpq4D27claweJwJhQFrndwwlkfmHrVf9aCS2RIz?=
 =?us-ascii?Q?IQDpX9pshfzMJaOVSFWw+4NA5Xa7aaka0api5y7o1vOJckiWpqzG8cOKwQCJ?=
 =?us-ascii?Q?n3L6t/F26WSVIrv/P1xcNDL72vprWEECZUQH2zaLQ+XilkeiX1rFDcRnyq4+?=
 =?us-ascii?Q?8dQZ8oyTUfMqES9j6g9RE7f7theaZdSj+NOpGr7chSscbCcEjUtwIP/KoYmv?=
 =?us-ascii?Q?MVyvBUbQmvgn23Hvqt2NScGG4sFQqE5M4qWs0f/uW5XZZrpYrYhkovPXeOqX?=
 =?us-ascii?Q?2j5mIWQIAunVpqqYaS/ckDxHcXr+9YvnwNJlfCktY0c/DvCcF7jgH/zYxb0I?=
 =?us-ascii?Q?Asj2/c+ocwh9WjxCBmKK0o3fqovM+NVIqn1juDq4oCcv78zg2h3G3Cm+OL1R?=
 =?us-ascii?Q?wm76JCSMdt4OhRdQj2eEPLQf9iGzrHPjdfq35V7yFeq1e2+Hz9qIoey5SIia?=
 =?us-ascii?Q?uEWw7APRuxzl+kw0TevNuQuLCM/GiiwY3PKWH7b0qJecimZF6CKlKsKveNQX?=
 =?us-ascii?Q?p20eSYxbpmNNUIn6LAAGaMcSLLArzy2RybWMbzlsvU5TLfpHH/3Gl+V3uJ4P?=
 =?us-ascii?Q?dOK+4GusTfAHx56e0NM8QnQXM/JZ4Wey26ok1NEyxiqiEZRZur1IyRpoJC0I?=
 =?us-ascii?Q?sYjSwXmOeIL1hST/FsArreRkjGsLvEnakJVOB9Nor5flmcOefwzMXOc+QJqw?=
 =?us-ascii?Q?+bchGpllpjfhdwOsc1ZCgEZ2N3ko6zv0SvERak5k6CLkyaUEEDKu8s0TlSE2?=
 =?us-ascii?Q?r2Uk9hLuAN3vmOHHnHg2fC7XoyVT2CJgI56IaiKUssNW+MTUysl1O95LdTuF?=
 =?us-ascii?Q?10UoWf9TvrCOv3FTHw6AESTJ7IZAWEU4FLXncvi1y0x7gsdb80c5f6+7lwFD?=
 =?us-ascii?Q?CLgQbmCHagVTFG7X0B4O7t1ts8fes4ZFGWkYGdfbwtN1a3Rsst7fQr0lFodI?=
 =?us-ascii?Q?7rKJRmORYToC05WFdP71Cqkw1Na03vUgW4ktmECq6WwWzf9OitLSvaHgA6g6?=
 =?us-ascii?Q?EqxcPqXKfqFYt25SQ4DWudMh4O1e82qCPZ5DtoIuo8BuFY09sSCa13Yv4YlI?=
 =?us-ascii?Q?IQJurXwKZZd/Rk/17s67diu4ERplFGtPekAiHlk1ueSgry37p2W/wpO3eq/E?=
 =?us-ascii?Q?lHEK7oIIao+1P5A9a++lE+v2NvXXP/Me+AAJ3zszWgGjrk32JGUacJXv2Hhu?=
 =?us-ascii?Q?46Hpgjls7Ls17iobnSqxM1RnEZ93CzalYrxSbdOhK5NInbF/o+ceymFZVsND?=
 =?us-ascii?Q?kTSoBGmAHyIxB76Bw9d20RiwdwrRngJO6HPZe4Mi7SPMDnnxMmJhn4RmjRJe?=
 =?us-ascii?Q?f4AmJcUZfBzGT+muPsOgMsh7bSJ6TBu84+lNquQMvXCLM2ELb2F3QaibiJdB?=
 =?us-ascii?Q?FpsgdYOUR9gRydQBWOhfgEnLTVzZjXPJplEm/2O2?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28f339d6-520d-4eae-effe-08da5600f292
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2022 16:45:29.7769
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BFDlszoOi1r9BJx6EDKMrCLXr/f1l7p/OgTrSuK0q/kQmLSJdWUUW+OrffTECHdll6QA2cPw0jUie17bL+F2yA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5115
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-06-24_08:2022-06-23,2022-06-24 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206240064
X-Proofpoint-GUID: BhlkWN6hnY_0ucS9EB3RMc0v-tJOBqr7
X-Proofpoint-ORIG-GUID: BhlkWN6hnY_0ucS9EB3RMc0v-tJOBqr7
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

add subtest verifying BPF kallsyms iter behaviour.  The BPF kallsyms
iter program shows an example of dumping a format different to
kallsyms.  It adds KIND and MAX_SIZE fields which represent the
kind of symbol (core kernel, module, ftrace, bpf, or kprobe) and
the maximum size the symbol can be.  The latter is calculated from
the difference between current symbol value and the next symbol
value.

The key benefit for this iterator will likely be supporting in-kernel
data-gathering rather than dumping symbol details to userspace and
parsing the results.

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 tools/testing/selftests/bpf/prog_tests/bpf_iter.c  | 16 +++++
 .../selftests/bpf/progs/bpf_iter_kallsyms.c        | 71 ++++++++++++++++++++++
 2 files changed, 87 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_kallsyms.c

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
index 7ff5fa9..1197a58 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
@@ -27,6 +27,7 @@
 #include "bpf_iter_test_kern5.skel.h"
 #include "bpf_iter_test_kern6.skel.h"
 #include "bpf_iter_bpf_link.skel.h"
+#include "bpf_iter_kallsyms.skel.h"
 
 static int duration;
 
@@ -1120,6 +1121,19 @@ static void test_link_iter(void)
 	bpf_iter_bpf_link__destroy(skel);
 }
 
+static void test_kallsyms_iter(void)
+{
+	struct bpf_iter_kallsyms *skel;
+
+	skel = bpf_iter_kallsyms__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "bpf_iter_kallsyms__open_and_load"))
+		return;
+
+	do_dummy_read(skel->progs.dump_kallsyms);
+
+	bpf_iter_kallsyms__destroy(skel);
+}
+
 #define CMP_BUFFER_SIZE 1024
 static char task_vma_output[CMP_BUFFER_SIZE];
 static char proc_maps_output[CMP_BUFFER_SIZE];
@@ -1267,4 +1281,6 @@ void test_bpf_iter(void)
 		test_buf_neg_offset();
 	if (test__start_subtest("link-iter"))
 		test_link_iter();
+	if (test__start_subtest("kallsyms"))
+		test_kallsyms_iter();
 }
diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_kallsyms.c b/tools/testing/selftests/bpf/progs/bpf_iter_kallsyms.c
new file mode 100644
index 0000000..20c8d85
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/bpf_iter_kallsyms.c
@@ -0,0 +1,71 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2022, Oracle and/or its affiliates. */
+#include "bpf_iter.h"
+#include <bpf/bpf_helpers.h>
+
+char _license[] SEC("license") = "GPL";
+
+unsigned long last_sym_value = 0;
+
+static inline char tolower(char c)
+{
+	if (c >= 'A' && c <= 'Z')
+		c += ('a' - 'A');
+	return c;
+}
+
+static inline char toupper(char c)
+{
+	if (c >= 'a' && c <= 'z')
+		c -= ('a' - 'A');
+	return c;
+}
+
+/* Dump symbols with max size; the latter is calculated by caching symbol N value
+ * and when iterating on symbol N+1, we can print max size of symbol N via
+ * address of N+1 - address of N.
+ */
+SEC("iter/kallsyms")
+int dump_kallsyms(struct bpf_iter__kallsyms *ctx)
+{
+	struct seq_file *seq = ctx->meta->seq;
+	struct kallsym_iter *iter = ctx->kallsym_iter;
+	__u32 seq_num = ctx->meta->seq_num;
+	char type;
+	int ret;
+
+	if (!iter)
+		return 0;
+
+	if (seq_num == 0) {
+		BPF_SEQ_PRINTF(seq, "ADDR TYPE NAME MODULE_NAME KIND MAX_SIZE\n");
+		return 0;
+	}
+	if (last_sym_value)
+		BPF_SEQ_PRINTF(seq, "0x%x\n", iter->value - last_sym_value);
+	else
+		BPF_SEQ_PRINTF(seq, "\n");
+
+	last_sym_value = iter->value;
+
+	type = iter->type;
+
+	if (iter->module_name[0]) {
+		type = iter->exported ? toupper(type) : tolower(type);
+		BPF_SEQ_PRINTF(seq, "0x%llx %c %s [ %s ] ",
+			       iter->value, type, iter->name, iter->module_name);
+	} else {
+		BPF_SEQ_PRINTF(seq, "0x%llx %c %s ", iter->value, type, iter->name);
+	}
+	if (!iter->pos_arch_end || iter->pos_arch_end > iter->pos)
+		BPF_SEQ_PRINTF(seq, "CORE ");
+	else if (!iter->pos_mod_end || iter->pos_mod_end > iter->pos)
+		BPF_SEQ_PRINTF(seq, "MOD ");
+	else if (!iter->pos_ftrace_mod_end || iter->pos_ftrace_mod_end > iter->pos)
+		BPF_SEQ_PRINTF(seq, "FTRACE_MOD ");
+	else if (!iter->pos_bpf_end || iter->pos_bpf_end > iter->pos)
+		BPF_SEQ_PRINTF(seq, "BPF ");
+	else
+		BPF_SEQ_PRINTF(seq, "KPROBE ");
+	return 0;
+}
-- 
1.8.3.1

