Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F852223D3B
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 15:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbgGQNpm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 09:45:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726221AbgGQNpl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 09:45:41 -0400
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6F3DC061755
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 06:45:41 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id o38so7618638qtf.6
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 06:45:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7ztCEXSrEjXV+aAu0HuFEs2AGLH1hENvLq4HsMbWxEI=;
        b=S2ZbeAA8JXp9Lxr0h3ChYgJvNn/ngCTG5TgFfYUb1sLbi4wW1sggCZkvOBrrxXsPny
         6MDtNBbIe0fktYFH29bjj/49iBw6/0lCI40Ieqek2e4g4qT67CYojkfJWloRJ+N8AVtg
         XrqQkniYHGbsLHYl6fLICisXQ2nV9juf0tG9ibr0DDIe3sCeLA/+fTR6k5xAFKqK3wCO
         E+n0MWS5GqTZP/UaGdPx3SvDxMOzCBl5LhkX0UvmLLWgwKBt2EfZbAToJBmLIZYpuDKD
         /5bsjWqjpOu2xL3QNCbjwtQvLQWxXHEINIi0N1DQTNWo6yqtA5Zx3ALf3C/4sq00Fhgg
         jPYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7ztCEXSrEjXV+aAu0HuFEs2AGLH1hENvLq4HsMbWxEI=;
        b=b1XhqW2vdtUN4Tv85k9oCvVwHRhHJ/QHMR42twm8EOD8+RlUAw+7xvFsen8M8y+Y+M
         nyWN9uBjsgrsYudwyyB1SEBdujEFQXsX2hnpS9UtHIkf8AakHrHf/IwqgR450Y4Usqoh
         5iJHFFzL0bSoaitL9A5IPssJ4JqA/gI/4qWjQx9C+c8SI6d+SuVY/rn0Zywj+GtkdPah
         MUDjBjT2YCTIEEM44QuYJuLEqCYjR/qYTERt9ey+QTw/BNiJlBc6LUOrwxGiTTCerRj6
         HZYl09TnSP68pT7sa64eJ8BlUxIDVW3xW2SNPiI5ik8BkU+yB6BqzBkynqJxkux0Esoa
         xLhA==
X-Gm-Message-State: AOAM531WuAxQ27CuFqDHNzKqkflNsxPY5t9FoFBylqrj3MVfOZ5iryzt
        YXcou2h/CXf7L7ZWc7nbkvnkG7/iGQoaaqGqgOCUsBsMVqw=
X-Google-Smtp-Source: ABdhPJzIEL89z5WjJ9XR+W9nU6pzgyW3akuWkD48VzMRUqn6fI8lJJRFPuYrOK0Gbs1MYRPiFdNngZLREUbVevDjVdQ=
X-Received: by 2002:ac8:396c:: with SMTP id t41mr10476078qtb.45.1594993540859;
 Fri, 17 Jul 2020 06:45:40 -0700 (PDT)
MIME-Version: 1.0
References: <CAA85sZvKNXCo5bB5a6kKmsOUAiw+_daAVaSYqNW6QbSBJ0TcyQ@mail.gmail.com>
 <CAA85sZua6Q8UR7TfCGO0bV=VU0gKtqj-8o_mqH38RpKrwYZGtg@mail.gmail.com>
 <20200715133136.5f63360c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAA85sZu09Z4gydJ8rAO_Ey0zqx-8Lg28=fBJ=FxFnp6cetNd3g@mail.gmail.com>
 <CAA85sZtjCW2Yg+tXPgYyoFA5BKAVZC8kVKG=6SiR64c8ur8UcQ@mail.gmail.com>
 <20200715144017.47d06941@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAA85sZvnytPzpia_ROnkmJoZC8n4vUsrwTQh2UBs6u6g2Fgqxw@mail.gmail.com>
 <CAKgT0UdwsmE=ygE2KObzM0z-0KgrPcr59JZzVk41F6-iqsSL+Q@mail.gmail.com>
 <CAA85sZturDN7uOHMDhUnntM43PHjop=TNDb4qvEA2L=jdRa1MA@mail.gmail.com>
 <CAKgT0Uf42EhnM+zPSb-oL1R8hmo0vEdssGztptbkWKoHXS7ygw@mail.gmail.com>
 <CAA85sZtHNkocj840i0ohMVekh0B4byuojU02UunK_bR+LB1WiQ@mail.gmail.com>
 <CAKgT0UdDjabvShwDv0qiume=Q2RKGkm3JhPMZ+f8v5yO37ZLxA@mail.gmail.com>
 <CAA85sZt6B+rG8pUfRoNVOH=VqHn=rT-+2kHpFDzW+eBwvODxJA@mail.gmail.com> <CAKgT0UfhMjZ6kZSkfpEVHBbQ+4eHQqWRbXk5Sm4nLQD6sSrj0A@mail.gmail.com>
In-Reply-To: <CAKgT0UfhMjZ6kZSkfpEVHBbQ+4eHQqWRbXk5Sm4nLQD6sSrj0A@mail.gmail.com>
From:   Ian Kumlien <ian.kumlien@gmail.com>
Date:   Fri, 17 Jul 2020 15:45:29 +0200
Message-ID: <CAA85sZs5D_ReOhsEv1SVbE5D8q77utNBZ=Uv34PVof9gHs9QWw@mail.gmail.com>
Subject: Re: [Intel-wired-lan] NAT performance issue 944mbit -> ~40mbit
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 17, 2020 at 2:09 AM Alexander Duyck
<alexander.duyck@gmail.com> wrote:
> On Thu, Jul 16, 2020 at 12:47 PM Ian Kumlien <ian.kumlien@gmail.com> wrote:

> > Sorry, tried to respond via the phone, used the webbrowser version but
> > still html mails... :/

> > On Thu, Jul 16, 2020 at 5:18 PM Alexander Duyck
> > <alexander.duyck@gmail.com> wrote:
> > > On Wed, Jul 15, 2020 at 5:00 PM Ian Kumlien <ian.kumlien@gmail.com> wrote:

[--8<--]

> > > > Well... I'll be damned... I used to force enable ASPM... this must be
> > > > related to the change in PCIe bus ASPM
> > > > Perhaps disable ASPM if there is only one link?
> > >
> > > Is there any specific reason why you are enabling ASPM? Is this system
> > > a laptop where you are trying to conserve power when on battery? If
> > > not disabling it probably won't hurt things too much since the power
> > > consumption for a 2.5GT/s link operating in a width of one shouldn't
> > > bee too high. Otherwise you are likely going to end up paying the
> > > price for getting the interface out of L1 when the traffic goes idle
> > > so you are going to see flows that get bursty paying a heavy penalty
> > > when they start dropping packets.
> >
> > Ah, you misunderstand, I used to do this and everything worked - now
> > Linux enables ASPM by default on all pcie controllers,
> > so imho this should be a quirk, if there is only one lane, don't do
> > ASPM due to latency and timing issues...
> >
> > > It is also possible this could be something that changed with the
> > > physical PCIe link. Basically L1 works by powering down the link when
> > > idle, and then powering it back up when there is activity. The problem
> > > is bringing it back up can sometimes be a challenge when the physical
> > > link starts to go faulty. I know I have seen that in some cases it can
> > > even result in the device falling off of the PCIe bus if the link
> > > training fails.
> >
> > It works fine without ASPM (and the machine is pretty new)
> >
> > I suspect we hit some timing race with aggressive ASPM (assumed as
> > such since it works on local links but doesn't on ~3 ms Links)
>
> Agreed. What is probably happening if you are using a NAT is that it
> may be seeing some burstiness being introduced and as a result the
> part is going to sleep and then being overrun when the traffic does
> arrive.

Weird though, seems to be very aggressive timings =)

[--8<--]

> > > > ethtool -S enp3s0 |grep -v ": 0"
> > > > NIC statistics:
> > > >      rx_packets: 16303520
> > > >      tx_packets: 21602840
> > > >      rx_bytes: 15711958157
> > > >      tx_bytes: 25599009212
> > > >      rx_broadcast: 122212
> > > >      tx_broadcast: 530
> > > >      rx_multicast: 333489
> > > >      tx_multicast: 18446
> > > >      multicast: 333489
> > > >      rx_missed_errors: 270143
> > > >      rx_long_length_errors: 6
> > > >      tx_tcp_seg_good: 1342561
> > > >      rx_long_byte_count: 15711958157
> > > >      rx_errors: 6
> > > >      rx_length_errors: 6
> > > >      rx_fifo_errors: 270143
> > > >      tx_queue_0_packets: 8963830
> > > >      tx_queue_0_bytes: 9803196683
> > > >      tx_queue_0_restart: 4920
> > > >      tx_queue_1_packets: 12639010
> > > >      tx_queue_1_bytes: 15706576814
> > > >      tx_queue_1_restart: 12718
> > > >      rx_queue_0_packets: 16303520
> > > >      rx_queue_0_bytes: 15646744077
> > > >      rx_queue_0_csum_err: 76
> > >
> > > Okay, so this result still has the same length and checksum errors,
> > > were you resetting the system/statistics between runs?
> >
> > Ah, no.... Will reset and do more tests when I'm back home
> >
> > Am I blind or is this part missing from ethtools man page?
>
> There isn't a reset that will reset the stats via ethtool. The device
> stats will be persistent until the driver is unloaded and reloaded or
> the system is reset. You can reset the queue stats by changing the
> number of queues. So for example using "ethtool -L enp3s0 1;  ethtool
> -L enp3s0 2".

It did reset some counters but not all...

NIC statistics:
     rx_packets: 37339997
     tx_packets: 36066432
     rx_bytes: 39226365570
     tx_bytes: 37364799188
     rx_broadcast: 197736
     tx_broadcast: 1187
     rx_multicast: 572374
     tx_multicast: 30546
     multicast: 572374
     collisions: 0
     rx_crc_errors: 0
     rx_no_buffer_count: 0
     rx_missed_errors: 270844
     tx_aborted_errors: 0
     tx_carrier_errors: 0
     tx_window_errors: 0
     tx_abort_late_coll: 0
     tx_deferred_ok: 0
     tx_single_coll_ok: 0
     tx_multi_coll_ok: 0
     tx_timeout_count: 0
     rx_long_length_errors: 6
     rx_short_length_errors: 0
     rx_align_errors: 0
     tx_tcp_seg_good: 2663350
     tx_tcp_seg_failed: 0
     rx_flow_control_xon: 0
     rx_flow_control_xoff: 0
     tx_flow_control_xon: 0
     tx_flow_control_xoff: 0
     rx_long_byte_count: 39226365570
     tx_dma_out_of_sync: 0
     tx_smbus: 0
     rx_smbus: 0
     dropped_smbus: 0
     os2bmc_rx_by_bmc: 0
     os2bmc_tx_by_bmc: 0
     os2bmc_tx_by_host: 0
     os2bmc_rx_by_host: 0
     tx_hwtstamp_timeouts: 0
     tx_hwtstamp_skipped: 0
     rx_hwtstamp_cleared: 0
     rx_errors: 6
     tx_errors: 0
     tx_dropped: 0
     rx_length_errors: 6
     rx_over_errors: 0
     rx_frame_errors: 0
     rx_fifo_errors: 270844
     tx_fifo_errors: 0
     tx_heartbeat_errors: 0
     tx_queue_0_packets: 16069894
     tx_queue_0_bytes: 16031462246
     tx_queue_0_restart: 4920
     tx_queue_1_packets: 19996538
     tx_queue_1_bytes: 21169430746
     tx_queue_1_restart: 12718
     rx_queue_0_packets: 37339997
     rx_queue_0_bytes: 39077005582
     rx_queue_0_drops: 0
     rx_queue_0_csum_err: 76
     rx_queue_0_alloc_failed: 0
     rx_queue_1_packets: 0
     rx_queue_1_bytes: 0
     rx_queue_1_drops: 0
     rx_queue_1_csum_err: 0
     rx_queue_1_alloc_failed: 0

-- vs --

NIC statistics:
     rx_packets: 37340720
     tx_packets: 36066920
     rx_bytes: 39226590275
     tx_bytes: 37364899567
     rx_broadcast: 197755
     tx_broadcast: 1204
     rx_multicast: 572582
     tx_multicast: 30563
     multicast: 572582
     collisions: 0
     rx_crc_errors: 0
     rx_no_buffer_count: 0
     rx_missed_errors: 270844
     tx_aborted_errors: 0
     tx_carrier_errors: 0
     tx_window_errors: 0
     tx_abort_late_coll: 0
     tx_deferred_ok: 0
     tx_single_coll_ok: 0
     tx_multi_coll_ok: 0
     tx_timeout_count: 0
     rx_long_length_errors: 6
     rx_short_length_errors: 0
     rx_align_errors: 0
     tx_tcp_seg_good: 2663352
     tx_tcp_seg_failed: 0
     rx_flow_control_xon: 0
     rx_flow_control_xoff: 0
     tx_flow_control_xon: 0
     tx_flow_control_xoff: 0
     rx_long_byte_count: 39226590275
     tx_dma_out_of_sync: 0
     tx_smbus: 0
     rx_smbus: 0
     dropped_smbus: 0
     os2bmc_rx_by_bmc: 0
     os2bmc_tx_by_bmc: 0
     os2bmc_tx_by_host: 0
     os2bmc_rx_by_host: 0
     tx_hwtstamp_timeouts: 0
     tx_hwtstamp_skipped: 0
     rx_hwtstamp_cleared: 0
     rx_errors: 6
     tx_errors: 0
     tx_dropped: 0
     rx_length_errors: 6
     rx_over_errors: 0
     rx_frame_errors: 0
     rx_fifo_errors: 270844
     tx_fifo_errors: 0
     tx_heartbeat_errors: 0
     tx_queue_0_packets: 59
     tx_queue_0_bytes: 11829
     tx_queue_0_restart: 0
     tx_queue_1_packets: 49
     tx_queue_1_bytes: 12058
     tx_queue_1_restart: 0
     rx_queue_0_packets: 84
     rx_queue_0_bytes: 22195
     rx_queue_0_drops: 0
     rx_queue_0_csum_err: 0
     rx_queue_0_alloc_failed: 0
     rx_queue_1_packets: 0
     rx_queue_1_bytes: 0
     rx_queue_1_drops: 0
     rx_queue_1_csum_err: 0
     rx_queue_1_alloc_failed: 0

---
