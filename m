Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC3E4278957
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 15:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728629AbgIYNTg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 09:19:36 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:61626 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727733AbgIYNTg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 09:19:36 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08PD9VWk009665;
        Fri, 25 Sep 2020 06:18:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=LUAsESVPP4leJU1xQxMMvCwcVHyUywRDtPLr9i29DRg=;
 b=dysZHjzSjshZejkMr6v117aTz0Y8bDeE5Zp5tBJDy+h9D4QSwtEtme5wHlDQ4zS/+hdF
 8OdPsKNDsv2qW4O5hiIrRm6W8ZdBs8iQYd9I4I8IeaQfKowhVjUR3iRRkt5BGzRS4kff
 p9dnIpEGoWB9B/GUwDyBSNRctLi+7fSHU64= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 33sdm18y7u-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 25 Sep 2020 06:18:33 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 25 Sep 2020 06:18:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kxj4Q9nMYt6h8V6WYsW8GeoDBCol1qbrzC0Ezuw/qerBRmtPAtA6H6EUn7rGoDcuTxriJFS0ShQv96cbiPUZybBUHci2hkMLKNeNBj/Iyq1zSi45hXIe46GQC/+deZJo2OIp7bNiEAocm7kTvZ/LSqH8m3vS7X7bfc0oyfoSQRZot7lKGj0B8aZjdvWje5FLeVSAJecGjBoTTk9O/lXEX6etIgFSBM4PmsR+y6zUhbRqfTdvaMmWJ9Wsz0ol9okNnUbjSXr82mdaK81OWejYVZrWhT7rx5q0MKA/+ATTVUrz3EdK1AuRgxcv5EkKyHOK6vl8SNH8tNFkcTeXiJPSdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LUAsESVPP4leJU1xQxMMvCwcVHyUywRDtPLr9i29DRg=;
 b=H/U1nld2YMUHNDvr8UTjdVSPWJ43rD8Ji3Hd9NBaDDNANgAEa3ab05ZlIxBAjXRqej1J6UiDtJQdPiROhk5jVCvaaeJrEiwEUD1CXaq5ibGk1PzTpd6fSfRZ3esSP7riF+TSF4Yk9Jm/+IEGO4cfmX5bnYMRWBccNjRKDtvci9ZUrNQR+PLugVHpVOn7VbyHGsnz0NV19kPIDawI+YTLkoOTSjF/MZtWyv9lm3W7sG4x3aqgAr05SestKpjqtN94Mrb6z93PfqtfL/A9I62XrCZaN+j0Iaclj6q8T/ZK96Y/QBEATKs7K6D4afOnBzQkfbmK6SJf1+G6bufsOT5FBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LUAsESVPP4leJU1xQxMMvCwcVHyUywRDtPLr9i29DRg=;
 b=j/cZHx2UOp1URBSS5PZANoNzkiSRNsvCiymEhTqCxbMOZuTtl19/2rko+Q0YI9deXyWCIESZ5u6ZUAiVYU87tcaBR9arZPNeDEntVJwA73Fjsi63F5RRD4pxHikwXkaeQ1KAB84ODzMtwgHfoUwfSblfrTdhqcgpRQa8c05uPH0=
Authentication-Results: cloudflare.com; dkim=none (message not signed)
 header.d=none;cloudflare.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2376.namprd15.prod.outlook.com (2603:10b6:a02:8c::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.22; Fri, 25 Sep
 2020 13:18:28 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c13c:fca9:5e04:9bfb]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c13c:fca9:5e04:9bfb%3]) with mapi id 15.20.3391.027; Fri, 25 Sep 2020
 13:18:28 +0000
Date:   Fri, 25 Sep 2020 06:18:20 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Lorenz Bauer <lmb@cloudflare.com>
CC:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH v4 bpf-next 02/13] bpf: Enable bpf_skc_to_* sock casting
 helper to networking prog type
Message-ID: <20200925131820.f5yknxfzivjuy6j6@kafai-mbp>
References: <20200925000337.3853598-1-kafai@fb.com>
 <20200925000350.3855720-1-kafai@fb.com>
 <CACAyw98fk6Vp3H_evke+-azatkz7eoqQaqy+37mMshkQf1Ri4Q@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACAyw98fk6Vp3H_evke+-azatkz7eoqQaqy+37mMshkQf1Ri4Q@mail.gmail.com>
X-ClientProxiedBy: MWHPR11CA0036.namprd11.prod.outlook.com
 (2603:10b6:300:115::22) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:e8a0) by MWHPR11CA0036.namprd11.prod.outlook.com (2603:10b6:300:115::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20 via Frontend Transport; Fri, 25 Sep 2020 13:18:26 +0000
X-Originating-IP: [2620:10d:c090:400::5:e8a0]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 344afa70-d830-4e9e-6b70-08d861557d4d
X-MS-TrafficTypeDiagnostic: BYAPR15MB2376:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB23765368824B1DE53D33DFE0D5360@BYAPR15MB2376.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2043;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9nJE+1Wenu5zgZjmNQnlI/DIAmzincIw1tRRQM5sL2XGHwK5zQeFGcArKBBTr4BZlswYD6N2cJmwJCXSZ8yIbuXUYURUTBHoB7EDXiaNpWm0V4DSYEqazmX/f7jIVpVFAsnv9tRknI/0LS2B4aXfKZCdj7PfIGSzAD79ri4OdanyBmCm/9ImiPCAgjJMIxioKr8PB8q26E1VyZkxfuOvULPUOp42xUpREq1YOaEQlcvUoECbIGG+/hPqyGWZELOUbSsApsXEsDJnq8GEaOEA4etdpwCW2P7JDZ7PL2OeCEj728GKHkbN9wNDUSLPAxffPCuoucy1Ftq2cRZ7gjgat9MubGc26zxWhqrxuqIcE57x7oBO1XQqBlxJ044Pi3/F9GqQ2rsSADSIgz+e/c0ufg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(376002)(346002)(39860400002)(396003)(316002)(66946007)(478600001)(5660300002)(8936002)(1076003)(966005)(2906002)(66476007)(9686003)(83380400001)(4326008)(86362001)(66556008)(6916009)(186003)(16526019)(33716001)(52116002)(6496006)(54906003)(55016002)(8676002)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: i6tbE6Q2QfODknVADwaZJA8uN31IDRBOupqFOUap2WJq/VGOXEHHS7s9KBc/PAY25B1G2uVc07UFGoN8nsMboM3fMEyEhuMkP2eVFgYCwo0sOLrnQjYp6wYgT457KRsRYkkR0xLSiTW+PHGOy7HpBv+kDeP99Qf/isiUkoVJHvNeQywnH6rgS+lkW0GFw/LVuJgZpL9QITbyRizcJECkocS69qfBy5JBpPS1XVcSDi//raAnGasgPoVJf1wF28dY9Yvq0LiERg/YLDigJuP2vnXo9kuqyogRz0j1xX3NoEgGpZN3FqPGckbRyVim5KgLrDNg8LxMGTEeVpaOHK7S1DhhFw0lTLExla6bBOvPtx6a2JcL8RRxGNtdWGB2MH9LxEdSY8nGtKkDm6vaNfW7KKnTfZ93ffkpejvcEMhXyOJOUykXKYdCrdBEuTNxfZ80vULRJbgH1afb57YTDdjmSgh0XYw8QWjoSdmFOc4F5JG05jPnlCKdluHi42vCJ2fbB1MEAwhW/8Ea1TrFyazWK0fntfC5Vug0iNiyZN0q4vQYrTMkf24eKrjoWaBR4Gt2PwVERhMFuxqsuGrzKWa8ODwwfHOI3MdX+5k2tx1acJkxCPYjpJFCexDmKG/Pif2aYw//FZHMJLfpkKjwkZAIUG+eb/zCKf5LQT9uTdylivY=
X-MS-Exchange-CrossTenant-Network-Message-Id: 344afa70-d830-4e9e-6b70-08d861557d4d
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2020 13:18:27.8293
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2yLUX821gWdxo/+1rLh8ZO8NcQLIceol7Wb+ujFFZIvCSlvXivPpEcNOb3KwsNz5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2376
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-25_11:2020-09-24,2020-09-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 lowpriorityscore=0 spamscore=0 impostorscore=0 malwarescore=0
 suspectscore=0 bulkscore=0 adultscore=0 phishscore=0 clxscore=1015
 mlxscore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2009250092
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 25, 2020 at 09:26:36AM +0100, Lorenz Bauer wrote:
> On Fri, 25 Sep 2020 at 01:04, Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > There is a constant need to add more fields into the bpf_tcp_sock
> > for the bpf programs running at tc, sock_ops...etc.
> >
> > A current workaround could be to use bpf_probe_read_kernel().  However,
> > other than making another helper call for reading each field and missing
> > CO-RE, it is also not as intuitive to use as directly reading
> > "tp->lsndtime" for example.  While already having perfmon cap to do
> > bpf_probe_read_kernel(), it will be much easier if the bpf prog can
> > directly read from the tcp_sock.
> >
> > This patch tries to do that by using the existing casting-helpers
> > bpf_skc_to_*() whose func_proto returns a btf_id.  For example, the
> > func_proto of bpf_skc_to_tcp_sock returns the btf_id of the
> > kernel "struct tcp_sock".
> >
> > These helpers are also added to is_ptr_cast_function().
> > It ensures the returning reg (BPF_REF_0) will also carries the ref_obj_id.
> > That will keep the ref-tracking works properly.
> >
> > The bpf_skc_to_* helpers are made available to most of the bpf prog
> > types in filter.c. The bpf_skc_to_* helpers will be limited by
> > perfmon cap.
> >
> > This patch adds a ARG_PTR_TO_BTF_ID_SOCK_COMMON.  The helper accepting
> > this arg can accept a btf-id-ptr (PTR_TO_BTF_ID + &btf_sock_ids[BTF_SOCK_TYPE_SOCK_COMMON])
> > or a legacy-ctx-convert-skc-ptr (PTR_TO_SOCK_COMMON).  The bpf_skc_to_*()
> > helpers are changed to take ARG_PTR_TO_BTF_ID_SOCK_COMMON such that
> > they will accept pointer obtained from skb->sk.
> >
> > Instead of specifying both arg_type and arg_btf_id in the same func_proto
> > which is how the current ARG_PTR_TO_BTF_ID does, the arg_btf_id of
> > the new ARG_PTR_TO_BTF_ID_SOCK_COMMON is specified in the
> > compatible_reg_types[] in verifier.c.  The reason is the arg_btf_id is
> > always the same.  Discussion in this thread:
> > https://lore.kernel.org/bpf/20200922070422.1917351-1-kafai@fb.com/
> >
> > The ARG_PTR_TO_BTF_ID_ part gives a clear expectation that the helper is
> > expecting a PTR_TO_BTF_ID which could be NULL.  This is the same
> > behavior as the existing helper taking ARG_PTR_TO_BTF_ID.
> >
> > The _SOCK_COMMON part means the helper is also expecting the legacy
> > SOCK_COMMON pointer.
> >
> > By excluding the _OR_NULL part, the bpf prog cannot call helper
> > with a literal NULL which doesn't make sense in most cases.
> > e.g. bpf_skc_to_tcp_sock(NULL) will be rejected.  All PTR_TO_*_OR_NULL
> > reg has to do a NULL check first before passing into the helper or else
> > the bpf prog will be rejected.  This behavior is nothing new and
> > consistent with the current expectation during bpf-prog-load.
> >
> > [ ARG_PTR_TO_BTF_ID_SOCK_COMMON will be used to replace
> >   ARG_PTR_TO_SOCK* of other existing helpers later such that
> >   those existing helpers can take the PTR_TO_BTF_ID returned by
> >   the bpf_skc_to_*() helpers.
> >
> >   The only special case is bpf_sk_lookup_assign() which can accept a
> >   literal NULL ptr.  It has to be handled specially in another follow
> >   up patch if there is a need (e.g. by renaming ARG_PTR_TO_SOCKET_OR_NULL
> >   to ARG_PTR_TO_BTF_ID_SOCK_COMMON_OR_NULL). ]
> >
> > [ When converting the older helpers that take ARG_PTR_TO_SOCK* in
> >   the later patch, if the kernel does not support BTF,
> >   ARG_PTR_TO_BTF_ID_SOCK_COMMON will behave like ARG_PTR_TO_SOCK_COMMON
> >   because no reg->type could have PTR_TO_BTF_ID in this case.
> >
> >   It is not a concern for the newer-btf-only helper like the bpf_skc_to_*()
> >   here though because these helpers must require BTF vmlinux to begin
> >   with. ]
> >
> > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > ---
> >  include/linux/bpf.h   |  1 +
> >  kernel/bpf/verifier.c | 34 +++++++++++++++++++--
> >  net/core/filter.c     | 69 ++++++++++++++++++++++++++++++-------------
> >  3 files changed, 82 insertions(+), 22 deletions(-)
> >
> > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > index fc5c901c7542..d0937f1d2980 100644
> > --- a/include/linux/bpf.h
> > +++ b/include/linux/bpf.h
> > @@ -292,6 +292,7 @@ enum bpf_arg_type {
> >         ARG_PTR_TO_ALLOC_MEM,   /* pointer to dynamically allocated memory */
> >         ARG_PTR_TO_ALLOC_MEM_OR_NULL,   /* pointer to dynamically allocated memory or NULL */
> >         ARG_CONST_ALLOC_SIZE_OR_ZERO,   /* number of allocated bytes requested */
> > +       ARG_PTR_TO_BTF_ID_SOCK_COMMON,  /* pointer to in-kernel sock_common or bpf-mirrored bpf_sock */
> >         __BPF_ARG_TYPE_MAX,
> >  };
> >
> > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > index 945fa2b4d096..d4ba29fb17a6 100644
> > --- a/kernel/bpf/verifier.c
> > +++ b/kernel/bpf/verifier.c
> > @@ -486,7 +486,12 @@ static bool is_acquire_function(enum bpf_func_id func_id,
> >  static bool is_ptr_cast_function(enum bpf_func_id func_id)
> >  {
> >         return func_id == BPF_FUNC_tcp_sock ||
> > -               func_id == BPF_FUNC_sk_fullsock;
> > +               func_id == BPF_FUNC_sk_fullsock ||
> > +               func_id == BPF_FUNC_skc_to_tcp_sock ||
> > +               func_id == BPF_FUNC_skc_to_tcp6_sock ||
> > +               func_id == BPF_FUNC_skc_to_udp6_sock ||
> > +               func_id == BPF_FUNC_skc_to_tcp_timewait_sock ||
> > +               func_id == BPF_FUNC_skc_to_tcp_request_sock;
> >  }
> >
> >  /* string representation of 'enum bpf_reg_type' */
> > @@ -3953,6 +3958,7 @@ static int resolve_map_arg_type(struct bpf_verifier_env *env,
> >
> >  struct bpf_reg_types {
> >         const enum bpf_reg_type types[10];
> > +       u32 *btf_id;
> >  };
> >
> >  static const struct bpf_reg_types map_key_value_types = {
> > @@ -3973,6 +3979,17 @@ static const struct bpf_reg_types sock_types = {
> >         },
> >  };
> >
> > +static const struct bpf_reg_types btf_id_sock_common_types = {
> > +       .types = {
> > +               PTR_TO_SOCK_COMMON,
> > +               PTR_TO_SOCKET,
> > +               PTR_TO_TCP_SOCK,
> > +               PTR_TO_XDP_SOCK,
> > +               PTR_TO_BTF_ID,
> > +       },
> > +       .btf_id = &btf_sock_ids[BTF_SOCK_TYPE_SOCK_COMMON],
> > +};
> > +
> >  static const struct bpf_reg_types mem_types = {
> >         .types = {
> >                 PTR_TO_STACK,
> > @@ -4014,6 +4031,7 @@ static const struct bpf_reg_types *compatible_reg_types[__BPF_ARG_TYPE_MAX] = {
> >         [ARG_PTR_TO_CTX]                = &context_types,
> >         [ARG_PTR_TO_CTX_OR_NULL]        = &context_types,
> >         [ARG_PTR_TO_SOCK_COMMON]        = &sock_types,
> > +       [ARG_PTR_TO_BTF_ID_SOCK_COMMON] = &btf_id_sock_common_types,
> >         [ARG_PTR_TO_SOCKET]             = &fullsock_types,
> >         [ARG_PTR_TO_SOCKET_OR_NULL]     = &fullsock_types,
> >         [ARG_PTR_TO_BTF_ID]             = &btf_ptr_types,
> > @@ -4059,6 +4077,14 @@ static int check_reg_type(struct bpf_verifier_env *env, u32 regno,
> >
> >  found:
> >         if (type == PTR_TO_BTF_ID) {
> > +               if (!arg_btf_id) {
> > +                       if (!compatible->btf_id) {
> > +                               verbose(env, "verifier internal error: missing arg compatible BTF ID\n");
> > +                               return -EFAULT;
> > +                       }
> > +                       arg_btf_id = compatible->btf_id;
> > +               }
> > +
> >                 if (!btf_struct_ids_match(&env->log, reg->off, reg->btf_id,
> >                                           *arg_btf_id)) {
> >                         verbose(env, "R%d is of type %s but %s is expected\n",
> > @@ -4575,10 +4601,14 @@ static bool check_btf_id_ok(const struct bpf_func_proto *fn)
> >  {
> >         int i;
> >
> > -       for (i = 0; i < ARRAY_SIZE(fn->arg_type); i++)
> > +       for (i = 0; i < ARRAY_SIZE(fn->arg_type); i++) {
> >                 if (fn->arg_type[i] == ARG_PTR_TO_BTF_ID && !fn->arg_btf_id[i])
> >                         return false;
> >
> > +               if (fn->arg_type[i] != ARG_PTR_TO_BTF_ID && fn->arg_btf_id[i])
> > +                       return false;
> > +       }
> > +
> 
> This is a hold over from the previous patchset?
hmm... what do you mean?
