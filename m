Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA782D67B0
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 20:57:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393702AbgLJT4g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 14:56:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404332AbgLJTnk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 14:43:40 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAB36C061282;
        Thu, 10 Dec 2020 11:42:28 -0800 (PST)
Message-Id: <20201210194043.546326568@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1607629347;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=5nQTlSWs0aM1JwskkO++sgVx3e7r1A0iUoENDct9w0g=;
        b=QPllCmzoid7R7QOyZWHCOYQKMI+juGJWW7IXPn4ldqvXap5zOWqeLwIujbfic04O+qhazO
        0xgWWwKg3GbwssA1OWCHaW+e3v13fVknyR8JXjPDh7PwNE+Ckpns9v0fFT+ZM3yGQ/k3Vv
        GCsqZz06V+zRI8tFVRs2T2IovMxYUYd8eD6JafQc5V2xJxNbrsWbTKI93mSM/Ta7w2MVgk
        H0DCRjstAo+JEpF+kGbxIAfIodj4WQwAN11f4kvj+YdByF1NUUzPqO+eeo3F+Zo17kc0So
        XSotZsWfd7b5nXWYK0Zyq3GvoLnhjvZlI0o0fsviKiEzV4hSu6MDcZkJycE3/A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1607629347;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=5nQTlSWs0aM1JwskkO++sgVx3e7r1A0iUoENDct9w0g=;
        b=vR1W3s1vgzWnaT5Q7BZrP5IMwXx2MgiIHJAS9ztGZt4iF+7Bkm46E7nJWgDdHbgllL9/0G
        km2qINIgPXSFZ2CQ==
Date:   Thu, 10 Dec 2020 20:25:46 +0100
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Marc Zyngier <maz@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Helge Deller <deller@gmx.de>,
        afzal mohammed <afzal.mohd.ma@gmail.com>,
        linux-parisc@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
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
Subject: [patch 10/30] arm64/smp: Use irq_desc_kstat_cpu() in arch_show_interrupts()
References: <20201210192536.118432146@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-transfer-encoding: 8-bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The irq descriptor is already there, no need to look it up again.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
---
 arch/arm64/kernel/smp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -809,7 +809,7 @@ int arch_show_interrupts(struct seq_file
 		seq_printf(p, "%*s%u:%s", prec - 1, "IPI", i,
 			   prec >= 4 ? " " : "");
 		for_each_online_cpu(cpu)
-			seq_printf(p, "%10u ", kstat_irqs_cpu(irq, cpu));
+			seq_printf(p, "%10u ", irq_desc_kstat_cpu(ipi_desc[i], cpu));
 		seq_printf(p, "      %s\n", ipi_types[i]);
 	}
 

