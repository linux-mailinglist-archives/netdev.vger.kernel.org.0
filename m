Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 896E06810D2
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 15:07:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237099AbjA3OHF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 09:07:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237101AbjA3OHE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 09:07:04 -0500
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B94EB3B3FD
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 06:07:02 -0800 (PST)
Received: by mail-yb1-xb30.google.com with SMTP id 123so14086164ybv.6
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 06:07:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dQhxgyOmlr4Bpy+wwZFnBSoLQuZu5lmdZ9YEteSSrOo=;
        b=NOI7V1V+KKxJD2UusJwA2QoSRfP7/+RQl1kfp5vuFgS2qSa28xKjOU5qqH+290Puoi
         GgRnLG5O+4d4dBCKQNDhq41e/ua1aL+j4PrplEdnuNzfhvkSaarZS4fbGdIZsDQtDeFb
         gxHErsrRm54aCcwzDpyVHjT4uhyN3C41Jo7cd/IhcyU2yy6e28gwUtF9CGKXlLReRpkR
         yVLYQfuPY49uNEgQ423NYC63OeLEZxzdrIxUeDs9VOfvPnVJg0JwXge2ZIzwr3KwG4OL
         LE/2jc+T5b8jHs+m6ZcBkFw3a1BKvAyw3jrfa5HlcZ82FJXGFHKbV4ujiSjrs2yUS4Fj
         oofw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dQhxgyOmlr4Bpy+wwZFnBSoLQuZu5lmdZ9YEteSSrOo=;
        b=nVdJAtsSrqec2jhYoL+lmm4Op21M1kOI/XUfsuwBa1gNa8wPeOlvjZVYa7VU/mVcWJ
         IYsDXHUBfq2OaM0+KPEpQtxauTx6OksiiG8HOimVtYOfl9XQSkzPDGtiQDCSRhpLG4s2
         w1JW0ClaW2F+G7ADZE5zdNIe9OHJFZjzW83zqg+Y5LlK7+sXmsZHS3VhM77LDJw1fXdc
         ya6rSfYEJk2wLogG1CasLhem4oluIPV3uFjXoeaghgEnbMY0QFBeeL/mA6LdsqTOQdGq
         4pnrLFY41AwGO3UizBchrzQy5LBjpsM4DBT7AlTf849gTD8eFhTgUFnOP4K8ff/eqX1I
         Q0BA==
X-Gm-Message-State: AFqh2kq4rfQEcKo4QzAm1VDbgt4o4WFldUW2D2DLaquNPIf7/KmFpD2Q
        +/aQMv/izhbCrCyE2whK+odIaVAV8qJK5kvRl3NJIw==
X-Google-Smtp-Source: AMrXdXtPbQ7PTPGE7bSY6vtQDheLUB3U6S3iN1Ac6qfPVyvflW2wI0mbZZgzgSkTc9mHIF5tVbsTzaaCvEvRVTsT7rM=
X-Received: by 2002:a25:4291:0:b0:803:a6eb:f94b with SMTP id
 p139-20020a254291000000b00803a6ebf94bmr4311024yba.509.1675087621801; Mon, 30
 Jan 2023 06:07:01 -0800 (PST)
MIME-Version: 1.0
References: <CAAFAkD8kahd0Ao6BVjwx+F+a0nUK0BzTNFocnpaeQrN7E8VRdQ@mail.gmail.com>
 <Y9RPsYbi2a9Q/H8h@google.com> <CAM0EoM=ONYkF_1CST7i_F9yDQRxSFSTO25UzWJzcRGa1efM2Sg@mail.gmail.com>
 <CAKH8qBtU-1A1iKnvTXV=5v8Dim1FBmtvL6wOqgdspSFRCwNohA@mail.gmail.com>
 <CA+FuTScHsm3Ajje=ziRBafXUQ5FHHEAv6R=LRWr1+c3QpCL_9w@mail.gmail.com>
 <CAM0EoMnBXnWDQKu5e0z1_zE3yabb2pTnOdLHRVKsChRm+7wxmQ@mail.gmail.com>
 <CA+FuTScBO-h6iM47-NbYSDDt6LX7pUXD82_KANDcjp7Y=99jzg@mail.gmail.com>
 <63d6069f31bab_2c3eb20844@john.notmuch> <CAM0EoMmeYc7KxY=Sv=oynrvYMeb-GD001Zh4m5TMMVXYre=tXw@mail.gmail.com>
 <63d747d91add9_3367c208f1@john.notmuch> <Y9eYNsklxkm8CkyP@nanopsycho> <87pmawxny5.fsf@toke.dk>
In-Reply-To: <87pmawxny5.fsf@toke.dk>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Mon, 30 Jan 2023 09:06:50 -0500
Message-ID: <CAM0EoM=u-VSDZAifwTiOy8vXAGX7Hwg4rdea62-kNFGsHj7ObQ@mail.gmail.com>
Subject: Re: [PATCH net-next RFC 00/20] Introducing P4TC
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        John Fastabend <john.fastabend@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Jamal Hadi Salim <hadi@mojatatu.com>,
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

So i dont have to respond to each email individually, I will respond
here in no particular order. First let me provide some context, if
that was already clear please skip it. Hopefully providing the context
will help us to focus otherwise that bikeshed's color and shape will
take forever to settle on.

__Context__

I hope we all agree that when you have 2x100G NIC (and i have seen
people asking for 2x800G NICs) no XDP or DPDK is going to save you. To
visualize: one 25G port is 35Mpps unidirectional. So "software stack"
is not the answer. You need to offload. I would argue further that in
the near future a lot of the stuff including transport will eventually
have to partially or fully move to hardware (see the HOMA keynote for
a sample space[0]). CPUs are not going to keep up with the massive IO
requirements. I am not talking about offload meaning NIC vendors
providing you Checksum or clever RSS or some basic metadata or
timestamp offload; I think those will continue to be needed - but that
is a different scope altogether. Neither are we trying to address
transport offload in P4TC.

I hope we also agree that the MAT construct is well understood and
that we have good experience in both sw (TC)
and hardware deployments over many years. P4 is a _standardized_
specification for addressing these constructs.
P4 is by no means perfect but it is an established standard. It is
already being used to provide requirements to NIC vendors today
(regardless of the underlying implementation)

So what are we trying to achieve with P4TC? John, I could have done a
better job in describing the goals in the cover letter:
We are going for MAT sw equivalence to what is in hardware. A two-fer
that is already provided by the existing TC infrastructure.
Scriptability is not a new idea in TC (see u32 and pedit and others in
TC). IOW, we are reusing and plugging into a proven and deployed
mechanism with a built-in policy driven, transparent symbiosis between
hardware offload and software that has matured over time. You can take
a pipeline or a table or actions and split them between hardware and
software transparently, etc. This hammer already meets our goals.
It's about using the appropriate tool for the right problem. We are
not going to rewrite that infra in rust or ebpf just because. If the
argument is about performance (see point above on 200G ports): We care
about sw performance but more importantly we care about equivalence. I
will put it this way: if we are confronted with a design choice of
picking whether we forgo equivalence in order to get better sw
performance, we are going to trade off performance. You want wire
speed performance then offload.

__End Context__

So now let me respond to the points raised.

Jiri, i think one of the concerns you have is that there is no way to
generalize the different hardware by using a single abstraction since
all hardware may have different architectures (eg whether using RMT vs
DRMT, a mesh processing xbar, TCAM, SRAM, host DRAM,  etc) which may
necessitate doing things like underlying table reordering, merging,
sorting etc. The consensus is that it is the vendor driver that is
responsible for =E2=80=9Ctransforming=E2=80=9D P4 abstractions into whateve=
r your
hardware does. The standardized abstraction is P4. Each P4 object
(match or action) has an ID and attributes - just like we do today
with flower with exception it is not hard coded in the kernel as we do
today. So if the tc ndo gets a callback to add an entry that will
match header and/or metadata X on table Y and execute action Z, it
should take care of figuring out how that transforms into its
appropriate hardware layout. IOW, your hardware doesnt have to be P4
native it just has to accept the constructs.
To emphasize again that folks are already doing this:  see the MS DASH
project where you have many NIC vendors (if i am not mistaken xilinx,
pensando, intel mev, nvidia bluefield, some startups, etc) -  they all
consume P4 and may implement differently.

The next question is how do you teach the driver what the different P4
object IDs mean and load the P4 objects for the hardware? We need to
have a consensus on that for sure - there are multiple approaches that
we explored: you could go directly from netlink using the templating
DSL; you could go via devlink or you can have a hybrid of the two.
Initially different vendors thought differently but they seem to
settle on devlink. From a TC perspective the ndo callbacks for runtime
dont change.
Toke, I labelled that one option as IMpossible as a parody - it is
what the vendors are saying today and my play on words is "even
impossible says IM possible". The challenge we have is that while some
vendor may have a driver and an approach that works, we need to have a
consensus instead of one vendor dictating the approach we use.

To John, I hope i have addressed some of your commentary above. The
current approach vendors are taking is total bypass of the kernel for
offload (we are getting our asses handed to us). The kernel is used to
configure control then it punts to user space and then you invoke a
vendor proprietary API. And every vendor has their own API. If you are
sourcing the NICs from multiple vendors then this is bad for the
consumer (unless you are a hyperscaler in which case almost all are
writing their own proprietary user space stacks). Are you pitching
that model?
The synced hardware + sw is already provided by TC - why punt to user space=
?

cheers,
jamal

[0] https://netdevconf.info/0x16/session.html?keynote-ousterhout

On Mon, Jan 30, 2023 at 6:27 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Jiri Pirko <jiri@resnulli.us> writes:
>
> >>P4TC as SW/HW running same P4:
> >>
> >>1. This doesn't need to be done in kernel. If one compiler runs
> >>   P4 into XDP or TC-BPF that is good and another compiler runs
> >>   it into hw specific backend. This satisifies having both
> >>   software and hardware implementation.
> >>
> >>Extra commentary: I agree we've been chatting about this for a long
> >>time but until some vendor (Intel?) will OSS and support a linux
> >>driver and hardware with open programmable parser and MAT. I'm not
> >>sure how we get P4 for Linux users. Does it exist and I missed it?
> >
> >
> > John, I think that your summary is quite accurate. Regarding SW
> > implementation, I have to admit I also fail to see motivation to have P=
4
> > specific datapath instead of having XDP/eBPF one, that could run P4
> > compiled program. The only motivation would be that if somehow helps to
> > offload to HW. But can it?
>
> According to the slides from the netdev talk[0], it seems that
> offloading will have to have a component that goes outside of TC anyway
> (see "Model 3: Joint loading" where it says "this is impossible"). So I
> don't really see why having this interpreter in TC help any.
>
> Also, any control plane management feature specific to managing P4 state
> in hardware could just as well manage a BPF-based software path on the
> kernel side instead of the P4 interpreter stuff...
>
> -Toke
>
> [0] https://netdevconf.info/0x16/session.html?Your-Network-Datapath-Will-=
Be-P4-Scripted
>
