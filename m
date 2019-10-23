Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA506E1363
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 09:47:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389913AbfJWHr0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 03:47:26 -0400
Received: from mx2.suse.de ([195.135.220.15]:39440 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388235AbfJWHr0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Oct 2019 03:47:26 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9F558B3FE;
        Wed, 23 Oct 2019 07:47:23 +0000 (UTC)
Date:   Wed, 23 Oct 2019 09:47:19 +0200
From:   Daniel Wagner <dwagner@suse.de>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rt-users@vger.kernel.org,
        Woojung Huh <woojung.huh@microchip.com>,
        Marc Zyngier <maz@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Stefan Wahren <wahrenst@gmx.net>,
        Jisheng Zhang <Jisheng.Zhang@synaptics.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] net: usb: lan78xx: Use phy_mac_interrupt() for interrupt
 handling
Message-ID: <20191023074719.gcov5xfrcvns5tlg@beryllium.lan>
References: <20191018082817.111480-1-dwagner@suse.de>
 <20191018131532.dsfhyiilsi7cy4cm@linutronix.de>
 <20191022101747.001b6d06@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191022101747.001b6d06@cakuba.netronome.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Wouldn't handle_nested_irq() work here instead of the simple thingy?
> 
> Daniel could you try this suggestion? Would it work?


[    6.427289] ------------[ cut here ]------------
[    6.431977] kernel BUG at drivers/net/phy/mdio_bus.c:626!
[    6.437453] Internal error: Oops - BUG: 0 [#1] PREEMPT SMP
[    6.443013] Modules linked in:
[    6.446116] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.4.0-rc3-00100-g70cc5ab156c3-dirty #50
[    6.454763] Hardware name: Raspberry Pi 3 Model B+ (DT)
[    6.460062] pstate: 00000005 (nzcv daif -PAN -UAO)
[    6.464928] pc : mdiobus_read+0x68/0x70
[    6.468821] lr : lan88xx_phy_ack_interrupt+0x1c/0x30
[    6.473852] sp : ffff800010003d70
[    6.477208] x29: ffff800010003d70 x28: 0000000000000000 
[    6.482597] x27: 0000000000000001 x26: 0000000000000060 
[    6.487985] x25: 00000000000000e0 x24: ffff8000113ca680 
[    6.493373] x23: ffff0000372ac174 x22: ffff00003768f6d4 
[    6.498762] x21: ffff00003768f600 x20: 0000000000000000 
[    6.504149] x19: ffff0000372c1000 x18: 000000000000000e 
[    6.509537] x17: 0000000000000001 x16: 0000000000000007 
[    6.514923] x15: 000000000000000e x14: 0000000000000013 
[    6.520311] x13: 0000000000000000 x12: 0000000000000000 
[    6.525699] x11: 000000000000057b x10: 0000000000000003 
[    6.531087] x9 : ffff0000383f4750 x8 : ffff0000383f3dc0 
[    6.536474] x7 : ffff0000374be100 x6 : ffff0000383f4750 
[    6.541862] x5 : ffff000037cab700 x4 : 0000000000000008 
[    6.547249] x3 : 0000000000000101 x2 : 000000000000001a 
[    6.552636] x1 : 0000000000000001 x0 : ffff0000372c0800 
[    6.558023] Call trace:
[    6.560506]  mdiobus_read+0x68/0x70
[    6.564045]  phy_interrupt+0x5c/0xb0
[    6.567672]  handle_nested_irq+0xb8/0x130
[    6.571740]  intr_complete+0xb0/0xe0
[    6.575368]  __usb_hcd_giveback_urb+0x58/0xf8
[    6.579787]  usb_giveback_urb_bh+0xac/0x108
[    6.584032]  tasklet_action_common.isra.0+0x154/0x1a0
[    6.589155]  tasklet_hi_action+0x24/0x30
[    6.593134]  __do_softirq+0x120/0x23c
[    6.596847]  irq_exit+0xb8/0xd8
[    6.600031]  __handle_domain_irq+0x64/0xb8
[    6.604183]  bcm2836_arm_irqchip_handle_irq+0x60/0xc0
[    6.609305]  el1_irq+0xb8/0x180
[    6.612490]  arch_cpu_idle+0x10/0x18
[    6.616115]  do_idle+0x200/0x280
[    6.619387]  cpu_startup_entry+0x20/0x40
[    6.623366]  rest_init+0xd4/0xe0
[    6.626642]  arch_call_rest_init+0xc/0x14
[    6.630706]  start_kernel+0x420/0x44c
[    6.634425] Code: a94153f3 a9425bf5 a8c37bfd d65f03c0 (d4210000) 
[    6.640614] ---[ end trace 97efd7bf12ed0c65 ]---
[    6.645295] Kernel panic - not syncing: Fatal exception in interrupt
[    6.651740] SMP: stopping secondary CPUs
[    6.655719] Kernel Offset: disabled
[    6.659254] CPU features: 0x0002,24002004
[    6.663315] Memory Limit: none
[    6.666416] ---[ end Kernel panic - not syncing: Fatal exception in interrupt ]---


Not really. It turns out phy_interrupt() wants to be run in a threaded
context. As Sebastian says on IRC "but this means, that it was broken from
the beginning"
