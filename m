Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D04B643C670
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 11:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240912AbhJ0JdA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 05:33:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230195AbhJ0Jcy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 05:32:54 -0400
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B30A2C061570
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 02:30:28 -0700 (PDT)
Received: by mail-qv1-xf2a.google.com with SMTP id jk5so1321802qvb.9
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 02:30:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pTTUNH/gU/3eflJ7B6gEQsJQnH0g4cg6t0ffmbPocQE=;
        b=A6TfcLgPcJSwZnIuXbr+2qkqV1kjNZoQOBGnnsp8cXQ4unLJ3szL7Kk/IJgX9fUV5h
         Cw3/qiu5MKVri32qlg6QIzmuB/erct9SNfjONguoJJKTKdyvbsRsrVr1QWkOCYjUNMUq
         2wFXAiK5eIwN88khtZZobZBfvoqLq9NLEqeFQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pTTUNH/gU/3eflJ7B6gEQsJQnH0g4cg6t0ffmbPocQE=;
        b=xhj4dy2N+Yzxw+wDCxfJt5M6V3f4nehGKM+2vmGP8+o5VDCI1rIwAenvSlphGhRluB
         INpvGSPn0G08q7ft2YpRqG3TOSX2pOHrRFZ3PCqNd5f0ji6yCCBOAPQuyklpr51Ino+B
         eJS1esxA9k2h1nDaT+N0NviiuHKu7K9hLhMbtG6omKY3YdpbJ6OSKv/t6SOTBesny0Bs
         q74oKMJTkFhYWt8zB9/wpAwwJKeMl1uKiwdgBAVWOPDApJGP3GbUBLtcX5zGbY6U7XBg
         jkvZpJcFNH88ofzs+KJ3tMh50Fgrf3qwHW0N5vb79oqU7Ov8mnloM1pDLNsgE00teJYC
         zT2w==
X-Gm-Message-State: AOAM531gO+6p/BfIIhZF19y4S2nspU8L6uRV6kgsH0dQRFGsgADnXCUo
        7uEjdDlSdNPbOUNCbNzNPxxe+zKLf+XwgOTOivuXew==
X-Google-Smtp-Source: ABdhPJxkYM//2S2rEXyx7WW/IqlRXmDejEYGJumfs5VuSvV6Kq/4s/BLOBjVPd/LbVorG40AcTsKRJyTXpALmBkdmRw=
X-Received: by 2002:ad4:4e66:: with SMTP id ec6mr6976882qvb.48.1635327027563;
 Wed, 27 Oct 2021 02:30:27 -0700 (PDT)
MIME-Version: 1.0
References: <0a1d6421-b618-9fea-9787-330a18311ec0@bursov.com> <CAMet4B4iJjQK6yX+XBD2CtH3B30oqECUAYDj3ZE3ysdJVu8O4w@mail.gmail.com>
In-Reply-To: <CAMet4B4iJjQK6yX+XBD2CtH3B30oqECUAYDj3ZE3ysdJVu8O4w@mail.gmail.com>
From:   Pavan Chebbi <pavan.chebbi@broadcom.com>
Date:   Wed, 27 Oct 2021 15:00:16 +0530
Message-ID: <CALs4sv2YVu0euy5-stBNuES3Bf2SR7MtiD0TJDfGmTLAiUONSA@mail.gmail.com>
Subject: Re: tg3 RX packet re-order in queue 0 with RSS
To:     Siva Reddy Kallam <siva.kallam@broadcom.com>
Cc:     Vitaly Bursov <vitaly@bursov.com>,
        Prashant Sreedharan <prashant@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        Linux Netdev List <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 22, 2021 at 12:10 PM Siva Reddy Kallam
<siva.kallam@broadcom.com> wrote:
>
> Thank you for reporting this. Pavan(cc'd) from Broadcom looking into this issue.
> We will provide our feedback very soon on this.
>
> On Mon, Sep 20, 2021 at 6:59 PM Vitaly Bursov <vitaly@bursov.com> wrote:
> >
> > Hi,
> >
> > We found a occassional and random (sometimes happens, sometimes not)
> > packet re-order when NIC is involved in UDP multicast reception, which
> > is sensitive to a packet re-order. Network capture with tcpdump
> > sometimes shows the packet re-order, sometimes not (e.g. no re-order on
> > a host, re-order in a container at the same time). In a pcap file
> > re-ordered packets have a correct timestamp - delayed packet had a more
> > earlier timestamp compared to a previous packet:
> >      1.00s packet1
> >      1.20s packet3
> >      1.10s packet2
> >      1.30s packet4
> >
> > There's about 300Mbps of traffic on this NIC, and server is busy
> > (hyper-threading enabled, about 50% overall idle) with its
> > computational application work.
> >
> > NIC is HPE's 4-port 331i adapter - BCM5719, in a default ring and
> > coalescing configuration, 1 TX queue, 4 RX queues.
> >
> > After further investigation, I believe that there are two separate
> > issues in tg3.c driver. Issues can be reproduced with iperf3, and
> > unicast UDP.
> >
> > Here are the details of how I understand this behavior.
> >
> > 1. Packet re-order.
> >
> > Driver calls napi_schedule(&tnapi->napi) when handling the interrupt,
> > however, sometimes it calls napi_schedule(&tp->napi[1].napi), which
> > handles RX queue 0 too:
> >
> >      https://github.com/torvalds/linux/blob/master/drivers/net/ethernet/broadcom/tg3.c#L6802-L7007
> >
> >      static int tg3_rx(struct tg3_napi *tnapi, int budget)
> >      {
> >              struct tg3 *tp = tnapi->tp;
> >
> >              ...
> >
> >              /* Refill RX ring(s). */
> >              if (!tg3_flag(tp, ENABLE_RSS)) {
> >                      ....
> >              } else if (work_mask) {
> >                      ...
> >
> >                      if (tnapi != &tp->napi[1]) {
> >                              tp->rx_refill = true;
> >                              napi_schedule(&tp->napi[1].napi);
> >                      }
> >              }
> >              ...
> >      }
> >
> >  From napi_schedule() code, it should schedure RX 0 traffic handling on
> > a current CPU, which handles queues RX1-3 right now.
> >
> > At least two traffic flows are required - one on RX queue 0, and the
> > other on any other queue (1-3). Re-ordering may happend only on flow
> > from queue 0, the second flow will work fine.
> >
> > No idea how to fix this.

In the case of RSS the actual rings for RX are from 1 to 4.
The napi of those rings are indeed processing the packets.
The explicit napi_schedule of napi[1] is only re-filling rx BD
producer ring because it is shared with return rings for 1-4.
I tried to repro this but I am not seeing the issue. If you are
receiving packets on RX 0 then the RSS must have been disabled.
Can you please check?


> >
> > There are two ways to mitigate this:
> >
> >    1. Enable RPS by writting any non-zero mask to
> >       /sys/class/net/enp2s0f0/queues/rx-0/rps_cpus This encorces CPU
> >       when processing traffic, and overrides whatever "current" CPU for
> >       RX queue 0 is in this moment.
> >
> >    2. Configure RX hash flow redirection with: ethtool -X enp2s0f0
> >       weight 0 1 1 1 to exclude RX queue 0 from handling the traffic.
> >
> >
> > 2. RPS configuration
> >
> > Before napi_gro_receive() call, there's no call to skb_record_rx_queue():
> >
> >      static int tg3_rx(struct tg3_napi *tnapi, int budget)
> >      {
> >              struct tg3 *tp = tnapi->tp;
> >              u32 work_mask, rx_std_posted = 0;
> >              u32 std_prod_idx, jmb_prod_idx;
> >              u32 sw_idx = tnapi->rx_rcb_ptr;
> >              u16 hw_idx;
> >              int received;
> >              struct tg3_rx_prodring_set *tpr = &tnapi->prodring;
> >
> >              ...
> >
> >                      napi_gro_receive(&tnapi->napi, skb);
> >
> >
> >                      received++;
> >                      budget--;
> >              ...
> >
> >
> > As a result, queue_mapping is always 0/not set, and RPS handles all
> > traffic as originating from queue 0.
> >
> >            <idle>-0     [013] ..s. 14030782.234664: napi_gro_receive_entry: dev=enp2s0f0 napi_id=0x0 queue_mapping=0 ...
> >
> > RPS configuration for rx-1 to to rx-3 has no effect.

OK I think we could add a patch to update skb with queue mapping. I
will discuss it internally.

> >
> >
> > NIC:
> > 02:00.0 Ethernet controller: Broadcom Inc. and subsidiaries NetXtreme BCM5719 Gigabit Ethernet PCIe (rev 01)
> >      Subsystem: Hewlett-Packard Company Ethernet 1Gb 4-port 331i Adapter
> >      Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx+
> >      Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> >      Latency: 0, Cache Line Size: 64 bytes
> >      Interrupt: pin A routed to IRQ 16
> >      NUMA node: 0
> >      Region 0: Memory at d9d90000 (64-bit, prefetchable) [size=64K]
> >      Region 2: Memory at d9da0000 (64-bit, prefetchable) [size=64K]
> >      Region 4: Memory at d9db0000 (64-bit, prefetchable) [size=64K]
> >      [virtual] Expansion ROM at d9c00000 [disabled] [size=256K]
> >      Capabilities: <access denied>
> >      Kernel driver in use: tg3
> >      Kernel modules: tg3
> >
> > Linux kernel:
> >      CentOS 7 - 3.10.0-1160.15.2
> >      Ubuntu - 5.4.0-80.90
> >
> > Network configuration:
> >      iperf3 (sender) - [LAN] - NIC (enp2s0f0) - Bridge (br0) - veth (v1) - namespace veth (v2) - iperf3 (receiver 1)
> >
> >      brctl addbr br0
> >      ip l set up dev br0
> >      ip a a 10.10.10.10/24 dev br0
> >      ip r a default via 10.10.10.1 dev br0
> >      ip l set dev enp2s0f0 master br0
> >      ip l set up dev enp2s0f0
> >
> >      ip netns add n1
> >      ip link add v1 type veth peer name v2
> >      ip l set up dev v1
> >      ip l set dev v1 master br0
> >      ip l set dev v2 netns n1
> >
> >      ip netns exec n1 bash
> >      ip l set up dev lo
> >      ip l set up dev v2
> >      ip a a 10.10.10.11/24 dev v2
> >
> >      "receiver 2" has the same configuration but different IP and different namespace.
> >
> > Iperf3:
> >
> >      Sender runs iperfs: iperf3 -s -p 5201 & iperf3 -s -p 5202 &
> >      Receiver's iperf3 -c 10.10.10.1 -R -p 5201 -u -l 163 -b 200M -t 300
> >
> > --
> > Thanks
> > Vitalii
> >
