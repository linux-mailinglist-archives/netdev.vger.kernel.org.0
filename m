Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91671681E73
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 23:54:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbjA3WyF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 17:54:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjA3WyE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 17:54:04 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1224014498
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 14:54:03 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id m199so16026058ybm.4
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 14:54:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0PdEj7bi0HAzlyaLUjbEd8sh+shr92a+FwoUTmwfmuQ=;
        b=nU8WAUDT2VlUVcrkObKIXivUbIwN3fOGd8Zj9V9Z/qGwa38cWdBpX3ZxjkPJxHJMdu
         WBFPbKPKFV0uuaa4aSjM2KZfDJ2b7dQZuKVo/v+fJwUgXH1MA38wrgLFdaRVPLEi6gQL
         G59OpipQ2dmJSNUxd9QJw2r9rFw7mSwM8mkaTiPHowcrLoxKlWDE1c/aDHrASw7/CH9B
         bs4ZPBzMNLedDf/ipTqqlKAkErxl09HOBWtZnArJOjZPdQuAyGm6Z6LOgBNTeClwyCmg
         F9tTznSyCl40+zKYVhHXlpTG5+0EhWJLX7FxeApeOIKxuYZMO3L469v8lX+CWHkUCIpw
         ghYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0PdEj7bi0HAzlyaLUjbEd8sh+shr92a+FwoUTmwfmuQ=;
        b=kATMLFLmAlrzkaaEYEKuPpmGDNVpCS2Sra/KU5w/pk4b6+k1vZfX5edEFfTJaGYQTN
         gYxL89cW4r7T1UrL9KfQ7aLVuU+LcDmbOg1NwUxx9I6iFNuWqjBbZ1HwpmgPD6F3hPFM
         OCJB0onJYrVsQJB3+Fi3iwOiz5Z/FL4dRYpWcplLdhhOMJvpQN+LK+/GcsyOJNNLQ93X
         44iWKQIAoeCbSIJF5+ibV82+59RpYoOkoNdYsVITOJOqPvQqMsnwk9gs2l/jzTm4n3fV
         3i0+Iai9CxJZ+dyDuidX6ppK6RGNGzmrZ5HqxUfAAbPJ+nt1b0CZVg4uDwClkMqlqx1P
         WweA==
X-Gm-Message-State: AO0yUKWXlmgh2oxlWsj8UubHu3YeoICzYdGelSZBEm9MJsijYL4niw6X
        +DXpyve4XvQA0jP2xPapNXQABzIUYiiduQAurR2Fnw==
X-Google-Smtp-Source: AK7set/20JVmj47QvJRr7jCo4ElFQqcxiqT24HiTjVRHZUQRphwDySV2uq1PNOBdH2e2KJD8mt3drV42bNMGih8Rj/c=
X-Received: by 2002:a25:ab24:0:b0:80b:8fbc:7e68 with SMTP id
 u33-20020a25ab24000000b0080b8fbc7e68mr2974325ybi.517.1675119242201; Mon, 30
 Jan 2023 14:54:02 -0800 (PST)
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
 <878rhkx8bd.fsf@toke.dk> <CAAFAkD9Sh5jbp4qkzxuS+J3PGdtN-Kc2HdP8CDqweY36extSdA@mail.gmail.com>
 <87wn53wz77.fsf@toke.dk> <63d8325819298_3985f20824@john.notmuch> <87leljwwg7.fsf@toke.dk>
In-Reply-To: <87leljwwg7.fsf@toke.dk>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Mon, 30 Jan 2023 17:53:50 -0500
Message-ID: <CAM0EoM=i_pTSRokDqDo_8JWjsDYwwzSgJw6sc+0c=Ss81SyJqg@mail.gmail.com>
Subject: Re: [PATCH net-next RFC 00/20] Introducing P4TC
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
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

I think we are going in cycles. John I asked you earlier and i think
you answered my question: You are actually pitching an out of band
runtime using some vendor sdk via devlink (why even bother with
devlink interface, not sure). P4TC is saying the runtime API is via
the kernel to the drivers.

Toke, i dont think i have managed to get across that there is an
"autonomous" control built into the kernel. It is not just things that
come across netlink. It's about the whole infra. I think without that
clarity we are going to speak past each other and it's a frustrating
discussion which could get emotional. You cant just displace, for
example flower and say "use ebpf because it works on tc", theres a lot
of tribal knowledge gluing relationship between hardware and software.
Maybe take a look at this patchset below to see an example which shows
how part of an action graph will work in hardware and partially in sw
under certain conditions:
https://www.spinics.net/lists/netdev/msg877507.html and then we can
have a better discussion.

cheers,
jamal


On Mon, Jan 30, 2023 at 4:21 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> John Fastabend <john.fastabend@gmail.com> writes:
>
> > Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> >> Jamal Hadi Salim <hadi@mojatatu.com> writes:
> >>
> >> > On Mon, Jan 30, 2023 at 12:04 PM Toke H=C3=B8iland-J=C3=B8rgensen <t=
oke@redhat.com> wrote:
> >> >>
> >> >> Jamal Hadi Salim <jhs@mojatatu.com> writes:
> >> >>
> >> >> > So i dont have to respond to each email individually, I will resp=
ond
> >> >> > here in no particular order. First let me provide some context, i=
f
> >> >> > that was already clear please skip it. Hopefully providing the co=
ntext
> >> >> > will help us to focus otherwise that bikeshed's color and shape w=
ill
> >> >> > take forever to settle on.
> >> >> >
> >> >> > __Context__
> >> >> >
> >> >> > I hope we all agree that when you have 2x100G NIC (and i have see=
n
> >> >> > people asking for 2x800G NICs) no XDP or DPDK is going to save yo=
u. To
> >> >> > visualize: one 25G port is 35Mpps unidirectional. So "software st=
ack"
> >> >> > is not the answer. You need to offload.
> >> >>
> >> >> I'm not disputing the need to offload, and I'm personally delighted=
 that
> >> >> P4 is breaking open the vendor black boxes to provide a standardise=
d
> >> >> interface for this.
> >> >>
> >> >> However, while it's true that software can't keep up at the high en=
d,
> >> >> not everything runs at the high end, and today's high end is tomorr=
ow's
> >> >> mid end, in which XDP can very much play a role. So being able to m=
ove
> >> >> smoothly between the two, and even implement functions that split
> >> >> processing between them, is an essential feature of a programmable
> >> >> networking path in Linux. Which is why I'm objecting to implementin=
g the
> >> >> P4 bits as something that's hanging off the side of the stack in it=
s own
> >> >> thing and is not integrated with the rest of the stack. You were to=
uting
> >> >> this as a feature ("being self-contained"). I consider it a bug.
> >> >>
> >> >> > Scriptability is not a new idea in TC (see u32 and pedit and othe=
rs in
> >> >> > TC).
> >> >>
> >> >> u32 is notoriously hard to use. The others are neat, but obviously
> >> >> limited to particular use cases.
> >> >
> >> > Despite my love for u32, I admit its user interface is cryptic. I ju=
st
> >> > wanted to point out to existing samples of scriptable and offloadabl=
e
> >> > TC objects.
> >> >
> >> >> Do you actually expect anyone to use P4
> >> >> by manually entering TC commands to build a pipeline? I really find=
 that
> >> >> hard to believe...
> >> >
> >> > You dont have to manually hand code anything - its the compilers job=
.
> >>
> >> Right, that was kinda my point: in that case the compiler could just a=
s
> >> well generate a (set of) BPF program(s) instead of this TC script thin=
g.
> >>
> >> >> > IOW, we are reusing and plugging into a proven and deployed mecha=
nism
> >> >> > with a built-in policy driven, transparent symbiosis between hard=
ware
> >> >> > offload and software that has matured over time. You can take a
> >> >> > pipeline or a table or actions and split them between hardware an=
d
> >> >> > software transparently, etc.
> >> >>
> >> >> That's a control plane feature though, it's not an argument for add=
ing
> >> >> another interpreter to the kernel.
> >> >
> >> > I am not sure what you mean by control, but what i described is kern=
el
> >> > built in. Of course i could do more complex things from user space (=
if
> >> > that is what you mean as control).
> >>
> >> "Control plane" as in SDN parlance. I.e., the bits that keep track of
> >> configuration of the flow/pipeline/table configuration.
> >>
> >> There's no reason you can't have all that infrastructure and use BPF a=
s
> >> the datapath language. I.e., instead of:
> >>
> >> tc p4template create pipeline/aP4proggie numtables 1
> >> ... + all the other stuff to populate it
> >>
> >> you could just do:
> >>
> >> tc p4 create pipeline/aP4proggie obj_file aP4proggie.bpf.o
> >>
> >> and still have all the management infrastructure without the new
> >> interpreter and associated complexity in the kernel.
> >>
> >> >> > This hammer already meets our goals.
> >> >>
> >> >> That 60k+ line patch submission of yours says otherwise...
> >> >
> >> > This is pretty much covered in the cover letter and a few responses =
in
> >> > the thread since.
> >>
> >> The only argument for why your current approach makes sense I've seen
> >> you make is "I don't want to rewrite it in BPF". Which is not a
> >> technical argument.
> >>
> >> I'm not trying to be disingenuous here, BTW: I really don't see the
> >> technical argument for why the P4 data plane has to be implemented as
> >> its own interpreter instead of integrating with what we have already
> >> (i.e., BPF).
> >>
> >> -Toke
> >>
> >
> > I'll just take this here becaues I think its mostly related.
> >
> > Still not convinced the P4TC has any value for sw. From the
> > slide you say vendors prefer you have this picture roughtly.
> >
> >
> >    [ P4 compiler ] ------ [ P4TC backend ] ----> TC API
> >         |
> >         |
> >    [ P4 Vendor backend ]
> >         |
> >         |
> >         V
> >    [ Devlink ]
> >
> >
> > Now just replace P4TC backend with P4C and your only work is to
> > replace devlink with the current hw specific bits and you have
> > a sw and hw components. Then you get XDP-BPF pretty easily from
> > P4XDP backend if you like. The compat piece is handled by compiler
> > where it should be. My CPU is not a MAT so pretending it is seems
> > not ideal to me, I don't have a TCAM on my cores.
> >
> > For runtime get those vendors to write their SDKs over Devlink
> > and no need for this software thing. The runtime for P4c should
> > already work over BPF. Giving this picture
> >
> >    [ P4 compiler ] ------ [ P4C backend ] ----> BPF
> >         |
> >         |
> >    [ P4 Vendor backend ]
> >         |
> >         |
> >         V
> >    [ Devlink ]
> >
> > And much less work for us to maintain.
>
> Yes, this was basically my point as well. Thank you for putting it into
> ASCII diagrams! :)
>
> There's still the control plane bit: some kernel component that
> configures the pieces (pipelines?) created in the top-right and
> bottom-left corners of your diagram(s), keeping track of which pipelines
> are in HW/SW, maybe updating some match tables dynamically and
> extracting statistics. I'm totally OK with having that bit be in the
> kernel, but that can be added on top of your second diagram just as well
> as on top of the first one...
>
> -Toke
>
