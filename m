Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AE2515710E
	for <lists+netdev@lfdr.de>; Mon, 10 Feb 2020 09:50:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727690AbgBJItu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Feb 2020 03:49:50 -0500
Received: from foss.arm.com ([217.140.110.172]:57540 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727681AbgBJItt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Feb 2020 03:49:49 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0BDD231B;
        Mon, 10 Feb 2020 00:49:49 -0800 (PST)
Received: from entos-d05.shanghai.arm.com (entos-d05.shanghai.arm.com [10.169.40.35])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id B2E6A3F68F;
        Mon, 10 Feb 2020 00:49:43 -0800 (PST)
From:   Jianyong Wu <jianyong.wu@arm.com>
To:     netdev@vger.kernel.org, yangbo.lu@nxp.com, john.stultz@linaro.org,
        tglx@linutronix.de, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, maz@kernel.org,
        richardcochran@gmail.com, Mark.Rutland@arm.com, will@kernel.org,
        suzuki.poulose@arm.com, steven.price@arm.com
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Steve.Capper@arm.com, Kaly.Xin@arm.com, justin.he@arm.com,
        jianyong.wu@arm.com, nd@arm.com
Subject: [RFC PATCH 4/9] clocksource: Add clocksource id for arm arch counter
Date:   Mon, 10 Feb 2020 16:49:01 +0800
Message-Id: <20200210084906.24870-5-jianyong.wu@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200210084906.24870-1-jianyong.wu@arm.com>
References: <20200210084906.24870-1-jianyong.wu@arm.com>
Sender: netdev-owner@vger.kernel.org
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
index 9a5464c625b4..4eb014fefa5b 100644
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
@@ -187,6 +188,7 @@ static u64 arch_counter_read_cc(const struct cyclecounter *cc)
 
 static struct clocksource clocksource_counter = {
 	.name	= "arch_sys_counter",
+	.id	= CSID_ARM_ARCH_COUNTER,
 	.rating	= 400,
 	.read	= arch_counter_read,
 	.mask	= CLOCKSOURCE_MASK(56),
diff --git a/include/linux/clocksource_ids.h b/include/linux/clocksource_ids.h
index 5595ab843c3d..93bec8426c44 100644
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

