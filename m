Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6586E277D94
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 03:23:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726808AbgIYBXk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 21:23:40 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:40186 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726718AbgIYBXk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 21:23:40 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08P1KskX007013;
        Thu, 24 Sep 2020 18:23:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=N3EpIFSmPVPydmj5PDT69oNHlW8BA+4BZCJrwyx2Oag=;
 b=T6XvdYlM2mm7hNxzu9rKRgHlmFdCqFXb3niwWb7iLe1Bn92dUYWjSxqbmB+l+v9M3Q/5
 tH81lSKQTZ/5a9r7m5lzBPlSNTyZKwu8Qht+BHKyAsx7SJBJs4chgQg98nvK3gqZQngR
 lT9fvvorGvcQS29s6SXjRYL+VJF7d9EgDGs= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 33qsp7d547-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 24 Sep 2020 18:23:25 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 24 Sep 2020 18:23:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NUUjDOZChqIRQh+cc6AyMRKs6wSrLOmkhVlmx6sEfs6TOl5DaUD7Ls19Bi4KlisGpiZVnIjwv7HCJ3HDGAxhnTaFpJYFBB7DKmwn1Xi2iU3Fp7cvEwiozizdVRDtBkplUiBlowSpCuE/mcbcmgrl5gtz+HmrIMz4s5LjPE8ipf530ADBwL5Pf9IUUAJuyA4egovIMozmZbCGRrWUCruujNhGdO+2Cu5qbnQgeL5X3TG89f9sqdXouaWjMWIBo0wEnm6ECQsFvaWE8ZCFYWa0t1b4N8lWE3ahtta04fqt5DEIsElzj46svt2J4b+9fpQystyK4dloWtAiQM2LHG+Ycw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N3EpIFSmPVPydmj5PDT69oNHlW8BA+4BZCJrwyx2Oag=;
 b=ZzIhwLnPisB9eejsVTttRk+c8IJv2ekG2JA0ssCy16iCHebC+3wAO6mcsg6zXQ/UW7MRAwmeHL/486GqkR2MeVmnWdIhQL7mVbpeuNqKkyxkmLcD896FCugr2AZE0MvmjWbWNFAqjs4dbZyURc5/vqNYojcSYYpXPU6KvucAFD/cQQ1yOtGAGZ336I3s4nIrrS0t1Qi7weuTPOpHrrkaXyJf1aUFytXQgw4cGHmykmTSghReIjeadGk22aPWAn1Q4yIvNjlPnU47sEHaDRkMLZTvIjt0Ru52cQkNZXw38TJh5fn/Cj/jB8Wvxkp6ctr4S0Mzv8gQida1JdDxw815zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N3EpIFSmPVPydmj5PDT69oNHlW8BA+4BZCJrwyx2Oag=;
 b=J4qpagLcjLGns7aedXifwAgrHSGmvuEE7yy3tti9WbSF1ve6ntdmyr7Ux9PAZNZDZL53QazdKzkvMXa84cxkw63NOIoJ4xtvPu/X5f8+hYKklHHU7Rp08U03MjMPxxKiU+bi7JimB6JXPP4H6127g0MLyf1UqmLSKcYT9qg26YA=
Authentication-Results: cloudflare.com; dkim=none (message not signed)
 header.d=none;cloudflare.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2406.namprd15.prod.outlook.com (2603:10b6:a02:84::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Fri, 25 Sep
 2020 01:23:03 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c13c:fca9:5e04:9bfb]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c13c:fca9:5e04:9bfb%3]) with mapi id 15.20.3391.027; Fri, 25 Sep 2020
 01:23:03 +0000
Date:   Thu, 24 Sep 2020 18:22:56 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Lorenz Bauer <lmb@cloudflare.com>
CC:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH v3 bpf-next 02/11] bpf: Enable bpf_skc_to_* sock casting
 helper to networking prog type
Message-ID: <20200925012256.puutanrjtdc2sqas@kafai-mbp>
References: <20200922070409.1914988-1-kafai@fb.com>
 <20200922070422.1917351-1-kafai@fb.com>
 <CACAyw9-LoKFuYxaMODtacJM-rOR0P5Y=j_yEm9bsFZe_j_9rYQ@mail.gmail.com>
 <20200922182622.zcrqwpzkouvlndbw@kafai-mbp.dhcp.thefacebook.com>
 <CACAyw99xbeVyzUT+fhHtRQEGoef-9vvTfiOEFaJWX6aoVL+Z9A@mail.gmail.com>
 <20200923170552.65i7bnht3qkkikp5@kafai-mbp.dhcp.thefacebook.com>
 <CACAyw98yYLD-oLQpj05Yrmphf285DUD4aXJMTK1GS8_eMy7jow@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACAyw98yYLD-oLQpj05Yrmphf285DUD4aXJMTK1GS8_eMy7jow@mail.gmail.com>
X-ClientProxiedBy: MWHPR17CA0094.namprd17.prod.outlook.com
 (2603:10b6:300:c2::32) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:c64) by MWHPR17CA0094.namprd17.prod.outlook.com (2603:10b6:300:c2::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20 via Frontend Transport; Fri, 25 Sep 2020 01:23:02 +0000
X-Originating-IP: [2620:10d:c090:400::5:c64]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b260b172-949c-4f5b-7604-08d860f18c48
X-MS-TrafficTypeDiagnostic: BYAPR15MB2406:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB240656ED0C1015D5240FA4FDD5360@BYAPR15MB2406.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6HlooS87ANSyVVOYCGqpMyhnSu5IXFV0soJDMp1ZF3GgezItCCEkwIz+AJNUGg4Cf1+QdJAAcFHjucud3JWIH7IJsw9bKCN9o7SmnbGN772WTrV1Zsdy/EHD05nLma1J7ig7nOmt7by2TR5JKeQe49xfPNWf5GBNS17+e6qYopk8OFnovyiotUrBGOj1fitESuEZWpZIFEFGs9v8SYLjdCbiYMBuNnjOcIypUF6Wz6sezBZBgkzMfIcbU9MvpC/vb4Uv/8OE4QfSoJYWs9ESSh48EYySXhT8iUC84PdboYxVF4e0FtJZD5mAzlqQBViT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(346002)(376002)(366004)(396003)(83380400001)(54906003)(6916009)(52116002)(55016002)(5660300002)(2906002)(8676002)(6496006)(6666004)(9686003)(33716001)(186003)(66946007)(66556008)(66476007)(8936002)(16526019)(478600001)(1076003)(4326008)(86362001)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: T9230ydnA00Yrs3FMa14JAXcdmf9fWw6Iy4cQbvWtf2GjS9fRGurv5ew+TgD/UiwtSuB4hIiajGpoASn35cqO3PclTimnAMdZhuAJ+3STzBJaTp2tWB/UXTjCVkHaCh0esf5N9LoAhttvrEUjfvUwG/e+ajtcNgbXarNdCFqwKZkK+NKGl0seeFSLjwmD+b+9OEmeWogRpzM8Fk2L/2eGkIEcWiaKoZYGd4h0LKO+dMtzjnyzPHHVZsMLNMDbjxBRq1ZPF4mFrRK0cDW/+MVXsbxSHQa21ObkHi2s9qlQ9KYWV9fkW4hdBTlJVAuv8Qb+m9LdXwf2nNYtWmQ02xmS4/Nhb0sAVD3qGcxSXMBIfyE/ic60ysp4Kx+aeMBQ80AVgduCozShVbfImKNNPQS9mvYfd2vi1mj7sObCc2rp16KbipG/j3QiJq8wY06Um3deEltC7C1gK+OnddfkDrwVbTzpVvzkHwuiMpdfSCl9kDthzS6pF4w+EALohMiVa3TvoiCPdAyKSOYUYvkUsdh/odc8+hOgc6FPlY/c7eMlG7GcB19uu+H9f37sU2rptJVuDeV4UL16OUlFSH+im441AZ3q7gT7szupuUwO6Mf5MLk1/4gujedqJ6MWaoAs+31XVuJjD6XHw9F81NX07X2SqAB5P8WGhfyCqKO5a0OmTU=
X-MS-Exchange-CrossTenant-Network-Message-Id: b260b172-949c-4f5b-7604-08d860f18c48
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2020 01:23:03.1747
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pRGmiL/NF4bFHlfU6Fcz0o5erep3vJZnXuwUytBt24jxOA0t+ebO7reyMPbe2Tz0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2406
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-24_18:2020-09-24,2020-09-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 mlxlogscore=999 impostorscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 mlxscore=0 malwarescore=0 spamscore=0 suspectscore=1
 clxscore=1015 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2009250005
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 24, 2020 at 09:38:09AM +0100, Lorenz Bauer wrote:
> On Wed, 23 Sep 2020 at 18:06, Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > On Wed, Sep 23, 2020 at 10:27:27AM +0100, Lorenz Bauer wrote:
> > > On Tue, 22 Sep 2020 at 19:26, Martin KaFai Lau <kafai@fb.com> wrote:
> > > >
> > > > On Tue, Sep 22, 2020 at 10:46:41AM +0100, Lorenz Bauer wrote:
> > > > > On Tue, 22 Sep 2020 at 08:04, Martin KaFai Lau <kafai@fb.com> wrote:
> > > > > >
> > > > > > There is a constant need to add more fields into the bpf_tcp_sock
> > > > > > for the bpf programs running at tc, sock_ops...etc.
> > > > > >
> > > > > > A current workaround could be to use bpf_probe_read_kernel().  However,
> > > > > > other than making another helper call for reading each field and missing
> > > > > > CO-RE, it is also not as intuitive to use as directly reading
> > > > > > "tp->lsndtime" for example.  While already having perfmon cap to do
> > > > > > bpf_probe_read_kernel(), it will be much easier if the bpf prog can
> > > > > > directly read from the tcp_sock.
> > > > > >
> > > > > > This patch tries to do that by using the existing casting-helpers
> > > > > > bpf_skc_to_*() whose func_proto returns a btf_id.  For example, the
> > > > > > func_proto of bpf_skc_to_tcp_sock returns the btf_id of the
> > > > > > kernel "struct tcp_sock".
> > > > > >
> > > > > > These helpers are also added to is_ptr_cast_function().
> > > > > > It ensures the returning reg (BPF_REF_0) will also carries the ref_obj_id.
> > > > > > That will keep the ref-tracking works properly.
> > > > > >
> > > > > > The bpf_skc_to_* helpers are made available to most of the bpf prog
> > > > > > types in filter.c. They are limited by perfmon cap.
> > > > > >
> > > > > > This patch adds a ARG_PTR_TO_BTF_ID_SOCK_COMMON.  The helper accepting
> > > > > > this arg can accept a btf-id-ptr (PTR_TO_BTF_ID + &btf_sock_ids[BTF_SOCK_TYPE_SOCK_COMMON])
> > > > > > or a legacy-ctx-convert-skc-ptr (PTR_TO_SOCK_COMMON).  The bpf_skc_to_*()
> > > > > > helpers are changed to take ARG_PTR_TO_BTF_ID_SOCK_COMMON such that
> > > > > > they will accept pointer obtained from skb->sk.
> > > > > >
> > > > > > PTR_TO_*_OR_NULL is not accepted as an ARG_PTR_TO_BTF_ID_SOCK_COMMON
> > > > > > at verification time.  All PTR_TO_*_OR_NULL reg has to do a NULL check
> > > > > > first before passing into the helper or else the bpf prog will be
> > > > > > rejected by the verifier.
> > > > > >
> > > > > > [ ARG_PTR_TO_SOCK_COMMON_OR_NULL was attempted earlier.  The _OR_NULL was
> > > > > >   needed because the PTR_TO_BTF_ID could be NULL but note that a could be NULL
> > > > > >   PTR_TO_BTF_ID is not a scalar NULL to the verifier.  "_OR_NULL" implicitly
> > > > > >   gives an expectation that the helper can take a scalar NULL which does
> > > > > >   not make sense in most (except one) helpers.  Passing scalar NULL
> > > > > >   should be rejected at the verification time.
> > > > >
> > > > > What is the benefit of requiring a !sk check from the user if all of
> > > > > the helpers know how to deal with a NULL pointer?
> > > > I don't see a reason why the verifier should not reject an incorrect
> > > > program at load time if it can.
> > > >
> > > > >
> > > > > >
> > > > > >   Thus, this patch uses ARG_PTR_TO_BTF_ID_SOCK_COMMON to specify that the
> > > > > >   helper can take both the btf-id ptr or the legacy PTR_TO_SOCK_COMMON but
> > > > > >   not scalar NULL.  It requires the func_proto to explicitly specify the
> > > > > >   arg_btf_id such that there is a very clear expectation that the helper
> > > > > >   can handle a NULL PTR_TO_BTF_ID. ]
> > > > >
> > > > > I think ARG_PTR_TO_BTF_ID_SOCK_COMMON is actually a misnomer, since
> > > > > nothing enforces that arg_btf_id is actually an ID for sock common.
> > > > > This is where ARG_PTR_TO_SOCK_COMMON_OR_NULL is much easier to
> > > > > understand, even though it's more permissive than it has to be. It
> > > > > communicates very clearly what values the argument can take.
> > > > _OR_NULL is incorrect which implies a scalar NULL as mentioned in
> > > > this commit message.  From verifier pov, _OR_NULL can take
> > > > a scalar NULL.
> > >
> > > Yes, I know. I'm saying that the distinction between scalar NULL and
> > > runtime NULL only makes sense after you understand how BTF pointers
> > > are implemented. It only clicked for me after I read the support code
> > > in the JIT that Yonghong pointed out. Should everybody that writes a
> > > helper need to read the JIT? In my opinion we shouldn't. I guess I
> > > don't even care about the verifier rejecting scalar NULL or not, I'd
> > > just like the types to have a name that conveys their NULLness.
> > It is not only about verifier and/or JIT, not sure why it is related to
> > JIT also.
> >
> > For some helpers, explicitly passing NULL may make sense.
> > e.g. bpf_sk_assign(ctx, NULL, 0) makes sense.
> >
> > For most helpers, the bpf prog is wrong for sure, for example
> > in sockmap, what does bpf_map_update_elem(sock_map, key, NULL, 0)
> > mean?  I would expect a delete from the sock_map if the verifier
> > accepted it.
> >
> > >
> > > >
> > > > >
> > > > > If you're set on ARG_PTR_TO_BTF_ID_SOCK_COMMON I'd suggest forcing the
> > > > > btf_id in struct bpf_reg_types. This avoids the weird case where the
> > > > > btf_id doesn't actually point at sock_common, and it also makes my
> > > > I have considered the bpf_reg_types option.  I prefer all
> > > > arg info (arg_type and arg_btf_id) stay in the same one
> > > > place (i.e. func_proto) as much as possible for now
> > > > instead of introducing another place to specify/override it
> > > > which then depends on a particular arg_type that some arg_type may be
> > > > in func_proto while some may be in other places.
> > >
> > > In my opinion that ship sailed when we started aliasing arg_type to
> > > multiple reg_type, but OK.
> > >
> > > >
> > > > The arg_btf_id can be checked in check_btf_id_ok() if it would be a
> > > > big concern that it might slip through the review but I think the
> > > > chance is pretty low.
> > >
> > > Why increase the burden on human reviewers? Why add code to check an
> > > invariant that we could get rid of in the first place?
> > Lets take the scalar NULL example that requires to read multiple
> > pieces of codes in different places (verifier, JIT...etc.).
> > As you also mentioned, yes, it may be easy for a few people.
> > However, for most others, having some obvious things in the same place is
> > easier to review.
> >
> > I think we have to agree we disagree on this one implementation details
> > which I think it has been over-thought (and time also).
> >
> > If you insist that should go into bpf_reg_types (i.e. compatible->btf_id),
> > I can do that in v4 and then add another check in another place to
> > ensure "!compatible->btf_id" as in v2.
> 
> No, I don't insist. I was hoping I could convince you, but alas :)

Not very convinced but I don't feel very strongly on this ;)
so I have posted v4 with btf_id in struct bpf_reg_types to continue
the review of the set.  Thanks.
