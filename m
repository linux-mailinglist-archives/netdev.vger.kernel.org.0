Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF905688D9
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 15:02:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232733AbiGFNCN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 09:02:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232228AbiGFNCM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 09:02:12 -0400
Received: from mx1.tq-group.com (mx1.tq-group.com [93.104.207.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B43814008;
        Wed,  6 Jul 2022 06:02:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1657112527; x=1688648527;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+JGP+PGs9iK7m+D3oigw1NTvs3LyJROAAilqsYYg0rs=;
  b=cVkVsjc1uj7it9mW/OW8mi/gcf9HLF5A2CmX/e5WY+/tj3/QJyGUwy9v
   wpUw7r1uhycNlGJnOiKGCC3Ae9nH0uScKdhv+unKMMaqXcNUoWuIffeSq
   o3F42I700I64/xMWZHYF3FMTHZ6qRuKf0QGqquo8seGYkrbUTocrD+2Zr
   hxNSJ64oFSj1q8CdTXRMZ5xHKRK0xFRkBqanP5amrSl7nCRUEYV1g92oP
   QdGmLIxzezTVTJNe7YZwirWE7KNACZGoCNsMuPGo/pTF63Lyre1+NWBSn
   7ubyICaKXvUuCBE2+kXf/UVJi2iBhLjQPfW0Hqywi5Lancucs0m0KRyGW
   Q==;
X-IronPort-AV: E=Sophos;i="5.92,250,1650924000"; 
   d="scan'208";a="24891271"
Received: from unknown (HELO tq-pgp-pr1.tq-net.de) ([192.168.6.15])
  by mx1-pgp.tq-group.com with ESMTP; 06 Jul 2022 15:02:04 +0200
Received: from mx1.tq-group.com ([192.168.6.7])
  by tq-pgp-pr1.tq-net.de (PGP Universal service);
  Wed, 06 Jul 2022 15:02:04 +0200
X-PGP-Universal: processed;
        by tq-pgp-pr1.tq-net.de on Wed, 06 Jul 2022 15:02:04 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1657112524; x=1688648524;
  h=from:to:cc:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding:subject;
  bh=+JGP+PGs9iK7m+D3oigw1NTvs3LyJROAAilqsYYg0rs=;
  b=DEJLVWhujxyDnIqHmNcVMozSyCCT1PXRypEwS9yvjITP9fkhurbC4KJn
   chzZmnZneciyKFb2MV5IkA3mwQ/EaPusllumSLuqfDLJNrwM7aDSxeax1
   SO+jzzpjv6MoMssApQAQA6qx61AbH6TX+q/4VJRu+0yGUijo+uGh/1Xee
   u4/j+Dalo+PKKFqC3rU2nue8M57QiI/wCt+YW/wgQKUQ16MDA4BxjTqVQ
   wmvveHkF+euIywgSMTNmZZuUM/zi3ofxhxuRa4uQZEzLjp8ypYWuDBTYy
   cpyTWzW4SNj6hLUdEb5eaz300lmIFk6lsu/EGrYYSJ3zc/ntpgzAxcIEt
   g==;
X-IronPort-AV: E=Sophos;i="5.92,250,1650924000"; 
   d="scan'208";a="24891270"
Subject: Re: Re: Re: Re: [PATCH v2 1/9] PM: domains: Delete usage of
 driver_deferred_probe_check_state()
Received: from vtuxmail01.tq-net.de ([10.115.0.20])
  by mx1.tq-group.com with ESMTP; 06 Jul 2022 15:02:04 +0200
Received: from steina-w.localnet (unknown [10.123.49.12])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by vtuxmail01.tq-net.de (Postfix) with ESMTPSA id 26E62280071;
        Wed,  6 Jul 2022 15:02:04 +0200 (CEST)
From:   Alexander Stein <alexander.stein@ew.tq-group.com>
To:     Saravana Kannan <saravanak@google.com>
Cc:     Tony Lindgren <tony@atomide.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Kevin Hilman <khilman@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, kernel-team@android.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        iommu@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-gpio@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 06 Jul 2022 15:02:01 +0200
Message-ID: <6079032.MhkbZ0Pkbq@steina-w>
Organization: TQ-Systems GmbH
In-Reply-To: <CAGETcx8KGOTanmnVTLJ=SSDgv71ofhUcRxXRiqnUBNB3RZsY=A@mail.gmail.com>
References: <20220601070707.3946847-1-saravanak@google.com> <5717577.DvuYhMxLoT@steina-w> <CAGETcx8KGOTanmnVTLJ=SSDgv71ofhUcRxXRiqnUBNB3RZsY=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart2073037.VLH7GnMWUR"
Content-Transfer-Encoding: 7Bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.

--nextPart2073037.VLH7GnMWUR
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Am Dienstag, 5. Juli 2022, 03:24:33 CEST schrieb Saravana Kannan:
> On Mon, Jul 4, 2022 at 12:07 AM Alexander Stein
> 
> <alexander.stein@ew.tq-group.com> wrote:
> > Am Freitag, 1. Juli 2022, 09:02:22 CEST schrieb Saravana Kannan:
> > > On Thu, Jun 30, 2022 at 11:02 PM Alexander Stein
> > > 
> > > <alexander.stein@ew.tq-group.com> wrote:
> > > > Hi Saravana,
> > > > 
> > > > Am Freitag, 1. Juli 2022, 02:37:14 CEST schrieb Saravana Kannan:
> > > > > On Thu, Jun 23, 2022 at 5:08 AM Alexander Stein
> > > > > 
> > > > > <alexander.stein@ew.tq-group.com> wrote:
> > > > > > Hi,
> > > > > > 
> > > > > > Am Dienstag, 21. Juni 2022, 09:28:43 CEST schrieb Tony Lindgren:
> > > > > > > Hi,
> > > > > > > 
> > > > > > > * Saravana Kannan <saravanak@google.com> [700101 02:00]:
> > > > > > > > Now that fw_devlink=on by default and fw_devlink supports
> > > > > > > > "power-domains" property, the execution will never get to the
> > > > > > > > point
> > > > > > > > where driver_deferred_probe_check_state() is called before the
> > > > > > > > supplier
> > > > > > > > has probed successfully or before deferred probe timeout has
> > > > > > > > expired.
> > > > > > > > 
> > > > > > > > So, delete the call and replace it with -ENODEV.
> > > > > > > 
> > > > > > > Looks like this causes omaps to not boot in Linux next. With
> > > > > > > this
> > > > > > > simple-pm-bus fails to probe initially as the power-domain is
> > > > > > > not
> > > > > > > yet available. On platform_probe() genpd_get_from_provider()
> > > > > > > returns
> > > > > > > -ENOENT.
> > > > > > > 
> > > > > > > Seems like other stuff is potentially broken too, any ideas on
> > > > > > > how to fix this?
> > > > > > 
> > > > > > I think I'm hit by this as well, although I do not get a lockup.
> > > > > > In my case I'm using
> > > > > > arch/arm64/boot/dts/freescale/imx8mq-tqma8mq-mba8mx.dts and
> > > > > > probing of
> > > > > > 38320000.blk-ctrl fails as the power-domain is not (yet) registed.
> > > > > 
> > > > > Ok, took a look.
> > > > > 
> > > > > The problem is that there are two drivers for the same device and
> > > > > they
> > > > > both initialize this device.
> > > > > 
> > > > >     gpc: gpc@303a0000 {
> > > > >     
> > > > >         compatible = "fsl,imx8mq-gpc";
> > > > >     
> > > > >     }
> > > > > 
> > > > > $ git grep -l "fsl,imx7d-gpc" -- drivers/
> > > > > drivers/irqchip/irq-imx-gpcv2.c
> > > > > drivers/soc/imx/gpcv2.c
> > > > > 
> > > > > IMHO, this is a bad/broken design.
> > > > > 
> > > > > So what's happening is that fw_devlink will block the probe of
> > > > > 38320000.blk-ctrl until 303a0000.gpc is initialized. And it stops
> > > > > blocking the probe of 38320000.blk-ctrl as soon as the first driver
> > > > > initializes the device. In this case, it's the irqchip driver.
> > > > > 
> > > > > I'd recommend combining these drivers into one. Something like the
> > > > > patch I'm attaching (sorry for the attachment, copy-paste is
> > > > > mangling
> > > > > the tabs). Can you give it a shot please?
> > > > 
> > > > I tried this patch and it delayed the driver initialization (those of
> > > > UART
> > > > as
> > > 
> > > > well BTW). Unfortunately the driver fails the same way:
> > > Thanks for testing the patch!
> > > 
> > > > > [    1.125253] imx8m-blk-ctrl 38320000.blk-ctrl: error -ENODEV:
> > > > > failed
> > > > > to
> > > > 
> > > > attach power domain "bus"
> > > > 
> > > > More than that it even introduced some more errors:
> > > > > [    0.008160] irq: no irq domain found for gpc@303a0000 !
> > > 
> > > So the idea behind my change was that as long as the irqchip isn't the
> > > root of the irqdomain (might be using the terms incorrectly) like the
> > > gic, you can make it a platform driver. And I was trying to hack up a
> > > patch that's the equivalent of platform_irqchip_probe() (which just
> > > ends up eventually calling the callback you use in IRQCHIP_DECLARE().
> > > I probably made some mistake in the quick hack that I'm sure if
> > > fixable.
> > > 
> > > > > [    0.013251] Failed to map interrupt for
> > > > > /soc@0/bus@30400000/timer@306a0000
> > > 
> > > However, this timer driver also uses TIMER_OF_DECLARE() which can't
> > > handle failure to get the IRQ (because it's can't -EPROBE_DEFER). So,
> > > this means, the timer driver inturn needs to be converted to a
> > > platform driver if it's supposed to work with the IRQCHIP_DECLARE()
> > > being converted to a platform driver.
> > > 
> > > But that's a can of worms not worth opening. But then I remembered
> > > this simpler workaround will work and it is pretty much a variant of
> > > the workaround that's already in the gpc's irqchip driver to allow two
> > > drivers to probe the same device (people really should stop doing
> > > that).
> > > 
> > > Can you drop my previous hack patch and try this instead please? I'm
> > > 99% sure this will work.
> > > 
> > > diff --git a/drivers/irqchip/irq-imx-gpcv2.c
> > > b/drivers/irqchip/irq-imx-gpcv2.c index b9c22f764b4d..8a0e82067924
> > > 100644
> > > --- a/drivers/irqchip/irq-imx-gpcv2.c
> > > +++ b/drivers/irqchip/irq-imx-gpcv2.c
> > > @@ -283,6 +283,7 @@ static int __init imx_gpcv2_irqchip_init(struct
> > > device_node *node,
> > > 
> > >          * later the GPC power domain driver will not be skipped.
> > >          */
> > >         
> > >         of_node_clear_flag(node, OF_POPULATED);
> > > 
> > > +       fwnode_dev_initialized(domain->fwnode, false);
> > > 
> > >         return 0;
> > >  
> > >  }
> > 
> > Just to be sure here, I tried this patch on top of next-20220701 but
> > unfortunately this doesn't fix the original problem either. The timer
> > errors are gone though.
> 
> To clarify, you had the timer issue only with my "combine drivers" patch,
> right?

That's correct.

> > The probe of imx8m-blk-ctrl got slightly delayed (from 0.74 to 0.90s
> > printk
> > time) but results in the identical error message.
> 
> My guess is that the probe attempt of blk-ctrl is delayed now till gpc
> probes (because of the device links getting created with the
> fwnode_dev_initialized() fix), but by the time gpc probe finishes, the
> power domains aren't registered yet because of the additional level of
> device addition and probing.
> 
> Can you try the attached patch please?

Sure, it needed some small fixes though. But the error still is present.

> And if that doesn't fix the issues, then enable the debug logs in the
> following functions please and share the logs from boot till the
> failure? If you can enable CONFIG_PRINTK_CALLER, that'd help too.
> device_link_add()
> fwnode_link_add()
> fw_devlink_relax_cycle()

I switched fw_devlink_relax_cycle() for fw_devlink_relax_link() as the former 
has no debug output here.

For the record I added the following line to my kernel command line:
> dyndbg="func device_link_add +p; func fwnode_link_add +p; func 
fw_devlink_relax_link +p"

I attached the dmesg until the probe error to this mail. But I noticed the 
following lines which seem interesting:
> [    1.466620][    T8] imx-pgc imx-pgc-domain.5: Linked as a consumer to
> regulator.8
> [    1.466743][    T8] imx-pgc imx-pgc-domain.5: imx_pgc_domain_probe: Probe 
succeeded
> [    1.474733][    T8] imx-pgc imx-pgc-domain.6: Linked as a consumer to 
regulator.9
> [    1.474774][    T8] imx-pgc imx-pgc-domain.6: imx_pgc_domain_probe: Probe 
succeeded

regulator.8 and regulator.9 is the power sequencer, attached on I2C. This also 
makes perfectly sense if you look at [1]ff. These power domains are supplied 
by specific power supply rails. Several, if not all, imx8mq boards have this 
kind of setting.

> Btw, part of the reason I'm trying to make sure we fix it the right
> way is that when we try to enable async boot by default, we don't run
> into issues.

Sounds resonable.

Best regards,
Alexander

[1] https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/tree/
arch/arm64/boot/dts/freescale/imx8mq-tqma8mq.dtsi#n84

--nextPart2073037.VLH7GnMWUR
Content-Disposition: attachment; filename="dmesg.short"
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"; name="dmesg.short"

[    0.000000][    T0] Booting Linux on physical CPU 0x0000000000 [0x410fd034]
[    0.000000][    T0] Linux version 5.19.0-rc5-next-20220706+ (steina@steina-w) (aarch64-v8a-linux-gnu-gcc (OSELAS.Toolchain-2020.08.0 10-20200822) 10.2.1 20200822, GNU ld (GNU Binutils) 2.35) #422 SMP PREEMPT Wed Jul 6 14:43:55 CEST 2022
[    0.000000][    T0] Machine model: TQ-Systems GmbH i.MX8MQ TQMa8MQ on MBa8Mx
[    0.000000][    T0] earlycon: ec_imx6q0 at MMIO 0x0000000030880000 (options '115200')
[    0.000000][    T0] printk: bootconsole [ec_imx6q0] enabled
[    0.000000][    T0] efi: UEFI not found.
[    0.000000][    T0] Reserved memory: created CMA memory pool at 0x0000000090000000, size 640 MiB
[    0.000000][    T0] OF: reserved mem: initialized node linux,cma, compatible id shared-dma-pool
[    0.000000][    T0] NUMA: No NUMA configuration found
[    0.000000][    T0] NUMA: Faking a node at [mem 0x0000000040000000-0x000000013fffffff]
[    0.000000][    T0] NUMA: NODE_DATA [mem 0x13f7beb40-0x13f7c0fff]
[    0.000000][    T0] Zone ranges:
[    0.000000][    T0]   DMA      [mem 0x0000000040000000-0x00000000ffffffff]
[    0.000000][    T0]   DMA32    empty
[    0.000000][    T0]   Normal   [mem 0x0000000100000000-0x000000013fffffff]
[    0.000000][    T0] Movable zone start for each node
[    0.000000][    T0] Early memory node ranges
[    0.000000][    T0]   node   0: [mem 0x0000000040000000-0x000000013fffffff]
[    0.000000][    T0] Initmem setup node 0 [mem 0x0000000040000000-0x000000013fffffff]
[    0.000000][    T0] psci: probing for conduit method from DT.
[    0.000000][    T0] psci: PSCIv1.1 detected in firmware.
[    0.000000][    T0] psci: Using standard PSCI v0.2 function IDs
[    0.000000][    T0] psci: MIGRATE_INFO_TYPE not supported.
[    0.000000][    T0] psci: SMC Calling Convention v1.1
[    0.000000][    T0] percpu: Embedded 19 pages/cpu s38376 r8192 d31256 u77824
[    0.000000][    T0] pcpu-alloc: s38376 r8192 d31256 u77824 alloc=19*4096
[    0.000000][    T0] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3 
[    0.000000][    T0] Detected VIPT I-cache on CPU0
[    0.000000][    T0] CPU features: detected: GIC system register CPU interface
[    0.000000][    T0] CPU features: detected: ARM erratum 845719
[    0.000000][    T0] Fallback order for Node 0: 0 
[    0.000000][    T0] Built 1 zonelists, mobility grouping on.  Total pages: 1032192
[    0.000000][    T0] Policy zone: Normal
[    0.000000][    T0] Kernel command line: root=/dev/nfs rw nfsroot=192.168.0.101:/srv/tftp/imx8_mainline,v3,tcp ip=192.168.0.100:192.168.0.101::::eth0:off console=ttymxc2,115200 earlycon=ec_imx6q,0x30880000,115200 dyndbg="func device_link_add +p; func fwnode_link_add +p; func fw_devlink_relax_link +p"
[    0.000000][    T0] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes, linear)
[    0.000000][    T0] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes, linear)
[    0.000000][    T0] mem auto-init: stack:off, heap alloc:off, heap free:off
[    0.000000][    T0] software IO TLB: mapped [mem 0x00000000fbfff000-0x00000000fffff000] (64MB)
[    0.000000][    T0] Memory: 3363428K/4194304K available (14016K kernel code, 2190K rwdata, 6540K rodata, 5312K init, 494K bss, 175516K reserved, 655360K cma-reserved)
[    0.000000][    T0] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000][    T0] rcu: Preemptible hierarchical RCU implementation.
[    0.000000][    T0] rcu: 	RCU event tracing is enabled.
[    0.000000][    T0] rcu: 	RCU restricting CPUs from NR_CPUS=256 to nr_cpu_ids=4.
[    0.000000][    T0] 	Trampoline variant of Tasks RCU enabled.
[    0.000000][    T0] 	Tracing variant of Tasks RCU enabled.
[    0.000000][    T0] rcu: RCU calculated value of scheduler-enlistment delay is 25 jiffies.
[    0.000000][    T0] rcu: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=4
[    0.000000][    T0] NR_IRQS: 64, nr_irqs: 64, preallocated irqs: 0
[    0.000000][    T0] GICv3: GIC: Using split EOI/Deactivate mode
[    0.000000][    T0] GICv3: 128 SPIs implemented
[    0.000000][    T0] GICv3: 0 Extended SPIs implemented
[    0.000000][    T0] Root IRQ handler: gic_handle_irq
[    0.000000][    T0] GICv3: GICv3 features: 16 PPIs
[    0.000000][    T0] GICv3: CPU0: found redistributor 0 region 0:0x0000000038880000
[    0.000000][    T0] ITS: No ITS available, not enabling LPIs
[    0.000000][    T0] rcu: srcu_init: Setting srcu_struct sizes based on contention.
[    0.000000][    T0] arch_timer: cp15 timer(s) running at 8.33MHz (phys).
[    0.000000][    T0] clocksource: arch_sys_counter: mask: 0xffffffffffffff max_cycles: 0x1ec0311ec, max_idle_ns: 440795202152 ns
[    0.000001][    T0] sched_clock: 56 bits at 8MHz, resolution 120ns, wraps every 2199023255541ns
[    0.009211][    T0] Console: colour dummy device 80x25
[    0.013967][    T0] Calibrating delay loop (skipped), value calculated using timer frequency.. 16.66 BogoMIPS (lpj=33333)
[    0.024859][    T0] pid_max: default: 32768 minimum: 301
[    0.030261][    T0] LSM: Security Framework initializing
[    0.035625][    T0] Mount-cache hash table entries: 8192 (order: 4, 65536 bytes, linear)
[    0.043622][    T0] Mountpoint-cache hash table entries: 8192 (order: 4, 65536 bytes, linear)
[    0.054209][    T1] cblist_init_generic: Setting adjustable number of callback queues.
[    0.060116][    T1] cblist_init_generic: Setting shift to 2 and lim to 1.
[    0.066983][    T1] cblist_init_generic: Setting shift to 2 and lim to 1.
[    0.073902][    T1] rcu: Hierarchical SRCU implementation.
[    0.079195][    T1] rcu: 	Max phase no-delay instances is 1000.
[    0.087737][    T1] EFI services will not be available.
[    0.090823][    T1] smp: Bringing up secondary CPUs ...
[    0.096224][    T0] Detected VIPT I-cache on CPU1
[    0.096283][    T0] GICv3: CPU1: found redistributor 1 region 0:0x00000000388a0000
[    0.096337][    T0] CPU1: Booted secondary processor 0x0000000001 [0x410fd034]
[    0.097001][    T0] Detected VIPT I-cache on CPU2
[    0.097041][    T0] GICv3: CPU2: found redistributor 2 region 0:0x00000000388c0000
[    0.097069][    T0] CPU2: Booted secondary processor 0x0000000002 [0x410fd034]
[    0.097672][    T0] Detected VIPT I-cache on CPU3
[    0.097711][    T0] GICv3: CPU3: found redistributor 3 region 0:0x00000000388e0000
[    0.097739][    T0] CPU3: Booted secondary processor 0x0000000003 [0x410fd034]
[    0.097832][    T1] smp: Brought up 1 node, 4 CPUs
[    0.158985][    T1] SMP: Total of 4 processors activated.
[    0.164380][    T1] CPU features: detected: 32-bit EL0 Support
[    0.170245][    T1] CPU features: detected: CRC32 instructions
[    0.176396][    T1] CPU: All CPU(s) started at EL2
[    0.180899][   T14] alternatives: patching kernel code
[    0.188121][    T1] devtmpfs: initialized
[    0.199468][    T1] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 7645041785100000 ns
[    0.207118][    T1] futex hash table entries: 1024 (order: 4, 65536 bytes, linear)
[    0.239390][    T1] pinctrl core: initialized pinctrl subsystem
[    0.245118][    T1] DMI not present or invalid.
[    0.247854][    T1] NET: Registered PF_NETLINK/PF_ROUTE protocol family
[    0.254831][    T1] DMA: preallocated 512 KiB GFP_KERNEL pool for atomic allocations
[    0.261589][    T1] DMA: preallocated 512 KiB GFP_KERNEL|GFP_DMA pool for atomic allocations
[    0.270133][    T1] DMA: preallocated 512 KiB GFP_KERNEL|GFP_DMA32 pool for atomic allocations
[    0.278564][    T1] audit: initializing netlink subsys (disabled)
[    0.284869][   T34] audit: type=2000 audit(0.184:1): state=initialized audit_enabled=0 res=1
[    0.285423][    T1] thermal_sys: Registered thermal governor 'bang_bang'
[    0.293086][    T1] thermal_sys: Registered thermal governor 'step_wise'
[    0.299794][    T1] thermal_sys: Registered thermal governor 'power_allocator'
[    0.306986][    T1] cpuidle: using governor menu
[    0.318580][    T1] hw-breakpoint: found 6 breakpoint and 4 watchpoint registers.
[    0.325965][    T1] ASID allocator initialised with 65536 entries
[    0.333008][    T1] Serial: AMBA PL011 UART driver
[    0.337902][    T1] gpio@30200000 Linked as a fwnode consumer to gpc@303a0000
[    0.337943][    T1] gpio@30200000 Linked as a fwnode consumer to clock-controller@30380000
[    0.338004][    T1] gpio@30210000 Linked as a fwnode consumer to gpc@303a0000
[    0.338038][    T1] gpio@30210000 Linked as a fwnode consumer to clock-controller@30380000
[    0.338098][    T1] gpio@30220000 Linked as a fwnode consumer to gpc@303a0000
[    0.338132][    T1] gpio@30220000 Linked as a fwnode consumer to clock-controller@30380000
[    0.338192][    T1] gpio@30230000 Linked as a fwnode consumer to gpc@303a0000
[    0.338227][    T1] gpio@30230000 Linked as a fwnode consumer to clock-controller@30380000
[    0.338284][    T1] gpio@30240000 Linked as a fwnode consumer to gpc@303a0000
[    0.338317][    T1] gpio@30240000 Linked as a fwnode consumer to clock-controller@30380000
[    0.338378][    T1] tmu@30260000 Linked as a fwnode consumer to gpc@303a0000
[    0.338398][    T1] tmu@30260000 Linked as a fwnode consumer to clock-controller@30380000
[    0.338455][    T1] watchdog@30280000 Linked as a fwnode consumer to gpc@303a0000
[    0.338475][    T1] watchdog@30280000 Linked as a fwnode consumer to clock-controller@30380000
[    0.338502][    T1] watchdog@30280000 Linked as a fwnode consumer to pinctrl@30330000
[    0.338549][    T1] sdma@302c0000 Linked as a fwnode consumer to gpc@303a0000
[    0.338571][    T1] sdma@302c0000 Linked as a fwnode consumer to clock-controller@30380000
[    0.338984][    T1] efuse@30350000 Linked as a fwnode consumer to clock-controller@30380000
[    0.339058][    T1] syscon@30360000 Linked as a fwnode consumer to gpc@303a0000
[    0.339120][    T1] snvs-rtc-lp Linked as a fwnode consumer to gpc@303a0000
[    0.339154][    T1] snvs-rtc-lp Linked as a fwnode consumer to clock-controller@30380000
[    0.339199][    T1] snvs-powerkey Linked as a fwnode consumer to gpc@303a0000
[    0.339226][    T1] snvs-powerkey Linked as a fwnode consumer to clock-controller@30380000
[    0.339278][    T1] clock-controller@30380000 Linked as a fwnode consumer to gpc@303a0000
[    0.339392][    T1] reset-controller@30390000 Linked as a fwnode consumer to gpc@303a0000
[    0.339497][    T1] power-domain@1 Linked as a fwnode consumer to gpc@303a0000
[    0.339564][    T1] power-domain@5 Linked as a fwnode consumer to clock-controller@30380000
[    0.339601][    T1] power-domain@5 Linked as a fwnode consumer to pmic@8
[    0.339631][    T1] power-domain@6 Linked as a fwnode consumer to clock-controller@30380000
[    0.339672][    T1] power-domain@6 Linked as a fwnode consumer to pmic@8
[    0.339786][    T1] pwm@30680000 Linked as a fwnode consumer to gpc@303a0000
[    0.339809][    T1] pwm@30680000 Linked as a fwnode consumer to clock-controller@30380000
[    0.339845][    T1] pwm@30680000 Linked as a fwnode consumer to pinctrl@30330000
[    0.339886][    T1] pwm@30690000 Linked as a fwnode consumer to gpc@303a0000
[    0.339906][    T1] pwm@30690000 Linked as a fwnode consumer to clock-controller@30380000
[    0.339942][    T1] pwm@30690000 Linked as a fwnode consumer to pinctrl@30330000
[    0.339985][    T1] timer@306a0000 Linked as a fwnode consumer to gpc@303a0000
[    0.340064][    T1] spi@30820000 Linked as a fwnode consumer to gpc@303a0000
[    0.340085][    T1] spi@30820000 Linked as a fwnode consumer to clock-controller@30380000
[    0.340114][    T1] spi@30820000 Linked as a fwnode consumer to sdma@30bd0000
[    0.340146][    T1] spi@30820000 Linked as a fwnode consumer to pinctrl@30330000
[    0.340167][    T1] spi@30820000 Linked as a fwnode consumer to gpio@30240000
[    0.340218][    T1] spi@30830000 Linked as a fwnode consumer to gpc@303a0000
[    0.340240][    T1] spi@30830000 Linked as a fwnode consumer to clock-controller@30380000
[    0.340266][    T1] spi@30830000 Linked as a fwnode consumer to sdma@30bd0000
[    0.340300][    T1] spi@30830000 Linked as a fwnode consumer to pinctrl@30330000
[    0.340319][    T1] spi@30830000 Linked as a fwnode consumer to gpio@30240000
[    0.340364][    T1] serial@30860000 Linked as a fwnode consumer to gpc@303a0000
[    0.340386][    T1] serial@30860000 Linked as a fwnode consumer to clock-controller@30380000
[    0.340419][    T1] serial@30860000 Linked as a fwnode consumer to pinctrl@30330000
[    0.340468][    T1] serial@30880000 Linked as a fwnode consumer to gpc@303a0000
[    0.340489][    T1] serial@30880000 Linked as a fwnode consumer to clock-controller@30380000
[    0.340524][    T1] serial@30880000 Linked as a fwnode consumer to pinctrl@30330000
[    0.340572][    T1] serial@30890000 Linked as a fwnode consumer to gpc@303a0000
[    0.340599][    T1] serial@30890000 Linked as a fwnode consumer to clock-controller@30380000
[    0.340635][    T1] serial@30890000 Linked as a fwnode consumer to pinctrl@30330000
[    0.340690][    T1] sai@308c0000 Linked as a fwnode consumer to gpc@303a0000
[    0.340712][    T1] sai@308c0000 Linked as a fwnode consumer to clock-controller@30380000
[    0.340782][    T1] sai@308c0000 Linked as a fwnode consumer to sdma@30bd0000
[    0.340817][    T1] sai@308c0000 Linked as a fwnode consumer to pinctrl@30330000
[    0.340880][    T1] crypto@30900000 Linked as a fwnode consumer to gpc@303a0000
[    0.340903][    T1] crypto@30900000 Linked as a fwnode consumer to clock-controller@30380000
[    0.340953][    T1] jr@2000 Linked as a fwnode consumer to gpc@303a0000
[    0.341002][    T1] jr@3000 Linked as a fwnode consumer to gpc@303a0000
[    0.341053][    T1] i2c@30a20000 Linked as a fwnode consumer to gpc@303a0000
[    0.341074][    T1] i2c@30a20000 Linked as a fwnode consumer to clock-controller@30380000
[    0.341109][    T1] i2c@30a20000 Linked as a fwnode consumer to pinctrl@30330000
[    0.341136][    T1] i2c@30a20000 Linked as a fwnode consumer to gpio@30240000
[    0.341384][    T1] rtc@51 Linked as a fwnode consumer to pinctrl@30330000
[    0.341404][    T1] rtc@51 Linked as a fwnode consumer to gpio@30200000
[    0.341513][    T1] gpio@23 Linked as a fwnode consumer to regulator-3v3
[    0.341529][    T1] gpio@23 Linked as a fwnode consumer to gpio@30200000
[    0.341641][    T1] gpio@24 Linked as a fwnode consumer to regulator-3v3
[    0.341678][    T1] gpio@25 Linked as a fwnode consumer to regulator-3v3
[    0.341698][    T1] gpio@25 Linked as a fwnode consumer to pinctrl@30330000
[    0.341714][    T1] gpio@25 Linked as a fwnode consumer to gpio@30200000
[    0.341800][    T1] i2c@30a30000 Linked as a fwnode consumer to gpc@303a0000
[    0.341821][    T1] i2c@30a30000 Linked as a fwnode consumer to clock-controller@30380000
[    0.341857][    T1] i2c@30a30000 Linked as a fwnode consumer to pinctrl@30330000
[    0.341885][    T1] i2c@30a30000 Linked as a fwnode consumer to gpio@30240000
[    0.341927][    T1] audio-codec@18 Linked as a fwnode consumer to gpio@25
[    0.341945][    T1] audio-codec@18 Linked as a fwnode consumer to regulator-3v3
[    0.341972][    T1] audio-codec@18 Linked as a fwnode consumer to clock-controller@30380000
[    0.342044][    T1] i2c@30a40000 Linked as a fwnode consumer to gpc@303a0000
[    0.342066][    T1] i2c@30a40000 Linked as a fwnode consumer to clock-controller@30380000
[    0.342100][    T1] i2c@30a40000 Linked as a fwnode consumer to pinctrl@30330000
[    0.342133][    T1] i2c@30a40000 Linked as a fwnode consumer to gpio@30240000
[    0.342192][    T1] mailbox@30aa0000 Linked as a fwnode consumer to gpc@303a0000
[    0.342213][    T1] mailbox@30aa0000 Linked as a fwnode consumer to clock-controller@30380000
[    0.342261][    T1] mmc@30b40000 Linked as a fwnode consumer to gpc@303a0000
[    0.342284][    T1] mmc@30b40000 Linked as a fwnode consumer to clock-controller@30380000
[    0.342333][    T1] mmc@30b40000 Linked as a fwnode consumer to pinctrl@30330000
[    0.342377][    T1] mmc@30b40000 Linked as a fwnode consumer to regulator-vcc3v3
[    0.342397][    T1] mmc@30b40000 Linked as a fwnode consumer to regulator-vcc1v8
[    0.342443][    T1] mmc@30b50000 Linked as a fwnode consumer to gpc@303a0000
[    0.342467][    T1] mmc@30b50000 Linked as a fwnode consumer to clock-controller@30380000
[    0.342515][    T1] mmc@30b50000 Linked as a fwnode consumer to pinctrl@30330000
[    0.342563][    T1] mmc@30b50000 Linked as a fwnode consumer to gpio@30210000
[    0.342592][    T1] mmc@30b50000 Linked as a fwnode consumer to regulator-vmmc
[    0.342634][    T1] sdma@30bd0000 Linked as a fwnode consumer to gpc@303a0000
[    0.342655][    T1] sdma@30bd0000 Linked as a fwnode consumer to clock-controller@30380000
[    0.342720][    T1] ethernet@30be0000 Linked as a fwnode consumer to gpc@303a0000
[    0.342783][    T1] ethernet@30be0000 Linked as a fwnode consumer to clock-controller@30380000
[    0.342843][    T1] ethernet@30be0000 Linked as a fwnode consumer to efuse@30350000
[    0.342874][    T1] ethernet@30be0000 Linked as a fwnode consumer to pinctrl@30330000
[    0.342901][    T1] ethernet@30be0000 Linked as a fwnode consumer to regulator-3v3
[    0.342969][    T1] ethernet-phy@e Linked as a fwnode consumer to gpio@25
[    0.343008][    T1] interconnect@32700000 Linked as a fwnode consumer to clock-controller@30380000
[    0.343113][    T1] interrupt-controller@32e2d000 Linked as a fwnode consumer to gpc@303a0000
[    0.343135][    T1] interrupt-controller@32e2d000 Linked as a fwnode consumer to clock-controller@30380000
[    0.343193][    T1] gpu@38000000 Linked as a fwnode consumer to gpc@303a0000
[    0.343214][    T1] gpu@38000000 Linked as a fwnode consumer to clock-controller@30380000
[    0.343288][    T1] usb@38100000 Linked as a fwnode consumer to clock-controller@30380000
[    0.343342][    T1] usb@38100000 Linked as a fwnode consumer to gpc@303a0000
[    0.343367][    T1] usb@38100000 Linked as a fwnode consumer to usb-phy@381f0040
[    0.343407][    T1] usb@38100000 Linked as a fwnode consumer to extcon-usbotg0
[    0.343450][    T1] usb-phy@381f0040 Linked as a fwnode consumer to clock-controller@30380000
[    0.343489][    T1] usb-phy@381f0040 Linked as a fwnode consumer to regulator-otg-vbus
[    0.343529][    T1] usb@38200000 Linked as a fwnode consumer to clock-controller@30380000
[    0.343582][    T1] usb@38200000 Linked as a fwnode consumer to gpc@303a0000
[    0.343606][    T1] usb@38200000 Linked as a fwnode consumer to usb-phy@382f0040
[    0.343659][    T1] usb-phy@382f0040 Linked as a fwnode consumer to clock-controller@30380000
[    0.343723][    T1] video-codec@38300000 Linked as a fwnode consumer to gpc@303a0000
[    0.343745][    T1] video-codec@38300000 Linked as a fwnode consumer to clock-controller@30380000
[    0.343779][    T1] video-codec@38300000 Linked as a fwnode consumer to blk-ctrl@38320000
[    0.343823][    T1] video-codec@38310000 Linked as a fwnode consumer to gpc@303a0000
[    0.343845][    T1] video-codec@38310000 Linked as a fwnode consumer to clock-controller@30380000
[    0.343870][    T1] video-codec@38310000 Linked as a fwnode consumer to blk-ctrl@38320000
[    0.343905][    T1] blk-ctrl@38320000 Linked as a fwnode consumer to gpc@303a0000
[    0.343943][    T1] blk-ctrl@38320000 Linked as a fwnode consumer to clock-controller@30380000
[    0.344029][    T1] pcie@33800000 Linked as a fwnode consumer to gpc@303a0000
[    0.344086][    T1] pcie@33800000 Linked as a fwnode consumer to reset-controller@30390000
[    0.344133][    T1] pcie@33800000 Linked as a fwnode consumer to pmic@8
[    0.344153][    T1] pcie@33800000 Linked as a fwnode consumer to gpio@23
[    0.344173][    T1] pcie@33800000 Linked as a fwnode consumer to clock-controller@30380000
[    0.344216][    T1] pcie@33800000 Linked as a fwnode consumer to regulator-3v3
[    0.344283][    T1] pcie@33c00000 Linked as a fwnode consumer to gpc@303a0000
[    0.344335][    T1] pcie@33c00000 Linked as a fwnode consumer to reset-controller@30390000
[    0.344382][    T1] pcie@33c00000 Linked as a fwnode consumer to pmic@8
[    0.344399][    T1] pcie@33c00000 Linked as a fwnode consumer to clock-controller@30380000
[    0.344442][    T1] pcie@33c00000 Linked as a fwnode consumer to regulator-3v3
[    0.346535][    T1] platform 30280000.watchdog: Linked as a consumer to 30330000.pinctrl
[    0.347193][    T1] imx8mq-pinctrl 30330000.pinctrl: initialized IMX pinctrl driver
[    0.353405][    T1] platform 30370000.snvs:snvs-powerkey: Linked as a consumer to 30380000.clock-controller
[    0.353484][    T1] platform 30370000.snvs:snvs-rtc-lp: Linked as a consumer to 30380000.clock-controller
[    0.353556][    T1] platform 30350000.efuse: Linked as a consumer to 30380000.clock-controller
[    0.353634][    T1] platform 302c0000.sdma: Linked as a consumer to 30380000.clock-controller
[    0.353706][    T1] platform 30280000.watchdog: Linked as a consumer to 30380000.clock-controller
[    0.353778][    T1] platform 30260000.tmu: Linked as a consumer to 30380000.clock-controller
[    0.353855][    T1] platform 30240000.gpio: Linked as a consumer to 30380000.clock-controller
[    0.353926][    T1] platform 30230000.gpio: Linked as a consumer to 30380000.clock-controller
[    0.354007][    T1] platform 30220000.gpio: Linked as a consumer to 30380000.clock-controller
[    0.354091][    T1] platform 30210000.gpio: Linked as a consumer to 30380000.clock-controller
[    0.354162][    T1] platform 30200000.gpio: Linked as a consumer to 30380000.clock-controller
[    0.354603][    T1] platform 30390000.reset-controller: Linked as a consumer to 303a0000.gpc
[    0.354688][    T1] platform 30380000.clock-controller: Linked as a consumer to 303a0000.gpc
[    0.354761][    T1] platform 30370000.snvs:snvs-powerkey: Linked as a consumer to 303a0000.gpc
[    0.354842][    T1] platform 30370000.snvs:snvs-rtc-lp: Linked as a consumer to 303a0000.gpc
[    0.354913][    T1] platform 30360000.syscon: Linked as a consumer to 303a0000.gpc
[    0.354982][    T1] platform 302c0000.sdma: Linked as a consumer to 303a0000.gpc
[    0.355058][    T1] platform 30280000.watchdog: Linked as a consumer to 303a0000.gpc
[    0.355128][    T1] platform 30260000.tmu: Linked as a consumer to 303a0000.gpc
[    0.355197][    T1] platform 30240000.gpio: Linked as a consumer to 303a0000.gpc
[    0.355276][    T1] platform 30230000.gpio: Linked as a consumer to 303a0000.gpc
[    0.355346][    T1] platform 30220000.gpio: Linked as a consumer to 303a0000.gpc
[    0.355431][    T1] platform 30210000.gpio: Linked as a consumer to 303a0000.gpc
[    0.355504][    T1] platform 30200000.gpio: Linked as a consumer to 303a0000.gpc
[    0.355584][    T1] platform 303a0000.gpc: Linked as a sync state only consumer to 30380000.clock-controller
[    0.355809][    T1] platform 30400000.bus: Linked as a sync state only consumer to 30330000.pinctrl
[    0.355879][    T1] platform 30400000.bus: Linked as a sync state only consumer to 30380000.clock-controller
[    0.355977][    T1] platform 30400000.bus: Linked as a sync state only consumer to 303a0000.gpc
[    0.356232][    T1] platform 30680000.pwm: Linked as a consumer to 30330000.pinctrl
[    0.356338][    T1] platform 30680000.pwm: Linked as a consumer to 30380000.clock-controller
[    0.356408][    T1] platform 30680000.pwm: Linked as a consumer to 303a0000.gpc
[    0.356650][    T1] platform 30690000.pwm: Linked as a consumer to 30330000.pinctrl
[    0.356762][    T1] platform 30690000.pwm: Linked as a consumer to 30380000.clock-controller
[    0.356834][    T1] platform 30690000.pwm: Linked as a consumer to 303a0000.gpc
[    0.357081][    T1] platform 306a0000.timer: Linked as a consumer to 303a0000.gpc
[    0.357380][    T1] platform 30800000.bus: Linked as a sync state only consumer to 30240000.gpio
[    0.357449][    T1] platform 30800000.bus: Linked as a sync state only consumer to 30330000.pinctrl
[    0.357520][    T1] platform 30800000.bus: Linked as a sync state only consumer to 30380000.clock-controller
[    0.357597][    T1] platform 30800000.bus: Linked as a sync state only consumer to 303a0000.gpc
[    0.357726][    T1] platform 30800000.bus: Linked as a sync state only consumer to 30200000.gpio
[    0.357837][    T1] platform 30800000.bus: Linked as a sync state only consumer to 30210000.gpio
[    0.357922][    T1] platform 30800000.bus: Linked as a sync state only consumer to 30350000.efuse
[    0.358158][    T1] platform 30820000.spi: Linked as a consumer to 30240000.gpio
[    0.358231][    T1] platform 30820000.spi: Linked as a consumer to 30330000.pinctrl
[    0.358335][    T1] platform 30820000.spi: Linked as a consumer to 30380000.clock-controller
[    0.358418][    T1] platform 30820000.spi: Linked as a consumer to 303a0000.gpc
[    0.358666][    T1] platform 30830000.spi: Linked as a consumer to 30240000.gpio
[    0.358741][    T1] platform 30830000.spi: Linked as a consumer to 30330000.pinctrl
[    0.358851][    T1] platform 30830000.spi: Linked as a consumer to 30380000.clock-controller
[    0.358927][    T1] platform 30830000.spi: Linked as a consumer to 303a0000.gpc
[    0.359177][    T1] platform 30860000.serial: Linked as a consumer to 30330000.pinctrl
[    0.359287][    T1] platform 30860000.serial: Linked as a consumer to 30380000.clock-controller
[    0.359356][    T1] platform 30860000.serial: Linked as a consumer to 303a0000.gpc
[    0.359601][    T1] platform 30880000.serial: Linked as a consumer to 30330000.pinctrl
[    0.359706][    T1] platform 30880000.serial: Linked as a consumer to 30380000.clock-controller
[    0.359782][    T1] platform 30880000.serial: Linked as a consumer to 303a0000.gpc
[    0.360024][    T1] platform 30890000.serial: Linked as a consumer to 30330000.pinctrl
[    0.360152][    T1] platform 30890000.serial: Linked as a consumer to 30380000.clock-controller
[    0.360223][    T1] platform 30890000.serial: Linked as a consumer to 303a0000.gpc
[    0.360474][    T1] platform 308c0000.sai: Linked as a consumer to 30330000.pinctrl
[    0.360591][    T1] platform 308c0000.sai: Linked as a consumer to 30380000.clock-controller
[    0.360662][    T1] platform 308c0000.sai: Linked as a consumer to 303a0000.gpc
[    0.360904][    T1] platform 30900000.crypto: Linked as a consumer to 30380000.clock-controller
[    0.360980][    T1] platform 30900000.crypto: Linked as a consumer to 303a0000.gpc
[    0.361263][    T1] platform 30a20000.i2c: Linked as a consumer to 30240000.gpio
[    0.361337][    T1] platform 30a20000.i2c: Linked as a consumer to 30330000.pinctrl
[    0.361448][    T1] platform 30a20000.i2c: Linked as a consumer to 30380000.clock-controller
[    0.361523][    T1] platform 30a20000.i2c: Linked as a consumer to 303a0000.gpc
[    0.361625][    T1] platform 30a20000.i2c: Linked as a sync state only consumer to 30200000.gpio
[    0.361880][    T1] platform 30a30000.i2c: Linked as a consumer to 30240000.gpio
[    0.361958][    T1] platform 30a30000.i2c: Linked as a consumer to 30330000.pinctrl
[    0.362062][    T1] platform 30a30000.i2c: Linked as a consumer to 30380000.clock-controller
[    0.362139][    T1] platform 30a30000.i2c: Linked as a consumer to 303a0000.gpc
[    0.362395][    T1] platform 30a40000.i2c: Linked as a consumer to 30240000.gpio
[    0.362474][    T1] platform 30a40000.i2c: Linked as a consumer to 30330000.pinctrl
[    0.362578][    T1] platform 30a40000.i2c: Linked as a consumer to 30380000.clock-controller
[    0.362654][    T1] platform 30a40000.i2c: Linked as a consumer to 303a0000.gpc
[    0.362911][    T1] platform 30aa0000.mailbox: Linked as a consumer to 30380000.clock-controller
[    0.362991][    T1] platform 30aa0000.mailbox: Linked as a consumer to 303a0000.gpc
[    0.363233][    T1] platform 30b40000.mmc: Linked as a consumer to 30330000.pinctrl
[    0.363345][    T1] platform 30b40000.mmc: Linked as a consumer to 30380000.clock-controller
[    0.363418][    T1] platform 30b40000.mmc: Linked as a consumer to 303a0000.gpc
[    0.363669][    T1] platform 30b50000.mmc: Linked as a consumer to 30210000.gpio
[    0.363740][    T1] platform 30b50000.mmc: Linked as a consumer to 30330000.pinctrl
[    0.363856][    T1] platform 30b50000.mmc: Linked as a consumer to 30380000.clock-controller
[    0.363933][    T1] platform 30b50000.mmc: Linked as a consumer to 303a0000.gpc
[    0.364193][    T1] platform 308c0000.sai: Linked as a consumer to 30bd0000.sdma
[    0.364264][    T1] platform 30830000.spi: Linked as a consumer to 30bd0000.sdma
[    0.364347][    T1] platform 30820000.spi: Linked as a consumer to 30bd0000.sdma
[    0.364424][    T1] platform 30bd0000.sdma: Linked as a consumer to 30380000.clock-controller
[    0.364497][    T1] platform 30bd0000.sdma: Linked as a consumer to 303a0000.gpc
[    0.364752][    T1] platform 30be0000.ethernet: Linked as a consumer to 30330000.pinctrl
[    0.364862][    T1] platform 30be0000.ethernet: Linked as a consumer to 30350000.efuse
[    0.364940][    T1] platform 30be0000.ethernet: Linked as a consumer to 30380000.clock-controller
[    0.365013][    T1] platform 30be0000.ethernet: Linked as a consumer to 303a0000.gpc
[    0.365261][    T1] platform 32700000.interconnect: Linked as a consumer to 30380000.clock-controller
[    0.365487][    T1] platform 32c00000.bus: Linked as a sync state only consumer to 30380000.clock-controller
[    0.365564][    T1] platform 32c00000.bus: Linked as a sync state only consumer to 303a0000.gpc
[    0.365795][    T1] platform 32e2d000.interrupt-controller: Linked as a consumer to 30380000.clock-controller
[    0.365877][    T1] platform 32e2d000.interrupt-controller: Linked as a consumer to 303a0000.gpc
[    0.366108][    T1] platform 38000000.gpu: Linked as a consumer to 30380000.clock-controller
[    0.366189][    T1] platform 38000000.gpu: Linked as a consumer to 303a0000.gpc
[    0.366417][    T1] platform 38100000.usb: Linked as a consumer to 303a0000.gpc
[    0.366511][    T1] platform 38100000.usb: Linked as a consumer to 30380000.clock-controller
[    0.366733][    T1] platform 38100000.usb: Linked as a consumer to 381f0040.usb-phy
[    0.366808][    T1] platform 381f0040.usb-phy: Linked as a consumer to 30380000.clock-controller
[    0.367025][    T1] platform 38200000.usb: Linked as a consumer to 303a0000.gpc
[    0.367124][    T1] platform 38200000.usb: Linked as a consumer to 30380000.clock-controller
[    0.367371][    T1] platform 38200000.usb: Linked as a consumer to 382f0040.usb-phy
[    0.367445][    T1] platform 382f0040.usb-phy: Linked as a consumer to 30380000.clock-controller
[    0.367664][    T1] platform 38300000.video-codec: Linked as a consumer to 30380000.clock-controller
[    0.367745][    T1] platform 38300000.video-codec: Linked as a consumer to 303a0000.gpc
[    0.367967][    T1] platform 38310000.video-codec: Linked as a consumer to 30380000.clock-controller
[    0.368048][    T1] platform 38310000.video-codec: Linked as a consumer to 303a0000.gpc
[    0.368308][    T1] platform 38310000.video-codec: Linked as a consumer to 38320000.blk-ctrl
[    0.368387][    T1] platform 38300000.video-codec: Linked as a consumer to 38320000.blk-ctrl
[    0.368462][    T1] platform 38320000.blk-ctrl: Linked as a consumer to 30380000.clock-controller
[    0.368542][    T1] platform 38320000.blk-ctrl: Linked as a consumer to 303a0000.gpc
[    0.368800][    T1] platform 33800000.pcie: Linked as a consumer to 30380000.clock-controller
[    0.368878][    T1] platform 33800000.pcie: Linked as a consumer to 30390000.reset-controller
[    0.368948][    T1] platform 33800000.pcie: Linked as a consumer to 303a0000.gpc
[    0.369210][    T1] platform 33c00000.pcie: Linked as a consumer to 30380000.clock-controller
[    0.369284][    T1] platform 33c00000.pcie: Linked as a consumer to 30390000.reset-controller
[    0.369361][    T1] platform 33c00000.pcie: Linked as a consumer to 303a0000.gpc
[    0.369721][    T1] platform 30b40000.mmc: Linked as a consumer to regulator-vcc1v8
[    0.369916][    T1] platform 30b40000.mmc: Linked as a consumer to regulator-vcc3v3
[    0.370041][    T1] regulator-vdd-arm Linked as a fwnode consumer to pinctrl@30330000
[    0.370081][    T1] regulator-vdd-arm Linked as a fwnode consumer to gpio@30200000
[    0.370179][    T1] platform regulator-vdd-arm: Linked as a consumer to 30200000.gpio
[    0.370254][    T1] platform regulator-vdd-arm: Linked as a consumer to 30330000.pinctrl
[    0.370410][    T1] beeper Linked as a fwnode consumer to pwm@30690000
[    0.370437][    T1] beeper Linked as a fwnode consumer to regulator-3v3
[    0.370519][    T1] platform beeper: Linked as a consumer to 30690000.pwm
[    0.370652][    T1] gpio-keys Linked as a fwnode consumer to pinctrl@30330000
[    0.370691][    T1] switch-1 Linked as a fwnode consumer to gpio@30200000
[    0.370729][    T1] switch-2 Linked as a fwnode consumer to gpio@30220000
[    0.370764][    T1] switch-3 Linked as a fwnode consumer to gpio@30200000
[    0.370853][    T1] platform gpio-keys: Linked as a consumer to 30330000.pinctrl
[    0.370957][    T1] platform gpio-keys: Linked as a sync state only consumer to 30200000.gpio
[    0.371032][    T1] platform gpio-keys: Linked as a sync state only consumer to 30220000.gpio
[    0.371162][    T1] gpio-leds Linked as a fwnode consumer to pinctrl@30330000
[    0.371192][    T1] led1 Linked as a fwnode consumer to gpio@30200000
[    0.371225][    T1] led2 Linked as a fwnode consumer to gpio@30220000
[    0.371255][    T1] led3 Linked as a fwnode consumer to gpio@30200000
[    0.371334][    T1] platform gpio-leds: Linked as a consumer to 30330000.pinctrl
[    0.371440][    T1] platform gpio-leds: Linked as a sync state only consumer to 30200000.gpio
[    0.371508][    T1] platform gpio-leds: Linked as a sync state only consumer to 30220000.gpio
[    0.371760][    T1] regulator-sn65dsi83-1v8 Linked as a fwnode consumer to gpio@23
[    0.371965][    T1] platform beeper: Linked as a consumer to regulator-3v3
[    0.372038][    T1] platform 33c00000.pcie: Linked as a consumer to regulator-3v3
[    0.372132][    T1] platform 33800000.pcie: Linked as a consumer to regulator-3v3
[    0.372210][    T1] platform 30be0000.ethernet: Linked as a consumer to regulator-3v3
[    0.372288][    T1] platform 30a30000.i2c: Linked as a sync state only consumer to regulator-3v3
[    0.372370][    T1] platform 30a20000.i2c: Linked as a sync state only consumer to regulator-3v3
[    0.372612][    T1] extcon-usbotg0 Linked as a fwnode consumer to pinctrl@30330000
[    0.372634][    T1] extcon-usbotg0 Linked as a fwnode consumer to gpio@30200000
[    0.372721][    T1] platform 38100000.usb: Linked as a consumer to extcon-usbotg0
[    0.372794][    T1] platform extcon-usbotg0: Linked as a consumer to 30200000.gpio
[    0.372870][    T1] platform extcon-usbotg0: Linked as a consumer to 30330000.pinctrl
[    0.373026][    T1] regulator-otg-vbus Linked as a fwnode consumer to pinctrl@30330000
[    0.373058][    T1] regulator-otg-vbus Linked as a fwnode consumer to gpio@30200000
[    0.373144][    T1] platform 381f0040.usb-phy: Linked as a consumer to regulator-otg-vbus
[    0.373223][    T1] platform regulator-otg-vbus: Linked as a consumer to 30200000.gpio
[    0.373303][    T1] platform regulator-otg-vbus: Linked as a consumer to 30330000.pinctrl
[    0.373468][    T1] regulator-vmmc Linked as a fwnode consumer to gpio@30210000
[    0.373557][    T1] platform 30b50000.mmc: Linked as a consumer to regulator-vmmc
[    0.373629][    T1] platform regulator-vmmc: Linked as a consumer to 30210000.gpio
[    0.374218][    T1] KASLR disabled due to lack of seed
[    0.388702][    T1] HugeTLB: registered 1.00 GiB page size, pre-allocated 0 pages
[    0.393390][    T1] HugeTLB: 16380 KiB vmemmap can be freed for a 1.00 GiB page
[    0.400687][    T1] HugeTLB: registered 32.0 MiB page size, pre-allocated 0 pages
[    0.408180][    T1] HugeTLB: 508 KiB vmemmap can be freed for a 32.0 MiB page
[    0.415333][    T1] HugeTLB: registered 2.00 MiB page size, pre-allocated 0 pages
[    0.422830][    T1] HugeTLB: 28 KiB vmemmap can be freed for a 2.00 MiB page
[    0.429896][    T1] HugeTLB: registered 64.0 KiB page size, pre-allocated 0 pages
[    0.437392][    T1] HugeTLB: 0 KiB vmemmap can be freed for a 64.0 KiB page
[    0.445115][    T1] cryptd: max_cpu_qlen set to 1000
[    0.452708][    T1] iommu: Default domain type: Translated 
[    0.455480][    T1] iommu: DMA domain TLB invalidation policy: strict mode 
[    0.462785][    T1] SCSI subsystem initialized
[    0.467027][    T1] libata version 3.00 loaded.
[    0.467296][    T1] usbcore: registered new interface driver usbfs
[    0.473114][    T1] usbcore: registered new interface driver hub
[    0.479109][    T1] usbcore: registered new device driver usb
[    0.485493][    T1] mc: Linux media interface: v0.10
[    0.489841][    T1] videodev: Linux video capture interface: v2.00
[    0.496022][    T1] pps_core: LinuxPPS API ver. 1 registered
[    0.501661][    T1] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    0.511529][    T1] PTP clock support registered
[    0.516295][    T1] EDAC MC: Ver: 3.0.0
[    0.520929][    T1] FPGA manager framework
[    0.524168][    T1] Advanced Linux Sound Architecture Driver Initialized.
[    0.531982][    T1] vgaarb: loaded
[    0.534640][    T1] clocksource: Switched to clocksource arch_sys_counter
[    0.541330][    T1] VFS: Disk quotas dquot_6.6.0
[    0.545754][    T1] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.562786][    T1] NET: Registered PF_INET protocol family
[    0.565777][    T1] IP idents hash table entries: 65536 (order: 7, 524288 bytes, linear)
[    0.577693][    T1] tcp_listen_portaddr_hash hash table entries: 2048 (order: 3, 32768 bytes, linear)
[    0.584158][    T1] Table-perturb hash table entries: 65536 (order: 6, 262144 bytes, linear)
[    0.592571][    T1] TCP established hash table entries: 32768 (order: 6, 262144 bytes, linear)
[    0.601494][    T1] TCP bind hash table entries: 32768 (order: 7, 524288 bytes, linear)
[    0.609827][    T1] TCP: Hash tables configured (established 32768 bind 32768)
[    0.616560][    T1] UDP hash table entries: 2048 (order: 4, 65536 bytes, linear)
[    0.623972][    T1] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes, linear)
[    0.631945][    T1] NET: Registered PF_UNIX/PF_LOCAL protocol family
[    0.638470][    T1] RPC: Registered named UNIX socket transport module.
[    0.644711][    T1] RPC: Registered udp transport module.
[    0.650116][    T1] RPC: Registered tcp transport module.
[    0.655516][    T1] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.662672][    T1] PCI: CLS 0 bytes, default 64
[    0.668140][    T1] hw perfevents: enabled with armv8_cortex_a53 PMU driver, 7 counters available
[    0.678299][    T1] Initialise system trusted keyrings
[    0.681494][    T1] workingset: timestamp_bits=42 max_order=20 bucket_order=0
[    0.697669][    T1] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    0.702176][    T1] NFS: Registering the id_resolver key type
[    0.707163][    T1] Key type id_resolver registered
[    0.712008][    T1] Key type id_legacy registered
[    0.716812][    T1] nfs4filelayout_init: NFSv4 File Layout Driver Registering...
[    0.724130][    T1] nfs4flexfilelayout_init: NFSv4 Flexfile Layout Driver Registering...
[    0.787889][    T1] Key type asymmetric registered
[    0.789832][    T1] Asymmetric key parser 'x509' registered
[    0.795474][    T1] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 243)
[    0.803537][    T1] io scheduler mq-deadline registered
[    0.808765][    T1] io scheduler kyber registered
[    0.820609][    T1] imx-pgc imx-pgc-domain.0: imx_pgc_domain_probe: Probe succeeded
[    0.825861][    T1] imx-pgc imx-pgc-domain.2: imx_pgc_domain_probe: Probe succeeded
[    0.833300][    T1] imx-pgc imx-pgc-domain.3: imx_pgc_domain_probe: Probe succeeded
[    0.840957][    T1] imx-pgc imx-pgc-domain.4: imx_pgc_domain_probe: Probe succeeded
[    0.849079][    T1] imx-pgc imx-pgc-domain.7: imx_pgc_domain_probe: Probe succeeded
[    0.856313][    T1] imx-pgc imx-pgc-domain.8: imx_pgc_domain_probe: Probe succeeded
[    0.863985][    T1] imx-pgc imx-pgc-domain.9: imx_pgc_domain_probe: Probe succeeded
[    0.871658][    T1] imx-pgc imx-pgc-domain.10: imx_pgc_domain_probe: Probe succeeded
[    0.879282][    T1] imx-gpcv2 303a0000.gpc: imx_gpcv2_probe: Probe succeeded
[    0.886886][    T1] SoC: i.MX8MQ revision 2.1
[    0.896040][    T1] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.916005][    T1] igbvf: Intel(R) Gigabit Virtual Function Network Driver
[    0.920152][    T1] igbvf: Copyright (c) 2009 - 2012 Intel Corporation.
[    0.927211][    T1] VFIO - User Level meta-driver version: 0.3
[    0.934574][    T1] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.939877][    T1] ehci-pci: EHCI PCI platform driver
[    0.945038][    T1] ehci-platform: EHCI generic platform driver
[    0.952771][    T1] i2c_dev: i2c /dev entries driver
[    0.958624][    T1] sdhci: Secure Digital Host Controller Interface driver
[    0.962791][    T1] sdhci: Copyright(c) Pierre Ossman
[    0.968202][    T1] Synopsys Designware Multimedia Card Interface Driver
[    0.975227][    T1] sdhci-pltfm: SDHCI platform and OF driver helper
[    0.983039][    T1] ledtrig-cpu: registered to indicate activity on CPUs
[    0.988797][    T1] hid: raw HID events driver (C) Jiri Kosina
[    0.994056][    T1] usbcore: registered new interface driver usbhid
[    0.999766][    T1] usbhid: USB HID core driver
[    1.007142][    T1]  cs_system_cfg: CoreSight Configuration manager initialised
[    1.017973][    T1] NET: Registered PF_PACKET protocol family
[    1.021006][    T1] Key type dns_resolver registered
[    1.026254][    T1] registered taskstats version 1
[    1.030692][    T1] Loading compiled-in X.509 certificates
[    1.072731][    T8] imx8m-blk-ctrl 38320000.blk-ctrl: error -ENODEV: failed to attach power domain "bus"

--nextPart2073037.VLH7GnMWUR--



