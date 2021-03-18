Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14C39341124
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 00:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231149AbhCRXjx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 19:39:53 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:39668 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230204AbhCRXj3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 19:39:29 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12INU6Di014678;
        Thu, 18 Mar 2021 16:39:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=BIqJPN6bwCYESFuVtQpS0CghsS5ZcwaIwfjHU4fapXM=;
 b=qjdZEu1Rz48DgiCj2TYnfNeny3i91TgGUBE85NyajjJuVwHOIFdh9S4a9m0FeafCUgbJ
 Jxte9BmLZSLqD88Vv396VCjjcFnNkEXyl0ACaPoltE7sbWySRiO0TG5IVakrYnh6lte2
 IhbUn8EwtDQ5/mkDhMivR6ik6YoikT7WnUY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 37bs29qhjs-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 18 Mar 2021 16:39:16 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 18 Mar 2021 16:39:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cG0QMKneGGw2daUjwrxEV+P1XHN3YSE3H8VuL/2R3L0RPndIbQ+HIiUnSyiauxSD+EmwGqNoImFoHcyvDJnnqAmg8nHUfOQfMCHb0MDSPR5QX0g8Vg3p9onl/na4+WLoDREL8S3zU/PlvrMPBxJuizx1zEat9AeOWKBqjZ/bYCs40oTWE3rkKrpkHOFAJe9GU8iTEDXCR/EWDa9EUrnw07jVuc0I6F8aLA8hay2dUeypdDpbrTp9G/+9CjRYhp5CtRA1Q3g3jo8ooosqbYWUR2vFg8SFe92diFLuwiIcVaBx4ylmgXmEx10rzYw16PI7npttoi660xLY5VmYxESbZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=opkwIenGQEUe17LRGgS3+ayakkEAKPbSm3Ot7rDyqNc=;
 b=fyQRBvWh1ZN45pzdOUJbjM028l6qilvkuFJP6FdYhgWfoO5epN4IgtKxDWVIA7zbu1PzUpWcEtZkpzHEYdyP4e+mo0dsBCN/cG3pTUTZPFp3qptYPJwRkdm+SVqwKn78dRA2wfo4/McNQdd73PDT1p6keYQd6vdvmMVZ6ZG0EXf2dt4NKvgilRvrpt+1Zxsde9nntY36dxFIhpCwc2voiBqNTwoo6k5FkmO9ER2fHDcB0p/abVAyCZtoJ2vNTsdSdUJtjP2Hs1VD4yPWirXbJT7TGBHWW452xkq5vjqknV02+ndFXsEhQaqrFcS0EsIB2jH7VBaVBBhpY+mCT/97ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2888.namprd15.prod.outlook.com (2603:10b6:a03:b5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31; Thu, 18 Mar
 2021 23:39:09 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2975:c9d8:3f7f:dbd0]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2975:c9d8:3f7f:dbd0%5]) with mapi id 15.20.3955.018; Thu, 18 Mar 2021
 23:39:09 +0000
Date:   Thu, 18 Mar 2021 16:39:07 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next 02/15] bpf: btf: Support parsing extern func
Message-ID: <20210318233907.r5pxtpe477jumjq6@kafai-mbp.dhcp.thefacebook.com>
References: <20210316011336.4173585-1-kafai@fb.com>
 <20210316011348.4175708-1-kafai@fb.com>
 <CAEf4Bzb57BrVOHRzikejK1ubWrZ_cd2FCS6BW6_E-2KuzJGrPg@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAEf4Bzb57BrVOHRzikejK1ubWrZ_cd2FCS6BW6_E-2KuzJGrPg@mail.gmail.com>
X-Originating-IP: [2620:10d:c090:400::5:2a96]
X-ClientProxiedBy: SJ0PR03CA0243.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::8) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:2a96) by SJ0PR03CA0243.namprd03.prod.outlook.com (2603:10b6:a03:3a0::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Thu, 18 Mar 2021 23:39:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 536eb995-6451-47fc-529e-08d8ea670704
X-MS-TrafficTypeDiagnostic: BYAPR15MB2888:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2888E925A12D316E959B3F54D5699@BYAPR15MB2888.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3cj0KSfrC5W6doR4GzgD4KJbAG0YtZTlkGSpuAqXQRkdziwI0zhpbvWTOSnz07BRHiYKvFk76jtTy7QZxpIRf+6irkPr/D+QDwuOALwqtlUrinq8OXLr/aPkXxanL77InmWXS8A/6d2vi94BgFYOpDE2s19ZfxUKr3B6DKBJMZNv+mwvRGcqIZz0QGBw8MAKw3mAS+cagFoL98xVpE5OFOc4LxHjneW2XNhIo9fYN0nfGgTJTjvqNRyJl/y+0vsjoNQEgrVzJDdYWzrGFtWXV+0MBDz94/cJDnZk7ifBpMqs3t7sq+Zp7dXgE2Hggz/LxG9Wqj5FZD6ikLSbLWGTU5nD8KeMh4gB2MpQ9sPknKIunjfk5cEHOzzvP/BhaqZ5Oanz6P9/GslHUXayVLfTVF4leIIHtLMz+62apSv54FjrMwHl2NvML0w+FEvT8WeNx4wYad1kCAOoIhTqQEiSJ+fGzXH6Syj3IZd6eWKf9QpKQJJTT4aaETFnZebeYtyHniOnRvHxqHVub8A/40jTM4d6l5ZtpsqcjnQCwChu8bcQExdPiBm39/AJtqRm1+RGCZLh94du3zKu72vtKpmahcgg91QVY6lxAkGO1jtdxPBsR737dTY7Oo2jFYLbRIjc6qEqcrMLrNY5w0JVwiAaMtxSt4QXlHwT4YBaJzXiFO/yJkRXKZ/k/Szs5Q1xyy+XM/MMcHUg/r/6WugQiLpvrop/USjgGw7IR1wfVRHn4Ok=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(396003)(376002)(346002)(39860400002)(66556008)(9686003)(7696005)(52116002)(53546011)(966005)(54906003)(55016002)(5660300002)(8936002)(478600001)(6506007)(38100700001)(186003)(316002)(83380400001)(16526019)(66476007)(8676002)(2906002)(1076003)(66946007)(6916009)(86362001)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?JNu0sh+WLbjMpmGdgV75fDyLRzTiVIMvGvMlRhXxUPuQDEgx0w48veOJjeel?=
 =?us-ascii?Q?GQaGBg7ImWYILxOY+mPQhMTJunx4+4RAuOLgY1lUMJWAZnMY6GYXMKoMSj8N?=
 =?us-ascii?Q?DuZH5wGEoBEQX9pVw/QhdHACGjofsb7QbYiZbJfWofkV81zYkGQnDSe4StxD?=
 =?us-ascii?Q?hilUuosQx/3hi+OxjJOSACHRHInK4nRT89Wgzf/5og7lgzE0005R5t4l9gUH?=
 =?us-ascii?Q?M/aigxdE/UPzxp890s4N82jmFgsOpp/KDBzv+amy0D99Ng+ApZp0Fu71rRgI?=
 =?us-ascii?Q?E1LTrCp4WU4gEpwwKbmCoEzBDf3HDrRxSuft1uLpUrSUhlLT24H8yJ1on7eJ?=
 =?us-ascii?Q?YT6VTwjx67sj4Zth6OGo7x6pjpekMx74bGR5+1ikuNf3i+3M1ZBa5ExQhR73?=
 =?us-ascii?Q?x8MLqBt1g8bv16FuAG1JPPQkXJIq1eKZ9XD1FpnJnmoDfJahe/SHl3xmhfZt?=
 =?us-ascii?Q?VKGiT/QyMIQHpq6Ay6vvSAsLVycf5CmYjoKwEnlx90ZsKP+yDAeZCM5gHvV5?=
 =?us-ascii?Q?3zEwbLql1xp49e3i3SZYSSyBBqdoQMh1Oa0NrSlHze1TuFqhH0FBzIeT/pcK?=
 =?us-ascii?Q?i7BkYMn0uF1UGwqhwSTWPHD0tsPAXFGu/1Aq90CyRVVJ4LzC6p9tAugWGqTr?=
 =?us-ascii?Q?+e9I97gWKVRolbs5cbd9DEEo5vRzbcRX/dLSi3U3zgI/y/HBdmCpRwcWrbwj?=
 =?us-ascii?Q?HL2v+KF9/5qpzRFJzPlsw9Bv/oX5MicwhfnhC2M+4lhq7H8X/B9cD9HxEpwx?=
 =?us-ascii?Q?cD23YXQIk6Uzsxif9Y7hKYWS84vaVVWjh9CuMlQJo5ws2LFlGVYdtl1y2qWN?=
 =?us-ascii?Q?TpX4T8GjMyn7EKUNhhc9hgDQ6A9w0NtHCzUgTx4moMooyJgnLKTaS6zkQ9C3?=
 =?us-ascii?Q?0hQJpAuPfbfjKilbtVc+SUylAfS8h3suNGrdilciEZ5Q+srDrsS1QADB7Nh0?=
 =?us-ascii?Q?lOB7hPMe1WdknN/Nhfx/6PdSTw6bdVAHUS6sRYdju9wzDycTFpDLDE7uo98O?=
 =?us-ascii?Q?Qhi4fe1pPBFt3pvPdJRTr332hsxABhZfK5iO3yZaw46kvyww51gDBTAnPU2e?=
 =?us-ascii?Q?p/NUkAGXRSK/LMRNRjqkShEPllTPTSiki4g6UuqAmBuUF9m21wFq8oddzzUl?=
 =?us-ascii?Q?TSURLS8yO6n7befgAZOW2wT44B7tYmeh6RJsO7HCm4CY44mIQgo80BbpZlKB?=
 =?us-ascii?Q?/y6lCpThFdNg7FjQqcK7Si2Fn++Q52zOoL1xP4CFlmUxHUXUTFy1BC/l6FVj?=
 =?us-ascii?Q?EBWA2H+a56BEbX++MTS4lPBFH0hEUMfi3UjVpmn2CfFzX/usbP0rprRdYg/O?=
 =?us-ascii?Q?AM+0MLp9FSmBMhhSyo/C2VP1VXzrIVdLN8euPk+mYJ59Ew=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 536eb995-6451-47fc-529e-08d8ea670704
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2021 23:39:09.5628
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ck1jDIlble+aWcT41vIB1wuA2bdzjxR+eNAE2+O1bSm09rnBg1XBLwdBve7ZV8NP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2888
X-OriginatorOrg: fb.com
X-Proofpoint-UnRewURL: 1 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-18_18:2021-03-17,2021-03-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 bulkscore=0 spamscore=0 clxscore=1015 malwarescore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 priorityscore=1501
 phishscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2103180169
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 18, 2021 at 03:53:38PM -0700, Andrii Nakryiko wrote:
> On Tue, Mar 16, 2021 at 12:01 AM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > This patch makes BTF verifier to accept extern func. It is used for
> > allowing bpf program to call a limited set of kernel functions
> > in a later patch.
> >
> > When writing bpf prog, the extern kernel function needs
> > to be declared under a ELF section (".ksyms") which is
> > the same as the current extern kernel variables and that should
> > keep its usage consistent without requiring to remember another
> > section name.
> >
> > For example, in a bpf_prog.c:
> >
> > extern int foo(struct sock *) __attribute__((section(".ksyms")))
> >
> > [24] FUNC_PROTO '(anon)' ret_type_id=15 vlen=1
> >         '(anon)' type_id=18
> > [25] FUNC 'foo' type_id=24 linkage=extern
> > [ ... ]
> > [33] DATASEC '.ksyms' size=0 vlen=1
> >         type_id=25 offset=0 size=0
> >
> > LLVM will put the "func" type into the BTF datasec ".ksyms".
> > The current "btf_datasec_check_meta()" assumes everything under
> > it is a "var" and ensures it has non-zero size ("!vsi->size" test).
> > The non-zero size check is not true for "func".  This patch postpones the
> > "!vsi-size" test from "btf_datasec_check_meta()" to
> > "btf_datasec_resolve()" which has all types collected to decide
> > if a vsi is a "var" or a "func" and then enforce the "vsi->size"
> > differently.
> >
> > If the datasec only has "func", its "t->size" could be zero.
> > Thus, the current "!t->size" test is no longer valid.  The
> > invalid "t->size" will still be caught by the later
> > "last_vsi_end_off > t->size" check.   This patch also takes this
> > chance to consolidate other "t->size" tests ("vsi->offset >= t->size"
> > "vsi->size > t->size", and "t->size < sum") into the existing
> > "last_vsi_end_off > t->size" test.
> >
> > The LLVM will also put those extern kernel function as an extern
> > linkage func in the BTF:
> >
> > [24] FUNC_PROTO '(anon)' ret_type_id=15 vlen=1
> >         '(anon)' type_id=18
> > [25] FUNC 'foo' type_id=24 linkage=extern
> >
> > This patch allows BTF_FUNC_EXTERN in btf_func_check_meta().
> > Also extern kernel function declaration does not
> > necessary have arg name. Another change in btf_func_check() is
> > to allow extern function having no arg name.
> >
> > The btf selftest is adjusted accordingly.  New tests are also added.
> >
> > The required LLVM patch: https://reviews.llvm.org/D93563 
> >
> > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > ---
> 
> High-level question about EXTERN functions in DATASEC. Does kernel
> need to see them under DATASEC? What if libbpf just removed all EXTERN
> funcs from under DATASEC and leave them as "free-floating" EXTERN
> FUNCs in BTF.
> 
> We need to tag EXTERNs with DATASECs mainly for libbpf to know whether
> it's .kconfig or .ksym or other type of externs. Does kernel need to
> care?
Although the kernel does not need to know, since the a legit llvm generates it,
I go with a proper support in the kernel (e.g. bpftool btf dump can better
reflect what was there).

> 
> >  kernel/bpf/btf.c                             |  52 ++++---
> >  tools/testing/selftests/bpf/prog_tests/btf.c | 154 ++++++++++++++++++-
> >  2 files changed, 178 insertions(+), 28 deletions(-)
> >
> 
> [...]
> 
> > @@ -3611,9 +3594,28 @@ static int btf_datasec_resolve(struct btf_verifier_env *env,
> >                 u32 var_type_id = vsi->type, type_id, type_size = 0;
> >                 const struct btf_type *var_type = btf_type_by_id(env->btf,
> >                                                                  var_type_id);
> > -               if (!var_type || !btf_type_is_var(var_type)) {
> > +               if (!var_type) {
> > +                       btf_verifier_log_vsi(env, v->t, vsi,
> > +                                            "type not found");
> > +                       return -EINVAL;
> > +               }
> > +
> > +               if (btf_type_is_func(var_type)) {
> > +                       if (vsi->size || vsi->offset) {
> > +                               btf_verifier_log_vsi(env, v->t, vsi,
> > +                                                    "Invalid size/offset");
> > +                               return -EINVAL;
> > +                       }
> > +                       continue;
> > +               } else if (btf_type_is_var(var_type)) {
> > +                       if (!vsi->size) {
> > +                               btf_verifier_log_vsi(env, v->t, vsi,
> > +                                                    "Invalid size");
> > +                               return -EINVAL;
> > +                       }
> > +               } else {
> >                         btf_verifier_log_vsi(env, v->t, vsi,
> > -                                            "Not a VAR kind member");
> > +                                            "Neither a VAR nor a FUNC");
> >                         return -EINVAL;
> 
> can you please structure it as follow (I think it is bit easier to
> follow the logic then):
> 
> if (btf_type_is_func()) {
>    ...
>    continue; /* no extra checks */
> }
> 
> if (!btf_type_is_var()) {
>    /* bad, complain, exit */
>    return -EINVAL;
> }
> 
> /* now we deal with extra checks for variables */
> 
> That way variable checks are kept all in one place.
> 
> Also a question: is that ok to enable non-extern functions under
> DATASEC? Maybe, but that wasn't explicitly mentioned.
The patch does not check.  We could reject that for now.

> 
> >                 }
> >
> > @@ -3849,9 +3851,11 @@ static int btf_func_check(struct btf_verifier_env *env,
> >         const struct btf_param *args;
> >         const struct btf *btf;
> >         u16 nr_args, i;
> > +       bool is_extern;
> >
> >         btf = env->btf;
> >         proto_type = btf_type_by_id(btf, t->type);
> > +       is_extern = btf_type_vlen(t) == BTF_FUNC_EXTERN;
> 
> using btf_type_vlen(t) for getting func linkage is becoming more and
> more confusing. Would it be terrible to have btf_func_linkage(t)
> helper instead?
I have it in my local v2.  and also just return when it is extern.

> 
> >
> >         if (!proto_type || !btf_type_is_func_proto(proto_type)) {
> >                 btf_verifier_log_type(env, t, "Invalid type_id");
> > @@ -3861,7 +3865,7 @@ static int btf_func_check(struct btf_verifier_env *env,
> >         args = (const struct btf_param *)(proto_type + 1);
> >         nr_args = btf_type_vlen(proto_type);
> >         for (i = 0; i < nr_args; i++) {
> > -               if (!args[i].name_off && args[i].type) {
> > +               if (!is_extern && !args[i].name_off && args[i].type) {
> >                         btf_verifier_log_type(env, t, "Invalid arg#%u", i + 1);
> >                         return -EINVAL;
> >                 }
> 
> [...]
