Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43FC93030C4
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 01:03:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732087AbhAZACr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 19:02:47 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:65374 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731569AbhAZABt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 19:01:49 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10PNrT1o021027;
        Mon, 25 Jan 2021 16:00:51 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=eWy6p6S/b11nSWZCYTLSl4N11IsL7iVftEovGnreYnw=;
 b=Irr84PMeXy6Kwlc9ZWv/FSKDJQmY3VLJBzn+023RjcFoj2M3BhllRsYQNlGhP3XhHaGS
 EGFquPveHX28h16mR6OyjQkqD7M1JTcseYhf4uMXFa7TzgnQOi7bYB/DCEHQsHhv0UFr
 Ufha9tTLCzYGgNDIoJUmvt6EjZ3OJkYVCxc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3694qurtpp-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 25 Jan 2021 16:00:51 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 25 Jan 2021 16:00:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fk7M2IFH3y0GDFtdiABTLJRktynBikzv55MKrpKoxzsY2KAHWFzRKA5w7E0XhrCWWFbpNJbcSj7DoSxdmNX7bZmHH224FZUs67gR9AWDvPfwDBAyut+cgOvIFP0CrLgqHqxZ96UyjY8iNGWm6sEtS1VnCNxo/0uG5Xf9/UDgysOlooH7T7YntYPSdIRosU7Nd/sDjnX29vr0nfeSKhlxbaQfeB65C3g1fFrkc1EUWSqYSXIyq6TLBt1uJ2pCrGkfS94SfBwzZzNakSpT29BxKDMOcG/jAIvCrR2euHTi2v2xvmXYUXRRnK4L20TmxOh3WxFkqyM9juR5YeFBcnSrfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eWy6p6S/b11nSWZCYTLSl4N11IsL7iVftEovGnreYnw=;
 b=O6/w6RIcA5wby9T7l702dS8fhSNabzt1O/ULKOMKErc+7sSMJKvGacL32HCCVJhNFutVC9Nol5/vUI9xQZDNpQUKqQYvIkGCE2XmmIiVo7YUcfzSZ4AkeqmDPqnjALDYGciVb0EKjHVWEtYuM4JeudRhXhfWBmj0lSDZNHXsSW8jI+RBM9xffh+V3thT4iHK4CIzFdzTCwLXLyg+IE98C7jh9SfSpdicnrVr15dqRSFcQIYeqxBtIJ/BB9ChtqajHHTBuetQFGCPtKOihRzpKHVoWd0JVa/0Z/V9Dh1DjiQ4IfERR4kUKSL7NgndBCgP9fPBLS9G9aZ2CcZ7Dtiy5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eWy6p6S/b11nSWZCYTLSl4N11IsL7iVftEovGnreYnw=;
 b=bkJQIOf+jyGyClTpG88IHE5QekbWV5TaSgGMh+ypQmLjuL/HJ+XrhAJ7wHU8n5sZ+OxR1+0ZijFpYx2KuQKGhVgQ5ThsFI6y5Gp7pFnrtRtQvBrhNHpp8xA287rTAVXX9kZTBKCB/z0txjGpGlRr0VvZ+Xqyt+iQuN7fl/4EcFY=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2998.namprd15.prod.outlook.com (2603:10b6:a03:fc::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.13; Tue, 26 Jan
 2021 00:00:42 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::d13b:962a:2ba7:9e66]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::d13b:962a:2ba7:9e66%3]) with mapi id 15.20.3784.017; Tue, 26 Jan 2021
 00:00:42 +0000
Date:   Mon, 25 Jan 2021 16:00:25 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
CC:     Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrey Ignatov <rdna@fb.com>
Subject: Re: [PATCH bpf-next v2 1/2] bpf: allow rewriting to ports under
 ip_unprivileged_port_start
Message-ID: <20210126000025.kaitlboviyjlsktn@kafai-mbp>
References: <20210125172641.3008234-1-sdf@google.com>
 <20210125232500.fmb4trbady6jfdfp@kafai-mbp>
 <CAKH8qBuz2uVO2oB3rDMqcw41FOWbx5HS0vUPT2KLv_6rhZuyrw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKH8qBuz2uVO2oB3rDMqcw41FOWbx5HS0vUPT2KLv_6rhZuyrw@mail.gmail.com>
X-Originating-IP: [2620:10d:c090:400::5:4fac]
X-ClientProxiedBy: MW4PR03CA0005.namprd03.prod.outlook.com
 (2603:10b6:303:8f::10) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:4fac) by MW4PR03CA0005.namprd03.prod.outlook.com (2603:10b6:303:8f::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.14 via Frontend Transport; Tue, 26 Jan 2021 00:00:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d6134693-6ef4-4870-4a36-08d8c18d6c30
X-MS-TrafficTypeDiagnostic: BYAPR15MB2998:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB29985CBB17D8BF869852890CD5BC9@BYAPR15MB2998.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ANYk3U5tMRRvkeF7Od59TiUTBC/EYmL4LRfTDqKj3om5kZD++//yabe/wh3oTLpY4soXJZmYfi9iirhRgswuYnEisjm4ZJWWv3TwKJm8uY/weTADdtu7tSDvkJtPfY31rLrdxSDXdz5Ms8FqXdkQk/GaBjrZa9FngQhdsGM2SHuvAw7UjXedChkTLwHNXRV3m2RrUiq0C4Q2obnsq2D3EkLMyT4S8bWU7QILSgAlWCUodS7kVxE+emeHdSYc5d+ytvRg+9xPxdKlHHcInsTwnkIZw+S0ylUVaIlw8k9C0zR3+04+p3YXJRPUIjg+b1a9nRzzuHoPOHRnFuOYN2eAVBq8WMZHJEpEPLxz8ntz15wDZCLRv/tRnf3hs1XgShORl4U6S46i3pP7BnfimPzICQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(396003)(39860400002)(136003)(366004)(6496006)(478600001)(52116002)(5660300002)(8676002)(3716004)(54906003)(86362001)(55016002)(9686003)(83380400001)(4326008)(6666004)(186003)(33716001)(53546011)(316002)(8936002)(1076003)(2906002)(66476007)(6916009)(66556008)(16526019)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?wpFuA0SuxL6fRx09Et2NxAbpUvmCzI32BhmiHXp/VuB2B0j9ILaZ09wTtqF3?=
 =?us-ascii?Q?qKdZH0Lt63e0KUujpaLbSF5fhhxAvrTk8FYU7vtI5VIppvjbimXSQkqSSn9k?=
 =?us-ascii?Q?IJG40bBvTyat0DSlw6VgbgO1p6sf32LT13cwtfXsuNty21U50cdjlvQvPh30?=
 =?us-ascii?Q?Ys5I5Tlru1iE68lz75+8vjXn3lFhwFA6cB8IOwaNe9lsbevCAxOnDWM2nGnA?=
 =?us-ascii?Q?MnwSiKt0Q4vuic2PN+NNMNWUi8CCejW3SvNZB1Rz790klXlkPbPLsqlKetuW?=
 =?us-ascii?Q?lpRQh/fuIVDlVuj7fVRU1Kwt5cSu6C5vagFgvfzOs+ZX6P+myrhidTuSFoqt?=
 =?us-ascii?Q?wTwrI6PdNHOIMgb+lpAgbTo0Ug8ON6TXXsExaz15ntsw5L2frmlLkCPKsDsy?=
 =?us-ascii?Q?NTj9EXxYbE3pnUp9z89Pzpf4pGckxwhpoubq5U7VUCBCCCZhzI6pItktDirv?=
 =?us-ascii?Q?h/p4bm8zsVcINmW4YkA8rRms3XT75naEky1g87k6WBWoeZWyTUdlbZugi7Dh?=
 =?us-ascii?Q?NUQiFXXlEScOx0zNHYIP+7BHcnsW5EI0SXsCcD7dYxyQ5gcURVNmPQhp5Zl3?=
 =?us-ascii?Q?FIzycDR/nJIhX4B2xDmPlcYV4Ow/8VRdcnNhEsb8fzmfSVP5g+wYY4cmtXLl?=
 =?us-ascii?Q?ZgJH9JvFD+Yr7eXusxEWoy1njj8AnQakPdJKBYDAayK2jB90b1Obdlb7f/W2?=
 =?us-ascii?Q?Wwc6tyDfz0yn8spNb9oQ/A0Vd/HbFcEW9zs4U7v/HQxd4HbBsXks/cjxZpir?=
 =?us-ascii?Q?3jXpP4wp5fUZ4HG/QwHMsFR9EBLrYUZZUwthb+thYw9iyQB3JQB/O2EA1T60?=
 =?us-ascii?Q?BTlI2WVIByJzvYWNGoF7b+H5yg6Q6Me8jBXTQzCQQDkMZ6+stBtStDufti62?=
 =?us-ascii?Q?YLm5b3P5Ooupqk4XSWV+RTCahNbFi4N9IDt6C6nZRcLXrxULyaPJEX4KAAC/?=
 =?us-ascii?Q?986uL7btOJD5UBA++GIJfi3iK+h4FzBv1bY4GGjrl/NsMcMioFR/7W79s1ax?=
 =?us-ascii?Q?nM2/qA31ukYHmRTVo7y7wB1HBEu2q8w6esBo6UZlEYaoEO7X5M2mj3AMHTDm?=
 =?us-ascii?Q?ihBR1n2dB1gM+81yD8ic6undF4wpf+ydbfOlDS+7gslfVGakIvA=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d6134693-6ef4-4870-4a36-08d8c18d6c30
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2021 00:00:42.3628
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ECMDGfrqvioTcgoUhr5aQytnTsbgM1NR6JE6qsBvPovVlk0IHFV31/40GnRYwgpR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2998
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-25_10:2021-01-25,2021-01-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 priorityscore=1501 suspectscore=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 phishscore=0 bulkscore=0 lowpriorityscore=0 clxscore=1015
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101250121
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 25, 2021 at 03:32:53PM -0800, Stanislav Fomichev wrote:
> On Mon, Jan 25, 2021 at 3:25 PM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > On Mon, Jan 25, 2021 at 09:26:40AM -0800, Stanislav Fomichev wrote:
> > > At the moment, BPF_CGROUP_INET{4,6}_BIND hooks can rewrite user_port
> > > to the privileged ones (< ip_unprivileged_port_start), but it will
> > > be rejected later on in the __inet_bind or __inet6_bind.
> > >
> > > Let's export 'port_changed' event from the BPF program and bypass
> > > ip_unprivileged_port_start range check when we've seen that
> > > the program explicitly overrode the port. This is accomplished
> > > by generating instructions to set ctx->port_changed along with
> > > updating ctx->user_port.
> > The description requires an update.
> Ah, sure, will update it.
> 
> > [ ... ]
> >
> > > diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> > > index da649f20d6b2..cdf3c7e611d9 100644
> > > --- a/kernel/bpf/cgroup.c
> > > +++ b/kernel/bpf/cgroup.c
> > > @@ -1055,6 +1055,8 @@ EXPORT_SYMBOL(__cgroup_bpf_run_filter_sk);
> > >   * @uaddr: sockaddr struct provided by user
> > >   * @type: The type of program to be exectuted
> > >   * @t_ctx: Pointer to attach type specific context
> > > + * @flags: Pointer to u32 which contains higher bits of BPF program
> > > + *         return value (OR'ed together).
> > >   *
> > >   * socket is expected to be of type INET or INET6.
> > >   *
> > > @@ -1064,7 +1066,8 @@ EXPORT_SYMBOL(__cgroup_bpf_run_filter_sk);
> > >  int __cgroup_bpf_run_filter_sock_addr(struct sock *sk,
> > >                                     struct sockaddr *uaddr,
> > >                                     enum bpf_attach_type type,
> > > -                                   void *t_ctx)
> > > +                                   void *t_ctx,
> > > +                                   u32 *flags)
> > >  {
> > >       struct bpf_sock_addr_kern ctx = {
> > >               .sk = sk,
> > > @@ -1087,7 +1090,8 @@ int __cgroup_bpf_run_filter_sock_addr(struct sock *sk,
> > >       }
> > >
> > >       cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
> > > -     ret = BPF_PROG_RUN_ARRAY(cgrp->bpf.effective[type], &ctx, BPF_PROG_RUN);
> > > +     ret = BPF_PROG_RUN_ARRAY_FLAGS(cgrp->bpf.effective[type], &ctx,
> > > +                                    BPF_PROG_RUN, flags);
> > >
> > >       return ret == 1 ? 0 : -EPERM;
> > >  }
> > > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > > index d0eae51b31e4..ef7c3ca53214 100644
> > > --- a/kernel/bpf/verifier.c
> > > +++ b/kernel/bpf/verifier.c
> > > @@ -7986,6 +7986,11 @@ static int check_return_code(struct bpf_verifier_env *env)
> > >                   env->prog->expected_attach_type == BPF_CGROUP_INET4_GETSOCKNAME ||
> > >                   env->prog->expected_attach_type == BPF_CGROUP_INET6_GETSOCKNAME)
> > >                       range = tnum_range(1, 1);
> > > +             if (env->prog->expected_attach_type == BPF_CGROUP_INET4_BIND ||
> > > +                 env->prog->expected_attach_type == BPF_CGROUP_INET6_BIND) {
> > > +                     range = tnum_range(0, 3);
> > > +                     enforce_attach_type_range = tnum_range(0, 3);
> > It should be:
> >                         enforce_attach_type_range = tnum_range(2, 3);
> Hm, weren't we enforcing attach_type for bind progs from the beginning?
Ah, right.  Then there is no need to set enforce_attach_type_range at all.
"enforce_attach_type_range = tnum_range(0, 3);" can be removed.

> Also, looking at bpf_prog_attach_check_attach_type, it seems that we
> care only about BPF_PROG_TYPE_CGROUP_SKB for
> prog->enforce_expected_attach_type.
> Am I missing something?
It is because, from the very beginning, BPF_PROG_TYPE_CGROUP_SKB did not
enforce the attach_type in bpf_prog_attach_check_attach_type().
