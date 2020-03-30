Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A2B0197242
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 03:52:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728122AbgC3BwP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 21:52:15 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:44463 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727954AbgC3BwP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Mar 2020 21:52:15 -0400
Received: by mail-qk1-f196.google.com with SMTP id j4so17421686qkc.11
        for <netdev@vger.kernel.org>; Sun, 29 Mar 2020 18:52:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=muskbmfvdZUs3Zkd1UGUNEdpRR3F6+WcTV/WMMTicwo=;
        b=I3jiV9seq/SI9QE0cBLRLdEknv58vHgzv0HGylJ3c8Rz1YsmSePr8i6g2coODv5xbw
         VFtj8k/dhkka6UQLDMFiTtr/cazav7E7mXH18ohu60H/RUvOaPRLLVgdcZSZIizj1chY
         mWTQqBbZbGFDxxhNeFy8Lrd9lLQO28txE0U7fovZSEMCTGOX7tryD345UgnlJqficM7f
         U+I5g0r4mihdBZw6rnu6tq2nR7QsnV7e3CVimqBVL0Jcd0W4uI66VoIlOIz1/T5i2jfl
         FYF8NSl41qGrugSnlSWLIlh5aTl1XfjKVtvnTvOkZP3UWOdttUQCb5obn62p1koyGqJh
         yJRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=muskbmfvdZUs3Zkd1UGUNEdpRR3F6+WcTV/WMMTicwo=;
        b=sAbc4O806aPAWNMCbzHPpMbI/scNn2+Ky4GBDAD+TIxANCcncwj0Nzgj6Xo/u01OHs
         mIxCUatHuDyfZAsQHTCMwYxAvG3UWCbcTSXDJNIr2qAC46YGI0IfOyKi9OfoHHsrV0Vv
         26Zjys1kBFWLICRcEWyoF27lJxQ1DY7Ldq1wqpyI9UYolI7Egg7ecd9A/az+XP8dUWfd
         Q+ygW1W0J4e0fjwHrV858dUzocfFtwxz4C8UXQ2EhUi1NXTK++1DV7YQo+/fplYaw/Ew
         ENWAE/Q0kp2TiVu08Ou7x9v4QaseFxxAQglHDaSZoLdy1F/3oUW1M82WO1dIMnmdrTeB
         D1Sg==
X-Gm-Message-State: ANhLgQ2fhGBnY8OtrfCNO5Y3xfMBTSKBb6dlgGQANSIGxDmaR/ipIxAz
        D/arH/xKABKMEAbJj9a0GhQqR42E
X-Google-Smtp-Source: ADFU+vtQKL1OVm3q7J8UkiaOa9vaBGNtUv9JyJizEhsEFo8d2+8FsnMtnIshVqtp9X6nu6a2ZTDEeg==
X-Received: by 2002:a37:4a85:: with SMTP id x127mr9957108qka.152.1585533132672;
        Sun, 29 Mar 2020 18:52:12 -0700 (PDT)
Received: from mail-yb1-f178.google.com (mail-yb1-f178.google.com. [209.85.219.178])
        by smtp.gmail.com with ESMTPSA id f93sm9648724qtd.26.2020.03.29.18.52.10
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 Mar 2020 18:52:11 -0700 (PDT)
Received: by mail-yb1-f178.google.com with SMTP id c13so4945648ybp.9
        for <netdev@vger.kernel.org>; Sun, 29 Mar 2020 18:52:10 -0700 (PDT)
X-Received: by 2002:a25:af0e:: with SMTP id a14mr16020907ybh.53.1585533130329;
 Sun, 29 Mar 2020 18:52:10 -0700 (PDT)
MIME-Version: 1.0
References: <2786b9598d534abf1f3d11357fa9b5f5@sslemail.net>
 <CA+FuTSf5U_ndpmBisjqLMihx0q+wCrqndDAUT1vF3=1DXJnumw@mail.gmail.com>
 <25b83b5245104a30977b042a886aa674@inspur.com> <CAF=yD-LAWc0POejfaB_xRW97BoVdLd6s6kjATyjDFBoK1aP-9Q@mail.gmail.com>
 <31e6d4edec0146e08cb3603ad6c2be4c@inspur.com> <CA+FuTSfG2J-5pu4kieXHm7d4giv4qXmwXBBHtJf0EcB1=83UOw@mail.gmail.com>
 <de32975979434430b914de00916bee95@inspur.com> <CA+FuTSe6vkWNq03zxP9Cbx4oj38sf1omeajh5fZRywouyADO6g@mail.gmail.com>
 <d81dbd7adfbe4bf3ba23649c5d3af59f@inspur.com>
In-Reply-To: <d81dbd7adfbe4bf3ba23649c5d3af59f@inspur.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sun, 29 Mar 2020 21:51:33 -0400
X-Gmail-Original-Message-ID: <CA+FuTScQfrHFdYYuwB6kWezPLCxs5dQH-hk7Vt9D4SQLzcbLXg@mail.gmail.com>
Message-ID: <CA+FuTScQfrHFdYYuwB6kWezPLCxs5dQH-hk7Vt9D4SQLzcbLXg@mail.gmail.com>
Subject: =?UTF-8?B?UmU6IFt2Z2VyLmtlcm5lbC5vcmfku6Plj5FdUmU6IFt2Z2VyLmtlcm5lbC5vcmfku6M=?=
        =?UTF-8?B?5Y+RXVJlOiBbUEFUQ0ggbmV0LW5leHRdIG5ldC8gcGFja2V0OiBmaXggVFBBQ0tFVF9WMyBwZXJmb3Jt?=
        =?UTF-8?B?YW5jZSBpc3N1ZSBpbiBjYXNlIG9mIFRTTw==?=
To:     =?UTF-8?B?WWkgWWFuZyAo5p2o54eaKS3kupHmnI3liqHpm4blm6I=?= 
        <yangyi01@inspur.com>
Cc:     "willemdebruijn.kernel@gmail.com" <willemdebruijn.kernel@gmail.com>,
        "yang_y_yi@163.com" <yang_y_yi@163.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "u9012063@gmail.com" <u9012063@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 28, 2020 at 10:43 PM Yi Yang (=E6=9D=A8=E7=87=9A)-=E4=BA=91=E6=
=9C=8D=E5=8A=A1=E9=9B=86=E5=9B=A2 <yangyi01@inspur.com> wrote:
>
> -----=E9=82=AE=E4=BB=B6=E5=8E=9F=E4=BB=B6-----
> =E5=8F=91=E4=BB=B6=E4=BA=BA: Willem de Bruijn [mailto:willemdebruijn.kern=
el@gmail.com]
> =E5=8F=91=E9=80=81=E6=97=B6=E9=97=B4: 2020=E5=B9=B43=E6=9C=8829=E6=97=A5 =
2:36
> =E6=94=B6=E4=BB=B6=E4=BA=BA: Yi Yang (=E6=9D=A8=E7=87=9A)-=E4=BA=91=E6=9C=
=8D=E5=8A=A1=E9=9B=86=E5=9B=A2 <yangyi01@inspur.com>
> =E6=8A=84=E9=80=81: willemdebruijn.kernel@gmail.com; yang_y_yi@163.com;
> netdev@vger.kernel.org; u9012063@gmail.com
> =E4=B8=BB=E9=A2=98: Re: [vger.kernel.org=E4=BB=A3=E5=8F=91]Re: [vger.kern=
el.org=E4=BB=A3=E5=8F=91]Re: [PATCH net-next]
> net/ packet: fix TPACKET_V3 performance issue in case of TSO
>
> On Sat, Mar 28, 2020 at 4:37 AM Yi Yang (=E6=9D=A8=E7=87=9A)-=E4=BA=91=E6=
=9C=8D=E5=8A=A1=E9=9B=86=E5=9B=A2
> <yangyi01@inspur.com> wrote:
> >
> <yangyi01@inspur.com> wrote:
> > > >
> > > > By the way, even if we used hrtimer, it can't ensure so high
> performance improvement, the reason is every frame has different size, yo=
u
> can't know how many microseconds one frame will be available, early timer
> firing will be an unnecessary waste, late timer firing will reduce
> performance, so I still think the way this patch used is best so far.
> > > >
> > >
> > > The key differentiating feature of TPACKET_V3 is the use of blocks to
> efficiently pack packets and amortize wake ups.
> > >
> > > If you want immediate notification for every packet, why not just use
> TPACKET_V2?
> > >
> > > For non-TSO packet, TPACKET_V3 is much better than TPACKET_V2, but fo=
r
> TSO packet, it is bad, we prefer to use TPACKET_V3 for better performance=
.
> >
> > At high rate, blocks are retired and userspace is notified as soon as a
> packet arrives that does not fit and requires dispatching a new block. As
> such, max throughput is not timer dependent. The timer exists to bound
> notification latency when packet arrival rate is slow.
> >
> > [Yi Yang] Per our iperf3 tcp test with TSO enabled, even if packet size=
 is
> about 64K and block size is also 64K + 4K (to accommodate tpacket_vX
> header), we can't see high performance without this patch, I think some
> small packets before 64K big packets decide what performance it can reach=
,
> according to my trace, TCP packet size is increasing from less than 100 t=
o
> 64K gradually, so it looks like how long this period took decides what
> performance it can reach. So yes, I don=E2=80=99t think hrtimer can help =
fix this
> issue very efficiently. In addition, I also noticed packet size pattern i=
s
> 1514, 64K, 64K, 64K, 64K, ..., 1514, 64K even if it reaches 64K packet si=
ze,
> maybe that 1514 packet has big impact on performance, I just guess.
>
> Again, the main issue is that the timer does not matter at high rate.
> The 3 Gbps you report corresponds to ~6000 TSO packets, or 167 usec inter
> arrival time. The timer, whether 1 or 4 ms, should never be needed.
>
> There are too many unknown variables here. Besides block size, what is
> tp_block_nr? What is the drop rate? Are you certain that you are not caus=
ing
> drops by not reading fast enough? What happens when you increase
> tp_block_size or tp_block_nr? It may be worthwhile to pin iperf to one (s=
et
> of) core(s) and the packet socket reader to another.
> Let it busy spin and do minimal processing, just return blocks back to th=
e
> kernel.
>
> If unsure about that, it may be interesting to instrument the kernel and
> count how many block retire operations are from
> prb_retire_rx_blk_timer_expired and how many from tpacket_rcv.
>
> Note that do_vnet only changes whether a virtio_net_header is prefixed to
> the data. Having that disabled (the common case) does not stop GSO packet=
s
> from arriving.
>
> [Yi Yang] You can refer to the patch
> (https://patchwork.ozlabs.org/patch/1257288/) for OVS DPDK for more detai=
ls,
> tp_block_nr is 128 for TSO case, frame size is equal to block size, I tri=
ed
> increase block size to multiple frames, also tried bigger tp_block_nr, bo=
th of
> them won't have any help. For TSO, we have to have vnet header in frame,
> otherwise TSO won't work. Our user scenario is Openstack, but use OVS DPD=
K not
> OVS, no matter it is tap interface or veth interface, performance is very=
 bad,
> because OVS DPDK is using RAW socket to receive packets from it and trans=
mit
> packets to it for veth, our iperf3 tcp test case attached two veth interf=
aces
> to OVS DPDK bridge and set two veth peers to two network name spaces and =
run
> iperf3 client in one ns, run iperf3 server in another ns, the traffic wil=
l go
> back and forth two veth interfaces, OVS DPDK used TPACKE_V3 to forward pa=
ckets
> between two veth interfaces.
>
>                                                TPACKET_V3       TPACKET_V=
3
> Here is an illustration for the traffic: ns01 <-> veth1 <-> vethbr1 <-> O=
VS
> DBDK Bridge <-> vethbr2 <-> veth2 <-> ns02
>
> I have used two pmd threads to handle vethbr1 and vethbr2 traffic,
> respectively, and pin them to core 2 and 3, respectively, iperf3 server a=
nd
> client are pinned to core 4 and 5, respectively, so the producer won't ha=
ve
> buffer overflow issue, on the contrary, the consumer is starved, I tried =
to
> output tpacket stats information, no queen freeze, no packet drop, so I'm=
 sure
> buffer is enough for it, I can see the consumer (pmd thread) is being sta=
rved
> because it can't receive packets in many loops, pmd threads are very fast=
,
> they don't have any other thing to do except receiving and transmitting
> packets.
>
> My test script for reference:
>
> #!/bin/bash
>
> DB_SOCK=3Dunix:/var/run/openvswitch/db.sock
> OVS_VSCTL=3D"/home/yangyi/workspace/ovs-master/utilities/ovs-vsctl --db=
=3D${DB_SOCK}"
>
> ${OVS_VSCTL} add-br br-int1 -- set bridge br-int1 datapath_type=3Dnetdev
> protocols=3DOpenFlow10,OpenFlow12,OpenFlow13
> ip link add veth1 type veth peer name vethbr1
> ip link add veth2 type veth peer name vethbr2
> ip netns add ns01
> ip netns add ns02
>
> ip link set veth1 netns ns01
> ip link set veth2 netns ns02
>
> ip netns exec ns01 ifconfig lo 127.0.0.1 up
> ip netns exec ns01 ifconfig veth1 10.15.1.2/24 up
> #ip netns exec ns01 ethtool -K veth1 tx off
>
> ip netns exec ns02 ifconfig lo 127.0.0.1 up
> ip netns exec ns02 ifconfig veth2 10.15.1.3/24 up
> #ip netns exec ns02 ethtool -K veth2 tx off
>
> ifconfig vethbr1 0 up
> ifconfig vethbr2 0 up
>
>
> ${OVS_VSCTL} add-port br-int1 vethbr1
> ${OVS_VSCTL} add-port br-int1 vethbr2
>
> ip netns exec ns01 ping 10.15.1.3 -c 3
> ip netns exec ns02 ping 10.15.1.2 -c 3
>
> killall iperf3
> ip netns exec ns02 iperf3 -s -i 10 -D -A 4
> ip netns exec ns01 iperf3 -t 60 -i 10 -c 10.15.1.3 -A 5 --get-server-outp=
ut
>
> ------------------------
> iperf3 test result
> -----------------------
> [yangyi@localhost ovs-master]$ sudo ../run-iperf3.sh
> iperf3: no process found
> Connecting to host 10.15.1.3, port 5201
> [  4] local 10.15.1.2 port 44976 connected to 10.15.1.3 port 5201
> [ ID] Interval           Transfer     Bandwidth       Retr  Cwnd
> [  4]   0.00-10.00  sec  19.6 GBytes  16.8 Gbits/sec  106586    307 KByte=
s
> [  4]  10.00-20.00  sec  19.5 GBytes  16.7 Gbits/sec  104625    215 KByte=
s
> [  4]  20.00-30.00  sec  20.0 GBytes  17.2 Gbits/sec  106962    301 KByte=
s

Thanks for the detailed info.

So there is more going on there than a simple network tap. veth, which
calls netif_rx and thus schedules delivery with a napi after a softirq
(twice), tpacket for recv + send + ovs processing. And this is a
single flow, so more sensitive to batching, drops and interrupt
moderation than a workload of many flows.

If anything, I would expect the ACKs on the return path to be the more
likely cause for concern, as they are even less likely to fill a block
before the timer. The return path is a separate packet socket?

With initial small window size, I guess it might be possible for the
entire window to be in transit. And as no follow-up data will arrive,
this waits for the timeout. But at 3Gbps that is no longer the case.
Again, the timeout is intrinsic to TPACKET_V3. If that is
unacceptable, then TPACKET_V2 is a more logical choice. Here also in
relation to timely ACK responses.

Other users of TPACKET_V3 may be using fewer blocks of larger size. A
change to retire blocks after 1 gso packet will negatively affect
their workloads. At the very least this should be an optional feature,
similar to how I suggested converting to micro seconds.
