Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7908715DB4F
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 16:45:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729585AbgBNPpT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 10:45:19 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:37016 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728859AbgBNPpT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 10:45:19 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01EFjDj8006473;
        Fri, 14 Feb 2020 07:45:17 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=b6NStWudufQzV9gAjRCxI7kXhJ6h63qPb8qjUoQ3Zrg=;
 b=GUrO2Py+aXoUbQdxpSYhCjIr8lEBC6jRk3v+AHhK1qIIbCuxtUE2+WfDDh2IkWySv7eG
 dVRTeUI71iPNZsY5nh+Dkry2CVf2KHU9MrXbWl/3sT76f/O4w0Nj5Al2FXEnL7kkpkbX
 iwvBwrHaG+zilaFEPvxcCxH0q2t5diAVBNuoSHiGtunGjBp9GwRDpfjCvd4ICkRWlX37
 ptwNbgijS13HfTxJePs3nTcoucCBb0JGJjLyhD08s2GRtsF/X3GHhOP7ceDQ9LdqfNlI
 EavSPvbAe//AmH6jQRCaM686eGTla78K6lPz3p48TDEYzy94KAQrxvz6L4BN6ScDfFpq Dg== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 2y4j5k3pau-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 14 Feb 2020 07:45:17 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 14 Feb
 2020 07:45:14 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 14 Feb 2020 07:45:15 -0800
Received: from NN-LT0019.rdc.aquantia.com (unknown [10.9.16.63])
        by maili.marvell.com (Postfix) with ESMTP id 31A353F7041;
        Fri, 14 Feb 2020 07:45:12 -0800 (PST)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <dbogdanov@marvell.com>, <pbelous@marvell.com>,
        <ndanilov@marvell.com>, <davem@davemloft.net>,
        Igor Russkikh <irusskikh@marvell.com>,
        Egor Pomozov <epomozov@marvell.com>
Subject: [PATCH net 3/8] net: atlantic: ptp gpio adjustments
Date:   Fri, 14 Feb 2020 18:44:53 +0300
Message-ID: <4fa6fa30f18d66de4892bdd2e1ca63d02c20a619.1580299250.git.irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1580299250.git.irusskikh@marvell.com>
References: <cover.1580299250.git.irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-14_04:2020-02-12,2020-02-14 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Egor Pomozov <epomozov@marvell.com>

Clock adjustment data should be passed to FW as well, otherwise in some
cases a drift was observed when using GPIO features.

Signed-off-by: Egor Pomozov <epomozov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Dmitry Bogdanov <dbogdanov@marvell.com>
---
 drivers/net/ethernet/aquantia/atlantic/aq_hw.h       |  2 ++
 .../ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c    |  4 +++-
 .../aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c     | 12 ++++++++++++
 3 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_hw.h b/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
index cc70c606b6ef..251767c31f7e 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
@@ -337,6 +337,8 @@ struct aq_fw_ops {
 
 	void (*enable_ptp)(struct aq_hw_s *self, int enable);
 
+	void (*adjust_ptp)(struct aq_hw_s *self, uint64_t adj);
+
 	int (*set_eee_rate)(struct aq_hw_s *self, u32 speed);
 
 	int (*get_eee_rate)(struct aq_hw_s *self, u32 *rate,
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
index 5784da26f868..9acdb3fbb750 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
@@ -1162,6 +1162,8 @@ static int hw_atl_b0_adj_sys_clock(struct aq_hw_s *self, s64 delta)
 {
 	self->ptp_clk_offset += delta;
 
+	self->aq_fw_ops->adjust_ptp(self, self->ptp_clk_offset);
+
 	return 0;
 }
 
@@ -1212,7 +1214,7 @@ static int hw_atl_b0_gpio_pulse(struct aq_hw_s *self, u32 index,
 	fwreq.ptp_gpio_ctrl.index = index;
 	fwreq.ptp_gpio_ctrl.period = period;
 	/* Apply time offset */
-	fwreq.ptp_gpio_ctrl.start = start - self->ptp_clk_offset;
+	fwreq.ptp_gpio_ctrl.start = start;
 
 	size = sizeof(fwreq.msg_id) + sizeof(fwreq.ptp_gpio_ctrl);
 	return self->aq_fw_ops->send_fw_request(self, &fwreq, size);
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c
index 97ebf849695f..77a4ed64830f 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c
@@ -30,6 +30,9 @@
 #define HW_ATL_FW3X_EXT_CONTROL_ADDR     0x378
 #define HW_ATL_FW3X_EXT_STATE_ADDR       0x37c
 
+#define HW_ATL_FW3X_PTP_ADJ_LSW_ADDR	 0x50a0
+#define HW_ATL_FW3X_PTP_ADJ_MSW_ADDR	 0x50a4
+
 #define HW_ATL_FW2X_CAP_PAUSE            BIT(CAPS_HI_PAUSE)
 #define HW_ATL_FW2X_CAP_ASYM_PAUSE       BIT(CAPS_HI_ASYMMETRIC_PAUSE)
 #define HW_ATL_FW2X_CAP_SLEEP_PROXY      BIT(CAPS_HI_SLEEP_PROXY)
@@ -475,6 +478,14 @@ static void aq_fw3x_enable_ptp(struct aq_hw_s *self, int enable)
 	aq_hw_write_reg(self, HW_ATL_FW3X_EXT_CONTROL_ADDR, ptp_opts);
 }
 
+static void aq_fw3x_adjust_ptp(struct aq_hw_s *self, uint64_t adj)
+{
+	aq_hw_write_reg(self, HW_ATL_FW3X_PTP_ADJ_LSW_ADDR,
+			(adj >>  0) & 0xffffffff);
+	aq_hw_write_reg(self, HW_ATL_FW3X_PTP_ADJ_MSW_ADDR,
+			(adj >> 32) & 0xffffffff);
+}
+
 static int aq_fw2x_led_control(struct aq_hw_s *self, u32 mode)
 {
 	if (self->fw_ver_actual < HW_ATL_FW_VER_LED)
@@ -633,4 +644,5 @@ const struct aq_fw_ops aq_fw_2x_ops = {
 	.enable_ptp         = aq_fw3x_enable_ptp,
 	.led_control        = aq_fw2x_led_control,
 	.set_phyloopback    = aq_fw2x_set_phyloopback,
+	.adjust_ptp         = aq_fw3x_adjust_ptp,
 };
-- 
2.17.1

