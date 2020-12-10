Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A39DE2D67F3
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 21:03:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404518AbgLJUB1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 15:01:27 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:57658 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393543AbgLJTn3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 14:43:29 -0500
Message-Id: <20201210194045.065115500@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1607629366;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=tEVls3jI8V5LtEBTs0cm0Szr6SDBh3GYqdx/X7n2UZY=;
        b=bwVQ7gaQwvbfHTgP7MZDc/YhDLMbL2OEi1WnGDxUtEPa/zAOSNbqLaLeQTtD11Dg5082Qp
        Qz2zPtGhojJeSFokGiFaFmgg8DCDEwh1sTNplvk+ABtrVMp4PQqBe9MzYq5Rmcua4Vok7H
        MC3M8vw+sJGbud8ji2De2+9/N0C9SKASfhkEKBqszbBCF+wOvRW/V0B92szqDuXVqeCKre
        YRoIqIe820JAXb6fr66VrfJCEVfdlAwTC/JagtnRSgmfc3XazagnRYgk6a6iOnmsLRNX1p
        MVTREOpKae1E6DDuEk9FawkuR3E7r4E4WNu7go88D2q5JTNminPamGP01SwVTQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1607629366;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=tEVls3jI8V5LtEBTs0cm0Szr6SDBh3GYqdx/X7n2UZY=;
        b=oavywJTHDWv3olwcxAvfm8NfynriH4GVMpKUR3SAwF8GgtSSOX9oqiCpUNJcYYnYuyj2zl
        2KDiXd1knCZbiIAw==
Date:   Thu, 10 Dec 2020 20:26:01 +0100
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
Subject: [patch 25/30] xen/events: Remove disfunct affinity spreading
References: <20201210192536.118432146@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-transfer-encoding: 8-bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This function can only ever work when the event channels:

  - are already established
  - interrupts assigned to them
  - the affinity has been set by user space already

because any newly set up event channel is forced to be bound to CPU0 and
the affinity mask of the interrupt is forced to contain cpumask_of(0).

As the CPU0 enforcement was in place _before_ this was implemented it's
entirely unclear how that can ever have worked at all.

Remove it as preparation for doing it proper.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: xen-devel@lists.xenproject.org
---
 drivers/xen/events/events_base.c |    9 ---------
 drivers/xen/evtchn.c             |   34 +---------------------------------
 2 files changed, 1 insertion(+), 42 deletions(-)

--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -1696,15 +1696,6 @@ static int set_affinity_irq(struct irq_d
 	return ret;
 }
 
-/* To be called with desc->lock held. */
-int xen_set_affinity_evtchn(struct irq_desc *desc, unsigned int tcpu)
-{
-	struct irq_data *d = irq_desc_get_irq_data(desc);
-
-	return set_affinity_irq(d, cpumask_of(tcpu), false);
-}
-EXPORT_SYMBOL_GPL(xen_set_affinity_evtchn);
-
 static void enable_dynirq(struct irq_data *data)
 {
 	evtchn_port_t evtchn = evtchn_from_irq(data->irq);
--- a/drivers/xen/evtchn.c
+++ b/drivers/xen/evtchn.c
@@ -421,36 +421,6 @@ static void evtchn_unbind_from_user(stru
 	del_evtchn(u, evtchn);
 }
 
-static DEFINE_PER_CPU(int, bind_last_selected_cpu);
-
-static void evtchn_bind_interdom_next_vcpu(evtchn_port_t evtchn)
-{
-	unsigned int selected_cpu, irq;
-	struct irq_desc *desc;
-	unsigned long flags;
-
-	irq = irq_from_evtchn(evtchn);
-	desc = irq_to_desc(irq);
-
-	if (!desc)
-		return;
-
-	raw_spin_lock_irqsave(&desc->lock, flags);
-	selected_cpu = this_cpu_read(bind_last_selected_cpu);
-	selected_cpu = cpumask_next_and(selected_cpu,
-			desc->irq_common_data.affinity, cpu_online_mask);
-
-	if (unlikely(selected_cpu >= nr_cpu_ids))
-		selected_cpu = cpumask_first_and(desc->irq_common_data.affinity,
-				cpu_online_mask);
-
-	this_cpu_write(bind_last_selected_cpu, selected_cpu);
-
-	/* unmask expects irqs to be disabled */
-	xen_set_affinity_evtchn(desc, selected_cpu);
-	raw_spin_unlock_irqrestore(&desc->lock, flags);
-}
-
 static long evtchn_ioctl(struct file *file,
 			 unsigned int cmd, unsigned long arg)
 {
@@ -508,10 +478,8 @@ static long evtchn_ioctl(struct file *fi
 			break;
 
 		rc = evtchn_bind_to_user(u, bind_interdomain.local_port);
-		if (rc == 0) {
+		if (rc == 0)
 			rc = bind_interdomain.local_port;
-			evtchn_bind_interdom_next_vcpu(rc);
-		}
 		break;
 	}
 

