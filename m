Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A9882AE8E1
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 07:26:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726236AbgKKGY0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 01:24:26 -0500
Received: from foss.arm.com ([217.140.110.172]:41810 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726125AbgKKGXK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Nov 2020 01:23:10 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2126E1476;
        Tue, 10 Nov 2020 22:23:10 -0800 (PST)
Received: from localhost.localdomain (entos-thunderx2-desktop.shanghai.arm.com [10.169.212.215])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id C62AE3F6CF;
        Tue, 10 Nov 2020 22:23:03 -0800 (PST)
From:   Jianyong Wu <jianyong.wu@arm.com>
To:     netdev@vger.kernel.org, yangbo.lu@nxp.com, john.stultz@linaro.org,
        tglx@linutronix.de, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, maz@kernel.org,
        richardcochran@gmail.com, Mark.Rutland@arm.com, will@kernel.org,
        suzuki.poulose@arm.com, Andre.Przywara@arm.com,
        steven.price@arm.com
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Steve.Capper@arm.com, justin.he@arm.com, jianyong.wu@arm.com,
        nd@arm.com
Subject: [PATCH v15 5/9] clocksource: Add clocksource id for arm arch counter
Date:   Wed, 11 Nov 2020 14:22:07 +0800
Message-Id: <20201111062211.33144-6-jianyong.wu@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201111062211.33144-1-jianyong.wu@arm.com>
References: <20201111062211.33144-1-jianyong.wu@arm.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add clocksource id for arm arch counter to let it be identified easily and
elegantly in ptp_kvm implementation for arm.

Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
---
 drivers/clocksource/arm_arch_timer.c | 2 ++
 include/linux/clocksource_ids.h      | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index 6c3e84180146..d55acffb0b90 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -16,6 +16,7 @@
 #include <linux/cpu_pm.h>
 #include <linux/clockchips.h>
 #include <linux/clocksource.h>
+#include <linux/clocksource_ids.h>
 #include <linux/interrupt.h>
 #include <linux/of_irq.h>
 #include <linux/of_address.h>
@@ -191,6 +192,7 @@ static u64 arch_counter_read_cc(const struct cyclecounter *cc)
 
 static struct clocksource clocksource_counter = {
 	.name	= "arch_sys_counter",
+	.id	= CSID_ARM_ARCH_COUNTER,
 	.rating	= 400,
 	.read	= arch_counter_read,
 	.mask	= CLOCKSOURCE_MASK(56),
diff --git a/include/linux/clocksource_ids.h b/include/linux/clocksource_ids.h
index 4d8e19e05328..16775d7d8f8d 100644
--- a/include/linux/clocksource_ids.h
+++ b/include/linux/clocksource_ids.h
@@ -5,6 +5,7 @@
 /* Enum to give clocksources a unique identifier */
 enum clocksource_ids {
 	CSID_GENERIC		= 0,
+	CSID_ARM_ARCH_COUNTER,
 	CSID_MAX,
 };
 
-- 
2.17.1

