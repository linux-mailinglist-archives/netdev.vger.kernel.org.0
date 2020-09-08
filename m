Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BED242617F5
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 19:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731844AbgIHRqD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 13:46:03 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:51738 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731352AbgIHRpc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 13:45:32 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 088HiuxP004041;
        Tue, 8 Sep 2020 10:45:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=d6/6frgZkyl94dUtPxOFnLzq+w5AapHa00HrRr5j7dc=;
 b=QNjYjQkM+dbach3Wsr56jiBE2PR2R4zfywdaog5ToKdoCiaJeQcsEVtXUcfKEhkRiM0E
 vTF4TA+vj8aS7Zy0dvxq4epwenSJiSQ3g5o29k9vLaargb0+hnF1YYyJJSA++PJzujDd
 pPpgvO4s+x3Za3uIqQvmeWv4dNGfj/SIrqI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 33c8dwdkad-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 08 Sep 2020 10:45:04 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 8 Sep 2020 10:44:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZVGYc59a2QD3W9MrdTLkb4N0EuD2duVYkU3aSMGyd1QurJHREbECrGsFhV7hnaM/5TVjNulhYKt5B0bVXoBvVTtZTte+sVXPjVAjyBqR1qCeS6Q4aJTX/j55H38nS/dhMiNtj0aTD0ScG9gyGJXEskdDwvo4yKdLCNGDbj6RhXQmMZjZGo+dOJJqXhChWsBOz3xHz3uPjgeifv4oQpVSNIayqPOMlZUNarA2OSJbPV8pWid+y1VjMNiP2MB3XkbGdZEWGFhFvEF1R3tgwliq+SaZ4MRUGvrxO4z1gF4YsXuGplODW3QHan0RnRY8hXCu4Wff80o0fH18GpGSGzyE3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d6/6frgZkyl94dUtPxOFnLzq+w5AapHa00HrRr5j7dc=;
 b=VAqQK60lX5igdfsC7hwGghT5YvLyYh3Gmsk0J7oNvCX4jQN1IKW4cfGZINodYXxZcW3xL8MKODn4Ri3ArghYs38hG5rQvN6s/8O+SNOO66aqhP9Q/OB3BFjLI7P8mDoFgjUtajjGRJiF6DjFeBtG3aqeD64dzUgratWFL4dIbEOdxshr1ogziBDJzeJgiIqg0w/Shu1FTgNh4IGORQbqRTsQjb+04UOwGl75k8x15s/qJJPQIF3ct1V50UK74OBh0VniBpNl7uX9wpvxDC9C8sKl0W8Zu9qW4JN9TiGsB5IcmMoSLoETXbyvZLd8wmW18sw6Zaff+3AkcvhxfChntw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d6/6frgZkyl94dUtPxOFnLzq+w5AapHa00HrRr5j7dc=;
 b=ZHi/0095CjHxLKSxTAQ/yLyggopnmFMkjxPXKMZc/fMVkNXSR2UedL80ejcYq3kAkmM9n+bFmImOpF7mQAH3PChEaTHP9zMCTcoFV/oNIHjflErqFrwRFWhTjugS+fIQbiYBb4Thj3e3883mvGojvHt5iISG+dc4GMN2o0njqsA=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4119.namprd15.prod.outlook.com (2603:10b6:a02:cd::20)
 by BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.16; Tue, 8 Sep
 2020 17:44:50 +0000
Received: from BYAPR15MB4119.namprd15.prod.outlook.com
 ([fe80::9536:1fda:18bb:1abb]) by BYAPR15MB4119.namprd15.prod.outlook.com
 ([fe80::9536:1fda:18bb:1abb%7]) with mapi id 15.20.3348.019; Tue, 8 Sep 2020
 17:44:50 +0000
Date:   Tue, 8 Sep 2020 10:44:49 -0700
From:   Andrey Ignatov <rdna@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        YiFei Zhu <zhuyifei@google.com>,
        YiFei Zhu <zhuyifei1999@gmail.com>
Subject: Re: [PATCH bpf-next v3 3/8] libbpf: Add BPF_PROG_BIND_MAP syscall
 and use it on .metadata section
Message-ID: <20200908174449.GA34763@rdna-mbp>
References: <20200828193603.335512-1-sdf@google.com>
 <20200828193603.335512-4-sdf@google.com>
 <CAEf4BzZtYTyBT=jURkF4RQLHXORooVwXrRRRkoSWDqCemyGQeA@mail.gmail.com>
 <20200904012909.c7cx5adhy5f23ovo@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzZp4ODLbjEiv=W7byoR9XzTqAQ052wZM_wD4=aTPmkjbw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAEf4BzZp4ODLbjEiv=W7byoR9XzTqAQ052wZM_wD4=aTPmkjbw@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-ClientProxiedBy: BYAPR06CA0041.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::18) To BYAPR15MB4119.namprd15.prod.outlook.com
 (2603:10b6:a02:cd::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2620:10d:c090:400::5:c664) by BYAPR06CA0041.namprd06.prod.outlook.com (2603:10b6:a03:14b::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Tue, 8 Sep 2020 17:44:49 +0000
X-Originating-IP: [2620:10d:c090:400::5:c664]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f12e933f-4bfb-41f9-43b8-08d8541ee288
X-MS-TrafficTypeDiagnostic: BY5PR15MB3571:
X-Microsoft-Antispam-PRVS: <BY5PR15MB35719429E8A2C7053656F187A8290@BY5PR15MB3571.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fjyrrKT019VSsyW7EXlrk6KkUWyslWcXxigio0NbtXyvJe1x972sgvt3KXQuY9GSS7tO/v7pXnczbpiEj71khSRgSwaPCkS7h9wUFDkq2xiR3K/e75zjmqJRbyOZ8JaKPxT9tmBMpEaJjH6T8aEB15pj4npwstceCDzzyX/4if9x6GRlVsVOWYXwd9Ohr71QYGbu49OFOPAuaJoXc5zczaBXzuBAQDE851hJjYqXTEq5Si+RfEkeYms7/gVMun0SKWXxf+mZKj4e0m4hmGX0/Yyvs2z4wenbuIIK3cxWsTyXRZ5gK/EN81/6iVhTzhF8eF7RoAjWV3ZjhIxxi3RCFXiVmzOZfPuQ4ynQOhrYUJBH7FGOIE+JZL0kLZRI61sn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4119.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(376002)(346002)(39860400002)(396003)(136003)(16526019)(33716001)(53546011)(6496006)(9686003)(52116002)(54906003)(2906002)(8936002)(7416002)(478600001)(8676002)(6916009)(6486002)(4326008)(1076003)(316002)(186003)(33656002)(86362001)(5660300002)(66946007)(83380400001)(66476007)(66556008)(142923001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: TZnZjHhJma9GX2z3S9juuYQVIvBchHNH1gAqk3Sdx1CHsRX8pnIJ17EuB6ycbNFcWEjP9NArgHFLQ7N237mk1KSWXAbF8FiC1NrPwsgZjgk41rTZ8Y/et4ri2T8A9T+0v9A+ip72R2Vn2euAfMJfdy6hUk2LG+PEzk5bw6NCI/hjhtTMwEe14Mzwq31xWvsJ1kQAks4O4y6uz3z0fjX3LZs/L4KNMsNOCYrWPxeVWbbOELRG7kFOalLvO1/OTgO9RAPXrdbf3TP/tOICLEByZNwcj4NU/ogFyUj2bYouF48GS98HoYmlioxSBGpO/mLF0lakypa6r/eaCT3gSd18KZ5GCeRbzZO0kIT1LW658JeRYgeSMqVdOjHd4JZr6Emw5Ul4IsHga61txIYc+LQEtT+Z05Wwg5nBVuZGhE6bwtuyE/JoQ70icOYrd8nwWsy43GdTBNksY85/6tUZrgNZnjf7WCN+iQknArdtMxBIWTAD8XQ96KapZ8ambpfQ2q/1hs5BOYGw6cjThkmbOhRyd4jp1S919deooSII3ZFZQ/fH7mS5iXOquPZh7ru74vB2dg9WgTvADjn4qA67xbkBoVJzb2Vn1ZdhX6oKgb3R2GQ8jmosBhxBinq1rXjKIPhNan7r6BxVrs0c3Mltfv2WkVu8WRZoFcskxw8A/GZYjsTqNS0GNQN3TxY4k0RSZldM
X-MS-Exchange-CrossTenant-Network-Message-Id: f12e933f-4bfb-41f9-43b8-08d8541ee288
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4119.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2020 17:44:50.1796
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Gn07Du4WE1TOczKyEV9jFIvg8d1ztwzo+yUQXMg9Jj+0qHnQKoQ1F/N46ICPRB+d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3571
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-08_09:2020-09-08,2020-09-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1011
 lowpriorityscore=0 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=959
 phishscore=0 bulkscore=0 priorityscore=1501 mlxscore=0 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009080168
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> [Fri, 2020-09-04 16:19 -0700]:
> On Thu, Sep 3, 2020 at 6:29 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Wed, Sep 02, 2020 at 07:31:33PM -0700, Andrii Nakryiko wrote:
> > > On Fri, Aug 28, 2020 at 12:37 PM Stanislav Fomichev <sdf@google.com> wrote:
> > > >
> > > > From: YiFei Zhu <zhuyifei@google.com>
> > > >
> > > > The patch adds a simple wrapper bpf_prog_bind_map around the syscall.
> > > > And when using libbpf to load a program, it will probe the kernel for
> > > > the support of this syscall, and scan for the .metadata ELF section
> > > > and load it as an internal map like a .data section.
> > > >
> > > > In the case that kernel supports the BPF_PROG_BIND_MAP syscall and
> > > > a .metadata section exists, the map will be explicitly bound to
> > > > the program via the syscall immediately after program is loaded.
> > > > -EEXIST is ignored for this syscall.
> > >
> > > Here is the question I have. How important is it that all this
> > > metadata is in a separate map? What if libbpf just PROG_BIND_MAP all
> > > the maps inside a single BPF .o file to all BPF programs in that file?
> > > Including ARRAY maps created for .data, .rodata and .bss, even if the
> > > BPF program doesn't use any of the global variables? If it's too
> > > extreme, we could do it only for global data maps, leaving explicit
> > > map definitions in SEC(".maps") alone. Would that be terrible?
> > > Conceptually it makes sense, because when you program in user-space,
> > > you expect global variables to be there, even if you don't reference
> > > it directly, right? The only downside is that you won't have a special
> > > ".metadata" map, rather it will be part of ".rodata" one.
> >
> > That's an interesting idea.
> > Indeed. If we have BPF_PROG_BIND_MAP command why do we need to create
> > another map that behaves exactly like .rodata but has a different name?
> 
> That was exactly my thought when I re-read this patch set :)
> 
> > Wouldn't it be better to identify metadata elements some other way?
> > Like by common prefix/suffix name of the variables or
> > via grouping them under one structure with standard prefix?
> > Like:
> > struct bpf_prog_metadata_blahblah {
> >   char compiler_name[];
> >   int my_internal_prog_version;
> > } = { .compiler_name[] = "clang v.12", ...};
> >
> > In the past we did this hack for 'version' and for 'license',
> > but we did it because we didn't have BTF and there was no other way
> > to determine the boundaries.
> > I think libbpf can and should support multiple rodata sections with
> 
> Yep, that's coming, we already have a pretty common .rodata.str1.1
> section emitted by Clang for some cases, which libbpf currently
> ignores, but that should change. Creating a separate map for all such
> small sections seems excessive, so my plan is to combine them and
> their BTFs into one, as you assumed below.
> 
> > arbitrary names, but hardcoding one specific ".metadata" name?
> > Hmm. Let's think through the implications.
> > Multiple .o support and static linking is coming soon.
> > When two .o-s with multiple bpf progs are statically linked libbpf
> > won't have any choice but to merge them together under single
> > ".metadata" section and single map that will be BPF_PROG_BIND_MAP-ed
> > to different progs. Meaning that metadata applies to final elf file
> > after linking. It's _not_ per program metadata.
> 
> Right, exactly.
> 
> > May be we should talk about problem statement and goals.
> > Do we actually need metadata per program or metadata per single .o
> > or metadata per final .o with multiple .o linked together?
> > What is this metadata?
> 
> Yep, that's a very valid question. I've also CC'ed Andrey.

From my side the problem statement is to be able to save a bunch of
metadata fields per BPF object file (I don't distinguish "final .o" and
"multiple .o linked together" since we have only the former in prod).

Specifically things like oncall team who owns the programs in the object
(the most important info), build info (repository revision, build commit
time, build time), etc. The plan is to integrate it with build system
and be able to quickly identify source code and point of contact for any
particular program.

All these things are always the same for all programs in one object. It
may change in the future, but at the moment I'm not aware of any
use-case where these things can be different for different programs in
the same object.

I don't have strong preferences on the implementation side as long as it
covers the use-case, e.g. the one in the patch set would work FWIW.

> > If it's just unreferenced by program read only data then no special names or
> > prefixes are needed. We can introduce BPF_PROG_BIND_MAP to bind any map to any
> > program and it would be up to tooling to decide the meaning of the data in the
> > map. For example, bpftool can choose to print all variables from all read only
> > maps that match "bpf_metadata_" prefix, but it will be bpftool convention only
> > and not hard coded in libbpf.
> 
> Agree as well. It feels a bit odd for libbpf to handle ".metadata"
> specially, given libbpf itself doesn't care about its contents at all.
> 
> So thanks for bringing this up, I think this is an important discussion to have.

-- 
Andrey Ignatov
