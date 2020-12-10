Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89C212D6735
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 20:45:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404415AbgLJToM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 14:44:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393492AbgLJTnb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 14:43:31 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 915D1C06138C;
        Thu, 10 Dec 2020 11:42:27 -0800 (PST)
Message-Id: <20201210194043.454288890@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1607629346;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=d6ZnDp1ZYVpzy4fVKUFFFULYmpUUlcl5sebpJ1aGphc=;
        b=MSBX3shBH0qoLZgoBaKe5kLbUB8TnsF2wkt/HDprwYNeTCAbd2lA/IPfG5shNVgtErFne6
        2e7dxedwAVSHA242jzYwEZEDos7nzVn3jxex71TScShSaummfLGCXQPpi9hsC6bxlpki1A
        PaKHNLN8C0jAcib2U6kKogdFm6aBvAusAl2wzmpxVjN8CVqMhcCswRy3h+4P9laPxunXLd
        H7LLUzUcw0fvfesHPPxL0uK/nLdCXiS7KyYQy2gAPBMvgGCcbyREn+oK+jObT1BhRalalZ
        V5Nn3/fVSWTJibiL01V8QA9WbzxTf/xt6yFIPqkmLVhG809hQRqJj+6eoADqiw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1607629346;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=d6ZnDp1ZYVpzy4fVKUFFFULYmpUUlcl5sebpJ1aGphc=;
        b=/jZEQ2YP5EiBLPFVPa41DzeVlkA22cUlEXVQ4rLDBt8Dt9AhsUKkU1UyqJF1WyN4nzOpZY
        l36XkFlXpQQTzpDg==
Date:   Thu, 10 Dec 2020 20:25:45 +0100
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Marc Zyngier <maz@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Helge Deller <deller@gmx.de>,
        afzal mohammed <afzal.mohd.ma@gmail.com>,
        linux-parisc@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
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
Subject: [patch 09/30] ARM: smp: Use irq_desc_kstat_cpu() in show_ipi_list()
References: <20201210192536.118432146@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-transfer-encoding: 8-bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The irq descriptor is already there, no need to look it up again.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org
---
 arch/arm/kernel/smp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -550,7 +550,7 @@ void show_ipi_list(struct seq_file *p, i
 		seq_printf(p, "%*s%u: ", prec - 1, "IPI", i);
 
 		for_each_online_cpu(cpu)
-			seq_printf(p, "%10u ", kstat_irqs_cpu(irq, cpu));
+			seq_printf(p, "%10u ", irq_desc_kstat_cpu(ipi_desc[i], cpu));
 
 		seq_printf(p, " %s\n", ipi_types[i]);
 	}

