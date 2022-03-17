Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA954DC430
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 11:44:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232699AbiCQKpA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 06:45:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232675AbiCQKo5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 06:44:57 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42B191DEC36;
        Thu, 17 Mar 2022 03:43:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1647513815; x=1679049815;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FLCIXkIQjq98zexzlVC7iTcxXTGbEUj86VVCms2xe78=;
  b=iupHe/uSEI8VIlaB1QAVH2ncyTekOqaU5U2KZsCoM2blSCtLVxUq5r0Y
   u0XkP2M3EY9tSFQZ/Wm0Q8FMCpzbkjCOd+j71ASY7bAXxcrz7X2CAVpC9
   63okBASbe1vGkOHKu3/hh3LqIoqmrQjJvPtKyXDP9IAwkYsxUVyaR8Rem
   bjSv6InE4pXvhbwApgRrmoMHXAw0l0B7qOoF3iOYRvzBr6zigvZ3liW8P
   1iclxh4o93I7DAHrCO01gjP4xMWr8pONdb/N5I4/nmb63yb1kGr0KBsK+
   LuQBeFHrJcjN2C/FugBwleq9El7inJhLRyowPLamvznwUc9E3sC4U5IaQ
   g==;
X-IronPort-AV: E=Sophos;i="5.90,188,1643698800"; 
   d="scan'208";a="152326648"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Mar 2022 03:43:34 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 17 Mar 2022 03:43:34 -0700
Received: from localhost.localdomain (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Thu, 17 Mar 2022 03:43:31 -0700
From:   Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <bryan.whitehead@microchip.com>,
        <richardcochran@gmail.com>, <UNGLinuxDriver@microchip.com>,
        <Ian.Saturley@microchip.com>
Subject: [PATCH net-next V1 5/5] net: lan743x: Add support for PTP-IO Event Output (Periodic Output)
Date:   Thu, 17 Mar 2022 16:13:10 +0530
Message-ID: <20220317104310.61091-6-Raju.Lakkaraju@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220317104310.61091-1-Raju.Lakkaraju@microchip.com>
References: <20220317104310.61091-1-Raju.Lakkaraju@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for PTP-IO Event Output (Periodic Output - perout) for
PCI11010/PCI11414 chips

Signed-off-by: Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
---
Change List:                                                                    
V0 -> V1:                                                                       
 1. Fix the checkpatch warnings

 drivers/net/ethernet/microchip/lan743x_main.h |  33 +++
 drivers/net/ethernet/microchip/lan743x_ptp.c  | 218 +++++++++++++++++-
 drivers/net/ethernet/microchip/lan743x_ptp.h  |   1 +
 3 files changed, 250 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.h b/drivers/net/ethernet/microchip/lan743x_main.h
index 9c528705866f..1ca5f3216403 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.h
+++ b/drivers/net/ethernet/microchip/lan743x_main.h
@@ -336,6 +336,7 @@
 #define INT_MOD_CFG9			(0x7E4)
 
 #define PTP_CMD_CTL					(0x0A00)
+#define PTP_CMD_CTL_PTP_LTC_TARGET_READ_		BIT(13)
 #define PTP_CMD_CTL_PTP_CLK_STP_NSEC_			BIT(6)
 #define PTP_CMD_CTL_PTP_CLOCK_STEP_SEC_			BIT(5)
 #define PTP_CMD_CTL_PTP_CLOCK_LOAD_			BIT(4)
@@ -357,6 +358,30 @@
 	(((value) & 0x7) << (1 + ((channel) << 2)))
 #define PTP_GENERAL_CONFIG_RELOAD_ADD_X_(channel)	(BIT((channel) << 2))
 
+#define HS_PTP_GENERAL_CONFIG				(0x0A04)
+#define HS_PTP_GENERAL_CONFIG_CLOCK_EVENT_X_MASK_(channel) \
+	(0xf << (4 + ((channel) << 2)))
+#define HS_PTP_GENERAL_CONFIG_CLOCK_EVENT_100NS_	(0)
+#define HS_PTP_GENERAL_CONFIG_CLOCK_EVENT_500NS_	(1)
+#define HS_PTP_GENERAL_CONFIG_CLOCK_EVENT_1US_		(2)
+#define HS_PTP_GENERAL_CONFIG_CLOCK_EVENT_5US_		(3)
+#define HS_PTP_GENERAL_CONFIG_CLOCK_EVENT_10US_		(4)
+#define HS_PTP_GENERAL_CONFIG_CLOCK_EVENT_50US_		(5)
+#define HS_PTP_GENERAL_CONFIG_CLOCK_EVENT_100US_	(6)
+#define HS_PTP_GENERAL_CONFIG_CLOCK_EVENT_500US_	(7)
+#define HS_PTP_GENERAL_CONFIG_CLOCK_EVENT_1MS_		(8)
+#define HS_PTP_GENERAL_CONFIG_CLOCK_EVENT_5MS_		(9)
+#define HS_PTP_GENERAL_CONFIG_CLOCK_EVENT_10MS_		(10)
+#define HS_PTP_GENERAL_CONFIG_CLOCK_EVENT_50MS_		(11)
+#define HS_PTP_GENERAL_CONFIG_CLOCK_EVENT_100MS_	(12)
+#define HS_PTP_GENERAL_CONFIG_CLOCK_EVENT_200MS_	(13)
+#define HS_PTP_GENERAL_CONFIG_CLOCK_EVENT_TOGG_		(14)
+#define HS_PTP_GENERAL_CONFIG_CLOCK_EVENT_INT_		(15)
+#define HS_PTP_GENERAL_CONFIG_CLOCK_EVENT_X_SET_(channel, value) \
+	(((value) & 0xf) << (4 + ((channel) << 2)))
+#define HS_PTP_GENERAL_CONFIG_EVENT_POL_X_(channel)	(BIT(1 + ((channel) * 2)))
+#define HS_PTP_GENERAL_CONFIG_RELOAD_ADD_X_(channel)	(BIT((channel) * 2))
+
 #define PTP_INT_STS				(0x0A08)
 #define PTP_INT_IO_FE_MASK_			GENMASK(31, 24)
 #define PTP_INT_IO_FE_SHIFT_			(24)
@@ -364,9 +389,17 @@
 #define PTP_INT_IO_RE_MASK_			GENMASK(23, 16)
 #define PTP_INT_IO_RE_SHIFT_			(16)
 #define PTP_INT_IO_RE_SET_(channel)		BIT(16 + (channel))
+#define PTP_INT_TX_TS_OVRFL_INT_		BIT(14)
+#define PTP_INT_TX_SWTS_ERR_INT_		BIT(13)
+#define PTP_INT_TX_TS_INT_			BIT(12)
+#define PTP_INT_RX_TS_OVRFL_INT_		BIT(9)
+#define PTP_INT_RX_TS_INT_			BIT(8)
+#define PTP_INT_TIMER_INT_B_			BIT(1)
+#define PTP_INT_TIMER_INT_A_			BIT(0)
 #define PTP_INT_EN_SET				(0x0A0C)
 #define PTP_INT_EN_FE_EN_SET_(channel)		BIT(24 + (channel))
 #define PTP_INT_EN_RE_EN_SET_(channel)		BIT(16 + (channel))
+#define PTP_INT_EN_TIMER_SET_(channel)		BIT(channel)
 #define PTP_INT_EN_CLR				(0x0A10)
 #define PTP_INT_EN_FE_EN_CLR_(channel)		BIT(24 + (channel))
 #define PTP_INT_EN_RE_EN_CLR_(channel)		BIT(16 + (channel))
diff --git a/drivers/net/ethernet/microchip/lan743x_ptp.c b/drivers/net/ethernet/microchip/lan743x_ptp.c
index 470d9050df0c..6a11e2ceb013 100644
--- a/drivers/net/ethernet/microchip/lan743x_ptp.c
+++ b/drivers/net/ethernet/microchip/lan743x_ptp.c
@@ -689,6 +689,215 @@ static int lan743x_ptp_perout(struct lan743x_adapter *adapter, int on,
 	return ret;
 }
 
+static void lan743x_ptp_io_perout_off(struct lan743x_adapter *adapter,
+				      u32 index)
+{
+	struct lan743x_ptp *ptp = &adapter->ptp;
+	int perout_pin;
+	int event_ch;
+	u32 gen_cfg;
+	int val;
+
+	event_ch = ptp->ptp_io_perout[index];
+	if (event_ch >= 0) {
+		/* set target to far in the future, effectively disabling it */
+		lan743x_csr_write(adapter,
+				  PTP_CLOCK_TARGET_SEC_X(event_ch),
+				  0xFFFF0000);
+		lan743x_csr_write(adapter,
+				  PTP_CLOCK_TARGET_NS_X(event_ch),
+				  0);
+
+		gen_cfg = lan743x_csr_read(adapter, HS_PTP_GENERAL_CONFIG);
+		gen_cfg &= ~(HS_PTP_GENERAL_CONFIG_CLOCK_EVENT_X_MASK_
+				    (event_ch));
+		gen_cfg &= ~(HS_PTP_GENERAL_CONFIG_EVENT_POL_X_(event_ch));
+		gen_cfg |= HS_PTP_GENERAL_CONFIG_RELOAD_ADD_X_(event_ch);
+		lan743x_csr_write(adapter, HS_PTP_GENERAL_CONFIG, gen_cfg);
+		if (event_ch)
+			lan743x_csr_write(adapter, PTP_INT_STS,
+					  PTP_INT_TIMER_INT_B_);
+		else
+			lan743x_csr_write(adapter, PTP_INT_STS,
+					  PTP_INT_TIMER_INT_A_);
+		lan743x_ptp_release_event_ch(adapter, event_ch);
+		ptp->ptp_io_perout[index] = -1;
+	}
+
+	perout_pin = ptp_find_pin(ptp->ptp_clock, PTP_PF_PEROUT, index);
+
+	/* Deselect Event output */
+	val = lan743x_csr_read(adapter, PTP_IO_EVENT_OUTPUT_CFG);
+
+	/* Disables the output of Local Time Target compare events */
+	val &= ~PTP_IO_EVENT_OUTPUT_CFG_EN_(perout_pin);
+	lan743x_csr_write(adapter, PTP_IO_EVENT_OUTPUT_CFG, val);
+
+	/* Configured as an opendrain driver*/
+	val = lan743x_csr_read(adapter, PTP_IO_PIN_CFG);
+	val &= ~PTP_IO_PIN_CFG_OBUF_TYPE_(perout_pin);
+	lan743x_csr_write(adapter, PTP_IO_PIN_CFG, val);
+	/* Dummy read to make sure write operation success */
+	val = lan743x_csr_read(adapter, PTP_IO_PIN_CFG);
+}
+
+static int lan743x_ptp_io_perout(struct lan743x_adapter *adapter, int on,
+				 struct ptp_perout_request *perout_request)
+{
+	struct lan743x_ptp *ptp = &adapter->ptp;
+	u32 period_sec, period_nsec;
+	u32 start_sec, start_nsec;
+	u32 pulse_sec, pulse_nsec;
+	int pulse_width;
+	int perout_pin;
+	int event_ch;
+	u32 gen_cfg;
+	u32 index;
+	int val;
+
+	index = perout_request->index;
+	event_ch = ptp->ptp_io_perout[index];
+
+	if (on) {
+		perout_pin = ptp_find_pin(ptp->ptp_clock, PTP_PF_PEROUT, index);
+		if (perout_pin < 0)
+			return -EBUSY;
+	} else {
+		lan743x_ptp_io_perout_off(adapter, index);
+		return 0;
+	}
+
+	if (event_ch >= LAN743X_PTP_N_EVENT_CHAN) {
+		/* already on, turn off first */
+		lan743x_ptp_io_perout_off(adapter, index);
+	}
+
+	event_ch = lan743x_ptp_reserve_event_ch(adapter, index);
+	if (event_ch < 0) {
+		netif_warn(adapter, drv, adapter->netdev,
+			   "Failed to reserve event channel %d for PEROUT\n",
+			   index);
+		goto failed;
+	}
+	ptp->ptp_io_perout[index] = event_ch;
+
+	if (perout_request->flags & PTP_PEROUT_DUTY_CYCLE) {
+		pulse_sec = perout_request->on.sec;
+		pulse_sec += perout_request->on.nsec / 1000000000;
+		pulse_nsec = perout_request->on.nsec % 1000000000;
+	} else {
+		pulse_sec = perout_request->period.sec;
+		pulse_sec += perout_request->period.nsec / 1000000000;
+		pulse_nsec = perout_request->period.nsec % 1000000000;
+	}
+
+	if (pulse_sec == 0) {
+		if (pulse_nsec >= 400000000) {
+			pulse_width = PTP_GENERAL_CONFIG_CLOCK_EVENT_200MS_;
+		} else if (pulse_nsec >= 200000000) {
+			pulse_width = HS_PTP_GENERAL_CONFIG_CLOCK_EVENT_100MS_;
+		} else if (pulse_nsec >= 100000000) {
+			pulse_width = HS_PTP_GENERAL_CONFIG_CLOCK_EVENT_50MS_;
+		} else if (pulse_nsec >= 20000000) {
+			pulse_width = HS_PTP_GENERAL_CONFIG_CLOCK_EVENT_10MS_;
+		} else if (pulse_nsec >= 10000000) {
+			pulse_width = HS_PTP_GENERAL_CONFIG_CLOCK_EVENT_5MS_;
+		} else if (pulse_nsec >= 2000000) {
+			pulse_width = HS_PTP_GENERAL_CONFIG_CLOCK_EVENT_1MS_;
+		} else if (pulse_nsec >= 1000000) {
+			pulse_width = HS_PTP_GENERAL_CONFIG_CLOCK_EVENT_500US_;
+		} else if (pulse_nsec >= 200000) {
+			pulse_width = HS_PTP_GENERAL_CONFIG_CLOCK_EVENT_100US_;
+		} else if (pulse_nsec >= 100000) {
+			pulse_width = HS_PTP_GENERAL_CONFIG_CLOCK_EVENT_50US_;
+		} else if (pulse_nsec >= 20000) {
+			pulse_width = HS_PTP_GENERAL_CONFIG_CLOCK_EVENT_10US_;
+		} else if (pulse_nsec >= 10000) {
+			pulse_width = HS_PTP_GENERAL_CONFIG_CLOCK_EVENT_5US_;
+		} else if (pulse_nsec >= 2000) {
+			pulse_width = HS_PTP_GENERAL_CONFIG_CLOCK_EVENT_1US_;
+		} else if (pulse_nsec >= 1000) {
+			pulse_width = HS_PTP_GENERAL_CONFIG_CLOCK_EVENT_500NS_;
+		} else if (pulse_nsec >= 200) {
+			pulse_width = HS_PTP_GENERAL_CONFIG_CLOCK_EVENT_100NS_;
+		} else {
+			netif_warn(adapter, drv, adapter->netdev,
+				   "perout period too small, min is 200nS\n");
+			goto failed;
+		}
+	} else {
+		pulse_width = HS_PTP_GENERAL_CONFIG_CLOCK_EVENT_200MS_;
+	}
+
+	/* turn off by setting target far in future */
+	lan743x_csr_write(adapter,
+			  PTP_CLOCK_TARGET_SEC_X(event_ch),
+			  0xFFFF0000);
+	lan743x_csr_write(adapter,
+			  PTP_CLOCK_TARGET_NS_X(event_ch), 0);
+
+	/* Configure to pulse every period */
+	gen_cfg = lan743x_csr_read(adapter, HS_PTP_GENERAL_CONFIG);
+	gen_cfg &= ~(HS_PTP_GENERAL_CONFIG_CLOCK_EVENT_X_MASK_(event_ch));
+	gen_cfg |= HS_PTP_GENERAL_CONFIG_CLOCK_EVENT_X_SET_
+			  (event_ch, pulse_width);
+	gen_cfg |= HS_PTP_GENERAL_CONFIG_EVENT_POL_X_(event_ch);
+	gen_cfg &= ~(HS_PTP_GENERAL_CONFIG_RELOAD_ADD_X_(event_ch));
+	lan743x_csr_write(adapter, HS_PTP_GENERAL_CONFIG, gen_cfg);
+
+	/* set the reload to one toggle cycle */
+	period_sec = perout_request->period.sec;
+	period_sec += perout_request->period.nsec / 1000000000;
+	period_nsec = perout_request->period.nsec % 1000000000;
+	lan743x_csr_write(adapter,
+			  PTP_CLOCK_TARGET_RELOAD_SEC_X(event_ch),
+			  period_sec);
+	lan743x_csr_write(adapter,
+			  PTP_CLOCK_TARGET_RELOAD_NS_X(event_ch),
+			  period_nsec);
+
+	start_sec = perout_request->start.sec;
+	start_sec += perout_request->start.nsec / 1000000000;
+	start_nsec = perout_request->start.nsec % 1000000000;
+
+	/* set the start time */
+	lan743x_csr_write(adapter,
+			  PTP_CLOCK_TARGET_SEC_X(event_ch),
+			  start_sec);
+	lan743x_csr_write(adapter,
+			  PTP_CLOCK_TARGET_NS_X(event_ch),
+			  start_nsec);
+
+	/* Enable LTC Target Read */
+	val = lan743x_csr_read(adapter, PTP_CMD_CTL);
+	val |= PTP_CMD_CTL_PTP_LTC_TARGET_READ_;
+	lan743x_csr_write(adapter, PTP_CMD_CTL, val);
+
+	/* Configure as an push/pull driver */
+	val = lan743x_csr_read(adapter, PTP_IO_PIN_CFG);
+	val |= PTP_IO_PIN_CFG_OBUF_TYPE_(perout_pin);
+	lan743x_csr_write(adapter, PTP_IO_PIN_CFG, val);
+
+	/* Select Event output */
+	val = lan743x_csr_read(adapter, PTP_IO_EVENT_OUTPUT_CFG);
+	if (event_ch)
+		/* Channel B as the output */
+		val |= PTP_IO_EVENT_OUTPUT_CFG_SEL_(perout_pin);
+	else
+		/* Channel A as the output */
+		val &= ~PTP_IO_EVENT_OUTPUT_CFG_SEL_(perout_pin);
+
+	/* Enables the output of Local Time Target compare events */
+	val |= PTP_IO_EVENT_OUTPUT_CFG_EN_(perout_pin);
+	lan743x_csr_write(adapter, PTP_IO_EVENT_OUTPUT_CFG, val);
+
+	return 0;
+
+failed:
+	lan743x_ptp_io_perout_off(adapter, index);
+	return -ENODEV;
+}
+
 static void lan743x_ptp_io_extts_off(struct lan743x_adapter *adapter,
 				     u32 index)
 {
@@ -812,9 +1021,14 @@ static int lan743x_ptpci_enable(struct ptp_clock_info *ptpci,
 							 &request->extts);
 			return -EINVAL;
 		case PTP_CLK_REQ_PEROUT:
-			if (request->perout.index < ptpci->n_per_out)
-				return lan743x_ptp_perout(adapter, on,
+			if (request->perout.index < ptpci->n_per_out) {
+				if (adapter->is_pci11x1x)
+					return lan743x_ptp_io_perout(adapter, on,
+							     &request->perout);
+				else
+					return lan743x_ptp_perout(adapter, on,
 							  &request->perout);
+			}
 			return -EINVAL;
 		case PTP_CLK_REQ_PPS:
 			return -EINVAL;
diff --git a/drivers/net/ethernet/microchip/lan743x_ptp.h b/drivers/net/ethernet/microchip/lan743x_ptp.h
index 96d3a134e788..e26d4eff7133 100644
--- a/drivers/net/ethernet/microchip/lan743x_ptp.h
+++ b/drivers/net/ethernet/microchip/lan743x_ptp.h
@@ -80,6 +80,7 @@ struct lan743x_ptp {
 
 	unsigned long used_event_ch;
 	struct lan743x_ptp_perout perout[LAN743X_PTP_N_PEROUT];
+	int ptp_io_perout[LAN743X_PTP_N_PEROUT]; /* PTP event channel (0=channel A, 1=channel B) */
 	struct lan743x_extts extts[LAN743X_PTP_N_EXTTS];
 
 	bool leds_multiplexed;
-- 
2.25.1

