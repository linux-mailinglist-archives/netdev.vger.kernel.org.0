Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7315F2AE4A5
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 01:07:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731984AbgKKAHf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 19:07:35 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:37714 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730894AbgKKAHc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 19:07:32 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AB04YkV028716;
        Tue, 10 Nov 2020 16:07:16 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=uRRoCWccS+rVMWrAnO5g6d7Qsawq7lwoyGwa+qjBTlE=;
 b=A6vgMVgthV693eY2xGeJZ3TLf/ufDcr0SbhITKWqSoOBF/1EF09tUh7EyHXeyxWWk7Wp
 V30K8aZFZSywRxFvHE1yLsdr8cDfo3UnISg8G1HjY7OapmCR/WHJwIiQIeiVDIAyJ9at
 3Ls+1f7B8oGf9TV1Kx7Gn5hOMogoDqcu1f0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 34pc9qe2v6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 10 Nov 2020 16:07:16 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 10 Nov 2020 16:07:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bJUoOu8/JdyP3KAlXZvjtSt7RorgqKe2vVVRGPjd07yGQE6Z6wqpuJCQtCc/WwT6/67E9ExmsnChfKI9vap7FeV3yl/Fw6T63aB97fxQcieTLj23109hytoxceZI42t9Vmo7hWWkoiMumMpaIqWOQ70TgaS+tEYMild6MdqBaq4FGt8smvIXD0qZINN9zAoShlEEcGwniPTn3wuDhVClZt63EZV3Z2vKCP01TEDvgD3ViRCjZWdEBFN7aITg/5XykO6+AHO8ig1ESLimP+jSviE1JuTtYZ/eMc93j9eOsBCVUl0pYWQQducCIqHmoIDdOwJaY3slosO3k9Wxdkq+Fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uRRoCWccS+rVMWrAnO5g6d7Qsawq7lwoyGwa+qjBTlE=;
 b=koYZmO0Wf9iP9Vxci3kWLxhau0XxWECoLGpTU+oJwB/NxSpZPEYysDimm+LpYP/9YzYIy397iFyVK2spP63Dpy3dO+Xqv9+cIRfd5HAPp4BEZ8JBWeFUa8X91ymP0t5SHBw7lVKnjHqgynJ9qDiWrEZKF+0+eNo2KgcKQEmTKm4VT1Ibg/JlzMm7a+P8ncMkh/CICxEZktg6a11I8WgS/xTpHq3uHppTgr3+xALVAEP2mS0cN+soEqp2ejtpPxxbhFWhNY/xgmsTAnuvTyUKixKvQ0jJpZZHbLZ+XCEApr2UK6vixVgVw+UT43HXg9n1Fp9NHHB7mxJZo/QZnkTNJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uRRoCWccS+rVMWrAnO5g6d7Qsawq7lwoyGwa+qjBTlE=;
 b=a52wjBFDrN28vwXmcl7lWt4gF3wu7vnekazNu6mLS8aWXDvNPzSE4sycdZKLzQmYvSk3wNYoXXcCntyP1zPVOxIIP2DCXQf4qWtnlPG+ssGsXbxETASHH/EI93JhHEYebjkgQ9EVOiaE9NOay5Bv9DvMUGOw7nZ+znJLhXSOtMA=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2565.namprd15.prod.outlook.com (2603:10b6:a03:14f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.25; Wed, 11 Nov
 2020 00:07:13 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee%4]) with mapi id 15.20.3541.025; Wed, 11 Nov 2020
 00:07:13 +0000
Date:   Tue, 10 Nov 2020 16:07:07 -0800
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
Message-ID: <20201111000651.fmsuax3fuzcn5v6s@kafai-mbp.dhcp.thefacebook.com>
References: <20201106220750.3949423-1-kafai@fb.com>
 <20201106220803.3950648-1-kafai@fb.com>
 <CAEf4BzaQMcnALQ3rPErQJxVjL-Mi8zB8aSBkL8bkR8mtivro+g@mail.gmail.com>
 <20201107015225.o7hm7oxpndqueae4@kafai-mbp.dhcp.thefacebook.com>
 <CAEf4BzbRXvWdEXC3GdT4Q_dYe6=VPymyDws5QV8wLkdnSONghQ@mail.gmail.com>
 <5fa9a741dc362_8c0e20827@john-XPS-13-9370.notmuch>
 <CACYkzJ4Jdabs5ot7TnHmeq2x+ULhuPuw8wwbR2gQzi22c3N_7A@mail.gmail.com>
 <20201110234325.kk7twlyu5ejvde6e@kafai-mbp.dhcp.thefacebook.com>
 <CAEf4BzZs+5xdA0ZEct6cXSgF294RATnn8TmAfaJrBX+kvc6Gxg@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZs+5xdA0ZEct6cXSgF294RATnn8TmAfaJrBX+kvc6Gxg@mail.gmail.com>
X-Originating-IP: [2620:10d:c090:400::5:b389]
X-ClientProxiedBy: MWHPR1601CA0018.namprd16.prod.outlook.com
 (2603:10b6:300:da::28) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:b389) by MWHPR1601CA0018.namprd16.prod.outlook.com (2603:10b6:300:da::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Wed, 11 Nov 2020 00:07:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0799d919-c7f6-4f42-afdf-08d885d5bde9
X-MS-TrafficTypeDiagnostic: BYAPR15MB2565:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB256511D66F059A4E671CDC0FD5E80@BYAPR15MB2565.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b53Q6eFTGuXyjSTZBRGjYROhGAbzTZlkiTVkSeLHIpBkAgav7JORVsNKTyrMpg0azlLoCKEsbKABOUBaXaOf1D8xvDEa8lTit+XWJrV5OtrZVUPVr6+V7AwQXoLyG2E1buA9tVi1re3+olEpIBP4i56hIhhAEzWHAcycIbvcGiWWj1IptcigNjamSM2XQr6v2VRQSeKpdwNL3buJemelVtdnadBES16zpcQMPfg/Io25mNezdDX7txkbK/UGv5EWDn1okeWsGuVB4h67MD7aeN8qemluWExyGJSfUokIaog4ztzd0VAtTMXtAl/c9Y4hzCQxuQGQU8Gdr9TjGi5L0g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(366004)(396003)(39860400002)(136003)(6916009)(8676002)(52116002)(6506007)(53546011)(83380400001)(1076003)(66946007)(7696005)(16526019)(5660300002)(66556008)(316002)(9686003)(54906003)(6666004)(4326008)(86362001)(478600001)(186003)(55016002)(8936002)(66476007)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: U1L82gmyZWhoMQ8SmG3Z3r7blSThepYsdHr6j0XT1ft+1ClJGG6D77TUkVszSqjJebHb7RpIFX1Nlm+Q/pAaWfr5Iy+1ZavcjmN4GAZQrGeaqcwS/aN1UGAGYAedO4+6CsE4+CraRX2XvInV5ilf/16b+3sSAeERpm/9b3QIhWPPeSI1AoT0Yr1vSwThNS0yg1ydsQ0XZl5f7HRVZ2JMmhpvE2Jjr4JuSfWQ6HakPcK2wQuUL7P4hIOZaEtcKJkaZG9nhrnP3KO78UMh2v5Y728MbLN/nDaAtosr5TaEIUj3bEOY+1wyG2zhIsSCBUDS8U+SMVpCC0ggOHN1gm8n7O1Y8K7zSEBZbLbjZ2T7EfvDIK3A7/CVQVmc4JLMZmvtm3S5AAUsA8biQj6AEq4eDrW6X5m26lLXN1d6OL5n6cchZIo3xv8N1QuLS6xeOZKj3VuZHcLHvVGTd2QDnlKn6enTfBhgOkQgQUNIAZUqavU+qrLkOntIHhh7EvRW1HFcDCPwB/yFUTc5r8If85xgLbbFCPVJquADp1s+G24E4hvH+1Caebac6UCpixCLz3WCBFMexHUou40oNlC0J688vHlly7T4ATDcj3Zhmk3hOnOFwsAqm+B0xILSOE8AJc41P2LOzZMRoepzigq9xp941oq/I8uwD8FBq1N91SDY5mpk7kzUC3a3h9/y3Ko854JPz4kNFZX82Swf/nKv7vPzlgadb7lCKKDqpfmCSV4NWIS2AktWJ6S/gtez6iUe2YwiheSTCDgd2SRCwiMPOys9weSRMeILVIc1CCstOlj0ouU38xQ1oXxhWaVNdsUK3Xd1YfS+QA2n3h5J5XoaHZ3NT6idG8uzQ0afFWZXtX/iyEo23YZ6Qc3eJ7rPm1pXHcdOlKRgl/NUlCzCCEY3rJRfyCParLZcYpgHVk4l4sLmN6E=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0799d919-c7f6-4f42-afdf-08d885d5bde9
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2020 00:07:13.4781
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LHGFoPLQRY7P8+nS9wM8Tntnd1VQMIwXcw8FGh0otaNAEskvhDi/XKX0v3EXhV46
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2565
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-10_09:2020-11-10,2020-11-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 adultscore=0 suspectscore=1
 priorityscore=1501 bulkscore=0 impostorscore=0 lowpriorityscore=0
 clxscore=1015 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011100158
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 10, 2020 at 03:53:13PM -0800, Andrii Nakryiko wrote:
> On Tue, Nov 10, 2020 at 3:43 PM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > On Tue, Nov 10, 2020 at 11:01:12PM +0100, KP Singh wrote:
> > > On Mon, Nov 9, 2020 at 9:32 PM John Fastabend <john.fastabend@gmail.com> wrote:
> > > >
> > > > Andrii Nakryiko wrote:
> > > > > On Fri, Nov 6, 2020 at 5:52 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > > > > >
> > > > > > On Fri, Nov 06, 2020 at 05:14:14PM -0800, Andrii Nakryiko wrote:
> > > > > > > On Fri, Nov 6, 2020 at 2:08 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > > > > > > >
> > > > > > > > This patch enables the FENTRY/FEXIT/RAW_TP tracing program to use
> > > > > > > > the bpf_sk_storage_(get|delete) helper, so those tracing programs
> > > > > > > > can access the sk's bpf_local_storage and the later selftest
> > > > > > > > will show some examples.
> > > > > > > >
> > > > > > > > The bpf_sk_storage is currently used in bpf-tcp-cc, tc,
> > > > > > > > cg sockops...etc which is running either in softirq or
> > > > > > > > task context.
> > > > > > > >
> > > > > > > > This patch adds bpf_sk_storage_get_tracing_proto and
> > > > > > > > bpf_sk_storage_delete_tracing_proto.  They will check
> > > > > > > > in runtime that the helpers can only be called when serving
> > > > > > > > softirq or running in a task context.  That should enable
> > > > > > > > most common tracing use cases on sk.
> > > > > > > >
> > > > > > > > During the load time, the new tracing_allowed() function
> > > > > > > > will ensure the tracing prog using the bpf_sk_storage_(get|delete)
> > > > > > > > helper is not tracing any *sk_storage*() function itself.
> > > > > > > > The sk is passed as "void *" when calling into bpf_local_storage.
> > > > > > > >
> > > > > > > > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > > > > > > > ---
> > > > > > > >  include/net/bpf_sk_storage.h |  2 +
> > > > > > > >  kernel/trace/bpf_trace.c     |  5 +++
> > > > > > > >  net/core/bpf_sk_storage.c    | 73 ++++++++++++++++++++++++++++++++++++
> > > > > > > >  3 files changed, 80 insertions(+)
> > > > > > > >
> > > > > > >
> > > > > > > [...]
> > > > > > >
> > > > > > > > +       switch (prog->expected_attach_type) {
> > > > > > > > +       case BPF_TRACE_RAW_TP:
> > > > > > > > +               /* bpf_sk_storage has no trace point */
> > > > > > > > +               return true;
> > > > > > > > +       case BPF_TRACE_FENTRY:
> > > > > > > > +       case BPF_TRACE_FEXIT:
> > > > > > > > +               btf_vmlinux = bpf_get_btf_vmlinux();
> > > > > > > > +               btf_id = prog->aux->attach_btf_id;
> > > > > > > > +               t = btf_type_by_id(btf_vmlinux, btf_id);
> > > > > > > > +               tname = btf_name_by_offset(btf_vmlinux, t->name_off);
> > > > > > > > +               return !strstr(tname, "sk_storage");
> > > > > > >
> > > > > > > I'm always feeling uneasy about substring checks... Also, KP just
> > > > > > > fixed the issue with string-based checks for LSM. Can we use a
> > > > > > > BTF_ID_SET of blacklisted functions instead?
> > > > > > KP one is different.  It accidentally whitelist-ed more than it should.
> > > > > >
> > > > > > It is a blacklist here.  It is actually cleaner and safer to blacklist
> > > > > > all functions with "sk_storage" and too pessimistic is fine here.
> > > > >
> > > > > Fine for whom? Prefix check would be half-bad, but substring check is
> > > > > horrible. Suddenly "task_storage" (and anything related) would be also
> > > > > blacklisted. Let's do a prefix check at least.
> > > > >
> > > >
> > > > Agree, prefix check sounds like a good idea. But, just doing a quick
> > > > grep seems like it will need at least bpf_sk_storage and sk_storage to
> > > > catch everything.
> > >
> > > Is there any reason we are not using BTF ID sets and an allow list similar
> > > to bpf_d_path helper? (apart from the obvious inconvenience of
> > > needing to update the set in the kernel)
> > It is a blacklist here, a small recap from commit message.
> >
> > > During the load time, the new tracing_allowed() function
> > > will ensure the tracing prog using the bpf_sk_storage_(get|delete)
> > > helper is not tracing any *sk_storage*() function itself.
> > > The sk is passed as "void *" when calling into bpf_local_storage.
> >
> > Both BTF_ID and string-based (either prefix/substr) will work.
> >
> > The intention is to first disallow a tracing program from tracing
> > any function in bpf_sk_storage.c and also calling the
> > bpf_sk_storage_(get|delete) helper at the same time.
> > This blacklist can be revisited later if there would
> > be a use case in some of the blacklist-ed
> > functions (which I doubt).
> >
> > To use BTF_ID, it needs to consider about if the current (and future)
> > bpf_sk_storage function can be used in BTF_ID or not:
> > static, global/external, or inlined.
> >
> > If BTF_ID is the best way for doing all black/white list, I don't mind
> > either.  I could force some to inline and we need to remember
> > to revisit the blacklist when the scope of fentry/fexit tracable
> > function changed, e.g. when static function becomes traceable
> 
> You can consider static functions traceable already. Arnaldo landed a
> change a day or so ago in pahole that exposes static functions in BTF
> and makes it possible to fentry/fexit attach them.
Good to know.

Is all static traceable (and can be used in BTF_ID)?
