Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0DA5681FB0
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 00:32:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbjA3Xcm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 18:32:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbjA3Xcl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 18:32:41 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB9912A161
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 15:32:39 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id r18so8816017pgr.12
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 15:32:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BIXQ9Bydu2pEwZFGmjamnOew1+RTWC3L3mLbRBDA5Fs=;
        b=k2+LTNSxXokr2c7ID7w62RNdgg+Y9rRnBKNFORK4r7jrGbGjPhVktt13+W1J4TMBht
         ENFqZh44enBOOyZiaQ8hbE8oujqbAVVfkG2iU16LZOujNrk+/oHF2vDsJ6dkckEcS5pD
         zMYIwF9WTbMdWtTVs+vg9oaNkjo48iHnGzRMzFcBevccrqJQhwwTu1iQQS2BV+qPbnqI
         HTmjOOHna3RAxgXsSUJSJoRgHEjSxR+eL8jQKjdf9Cu2HhK5P/y2P08THlTxCXomgVo5
         n1b34dMPuOCnq7Gzqp/H8b3T5hzYjMfyQV4QZxWtm0dA2jkShL4rm34IN95sp3qIzvHM
         bzSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=BIXQ9Bydu2pEwZFGmjamnOew1+RTWC3L3mLbRBDA5Fs=;
        b=LZ9huCu5f6MsoRft7XEbwiYq17lU1TYAXUyE5aM5jGC/azYmcc0Ax8m4vswVgcgIch
         RpTtR/wD5wayg75385oofM+jguFqwmf3ctR1M5XpPYFHPRJ+nE6kJILFUTF+jFe6zmsn
         HdiWsZ1tP58nRL4W2kcZtKWu0vM29lKuDWjuejyrlNqlMw2d+20cOoRISWmo39hIZbI9
         dW4xU2/bKxqoXZL9gsQ2wVQJM7tkaxHwLm0ZDEKWUwZxt3gxSA5KUIbQHLrmxK2szcTK
         X/kYj33krNlz4Y/5sTrTnn8Jwr1GfIMAeyvAJlSKRZdT1oj2nPSQSVbj/AGcrsacjpC9
         yOug==
X-Gm-Message-State: AFqh2kpWbvkp0jhzNKFeyUlEkmZxyPSq8FoReZvdofL8vC7zO4pBm6Ag
        8f2ZG/Thf49ftz7ToqADDAM=
X-Google-Smtp-Source: AMrXdXtorEFgdnI5w+QZ41kFtaB1DaWzo0h33Qyo+cr1L7W8LNmKkqkpBDleGjdj3oIhdmzgqDGMgg==
X-Received: by 2002:a05:6a00:70b:b0:582:a212:d92c with SMTP id 11-20020a056a00070b00b00582a212d92cmr50367569pfl.10.1675121559127;
        Mon, 30 Jan 2023 15:32:39 -0800 (PST)
Received: from localhost ([98.97.45.87])
        by smtp.gmail.com with ESMTPSA id 144-20020a621496000000b0058d9428e482sm7965105pfu.85.2023.01.30.15.32.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 15:32:38 -0800 (PST)
Date:   Mon, 30 Jan 2023 15:32:35 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Jamal Hadi Salim <hadi@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
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
Message-ID: <63d853938bb0f_3c63e208c5@john.notmuch>
In-Reply-To: <CAM0EoM=i_pTSRokDqDo_8JWjsDYwwzSgJw6sc+0c=Ss81SyJqg@mail.gmail.com>
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
 <63d8325819298_3985f20824@john.notmuch>
 <87leljwwg7.fsf@toke.dk>
 <CAM0EoM=i_pTSRokDqDo_8JWjsDYwwzSgJw6sc+0c=Ss81SyJqg@mail.gmail.com>
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

Jamal Hadi Salim wrote:
> I think we are going in cycles. John I asked you earlier and i think
> you answered my question: You are actually pitching an out of band
> runtime using some vendor sdk via devlink (why even bother with
> devlink interface, not sure). P4TC is saying the runtime API is via
> the kernel to the drivers.

Not out of band, via devlink and a common API for all vendors to
implement so userspace applications can abstract away vendor
specifics of the runtime API as much as possible. Then runtime
component can implement the Linux API and abstract the hardware
away this way.

runtime API is still via the kernel and the the driver its just going
through devlink because its fundamentally a hardware configuration
and independent of a software datapath.

I think the key here is I see no value in (re)implementing a duplicate
software stack when we already have one and even have a backend for the
one we have. Its more general. And likely more performant.

If you want a software implementation do it in rocker so its clear
its a software implementatoin of a switch.

> =

> Toke, i dont think i have managed to get across that there is an
> "autonomous" control built into the kernel. It is not just things that
> come across netlink. It's about the whole infra. I think without that
> clarity we are going to speak past each other and it's a frustrating
> discussion which could get emotional. You cant just displace, for
> example flower and say "use ebpf because it works on tc", theres a lot
> of tribal knowledge gluing relationship between hardware and software.
> Maybe take a look at this patchset below to see an example which shows
> how part of an action graph will work in hardware and partially in sw
> under certain conditions:
> https://www.spinics.net/lists/netdev/msg877507.html and then we can
> have a better discussion.
> =

> cheers,
> jamal
> =

> =

> On Mon, Jan 30, 2023 at 4:21 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@=
redhat.com> wrote:
> >
> > John Fastabend <john.fastabend@gmail.com> writes:
> >
> > > Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> > >> Jamal Hadi Salim <hadi@mojatatu.com> writes:
> > >>
> > >> > On Mon, Jan 30, 2023 at 12:04 PM Toke H=C3=B8iland-J=C3=B8rgense=
n <toke@redhat.com> wrote:
> > >> >>
> > >> >> Jamal Hadi Salim <jhs@mojatatu.com> writes:
> > >> >>
> > >> >> > So i dont have to respond to each email individually, I will =
respond
> > >> >> > here in no particular order. First let me provide some contex=
t, if
> > >> >> > that was already clear please skip it. Hopefully providing th=
e context
> > >> >> > will help us to focus otherwise that bikeshed's color and sha=
pe will
> > >> >> > take forever to settle on.
> > >> >> >
> > >> >> > __Context__
> > >> >> >
> > >> >> > I hope we all agree that when you have 2x100G NIC (and i have=
 seen
> > >> >> > people asking for 2x800G NICs) no XDP or DPDK is going to sav=
e you. To
> > >> >> > visualize: one 25G port is 35Mpps unidirectional. So "softwar=
e stack"
> > >> >> > is not the answer. You need to offload.
> > >> >>
> > >> >> I'm not disputing the need to offload, and I'm personally delig=
hted that
> > >> >> P4 is breaking open the vendor black boxes to provide a standar=
dised
> > >> >> interface for this.
> > >> >>
> > >> >> However, while it's true that software can't keep up at the hig=
h end,
> > >> >> not everything runs at the high end, and today's high end is to=
morrow's
> > >> >> mid end, in which XDP can very much play a role. So being able =
to move
> > >> >> smoothly between the two, and even implement functions that spl=
it
> > >> >> processing between them, is an essential feature of a programma=
ble
> > >> >> networking path in Linux. Which is why I'm objecting to impleme=
nting the
> > >> >> P4 bits as something that's hanging off the side of the stack i=
n its own
> > >> >> thing and is not integrated with the rest of the stack. You wer=
e touting
> > >> >> this as a feature ("being self-contained"). I consider it a bug=
.
> > >> >>
> > >> >> > Scriptability is not a new idea in TC (see u32 and pedit and =
others in
> > >> >> > TC).
> > >> >>
> > >> >> u32 is notoriously hard to use. The others are neat, but obviou=
sly
> > >> >> limited to particular use cases.
> > >> >
> > >> > Despite my love for u32, I admit its user interface is cryptic. =
I just
> > >> > wanted to point out to existing samples of scriptable and offloa=
dable
> > >> > TC objects.
> > >> >
> > >> >> Do you actually expect anyone to use P4
> > >> >> by manually entering TC commands to build a pipeline? I really =
find that
> > >> >> hard to believe...
> > >> >
> > >> > You dont have to manually hand code anything - its the compilers=
 job.
> > >>
> > >> Right, that was kinda my point: in that case the compiler could ju=
st as
> > >> well generate a (set of) BPF program(s) instead of this TC script =
thing.
> > >>
> > >> >> > IOW, we are reusing and plugging into a proven and deployed m=
echanism
> > >> >> > with a built-in policy driven, transparent symbiosis between =
hardware
> > >> >> > offload and software that has matured over time. You can take=
 a
> > >> >> > pipeline or a table or actions and split them between hardwar=
e and
> > >> >> > software transparently, etc.
> > >> >>
> > >> >> That's a control plane feature though, it's not an argument for=
 adding
> > >> >> another interpreter to the kernel.
> > >> >
> > >> > I am not sure what you mean by control, but what i described is =
kernel
> > >> > built in. Of course i could do more complex things from user spa=
ce (if
> > >> > that is what you mean as control).
> > >>
> > >> "Control plane" as in SDN parlance. I.e., the bits that keep track=
 of
> > >> configuration of the flow/pipeline/table configuration.
> > >>
> > >> There's no reason you can't have all that infrastructure and use B=
PF as
> > >> the datapath language. I.e., instead of:
> > >>
> > >> tc p4template create pipeline/aP4proggie numtables 1
> > >> ... + all the other stuff to populate it
> > >>
> > >> you could just do:
> > >>
> > >> tc p4 create pipeline/aP4proggie obj_file aP4proggie.bpf.o
> > >>
> > >> and still have all the management infrastructure without the new
> > >> interpreter and associated complexity in the kernel.
> > >>
> > >> >> > This hammer already meets our goals.
> > >> >>
> > >> >> That 60k+ line patch submission of yours says otherwise...
> > >> >
> > >> > This is pretty much covered in the cover letter and a few respon=
ses in
> > >> > the thread since.
> > >>
> > >> The only argument for why your current approach makes sense I've s=
een
> > >> you make is "I don't want to rewrite it in BPF". Which is not a
> > >> technical argument.
> > >>
> > >> I'm not trying to be disingenuous here, BTW: I really don't see th=
e
> > >> technical argument for why the P4 data plane has to be implemented=
 as
> > >> its own interpreter instead of integrating with what we have alrea=
dy
> > >> (i.e., BPF).
> > >>
> > >> -Toke
> > >>
> > >
> > > I'll just take this here becaues I think its mostly related.
> > >
> > > Still not convinced the P4TC has any value for sw. From the
> > > slide you say vendors prefer you have this picture roughtly.
> > >
> > >
> > >    [ P4 compiler ] ------ [ P4TC backend ] ----> TC API
> > >         |
> > >         |
> > >    [ P4 Vendor backend ]
> > >         |
> > >         |
> > >         V
> > >    [ Devlink ]
> > >
> > >
> > > Now just replace P4TC backend with P4C and your only work is to
> > > replace devlink with the current hw specific bits and you have
> > > a sw and hw components. Then you get XDP-BPF pretty easily from
> > > P4XDP backend if you like. The compat piece is handled by compiler
> > > where it should be. My CPU is not a MAT so pretending it is seems
> > > not ideal to me, I don't have a TCAM on my cores.
> > >
> > > For runtime get those vendors to write their SDKs over Devlink
> > > and no need for this software thing. The runtime for P4c should
> > > already work over BPF. Giving this picture
> > >
> > >    [ P4 compiler ] ------ [ P4C backend ] ----> BPF
> > >         |
> > >         |
> > >    [ P4 Vendor backend ]
> > >         |
> > >         |
> > >         V
> > >    [ Devlink ]
> > >
> > > And much less work for us to maintain.
> >
> > Yes, this was basically my point as well. Thank you for putting it in=
to
> > ASCII diagrams! :)
> >
> > There's still the control plane bit: some kernel component that
> > configures the pieces (pipelines?) created in the top-right and
> > bottom-left corners of your diagram(s), keeping track of which pipeli=
nes
> > are in HW/SW, maybe updating some match tables dynamically and
> > extracting statistics. I'm totally OK with having that bit be in the
> > kernel, but that can be added on top of your second diagram just as w=
ell
> > as on top of the first one...
> >
> > -Toke
> >


