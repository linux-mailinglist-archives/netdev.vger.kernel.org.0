Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F37053B9567
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 19:23:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232593AbhGARZ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 13:25:56 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:60180 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230139AbhGARZz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 13:25:55 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 161HBjkA017337;
        Thu, 1 Jul 2021 17:23:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : in-reply-to : message-id : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=EgAhZPaW2wqlGk0izpIvxP7Tp4COA5MwLtH0oT2w5T0=;
 b=pde+aOSsWqBEF3bCxrNXPXeNpqtweiL0Qaub9ksAdgqAk8Bm2U4c9IIvxw2G2xQ8x2eS
 nVLzr/x2yDOLgEsf0iSJw8TmJSPzfJvH8MGAXlkXIjsxrkilR3zU7GQaG40Qg3q9ePYM
 Qg/M7VLDG8DXjauv07cFolzxBYn4FIpOlsZrump5o7tBtc0sw4V5eyjjA5GWcAsbrhAy
 Auf089D4xSP1TT7zrdeDhBVTrEnWqujIEY5nOeor2cCYdWsXHEALlsFhxbAQwRwthtoe
 KYvtuvaaQLY7N7UYLXTrxF5NIjos/HBRPc5t6e3VXQGKP5OD6G2AWqCvi5nPUK++wTUv Iw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 39gha4c0a0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Jul 2021 17:23:06 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 161HBmL5132172;
        Thu, 1 Jul 2021 17:23:05 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2104.outbound.protection.outlook.com [104.47.55.104])
        by userp3030.oracle.com with ESMTP id 39dsc4c9r8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Jul 2021 17:23:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n9Owm1tkGSGpSU7HzUAd3+cVQfRMNJRcpOt4GQRQ01s56+PJhMmhyJwiU5wowPPy+gP2axEbV2Duza56ygZI/ULsZgGCBDCFbZCLgr93tWXPG0yNKSYb42Q3EOmXf0n3CH0oz1p2RRgUJtqRu/4ohiC+c8rmBVjQzP01gTK48dPrbx3vv0mLzsDkORmJqsTpyYoxmPTvrZ7vuDkV2ZtxkUgfABxCdHGHAcrsTzahJB2F4ENHzTVOC+xhfiw9X6SwfGzGajHLgvdKc6YMzZZbGhL/XUHmDS/vtJrRYmV2FIBh0VObYQITboIoLrmvHApdcKSp/0a+GLT8k8GKgzBEAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EgAhZPaW2wqlGk0izpIvxP7Tp4COA5MwLtH0oT2w5T0=;
 b=IK1J0vweFPRGxmO8Y4IcrAIcK+ykKz0J72YAqlAkag3Fo1FW4N+SiF4ZtUyV6WlFAnk3T1PUgaEvSvqfLmq9/4T8V+hjoLRf9VcT0x7vZ3F8ap6/UKG/jzm8dgu+JoEMo+Xid2f4BS8G3pXXXzqaLReyFSGoMAoPSc/QG9jAuh2oDufWSCHxU+adc9n2Z6sEo8qfXL2dH6DNcWDyZGWm2x5v+1wXakQlEAZUc3PZBKLrn/1q0/zn1ecVV9VL0EGz3UoaiT7uAwZr/c6r4odH8P/pNtRupRAppuMBUZxT+aAdIhjQQDv7x3qqkWCpFCkGxk64GcQc2oCwTIY4TAwG+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EgAhZPaW2wqlGk0izpIvxP7Tp4COA5MwLtH0oT2w5T0=;
 b=fKhBrTkSxj05n80TDS9tMukLtZnl6e+c44fU54vXy/0x9DhOQy11aJOUkERDKqJkIug8T86asCocRYOiTNu1ypM/D3ZRKY6srIoqZixzoLAKDqTkDtxXyWK5/KRLWi5Qt1XYKONBpVTVddTIEiqChZQkCwfNERbVVDaz/tCAkFY=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by MN2PR10MB3263.namprd10.prod.outlook.com (2603:10b6:208:12a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.21; Thu, 1 Jul
 2021 17:23:00 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::39e8:94ec:fc2d:5a56]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::39e8:94ec:fc2d:5a56%9]) with mapi id 15.20.4287.024; Thu, 1 Jul 2021
 17:23:00 +0000
Date:   Thu, 1 Jul 2021 18:22:45 +0100 (IST)
From:   Alan Maguire <alan.maguire@oracle.com>
X-X-Sender: alan@localhost
To:     Jiri Olsa <jolsa@redhat.com>
cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Masami Hiramatsu <mhiramat@kernel.org>
Subject: Re: [RFC bpf-next 0/5] bpf, x86: Add bpf_get_func_ip helper
In-Reply-To: <20210629192945.1071862-1-jolsa@kernel.org>
Message-ID: <alpine.LRH.2.23.451.2107011819160.27594@localhost>
References: <20210629192945.1071862-1-jolsa@kernel.org>
Content-Type: text/plain; charset=US-ASCII
X-Originating-IP: [2a02:6900:8208:1848::16ae]
X-ClientProxiedBy: LO4P123CA0324.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:197::23) To BLAPR10MB5267.namprd10.prod.outlook.com
 (2603:10b6:208:30e::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (2a02:6900:8208:1848::16ae) by LO4P123CA0324.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:197::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.22 via Frontend Transport; Thu, 1 Jul 2021 17:22:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ed72c246-64e0-4455-d372-08d93cb4e014
X-MS-TrafficTypeDiagnostic: MN2PR10MB3263:
X-Microsoft-Antispam-PRVS: <MN2PR10MB3263054025831A92398BED22EF009@MN2PR10MB3263.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VEBzNU6SmlClQ47MP1BI+5cjHZ5v5yOIEKjiW7uU9FFwuXgVnRY4Rg/I+Xo0p3o++7sa3OQVZYq8/rCeb+SEaEOlWsTdDknA06in+YdYJKpq9XM90UIW13ikiyE4R0WAAVDpg65wvAtHbs//IibmfouLvay3xnr3jwqe/hpTap1Ez10pnnWMR982c+2LCay1s4GTx/4DppGPAfSUNjrTMUhAFLAiDu0iXqKRCxulLEfQuQ3xnS7b5n7nzpuNCiK1NhMOJuExCB7k1qpbt4IamtnbZzsEO9BwI9SSesFsOvXCDijrvwU14U45d+HOUqjEZwezj9EDfhhPR+8ch3yCGLd0vOXpPxIYVNCkjnIeAQ1P2Q/K1aZu7dpAw1RsryGe99oVTahM3UW28ZUB/eZlMjWK9WL1BDxMoE89NZ5UXlwTCEpaq2GXJoPieSlGzVu0eYWALNMj5gEcDTDBWZ8YN3sgh30XmE+KFov3op+kjzUYDXbf/U4/z1N9PP/f20WrdRc13EnhhOyXTxP+9rG2R/dTPO9YKyz6MJAPpQaEhJOTJNWgBMrP+lWzE5SDTEgTVKUSdTTCDImxw7hndzlqa5uwg9N+P0Lwqbva/SHtlkG/TC/qZyUIGklr4a2p4ghtTP6IgkrfnjNE4UU+zwv1a7NWPV8P3TVJ0NOrAK7JqNFeDjCYRq/hnL93hbaxfnmqR2afVcpYEGS4czQJL/m071QFhs7xTmszSb5V174eul/kIX9Tj1tj39wh02bQ7rlid5gpFnUJZmhM2s/sluUDTQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(346002)(366004)(376002)(136003)(6486002)(52116002)(44832011)(6512007)(9686003)(966005)(186003)(7416002)(8936002)(2906002)(8676002)(9576002)(16526019)(6916009)(316002)(66476007)(38100700002)(83380400001)(33716001)(6666004)(6506007)(66556008)(478600001)(4326008)(66946007)(5660300002)(86362001)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hauVMcvjitO/SWCyb1bs0UwhEQd018eLgXzAWQPTYuwRiuWPar+vNBEIMdnm?=
 =?us-ascii?Q?g1NQpXcqmOWjz/D1sEPLFR9Q6d5YcxMeKNJJ48GYpL9eG2QaQb/pDc/uJA4f?=
 =?us-ascii?Q?bNR1rL56zCktcxZiZAe6AixY3em2BOau+22zWbqY1YlOzECSvECLX7dEnciK?=
 =?us-ascii?Q?T1YhzW6E94l6T1hyKBxYc7q9QR0j/29u2jvSshmnYUenjgUiTiPCii2WRgGA?=
 =?us-ascii?Q?VMNQ4U057g+x0FjO84XdBHDbwMSV+YBBOo0CaPNVo3LQVFRwhAgD49g7LB8Y?=
 =?us-ascii?Q?48Hz8C3Rm0OCISz7P58jUFowntxcoLLJbqLwm0y/M9NSaidk1V/XX4lGPg7/?=
 =?us-ascii?Q?GU/ROu2tJv6ZS7GoMgXZu6+3/uoHTfJZKtPGVb42vGvYJa/mOrMZmE4DTz/b?=
 =?us-ascii?Q?f6nNirzr0iMS2qL1iV4eUyM14zY1vxX7yhRVG2eJ+Zdu6ejjnzB2reX1b5RV?=
 =?us-ascii?Q?jn05sSJCPSVLFr1x4ONunqxm7F2HYl9BurNoMFo6a5CHTLyXii2ZEsI/Lm18?=
 =?us-ascii?Q?uBNpXBy/UZ7PaYUXgriIK+4Du4CD5NS0/neEATHL6hGkb8AxFku3wUhuIdDK?=
 =?us-ascii?Q?jyh1MHgiNWb3Zijtq3BDHv3fSYqYCnQRL8G/WyH7qDpXZnHLCkyWM0N4Ljo4?=
 =?us-ascii?Q?/Dfz5oklVEoMxIv8HHCv+BRu1CTS6kCcSdF/9P8ZriCELCkriMqYe4LUm1yt?=
 =?us-ascii?Q?2+3+42jKABs/JbbU5z5QKRn5LCRA1tkHgaQIU/t0eO87BjrjuR4naSTFSHYw?=
 =?us-ascii?Q?ZAvsTHuy5aFM8bfgJ+9J6X8r9ypcdB5We16rMZ+BtLzDOqQFc69wCxuGlRGI?=
 =?us-ascii?Q?oqgvyTlMTyy3Ehde78Bjaka2cDYa5/q9B08lfhLvHV8z7N3aZfMqvu4wUYaL?=
 =?us-ascii?Q?JaVNTk+wMJUPCnu+0eRLRnbq6nFxhpoP1l82DFWKF7o/E1gGJjtgeo9qwY6g?=
 =?us-ascii?Q?ExLJ+FdjoSLEDQ5B2W19F/Ryv2jhdUGsMLDH5cQAdjDftdo17cjgwo6DWKp+?=
 =?us-ascii?Q?IWtps3N3PKJKmZWy2pwFuf0rtQzy0SgzUKtr9sfXQkz3whoFmuTGgiYUMjsr?=
 =?us-ascii?Q?L2AiZQEpCOQ/VOFVlTfiMfR05/puH0OO9Rs0xTOwSdH7rtWGttZib7C2fDXP?=
 =?us-ascii?Q?wBWcakfruUEVHa9vhW7nLNZfLD3WSP9fwX2bYJJgT8cEVGelk9Ir/1bSFxeM?=
 =?us-ascii?Q?W7ccjgHMgxYennHZPhuLBrXqNlTS8x/9P7z0ncTyVGHKS0MxXYaGNV9iiypa?=
 =?us-ascii?Q?aW9+DoMswWzgLX18QV/1/9gfO2QpcBmKifjOacEztOXGksozWnbxTuo6kljO?=
 =?us-ascii?Q?f61L2nsEFKBw8h7sTriRZEVMAvMIfAG4vz9cQP5mDNGl6g=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed72c246-64e0-4455-d372-08d93cb4e014
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2021 17:23:00.2360
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yCn9Oxu+XL1bqA2AAa67OZeTCj28DQJLLzDVnfgLPNw1sOCRxEGb57zHumplLuPWfe2+6BXIh/+VS+/WmRZn+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3263
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10032 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 bulkscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107010102
X-Proofpoint-ORIG-GUID: xoJLkxN_c3D7QJa4n2DMe60foAXjOF1F
X-Proofpoint-GUID: xoJLkxN_c3D7QJa4n2DMe60foAXjOF1F
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 29 Jun 2021, Jiri Olsa wrote:

> hi,
> adding bpf_get_func_ip helper that returns IP address of the
> caller function for trampoline and krobe programs.
> 
> There're 2 specific implementation of the bpf_get_func_ip
> helper, one for trampoline progs and one for kprobe/kretprobe
> progs.
> 
> The trampoline helper call is replaced/inlined by verifier
> with simple move instruction. The kprobe/kretprobe is actual
> helper call that returns prepared caller address.
> 
> The trampoline extra 3 instructions for storing IP address
> is now optional, which I'm not completely sure is necessary,
> so I plan to do some benchmarks, if it's noticeable, hence
> the RFC. I'm also not completely sure about the kprobe/kretprobe
> implementation.
> 
> Also available at:
>   https://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
>   bpf/get_func_ip
> 
> thanks,
> jirka
> 
>

This is great Jiri! Feel free to add for the series:

Tested-by: Alan Maguire <alan.maguire@oracle.com>

BTW I also verified that if we extend bpf_program__attach_kprobe() to
support the function+offset format in the func_name argument for kprobes, 
the following test will pass too:

__u64 test5_result = 0;
SEC("kprobe/bpf_fentry_test5+0x6")
int test5(struct pt_regs *ctx)
{
        __u64 addr = bpf_get_func_ip(ctx);

        test5_result = (const void *) addr == (&bpf_fentry_test5 + 0x6);
        return 0;
}

Thanks!

Alan
 
> ---
> Jiri Olsa (5):
>       bpf, x86: Store caller's ip in trampoline stack
>       bpf: Enable BPF_TRAMP_F_IP_ARG for trampolines with call_get_func_ip
>       bpf: Add bpf_get_func_ip helper for tracing programs
>       bpf: Add bpf_get_func_ip helper for kprobe programs
>       selftests/bpf: Add test for bpf_get_func_ip helper
> 
>  arch/x86/net/bpf_jit_comp.c                               | 19 +++++++++++++++++++
>  include/linux/bpf.h                                       |  5 +++++
>  include/linux/filter.h                                    |  3 ++-
>  include/uapi/linux/bpf.h                                  |  7 +++++++
>  kernel/bpf/trampoline.c                                   | 12 +++++++++---
>  kernel/bpf/verifier.c                                     | 55 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  kernel/trace/bpf_trace.c                                  | 29 +++++++++++++++++++++++++++++
>  kernel/trace/trace_kprobe.c                               | 20 ++++++++++++++++++--
>  kernel/trace/trace_probe.h                                |  5 +++++
>  tools/include/uapi/linux/bpf.h                            |  7 +++++++
>  tools/testing/selftests/bpf/prog_tests/get_func_ip_test.c | 42 ++++++++++++++++++++++++++++++++++++++++++
>  tools/testing/selftests/bpf/progs/get_func_ip_test.c      | 62 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  12 files changed, 260 insertions(+), 6 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/get_func_ip_test.c
>  create mode 100644 tools/testing/selftests/bpf/progs/get_func_ip_test.c
> 
> 
