Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 008CC443FA1
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 10:50:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231949AbhKCJxX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 05:53:23 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:19520 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230097AbhKCJxR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 05:53:17 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A39jNBc001867;
        Wed, 3 Nov 2021 09:49:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=PmaE9TWkSMPOx8p0OiHjtrQfRXGyvONNCgsAEfhasss=;
 b=YLQe8PY/wGMqaTCCtw4u91JaWJtbepM8lSIPSfMS1BCKRLWT/VlSUSaoDNU5p6a6v5DA
 VXxpP1GhnE1fyVd1yRjjot9bGIAzby1VCurxd7aLS6GwFYUNP6S5teD25KrHIVw/k3K/
 uDiHyrYoug5IPBu1oGUJ7oynuF2KXaY6HA5ekUu8CP1UOEmd5dzpKdP3O4LcWzMPpC9V
 A2G5K1yiBGAnvGLjLXx7zbSCCQAuQMWel/AxXYeJqEWvXOpmFR1flSzgq05ta0ueamku
 3U+J/LatdV1S5BPI/D96ReM4hqlWTqA/eRTJamF9nP4PzGmMaJaqcC+H9OMZF2GNnFO3 Qw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c3mt58xhp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Nov 2021 09:49:52 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A39juGs029532;
        Wed, 3 Nov 2021 09:49:51 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2174.outbound.protection.outlook.com [104.47.58.174])
        by aserp3020.oracle.com with ESMTP id 3c0wv604tc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Nov 2021 09:49:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uwk5X5NP81pt3ehWhyU14BdqkSvv3CIHXw3UlM43XCWS0dIBUY4P/prArBHZYdjX1GKqqulkCyI5NB986yXPKYQvgXMa9mOPRmxUnuNhfGR8Z+Xgs8DgkH14OdsaIB7VHuoWyW6S3Ecj71EGqIL1mPxttfsydaSWaACAi79viM7fTSa6Gebd0bLt0KFRVkzrDhQxCcG+CuvbY3t6LMaBjh5iEt5/WxrLNscdYiJCbw47Q6pFhSaRWsSJ1AibI5CG59EcltcE0bmeBi1fshEjWaIh1JKmWfOB/P4fmjdCYJUYZqw17xVY9xCMMH8+sQiWSLGko+Q4TOIno9XtG7g1fQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PmaE9TWkSMPOx8p0OiHjtrQfRXGyvONNCgsAEfhasss=;
 b=AHL3whcO+kaBoMl+EwxNgZmqrIxv3dtBQ0SlzbRh639id1Rd9cILVesaKZ+cMttRNzrTmjRmzxB2Uond7nli6azsa0tzBrl/L2wHI5GKmuZZlmtp6i0eokGbpgU0lUEyoPzj6KE5NgNJzcBBbK1eie5TF6mB9AP6IVkABlDmZShweV+7/t1DkJidnArXNwY2SrC9uD9FWDssOfz/v5KE2TBZnK3gaEYk+a9ADYn0Cq1wtuSLAzLkJXL65wsxUBnDBoGgkagVqbGbOVWbnNhBvEzKxKAXTq4lXvNhE+y5hsxTwfcji1qHkjlKH26fFUVWQq5vak1woYBGwYuoFI5pHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PmaE9TWkSMPOx8p0OiHjtrQfRXGyvONNCgsAEfhasss=;
 b=RDocs0SaE79rs+wgR5FIKc3qiLJD+lpFPYGT/JT6MutMrxlJKiG/ollRFidoS8PYrOvteIDCyYS7JXGNTg6hjlYKTPgeFb2neSss874h7bu/oxIDuJjTKEwsridRg+pJyvlJaCbdqSZ1l/Qj5lKe6Xn6buEq+jQaYkZZnQdZlws=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from DS7PR10MB5278.namprd10.prod.outlook.com (2603:10b6:5:3a5::9) by
 DM6PR10MB2490.namprd10.prod.outlook.com (2603:10b6:5:ae::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4649.17; Wed, 3 Nov 2021 09:49:49 +0000
Received: from DS7PR10MB5278.namprd10.prod.outlook.com
 ([fe80::6c17:986b:dd58:431d]) by DS7PR10MB5278.namprd10.prod.outlook.com
 ([fe80::6c17:986b:dd58:431d%7]) with mapi id 15.20.4649.018; Wed, 3 Nov 2021
 09:49:49 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ardb@kernel.org, catalin.marinas@arm.com, will@kernel.org,
        daniel@iogearbox.net, ast@kernel.org
Cc:     zlim.lnx@gmail.com, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, andreyknvl@gmail.com,
        vincenzo.frascino@arm.com, mark.rutland@arm.com,
        samitolvanen@google.com, joey.gouly@arm.com, maz@kernel.org,
        daizhiyuan@phytium.com.cn, jthierry@redhat.com,
        tiantao6@hisilicon.com, pcc@google.com, akpm@linux-foundation.org,
        rppt@kernel.org, Jisheng.Zhang@synaptics.com,
        liu.hailong6@zte.com.cn, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH bpf-next 2/2] selftests/bpf: add exception handling selftests for tp_bpf program
Date:   Wed,  3 Nov 2021 09:49:29 +0000
Message-Id: <1635932969-13149-3-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1635932969-13149-1-git-send-email-alan.maguire@oracle.com>
References: <1635932969-13149-1-git-send-email-alan.maguire@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0089.eurprd07.prod.outlook.com
 (2603:10a6:207:6::23) To DS7PR10MB5278.namprd10.prod.outlook.com
 (2603:10b6:5:3a5::9)
MIME-Version: 1.0
Received: from localhost.uk.oracle.com (138.3.204.46) by AM3PR07CA0089.eurprd07.prod.outlook.com (2603:10a6:207:6::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.4 via Frontend Transport; Wed, 3 Nov 2021 09:49:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a624aba9-91d4-4eec-6acb-08d99eaf468c
X-MS-TrafficTypeDiagnostic: DM6PR10MB2490:
X-Microsoft-Antispam-PRVS: <DM6PR10MB249039B3EFC07413A4ADDE52EF8C9@DM6PR10MB2490.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d98Ibjwvb1UITU67vBkqwBhRta9Y0BMV56bQY5d1nCXAOjHWJUB6y7lVxQKE9CyW10607O8NQ+67+GP0BNtnrYUKjoRG5nwnF0DEhqp9hatRsL77jE3eyoVNPkvWkP42BkrV+JHQmKV3TdTd2JRkMUtaUc9LltLa0Qj9mXu6Xnuv1dcjBFmP2z6NeBrOtsEk5NLikZS+33fK3bzicZON5myW/Bnj+aV19CzlXM/qmq5mmlfSTJOWVtDeKBxWxUI1nam+/yANc5o0BWFgEHBtWTXFqDIJPIag2QY3tUehp+L/j0N1aRfQ0yXu5c+pVyCf0eDWS2wzWrRhbjHB0K9qLXJt9sLnrHNqp2bE543GYbkUkhQVtQKY4CZLrCuflPS3scEKaeKW52ZpG1zjBagapvj4iuAQVy/NSX3Z5U76Rhx5LzD2xT3wt2y5wzDBqwO/9F3eAl957SVDstOE1237i+3z3BvxlrhO4MTP6sqVog0Id/Wj0RXDi6c03SyfJCdhvv3uaJecbRWUErsibbqJenoF7tb78O6FCFvz+OgBrmjOWS5hpY2ilX8ANANCTXYKWmdqoAdfi6xNwqUtt8mrvFy1F9MFZPRN50B/MYhLvrBATQJhG6LyJljHNpVr1696/Yc374jozf8xB6CyTldPj+Vt0WVfbBMV4cJyaPQkrIv2+qyNWIBcGwVVqHc2aUqpv0LJMg30vUb5Bm80V6xrBQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5278.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(316002)(36756003)(2906002)(66556008)(26005)(86362001)(8676002)(508600001)(83380400001)(6666004)(7416002)(8936002)(7406005)(38350700002)(956004)(2616005)(186003)(44832011)(107886003)(6486002)(38100700002)(66476007)(7696005)(66946007)(4326008)(52116002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dL0Lm8pbDUTwCfPSmODCl92EP6qHV/FD88gEotLPBlr/jC+Af7bMbk5xqy38?=
 =?us-ascii?Q?mlGj3R9LQdsBpwMXMKO5fteC3HyAiYBbygwYWdVSxt5CVO94YNcx2REDS1ot?=
 =?us-ascii?Q?coAXBvSZpHFA3pVIFsmqAbkH7p06zMHhDwiU0lviDQQNCBpzqYqJC8j3iUsT?=
 =?us-ascii?Q?STAKLFhQVZdmQpDnBgrDx48ESSCwoQoQ3sET3s7wKGxewFWE9q0Ms79e2O83?=
 =?us-ascii?Q?E3WIfSuOobJtT1h9Btrp3ugY9COx9LJ8S8kSoVIhMTrjKqcARulcyLulH5Vq?=
 =?us-ascii?Q?HVN2cl1d2n3f6vfSvLAo7xSBY5UvH6aQEghiVpdrg4EhRyOZUKRN/kmWgk99?=
 =?us-ascii?Q?GhbRVIRL9oLS82mw8eK1R6tORFhyQvCSbBO2pC2B/nk7d5DLhNwMESTvF2Op?=
 =?us-ascii?Q?Nh6Num6s4iSCWBd1KvQMqPVRTsrhmvF6aL03IfSj4tnuGsadeyWBiuV2FTTo?=
 =?us-ascii?Q?IBparsfIpliuraexo0FEnH1vUQcJwHuUx9wf19J6nguKQh0DsSrn4jP4tbVJ?=
 =?us-ascii?Q?w9GmMgSr6bhbmzTiELuBqtxPrBoQf2QMrnG7RyZzdLTHhAFQp5gj1pi3ARyY?=
 =?us-ascii?Q?HvXZQd5Ppn/w98u9tgd6yz8unXmojScafS/k3rpkqX1X9e756QxBtSS71/j8?=
 =?us-ascii?Q?BMZFyOACiDOi7gNI+Ot6C51lWnzaVyVyfQCau2Z5vGFnXb+gz8ob/6Y7tsWm?=
 =?us-ascii?Q?Tb/5rLmdwtJwUhjRW6R+hs2g3c2Shkud+Akj2AKpkAsp+++9Z9X7R531RAPX?=
 =?us-ascii?Q?bW0Gl8jMtnt5ZA5IycWneaCDwunHhGqhj84VuIX7FpTgOAKtsALcd7Io5oR/?=
 =?us-ascii?Q?InKHN01+JvmCpuHEDqGtVFt4To9KFyiy2gy26KQ6m9tyOba+3oBZU2WQozHA?=
 =?us-ascii?Q?xhHY1eXPoJCrHhErVvDnJCO5Gkh1caSTMFUT1ZisXveOUw2JxyH+i7h3Dlif?=
 =?us-ascii?Q?3cidOPF2kDADHCVCymlp25F5NSRku/KgrPhaTROBzVacLjPrLRnNP8DafKtr?=
 =?us-ascii?Q?tG5MLS/7doasrZRoYpfPW7aKF8de4+K4jXcoznfcfpK4/FCypVgC+2pjIRyP?=
 =?us-ascii?Q?ISye+Zmmd6BPMUxUzHMn1w7W0ONnY/q/Frk/fk9wPxdw4tewjK3K2FEU9DEX?=
 =?us-ascii?Q?IXmQGLDMjDVK3t05oPvjg9hLrl5AyffrJdzQw1SLYv2a5WGqq/PcWpewIEH3?=
 =?us-ascii?Q?UlFvHJxc3OIfpGsHfLyc3NnRy7HY8GBfeosekPayJj9vlnGHSl22iHZyoTkZ?=
 =?us-ascii?Q?R/dB2rbOq6uRrqIk4yZt0ZQc2aRauEW3c6WlE9rOoB7dsJIu96vHRkzd1Fpc?=
 =?us-ascii?Q?hOAAQhyMMpCF8hqdE/MpbTgjpQe2ZPX/nhzlv8ZzhNXl2OxU/z1wu1ym4XtP?=
 =?us-ascii?Q?56NVbmGoICw4745z/t21hLOQnrnl1xGf4J91WWyw0rOVP9rPzUL50J5TxaBb?=
 =?us-ascii?Q?rzUiiBRp4ljFLtSTmA+8cKlm9/GLe7A4DV7tMNnLXA+UgBzv8+0vLQS8e/Vl?=
 =?us-ascii?Q?r2/kzHhz+sxYy39HZoTy9M72VIBAlxEoZlEJrb1GLtC23xMs5wRqUUfbBFMV?=
 =?us-ascii?Q?A8mm7rTjGlSE78WGC+2R4IbUPvK83ld+EN41cqf2+Fu86dlayPNQaQdXrEJ4?=
 =?us-ascii?Q?rrqPfJaHZ7sBE9sfnR5vr5M=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a624aba9-91d4-4eec-6acb-08d99eaf468c
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5278.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2021 09:49:49.2436
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qeKx8dezlbsR8PAd8yuRwKP+AuMPJ3GcDNvlztxFAAENU0Z31J2ctHZrZFoWshFBMlmcZuR5Nz2byOjB8dheJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2490
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10156 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 malwarescore=0
 mlxscore=0 suspectscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111030055
X-Proofpoint-ORIG-GUID: Sg-vJPoLRvC8oyn5yzt-B-MIo9Ce3Y9s
X-Proofpoint-GUID: Sg-vJPoLRvC8oyn5yzt-B-MIo9Ce3Y9s
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Exception handling is triggered in BPF tracing programs when
a NULL pointer is dereferenced; the exception handler zeroes the
target register and execution of the BPF program progresses.

To test exception handling then, we need to trigger a NULL pointer
dereference for a field which should never be zero; if it is, the
only explanation is the exception handler ran.  The skb->sk is
the NULL pointer chosen (for a ping received for 127.0.0.1 there
is no associated socket), and the sk_sndbuf size is chosen as the
"should never be 0" field.  Test verifies sk is NULL and sk_sndbuf
is zero.

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 tools/testing/selftests/bpf/prog_tests/exhandler.c | 45 ++++++++++++++++++++++
 tools/testing/selftests/bpf/progs/exhandler_kern.c | 35 +++++++++++++++++
 2 files changed, 80 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/exhandler.c
 create mode 100644 tools/testing/selftests/bpf/progs/exhandler_kern.c

diff --git a/tools/testing/selftests/bpf/prog_tests/exhandler.c b/tools/testing/selftests/bpf/prog_tests/exhandler.c
new file mode 100644
index 0000000..5999498
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/exhandler.c
@@ -0,0 +1,45 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2021, Oracle and/or its affiliates. */
+
+#include <test_progs.h>
+
+/* Test that verifies exception handling is working; ping to localhost
+ * will result in a receive with a NULL skb->sk; our BPF program
+ * then dereferences the an sk field which shouldn't be 0, and if we
+ * see 0 we can conclude the exception handler ran when we attempted to
+ * dereference the NULL sk and zeroed the destination register.
+ */
+#include "exhandler_kern.skel.h"
+
+#define SYSTEM(...)    \
+	(env.verbosity >= VERBOSE_VERY ?        \
+	 system(__VA_ARGS__) : system(__VA_ARGS__ " >/dev/null 2>&1"))
+
+void test_exhandler(void)
+{
+	struct exhandler_kern *skel;
+	struct exhandler_kern__bss *bss;
+	int err = 0, duration = 0;
+
+	skel = exhandler_kern__open_and_load();
+	if (CHECK(!skel, "skel_load", "skeleton failed: %d\n", err))
+		goto cleanup;
+
+	bss = skel->bss;
+
+	err = exhandler_kern__attach(skel);
+	if (CHECK(err, "attach", "attach failed: %d\n", err))
+		goto cleanup;
+
+	if (CHECK(SYSTEM("ping -c 1 127.0.0.1"),
+		  "ping localhost",
+		  "ping localhost failed\n"))
+		goto cleanup;
+
+	if (CHECK(bss->exception_triggered == 0,
+		  "verify exceptions were triggered",
+		  "no exceptions were triggered\n"))
+		goto cleanup;
+cleanup:
+	exhandler_kern__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/exhandler_kern.c b/tools/testing/selftests/bpf/progs/exhandler_kern.c
new file mode 100644
index 0000000..4049450
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/exhandler_kern.c
@@ -0,0 +1,35 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2021, Oracle and/or its affiliates. */
+
+#include "vmlinux.h"
+
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+#include <bpf/bpf_core_read.h>
+
+char _license[] SEC("license") = "GPL";
+
+unsigned int exception_triggered;
+
+/* TRACE_EVENT(netif_rx,
+ *         TP_PROTO(struct sk_buff *skb),
+ */
+SEC("tp_btf/netif_rx")
+int BPF_PROG(trace_netif_rx, struct sk_buff *skb)
+{
+	struct sock *sk;
+	int sndbuf;
+
+	/* To verify we hit an exception we dereference skb->sk->sk_sndbuf;
+	 * sndbuf size should never be zero, so if it is we know the exception
+	 * handler triggered and zeroed the destination register.
+	 */
+	__builtin_preserve_access_index(({
+		sk = skb->sk;
+		sndbuf = sk->sk_sndbuf;
+	}));
+
+	if (!sk && !sndbuf)
+		exception_triggered++;
+	return 0;
+}
-- 
1.8.3.1

