Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C63D443F671
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 07:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231724AbhJ2FHc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 01:07:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbhJ2FHc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 01:07:32 -0400
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E68FDC061570
        for <netdev@vger.kernel.org>; Thu, 28 Oct 2021 22:05:03 -0700 (PDT)
Received: by mail-qt1-x832.google.com with SMTP id h14so7253242qtb.3
        for <netdev@vger.kernel.org>; Thu, 28 Oct 2021 22:05:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iO5fcUYT5TXFk3gvzMEeFMOo4hqb5az/CyaZciTI7zM=;
        b=AJVG/LvvvJQF0Xp91yAZxdTpCarPXivw6dmAdaSfXz5iab0vIcVKyaPeZEH9K/8M9O
         2l2wCI9pIzZzIKll6wSmARdoaVu+ll3O6JemEbivCyRgKASHTcjFls3FJtG6RsUWQWEe
         Xq/DIRHM65uoF4vck0qSfBiiZSjzzWXrUK720=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iO5fcUYT5TXFk3gvzMEeFMOo4hqb5az/CyaZciTI7zM=;
        b=24Kg63QUUfshL8KP/HBlATq2T6dHmonYtD9ZKVUkqEQgB93PCZVGsjpYDjg0EyXHlQ
         V427rOJ7CEQcNl3xbv6SjqQ6/hdsNGwRH5WSNEkJ8M92pnfdT1CwwiS66fpy60DTmrd5
         97jugs7Pf8W/d6DiUc+HMRKUPuSsiDu+HQ/vOmh+WWx5MbFJEb2n1/NTIRq1XzXoaLAK
         YFXp4qJNmUvJXlfcfzoInMiksnps4YYs4Q52dRHS0HCXyee5z59WtF0VNEfcJ0EoJ1L4
         gBWbK96mS9LsQ65NALUhOUYtMMNE87yX8ZChdOVUb+wZbYs6fOB2eCID7tArpYCJi6e6
         cgnQ==
X-Gm-Message-State: AOAM531dXUFQZNymsON+LHHaJgROP1PnisSF07Rceu4PWTeCJGD7Ws4f
        xrlt/qjp4qIGqyfdQ/npzzqn8grMHyhuk4ub+brSxg==
X-Google-Smtp-Source: ABdhPJyHZgPMK3943gNLuPrucyrH6q6s6fcKexVreQ9ehajJkHtMoSs8igJSWK+e92MNYSppwNzOchUNJjUFOD8gcN4=
X-Received: by 2002:ac8:5a4d:: with SMTP id o13mr9551738qta.330.1635483902583;
 Thu, 28 Oct 2021 22:05:02 -0700 (PDT)
MIME-Version: 1.0
References: <0a1d6421-b618-9fea-9787-330a18311ec0@bursov.com>
 <CAMet4B4iJjQK6yX+XBD2CtH3B30oqECUAYDj3ZE3ysdJVu8O4w@mail.gmail.com>
 <CALs4sv2YVu0euy5-stBNuES3Bf2SR7MtiD0TJDfGmTLAiUONSA@mail.gmail.com>
 <02400c1a-e626-d6c3-ecfd-3b9e9e4b6988@bursov.com> <CALs4sv3XOTBKCxaUieYosMdXuuqiuHT5Gbhz8oixGv2XGw4+Ug@mail.gmail.com>
 <a5c6e92f-cc59-0214-56f6-66632c5e59c2@bursov.com>
In-Reply-To: <a5c6e92f-cc59-0214-56f6-66632c5e59c2@bursov.com>
From:   Pavan Chebbi <pavan.chebbi@broadcom.com>
Date:   Fri, 29 Oct 2021 10:34:50 +0530
Message-ID: <CALs4sv2PWbijor=7aU4oh=yipYo2OMD79wMqEGfj3c4Lw9uycA@mail.gmail.com>
Subject: Re: tg3 RX packet re-order in queue 0 with RSS
To:     Vitaly Bursov <vitaly@bursov.com>
Cc:     Siva Reddy Kallam <siva.kallam@broadcom.com>,
        Prashant Sreedharan <prashant@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        Linux Netdev List <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

90On Thu, Oct 28, 2021 at 9:11 PM Vitaly Bursov <vitaly@bursov.com> wrote:
>
>
> 28.10.2021 10:33, Pavan Chebbi wrote:
> > On Wed, Oct 27, 2021 at 4:02 PM Vitaly Bursov <vitaly@bursov.com> wrote:
> >>
> >>
> >> 27.10.2021 12:30, Pavan Chebbi wrote:
> >>> On Wed, Sep 22, 2021 at 12:10 PM Siva Reddy Kallam
> >>> <siva.kallam@broadcom.com> wrote:
> >>>>
> >>>> Thank you for reporting this. Pavan(cc'd) from Broadcom looking into this issue.
> >>>> We will provide our feedback very soon on this.
> >>>>
> >>>> On Mon, Sep 20, 2021 at 6:59 PM Vitaly Bursov <vitaly@bursov.com> wrote:
> >>>>>
> >>>>> Hi,
> >>>>>
> >>>>> We found a occassional and random (sometimes happens, sometimes not)
> >>>>> packet re-order when NIC is involved in UDP multicast reception, which
> >>>>> is sensitive to a packet re-order. Network capture with tcpdump
> >>>>> sometimes shows the packet re-order, sometimes not (e.g. no re-order on
> >>>>> a host, re-order in a container at the same time). In a pcap file
> >>>>> re-ordered packets have a correct timestamp - delayed packet had a more
> >>>>> earlier timestamp compared to a previous packet:
> >>>>>        1.00s packet1
> >>>>>        1.20s packet3
> >>>>>        1.10s packet2
> >>>>>        1.30s packet4
> >>>>>
> >>>>> There's about 300Mbps of traffic on this NIC, and server is busy
> >>>>> (hyper-threading enabled, about 50% overall idle) with its
> >>>>> computational application work.
> >>>>>
> >>>>> NIC is HPE's 4-port 331i adapter - BCM5719, in a default ring and
> >>>>> coalescing configuration, 1 TX queue, 4 RX queues.
> >>>>>
> >>>>> After further investigation, I believe that there are two separate
> >>>>> issues in tg3.c driver. Issues can be reproduced with iperf3, and
> >>>>> unicast UDP.
> >>>>>
> >>>>> Here are the details of how I understand this behavior.
> >>>>>
> >>>>> 1. Packet re-order.
> >>>>>
> >>>>> Driver calls napi_schedule(&tnapi->napi) when handling the interrupt,
> >>>>> however, sometimes it calls napi_schedule(&tp->napi[1].napi), which
> >>>>> handles RX queue 0 too:
> >>>>>
> >>>>>        https://github.com/torvalds/linux/blob/master/drivers/net/ethernet/broadcom/tg3.c#L6802-L7007
> >>>>>
> >>>>>        static int tg3_rx(struct tg3_napi *tnapi, int budget)
> >>>>>        {
> >>>>>                struct tg3 *tp = tnapi->tp;
> >>>>>
> >>>>>                ...
> >>>>>
> >>>>>                /* Refill RX ring(s). */
> >>>>>                if (!tg3_flag(tp, ENABLE_RSS)) {
> >>>>>                        ....
> >>>>>                } else if (work_mask) {
> >>>>>                        ...
> >>>>>
> >>>>>                        if (tnapi != &tp->napi[1]) {
> >>>>>                                tp->rx_refill = true;
> >>>>>                                napi_schedule(&tp->napi[1].napi);
> >>>>>                        }
> >>>>>                }
> >>>>>                ...
> >>>>>        }
> >>>>>
> >>>>>    From napi_schedule() code, it should schedure RX 0 traffic handling on
> >>>>> a current CPU, which handles queues RX1-3 right now.
> >>>>>
> >>>>> At least two traffic flows are required - one on RX queue 0, and the
> >>>>> other on any other queue (1-3). Re-ordering may happend only on flow
> >>>>> from queue 0, the second flow will work fine.
> >>>>>
> >>>>> No idea how to fix this.
> >>>
> >>> In the case of RSS the actual rings for RX are from 1 to 4.
> >>> The napi of those rings are indeed processing the packets.
> >>> The explicit napi_schedule of napi[1] is only re-filling rx BD
> >>> producer ring because it is shared with return rings for 1-4.
> >>> I tried to repro this but I am not seeing the issue. If you are
> >>> receiving packets on RX 0 then the RSS must have been disabled.
> >>> Can you please check?
> >>>
> >>
> >> # ethtool -i enp2s0f0
> >> driver: tg3
> >> version: 3.137
> >> firmware-version: 5719-v1.46 NCSI v1.5.18.0
> >> expansion-rom-version:
> >> bus-info: 0000:02:00.0
> >> supports-statistics: yes
> >> supports-test: yes
> >> supports-eeprom-access: yes
> >> supports-register-dump: yes
> >> supports-priv-flags: no
> >>
> >> # ethtool -l enp2s0f0
> >> Channel parameters for enp2s0f0:
> >> Pre-set maximums:
> >> RX:             4
> >> TX:             4
> >> Other:          0
> >> Combined:       0
> >> Current hardware settings:
> >> RX:             4
> >> TX:             1
> >> Other:          0
> >> Combined:       0
> >>
> >> # ethtool -x enp2s0f0
> >> RX flow hash indirection table for enp2s0f0 with 4 RX ring(s):
> >>       0:      0     1     2     3     0     1     2     3
> >>       8:      0     1     2     3     0     1     2     3
> >>      16:      0     1     2     3     0     1     2     3
> >>      24:      0     1     2     3     0     1     2     3
> >>      32:      0     1     2     3     0     1     2     3
> >>      40:      0     1     2     3     0     1     2     3
> >>      48:      0     1     2     3     0     1     2     3
> >>      56:      0     1     2     3     0     1     2     3
> >>      64:      0     1     2     3     0     1     2     3
> >>      72:      0     1     2     3     0     1     2     3
> >>      80:      0     1     2     3     0     1     2     3
> >>      88:      0     1     2     3     0     1     2     3
> >>      96:      0     1     2     3     0     1     2     3
> >>     104:      0     1     2     3     0     1     2     3
> >>     112:      0     1     2     3     0     1     2     3
> >>     120:      0     1     2     3     0     1     2     3
> >> RSS hash key:
> >> Operation not supported
> >> RSS hash function:
> >>       toeplitz: on
> >>       xor: off
> >>       crc32: off
> >>
> >> In /proc/interrupts there are enp2s0f0-tx-0, enp2s0f0-rx-1,
> >> enp2s0f0-rx-2, enp2s0f0-rx-3, enp2s0f0-rx-4 interrupts, all on
> >> different CPU cores. Kernel also has "threadirqs" enabled in
> >> command line, I didn't check if this parameter affects the issue.
> >>
> >> Yes, some things start with 0, and others with 1, sorry for a confusion
> >> in terminology, what I meant:
> >>    - There are 4 RX rings/queues, I counted starting from 0, so: 0..3.
> >>      RX0 is the first queue/ring that actually receives the traffic.
> >>      RX0 is handled by enp2s0f0-rx-1 interrupt.
> >>    - These are related to (tp->napi[i]), but i is in 1..4, so the first
> >>      receiving queue relates to tp->napi[1], the second relates to
> >>      tp->napi[2], and so on. Correct?
> >>
> >> Suppose, tg3_rx() is called for tp->napi[2], this function most likely
> >> calls napi_gro_receive(&tnapi->napi, skb) to further process packets in
> >> tp->napi[2]. And, under some conditions (RSS and work_mask), it calls
> >> napi_schedule(&tp->napi[1].napi), which schedules tp->napi[1] work
> >> on a currect CPU, which is designated for tp->napi[2], but not for
> >> tp->napi[1]. Correct?
> >>
> >> I don't understand what napi_schedule(&tp->napi[1].napi) does for the
> >> NIC or driver, "re-filling rx BD producer ring" sounds important. I
> >> suspect something will break badly if I simply remove it without
> >> replacing with something more elaborate. I guess along with re-filling
> >> rx BD producer ring it also can process incoming packets. Is it possible?
> >>
> >
> > Yes, napi[1] work may be called on the napi[2]'s CPU but it generally
> > won't process
> > any rx packets because the producer index of napi[1] has not changed. If the
> > producer count did change, then we get a poll from the ISR for napi[1]
> > to process
> > packets. So it is mostly used to re-fill rx buffers when called
> > explicitly. However
> > there could be a small window where the prod index is incremented but the ISR
> > is not fired yet. It may process some small no of packets. But I don't
> > think this
> > should lead to a reorder problem.
> >
>
> I tried to reproduce without using bridge and veth interfaces, and it seems
> like it's not reproducible, so traffic forwarding via a bridge interface may
> be necessary. It also does not happen if traffic load is low, but moderate
> load is enough - e.g. two 100 Mbps streams with 130-byte packets. It's easier
> to reproduce with a higher load.
>
> With about the same setup as in an original message (bridge + veth 2
> network namespaces), irqbalance daemon stopped, if traffic flows via
> enp2s0f0-rx-2 and enp2s0f0-rx-4, there's no reordering. enp2s0f0-rx-1
> still gets some interrupts, but at a much lower rate compared to 2 and
> 4.
>
> namespace 1:
>    # iperf3 -u -c server_ip -p 5000 -R -b 300M -t 300 -l 130
>    - - - - - - - - - - - - - - - - - - - - - - - - -
>    [ ID] Interval           Transfer     Bandwidth       Jitter    Lost/Total Datagrams
>    [  4]   0.00-300.00 sec  6.72 GBytes   192 Mbits/sec  0.008 ms  3805/55508325 (0.0069%)
>    [  4] Sent 55508325 datagrams
>
>    iperf Done.
>
> namespace 2:
>    # iperf3 -u -c server_ip -p 5001 -R -b 300M -t 300 -l 130
>    - - - - - - - - - - - - - - - - - - - - - - - - -
>    [ ID] Interval           Transfer     Bandwidth       Jitter    Lost/Total Datagrams
>    [  4]   0.00-300.00 sec  6.83 GBytes   196 Mbits/sec  0.005 ms  3873/56414001 (0.0069%)
>    [  4] Sent 56414001 datagrams
>
>    iperf Done.
>
>
> With the same configuration but different IP address so that instead of
> enp2s0f0-rx-4 enp2s0f0-rx-1 would be used, there is a reordering.
>
>
> namespace 1 (client IP was changed):
>    # iperf3 -u -c server_ip -p 5000 -R -b 300M -t 300 -l 130
>    - - - - - - - - - - - - - - - - - - - - - - - - -
>    [ ID] Interval           Transfer     Bandwidth       Jitter    Lost/Total Datagrams
>    [  4]   0.00-300.00 sec  6.32 GBytes   181 Mbits/sec  0.007 ms  8506/52172059 (0.016%)
>    [  4] Sent 52172059 datagrams
>    [SUM]  0.0-300.0 sec  2452 datagrams received out-of-order
>
>    iperf Done.
>
> namespace 2:
>    # iperf3 -u -c server_ip -p 5001 -R -b 300M -t 300 -l 130
>    - - - - - - - - - - - - - - - - - - - - - - - - -
>    [ ID] Interval           Transfer     Bandwidth       Jitter    Lost/Total Datagrams
>    [  4]   0.00-300.00 sec  6.59 GBytes   189 Mbits/sec  0.006 ms  6302/54463973 (0.012%)
>    [  4] Sent 54463973 datagrams
>
>    iperf Done.
>
> Swapping IP addresses in these namespaces also changes the namespace exhibiting the issue,
> it's following the IP address.
>
>
> Is there something I could check to confirm that this behavior is or is not
> related to napi_schedule(&tp->napi[1].napi) call?

in the function tg3_msi_1shot() you could store the cpu assigned to
tnapi1 (inside the struct tg3_napi)
and then in tg3_poll_work() you can add another check after
        if (*(tnapi->rx_rcb_prod_idx) != tnapi->rx_rcb_ptr)
something like
if (tnapi == &tp->napi[1] && tnapi->assigned_cpu == smp_processor_id())
only then execute tg3_rx()

This may stop tnapi 1 from reading rx pkts on the current CPU from
which refill is called.

>
> --
> Thanks
> Vitalii
