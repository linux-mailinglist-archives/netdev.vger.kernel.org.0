Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46654275E3B
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 19:06:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbgIWRGS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 13:06:18 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:64936 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726342AbgIWRGR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 13:06:17 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08NH5f1W002824;
        Wed, 23 Sep 2020 10:06:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=kHk2G6JAmYHKCeznk0afyQeEbMxUBiE/rDlJ8ZuLBcE=;
 b=Nv17rGqLFw3ZFljsPccCuXIDKf4Tmb92b7hi4NPgdjexavviIbUPVCKip2Vfp9kZWVvS
 ExAWGjeAWspla8SqlirX8g2p6kp5OqR/rIamZEzooUk80HXFiJ6k/T0XNH5wCoO4Nr3Y
 4EUj9GfpGygPa3GiI6OnCCTnm0X6erTdKTk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 33qsp7vqva-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 23 Sep 2020 10:06:03 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 23 Sep 2020 10:06:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gAccmKmhpa2x3SswGmHWV/BDuAITM7CIDsdol6LnmKDayfoH16VMeFsPMK3grTC0UrzyDJ3RHG96ID+TqbKCWdRvwy3DIfxwBInjnWuBmJVNzCAtWo0ucOJv374Zo7DgO2KrOOa+0N6ei9AE4svANAL6rccKqOSsNYtb/VboWcFbez4YTNXnwFn1nI5acqsap8Vw3zYA8t3OGn2CtTgH5tf2BPDIvorYqtKox/Ggky+lvgU/lm6CCEdh4LLDscEYG21svU4LhDBZaykEx85OR9XuOjAJCG4MjNkoEXoWCSYhOWHdEEqMiAdEAlVn47KG7zvZVKTSJSImCW1PxoSjPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kHk2G6JAmYHKCeznk0afyQeEbMxUBiE/rDlJ8ZuLBcE=;
 b=KmiX/tfpQPUsOza4eDOiZXWOPmkmGR62UaVkI/GqFjd2QiqOLKBfmyHp9I6TY6IyYag8C84qiZctEYmIitjfiX1ChZo6CGalmO1cUaEpjXj84HEL4c2BuVWeHHDLkStwoZzozC2O59w8ptiHCo2IJ+HyO9MJ6NmGbTSkHaZBQqcKFHvUgGn4KhX0FPCqjNiKcfRf9Fk+S7TPgwf/0DMY8RuhciphrHUmeX2vHLFBL4pN4hcTYD0M7kxwxTwYDFsy47lmX1YEAKBDN14UeNj7LIs+kqA96j3gAdRLDxHHkxqLvUBCR8v350YPpgvK3PnfaP5ObVU/+ftYrsPde3ZuPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kHk2G6JAmYHKCeznk0afyQeEbMxUBiE/rDlJ8ZuLBcE=;
 b=R6Qtn+fimV9hulRKk26jrAMINbEHxgr8EFyKhot6jjiEdrofwWXoKjAIwA3lmbV4G0ZfUfRISFI0CHbqDk79bpnp2X/6lKrLDk4RPe5EXoAhIJczT2gvB5l/X9WbcSpLsNXjytwj0Eri/gzKuFl2aGbZE7ToRSF7bgVZRV2o8BE=
Authentication-Results: cloudflare.com; dkim=none (message not signed)
 header.d=none;cloudflare.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2823.namprd15.prod.outlook.com (2603:10b6:a03:15a::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.19; Wed, 23 Sep
 2020 17:05:59 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c13c:fca9:5e04:9bfb]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c13c:fca9:5e04:9bfb%3]) with mapi id 15.20.3391.027; Wed, 23 Sep 2020
 17:05:59 +0000
Date:   Wed, 23 Sep 2020 10:05:52 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Lorenz Bauer <lmb@cloudflare.com>
CC:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH v3 bpf-next 02/11] bpf: Enable bpf_skc_to_* sock casting
 helper to networking prog type
Message-ID: <20200923170552.65i7bnht3qkkikp5@kafai-mbp.dhcp.thefacebook.com>
References: <20200922070409.1914988-1-kafai@fb.com>
 <20200922070422.1917351-1-kafai@fb.com>
 <CACAyw9-LoKFuYxaMODtacJM-rOR0P5Y=j_yEm9bsFZe_j_9rYQ@mail.gmail.com>
 <20200922182622.zcrqwpzkouvlndbw@kafai-mbp.dhcp.thefacebook.com>
 <CACAyw99xbeVyzUT+fhHtRQEGoef-9vvTfiOEFaJWX6aoVL+Z9A@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACAyw99xbeVyzUT+fhHtRQEGoef-9vvTfiOEFaJWX6aoVL+Z9A@mail.gmail.com>
X-ClientProxiedBy: MWHPR22CA0029.namprd22.prod.outlook.com
 (2603:10b6:300:69::15) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:e2df) by MWHPR22CA0029.namprd22.prod.outlook.com (2603:10b6:300:69::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20 via Frontend Transport; Wed, 23 Sep 2020 17:05:58 +0000
X-Originating-IP: [2620:10d:c090:400::5:e2df]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2175626b-2b6e-4b33-126a-08d85fe2f133
X-MS-TrafficTypeDiagnostic: BYAPR15MB2823:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2823232E4499365E90DC4712D5380@BYAPR15MB2823.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PaYr6ys2w8fykEO4Y9/qblsjbE3YtcvJubjXnI7VQ4oLPW4jgFkZDfclpfkdUlZE37JLo7m6D8rnWnTNeZAhepixOj1+4cdKI9Wfpg7VtNe5nUw40eHe/+nY61cNa1RrL5QEYlbbpvi1lgjWTCf3Xz4//m88wIslE3/40/wIZLa0DNjhWXlsv75x4M/tY1bqj14X4t+Tgx4HVQ3w88YFx/v8B3MEbxovtjwloeIhk9LnQHO5CVeNQKNzXCJLiTZd/cBc79EG++ZWCQnaBDI/SQpFVl1GrQn4rzj9E2UnJnVFctLJ1nvPycyW8/p+99/EVWpHbl9H35OC4oBIMqO94gw9ysJp6J2JFHAtfQfVDH5XmiVJcvkrI9CicpfxzqOy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(396003)(39860400002)(346002)(376002)(66556008)(55016002)(4326008)(66946007)(6916009)(66476007)(6666004)(9686003)(8676002)(8936002)(2906002)(316002)(1076003)(186003)(16526019)(5660300002)(54906003)(86362001)(6506007)(83380400001)(7696005)(52116002)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: v41ke418C0G5XlOCiMCODNlnnzwTuLuyKYxEtP2mJ1iVCNQ7W4ZSscsd+TD/EiFHHtHgSBVhdnYObZcNKNWRbKmhpXoztq93GDEP28ELIwjIt/SZcaSnYeO9o9ttCaQEGF/BkD089+xsq9z/c6kab1Ts48Un+QNxHjJn6QodB4/7KyHkI+ggwor4kYg58vWZPoAwsHZRlq08Lhonx7wFkbf/8tJZLTcfFOz6kjoaGebop9qrfAWQT1ZhdyfTADr0zbQcYlqx7BojhP5jHPieD36x3eMzOKfNYzANl5VQK0OSwUb/qw8+wACAR8EyTDEfnFlY3mprrj+TCj8AVLln1GmJ9MohXplk8763SzJYQktiLxGvXx6FjXZ2jA755PAZQEeG5Yeyq5I816ZkQvPPLnxKyaL48GPDbqfKSJSkmXzoOTQP7t+6dF1nyUiguVtQh7YC5sUppjvr2YVS/+A25ooh+t41ukV58grGaNptxslZYoMbKtusg6f2LOpx0suNBL53N68ofsuaBylLqOUwnM7PRaclynlDhjt2LWVqi2DrSh5PNHxdPmb84m69suAhqpHKEgDR68DsxvDMXRo249MJxrVLhQuHAtWVIZ4Up/IB0iSHE/wt0PGSombUW4Dg3DH0C0W2vy1B4C1abmFwOqqaqkdG3baAjVYU2usPK+1NAfC4L2gVuYRwzdsOhyXO
X-MS-Exchange-CrossTenant-Network-Message-Id: 2175626b-2b6e-4b33-126a-08d85fe2f133
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2020 17:05:59.0207
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Smrlgexh4PF7bAiU7sA+aCZh9XgPwO/d1s/e9OY8f4FC41EyC2iENRUuNhxZzbIM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2823
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-23_13:2020-09-23,2020-09-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 mlxlogscore=999 spamscore=0 adultscore=0 phishscore=0 malwarescore=0
 lowpriorityscore=0 bulkscore=0 clxscore=1015 suspectscore=1
 priorityscore=1501 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2009230132
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 23, 2020 at 10:27:27AM +0100, Lorenz Bauer wrote:
> On Tue, 22 Sep 2020 at 19:26, Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > On Tue, Sep 22, 2020 at 10:46:41AM +0100, Lorenz Bauer wrote:
> > > On Tue, 22 Sep 2020 at 08:04, Martin KaFai Lau <kafai@fb.com> wrote:
> > > >
> > > > There is a constant need to add more fields into the bpf_tcp_sock
> > > > for the bpf programs running at tc, sock_ops...etc.
> > > >
> > > > A current workaround could be to use bpf_probe_read_kernel().  However,
> > > > other than making another helper call for reading each field and missing
> > > > CO-RE, it is also not as intuitive to use as directly reading
> > > > "tp->lsndtime" for example.  While already having perfmon cap to do
> > > > bpf_probe_read_kernel(), it will be much easier if the bpf prog can
> > > > directly read from the tcp_sock.
> > > >
> > > > This patch tries to do that by using the existing casting-helpers
> > > > bpf_skc_to_*() whose func_proto returns a btf_id.  For example, the
> > > > func_proto of bpf_skc_to_tcp_sock returns the btf_id of the
> > > > kernel "struct tcp_sock".
> > > >
> > > > These helpers are also added to is_ptr_cast_function().
> > > > It ensures the returning reg (BPF_REF_0) will also carries the ref_obj_id.
> > > > That will keep the ref-tracking works properly.
> > > >
> > > > The bpf_skc_to_* helpers are made available to most of the bpf prog
> > > > types in filter.c. They are limited by perfmon cap.
> > > >
> > > > This patch adds a ARG_PTR_TO_BTF_ID_SOCK_COMMON.  The helper accepting
> > > > this arg can accept a btf-id-ptr (PTR_TO_BTF_ID + &btf_sock_ids[BTF_SOCK_TYPE_SOCK_COMMON])
> > > > or a legacy-ctx-convert-skc-ptr (PTR_TO_SOCK_COMMON).  The bpf_skc_to_*()
> > > > helpers are changed to take ARG_PTR_TO_BTF_ID_SOCK_COMMON such that
> > > > they will accept pointer obtained from skb->sk.
> > > >
> > > > PTR_TO_*_OR_NULL is not accepted as an ARG_PTR_TO_BTF_ID_SOCK_COMMON
> > > > at verification time.  All PTR_TO_*_OR_NULL reg has to do a NULL check
> > > > first before passing into the helper or else the bpf prog will be
> > > > rejected by the verifier.
> > > >
> > > > [ ARG_PTR_TO_SOCK_COMMON_OR_NULL was attempted earlier.  The _OR_NULL was
> > > >   needed because the PTR_TO_BTF_ID could be NULL but note that a could be NULL
> > > >   PTR_TO_BTF_ID is not a scalar NULL to the verifier.  "_OR_NULL" implicitly
> > > >   gives an expectation that the helper can take a scalar NULL which does
> > > >   not make sense in most (except one) helpers.  Passing scalar NULL
> > > >   should be rejected at the verification time.
> > >
> > > What is the benefit of requiring a !sk check from the user if all of
> > > the helpers know how to deal with a NULL pointer?
> > I don't see a reason why the verifier should not reject an incorrect
> > program at load time if it can.
> >
> > >
> > > >
> > > >   Thus, this patch uses ARG_PTR_TO_BTF_ID_SOCK_COMMON to specify that the
> > > >   helper can take both the btf-id ptr or the legacy PTR_TO_SOCK_COMMON but
> > > >   not scalar NULL.  It requires the func_proto to explicitly specify the
> > > >   arg_btf_id such that there is a very clear expectation that the helper
> > > >   can handle a NULL PTR_TO_BTF_ID. ]
> > >
> > > I think ARG_PTR_TO_BTF_ID_SOCK_COMMON is actually a misnomer, since
> > > nothing enforces that arg_btf_id is actually an ID for sock common.
> > > This is where ARG_PTR_TO_SOCK_COMMON_OR_NULL is much easier to
> > > understand, even though it's more permissive than it has to be. It
> > > communicates very clearly what values the argument can take.
> > _OR_NULL is incorrect which implies a scalar NULL as mentioned in
> > this commit message.  From verifier pov, _OR_NULL can take
> > a scalar NULL.
> 
> Yes, I know. I'm saying that the distinction between scalar NULL and
> runtime NULL only makes sense after you understand how BTF pointers
> are implemented. It only clicked for me after I read the support code
> in the JIT that Yonghong pointed out. Should everybody that writes a
> helper need to read the JIT? In my opinion we shouldn't. I guess I
> don't even care about the verifier rejecting scalar NULL or not, I'd
> just like the types to have a name that conveys their NULLness.
It is not only about verifier and/or JIT, not sure why it is related to
JIT also.

For some helpers, explicitly passing NULL may make sense.
e.g. bpf_sk_assign(ctx, NULL, 0) makes sense.

For most helpers, the bpf prog is wrong for sure, for example
in sockmap, what does bpf_map_update_elem(sock_map, key, NULL, 0)
mean?  I would expect a delete from the sock_map if the verifier
accepted it.

> 
> >
> > >
> > > If you're set on ARG_PTR_TO_BTF_ID_SOCK_COMMON I'd suggest forcing the
> > > btf_id in struct bpf_reg_types. This avoids the weird case where the
> > > btf_id doesn't actually point at sock_common, and it also makes my
> > I have considered the bpf_reg_types option.  I prefer all
> > arg info (arg_type and arg_btf_id) stay in the same one
> > place (i.e. func_proto) as much as possible for now
> > instead of introducing another place to specify/override it
> > which then depends on a particular arg_type that some arg_type may be
> > in func_proto while some may be in other places.
> 
> In my opinion that ship sailed when we started aliasing arg_type to
> multiple reg_type, but OK.
> 
> >
> > The arg_btf_id can be checked in check_btf_id_ok() if it would be a
> > big concern that it might slip through the review but I think the
> > chance is pretty low.
> 
> Why increase the burden on human reviewers? Why add code to check an
> invariant that we could get rid of in the first place?
Lets take the scalar NULL example that requires to read multiple
pieces of codes in different places (verifier, JIT...etc.).
As you also mentioned, yes, it may be easy for a few people.
However, for most others, having some obvious things in the same place is
easier to review.

I think we have to agree we disagree on this one implementation details
which I think it has been over-thought (and time also).

If you insist that should go into bpf_reg_types (i.e. compatible->btf_id),
I can do that in v4 and then add another check in another place to
ensure "!compatible->btf_id" as in v2.
