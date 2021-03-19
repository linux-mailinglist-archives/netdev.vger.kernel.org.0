Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ADB134147D
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 06:07:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233681AbhCSFHT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 01:07:19 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:62922 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233568AbhCSFHK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 01:07:10 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12J55vUm013217;
        Thu, 18 Mar 2021 22:06:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=y9Klw24MTxvkDWRn88Kl5h8SZGluDwh2YWshnLRvNF4=;
 b=BKO1SOJo4bFChgBz4Ir8sSPJc+NgCqCPjatoQFiH2lsi1bryeXZKeYQ559vyxhnQmA+a
 o7uEzD7xc2lW8raIxEyIGfqXm6ktI7CrprTGC1GC2qJlOfi8/O9q3mHKXX9v2iYvp+Wy
 Fdc0+JpGidKDcMnn6FMQqVUAdyrU16tSrKg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 37bs1w8ra4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 18 Mar 2021 22:06:54 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 18 Mar 2021 22:06:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dBmo9Sbe+taAMjBwwort3eoIrI5SDXe7NVcnM7Zie78A7FyTuIh6RpUfwVzJmTVCzgviuns0PkRtYvZDjY5IJ1K202CGTQskXMH9Zh9ENdMIgfPzktggIErI5SHUUj+meTJoMGJksX0E9DMhYzARckSfSFvlHzXTdX2toK4NVGyTd9eZ0FnB++bqYDfzO5GQdgL3bCqSfA5DGmAjoLBwa0Fox6/p5J+lyh+dmVw7//BuzFX/9rnolzMk9ZKoGsSdrssKTOwBUSduTP2++AcjTGWnR2y4e3IqZSODy8kv/brb9gc9kuNlhB0nbI4x7MzXdGkhDdCzifA+TeXsnWd1zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sF7oVkiPpL7oXXGAgdrqExwXMBMubMCNhCLStOkwRac=;
 b=KEbZKOuQ9dIMFIZ2DFcci8eVUKS5HTssTiaJZ6ARQS6gnKCBmvnafMEB9uVBgIXgrsnQ1x9Dv6wlcO9eCvadCdgz6W75qXr++wnpLfmmWHNU3SHKuBX5BTtWoJVmng0HbPwPqCScY4SKFgY0KxqL7bXgv5+Gv2KD02/FonFaVLXOnuwPoXROHQda9vEwIduTK+9ey2cB54JzprcBdy1r0kzzei7fIvvNvUYy+wOPZTNybFdi9kKaSVF2ODv6suHxu7rfOM9w9Jjn+i6dHehMwFO7orSxl3f8SWltmktw7ILyl4t2RloVVY76vfQfLyhe2YHvpMcB4EKA0xLR3VUB1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2837.namprd15.prod.outlook.com (2603:10b6:a03:f9::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Fri, 19 Mar
 2021 05:06:50 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2975:c9d8:3f7f:dbd0]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2975:c9d8:3f7f:dbd0%5]) with mapi id 15.20.3955.018; Fri, 19 Mar 2021
 05:06:50 +0000
Date:   Thu, 18 Mar 2021 22:06:49 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next 12/15] libbpf: Support extern kernel function
Message-ID: <20210319050649.ytoy4kpw6pvap4ky@kafai-mbp.dhcp.thefacebook.com>
References: <20210316011336.4173585-1-kafai@fb.com>
 <20210316011451.4180026-1-kafai@fb.com>
 <CAEf4BzZVROg4Ygas2q-FFmc4o=yk+oHtx6KV_b=93OZbsjK0Bw@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAEf4BzZVROg4Ygas2q-FFmc4o=yk+oHtx6KV_b=93OZbsjK0Bw@mail.gmail.com>
X-Originating-IP: [2620:10d:c090:400::5:2c43]
X-ClientProxiedBy: SJ0PR03CA0080.namprd03.prod.outlook.com
 (2603:10b6:a03:331::25) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:2c43) by SJ0PR03CA0080.namprd03.prod.outlook.com (2603:10b6:a03:331::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Fri, 19 Mar 2021 05:06:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a8ef3656-986f-4d94-0f88-08d8ea94cdd0
X-MS-TrafficTypeDiagnostic: BYAPR15MB2837:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB28374A3A46877ED8F16BC117D5689@BYAPR15MB2837.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:1247;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mDp+DNuo8TMMHhUPqOvIyelpK4VZXdlE/sT1WxCv4Hz65Y/Ip09Cf0hDGNCPwhZfvoddSBwugtlz/uq5EMutXKGWnqvTIDZUfevLJg0zslK9xSomQg/YomlQpv+pFK/ldoSdk9ux3HEbYT0nX4HBctFj+bOWcNVFVzLXGmhDRF01SXvGTE82tSEUYX2mMKCHeIJW5L+6MUaGNTpf/CMWSGl6lRPbywAerIIFcm8hrlKV8fvYAhgMPbTAbPbCtbw91v+hg2Pqf/eKsNxhae1bCtRhoen0zu8Ra9fBL3R4TvODAhb1x5vnZxCTmZOHZVNgsfihnOzVjncbZjXFrv9CDYUvf16Yf8KgQRARGFydSVcusDn0f1WazMUDbaJm6TI+uvvGXo3oxAndHwozS8gc1XiogN0YUTEurryadQHZCg7R9AaDL39+OF/+/5Z83En7UKGMEreQ/A1+LjPELVj5SF7NDcRiYieGYICMfKxqZfghV+c+upY44nZt8OSXYKkcNF+aTHR13iUHaUTqsYng0c2RMdFK7hF0GyvbFY2DsjIsOI6JtARtvdcup34d4Ra+53jtsX3+klz+Kp80d+iGe0EUsVcDL1wxjXt07KPIAohZFrZXGAV6NM5jQwYKkMzx70amDOaJKAaVoaZ21k9iDI7xBYrOBYdAqcASenfy/3JvEOA/Wn0+MQYoTTnmgaLN1g0E3Kcj05KmGH3E0/pze04rF2AabiX+NjJHsXv0VdM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(39860400002)(136003)(346002)(396003)(66946007)(478600001)(53546011)(54906003)(52116002)(7696005)(6506007)(9686003)(55016002)(966005)(66556008)(66476007)(4326008)(186003)(8936002)(5660300002)(2906002)(86362001)(30864003)(6916009)(316002)(8676002)(83380400001)(16526019)(1076003)(38100700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?3026KYYJIryXMDtsbNBobm0KmN/Ku8AZDDE0JNuAFlcyJgrwLwGp8UFT1dZ4?=
 =?us-ascii?Q?d/9VZmmat7oPLW01aX+Hn3jThV6sI7bWA95Mb/Pjrb+wYQamps98rPoU1PBU?=
 =?us-ascii?Q?79sHpEYaKw0KzZn1EUeTmzkBbcEuechazVfyZOE35s3KqHHWtrWoZ9nYJ6W6?=
 =?us-ascii?Q?gXwv7/3wB84gjXGt/sTiF98FOk/WQsmd3Rp/vMuC4ZWGCO0tF/Qay3MSoniF?=
 =?us-ascii?Q?Bl11n520QETCt8k3Zlc/Q9jiUtn+KT+v2dvj7XHVeKCWmTN3nQyXRHbZgKGG?=
 =?us-ascii?Q?gEVQPQcxYQ6ulnKZAbbwMzMgI/O1Mkyq7Q60SJ0fXO5cx/eJkh1Dc0mKQOtm?=
 =?us-ascii?Q?pLhkwJBmd3cqntNpDyabWizFMIe49PLJ4Mc//KffY+/n6Z1a5+A6CWewc3F7?=
 =?us-ascii?Q?PA6xu+yMuMznqNNk5SDD1qVgXF8APU9q3nWZy9TmPy7j/Y89KdCks21PXyuH?=
 =?us-ascii?Q?eTP0c9fZdXmf+38JMM3kKsiByGAeAQ9+8YaQLoh0WDN2tdJnXl4mh8Hr3/AZ?=
 =?us-ascii?Q?PR/z2NFTUhc9FhE6SalrELSsy43ZlVBIyNqPpJerV7dJ/NRu/YRuEgLo7IwT?=
 =?us-ascii?Q?llR/PeWamxBSEzSvb93Tijzagsk2QvWDreCgMFacrGWMZL7kFr06q2FgTb10?=
 =?us-ascii?Q?insOtZcvims/YMpoavZsiyI3AQjyDfBc6E/+pGRoCdBd1LgSFIknJLFp+zMY?=
 =?us-ascii?Q?PrmwWpRCooFD3CVTzEDBoe88EkjAtM0JRZiurvseFIaqQlyTmoVc1S9I8NKQ?=
 =?us-ascii?Q?fYFhgXu9XFELzAI2zcVAJB1tFyHt6El9GzOleQXz/xI7wuNvnBar9kdt0El+?=
 =?us-ascii?Q?HyMFkKSkShOfS1eGsMrD5EAdECbfhlngbveyGtGUVjFJLaf9lw01YoeIDYRN?=
 =?us-ascii?Q?Xh5Pk/lvqENZbFYh8OF4g5NuhBNyFPd8TzKHfvJlQlunQwCsuJ9yb4nTl1de?=
 =?us-ascii?Q?SAY1PYf537I7lg8jJUDMBxO8F45zhtqvs7D1hdBAADm/TpVG7ZgeocMkCJZ4?=
 =?us-ascii?Q?uXy2N3Ni4WYhejaRxQ6nQfi1Tfma6UCLu/Wg2n3zPeA+iS0rscNwmvjnIpdp?=
 =?us-ascii?Q?OPsNbcYIJAuzhgBg5OYzVwYai4QmHY2mnozrR3vKCBflnW6UcaGR+9TmkArs?=
 =?us-ascii?Q?HYx9BVCzFmpJYJGtTTa3HhDcsEe9HAeIv0to4eREf8yCFd+YphzcLrCy1OaD?=
 =?us-ascii?Q?INDWKEtUHKjpbrn4CF9z+Cn+co+z/VXQmM8OYh78NUPb+ChxYK43eCyfjmjB?=
 =?us-ascii?Q?kGIeWA5ZnTfSy0BWG30rSr3m/KV4WIawqoWZlxki/UuF4zArSDuRVMZ4wmY+?=
 =?us-ascii?Q?6UQNu3aQL09rE0vvA/V7u8irMurR/dbkOEZL2fNIB+qkFg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a8ef3656-986f-4d94-0f88-08d8ea94cdd0
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2021 05:06:50.5967
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: drO91ecJiS+AEWnOoprZ/0hcyPev77+DI1+EtujuXd7oXobY/8OQQ5FFLaNHPyMy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2837
X-OriginatorOrg: fb.com
X-Proofpoint-UnRewURL: 1 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-19_01:2021-03-17,2021-03-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 phishscore=0 spamscore=0 priorityscore=1501 adultscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103190036
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 18, 2021 at 09:11:39PM -0700, Andrii Nakryiko wrote:
> On Tue, Mar 16, 2021 at 12:02 AM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > This patch is to make libbpf able to handle the following extern
> > kernel function declaration and do the needed relocations before
> > loading the bpf program to the kernel.
> >
> > extern int foo(struct sock *) __attribute__((section(".ksyms")))
> >
> > In the collect extern phase, needed changes is made to
> > bpf_object__collect_externs() and find_extern_btf_id() to collect
> > function.
> >
> > In the collect relo phase, it will record the kernel function
> > call as RELO_EXTERN_FUNC.
> >
> > bpf_object__resolve_ksym_func_btf_id() is added to find the func
> > btf_id of the running kernel.
> >
> > During actual relocation, it will patch the BPF_CALL instruction with
> > src_reg = BPF_PSEUDO_FUNC_CALL and insn->imm set to the running
> > kernel func's btf_id.
> >
> > btf_fixup_datasec() is changed also because a datasec may
> > only have func and its size will be 0.  The "!size" test
> > is postponed till it is confirmed there are vars.
> > It also takes this chance to remove the
> > "if (... || (t->size && t->size != size)) { return -ENOENT; }" test
> > because t->size is zero at the point.
> >
> > The required LLVM patch: https://reviews.llvm.org/D93563 
> >
> > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > ---
> >  tools/lib/bpf/btf.c    |  32 ++++++++----
> >  tools/lib/bpf/btf.h    |   5 ++
> >  tools/lib/bpf/libbpf.c | 113 +++++++++++++++++++++++++++++++++++++----
> >  3 files changed, 129 insertions(+), 21 deletions(-)
> >
> > diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
> > index 3aa58f2ac183..bb09b577c154 100644
> > --- a/tools/lib/bpf/btf.c
> > +++ b/tools/lib/bpf/btf.c
> > @@ -1108,7 +1108,7 @@ static int btf_fixup_datasec(struct bpf_object *obj, struct btf *btf,
> >         const struct btf_type *t_var;
> >         struct btf_var_secinfo *vsi;
> >         const struct btf_var *var;
> > -       int ret;
> > +       int ret, nr_vars = 0;
> >
> >         if (!name) {
> >                 pr_debug("No name found in string section for DATASEC kind.\n");
> > @@ -1117,27 +1117,27 @@ static int btf_fixup_datasec(struct bpf_object *obj, struct btf *btf,
> >
> >         /* .extern datasec size and var offsets were set correctly during
> >          * extern collection step, so just skip straight to sorting variables
> > +        * One exception is the datasec may only have extern funcs,
> > +        * t->size is 0 in this case.  This will be handled
> > +        * with !nr_vars later.
> >          */
> >         if (t->size)
> >                 goto sort_vars;
> >
> > -       ret = bpf_object__section_size(obj, name, &size);
> > -       if (ret || !size || (t->size && t->size != size)) {
> > -               pr_debug("Invalid size for section %s: %u bytes\n", name, size);
> > -               return -ENOENT;
> > -       }
> > -
> > -       t->size = size;
> > +       bpf_object__section_size(obj, name, &size);
> 
> So it's not great that we just ignore any errors here. ".ksyms" is a
> special section, so it should be fine to just ignore it by name and
> leave the rest of error handling intact.
The ret < 0 case? In that case, size is 0.

or there are cases that a section has no vars but the size should not be 0?

> 
> >
> >         for (i = 0, vsi = btf_var_secinfos(t); i < vars; i++, vsi++) {
> >                 t_var = btf__type_by_id(btf, vsi->type);
> > -               var = btf_var(t_var);
> >
> > -               if (!btf_is_var(t_var)) {
> > -                       pr_debug("Non-VAR type seen in section %s\n", name);
> > +               if (btf_is_func(t_var)) {
> > +                       continue;
> 
> just
> 
> if (btf_is_func(t_var))
>     continue;
> 
> no need for "else if" below
> 
> > +               } else if (!btf_is_var(t_var)) {
> > +                       pr_debug("Non-VAR and Non-FUNC type seen in section %s\n", name);
> 
> nit: Non-FUNC -> non-FUNC
> 
> >                         return -EINVAL;
> >                 }
> >
> > +               nr_vars++;
> > +               var = btf_var(t_var);
> >                 if (var->linkage == BTF_VAR_STATIC)
> >                         continue;
> >
> > @@ -1157,6 +1157,16 @@ static int btf_fixup_datasec(struct bpf_object *obj, struct btf *btf,
> >                 vsi->offset = off;
> >         }
> >
> > +       if (!nr_vars)
> > +               return 0;
> > +
> > +       if (!size) {
> > +               pr_debug("Invalid size for section %s: %u bytes\n", name, size);
> > +               return -ENOENT;
> > +       }
> > +
> > +       t->size = size;
> > +
> >  sort_vars:
> >         qsort(btf_var_secinfos(t), vars, sizeof(*vsi), compare_vsi_off);
> >         return 0;
> > diff --git a/tools/lib/bpf/btf.h b/tools/lib/bpf/btf.h
> > index 029a9cfc8c2d..07d508b70497 100644
> > --- a/tools/lib/bpf/btf.h
> > +++ b/tools/lib/bpf/btf.h
> > @@ -368,6 +368,11 @@ btf_var_secinfos(const struct btf_type *t)
> >         return (struct btf_var_secinfo *)(t + 1);
> >  }
> >
> > +static inline enum btf_func_linkage btf_func_linkage(const struct btf_type *t)
> > +{
> > +       return (enum btf_func_linkage)BTF_INFO_VLEN(t->info);
> > +}
> 
> exposing `enum btf_func_linkage` in libbpf API headers will cause
> compilation errors for users on older systems. We went through a bunch
> of pain with `enum bpf_stats_type` (and it is still causing pain for
> C++), I'd rather avoid some more here. Can you please move it into
> libbpf.c for now. It doesn't seem like a very popular function that
> needs to be exposed to users.
will do.

> 
> > +
> >  #ifdef __cplusplus
> >  } /* extern "C" */
> >  #endif
> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > index 0a60fcb2fba2..49bda179bd93 100644
> > --- a/tools/lib/bpf/libbpf.c
> > +++ b/tools/lib/bpf/libbpf.c
> > @@ -190,6 +190,7 @@ enum reloc_type {
> >         RELO_CALL,
> >         RELO_DATA,
> >         RELO_EXTERN_VAR,
> > +       RELO_EXTERN_FUNC,
> >         RELO_SUBPROG_ADDR,
> >  };
> >
> > @@ -384,6 +385,7 @@ struct extern_desc {
> >         int btf_id;
> >         int sec_btf_id;
> >         const char *name;
> > +       const struct btf_type *btf_type;
> >         bool is_set;
> >         bool is_weak;
> >         union {
> > @@ -3022,7 +3024,7 @@ static bool sym_is_subprog(const GElf_Sym *sym, int text_shndx)
> >  static int find_extern_btf_id(const struct btf *btf, const char *ext_name)
> >  {
> >         const struct btf_type *t;
> > -       const char *var_name;
> > +       const char *tname;
> >         int i, n;
> >
> >         if (!btf)
> > @@ -3032,14 +3034,18 @@ static int find_extern_btf_id(const struct btf *btf, const char *ext_name)
> >         for (i = 1; i <= n; i++) {
> >                 t = btf__type_by_id(btf, i);
> >
> > -               if (!btf_is_var(t))
> > +               if (!btf_is_var(t) && !btf_is_func(t))
> >                         continue;
> >
> > -               var_name = btf__name_by_offset(btf, t->name_off);
> > -               if (strcmp(var_name, ext_name))
> > +               tname = btf__name_by_offset(btf, t->name_off);
> > +               if (strcmp(tname, ext_name))
> >                         continue;
> >
> > -               if (btf_var(t)->linkage != BTF_VAR_GLOBAL_EXTERN)
> > +               if (btf_is_var(t) &&
> > +                   btf_var(t)->linkage != BTF_VAR_GLOBAL_EXTERN)
> > +                       return -EINVAL;
> > +
> > +               if (btf_is_func(t) && btf_func_linkage(t) != BTF_FUNC_EXTERN)
> >                         return -EINVAL;
> >
> >                 return i;
> > @@ -3199,10 +3205,10 @@ static int bpf_object__collect_externs(struct bpf_object *obj)
> >                         return ext->btf_id;
> >                 }
> >                 t = btf__type_by_id(obj->btf, ext->btf_id);
> > +               ext->btf_type = t;
> 
> ext->btf_type is derived from ext->btf_id and obj->btf (always), so
> there is no need for it
It is for easier btf_is_var() check later instead of going through
another btf__type_by_id().

yeah, I will make a few btf__type_by_id() calls in v2.

> 
> >                 ext->name = btf__name_by_offset(obj->btf, t->name_off);
> >                 ext->sym_idx = i;
> >                 ext->is_weak = GELF_ST_BIND(sym.st_info) == STB_WEAK;
> > -
> >                 ext->sec_btf_id = find_extern_sec_btf_id(obj->btf, ext->btf_id);
> >                 if (ext->sec_btf_id <= 0) {
> >                         pr_warn("failed to find BTF for extern '%s' [%d] section: %d\n",
> > @@ -3212,6 +3218,34 @@ static int bpf_object__collect_externs(struct bpf_object *obj)
> >                 sec = (void *)btf__type_by_id(obj->btf, ext->sec_btf_id);
> >                 sec_name = btf__name_by_offset(obj->btf, sec->name_off);
> >
> > +               if (btf_is_func(t)) {
> 
> there is a KSYMS_SEC handling logic below, let's keep both func and
> variables handling together there?
It is to keep the indentation manageable
and also most of the things doing here is not
sharable with variables.

Sure. I can move it there.

> 
> > +                       const struct btf_type *func_proto;
> > +
> > +                       func_proto = btf__type_by_id(obj->btf, t->type);
> > +                       if (!func_proto || !btf_is_func_proto(func_proto)) {
> 
> this is implied by BTF format itself, seems a bit redundant
It has already been checked?

> 
> > +                               pr_warn("extern function %s does not have a valid func_proto\n",
> > +                                       ext->name);
> > +                               return -EINVAL;
> > +                       }
> > +
> > +                       if (ext->is_weak) {
> > +                               pr_warn("extern weak function %s is unsupported\n",
> > +                                       ext->name);
> > +                               return -ENOTSUP;
> > +                       }
> > +
> > +                       if (strcmp(sec_name, KSYMS_SEC)) {
> > +                               pr_warn("extern function %s is only supported under %s section\n",
> > +                                       ext->name, KSYMS_SEC);
> > +                               return -ENOTSUP;
> > +                       }
> > +
> > +                       ksym_sec = sec;
> > +                       ext->type = EXT_KSYM;
> > +                       ext->ksym.type_id = ext->btf_id;
> 
> there is skip_mods_and_typedefs in KSYMS_SEC section below, but it
> won't have any effect on FUNC_PROTO, so existing logic can be used
> as-is
func id is used here to keep what ksyms.type_id means:
/* local btf_id of the ksym extern's type. */

The kernel extern type here should be func instead of func_proto.
func_proto cannot be extern.

> 
> > +                       continue;
> > +               }
> > +
> >                 if (strcmp(sec_name, KCONFIG_SEC) == 0) {
> >                         kcfg_sec = sec;
> >                         ext->type = EXT_KCFG;
> 
> [...]
> 
> > +static int bpf_object__resolve_ksym_func_btf_id(struct bpf_object *obj,
> > +                                               struct extern_desc *ext)
> > +{
> > +       int local_func_proto_id, kern_func_proto_id, kern_func_id;
> > +       const struct btf_type *kern_func;
> > +       struct btf *kern_btf = NULL;
> > +       int ret, kern_btf_fd = 0;
> > +
> > +       local_func_proto_id = ext->btf_type->type;
> 
> yeah, so this ext->btf_type can be retrieved with
> btf__type_by_id(obj->btf, ext->btf_id) here, no need to pollute
> extern_desc with extra field
> 
> > +
> > +       kern_func_id = find_ksym_btf_id(obj, ext->name, BTF_KIND_FUNC,
> > +                                       &kern_btf, &kern_btf_fd);
> > +       if (kern_func_id < 0) {
> > +               pr_warn("extern (func ksym) '%s': not found in kernel BTF\n",
> > +                       ext->name);
> > +               return kern_func_id;
> > +       }
> > +
> > +       if (kern_btf != obj->btf_vmlinux) {
> > +               pr_warn("extern (func ksym) '%s': function in kernel module is not supported\n",
> > +                       ext->name);
> > +               return -ENOTSUP;
> > +       }
> > +
> 
> [...]
