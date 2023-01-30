Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E75F6681738
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 18:05:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237451AbjA3RFn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 12:05:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234818AbjA3RFh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 12:05:37 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE3C340BDE
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 09:05:34 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id ml19so10155095ejb.0
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 09:05:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sipanda-io.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QZayIkCR0DtwcIJQBmIcy1zoBULz63PTDmfMeBBKJHE=;
        b=XiBV6iahSxZj8kqxW3W33vgJN3u6ZWBEQriQ3A88QjddNkbzjl8pNP3KfoWEUQh83C
         OOteLOjlL9QAIcGIUL0ncsbuSl+wqj/iV/LY7Q50SxA5NKRZYozmweaeeXOwjk8jvh5y
         3BvucxKEGo03HLHe1Tzr5w8l/dHtAaEMLYqI3Kz4GrDrYwq4xvyskJ7xjrvlNqpIHisD
         ExwnCAJGZu+hZnmy51qB2f+l20Ga85TqX8OWQzta3UT2JymD9Wzqd5AfjlwFUZ8PfAJK
         FRJr7hTyDyq9pcD3P9fiBXD4AZRPnhkBGW9oqyoHqYKvDPT26Ry6pNg6MI8oYhLSE6wX
         0L3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QZayIkCR0DtwcIJQBmIcy1zoBULz63PTDmfMeBBKJHE=;
        b=jdKS6FNUlfN/ekPLcDpDDsk8bdAjsMgmOk2xR60F7wXKMcZFZgSfqLiQeb8mpqS/En
         JCT0k4JzS/glPzFukv8Kb7I0YV/7ta/E/KnGNvFNBoGbOK3fuF0Qgf1aTK8mpZqBkqS3
         V/PkDrPeLGyFAQGTGrl1kMl7NBYksMRgZXIRXqu8UOdXPCtYDeAMZ2p98FF7vWCwP5ds
         gXn9h/6BnCU/QlbH3gT4fwuyHUDN5FslwP+mPCdFlo3glSspEajR2kb0T06QutVd6rXk
         1UQJUukVk4nhtjsYt+2Q4r9HJy/yUnVMMIG5XEFu6IDR1CTFip7y/YOr9sgcJ0dKeKtd
         nTqg==
X-Gm-Message-State: AO0yUKWqx9tDE+AmJ+jgPDzSSyDk1nGVBj5pkJUI6Zz1nswqo8w+Ta3M
        AbHcdyGz9DPUnZLnwzhMEPUTPYNKLzAnSS+VRyhztQ==
X-Google-Smtp-Source: AK7set/ubelZRw6L1T0PXSj9VWXPW61vCLl/5z/kcknJhHLl3sSWBfMIah8JAjMyRmeaGLQbSdzuTWLYGjN3Ko6NIgo=
X-Received: by 2002:a17:906:3b45:b0:887:6c23:1940 with SMTP id
 h5-20020a1709063b4500b008876c231940mr1617967ejf.198.1675098333204; Mon, 30
 Jan 2023 09:05:33 -0800 (PST)
MIME-Version: 1.0
References: <20230124170346.316866-1-jhs@mojatatu.com> <20230126153022.23bea5f2@kernel.org>
 <CAM0EoMnHcR9jFVtLt+L1FPRY5BK7_NgH3gsOZxQrXzEkaR1HYQ@mail.gmail.com>
 <20230127091815.3e066e43@kernel.org> <CAAFAkD80UtwX3PgmYsw3=_wmOEaEZEdui6uHf2FtG1OvDd5s4g@mail.gmail.com>
 <CO1PR11MB49933B0E4FC6752D8C439B3593CD9@CO1PR11MB4993.namprd11.prod.outlook.com>
 <CALx6S36akGgRKohduW-aApgRCbZqjJ5uDzTeGQpD=pPietN2Dg@mail.gmail.com> <CO1PR11MB499319AD6201A961515818E393D39@CO1PR11MB4993.namprd11.prod.outlook.com>
In-Reply-To: <CO1PR11MB499319AD6201A961515818E393D39@CO1PR11MB4993.namprd11.prod.outlook.com>
From:   Tom Herbert <tom@sipanda.io>
Date:   Mon, 30 Jan 2023 09:05:21 -0800
Message-ID: <CAOuuhY929LM0_b29mYfUkvYik8UW+7iAe7MZLKgMvtk6EeaxzQ@mail.gmail.com>
Subject: Re: [PATCH net-next RFC 00/20] Introducing P4TC
To:     "Singhai, Anjali" <anjali.singhai@intel.com>
Cc:     Tom Herbert <tom@herbertland.com>,
        Jamal Hadi Salim <hadi@mojatatu.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel@mojatatu.com" <kernel@mojatatu.com>,
        "Chatterjee, Deb" <deb.chatterjee@intel.com>,
        "Limaye, Namrata" <namrata.limaye@intel.com>,
        "khalidm@nvidia.com" <khalidm@nvidia.com>,
        "pratyush@sipanda.io" <pratyush@sipanda.io>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "vladbu@nvidia.com" <vladbu@nvidia.com>,
        "simon.horman@corigine.com" <simon.horman@corigine.com>,
        "stefanc@marvell.com" <stefanc@marvell.com>,
        "seong.kim@amd.com" <seong.kim@amd.com>,
        "mattyk@nvidia.com" <mattyk@nvidia.com>,
        "Daly, Dan" <dan.daly@intel.com>,
        "Fingerhut, John Andy" <john.andy.fingerhut@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 29, 2023 at 7:09 PM Singhai, Anjali
<anjali.singhai@intel.com> wrote:
>
> I am agreeing with you Tom. P4tc does not restrict the high level languag=
e to be P4, it can be anything as long as it can be compiled to create an I=
R that can be used to teach/program the SW and the HW, which is what the sc=
ript-ability of p4tc provides.
>
> Ultimately the devices are evolving as combination of highly efficient Do=
main specific architecture and the traditional Generic cores, and SW in the=
 kernel has to evolve to program them both in a way that the user can decid=
e whether to run a particular functionality in Domain specific HW or SW tha=
t runs on general purpose cores or in some cases the functionality runs in =
both places and the intelligent (and some-day AI managed Infrastructure con=
troller) entity decides whether the flow should use the HW path or the SW p=
ath. There is no other way forward because a SW dataplane can only provide =
an overflow region for flows and the HW will have to run the most demanding=
 flows, as the Network demand and capacity of the data-center keeps reachin=
g higher and higher levels. From a HW vendor's point of view we have alread=
y  entered the 3rd epoch of computer architecture.
>
> A domain specific architecture still has to be programmable but for a spe=
cific domain, linux kernel which has remained fixed function (and fixed pro=
tocol)

I believe the majority of people on this list would disagree with
that. XDP and eBPF were invented precisely to make the Linux kernel
extensible. As Toke said, any proposed solution for programmable
datapaths cannot ignore XDP/eBPF.

> traditionally needs to evolve to support these domain specific architectu=
re that are protocol and dataplane programmable. I think p4tc definitely is=
 the right way forward.
>
> There were some arguments made earlier about but the big Datacenters are =
programming these domain specific architecture from user space already, no =
doubt but isn't the whole argument for linux kernel is democratizing of the=
 goodness the HW brings to all , the small users and the big ones?
>
> There is also argument that is being made about using ebpf for implementi=
ng the SW path, may be I am missing the part as to how do you offload if no=
t to another general purpose core even if it is not as evolved as the curre=
nt day Xeon's. And we know that even the simplest of the general purpose co=
res ( example RISC-V) right now cannot sustain the rate at which the networ=
k needs to feed the business logic running on the CPUs or GPUs or TPUs in a=
n economically viable solution. All data points to the fact that Network pr=
ocessing running on general purpose cores eats up more than half of the cor=
es and that=E2=80=99s expensive.

You are making the incorrect assumption that we are restricted to
using off the shelf commodity CPUs. With an open ISA like RISC-V we
are free to customize it and build domain specific CPUs following the
same principles of domain specific architectures. I believe it is
quite feasible with current technology to build a fully programmable
and very high performance datapath through CPUs. The solution involves
ripping out things we don't need like FPU and MMU, and putting in
things like optimized instructions for parsing, primitives for
maximizing parallelism, arithmetic instructions to optimize processing
nature of specific nature data, and inline accelerators. Running a
datapath on CPU avoids the rigid structures of hardware pipeline (like
John mention, a match-action pipeline won't work for all problems)

> Because the performance/power unit math when using an IPU/DPU/Smart NIC f=
or network work load is so much better than that of a General purpose core.=
 So I do not see a way forward for epbf to be offloaded on anything but gen=
eral purpose cores

We can already do that. The CLI command examples in the kParser were
generated from a parser written to the PANDA-C. PANDA is a library API
for C and a parser defines a set of data structures and macros. It's
just plain C code and doesn't even use #pragma like CUDA does which is
the analogue programming model for GPUs. PANDA-C code can be compiled
into eBPF, userspace, the kParser CLI, and other targets. Assuming
that the HW offload for P4TC is supported then the same parser would
be running in both eBPF and the P4 hardware, and hence we have
factually offloaded a parser that runs in eBPF to P4 hardware. This is
supported for the parser, but adding the rest of the processing can be
similarly achieved.

> and in the meantime Domain specific programmable ASICs need to be still p=
rogrammed as they are the right solution for the economy of scale.
>
> Having said that we do have to find a good solution for p4 externs in SW =
and may be there is room for some helpers ( may be even ebpf) ( as long as =
you don=E2=80=99t ask me to offload that in HW =F0=9F=98=8A)

Well, at least you're including eBPF somewhere in the mix :-)

Tom

>
> Anjali
>
> -----Original Message-----
> From: Tom Herbert <tom@herbertland.com>
> Sent: Saturday, January 28, 2023 1:18 PM
> To: Singhai, Anjali <anjali.singhai@intel.com>
> Cc: Jamal Hadi Salim <hadi@mojatatu.com>; Jakub Kicinski <kuba@kernel.org=
>; Jamal Hadi Salim <jhs@mojatatu.com>; netdev@vger.kernel.org; kernel@moja=
tatu.com; Chatterjee, Deb <deb.chatterjee@intel.com>; Limaye, Namrata <namr=
ata.limaye@intel.com>; khalidm@nvidia.com; tom@sipanda.io; pratyush@sipanda=
.io; jiri@resnulli.us; xiyou.wangcong@gmail.com; davem@davemloft.net; eduma=
zet@google.com; pabeni@redhat.com; vladbu@nvidia.com; simon.horman@corigine=
.com; stefanc@marvell.com; seong.kim@amd.com; mattyk@nvidia.com; Daly, Dan =
<dan.daly@intel.com>; Fingerhut, John Andy <john.andy.fingerhut@intel.com>
> Subject: Re: [PATCH net-next RFC 00/20] Introducing P4TC
>
> On Fri, Jan 27, 2023 at 5:34 PM Singhai, Anjali <anjali.singhai@intel.com=
> wrote:
> >
> > P4 is definitely the language of choice for defining a Dataplane in HW =
for IPUs/DPUs/FNICs and Switches. As a vendor I can definitely say that the=
 smart devices implement a very programmable ASIC as each customer Dataplan=
e defers quite a bit and P4 is the language of choice for specifying the Da=
taplane definitions. A lot of customer deploy proprietary protocols that ru=
n in HW and there is no good way right now in kernel to support these propr=
ietary protcols. If we enable these protocol in the kernel it takes a huge =
effort and they don=E2=80=99t evolve well.
> > Being able to define in P4 and offload into HW using tc mechanism
> > really helps in supporting the customer's Dataplane and protcols
> > without having to wait months and years to get the kernel updated.
> > Here is a link to our IPU offering that is P4 programmable
>
> Anjali,
>
> P4 may be the language of choice for programming HW datapath, however it'=
s not the language of choice for programming SW datapaths-- that's C over X=
DP/eBPF. And while XDP/eBPF also doesn't depend on kernel updates, it has a=
 major advantage over P4 in that it doesn't require fancy hardware either.
>
> Even at full data center deployment of P4 devices, there will be at least=
 an order of magnitude more deployment of SW programmed datapaths; and unle=
ss someone is using P4 hardware, there's zero value in rewriting programs i=
n P4 instead of C. IMO, we will never see networking developers moving to P=
4 en masse-- P4 will always be a niche market relative to the programmable =
datapath space and the skill sets required to support serious scalable depl=
oyment. That being said, there will be a nontrivial contingent of users who=
 need to run the same programs in both SW and HW environments. Expecting th=
em to maintain two very different code bases to support two disparate model=
s is costly and prohibitive to them. So for their benefit, we need a soluti=
on to reconcile these two models. P4TC is one means to accomplish that.
>
> We want to consider both the permutations: 1) compile C code to run in
> P4 hardware 2) compile P4 to run in SW. If we establish a common IR, then=
 we can generalize the problem: programmer writes their datapath in the lan=
guage of their choosing (P4, C, Python, Rust, etc.), they compile the progr=
am to whatever backend they are using (HW, SW, XDP/eBPF, etc.). The P4TC CL=
I serves as one such IR as there's nothing that prevents someone from compi=
ling a program from another language to the CLI (for instance, we've implem=
ented the compiler to output the parser CLI from PANDA-C). The CLI natively=
 runs in kernel SW, and with the right hooks could be offloaded to HW-- not=
 just P4 hardware but potentially other hardware targets as well.
>
> Tom
>
> >
> > https://www.intel.com/content/www/us/en/products/details/network-io/ip
> > u/e2000-asic.html
> > Here are some other useful links
> > https://ipdk.io/
> >
> > Anjali
> >
> > -----Original Message-----
> > From: Jamal Hadi Salim <hadi@mojatatu.com>
> > Sent: Friday, January 27, 2023 11:43 AM
> > To: Jakub Kicinski <kuba@kernel.org>
> > Cc: Jamal Hadi Salim <jhs@mojatatu.com>; netdev@vger.kernel.org;
> > kernel@mojatatu.com; Chatterjee, Deb <deb.chatterjee@intel.com>;
> > Singhai, Anjali <anjali.singhai@intel.com>; Limaye, Namrata
> > <namrata.limaye@intel.com>; khalidm@nvidia.com; tom@sipanda.io;
> > pratyush@sipanda.io; jiri@resnulli.us; xiyou.wangcong@gmail.com;
> > davem@davemloft.net; edumazet@google.com; pabeni@redhat.com;
> > vladbu@nvidia.com; simon.horman@corigine.com; stefanc@marvell.com;
> > seong.kim@amd.com; mattyk@nvidia.com; Daly, Dan <dan.daly@intel.com>;
> > Fingerhut, John Andy <john.andy.fingerhut@intel.com>
> > Subject: Re: [PATCH net-next RFC 00/20] Introducing P4TC
> >
> > On Fri, Jan 27, 2023 at 12:18 PM Jakub Kicinski <kuba@kernel.org> wrote=
:
> > >
> > > On Fri, 27 Jan 2023 08:33:39 -0500 Jamal Hadi Salim wrote:
> > > > On Thu, Jan 26, 2023 at 6:30 PM Jakub Kicinski <kuba@kernel.org> wr=
ote:
> > > > > On Tue, 24 Jan 2023 12:03:46 -0500 Jamal Hadi Salim wrote:
> >
> > [..]
> > > > Network programmability involving hardware  - where at minimal the
> > > > specification of the datapath is in P4 and often the
> > > > implementation is. For samples of specification using P4 (that are
> > > > public) see for example MS Azure:
> > > > https://github.com/sonic-net/DASH/tree/main/dash-pipeline
> > >
> > > That's an IPU thing?
> > >
> >
> > Yes, DASH is xPU. But the whole Sonic/SAI thing includes switches and P=
4 plays a role there.
> >
> > > > If you are a vendor and want to sell a NIC in that space, the spec
> > > > you get is in P4.
> > >
> > > s/NIC/IPU/ ?
> >
> > I do believe that one can write a P4 program to express things a regula=
r NIC could express that may be harder to expose with current interfaces.
> >
> > > > Your underlying hardware
> > > > doesnt have to be P4 native, but at minimal the abstraction (as we
> > > > are trying to provide with P4TC) has to be able to consume the P4
> > > > specification.
> > >
> > > P4 is certainly an option, especially for specs, but I haven't seen
> > > much adoption myself.
> >
> > The xPU market outside of hyper-scalers is emerging now. Hyperscalers l=
ooking at xPUs are looking at P4 as the datapath language - that sets the t=
rend forward to large enterprises.
> > That's my experience.
> > Some of the vendors on the Cc should be able to point to adoption.
> > Anjali? Matty?
> >
> > > What's the benefit / use case?
> >
> > Of P4 or xPUs?
> > Unified approach to standardize how a datapath is defined is a value fo=
r P4.
> > Providing a singular abstraction via the kernel (as opposed to every ve=
ndor pitching their API) is what the kernel brings.
> >
> > > > For implementations where P4 is in use, there are many - some
> > > > public others not, sample space:
> > > > https://cloud.google.com/blog/products/gcp/google-cloud-using-p4ru
> > > > nt
> > > > ime-to-build-smart-networks
> > >
> > > Hyper-scaler proprietary.
> >
> > The control abstraction (P4 runtime) is certainly not proprietary.
> > The datapath that is targetted by the runtime is.
> > Hopefully we can fix that with P4TC.
> > The majority of the discussions i have with some of the folks who do ke=
rnel bypass have one theme in common:
> > The kernel process is just too long. Trying to add one feature to flowe=
r could take anywhere from 6 months to 3 years to finally show up in some s=
upported distro. With P4TC we are taking the approach of scriptability to a=
llow for speacilized datapaths (which P4 excels in). The google datapath ma=
ybe proprietary while their hardware may even(or not) be using native P4 - =
but the important detail is we have _a way_ to abstract those datapaths.
> >
> > > > There are NICs and switches which are P4 native in the market.
> > >
> > > Link to docs?
> > >
> >
> > Off top of my head Intel Mount Evans, Pensando, Xilinx FPGAs, etc. The =
point is to bring them together under the linux umbrella.
> >
> > > > IOW, there is beacoup $ investment in this space that makes it wort=
h pursuing.
> > >
> > > Pursuing $ is good! But the community IMO should maximize a
> > > different function.
> >
> > While I agree $ is not the primary motivator it is a factor, it is a go=
od indicator. No different than the network stack being tweaked to do certa=
in things that certain hyperscalers need because they invest $.
> > I have no problems with a large harmonious tent.
> >
> > cheers,
> > jamal
> >
> > > > TC is the kernel offload mechanism that has gathered deployment
> > > > experience over many years - hence P4TC.
> > >
> > > I don't wanna argue. I thought it'd be more fair towards you if I
> > > made my lack of conviction known, rather than sit quiet and ignore
> > > it since it's just an RFC.
