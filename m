Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 644E92695CE
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 21:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726038AbgINTnr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 15:43:47 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:64504 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725990AbgINTno (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 15:43:44 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08EJhSob002842;
        Mon, 14 Sep 2020 12:43:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=C9iroRyCsTnX73ckxP+nnwLFrZ2k20Ws6jMbX/QyWcs=;
 b=JKaZxVL7xWN/fmBWUd9TbZos7rPst3GpEKpRE3SQytTam8ATA0Ui0PSNQ1pe6AWkmb7N
 +MQWP5hqNb6uKPpYR8IfTbBqjuCdcMNviqQ0VssESovFP0dFbr9cp3tebf0o/R2Ymq+/
 uFmb0+oxTK7Q411T3Cs4EMUhGm2En1gwHTA= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 33hekmxtah-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 14 Sep 2020 12:43:29 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 14 Sep 2020 12:43:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cle2+oAtepOrv9kQjW/dbew/lpCJyKIbWL+dvOOfJzrDh30Ekl0rn4QnM15G6DKxiaBjROi68heXsD/3NB7jGK91gNJhu4bWExiGaErHxtTGe5v2dvrBrmPzbIVoSNYZViJKVK9qpBWK+FnF3WvVKmgdXrsuKbGzJCmEuZlv07VS/kmctu5J5BSpwdX2HAlPc8eyiagv4md+KkSZnfSBF6692BR3WmWqPIJo1/d5NdAaPF4G0S6TbrdzPdAFzrAET9NPe7GkOz++tnEy5tGqLqqMqr0ExCX+97/tvPSGnuZgwMclJQFtzBowE7H1Zf8cF00fTacq/UB+XKmIJHVzBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C9iroRyCsTnX73ckxP+nnwLFrZ2k20Ws6jMbX/QyWcs=;
 b=eh1Ko0BvAUzgoxhgPDSqbv0Mg+IAJUkr1BsIuC380iKt9dSwakN1ITEBP43xO35iGfKuWCLCwRvrmiDo/lAn0IW4c2jXvQz3c125SJhETJuARV07QjraPLNJOVxgNkxAYc4znlPrIoeSrx5c7cyAkErs4YMLilh1DcOw9FPd1jlHh3u3tt9Jvv+4LiUWJGklFA8YyfaIaXf3K9ZO9lhKAy7imwO/rgPT2o01ElfGH6yVudRBVvdPnfRF10JGcGthl12UiZN74BJMO7A39LnF9fXzzv2LBD0PyBrfTV+SXZM4QSJCEJTZTUhNfMHYDunxgVZdNkkO1OEetQYpT8WHQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C9iroRyCsTnX73ckxP+nnwLFrZ2k20Ws6jMbX/QyWcs=;
 b=RUxthCpK335t8h+HaOE3vdI5V8MwY9IYf8FB2xsgeUdWuHwFKQ9+bMgwBuD9H2ztiP6Nu0zJ9DiKSbw+iompYGDs3imUHcL1XFFN0y1SE+z5dChLxrfsxnSg8tNvSnqh+nooPQYUYRBvvs4vAJ0BSfrKjxJ4dz9q+606uIMahPU=
Authentication-Results: cloudflare.com; dkim=none (message not signed)
 header.d=none;cloudflare.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2263.namprd15.prod.outlook.com (2603:10b6:a02:87::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Mon, 14 Sep
 2020 19:43:12 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c13c:fca9:5e04:9bfb]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c13c:fca9:5e04:9bfb%3]) with mapi id 15.20.3370.019; Mon, 14 Sep 2020
 19:43:12 +0000
Date:   Mon, 14 Sep 2020 12:43:04 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Lorenz Bauer <lmb@cloudflare.com>
CC:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>, Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH RFC bpf-next 2/2] bpf: Enable bpf_skc_to_* sock casting
 helper to networking prog type
Message-ID: <20200914194304.4ccb6n5sdcfkzxcp@kafai-mbp>
References: <20200912045917.2992578-1-kafai@fb.com>
 <20200912045930.2993219-1-kafai@fb.com>
 <CACAyw9-rirpChioEaSKiYC5+fLGzL38OawcBvE8Mv+16vNApZA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACAyw9-rirpChioEaSKiYC5+fLGzL38OawcBvE8Mv+16vNApZA@mail.gmail.com>
X-ClientProxiedBy: MWHPR22CA0004.namprd22.prod.outlook.com
 (2603:10b6:300:ef::14) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:75e) by MWHPR22CA0004.namprd22.prod.outlook.com (2603:10b6:300:ef::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Mon, 14 Sep 2020 19:43:10 +0000
X-Originating-IP: [2620:10d:c090:400::5:75e]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8aba0df3-579e-4672-700e-08d858e669fb
X-MS-TrafficTypeDiagnostic: BYAPR15MB2263:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB22635F18770BD9C08D373649D5230@BYAPR15MB2263.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ozSS2sgazeimYcqOSWcHEuJEIejrogxZy5+p7QoSOTF35nb93odIU7T3yZxfmuy1PqXx4QLNzZg/Zog0Dy/uoXX25qZMGnB6EksV/y7575QnMMcxxVBMjg/f039CgoXKPy0mUBCk1wgT41yHmEqFZvbIS4ElCD70RvmbDiVpkTVHA0nkcrkaBp95L2JNOT4tiNuaoDUOipiX5RF7DtuJIJMEqER2Z5wwkmYQ/4zAwfnMDETvhymAo02TodjqT0aXIGjuOufukz2tmQapQsn9Hc/WH35hwZPEPGB2+Dg9tMAnBceWgfbbChykeTs14gHeG/iN4oFRwlCpPv9TkxmD9k6mxl3KA3OsdOuV6TZcerGb1uSgFkJso/g0loA2cBew81wfJ9ePBqwRjuSqUyq4Og==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(366004)(346002)(396003)(376002)(54906003)(316002)(1076003)(2906002)(6496006)(16526019)(186003)(86362001)(8936002)(6666004)(52116002)(478600001)(8676002)(83380400001)(966005)(66946007)(66476007)(66556008)(55016002)(4326008)(5660300002)(6916009)(33716001)(9686003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: w6ifIUcWZ71o313DvNu0E5JJjattfPpZofnFxDI3b7V2Yw42dVpzhs3S80OrwR6ISh3UPjGzDXrTbTRBccQYrOhRB5Jzty/Nive8lJAEoPWDzxNhZJMcdoI4i7Mk6VXU4PvLZgk6XosAyNdm/ey+gExdFFoE3z9A8ybO+XZrxdrndl1+wg4YovQCbD1StPmXWkWVqewdaLdJJiKnmCQsupHYyQprQLRcF++QYo01mh6ETFSG/v1GOIAcQqnXSGXX+GHXBmuAPv1hf4pc3NI7qTKOFKFX5XfbNCV5jTMyx3AgfptNuOX2lgUwEmipFb7vcvxY69GjYWOEmkK3Ecnz3i7VdKy9yoEvZ9m54AYpDGvUx0Q/DU7cFPyZ/JAB+UvuiYdaE9A02Jm9KOhFIXwFRWx9p7IhfO3FGVQoVC94lNUdx7N5Q1zwQ0XZxFriL6WlJXe71rbDiEyBEsS4zRolykgeDctNt6k66maJ1US+zdwlR6OIy+LaFPXvHs3gJd/+u2lqBvXCFmKWo9C0fYiMY8dezvxxPXVd3BohrYPxetx+syhfARLdYj/P+BHVS8FtyfssjS6qRhfOgYHb5mU/k+3qAdzCQ0eV01wKB9WljOvaYKaHdzbq4N2PnhwKgesgNzRzX93PfHqEi5ORnAlOW6q5njCn0+224BJEcjnTHrE=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8aba0df3-579e-4672-700e-08d858e669fb
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2020 19:43:12.2430
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LTTZtm2d1uE5FRte5Agsw0POHfgZHaf8F5Tu57daqy2P4+3oMdPwFvWHsa6kUcHp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2263
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-14_08:2020-09-14,2020-09-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 priorityscore=1501 suspectscore=0 mlxscore=0 spamscore=0 malwarescore=0
 adultscore=0 lowpriorityscore=0 phishscore=0 mlxlogscore=970
 impostorscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2009140154
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 14, 2020 at 10:26:18AM +0100, Lorenz Bauer wrote:
> On Sat, 12 Sep 2020 at 05:59, Martin KaFai Lau <kafai@fb.com> wrote:
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
> > [ One approach is to make a separate copy of the bpf_skc_to_*
> >   func_proto and use ARG_PTR_TO_SOCK_COMMON instead of ARG_PTR_TO_BTF_ID.
> >   More on this later (1). ]
> >
> > This patch modifies the existing bpf_skc_to_* func_proto to take
> > ARG_PTR_TO_SOCK_COMMON instead of taking
> > "ARG_PTR_TO_BTF_ID + &btf_sock_ids[BTF_SOCK_TYPE_SOCK_COMMON]".
> > That will allow tc, sock_ops,...etc to call these casting helpers
> > because they already hold the PTR_TO_SOCK_COMMON (or its
> > equivalent).  For example:
> >
> >         sk = sock_ops->sk;
> >         if (!sk)
> >                 return;
> >         tp = bpf_skc_to_tcp_sock(sk);
> >         if (!tp)
> >                 return;
> >         /* Read tp as a PTR_TO_BTF_ID */
> >         lsndtime = tp->lsndtime;
> >
> > To ensure the current bpf prog passing a PTR_TO_BTF_ID to
> > bpf_skc_to_*() still works as is, the verifier is modified such that
> > ARG_PTR_TO_SOCK_COMMON can accept a reg with reg->type == PTR_TO_BTF_ID
> > and reg->btf_id is btf_sock_ids[BTF_SOCK_TYPE_SOCK_COMMON]
> >
> > To do that, an idea is borrowed from one of the Lorenz's patch:
> > https://lore.kernel.org/bpf/20200904112401.667645-12-lmb@cloudflare.com/ .
> > It adds PTR_TO_BTF_ID as one of the acceptable reg->type for
> > ARG_PTR_TO_SOCK_COMMON and also specifies what btf_id it can take.
> > By doing this, the bpf_skc_to_* will work as before and can still
> > take PTR_TO_BTF_ID as the arg.  e.g. The bpf tcp iter will work
> > as is.
> >
> > This will also make other existing helper taking ARG_PTR_TO_SOCK_COMMON
> > works with the pointer obtained from bpf_skc_to_*(). For example:
> 
> Unfortunately, I think that we need to introduce a new
> ARG_PTR_TO_SOCK_COMMON_OR_NULL for this to work. This is because
> dereferencing a "tracing" pointer can yield NULL at runtime due to a
> page fault, so the helper has to deal with this. Other than that I
> think this is a really nice approach: we can gradually move helpers to
> PTR_TO_SOCK_COMMON_OR_NULL and in doing so make them compatible with
> BTF pointers.
Good point on the sk could be NULL.  I think the existing
bpf_skc_to_*() helper is missing the "!sk" check regardless of
this patch.

For other ARG_PTR_TO_SOCK_COMMON helpers, they are not available to
the tracing prog type.  Hence, they are fine to accept PTR_TO_BTF_ID
as ARG_PTR_TO_SOCK_COMMON since the only way for non tracing prog to
get a PTR_TO_BTF_ID is from casting helpers bpf_skc_to_* and
the NULL check on return value must be done first.  If these
ARG_PTR_TO_* helpers were ever made available to tracing prog,
it might be better off to have another func_proto taking
ARG_PTR_TO_BTF_ID instead.

For the verifier, I think the PTR_TO_BTF_ID should only be accepted
as ARG_TO_* for non tracing program.  That means the bpf_skc_to_*
proto has to be duplicated to take ARG_PTR_TO_SOCK_COMMON.  I think
that may be cleaner going forward.  Then the verifier does not need
to worry about how to deal with what btf_id can be taken as fullsock
ARG_PTR_TO_SOCKET.  The helper taking ARG_PTR_TO_BTF_ID will decide
where it could be called from and see how it wants to treat
"struct sock *sk".  For example, the sk_storage_get_btf_proto
is taking &btf_sock_ids[BTF_SOCK_TYPE_SOCK] and is only used from
the LSM context that is holding a fullsock.

The same goes for the sock_map iter, how about the map_update
and map_lookup use a ARG_PTR_TO_BTF_ID and PTR_TO_BTF_ID instead?
For other prog types, they can keep using ARG_PTR_TO_SOCKET and
PTR_TO_SOCKET.


> 
> [...]
> 
> > @@ -4014,7 +4022,17 @@ static int check_reg_type(struct bpf_verifier_env *env, u32 arg,
> >
> >  found:
> >         if (type == PTR_TO_BTF_ID) {
> > -               u32 *expected_btf_id = fn->arg_btf_id[arg];
> > +               u32 *expected_btf_id;
> > +
> > +               if (arg_type == ARG_PTR_TO_BTF_ID) {
> > +                       expected_btf_id = fn->arg_btf_id[arg];
> 
> Personal preference, but what do you think about moving this to after
> the assignment of compatible?
> 
>     btf_id = compatible->btf_id;
>     if (arg_type == ARG_PTR_TO_BTF_ID)
>        btf_id = fn->fn->arg_btf_id[arg];
> 
> That makes it clearer that we have to special case ARG_PTR_TO_BTF_ID since
> it doesn't make sense to use compatible->btf_id in that case.
Sure.  I don't mind moving this assignment out of the else.
However, I think resorting to "compatible" btf_id is the exception
instead.
