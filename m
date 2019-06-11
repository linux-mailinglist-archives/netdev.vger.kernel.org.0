Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 787563D13E
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 17:46:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405338AbfFKPp4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 11:45:56 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:46963 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2405276AbfFKPpz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 11:45:55 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 43281203ED;
        Tue, 11 Jun 2019 11:45:53 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 11 Jun 2019 11:45:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=eKgW+W1va/tRERnPXeo/BnAYib1JXFdpR1nJ9l8vngI=; b=bwBJtppk
        TEMKp4DrlGuje2maP992HxHbDEKhoyPLs1ntX66iFldMiHvIRRmX/uv/kPhiBPGi
        8AUQxz8AEG5Ip2uh47ikQyia9MIMunDEF3b+V8twPlXOlSmnGtvds374DiGyj3hY
        k8cx2XpGj9T4Qo1Ho2FrRYY7bmg3zzg5iSRYAgif+dVqqN35fx7otKwy1uKfPUS8
        MoTAR6Tiy5TEOvdZNlTdGBJidcIz4lALQ/+7AU0sqq8XqDj8kc5wGMT2QQndeknc
        TtSMc5Smlar9ixnwI2p0OuihK9Kk/Qr4OU82PEw7E50ddNU0GBQjXhkeyXwVnoGJ
        5dgnJtmNF/AiCA==
X-ME-Sender: <xms:scz_XD2dWyXj7BpK7ixaKRjLILCYa3EGq_hWjOeo38FR6K7vjdzmXw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudehhedgjeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:scz_XOqnTok4WRY3paeh5Woi0nh6W7qtMvrtpJiXVoqOQbsGxF3r5A>
    <xmx:scz_XIXzt0xMaOSYBe23dGdyWLjC91vp81u_Eju30m3Yc6xkUnTrLQ>
    <xmx:scz_XPouLfRhKVzgiuVPBchAHaXZ6yu8yCtO6K8F_Sfp9-OMN4G37A>
    <xmx:scz_XEZDZbkhY2qLxF7t1jInwTlPdgS7wMb1q0XOt8eX8UwCL6pOSg>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 64D3538008A;
        Tue, 11 Jun 2019 11:45:51 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, shalomt@mellanox.com,
        petrm@mellanox.com, richardcochran@gmail.com, olteanv@gmail.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 7/9] mlxsw: spectrum_ptp: Add implementation for physical hardware clock operations
Date:   Tue, 11 Jun 2019 18:45:10 +0300
Message-Id: <20190611154512.17650-8-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190611154512.17650-1-idosch@idosch.org>
References: <20190611154512.17650-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shalom Toledo <shalomt@mellanox.com>

Implement physical hardware clock operations.

Signed-off-by: Shalom Toledo <shalomt@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Reviewed-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/Kconfig   |   1 +
 drivers/net/ethernet/mellanox/mlxsw/Makefile  |   1 +
 .../ethernet/mellanox/mlxsw/spectrum_ptp.c    | 267 ++++++++++++++++++
 .../ethernet/mellanox/mlxsw/spectrum_ptp.h    |  44 +++
 4 files changed, 313 insertions(+)
 create mode 100644 drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
 create mode 100644 drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h

diff --git a/drivers/net/ethernet/mellanox/mlxsw/Kconfig b/drivers/net/ethernet/mellanox/mlxsw/Kconfig
index 11ded0bc7d98..b5d64aed259e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/Kconfig
+++ b/drivers/net/ethernet/mellanox/mlxsw/Kconfig
@@ -83,6 +83,7 @@ config MLXSW_SPECTRUM
 	select PARMAN
 	select OBJAGG
 	select MLXFW
+	imply PTP_1588_CLOCK
 	default m
 	---help---
 	  This driver supports Mellanox Technologies Spectrum Ethernet
diff --git a/drivers/net/ethernet/mellanox/mlxsw/Makefile b/drivers/net/ethernet/mellanox/mlxsw/Makefile
index c4dc72e1ce63..171b36bd8a4e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/Makefile
+++ b/drivers/net/ethernet/mellanox/mlxsw/Makefile
@@ -31,5 +31,6 @@ mlxsw_spectrum-objs		:= spectrum.o spectrum_buffers.o \
 				   spectrum_nve.o spectrum_nve_vxlan.o \
 				   spectrum_dpipe.o
 mlxsw_spectrum-$(CONFIG_MLXSW_SPECTRUM_DCB)	+= spectrum_dcb.o
+mlxsw_spectrum-$(CONFIG_PTP_1588_CLOCK)		+= spectrum_ptp.o
 obj-$(CONFIG_MLXSW_MINIMAL)	+= mlxsw_minimal.o
 mlxsw_minimal-objs		:= minimal.o
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
new file mode 100644
index 000000000000..2a9bbc90225e
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
@@ -0,0 +1,267 @@
+// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
+/* Copyright (c) 2019 Mellanox Technologies. All rights reserved */
+
+#include <linux/ptp_clock_kernel.h>
+#include <linux/clocksource.h>
+#include <linux/timecounter.h>
+#include <linux/spinlock.h>
+#include <linux/device.h>
+
+#include "spectrum_ptp.h"
+#include "core.h"
+
+#define MLXSW_SP1_PTP_CLOCK_CYCLES_SHIFT	29
+#define MLXSW_SP1_PTP_CLOCK_FREQ_KHZ		156257 /* 6.4nSec */
+#define MLXSW_SP1_PTP_CLOCK_MASK		64
+
+struct mlxsw_sp_ptp_clock {
+	struct mlxsw_core *core;
+	spinlock_t lock; /* protect this structure */
+	struct cyclecounter cycles;
+	struct timecounter tc;
+	u32 nominal_c_mult;
+	struct ptp_clock *ptp;
+	struct ptp_clock_info ptp_info;
+	unsigned long overflow_period;
+	struct delayed_work overflow_work;
+};
+
+static u64 __mlxsw_sp1_ptp_read_frc(struct mlxsw_sp_ptp_clock *clock,
+				    struct ptp_system_timestamp *sts)
+{
+	struct mlxsw_core *mlxsw_core = clock->core;
+	u32 frc_h1, frc_h2, frc_l;
+
+	frc_h1 = mlxsw_core_read_frc_h(mlxsw_core);
+	ptp_read_system_prets(sts);
+	frc_l = mlxsw_core_read_frc_l(mlxsw_core);
+	ptp_read_system_postts(sts);
+	frc_h2 = mlxsw_core_read_frc_h(mlxsw_core);
+
+	if (frc_h1 != frc_h2) {
+		/* wrap around */
+		ptp_read_system_prets(sts);
+		frc_l = mlxsw_core_read_frc_l(mlxsw_core);
+		ptp_read_system_postts(sts);
+	}
+
+	return (u64) frc_l | (u64) frc_h2 << 32;
+}
+
+static u64 mlxsw_sp1_ptp_read_frc(const struct cyclecounter *cc)
+{
+	struct mlxsw_sp_ptp_clock *clock =
+		container_of(cc, struct mlxsw_sp_ptp_clock, cycles);
+
+	return __mlxsw_sp1_ptp_read_frc(clock, NULL) & cc->mask;
+}
+
+static int
+mlxsw_sp1_ptp_phc_adjfreq(struct mlxsw_sp_ptp_clock *clock, int freq_adj)
+{
+	struct mlxsw_core *mlxsw_core = clock->core;
+	char mtutc_pl[MLXSW_REG_MTUTC_LEN];
+
+	mlxsw_reg_mtutc_pack(mtutc_pl, MLXSW_REG_MTUTC_OPERATION_ADJUST_FREQ,
+			     freq_adj, 0);
+	return mlxsw_reg_write(mlxsw_core, MLXSW_REG(mtutc), mtutc_pl);
+}
+
+static u64 mlxsw_sp1_ptp_ns2cycles(const struct timecounter *tc, u64 nsec)
+{
+	u64 cycles = (u64) nsec;
+
+	cycles <<= tc->cc->shift;
+	cycles = div_u64(cycles, tc->cc->mult);
+
+	return cycles;
+}
+
+static int
+mlxsw_sp1_ptp_phc_settime(struct mlxsw_sp_ptp_clock *clock, u64 nsec)
+{
+	struct mlxsw_core *mlxsw_core = clock->core;
+	char mtutc_pl[MLXSW_REG_MTUTC_LEN];
+	char mtpps_pl[MLXSW_REG_MTPPS_LEN];
+	u64 next_sec_in_nsec, cycles;
+	u32 next_sec;
+	int err;
+
+	next_sec = nsec / NSEC_PER_SEC + 1;
+	next_sec_in_nsec = next_sec * NSEC_PER_SEC;
+
+	spin_lock(&clock->lock);
+	cycles = mlxsw_sp1_ptp_ns2cycles(&clock->tc, next_sec_in_nsec);
+	spin_unlock(&clock->lock);
+
+	mlxsw_reg_mtpps_vpin_pack(mtpps_pl, cycles);
+	err = mlxsw_reg_write(mlxsw_core, MLXSW_REG(mtpps), mtpps_pl);
+	if (err)
+		return err;
+
+	mlxsw_reg_mtutc_pack(mtutc_pl,
+			     MLXSW_REG_MTUTC_OPERATION_SET_TIME_AT_NEXT_SEC,
+			     0, next_sec);
+	return mlxsw_reg_write(mlxsw_core, MLXSW_REG(mtutc), mtutc_pl);
+}
+
+static int mlxsw_sp1_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
+{
+	struct mlxsw_sp_ptp_clock *clock =
+		container_of(ptp, struct mlxsw_sp_ptp_clock, ptp_info);
+	int neg_adj = 0;
+	u32 diff;
+	u64 adj;
+	s32 ppb;
+
+	ppb = scaled_ppm_to_ppb(scaled_ppm);
+
+	if (ppb < 0) {
+		neg_adj = 1;
+		ppb = -ppb;
+	}
+
+	adj = clock->nominal_c_mult;
+	adj *= ppb;
+	diff = div_u64(adj, NSEC_PER_SEC);
+
+	spin_lock(&clock->lock);
+	timecounter_read(&clock->tc);
+	clock->cycles.mult = neg_adj ? clock->nominal_c_mult - diff :
+				       clock->nominal_c_mult + diff;
+	spin_unlock(&clock->lock);
+
+	return mlxsw_sp1_ptp_phc_adjfreq(clock, neg_adj ? -ppb : ppb);
+}
+
+static int mlxsw_sp1_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
+{
+	struct mlxsw_sp_ptp_clock *clock =
+		container_of(ptp, struct mlxsw_sp_ptp_clock, ptp_info);
+	u64 nsec;
+
+	spin_lock(&clock->lock);
+	timecounter_adjtime(&clock->tc, delta);
+	nsec = timecounter_read(&clock->tc);
+	spin_unlock(&clock->lock);
+
+	return mlxsw_sp1_ptp_phc_settime(clock, nsec);
+}
+
+static int mlxsw_sp1_ptp_gettimex(struct ptp_clock_info *ptp,
+				  struct timespec64 *ts,
+				  struct ptp_system_timestamp *sts)
+{
+	struct mlxsw_sp_ptp_clock *clock =
+		container_of(ptp, struct mlxsw_sp_ptp_clock, ptp_info);
+	u64 cycles, nsec;
+
+	spin_lock(&clock->lock);
+	cycles = __mlxsw_sp1_ptp_read_frc(clock, sts);
+	nsec = timecounter_cyc2time(&clock->tc, cycles);
+	spin_unlock(&clock->lock);
+
+	*ts = ns_to_timespec64(nsec);
+
+	return 0;
+}
+
+static int mlxsw_sp1_ptp_settime(struct ptp_clock_info *ptp,
+				 const struct timespec64 *ts)
+{
+	struct mlxsw_sp_ptp_clock *clock =
+		container_of(ptp, struct mlxsw_sp_ptp_clock, ptp_info);
+	u64 nsec = timespec64_to_ns(ts);
+
+	spin_lock(&clock->lock);
+	timecounter_init(&clock->tc, &clock->cycles, nsec);
+	nsec = timecounter_read(&clock->tc);
+	spin_unlock(&clock->lock);
+
+	return mlxsw_sp1_ptp_phc_settime(clock, nsec);
+}
+
+static const struct ptp_clock_info mlxsw_sp1_ptp_clock_info = {
+	.owner		= THIS_MODULE,
+	.name		= "mlxsw_sp_clock",
+	.max_adj	= 100000000,
+	.adjfine	= mlxsw_sp1_ptp_adjfine,
+	.adjtime	= mlxsw_sp1_ptp_adjtime,
+	.gettimex64	= mlxsw_sp1_ptp_gettimex,
+	.settime64	= mlxsw_sp1_ptp_settime,
+};
+
+static void mlxsw_sp1_ptp_clock_overflow(struct work_struct *work)
+{
+	struct delayed_work *dwork = to_delayed_work(work);
+	struct mlxsw_sp_ptp_clock *clock;
+
+	clock = container_of(dwork, struct mlxsw_sp_ptp_clock, overflow_work);
+
+	spin_lock(&clock->lock);
+	timecounter_read(&clock->tc);
+	spin_unlock(&clock->lock);
+	mlxsw_core_schedule_dw(&clock->overflow_work, clock->overflow_period);
+}
+
+struct mlxsw_sp_ptp_clock *
+mlxsw_sp1_ptp_clock_init(struct mlxsw_sp *mlxsw_sp, struct device *dev)
+{
+	u64 overflow_cycles, nsec, frac = 0;
+	struct mlxsw_sp_ptp_clock *clock;
+	int err;
+
+	clock = kzalloc(sizeof(*clock), GFP_KERNEL);
+	if (!clock)
+		return ERR_PTR(-ENOMEM);
+
+	spin_lock_init(&clock->lock);
+	clock->cycles.read = mlxsw_sp1_ptp_read_frc;
+	clock->cycles.shift = MLXSW_SP1_PTP_CLOCK_CYCLES_SHIFT;
+	clock->cycles.mult = clocksource_khz2mult(MLXSW_SP1_PTP_CLOCK_FREQ_KHZ,
+						  clock->cycles.shift);
+	clock->nominal_c_mult = clock->cycles.mult;
+	clock->cycles.mask = CLOCKSOURCE_MASK(MLXSW_SP1_PTP_CLOCK_MASK);
+	clock->core = mlxsw_sp->core;
+
+	timecounter_init(&clock->tc, &clock->cycles,
+			 ktime_to_ns(ktime_get_real()));
+
+	/* Calculate period in seconds to call the overflow watchdog - to make
+	 * sure counter is checked at least twice every wrap around.
+	 * The period is calculated as the minimum between max HW cycles count
+	 * (The clock source mask) and max amount of cycles that can be
+	 * multiplied by clock multiplier where the result doesn't exceed
+	 * 64bits.
+	 */
+	overflow_cycles = div64_u64(~0ULL >> 1, clock->cycles.mult);
+	overflow_cycles = min(overflow_cycles, div_u64(clock->cycles.mask, 3));
+
+	nsec = cyclecounter_cyc2ns(&clock->cycles, overflow_cycles, 0, &frac);
+	clock->overflow_period = nsecs_to_jiffies(nsec);
+
+	INIT_DELAYED_WORK(&clock->overflow_work, mlxsw_sp1_ptp_clock_overflow);
+	mlxsw_core_schedule_dw(&clock->overflow_work, 0);
+
+	clock->ptp_info = mlxsw_sp1_ptp_clock_info;
+	clock->ptp = ptp_clock_register(&clock->ptp_info, dev);
+	if (IS_ERR(clock->ptp)) {
+		err = PTR_ERR(clock->ptp);
+		dev_err(dev, "ptp_clock_register failed %d\n", err);
+		goto err_ptp_clock_register;
+	}
+
+	return clock;
+
+err_ptp_clock_register:
+	cancel_delayed_work_sync(&clock->overflow_work);
+	kfree(clock);
+	return ERR_PTR(err);
+}
+
+void mlxsw_sp1_ptp_clock_fini(struct mlxsw_sp_ptp_clock *clock)
+{
+	ptp_clock_unregister(clock->ptp);
+	cancel_delayed_work_sync(&clock->overflow_work);
+	kfree(clock);
+}
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h
new file mode 100644
index 000000000000..76fa00a4be75
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h
@@ -0,0 +1,44 @@
+/* SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0 */
+/* Copyright (c) 2019 Mellanox Technologies. All rights reserved */
+
+#ifndef _MLXSW_SPECTRUM_PTP_H
+#define _MLXSW_SPECTRUM_PTP_H
+
+#include <linux/device.h>
+
+#include "spectrum.h"
+
+struct mlxsw_sp_ptp_clock;
+
+#if IS_REACHABLE(CONFIG_PTP_1588_CLOCK)
+
+struct mlxsw_sp_ptp_clock *
+mlxsw_sp1_ptp_clock_init(struct mlxsw_sp *mlxsw_sp, struct device *dev);
+
+void mlxsw_sp1_ptp_clock_fini(struct mlxsw_sp_ptp_clock *clock);
+
+#else
+
+static inline struct mlxsw_sp_ptp_clock *
+mlxsw_sp1_ptp_clock_init(struct mlxsw_sp *mlxsw_sp, struct device *dev)
+{
+	return NULL;
+}
+
+static inline void mlxsw_sp1_ptp_clock_fini(struct mlxsw_sp_ptp_clock *clock)
+{
+}
+
+#endif
+
+static inline struct mlxsw_sp_ptp_clock *
+mlxsw_sp2_ptp_clock_init(struct mlxsw_sp *mlxsw_sp, struct device *dev)
+{
+	return NULL;
+}
+
+static inline void mlxsw_sp2_ptp_clock_fini(struct mlxsw_sp_ptp_clock *clock)
+{
+}
+
+#endif
-- 
2.20.1

