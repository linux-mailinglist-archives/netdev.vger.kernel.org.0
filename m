Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89442696EA9
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 21:44:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231680AbjBNUoi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 15:44:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbjBNUog (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 15:44:36 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42197A25B
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 12:44:35 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id j17so6320846ioa.9
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 12:44:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8PWjgKzXjzWTzb0x8CgPKFE6xZ6GQixa4oQjtBlGTh4=;
        b=PqfhzMr/EEzO6V9juyE0GY5Vt5CQDMoCpMvHCYKYNvLPbGazdmTYqFvfvskJMaAI65
         NhNQ3nQeM0aE7IWlRxUFoqfCtVbQLXXimShFZV5he14kli0VLwknGruG61+nd4Hp/jHt
         sp3RSAQSa5JakZ4wL88VpMmdyFY1FULx0e1TDgRV7yTjIvQYtEJAvKGm99dLdNCWVtGu
         33vGsjBkYgquIiqauQZ+q4hdhF54FiqHK6xLqmFmL1LkPeAYPwtBUocnByXjGGB8iOUC
         O+t+K5aUd4TqgXBSJ97v0xm+OG6TXnPNrlIwH2BPRsnwfEECxbCwYXJcTiPv6gv3kN5h
         J7yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8PWjgKzXjzWTzb0x8CgPKFE6xZ6GQixa4oQjtBlGTh4=;
        b=HiyqG4bFkUvnvHw0dHcdAVl6T8D+8TZS4pcTZNLbS7MoNNkpiMo/K2i1Z57q+YEIoW
         DLew+XjhA7ITb68zzplzZE4z/X0YJ+OxaBrR7n3niWBdmz6CMapSp6fMD38DGGVl3UPX
         g+8gN3e9k5Qu5O+2q+mysKrDsUc+WYln5a5/KvLiICrYswqYjJyazZxpP2z24lRhYnnB
         XuS6hntEPOoqAnhh9evxABubwJGRqcHMLDkwt6Ph6s7fgSJftS3JcPrdyyZkUssDnf+a
         EBsRpTAPsK5U/i0Zl+iK4/BRxMjsodortsMLIhh7SMZf3k4p4yVHqYQDwgmjlga9dqec
         1O2g==
X-Gm-Message-State: AO0yUKXli0PafiHGFrBacLTscf7QMINwjwwemUhOfkAQM7zS5k6MsrXc
        HSHRqnr39VqDBrAqz5IJG2x6DYtYTQ9bD2gZtc7IGg==
X-Google-Smtp-Source: AK7set8iCTl20tahWsZ1uTDjXilxxmX7ylQlY1+zVv1WYcDtXt7u9fIYaWkvLbnmSjXEZLbKHiIRpfBaGkq9rjdtrpA=
X-Received: by 2002:a5e:8d09:0:b0:73b:1230:331d with SMTP id
 m9-20020a5e8d09000000b0073b1230331dmr52119ioj.99.1676407474578; Tue, 14 Feb
 2023 12:44:34 -0800 (PST)
MIME-Version: 1.0
References: <CAAFAkD8kahd0Ao6BVjwx+F+a0nUK0BzTNFocnpaeQrN7E8VRdQ@mail.gmail.com>
 <Y9RPsYbi2a9Q/H8h@google.com> <CAM0EoM=ONYkF_1CST7i_F9yDQRxSFSTO25UzWJzcRGa1efM2Sg@mail.gmail.com>
 <CAKH8qBtU-1A1iKnvTXV=5v8Dim1FBmtvL6wOqgdspSFRCwNohA@mail.gmail.com>
 <CA+FuTScHsm3Ajje=ziRBafXUQ5FHHEAv6R=LRWr1+c3QpCL_9w@mail.gmail.com>
 <CAM0EoMnBXnWDQKu5e0z1_zE3yabb2pTnOdLHRVKsChRm+7wxmQ@mail.gmail.com>
 <CA+FuTScBO-h6iM47-NbYSDDt6LX7pUXD82_KANDcjp7Y=99jzg@mail.gmail.com>
 <63d6069f31bab_2c3eb20844@john.notmuch> <CAM0EoMmeYc7KxY=Sv=oynrvYMeb-GD001Zh4m5TMMVXYre=tXw@mail.gmail.com>
 <63d747d91add9_3367c208f1@john.notmuch> <Y9eYNsklxkm8CkyP@nanopsycho>
 <87pmawxny5.fsf@toke.dk> <CAM0EoM=u-VSDZAifwTiOy8vXAGX7Hwg4rdea62-kNFGsHj7ObQ@mail.gmail.com>
 <b7dafeb9-4535-9fa6-fb42-d6538b7ecf10@gmail.com>
In-Reply-To: <b7dafeb9-4535-9fa6-fb42-d6538b7ecf10@gmail.com>
From:   Jamal Hadi Salim <hadi@mojatatu.com>
Date:   Tue, 14 Feb 2023 15:44:23 -0500
Message-ID: <CAAFAkD8Z5ZUQTcwsXPph0ms=mDJj2h2mYtRP4xGAbWvGUnnA2A@mail.gmail.com>
Subject: Re: [PATCH net-next RFC 00/20] Introducing P4TC
To:     Edward Cree <ecree.xilinx@gmail.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Jiri Pirko <jiri@resnulli.us>,
        John Fastabend <john.fastabend@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel@mojatatu.com, deb.chatterjee@intel.com,
        anjali.singhai@intel.com, namrata.limaye@intel.com,
        khalidm@nvidia.com, tom@sipanda.io, pratyush@sipanda.io,
        xiyou.wangcong@gmail.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, vladbu@nvidia.com, simon.horman@corigine.com,
        stefanc@marvell.com, seong.kim@amd.com, mattyk@nvidia.com,
        dan.daly@intel.com, john.andy.fingerhut@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ed,

On Tue, Feb 14, 2023 at 12:07 PM Edward Cree <ecree.xilinx@gmail.com> wrote=
:
>
> On 30/01/2023 14:06, Jamal Hadi Salim wrote:
> > So what are we trying to achieve with P4TC? John, I could have done a
> > better job in describing the goals in the cover letter:
> > We are going for MAT sw equivalence to what is in hardware. A two-fer
> > that is already provided by the existing TC infrastructure.
> ...
> > This hammer already meets our goals.
>
> I'd like to give a perspective from the AMD/Xilinx/Solarflare SmartNIC
>  project.  Though I must stress I'm not speaking for that organisation,
>  and I wasn't the one writing the P4 code; these are just my personal
>  observations based on the view I had from within the project team.
> We used P4 in the SN1022's datapath, but encountered a number of
>  limitations that prevented a wholly P4-based implementation, in spite
>  of the hardware being MAT/CAM flavoured.
>  Overall I would say that P4
>  was not a great fit for the problem space; it was usually possible to
>  get it to do what we wanted but only by bending it in unnatural ways.
>  (The advantage was, of course, the strong toolchain for compiling it
>  into optimised logic on the FPGA; writing the whole thing by hand in
>  RTL would have taken far more effort.)
> Developing a worthwhile P4-based datapath proved to be something of an
>  engineer-time sink; compilation and verification weren't quick, and
>  just because your P4 works in a software model doesn't necessarily
>  mean it will perform well in hardware.
> Thus P4 is, in my personal opinion, a poor choice for end-user/runtime
>  behaviour specification, at least for FPGA-flavoured devices.

I am curios to understand the challenges you came across specific to
P4 in what you describe above.
My gut feeling is, depending on the P4 program, you ran out of
resources. How many LUTs does this device offer? I am going to hazard
a guess that 30-40% of the resources on the FPGA  were just for P4
abstraction in which case writing a complex P4 program just wont fit.
Having said that, tooling is also very important as part of the
developer experience - if it takes forever to compile things then that
developer experience goes down the tubes. Maybe it is a tooling
challenge?
IMO:
it is also about operational experience (i.e the ops not just the
devs) and deployment infra is key. IOW, it's not just about the
datapath but also the full package integration, for example, ease of
control plane integration, field debuggability, operational usability,
etc... If you are doing a one-off you can integrate whatever
infrastructure you want. If you are a cloud vendor you have the skills
in house and it may be worth investing in them. If you are a second
tier operator or large enterprise OTOH it is not part of your business
model to stock up with smart people.

>   It
>  works okay for a multi-month product development project, is just
>  about viable for implementing something like a pipeline plugin, but
>  treating it as a fully flexible software-defined datapath is not
>  something that will fly.
>

I would argue that FPGA projects tend to be one-offs mostly
(multi-month very specialized solutions). If you want a generic,
repeatable solution you will have to pay the cost for abstraction
(both performance and resource consumption). Then you can train people
to be able to operate the repeatable solutions in some manual.

> > I would argue further that in
> > the near future a lot of the stuff including transport will eventually
> > have to partially or fully move to hardware (see the HOMA keynote for
> > a sample space[0]).
>
> I think HOMA is very interesting and I agree hardware doing something
>  like it will eventually be needed.  But as you admit, P4TC doesn't
>  address that =E2=80=94 unsurprising, since the kind of dynamic imperativ=
e
>  behaviour involved is totally outside P4's wheelhouse.  So maybe I'm
>  missing your point here but I don't see why you bring it up.

It was a response to the sentiment that XDP or ebpf is needed to solve
the performance problem. My response was: i can't count on s/w saving
me from 800Gbps ethernet port capacity; i gave that transport offload
example as a statement of the inevitability of even things outside the
classical L2-L4 datapath infrastructure to eventually move to offload.

> Ultimately I think trying to expose the underlying hardware as a P4
>  platform is the wrong abstraction layer to provide to userspace.

If you mean transport layer exposure via P4 then I would agree. But
for L2-L4 the P4 abstraction (TC as well) is match-action pipeline
which works very well today with control plane abstraction from user
space.

> It's trying too hard to avoid protocol ossification, by requiring the
>  entire pipeline to be user-definable at a bit level, but in the real
>  world if someone wants to deploy a new low-level protocol they'll be
>  better off upgrading their kernel and drivers to offload the new
>  protocol-specific *feature* onto protocol-agnostic *hardware* than
>  trying to develop and validate a P4 pipeline.

I agree with your  view on low-level bit confusion in P4 (depending on
how you write your program); however, I dont agree with the
perspective that you can somehow write that code for your new action
or new header processing and then go ahead and upgrade the driver and
maybe install some new firmware is the right solution. If you have the
skills, sure. But if you are second tier consumer, sourcing from
multiple NIC vendors, and want to offload a new
pipeline/protocol-specific feature across those NICs i would argue
that those skills are not within your reach unless you standardize
that interface (which is what P4 and P4TC strive for). I am not saying
the abstraction is free rather that it is worth the return on
investment for this scenario.

> It is only protocol ossification in *hardware* that is a problem for
>  this kind of thing (not to be confused with the ossification problem
>  on a network where you can't use new proto because a middlebox
>  somewhere in the path barfs on it); protocol-specific SW APIs are
>  only a problem if they result in vendors designing ossified hardware
>  (to implement exactly those APIs and nothing else), which hopefully
>  we've all learned not to do by now.

It's more of a challenge on velocity-to-feature and getting the whole
package with the same effort by specification with P4 i.e starting
with the datapath all the way to the control plane. And that instead
of multi-vendor APIs for protocol-specific solutions (vendors are
pitching DPDK APIs mostly)  we are suggesting that unifying API is
P4TC etc for all vendors.

BTW: I am not arguing that on an FPGA you can generate very optimal
RTL code(that is both resource and computation efficient) which is
very specific to the target datapath. I am sure there are use cases
for that. OTOH, there is a very large set of users who would rather go
for the match-action paradigm for generality of abstraction.

BTW, in your response below to Anjali:
Sure, you can start with ebpf  - why not any other language? What is
the connection to RTL? the frontend you said you have used is P4 for
example and you could generate that into RTL.

cheers,
jamal


> On 30/01/2023 03:09, Singhai, Anjali wrote:
> > There is also argument that is being made about using ebpf for
> > implementing the SW path, may be I am missing the part as to how do
> > you offload if not to another general purpose core even if it is not
> > as evolved as the current day Xeon's.
>
> I have to be a little circumspect here as I don't know how much we've
>  made public, but there are good prospects for FPGA offloads of eBPF
>  with high performance.  The instructions can be transformed into a
>  pipeline of logic blocks which look nothing like a Von Neumann
>  architecture, so can get much better perf/area and perf/power than an
>  array of general-purpose cores.
> My personal belief (which I don't, alas, have hard data to back up) is
>  that this approach will also outperform the 'array of specialised
>  packet-processor cores' that many NPU/DPU products are using.
>
> In the situations where you do need a custom datapath (which often
>  involve the kind of dynamic behaviour that's not P4-friendly), eBPF
>  is, I would say, far superior to P4 as an IR.
>
> -ed
