Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 591032D6827
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 21:10:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404275AbgLJTnF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 14:43:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393443AbgLJTm7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 14:42:59 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 235BAC0613D6;
        Thu, 10 Dec 2020 11:42:19 -0800 (PST)
Message-Id: <20201210194042.703779349@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1607629337;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=xNUoZoBVroF7IJy3X8hhV7V+S/ANMxwK+r48iZvHH7k=;
        b=SuZCyt4zlNSkg7Jh6xjd5t+bljnkIDhiuE1rhn/qKeMG+ite6vJEiEbNofXy6Jc8tYg+0b
        IECvv2LjnWcGzCS6R2c2tg4sgQpGcjXByKLBZPL7Xs4OwNUUaKF820w3Ic1JKPFWbxYaV/
        zQxlwp4rnzD+WzTiaw91J+4L7iQQ+SR32KSqZT854CLAJKIIUHqBcwUh01vq4gYJysHS9U
        2YuIdbPutXAYf6qxYXI8k/N2s6EcL8OojQbYBV3yqFeMwoY5o0cLfzqE9P8/gw+P+igDVq
        lKj3W3wk7xu1ziy9h34ybqOITt3G9Oy0XdV3S2Ut5Fvm8NWwxziMLNP2XRk3vg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1607629337;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=xNUoZoBVroF7IJy3X8hhV7V+S/ANMxwK+r48iZvHH7k=;
        b=VHoSRskFC2dXgfT8CV99ZHE5BpRPUfLU6nfE7o3PMPrsIEKWqDmtgbLpWFRMlRZjjTeINe
        qsFjW8cMZ9WikxCw==
Date:   Thu, 10 Dec 2020 20:25:38 +0100
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Marc Zyngier <maz@kernel.org>,
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
        Leon Romanovsky <leon@kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        xen-devel@lists.xenproject.org
Subject: [patch 02/30] genirq: Move status flag checks to core
References: <20201210192536.118432146@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-transfer-encoding: 8-bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These checks are used by modules and prevent the removal of the export of
irq_to_desc(). Move the accessor into the core.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/irqdesc.h |   17 +++++------------
 kernel/irq/manage.c     |   17 +++++++++++++++++
 2 files changed, 22 insertions(+), 12 deletions(-)

--- a/include/linux/irqdesc.h
+++ b/include/linux/irqdesc.h
@@ -223,28 +223,21 @@ irq_set_chip_handler_name_locked(struct
 	data->chip = chip;
 }
 
+bool irq_check_status_bit(unsigned int irq, unsigned int bitmask);
+
 static inline bool irq_balancing_disabled(unsigned int irq)
 {
-	struct irq_desc *desc;
-
-	desc = irq_to_desc(irq);
-	return desc->status_use_accessors & IRQ_NO_BALANCING_MASK;
+	return irq_check_status_bit(irq, IRQ_NO_BALANCING_MASK);
 }
 
 static inline bool irq_is_percpu(unsigned int irq)
 {
-	struct irq_desc *desc;
-
-	desc = irq_to_desc(irq);
-	return desc->status_use_accessors & IRQ_PER_CPU;
+	return irq_check_status_bit(irq, IRQ_PER_CPU);
 }
 
 static inline bool irq_is_percpu_devid(unsigned int irq)
 {
-	struct irq_desc *desc;
-
-	desc = irq_to_desc(irq);
-	return desc->status_use_accessors & IRQ_PER_CPU_DEVID;
+	return irq_check_status_bit(irq, IRQ_PER_CPU_DEVID);
 }
 
 static inline void
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -2769,3 +2769,23 @@ bool irq_has_action(unsigned int irq)
 	return res;
 }
 EXPORT_SYMBOL_GPL(irq_has_action);
+
+/**
+ * irq_check_status_bit - Check whether bits in the irq descriptor status are set
+ * @irq:	The linux irq number
+ * @bitmask:	The bitmask to evaluate
+ *
+ * Returns: True if one of the bits in @bitmask is set
+ */
+bool irq_check_status_bit(unsigned int irq, unsigned int bitmask)
+{
+	struct irq_desc *desc;
+	bool res = false;
+
+	rcu_read_lock();
+	desc = irq_to_desc(irq);
+	if (desc)
+		res = !!(desc->status_use_accessors & bitmask);
+	rcu_read_unlock();
+	return res;
+}

