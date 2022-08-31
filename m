Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7855A8077
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 16:42:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231944AbiHaOmV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 10:42:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231936AbiHaOmS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 10:42:18 -0400
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EC45C3F7E;
        Wed, 31 Aug 2022 07:42:17 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 5864932007D7;
        Wed, 31 Aug 2022 10:42:12 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 31 Aug 2022 10:42:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cerno.tech; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:message-id
        :mime-version:reply-to:sender:subject:subject:to:to; s=fm3; t=
        1661956930; x=1662043330; bh=wgddTPMrnv5MJa6nI4oUHuH16TmALCsoINA
        DyvR3vOM=; b=bEEJXBO5F4bg/rhDlik9lU4mJq35Xq06kI/Ay8gtE9R5I/Pqg+Y
        01K9rxdCVMbJ1Q83HaUuHcQ8km4PO68AEJnAP5OIZr0QzaZ2Et7kEDsGs1gVG/JK
        H1ZitwxG8j0JZ+r3LvVzNpzCDjEzgwJnjXWUGK6VaXlVT24Az2DmuOtKOG59YCU/
        ljEHx3mA/DHSN9D0HQO49dvTY2CFzWxjXKbZuOy92IR6/pYmhgiYOeBeiiCfwUAh
        ewWzCxntg3wMwckU926xU+2bHsyp4P9KIAavrqXe4QcxokmDEKJ+DnyyTkdjiU7G
        ohy/2eAUN6/dezcEEJmdlCpipDSs3S0m5HQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:message-id:mime-version
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1661956930; x=
        1662043330; bh=wgddTPMrnv5MJa6nI4oUHuH16TmALCsoINADyvR3vOM=; b=4
        B3s0nf2VTHp3uC2IkmvyWvrrLSUPEXw6ZoYAv7I2p7k9MXAojEm99iG+vS53tu3v
        E9Mwf2lgxx2xjhKjQB0r99TakUTnsSKT34qyMAgU3UKktesWYDsxG1G1f471pWMw
        0RP78eOBxcNBW10o3XwE6swoaMYXAeHu/rlLtlchZ+iA07gTKs8rlVRYTOE6W9zh
        iJOaDyvsmltm4P4oAkIeYKhxk9OmixXxU5F+zzHJacRu1rjRkQZu1ZW90zfXh910
        ZWnlPyKVjHMxrJjJGOQnSaaPO6kV1PnmDQ100Ok1BfkH/04hq3oU2nMR2yJCVpCu
        YMa4BCbzjnNN336kNtHqQ==
X-ME-Sender: <xms:QHMPY71THxvMOkHW22SJHYLklFaGuY8rOwTCjg5NtRC__Nu7DmE2lg>
    <xme:QHMPY6GRxBEdCRDL8wVgLzs0WNBorLV6fdIBVfgmtJ9DFv5__oSVPMKTOVOxwZ4iy
    XpcS10M48bih-yjODk>
X-ME-Received: <xmr:QHMPY77_VAF5dxzZggPSTv5PqjfCzixz-mXeYVEEK2E4lmJXcLAyopR0pDgH>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdekiedghedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkgggtugesthdtredttddtvdenucfhrhhomhepofgrgihimhgv
    ucftihhprghrugcuoehmrgigihhmvgestggvrhhnohdrthgvtghhqeenucggtffrrghtth
    gvrhhnpedtleevgfehjeejfeekgeelffeiveektdeguddujeetiedvhfdvuedtheehvdfg
    jeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehmrg
    igihhmvgestggvrhhnohdrthgvtghh
X-ME-Proxy: <xmx:QHMPYw0EAbsVd68V-TNC5e1awIQ8-sFhicdPPLe5u9NTHCSNQjO_XQ>
    <xmx:QHMPY-ErUsfwMcW2KWJbcgREzGicy3jlvT00qjicyBaxD53DqK9Hbw>
    <xmx:QHMPYx9xu8Mq8bV3PTBSqRynUkxGmPYpsuglKfr1Fyx4mHYZkdexSw>
    <xmx:QnMPY2RP8hNoGD0N29CeC8WE9lsiopPMjrlQ2PqF0oLUGK56HVFRBA>
Feedback-ID: i8771445c:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 31 Aug 2022 10:42:07 -0400 (EDT)
Date:   Wed, 31 Aug 2022 16:42:05 +0200
From:   Maxime Ripard <maxime@cerno.tech>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Daniel Vetter <daniel.vetter@intel.com>,
        David Airlie <airlied@linux.ie>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Maxime Ripard <maxime@cerno.tech>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Roman Gushchin <roman.gushchin@linux.dev>
Cc:     Martin Roukala <martin.roukala@mupuf.org>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Dave Stevenson <dave.stevenson@raspberrypi.com>,
        Phil Elwell <phil@raspberrypi.com>,
        Tim Gover <tim.gover@raspberrypi.com>,
        Dom Cobley <dom@raspberrypi.com>
Subject: RaspberryPi4 Panic in net_ns_init()
Message-ID: <20220831144205.iirdun6bf3j5v6q4@houat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Sorry for the fairly broad list of recipients, I'm not entirely sure
where the issue lies exactly, and it seems like multiple areas are
involved.

Martin reported me an issue discovered with the VC4 DRM driver that
would prevent the RaspberryPi4 from booting entirely. At boot, and
apparently before the console initialization, the board would just die.

It first appeared when both DYNAMIC_DEBUG and DRM_VC4 were built-in. We
started to look into what configuration would trigger it.

It looks like a good reproducer is:

ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- make -j18 defconfig mod2yesconfig
./scripts/config -e CONFIG_DYNAMIC_DEBUG
ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- make -j18 olddefconfig

If we enable earlycon, we end up with:

[    0.000000] Booting Linux on physical CPU 0x0000000000 [0x410fd083]
[    0.000000] Linux version 6.0.0-rc3 (max@houat) (aarch64-linux-gnu-gcc (GCC) 12.1.1 20220507 (Red Hat Cross 12.1.1-1), GNU ld version 2.37-7.fc36) #52 SMP PREEMPT Wed Aug 31 14:28:41 CEST 2022
[    0.000000] random: crng init done
[    0.000000] Machine model: Raspberry Pi 4 Model B Rev 1.1
[    0.000000] earlycon: uart8250 at MMIO32 0x00000000fe215040 (options '')
[    0.000000] printk: bootconsole [uart8250] enabled
[    0.000000] efi: UEFI not found.
[    0.000000] Reserved memory: bypass linux,cma node, using cmdline CMA params instead
[    0.000000] OF: reserved mem: node linux,cma compatible matching fail
[    0.000000] NUMA: No NUMA configuration found
[    0.000000] NUMA: Faking a node at [mem 0x0000000000000000-0x00000000fbffffff]
[    0.000000] NUMA: NODE_DATA [mem 0xfb815b40-0xfb817fff]
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x0000000000000000-0x000000003fffffff]
[    0.000000]   DMA32    [mem 0x0000000040000000-0x00000000fbffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000000000000-0x000000003b3fffff]
[    0.000000]   node   0: [mem 0x0000000040000000-0x00000000fbffffff]
[    0.000000] Initmem setup node 0 [mem 0x0000000000000000-0x00000000fbffffff]
[    0.000000] On node 0, zone DMA32: 19456 pages in unavailable ranges
[    0.000000] On node 0, zone DMA32: 16384 pages in unavailable ranges
[    0.000000] cma: Reserved 512 MiB at 0x000000000ee00000
[    0.000000] percpu: Embedded 21 pages/cpu s48040 r8192 d29784 u86016
[    0.000000] Detected PIPT I-cache on CPU0
[    0.000000] CPU features: detected: Spectre-v2
[    0.000000] CPU features: detected: Spectre-v3a
[    0.000000] CPU features: detected: Spectre-v4
[    0.000000] CPU features: detected: Spectre-BHB
[    0.000000] CPU features: detected: Kernel page table isolation (KPTI)
[    0.000000] CPU features: detected: ARM erratum 1742098
[    0.000000] CPU features: detected: ARM errata 1165522, 1319367, or 1530923
[    0.000000] Fallback order for Node 0: 0
[    0.000000] Built 1 zonelists, mobility grouping on.  Total pages: 996912
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: video=Composite-1:720x480@60i,margin_left=32,margin_right=32,margin_top=32,margin_bottom=32 dma.dmachans=0x37f5 bcm2709.boardrev=0xc03111 bcm2709.serial=0xb7f44626 bcm2709.uart_clock=48000000 bcm2709.disk_led_gpio=42 bcm2709.disk_led_active_low=0 smsc95xx.macaddr=DC:A6:32:0E:F7:01 vc_mem.mem_base=0x3ec00000 vc_mem.mem_size=0x40000000  root=/dev/nfs nfsroot=192.168.20.10:/srv/nfs/rpi/bullseye64 rw 8250.nr_uarts=1 cma=512M ip=dhcp console=ttyS0,115200 earlycon=uart8250,mmio32,0xfe215040
[    0.000000] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes, linear)
[    0.000000] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes, linear)
[    0.000000] mem auto-init: stack:all(zero), heap alloc:off, heap free:off
[    0.000000] software IO TLB: area num 4.
[    0.000000] software IO TLB: mapped [mem 0x0000000037400000-0x000000003b400000] (64MB)
[    0.000000] Memory: 3312220K/4050944K available (30656K kernel code, 5924K rwdata, 18912K rodata, 11584K init, 672K bss, 214436K reserved, 524288K cma-reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] rcu: Preemptible hierarchical RCU implementation.
[    0.000000] rcu: 	RCU event tracing is enabled.
[    0.000000] rcu: 	RCU restricting CPUs from NR_CPUS=256 to nr_cpu_ids=4.
[    0.000000] 	Trampoline variant of Tasks RCU enabled.
[    0.000000] 	Tracing variant of Tasks RCU enabled.
[    0.000000] rcu: RCU calculated value of scheduler-enlistment delay is 25 jiffies.
[    0.000000] rcu: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=4
[    0.000000] NR_IRQS: 64, nr_irqs: 64, preallocated irqs: 0
[    0.000000] Root IRQ handler: gic_handle_irq
[    0.000000] GIC: Using split EOI/Deactivate mode
[    0.000000] rcu: srcu_init: Setting srcu_struct sizes based on contention.
[    0.000000] arch_timer: cp15 timer(s) running at 54.00MHz (phys).
[    0.000000] clocksource: arch_sys_counter: mask: 0xffffffffffffff max_cycles: 0xc743ce346, max_idle_ns: 440795203123 ns
[    0.000001] sched_clock: 56 bits at 54MHz, resolution 18ns, wraps every 4398046511102ns
[    0.008648] Console: colour dummy device 80x25
[    0.013237] Calibrating delay loop (skipped), value calculated using timer frequency.. 108.00 BogoMIPS (lpj=216000)
[    0.023803] pid_max: default: 32768 minimum: 301
[    0.028540] LSM: Security Framework initializing
[    0.033252] Kernel panic - not syncing: Could not allocate generic netns
[    0.040026] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 6.0.0-rc3 #52
[    0.046363] Hardware name: Raspberry Pi 4 Model B Rev 1.1 (DT)
[    0.052255] Call trace:
[    0.054721]  dump_backtrace+0xe4/0x124
[    0.058525]  show_stack+0x1c/0x5c
[    0.061878]  dump_stack_lvl+0x64/0x80
[    0.065582]  dump_stack+0x1c/0x38
[    0.068932]  panic+0x170/0x328
[    0.072020]  net_ns_init+0x88/0x134
[    0.075548]  start_kernel+0x628/0x69c
[    0.079251]  __primary_switched+0xbc/0xc4
[    0.083311] ---[ end Kernel panic - not syncing: Could not allocate generic netns ]---

So it seems that net_alloc_generic() fails, and the only reason I could
see is if kzalloc() fails, so now I'm super confused.

It looks like the board has plenty (~3GB) of RAM available at boot, and
most importantly I don't see the relationship between a DRM driver,
DYNAMIC_DEBUG, and SLAB or the network namespace.

After a bit more experiments,

 * ./scripts/config -e CONFIG_DYNAMIC_DEBUG -d CONFIG_DRM_VC4 still has
   that panic, so it looks like VC4 itself isn't involved.

 * ./scripts/config -e CONFIG_DYNAMIC_DEBUG -d CONFIG_DRM works, so DRM
   seems to be involved somehow. It has a number of memory management
   dependencies, so it's probably a side effect of DRM being there.

 * make defconfig mod2yesconfig (so without DYNAMIC_DEBUG, with DRM)
   works too.

So it looks to me like there's indeed some interaction between DRM,
DYNAMIC_DEBUG, SLAB and/or the network namespace, but I'm not entirely
sure where to go from there. Any ideas?

Maxime
