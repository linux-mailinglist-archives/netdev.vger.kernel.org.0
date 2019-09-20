Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E14DBB8A55
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 07:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437201AbfITFCH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 01:02:07 -0400
Received: from mail-ua1-f68.google.com ([209.85.222.68]:41452 "EHLO
        mail-ua1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437189AbfITFCH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Sep 2019 01:02:07 -0400
Received: by mail-ua1-f68.google.com with SMTP id l13so1820059uap.8;
        Thu, 19 Sep 2019 22:02:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=/RtlO+u8sbN7Jto7SzD7OihZc393aP3mlz000KKCEE8=;
        b=YQiz/3DVIWyLKDt9Uydh2tKORCtYNDjXPFJYcEw7zKkCkRYC2xiQAnZaAGZEUDlWCJ
         o9FoFeNj1epwqyo8Ch11Nok49z1xYMneFXSQ6VVOTpq7KSrXKz/9uagUMt7dSLT5H87O
         NE2oRnSzYkW3jNTiZl+Mz7gNzk1/6T83aMJJ52vKPa7jR8uReulT0cR7/btA09F6z4cS
         WUMZP+ZUXACtWsfWi2Slhlimi8eD0zLwm1BttBVRP7Pc/rExRLC3WROcHYCBvPFajEy2
         c+GvWdsxArX4polxHWfi3dzB6aAW3ta5f56SETbysWgQCRNuxxFh29u6tZdLBpK7yjxj
         AElg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/RtlO+u8sbN7Jto7SzD7OihZc393aP3mlz000KKCEE8=;
        b=p9Hv1pj55FGRzq7UvCB9dAlwy8mMUtBMXMnaN2gLKR8advwtn7SMhY2Yhu3dPzz4LL
         h59Nq/fL9TgJlnlSr5a7kNks6qm5CSz0uFxgnEm1jZIP2Tal0MzLoUQM8kjcsfXi28CM
         S+WUznRabUulQ+cI/aOoXIa97K6YyNN0ohuQczJYM57EDOxTIThaPnbspt06Nwv5FIaq
         s3CoJDSpc/wV/cx23FUNYyirHsjvuWRvEAPHD4IhduJx/AGvlmxUxkS4He/hzDmAfFSJ
         Lao50ZSf6ihgjEwbePm9bV3BhEkTvKd0J7VxcInhHNuziBBRK/++GMvbBKhEVSc67rj7
         /f7A==
X-Gm-Message-State: APjAAAVg783kHMF+yl1PsfWqLLqB7Xwh51jPo7VO0WZv+lX63Wg2ee+Z
        dVw1LZ8hP4zn6F0GSc3UiUlDtkiotYsvm2V0l0M=
X-Google-Smtp-Source: APXvYqze6NjiT9F0CP+biauZjO6JXnnoWE8yPNdk7nU739hTYCYiVdK4UIYJDaQdjYdwRTan9ZFvvjpGdTGFFJRJjzU=
X-Received: by 2002:ab0:2041:: with SMTP id g1mr680771ual.45.1568955725302;
 Thu, 19 Sep 2019 22:02:05 -0700 (PDT)
MIME-Version: 1.0
References: <20190919224458.91422-1-matthew.cover@stackpath.com>
 <CAGyo_hrkUPxBAOttpo+xqcUHr89i2N5BOV4_rYFh=dRPkYVPGA@mail.gmail.com>
 <fa17e10b-d61b-00c3-b3eb-02cf6a197b78@redhat.com> <CAGyo_hpQSeFJYNuYvXp326C0646YUYr9CbBm-TpLobeOEaTgzg@mail.gmail.com>
In-Reply-To: <CAGyo_hpQSeFJYNuYvXp326C0646YUYr9CbBm-TpLobeOEaTgzg@mail.gmail.com>
From:   Matt Cover <werekraken@gmail.com>
Date:   Thu, 19 Sep 2019 22:01:52 -0700
Message-ID: <CAGyo_hquuZ5JNVgN_+6uPB4P_HTcS6D8yO-JbxAmM8gTpqaK-g@mail.gmail.com>
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

On Thu, Sep 19, 2019 at 7:45 PM Matt Cover <werekraken@gmail.com> wrote:
>
> On Thu, Sep 19, 2019 at 6:42 PM Jason Wang <jasowang@redhat.com> wrote:
> >
> >
> > On 2019/9/20 =E4=B8=8A=E5=8D=888:05, Matt Cover wrote:
> > > On Thu, Sep 19, 2019 at 3:45 PM Matthew Cover <werekraken@gmail.com> =
wrote:
> > >> WORK IN PROGRESS:
> > >>    * bpf program loading works!
> > >>    * txq steering via bpf program return code works!
> > >>    * bpf program unloading not working.
> > >>    * bpf program attached query not working.
> > >>
> > >> This patch set provides a bpf hookpoint with goals similar to, but a=
 more
> > >> generic implementation than, TUNSETSTEERINGEBPF; userspace supplied =
tx queue
> > >> selection policy.
> >
> >
> > One point that I introduce TUNSETSTEERINGEBPF instead of using a generi=
c
> > way like cls/act bpf is that I need make sure to have a consistent API
> > with macvtap.
> >
> > In the case of macvtap, TX means transmit from userspace to kernel, but
> > for TUN, it means transmit from kernel to userspace.
> >
>
> Ah, ok. I'll have to check that out at some point.
>
> >
> > >>
> > >> TUNSETSTEERINGEBPF is a useful bpf hookpoint, but has some drawbacks=
.
> > >>
> > >> First, it only works on tun/tap devices.
> > >>
> > >> Second, there is no way in the current TUNSETSTEERINGEBPF implementa=
tion
> > >> to bail out or load a noop bpf prog and fallback to the no prog tx q=
ueue
> > >> selection method.
> >
> >
> > I believe it expect that eBPF should take all the parts (even the
> > fallback part).
> >
>
> This would be easy to change in the existing TUNSETSTEERINGEBPF
> implementation if desired. We'd just need a negative return from the bpf =
prog
> to result in falling back to tun_automq_select_queue(). If that behavior
> sounds reasonable to you, I can look into that as a separate patch.
>
> >
> > >>
> > >> Third, the TUNSETSTEERINGEBPF interface seems to require possession =
of existing
> > >> or creation of new queues/fds.
> >
> >
> > That's the way TUN work for past +10 years because ioctl is the only wa=
y
> > to do configuration and it requires a fd to carry that. David suggest t=
o
> > implement netlink but nobody did that.
> >
>
> I see.
>
> >
> > >>
> > >> This most naturally fits in the "wire" implementation since possessi=
on of fds
> > >> is ensured. However, it also means the various "wire" implementation=
s (e.g.
> > >> qemu) have to all be made aware of TUNSETSTEERINGEBPF and expose an =
interface
> > >> to load/unload a bpf prog (or provide a mechanism to pass an fd to a=
nother
> > >> program).
> >
> >
> > The load/unload of ebpf program is standard bpf() syscall. Ioctl just
> > attach that to TUN. This idea is borrowed from packet socket which the
> > bpf program was attached through setsockopt().
> >
>
> Yeah, it doesn't take much code to load a prog. I wrote one earlier this =
week
> in fact which spins up an extra fd and detaches right after.
>
> >
> > >>
> > >> Alternatively, you can spin up an extra queue and immediately disabl=
e via
> > >> IFF_DETACH_QUEUE, but this seems unsafe; packets could be enqueued t=
o this
> > >> extra file descriptor which is part of our bpf prog loader, not our =
"wire".
> >
> >
> > You can use you 'wire' queue to do ioctl, but we can invent other API.
> >
>
> It might be cool to provide a way to create an already detached fd
> (not sure if this
> is non-trivial for some reason). Switching over to netlink could be
> the more long
> term goal.
>
> >
> > >>
> > >> Placing this in the XPS code and leveraging iproute2 and rtnetlink t=
o provide
> > >> our bpf prog loader in a similar manner to xdp gives us a nice way t=
o separate
> > >> the tap "wire" and the loading of tx queue selection policy. It also=
 lets us
> > >> use this hookpoint for any device traversing XPS.
> > >>
> > >> This patch only introduces the new hookpoint to the XPS code and wil=
l not yet
> > >> be used by tun/tap devices using the intree tun.ko (which implements=
 an
> > >> .ndo_select_queue and does not traverse the XPS code).
> > >>
> > >> In a future patch set, we can optionally refactor tun.ko to traverse=
 this call
> > >> to bpf_prog_run_clear_cb() and bpf prog storage. tun/tap devices cou=
ld then
> > >> leverage iproute2 as a generic loader. The TUNSETSTEERINGEBPF interf=
ace could
> > >> at this point be optionally deprecated/removed.
> >
> >
> > As described above, we need it for macvtap and you propose here can not
> > work for that.
> >
> > I'm not against this proposal, just want to clarify some considerations
> > when developing TUNSETSTEERINGEPF. The main goal is for VM to implement
> > sophisticated steering policy like RSS without touching kernel.
> >
>
> Very cool. Thank you for your comments Jason; they have added clarity
> to some things.
>
> I'm still interested in adding this hookpoint, community willing. I
> believe it provides
> value beyond xps_cpus/xps_rxqs.
>
> I also plan to look into adding a similar hookpoint in the rps code.
> That will unlock
> additional possibilities for this xps hookpoint (e.g. rfs implemented
> via bpf maps, but
> only on a subset of traffic [high priority or especially resource
> costly] rather than all).
>
> I've had (so far casual) chats with a couple NIC vendors about various
> "SmartNICs" supporting custom entropy fields for RSS. I'm playing with th=
e idea
> of an "rpsoffload" prog loaded into the NIC being the way custom entropy =
is
> configured. Being able to configure RSS to generate a hash based on an fi=
elds
> of an inner packet or a packet type specific field like GRE key would be =
super
> nice for NFV workloads.
>

Turns out the RSS part is already being done via XDP!
https://github.com/Netronome/bpf-samples/tree/master/programmable_rss

> Perhaps even an "rpsdrv" or "rpsoffload" hookpoint could leverage bpf
> helpers for
> RSS hash algorithm (e.g. bfp_rss_hash_toeplitz(), bpf_rss_hash_crc(),
> bpf_rss_hash_xor(), etc.).
>
> The ideas on how things would look for receive are still early, but I
> think there is
> a lot of potential for making things more flexible by leveraging ebpf
> in this area.
>
> > Thanks
> >
> >
> > >>
> > >> Both patches in this set have been tested using a rebuilt tun.ko wit=
h no
> > >> .ndo_select_queue.
> > >>
> > >>    sed -i '/\.ndo_select_queue.*=3D/d' drivers/net/tun.c
> > >>
> > >> The tap device was instantiated using tap_mq_pong.c, supporting scri=
pts, and
> > >> wrapping service found here:
> > >>
> > >>    https://github.com/stackpath/rxtxcpu/tree/v1.2.6/helpers
> > >>
> > >> The bpf prog source and test scripts can be found here:
> > >>
> > >>    https://github.com/werekraken/xps_ebpf
> > >>
> > >> In nstxq, netsniff-ng using PACKET_FANOUT_QM is leveraged to check t=
he
> > >> queue_mapping.
> > >>
> > >> With no prog loaded, the tx queue selection is adhering our xps_cpus
> > >> configuration.
> > >>
> > >>    [vagrant@localhost ~]$ grep . /sys/class/net/tap0/queues/tx-*/xps=
_cpus; ./nstxq; sudo timeout 1 cat /sys/kernel/debug/tracing/trace_pipe;
> > >>    /sys/class/net/tap0/queues/tx-0/xps_cpus:1
> > >>    /sys/class/net/tap0/queues/tx-1/xps_cpus:2
> > >>    cpu0: ping: 64 bytes from 169.254.254.1: icmp_seq=3D1 ttl=3D64 ti=
me=3D0.146 ms
> > >>    cpu0: qm0:  > tap0 98 Unknown =3D> Unknown IPv4 169.254.254.2/169=
.254.254.1 Len 84 Type 8 Code 0
> > >>    cpu1: ping: 64 bytes from 169.254.254.1: icmp_seq=3D1 ttl=3D64 ti=
me=3D0.121 ms
> > >>    cpu1: qm1:  > tap0 98 Unknown =3D> Unknown IPv4 169.254.254.2/169=
.254.254.1 Len 84 Type 8 Code 0
> > >>
> > >> With a return 0 bpg prog, our tx queue is 0 (despite xps_cpus).
> > >>
> > >>    [vagrant@localhost ~]$ sudo ip link set dev tap0 xps obj hello0.o=
 sec hello && { ./nstxq; sudo timeout 1 cat /sys/kernel/debug/tracing/trace=
_pipe; }
> > >>    cpu0: ping: 64 bytes from 169.254.254.1: icmp_seq=3D1 ttl=3D64 ti=
me=3D0.160 ms
> > >>    cpu0: qm0:  > tap0 98 Unknown =3D> Unknown IPv4 169.254.254.2/169=
.254.254.1 Len 84 Type 8 Code 0
> > >>    cpu1: ping: 64 bytes from 169.254.254.1: icmp_seq=3D1 ttl=3D64 ti=
me=3D0.124 ms
> > >>    cpu1: qm0:  > tap0 98 Unknown =3D> Unknown IPv4 169.254.254.2/169=
.254.254.1 Len 84 Type 8 Code 0
> > >>                ping-4852  [000] ....  2691.633260: 0: xps (RET 0): H=
ello, World!
> > >>                ping-4869  [001] ....  2695.753588: 0: xps (RET 0): H=
ello, World!
> > >>
> > >> With a return 1 bpg prog, our tx queue is 1.
> > >>
> > >>    [vagrant@localhost ~]$ sudo ip link set dev tap0 xps obj hello1.o=
 sec hello && { ./nstxq; sudo timeout 1 cat /sys/kernel/debug/tracing/trace=
_pipe; }
> > >>    cpu0: ping: 64 bytes from 169.254.254.1: icmp_seq=3D1 ttl=3D64 ti=
me=3D0.193 ms
> > >>    cpu0: qm1:  > tap0 98 Unknown =3D> Unknown IPv4 169.254.254.2/169=
.254.254.1 Len 84 Type 8 Code 0
> > >>    cpu1: ping: 64 bytes from 169.254.254.1: icmp_seq=3D1 ttl=3D64 ti=
me=3D0.135 ms
> > >>    cpu1: qm1:  > tap0 98 Unknown =3D> Unknown IPv4 169.254.254.2/169=
.254.254.1 Len 84 Type 8 Code 0
> > >>                ping-4894  [000] ....  2710.652080: 0: xps (RET 1): H=
ello, World!
> > >>                ping-4911  [001] ....  2714.774608: 0: xps (RET 1): H=
ello, World!
> > >>
> > >> With a return 2 bpg prog, our tx queue is 0 (we only have 2 tx queue=
s).
> > >>
> > >>    [vagrant@localhost ~]$ sudo ip link set dev tap0 xps obj hello2.o=
 sec hello && { ./nstxq; sudo timeout 1 cat /sys/kernel/debug/tracing/trace=
_pipe; }
> > >>    cpu0: ping: 64 bytes from 169.254.254.1: icmp_seq=3D1 ttl=3D64 ti=
me=3D1.20 ms
> > >>    cpu0: qm0:  > tap0 98 Unknown =3D> Unknown IPv4 169.254.254.2/169=
.254.254.1 Len 84 Type 8 Code 0
> > >>    cpu1: ping: 64 bytes from 169.254.254.1: icmp_seq=3D1 ttl=3D64 ti=
me=3D0.986 ms
> > >>    cpu1: qm0:  > tap0 98 Unknown =3D> Unknown IPv4 169.254.254.2/169=
.254.254.1 Len 84 Type 8 Code 0
> > >>                ping-4936  [000] ....  2729.442668: 0: xps (RET 2): H=
ello, World!
> > >>                ping-4953  [001] ....  2733.614558: 0: xps (RET 2): H=
ello, World!
> > >>
> > >> With a return -1 bpf prog, our tx queue selection is once again dete=
rmined by
> > >> xps_cpus. Any negative return should work the same and provides a ni=
ce
> > >> mechanism to bail out or have a noop bpf prog at this hookpoint.
> > >>
> > >>    [vagrant@localhost ~]$ sudo ip link set dev tap0 xps obj hello_ne=
g1.o sec hello && { ./nstxq; sudo timeout 1 cat /sys/kernel/debug/tracing/t=
race_pipe; }
> > >>    cpu0: ping: 64 bytes from 169.254.254.1: icmp_seq=3D1 ttl=3D64 ti=
me=3D0.628 ms
> > >>    cpu0: qm0:  > tap0 98 Unknown =3D> Unknown IPv4 169.254.254.2/169=
.254.254.1 Len 84 Type 8 Code 0
> > >>    cpu1: ping: 64 bytes from 169.254.254.1: icmp_seq=3D1 ttl=3D64 ti=
me=3D0.322 ms
> > >>    cpu1: qm1:  > tap0 98 Unknown =3D> Unknown IPv4 169.254.254.2/169=
.254.254.1 Len 84 Type 8 Code 0
> > >>                ping-4981  [000] ....  2763.510760: 0: xps (RET -1): =
Hello, World!
> > >>                ping-4998  [001] ....  2767.632583: 0: xps (RET -1): =
Hello, World!
> > >>
> > >> bpf prog unloading is not yet working and neither does `ip link show=
` report
> > >> when an "xps" bpf prog is attached. This is my first time touching i=
proute2 or
> > >> rtnetlink, so it may be something obvious to those more familiar.
> > > Adding Jason... sorry for missing that the first time.
