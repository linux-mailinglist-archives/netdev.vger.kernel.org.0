Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 664472D678F
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 20:54:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393533AbgLJTwW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 14:52:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404336AbgLJTnm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 14:43:42 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C406C0611CA;
        Thu, 10 Dec 2020 11:42:36 -0800 (PST)
Message-Id: <20201210194044.157283633@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1607629354;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=4K6qItYlSe7EBUp3WfMEzcI2y69yZ4OdOhSokF1HvFw=;
        b=dopfjz4hp6A4Xryu0tbdegM/v0YL6lWYdnP3XlIYCgQ9pjXx9ZT1p3TI0zk4elgm5gPd+q
        FURWbMd/ftse0CXn8TWD7Lf/LMt29YyfqJkuoxwIq2zLBOhpU5N1uQ9NTcofTSPiRoKfTO
        PEbzx4Og6n9n+3PdfyA3eCON82LOBsb5cz2c2++JdWXn2zeffzgZ5twz3L2T1NgK3Sr/6E
        z4hGHNQPL1mjIDXhMbZMKcry3IqKzOm1XwkJ497HBo+O7rAGzJagP8Bz95WOHjr107cL1M
        F3z7vCp/PgmQ7w0NfOrec8JvWkd2Glw3/TrHKxQy3AjIzKLFjQ11edATiOjGMg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1607629354;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=4K6qItYlSe7EBUp3WfMEzcI2y69yZ4OdOhSokF1HvFw=;
        b=K3Wur5e2Woy0OzRxLAAmfcCZIUuOyHlagbFXs1H4WET0hQYXgya6h4ah4Fheh+nueTyzzX
        ONj+v+orSFGMaLBQ==
Date:   Thu, 10 Dec 2020 20:25:52 +0100
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Marc Zyngier <maz@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Helge Deller <deller@gmx.de>,
        afzal mohammed <afzal.mohd.ma@gmail.com>,
        linux-parisc@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
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
        linux-gpio@vger.kernel.org, Jon Mason <jdmason@kudzu.us>,
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
Subject: [patch 16/30] mfd: ab8500-debugfs: Remove the racy fiddling with irq_desc
References: <20201210192536.118432146@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-transfer-encoding: 8-bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

First of all drivers have absolutely no business to dig into the internals
of an irq descriptor. That's core code and subject to change. All of this
information is readily available to /proc/interrupts in a safe and race
free way.

Remove the inspection code which is a blatant violation of subsystem
boundaries and racy against concurrent modifications of the interrupt
descriptor.

Print the irq line instead so the information can be looked up in a sane
way in /proc/interrupts.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org
---
 drivers/mfd/ab8500-debugfs.c |   16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

--- a/drivers/mfd/ab8500-debugfs.c
+++ b/drivers/mfd/ab8500-debugfs.c
@@ -1513,24 +1513,14 @@ static int ab8500_interrupts_show(struct
 {
 	int line;
 
-	seq_puts(s, "name: number:  number of: wake:\n");
+	seq_puts(s, "name: number: irq: number of: wake:\n");
 
 	for (line = 0; line < num_interrupt_lines; line++) {
-		struct irq_desc *desc = irq_to_desc(line + irq_first);
-
-		seq_printf(s, "%3i:  %6i %4i",
+		seq_printf(s, "%3i:  %6i %4i %4i\n",
 			   line,
+			   line + irq_first,
 			   num_interrupts[line],
 			   num_wake_interrupts[line]);
-
-		if (desc && desc->name)
-			seq_printf(s, "-%-8s", desc->name);
-		if (desc && desc->action) {
-			struct irqaction *action = desc->action;
-
-			seq_printf(s, "  %s", action->name);
-			while ((action = action->next) != NULL)
-				seq_printf(s, ", %s", action->name);
 		}
 		seq_putc(s, '\n');
 	}

