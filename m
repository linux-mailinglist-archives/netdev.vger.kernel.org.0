Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A774166517
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 18:42:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728429AbgBTRly (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 12:41:54 -0500
Received: from mail-mw2nam10on2109.outbound.protection.outlook.com ([40.107.94.109]:62177
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726959AbgBTRly (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Feb 2020 12:41:54 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TVhsMTHP53kCMzYTuu6juT7KLkm87wqZ8hnUQvDg2xdMNuOpUdG7isDNFmF1/3A5KwsTlRd7+BazSZdhJRm0mam6NxgsClc3qYnvad//LYynJPT33XUSv18vmgD1Ja/0y1VqF1o2+U4kU8JdS0uHdeqVTkQ6bVQpADFhrXrJ0qFcSI3KUC2b7nvp79NANcqmFiA/48YF15EBhMcNBWpAr9+aE8pjjLBpmWoMpE+ovqaF+ksDpAw30vFu+T9nI3K2ZQ4W1uKiWlrQuVWDObjJ8N2ECjJO3vvRZShnMne0Qlo8uXysIOM27vnrbHa77IUwa21O1HvWr642Nt1/v3WZ8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l9aAM5Wjiu948eTSW5mCmAEJGLgZgUNWfuOH3OeHZFA=;
 b=eW8oJ8+q8LbyMaaUzrbEr9STt0jQAiJDPNKXfITEc4w5acW3lew/xjGByLHZkP17QjRoeGkLWHzgpbMFOzCYau94iU4pVx5zuCX9Kg7qO2gvAvfu1B0uNPFHpqFNi8MsPauGkYsx+YHBfBwnqP6KLpflBfzCZi9C8ESAkFfe+/3HoXXxSeaowfNldjtXt7tptK67NByMibXh+O8kCqIUdB7u4N9Jk/CDJqa13heIAKsc8QrzavQX3VOShrTh5Z+jb0iRjlrkr0otwXZrI18nb3clgoNbsQdWMLxTsvkwa5rQJttC8ubkOoIXBoroF1Urqf6snA1vM3IS/AshIrUCxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sony.com; dmarc=pass action=none header.from=sony.com;
 dkim=pass header.d=sony.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Sony.onmicrosoft.com;
 s=selector2-Sony-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l9aAM5Wjiu948eTSW5mCmAEJGLgZgUNWfuOH3OeHZFA=;
 b=vKP8zmdOhPzY6K3UeI54CtFlS1BTeMAIDFc7OXvZv0G1CWbZq20w86mSyaQPWmUcnrSETFEBc2KVBbufD7jfoZnb+Pekfo9KcU+PX+yhyw9RjYpEFvJN4Geni9VxcLaw9ntM1tZSyv7Zx0r5TebyUbX0UZgBlzY4abIl4u11PQM=
Received: from MWHPR13MB0895.namprd13.prod.outlook.com (2603:10b6:300:2::27)
 by MWHPR13MB1871.namprd13.prod.outlook.com (2603:10b6:300:132::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.6; Thu, 20 Feb
 2020 17:41:51 +0000
Received: from MWHPR13MB0895.namprd13.prod.outlook.com
 ([fe80::7544:fc2:b078:5dcd]) by MWHPR13MB0895.namprd13.prod.outlook.com
 ([fe80::7544:fc2:b078:5dcd%3]) with mapi id 15.20.2750.016; Thu, 20 Feb 2020
 17:41:51 +0000
From:   "Bird, Tim" <Tim.Bird@sony.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Jesper Dangaard Brouer <brouer@redhat.com>,
        shuah <shuah@kernel.org>,
        =?iso-8859-1?Q?Daniel_D=EDaz?= <daniel.diaz@linaro.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        BPF-dev-list <bpf@vger.kernel.org>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        =?iso-8859-1?Q?Toke_H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Subject: RE: Kernel 5.5.4 build fail for BPF-selftests with latest LLVM
Thread-Topic: Kernel 5.5.4 build fail for BPF-selftests with latest LLVM
Thread-Index: AQHV54eZmWZeYpO93EedYy5TfrJieagkSRIAgAAEQ8CAAAlOgIAAAVRg
Date:   Thu, 20 Feb 2020 17:41:51 +0000
Message-ID: <MWHPR13MB0895B185BC36759121D6F26AFD130@MWHPR13MB0895.namprd13.prod.outlook.com>
References: <20200219180348.40393e28@carbon>
 <CAEf4Bza9imKymHfv_LpSFE=kNB5=ZapTS3SCdeZsDdtrUrUGcg@mail.gmail.com>
 <20200219192854.6b05b807@carbon>
 <CAEf4BzaRAK6-7aCCVOA6hjTevKuxgvZZnHeVgdj_ZWNn8wibYQ@mail.gmail.com>
 <20200219210609.20a097fb@carbon>
 <CAEUSe79Vn8wr=BOh0RzccYij_snZDY=2XGmHmR494wsQBBoo5Q@mail.gmail.com>
 <20200220002748.kpwvlz5xfmjm5fd5@ast-mbp>
 <4a26e6c6-500e-7b92-1e26-16e1e0233889@kernel.org>
 <20200220173740.7a3f9ad7@carbon>
 <MWHPR13MB0895649219625C5F7380314FFD130@MWHPR13MB0895.namprd13.prod.outlook.com>
 <20200220172612.7aqmiwrnizgsukvm@ast-mbp>
In-Reply-To: <20200220172612.7aqmiwrnizgsukvm@ast-mbp>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Tim.Bird@sony.com; 
x-originating-ip: [160.33.195.21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 250fdeae-19d6-44ff-e55a-08d7b62c2b02
x-ms-traffictypediagnostic: MWHPR13MB1871:
x-microsoft-antispam-prvs: <MWHPR13MB18712F2774B073EA40BD4D1BFD130@MWHPR13MB1871.namprd13.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 031996B7EF
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(396003)(366004)(346002)(376002)(136003)(189003)(199004)(52536014)(66476007)(66556008)(64756008)(66446008)(76116006)(9686003)(8676002)(5660300002)(33656002)(8936002)(7416002)(55016002)(66946007)(81166006)(2906002)(6916009)(81156014)(478600001)(7696005)(4326008)(54906003)(186003)(6506007)(53546011)(316002)(71200400001)(86362001)(66574012)(26005);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR13MB1871;H:MWHPR13MB0895.namprd13.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: sony.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Lwk2a4tVtCT9iGQac40Ekk6QshPCdkVvIPJAgWdy4h9DBoExAXErkKs5cnP2QWO+WDAwIe02eXdrrx/js/TJfZNfsQUcU3GACDje2bn3hok2UskGU4HIbJbYc5bf9wKOjdd6Kzlj0nfvhK8tNDuIPfqj5k6fhywnvBcB+C/KXdWU0NWZBE7Ca5Jfuk+lAokn9PSdhCilw/tmuCDs2egFCmnF28AmTmNlpi3mW0cKeNtTFvGReTGyP2/0ABzMn9FqUHW1M2uoayHWtIsAXtNex/cQjnUVL+ctnM/nBvP3PoYkKOsZ2rV5md1hfpOR6sB8rNre8Ge6ivZtagmhQwpM/RFCtB6QajohPc1gyDfhTprl7YJU9OIS4avyM2PiJFF65H5E4QJyihL1Mz1xNtBjQCVPDNlpP3axRr9quiBljkHcczeL9rUSThlhVQGtb61C
x-ms-exchange-antispam-messagedata: v9j/ZEcDQLdOveLVsf1ZVcFEitswXiCmZq25bJocG0GnYfSH/25BhaBA07KilepTU0rMKOa8CrtQfDpRoy0Au7spn2/7VUJ5st9vouJZVGfWYSXzcJyulKszRpxhfxuBEwcpvjlnFTQuwp4jAJwreg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sony.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 250fdeae-19d6-44ff-e55a-08d7b62c2b02
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Feb 2020 17:41:51.1531
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 66c65d8a-9158-4521-a2d8-664963db48e4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GMveCYqBc2CYF9c7QnaMDYG4YZPqDfmpFqbC/GY8lbUycuGbQU4avzO74Lb5yspdCse9nt4CceGt8tGS9b/ntA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR13MB1871
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
>=20
> On Thu, Feb 20, 2020 at 05:02:25PM +0000, Bird, Tim wrote:
> >
> > > -----Original Message-----
> > > From:  Jesper Dangaard Brouer
> > >
> > > On Wed, 19 Feb 2020 17:47:23 -0700
> > > shuah <shuah@kernel.org> wrote:
> > >
> > > > On 2/19/20 5:27 PM, Alexei Starovoitov wrote:
> > > > > On Wed, Feb 19, 2020 at 03:59:41PM -0600, Daniel D=EDaz wrote:
> > > > >>>
> > > > >>> When I download a specific kernel release, how can I know what =
LLVM
> > > > >>> git-hash or version I need (to use BPF-selftests)?
> > > > >
> > > > > as discussed we're going to add documentation-like file that will
> > > > > list required commits in tools.
> > > > > This will be enforced for future llvm/pahole commits.
> > > > >
> > > > >>> Do you think it is reasonable to require end-users to compile t=
heir own
> > > > >>> bleeding edge version of LLVM, to use BPF-selftests?
> > > > >
> > > > > absolutely.
> >
> > Is it just the BPF-selftests that require the bleeding edge version of =
LLVM,
> > or do BPF features themselves need the latest LLVM.  If the latter, the=
n this
> > is quite worrisome, and I fear the BPF developers are getting ahead of =
themselves.
> > We don't usually have a kernel dependency on the latest compiler versio=
n (some
> > recent security fixes are an anomaly).  In fact deprecating support for=
 older compiler
> > versions has been quite slow and methodical over the years.
> >
> > It's quite dangerous to be baking stuff into the kernel that depends on=
 features
> > from compilers that haven't even made it to release yet.
> >
> > I'm sorry, but I'm coming into the middle of this thread.  Can you plea=
se explain
> > what the features are in the latest LLVM that are required for BPF-self=
tests?
>=20
> Above is correct. bpf kernel features do depend on the latest pahole and =
llvm
> features that did not make it into a release. That was the case for many =
years
> now and still the case. The first commit 8 years ago relied on something =
that
> can generate those instructions. For many years llvm was the only compile=
r that
> could generate them. Right now there is GCC backend as well. New features=
 (like
> new instructions) depend on the compiler.
>=20
> selftests/bpf are not testing kernel's bpf features. They are testing the=
 whole
> bpf ecosystem. They test llvm, pahole, libbpf, bpftool, and kernel togeth=
er.
> Hence it's a requirement to install the latest pahole and llvm.
>=20
> When I'm talking about selftests/bpf I'm talking about all the tests in t=
hat
> directory combined. There are several unit tests scattered across repos. =
The
> unit tests for llvm bpf backend are inside llvm repo.
> selftests/bpf/test_verifier and test_maps are unit tests for the verifier=
 and
> for maps. They are llvm independent. They test a combination of kernel an=
d
> libbpf only. But majority of the selftests/bpf are done via test_progs wh=
ich
> are the whole ecosystem tests.

Alexei,

Thank you very much for this explanation.  It is very helpful.  I apologize=
 for my
ignorance of this, but can I ask a few questions just to check my understan=
ding?
Please forgive me if I use the wrong terminology below.

So - do the BPF developers add new instructions to the virtual machine, tha=
t then
have to be added to both the compiler and the executor (VM implementation)?
It sounds like the compiler support and executor support is done in concert=
, and
that patches are at least accepted upstream (but possibly are not yet avail=
able in
a compiler release) for the compiler side.  What about the Linux kernel sid=
e?  Is the
support for a new instruction only in non-released kernels (say, in the BPF=
 development
tree), or could it potentially be included in a released kernel, before the=
 compiler
with matching support is released?  What would happen if a bug was found, a=
nd
compiler support for the instruction was delayed?  I suppose that this woul=
d only
mean that the executor supported an instruction that never appeared in a co=
mpiled
BPF program? Is that right?

Thanks,
 -- Tim

