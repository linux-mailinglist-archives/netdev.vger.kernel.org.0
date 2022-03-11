Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3FD14D614A
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 13:12:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348103AbiCKMMo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 07:12:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347911AbiCKMMk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 07:12:40 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0619817AEE1;
        Fri, 11 Mar 2022 04:11:34 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22BBeGs9024109;
        Fri, 11 Mar 2022 12:11:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=o+crwmIaRiur1B8tccY50Nwg6siAf4qC4X9Mad9uEjw=;
 b=oWqF0E7d7OwQswuv8wszRQtcTjWuSRs8P1MkcSxL/A0efyBRF2WPZhKLC6CABSHdfm5b
 mov4MQXoN2wmzkqLsn4hwH1wvVi0zL9N2Jii7hvRws315VnePslf6IEeBlNCRs6br2HW
 +I+JWNwRVIVr3kdlh/uZrQmsDTu5leSUI0yWy5UXREqEavTtMK+YajCcciwZYxcKjcV8
 ApQ74oqAVW5OWbMvn8vGvLW4CZxKM7z/xX7Tcv0VRN0dhhU9DRLb7mxMS5QzJeeYZmKh
 4/ZekW5fYFrawxOfugw0JU6S1H0FBlPdkZFwGCwS/SWzM7t0AakcIjgSTa2Id0jOMvBL jw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ekx9creuu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Mar 2022 12:11:15 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22BC0UM6117764;
        Fri, 11 Mar 2022 12:11:14 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
        by userp3030.oracle.com with ESMTP id 3ekvyxjce0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Mar 2022 12:11:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LMRdp6dU8HiSsA+15FGJZdE8TJjPH/MEhqU1DyE7LZwZ/BgN9OqdoNoVYvIiIP0nKF5YFFJ5ZgBT5ojV7j34X99KW8eo8+LM5a5XgnVdKKSqkhxT8PNkksTkuovDxhs/GSitAPnq0sWdBNrHbsewwFBiFoXBzHNcqwuh/MvGCIEiBjdtb5FSak5kIUDAgz9YeS1yCSU/X+YWCgrG3NR7JB+sy1Jbd965sJNNk3HIJyDcW7bL6fo136wLDO2QHH0zeh6I8/YxVhwx8fByHTDM8eX9OHbWR6nFdc9EGa8LWYgpBTwj+L+c9Fzwe3k+RMz1ms1UHLw182PJHSP2+gBSBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o+crwmIaRiur1B8tccY50Nwg6siAf4qC4X9Mad9uEjw=;
 b=f3lO6u0lj9+thC/dOgGqQekufJUFSBNEH9lD0Ej1m0GEE5lb3HptHiQufh/4JgNQcd9ag8Z/R+xdoodAfqfjJUyR27Ja61ku4s67rMpHLexzktd83zLMNSa2StBIO5ZaEup52lbk0JF/t5Jnp7ONnv0/oINI+vJ7ntwtFVnfy4mPDcjxE30SXsYlHW4qcOCKfLOwicO0Qt76Xw9MBFkw09KNX07+J/P2eXWeBgum9pNg5bbzV5u3PB82B0rzYMeO7778LnsB2rf/94a59pLgJaoSjPOoo8yz9iMRHbe/v6SjM/1tVIyXS+rymPaEFqQGq3B/O7RcXuIje0ElOtF0xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o+crwmIaRiur1B8tccY50Nwg6siAf4qC4X9Mad9uEjw=;
 b=toHr3i3juz6jPildNiAQf4u33IbeXSJcenyjXWYXgqOyxv22nBOSP/yA4/IiYrkySZZ/eO+CWvlTraxQtfcPduKu3BlQ+TwbLxWhqhzxKaWLNNB2rmtZxiXKH569LOGI0O0Mn0gxnZ4NQA2Cpp8eQfANDIDuZSCJjZ79qKFyVmw=
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by SJ0PR10MB4784.namprd10.prod.outlook.com (2603:10b6:a03:2d4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Fri, 11 Mar
 2022 12:11:11 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::517b:68:908d:b931]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::517b:68:908d:b931%3]) with mapi id 15.20.5061.024; Fri, 11 Mar 2022
 12:11:11 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, toke@redhat.com,
        sunyucong@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH v4 bpf-next 4/5] selftests/bpf: add tests for u[ret]probe attach by name
Date:   Fri, 11 Mar 2022 12:10:57 +0000
Message-Id: <1647000658-16149-5-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1647000658-16149-1-git-send-email-alan.maguire@oracle.com>
References: <1647000658-16149-1-git-send-email-alan.maguire@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0335.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18c::16) To BLAPR10MB5267.namprd10.prod.outlook.com
 (2603:10b6:208:30e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b3d2775f-67dc-4a2e-a2ba-08da03583b4f
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4784:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4784A61209D20AC49C917AD1EF0C9@SJ0PR10MB4784.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LLLeAJNAQnum0e+X5EWHmJc2alR+w/W0hpmHbCIfRZTGwWklLc8CtVww0H1R3ClcNA/spuvK9ROYjtV2lw8iq0AsUgN4AkSEnYeDMWb6c5SAbUIvZgZIeiMT2bd+/97rtCQTBdjIEa3TKOs/6yAJQn2hFvk7A/YfV5x6izKfP+9A0MHCmNCVKLThmXq4YXpBvpWdjsijMPjeXtfXfuDLSSuOML7r6A9q+rA6znS1BK4TGlIcTJBHVd6Eg5PwfnJF6f+bUmVP4fjrrXnKaOsCMcf/GFF90dY3ms7XnYbpYZS836b0jUyCxETgrSFQyMeqVl+jhiTssj4bZYD7FSFVwryO0ihm5pGj+GhccKB3hMqS6lP2XiTodsn4cAfyqiKmzDf8ZzZ9J/jjxSCupdblQcJK+FHTp1eHAitK1XzZ0cxk70m2P072Z434E6gvaT2m2h2Rn/gmRjitxLkawg+ak6o+8AHiVeblRoWGx3IietORHR4MpYH6WIJJskL/suMlBqfrdkX8Obztw3WBC/dnkLeQkU5+JiR6fqW+yk7ps39hjwfQBOX7yRRvdLfI4f/5sbvFcjLmmwugfIaRXwRKReH+GmuYfyGTTzh+lrl7MC+QbZsLeV/WZSRR16lkhwXKmxP2UUFG1LNAqV2JqVXQSaYWmL6eEEyoqVwH5l5jwT23X5yNh/sg/9lMdEW9o4aCJcdFvKya5/63dR746efhNw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38350700002)(2616005)(66946007)(36756003)(7416002)(83380400001)(316002)(38100700002)(6666004)(86362001)(508600001)(5660300002)(44832011)(6506007)(8936002)(52116002)(26005)(6512007)(186003)(2906002)(107886003)(66476007)(8676002)(4326008)(6486002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ruBgXkj/km9jRYiIv+lR0mLWcFS+H1QJZ2Lej4/o5tVJxwRbP6dRtp/IG9Zh?=
 =?us-ascii?Q?6TT0B58uGcivDEMogH6LxdLCiJa6yMMcDrYfHLkHtd5ePH6S02R7JjDJ13Jp?=
 =?us-ascii?Q?o7Hx6RtbMJZxkz0bUDHg/ecQH/vfkITA0IIgV7d4M06ONJNmtceeBsXwBmTK?=
 =?us-ascii?Q?AGk6Kfm4dhP1gASTbSYf7XiLNoLqQ3v+rqOyTBzABqYzlZXLbaIqs3yIEzot?=
 =?us-ascii?Q?c2pkeSe1ILeJ3ZJJirt4E+cYnHobdsQkszR1kUB+bgY/C3w7DL/LQ9i9duum?=
 =?us-ascii?Q?9TFEHNHVwRq3Kgb1sac6aCE22ivCwV6pyK8arGY3wGxebdK+lXCFjdlfOmkO?=
 =?us-ascii?Q?1xguqvFETbCwe1tWR8NMZqQkfYhuc1Ma14kl2I5xzOhuk5JagRyIbIu+SLLj?=
 =?us-ascii?Q?+b6v0im2ZX4yUgxtt99DPCO1CM53yWSYg+lqIuE2N8vohf4cuM2zTYmnbGhQ?=
 =?us-ascii?Q?SePDVlkp63IweDwSh2wx2r+QiAtnXKiQp49HJcL7LH0mdeESxxnoOdMOd9AH?=
 =?us-ascii?Q?ZatmwK8oSI4m2jCFulVXnlH8E6zWqDgdpom+J9/r8dXIyTLXznz4BruYL7+d?=
 =?us-ascii?Q?0RYkN61LwpGhdfE+NBNj6V1ynBOsgk95l0TW2RJdlb3sBM0gCkYuKvsSv+LY?=
 =?us-ascii?Q?ppwl38K5ePfVrX7h10mkFGvw6NxJChpWTlTawC+ijR9DSAEgrGG7H425QqU4?=
 =?us-ascii?Q?n4aR7Yh6aVTEjywYCTv7Cfl9CY85J7W+svVmebKd596xhNfsRf84axYvbjYz?=
 =?us-ascii?Q?70rPJbQponrguNqbRWLb8A2dCL/EUrTWP1eXbzVDoCuVmV7fkAFckMOewQd/?=
 =?us-ascii?Q?MNYJSixnRN4Hfi3Z1KZ0exbtTT8AcTOD8SatP3AkfVWLimak3BfFkXLqTOnw?=
 =?us-ascii?Q?fYu4epy3AVDUFkCLuOATZF2BTV1Pf0qe9v4HBfybzjRDL+UHXhmvpuDXGw2M?=
 =?us-ascii?Q?G4yW+lrChcz7CduK6rnFis9xY2ApD55D1yNC2jB0rd3quqRZXnwNo6VLF/7P?=
 =?us-ascii?Q?OIOZ6VhT2sGFAgkARgqy8fdULUIFDUBltX8phziHW0L2jVhnGVxx7PC/RizH?=
 =?us-ascii?Q?8LbKfEPONPrQa9DhsMxMa10gYsUhpJHoZtRJYPGpUWcesa5PyFrw81bokrkr?=
 =?us-ascii?Q?29+emO9YMr20uDYBsOLpg2Kg+JOV5LlAG+DTC8HtHr1f7bk/Y71DshM8WeZd?=
 =?us-ascii?Q?SR9dWGL55dNYULHQUki6JmIvvecSTbciEeS+4XMQpzelXKI1Gu9MDJafOINz?=
 =?us-ascii?Q?hzlXRBC5yGRV7v8GInDE/YxBoFhAaAzREfGPCuvWYaWzmdmIf9ECfutKHAhN?=
 =?us-ascii?Q?ONsuzTZTyMrh/S0KPW5uXLOwBj5N5kuIji3b32m5SbcpAb8uDJ73cUVgLzJE?=
 =?us-ascii?Q?a5JChEKds/ySFXNCjrSQCh9VD/vuXiRpPvMGROm+BNlLdbtYhk7U6KJGkCHq?=
 =?us-ascii?Q?HOyaO65C9+F/UpL7GQq8I/614OFCtgLGDNZ/o2HthmHATAmQ0pI/vldiYE/p?=
 =?us-ascii?Q?tnYziRncr2TAEozN3NX/oJW0UxBIKw91j7Q/tLRYoQXpA5AglIwB1Yjs/SX8?=
 =?us-ascii?Q?mABoURhPPKGcb8pX5bEY9EPF0vWX81I1QXl20SkSmBnpMtyXFvC2ziyBHodB?=
 =?us-ascii?Q?5DX734lva0Jy8o0lK4cZPXM=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3d2775f-67dc-4a2e-a2ba-08da03583b4f
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2022 12:11:11.5926
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: haIAZiyAS8JRkcjEvGpPEcwqwZfNy4DeC34PqRjlrLLBTF2mCLnX87JRFHZNmQBhEZDH9Kny1uNqogvifHBk5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4784
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10282 signatures=692556
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 suspectscore=0 bulkscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203110059
X-Proofpoint-ORIG-GUID: rpKjM3Ogzj13YCX5ZWTbVbCJIRuBHPNW
X-Proofpoint-GUID: rpKjM3Ogzj13YCX5ZWTbVbCJIRuBHPNW
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

add tests that verify attaching by name for

1. local functions in a program
2. library functions in a shared object; and
3. library functions in a program

...succeed for uprobe and uretprobes using new "func_name"
option for bpf_program__attach_uprobe_opts().  Also verify
auto-attach works where uprobe, path to binary and function
name are specified, but fails with -EOPNOTSUPP when the format
does not match (the latter is to support backwards-compatibility).

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 .../selftests/bpf/prog_tests/attach_probe.c        | 89 ++++++++++++++++++----
 .../selftests/bpf/progs/test_attach_probe.c        | 37 +++++++++
 2 files changed, 113 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/attach_probe.c b/tools/testing/selftests/bpf/prog_tests/attach_probe.c
index d48f6e5..b770e0e 100644
--- a/tools/testing/selftests/bpf/prog_tests/attach_probe.c
+++ b/tools/testing/selftests/bpf/prog_tests/attach_probe.c
@@ -11,15 +11,22 @@ static void trigger_func(void)
 	asm volatile ("");
 }
 
+/* attach point for byname uprobe */
+static void trigger_func2(void)
+{
+	asm volatile ("");
+}
+
 void test_attach_probe(void)
 {
 	DECLARE_LIBBPF_OPTS(bpf_uprobe_opts, uprobe_opts);
-	int duration = 0;
 	struct bpf_link *kprobe_link, *kretprobe_link;
 	struct bpf_link *uprobe_link, *uretprobe_link;
 	struct test_attach_probe* skel;
 	ssize_t uprobe_offset, ref_ctr_offset;
+	struct bpf_link *uprobe_err_link;
 	bool legacy;
+	char *mem;
 
 	/* Check if new-style kprobe/uprobe API is supported.
 	 * Kernels that support new FD-based kprobe and uprobe BPF attachment
@@ -43,9 +50,9 @@ void test_attach_probe(void)
 		return;
 
 	skel = test_attach_probe__open_and_load();
-	if (CHECK(!skel, "skel_open", "failed to open skeleton\n"))
+	if (!ASSERT_OK_PTR(skel, "skel_open"))
 		return;
-	if (CHECK(!skel->bss, "check_bss", ".bss wasn't mmap()-ed\n"))
+	if (!ASSERT_OK_PTR(skel->bss, "check_bss"))
 		goto cleanup;
 
 	kprobe_link = bpf_program__attach_kprobe(skel->progs.handle_kprobe,
@@ -90,24 +97,80 @@ void test_attach_probe(void)
 		goto cleanup;
 	skel->links.handle_uretprobe = uretprobe_link;
 
-	/* trigger & validate kprobe && kretprobe */
-	usleep(1);
+	/* verify auto-attach fails for old-style uprobe definition */
+	uprobe_err_link = bpf_program__attach(skel->progs.handle_uprobe_byname);
+	if (!ASSERT_EQ(libbpf_get_error(uprobe_err_link), -EOPNOTSUPP,
+		       "auto-attach should fail for old-style name"))
+		goto cleanup;
 
-	if (CHECK(skel->bss->kprobe_res != 1, "check_kprobe_res",
-		  "wrong kprobe res: %d\n", skel->bss->kprobe_res))
+	uprobe_opts.func_name = "trigger_func2";
+	uprobe_opts.retprobe = false;
+	uprobe_opts.ref_ctr_offset = 0;
+	skel->links.handle_uprobe_byname =
+			bpf_program__attach_uprobe_opts(skel->progs.handle_uprobe_byname,
+							0 /* this pid */,
+							"/proc/self/exe",
+							0, &uprobe_opts);
+	if (!ASSERT_OK_PTR(skel->links.handle_uprobe_byname, "attach_uprobe_byname"))
 		goto cleanup;
-	if (CHECK(skel->bss->kretprobe_res != 2, "check_kretprobe_res",
-		  "wrong kretprobe res: %d\n", skel->bss->kretprobe_res))
+
+	/* verify auto-attach works */
+	skel->links.handle_uretprobe_byname =
+			bpf_program__attach(skel->progs.handle_uretprobe_byname);
+	if (!ASSERT_OK_PTR(skel->links.handle_uretprobe_byname, "attach_uretprobe_byname"))
 		goto cleanup;
 
+	/* test attach by name for a library function, using the library
+	 * as the binary argument. libc.so.6 will be resolved via dlopen()/dlinfo().
+	 */
+	uprobe_opts.func_name = "malloc";
+	uprobe_opts.retprobe = false;
+	skel->links.handle_uprobe_byname2 =
+			bpf_program__attach_uprobe_opts(skel->progs.handle_uprobe_byname2,
+							0 /* this pid */,
+							"libc.so.6",
+							0, &uprobe_opts);
+	if (!ASSERT_OK_PTR(skel->links.handle_uprobe_byname2, "attach_uprobe_byname2"))
+		goto cleanup;
+
+	uprobe_opts.func_name = "free";
+	uprobe_opts.retprobe = true;
+	skel->links.handle_uretprobe_byname2 =
+			bpf_program__attach_uprobe_opts(skel->progs.handle_uretprobe_byname2,
+							-1 /* any pid */,
+							"/proc/self/exe",
+							0, &uprobe_opts);
+	if (!ASSERT_OK_PTR(skel->links.handle_uretprobe_byname2, "attach_uretprobe_byname2"))
+		goto cleanup;
+
+	/* trigger & validate kprobe && kretprobe */
+	usleep(1);
+
+	/* trigger & validate shared library u[ret]probes attached by name */
+	mem = malloc(1);
+	free(mem);
+
 	/* trigger & validate uprobe & uretprobe */
 	trigger_func();
 
-	if (CHECK(skel->bss->uprobe_res != 3, "check_uprobe_res",
-		  "wrong uprobe res: %d\n", skel->bss->uprobe_res))
+	/* trigger & validate uprobe attached by name */
+	trigger_func2();
+
+	if (!ASSERT_EQ(skel->bss->kprobe_res, 1, "check_kprobe_res"))
+		goto cleanup;
+	if (!ASSERT_EQ(skel->bss->kretprobe_res, 2, "check_kretprobe_res"))
+		goto cleanup;
+	if (!ASSERT_EQ(skel->bss->uprobe_res, 3, "check_uprobe_res"))
+		goto cleanup;
+	if (!ASSERT_EQ(skel->bss->uretprobe_res, 4, "check_uretprobe_res"))
+		goto cleanup;
+	if (!ASSERT_EQ(skel->bss->uprobe_byname_res, 5, "check_uprobe_byname_res"))
+		goto cleanup;
+	if (!ASSERT_EQ(skel->bss->uretprobe_byname_res, 6, "check_uretprobe_byname_res"))
+		goto cleanup;
+	if (!ASSERT_EQ(skel->bss->uprobe_byname2_res, 7, "check_uprobe_byname2_res"))
 		goto cleanup;
-	if (CHECK(skel->bss->uretprobe_res != 4, "check_uretprobe_res",
-		  "wrong uretprobe res: %d\n", skel->bss->uretprobe_res))
+	if (!ASSERT_EQ(skel->bss->uretprobe_byname2_res, 8, "check_uretprobe_byname2_res"))
 		goto cleanup;
 
 cleanup:
diff --git a/tools/testing/selftests/bpf/progs/test_attach_probe.c b/tools/testing/selftests/bpf/progs/test_attach_probe.c
index 8056a4c..9942461c 100644
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
@@ -39,4 +43,37 @@ int handle_uretprobe(struct pt_regs *ctx)
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
+SEC("uretprobe//proc/self/exe:trigger_func2")
+int handle_uretprobe_byname(struct pt_regs *ctx)
+{
+	uretprobe_byname_res = 6;
+	return 0;
+}
+
+SEC("uprobe/trigger_func_byname2")
+int handle_uprobe_byname2(struct pt_regs *ctx)
+{
+	unsigned int size = PT_REGS_PARM1(ctx);
+
+	/* verify malloc size */
+	if (size == 1)
+		uprobe_byname2_res = 7;
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

