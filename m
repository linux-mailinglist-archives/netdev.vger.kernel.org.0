Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69C8D342642
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 20:34:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbhCSTdo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 15:33:44 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:18242 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230341AbhCSTdM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 15:33:12 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12JJEFlA020299;
        Fri, 19 Mar 2021 12:32:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=yv1ZiO2o2LtQ625jqp8nstGs5kt8Cjz6lXSUdbVFTl4=;
 b=bgmJ6dqbnqGjo/j9nUPxrUlj3UARFo1SNPwOpxgtm2f9rKXnAL/EZzgAhMdpvMfQ+9yx
 iCvy/Y0TG7RlCU3PBpJCB+X8t4o8SvjFbLDcaJvll5jW25OQGt0M6nkRQl/FA7NMyEVm
 of0w2Qs/ivp0WL4pWFFWOlrVvwWmVwCaqWY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 37cefudv03-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 19 Mar 2021 12:32:58 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 19 Mar 2021 12:32:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IDtfin1D3jrybMw5lAxAmwnYOGnA9lHe2fcaqmfGPczvjzlW2kuW2c9VSsaSkD+s7rIWIXgl8tO+fFMuFoKWIqJnPTM9pYxTW/4U/EwkLRBYCyElaeV78t7XNyYNE1aEEdhTjO8/5gj8hj8FFBRwfhmCJNe8hdU6NtNSqmfGuzcKocOIY/D7oukjKDZleJeh6zCBjNROx2wiowKQD8gLjRSqCnxd1Jl/lj//MIQBEsyBDLazYfNa7uWDH2pVyGCMB/0Fl2mU0MrHmwpiD1CtmMlh4mYuHNQJFlLoqzSXzXShWhVx/NzAEX63nbp72VplFwk2NDVz6vLQId46NgLMVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yv1ZiO2o2LtQ625jqp8nstGs5kt8Cjz6lXSUdbVFTl4=;
 b=BIiHw/xj2IhoMLfSumm0nVn/ZCvMHgH9dQ/NaOv0+JGUgD8nQNTKLxJS3OHzwf6dHitZxRuMQ7wBPnkGVbZJjHw5CjzzIY7Fx2XCvs8AHZNK/5UNSvSIy35rETTveDVw8l/Aqw3/iY4JSvHgWk6MkHlDtE4sXORXtqGSBVZTVD3KptfWUa1L2QyYUl9SMS5uSxsRYkCZxhniVGCGoOz4t/gGEKcAHU8N/s40mXVZPjU4yJXseDybqG1+hGkC6E7s+RoKjUcgILhbnM4jqGW2r4aB6iH9l9Yv+D5IPnJnpmwCpk3O//+3u5E3+gnSG+NMfk//EoXX8cNJtEo6s1zjrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2886.namprd15.prod.outlook.com (2603:10b6:a03:f7::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31; Fri, 19 Mar
 2021 19:32:52 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2975:c9d8:3f7f:dbd0]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2975:c9d8:3f7f:dbd0%5]) with mapi id 15.20.3955.024; Fri, 19 Mar 2021
 19:32:52 +0000
Date:   Fri, 19 Mar 2021 12:32:50 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next 03/15] bpf: Refactor btf_check_func_arg_match
Message-ID: <20210319193250.qogxn6ajnzoys43h@kafai-mbp.dhcp.thefacebook.com>
References: <20210316011336.4173585-1-kafai@fb.com>
 <20210316011355.4176313-1-kafai@fb.com>
 <CAEf4BzbyKPgHC8h9z--j=h9Fw+Qd6HSgCtvPvytO5nw82FJoMQ@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAEf4BzbyKPgHC8h9z--j=h9Fw+Qd6HSgCtvPvytO5nw82FJoMQ@mail.gmail.com>
X-Originating-IP: [2620:10d:c090:400::5:d22b]
X-ClientProxiedBy: BY3PR05CA0036.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::11) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:d22b) by BY3PR05CA0036.namprd05.prod.outlook.com (2603:10b6:a03:39b::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.9 via Frontend Transport; Fri, 19 Mar 2021 19:32:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 967a49e9-7c24-4434-35fb-08d8eb0dc95d
X-MS-TrafficTypeDiagnostic: BYAPR15MB2886:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2886EDBB2CBC1CD9D2D66170D5689@BYAPR15MB2886.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 58AlvGVPQ/cl8qUZluiBCz8WP273A55t1jyfVzGSJMkL6XvoNyapYIsF2GfYV458H7ecUbauvFbl2BDexFK/cmIDimmh6QK5Q9xSw73hVwR9l7mty2n5fIwZMDmUVu3pU7koa5FhuuiShdeoA5P5+UHL+7miV5W87LxAn+TOSA29r57Pp2/QgqHja8i0rNQt4SkOgwOr0itPN6hX3/+qhRoBWGBhX7xH2ZoLVdP2eZt6Rh9mnWmt7WXOSoLbIKAEtOwkjNY43DeBhyr0ownJ7jOlkeQkq3Lcmb9ZXu+qOnI/qzag9FAr7zD67Bs7uiUR4mfeRtm4d9Pxhy+yoOrnl5VFFFO5eFDWUx0RgSz6hLiXH8Ey+NzEV97YsGXEVEk+2erhFhHk1cF6fvwhuxNmqnFAu975YGMHl0kNN+HEFukS7Yv+ylwNnxz/4+jPGSLLlWT8lXoDI3Kr8q6Ez0YNisEBMFU2cvEj3kuI3pg84roZNBivpcZ98Xrg0xNaQmdxoEzpdxBzCArE4GjJmSpI0GtLPa6TheUmD/I30h8SS5vach6JZlzyoUrNgo3gKNNwUcRqbhzImQonCJIMf0b+fAiGQuiJZTBREs888I780ieynnKOx9qLYSrjCn7R9DkFB/Ud1mAElTQ2RpQ7lx6tOQCgLXYALlTbZZSf8OxKz58=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(366004)(136003)(346002)(376002)(6916009)(66556008)(316002)(66476007)(1076003)(53546011)(16526019)(52116002)(86362001)(186003)(83380400001)(54906003)(2906002)(7696005)(8936002)(55016002)(30864003)(9686003)(478600001)(4326008)(66946007)(8676002)(6506007)(38100700001)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?k8Tk11yeg+bbDduWqzzDQDpXbFR0kZvJAhConL00fLmLfuxZkz8wdIFHGJ7k?=
 =?us-ascii?Q?46Go7pbhPuXkcZ0ymU72a508XRTBN5DY7YHtBjxuk/o6jv5lLukgWDQh6CVc?=
 =?us-ascii?Q?HFtYSvCWUWF8fO4FwqHXJLo3i60Xgb7NJGPDvVZmI4KBQQlW5qyMqmaeVxkP?=
 =?us-ascii?Q?z8yZ3Uy+PlDFfKffF8t3lrcUcxz22x1W8Cy48BTZcVlt9Y5e9yKiE6rwrjtS?=
 =?us-ascii?Q?liyEAbpupA/eXSjpBJYkG2+FRatH7tAWOAVPy3IZNchDuo1JLBQOPTSOeZ1V?=
 =?us-ascii?Q?W9kTfpOaFSqZvPmphpUgIcbybJZFsw8Y2Orkbz4ClqT/w/brAycf2o9RT1fS?=
 =?us-ascii?Q?qT3iX519Z0bcFCcgKh2z/R36X0LGra/K1YTElBVVc4uQ5HgVssmvQUct/+5Z?=
 =?us-ascii?Q?KooPcDmtr0lf3Wes4QYLMhhadiD7PsM+zLxh2ZyUG25d5m0tmnHrQeiPPT8v?=
 =?us-ascii?Q?uz1WXpE/oG9+mSXS149/87EXvkOeYKRTzbQNPCK5lhDef2MbaIie8xeR+A/Z?=
 =?us-ascii?Q?2j5xRlNKoFzQ/yhzex53z5CzhFM/vTkczl82w+dfBhDuOjj9rjNG5n/LnGk1?=
 =?us-ascii?Q?uSOVhFuetelMYTZ5BgwD19V54c6OMZpaJHasR1MnGBz4WkkFLuSTkiUUJI3e?=
 =?us-ascii?Q?3DTRLPavNx9NSYvU/g5jMQ3+wPxT5TJINJKGytAoqJnplH2sUCfx2CkLyMNN?=
 =?us-ascii?Q?72LzYoIQKJOvUlVkSZEKH138xJcqZ9Zs/1DjqnGHR1coOE+oHdTyMjOkF9/K?=
 =?us-ascii?Q?exJRDtpCHSFtFSLK8RO43V8n9DTFaONxDjNtZwoLrYVjssIjbArYvyIkgm3U?=
 =?us-ascii?Q?6Q00zfCHi9vds9Wka2+2b0SvCYCycZBNEfziHUilnmbLp8iOkiYyLbmW9Qpj?=
 =?us-ascii?Q?3i1QvnInx8gOn8/n5H/Xf9s7vr6gKnAwnKMvvNvnbYFWIoTTGE0snoherTeO?=
 =?us-ascii?Q?nYLCD6NPJ8VuKbFP6k8XRrxrq1o7q7NNAdjEc/P3Tl9F4l066+sfHSwbBi5R?=
 =?us-ascii?Q?IX3kQq+yl5VDFgw6X3+f3YDh6H+1K810JoN2tSznA5vVjBxYBxgJqgMBdB7y?=
 =?us-ascii?Q?44xjCed63+8yl/3eRV75MpEVkOKeXYJe4nRb2613KCnxGMVYe9wvCy+kLbW4?=
 =?us-ascii?Q?D2eYQaEPs5L6qLK/rn2RnyO9qq+2vqC2819rET3D3ifbVjQbBT+8lJnGYlrs?=
 =?us-ascii?Q?Uzz/2tyIUaaW8BooLvcC1vquMJyg4XkK0Sp5NYOLaxtUhE48hkUS/8j03fEF?=
 =?us-ascii?Q?b+JB4M8zVXNMWDigkh1cszViHt9vrCFKwmdsxeMCMPjB/HLHLBuhl2NYmG4P?=
 =?us-ascii?Q?JY8zUyAZfqqS2JYBGoiZ5SsVP1BCxdsnELu4bPzzLKxDVQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 967a49e9-7c24-4434-35fb-08d8eb0dc95d
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2021 19:32:52.1724
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7vPB6S+B0gEyAZJfc4jLnmJkJiz+Urfy0pEZuDjAl3xM/LNO2Evh2Yw6sixKiwcS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2886
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-19_10:2021-03-19,2021-03-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 impostorscore=0 mlxscore=0 malwarescore=0 suspectscore=0 mlxlogscore=999
 adultscore=0 bulkscore=0 priorityscore=1501 clxscore=1015 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103190129
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 18, 2021 at 04:32:47PM -0700, Andrii Nakryiko wrote:
> On Tue, Mar 16, 2021 at 12:01 AM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > This patch refactors the core logic of "btf_check_func_arg_match()"
> > into a new function "do_btf_check_func_arg_match()".
> > "do_btf_check_func_arg_match()" will be reused later to check
> > the kernel function call.
> >
> > The "if (!btf_type_is_ptr(t))" is checked first to improve the indentation
> > which will be useful for a later patch.
> >
> > Some of the "btf_kind_str[]" usages is replaced with the shortcut
> > "btf_type_str(t)".
> >
> > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > ---
> >  include/linux/btf.h |   5 ++
> >  kernel/bpf/btf.c    | 159 ++++++++++++++++++++++++--------------------
> >  2 files changed, 91 insertions(+), 73 deletions(-)
> >
> > diff --git a/include/linux/btf.h b/include/linux/btf.h
> > index 7fabf1428093..93bf2e5225f5 100644
> > --- a/include/linux/btf.h
> > +++ b/include/linux/btf.h
> > @@ -140,6 +140,11 @@ static inline bool btf_type_is_enum(const struct btf_type *t)
> >         return BTF_INFO_KIND(t->info) == BTF_KIND_ENUM;
> >  }
> >
> > +static inline bool btf_type_is_scalar(const struct btf_type *t)
> > +{
> > +       return btf_type_is_int(t) || btf_type_is_enum(t);
> > +}
> > +
> >  static inline bool btf_type_is_typedef(const struct btf_type *t)
> >  {
> >         return BTF_INFO_KIND(t->info) == BTF_KIND_TYPEDEF;
> > diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> > index 96cd24020a38..529b94b601c6 100644
> > --- a/kernel/bpf/btf.c
> > +++ b/kernel/bpf/btf.c
> > @@ -4381,7 +4381,7 @@ static u8 bpf_ctx_convert_map[] = {
> >  #undef BPF_LINK_TYPE
> >
> >  static const struct btf_member *
> > -btf_get_prog_ctx_type(struct bpf_verifier_log *log, struct btf *btf,
> > +btf_get_prog_ctx_type(struct bpf_verifier_log *log, const struct btf *btf,
> >                       const struct btf_type *t, enum bpf_prog_type prog_type,
> >                       int arg)
> >  {
> > @@ -5366,122 +5366,135 @@ int btf_check_type_match(struct bpf_verifier_log *log, const struct bpf_prog *pr
> >         return btf_check_func_type_match(log, btf1, t1, btf2, t2);
> >  }
> >
> > -/* Compare BTF of a function with given bpf_reg_state.
> > - * Returns:
> > - * EFAULT - there is a verifier bug. Abort verification.
> > - * EINVAL - there is a type mismatch or BTF is not available.
> > - * 0 - BTF matches with what bpf_reg_state expects.
> > - * Only PTR_TO_CTX and SCALAR_VALUE states are recognized.
> > - */
> > -int btf_check_func_arg_match(struct bpf_verifier_env *env, int subprog,
> > -                            struct bpf_reg_state *regs)
> > +static int do_btf_check_func_arg_match(struct bpf_verifier_env *env,
> 
> do_btf_check_func_arg_match vs btf_check_func_arg_match distinction is
> not clear at all. How about something like
> 
> btf_check_func_arg_match vs btf_check_subprog_arg_match (or btf_func
> vs bpf_subprog). I think that highlights the main distinction better,
> no?
will rename.

> 
> > +                                      const struct btf *btf, u32 func_id,
> > +                                      struct bpf_reg_state *regs,
> > +                                      bool ptr_to_mem_ok)
> >  {
> >         struct bpf_verifier_log *log = &env->log;
> > -       struct bpf_prog *prog = env->prog;
> > -       struct btf *btf = prog->aux->btf;
> > -       const struct btf_param *args;
> > +       const char *func_name, *ref_tname;
> >         const struct btf_type *t, *ref_t;
> > -       u32 i, nargs, btf_id, type_size;
> > -       const char *tname;
> > -       bool is_global;
> > -
> > -       if (!prog->aux->func_info)
> > -               return -EINVAL;
> > -
> > -       btf_id = prog->aux->func_info[subprog].type_id;
> > -       if (!btf_id)
> > -               return -EFAULT;
> > -
> > -       if (prog->aux->func_info_aux[subprog].unreliable)
> > -               return -EINVAL;
> > +       const struct btf_param *args;
> > +       u32 i, nargs;
> >
> > -       t = btf_type_by_id(btf, btf_id);
> > +       t = btf_type_by_id(btf, func_id);
> >         if (!t || !btf_type_is_func(t)) {
> >                 /* These checks were already done by the verifier while loading
> >                  * struct bpf_func_info
> >                  */
> > -               bpf_log(log, "BTF of func#%d doesn't point to KIND_FUNC\n",
> > -                       subprog);
> > +               bpf_log(log, "BTF of func_id %u doesn't point to KIND_FUNC\n",
> > +                       func_id);
> >                 return -EFAULT;
> >         }
> > -       tname = btf_name_by_offset(btf, t->name_off);
> > +       func_name = btf_name_by_offset(btf, t->name_off);
> >
> >         t = btf_type_by_id(btf, t->type);
> >         if (!t || !btf_type_is_func_proto(t)) {
> > -               bpf_log(log, "Invalid BTF of func %s\n", tname);
> > +               bpf_log(log, "Invalid BTF of func %s\n", func_name);
> >                 return -EFAULT;
> >         }
> >         args = (const struct btf_param *)(t + 1);
> >         nargs = btf_type_vlen(t);
> >         if (nargs > MAX_BPF_FUNC_REG_ARGS) {
> > -               bpf_log(log, "Function %s has %d > %d args\n", tname, nargs,
> > +               bpf_log(log, "Function %s has %d > %d args\n", func_name, nargs,
> >                         MAX_BPF_FUNC_REG_ARGS);
> > -               goto out;
> > +               return -EINVAL;
> >         }
> >
> > -       is_global = prog->aux->func_info_aux[subprog].linkage == BTF_FUNC_GLOBAL;
> >         /* check that BTF function arguments match actual types that the
> >          * verifier sees.
> >          */
> >         for (i = 0; i < nargs; i++) {
> > -               struct bpf_reg_state *reg = &regs[i + 1];
> > +               u32 regno = i + 1;
> > +               struct bpf_reg_state *reg = &regs[regno];
> >
> > -               t = btf_type_by_id(btf, args[i].type);
> > -               while (btf_type_is_modifier(t))
> > -                       t = btf_type_by_id(btf, t->type);
> > -               if (btf_type_is_int(t) || btf_type_is_enum(t)) {
> > +               t = btf_type_skip_modifiers(btf, args[i].type, NULL);
> > +               if (btf_type_is_scalar(t)) {
> >                         if (reg->type == SCALAR_VALUE)
> >                                 continue;
> > -                       bpf_log(log, "R%d is not a scalar\n", i + 1);
> > -                       goto out;
> > +                       bpf_log(log, "R%d is not a scalar\n", regno);
> > +                       return -EINVAL;
> >                 }
> > -               if (btf_type_is_ptr(t)) {
> > +
> > +               if (!btf_type_is_ptr(t)) {
> > +                       bpf_log(log, "Unrecognized arg#%d type %s\n",
> > +                               i, btf_type_str(t));
> > +                       return -EINVAL;
> > +               }
> > +
> > +               ref_t = btf_type_skip_modifiers(btf, t->type, NULL);
> > +               ref_tname = btf_name_by_offset(btf, ref_t->name_off);
> 
> these two seem to be used only inside else `if (ptr_to_mem_ok)`, let's
> move the code and variables inside that branch?
It is kept here because the next patch uses it in
another case also.

> 
> > +               if (btf_get_prog_ctx_type(log, btf, t, env->prog->type, i)) {
> >                         /* If function expects ctx type in BTF check that caller
> >                          * is passing PTR_TO_CTX.
> >                          */
> > -                       if (btf_get_prog_ctx_type(log, btf, t, prog->type, i)) {
> > -                               if (reg->type != PTR_TO_CTX) {
> > -                                       bpf_log(log,
> > -                                               "arg#%d expected pointer to ctx, but got %s\n",
> > -                                               i, btf_kind_str[BTF_INFO_KIND(t->info)]);
> > -                                       goto out;
> > -                               }
> > -                               if (check_ctx_reg(env, reg, i + 1))
> > -                                       goto out;
> > -                               continue;
> > +                       if (reg->type != PTR_TO_CTX) {
> > +                               bpf_log(log,
> > +                                       "arg#%d expected pointer to ctx, but got %s\n",
> > +                                       i, btf_type_str(t));
> > +                               return -EINVAL;
> >                         }
> > +                       if (check_ctx_reg(env, reg, regno))
> > +                               return -EINVAL;
> 
> original code had `continue` here allowing to stop tracking if/else
> logic. Any specific reason you removed it? It keeps logic simpler to
> follow, imo.
There is no other case after this.
"continue" becomes redundant, so removed.

> 
> > +               } else if (ptr_to_mem_ok) {
> 
> similarly to how you did reduction of nestedness with btf_type_is_ptr, I'd do
> 
> if (!ptr_to_mem_ok)
>     return -EINVAL;
> 
> and let brain forget about another if/else branch tracking
I don't see a significant difference.  Either way looks the same with
a few more test cases, IMO.

I prefer to keep it like this since there is
another test case added in the next patch.

There are usages with much longer if-else-if statement inside a
loop in the verifier also without explicit "continue" in the middle
or handle the last case differently and they are very readable.

> 
> > +                       const struct btf_type *resolve_ret;
> > +                       u32 type_size;
> >
> > -                       if (!is_global)
> > -                               goto out;
> > -
> > -                       t = btf_type_skip_modifiers(btf, t->type, NULL);
> > -
> > -                       ref_t = btf_resolve_size(btf, t, &type_size);
> > -                       if (IS_ERR(ref_t)) {
> > +                       resolve_ret = btf_resolve_size(btf, ref_t, &type_size);
> > +                       if (IS_ERR(resolve_ret)) {
> >                                 bpf_log(log,
> > -                                   "arg#%d reference type('%s %s') size cannot be determined: %ld\n",
> > -                                   i, btf_type_str(t), btf_name_by_offset(btf, t->name_off),
> > -                                       PTR_ERR(ref_t));
> > -                               goto out;
> > +                                       "arg#%d reference type('%s %s') size cannot be determined: %ld\n",
> > +                                       i, btf_type_str(ref_t), ref_tname,
> > +                                       PTR_ERR(resolve_ret));
> > +                               return -EINVAL;
> >                         }
> >
> > -                       if (check_mem_reg(env, reg, i + 1, type_size))
> > -                               goto out;
> > -
> > -                       continue;
> > +                       if (check_mem_reg(env, reg, regno, type_size))
> > +                               return -EINVAL;
> > +               } else {
> > +                       return -EINVAL;
> >                 }
> > -               bpf_log(log, "Unrecognized arg#%d type %s\n",
> > -                       i, btf_kind_str[BTF_INFO_KIND(t->info)]);
> > -               goto out;
> >         }
> > +
> >         return 0;
> > -out:
> > +}
> > +
> > +/* Compare BTF of a function with given bpf_reg_state.
> > + * Returns:
> > + * EFAULT - there is a verifier bug. Abort verification.
> > + * EINVAL - there is a type mismatch or BTF is not available.
> > + * 0 - BTF matches with what bpf_reg_state expects.
> > + * Only PTR_TO_CTX and SCALAR_VALUE states are recognized.
> > + */
> > +int btf_check_func_arg_match(struct bpf_verifier_env *env, int subprog,
> > +                            struct bpf_reg_state *regs)
> > +{
> > +       struct bpf_prog *prog = env->prog;
> > +       struct btf *btf = prog->aux->btf;
> > +       bool is_global;
> > +       u32 btf_id;
> > +       int err;
> > +
> > +       if (!prog->aux->func_info)
> > +               return -EINVAL;
> > +
> > +       btf_id = prog->aux->func_info[subprog].type_id;
> > +       if (!btf_id)
> > +               return -EFAULT;
> > +
> > +       if (prog->aux->func_info_aux[subprog].unreliable)
> > +               return -EINVAL;
> > +
> > +       is_global = prog->aux->func_info_aux[subprog].linkage == BTF_FUNC_GLOBAL;
> > +       err = do_btf_check_func_arg_match(env, btf, btf_id, regs, is_global);
> > +
> >         /* Compiler optimizations can remove arguments from static functions
> >          * or mismatched type can be passed into a global function.
> >          * In such cases mark the function as unreliable from BTF point of view.
> >          */
> > -       prog->aux->func_info_aux[subprog].unreliable = true;
> > -       return -EINVAL;
> > +       if (err == -EINVAL)
> > +               prog->aux->func_info_aux[subprog].unreliable = true;
> 
> is there any harm marking it unreliable for any error? this makes it
> look like -EINVAL is super-special. If it's EFAULT, it won't matter,
> right?
will always assign true on any err.

> 
> > +       return err;
> >  }
> >
> >  /* Convert BTF of a function into bpf_reg_state if possible
> > --
> > 2.30.2
> >
