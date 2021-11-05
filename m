Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06E3F446799
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 18:11:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232818AbhKEROA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 13:14:00 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:7610 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229569AbhKERN7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Nov 2021 13:13:59 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A5Ft6Ol003132;
        Fri, 5 Nov 2021 17:10:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=WduBE2B0N+x/bZpKLXyB/mVPPHOQDlzqH2vvnlr6tlM=;
 b=d4IAbAdW3IBShSyd8xovVFJV9R70EL+pVhy7svWPC0EyCCtp9B5n3fuvFLfxih+nPw7k
 wVNsoeYMKRqbGbXm7LbIF9xK4dBtVW9u9KgY7XG+49Jp9AoWQ9o6j1zcXBHg2VPmzjjg
 t3ZHY84zU6Fa8drQNjSf2FIIUzJL9jzO8qyHTk418X781b8HOAupbwlU5GhPXJeI/b6V
 gX0i0NWdzQQt0nCAx621paKOppIHg1y6XhiRTA7j9f9qkWnmLbqg0i/jQj/uS7f65A3e
 vGMzbjbIJbzKvRKIPDNAxBulak6UNVRkGg6gOJW1n/VH+2sZniZH0tP2SWq55J9JY+nW Ng== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c4t7bum6s-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Nov 2021 17:10:41 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A5GeRN3074882;
        Fri, 5 Nov 2021 16:51:06 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by userp3020.oracle.com with ESMTP id 3c4t61fvpk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Nov 2021 16:51:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cqCs6ZLbQAj97I3d4mGyW/VlNET6MVT7bqNK4aBZvPRChJPBjFF5tbQxmh6SpN7nduURoPV9dQhW7Dx1KWYwIFf41OBHDFbx/elxDoNB9Y7QbQjpMMLAL7adhx8LSd69M439g6/OExNifit/i4kzSUqUFSGu6JYCzqswzTQMKA/R1Ycmp/o3MD/pbVISIXVBwmlajQF7SwLNcSRC/J67v4f8CvbtHPLxBFq4x8iEjWPpdInTvMr+cjk7MXxLDPE7ik8qXRgOqwbSNjbZJ4q7qm5+b5QS2WDn+UqBqNtaho0gyTptlNS0O+vdl4VZ6ttivfoCbnKGU6gk5th1bPItwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WduBE2B0N+x/bZpKLXyB/mVPPHOQDlzqH2vvnlr6tlM=;
 b=fMO9g9a17K663hk83lxie0VoH6qNpH7z+Yehj5QLAdWchcmJluvcAWMHO0idXwoGczzDThcEHC6mA4V5Xk06wInLGDQMqn+ruqoQjn81wO/+1gnT28YidX174Ugn+1I46E3dCb9EwB86nK5BVtarrgG5R8YHisHwKKXmrADdlUP6gbLGnbSXZC9R9g5/b/df4q+5FwOYeWDK+TtHJUdvuV+DnaCkVu9ci8f11pbKb7VNBIeNlAdGvsl4s9PtotmyKpRuQcVjzrXZHdp68IKDoRVsE8b9p97Rhb3dUB2ayUMbAukWoHSm8VjSvvHlOE5m8xhVxyxOUB4JPkxU5VdIYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WduBE2B0N+x/bZpKLXyB/mVPPHOQDlzqH2vvnlr6tlM=;
 b=QGSUNB9RWCP0L7aVipaMvDRtOu3PiKRpu9h9kGLQRrO+CN+xBTSDWRXV9vjAOGROPvIX9z4ry8pbsqM+udtESaUAbHdswxTybOcSjYHJ4dYyBKdOvYnmtzHfc6OO0BJux4XAQTobGZyU+2/r5b3ShA1fcf2iwddN2O76ofnu9D4=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by MN2PR10MB3213.namprd10.prod.outlook.com (2603:10b6:208:131::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.13; Fri, 5 Nov
 2021 16:51:03 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::998f:e9eb:ec26:1334]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::998f:e9eb:ec26:1334%7]) with mapi id 15.20.4669.013; Fri, 5 Nov 2021
 16:51:03 +0000
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
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH v2 bpf-next 2/2] selftests/bpf: add exception handling selftests for tp_bpf program
Date:   Fri,  5 Nov 2021 16:50:46 +0000
Message-Id: <1636131046-5982-3-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1636131046-5982-1-git-send-email-alan.maguire@oracle.com>
References: <1636131046-5982-1-git-send-email-alan.maguire@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: AM9P192CA0024.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:21d::29) To BLAPR10MB5267.namprd10.prod.outlook.com
 (2603:10b6:208:30e::22)
MIME-Version: 1.0
Received: from localhost.uk.oracle.com (138.3.204.60) by AM9P192CA0024.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:21d::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.17 via Frontend Transport; Fri, 5 Nov 2021 16:50:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9748385b-fe20-4f99-f403-08d9a07c73d2
X-MS-TrafficTypeDiagnostic: MN2PR10MB3213:
X-Microsoft-Antispam-PRVS: <MN2PR10MB3213D6E65E95AE8CBAF1DDC7EF8E9@MN2PR10MB3213.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OSt5EXZEoHAAC6WWxNsw88EqeXBfSx12EWVhR7QS8E5KumUhtES3Cb8SL0ha0N5zhkszS/0XmUmRl5D1u6z1SqbOJ+kBKu8s4Aa14NNk5NanzXQCgnOgsr1jMaPhayIsVMQrg6cT82HDGc7FOA7dqW3whDE0uYt5MAwK1Bk61UAeB3VmsXKsEEs1ABSA3S6HovfxYKwll2NITQQqVLc9d3FElv0WrLvfWIhCd490ko8uKnPyC7FdqMO01Y60giO6Y4lSTyN1EJncKYzD+GxK9jphNH6gwE0L4lVU+OHrIbXML3zWvr2ihzjLn8n/q3c+p96EZUU0smVjbU+uJoiQCNMZ3r1Nen1/9gY+OYpfaz2Rrrl1nTKSWs+h0cwOxP3ZEioB8AIamMJTbep+B5OIvEUQVSZzVZJrc37KeaULqPgSQnKRbVHAg75+wIfESmPWT+2V4f+qARhfXdVfI2QzdLWGtj8xyGbrUzL+fTn1WftaAdfXqrjyEUVflF8vUKFknH+faXEuT/Ev5eRen4Hk3P0Chq1ZyM/4LCBX5CKSQtMItDwPChpJUr/WEZUm6gKl/6MBlPZTfGmRZ8ejarVlu7dDWdcqW4uyEyjq2ZZUUiaZh0QB/jeze0HYfHAEyrvSEvkLyxw/i1N/UZaHylWuxtz0I08g8O+6Z6PIIPnU6gbS+GrcZ0z86adpoy/dH3YDXUvIdNmqzh+iKa3iLNqTwg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(186003)(8676002)(44832011)(36756003)(107886003)(2906002)(956004)(2616005)(66946007)(508600001)(66556008)(66476007)(316002)(4326008)(8936002)(38350700002)(83380400001)(52116002)(7696005)(6666004)(38100700002)(5660300002)(86362001)(7416002)(26005)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mSgiylU6gwdSkQ+FV1eZWk+Dcpgxr6wx39dSacTattWr1AQUtXQfH1e9DOe6?=
 =?us-ascii?Q?VSelrm6ywZfO/EjsJhNIK+3SL7MYb3fSIL5xGg5XBSmP9Tlnsw/ZgTGzxhC0?=
 =?us-ascii?Q?PFSQ2ijkGDKIycasLa4sWoENefFU8cVDL36rmQDviUQDtmMFLilEDyIxzAIX?=
 =?us-ascii?Q?gUvtSC7E1ckOd18KyqlaRCuxlj20AlGnViiEySR/HEqbEtSavqoyDcogF4bC?=
 =?us-ascii?Q?9JSfkSzIidCBHsm4ZsyvH1atN4+78YS2oFHUj5YQAacfhYviUwbRx9kvW/h2?=
 =?us-ascii?Q?BUVu79jgBSWB/OqVkvub37Z+7U28wVAvptOOQ81jJkbppi2ySR/kCPO1w7eE?=
 =?us-ascii?Q?BdKWtM1mFdiSkaUsu1l+VDsLYXBdZ4Knmi4vD7Q7mwgAwyuvvTkO9acVYfFN?=
 =?us-ascii?Q?3A//HbtDqGPVVPByhanRKp9bH0GPh6HDLAQ5cn+bPdr48Ebgkhvs3ZDkmegn?=
 =?us-ascii?Q?5mEO+cRIfXwsY8fQLt+tE7oMrgtkmtlNL8sJyLp+jOmoq2M3dfIyCh6mT8qk?=
 =?us-ascii?Q?cAo9hox+3qdUPPrHW9qyRLU1jNdupctVZSkbYclmFJbUwtakitxObBrcowBy?=
 =?us-ascii?Q?WK5YpePZuS8Esbn8j1m437MUPz3MCSS61Bg+b8vvihUL32S48WaFHnsPSg7L?=
 =?us-ascii?Q?Fb+kcF6eG2Up2db+xcbnDidCEFbzPpw9xmDG+v1xrbKdjOnEFy/b2lyIrPWW?=
 =?us-ascii?Q?Fj0vC00tQp2cBL7GFxlqOUGI76CMFNOh5KL9vUHwJREhzHqzvo5aT7B74Y6y?=
 =?us-ascii?Q?DslwY6AEoejMR65O7X3Acj21yrNJRM49WgPfHUx5moILgTFHnXxcHMHklcLC?=
 =?us-ascii?Q?GDj2i228Gun0pwI4wkSy+36YeyJRhGspn67T8bEqaBTG7uSNGOlC+KL6y9A+?=
 =?us-ascii?Q?F88q3D58NX7V+rDWEo44+URAHmaLESqwYx6Tb17pILNV3mFoGdD0kfsJX6J7?=
 =?us-ascii?Q?IdSoaeltvVo1POZBC3OvGPYmpwKBRYLhCbAx4EBKg9DTdVD4th83d8dk4nZy?=
 =?us-ascii?Q?xRKq9gg048dgBghFdOByqfj9db39M6BxuDg+ZlB+HDbbm/E3wz4BrGEZ57Ov?=
 =?us-ascii?Q?WuGLOLnngxceO8xt9DQ/HYAm5MrbXn8ni9hcR2aCZrkSkG9J0eG828a2VBAT?=
 =?us-ascii?Q?hWY3fPzUp8RysE4ybjf9L0uGsD6U7Je08HmShmsuP3GF3o439PGLSPihURKW?=
 =?us-ascii?Q?JZjzppPuzGMYgUGSEhf6XgyMsZVQjlanGQ2wMi+xUB2ApgtCX8U6mzsS5UpG?=
 =?us-ascii?Q?oXrfGXih6K1lWQy0jyumRz75BmpJZJP1xKjABWw60eX3bQoDW6JvQJVVCPtD?=
 =?us-ascii?Q?gdIPcljI4h80R/66HRxqzsoyujA94V1eWGJ/9kQ5QVr6rxUpCamnBPPCoHhZ?=
 =?us-ascii?Q?+LqeeV5emkT4hy3H69taMTGMTgljQ+3U42IiGXcACLY4PvyBOiVLY41q3QwX?=
 =?us-ascii?Q?WM9DsjFH/kNDfnvK6gq9dNs0VOOc1xsJLWIEersgQVHNC7xQtHpTiL3gXLpc?=
 =?us-ascii?Q?hbs1YN/0AjNMCuokdYLj5IS9yzkxPIIesmzdkFDuezg0N8JpPGnNArakuU3M?=
 =?us-ascii?Q?Mwf8sKvtUbK7Ej5N3VfuZQDgEy/lyVUynXNryFDI/+yeqhmppArivfuajxwW?=
 =?us-ascii?Q?bVFIhmRDA9r5NqHM6EIIPG0=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9748385b-fe20-4f99-f403-08d9a07c73d2
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2021 16:51:03.2266
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DWIuoyGOG/56aAE+m1LUSSO4nor+uajthszMCfd9Gql/HHy6vYU9H9NQQJl7l633heDs+MAoaUtjROQu52KcYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3213
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10159 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 mlxscore=0
 spamscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111050094
X-Proofpoint-GUID: -UnUb5oHowJ45UQWeRycCt1MBUNiyBKd
X-Proofpoint-ORIG-GUID: -UnUb5oHowJ45UQWeRycCt1MBUNiyBKd
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Exception handling is triggered in BPF tracing programs when
a NULL pointer is dereferenced; the exception handler zeroes the
target register and execution of the BPF program progresses.

To test exception handling then, we need to trigger a NULL pointer
dereference for a field which should never be zero; if it is, the
only explanation is the exception handler ran.  task->task_works
is the NULL pointer chosen (for a new task from fork() no work
is associated), and the task_works->func field should not be zero
if task_works is non-NULL.  Test verifies task_works and
task_works->func are 0.

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 tools/testing/selftests/bpf/prog_tests/exhandler.c | 43 ++++++++++++++++++++++
 tools/testing/selftests/bpf/progs/exhandler_kern.c | 43 ++++++++++++++++++++++
 2 files changed, 86 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/exhandler.c
 create mode 100644 tools/testing/selftests/bpf/progs/exhandler_kern.c

diff --git a/tools/testing/selftests/bpf/prog_tests/exhandler.c b/tools/testing/selftests/bpf/prog_tests/exhandler.c
new file mode 100644
index 0000000..118bb18
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/exhandler.c
@@ -0,0 +1,43 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2021, Oracle and/or its affiliates. */
+
+#include <test_progs.h>
+
+/* Test that verifies exception handling is working. fork()
+ * triggers task_newtask tracepoint; that new task will have a
+ * NULL pointer task_works, and the associated task->task_works->func
+ * should not be NULL if task_works itself is non-NULL.
+ *
+ * So to verify exception handling we want to see a NULL task_works
+ * and task_works->func; if we see this we can conclude that the
+ * exception handler ran when we attempted to dereference task->task_works
+ * and zeroed the destination register.
+ */
+#include "exhandler_kern.skel.h"
+
+void test_exhandler(void)
+{
+	int err = 0, duration = 0, status;
+	struct exhandler_kern *skel;
+	pid_t cpid;
+
+	skel = exhandler_kern__open_and_load();
+	if (CHECK(!skel, "skel_load", "skeleton failed: %d\n", err))
+		goto cleanup;
+
+	skel->bss->test_pid = getpid();
+
+	err = exhandler_kern__attach(skel);
+	if (!ASSERT_OK(err, "attach"))
+		goto cleanup;
+	cpid = fork();
+	if (!ASSERT_GT(cpid, -1, "fork failed"))
+		goto cleanup;
+	if (cpid == 0)
+		_exit(0);
+	waitpid(cpid, &status, 0);
+
+	ASSERT_NEQ(skel->bss->exception_triggered, 0, "verify exceptions occurred");
+cleanup:
+	exhandler_kern__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/exhandler_kern.c b/tools/testing/selftests/bpf/progs/exhandler_kern.c
new file mode 100644
index 0000000..f5ca142
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/exhandler_kern.c
@@ -0,0 +1,43 @@
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
+int test_pid;
+
+/* TRACE_EVENT(task_newtask,
+ *         TP_PROTO(struct task_struct *p, u64 clone_flags)
+ */
+SEC("tp_btf/task_newtask")
+int BPF_PROG(trace_task_newtask, struct task_struct *task, u64 clone_flags)
+{
+	int pid = bpf_get_current_pid_tgid() >> 32;
+	struct callback_head *work;
+	void *func;
+
+	if (test_pid != pid)
+		return 0;
+
+	/* To verify we hit an exception we dereference task->task_works->func.
+	 * If task work has been added,
+	 * - task->task_works is non-NULL; and
+	 * - task->task_works->func is non-NULL also (the callback function
+	 *   must be specified for the task work.
+	 *
+	 * However, for a newly-created task, task->task_works is NULLed,
+	 * so we know the exception handler triggered if task_works is
+	 * NULL and func is NULL.
+	 */
+	work = task->task_works;
+	func = work->func;
+	if (!work && !func)
+		exception_triggered++;
+	return 0;
+}
-- 
1.8.3.1

