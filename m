Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E0F32D6734
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 20:45:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404405AbgLJTn6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 14:43:58 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:57796 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404307AbgLJTnc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 14:43:32 -0500
Message-Id: <20201210194045.250321315@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1607629368;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=h+/J8p7baJr0DOpzZw5pWLEFMQkgQKdthJegqn8/Z3Y=;
        b=ViQ26TbnUeY8qEjEzYulRVnhFAoB9EDH9YUPDvEiFg//dnXloI1oen9eNgmVDH3RmZaBn0
        0l0hb/eh9AtQOqQOiBnzJtoucvR/Mgcwm3gjLtIH7WkV3WksbFVdOMHzNi5Zj6EnqfiQBo
        j3AWozoE82ZIwe2qbFS8RFleThcs9Bt3OInvffx5HlfgL9KUZRRlg7kyEJZxqWJqWBqEXh
        aZpEesZBBg55CfasJSjlzL/0bXPLxp/DGSRYtaZAfSC1smsroPfxhOGgzqx3F6MyhNadS8
        HUk9gvp8N0w4LGaQVpf17rVe2GplhulXqQJFiAihQg9NPYrVAz0L2MOk4uIbBw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1607629368;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=h+/J8p7baJr0DOpzZw5pWLEFMQkgQKdthJegqn8/Z3Y=;
        b=VbJwfVLRzH/9JhiMalVLwKmOuULPqzvXaWNQJQDqIexhTGvkL8AL9yE+2ch4ltaw7RfVm0
        CZcollJCruWADiAA==
Date:   Thu, 10 Dec 2020 20:26:03 +0100
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Marc Zyngier <maz@kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        xen-devel@lists.xenproject.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Helge Deller <deller@gmx.de>,
        afzal mohammed <afzal.mohd.ma@gmail.com>,
        linux-parisc@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, linux-s390@vger.kernel.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Pankaj Bharadiya <pankaj.laxminarayan.bharadiya@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Wambui Karuga <wambui.karugax@gmail.com>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-gpio@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Jon Mason <jdmason@kudzu.us>,
        Dave Jiang <dave.jiang@intel.com>,
        Allen Hubbe <allenbh@gmail.com>, linux-ntb@googlegroups.com,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Rob Herring <robh@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Michal Simek <michal.simek@xilinx.com>,
        linux-pci@vger.kernel.org,
        Karthikeyan Mitran <m.karthikeyan@mobiveil.co.in>,
        Hou Zhiqiang <Zhiqiang.Hou@nxp.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>
Subject: [patch 27/30] xen/events: Only force affinity mask for percpu interrupts
References: <20201210192536.118432146@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-transfer-encoding: 8-bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All event channel setups bind the interrupt on CPU0 or the target CPU for
percpu interrupts and overwrite the affinity mask with the corresponding
cpumask. That does not make sense.

The XEN implementation of irqchip::irq_set_affinity() already picks a
single target CPU out of the affinity mask and the actual target is stored
in the effective CPU mask, so destroying the user chosen affinity mask
which might contain more than one CPU is wrong.

Change the implementation so that the channel is bound to CPU0 at the XEN
level and leave the affinity mask alone. At startup of the interrupt
affinity will be assigned out of the affinity mask and the XEN binding will
be updated. Only keep the enforcement for real percpu interrupts.

On resume the overwrite is not required either because info->cpu and the
affinity mask are still the same as at the time of suspend. Same for
rebind_evtchn_irq().

This also prepares for proper interrupt spreading.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: xen-devel@lists.xenproject.org
---
 drivers/xen/events/events_base.c |   42 ++++++++++++++++++++++++++-------------
 1 file changed, 28 insertions(+), 14 deletions(-)

--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -433,15 +433,20 @@ static bool pirq_needs_eoi_flag(unsigned
 	return info->u.pirq.flags & PIRQ_NEEDS_EOI;
 }
 
-static void bind_evtchn_to_cpu(evtchn_port_t evtchn, unsigned int cpu)
+static void bind_evtchn_to_cpu(evtchn_port_t evtchn, unsigned int cpu,
+			       bool force_affinity)
 {
 	int irq = get_evtchn_to_irq(evtchn);
 	struct irq_info *info = info_for_irq(irq);
 
 	BUG_ON(irq == -1);
-#ifdef CONFIG_SMP
-	cpumask_copy(irq_get_affinity_mask(irq), cpumask_of(cpu));
-#endif
+
+	if (IS_ENABLED(CONFIG_SMP) && force_affinity) {
+		cpumask_copy(irq_get_affinity_mask(irq), cpumask_of(cpu));
+		cpumask_copy(irq_get_effective_affinity_mask(irq),
+			     cpumask_of(cpu));
+	}
+
 	xen_evtchn_port_bind_to_cpu(evtchn, cpu, info->cpu);
 
 	info->cpu = cpu;
@@ -788,7 +793,7 @@ static unsigned int __startup_pirq(unsig
 		goto err;
 
 	info->evtchn = evtchn;
-	bind_evtchn_to_cpu(evtchn, 0);
+	bind_evtchn_to_cpu(evtchn, 0, false);
 
 	rc = xen_evtchn_port_setup(evtchn);
 	if (rc)
@@ -1107,8 +1112,8 @@ static int bind_evtchn_to_irq_chip(evtch
 			irq = ret;
 			goto out;
 		}
-		/* New interdomain events are bound to VCPU 0. */
-		bind_evtchn_to_cpu(evtchn, 0);
+		/* New interdomain events are initially bound to VCPU 0. */
+		bind_evtchn_to_cpu(evtchn, 0, false);
 	} else {
 		struct irq_info *info = info_for_irq(irq);
 		WARN_ON(info == NULL || info->type != IRQT_EVTCHN);
@@ -1156,7 +1161,11 @@ static int bind_ipi_to_irq(unsigned int
 			irq = ret;
 			goto out;
 		}
-		bind_evtchn_to_cpu(evtchn, cpu);
+		/*
+		 * Force the affinity mask to the target CPU so proc shows
+		 * the correct target.
+		 */
+		bind_evtchn_to_cpu(evtchn, cpu, true);
 	} else {
 		struct irq_info *info = info_for_irq(irq);
 		WARN_ON(info == NULL || info->type != IRQT_IPI);
@@ -1269,7 +1278,11 @@ int bind_virq_to_irq(unsigned int virq,
 			goto out;
 		}
 
-		bind_evtchn_to_cpu(evtchn, cpu);
+		/*
+		 * Force the affinity mask for percpu interrupts so proc
+		 * shows the correct target.
+		 */
+		bind_evtchn_to_cpu(evtchn, cpu, percpu);
 	} else {
 		struct irq_info *info = info_for_irq(irq);
 		WARN_ON(info == NULL || info->type != IRQT_VIRQ);
@@ -1634,8 +1647,7 @@ void rebind_evtchn_irq(evtchn_port_t evt
 
 	mutex_unlock(&irq_mapping_update_lock);
 
-        bind_evtchn_to_cpu(evtchn, info->cpu);
-	irq_set_affinity(irq, cpumask_of(info->cpu));
+	bind_evtchn_to_cpu(evtchn, info->cpu, false);
 
 	/* Unmask the event channel. */
 	enable_irq(irq);
@@ -1669,7 +1681,7 @@ static int xen_rebind_evtchn_to_cpu(evtc
 	 * it, but don't do the xenlinux-level rebind in that case.
 	 */
 	if (HYPERVISOR_event_channel_op(EVTCHNOP_bind_vcpu, &bind_vcpu) >= 0)
-		bind_evtchn_to_cpu(evtchn, tcpu);
+		bind_evtchn_to_cpu(evtchn, tcpu, false);
 
 	if (!masked)
 		unmask_evtchn(evtchn);
@@ -1798,7 +1810,8 @@ static void restore_cpu_virqs(unsigned i
 
 		/* Record the new mapping. */
 		(void)xen_irq_info_virq_setup(cpu, irq, evtchn, virq);
-		bind_evtchn_to_cpu(evtchn, cpu);
+		/* The affinity mask is still valid */
+		bind_evtchn_to_cpu(evtchn, cpu, false);
 	}
 }
 
@@ -1823,7 +1836,8 @@ static void restore_cpu_ipis(unsigned in
 
 		/* Record the new mapping. */
 		(void)xen_irq_info_ipi_setup(cpu, irq, evtchn, ipi);
-		bind_evtchn_to_cpu(evtchn, cpu);
+		/* The affinity mask is still valid */
+		bind_evtchn_to_cpu(evtchn, cpu, false);
 	}
 }
 

