Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4BAF342676
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 20:48:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230235AbhCSTrw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 15:47:52 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:28706 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229990AbhCSTro (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 15:47:44 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 12JJieOF014222;
        Fri, 19 Mar 2021 12:47:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=112ldRhEMmscAiVj+wtJZb02DY4XYlqMFyNPnaC5Ads=;
 b=OUyPRENSaENQuuLP+uPOmFQ+IpFRzYudKwkSdpxU2n507hdeaG+7H2oDXFhG0rd4uM2E
 fZErhA/zK8jGY1crcfQVivta9zFpOtbtDsrgetBpP53qV9AlPVNZClf0vEKMShL11pMg
 f41d4GFvTDUJHeQuO9mgsSIIDpFSXKwZOyE= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 37crcwubfx-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 19 Mar 2021 12:47:31 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 19 Mar 2021 12:47:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ybf8pmlmYxGJpROLpqQ/gOGAmyM63c5ePuUH8k/1c9lmA9nrVy8UAnNgsAS5A6CwrXlNR53HauJj+dkDS3L0jO5VwjN7vPsKujn75fkvVtfUbq6kfsyDlcOp7/uVcRfqg346ky995skevn2kJvumCLVhe5KtO+bT6ktjFWWc5d/xkJn7yoalqk3kGOSB0XEaSsF8gYufqp7ihqow6jazCe9KbDMAf+POr6w5B0dvTYSRI0Ec//ksItF2tGUCaa7pPlrYt6738Ztgfw5uuQcvgNoHiJLPHBg9f6e45+GrBmD+NbJUExbgcgd3jPcsEdsLTfQFYVu5YzBpnANXbPAG9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=112ldRhEMmscAiVj+wtJZb02DY4XYlqMFyNPnaC5Ads=;
 b=FI31TV55YIVZzvQe9Zi3RUjIa1e96x9QTNoMNyOipzDkqdpp5K2pGMsuTataaDvHSD2mfg35+f9PCJWfBa4GVsQ5riMhIjurx/TQshzl8QfwSZLSpkgFS9pKUrpCtBk89YwSNRv7YVJKOd8XS/ZFHeHxHsWFe3FNfDsEol9EIUnJYcHU467Ibkr5Z5t5TiiyTa++5XZA9o34Jd2HhMB5Cz5sfpK53Y1D9AMyBOrzyxWLF/RF1sCxJY8MpXK63cUy0dmdfPGzmXT4u+J4e8qQT5nDIP5kkGaXUJbPZ9eHy2S/Vda0uiaK3yDJG0jLAHrcQw/2gDCk1UgVlA+FGLod8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by SJ0PR15MB4424.namprd15.prod.outlook.com (2603:10b6:a03:375::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Fri, 19 Mar
 2021 19:47:28 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2975:c9d8:3f7f:dbd0]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2975:c9d8:3f7f:dbd0%5]) with mapi id 15.20.3955.024; Fri, 19 Mar 2021
 19:47:28 +0000
Date:   Fri, 19 Mar 2021 12:47:26 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next 04/15] bpf: Support bpf program calling kernel
 function
Message-ID: <20210319194726.72rh27cluj6jlwao@kafai-mbp.dhcp.thefacebook.com>
References: <20210316011336.4173585-1-kafai@fb.com>
 <20210316011401.4176793-1-kafai@fb.com>
 <CAEf4Bzb-AmXvV+v-ByGH7iUUG7iLdFxWeY1CJGB7xKHxuABWUg@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAEf4Bzb-AmXvV+v-ByGH7iUUG7iLdFxWeY1CJGB7xKHxuABWUg@mail.gmail.com>
X-Originating-IP: [2620:10d:c090:400::5:d22b]
X-ClientProxiedBy: SJ0PR03CA0177.namprd03.prod.outlook.com
 (2603:10b6:a03:338::32) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:d22b) by SJ0PR03CA0177.namprd03.prod.outlook.com (2603:10b6:a03:338::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Fri, 19 Mar 2021 19:47:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cf446d54-becb-42c1-aacf-08d8eb0fd3d1
X-MS-TrafficTypeDiagnostic: SJ0PR15MB4424:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR15MB442480E78DDF445319376777D5689@SJ0PR15MB4424.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:972;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: htkqg0Ou+H69fPbq11vS1HLr6tx8m0IEkcsXUOujOeG3aUSAi9xYq5twyOefYlosAfUGIV5a4kKlKq7UZXqiRgap4kdggTRv9Aps3yldddpN0UeizODdYUPZnP0cEAblxspKaNcGokwI4OYn77wZDPEPSLl6bJgZxhaqkkQFMw7A2Dq6eJh5oOVVfq/rap7uIkA0I5KvMbeK7WsxMf+fSwS9x9juiBwehhLsZo7SlJeqPjXNGbDidCGddokyzv6gDcLcNpChlFr3kJDKlgnPj3lRLU8vriE9Nzx56ZbhbJL3bnqDX/j1PKzOEYqDYyfYjTFK5JxB+cOSTbO7FuGgDLxi/EeCk94E2tuWorvpwRAdH/Mwrez32e620TQFHlIzkujLGg5/Af4/90DLtYR/hxYJH8DxSN27yafmqzSQB/Y5gbaABXUWWAl6HvF75I3VCykhEoNim2pZSuptOMG1ksygGHvGM47PsewoUnag1PFW2npHBgQ8oqyphBgUcBz2ov2ZIFKyeTqbPNT1ORjM3HjMgqXKVY0JWBI88Nn3mHQNVu/a8rSKWoQLBpMZWkx3BwjoOV8GMgxKm8CSspx1fN7aKBoeiAREUWNo+kUtLZPZAux7nvmtngXNqIeLUBFSTPwaWmeJwXZu03JNvJiNqZjmL85/7NGwkSbxW/QmiE4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(366004)(346002)(136003)(396003)(52116002)(7696005)(6506007)(1076003)(86362001)(55016002)(186003)(9686003)(4326008)(6916009)(16526019)(53546011)(54906003)(478600001)(316002)(83380400001)(66476007)(66556008)(8676002)(2906002)(38100700001)(66946007)(5660300002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?IKYb2gPCWKsptk9BCtZo8YLumM8EkSjOp8nJ0k1KWxueyR8vVk+Wf3f3Ynxq?=
 =?us-ascii?Q?uO2eSQVPchUCBT3NbnO0wBaihHAWUWosRwEu8BrTyIbfoT8ZRUEMR65eaVJz?=
 =?us-ascii?Q?Tj0GyLvTjt1dQmikNksmsO32Y+4oDv5zSbL4Sk/cNjlHieqYjf7hA8QlKR4r?=
 =?us-ascii?Q?ZE8tVAIb5bSz1Dm0YBW5sK6rQfImQoPWvDskvgDegyqNMJRCU0Q6mlWhru2I?=
 =?us-ascii?Q?xR+e1c73v8QQCmSTcYcF3MuABubiNoHZiaghODi4wCvgZCuePYLYOq9K2i3k?=
 =?us-ascii?Q?PKW4FppE+57EkO9CKPFhygNGb4BNzTtuE3Y1u4B/d88biFfc2D48xTcjlFDu?=
 =?us-ascii?Q?iyb9AryMKDy0UjbHFGWZFg/HGayyXQTPVMTdvSgvhMqMJfc11fWe7/O0nfsX?=
 =?us-ascii?Q?OQzZIPVURnmS1EjiLg5KENDaEafNwjus44rNpfnwZWrUSTGXdVOqkyZTjY5O?=
 =?us-ascii?Q?GugrOuUhLpFtjcZeHkOIfD2tqqToyIFjCTXn/ybHB77bSm6EmEJqGhtQrMki?=
 =?us-ascii?Q?x74qiwrZQ4sS1IkouVXlWAKuQW8dJnIk8NGymYx2x7UHdNQO1rLUrncSgGOO?=
 =?us-ascii?Q?Plgdxz1p7qWQUCFOV38/sJERN6hQkjfCEichznN+jeT9l3R1cN0DvW9KET4Z?=
 =?us-ascii?Q?FNSkvcHIdzjDTTvCXyfSOqLuj8+K1ROO+vaVeMPxrYHOHup3BTjvNXlPBqEO?=
 =?us-ascii?Q?gZKN3fdHK3QV5wsy4I7eLXYIuBwXaxERtFbNpf91S+x0J47Lpizq+KjD4SPu?=
 =?us-ascii?Q?PKZuepiTvE/mlEpObhE21aLzltjkbhScxN2vsFTMyT11wZ07kFh8PrkxdkgB?=
 =?us-ascii?Q?TeBcWIA9zZsXCVlGw1HcoxE73p2Xzt1iwwrDsvBSwi8LO8e4S/L/x1v52hMK?=
 =?us-ascii?Q?DEWGFuculcI7nnrniS+TnneKUdDBkxKMLro5w/0CeeUzSYV+UTS8+mfOTrfw?=
 =?us-ascii?Q?hJyZw4m91DM+jSSVSHTlqJllrVKnKWCylJpFnjC+ah8Xe070J0m7xiY+zn0e?=
 =?us-ascii?Q?mW9ac5o+mBII35sLROI28tb5jmyD4z+AKdoJ9Hpnk4TvrQFFj8nnN7udI8nN?=
 =?us-ascii?Q?g97VG/bI7TKPj0l/ti/h+rKfn0w9rTFPTZ95lPZNBeZy1ZWCG0EQBvvu8Mfc?=
 =?us-ascii?Q?ovnmFVEj5cGF3lhdC3dFzrQABvF1tOrbhLoXvqV3chQxWCFiwBat6+SpJbbx?=
 =?us-ascii?Q?XbhNHfdpO7b3DKFkRh8tFm5w4dqb3e3x1OhfUSPbZX0JYt2ZmHBEly0eUW2O?=
 =?us-ascii?Q?Y1coge+d6ASLQBePonQvHv3paxB0wkiO1Zk6b/hDDVVkKl1Xysxgl93nCYCg?=
 =?us-ascii?Q?9sB8hOHfPmxXn8HG1CzZm25UMh/PiYyE/4cyd28jIdsLPCIqEh6Onu59cSmI?=
 =?us-ascii?Q?IxM/fh0=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cf446d54-becb-42c1-aacf-08d8eb0fd3d1
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2021 19:47:28.7113
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e9gDODeY3O4cfpvqIbk2+GjwAExkJkwA4ctWTFk0e5qs0ohPY0B3/UChjRU3Hrms
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4424
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-19_10:2021-03-19,2021-03-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 phishscore=0
 impostorscore=0 suspectscore=0 mlxlogscore=999 malwarescore=0
 lowpriorityscore=0 spamscore=0 mlxscore=0 priorityscore=1501 bulkscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103190132
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 18, 2021 at 06:03:49PM -0700, Andrii Nakryiko wrote:
> On Tue, Mar 16, 2021 at 12:01 AM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > This patch adds support to BPF verifier to allow bpf program calling
> > kernel function directly.
> >
> > The use case included in this set is to allow bpf-tcp-cc to directly
> > call some tcp-cc helper functions (e.g. "tcp_cong_avoid_ai()").  Those
> > functions have already been used by some kernel tcp-cc implementations.
> >
> > This set will also allow the bpf-tcp-cc program to directly call the
> > kernel tcp-cc implementation,  For example, a bpf_dctcp may only want to
> > implement its own dctcp_cwnd_event() and reuse other dctcp_*() directly
> > from the kernel tcp_dctcp.c instead of reimplementing (or
> > copy-and-pasting) them.
> >
> > The tcp-cc kernel functions mentioned above will be white listed
> > for the struct_ops bpf-tcp-cc programs to use in a later patch.
> > The white listed functions are not bounded to a fixed ABI contract.
> > Those functions have already been used by the existing kernel tcp-cc.
> > If any of them has changed, both in-tree and out-of-tree kernel tcp-cc
> > implementations have to be changed.  The same goes for the struct_ops
> > bpf-tcp-cc programs which have to be adjusted accordingly.
> >
> > This patch is to make the required changes in the bpf verifier.
> >
> > First change is in btf.c, it adds a case in "do_btf_check_func_arg_match()".
> > When the passed in "btf->kernel_btf == true", it means matching the
> > verifier regs' states with a kernel function.  This will handle the
> > PTR_TO_BTF_ID reg.  It also maps PTR_TO_SOCK_COMMON, PTR_TO_SOCKET,
> > and PTR_TO_TCP_SOCK to its kernel's btf_id.
> >
> > In the later libbpf patch, the insn calling a kernel function will
> > look like:
> >
> > insn->code == (BPF_JMP | BPF_CALL)
> > insn->src_reg == BPF_PSEUDO_KFUNC_CALL /* <- new in this patch */
> > insn->imm == func_btf_id /* btf_id of the running kernel */
> >
> > [ For the future calling function-in-kernel-module support, an array
> >   of module btf_fds can be passed at the load time and insn->off
> >   can be used to index into this array. ]
> >
> > At the early stage of verifier, the verifier will collect all kernel
> > function calls into "struct bpf_kern_func_descriptor".  Those
> > descriptors are stored in "prog->aux->kfunc_tab" and will
> > be available to the JIT.  Since this "add" operation is similar
> > to the current "add_subprog()" and looking for the same insn->code,
> > they are done together in the new "add_subprog_and_kern_func()".
> >
> > In the "do_check()" stage, the new "check_kern_func_call()" is added
> > to verify the kernel function call instruction:
> > 1. Ensure the kernel function can be used by a particular BPF_PROG_TYPE.
> >    A new bpf_verifier_ops "check_kern_func_call" is added to do that.
> >    The bpf-tcp-cc struct_ops program will implement this function in
> >    a later patch.
> > 2. Call "btf_check_kern_func_args_match()" to ensure the regs can be
> >    used as the args of a kernel function.
> > 3. Mark the regs' type, subreg_def, and zext_dst.
> >
> > At the later do_misc_fixups() stage, the new fixup_kern_func_call()
> > will replace the insn->imm with the function address (relative
> > to __bpf_call_base).  If needed, the jit can find the btf_func_model
> > by calling the new bpf_jit_find_kern_func_model(prog, insn->imm).
> > With the imm set to the function address, "bpftool prog dump xlated"
> > will be able to display the kernel function calls the same way as
> > it displays other bpf helper calls.
> >
> > gpl_compatible program is required to call kernel function.
> >
> > This feature currently requires JIT.
> >
> > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > ---
> 
> After the initial pass it all makes sense so far. I am a bit concerned
> about s32 and kernel function offset, though. See below.
> 
> Also "kern_func" and "descriptor" are quite mouthful, it seems to me
> that using kfunc consistently wouldn't hurt readability at all. You
> also already use desc in place of "descriptor" for variables, so I'd
> do that in type names as well.
The descriptor/desc naming follows the existing poke descriptor
and some of its helper naming.

Sure. both can be renamed in v2.
s/descriptor/desc/
s/kern_func/kfunc/

> > +static int kern_func_desc_cmp_by_imm(const void *a, const void *b)
> > +{
> > +       const struct bpf_kern_func_descriptor *d0 = a;
> > +       const struct bpf_kern_func_descriptor *d1 = b;
> > +
> > +       return d0->imm - d1->imm;
> 
> this is not safe, assuming any possible s32 values, no?
Good catch. will fix.
