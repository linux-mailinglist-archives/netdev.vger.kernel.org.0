Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80F70FEA2E
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 02:52:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727365AbfKPBwk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 20:52:40 -0500
Received: from mail-oi1-f171.google.com ([209.85.167.171]:35996 "EHLO
        mail-oi1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727089AbfKPBwk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 20:52:40 -0500
Received: by mail-oi1-f171.google.com with SMTP id j7so10358121oib.3
        for <netdev@vger.kernel.org>; Fri, 15 Nov 2019 17:52:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FCrjWN9xuMa6Ah+xNPKfnt3IK3UhGLmxaGJwqC29cME=;
        b=uwpXaKAskL/FcMoAUoipwO0GHwsug8IguAXalLo+s6cNuz/Pe+2tuUOHuCHQ9x3P1H
         ywYvs4Ug2UiFrcTvgxkX3XcFMZtkwYrEoK9Icqvb0EDrRDf+hQt5sTN18pjStRwSIhWM
         JfsacMtTWOU3zAW8pzUsDS6OTvIzZHNsFzzJJiSNEfuAirFUl5PgJrfOqUzupYd+7fGk
         7SiiNov9iEKwWaz7J2qVkm5wUFPsaluMMSW05GeJvB2a76wn6Mqfh8iExS3MYezhK14a
         x+jmbIDYqT0n6oK9mI4bpseH2In/qkyIOITG3f5n8kVdO4GWFdCz4oRsI8rd7n8I5Juw
         M2vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FCrjWN9xuMa6Ah+xNPKfnt3IK3UhGLmxaGJwqC29cME=;
        b=PtQkC+hQnHYKbkEBWuzvDaNAjQzuJh+APmGQh7+yxAUbOlmZqISEbQQEAQmN5VL2ne
         U6O0N5GW6dSktyCjWIVprQl4grQ3B+ZmpKYhTpBEaHxLl85kIXw7Iwicv5bW5AWPgauk
         2yGrwvWRTjVDUCk8NAjtfkYxFNOIdT7GErGAmPeRqCa626sbDDuDaQCCV5EB2hcyhRSk
         6Rau4k/uHmZWK7NXpu75tutimC0049iFCJM/bDPHtxYPllMnzUv7lhRNM9fblgoSibPe
         9XcrBwZ7TXeu2l4ZtUE7WeL5czolxUmcOLr4j7S5sdZdjEhngLpb8HiqOyZhJufdaMVX
         OIAw==
X-Gm-Message-State: APjAAAWzqobFBMezmAkvoLojwRfFTdGPdWFeR9YzdFs6zLaGHx93SX9B
        DJAqG+wmClUpXJILW/IDJRYt7vZ0VbEHTy1dO1kK9Hq1jrI=
X-Google-Smtp-Source: APXvYqzvfYw7tZYNS8ChUY9i53PVRwNVR1d3Rd+D3G0kTxItSCI4e/iLaiBxXCrUbu9i/G554N5OYTyVZbR6Hst/4xA=
X-Received: by 2002:aca:5441:: with SMTP id i62mr10234051oib.42.1573869158902;
 Fri, 15 Nov 2019 17:52:38 -0800 (PST)
MIME-Version: 1.0
References: <CAJwzM1k7iW9tJZiO-JhVbnT-EmwaJbsroaVbJLnSVY-tyCzjLQ@mail.gmail.com>
 <0d553faa-b665-14cf-e977-d2b0ff3d763e@gmail.com>
In-Reply-To: <0d553faa-b665-14cf-e977-d2b0ff3d763e@gmail.com>
From:   Avinash Patil <avinashapatil@gmail.com>
Date:   Fri, 15 Nov 2019 17:52:27 -0800
Message-ID: <CAJwzM1=uv8NG=upCiRonvA504dn1u5Tj5DNM83BCSMbSmwvLuw@mail.gmail.com>
Subject: Re: Possible bug in TCP retry logic/Kernel crash
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

I integrated all patches till 4.19.83 as per your suggestion.
Unfortunately, I still see crash.

[  991.291968] [ECR   ]: 0x00230400 => Misaligned r/w from 0x00000001
[  991.299766] [EFA   ]: 0x00000001
[  991.299766] [BLINK ]: tcp_clean_rtx_queue+0x2a4/0xc88
[  991.299766] [ERET  ]: __list_del_entry_valid+0x12/0x1a0
[  991.313350] [STAT32]: 0x00000206 : K         E2 E1
[  991.318323] BTA: 0x8b188843   SP: 0x8f04fcf4  FP: 0x00000000
[  991.323977] LPS: 0x8b2e2942  LPE: 0x8b2e2946 LPC: 0x00000000
[  991.329660] r00: 0x8cbf2224  r01: 0x8cbf21c0 r02: 0x6e6c53fe
[  991.329660] r03: 0x00000001  r04: 0x00000000 r05: 0x39ef6f1d
[  991.329660] r06: 0x8f3e3180  r07: 0x00000000 r08: 0x3b14d54c
[  991.329660] r09: 0x00000000  r10: 0x0000c0ef r11: 0x00000000
[  991.329660] r12: 0x04c80000  r13: 0x8cbf21c0 r14: 0x00000000
[  991.329660] r15: 0x00000000  r16: 0x00000001 r17: 0x00000000
[  991.329660] r18: 0x8f3e3580  r19: 0x8f3e2d80 r20: 0x00000004
[  991.329660] r21: 0x8f04fd7c  r22: 0x00000001 r23: 0x3b14d54c
[  991.329660] r24: 0x00000000  r25: 0x8f0315c0
[  991.329660]
[  991.329660]
[  991.382333]
[  991.382333] Stack Trace:
[  991.386374] Firmware build version: avinashp6_bbic5_a-cl103643
[  991.386374] Firmware configuration: pearl_10gax_config
[  991.386374] Hardware ID           : 65535
[  991.401461]   __list_del_entry_valid+0x12/0x1a0
[  991.406125]   tcp_clean_rtx_queue+0x2a4/0xc88
[  991.410618]   tcp_ack+0x484/0x914
[  991.414073]   tcp_rcv_established+0x538/0x724
[  991.418564]   tcp_v4_do_rcv+0xda/0x120
[  991.422456]   tcp_v4_rcv+0x954/0xa7c
[  991.426105]   ip_local_deliver+0x72/0x208
[  991.430257]   process_backlog+0xbe/0x1b0
[  991.434319]   net_rx_action+0x106/0x294
[  991.438286]   __do_softirq+0xf0/0x218
[  991.442014]   run_ksoftirqd+0x2a/0x3c
[  991.445812]   smpboot_thread_fn+0xb4/0x10c
[  991.450054]   kthread+0xd8/0xdc
[  991.453338]   ret_from_fork+0x18/0x1c
[  991.457067]

Thank you!

-Avinash

On Sun, Nov 10, 2019 at 3:48 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>
>
> On 11/9/19 9:59 PM, Avinash Patil wrote:
> > Hi everyone,
> >
> > Kernel: Linux 4.19.35 kernel built from linux-stable
> >
>
> This is quite an old version.
>
> Please upgrade to the latest one.
>
> $ git log --oneline v4.19.35..v4.19.82 -- net/ipv4/tcp*c
> 3fdcf6a88ded2bb5c3c0f0aabaff253dd3564013 tcp: better handle TCP_USER_TIMEOUT in SYN_SENT state
> 67fe3b94a833779caf4504ececa7097fba9b2627 tcp: fix tcp_ecn_withdraw_cwr() to clear TCP_ECN_QUEUE_CWR
> 5977bc19ce7f1ed25bf20d09d8e93e56873a9abb tcp: remove empty skb from write queue in error cases
> 6f3126379879bb2b9148174f0a4b6b65e04dede9 tcp: inherit timestamp on mtu probe
> 1b200acde418f4d6d87279d3f6f976ebf188f272 tcp: Reset bytes_acked and bytes_received when disconnecting
> c60f57dfe995172c2f01e59266e3ffa3419c6cd9 tcp: fix tcp_set_congestion_control() use from bpf hook
> 6323c238bb4374d1477348cfbd5854f2bebe9a21 tcp: be more careful in tcp_fragment()
> dad3a9314ac95dedc007bc7dacacb396ea10e376 tcp: refine memory limit test in tcp_fragment()
> 59222807fcc99951dc769cd50e132e319d73d699 tcp: enforce tcp_min_snd_mss in tcp_mtu_probing()
> 7f9f8a37e563c67b24ccd57da1d541a95538e8d9 tcp: add tcp_min_snd_mss sysctl
> ec83921899a571ad70d582934ee9e3e07f478848 tcp: tcp_fragment() should apply sane memory limits
> c09be31461ed140976c60a87364415454a2c3d42 tcp: limit payload size of sacked skbs
> 6728c6174a47b8a04ceec89aca9e1195dee7ff6b tcp: tcp_grow_window() needs to respect tcp_space()
>
