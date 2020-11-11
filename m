Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11F2D2AE4DD
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 01:21:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732432AbgKKAUx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 19:20:53 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:56600 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732319AbgKKAUq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 19:20:46 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AB0AlJo014993;
        Tue, 10 Nov 2020 16:20:29 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=2jgwh95lCeSievPmlpKQtvhEQKxvaim+KOHkTF1Xopc=;
 b=cxbw6kt07HiNk8tMtJSLFNxk+ti7X9gzudW86yy5WvtpOQUq+D2TmyUCEPCoNTyr3CH3
 sWHlIQFFVsxucvdr2tfq3n8NEmwNrjD113S5I7qnZFNs9kD0CrpZBzD5xWlcrWTfZTdM
 hHY6BkTwDvZwW3SGnGhXtJy38ngH2SM7lWU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 34pcmjdwxd-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 10 Nov 2020 16:20:29 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 10 Nov 2020 16:20:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lYrchV7bD0WBbr+8N+LTvekcDiw+2qSXQ9PfglYNXj3Rrc5wk+myJ8NIoPDPw4p2yIqHT90sDtkMGOsgHf76eqLdTsorR5e3rviHADmE2+lQhArp/o7GrIt+U9eHcPjF1n7dBEIPZUakr0HH+tbRhjuXsLAfvMWMssf/P3VCZBP5fBT+nhpMB3EyOZOi5vJdHa67eJZ7RGVH0TFHl5fo90/OpE+b7BxtN1zdc0VcDyP0yXj9ofcy9uyw4RgHCcVaispJ243RJTCzaGJaJwSrKUtjBmJWIOe05ihKO0PBEpGaVLZgbFV/CtQdpS5S8u5YCppjNo38DCN5t8pyl+Kl3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2jgwh95lCeSievPmlpKQtvhEQKxvaim+KOHkTF1Xopc=;
 b=MCVREpP9vAuUpMjcZmw/0hC6RHm63AStyxJwVVCsguK3eWuC0foXmr/lGa03S+r/+q2toqP1sV9wHjvYDAPdVsSiL8XRNneP8zCQR7+JoRjh9hQjIvQhXFVkvSrcmbBHC2kVHkFoUiClRr6ubdR3JcE8nHfwtg3lbDSKYAru6aHtTh2gQa8g4motEO5Nd/GKq9YIbowh0659lxPZvXllaR6RINyWcMQTsIHtLP3FoBEVMPJa+PLYSQYIOGtnF482unafm0ujagvVsYVUBYFtPdIXzFL01usk8qohvfZwlRl5jam1dEPKQW48NkAfjX+QkHCkF3biUkIrP9LJr/vlRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2jgwh95lCeSievPmlpKQtvhEQKxvaim+KOHkTF1Xopc=;
 b=Zp3S9XieR8ZUgLM1cQHPbZBEWbk5PylDr1nXilOWdl+7AMj/66n+pqniZUpk8kUGD7dcRvMsXP3vJYOgW69mhr//I9I02Mr7GFYk6LXjbwapOMtX8o5ELxWQyta6FUkT1ncjFPqQxxqM7sEoJSN1mLtjatbnKZ+sTiSkTC4ZHg8=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2694.namprd15.prod.outlook.com (2603:10b6:a03:158::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.25; Wed, 11 Nov
 2020 00:20:27 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee%4]) with mapi id 15.20.3541.025; Wed, 11 Nov 2020
 00:20:27 +0000
Date:   Tue, 10 Nov 2020 16:20:20 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     KP Singh <kpsingh@chromium.org>,
        John Fastabend <john.fastabend@gmail.com>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next 2/3] bpf: Allow using bpf_sk_storage in
 FENTRY/FEXIT/RAW_TP
Message-ID: <20201111002020.2o5ir2qt5h5u676y@kafai-mbp.dhcp.thefacebook.com>
References: <20201106220803.3950648-1-kafai@fb.com>
 <CAEf4BzaQMcnALQ3rPErQJxVjL-Mi8zB8aSBkL8bkR8mtivro+g@mail.gmail.com>
 <20201107015225.o7hm7oxpndqueae4@kafai-mbp.dhcp.thefacebook.com>
 <CAEf4BzbRXvWdEXC3GdT4Q_dYe6=VPymyDws5QV8wLkdnSONghQ@mail.gmail.com>
 <5fa9a741dc362_8c0e20827@john-XPS-13-9370.notmuch>
 <CACYkzJ4Jdabs5ot7TnHmeq2x+ULhuPuw8wwbR2gQzi22c3N_7A@mail.gmail.com>
 <20201110234325.kk7twlyu5ejvde6e@kafai-mbp.dhcp.thefacebook.com>
 <CAEf4BzZs+5xdA0ZEct6cXSgF294RATnn8TmAfaJrBX+kvc6Gxg@mail.gmail.com>
 <20201111000651.fmsuax3fuzcn5v6s@kafai-mbp.dhcp.thefacebook.com>
 <CAEf4BzY0nCXaShyxivyvC0zqGo=JSDazAOGoHVUrr4Dv2Lugiw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzY0nCXaShyxivyvC0zqGo=JSDazAOGoHVUrr4Dv2Lugiw@mail.gmail.com>
X-Originating-IP: [2620:10d:c090:400::5:b389]
X-ClientProxiedBy: MWHPR08CA0046.namprd08.prod.outlook.com
 (2603:10b6:300:c0::20) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:b389) by MWHPR08CA0046.namprd08.prod.outlook.com (2603:10b6:300:c0::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Wed, 11 Nov 2020 00:20:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 90f3eb13-921b-4e9f-8797-08d885d7970e
X-MS-TrafficTypeDiagnostic: BYAPR15MB2694:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB269445ADB19AF4F66B510FC0D5E80@BYAPR15MB2694.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lCReePluUImY339IBwUuXuB6wTTXvyhEaYubahEQOv/5RbUFcG11t2qUUG9W3UHIm5JDbBq5B/polF4u1SZypVEODYmk7hsQh3F6WmyKtR0oDyyLWAYFV2On4ajKMibmAji5v33TVTkJpXzQJPjLVj6VCK+N4EFLhdn59CP/S9uRZqcVQ2EPi2qHmlFJYp8xQ62Xo+ffizOpX1/1jHbC5sJ+PmeZxqywasHffwElD7ChqoHxwOXTGQYlEebmOOkHIGjRogcoufFKOF4Nex4FmsWvcpkvo/owlTAwbFhMN5B6kiWQlV9E/1kcXsZO4RHBz3JWtdD0Ckgd9/jPowHKjNJZQ/Y7Etj6ib9j4EUOtM9AIyWMsrqmbYA1qq6V7XqIqOg8hWE4NNS1tkdapx0c+Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(366004)(136003)(39850400004)(376002)(966005)(86362001)(4326008)(316002)(2906002)(53546011)(8936002)(52116002)(7696005)(9686003)(6506007)(55016002)(1076003)(66556008)(6666004)(5660300002)(54906003)(478600001)(66476007)(66946007)(83380400001)(16526019)(186003)(8676002)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: k34Nvp0JvJR4U//MoIijF7cTuzLIr7Hu7MqRVhrhtJJn1TEBLU1xOMNiglm7BTKR4j7faoxw9c6jJPwiVdAb65oWmul455H3ARbFLQ+qmW/jDwOXsEQMSynsNOFcTrHqUrp+94sllOVem+NiyCokMer3CpSSj/Gbbs1thoXb6lx6ByUg69Y51AoG+fQAQ1lNYjjkj8pGrDFY4KHrGp4xYfusltio9wZBC70qpy31hpUV55tMkFohRWiBIqbkDteBCva3ySEBiQmjnOMP0udjLHp41ZnkKIKTzsf+hE4pGe6g+G1VTwaT08t7cED3eOXUFsP7txXLRBthDCiv2G+CE2ZA0BpgHGU4KtHBi+xr5YHrtUIeYRvXmUP8hoIH12G0Ju/ZO+OS10JpseAi9er92DhpRvKXOhOJsbVEVVYUol7j81csYIm8TnhhoHPhsnuiR72llcJiwMvSj3XUlBAw/gSAFtJ7M2pbkAwzQMkYlH+XzTAOAYP4kNidtta7itHxVWiJdx0DZEtT9kynxlDDgmJuIcSauUSN7m3aMfsXgCKRBw4VYk1Jfd39lxBEU5kWYQVxLkyj/u5/V41XD4+R6Yg/b1VzguFCf+VbLUZ8g/Y9uo0lAUXt4Shvpdx8qUOUdDTDbGPFEFpyWmdefpUDw7V4pqUJ/bERz7Ewef1PJ6eqdeEFSYZfdWYcjUybclQlT1RkHvglChL//OjfO9GPFNJgFffeu6WA4BkP3gcd5eDBgbz/QEfg6KF8Zjc6tXXpP1lBUotQO4XQQVabYcjkCrI5SemBAzRd2tqPrZkid/nNw8i5t+5ZzzjDggc3OxADcrgwr2QpcTwIa/ukm0TtqgT7CzOscz08i8IKmBxBrV8pdtxe2ioOGzWhIHTYhpcX1pMoJVQzSpIWuNB4U6aMevBB+goxvsUhaSTqvsViRY8=
X-MS-Exchange-CrossTenant-Network-Message-Id: 90f3eb13-921b-4e9f-8797-08d885d7970e
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2020 00:20:27.2819
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tFQJeXZRCFRTOJ8isocso3cqq2A4c/lpysrJIFCns/JvU2Y1kcnl3qiJ3C9uSKbw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2694
X-OriginatorOrg: fb.com
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-10_09:2020-11-10,2020-11-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 lowpriorityscore=0 adultscore=0 impostorscore=0 spamscore=0
 priorityscore=1501 mlxscore=0 suspectscore=0 clxscore=1015 phishscore=0
 mlxlogscore=999 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011110000
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 10, 2020 at 04:17:06PM -0800, Andrii Nakryiko wrote:
> On Tue, Nov 10, 2020 at 4:07 PM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > On Tue, Nov 10, 2020 at 03:53:13PM -0800, Andrii Nakryiko wrote:
> > > On Tue, Nov 10, 2020 at 3:43 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > > >
> > > > On Tue, Nov 10, 2020 at 11:01:12PM +0100, KP Singh wrote:
> > > > > On Mon, Nov 9, 2020 at 9:32 PM John Fastabend <john.fastabend@gmail.com> wrote:
> > > > > >
> > > > > > Andrii Nakryiko wrote:
> > > > > > > On Fri, Nov 6, 2020 at 5:52 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > > > > > > >
> > > > > > > > On Fri, Nov 06, 2020 at 05:14:14PM -0800, Andrii Nakryiko wrote:
> > > > > > > > > On Fri, Nov 6, 2020 at 2:08 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > > > > > > > > >
> > > > > > > > > > This patch enables the FENTRY/FEXIT/RAW_TP tracing program to use
> > > > > > > > > > the bpf_sk_storage_(get|delete) helper, so those tracing programs
> > > > > > > > > > can access the sk's bpf_local_storage and the later selftest
> > > > > > > > > > will show some examples.
> > > > > > > > > >
> > > > > > > > > > The bpf_sk_storage is currently used in bpf-tcp-cc, tc,
> > > > > > > > > > cg sockops...etc which is running either in softirq or
> > > > > > > > > > task context.
> > > > > > > > > >
> > > > > > > > > > This patch adds bpf_sk_storage_get_tracing_proto and
> > > > > > > > > > bpf_sk_storage_delete_tracing_proto.  They will check
> > > > > > > > > > in runtime that the helpers can only be called when serving
> > > > > > > > > > softirq or running in a task context.  That should enable
> > > > > > > > > > most common tracing use cases on sk.
> > > > > > > > > >
> > > > > > > > > > During the load time, the new tracing_allowed() function
> > > > > > > > > > will ensure the tracing prog using the bpf_sk_storage_(get|delete)
> > > > > > > > > > helper is not tracing any *sk_storage*() function itself.
> > > > > > > > > > The sk is passed as "void *" when calling into bpf_local_storage.
> > > > > > > > > >
> > > > > > > > > > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > > > > > > > > > ---
> > > > > > > > > >  include/net/bpf_sk_storage.h |  2 +
> > > > > > > > > >  kernel/trace/bpf_trace.c     |  5 +++
> > > > > > > > > >  net/core/bpf_sk_storage.c    | 73 ++++++++++++++++++++++++++++++++++++
> > > > > > > > > >  3 files changed, 80 insertions(+)
> > > > > > > > > >
> > > > > > > > >
> > > > > > > > > [...]
> > > > > > > > >
> > > > > > > > > > +       switch (prog->expected_attach_type) {
> > > > > > > > > > +       case BPF_TRACE_RAW_TP:
> > > > > > > > > > +               /* bpf_sk_storage has no trace point */
> > > > > > > > > > +               return true;
> > > > > > > > > > +       case BPF_TRACE_FENTRY:
> > > > > > > > > > +       case BPF_TRACE_FEXIT:
> > > > > > > > > > +               btf_vmlinux = bpf_get_btf_vmlinux();
> > > > > > > > > > +               btf_id = prog->aux->attach_btf_id;
> > > > > > > > > > +               t = btf_type_by_id(btf_vmlinux, btf_id);
> > > > > > > > > > +               tname = btf_name_by_offset(btf_vmlinux, t->name_off);
> > > > > > > > > > +               return !strstr(tname, "sk_storage");
> > > > > > > > >
> > > > > > > > > I'm always feeling uneasy about substring checks... Also, KP just
> > > > > > > > > fixed the issue with string-based checks for LSM. Can we use a
> > > > > > > > > BTF_ID_SET of blacklisted functions instead?
> > > > > > > > KP one is different.  It accidentally whitelist-ed more than it should.
> > > > > > > >
> > > > > > > > It is a blacklist here.  It is actually cleaner and safer to blacklist
> > > > > > > > all functions with "sk_storage" and too pessimistic is fine here.
> > > > > > >
> > > > > > > Fine for whom? Prefix check would be half-bad, but substring check is
> > > > > > > horrible. Suddenly "task_storage" (and anything related) would be also
> > > > > > > blacklisted. Let's do a prefix check at least.
> > > > > > >
> > > > > >
> > > > > > Agree, prefix check sounds like a good idea. But, just doing a quick
> > > > > > grep seems like it will need at least bpf_sk_storage and sk_storage to
> > > > > > catch everything.
> > > > >
> > > > > Is there any reason we are not using BTF ID sets and an allow list similar
> > > > > to bpf_d_path helper? (apart from the obvious inconvenience of
> > > > > needing to update the set in the kernel)
> > > > It is a blacklist here, a small recap from commit message.
> > > >
> > > > > During the load time, the new tracing_allowed() function
> > > > > will ensure the tracing prog using the bpf_sk_storage_(get|delete)
> > > > > helper is not tracing any *sk_storage*() function itself.
> > > > > The sk is passed as "void *" when calling into bpf_local_storage.
> > > >
> > > > Both BTF_ID and string-based (either prefix/substr) will work.
> > > >
> > > > The intention is to first disallow a tracing program from tracing
> > > > any function in bpf_sk_storage.c and also calling the
> > > > bpf_sk_storage_(get|delete) helper at the same time.
> > > > This blacklist can be revisited later if there would
> > > > be a use case in some of the blacklist-ed
> > > > functions (which I doubt).
> > > >
> > > > To use BTF_ID, it needs to consider about if the current (and future)
> > > > bpf_sk_storage function can be used in BTF_ID or not:
> > > > static, global/external, or inlined.
> > > >
> > > > If BTF_ID is the best way for doing all black/white list, I don't mind
> > > > either.  I could force some to inline and we need to remember
> > > > to revisit the blacklist when the scope of fentry/fexit tracable
> > > > function changed, e.g. when static function becomes traceable
> > >
> > > You can consider static functions traceable already. Arnaldo landed a
> > > change a day or so ago in pahole that exposes static functions in BTF
> > > and makes it possible to fentry/fexit attach them.
> > Good to know.
> >
> > Is all static traceable (and can be used in BTF_ID)?
> 
> Only those that end up not inlined, I think. Similarly as with
> kprobes. pahole actually checks mcount section to keep only those that
> are attachable with ftrace. See [0] for patches.
> 
>   [0] https://patchwork.kernel.org/project/netdevbpf/list/?series=379377&state=*
I will go with the prefix then to avoid tagging functions with
inline/noinline.
