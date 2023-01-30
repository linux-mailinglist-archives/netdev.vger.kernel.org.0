Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29302681E39
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 23:41:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbjA3Wlk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 17:41:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjA3Wli (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 17:41:38 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9969265B4
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 14:41:36 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id ml19so12882602ejb.0
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 14:41:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sipanda-io.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MBkKxs7fEofaY76lNckMbzWmQGX6oyUMksLDfYNMV/Q=;
        b=belkplSU0iNpsuVIA3HWAWn1yRJrqZVhA1tP4W8kPi+wN0LZLkCwL5uBsAjkl5jbRe
         z3FXBQjP84uKO5nJZgfn5qaodqBEiQWDajhgvm5izfCtRJZvDys7gEyid8Qy3SB1+INF
         69aIkZXHV8zl6pn1R7Md1rgocccukBvGVQhOlAz8E5CQLzmwHtkL8rkOtXesfR/HEmN+
         4MDUTupPtzQFV5Xe67Sev2X4oPkUd4ImhSKLjihTmHRV7IXCwb6RuhhN/XiSotRkoCgV
         LnBgkHVZ5AlKEIvr/DUoWaVhclu2vLk1NTHG9HdifTHupaU1P1CcOWDEP5NM8Wun+POG
         TmUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MBkKxs7fEofaY76lNckMbzWmQGX6oyUMksLDfYNMV/Q=;
        b=hts7Jo0OuhouD58qo6v4FtdT8Ab0W2flqLua+U6zxgDdBsrH+eOueXB1lIDSXU4b+d
         Lo1wvH62nFIqK1Hbl6I1jwJ7vQ3d7ekdB5iYzolZEcBTX1MuAy7LPkad6fswK+PkPwL0
         KxEHE4VrutDfh9ne7TmHtU6yrP7A22rqV3+WvOwBTlkLmfpN/5pwPmA0supo5HBlwHWP
         H5luYgJORx/fazI09IrXwY/ZfQeFp9D85DpOiUOyex6vn1cEliTBNc09EQ9bIFe3h6zS
         8IIpRKcnDnsq2Xr//bGPS4dlSdYTTG+tBg95mmAshs47GV7ePYce7uMT1XHQpIdZoeek
         OEyg==
X-Gm-Message-State: AO0yUKXgq3DSo5KSzwBT87pJLP9XCAEhPXA1j9ciiKO8f54KJDrtTKRF
        MjijFS4opUFOADWfgPDJjtj8dlGwI1ADz83u9yh1jg==
X-Google-Smtp-Source: AK7set9tYi1j1ujpYB2n2kMkf0/AiF2qEZ6PUFH6uWOQlNUaResxvi9Hh5kFgQn5RfibrEUo9nOIdVYCINPwEcAFzXY=
X-Received: by 2002:a17:906:14cf:b0:878:69e5:b797 with SMTP id
 y15-20020a17090614cf00b0087869e5b797mr3795220ejc.228.1675118495154; Mon, 30
 Jan 2023 14:41:35 -0800 (PST)
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
 <87wn53wz77.fsf@toke.dk> <63d8325819298_3985f20824@john.notmuch>
In-Reply-To: <63d8325819298_3985f20824@john.notmuch>
From:   Tom Herbert <tom@sipanda.io>
Date:   Mon, 30 Jan 2023 14:41:23 -0800
Message-ID: <CAOuuhY8_W-Evd1=1020bv4oP4pK2mCyyCuDLAu1ZU51hTefZrQ@mail.gmail.com>
Subject: Re: [PATCH net-next RFC 00/20] Introducing P4TC
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Jamal Hadi Salim <hadi@mojatatu.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Willem de Bruijn <willemb@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel@mojatatu.com, deb.chatterjee@intel.com,
        anjali.singhai@intel.com, namrata.limaye@intel.com,
        khalidm@nvidia.com, pratyush@sipanda.io, xiyou.wangcong@gmail.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        vladbu@nvidia.com, simon.horman@corigine.com, stefanc@marvell.com,
        seong.kim@amd.com, mattyk@nvidia.com, dan.daly@intel.com,
        john.andy.fingerhut@intel.com
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

On Mon, Jan 30, 2023 at 1:10 PM John Fastabend <john.fastabend@gmail.com> w=
rote:
>
> Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> > Jamal Hadi Salim <hadi@mojatatu.com> writes:
> >
> > > On Mon, Jan 30, 2023 at 12:04 PM Toke H=C3=B8iland-J=C3=B8rgensen <to=
ke@redhat.com> wrote:
> > >>
> > >> Jamal Hadi Salim <jhs@mojatatu.com> writes:
> > >>
> > >> > So i dont have to respond to each email individually, I will respo=
nd
> > >> > here in no particular order. First let me provide some context, if
> > >> > that was already clear please skip it. Hopefully providing the con=
text
> > >> > will help us to focus otherwise that bikeshed's color and shape wi=
ll
> > >> > take forever to settle on.
> > >> >
> > >> > __Context__
> > >> >
> > >> > I hope we all agree that when you have 2x100G NIC (and i have seen
> > >> > people asking for 2x800G NICs) no XDP or DPDK is going to save you=
. To
> > >> > visualize: one 25G port is 35Mpps unidirectional. So "software sta=
ck"
> > >> > is not the answer. You need to offload.
> > >>
> > >> I'm not disputing the need to offload, and I'm personally delighted =
that
> > >> P4 is breaking open the vendor black boxes to provide a standardised
> > >> interface for this.
> > >>
> > >> However, while it's true that software can't keep up at the high end=
,
> > >> not everything runs at the high end, and today's high end is tomorro=
w's
> > >> mid end, in which XDP can very much play a role. So being able to mo=
ve
> > >> smoothly between the two, and even implement functions that split
> > >> processing between them, is an essential feature of a programmable
> > >> networking path in Linux. Which is why I'm objecting to implementing=
 the
> > >> P4 bits as something that's hanging off the side of the stack in its=
 own
> > >> thing and is not integrated with the rest of the stack. You were tou=
ting
> > >> this as a feature ("being self-contained"). I consider it a bug.
> > >>
> > >> > Scriptability is not a new idea in TC (see u32 and pedit and other=
s in
> > >> > TC).
> > >>
> > >> u32 is notoriously hard to use. The others are neat, but obviously
> > >> limited to particular use cases.
> > >
> > > Despite my love for u32, I admit its user interface is cryptic. I jus=
t
> > > wanted to point out to existing samples of scriptable and offloadable
> > > TC objects.
> > >
> > >> Do you actually expect anyone to use P4
> > >> by manually entering TC commands to build a pipeline? I really find =
that
> > >> hard to believe...
> > >
> > > You dont have to manually hand code anything - its the compilers job.
> >
> > Right, that was kinda my point: in that case the compiler could just as
> > well generate a (set of) BPF program(s) instead of this TC script thing=
.
> >
> > >> > IOW, we are reusing and plugging into a proven and deployed mechan=
ism
> > >> > with a built-in policy driven, transparent symbiosis between hardw=
are
> > >> > offload and software that has matured over time. You can take a
> > >> > pipeline or a table or actions and split them between hardware and
> > >> > software transparently, etc.
> > >>
> > >> That's a control plane feature though, it's not an argument for addi=
ng
> > >> another interpreter to the kernel.
> > >
> > > I am not sure what you mean by control, but what i described is kerne=
l
> > > built in. Of course i could do more complex things from user space (i=
f
> > > that is what you mean as control).
> >
> > "Control plane" as in SDN parlance. I.e., the bits that keep track of
> > configuration of the flow/pipeline/table configuration.
> >
> > There's no reason you can't have all that infrastructure and use BPF as
> > the datapath language. I.e., instead of:
> >
> > tc p4template create pipeline/aP4proggie numtables 1
> > ... + all the other stuff to populate it
> >
> > you could just do:
> >
> > tc p4 create pipeline/aP4proggie obj_file aP4proggie.bpf.o
> >
> > and still have all the management infrastructure without the new
> > interpreter and associated complexity in the kernel.
> >
> > >> > This hammer already meets our goals.
> > >>
> > >> That 60k+ line patch submission of yours says otherwise...
> > >
> > > This is pretty much covered in the cover letter and a few responses i=
n
> > > the thread since.
> >
> > The only argument for why your current approach makes sense I've seen
> > you make is "I don't want to rewrite it in BPF". Which is not a
> > technical argument.
> >
> > I'm not trying to be disingenuous here, BTW: I really don't see the
> > technical argument for why the P4 data plane has to be implemented as
> > its own interpreter instead of integrating with what we have already
> > (i.e., BPF).
> >
> > -Toke
> >
>
> I'll just take this here becaues I think its mostly related.
>
> Still not convinced the P4TC has any value for sw. From the
> slide you say vendors prefer you have this picture roughtly.
>
>
>    [ P4 compiler ] ------ [ P4TC backend ] ----> TC API
>         |
>         |
>    [ P4 Vendor backend ]
>         |
>         |
>         V
>    [ Devlink ]
>
>
> Now just replace P4TC backend with P4C and your only work is to
> replace devlink with the current hw specific bits and you have
> a sw and hw components. Then you get XDP-BPF pretty easily from
> P4XDP backend if you like. The compat piece is handled by compiler
> where it should be. My CPU is not a MAT so pretending it is seems
> not ideal to me, I don't have a TCAM on my cores.
>
> For runtime get those vendors to write their SDKs over Devlink
> and no need for this software thing. The runtime for P4c should
> already work over BPF. Giving this picture
>
>    [ P4 compiler ] ------ [ P4C backend ] ----> BPF
>         |
>         |
>    [ P4 Vendor backend ]
>         |
>         |
>         V
>    [ Devlink ]
>

John, that's a good direction. If we go one step further and define a
common Intermediate Representation for programmable datapaths, we can
create a general solution that gives the user maximum flexibility and
freedom on both the frontend and the backend. For the front end they
can use whatever language they want as long as it supports an API that
can be compiled into the common IR (this is what PANDA does for
defining data paths in C). Similarly, for the backend we want to
support multiple targets both hardware and software. This is "write
once, run anywhere, run well": the developer writes their program
once, the same program runs on different targets, and on any
particular target the program runs as fast as possible given the
capabilities of the target.

There is another problem that a common IR addresses. The salient
requirement of kernel offload is that the offloaded functionality is
precisely equivalent to the kernel functionality that is being
offloaded. The traditional way this has been done is that the kernel
has to manage the bits offloaded to the device and provide all the
API. The problem is that it doesn't scale and quickly leads to
complexities like callouts to a jit compiler. My proposal is that we
compute an MD-5 hash of the IR and tag the program compiled from it
for the kernel (e.g. eBPF bytecode) and also tag the executable
compiled for the hardware (e.g. the P4 run-time).  At run time, there
kernel would query the device to see what program its running, if the
reported hash is equal to that of the loaded eBPF program, then the
device is running a functionally equivalent program and the offload
can safely be performed (via whatever datapath interfaces are needed).
This means that the device can be managed through a side channel, but
the kernel retains the necessary transparency to instantiate the
offload.

Here is a diagram of what this might look like:

[ P4 program ] ---- [ P4 compiler ] -----------------------+

           |
[ PANDA-C program ] ---- [ LLVM ]-----------------------+

           |
[ PANDA-Python program ] --- {Python compiler] ---+

           |
[ PANDA-Rust program ] --- [Rust compiler] ----------+

           |
[GUI] -------------[GUI to IR]---------------------------------+

           |
[CLI] --------------[CLI to IR]---------------------------------+

           |
                              +-----------------------------------------+
                              |
                              V
                  [Common IR (.json)]
                              |
+-----------------------+
|
+----[P4 Vendor Backend] ---- [Devlink]
|
+----[IR to eBPF backend compiler] --- [eBPF bytecode code]
|
+----[IR to CPU instructions] --- [Executable Binary]
|
+----[IR to P4TC CLI] --- [Script of commands]


> And much less work for us to maintain.

+1

>
> .John
