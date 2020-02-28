Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF7D1741DB
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 23:15:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726366AbgB1WPm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 17:15:42 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:33504 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726151AbgB1WPm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 17:15:42 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01SMEg3o030035;
        Fri, 28 Feb 2020 14:15:24 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=facebook;
 bh=YTvR9mdzXT4oHfXcf1sInoFmuI1FIlOOznY7s2j67ys=;
 b=CHKhv16RUfD9yjuApDLLAxpeoq3PpZQFGsfSvmIAy0oV86dyAFsO3x7vWTjhbW/d3SJA
 MZlBYa5L8kXOoC7Ut5pkARZlmKB714hW/U7KgqliNyAuTYNvoCnBQfk9Vzc5nVsm1C/g
 JuUtVvj+f3wLhfjY1btBZg3Hw1dK80BID9E= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2yepvgws9f-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 28 Feb 2020 14:15:23 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Fri, 28 Feb 2020 14:15:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hOA8e6oPChmxAQJqemXCsXzI5nnrSKrVhDOCO8Eqy/aMRjzohjg6qSbUl6sOyBCPhWlPiDXTbZtCIKKQFR8LAZ7GHf1nAArgBjZwRZMlkJjHMX9XLve8u2VkGOI2G5cQEbo3f/nzKPZ9S30JfOBdARGv3BfAcviLEA8RdNekbl4LG2iEcpsNzu0EBRXVCpgJPTWW68bG4cqsySpfgy2sIL2QcTrwcTEtJzI88KJqpke76DJ4kBFp0urJoTdeMsnOfFP0LgDDsM2rHFpUTxnNqjZD8DnuBotj7tb7j+1KxUKiO0aqixM2BENQb/yNikodrpAADoJtqlg2rLWEVwL5xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YTvR9mdzXT4oHfXcf1sInoFmuI1FIlOOznY7s2j67ys=;
 b=TCNQc/hAmr/bpIyPM+xLvWxhTEXU+izHGL3C8weq/a7UoYLq/BlfvpB6aTXqiSbngN3oyhLuP5pHvdJ10EmsiKm7BWu4c3FcvSK7ioonuZflpkgWyrLvjFuXXnXqhgI2mSXkOVsmExQgnWnOE5aWpCnNBHwwgWTCRs1l0wDAJXr3LYP2luCJLTbyceMbQpioNdelEK8/s5W0mq8KKd/u5/qdJJE9zT0kR957zpdQ3NpsAJHb5UTqfZKNBMRNfDFUxEfQXqfz2Tjtq0MyBC+Jhj+ev2DyzH6GKdegLFIGpqp6PkMG7SPnhuEvGRLSNUjjs6dIjhWlxhC6h5Go8wQ9Mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YTvR9mdzXT4oHfXcf1sInoFmuI1FIlOOznY7s2j67ys=;
 b=Nc0eerNZmRySYzoIoy6eJDZGu/j93gbTbEdCMbfulURiePBoXpf3wgtRCD0rZVoBOiUAZSm2BqaUWiBP6qOpSQT6V2BZdxGZ+wo/fu4s2GZEZfDx8hruI2BQ/5+PPy0mKii1hoX12Xe7nB6TTM/21gfDqQGZYOEzG/gM9XPUsqE=
Received: from MWHPR15MB1294.namprd15.prod.outlook.com (2603:10b6:320:25::22)
 by MWHPR15MB1184.namprd15.prod.outlook.com (2603:10b6:320:25::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.15; Fri, 28 Feb
 2020 22:15:21 +0000
Received: from MWHPR15MB1294.namprd15.prod.outlook.com
 ([fe80::b47a:a4d2:b9dd:eb1e]) by MWHPR15MB1294.namprd15.prod.outlook.com
 ([fe80::b47a:a4d2:b9dd:eb1e%5]) with mapi id 15.20.2750.021; Fri, 28 Feb 2020
 22:15:21 +0000
Date:   Fri, 28 Feb 2020 14:15:19 -0800
From:   Andrey Ignatov <rdna@fb.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <ctakshak@fb.com>
Subject: Re: [PATCH RFC] Userspace library for handling multiple XDP programs
 on an interface
Message-ID: <20200228221519.GE51456@rdna-mbp>
References: <158289973977.337029.3637846294079508848.stgit@toke.dk>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <158289973977.337029.3637846294079508848.stgit@toke.dk>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-ClientProxiedBy: MWHPR1601CA0021.namprd16.prod.outlook.com
 (2603:10b6:300:da::31) To MWHPR15MB1294.namprd15.prod.outlook.com
 (2603:10b6:320:25::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2620:10d:c090:500::5:5d39) by MWHPR1601CA0021.namprd16.prod.outlook.com (2603:10b6:300:da::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.15 via Frontend Transport; Fri, 28 Feb 2020 22:15:20 +0000
X-Originating-IP: [2620:10d:c090:500::5:5d39]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8cbfc51b-f8ea-4c4f-58df-08d7bc9bb34a
X-MS-TrafficTypeDiagnostic: MWHPR15MB1184:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR15MB11844EF80D952F791DAA58CDA8E80@MWHPR15MB1184.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0327618309
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(7916004)(346002)(39860400002)(376002)(396003)(366004)(136003)(199004)(189003)(6496006)(54906003)(52116002)(6486002)(16526019)(9686003)(33656002)(4326008)(7416002)(186003)(316002)(6916009)(66556008)(66476007)(478600001)(66574012)(86362001)(8676002)(1076003)(33716001)(5660300002)(66946007)(8936002)(81166006)(81156014)(2906002)(966005);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1184;H:MWHPR15MB1294.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E+Oga6Ja92xSGc+n6doOhUzXXVA6ESu5xrIauIUV3VVmvy4nhsrLDeFasYPlkCCvxIlqoS2ariejA+Z2FoMEhY3/mplqcOjl1YJwN3Sa1WSWF7e2fRv8SYVerKJYpt9NPsdQp/BAZo4qMxhONZMikKOHJVUyRBZe7ZBIt+S0UzslzsdpWSEG76ipmLj1UV/LaVAYib1dv2kThvOBYSj1Wzi8NKOrWHllIKQv7Kf3QbjtZW1CpJn1Uwed7KwIewhei20Pyeyn4VXQPpF7e+OBhGB73i367jeQYj8MRC3Qj/iBJF3TeHfe1YHs480nkTedmUxjN+S7YvUuHOpF50RXu3iltSR0EErU8FRH/TkiVrmwk4CKu7O7EKWskCWPtKDzWGRyI2YLWu2IljZ5i87OKAf1dNfliwbZ1n8d1B6KDLqIoqInsp/xhaQeDPazTqDfSsfVvL96Y5OfXIhFwCrrauFY+HLnNUzSzz5wAD6R+4DM6Foitlo+VTC8ptaGg6hE5ImBojK68omhKCpjahv1mA==
X-MS-Exchange-AntiSpam-MessageData: lGE8+mVYQjTcCtrkp2cpqE3uOn3+VSJNIS0nXU1bkGaNrfDo8M7u5t3W15XPJTmsvfpovPbVQoG11u9vHxhSBsLF+PbsdI9pfs1W/1/EbZvnuSlbBxWxBFzzm7tmQ9NblCCoPPwSG9f9LESxvcvYo3scA0pHgl5JOso56l/vJPdBozKLFy7j2yfYf4coF58q
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cbfc51b-f8ea-4c4f-58df-08d7bc9bb34a
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2020 22:15:21.2720
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E5H5vEYHnNKTC2jz3lzuPBQPhB+l9uL4rFcaN0vDOONkheTr7YifLSqdoZ+w8ZRh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1184
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-28_08:2020-02-28,2020-02-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 spamscore=0 bulkscore=0 phishscore=0 suspectscore=0 mlxscore=0
 lowpriorityscore=0 adultscore=0 clxscore=1011 mlxlogscore=999
 malwarescore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2001150001 definitions=main-2002280159
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Toke Høiland-Jørgensen <toke@redhat.com> [Fri, 2020-02-28 06:22 -0800]:
> Hi everyone
> 
> As most of you are no doubt aware, we've had various discussions on how
> to handle multiple XDP programs on a single interface. With the freplace
> functionality, the kernel infrastructure is now there to handle this
> (almost, see "missing pieces" below).
> 
> While the freplace mechanism offers userspace a lot of flexibility in
> how to handle dispatching of multiple XDP programs, userspace also has
> to do quite a bit of work to implement this (compared to just issuing
> load+attach). The goal of this email is to get some feedback on a
> library to implement this, in the hope that we can converge on something
> that will be widely applicable, ensuring that both (a) everyone doesn't
> have to reinvent the wheel, and (b) we don't end up with a proliferation
> of subtly incompatible dispatcher models that makes it hard or
> impossible to mix and match XDP programs from multiple sources.
> 
> My proposal for the beginnings of such a library is in the xdp-tools repository
> on Github, in the 'xdp-multi-prog' branch.
> 
> To clone and compile simply do this:
> 
> $ git clone --recurse-submodules -b xdp-multi-prog https://github.com/xdp-project/xdp-tools
> $ cd xdp-tools && ./configure && make
> 
> See lib/libxdp/libxdp.c for the library implementation, and xdp-loader/ for a
> command-line loader that supports loading multiple programs in one go using the
> dispatch (just supply it multiple filenames on the command line). There are
> still some missing bits, marked with FIXME comments in the code, and discussed
> below.
> 
> I'm also including libxdp as a patch in the next email, but only to facilitate
> easy commenting on the code; use the version of Github if you actually want to
> compile and play with it.
> 
> The overall goal of the library is to *make the simple case easy* but retain
> enough flexibility for custom applications to specify their own load order etc
> where needed. The "simple case" here being to just load one or more XDP programs
> onto an interface while retaining any programs that may already be loaded there.
> 
> **** Program metadata
> 
> To do this, I propose two pieces of metadata that an XDP program can specify for
> itself, which will serve as defaults to guide the loading:
> 
> - Its *run priority*: This is simply an integer priority number that will be
>   used to sort programs when building the dispatcher. The inspiration is
>   old-style rc init scripts, where daemons are started in numerical order on
>   boot (e.g., /etc/rc.d/S50sshd). My hope here is that we can establish a
>   convention around ranges of priorities that make sense for different types of
>   programs; e.g., packet filters would use low priorities, and programs that
>   want to monitor the traffic on the host will use high priorities, etc.
> 
> - Its *chain call actions*: These are the return codes for which the next
>   program should be called. The idea here is that a program can indicate which
>   actions it makes sense to continue operating on; the default is just XDP_PASS,
>   and I expect this would be the most common case.
> 
> The metadata is specified using BTF, using a syntax similar to BTF-defined maps,
> i.e.:
> 
> struct {
> 	__uint(priority, 10);
> 	__uint(XDP_PASS, 1); // chain call on XDP_PASS...
> 	__uint(XDP_ROP, 1);  // ...and on XDP_DROP
> } XDP_RUN_CONFIG(FUNCNAME);
> 
> (where FUNCNAME is the function name of the XDP program this config refers to).
> 
> Using BTF for this ensures that the metadata stays with the program in the
> object file. And because this becomes part of the object BTF, it will be loaded
> into the kernel and is thus also retrievable for loaded programs.
> 
> The libxdp loaded will use the run priority to sort XDP programs before loading,
> and it will use the chain call actions to configure the dispatcher program. Note
> that the values defined metadata only serve as a default, though; the user
> should be able to override the values on load to sort programs in an arbitrary
> order.
> 
> **** The dispatcher program
> The dispatcher program is a simple XDP program that is generated from a template
> to just implement a series of dispatch statements like these:
> 
>         if (num_progs_enabled < 1)
>                 goto out;
>         ret = prog0(ctx);
>         if (!((1 << ret) & conf.chain_call_actions[0]))
>                 return ret;
> 
>         if (num_progs_enabled < 2)
>                 goto out;
>         ret = prog1(ctx);
>         if (!((1 << ret) & conf.chain_call_actions[1]))
>                 return ret;
> 
>         [...]
> 
> The num_progs_enabled and conf.chain_call_actions variables are static const
> global variables, which means that the compiler will put them into the .rodata
> section, allowing the kernel to perform dead code elimination if the
> num_progs_enabled check fails. libxdp will set the values based on the program
> metadata before loading the dispatcher, the use freplace to put the actual
> component programs into the placeholders specified by prog0, prog1, etc.
> 
> The dispatcher program makes liberal use of variables marked as 'volatile' to
> prevent the compiler from optimising out the checks and calls to the dummy
> functions.
> 
> **** Missing pieces
> While the libxdp code can assemble a basic dispatcher and load it into the
> kernel, there are a couple of missing pieces on the kernel side; I will propose
> patches to fix these, but figured there was no reason to hold back posting of
> the library for comments because of this. These missing pieces are:
> 
> - There is currently no way to persist the freplace after the program exits; the
>   file descriptor returned by bpf_raw_tracepoint_open() will release the program
>   when it is closed, and it cannot be pinned.
> 
> - There is no way to re-attach an already loaded program to another function;
>   this is needed for updating the call sequence: When a new program is loaded,
>   libxdp should get the existing list of component programs on the interface and
>   insert the new one into the chain in the appropriate place. To do this it
>   needs to build a new dispatcher and reattach all the old programs to it.
>   Ideally, this should be doable without detaching them from the old dispatcher;
>   that way, we can build the new dispatcher completely, and atomically replace
>   it on the interface by the usual XDP attach mechanism.

Hey Toke,

Thanks for posting it. I'm still reading the library on github and may
have more thoughts later, but wanted to provide early feedback on one
high level thing.

The main challenges I see for applying this approach in fb case is the
need to recreate the dispatcher every time a new program has to be
added.

Imagine there there are a few containers and every container wants to
run an application that attaches XDP program to the "dispatcher" via
freplace. Every application may have a "priority" reserved for it, but
recreating the dispatcher may have race condition, for example:

- dispatcher exists in some stable stage with programs p1, p2 attached
  to it;

- app A starts and gets the set of progs currently attached to
  dispatcher: p1, p2 (yeah, this kernel API doesn't exist, as you
  mentioned but even if it's added ..);

- app A adds another program pA to the list and generates dispatcher
  with the new set: p1, p2, pA;

- app B starts, gets same list from dispatcher: p1, p2 and adds its own
  pB program and generates new dispatcher.

- now the end result depends on the order in which app A and app B
  attach corresponding new dispatcher to the interface, but in any case
  dispatcher won't have either pA or pB.

Yes, some central coordination mechanism may be added to "lock" the lib
while recreating the dispatcher, but it may not be container-environment
friendly.

Also I see at least one other way to do it w/o regenerating dispatcher
every time:

It can be created and attached once with "big enough" number of slots,
for example with 100 and programs may use use their corresponding slot
to freplace w/o regenerating the dispatcher. Having those big number of
no-op slots should not be a big deal from what I understand and kernel
can optimize it.

Sure, chaining decisions may be different but it may be abstracted to a
separate freplace-able step that may get the action (XDP_PASS,
XDP_DROP, etc) from the XDP program, pass it to the next,
decision-making function that by default proceeds only if previous
program returned XDP_PASS, but user can freplace it with whatever logic
is needed.

And yeah, regenerating the dispatcher would need a new kernel API to be
added to learn what ext-programs are currently attached to the
dispatcher (that I don't know how big the deal is).

This is the main thing so far, I'll likely provide more feedback when
have some more time to read the code ..

> ---
> 
> Toke Høiland-Jørgensen (1):
>       libxdp: Add libxdp (FOR COMMENT ONLY)
> 
> 
>  tools/lib/xdp/libxdp.c          |  856 +++++++++++++++++++++++++++++++++++++++
>  tools/lib/xdp/libxdp.h          |   38 ++
>  tools/lib/xdp/prog_dispatcher.h |   17 +
>  tools/lib/xdp/xdp-dispatcher.c  |  178 ++++++++
>  tools/lib/xdp/xdp_helpers.h     |   12 +
>  5 files changed, 1101 insertions(+)
>  create mode 100644 tools/lib/xdp/libxdp.c
>  create mode 100644 tools/lib/xdp/libxdp.h
>  create mode 100644 tools/lib/xdp/prog_dispatcher.h
>  create mode 100644 tools/lib/xdp/xdp-dispatcher.c
>  create mode 100644 tools/lib/xdp/xdp_helpers.h
> 

-- 
Andrey Ignatov
