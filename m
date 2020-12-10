Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1988A2D6787
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 20:52:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404468AbgLJTwE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 14:52:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404335AbgLJTnk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 14:43:40 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36F09C0611C5;
        Thu, 10 Dec 2020 11:42:35 -0800 (PST)
Message-Id: <20201210194044.065003856@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1607629353;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=fEH7SfFXgNBjB2KnJKxA/TzRUtcjVN/8Utn6le7GAgY=;
        b=jLhcNWAI6/f0h7r8+rFxJO/huD0wZGw+D4hiyZeoGMMj1an/mYZLtmxjGnZ/aSu9ajxbNk
        p75pL7pZYF9lDXL6k6cLxjzZOwC5q8ecIjJ39xF/dSPObsyqM+yudoL9yN0v7780Bn5yyF
        /Ve3t66EmBeMbc9BsRyBF2dkjfBuqeDKx8lYvDouLXZuAf0vFtIPH5zU4jlfdixs/IVdOS
        vmsr5U63fIVzglTEhwYSxzXESekgTuzdOHcprErKfUMwbSexx9oDdfFa+4Z1VcZaNX5rSu
        6l8HXwdp3e4RNwPr1pyTZfpMenA4zfmUQEoZ4/oyxWsRJm8zIR/y6ojvGi9aNQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1607629353;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=fEH7SfFXgNBjB2KnJKxA/TzRUtcjVN/8Utn6le7GAgY=;
        b=vcq9ylrl3bvEPVRyLq7+7uNgnxo0i4JU/giqH4jOxFiIi2uv7Mz1SZNae4Tgp0yDwrMR2T
        GgsHxKk5w8TyzfBQ==
Date:   Thu, 10 Dec 2020 20:25:51 +0100
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Marc Zyngier <maz@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
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
        Lee Jones <lee.jones@linaro.org>, Jon Mason <jdmason@kudzu.us>,
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
Subject: [patch 15/30] pinctrl: nomadik: Use irq_has_action()
References: <20201210192536.118432146@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-transfer-encoding: 8-bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Let the core code do the fiddling with irq_desc.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-gpio@vger.kernel.org
---
 drivers/pinctrl/nomadik/pinctrl-nomadik.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/pinctrl/nomadik/pinctrl-nomadik.c
+++ b/drivers/pinctrl/nomadik/pinctrl-nomadik.c
@@ -948,7 +948,6 @@ static void nmk_gpio_dbg_show_one(struct
 			   (mode < 0) ? "unknown" : modes[mode]);
 	} else {
 		int irq = chip->to_irq(chip, offset);
-		struct irq_desc	*desc = irq_to_desc(irq);
 		const int pullidx = pull ? 1 : 0;
 		int val;
 		static const char * const pulls[] = {
@@ -969,7 +968,7 @@ static void nmk_gpio_dbg_show_one(struct
 		 * This races with request_irq(), set_irq_type(),
 		 * and set_irq_wake() ... but those are "rare".
 		 */
-		if (irq > 0 && desc && desc->action) {
+		if (irq > 0 && irq_has_action(irq)) {
 			char *trigger;
 
 			if (nmk_chip->edge_rising & BIT(offset))

