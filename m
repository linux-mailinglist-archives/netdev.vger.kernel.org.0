Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA0ED4D6146
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 13:11:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244567AbiCKMMb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 07:12:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242350AbiCKMMa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 07:12:30 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0449710C51E;
        Fri, 11 Mar 2022 04:11:26 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22BC2rtM024115;
        Fri, 11 Mar 2022 12:11:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2021-07-09; bh=Lc3OYrRRaf4xksTI+8Hf6aQk3XOe2Dn4uNLq547I4w8=;
 b=M7KdxmeqyJltZDR3WdGZEc0I/alfYZmZRKp1IPezMlB7cf7/uHTw4tsnRXg/1nR3g8ek
 C3WvNqreFO2pCF+Fpb1fVksjLjtAlYjzfOYJCedMcD3zgCFnm8q2QcssYHX0bStLA5ES
 mwEHTNv26ljlCD3RdmoQ/cXBIoUFqOwB2i7wHM4/L/JBZ+jN501CQKpVtdHsSY4ZsQfS
 cf5DPfNoC9njfNQeJqXLed2LEjzNMo2hY4d02aeqpnxoBrBELt8mPpsGWOgcCUeKjpT2
 4f/IQcRX/9VQlJFnFZMm4Kc1la70MJ+DqCkJp0983t0sITkL7SRpHzi1qCEfGCxrW669 bw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ekx9creum-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Mar 2022 12:11:07 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22BC1NZg078598;
        Fri, 11 Mar 2022 12:11:07 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2104.outbound.protection.outlook.com [104.47.55.104])
        by aserp3020.oracle.com with ESMTP id 3ekyp47eh1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Mar 2022 12:11:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WEPh2Tj6yy+yICBRLzUZVFHD7sna8x2gm7+bC+QkDfD+TlBS2H3fAxATyXapphy8nHaqZgoH6oBDa5YyX/+tJRXIV5Pp0bQblj14DsjYCeqfHawhVqhQCLEE65alhXn6BDUEv34bpnGb8om5tQ7vvPXo9QvYY5Y6QNl1mOxX/M/cdW8Wkl6M3KD8pkpFS8IIJfBBDEacpu/vbURwsQ/bqNZMbS/f+RwZeG9epsEcrN4yGW2bqGP5V135Mu9uYOeCbx5k2bDi8IQk9brrnt4UUSZFVyFwsDkJKSaKHXE/Yafj26egzaY88Ub7uvtdKFmuXdgtNUOt8PrQ8N4zSQehKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lc3OYrRRaf4xksTI+8Hf6aQk3XOe2Dn4uNLq547I4w8=;
 b=ZHifNYcfyzw2YD8fE8CMCYF3RMa6CoO1oDpbMEouJNIb4jvJ5z6aV0UodRLKwCwHJfJUaMmCh8zh9Qb18Zt8TBsgdXBuL1iInDop9xug1Sz9cyS5ym8ail214qkQ/a1nFnFpxS8YG7mfSsXCHTlsmbo67oCZoOwuPosJ8i5vhifXDtRimUy4Z5kSopZeNGC+3kXcU+xv2+ThffIAWSC0mkR7cITqKs44Q4IV+xNczKsaTXtcLs1KWjYUlrBx24pPykZuUdsVRZiO6OKJ5Xw4go5TH50k3NL+fY9pdwzxDfGMPOUYl8E9nCRntf1uuvhK17fUWzbkPdyqDzmRp5JFpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lc3OYrRRaf4xksTI+8Hf6aQk3XOe2Dn4uNLq547I4w8=;
 b=0IyqH7zz/+PniKdmeYi4w49yai83k+QQ6ec2WwPCjzvp2xzX5kyD2RFjPyE/ydAAlXP/3dXQW8Kq5shjXcW57f98FHMzUrKPgSUthH0tk5JXchAspfgAWhEcm5Ib+/GAb84pgX28ebU7vHUupjnIr29ZTqJU3s5yPDE4znUePR0=
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by SJ0PR10MB4784.namprd10.prod.outlook.com (2603:10b6:a03:2d4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Fri, 11 Mar
 2022 12:11:04 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::517b:68:908d:b931]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::517b:68:908d:b931%3]) with mapi id 15.20.5061.024; Fri, 11 Mar 2022
 12:11:04 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, toke@redhat.com,
        sunyucong@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH v4 bpf-next 0/5] libbpf: name-based u[ret]probe attach
Date:   Fri, 11 Mar 2022 12:10:53 +0000
Message-Id: <1647000658-16149-1-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0335.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18c::16) To BLAPR10MB5267.namprd10.prod.outlook.com
 (2603:10b6:208:30e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e58c3cb5-8e0e-4242-b1e5-08da035836e9
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4784:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4784F6324C8B0152F6323881EF0C9@SJ0PR10MB4784.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VCPST7f+C8JTlNfkl6aK3d95ZM81teeQKMjZQwPQVxTEr/FEAKX3R4SrQps/27IFU8KGuRGHxll5FYkA5kXZlACc2hPLUbLRKiAP57Y0tQCt+WqU5JZnvxR7o0Ric8Be9o3Cw5LbylxwYrT0IT8ogk8LhhZ5wVF77ptmelggPyHBcc9skXoECjXKtA0irz7OwZzKXOPjccmeG5ZbYpu/q+Esti4nXd8I/4aoAqcD1AznLmyzNW1mpG1ovUAB4q4HF/0Y5gYEdXdLGr1l9fCwCObQZiAvV9u3poc8HAc9ykjKeGoByDOBHxhfnRmxACjDyNR0JCEDM1T61JlNEaJK0y4EyY3TSxAv+AX6H/wyPhcGjjlabzkb/daVVoZolCtF0fnyS+HC4c4jRvk/IXXrvPiqGGqdKGZFGjhS/b6oXuDJt1u/LUFIUN+sW3Mr3msv5TiZEpj0edQHe0/Vrxzqp3NWu5lBO9OG4I1nlgti26UhzBvVWC6LIM0BoQ9dRwY591XJwkxVaLa+KsnmrHyIVbbFJkiRXYczhSj7dB3B6j8NS+xyBcrbzmBh2Gb/LP7QqVGxkuLZl1CQWlRuxoZjX7igFm+8Dc5znTYXTfLiOe7wU+CA+l6F06qWXiW822yyve3X6UB4FqYBj9Y+QA1cZiNJ1cU8JOb4q4JEJlhDSsjUAhuBk7OnKpvE6aX2TxbthFraSunWGRs9ztouf2oUVDVUwmQ42jKdRJjyUPZnjYIIslZq1jA0T49lLMsUxIcCskcVwhUjTDcmq1NZqqmsk3O7tBvqGSSK2HxBNvluZ/LDJguJ8RbtC5JeTo5hvGaQbbsAxpDPxLfE0EYPMuAa6A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38350700002)(2616005)(66946007)(36756003)(7416002)(966005)(83380400001)(316002)(38100700002)(6666004)(86362001)(508600001)(5660300002)(44832011)(6506007)(8936002)(52116002)(26005)(6512007)(186003)(2906002)(107886003)(66476007)(8676002)(4326008)(6486002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?C1E0qBegNVXmIumNRI22i+3voHsa+Bhha6vVG4Bc88GIcmiYeTZMRAt1blmg?=
 =?us-ascii?Q?uUvF1lUbOfMwjZn3U7ewARf2z3yS5PUdncMyfEcdVb6ZsMU/WrOaWWD9zqM6?=
 =?us-ascii?Q?PhnN5MBr/dvNvH+Ta94J3wreaa3XQCbUZyWykvgayhZBPvuSWPil/HGJT2vz?=
 =?us-ascii?Q?mr7xoa13US3qlkwYi8WYfoGOcOLd61dedYXyyJ4gog0gPvLnRR8ZShSDkrLF?=
 =?us-ascii?Q?eGLbJ+1nB8tW4kO7JStiPZ6TlZkpZVTcCKWAZoiyltMx7Odqvz3G8P+2LWjt?=
 =?us-ascii?Q?r0jLwxmwy1G8omPJNQZu1FvrZxbQbdu3xIk6QL9vXYFqPwoa786z7pk/6GhV?=
 =?us-ascii?Q?S4SPAzlc2y/z2hIQ4IkertL0BF3PASc6qDG7PBNoXYF4eq3sjOEo45D4bA/T?=
 =?us-ascii?Q?f2oyXPs9lbxzRtkmNRAczSmkyFuSd+MyfiEkJKNMMIuoNSTrUTnoD1KjZnz+?=
 =?us-ascii?Q?tK98eSKToTBfU095Ca1ZXOKOYuLFzO+8m2AXJIPOy7chuJcSi/Xu2jfDEa2b?=
 =?us-ascii?Q?3ksrdsBvuuuMPL4jDwLDXT6+ZiAg7E9wEb2c5LMLm0aiWhKkJ7TakvZsiT4Q?=
 =?us-ascii?Q?+bnPCDpPLJF0mU44xb9trgfKcUXdEGnrhklFixqH7jZWIVOWrK2OaG+xQ8mZ?=
 =?us-ascii?Q?9JJHfBKwLK2Rvtp2OtdZgG1d9OOGzDfrWAOwAKF1JkT1csfhMH8fSTZhqVjS?=
 =?us-ascii?Q?FC7nTy/axbT/1/+cNOvaLud269xNuEnnpK9OEV1Lt4lTmSrNJN6ep/9fHPid?=
 =?us-ascii?Q?NnEsrXx81XW8sSIIn7Rmfk/rhtKAxj0FS8TN3GO314cuMSPU7xSUMKtDu+KU?=
 =?us-ascii?Q?Hb34strXZa0cnZKWtzVnZlnYKc4l2wOJZXamm+a65pURC/gSPDqpssZXKYu/?=
 =?us-ascii?Q?J8+OlFm8XRGJvCIgg7euuoVTAaXaYyFGQwut4fholMLaJF3W1dbzAx50cW6U?=
 =?us-ascii?Q?IbAh2o/8WnQmHHhNV4kXHPjXC/cbvwS3GVkgd2MKL7nVRbtd3A9N+MILWc+f?=
 =?us-ascii?Q?EcJBCqDIw0AYHEZlPg3/YhyHD3A9/7ctLIqjOCKMUFRORqdcxVnnXe35TeDF?=
 =?us-ascii?Q?QXZZwPb1avO+ysmNt014bSl1QLYrFr75mxRUOFkORerdaw7QLXJY8g679RUk?=
 =?us-ascii?Q?xis5XvqvL61pE9r+mblfDRedyABvY8VwfLEOHKDxTOtx2YctZY/fYMCbTcZq?=
 =?us-ascii?Q?+VdFmHo9JVEyU6XMHmo0niUiK6i0DTVezGkssfEmY/5EIjKlfBm2cvWs1+nn?=
 =?us-ascii?Q?aLzpnFuen0PmS4QR4Q5f0KSJWRvFe0cJCcxLWY7v7i0HX+EHwYJ6u84m1kJq?=
 =?us-ascii?Q?2cFpx+Q7D47JPjtSFZDHrN/lf032dgaw6l6hb+fP4qTcI8PS87HbXa0QOP2W?=
 =?us-ascii?Q?PwcGWwNbZAMr6ABnCJXLIZ4n28XffZV+4unAmoQh5xCACerJ+c7eJXK1F9hr?=
 =?us-ascii?Q?s2Gr47f6yVwEZYD/fBG77LxVaLAgvb0qQau7mqDBc3Ys15nUpvXCZ1+jtJlJ?=
 =?us-ascii?Q?aPG6BpsUQoZM4ScZcyhCaZOAmso8WgjZH2hcWud1JOTDSJtRytFQX+EC0sGk?=
 =?us-ascii?Q?WM8ae0gtEVNboM6sAgvnISMjmLACDX0U5CoZALoiTl5KViJV/cQ8YCQn5Nff?=
 =?us-ascii?Q?m9ovKc4MBXtunNe9R9eLhOo=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e58c3cb5-8e0e-4242-b1e5-08da035836e9
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2022 12:11:04.2305
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mhy+nSqe70NnY61mqOrfbhrgmXG801+3uf2MRyR1sPNioEIGs4Y/M6mxnSxXbFR5z1SQO4kTQ0rIxqXG3jTsow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4784
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10282 signatures=692556
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 mlxscore=0
 bulkscore=0 mlxlogscore=999 spamscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203110059
X-Proofpoint-ORIG-GUID: 8KfHXjClJcejbxeDiIH5XvEgGvS1oXnk
X-Proofpoint-GUID: 8KfHXjClJcejbxeDiIH5XvEgGvS1oXnk
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series focuses on supporting name-based attach - similar
to that supported for kprobes - for uprobe BPF programs.

Currently attach for such probes is done by determining the offset
manually, so the aim is to try and mimic the simplicity of kprobe
attach, making use of uprobe opts to specify a name string.
Patch 1 supports expansion of the binary_path argument used for
bpf_program__attach_uprobe_opts(), allowing it to determine paths
for programs and shared objects automatically, allowing for
specification of "libc.so.6" rather than the full path
"/usr/lib64/libc.so.6".

Patch 2 adds the "func_name" option to allow uprobe attach by
name; the mechanics are described there.

Having name-based support allows us to support auto-attach for
uprobes; patch 3 adds auto-attach support while attempting
to handle backwards-compatibility issues that arise.  The format
supported is

u[ret]probe/path2binary:[raw_offset|function[+offset]]

For example, to attach to libc malloc:

SEC("uprobe//usr/lib64/libc.so.6:malloc")

..or, making use of the path computation mechanisms introduced in patch 1

SEC("uprobe/libc.so.6:malloc")

Finally patch 4 add tests to the attach_probe selftests covering
attach by name, with patch 5 covering skeleton auto-attach.

Changes since v3 [1]:
- reworked variable naming to fit better with libbpf conventions
  (Andrii, patch 2)
- use quoted binary path in log messages (Andrii, patch 2)
- added path determination mechanisms using LD_LIBRARY_PATH/PATH and
  standard locations (patch 1, Andrii)
- changed section lookup to be type+name (if name is specified) to
  simplify use cases (patch 2, Andrii)
- fixed .plt lookup scheme to match symbol table entries with .plt
  index via the .rela.plt table; also fix the incorrect assumption
  that the code in the .plt that does library linking is the same
  size as .plt entries (it just happens to be on x86_64)
- aligned with pluggable section support such that uprobe SEC() names
  that do not conform to auto-attach format do not cause skeleton load
  failure (patch 3, Andrii)
- no longer need to look up absolute path to libraries used by test_progs
  since we have mechanism to determine path automatically
- replaced CHECK()s with ASSERT*()s for attach_probe test (Andrii, patch 4)
- added auto-attach selftests also (Andrii, patch 5)
Changes since RFC [2]:
- used "long" for addresses instead of ssize_t (Andrii, patch 1).
- used gelf_ interfaces to avoid assumptions about 64-bit
  binaries (Andrii, patch 1)
- clarified string matching in symbol table lookups
  (Andrii, patch 1)
- added support for specification of shared object functions
  in a non-shared object binary.  This approach instruments
  the Procedure Linking Table (PLT) - malloc@PLT.
- changed logic in symbol search to check dynamic symbol table
  first, then fall back to symbol table (Andrii, patch 1).
- modified auto-attach string to require "/" separator prior
  to path prefix i.e. uprobe//path/to/binary (Andrii, patch 2)
- modified auto-attach string to use ':' separator (Andrii,
  patch 2)
- modified auto-attach to support raw offset (Andrii, patch 2)
- modified skeleton attach to interpret -ESRCH errors as
  a non-fatal "unable to auto-attach" (Andrii suggested
  -EOPNOTSUPP but my concern was it might collide with other
  instances where that value is returned and reflects a
  failure to attach a to-be-expected attachment rather than
  skip a program that does not present an auto-attachable
  section name. Admittedly -EOPNOTSUPP seems a more natural
  value here).
- moved library path retrieval code to trace_helpers (Andrii,
  patch 3)

[1] https://lore.kernel.org/bpf/1643645554-28723-1-git-send-email-alan.maguire@oracle.com/
[2] https://lore.kernel.org/bpf/1642678950-19584-1-git-send-email-alan.maguire@oracle.com/

Alan Maguire (5):
  libbpf: bpf_program__attach_uprobe_opts() should determine paths for
    programs/libraries where possible
  libbpf: support function name-based attach uprobes
  libbpf: add auto-attach for uprobes based on section name
  selftests/bpf: add tests for u[ret]probe attach by name
  selftests/bpf: add tests for uprobe auto-attach via skeleton

 tools/lib/bpf/libbpf.c                             | 429 ++++++++++++++++++++-
 tools/lib/bpf/libbpf.h                             |  10 +-
 .../selftests/bpf/prog_tests/attach_probe.c        |  89 ++++-
 .../selftests/bpf/prog_tests/uprobe_autoattach.c   |  48 +++
 .../selftests/bpf/progs/test_attach_probe.c        |  37 ++
 .../selftests/bpf/progs/test_uprobe_autoattach.c   |  69 ++++
 6 files changed, 665 insertions(+), 17 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/uprobe_autoattach.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_uprobe_autoattach.c

-- 
1.8.3.1

