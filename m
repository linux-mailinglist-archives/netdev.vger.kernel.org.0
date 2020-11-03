Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A7762A4AE5
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 17:13:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727975AbgKCQNY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 11:13:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727109AbgKCQNX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 11:13:23 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C57EC0613D1
        for <netdev@vger.kernel.org>; Tue,  3 Nov 2020 08:13:23 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id l24so18868146edj.8
        for <netdev@vger.kernel.org>; Tue, 03 Nov 2020 08:13:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mUoRul84vOwAQQD3Ky9zccS3L3s1uyt1PSK6na42oSk=;
        b=l/dn1RMnkh8ux3llyz8s7s56gC+H3NlkueeaAoYjsa8Shx8/lhok4VDE4FWjP1EIYX
         biKRF9/9+FH0K7kyXyuhYr6xfqUfwszIXLeRovjEnwaqJcPDLAzT+WuRyti5jZGkveOJ
         z5MkLS99SOPbMxM/mS6/iK3uXnhRBboHKUaWEhP6PGh+PHvBEPsAzpeaBamq5WQlM0SB
         v1zNONWJJYfwmhO2tJOmRRF9ocg8JuooaCZ1TkkUdRIUulydeUH6oAulruhZ0vkMgNk2
         DNSW3cQV8Xg/G7OAGowKqsqJNKmAajEE52vH4WV/YIOLkVFtQ5+KhYInk1u5yYAZT3Qe
         rlgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mUoRul84vOwAQQD3Ky9zccS3L3s1uyt1PSK6na42oSk=;
        b=HgLTS80kSntTb+ofVpBGzocv1vEphTWNA9RFtcPZKJslabF4vGNP+DJCRa+5pRs8QM
         R2v4sd7ePuaRwp6LeC4Uam+ChL1129K8Xhe51dWW1zGxauV2JO2U3ilhUFTjiM4pZtgf
         B//UQOqbgvU6vo5Ea2U92ZsECkZrEH0eF87jL1jMurmC5xZTdnD5f3OOFjMRZD3e7xgj
         UtcVW9/WfdGQYdtTv5GC6xuB7ciRospL8sKiMXcCXmFtjB1oM3fOEw87ZHUdXogyE6at
         rcmt82ir6sl4LyPfdp8/yuTOd6xK4bRjTYXOMFLKz/Fa5eXuQHnNZBJ5iMgssYcq6ipF
         wv+g==
X-Gm-Message-State: AOAM530RYS3Hq8cD59hEI01wlj6/pE8NltkvZFAALeNgq89VMoIUlgIC
        hQSTtPCAeMiX0NvCUmu+5wA=
X-Google-Smtp-Source: ABdhPJw/V7IfQ7NI45dUJdUxMKrZ6Q78P0eeRSOjH8RelixOjxq8TU2aFcqesYC+vWt0mxhSQzj/9w==
X-Received: by 2002:aa7:cb1a:: with SMTP id s26mr22502594edt.219.1604420001919;
        Tue, 03 Nov 2020 08:13:21 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id z22sm10961872ejw.107.2020.11.03.08.13.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 08:13:21 -0800 (PST)
Date:   Tue, 3 Nov 2020 18:13:19 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, james.jurack@ametek.com
Subject: Re: [PATCH net v2 1/2] gianfar: Replace skb_realloc_headroom with
 skb_cow_head for PTP
Message-ID: <20201103161319.wisvmjbdqhju6vyh@skbuf>
References: <fa12d66e-de52-3e2e-154c-90c775bb4fe4@ametek.com>
 <20201029081057.8506-1-claudiu.manoil@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201029081057.8506-1-claudiu.manoil@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 29, 2020 at 10:10:56AM +0200, Claudiu Manoil wrote:
> When PTP timestamping is enabled on Tx, the controller
> inserts the Tx timestamp at the beginning of the frame
> buffer, between SFD and the L2 frame header.  This means
> that the skb provided by the stack is required to have
> enough headroom otherwise a new skb needs to be created
> by the driver to accommodate the timestamp inserted by h/w.
> Up until now the driver was relying on skb_realloc_headroom()
> to create new skbs to accommodate PTP frames.  Turns out that
> this method is not reliable in this context at least, as
> skb_realloc_headroom() for PTP frames can cause random crashes,
> mostly in subsequent skb_*() calls, when multiple concurrent
> TCP streams are run at the same time with the PTP flow
> on the same device (as seen in James' report).  I also noticed
> that when the system is loaded by sending multiple TCP streams,
> the driver receives cloned skbs in large numbers.
> skb_cow_head() instead proves to be stable in this scenario,
> and not only handles cloned skbs too but it's also more efficient
> and widely used in other drivers.
> The commit introducing skb_realloc_headroom in the driver
> goes back to 2009, commit 93c1285c5d92
> ("gianfar: reallocate skb when headroom is not enough for fcb").
> For practical purposes I'm referencing a newer commit (from 2012)
> that brings the code to its current structure (and fixes the PTP
> case).
> 
> Fixes: 9c4886e5e63b ("gianfar: Fix invalid TX frames returned on error queue when time stamping")
> Reported-by: James Jurack <james.jurack@ametek.com>
> Suggested-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
> ---

Still crashes for me:

[root@LS1021ATSN ~] # ./ptp4l -i eth1 -f /etc/ptp4l_cfg/gPTP.cfg --tx_timestamp_timeout 20 &
[1] 887
[root@LS1021ATSN ~] # ./perf record -e cycles iperf3 -c 192.168.1.2 -t 100
Connecting to host 192.168.1.2, port 5201
[  5] local 192.168.1.1 port 59152 connected to 192.168.1.2 port 5201
[ ID] Interval           Transfer     Bitrate         Retr  Cwnd
[  5]   0.00-1.00   sec   111 MBytes   932 Mbits/sec    0    267 KBytes
[  5]   1.00-2.00   sec   111 MBytes   935 Mbits/sec    0    298 KBytes
[  5]   2.00-3.00   sec   112 MBytes   941 Mbits/sec    0    325 KBytes
[  5]   3.00-4.00   sec   112 MBytes   938 Mbits/sec    0    344 KBytes
[  5]   4.00-5.01   sec   108 MBytes   898 Mbits/sec    0    352 KBytes
[  5]   5.01-6.00   sec  93.8 MBytes   789 Mbits/sec    0    354 KBytes
[  5]   6.00-7.00   sec  93.8 MBytes   786 Mbits/sec    0    354 KBytes
[  5]   7.00-8.01   sec   101 MBytes   844 Mbits/sec    0    369 KBytes
[  5]   8.01-9.00   sec   107 MBytes   910 Mbits/sec    0    373 KBytes
[  5]   9.00-10.00  sec   113 MBytes   944 Mbits/sec    0    396 KBytes
[  5]  10.00-11.00  sec   112 MBytes   939 Mbits/sec    0    436 KBytes
[  5]  11.00-12.00  sec   112 MBytes   939 Mbits/sec    0    436 KBytes
[  5]  12.00-13.00  sec   113 MBytes   944 Mbits/sec    0    462 KBytes
[  5]  13.00-14.01  sec  96.0 MBytes   799 Mbits/sec    0    492 KBytes
[  5]  14.01-15.01  sec  93.8 MBytes   788 Mbits/sec    0    570 KBytes
[  5]  15.01-16.00  sec   106 MBytes   894 Mbits/sec    0    708 KBytes
[  5]  16.00-17.00  sec   107 MBytes   898 Mbits/sec    0    844 KBytes
[  5]  17.00-18.00  sec   105 MBytes   882 Mbits/sec    0    997 KBytes
[  5]  18.00-19.00  sec   103 MBytes   863 Mbits/sec    0   1.07 MBytes
[14538.007252] 8<--- cut here ---
[14538.010310] Unable to handle kernel NULL pointer dereference at virtual address 00000008
[14538.018395] pgd = d79f0b3d
[14538.021108] [00000008] *pgd=80000080204003, *pmd=00000000
[14538.026553] Internal error: Oops: 207 [#1] SMP ARM
[14538.031324] Modules linked in:
[14538.034368] CPU: 0 PID: 9 Comm: ksoftirqd/0 Not tainted 5.10.0-rc1-00296-g37442a47b604 #707
[14538.042672] Hardware name: Freescale LS1021A
[14538.046926] PC is at skb_release_data+0x6c/0x14c
[14538.051518] LR is at consume_skb+0x38/0xd8
[14538.055588] pc : [<c10e439c>]    lr : [<c10e3fac>]    psr: 200f0013
[14538.061817] sp : c28f1da8  ip : 00000000  fp : c265aa40
[14538.067010] r10: 00000000  r9 : 00000000  r8 : c2f98000
[14538.072204] r7 : c511d900  r6 : c3d3d900  r5 : c3d3d900  r4 : 00000000
[14538.078693] r3 : 000000d3  r2 : 00000001  r1 : 00000000  r0 : 00000000
[14538.085184] Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
[14538.092279] Control: 30c5387d  Table: 848c7d00  DAC: fffffffd
[14538.097994] Process ksoftirqd/0 (pid: 9, stack limit = 0x6d78b0e1)
[14538.104139] Stack: (0xc28f1da8 to 0xc28f2000)
[14538.108472] 1da0:                   c511d900 c511d900 c5271a80 c2f1f900 c2f98000 c10e3fac
[14538.116606] 1dc0: c2f6d600 c0d529bc c28f1ecc c04aa7d4 00000001 337a26ba 00000018 c2f6e36c
[14538.124741] 1de0: 00000000 c04aa838 ec05c800 c2406f78 f088c000 c04aee10 c236edac 00000045
[14538.132876] 1e00: c236edac c511d900 c2f98000 00000000 00000000 c2f1f900 00000044 c2403d00
[14538.141011] 1e20: c265aa40 c10fcdf8 c0d51064 600f0013 c265aa60 c236eda4 c24087f0 ffffe000
[14538.149146] 1e40: c240675c c28f1e78 c2f98600 c511d900 c4b95000 c2406708 00000000 c2f1f900
[14538.157280] 1e60: c2f98000 00000000 c2403080 c1158524 c28f1ecc 0065ac80 00000010 337a26ba
[14538.165415] 1e80: c4b95000 00000001 c511d900 00000040 c2f1f900 00000000 c265ae20 c1158858
[14538.173549] 1ea0: 00000000 00000000 c2f98608 c4b95040 c265ae20 ffffe000 c240675c 2903d000
[14538.181684] 1ec0: ffffe000 c4b95000 00000000 00000000 00000000 ffffe000 c2654040 00000100
[14538.189818] 1ee0: c2403080 c10f959c c2403088 00000003 0000000c 00000002 ffffe000 c2654040
[14538.197954] 1f00: 00000100 c04013f0 00000001 c1404ab4 c2364390 c236fdc0 c240675c 00000009
[14538.206088] 1f20: c236431c 0015ba25 c2403d00 c1608068 04208040 c28db200 ffffe000 c28ab240
[14538.214222] 1f40: ffffe000 00000000 00000001 c24261a4 00000002 00000000 c28ab2e4 c0450180
[14538.222357] 1f60: c28ab240 c047022c c28ab2c0 c28ab280 00000000 c28f0000 c047011c c28ab240
[14538.230491] 1f80: c28cbe34 c046c5c4 00000001 c28ab280 c046c478 00000000 00000000 00000000
[14538.238625] 1fa0: 00000000 00000000 00000000 c0400278 00000000 00000000 00000000 00000000
[14538.246758] 1fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[14538.254892] 1fe0: 00000000 00000000 00000000 00000000 00000013 00000000 00000000 00000000
[14538.263039] [<c10e439c>] (skb_release_data) from [<c10e3fac>] (consume_skb+0x38/0xd8)
[14538.270834] [<c10e3fac>] (consume_skb) from [<c0d529bc>] (gfar_start_xmit+0x704/0x784)
[14538.278714] [<c0d529bc>] (gfar_start_xmit) from [<c10fcdf8>] (dev_hard_start_xmit+0xfc/0x254)
[14538.287198] [<c10fcdf8>] (dev_hard_start_xmit) from [<c1158524>] (sch_direct_xmit+0x104/0x2e0)
[14538.295767] [<c1158524>] (sch_direct_xmit) from [<c1158858>] (__qdisc_run+0x158/0x5fc)
[14538.303644] [<c1158858>] (__qdisc_run) from [<c10f959c>] (net_tx_action+0x144/0x2b8)
[14538.311350] [<c10f959c>] (net_tx_action) from [<c04013f0>] (__do_softirq+0x130/0x3b8)
[14538.319145] [<c04013f0>] (__do_softirq) from [<c0450180>] (run_ksoftirqd+0x2c/0x38)
[14538.326766] [<c0450180>] (run_ksoftirqd) from [<c047022c>] (smpboot_thread_fn+0x110/0x1a8)
[14538.334991] [<c047022c>] (smpboot_thread_fn) from [<c046c5c4>] (kthread+0x14c/0x150)
[14538.342696] [<c046c5c4>] (kthread) from [<c0400278>] (ret_from_fork+0x14/0x3c)
[14538.349877] Exception stack(0xc28f1fb0 to 0xc28f1ff8)
[14538.354898] 1fa0:                                     00000000 00000000 00000000 00000000
[14538.363032] 1fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[14538.371164] 1fe0: 00000000 00000000 00000000 00000000 00000013 00000000
[14538.377744] Code: 11a05006 13a04000 0a000014 e5950028 (e5903008)
[14538.383877] ---[ end trace bb4785b99c68319a ]---
[14538.388529] Kernel panic - not syncing: Fatal exception in interrupt
[14538.394858] CPU1: stopping
[14538.397555] CPU: 1 PID: 907 Comm: iperf3 Tainted: G      D           5.10.0-rc1-00296-g37442a47b604 #707
[14538.406981] Hardware name: Freescale LS1021A
[14538.411238] [<c04120b8>] (unwind_backtrace) from [<c040c554>] (show_stack+0x10/0x14)
[14538.418946] [<c040c554>] (show_stack) from [<c13fabfc>] (dump_stack+0xc8/0xdc)
[14538.426134] [<c13fabfc>] (dump_stack) from [<c040f83c>] (do_handle_IPI+0x320/0x33c)
[14538.433752] [<c040f83c>] (do_handle_IPI) from [<c040f870>] (ipi_handler+0x18/0x20)
[14538.441286] [<c040f870>] (ipi_handler) from [<c04b0028>] (handle_percpu_devid_fasteoi_ipi+0x80/0x150)
[14538.450462] [<c04b0028>] (handle_percpu_devid_fasteoi_ipi) from [<c04a981c>] (generic_handle_irq+0x34/0x44)
[14538.460156] [<c04a981c>] (generic_handle_irq) from [<c04a9e08>] (__handle_domain_irq+0x5c/0xb4)
[14538.468814] [<c04a9e08>] (__handle_domain_irq) from [<c08f89dc>] (gic_handle_irq+0x94/0xb4)
[14538.477125] [<c08f89dc>] (gic_handle_irq) from [<c0400c38>] (__irq_svc+0x58/0x74)
[14538.484564] Exception stack(0xc4fdbdd0 to 0xc4fdbe18)
[14538.489587] bdc0:                                     c26e27e8 a00e0013 0000000f 0000f4f6
[14538.497721] bde0: 00000000 c2afb000 00000000 00000002 00000fff c26e27e8 c3e65e00 c1e55086
[14538.505854] be00: 0000000a c4fdbe20 c0ad6bb0 c1409670 800e0013 ffffffff
[14538.512437] [<c0400c38>] (__irq_svc) from [<c1409670>] (_raw_spin_unlock_irqrestore+0x1c/0x20)
[14538.521007] [<c1409670>] (_raw_spin_unlock_irqrestore) from [<c0ad6bb0>] (uart_write+0xf4/0x1f0)
[14538.529749] [<c0ad6bb0>] (uart_write) from [<c0ab759c>] (do_output_char+0x160/0x1e4)
[14538.537453] [<c0ab759c>] (do_output_char) from [<c0ab83ac>] (n_tty_write+0x228/0x480)
[14538.545243] [<c0ab83ac>] (n_tty_write) from [<c0ab6168>] (tty_write+0x12c/0x33c)
[14538.552604] [<c0ab6168>] (tty_write) from [<c0602d28>] (vfs_write+0xc4/0x334)
[14538.559705] [<c0602d28>] (vfs_write) from [<c0603114>] (ksys_write+0xa4/0xd4)
[14538.566805] [<c0603114>] (ksys_write) from [<c04001a0>] (ret_fast_syscall+0x0/0x4c)
[14538.574417] Exception stack(0xc4fdbfa8 to 0xc4fdbff0)
[14538.579440] bfa0:                   0000004f 00022bd0 00000001 00022bd0 0000004f 00000000
[14538.587574] bfc0: 0000004f 00022bd0 b6f0e6d0 00000004 0000004f b6ed4f7d b6ed2e2c 00000000
[14538.595707] bfe0: 00000004 be9e1d18 b6b810f7 b6b0c856
[14538.600736] Rebooting in 3 seconds..

Takes a while to reproduce though.
