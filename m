Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 254EA2217D0
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 00:33:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726785AbgGOWc5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 18:32:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726356AbgGOWc5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 18:32:57 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FDCFC061755
        for <netdev@vger.kernel.org>; Wed, 15 Jul 2020 15:32:57 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id f23so3980523iof.6
        for <netdev@vger.kernel.org>; Wed, 15 Jul 2020 15:32:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2Nev6/M4nX6s5PEOrK6usbHNr8mBxbOHskSDsS3QUmU=;
        b=RPrAxNZCbMSslguhVYZ3YTLNRJwAlFXrpsEiCGSNdKvQm1WR/HxmU1BK+OmziBHEMD
         sELNNBQ6PGTkN1Djmtn7NQq1FW2jQB+yr4n/pvE53V0RIJ/fKgZ6llqGUEYhs2F4nnct
         1yK5eH31uxoxGeGxxsySYi9SHZ7JAfoIm03PU9fR9xAdTCRx8a9iRgviUDjs2uUKCa2R
         AdLfPb92j+g405fGmFRX8TwHyjuDRSYY+0utk20ZT3rJNia4QIXSQCkqV7Ddb+mX8dhk
         C0V0BK5wnAkiiFNNWKnEcQYt21SOQJW/tlACN0cMmUtevn7q7ZCwV3uv34qOTfyCunfn
         3wGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2Nev6/M4nX6s5PEOrK6usbHNr8mBxbOHskSDsS3QUmU=;
        b=D+DPvJ1RDphf8nisypL4lSJA3fnWqG2vHz1N789jAuQsJsDKbk7WxOj5SrZHIAhum2
         MjPRbq2bfGR8d9Rhw+y4VGzMvSamSK7W0eyqmbf+yRdHaPDfGUltqs8FGbVyBWw7Rt/o
         JvjrBUxrLMN7obutm0BNuRzgwCEn+cGzHX31LM4EgCTRmZKXr1St2kEHOs1g5/Hcp3qf
         jCroGgYAB8sF/3PVdA6WWa0QJTD4mxcY9MVIULOM/7GJazl6p/EXGF0PxT6noXmi/dsX
         Prs4AJX03OPLiqdVfMtgkOQ7oiit1Bl4DMk4f/LBOyivNZTld9Cd45O1xjh06ZKu6mdA
         io3Q==
X-Gm-Message-State: AOAM530RETIJ7zfyviWBhnnTtIuPLRq3xNkcS9g3Ea1tBEW0i3rYMa5P
        F41WnYF2KmohtcpfItb9tjrEjqvCngJ+/X39LLrZ9R+o
X-Google-Smtp-Source: ABdhPJyGiYJwmJex9IFV4VwJskSjI8FHwO4mufC7+tFSl9rFkX2kq2DKPf/VY35BHhEb0fYcSpp7G6KTmsxIyGQriRg=
X-Received: by 2002:a5e:8a03:: with SMTP id d3mr1601460iok.38.1594852376253;
 Wed, 15 Jul 2020 15:32:56 -0700 (PDT)
MIME-Version: 1.0
References: <CAA85sZvKNXCo5bB5a6kKmsOUAiw+_daAVaSYqNW6QbSBJ0TcyQ@mail.gmail.com>
 <CAA85sZua6Q8UR7TfCGO0bV=VU0gKtqj-8o_mqH38RpKrwYZGtg@mail.gmail.com>
 <20200715133136.5f63360c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAA85sZu09Z4gydJ8rAO_Ey0zqx-8Lg28=fBJ=FxFnp6cetNd3g@mail.gmail.com>
 <CAA85sZtjCW2Yg+tXPgYyoFA5BKAVZC8kVKG=6SiR64c8ur8UcQ@mail.gmail.com>
 <20200715144017.47d06941@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <CAA85sZvnytPzpia_ROnkmJoZC8n4vUsrwTQh2UBs6u6g2Fgqxw@mail.gmail.com>
In-Reply-To: <CAA85sZvnytPzpia_ROnkmJoZC8n4vUsrwTQh2UBs6u6g2Fgqxw@mail.gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Wed, 15 Jul 2020 15:32:45 -0700
Message-ID: <CAKgT0UdwsmE=ygE2KObzM0z-0KgrPcr59JZzVk41F6-iqsSL+Q@mail.gmail.com>
Subject: Re: [Intel-wired-lan] NAT performance issue 944mbit -> ~40mbit
To:     Ian Kumlien <ian.kumlien@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 15, 2020 at 3:00 PM Ian Kumlien <ian.kumlien@gmail.com> wrote:
>
> On Wed, Jul 15, 2020 at 11:40 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > On Wed, 15 Jul 2020 23:12:23 +0200 Ian Kumlien wrote:
> > > On Wed, Jul 15, 2020 at 11:02 PM Ian Kumlien <ian.kumlien@gmail.com> wrote:
> > > > On Wed, Jul 15, 2020 at 10:31 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > > > > On Wed, 15 Jul 2020 22:05:58 +0200 Ian Kumlien wrote:
> > > > > > After a  lot of debugging it turns out that the bug is in igb...
> > > > > >
> > > > > > driver: igb
> > > > > > version: 5.6.0-k
> > > > > > firmware-version:  0. 6-1
> > > > > >
> > > > > > 03:00.0 Ethernet controller: Intel Corporation I211 Gigabit Network
> > > > > > Connection (rev 03)
> > > > >
> > > > > Unclear to me what you're actually reporting. Is this a regression
> > > > > after a kernel upgrade? Compared to no NAT?
> > > >
> > > > It only happens on "internet links"
> > > >
> > > > Lets say that A is client with ibg driver, B is a firewall running NAT
> > > > with ixgbe drivers, C is another local node with igb and
> > > > D is a remote node with a bridge backed by a bnx2 interface.
> > > >
> > > > A -> B -> C is ok (B and C is on the same switch)
> > > >
> > > > A -> B -> D -- 32-40mbit
> > > >
> > > > B -> D 944 mbit
> > > > C -> D 944 mbit
> > > >
> > > > A' -> D ~933 mbit (A with realtek nic -- also link is not idle atm)
> > >
> > > This should of course be A' -> B -> D
> > >
> > > Sorry, I've been scratching my head for about a week...
> >
> > Hm, only thing that comes to mind if A' works reliably and A doesn't is
> > that A has somehow broken TCP offloads. Could you try disabling things
> > via ethtool -K and see if those settings make a difference?
>
> It's a bit hard since it works like this, turned tso off:
> [ ID] Interval           Transfer     Bitrate         Retr  Cwnd
> [  5]   0.00-1.00   sec   108 MBytes   902 Mbits/sec    0    783 KBytes
> [  5]   1.00-2.00   sec   110 MBytes   923 Mbits/sec   31    812 KBytes
> [  5]   2.00-3.00   sec   111 MBytes   933 Mbits/sec   92    772 KBytes
> [  5]   3.00-4.00   sec   110 MBytes   923 Mbits/sec    0    834 KBytes
> [  5]   4.00-5.00   sec   111 MBytes   933 Mbits/sec   60    823 KBytes
> [  5]   5.00-6.00   sec   110 MBytes   923 Mbits/sec   31    789 KBytes
> [  5]   6.00-7.00   sec   111 MBytes   933 Mbits/sec    0    786 KBytes
> [  5]   7.00-8.00   sec   110 MBytes   923 Mbits/sec    0    761 KBytes
> [  5]   8.00-9.00   sec   110 MBytes   923 Mbits/sec    0    772 KBytes
> [  5]   9.00-10.00  sec   109 MBytes   912 Mbits/sec    0    868 KBytes
> - - - - - - - - - - - - - - - - - - - - - - - - -
> [ ID] Interval           Transfer     Bitrate         Retr
> [  5]   0.00-10.00  sec  1.07 GBytes   923 Mbits/sec  214             sender
> [  5]   0.00-10.00  sec  1.07 GBytes   920 Mbits/sec                  receiver
>
> Continued running tests:
> [ ID] Interval           Transfer     Bitrate         Retr  Cwnd
> [  5]   0.00-1.00   sec  5.82 MBytes  48.8 Mbits/sec    0   82.0 KBytes
> [  5]   1.00-2.00   sec  4.97 MBytes  41.7 Mbits/sec    0    130 KBytes
> [  5]   2.00-3.00   sec  5.28 MBytes  44.3 Mbits/sec    0   99.0 KBytes
> [  5]   3.00-4.00   sec  5.28 MBytes  44.3 Mbits/sec    0    105 KBytes
> [  5]   4.00-5.00   sec  5.28 MBytes  44.3 Mbits/sec    0    122 KBytes
> [  5]   5.00-6.00   sec  5.28 MBytes  44.3 Mbits/sec    0   82.0 KBytes
> [  5]   6.00-7.00   sec  5.28 MBytes  44.3 Mbits/sec    0   79.2 KBytes
> [  5]   7.00-8.00   sec  5.28 MBytes  44.3 Mbits/sec    0    110 KBytes
> [  5]   8.00-9.00   sec  5.28 MBytes  44.3 Mbits/sec    0    156 KBytes
> [  5]   9.00-10.00  sec  5.28 MBytes  44.3 Mbits/sec    0   87.7 KBytes
> - - - - - - - - - - - - - - - - - - - - - - - - -
> [ ID] Interval           Transfer     Bitrate         Retr
> [  5]   0.00-10.00  sec  53.0 MBytes  44.5 Mbits/sec    0             sender
> [  5]   0.00-10.00  sec  52.5 MBytes  44.1 Mbits/sec                  receiver
>
> [ ID] Interval           Transfer     Bitrate         Retr  Cwnd
> [  5]   0.00-1.00   sec  7.08 MBytes  59.4 Mbits/sec    0    156 KBytes
> [  5]   1.00-2.00   sec  5.97 MBytes  50.0 Mbits/sec    0    110 KBytes
> [  5]   2.00-3.00   sec  4.97 MBytes  41.7 Mbits/sec    0    124 KBytes
> [  5]   3.00-4.00   sec  5.47 MBytes  45.9 Mbits/sec    0   96.2 KBytes
> [  5]   4.00-5.00   sec  5.47 MBytes  45.9 Mbits/sec    0    158 KBytes
> [  5]   5.00-6.00   sec  4.97 MBytes  41.7 Mbits/sec    0   70.7 KBytes
> [  5]   6.00-7.00   sec  5.47 MBytes  45.9 Mbits/sec    0    113 KBytes
> [  5]   7.00-8.00   sec  5.47 MBytes  45.9 Mbits/sec    0   96.2 KBytes
> [  5]   8.00-9.00   sec  4.97 MBytes  41.7 Mbits/sec    0   84.8 KBytes
> [  5]   9.00-10.00  sec  5.47 MBytes  45.9 Mbits/sec    0    116 KBytes
> - - - - - - - - - - - - - - - - - - - - - - - - -
> [ ID] Interval           Transfer     Bitrate         Retr
> [  5]   0.00-10.00  sec  55.3 MBytes  46.4 Mbits/sec    0             sender
> [  5]   0.00-10.00  sec  53.9 MBytes  45.2 Mbits/sec                  receiver
>
> And the low bandwidth continues with:
> ethtool -k enp3s0 |grep ": on"
> rx-vlan-offload: on
> tx-vlan-offload: on [requested off]
> highdma: on [fixed]
> rx-vlan-filter: on [fixed]
> tx-gre-segmentation: on
> tx-gre-csum-segmentation: on
> tx-ipxip4-segmentation: on
> tx-ipxip6-segmentation: on
> tx-udp_tnl-segmentation: on
> tx-udp_tnl-csum-segmentation: on
> tx-gso-partial: on
> tx-udp-segmentation: on
> hw-tc-offload: on
>
> Can't quite find how to turn those off since they aren't listed in
> ethtool (since the text is not what you use to enable/disable)

To disable them you would just repeat the same string in the display
string. So it should just be "ethtool -K enp3s0 tx-gso-partial off"
and that would turn off a large chunk of them as all the encapsulated
support requires gso partial support.

> I was hoping that you'd have a clue of something that might introduce
> a regression - ie specific patches to try to revert
>
> Btw, the same issue applies to udp as werll
>
> [ ID] Interval           Transfer     Bitrate         Total Datagrams
> [  5]   0.00-1.00   sec  6.77 MBytes  56.8 Mbits/sec  4900
> [  5]   1.00-2.00   sec  4.27 MBytes  35.8 Mbits/sec  3089
> [  5]   2.00-3.00   sec  4.20 MBytes  35.2 Mbits/sec  3041
> [  5]   3.00-4.00   sec  4.30 MBytes  36.1 Mbits/sec  3116
> [  5]   4.00-5.00   sec  4.24 MBytes  35.6 Mbits/sec  3070
> [  5]   5.00-6.00   sec  4.21 MBytes  35.3 Mbits/sec  3047
> [  5]   6.00-7.00   sec  4.29 MBytes  36.0 Mbits/sec  3110
> [  5]   7.00-8.00   sec  4.28 MBytes  35.9 Mbits/sec  3097
> [  5]   8.00-9.00   sec  4.25 MBytes  35.6 Mbits/sec  3075
> [  5]   9.00-10.00  sec  4.20 MBytes  35.2 Mbits/sec  3039
> - - - - - - - - - - - - - - - - - - - - - - - - -
> [ ID] Interval           Transfer     Bitrate         Jitter
> Lost/Total Datagrams
> [  5]   0.00-10.00  sec  45.0 MBytes  37.7 Mbits/sec  0.000 ms
> 0/32584 (0%)  sender
> [  5]   0.00-10.00  sec  45.0 MBytes  37.7 Mbits/sec  0.037 ms
> 0/32573 (0%)  receiver
>
> vs:
>
> [ ID] Interval           Transfer     Bitrate         Total Datagrams
> [  5]   0.00-1.00   sec   114 MBytes   954 Mbits/sec  82342
> [  5]   1.00-2.00   sec   114 MBytes   955 Mbits/sec  82439
> [  5]   2.00-3.00   sec   114 MBytes   956 Mbits/sec  82507
> [  5]   3.00-4.00   sec   114 MBytes   955 Mbits/sec  82432
> [  5]   4.00-5.00   sec   114 MBytes   956 Mbits/sec  82535
> [  5]   5.00-6.00   sec   114 MBytes   953 Mbits/sec  82240
> [  5]   6.00-7.00   sec   114 MBytes   956 Mbits/sec  82512
> [  5]   7.00-8.00   sec   114 MBytes   956 Mbits/sec  82503
> [  5]   8.00-9.00   sec   114 MBytes   956 Mbits/sec  82532
> [  5]   9.00-10.00  sec   114 MBytes   956 Mbits/sec  82488
> - - - - - - - - - - - - - - - - - - - - - - - - -
> [ ID] Interval           Transfer     Bitrate         Jitter
> Lost/Total Datagrams
> [  5]   0.00-10.00  sec  1.11 GBytes   955 Mbits/sec  0.000 ms
> 0/824530 (0%)  sender
> [  5]   0.00-10.01  sec  1.11 GBytes   949 Mbits/sec  0.014 ms
> 4756/824530 (0.58%)  receiver

The fact that it is impacting UDP seems odd. I wonder if we don't have
a qdisc somewhere that is misbehaving and throttling the Tx. Either
that or I wonder if we are getting spammed with flow control frames.

It would be useful to include the output of just calling "ethtool
enp3s0" on the interface to verify the speed, "ethtool -a enp3s0" to
verify flow control settings, and "ethtool -S enp3s0 | grep -v :\ 0"
to output the statistics and dump anything that isn't zero.

> lspci -s 03:00.0  -vvv
> 03:00.0 Ethernet controller: Intel Corporation I211 Gigabit Network
> Connection (rev 03)
> Subsystem: ASUSTeK Computer Inc. I211 Gigabit Network Connection
> Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx+
> Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> Latency: 0
> Interrupt: pin A routed to IRQ 57
> IOMMU group: 20
> Region 0: Memory at fc900000 (32-bit, non-prefetchable) [size=128K]
> Region 2: I/O ports at e000 [size=32]
> Region 3: Memory at fc920000 (32-bit, non-prefetchable) [size=16K]
> Capabilities: [40] Power Management version 3
> Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
> Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=1 PME-
> Capabilities: [50] MSI: Enable- Count=1/1 Maskable+ 64bit+
> Address: 0000000000000000  Data: 0000
> Masking: 00000000  Pending: 00000000
> Capabilities: [70] MSI-X: Enable+ Count=5 Masked-
> Vector table: BAR=3 offset=00000000
> PBA: BAR=3 offset=00002000
> Capabilities: [a0] Express (v2) Endpoint, MSI 00
> DevCap: MaxPayload 512 bytes, PhantFunc 0, Latency L0s <512ns, L1 <64us
> ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset+ SlotPowerLimit 0.000W
> DevCtl: CorrErr+ NonFatalErr+ FatalErr+ UnsupReq+
> RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+ FLReset-
> MaxPayload 128 bytes, MaxReadReq 512 bytes
> DevSta: CorrErr- NonFatalErr- FatalErr- UnsupReq- AuxPwr+ TransPend-
> LnkCap: Port #3, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit Latency
> L0s <2us, L1 <16us
> ClockPM- Surprise- LLActRep- BwNot- ASPMOptComp+
> LnkCtl: ASPM L1 Enabled; RCB 64 bytes, Disabled- CommClk+
> ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
> LnkSta: Speed 2.5GT/s (ok), Width x1 (ok)
> TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-

PCIe wise the connection is going to be pretty tight in terms of
bandwidth. It looks like we have 2.5GT/s with only a single lane of
PCIe. In addition we are running with ASPM enabled so that means that
if we don't have enough traffic we are shutting off the one PCIe lane
we have so if we are getting bursty traffic that can get ugly.
