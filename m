Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 717B3202213
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 09:04:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726955AbgFTHEl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 03:04:41 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:33442 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725826AbgFTHEj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jun 2020 03:04:39 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 05K70gaT012670;
        Sat, 20 Jun 2020 00:04:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=SXUUMK0Li1qie/EMxwPX5zXBtqdd/ERN5f+0U8v5I88=;
 b=GzehHFSRpqTLpgYIHS1i9+zfZ9wiwfnGBwKQ8clWMFQpfyb4R3mVO+d92wtVgvyzqVh5
 KyrH8kzVOxMweycfuPakSLMzCkStfGsjUb1fHy3yezbXspEw3b1y8BHZHBDbUW/5FuKS
 wKUb8BtGSmlRFF6Nzz/yxqv4rP9NSUYTMdc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 31q6458fqt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 20 Jun 2020 00:04:25 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sat, 20 Jun 2020 00:04:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YU7W9pQ0ue5kdMczeMh3uVp+Zm5Y18TSL83CBdUz6K2O5zA5n6x7bm/+2dCWV/vayiWdEsuO93nxBefuCeNTOyrK8SxXou/zAqEx07MFDSR2HINMxWLXuRQMt/Bzcs/1DfjfdpPZJM4MyOuy4qCMN7j+PCODUyTZxim9KbxzzZBMUAXJam5BNaiKTtHrVNaqHin1pPAlQrITAvr6N7EgyPxeqP4riVsej/tdUfZQ3s4hMLVCnd4YYCXnBuwRW3NgNqNs+65exIRPUU5zv938VFJS3Rnmeo8H+/5fyznJh9duQZs1KDD1co2XIwiLQGJeFuFQa5vJ3Vllw15E24FqrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SXUUMK0Li1qie/EMxwPX5zXBtqdd/ERN5f+0U8v5I88=;
 b=FIAFT4UThDC3pwvIEwc6Dj0BrRZj/9Ly1vDCrU8nnBpCV2MEXTr6Q5bG0UHfWPLfVtpo3/Okkv19b3uLks7E8FHvPrza6dXKBD35tL0csrDdf/Mke5zGtZ9XXrK7C7VNPqrOL9kG7IUUiCWMEaSLhaoFBy+bgj9OjWZJ2gb4tx1fpFC2v3kPyGSuTSLBhRipR8sFAwI22y+Jk4idF5183MdalyqdkzOutYSHnuoCxbq3FEviv+YO5RQ0BQLDEb+2eMxql5eDkZxYFBKotOG1x57ogudgj1nsqWhPSULLwqG1SjFhJEQV/YCjF2uIxtVZjaoJAyH5sDltctneo+AaPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SXUUMK0Li1qie/EMxwPX5zXBtqdd/ERN5f+0U8v5I88=;
 b=S2y2/MkFqXjt4ER+GIVQFdUpVRC9EMg5uIZKLGWmKdf+k/0A/paeVONP9czLo4TbXRd7dtW9nDlTne03TUVSZDjJHumfmP1mWVhP2ahXdlZFrI54Jq/LoarebYv5AapMyOc66+QSoLcYFlmuDlCA6K7Fq3WrjkPiEnVV7Ln1jHk=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BY5PR15MB3569.namprd15.prod.outlook.com (2603:10b6:a03:1ff::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.25; Sat, 20 Jun
 2020 07:04:20 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301%7]) with mapi id 15.20.3109.021; Sat, 20 Jun 2020
 07:04:20 +0000
Subject: Re: [PATCH bpf] libbpf: fix CO-RE relocs against .text section
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>
References: <20200619230423.691274-1-andriin@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <ff1e49a8-57bb-a323-f477-018f9a6f0597@fb.com>
Date:   Sat, 20 Jun 2020 00:04:13 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
In-Reply-To: <20200619230423.691274-1-andriin@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR17CA0012.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::25) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21d6::1288] (2620:10d:c090:400::5:54f6) by BY5PR17CA0012.namprd17.prod.outlook.com (2603:10b6:a03:1b8::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22 via Frontend Transport; Sat, 20 Jun 2020 07:04:18 +0000
X-Originating-IP: [2620:10d:c090:400::5:54f6]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 75410406-67be-4db9-cdae-08d814e827b3
X-MS-TrafficTypeDiagnostic: BY5PR15MB3569:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR15MB3569CB82261FABD1DD8BEAA7D3990@BY5PR15MB3569.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 0440AC9990
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FgCrMgnf3tecd8vBHefPjoRWL+RB9BKiEHncYchnO/fTGOvs5E7ezB8aosXkZzGUMI0/She+xDdAyl/85hj8xhdpVLr/83Gq8xbz7yc5jAGPv6vQAKEUViVIVZUXj3Mmuy/nCChLwBl4husrFm/BZ4ISCs0b9oSoGODQcPQ52eiHglvVlNpY2DzOaZDU/oiH+zWN1a2rClC/zuQv5/86VGoy1wSHfEpa0waxjTAU8FIO9BUE2z1a5Zy9q4zIOrBe3XUsyr4yCddy2SE1kdo94RnFQ1GcAm84nluCiZxZmI3uP8o5UGnPOZwZRuc4tNBer41WpiOtbK7MHv9JAwQ8Flfj7hT7tVTeStsVXl8MG32UZ/oh6h/1PZaCqcT6KFk43E1rf2Qqjp8T7b+pW3ZH7xJMwnhoit7oISXD+pe480U=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(396003)(376002)(366004)(346002)(39860400002)(2616005)(66476007)(52116002)(66556008)(8936002)(66946007)(6666004)(5660300002)(8676002)(16526019)(53546011)(186003)(316002)(478600001)(4326008)(83380400001)(6486002)(86362001)(36756003)(2906002)(31696002)(31686004)(142923001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 9Jum+ynhiSBvF8SVOrViLFMhX/K23TjBwmM2n37Xm9f5fV8r8d8hOhKK/e/ORuUmdRNu9W+Q5tQDh07I3DLo/7MaYU86ba2l5RCFfDi3rxjsSm6+DVmE6dA2gwS/1g4/Gal68avaQsTo8vTElxhnvBg3MQfdWOQjcLZspoEaGumGNejQXDOxXZJcqvEMKODW+3mBsVsbbpF8BiuYGvb+2aSfix6mT1o4ksatdUW9KR/5OuDN0gqxlLaKrL5ngpj7e7lpdLEMog7AIERUHVzsePSV1ND4dyft6U+M0mIKQcyGbBLeYxDNEyZ3AQsSGrPK2HOcWHPtJJ7HgTFx5Gv06KG81jMFn8JXNtCPej7jmcRSjO+4i1jPH4cKc0cMO1wDzLpE4/N9Jd8wFFHDGEeAqvlPi7ey9KOpPyCQPtgAlrBkEEOgZ2w2ngVdv0o4JEg+o46MXTuSfvoMh1l5DPDZVUINHrIal4n4oO/vJtHa4r2xFQ7mzWF3yJbtm+P5EjMpX4S87Ll3ntZ6aMNsP2Yqsw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 75410406-67be-4db9-cdae-08d814e827b3
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2020 07:04:20.6546
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RbR1IVLLsFXXpcS5rs9RqPJ5cTAvf/cgeLUxcBLo0VQRB+le+Ag0JnR8CcLMM72f
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3569
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-20_02:2020-06-19,2020-06-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 impostorscore=0 cotscore=-2147483648 suspectscore=0 adultscore=0
 spamscore=0 clxscore=1015 priorityscore=1501 mlxscore=0 phishscore=0
 lowpriorityscore=0 bulkscore=0 mlxlogscore=999 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006200051
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/19/20 4:04 PM, Andrii Nakryiko wrote:
> bpf_object__find_program_by_title(), used by CO-RE relocation code, doesn't
> return .text "BPF program", if it is a function storage for sub-programs.
> Because of that, any CO-RE relocation in helper non-inlined functions will
> fail. Fix this by searching for .text-corresponding BPF program manually.
> 
> Adjust one of bpf_iter selftest to exhibit this pattern.
> 
> Reported-by: Yonghong Song <yhs@fb.com>
> Fixes: ddc7c3042614 ("libbpf: implement BPF CO-RE offset relocation algorithm")
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Acked-by: Yonghong Song <yhs@fb.com>

But the fix here only fixed the issue for interpreter mode.
For jit only mode, we still have issues. The following patch can fix
the jit mode issue,

=============

 From 4d66814513ec45b86a30a1231b8a000d4bfc6f1a Mon Sep 17 00:00:00 2001
From: Yonghong Song <yhs@fb.com>
Date: Fri, 19 Jun 2020 23:26:13 -0700
Subject: [PATCH bpf] bpf: set the number of exception entries properly for
  subprograms

Currently, if a bpf program has more than one subprograms, each
program will be jitted separately. For tracing problem, the
prog->aux->num_exentries is not setup properly. For example,
with bpf_iter_netlink.c modified to force one function not inlined,
and with proper libbpf fix, with CONFIG_BPF_JIT_ALWAYS_ON,
we will have error like below:
   $ ./test_progs -n 3/3
   ...
   libbpf: failed to load program 'iter/netlink'
   libbpf: failed to load object 'bpf_iter_netlink'
   libbpf: failed to load BPF skeleton 'bpf_iter_netlink': -4007
   test_netlink:FAIL:bpf_iter_netlink__open_and_load skeleton 
open_and_load failed
   #3/3 netlink:FAIL
The dmesg shows the following errors:
   ex gen bug
which is triggered by the following code in arch/x86/net/bpf_jit_comp.c:
   if (excnt >= bpf_prog->aux->num_exentries) {
     pr_err("ex gen bug\n");
     return -EFAULT;
   }

If the program has more than one subprograms, num_exentries is actually
0 since it is not setup.

This patch fixed the issue by setuping proper num_exentries for
each subprogram before calling jit function.

Signed-off-by: Yonghong Song <yhs@fb.com>
---
  kernel/bpf/verifier.c | 12 +++++++++++-
  1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 34cde841ab68..7d8b23ba825c 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -9801,7 +9801,7 @@ static int jit_subprogs(struct bpf_verifier_env *env)
  	int i, j, subprog_start, subprog_end = 0, len, subprog;
  	struct bpf_insn *insn;
  	void *old_bpf_func;
-	int err;
+	int err, num_exentries;

  	if (env->subprog_cnt <= 1)
  		return 0;
@@ -9876,6 +9876,16 @@ static int jit_subprogs(struct bpf_verifier_env *env)
  		func[i]->aux->nr_linfo = prog->aux->nr_linfo;
  		func[i]->aux->jited_linfo = prog->aux->jited_linfo;
  		func[i]->aux->linfo_idx = env->subprog_info[i].linfo_idx;
+
+		num_exentries = 0;
+		insn = func[i]->insnsi;
+		for (j = 0; j < func[i]->len; j++, insn++) {
+			if (BPF_CLASS(insn->code) == BPF_LDX &&
+			    BPF_MODE(insn->code) == BPF_PROBE_MEM)
+				num_exentries++;
+		}
+		func[i]->aux->num_exentries = num_exentries;
+
  		func[i] = bpf_int_jit_compile(func[i]);
  		if (!func[i]->jited) {
  			err = -ENOTSUPP;
-- 
2.24.1

================

We need this (or similar fixes) go in together with libbpf fix
to avoid bpf_iter_netlink.c test failure at jit only mode.

Do we need a separate patch for the above fix? Or Andrii can
fold this into his patch and resubmit? Maybe the latter is better.

> ---
>   tools/lib/bpf/libbpf.c                               | 8 +++++++-
>   tools/testing/selftests/bpf/progs/bpf_iter_netlink.c | 2 +-
>   2 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 477c679ed945..f17151d866e6 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -4818,7 +4818,13 @@ bpf_core_reloc_fields(struct bpf_object *obj, const char *targ_btf_path)
>   			err = -EINVAL;
>   			goto out;
>   		}
> -		prog = bpf_object__find_program_by_title(obj, sec_name);
> +		prog = NULL;
> +		for (i = 0; i < obj->nr_programs; i++) {
> +			if (!strcmp(obj->programs[i].section_name, sec_name)) {
> +				prog = &obj->programs[i];
> +				break;
> +			}
> +		}
>   		if (!prog) {
>   			pr_warn("failed to find program '%s' for CO-RE offset relocation\n",
>   				sec_name);
> diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_netlink.c b/tools/testing/selftests/bpf/progs/bpf_iter_netlink.c
> index e7b8753eac0b..75ecf956a2df 100644
> --- a/tools/testing/selftests/bpf/progs/bpf_iter_netlink.c
> +++ b/tools/testing/selftests/bpf/progs/bpf_iter_netlink.c
> @@ -25,7 +25,7 @@ struct bpf_iter__netlink {
>   	struct netlink_sock *sk;
>   } __attribute__((preserve_access_index));
>   
> -static inline struct inode *SOCK_INODE(struct socket *socket)
> +static __attribute__((noinline)) struct inode *SOCK_INODE(struct socket *socket)
>   {
>   	return &container_of(socket, struct socket_alloc, socket)->vfs_inode;
>   }
> 
