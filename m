Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AD64681C69
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 22:11:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbjA3VK5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 16:10:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230484AbjA3VKx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 16:10:53 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F313CCC0D
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 13:10:50 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id 78so8600565pgb.8
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 13:10:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hxLXLym7CRtpfooamul8HW90qBM0y4wtjt2sG/xXPXU=;
        b=EPUGEqA5zB9hO/yMHgRahcLCVqyHndzFM483/NA6X+usViItSjPEwGlQkchbM5ygwj
         xOZILWQ9r6be8eRLSIjxcV2gtO8ac2pxjk8Gv9Rp86r3SBHeOXrAOQ4ByaXBCqj/mV/t
         iaL3cJT1tuiM7WIbWTukjaRJsgEW5e1YrSgyEJvSyhk64mLhfatVl9ezMP7VFOwZht6B
         9OCP7BYiZggQHHHh1iJJUS8/obYOhQ3AoP1bydPV3BZhE6Udnf6WqBRblwJh6y77B/ct
         mHuEE6mBEqeol241WlOBUJCzPZ858WMN9LuPVAezYnZ2UaUfOQBou6G4yNNc3OzuiJRG
         gmrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=hxLXLym7CRtpfooamul8HW90qBM0y4wtjt2sG/xXPXU=;
        b=YgrAUXUSneWAXADqg1iaGqZx7t6+XWuqw7Pmn1QfHIYQxks1wZUF1263vL6PBdWedS
         tQE9F1OQ0kdBINt9BJEF/CG8U5RFiCbzwr+cU+bZjLM62WVjFTgpgzykJOWV/AgSaA5w
         DRPL0wJ8IIlAEWTSZzAzH8+iGascFlVARZDjLaU/V4C7cufy44j4g/Sg+IOaiEhpVGk/
         d0hlDJl1+pOHQANfZwzYQyzzm7Nv6uY1XvEI14YOrlA0szp6MnOSZ9EeYM5eDV8nE9Yv
         L5dF3iObY9C2vUXXY2K2U/uAOdp29qpO7r1kwgokosMriZrgoX16pzEjLAYTsgbfsQ8+
         uL/w==
X-Gm-Message-State: AO0yUKXqItN83jOvnBlGw8qkHMae8M9Emwt/0Db3UwxPjB0/Rtqhz7IF
        vvFbWwTmYcXjHBDGsZ/X8s0=
X-Google-Smtp-Source: AK7set9zYB3zKUWlz8Fll2hLRQvQ6VT4sMgIEwxMD97tfYCcveE8zIl6NGwheij1nFqvB0CiuTQ2EA==
X-Received: by 2002:a05:6a00:1342:b0:593:cade:6376 with SMTP id k2-20020a056a00134200b00593cade6376mr4031710pfu.2.1675113050324;
        Mon, 30 Jan 2023 13:10:50 -0800 (PST)
Received: from localhost ([98.97.45.87])
        by smtp.gmail.com with ESMTPSA id k62-20020a628441000000b00581dd94be3asm3676298pfd.61.2023.01.30.13.10.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 13:10:49 -0800 (PST)
Date:   Mon, 30 Jan 2023 13:10:48 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Jamal Hadi Salim <hadi@mojatatu.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
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
Message-ID: <63d8325819298_3985f20824@john.notmuch>
In-Reply-To: <87wn53wz77.fsf@toke.dk>
References: <CAAFAkD8kahd0Ao6BVjwx+F+a0nUK0BzTNFocnpaeQrN7E8VRdQ@mail.gmail.com>
 <Y9RPsYbi2a9Q/H8h@google.com>
 <CAM0EoM=ONYkF_1CST7i_F9yDQRxSFSTO25UzWJzcRGa1efM2Sg@mail.gmail.com>
 <CAKH8qBtU-1A1iKnvTXV=5v8Dim1FBmtvL6wOqgdspSFRCwNohA@mail.gmail.com>
 <CA+FuTScHsm3Ajje=ziRBafXUQ5FHHEAv6R=LRWr1+c3QpCL_9w@mail.gmail.com>
 <CAM0EoMnBXnWDQKu5e0z1_zE3yabb2pTnOdLHRVKsChRm+7wxmQ@mail.gmail.com>
 <CA+FuTScBO-h6iM47-NbYSDDt6LX7pUXD82_KANDcjp7Y=99jzg@mail.gmail.com>
 <63d6069f31bab_2c3eb20844@john.notmuch>
 <CAM0EoMmeYc7KxY=Sv=oynrvYMeb-GD001Zh4m5TMMVXYre=tXw@mail.gmail.com>
 <63d747d91add9_3367c208f1@john.notmuch>
 <Y9eYNsklxkm8CkyP@nanopsycho>
 <87pmawxny5.fsf@toke.dk>
 <CAM0EoM=u-VSDZAifwTiOy8vXAGX7Hwg4rdea62-kNFGsHj7ObQ@mail.gmail.com>
 <878rhkx8bd.fsf@toke.dk>
 <CAAFAkD9Sh5jbp4qkzxuS+J3PGdtN-Kc2HdP8CDqweY36extSdA@mail.gmail.com>
 <87wn53wz77.fsf@toke.dk>
Subject: Re: [PATCH net-next RFC 00/20] Introducing P4TC
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> Jamal Hadi Salim <hadi@mojatatu.com> writes:
> =

> > On Mon, Jan 30, 2023 at 12:04 PM Toke H=C3=B8iland-J=C3=B8rgensen <to=
ke@redhat.com> wrote:
> >>
> >> Jamal Hadi Salim <jhs@mojatatu.com> writes:
> >>
> >> > So i dont have to respond to each email individually, I will respo=
nd
> >> > here in no particular order. First let me provide some context, if=

> >> > that was already clear please skip it. Hopefully providing the con=
text
> >> > will help us to focus otherwise that bikeshed's color and shape wi=
ll
> >> > take forever to settle on.
> >> >
> >> > __Context__
> >> >
> >> > I hope we all agree that when you have 2x100G NIC (and i have seen=

> >> > people asking for 2x800G NICs) no XDP or DPDK is going to save you=
. To
> >> > visualize: one 25G port is 35Mpps unidirectional. So "software sta=
ck"
> >> > is not the answer. You need to offload.
> >>
> >> I'm not disputing the need to offload, and I'm personally delighted =
that
> >> P4 is breaking open the vendor black boxes to provide a standardised=

> >> interface for this.
> >>
> >> However, while it's true that software can't keep up at the high end=
,
> >> not everything runs at the high end, and today's high end is tomorro=
w's
> >> mid end, in which XDP can very much play a role. So being able to mo=
ve
> >> smoothly between the two, and even implement functions that split
> >> processing between them, is an essential feature of a programmable
> >> networking path in Linux. Which is why I'm objecting to implementing=
 the
> >> P4 bits as something that's hanging off the side of the stack in its=
 own
> >> thing and is not integrated with the rest of the stack. You were tou=
ting
> >> this as a feature ("being self-contained"). I consider it a bug.
> >>
> >> > Scriptability is not a new idea in TC (see u32 and pedit and other=
s in
> >> > TC).
> >>
> >> u32 is notoriously hard to use. The others are neat, but obviously
> >> limited to particular use cases.
> >
> > Despite my love for u32, I admit its user interface is cryptic. I jus=
t
> > wanted to point out to existing samples of scriptable and offloadable=

> > TC objects.
> >
> >> Do you actually expect anyone to use P4
> >> by manually entering TC commands to build a pipeline? I really find =
that
> >> hard to believe...
> >
> > You dont have to manually hand code anything - its the compilers job.=

> =

> Right, that was kinda my point: in that case the compiler could just as=

> well generate a (set of) BPF program(s) instead of this TC script thing=
.
> =

> >> > IOW, we are reusing and plugging into a proven and deployed mechan=
ism
> >> > with a built-in policy driven, transparent symbiosis between hardw=
are
> >> > offload and software that has matured over time. You can take a
> >> > pipeline or a table or actions and split them between hardware and=

> >> > software transparently, etc.
> >>
> >> That's a control plane feature though, it's not an argument for addi=
ng
> >> another interpreter to the kernel.
> >
> > I am not sure what you mean by control, but what i described is kerne=
l
> > built in. Of course i could do more complex things from user space (i=
f
> > that is what you mean as control).
> =

> "Control plane" as in SDN parlance. I.e., the bits that keep track of
> configuration of the flow/pipeline/table configuration.
> =

> There's no reason you can't have all that infrastructure and use BPF as=

> the datapath language. I.e., instead of:
> =

> tc p4template create pipeline/aP4proggie numtables 1
> ... + all the other stuff to populate it
> =

> you could just do:
> =

> tc p4 create pipeline/aP4proggie obj_file aP4proggie.bpf.o
> =

> and still have all the management infrastructure without the new
> interpreter and associated complexity in the kernel.
> =

> >> > This hammer already meets our goals.
> >>
> >> That 60k+ line patch submission of yours says otherwise...
> >
> > This is pretty much covered in the cover letter and a few responses i=
n
> > the thread since.
> =

> The only argument for why your current approach makes sense I've seen
> you make is "I don't want to rewrite it in BPF". Which is not a
> technical argument.
> =

> I'm not trying to be disingenuous here, BTW: I really don't see the
> technical argument for why the P4 data plane has to be implemented as
> its own interpreter instead of integrating with what we have already
> (i.e., BPF).
> =

> -Toke
> =


I'll just take this here becaues I think its mostly related.

Still not convinced the P4TC has any value for sw. From the
slide you say vendors prefer you have this picture roughtly.


   [ P4 compiler ] ------ [ P4TC backend ] ----> TC API
        |
        |
   [ P4 Vendor backend ]
        |
        |
        V
   [ Devlink ]


Now just replace P4TC backend with P4C and your only work is to
replace devlink with the current hw specific bits and you have
a sw and hw components. Then you get XDP-BPF pretty easily from
P4XDP backend if you like. The compat piece is handled by compiler
where it should be. My CPU is not a MAT so pretending it is seems
not ideal to me, I don't have a TCAM on my cores.

For runtime get those vendors to write their SDKs over Devlink
and no need for this software thing. The runtime for P4c should
already work over BPF. Giving this picture

   [ P4 compiler ] ------ [ P4C backend ] ----> BPF
        |
        |
   [ P4 Vendor backend ]
        |
        |
        V
   [ Devlink ]

And much less work for us to maintain.

.John
