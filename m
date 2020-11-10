Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA6482AE449
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 00:44:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732235AbgKJXoH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 18:44:07 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:47512 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731854AbgKJXoH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 18:44:07 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 0AANh9e6007912;
        Tue, 10 Nov 2020 15:43:50 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=gRhcHNjEVGyJnwVtIEe3y6SevMxC5DYyUPyV4A1aIAk=;
 b=j6+2lJ9qSP9h5fL+CfnSwIMKZMQ7tcN9drCJgctgAyQ51vzKq5zlZM1O7PFSToJXdnJE
 VSpMuyQFmVBo7Cc1YhNm2oTpTpmSEzdEr1shduZ8AZ2+tTtNwZpj4hrsivRManhVEAYd
 8oOMD8Ylj5vqHoFezwQfHbQlDpYkg5TEkhM= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 34r4sgr03v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 10 Nov 2020 15:43:50 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 10 Nov 2020 15:43:35 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dW4SM8ZsjNEGTrFw74b+TJniGrOB0pjzl6fVkGKsc52pd+3D6wJkbzkQ795QYmrVB8cZ3abHjz4nhzhvzXlqHMKqCHCs9g5z3dT+durm5cIISMfnBF0OJRfB7P8OXvHM5gxB3Me+04X45qCTtfD+ZQ9UIZc3Lkf4s0pZnBOj9pUCdARtS2RXEeNUQqqmx5blM7124h/H1HytafYErWliTJ78HBWoE15MmZRtCJ4q38LoNm7S/3E5qTC3m6r1U0q9xPBfm9+eky2YJzYZRWSsgIgBc8v8342iaOZm1u8JN+TDZ5GyprUjTYfqpSqcnpLyM4U4NoMratFavhIVvavYYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gRhcHNjEVGyJnwVtIEe3y6SevMxC5DYyUPyV4A1aIAk=;
 b=VUFLJjAZntwHQ+F4TnZel2Vdmb9GAXqnWsui7OQh+d0I5Rzl8RHIlu9a/qm7UfcEA5qMSmdbEw1udCjcop++PT3nB27yntAXvIKGS78RwFRJdWN7RuotGnUz0ck+fbwDPuBRP8Ily6AzuE3mFnTQhbZvefqvnUBq3P9mUytRK2y2A06awsEU/zOFh+jOiOKuZizcUxxDLcaUlrengZm4jBMXsmfptk3gn3jyVnKtG5pByCYgaXV0bhwuZCK3OSO1+wgrETCpVjIFi/JHHdVCJBp29zwv6rTzaKhL+c7AESTGCWiJiPKZQN8kkytiAEiavcvN/Qo9E4pEjImVRnmdsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gRhcHNjEVGyJnwVtIEe3y6SevMxC5DYyUPyV4A1aIAk=;
 b=Abzc8NpaVgtszbApaoT9uxzCoa/nLPGGvfmI2jr+VXHrrOXZA0wI7YiW6Oq7Vmy6Mu8hZ1NEr7bMv5UN/4PsFSteVs9onGyGdosfGYT5RPfMVkxZjXxy5hL/CP4CK/2owcnxWsbnIVtXukd6lENL4Rajvl4API6Lwh5q6LMQjr0=
Authentication-Results: chromium.org; dkim=none (message not signed)
 header.d=none;chromium.org; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by SJ0PR15MB4233.namprd15.prod.outlook.com (2603:10b6:a03:2ec::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.27; Tue, 10 Nov
 2020 23:43:32 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee%4]) with mapi id 15.20.3541.025; Tue, 10 Nov 2020
 23:43:32 +0000
Date:   Tue, 10 Nov 2020 15:43:25 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     KP Singh <kpsingh@chromium.org>
CC:     John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next 2/3] bpf: Allow using bpf_sk_storage in
 FENTRY/FEXIT/RAW_TP
Message-ID: <20201110234325.kk7twlyu5ejvde6e@kafai-mbp.dhcp.thefacebook.com>
References: <20201106220750.3949423-1-kafai@fb.com>
 <20201106220803.3950648-1-kafai@fb.com>
 <CAEf4BzaQMcnALQ3rPErQJxVjL-Mi8zB8aSBkL8bkR8mtivro+g@mail.gmail.com>
 <20201107015225.o7hm7oxpndqueae4@kafai-mbp.dhcp.thefacebook.com>
 <CAEf4BzbRXvWdEXC3GdT4Q_dYe6=VPymyDws5QV8wLkdnSONghQ@mail.gmail.com>
 <5fa9a741dc362_8c0e20827@john-XPS-13-9370.notmuch>
 <CACYkzJ4Jdabs5ot7TnHmeq2x+ULhuPuw8wwbR2gQzi22c3N_7A@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACYkzJ4Jdabs5ot7TnHmeq2x+ULhuPuw8wwbR2gQzi22c3N_7A@mail.gmail.com>
X-Originating-IP: [2620:10d:c090:400::5:b389]
X-ClientProxiedBy: MWHPR14CA0060.namprd14.prod.outlook.com
 (2603:10b6:300:81::22) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:b389) by MWHPR14CA0060.namprd14.prod.outlook.com (2603:10b6:300:81::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Tue, 10 Nov 2020 23:43:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 001f0696-333c-4235-712c-08d885d26f1b
X-MS-TrafficTypeDiagnostic: SJ0PR15MB4233:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR15MB4233259372819C4BE1DAC994D5E90@SJ0PR15MB4233.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NnVRMQuEW7WUOTNCS+CPL8w/SdBp8jIM7mGdWqSKLTIALiP9uVcNqWmhylTEF5Yovz8Fsd5T0kiMav+7/u4b7UPk2leN0CgWVwM4/NN7tc5cuUrFS/sajVpugsjeQlecMQk6R2v7Ag1vwEGTfMdp+8NW7NhnGFD9wpfqTUavA2u6USHFKHpiGR6KwRBQ4ZjeaCjSN+0wYRK7HqQQh9UpYtYIvsK0YidNfwBAsVTRLLGENOhyaExZf4Jlh03Qz0rlVb1ntTSWeAz5rwqILAhCgd+A5uo0h33n4sg0G11vP27F1ABjmRENIzbIDUv/84wFySmBPRvlH7jH/ZYhBjZTQQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(39860400002)(396003)(136003)(346002)(83380400001)(8676002)(55016002)(5660300002)(66946007)(66556008)(4326008)(316002)(66476007)(9686003)(1076003)(6666004)(86362001)(6506007)(53546011)(54906003)(8936002)(6916009)(52116002)(186003)(7696005)(2906002)(16526019)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: onrqXUx8c+9Y0Xr++go2TWsXuZvBvzOxkh0bKwYt5SjYnXv1UxZKa1NDSOgbWwL0r/m8cAANT0I8bAPtJ9KUImr2WdCz3p32NnnBMDiE2Hxh9DKpeD1g1BAaiTNeCmrM/KxAwlyuKqky0VHOPneMDt/13uCkB/VOI9dPzpM6oBTClwgB52lf9y92h9iZhjki90bj95+JsAHkZS1+2/HlyL2qTb/BYul22sEVCTbYD4x1RCAPTAUslJ1PKhr1+nY+bE86/8mzMefTQSRScQhZs+bEHnvECyT55mTdhk10p9O55ffPv0VrK4fwgP9OUSJIPXg/SWoIZhAHSSq30bWTSBvLjk1i1dAapwZH0B8/uHbtfwN5F7fnbo1YIfmwkJ42gn1DF1otOjOwLhn/Tf850AdP2k52QN1XlNHAK1/PUuIcfL3BNvBCGm+bZdgDXQbfT2+eY0zjPrsBrzL05a37sWsmq+oRJGyANlFIC598b5ZrjvNuqzMqw1VrfjTC2I4UYNdNm6nKN2T66UJZ5YopcQW7GGTtGtokQ4yU0c7qWFeUjthg0mWvNUZkv2X1lbs/6u4q90mF5rOLtzfzcHIBdfc+xfpr7H6C8YSA4k7J5EG01UxplxnfRtjlcwgdGH60cGwyqjHsNgF/zUjJ3OKaO+Ko/ra+jl2NibfHadhwyqzyH9B7Go4u6JyQ6NuudBO1EcGWKuwUs4DJPSO32yWtGiVSjcvrVYyE36p2mhkY2xE567jvEVVNdUvBi4DbuvG7bQMuYd3qAl20u+yMTD61HAC6W5XY7+kWa3SVm15GSeoNHS/k299VD9t8Pg0L4I3oNn0t7cBd06F3WYYxQB58bLozQpWaDbT/7NiOx/v4cL9d3j2iW20FV3RWIBM1X+jQGMgi4qJjk3buAvH4pYZiZwvxUjpP6YO6xQsLaDxM0Pk=
X-MS-Exchange-CrossTenant-Network-Message-Id: 001f0696-333c-4235-712c-08d885d26f1b
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2020 23:43:32.8190
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Eb2rFsP0HQZxs2gQd1riTo8ptQYgacZAfE/qoGeIiL6WMGZmAsIhMAzCunQYQ9zZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4233
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-10_09:2020-11-10,2020-11-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 adultscore=0 clxscore=1015 suspectscore=1 bulkscore=0 mlxlogscore=999
 priorityscore=1501 lowpriorityscore=0 mlxscore=0 phishscore=0 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011100156
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 10, 2020 at 11:01:12PM +0100, KP Singh wrote:
> On Mon, Nov 9, 2020 at 9:32 PM John Fastabend <john.fastabend@gmail.com> wrote:
> >
> > Andrii Nakryiko wrote:
> > > On Fri, Nov 6, 2020 at 5:52 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > > >
> > > > On Fri, Nov 06, 2020 at 05:14:14PM -0800, Andrii Nakryiko wrote:
> > > > > On Fri, Nov 6, 2020 at 2:08 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > > > > >
> > > > > > This patch enables the FENTRY/FEXIT/RAW_TP tracing program to use
> > > > > > the bpf_sk_storage_(get|delete) helper, so those tracing programs
> > > > > > can access the sk's bpf_local_storage and the later selftest
> > > > > > will show some examples.
> > > > > >
> > > > > > The bpf_sk_storage is currently used in bpf-tcp-cc, tc,
> > > > > > cg sockops...etc which is running either in softirq or
> > > > > > task context.
> > > > > >
> > > > > > This patch adds bpf_sk_storage_get_tracing_proto and
> > > > > > bpf_sk_storage_delete_tracing_proto.  They will check
> > > > > > in runtime that the helpers can only be called when serving
> > > > > > softirq or running in a task context.  That should enable
> > > > > > most common tracing use cases on sk.
> > > > > >
> > > > > > During the load time, the new tracing_allowed() function
> > > > > > will ensure the tracing prog using the bpf_sk_storage_(get|delete)
> > > > > > helper is not tracing any *sk_storage*() function itself.
> > > > > > The sk is passed as "void *" when calling into bpf_local_storage.
> > > > > >
> > > > > > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > > > > > ---
> > > > > >  include/net/bpf_sk_storage.h |  2 +
> > > > > >  kernel/trace/bpf_trace.c     |  5 +++
> > > > > >  net/core/bpf_sk_storage.c    | 73 ++++++++++++++++++++++++++++++++++++
> > > > > >  3 files changed, 80 insertions(+)
> > > > > >
> > > > >
> > > > > [...]
> > > > >
> > > > > > +       switch (prog->expected_attach_type) {
> > > > > > +       case BPF_TRACE_RAW_TP:
> > > > > > +               /* bpf_sk_storage has no trace point */
> > > > > > +               return true;
> > > > > > +       case BPF_TRACE_FENTRY:
> > > > > > +       case BPF_TRACE_FEXIT:
> > > > > > +               btf_vmlinux = bpf_get_btf_vmlinux();
> > > > > > +               btf_id = prog->aux->attach_btf_id;
> > > > > > +               t = btf_type_by_id(btf_vmlinux, btf_id);
> > > > > > +               tname = btf_name_by_offset(btf_vmlinux, t->name_off);
> > > > > > +               return !strstr(tname, "sk_storage");
> > > > >
> > > > > I'm always feeling uneasy about substring checks... Also, KP just
> > > > > fixed the issue with string-based checks for LSM. Can we use a
> > > > > BTF_ID_SET of blacklisted functions instead?
> > > > KP one is different.  It accidentally whitelist-ed more than it should.
> > > >
> > > > It is a blacklist here.  It is actually cleaner and safer to blacklist
> > > > all functions with "sk_storage" and too pessimistic is fine here.
> > >
> > > Fine for whom? Prefix check would be half-bad, but substring check is
> > > horrible. Suddenly "task_storage" (and anything related) would be also
> > > blacklisted. Let's do a prefix check at least.
> > >
> >
> > Agree, prefix check sounds like a good idea. But, just doing a quick
> > grep seems like it will need at least bpf_sk_storage and sk_storage to
> > catch everything.
> 
> Is there any reason we are not using BTF ID sets and an allow list similar
> to bpf_d_path helper? (apart from the obvious inconvenience of
> needing to update the set in the kernel)
It is a blacklist here, a small recap from commit message.

> During the load time, the new tracing_allowed() function
> will ensure the tracing prog using the bpf_sk_storage_(get|delete)
> helper is not tracing any *sk_storage*() function itself.
> The sk is passed as "void *" when calling into bpf_local_storage.

Both BTF_ID and string-based (either prefix/substr) will work.

The intention is to first disallow a tracing program from tracing
any function in bpf_sk_storage.c and also calling the
bpf_sk_storage_(get|delete) helper at the same time.
This blacklist can be revisited later if there would
be a use case in some of the blacklist-ed
functions (which I doubt).

To use BTF_ID, it needs to consider about if the current (and future)
bpf_sk_storage function can be used in BTF_ID or not:
static, global/external, or inlined.

If BTF_ID is the best way for doing all black/white list, I don't mind
either.  I could force some to inline and we need to remember
to revisit the blacklist when the scope of fentry/fexit tracable
function changed, e.g. when static function becomes traceable
later.  The future changes to bpf_sk_storage.c will need to
adjust this list also.
