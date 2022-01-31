Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 957C44A4B87
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 17:13:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349733AbiAaQNJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 11:13:09 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:42186 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232033AbiAaQNH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 11:13:07 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20VFx21o031412;
        Mon, 31 Jan 2022 16:12:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=qjdj5f6hn6Xa+VuuIRJZ5LY+kQsH0gu9JoqOGofCieY=;
 b=LEzwEgmjvXfLH+sdPRA1rJPCdWohgVxNaugDQfP0BpV2IPbXVUMalisI2bdR5lVfhf2x
 9cH3dDc1QqKjgC6H40yELhlll0KB9t078uhoIFhBdoso+PBchTmiGnPDWaz4BDkXTcV+
 rflTSz2txcR2Mzsf/0B0y1Gizr9TC533yDiAJZ9anA/0qDZxE9pgricf03yIj5BQLPET
 6OmDnvbJhmQZ1HABs0JGkuVtbx8wvdk4e0VuO1jrcRoIqX9KwOOOFFkUC1IjlMVtiNC3
 +SYd2KOPMYlHbPe5kXc3MIPGeaEylyv62u3Rbq69MsWIfd6G3I23fCodrRavL54qTShf MA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dxj9v86dq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Jan 2022 16:12:52 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20VGBL72164151;
        Mon, 31 Jan 2022 16:12:51 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by userp3030.oracle.com with ESMTP id 3dvtpx912s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Jan 2022 16:12:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WDnuUY6Z11n5pkWw+f66NdgH2AOEGY+haPk/EQY5kn2Y2ZB7xtjzcfPSM/D7TjOScRr34xam/Ykw02Azd6E0svFvYmDec5J4AfX5ltpa8scw/4LSMecNLKlfbYVgCVjlj4tHUTNnOSuYgrxgRG6gPbxxreZlcyrX/+H6c4waXHizl7JkzzEoJ38X6j6oMig7zzDxTJkete2xFUjgPAihVDvNOCiwEcMNQ4fbDQJkxAeWcF/Fy9R1vnE/1lPc5lsDMPN8uf6vApCbE6i8q4qSneErGBTxE/Z7vixykDyVrRThnlm8VRifV6Svaoa7a9Dns4E57lI9Bm3XYBFk9fVLtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qjdj5f6hn6Xa+VuuIRJZ5LY+kQsH0gu9JoqOGofCieY=;
 b=Q/BB/rkBFlj75Fb7dQ/nNrEc3CTyXUyMoc78J/CgPnURGk90JwrSN2rOCfqU1rlMvHFcJ7oorWG9tSyVHFtELyiGptLQl916YN14NmQf+SnqOdiCFxDNLVi9eU8z7MWYE6ceBDxsaCugSZSGjRfRiLkgB0em20POpXA8BHHbSJXzoaZYc7giq4qh7rursonCF4JAThHj/bUsspl3aoo3TPkAI+maYJhv4aJ3AU6nLW5aDVhHsIq5DVX5YgEw8fx6YIUKL85QQFHUuf/WhOMVx6SIXXVtx+mhjYxjpA5tftGewSYhnRUD1P15zs8+ZFih3j2Scid0UXzgfEPW8zT7ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qjdj5f6hn6Xa+VuuIRJZ5LY+kQsH0gu9JoqOGofCieY=;
 b=Zcrvk2pIzzzhB3m52/9FFrLop1SiujrR/RVSD/2vy6M8t8+GiyRInoaG9T6qcDnZOwZuAd9fLPEeeDXtlQwg9qWT3R++3C81j8gPIPnaKtgXTPUp2c32TR15qyhLxWUd8fQBClc7o9UMtVrQqTe7EF0jOyKhySKZV18nD/eRKOU=
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by BN7PR10MB2516.namprd10.prod.outlook.com (2603:10b6:406:c1::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17; Mon, 31 Jan
 2022 16:12:48 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::49df:513e:bdbb:33a6]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::49df:513e:bdbb:33a6%6]) with mapi id 15.20.4930.022; Mon, 31 Jan 2022
 16:12:48 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     andrii@kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, jolsa@kernel.org,
        sunyucong@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH v3 bpf-next 4/4] selftests/bpf: add tests for u[ret]probe attach by name
Date:   Mon, 31 Jan 2022 16:12:34 +0000
Message-Id: <1643645554-28723-5-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1643645554-28723-1-git-send-email-alan.maguire@oracle.com>
References: <1643645554-28723-1-git-send-email-alan.maguire@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0PR06CA0124.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::29) To BLAPR10MB5267.namprd10.prod.outlook.com
 (2603:10b6:208:30e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6241d6b3-e94b-44eb-e5da-08d9e4d485d3
X-MS-TrafficTypeDiagnostic: BN7PR10MB2516:EE_
X-Microsoft-Antispam-PRVS: <BN7PR10MB251685A35D65FC01347A8AD6EF259@BN7PR10MB2516.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cfPmgJYl/3q9+vNRLjDuxdsXRwWqV/hQxMUHX7L1kMqqBUY9BKYQUflF1aC2eStfhtvEQYr3sgzg1+hpRaGvlLcb0OCw25Rpw/RrnkjDTPalpAUXxVCmhA6FEqFCicKQNZLch6DGfND8AsV7GMFB81hetAH5VOYhQ9papcLD5SeLbVEgaiDy+d3Xv25rkWHwxaVmhoQy44COqFUu1kU9Wcz6xS6M6L4a0ZdsoIobtXaCS7rpHn/Mltv83/gqq8tGdgGW6s4idcpfbgtz2is9aVCQn/6N051F1wK5fY8PsM/UtymjvEcftn7GMIybLU2uqZm/LPvt1w9HRfzODv4zHaRZvMQ/W7XBTXXFdOD4gxNvjLY0WWBR0VvsagOqPARjcvVtbuU2eCBBj6w55Jht4zk+6TkwCc+nE9TVTWGdHm8nFzw6iWNnSAmpMqM/LTYFhfKSRTo4+VJg4rQwGbDCdDnOhLF4zejCGHmh5nbBKULEJEmq9x6Jq5Ttjl/KP5EX9bMgAiC9IOHHa0VIAcDkrYIDnh8/rSx4cGtqMIns+PEJlHPrxpbNL4KYnf7/SZlHa/fEJ9YHnAS8nC3Phr7pyyGGbgg0vRNX+EC2WLQeQTQ8GEvd9bdoGmSt6pP7mD0C6LS5vxjiCHaNJa27XvfIrVcCurRJWo0LiGREBx7LegtaZQc4p0rj+D88jUsc/jjzm+MSLM/bs+Fd+XOFeGRmFg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(26005)(186003)(38350700002)(6486002)(38100700002)(5660300002)(6666004)(107886003)(2616005)(52116002)(86362001)(508600001)(6512007)(6506007)(316002)(83380400001)(44832011)(8936002)(4326008)(8676002)(66946007)(2906002)(66556008)(66476007)(7416002)(36756003)(20210929001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Hu3o0ZPG+uftrjlVle+D4OfCGYPwg/y4UCte+8vfzaJgG9HdVDc2RXfuFDjL?=
 =?us-ascii?Q?IISkrqY/h9TMyXQRMr5SDDjCSviUUiFZkpYQmVxP4aIRLVXqqhJSYVEAcL+T?=
 =?us-ascii?Q?OY6BDO4JwrDucvgDIIC5GKolmRS5sY122HeY+4FF/QkFbRn3iPufB7R3sDGL?=
 =?us-ascii?Q?Q+tQzTRqtQfDq0Zu2or/r7n/uq89bZwBu/uL0jloOXXYIkCkeEPH8nUteRGD?=
 =?us-ascii?Q?FjHRZKRZ8KK/qeLFyq71Do+6KuXy03XMPQkoweZYw1+r5TCDul7RJHeLRkf+?=
 =?us-ascii?Q?GYcwSHFchz5ALT672cacgGuHC72OhgExFLhMpLh8zLxqH82GsMkjP3j+iF7L?=
 =?us-ascii?Q?Z0VP3bY1Wwfjp6mrmlYI4msjUOpKTqy7OFfKQkhaC/hE6qmRbJyCXG6gULgq?=
 =?us-ascii?Q?JmrNg8JoD7QzOfYBVK/Jdr1005JoXkPsY2rULvbQUlhTg9BSpXN4MOncNn0u?=
 =?us-ascii?Q?UIIoNVv7lZ5MfgaepZAwKcC3EEtoygOEgjkZTa0eG/ArUruKQh57sux//d/X?=
 =?us-ascii?Q?xGSxPPkBBrD0WJMIgMIDNuVYr7xn9OyC+4qWPiGQ2Hi1EJ+KMNFe2SR0vaJr?=
 =?us-ascii?Q?dAH1P1f2Fa9Mi632So77QjNGlE9eaIYuLQksWW66oDUhf9VbT2pj8thK122l?=
 =?us-ascii?Q?iARL/7dJRr1OhMEbUCCyJKRaxzu9OyrPcBcZZtFeR+iaPCGpAt9CsG7oOWFY?=
 =?us-ascii?Q?qTBVY7XQ/lBFxKJFOIuR4YTnfXc2d14gL69RIN8a+q0F84JDUMedHP5OI6oM?=
 =?us-ascii?Q?hRFFPUkKrLBQmbKCxqJKA4+LZ9vDhVubrxNKJ/zIEMhD9ObqBmCZrEkmhiW2?=
 =?us-ascii?Q?7LwZdK9hrJv71roW59SfbkrFgQmk4zEGJ6nd0oZh58/Xy4aQOHosbfy3DQI4?=
 =?us-ascii?Q?kxt9n4Mky3vJxHc/WJroU5CcjF0NKA+JtSEo2lHiC276eJc75heGfsqSm/8Z?=
 =?us-ascii?Q?1vgOAxElMEUsk57XAH2bfd47BmGE2pcPHIN0VPqFNT1I9o/ZFIfTy+UJENoP?=
 =?us-ascii?Q?KXiIxEjoQabr52onMb7aRllI4O8L4EECjTZ9NELlhfJz8EoYp2qcRq32IGYy?=
 =?us-ascii?Q?B0JecDFDhElOZcJmA2rvA8Y033a512bO0pW3uR/L4HYYTo+mYjjGybtRFu+I?=
 =?us-ascii?Q?zNdHUZEDUhMZn9byR0U0EC6DXRqSmcNhQATEQ3DSfdKYguR0EB95lqCJM20K?=
 =?us-ascii?Q?HbYO7i3QTIW2935xhF6cGgKB0tcLWGrNg/NA7XYEirXsrrOWTcB8oZheZlX3?=
 =?us-ascii?Q?9QW9hHiOQFYkcBEATjuxa9k4Iul/CUqByGYexsbCBgfn6GPvkeyW7ROOFkOm?=
 =?us-ascii?Q?TfUPxlKhFGvVXH1Bnq4Z2BZfATgik0yAutrK4rAOGBFbOCRVGOLkuHnyLR4H?=
 =?us-ascii?Q?qcK3LZsPUSIA4ygPMBlN1YZV8UyCsW9r0zAlpDA1LHkA3AthRtxttARJUWkK?=
 =?us-ascii?Q?YxWSsk+HAmUF56jFRFTyGhlnSDyWggbSTUgCnb0QEulxSy+tmlr/I3B6Aj1h?=
 =?us-ascii?Q?g1000jbflBNA6sDRiE9CJUim/JaXRSGKCe8x77NeGMllDNTrvrzqexO9OmWw?=
 =?us-ascii?Q?s4gFqeLu3fsk3Kw2L5QQOlOMpDyp6y7qNk3VUvoWRrghCzevnpqHqGY26Er7?=
 =?us-ascii?Q?8D2U7glJFbLHfxQ2RxuUgtw=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6241d6b3-e94b-44eb-e5da-08d9e4d485d3
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2022 16:12:48.0966
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OocT3/BX+JtoSwSjwd0zZxi7vjKv3OZGA4Ahq27Dx+HMhTs/XF32dfg3yluagZQWwCahyEo1oXh8iR+i1B6Z7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR10MB2516
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10244 signatures=673430
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 bulkscore=0 suspectscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201310106
X-Proofpoint-ORIG-GUID: HCfct17mV14w33ny5_oIyjJhOX2UPoYC
X-Proofpoint-GUID: HCfct17mV14w33ny5_oIyjJhOX2UPoYC
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
name are specified, but fails with -ESRCH when the format
does not match (the latter is to support backwards-compatibility).

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 .../selftests/bpf/prog_tests/attach_probe.c        | 89 +++++++++++++++++++++-
 .../selftests/bpf/progs/test_attach_probe.c        | 37 +++++++++
 2 files changed, 123 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/attach_probe.c b/tools/testing/selftests/bpf/prog_tests/attach_probe.c
index d48f6e5..127c347 100644
--- a/tools/testing/selftests/bpf/prog_tests/attach_probe.c
+++ b/tools/testing/selftests/bpf/prog_tests/attach_probe.c
@@ -11,6 +11,12 @@ static void trigger_func(void)
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
@@ -19,7 +25,10 @@ void test_attach_probe(void)
 	struct bpf_link *uprobe_link, *uretprobe_link;
 	struct test_attach_probe* skel;
 	ssize_t uprobe_offset, ref_ctr_offset;
+	struct bpf_link *uprobe_err_link;
+	char *libc_path;
 	bool legacy;
+	char *mem;
 
 	/* Check if new-style kprobe/uprobe API is supported.
 	 * Kernels that support new FD-based kprobe and uprobe BPF attachment
@@ -90,9 +99,72 @@ void test_attach_probe(void)
 		goto cleanup;
 	skel->links.handle_uretprobe = uretprobe_link;
 
+	/* verify auto-attach fails for old-style uprobe definition */
+	uprobe_err_link = bpf_program__attach(skel->progs.handle_uprobe_byname);
+	if (!ASSERT_EQ(libbpf_get_error(uprobe_err_link), -ESRCH,
+		       "auto-attach should fail for old-style name"))
+		goto cleanup;
+
+	uprobe_opts.func_name = "trigger_func2";
+	uprobe_opts.retprobe = false;
+	uprobe_opts.ref_ctr_offset = 0;
+	skel->links.handle_uprobe_byname =
+			bpf_program__attach_uprobe_opts(skel->progs.handle_uprobe_byname,
+							0 /* this pid */,
+							"/proc/self/exe",
+							0, &uprobe_opts);
+	if (!ASSERT_OK_PTR(skel->links.handle_uprobe_byname, "attach_uprobe_byname"))
+		goto cleanup;
+
+	/* verify auto-attach works */
+	skel->links.handle_uretprobe_byname =
+			bpf_program__attach(skel->progs.handle_uretprobe_byname);
+	if (!ASSERT_OK_PTR(skel->links.handle_uretprobe_byname, "attach_uretprobe_byname"))
+		goto cleanup;
+
+	/* test attach by name for a library function, using the library
+	 * as the binary argument.  To do this, find path to libc used
+	 * by test_progs via /proc/self/maps.
+	 */
+	libc_path = get_lib_path("libc-");
+	if (!ASSERT_OK_PTR(libc_path, "get path to libc"))
+		goto cleanup;
+	if (!ASSERT_NEQ(strstr(libc_path, "libc-"), NULL, "find libc path in /proc/self/maps"))
+		goto cleanup;
+
+	uprobe_opts.func_name = "malloc";
+	uprobe_opts.retprobe = false;
+	skel->links.handle_uprobe_byname2 =
+			bpf_program__attach_uprobe_opts(skel->progs.handle_uprobe_byname2,
+							0 /* this pid */,
+							libc_path,
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
 	/* trigger & validate kprobe && kretprobe */
 	usleep(1);
 
+	/* trigger & validate shared library u[ret]probes attached by name */
+	mem = malloc(1);
+	free(mem);
+
+	/* trigger & validate uprobe & uretprobe */
+	trigger_func();
+
+	/* trigger & validate uprobe attached by name */
+	trigger_func2();
+
 	if (CHECK(skel->bss->kprobe_res != 1, "check_kprobe_res",
 		  "wrong kprobe res: %d\n", skel->bss->kprobe_res))
 		goto cleanup;
@@ -100,9 +172,6 @@ void test_attach_probe(void)
 		  "wrong kretprobe res: %d\n", skel->bss->kretprobe_res))
 		goto cleanup;
 
-	/* trigger & validate uprobe & uretprobe */
-	trigger_func();
-
 	if (CHECK(skel->bss->uprobe_res != 3, "check_uprobe_res",
 		  "wrong uprobe res: %d\n", skel->bss->uprobe_res))
 		goto cleanup;
@@ -110,7 +179,21 @@ void test_attach_probe(void)
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
+	free(libc_path);
 	test_attach_probe__destroy(skel);
 	ASSERT_EQ(uprobe_ref_ctr, 0, "uprobe_ref_ctr_cleanup");
 }
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

