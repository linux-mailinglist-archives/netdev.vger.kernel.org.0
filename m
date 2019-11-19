Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0FC9102F72
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 23:39:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727222AbfKSWjt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 17:39:49 -0500
Received: from mail-oi1-f195.google.com ([209.85.167.195]:41593 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726346AbfKSWjs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 17:39:48 -0500
Received: by mail-oi1-f195.google.com with SMTP id e9so20633557oif.8
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 14:39:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E4UaSo/WHQmcXoTHhB3JtZWeJYUeCByWMSPjsIZAupc=;
        b=HiqyEs3PbVmYSvuNQdRrsSoaBgX9HvkdxeGCTdUMPDyB3Di1V1TwcMoWY+h0SUZIdV
         uhoCIz42GAzuSvWG1vMlAxEaidsMZW0B3B+Dt2nLh7zalaywaiDZdgIPRpsMkjeIB8VB
         IdM8AG51l8F3Ksmy26u5T9vhAREnSoE7fx77KQbXktmnMNlxkXLp1iyGlDgagwbrdJdT
         /ZtwODD4dpd1NnJW6v+ilw9fxH61ooe7PSpCWOoEX8CJweVuc8+aQfLq03rUyrkmlje6
         9hrea+EUum+vaQ/i+BZsaORAdWB4CjZSldRG+oaUdDjemQnPxNw5hR8Z6jHtdlDBWWtu
         Ya6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E4UaSo/WHQmcXoTHhB3JtZWeJYUeCByWMSPjsIZAupc=;
        b=KbrFU7mJuKEGkL2evWWxTCoQ9PYtQLww8CbIE5haM5RaSxgSBSX91AAewBXyWHzwyA
         uwGFZQAJi3dOvatefM09FBNktNcu+cxiluWv29m7GUf2zs2bqhnSnAR2oqIwfsBVnMtH
         en3HcEOnFQggw6Tvg1hgnJOMsyO3IkqObVEvxIvsIhQ6cUEkH19IEB7dWqGGYl0gRwZt
         y0xcxX7jdgIOfiZHrwqkv+ewjs3FsHhzbecRgtup7qWdqJkYlRrAV5GotiTJpLqcZaCt
         d4xAQdjUUXZgE7ruD/mO7/4y/TOsb3Y5lP/Np3r4MUMppXb+HFSrHpeKLLXK4yXvNuTG
         bhWQ==
X-Gm-Message-State: APjAAAUbvzu5Fo++GNMP6L8CJKs+oaQR+E5NCEjdEykFxU5aB54RD+1l
        uvBw4qRF3ktCfs1iZm8/PX12kLTe1o7pyQq6wznwYvyuS/g=
X-Google-Smtp-Source: APXvYqxfNSKVz733UOqG1PJ5LAHhflXXmsjG7DkbpCMoPyJ1e6bVMUrGNqYTWJ0N6YgD98v9ioTxYDd+qb4TtjsQL+I=
X-Received: by 2002:a05:6808:14:: with SMTP id u20mr6294655oic.49.1574203185795;
 Tue, 19 Nov 2019 14:39:45 -0800 (PST)
MIME-Version: 1.0
References: <CAJwzM1k7iW9tJZiO-JhVbnT-EmwaJbsroaVbJLnSVY-tyCzjLQ@mail.gmail.com>
 <0d553faa-b665-14cf-e977-d2b0ff3d763e@gmail.com> <CAJwzM1=uv8NG=upCiRonvA504dn1u5Tj5DNM83BCSMbSmwvLuw@mail.gmail.com>
 <5bc7724f-c713-1810-2988-75520cb6f5eb@gmail.com> <CAJwzM1m-CTK-H9At_LdpMUP8kZNGkY6v1jZmusyFpChG2sGefQ@mail.gmail.com>
 <40b553a5-11b1-3278-3c73-406baec833d6@gmail.com>
In-Reply-To: <40b553a5-11b1-3278-3c73-406baec833d6@gmail.com>
From:   Avinash Patil <avinashapatil@gmail.com>
Date:   Tue, 19 Nov 2019 14:39:34 -0800
Message-ID: <CAJwzM1=HPN92sDXJfq6RTXf1zpPiZxwkQUKukAq-L5POP9YyFw@mail.gmail.com>
Subject: Re: Possible bug in TCP retry logic/Kernel crash
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

Thanks for your help so far.
I am in no way suggesting you to debug this issue. I have already said
in first email itself that I am debugging this myself and looking for
pointers from experts for conditions under which this could happen.
BTW, I am also checking about the possibility of sharing my changes to
kernel sources.
Here is another crash I observed today.

[  139.786529] ===============
[  139.789445] tcp_rcv_established: sk=8f3eb400, skb=8f3c0c00, len=47
[  139.795833] tcp_rcv_established: step5 skb=8f3c0c00
[  139.800814] tcp_queue_rcv: sk=8f3eb400, skb=8f3c0c00, src-port=39620, len=15
[  139.808199] ===============
[  139.811033] tcp_rcv_established: sk=8f3eb400, skb=8f3c0900, len=32
[  139.817409] tcp_rcv_established: slow_path skb=8f3c0900
[  139.822774] tcp_rcv_established: step5 skb=8f3c0900
[  139.827753] tcp_queue_rcv: sk=8f3eb400, skb=8f3c0900, src-port=39620, len=0
[  139.834965] tcp_drop: sk=8f3eb400, skb=8f3c0900
[  140.846604] TCP: tcp_recvmsg: found a SYN, please report !
[  140.852198] ------------[ cut here ]------------
[  140.856948] WARNING: CPU: 0 PID: 1353 at net/ipv4/tcp.c:2039
tcp_recvmsg+0x648/0x9f4
[  140.864793] TCP recvmsg seq # bug 2: copied F5058AF9, seq 8C96A6D0,
rcvnxt F5058C85, fl 0
[  140.873073] Modules linked in: wlan_scan_ap(O) wlan_acl(O)
wlan_gcmp_256(O) wlan_gcmp(O) wlan_ccmp_256(O) wlan_wep(O)
wlan_tkip(O) wlan_ccmp(O) wlan_xauth(O) qdrv(O) auc_fw(PO) wlan(O)
radar(PO) i2cbu)
[  140.904278] CPU: 0 PID: 1353 Comm: qtn_ca Tainted: P           O
  4.19.35 #135
[  140.911948]
[  140.911948] Stack Trace:
[  140.916040] Firmware build version: avinashp6_bbic5_a-cl103746
[  140.916040] Firmware configuration: pearl_10gax_config
[  140.916040] Hardware ID           : 65535
[  140.931150]   arc_unwind_core+0xc8/0xe8
[  140.935127]   __warn+0x9c/0xbc
[  140.938316]   warn_slowpath_fmt+0x32/0x3c
[  140.942385]   tcp_recvmsg+0x648/0x9f4
[  140.946185]   inet_recvmsg+0x2a/0x3c
[  140.949906]   __sys_recvfrom+0xba/0x100
[  140.953903]   EV_Trap+0x11c/0x120
[  140.957263] ---[ end trace 0e4059a49f3521b9 ]---
[  140.961983]
[  140.961983] Oops
[  140.965397] Path: /usr/bin/qtn_ca
[  140.968815] CPU: 0 PID: 1353 Comm: qtn_ca Tainted: P        W  O
  4.19.35 #135
[  140.976473]
[  140.976473] [ECR   ]: 0x00220100 => Invalid Read @ 0x00000020 by
insn @ 0x8b39d8a0
[  140.985651] [EFA   ]: 0x00000020
[  140.985651] [BLINK ]: tcp_recvmsg+0x648/0x9f4
[  140.985651] [ERET  ]: tcp_recvmsg+0x654/0x9f4
[  140.997675] [STAT32]: 0x00000406 : K         E2 E1
[  141.002648] BTA: 0x8b188843   SP: 0x8f32fe28  FP: 0x00000000
[  141.008305] LPS: 0x8b2e2942  LPE: 0x8b2e2946 LPC: 0x00000000
[  141.013990] r00: 0x00000009  r01: 0x00000000 r02: 0x8b5c003c
[  141.013990] r03: 0xf5058af9  r04: 0x00001001 r05: 0x00000000
[  141.013990] r06: 0x00000136  r07: 0x00000000 r08: 0x8f32fc90
[  141.013990] r09: 0x00000011  r10: 0x00000000 r11: 0x00000000
[  141.013990] r12: 0x0000002d  r13: 0x00000000 r14: 0x00000000
[  141.013990] r15: 0x00000000  r16: 0x00000000 r17: 0x00000000
[  141.013990] r18: 0x00000000  r19: 0x00000000 r20: 0x00000000
[  141.013990] r21: 0x00000000  r22: 0x00000000 r23: 0x00000000
[  141.013990] r24: 0x00000000  r25: 0x00000000
[  141.013990]
[  141.013990]
[  141.066650]
[  141.066650] Stack Trace:
[  141.070740] Firmware build version: avinashp6_bbic5_a-cl103746
[  141.070740] Firmware configuration: pearl_10gax_config
[  141.070740] Hardware ID           : 65535
[  141.085836]   tcp_recvmsg+0x654/0x9f4
[  141.089634]   inet_recvmsg+0x2a/0x3c
[  141.093350]   __sys_recvfrom+0xba/0x100
[  141.097314]   EV_Trap+0x11c/0x120
[  141.100773]
[  141.100773] Stack not used for current process: 6200


Thanks,
Avinash

On Fri, Nov 15, 2019 at 6:29 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>
>
> On 11/15/19 6:07 PM, Avinash Patil wrote:
> > No; I am not using an official tree. There are certain changes to
> > arch/arc directory which are specific to Synposys ARC platform.
> > However, there are no changes to TCP module and this is why I suspect
> > crash is generic TCP issue.
>
>
> Please provide a git tree then, and exact line numbers of the stack trace.
>
> Really I can not spend days working on non pristibe kernels, you have to help a bit.

> Thanks.
>
> >
> > Thanks,
> > Avinash
> >
> >
> > On Fri, Nov 15, 2019 at 6:01 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> >>
> >>
> >>
> >> On 11/15/19 5:52 PM, Avinash Patil wrote:
> >>> Hi Eric,
> >>>
> >>> I integrated all patches till 4.19.83 as per your suggestion.
> >>> Unfortunately, I still see crash.
> >>
> >> What do you mean by integrating patches ?
> >>
> >> Are you using an official/pristine tree ?
> >>
> >>>
> >>> [  991.291968] [ECR   ]: 0x00230400 => Misaligned r/w from 0x00000001
> >>> [  991.299766] [EFA   ]: 0x00000001
> >>> [  991.299766] [BLINK ]: tcp_clean_rtx_queue+0x2a4/0xc88
> >>> [  991.299766] [ERET  ]: __list_del_entry_valid+0x12/0x1a0
> >>> [  991.313350] [STAT32]: 0x00000206 : K         E2 E1
> >>> [  991.318323] BTA: 0x8b188843   SP: 0x8f04fcf4  FP: 0x00000000
> >>> [  991.323977] LPS: 0x8b2e2942  LPE: 0x8b2e2946 LPC: 0x00000000
> >>> [  991.329660] r00: 0x8cbf2224  r01: 0x8cbf21c0 r02: 0x6e6c53fe
> >>> [  991.329660] r03: 0x00000001  r04: 0x00000000 r05: 0x39ef6f1d
> >>> [  991.329660] r06: 0x8f3e3180  r07: 0x00000000 r08: 0x3b14d54c
> >>> [  991.329660] r09: 0x00000000  r10: 0x0000c0ef r11: 0x00000000
> >>> [  991.329660] r12: 0x04c80000  r13: 0x8cbf21c0 r14: 0x00000000
> >>> [  991.329660] r15: 0x00000000  r16: 0x00000001 r17: 0x00000000
> >>> [  991.329660] r18: 0x8f3e3580  r19: 0x8f3e2d80 r20: 0x00000004
> >>> [  991.329660] r21: 0x8f04fd7c  r22: 0x00000001 r23: 0x3b14d54c
> >>> [  991.329660] r24: 0x00000000  r25: 0x8f0315c0
> >>> [  991.329660]
> >>> [  991.329660]
> >>> [  991.382333]
> >>> [  991.382333] Stack Trace:
> >>> [  991.386374] Firmware build version: avinashp6_bbic5_a-cl103643
> >>> [  991.386374] Firmware configuration: pearl_10gax_config
> >>> [  991.386374] Hardware ID           : 65535
> >>> [  991.401461]   __list_del_entry_valid+0x12/0x1a0
> >>> [  991.406125]   tcp_clean_rtx_queue+0x2a4/0xc88
> >>> [  991.410618]   tcp_ack+0x484/0x914
> >>> [  991.414073]   tcp_rcv_established+0x538/0x724
> >>> [  991.418564]   tcp_v4_do_rcv+0xda/0x120
> >>> [  991.422456]   tcp_v4_rcv+0x954/0xa7c
> >>> [  991.426105]   ip_local_deliver+0x72/0x208
> >>> [  991.430257]   process_backlog+0xbe/0x1b0
> >>> [  991.434319]   net_rx_action+0x106/0x294
> >>> [  991.438286]   __do_softirq+0xf0/0x218
> >>> [  991.442014]   run_ksoftirqd+0x2a/0x3c
> >>> [  991.445812]   smpboot_thread_fn+0xb4/0x10c
> >>> [  991.450054]   kthread+0xd8/0xdc
> >>> [  991.453338]   ret_from_fork+0x18/0x1c
> >>> [  991.457067]
> >>>
> >>> Thank you!
> >>>
> >>> -Avinash
> >>>
> >>> On Sun, Nov 10, 2019 at 3:48 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> >>>>
> >>>>
> >>>>
> >>>> On 11/9/19 9:59 PM, Avinash Patil wrote:
> >>>>> Hi everyone,
> >>>>>
> >>>>> Kernel: Linux 4.19.35 kernel built from linux-stable
> >>>>>
> >>>>
> >>>> This is quite an old version.
> >>>>
> >>>> Please upgrade to the latest one.
> >>>>
> >>>> $ git log --oneline v4.19.35..v4.19.82 -- net/ipv4/tcp*c
> >>>> 3fdcf6a88ded2bb5c3c0f0aabaff253dd3564013 tcp: better handle TCP_USER_TIMEOUT in SYN_SENT state
> >>>> 67fe3b94a833779caf4504ececa7097fba9b2627 tcp: fix tcp_ecn_withdraw_cwr() to clear TCP_ECN_QUEUE_CWR
> >>>> 5977bc19ce7f1ed25bf20d09d8e93e56873a9abb tcp: remove empty skb from write queue in error cases
> >>>> 6f3126379879bb2b9148174f0a4b6b65e04dede9 tcp: inherit timestamp on mtu probe
> >>>> 1b200acde418f4d6d87279d3f6f976ebf188f272 tcp: Reset bytes_acked and bytes_received when disconnecting
> >>>> c60f57dfe995172c2f01e59266e3ffa3419c6cd9 tcp: fix tcp_set_congestion_control() use from bpf hook
> >>>> 6323c238bb4374d1477348cfbd5854f2bebe9a21 tcp: be more careful in tcp_fragment()
> >>>> dad3a9314ac95dedc007bc7dacacb396ea10e376 tcp: refine memory limit test in tcp_fragment()
> >>>> 59222807fcc99951dc769cd50e132e319d73d699 tcp: enforce tcp_min_snd_mss in tcp_mtu_probing()
> >>>> 7f9f8a37e563c67b24ccd57da1d541a95538e8d9 tcp: add tcp_min_snd_mss sysctl
> >>>> ec83921899a571ad70d582934ee9e3e07f478848 tcp: tcp_fragment() should apply sane memory limits
> >>>> c09be31461ed140976c60a87364415454a2c3d42 tcp: limit payload size of sacked skbs
> >>>> 6728c6174a47b8a04ceec89aca9e1195dee7ff6b tcp: tcp_grow_window() needs to respect tcp_space()
> >>>>
