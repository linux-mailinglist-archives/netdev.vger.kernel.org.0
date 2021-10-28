Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0B6F43DC18
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 09:34:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbhJ1Hgg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 03:36:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbhJ1Hgf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 03:36:35 -0400
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BCAEC061570
        for <netdev@vger.kernel.org>; Thu, 28 Oct 2021 00:34:09 -0700 (PDT)
Received: by mail-qv1-xf2c.google.com with SMTP id v10so3451608qvb.10
        for <netdev@vger.kernel.org>; Thu, 28 Oct 2021 00:34:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dD5+5xKsQ5Ly5sVdS+uAIPIsmXNATkPobXazHeJHmXc=;
        b=iPQf7KHG4xi6RtOS/soZ8Mv+e/KvE+wGH9IFzYjp6N4QPKNqubDi5QKRJwoYiAFpVE
         2/XPJrqaZPCxRgIUVvUXLO8ztXIHMoCaxsYTlKe2iGmGnaN+7Io8Ul4rpw78Kbsm2uL9
         CFi04S3dl5GBnXykc9/QFDJPYTLQMaCrftHhE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dD5+5xKsQ5Ly5sVdS+uAIPIsmXNATkPobXazHeJHmXc=;
        b=TQ/0AvFlyYL+h6rAWy5A+V+cRsFtikspia5oO2PrOd+5oGBYBty57ASkhbkhvpmg/B
         1ldkF5DNxStrEfPgD6DMZpHuM9usZnad3OFzRGxpbTY8cDP1IqCcwuObAfc+fvvyM0ZA
         fuTU0fnAf9ivFnutJzF2WI5Dr8+eUkZC5VqLQsBYpw3dijyFI73TQron2sOKYun+3FCh
         py/RMwNvqWMcUdxLQ7A0BSDcKy4rgyupCh3dbEYCBcBOTV4k1rTQTVXM6I8qe/PQH4J6
         JKgIqkfWMZMbEG+IcAXVDeERxeV7MFJ9niY8B1vVBaaHw1yv12uhJib2WlLiKGZz5QQ3
         A8UQ==
X-Gm-Message-State: AOAM533qHRqedVMTYq0aj/ZXXMYbbthiDCeUqW2V/faQLda/bjWUMUHV
        caE7+TWsgBOjqwwM7ilubdb4Qc8v9d9/zKHRySQokBxXyW/uwxKz
X-Google-Smtp-Source: ABdhPJzUKqUIinsvos9Z5+THHTY3PjJnX1xblNIEuIf/a5Z1T5H5YOD56N4dVowUES1v1msLsxJ2DVEDHqnkJmA77Ug=
X-Received: by 2002:a05:6214:c47:: with SMTP id r7mr2267274qvj.47.1635406448093;
 Thu, 28 Oct 2021 00:34:08 -0700 (PDT)
MIME-Version: 1.0
References: <0a1d6421-b618-9fea-9787-330a18311ec0@bursov.com>
 <CAMet4B4iJjQK6yX+XBD2CtH3B30oqECUAYDj3ZE3ysdJVu8O4w@mail.gmail.com>
 <CALs4sv2YVu0euy5-stBNuES3Bf2SR7MtiD0TJDfGmTLAiUONSA@mail.gmail.com> <02400c1a-e626-d6c3-ecfd-3b9e9e4b6988@bursov.com>
In-Reply-To: <02400c1a-e626-d6c3-ecfd-3b9e9e4b6988@bursov.com>
From:   Pavan Chebbi <pavan.chebbi@broadcom.com>
Date:   Thu, 28 Oct 2021 13:03:57 +0530
Message-ID: <CALs4sv3XOTBKCxaUieYosMdXuuqiuHT5Gbhz8oixGv2XGw4+Ug@mail.gmail.com>
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

On Wed, Oct 27, 2021 at 4:02 PM Vitaly Bursov <vitaly@bursov.com> wrote:
>
>
> 27.10.2021 12:30, Pavan Chebbi wrote:
> > On Wed, Sep 22, 2021 at 12:10 PM Siva Reddy Kallam
> > <siva.kallam@broadcom.com> wrote:
> >>
> >> Thank you for reporting this. Pavan(cc'd) from Broadcom looking into this issue.
> >> We will provide our feedback very soon on this.
> >>
> >> On Mon, Sep 20, 2021 at 6:59 PM Vitaly Bursov <vitaly@bursov.com> wrote:
> >>>
> >>> Hi,
> >>>
> >>> We found a occassional and random (sometimes happens, sometimes not)
> >>> packet re-order when NIC is involved in UDP multicast reception, which
> >>> is sensitive to a packet re-order. Network capture with tcpdump
> >>> sometimes shows the packet re-order, sometimes not (e.g. no re-order on
> >>> a host, re-order in a container at the same time). In a pcap file
> >>> re-ordered packets have a correct timestamp - delayed packet had a more
> >>> earlier timestamp compared to a previous packet:
> >>>       1.00s packet1
> >>>       1.20s packet3
> >>>       1.10s packet2
> >>>       1.30s packet4
> >>>
> >>> There's about 300Mbps of traffic on this NIC, and server is busy
> >>> (hyper-threading enabled, about 50% overall idle) with its
> >>> computational application work.
> >>>
> >>> NIC is HPE's 4-port 331i adapter - BCM5719, in a default ring and
> >>> coalescing configuration, 1 TX queue, 4 RX queues.
> >>>
> >>> After further investigation, I believe that there are two separate
> >>> issues in tg3.c driver. Issues can be reproduced with iperf3, and
> >>> unicast UDP.
> >>>
> >>> Here are the details of how I understand this behavior.
> >>>
> >>> 1. Packet re-order.
> >>>
> >>> Driver calls napi_schedule(&tnapi->napi) when handling the interrupt,
> >>> however, sometimes it calls napi_schedule(&tp->napi[1].napi), which
> >>> handles RX queue 0 too:
> >>>
> >>>       https://github.com/torvalds/linux/blob/master/drivers/net/ethernet/broadcom/tg3.c#L6802-L7007
> >>>
> >>>       static int tg3_rx(struct tg3_napi *tnapi, int budget)
> >>>       {
> >>>               struct tg3 *tp = tnapi->tp;
> >>>
> >>>               ...
> >>>
> >>>               /* Refill RX ring(s). */
> >>>               if (!tg3_flag(tp, ENABLE_RSS)) {
> >>>                       ....
> >>>               } else if (work_mask) {
> >>>                       ...
> >>>
> >>>                       if (tnapi != &tp->napi[1]) {
> >>>                               tp->rx_refill = true;
> >>>                               napi_schedule(&tp->napi[1].napi);
> >>>                       }
> >>>               }
> >>>               ...
> >>>       }
> >>>
> >>>   From napi_schedule() code, it should schedure RX 0 traffic handling on
> >>> a current CPU, which handles queues RX1-3 right now.
> >>>
> >>> At least two traffic flows are required - one on RX queue 0, and the
> >>> other on any other queue (1-3). Re-ordering may happend only on flow
> >>> from queue 0, the second flow will work fine.
> >>>
> >>> No idea how to fix this.
> >
> > In the case of RSS the actual rings for RX are from 1 to 4.
> > The napi of those rings are indeed processing the packets.
> > The explicit napi_schedule of napi[1] is only re-filling rx BD
> > producer ring because it is shared with return rings for 1-4.
> > I tried to repro this but I am not seeing the issue. If you are
> > receiving packets on RX 0 then the RSS must have been disabled.
> > Can you please check?
> >
>
> # ethtool -i enp2s0f0
> driver: tg3
> version: 3.137
> firmware-version: 5719-v1.46 NCSI v1.5.18.0
> expansion-rom-version:
> bus-info: 0000:02:00.0
> supports-statistics: yes
> supports-test: yes
> supports-eeprom-access: yes
> supports-register-dump: yes
> supports-priv-flags: no
>
> # ethtool -l enp2s0f0
> Channel parameters for enp2s0f0:
> Pre-set maximums:
> RX:             4
> TX:             4
> Other:          0
> Combined:       0
> Current hardware settings:
> RX:             4
> TX:             1
> Other:          0
> Combined:       0
>
> # ethtool -x enp2s0f0
> RX flow hash indirection table for enp2s0f0 with 4 RX ring(s):
>      0:      0     1     2     3     0     1     2     3
>      8:      0     1     2     3     0     1     2     3
>     16:      0     1     2     3     0     1     2     3
>     24:      0     1     2     3     0     1     2     3
>     32:      0     1     2     3     0     1     2     3
>     40:      0     1     2     3     0     1     2     3
>     48:      0     1     2     3     0     1     2     3
>     56:      0     1     2     3     0     1     2     3
>     64:      0     1     2     3     0     1     2     3
>     72:      0     1     2     3     0     1     2     3
>     80:      0     1     2     3     0     1     2     3
>     88:      0     1     2     3     0     1     2     3
>     96:      0     1     2     3     0     1     2     3
>    104:      0     1     2     3     0     1     2     3
>    112:      0     1     2     3     0     1     2     3
>    120:      0     1     2     3     0     1     2     3
> RSS hash key:
> Operation not supported
> RSS hash function:
>      toeplitz: on
>      xor: off
>      crc32: off
>
> In /proc/interrupts there are enp2s0f0-tx-0, enp2s0f0-rx-1,
> enp2s0f0-rx-2, enp2s0f0-rx-3, enp2s0f0-rx-4 interrupts, all on
> different CPU cores. Kernel also has "threadirqs" enabled in
> command line, I didn't check if this parameter affects the issue.
>
> Yes, some things start with 0, and others with 1, sorry for a confusion
> in terminology, what I meant:
>   - There are 4 RX rings/queues, I counted starting from 0, so: 0..3.
>     RX0 is the first queue/ring that actually receives the traffic.
>     RX0 is handled by enp2s0f0-rx-1 interrupt.
>   - These are related to (tp->napi[i]), but i is in 1..4, so the first
>     receiving queue relates to tp->napi[1], the second relates to
>     tp->napi[2], and so on. Correct?
>
> Suppose, tg3_rx() is called for tp->napi[2], this function most likely
> calls napi_gro_receive(&tnapi->napi, skb) to further process packets in
> tp->napi[2]. And, under some conditions (RSS and work_mask), it calls
> napi_schedule(&tp->napi[1].napi), which schedules tp->napi[1] work
> on a currect CPU, which is designated for tp->napi[2], but not for
> tp->napi[1]. Correct?
>
> I don't understand what napi_schedule(&tp->napi[1].napi) does for the
> NIC or driver, "re-filling rx BD producer ring" sounds important. I
> suspect something will break badly if I simply remove it without
> replacing with something more elaborate. I guess along with re-filling
> rx BD producer ring it also can process incoming packets. Is it possible?
>

Yes, napi[1] work may be called on the napi[2]'s CPU but it generally
won't process
any rx packets because the producer index of napi[1] has not changed. If the
producer count did change, then we get a poll from the ISR for napi[1]
to process
packets. So it is mostly used to re-fill rx buffers when called
explicitly. However
there could be a small window where the prod index is incremented but the ISR
is not fired yet. It may process some small no of packets. But I don't
think this
should lead to a reorder problem.


> --
> Thanks
> Vitalii
