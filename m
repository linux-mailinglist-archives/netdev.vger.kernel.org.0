Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D2EA67FB16
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 22:17:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbjA1VRx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 16:17:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231586AbjA1VRv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 16:17:51 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 433B946BA
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 13:17:48 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id q9so5307104pgq.5
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 13:17:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland.com; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=va8nsU20RncsRRPc1XitBKRWj3IRj1VI0jiMESUsLfE=;
        b=CbiajrHUz+of3Cgpt0ZhkQHMo7stkNH6bCBS1Vet1abJmdGnXWkqqDby5WSH+SRrSl
         LAvcXcGpsW2DQMujFZ3KNvFgR4ZYDnlegre0GUKUq1qoPvq1KfjEqddsYUe0UefEvfUl
         yPBytnU6IKM3LAcM4+P2c6qyD8Qi/QcAvkbqNXKgwUF118Z/92dKhW2QU89FAdi9ZxxI
         H7VhTISpWd0HFHT7eJ6PFeEFwx5fo4VExr7xunAmziADXvVKfz4X18hAwFKzyoL5sjX7
         4jpURwZkZAp4YUB0ranCdIbokxc4uHZ7OBS5IlDpY8pswCb1+9bq+4FEvMRxqxx7QVFO
         e7Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=va8nsU20RncsRRPc1XitBKRWj3IRj1VI0jiMESUsLfE=;
        b=oycaGjIxFGAJNxj+qL8JyTZxSxobX1huSmlfE51x/7l9A0VSfd/OM4JaUC7zWIQjN/
         toKrshn+63QZBst6vCvjCBO6lbeZOb2GZNe9a+0WY6RRNaWnYVLW57DeBeOL+jsn4yPR
         2VZzkDZxJLiITvmeFbEy7fxar8Y+CB/vn+fLsTMad99Pl2uymbaqy006jme15n38g6fb
         079pGtirK12jQHbooIg6So5jZ/FynQbiROMmw4zZy0DGoTwEhm8oMud8fWdWSa9D5rHB
         rZpikGJ/IZdl1UAnjJAne7FAoNw8q1LDBCdOcMg8v84GBe9eVQl77ft/IDzQO/XA2vbI
         f00g==
X-Gm-Message-State: AFqh2kqTzcGo9pbNr6FiH0hc5jQp607MmDvMC3LqKmazTNUxKNRSGvW+
        ORBCIUfVTtHe6mMpTkuN803acPRWfPTUiMb1XB33DQ==
X-Google-Smtp-Source: AMrXdXt85gXSP6UZTZtSY0TixVjfV3qOmcEEx1p0niVMrCYKAlJi5IQT9rSoQKiZmdJX/6IC6Jbzojfq6pn3H7RtWDE=
X-Received: by 2002:aa7:9495:0:b0:58d:8da4:3848 with SMTP id
 z21-20020aa79495000000b0058d8da43848mr5654618pfk.44.1674940667667; Sat, 28
 Jan 2023 13:17:47 -0800 (PST)
MIME-Version: 1.0
References: <20230124170346.316866-1-jhs@mojatatu.com> <20230126153022.23bea5f2@kernel.org>
 <CAM0EoMnHcR9jFVtLt+L1FPRY5BK7_NgH3gsOZxQrXzEkaR1HYQ@mail.gmail.com>
 <20230127091815.3e066e43@kernel.org> <CAAFAkD80UtwX3PgmYsw3=_wmOEaEZEdui6uHf2FtG1OvDd5s4g@mail.gmail.com>
 <CO1PR11MB49933B0E4FC6752D8C439B3593CD9@CO1PR11MB4993.namprd11.prod.outlook.com>
In-Reply-To: <CO1PR11MB49933B0E4FC6752D8C439B3593CD9@CO1PR11MB4993.namprd11.prod.outlook.com>
From:   Tom Herbert <tom@herbertland.com>
Date:   Sat, 28 Jan 2023 13:17:35 -0800
Message-ID: <CALx6S36akGgRKohduW-aApgRCbZqjJ5uDzTeGQpD=pPietN2Dg@mail.gmail.com>
Subject: Re: [PATCH net-next RFC 00/20] Introducing P4TC
To:     "Singhai, Anjali" <anjali.singhai@intel.com>
Cc:     Jamal Hadi Salim <hadi@mojatatu.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel@mojatatu.com" <kernel@mojatatu.com>,
        "Chatterjee, Deb" <deb.chatterjee@intel.com>,
        "Limaye, Namrata" <namrata.limaye@intel.com>,
        "khalidm@nvidia.com" <khalidm@nvidia.com>,
        "tom@sipanda.io" <tom@sipanda.io>,
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
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 27, 2023 at 5:34 PM Singhai, Anjali
<anjali.singhai@intel.com> wrote:
>
> P4 is definitely the language of choice for defining a Dataplane in HW fo=
r IPUs/DPUs/FNICs and Switches. As a vendor I can definitely say that the s=
mart devices implement a very programmable ASIC as each customer Dataplane =
defers quite a bit and P4 is the language of choice for specifying the Data=
plane definitions. A lot of customer deploy proprietary protocols that run =
in HW and there is no good way right now in kernel to support these proprie=
tary protcols. If we enable these protocol in the kernel it takes a huge ef=
fort and they don=E2=80=99t evolve well.
> Being able to define in P4 and offload into HW using tc mechanism really =
helps in supporting the customer's Dataplane and protcols without having to=
 wait months and years to get the kernel updated. Here is a link to our IPU=
 offering that is P4 programmable

Anjali,

P4 may be the language of choice for programming HW datapath, however
it's not the language of choice for programming SW datapaths-- that's
C over XDP/eBPF. And while XDP/eBPF also doesn't depend on kernel
updates, it has a major advantage over P4 in that it doesn't require
fancy hardware either.

Even at full data center deployment of P4 devices, there will be at
least an order of magnitude more deployment of SW programmed
datapaths; and unless someone is using P4 hardware, there's zero value
in rewriting programs in P4 instead of C. IMO, we will never see
networking developers moving to P4 en masse-- P4 will always be a
niche market relative to the programmable datapath space and the skill
sets required to support serious scalable deployment. That being said,
there will be a nontrivial contingent of users who need to run the
same programs in both SW and HW environments. Expecting them to
maintain two very different code bases to support two disparate models
is costly and prohibitive to them. So for their benefit, we need a
solution to reconcile these two models. P4TC is one means to
accomplish that.

We want to consider both the permutations: 1) compile C code to run in
P4 hardware 2) compile P4 to run in SW. If we establish a common IR,
then we can generalize the problem: programmer writes their datapath
in the language of their choosing (P4, C, Python, Rust, etc.), they
compile the program to whatever backend they are using (HW, SW,
XDP/eBPF, etc.). The P4TC CLI serves as one such IR as there's nothing
that prevents someone from compiling a program from another language
to the CLI (for instance, we've implemented the compiler to output the
parser CLI from PANDA-C). The CLI natively runs in kernel SW, and with
the right hooks could be offloaded to HW-- not just P4 hardware but
potentially other hardware targets as well.

Tom

>  https://www.intel.com/content/www/us/en/products/details/network-io/ipu/=
e2000-asic.html
> Here are some other useful links
> https://ipdk.io/
>
> Anjali
>
> -----Original Message-----
> From: Jamal Hadi Salim <hadi@mojatatu.com>
> Sent: Friday, January 27, 2023 11:43 AM
> To: Jakub Kicinski <kuba@kernel.org>
> Cc: Jamal Hadi Salim <jhs@mojatatu.com>; netdev@vger.kernel.org; kernel@m=
ojatatu.com; Chatterjee, Deb <deb.chatterjee@intel.com>; Singhai, Anjali <a=
njali.singhai@intel.com>; Limaye, Namrata <namrata.limaye@intel.com>; khali=
dm@nvidia.com; tom@sipanda.io; pratyush@sipanda.io; jiri@resnulli.us; xiyou=
.wangcong@gmail.com; davem@davemloft.net; edumazet@google.com; pabeni@redha=
t.com; vladbu@nvidia.com; simon.horman@corigine.com; stefanc@marvell.com; s=
eong.kim@amd.com; mattyk@nvidia.com; Daly, Dan <dan.daly@intel.com>; Finger=
hut, John Andy <john.andy.fingerhut@intel.com>
> Subject: Re: [PATCH net-next RFC 00/20] Introducing P4TC
>
> On Fri, Jan 27, 2023 at 12:18 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Fri, 27 Jan 2023 08:33:39 -0500 Jamal Hadi Salim wrote:
> > > On Thu, Jan 26, 2023 at 6:30 PM Jakub Kicinski <kuba@kernel.org> wrot=
e:
> > > > On Tue, 24 Jan 2023 12:03:46 -0500 Jamal Hadi Salim wrote:
>
> [..]
> > > Network programmability involving hardware  - where at minimal the
> > > specification of the datapath is in P4 and often the implementation
> > > is. For samples of specification using P4 (that are public) see for
> > > example MS Azure:
> > > https://github.com/sonic-net/DASH/tree/main/dash-pipeline
> >
> > That's an IPU thing?
> >
>
> Yes, DASH is xPU. But the whole Sonic/SAI thing includes switches and P4 =
plays a role there.
>
> > > If you are a vendor and want to sell a NIC in that space, the spec
> > > you get is in P4.
> >
> > s/NIC/IPU/ ?
>
> I do believe that one can write a P4 program to express things a regular =
NIC could express that may be harder to expose with current interfaces.
>
> > > Your underlying hardware
> > > doesnt have to be P4 native, but at minimal the abstraction (as we
> > > are trying to provide with P4TC) has to be able to consume the P4
> > > specification.
> >
> > P4 is certainly an option, especially for specs, but I haven't seen
> > much adoption myself.
>
> The xPU market outside of hyper-scalers is emerging now. Hyperscalers loo=
king at xPUs are looking at P4 as the datapath language - that sets the tre=
nd forward to large enterprises.
> That's my experience.
> Some of the vendors on the Cc should be able to point to adoption.
> Anjali? Matty?
>
> > What's the benefit / use case?
>
> Of P4 or xPUs?
> Unified approach to standardize how a datapath is defined is a value for =
P4.
> Providing a singular abstraction via the kernel (as opposed to every vend=
or pitching their API) is what the kernel brings.
>
> > > For implementations where P4 is in use, there are many - some public
> > > others not, sample space:
> > > https://cloud.google.com/blog/products/gcp/google-cloud-using-p4runt
> > > ime-to-build-smart-networks
> >
> > Hyper-scaler proprietary.
>
> The control abstraction (P4 runtime) is certainly not proprietary.
> The datapath that is targetted by the runtime is.
> Hopefully we can fix that with P4TC.
> The majority of the discussions i have with some of the folks who do kern=
el bypass have one theme in common:
> The kernel process is just too long. Trying to add one feature to flower =
could take anywhere from 6 months to 3 years to finally show up in some sup=
ported distro. With P4TC we are taking the approach of scriptability to all=
ow for speacilized datapaths (which P4 excels in). The google datapath mayb=
e proprietary while their hardware may even(or not) be using native P4 - bu=
t the important detail is we have _a way_ to abstract those datapaths.
>
> > > There are NICs and switches which are P4 native in the market.
> >
> > Link to docs?
> >
>
> Off top of my head Intel Mount Evans, Pensando, Xilinx FPGAs, etc. The po=
int is to bring them together under the linux umbrella.
>
> > > IOW, there is beacoup $ investment in this space that makes it worth =
pursuing.
> >
> > Pursuing $ is good! But the community IMO should maximize a different
> > function.
>
> While I agree $ is not the primary motivator it is a factor, it is a good=
 indicator. No different than the network stack being tweaked to do certain=
 things that certain hyperscalers need because they invest $.
> I have no problems with a large harmonious tent.
>
> cheers,
> jamal
>
> > > TC is the kernel offload mechanism that has gathered deployment
> > > experience over many years - hence P4TC.
> >
> > I don't wanna argue. I thought it'd be more fair towards you if I made
> > my lack of conviction known, rather than sit quiet and ignore it since
> > it's just an RFC.
