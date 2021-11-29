Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 788C4461678
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 14:32:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343919AbhK2Nfk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 08:35:40 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:56000 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234675AbhK2Ndh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 08:33:37 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1ATBwiGV010651;
        Mon, 29 Nov 2021 05:30:18 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=NJGJcLlMLOdHQjNCc7Jf6z50tHzG/BSmq+edBx7FHDc=;
 b=NZkp6lXnT1FjxqtGtewW5uqRXad7X/MqPfr26Foc054K0hJarCzXX2uAxnLRazAolNys
 XX7h8HX+EFMmHAKUAWKxi+3DmbS3eb+s1zGFTZ3R8/V8MYtvwBp7m6pGiK0K/tPVcLv0
 22gX+tnuqVXDzJWEZ0wHoqg/ejxwelDKIJF5UfZIcE1Bmw/xH7sxGsNjtRh0pZFbpkAT
 Xbo4XY7atg9S4QSlMiYcLkz80skY11ZdAoeeuRIPNeXOnDBpaoORHQ4RteeCSreheRWh
 9Ly3753CxpTecx/kBQuh002wD1EWvNkeZlvkMIwn4I1iESF+DCWkrvC6c0igxMAshk9U 2A== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3cmgkptk0j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 29 Nov 2021 05:30:18 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 29 Nov
 2021 05:30:17 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 29 Nov 2021 05:30:17 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 389183F70D6;
        Mon, 29 Nov 2021 05:30:17 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 1ATDUHpj016164;
        Mon, 29 Nov 2021 05:30:17 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 1ATDUH2R016163;
        Mon, 29 Nov 2021 05:30:17 -0800
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <irusskikh@marvell.com>,
        <dbezrukov@marvell.com>, Nikita Danilov <ndanilov@aquantia.com>
Subject: [PATCH net 4/7] atlantic: Add missing DIDs and fix 115c.
Date:   Mon, 29 Nov 2021 05:28:26 -0800
Message-ID: <20211129132829.16038-5-skalluru@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20211129132829.16038-1-skalluru@marvell.com>
References: <20211129132829.16038-1-skalluru@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 4AGA1x8cmIKEMUfuB1f3SkS_6Hr6f4gr
X-Proofpoint-GUID: 4AGA1x8cmIKEMUfuB1f3SkS_6Hr6f4gr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-29_08,2021-11-28_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikita Danilov <ndanilov@aquantia.com>

At the late production stages new dev ids were introduced. These are
now in production, so its important for the driver to recognize these.
And also fix the board caps for AQC115C adapter.

Fixes: b3f0c79cba206 ("net: atlantic: A2 hw_ops skeleton")
Signed-off-by: Nikita Danilov <ndanilov@aquantia.com>
Signed-off-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 .../net/ethernet/aquantia/atlantic/aq_common.h  |  2 ++
 .../ethernet/aquantia/atlantic/aq_pci_func.c    |  7 ++++++-
 .../aquantia/atlantic/hw_atl2/hw_atl2.c         | 17 +++++++++++++++++
 .../aquantia/atlantic/hw_atl2/hw_atl2.h         |  2 ++
 4 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_common.h b/drivers/net/ethernet/aquantia/atlantic/aq_common.h
index 4ad8f36fcade..ace691d7cd75 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_common.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_common.h
@@ -40,10 +40,12 @@
 
 #define AQ_DEVICE_ID_AQC113DEV	0x00C0
 #define AQ_DEVICE_ID_AQC113CS	0x94C0
+#define AQ_DEVICE_ID_AQC113CA	0x34C0
 #define AQ_DEVICE_ID_AQC114CS	0x93C0
 #define AQ_DEVICE_ID_AQC113	0x04C0
 #define AQ_DEVICE_ID_AQC113C	0x14C0
 #define AQ_DEVICE_ID_AQC115C	0x12C0
+#define AQ_DEVICE_ID_AQC116C	0x11C0
 
 #define HW_ATL_NIC_NAME "Marvell (aQuantia) AQtion 10Gbit Network Adapter"
 
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c b/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
index d4b1976ee69b..797a95142d1f 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
@@ -49,6 +49,8 @@ static const struct pci_device_id aq_pci_tbl[] = {
 	{ PCI_VDEVICE(AQUANTIA, AQ_DEVICE_ID_AQC113), },
 	{ PCI_VDEVICE(AQUANTIA, AQ_DEVICE_ID_AQC113C), },
 	{ PCI_VDEVICE(AQUANTIA, AQ_DEVICE_ID_AQC115C), },
+	{ PCI_VDEVICE(AQUANTIA, AQ_DEVICE_ID_AQC113CA), },
+	{ PCI_VDEVICE(AQUANTIA, AQ_DEVICE_ID_AQC116C), },
 
 	{}
 };
@@ -85,7 +87,10 @@ static const struct aq_board_revision_s hw_atl_boards[] = {
 	{ AQ_DEVICE_ID_AQC113CS,	AQ_HWREV_ANY,	&hw_atl2_ops, &hw_atl2_caps_aqc113, },
 	{ AQ_DEVICE_ID_AQC114CS,	AQ_HWREV_ANY,	&hw_atl2_ops, &hw_atl2_caps_aqc113, },
 	{ AQ_DEVICE_ID_AQC113C,		AQ_HWREV_ANY,	&hw_atl2_ops, &hw_atl2_caps_aqc113, },
-	{ AQ_DEVICE_ID_AQC115C,		AQ_HWREV_ANY,	&hw_atl2_ops, &hw_atl2_caps_aqc113, },
+	{ AQ_DEVICE_ID_AQC115C,		AQ_HWREV_ANY,	&hw_atl2_ops, &hw_atl2_caps_aqc115c, },
+	{ AQ_DEVICE_ID_AQC113CA,	AQ_HWREV_ANY,	&hw_atl2_ops, &hw_atl2_caps_aqc113, },
+	{ AQ_DEVICE_ID_AQC116C,		AQ_HWREV_ANY,	&hw_atl2_ops, &hw_atl2_caps_aqc116c, },
+
 };
 
 MODULE_DEVICE_TABLE(pci, aq_pci_tbl);
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c
index c98708bb044c..0a28428a0cb7 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c
@@ -72,6 +72,23 @@ const struct aq_hw_caps_s hw_atl2_caps_aqc113 = {
 			  AQ_NIC_RATE_10M_HALF,
 };
 
+const struct aq_hw_caps_s hw_atl2_caps_aqc115c = {
+	DEFAULT_BOARD_BASIC_CAPABILITIES,
+	.media_type = AQ_HW_MEDIA_TYPE_TP,
+	.link_speed_msk = AQ_NIC_RATE_2G5 |
+			  AQ_NIC_RATE_1G  |
+			  AQ_NIC_RATE_100M      |
+			  AQ_NIC_RATE_10M,
+};
+
+const struct aq_hw_caps_s hw_atl2_caps_aqc116c = {
+	DEFAULT_BOARD_BASIC_CAPABILITIES,
+	.media_type = AQ_HW_MEDIA_TYPE_TP,
+	.link_speed_msk = AQ_NIC_RATE_1G  |
+			  AQ_NIC_RATE_100M      |
+			  AQ_NIC_RATE_10M,
+};
+
 static u32 hw_atl2_sem_act_rslvr_get(struct aq_hw_s *self)
 {
 	return hw_atl_reg_glb_cpu_sem_get(self, HW_ATL2_FW_SM_ACT_RSLVR);
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.h b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.h
index de8723f1c28a..346f0dc9912e 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.h
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.h
@@ -9,6 +9,8 @@
 #include "aq_common.h"
 
 extern const struct aq_hw_caps_s hw_atl2_caps_aqc113;
+extern const struct aq_hw_caps_s hw_atl2_caps_aqc115c;
+extern const struct aq_hw_caps_s hw_atl2_caps_aqc116c;
 extern const struct aq_hw_ops hw_atl2_ops;
 
 #endif /* HW_ATL2_H */
-- 
2.27.0

