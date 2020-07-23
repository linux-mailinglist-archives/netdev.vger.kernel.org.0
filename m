Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AEEE22A52C
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 04:15:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387618AbgGWCPW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 22:15:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387467AbgGWCPV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 22:15:21 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF7D4C0619DC
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 19:15:21 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id v9so2053864ybe.3
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 19:15:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=71C62Esk6ZUzuR9fvqBgHdse0cZbLyF1EplOpL9jf9g=;
        b=FH56QzJQ7sTsyt6dzBPPK7G3nGBeU72aqxjZtp6+m1qOtVYtt0so8HmYGgFTdHAHMD
         VvSrqaa9DEyZc7SPzwIjE4sg8qshTx7bMmrjZRVcKsTfblU1PDTBrxLTrerSPTBHPKKs
         HGtP7lVccCl6tMr8DUj+nNlasy4nR1aWqwZjM5QBXHCwHx9lHh3UuCEEFkWwIrf5DJ7Z
         /OgRfgXIWKOu03eunw+S+O9rCQZs02m0+qt/pkuA73Cf7QqCJymvankTdE+Zf57awcm4
         i+XZbKZ4RL3u8ttGf5zIlVLzXzz6WGlHnjRXa1UjuKCP/AuwMOEA+oFZxDMW5zDnzg5P
         cF2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=71C62Esk6ZUzuR9fvqBgHdse0cZbLyF1EplOpL9jf9g=;
        b=fVutwtMVtQMIWUYfLovSV0PglgfrP5j4Y9sloMB21Dl/pk8phaqxvmZ6BPscHqgNL1
         xx0k52IstUvGPlppPKK+jGddPBpVsFxjxXU0agyzQv/zt212nH2u+M4GLRfBHrhrAmiF
         r55zk7eVDqzyMoTJWqbamacau6UQg6UiMhyT6eGtGAwJ01BuBr2YJbw0FEaxoK1kzMqh
         ajEQUXimjWKb7kyhpsoUXmQv4BUI4GuqUV7eb+Fhs/iq5w7vEQ4l1kD7oqE7dwJBvSqj
         wX+eaQ1ofTgF7IUI0b1PQ+/qO9pjrP/kI9q6KSxPko2E0LhggMKNqRut3Eh08VeGeNsM
         s0iQ==
X-Gm-Message-State: AOAM5326KzBhXCwTIVrZRvdQOBCG+z/w447rdjyEwCGhQF90jDQ1tlC6
        YbuRKmSB++9iTe+JTnv7wc0BUppKZtHYta0Y+qf+ag==
X-Google-Smtp-Source: ABdhPJzx4WwH//RYdcCYIT+69N1ij6vJCK351Pvo47UXY9M7+Pbop2SoAnvEKO4XsZscLueXeRaKNDBrxQkc8li/eaI=
X-Received: by 2002:a25:838f:: with SMTP id t15mr3466045ybk.380.1595470520404;
 Wed, 22 Jul 2020 19:15:20 -0700 (PDT)
MIME-Version: 1.0
References: <1595409499-25008-1-git-send-email-geffrey.guo@huawei.com>
 <20200722.130408.2000579366934431355.davem@davemloft.net> <6c050a3a1111445287edc52ca6cb056d@huawei.com>
In-Reply-To: <6c050a3a1111445287edc52ca6cb056d@huawei.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 22 Jul 2020 19:15:09 -0700
Message-ID: <CANn89i+OyQcZvAHi5ScehV2fyDyS0KsOpigU-KUokbD0z-NkmA@mail.gmail.com>
Subject: Re: [PATCH,v2] ipvlan: add the check of ip header checksum
To:     "Guodeqing (A)" <geffrey.guo@huawei.com>
Cc:     David Miller <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "maheshb@google.com" <maheshb@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 22, 2020 at 6:59 PM Guodeqing (A) <geffrey.guo@huawei.com> wrot=
e:
>
> I am sorry, the mail is not sent to you directly;
>
> If do the following test,this will cause a panic in a arm64 VM. this can =
be reproduced easily.
>
> Linux osc 5.8.0-rc6+ #3 SMP Thu Jul 23 01:40:47 UTC 2020 aarch64
>
> The programs included with the Debian GNU/Linux system are free software;
> the exact distribution terms for each program are described in the
> individual files in /usr/share/doc/*/copyright.
>
> Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
> permitted by applicable law.
> root@osc:~# ifconfig eth0 up
> root@osc:~# ip netns add ns1
> root@osc:~# ip link add gw link eth0 type ipvlan
> root@osc:~# ip addr add 168.16.0.1/24 dev gw
> root@osc:~# ip link set dev gw up
> root@osc:~# ip link add ip1 link eth0 type ipvlan
> root@osc:~# ip link set ip1 netns ns1
> root@osc:~# ip netns exec ns1 ip link set ip1 up
> root@osc:~# ip netns exec ns1 ip addr add 168.16.0.2/24 dev ip1
> root@osc:~# ip netns exec ns1 ip link set lo up
> root@osc:~# ip netns exec ns1 ip addr add 127.0.0.1/8 dev lo
> RTNETLINK answers: File exists
> root@osc:~# ip netns exec ns1 tc qdisc add dev ip1 root netem corrupt 100=
%
> root@osc:~# ip netns exec ns1 ping 168.16.0.1
> PING 168.16.0.1 (168.16.0.1) 56(84) bytes of data.
> From 168.16.0.1 icmp_seq=3D2 Destination Host Unreachable
> From 168.16.0.1 icmp_seq=3D12 Destination Host Unreachable
> From 168.16.0.1 icmp_seq=3D30 Destination Host Unreachable
> 64 bytes from 168.16.0.1: icmp_seq=3D48 ttl=3D64 time=3D0.052 ms
> 64 bytes from 168.16.0.1: icmp_seq=3D65 ttl=3D64 time=3D0.060 ms
> From 168.16.0.1 icmp_seq=3D80 Destination Host Unreachable
> From 168.16.0.1 icmp_seq=3D97 Destination Host Unreachable
> 64 bytes from 168.16.0.1: icmp_seq=3D100 ttl=3D64 time=3D0.022 ms
> 64 bytes from 168.16.0.1: icmp_seq=3D101 ttl=3D64 time=3D0.054 ms
> 64 bytes from 168.16.0.1: icmp_seq=3D103 ttl=3D64 time=3D0.053 ms
> From 168.16.0.1 icmp_seq=3D102 Destination Host Unreachable
> From 168.16.0.1 icmp_seq=3D127 Destination Host Unreachable
> 64 bytes from 168.16.0.1: icmp_seq=3D132 ttl=3D64 time=3D0.057 ms
> 64 bytes from 168.16.0.1: icmp_seq=3D135 ttl=3D64 time=3D0.051 ms
> 64 bytes from 168.16.0.1: icmp_seq=3D141 ttl=3D64 time=3D0.051 ms
> From 168.16.0.1 icmp_seq=3D140 Destination Host Unreachable
> From 168.16.0.1 icmp_seq=3D142 Destination Host Unreachable
> From 168.16.0.1 icmp_seq=3D150 Destination Host Unreachable
> From 168.16.0.1 icmp_seq=3D154 Destination Host Unreachable
> From 168.16.0.1 icmp_seq=3D164 Destination Host Unreachable
> From 168.16.0.1 icmp_seq=3D169 Destination Host Unreachable
> 64 bytes from 168.16.0.1: icmp_seq=3D173 ttl=3D64 time=3D0.056 ms
> 64 bytes from 168.16.0.1: icmp_seq=3D185 ttl=3D64 time=3D0.058 ms
> 64 bytes from 168.16.0.1: icmp_seq=3D202 ttl=3D64 time=3D0.056 ms
> 64 bytes from 168.16.0.1: icmp_seq=3D203 ttl=3D64 time=3D0.057 ms
> 64 bytes from 168.16.0.1: icmp_seq=3D219 ttl=3D64 time=3D0.050 ms
> 64 bytes from 168.16.0.1: icmp_seq=3D227 ttl=3D64 time=3D0.057 ms
> 64 bytes from 168.16.0.1: icmp_seq=3D228 ttl=3D64 time=3D0.044 ms
> From 168.16.0.1 icmp_seq=3D237 Destination Host Unreachable
> From 168.16.0.1 icmp_seq=3D239 Destination Host Unreachable
> 64 bytes from 168.16.0.1: icmp_seq=3D243 ttl=3D64 time=3D0.053 ms
> From 168.16.0.1 icmp_seq=3D242 Destination Host Unreachable
> 64 bytes from 168.16.0.1: icmp_seq=3D246 ttl=3D64 time=3D0.056 ms
> 64 bytes from 168.16.0.1: icmp_seq=3D254 ttl=3D64 time=3D0.056 ms
> 64 bytes from 168.16.0.1: icmp_seq=3D255 ttl=3D64 time=3D0.054 ms
> From 168.16.0.1 icmp_seq=3D263 Destination Host Unreachable
> From 168.16.0.1 icmp_seq=3D269 Destination Host Unreachable
> From 168.16.0.1 icmp_seq=3D273 Destination Host Unreachable
> 64 bytes from 168.16.0.1: icmp_seq=3D279 ttl=3D64 time=3D0.057 ms
> From 168.16.0.1 icmp_seq=3D284 Destination Host Unreachable
> From 168.16.0.1 icmp_seq=3D286 Destination Host Unreachable
> 64 bytes from 168.16.0.1: icmp_seq=3D291 ttl=3D64 time=3D0.054 ms
> 64 bytes from 168.16.0.1: icmp_seq=3D293 ttl=3D64 time=3D0.058 ms
> From 168.16.0.1 icmp_seq=3D294 Destination Host Unreachable
> From 168.16.0.1 icmp_seq=3D298 Destination Host Unreachable
> 64 bytes from 168.16.0.1: icmp_seq=3D309 ttl=3D64 time=3D0.056 ms
> From 168.16.0.1 icmp_seq=3D310 Destination Host Unreachable
> From 168.16.0.1 icmp_seq=3D312 Destination Host Unreachable
> 64 bytes from 168.16.0.1: icmp_seq=3D332 ttl=3D64 time=3D0.055 ms
> From 168.16.0.1 icmp_seq=3D334 Destination Host Unreachable
> 64 bytes from 168.16.0.1: icmp_seq=3D340 ttl=3D64 time=3D0.055 ms
> 64 bytes from 168.16.0.1: icmp_seq=3D344 ttl=3D64 time=3D0.050 ms
> 64 bytes from 168.16.0.1: icmp_seq=3D355 ttl=3D64 time=3D0.057 ms
> 64 bytes from 168.16.0.1: icmp_seq=3D358 ttl=3D64 time=3D0.050 ms
> From 168.16.0.1 icmp_seq=3D356 Destination Host Unreachable
> From 168.16.0.1 icmp_seq=3D369 Destination Host Unreachable
> 64 bytes from 168.16.0.1: icmp_seq=3D382 ttl=3D64 time=3D0.053 ms
> From 168.16.0.1 icmp_seq=3D381 Destination Host Unreachable
> From 168.16.0.1 icmp_seq=3D396 Destination Host Unreachable
> 64 bytes from 168.16.0.1: icmp_seq=3D400 ttl=3D64 time=3D0.058 ms
> From 168.16.0.1 icmp_seq=3D406 Destination Host Unreachable
> From 168.16.0.1 icmp_seq=3D414 Destination Host Unreachable
> From 168.16.0.1 icmp_seq=3D417 Destination Host Unreachable
> 64 bytes from 168.16.0.1: icmp_seq=3D422 ttl=3D64 time=3D0.018 ms
> 64 bytes from 168.16.0.1: icmp_seq=3D423 ttl=3D64 time=3D0.058 ms
> 64 bytes from 168.16.0.1: icmp_seq=3D429 ttl=3D64 time=3D0.056 ms
> 64 bytes from 168.16.0.1: icmp_seq=3D445 ttl=3D64 time=3D0.049 ms
> From 168.16.0.1 icmp_seq=3D444 Destination Host Unreachable
> From 168.16.0.1 icmp_seq=3D453 Destination Host Unreachable
> From 168.16.0.1 icmp_seq=3D455 Destination Host Unreachable
> 64 bytes from 168.16.0.1: icmp_seq=3D456 ttl=3D64 time=3D0.024 ms
> 64 bytes from 168.16.0.1: icmp_seq=3D469 ttl=3D64 time=3D0.058 ms
> From 168.16.0.1 icmp_seq=3D475 Destination Host Unreachable
> 64 bytes from 168.16.0.1: icmp_seq=3D483 ttl=3D64 time=3D0.054 ms
> From 168.16.0.1 icmp_seq=3D488 Destination Host Unreachable
> 64 bytes from 168.16.0.1: icmp_seq=3D504 ttl=3D64 time=3D0.056 ms
> 64 bytes from 168.16.0.1: icmp_seq=3D505 ttl=3D64 time=3D0.055 ms
> From 168.16.0.1 icmp_seq=3D510 Destination Host Unreachable
> From 168.16.0.1 icmp_seq=3D511 Destination Host Unreachable
> 64 bytes from 168.16.0.1: icmp_seq=3D516 ttl=3D64 time=3D0.055 ms
> From 168.16.0.1 icmp_seq=3D519 Destination Host Unreachable
> [  582.368938] Unable to handle kernel paging request at virtual address =
ffff0000f85f0000
> [  582.369732] Mem abort info:
> [  582.369987]   ESR =3D 0x96000007
> [  582.370266]   EC =3D 0x25: DABT (current EL), IL =3D 32 bits
> [  582.370833]   SET =3D 0, FnV =3D 0
> [  582.371113]   EA =3D 0, S1PTW =3D 0
> [  582.371391] Data abort info:
> [  582.371671]   ISV =3D 0, ISS =3D 0x00000007
> [  582.372017]   CM =3D 0, WnR =3D 0
> [  582.372299] swapper pgtable: 4k pages, 48-bit VAs, pgdp=3D000000012dab=
7000
> [  582.372896] [ffff0000f85f0000] pgd=3D000000013fff8003, p4d=3D000000013=
fff8003, pud=3D000000013f9f4003, pmd=3D000000013f838003, pte=3D000000000000=
0000
> [  582.374033] Internal error: Oops: 96000007 [#1] SMP
> [  582.374468] Modules linked in:
> [  582.374795] CPU: 1 PID: 525 Comm: ping Not tainted 5.8.0-rc6+ #3
> [  582.375468] Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 02/06/=
2015
> [  582.376215] pstate: 20400005 (nzCv daif +PAN -UAO BTYPE=3D--)
> [  582.376805] pc : __ip_local_out+0x84/0x188
> [  582.377234] lr : ip_local_out+0x34/0x68
> [  582.377635] sp : ffff800013263440
> [  582.377986] x29: ffff800013263440 x28: 0000000000000001
> [  582.378536] x27: ffff8000111d2018 x26: ffff8000114cba80
> [  582.379093] x25: ffff0000ec4e7400 x24: 0000000000000000
> [  582.379653] x23: 0000000000000062 x22: ffff8000114c9000
> [  582.380221] x21: ffff0000d97ac600 x20: ffff0000ec519000
> [  582.380778] x19: ffff8000115b5bc0 x18: 0000000000000000
> [  582.381324] x17: 0000000000000000 x16: 0000000000000000
> [  582.381876] x15: 0000000000000000 x14: 0000000000000000
> [  582.382431] x13: 0000000000000000 x12: 0000000000000001
> [  582.382986] x11: ffff800010d21838 x10: 0000000000000001
> [  582.383567] x9 : 0000000000000001 x8 : 0000000000000000
> [  582.384136] x7 : 0000000000000000 x6 : ffff0000ec4e5e00
> [  582.384693] x5 : 024079ca54000184 x4 : ffff0000ec4e5e10
> [  582.385246] x3 : 0000000000000000 x2 : ffff0004ec4e5e20
> [  582.385808] x1 : ffff0000f85f0000 x0 : 031d079626a9c7ae
> [  582.386365] Call trace:
> [  582.386629]  __ip_local_out+0x84/0x188
> [  582.387030]  ip_local_out+0x34/0x68
> [  582.387400]  ipvlan_queue_xmit+0x548/0x5c0
> [  582.387845]  ipvlan_start_xmit+0x2c/0x90
> [  582.388283]  dev_hard_start_xmit+0xb4/0x260
> [  582.388732]  sch_direct_xmit+0x1b4/0x550
> [  582.389145]  __qdisc_run+0x140/0x648
> [  582.389524]  __dev_queue_xmit+0x6a4/0x8b8
> [  582.389948]  dev_queue_xmit+0x24/0x30
> [  582.390339]  ip_finish_output2+0x324/0x580
> [  582.390770]  __ip_finish_output+0x130/0x218
> [  582.391218]  ip_finish_output+0x38/0xd0
> [  582.391633]  ip_output+0xb4/0x130
> [  582.391984]  ip_local_out+0x58/0x68
> [  582.392369]  ip_send_skb+0x2c/0x88
> [  582.392729]  ip_push_pending_frames+0x44/0x50
> [  582.393189]  raw_sendmsg+0x7a4/0x988
> [  582.393569]  inet_sendmsg+0x4c/0x78
> [  582.393942]  sock_sendmsg+0x58/0x68
> [  582.394311]  ____sys_sendmsg+0x284/0x2c0
> [  582.394721]  ___sys_sendmsg+0x90/0xd0
> [  582.395113]  __sys_sendmsg+0x78/0xd0
> [  582.395504]  __arm64_sys_sendmsg+0x2c/0x38
> [  582.395942]  el0_svc_common.constprop.2+0x70/0x128
> [  582.396472]  do_el0_svc+0x34/0xa0
> [  582.396834]  el0_sync_handler+0xec/0x128
> [  582.397249]  el0_sync+0x140/0x180
> [  582.397611] Code: ab030005 91001442 9a030000 8b020882 (b8404423)
> [  582.398264] ---[ end trace 92adb54c8611f8c5 ]---
> [  582.398754] Kernel panic - not syncing: Fatal exception in interrupt
> [  582.399481] SMP: stopping secondary CPUs
> [  582.399923] Kernel Offset: 0xc0000 from 0xffff800010000000
> [  582.400561] PHYS_OFFSET: 0x40000000
> [  582.400939] CPU features: 0x040002,22a08238
> [  582.401380] Memory Limit: none
> [  582.401710] ---[ end Kernel panic - not syncing: Fatal exception in in=
terrupt ]---
>
> This panic is because the ip header is corrupted. The ihl of the ip heade=
r is error=EF=BC=8Cthis cause ip_fast_csum access the illegal address.
> 23 static inline __sum16 ip_fast_csum(const void *iph, unsigned int ihl)
>  24 {
>  25     __uint128_t tmp;
>  26     u64 sum;
>  27
>  28     tmp =3D *(const __uint128_t *)iph;
>  29     iph +=3D 16;
>  30     ihl -=3D 4;                                           -----here, =
if ihl is smaller than 5, the next will access the illegal address.


Well, the bug is there then.

Code for other arches is different.

x86 for instance has a test for silly ihl

static inline __sum16 ip_fast_csum(const void *iph, unsigned int ihl)
{
unsigned int sum;

asm("  movl (%1), %0\n"
    "  subl $4, %2\n"
    "  jbe 2f\n"                          --- here
    "  addl 4(%1), %0\n"
    "  adcl 8(%1), %0\n"
    "  adcl 12(%1), %0\n"
    "1: adcl 16(%1), %0\n"
    "  lea 4(%1), %1\n"
    "  decl %2\n"
    "  jne 1b\n"
    "  adcl $0, %0\n"
    "  movl %0, %2\n"
    "  shrl $16, %0\n"
    "  addw %w2, %w0\n"
    "  adcl $0, %0\n"
    "  notl %0\n"
    "2:"
/* Since the input registers which are loaded with iph and ihl
   are modified, we must also specify them as outputs, or gcc
   will assume they contain their original values. */
    : "=3Dr" (sum), "=3Dr" (iph), "=3Dr" (ihl)
    : "1" (iph), "2" (ihl)
    : "memory");
return (__force __sum16)sum;
}


>  31     tmp +=3D ((tmp >> 64) | (tmp << 64));
>  32     sum =3D tmp >> 64;
>  33     do {
>  34         sum +=3D *(const u32 *)iph;
>  35         iph +=3D 4;
>  36     } while (--ihl);
>  37
>  38     sum +=3D ((sum >> 32) | (sum << 32));
>  39     return csum_fold((__force u32)(sum >> 32));
>  40 }
>
> I think this panic may be a problem, thanks.
>
>
>
> -----=E9=82=AE=E4=BB=B6=E5=8E=9F=E4=BB=B6-----
> =E5=8F=91=E4=BB=B6=E4=BA=BA: Cong Wang [mailto:xiyou.wangcong@gmail.com]
> =E5=8F=91=E9=80=81=E6=97=B6=E9=97=B4: Wednesday, July 22, 2020 3:39
> =E6=94=B6=E4=BB=B6=E4=BA=BA: Guodeqing (A) <geffrey.guo@huawei.com>
> =E6=8A=84=E9=80=81: David Miller <davem@davemloft.net>; Jakub Kicinski <k=
uba@kernel.org>; Mahesh Bandewar <maheshb@google.com>; Eric Dumazet <edumaz=
et@google.com>; Linux Kernel Network Developers <netdev@vger.kernel.org>
> =E4=B8=BB=E9=A2=98: Re: [PATCH] ipvlan: add the check of ip header checks=
um
>
> On Tue, Jul 21, 2020 at 6:17 AM guodeqing <geffrey.guo@huawei.com> wrote:
> >
> > The ip header checksum can be error in the following steps.
> > $ ip netns add ns1
> > $ ip link add gw link eth0 type ipvlan $ ip addr add 168.16.0.1/24 dev
> > gw $ ip link set dev gw up $ ip link add ip1 link eth0 type ipvlan $
> > ip link set ip1 netns ns1 $ ip netns exec ns1 ip link set ip1 up $ ip
> > netns exec ns1 ip addr add 168.16.0.2/24 dev ip1 $ ip netns exec ns1
> > tc qdisc add dev ip1 root netem corrupt 50% $ ip netns exec ns1 ping
> > 168.16.0.1
> >
> > The ip header of a packet maybe modified when it steps in
> > ipvlan_process_v4_outbound because of the netem, the corruptted
> > packets should be dropped.
>
> This does not make much sense, as you intentionally corrupt the header. M=
ore importantly, the check you add is too late, right?
> ipvlan_xmit_mode_l3() already does the addr lookup with IP header,
>
> Thanks.
>
> -----=E9=82=AE=E4=BB=B6=E5=8E=9F=E4=BB=B6-----
> =E5=8F=91=E4=BB=B6=E4=BA=BA: David Miller [mailto:davem@davemloft.net]
> =E5=8F=91=E9=80=81=E6=97=B6=E9=97=B4: Thursday, July 23, 2020 4:04
> =E6=94=B6=E4=BB=B6=E4=BA=BA: Guodeqing (A) <geffrey.guo@huawei.com>
> =E6=8A=84=E9=80=81: kuba@kernel.org; maheshb@google.com; edumazet@google.=
com; netdev@vger.kernel.org
> =E4=B8=BB=E9=A2=98: Re: [PATCH,v2] ipvlan: add the check of ip header che=
cksum
>
> From: guodeqing <geffrey.guo@huawei.com>
> Date: Wed, 22 Jul 2020 17:18:19 +0800
>
> > The ip header checksum can be error in the following steps.
>
> You did not respond to my feedback from your previous submissions.
>
> Packets created inside of the kernel have correct checksums, and the ipvl=
an driver can depend upon this precondition.
>
> I am not applying this patch, sorry.
