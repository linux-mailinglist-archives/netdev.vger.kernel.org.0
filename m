Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67EFE42914D
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 16:15:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244354AbhJKORO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 10:17:14 -0400
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:28414 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243981AbhJKONb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 10:13:31 -0400
Received: from pps.filterd (m0167089.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19B71jxN027370;
        Mon, 11 Oct 2021 10:11:14 -0400
Received: from nwd2mta3.analog.com ([137.71.173.56])
        by mx0a-00128a01.pphosted.com with ESMTP id 3bm8qfuv7s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Oct 2021 10:11:13 -0400
Received: from SCSQMBX10.ad.analog.com (SCSQMBX10.ad.analog.com [10.77.17.5])
        by nwd2mta3.analog.com (8.14.7/8.14.7) with ESMTP id 19BEBC4n017040
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 11 Oct 2021 10:11:12 -0400
Received: from SCSQCASHYB6.ad.analog.com (10.77.17.132) by
 SCSQMBX10.ad.analog.com (10.77.17.5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.858.5;
 Mon, 11 Oct 2021 07:11:11 -0700
Received: from SCSQMBX11.ad.analog.com (10.77.17.10) by
 SCSQCASHYB6.ad.analog.com (10.77.17.132) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.858.5;
 Mon, 11 Oct 2021 07:11:10 -0700
Received: from zeus.spd.analog.com (10.66.68.11) by scsqmbx11.ad.analog.com
 (10.77.17.10) with Microsoft SMTP Server id 15.2.858.5 via Frontend
 Transport; Mon, 11 Oct 2021 07:11:10 -0700
Received: from localhost.localdomain ([10.48.65.12])
        by zeus.spd.analog.com (8.15.1/8.15.1) with ESMTP id 19BEAxn7020418;
        Mon, 11 Oct 2021 10:11:07 -0400
From:   <alexandru.tachici@analog.com>
To:     <andrew@lunn.ch>
CC:     <o.rempel@pengutronix.de>, <alexandru.tachici@analog.com>,
        <davem@davemloft.net>, <devicetree@vger.kernel.org>,
        <hkallweit1@gmail.com>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux@armlinux.org.uk>,
        <netdev@vger.kernel.org>, <robh+dt@kernel.org>
Subject: [PATCH v3 3/8] net: phy: Add BaseT1 auto-negotiation registers
Date:   Mon, 11 Oct 2021 17:22:10 +0300
Message-ID: <20211011142215.9013-4-alexandru.tachici@analog.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211011142215.9013-1-alexandru.tachici@analog.com>
References: <20211011142215.9013-1-alexandru.tachici@analog.com>
MIME-Version: 1.0
Content-Type: text/plain
X-ADIRuleOP-NewSCL: Rule Triggered
X-Proofpoint-ORIG-GUID: GQ_jAdV7FazQuA6Py0Sqyh0eQYcDJWXL
X-Proofpoint-GUID: GQ_jAdV7FazQuA6Py0Sqyh0eQYcDJWXL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-11_04,2021-10-07_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 adultscore=0 suspectscore=0 impostorscore=0 malwarescore=0 mlxlogscore=564
 lowpriorityscore=0 clxscore=1015 spamscore=0 priorityscore=1501
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110110082
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexandru Tachici <alexandru.tachici@analog.com>

Added BASE-T1 AN advertisement register (Registers 7.514, 7.515, and
7.516) and BASE-T1 AN LP Base Page ability register (Registers 7.517,
7.518, and 7.519).

Signed-off-by: Alexandru Tachici <alexandru.tachici@analog.com>
---
 include/uapi/linux/mdio.h | 40 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/include/uapi/linux/mdio.h b/include/uapi/linux/mdio.h
index 8ae82fe3aece..58ac5cdf7eb4 100644
--- a/include/uapi/linux/mdio.h
+++ b/include/uapi/linux/mdio.h
@@ -67,6 +67,14 @@
 #define MDIO_AN_10GBT_STAT	33	/* 10GBASE-T auto-negotiation status */
 #define MDIO_PMA_10T1L_STAT	2295	/* 10BASE-T1L PMA status */
 #define MDIO_PCS_10T1L_CTRL	2278	/* 10BASE-T1L PCS control */
+#define MDIO_AN_T1_CTRL		512	/* BASE-T1 AN control */
+#define MDIO_AN_T1_STAT		513	/* BASE-T1 AN status */
+#define MDIO_AN_T1_ADV_L	514	/* BASE-T1 AN advertisement register [15:0] */
+#define MDIO_AN_T1_ADV_M	515	/* BASE-T1 AN advertisement register [31:16] */
+#define MDIO_AN_T1_ADV_H	516	/* BASE-T1 AN advertisement register [47:32] */
+#define MDIO_AN_T1_LP_L		517	/* BASE-T1 AN LP's base page register [15:0] */
+#define MDIO_AN_T1_LP_M		518	/* BASE-T1 AN LP's base page register [31:16] */
+#define MDIO_AN_T1_LP_H		519	/* BASE-T1 AN LP's base page register [47:32] */
 
 /* LASI (Link Alarm Status Interrupt) registers, defined by XENPAK MSA. */
 #define MDIO_PMA_LASI_RXCTRL	0x9000	/* RX_ALARM control */
@@ -278,6 +286,38 @@
 #define MDIO_PCS_10T1L_CTRL_LB		0x4000	/* Enable PCS level loopback mode */
 #define MDIO_PCS_10T1L_CTRL_RESET	0x8000	/* PCS reset */
 
+/* BASE-T1 auto-negotiation advertisement register [15:0] */
+#define MDIO_AN_T1_ADV_L_PAUSE_CAP	ADVERTISE_PAUSE_CAP
+#define MDIO_AN_T1_ADV_L_PAUSE_ASYM	ADVERTISE_PAUSE_ASYM
+#define MDIO_AN_T1_ADV_L_FORCE_MS	0x1000	/* Force Master/slave Configuration */
+#define MDIO_AN_T1_ADV_L_REMOTE_FAULT	ADVERTISE_RFAULT
+#define MDIO_AN_T1_ADV_L_ACK		ADVERTISE_LPACK
+#define MDIO_AN_T1_ADV_L_NEXT_PAGE_REQ	ADVERTISE_NPAGE
+
+/* BASE-T1 auto-negotiation advertisement register [31:16] */
+#define MDIO_AN_T1_ADV_M_B10L		0x4000	/* device is compatible with 10BASE-T1L */
+#define MDIO_AN_T1_ADV_M_MST		0x0010	/* advertise master preference */
+
+/* BASE-T1 auto-negotiation advertisement register [47:32] */
+#define MDIO_AN_T1_ADV_H_10L_TX_HI_REQ	0x1000	/* 10BASE-T1L High Level Transmit Request */
+#define MDIO_AN_T1_ADV_H_10L_TX_HI	0x2000	/* 10BASE-T1L High Level Transmit Ability */
+
+/* BASE-T1 AN LP's base page register [15:0] */
+#define MDIO_AN_T1_LP_L_PAUSE_CAP	LPA_PAUSE_CAP
+#define MDIO_AN_T1_LP_L_PAUSE_ASYM	LPA_PAUSE_ASYM
+#define MDIO_AN_T1_LP_L_FORCE_MS	0x1000	/* LP Force Master/slave Configuration */
+#define MDIO_AN_T1_LP_L_REMOTE_FAULT	LPA_RFAULT
+#define MDIO_AN_T1_LP_L_ACK		LPA_LPACK
+#define MDIO_AN_T1_LP_L_NEXT_PAGE_REQ	LPA_NPAGE
+
+/* BASE-T1 AN LP's base page register [31:16] */
+#define MDIO_AN_T1_LP_M_MST		0x0080	/* LP master preference */
+#define MDIO_AN_T1_LP_M_B10L		0x4000	/* LP is compatible with 10BASE-T1L */
+
+/* BASE-T1 AN LP's base page register [47:32] */
+#define MDIO_AN_T1_LP_H_10L_TX_HI_REQ	0x1000	/* 10BASE-T1L High Level LP Transmit Request */
+#define MDIO_AN_T1_LP_H_10L_TX_HI	0x2000	/* 10BASE-T1L High Level LP Transmit Ability */
+
 /* EEE Supported/Advertisement/LP Advertisement registers.
  *
  * EEE capability Register (3.20), Advertisement (7.60) and
-- 
2.25.1

