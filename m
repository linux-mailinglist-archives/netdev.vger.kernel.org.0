Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D8F1B8980
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 04:46:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394735AbfITCp5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 22:45:57 -0400
Received: from mail-vs1-f68.google.com ([209.85.217.68]:46866 "EHLO
        mail-vs1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394726AbfITCp4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 22:45:56 -0400
Received: by mail-vs1-f68.google.com with SMTP id z14so3670918vsz.13;
        Thu, 19 Sep 2019 19:45:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=vaLrY1LdPtrqZA5ZcXyHp62t+DfQTOJq9lUFsByTH4c=;
        b=mYiRNwR29PHZ8kSuugX7zgeNHn/YZ1+mWnXcZreKF1QSaOktLAQObjWM1t4LKZACtx
         9kkjQp0Y3el5ak/5zd5I1lj5e+d9D26PY4aGT7aUrpn6ast/tIhhiFxeaOaz35lc+9Yy
         yEkx6Xfl30I1ouuCfKOIwkCI0+r9lO/3PTg36h5rY3Glezja4BJmRMc+eakjcb4iBRmM
         2xl/vXedoUR0rafdMlUpaWQG1/FKcD0sK0oSuR68zafTsX2Qql81+4HOsMSxSD29n5tD
         o3ZSqdOiJXZEwocUBUCBf/xY65ddUtVppwo9WkEMPAGG36WbH39KdWGMIPdWfc5H6OKu
         TtWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=vaLrY1LdPtrqZA5ZcXyHp62t+DfQTOJq9lUFsByTH4c=;
        b=p5w2Vv3E+L42wMsZytfrpJbqYHZboVALRh0mtFBwCpyZvKYOqRVXcS8YJTHWvHARf4
         xrG2X8C0BFNEXKQZPn/0C4b7a7QADZ6otP0dyXh9SXDhEd0BRYhwlLl+HfiPDUufDAux
         UkiRd99L0wWdW4L+yBW63aKktdJusGA9AcyebeXxLghSEF5alw1ADruXOvG/4sYIKcWg
         Mz44YpF1gP0Hn1yfuy32viLvJPW0JuG9BvXu+wqsFiy4xZJEpJWAjvrZzg2R5yyNjNbv
         xdedHLUpOX6YoG9Mfk3BDN2GdhZU1fDbZCZsBKePw1nTC1i5wFvSmKP8E8Of2PS6XvWy
         6I+g==
X-Gm-Message-State: APjAAAVBLBBoPxQxee4CB0s8GajeHdvHRN28Bsvy6w3NkMI1Q1JyLqhe
        Z2vkUzNcHvlkQ87zwhlvqTl7jUMgaVuMdkgkRmU=
X-Google-Smtp-Source: APXvYqxp+Ii8C6GorVGChWjQQP7h5Wy654ixhxiswmunb5bHYqnQd/zmqeed0Bh+T4r63gtbQdQwylPim5ldf0nlWLY=
X-Received: by 2002:a67:c392:: with SMTP id s18mr1040018vsj.15.1568947555213;
 Thu, 19 Sep 2019 19:45:55 -0700 (PDT)
MIME-Version: 1.0
References: <20190919224458.91422-1-matthew.cover@stackpath.com>
 <CAGyo_hrkUPxBAOttpo+xqcUHr89i2N5BOV4_rYFh=dRPkYVPGA@mail.gmail.com> <fa17e10b-d61b-00c3-b3eb-02cf6a197b78@redhat.com>
In-Reply-To: <fa17e10b-d61b-00c3-b3eb-02cf6a197b78@redhat.com>
From:   Matt Cover <werekraken@gmail.com>
Date:   Thu, 19 Sep 2019 19:45:43 -0700
Message-ID: <CAGyo_hpQSeFJYNuYvXp326C0646YUYr9CbBm-TpLobeOEaTgzg@mail.gmail.com>
Subject: Re: [RFC {net,iproute2}-next 0/2] Introduce an eBPF hookpoint for tx
 queue selection in the XPS (Transmit Packet Steering) code.
To:     Jason Wang <jasowang@redhat.com>
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        nikolay@cumulusnetworks.com, sd@queasysnail.net,
        sbrivio@redhat.com, vincent@bernat.ch, kda@linux-powerpc.org,
        Matthew Cover <matthew.cover@stackpath.com>, jiri@mellanox.com,
        Eric Dumazet <edumazet@google.com>, pabeni@redhat.com,
        idosch@mellanox.com, petrm@mellanox.com, f.fainelli@gmail.com,
        stephen@networkplumber.org, dsahern@gmail.com,
        christian@brauner.io, jakub.kicinski@netronome.com,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        johannes.berg@intel.com, mkubecek@suse.cz, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 19, 2019 at 6:42 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> On 2019/9/20 =E4=B8=8A=E5=8D=888:05, Matt Cover wrote:
> > On Thu, Sep 19, 2019 at 3:45 PM Matthew Cover <werekraken@gmail.com> wr=
ote:
> >> WORK IN PROGRESS:
> >>    * bpf program loading works!
> >>    * txq steering via bpf program return code works!
> >>    * bpf program unloading not working.
> >>    * bpf program attached query not working.
> >>
> >> This patch set provides a bpf hookpoint with goals similar to, but a m=
ore
> >> generic implementation than, TUNSETSTEERINGEBPF; userspace supplied tx=
 queue
> >> selection policy.
>
>
> One point that I introduce TUNSETSTEERINGEBPF instead of using a generic
> way like cls/act bpf is that I need make sure to have a consistent API
> with macvtap.
>
> In the case of macvtap, TX means transmit from userspace to kernel, but
> for TUN, it means transmit from kernel to userspace.
>

Ah, ok. I'll have to check that out at some point.

>
> >>
> >> TUNSETSTEERINGEBPF is a useful bpf hookpoint, but has some drawbacks.
> >>
> >> First, it only works on tun/tap devices.
> >>
> >> Second, there is no way in the current TUNSETSTEERINGEBPF implementati=
on
> >> to bail out or load a noop bpf prog and fallback to the no prog tx que=
ue
> >> selection method.
>
>
> I believe it expect that eBPF should take all the parts (even the
> fallback part).
>

This would be easy to change in the existing TUNSETSTEERINGEBPF
implementation if desired. We'd just need a negative return from the bpf pr=
og
to result in falling back to tun_automq_select_queue(). If that behavior
sounds reasonable to you, I can look into that as a separate patch.

>
> >>
> >> Third, the TUNSETSTEERINGEBPF interface seems to require possession of=
 existing
> >> or creation of new queues/fds.
>
>
> That's the way TUN work for past +10 years because ioctl is the only way
> to do configuration and it requires a fd to carry that. David suggest to
> implement netlink but nobody did that.
>

I see.

>
> >>
> >> This most naturally fits in the "wire" implementation since possession=
 of fds
> >> is ensured. However, it also means the various "wire" implementations =
(e.g.
> >> qemu) have to all be made aware of TUNSETSTEERINGEBPF and expose an in=
terface
> >> to load/unload a bpf prog (or provide a mechanism to pass an fd to ano=
ther
> >> program).
>
>
> The load/unload of ebpf program is standard bpf() syscall. Ioctl just
> attach that to TUN. This idea is borrowed from packet socket which the
> bpf program was attached through setsockopt().
>

Yeah, it doesn't take much code to load a prog. I wrote one earlier this we=
ek
in fact which spins up an extra fd and detaches right after.

>
> >>
> >> Alternatively, you can spin up an extra queue and immediately disable =
via
> >> IFF_DETACH_QUEUE, but this seems unsafe; packets could be enqueued to =
this
> >> extra file descriptor which is part of our bpf prog loader, not our "w=
ire".
>
>
> You can use you 'wire' queue to do ioctl, but we can invent other API.
>

It might be cool to provide a way to create an already detached fd
(not sure if this
is non-trivial for some reason). Switching over to netlink could be
the more long
term goal.

>
> >>
> >> Placing this in the XPS code and leveraging iproute2 and rtnetlink to =
provide
> >> our bpf prog loader in a similar manner to xdp gives us a nice way to =
separate
> >> the tap "wire" and the loading of tx queue selection policy. It also l=
ets us
> >> use this hookpoint for any device traversing XPS.
> >>
> >> This patch only introduces the new hookpoint to the XPS code and will =
not yet
> >> be used by tun/tap devices using the intree tun.ko (which implements a=
n
> >> .ndo_select_queue and does not traverse the XPS code).
> >>
> >> In a future patch set, we can optionally refactor tun.ko to traverse t=
his call
> >> to bpf_prog_run_clear_cb() and bpf prog storage. tun/tap devices could=
 then
> >> leverage iproute2 as a generic loader. The TUNSETSTEERINGEBPF interfac=
e could
> >> at this point be optionally deprecated/removed.
>
>
> As described above, we need it for macvtap and you propose here can not
> work for that.
>
> I'm not against this proposal, just want to clarify some considerations
> when developing TUNSETSTEERINGEPF. The main goal is for VM to implement
> sophisticated steering policy like RSS without touching kernel.
>

Very cool. Thank you for your comments Jason; they have added clarity
to some things.

I'm still interested in adding this hookpoint, community willing. I
believe it provides
value beyond xps_cpus/xps_rxqs.

I also plan to look into adding a similar hookpoint in the rps code.
That will unlock
additional possibilities for this xps hookpoint (e.g. rfs implemented
via bpf maps, but
only on a subset of traffic [high priority or especially resource
costly] rather than all).

I've had (so far casual) chats with a couple NIC vendors about various
"SmartNICs" supporting custom entropy fields for RSS. I'm playing with the =
idea
of an "rpsoffload" prog loaded into the NIC being the way custom entropy is
configured. Being able to configure RSS to generate a hash based on an fiel=
ds
of an inner packet or a packet type specific field like GRE key would be su=
per
nice for NFV workloads.

Perhaps even an "rpsdrv" or "rpsoffload" hookpoint could leverage bpf
helpers for
RSS hash algorithm (e.g. bfp_rss_hash_toeplitz(), bpf_rss_hash_crc(),
bpf_rss_hash_xor(), etc.).

The ideas on how things would look for receive are still early, but I
think there is
a lot of potential for making things more flexible by leveraging ebpf
in this area.

> Thanks
>
>
> >>
> >> Both patches in this set have been tested using a rebuilt tun.ko with =
no
> >> .ndo_select_queue.
> >>
> >>    sed -i '/\.ndo_select_queue.*=3D/d' drivers/net/tun.c
> >>
> >> The tap device was instantiated using tap_mq_pong.c, supporting script=
s, and
> >> wrapping service found here:
> >>
> >>    https://github.com/stackpath/rxtxcpu/tree/v1.2.6/helpers
> >>
> >> The bpf prog source and test scripts can be found here:
> >>
> >>    https://github.com/werekraken/xps_ebpf
> >>
> >> In nstxq, netsniff-ng using PACKET_FANOUT_QM is leveraged to check the
> >> queue_mapping.
> >>
> >> With no prog loaded, the tx queue selection is adhering our xps_cpus
> >> configuration.
> >>
> >>    [vagrant@localhost ~]$ grep . /sys/class/net/tap0/queues/tx-*/xps_c=
pus; ./nstxq; sudo timeout 1 cat /sys/kernel/debug/tracing/trace_pipe;
> >>    /sys/class/net/tap0/queues/tx-0/xps_cpus:1
> >>    /sys/class/net/tap0/queues/tx-1/xps_cpus:2
> >>    cpu0: ping: 64 bytes from 169.254.254.1: icmp_seq=3D1 ttl=3D64 time=
=3D0.146 ms
> >>    cpu0: qm0:  > tap0 98 Unknown =3D> Unknown IPv4 169.254.254.2/169.2=
54.254.1 Len 84 Type 8 Code 0
> >>    cpu1: ping: 64 bytes from 169.254.254.1: icmp_seq=3D1 ttl=3D64 time=
=3D0.121 ms
> >>    cpu1: qm1:  > tap0 98 Unknown =3D> Unknown IPv4 169.254.254.2/169.2=
54.254.1 Len 84 Type 8 Code 0
> >>
> >> With a return 0 bpg prog, our tx queue is 0 (despite xps_cpus).
> >>
> >>    [vagrant@localhost ~]$ sudo ip link set dev tap0 xps obj hello0.o s=
ec hello && { ./nstxq; sudo timeout 1 cat /sys/kernel/debug/tracing/trace_p=
ipe; }
> >>    cpu0: ping: 64 bytes from 169.254.254.1: icmp_seq=3D1 ttl=3D64 time=
=3D0.160 ms
> >>    cpu0: qm0:  > tap0 98 Unknown =3D> Unknown IPv4 169.254.254.2/169.2=
54.254.1 Len 84 Type 8 Code 0
> >>    cpu1: ping: 64 bytes from 169.254.254.1: icmp_seq=3D1 ttl=3D64 time=
=3D0.124 ms
> >>    cpu1: qm0:  > tap0 98 Unknown =3D> Unknown IPv4 169.254.254.2/169.2=
54.254.1 Len 84 Type 8 Code 0
> >>                ping-4852  [000] ....  2691.633260: 0: xps (RET 0): Hel=
lo, World!
> >>                ping-4869  [001] ....  2695.753588: 0: xps (RET 0): Hel=
lo, World!
> >>
> >> With a return 1 bpg prog, our tx queue is 1.
> >>
> >>    [vagrant@localhost ~]$ sudo ip link set dev tap0 xps obj hello1.o s=
ec hello && { ./nstxq; sudo timeout 1 cat /sys/kernel/debug/tracing/trace_p=
ipe; }
> >>    cpu0: ping: 64 bytes from 169.254.254.1: icmp_seq=3D1 ttl=3D64 time=
=3D0.193 ms
> >>    cpu0: qm1:  > tap0 98 Unknown =3D> Unknown IPv4 169.254.254.2/169.2=
54.254.1 Len 84 Type 8 Code 0
> >>    cpu1: ping: 64 bytes from 169.254.254.1: icmp_seq=3D1 ttl=3D64 time=
=3D0.135 ms
> >>    cpu1: qm1:  > tap0 98 Unknown =3D> Unknown IPv4 169.254.254.2/169.2=
54.254.1 Len 84 Type 8 Code 0
> >>                ping-4894  [000] ....  2710.652080: 0: xps (RET 1): Hel=
lo, World!
> >>                ping-4911  [001] ....  2714.774608: 0: xps (RET 1): Hel=
lo, World!
> >>
> >> With a return 2 bpg prog, our tx queue is 0 (we only have 2 tx queues)=
.
> >>
> >>    [vagrant@localhost ~]$ sudo ip link set dev tap0 xps obj hello2.o s=
ec hello && { ./nstxq; sudo timeout 1 cat /sys/kernel/debug/tracing/trace_p=
ipe; }
> >>    cpu0: ping: 64 bytes from 169.254.254.1: icmp_seq=3D1 ttl=3D64 time=
=3D1.20 ms
> >>    cpu0: qm0:  > tap0 98 Unknown =3D> Unknown IPv4 169.254.254.2/169.2=
54.254.1 Len 84 Type 8 Code 0
> >>    cpu1: ping: 64 bytes from 169.254.254.1: icmp_seq=3D1 ttl=3D64 time=
=3D0.986 ms
> >>    cpu1: qm0:  > tap0 98 Unknown =3D> Unknown IPv4 169.254.254.2/169.2=
54.254.1 Len 84 Type 8 Code 0
> >>                ping-4936  [000] ....  2729.442668: 0: xps (RET 2): Hel=
lo, World!
> >>                ping-4953  [001] ....  2733.614558: 0: xps (RET 2): Hel=
lo, World!
> >>
> >> With a return -1 bpf prog, our tx queue selection is once again determ=
ined by
> >> xps_cpus. Any negative return should work the same and provides a nice
> >> mechanism to bail out or have a noop bpf prog at this hookpoint.
> >>
> >>    [vagrant@localhost ~]$ sudo ip link set dev tap0 xps obj hello_neg1=
.o sec hello && { ./nstxq; sudo timeout 1 cat /sys/kernel/debug/tracing/tra=
ce_pipe; }
> >>    cpu0: ping: 64 bytes from 169.254.254.1: icmp_seq=3D1 ttl=3D64 time=
=3D0.628 ms
> >>    cpu0: qm0:  > tap0 98 Unknown =3D> Unknown IPv4 169.254.254.2/169.2=
54.254.1 Len 84 Type 8 Code 0
> >>    cpu1: ping: 64 bytes from 169.254.254.1: icmp_seq=3D1 ttl=3D64 time=
=3D0.322 ms
> >>    cpu1: qm1:  > tap0 98 Unknown =3D> Unknown IPv4 169.254.254.2/169.2=
54.254.1 Len 84 Type 8 Code 0
> >>                ping-4981  [000] ....  2763.510760: 0: xps (RET -1): He=
llo, World!
> >>                ping-4998  [001] ....  2767.632583: 0: xps (RET -1): He=
llo, World!
> >>
> >> bpf prog unloading is not yet working and neither does `ip link show` =
report
> >> when an "xps" bpf prog is attached. This is my first time touching ipr=
oute2 or
> >> rtnetlink, so it may be something obvious to those more familiar.
> > Adding Jason... sorry for missing that the first time.
