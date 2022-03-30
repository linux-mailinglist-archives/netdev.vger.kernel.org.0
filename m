Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56F154EC843
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 17:28:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348183AbiC3P26 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 11:28:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348176AbiC3P24 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 11:28:56 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9E951B0853;
        Wed, 30 Mar 2022 08:27:09 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22UFLXYr027896;
        Wed, 30 Mar 2022 15:26:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2021-07-09; bh=X+eNcUQ9DrAkJieaIYBVmn0OS6UICRcSzlv8Q9D3k18=;
 b=O9RBBA78dUrg6CfXpq4nzchXxfW0Qc2mZlH/bOTyrQJmst6V5KO3+ukJz43Xr9oh44dR
 SSf5RVa9rOy6vpo8lIkVVSbwO4x0FEYDCbG2LRmNjisqmNA4ZA9wXRv+n4DnQwHJxh3K
 31R4eV4PJoTWZDi1P4DRYTt9betz3lYOtEHscNfuac/10Iq15wKyXAQf7iL+87B9ry7v
 4w+0gMGCx7NpVXQdI0iLiNqT50IFJrM+T3LZMS87jQiBGA/e6kdVbB2N/C9eaAIO+YL1
 /wbbMS6mj9VprNGTN7vLS9uc5Ls2TrKihag20M5TxeoZ5Cme+Vp5pFa6Z8VJNCUzP8kU aA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f1sm2hv6m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Mar 2022 15:26:49 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 22UFBI3C006982;
        Wed, 30 Mar 2022 15:26:48 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f1s93qmhy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Mar 2022 15:26:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=StU3JWIRQwtPMvdtbBeugpWguvYxReSAvFPuZZUdX/8mjvpnaRbazl7tAa1+38X5l8KAqnjQ7IDs6+Bd1BlEoaFurz8eic6jqO7yJ8I+iPSiTS3dJehQag6UBWFg3SfM6PaymGk+M+wM42mg0KMQ7EUstCXsyZg18UiX3KoYbLe6Dm4Hiy7kDn3//0d5FH4ywueooJSN+SrzcbTuZMEJAmWLgnGvYAr3RWRdq7d7jQ90VwWcZJfewbhmF5/CxHnZ1T6n5tKkU5EVDSh/yK/buRQqxI0ycny/g8wriNFUsROvvH7xKC+OF/mC9QoIbEDVx0KW5z1ayA9wOeYQGNY3JA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X+eNcUQ9DrAkJieaIYBVmn0OS6UICRcSzlv8Q9D3k18=;
 b=Vpnyq6bZe8jZ42Zwhkui+4VdwzG2+0vL7iL88sLDi+cmqt/RQyo0A2egXSygTjWAX0fDjWhWbxRZiv447FvrRo4UW2W1CHlgLd3IQZMBLEDhQVhSeD8qkLvL0CEcfKlSvs9DGzxj38y2o3tU/MTiJHp3tgEU6UCSNS4Zs7mTJG1Etbg8+EannAziasJsCJMNcrE2ab/dmFd4y8HOnHXebtFtfvXVQwmRnazaiH1kIg2woO3OmeGKvZJnxbfHTlhVo+tZaSlIHRVVIthMZtcNRuf14E/35hWU68wdl93wbBa+vZQupTtbD8twOwLj2YaNVkCGC1dKFtYJJBGhVSrz8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X+eNcUQ9DrAkJieaIYBVmn0OS6UICRcSzlv8Q9D3k18=;
 b=rl6NeJGU9qCXKeqynDHKYY+AehsisuEseydJY9+zYHUjDGwD4GB+cmT/jDCSVNM6vqFgSLwIhhBRPI45Q/XuvFJVvkM92mOdoCvs5jE+1XFu0y6BP7aFxhN6p9KBMpJekrIILG9JEsEx9WAFyZDJ35XF2AZv59oVcO33PtCR0po=
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by SA1PR10MB5866.namprd10.prod.outlook.com (2603:10b6:806:22b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.19; Wed, 30 Mar
 2022 15:26:46 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::1483:5b00:1247:2386]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::1483:5b00:1247:2386%4]) with mapi id 15.20.5123.020; Wed, 30 Mar 2022
 15:26:46 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     andrii@kernel.org, daniel@iogearbox.net, ast@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, toke@redhat.com,
        sunyucong@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH v5 bpf-next 0/5] libbpf: name-based u[ret]probe attach
Date:   Wed, 30 Mar 2022 16:26:35 +0100
Message-Id: <1648654000-21758-1-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0362.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18e::7) To BLAPR10MB5267.namprd10.prod.outlook.com
 (2603:10b6:208:30e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7a2a6123-79b5-45c2-8b99-08da1261b3cb
X-MS-TrafficTypeDiagnostic: SA1PR10MB5866:EE_
X-Microsoft-Antispam-PRVS: <SA1PR10MB58661A7F3C2353127C180F54EF1F9@SA1PR10MB5866.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2rph9O0ZURCUwahMVo5fsruxQjHiPB2HjqX2TqNx0f1bEWVVRO/ICrEG1chbYdGmID4NQ+5GYUoshmHdIKVYbQCAORkwr5zHggLt+IWLFAEMX4ia9CKIK/x9fMQhRHJ0lDvipIXoc/70043rXHWGlD81//rkRtBXi3MVYve+pNAm81VEKf5URWlN5Dxru+tO34IIzNFobiTzpveOiehLGjhKe2E1unrmLYvaqZf009GVDGgGiktvx6hJCuvLzjJDP1WY6ekYMHbCewnAdZ98tozuEmBqeF0mrG0HBxGRnDMf2pK1ckv1323uekxBWyMJ16kI09YqUj7MmREGBU/kTN1S/OdRWWw4grmTSIGib9kPvOsd23ft4RlPQlndR4ecvd1QkWDrd12B1ruX6qWJu+kSjYPnA2pHpbiL2R7CraszL0aBeWoaC0jTZNZiyOzENjdo7Ws/pEUppecIX/5eaJ8cZ9ojdqagHYq09HstfWdDUcnZjUNrxFNH1TvXyPK0sfkpJFb9SjyB3Ar6ZEm+vo8i2CJQz2IKl0GP7alpy1z5v3XrA2sCq8GbnfL24xPSreh5wa+uvUWnMGQCkhiB7w24xyB+yRSWt09zHQeSYh+NCZcfJnxmt66qoqrdT3vIvIULpRQ0/xgWkU/TqkhIG++Z/KignXeennxeQCwNBbj+4P32vIlbNbELvh8JFzDY/rZEsiDvriXn1yKK2tZmcJkq/vE6dLwqhP4NWMQt6bVmIBx4NF6zjhEv27Jyoau0lQljYwAkRVzTBhEewBpUSlFejb9/DPLAi50q09GeXdXMALAIoEgp3aDN5yHfO/5FCkjeLnnHp/iiVzcAlPc1RA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(7416002)(186003)(5660300002)(26005)(38100700002)(36756003)(107886003)(38350700002)(2906002)(8936002)(83380400001)(86362001)(2616005)(66946007)(316002)(52116002)(66556008)(6512007)(6506007)(66476007)(44832011)(8676002)(6666004)(966005)(4326008)(6486002)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+PT67+6lzaQsA2BUkSIJn515MHBOCJtkfcqYs3PpaF5nsT3kTMKbeAnO9e7p?=
 =?us-ascii?Q?KxLeucTYUl2FUkrjTU9i2ohPOqVSYEvSn1kHvoKZMzZgHAeNVXU8kPfLTdYA?=
 =?us-ascii?Q?HVg3e2hGZC8YpEHw3NnOZUZNfE4irveu8g44X3eQX+8tgVaNSQ7tUURiPdAj?=
 =?us-ascii?Q?968M8E7kTehKNKZN6LdKLnsmYM+LTSSvJ8hDFEGnAiIgPZQBnLGcwXBR1CVo?=
 =?us-ascii?Q?Bpg53CIwx9yMxhh6ac5ccf/mJ7JZ+gSBbfRhd3wAGj6n+v/O+ct2Mezl29A/?=
 =?us-ascii?Q?+g19vKI4YzpCWBbvC15nW1PnmTSbnrdr3e5i18azILe3Ltyk0XegwEVnQxMt?=
 =?us-ascii?Q?A9vH1T+WeS7Lskz8JY0f5vmJNIBE9Cc3blVo2VPAjjpnnTHRXFivcE8a2Qud?=
 =?us-ascii?Q?dK9ux1JbeVRrtRLfqC84msvgOb2kMCQbHvFoOSxQHgt//M5GJROwMJ2BWlhj?=
 =?us-ascii?Q?fSKZxtX2IG/XORpmMvUCVFNkNymwyY9irmo1puTPVqJ/jBOrM2ZKp3vj8lDa?=
 =?us-ascii?Q?q2EDALFy6I7g85bHDq826WXG7REbDBjymRPvz+1DikS+2szp2tmU8Y7gIZC2?=
 =?us-ascii?Q?YEc3wZhzc07b1XBB/AS6GyxnGtHLPBYE6dIIDKLE3ouWdbyriLHoHn7mMW4u?=
 =?us-ascii?Q?opo5BLKodMStPuibpBUbn5l+71hv2Hja70dIz39uV7w0iT7kqEicLI9hN/pH?=
 =?us-ascii?Q?Nr8YCQ0TR2nR66ScmFTQ7H/FN499aQCoUu7+3svKPHHPwxU2lBR1H1YR8J21?=
 =?us-ascii?Q?EpEVjkyezDIYoJjzfolL79Z7yqNlJPay5z7OKAriBsP1MALiknnb0S0Cx7MP?=
 =?us-ascii?Q?6MhUbrUcJzm2FYm4w6TmjS5EDW8MmhhAn81bI24hKPJf+xsoHftK7ObaPafg?=
 =?us-ascii?Q?GQtzwe9U61v5ohyWwDuignSN4r8u5A3i7fWfOWCPcbI+yq0rI0qYzg7QvgvU?=
 =?us-ascii?Q?WJF3okC7ObQ/i+B6xpsYQaVCyaAyKP/YGM9KP6k5TAc/OBvqrRQBoH7kQ9JL?=
 =?us-ascii?Q?Xm4DpYUq3dXsQSAu6JHnY+5Gv5OCMCQIQRZt4q0faDd71eYDQtLlK8nmq7m0?=
 =?us-ascii?Q?d92iu4Bm5JsvZ+srRVkmN8QG9a7SSRiesQnk2ifQ9KgxBh4dSdLuozvmBPHl?=
 =?us-ascii?Q?KzK1yaij2YFMdGJfCkpg/KlIknubEZ36QZaalbwkYMUgINM2Xin8dlL4f2hc?=
 =?us-ascii?Q?E29hwbMIDOHZyQ+VEiftO5GfhAFTGA4OOkIpH8z5qs8KR2Pi0C3MfidVjKUm?=
 =?us-ascii?Q?cdDtPlmq1YoUAramuuRNH2qD/oGWIoHcRWcH3AZQ2Q4SElHu3bVc5wv0Xnxx?=
 =?us-ascii?Q?IPGyCKmhIt2GrGcl0w8cfjHzbNqCEeTSY1EOTnWJkkIfRv9RxIx/u9F+VwD8?=
 =?us-ascii?Q?+t8xP1UFMchZFJNN6CPbirqNpQlVfEuZIsIwrl657a6hN18j+mqTZYHIsXSQ?=
 =?us-ascii?Q?4Hg0qnKy0kLfnHHKAt9Vy9kv90YkBFY6VnKyur0ksQ9o6oWvt+yRNq/QJW6Z?=
 =?us-ascii?Q?fjiBlciY9tJeoAkW7QnbcmmtnePdqPpYp0utY8Vr4M3TjhuDwaK5TgQN/0br?=
 =?us-ascii?Q?54gkCDo9DI3rlm3ilcww6A66otUAOx4nMGekYDydPsLWJppjr7Cj6UqfA2Ue?=
 =?us-ascii?Q?ZBZg9LqK0PFsRSpc4qoCKIwM8VmoOll6cjmJivOlhh9qUsu15PnV8suRe6sS?=
 =?us-ascii?Q?ehzzz5IJH/Mqa9bCDEaxOaZPTvXjdx9vkpkYRlc5VcU1CBIWEv8Vcj3Puo/R?=
 =?us-ascii?Q?AWDXKkXL+7UYzvOuDCR+fcJxa8jABU0=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a2a6123-79b5-45c2-8b99-08da1261b3cb
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2022 15:26:46.6122
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iY1e9KzmqbRktnXDBj97R0ncs78CCXuNzq+knBgEcvHsidCnVCb4jpVQtpX/MILIg5eQWW2XDBklfTnt7TmSZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5866
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-03-30_04:2022-03-29,2022-03-30 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 malwarescore=0 bulkscore=0 suspectscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203300074
X-Proofpoint-ORIG-GUID: njrIK7APtI2hFSYRBda4BjdG1KV2AOWm
X-Proofpoint-GUID: njrIK7APtI2hFSYRBda4BjdG1KV2AOWm
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

u[ret]probe/binary_path:[raw_offset|function[+offset]]

For example, to attach to libc malloc:

SEC("uprobe//usr/lib64/libc.so.6:malloc")

..or, making use of the path computation mechanisms introduced in patch 1

SEC("uprobe/libc.so.6:malloc")

Finally patch 4 add tests to the attach_probe selftests covering
attach by name, with patch 5 covering skeleton auto-attach.

Changes since v4 [1]:
- replaced strtok_r() usage with copying segments from static char *; avoids
  unneeded string allocation (Andrii, patch 1)
- switched to using access() instead of stat() when checking path-resolved
  binary (Andrii, patch 1)
- removed computation of .plt offset for instrumenting shared library calls
  within binaries.  Firstly it proved too brittle, and secondly it was somewhat
  unintuitive in that this form of instrumentation did not support function+offset
  as the "local function in binary" and "shared library function in shared library"
  cases did.  We can still instrument library calls, just need to do it in the
  library .so (patch 2)
- added binary path logging in cases where it was missing (Andrii, patch 2)
- avoid strlen() calcuation in checking name match (Andrii, patch 2)
- reword comments for func_name option (Andrii, patch 2)
- tightened SEC() name validation to support "u[ret]probe" and fail on other
  permutations that do not support auto-attach (i.e. have u[ret]probe/binary_path:func
  format (Andrii, patch 3)
- fixed selftests to fail independently rather than skip remainder on failure
  (Andrii, patches 4,5)
Changes since v3 [2]:
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
Changes since RFC [3]:
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

[1] https://lore.kernel.org/bpf/1647000658-16149-1-git-send-email-alan.maguire@oracle.com/
[2] https://lore.kernel.org/bpf/1643645554-28723-1-git-send-email-alan.maguire@oracle.com/
[3] https://lore.kernel.org/bpf/1642678950-19584-1-git-send-email-alan.maguire@oracle.com/

Alan Maguire (5):
  libbpf: bpf_program__attach_uprobe_opts() should determine paths for
    programs/libraries where possible
  libbpf: support function name-based attach uprobes
  libbpf: add auto-attach for uprobes based on section name
  selftests/bpf: add tests for u[ret]probe attach by name
  selftests/bpf: add tests for uprobe auto-attach via skeleton

 tools/lib/bpf/libbpf.c                             | 330 ++++++++++++++++++++-
 tools/lib/bpf/libbpf.h                             |  10 +-
 .../selftests/bpf/prog_tests/attach_probe.c        |  85 +++++-
 .../selftests/bpf/prog_tests/uprobe_autoattach.c   |  38 +++
 .../selftests/bpf/progs/test_attach_probe.c        |  41 ++-
 .../selftests/bpf/progs/test_uprobe_autoattach.c   |  52 ++++
 6 files changed, 535 insertions(+), 21 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/uprobe_autoattach.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_uprobe_autoattach.c

-- 
1.8.3.1

