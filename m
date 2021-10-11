Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D50E3429119
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 16:13:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241868AbhJKOPk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 10:15:40 -0400
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:37556 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244069AbhJKONg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 10:13:36 -0400
Received: from pps.filterd (m0167088.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19BDhHCq015355;
        Mon, 11 Oct 2021 10:11:10 -0400
Received: from nwd2mta3.analog.com ([137.71.173.56])
        by mx0a-00128a01.pphosted.com with ESMTP id 3bm7b1c0k2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Oct 2021 10:11:10 -0400
Received: from SCSQMBX11.ad.analog.com (SCSQMBX11.ad.analog.com [10.77.17.10])
        by nwd2mta3.analog.com (8.14.7/8.14.7) with ESMTP id 19BEB8Em017030
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 11 Oct 2021 10:11:08 -0400
Received: from SCSQMBX11.ad.analog.com (10.77.17.10) by
 SCSQMBX11.ad.analog.com (10.77.17.10) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.858.5;
 Mon, 11 Oct 2021 07:11:07 -0700
Received: from zeus.spd.analog.com (10.66.68.11) by scsqmbx11.ad.analog.com
 (10.77.17.10) with Microsoft SMTP Server id 15.2.858.5 via Frontend
 Transport; Mon, 11 Oct 2021 07:11:07 -0700
Received: from localhost.localdomain ([10.48.65.12])
        by zeus.spd.analog.com (8.15.1/8.15.1) with ESMTP id 19BEAxn6020418;
        Mon, 11 Oct 2021 10:11:05 -0400
From:   <alexandru.tachici@analog.com>
To:     <andrew@lunn.ch>
CC:     <o.rempel@pengutronix.de>, <alexandru.tachici@analog.com>,
        <davem@davemloft.net>, <devicetree@vger.kernel.org>,
        <hkallweit1@gmail.com>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux@armlinux.org.uk>,
        <netdev@vger.kernel.org>, <robh+dt@kernel.org>
Subject: [PATCH v3 2/8] net: phy: Add 10-BaseT1L registers
Date:   Mon, 11 Oct 2021 17:22:09 +0300
Message-ID: <20211011142215.9013-3-alexandru.tachici@analog.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211011142215.9013-1-alexandru.tachici@analog.com>
References: <20211011142215.9013-1-alexandru.tachici@analog.com>
MIME-Version: 1.0
Content-Type: text/plain
X-ADIRuleOP-NewSCL: Rule Triggered
X-Proofpoint-GUID: VmPQnVmpit25sKf2KGyicyRUKLoyxq2g
X-Proofpoint-ORIG-GUID: VmPQnVmpit25sKf2KGyicyRUKLoyxq2g
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-11_04,2021-10-07_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 mlxlogscore=565 impostorscore=0 mlxscore=0 clxscore=1015
 lowpriorityscore=0 priorityscore=1501 spamscore=0 suspectscore=0
 bulkscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110110082
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexandru Tachici <alexandru.tachici@analog.com>

The 802.3gc specification defines the 10-BaseT1L link
mode for ethernet trafic on twisted wire pair.

PMA status register can be used to detect if the phy supports
2.4 V TX level and PCS control register can be used to
enable/disable PCS level loopback.

Signed-off-by: Alexandru Tachici <alexandru.tachici@analog.com>
---
 include/uapi/linux/mdio.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/include/uapi/linux/mdio.h b/include/uapi/linux/mdio.h
index bdf77dffa5a4..8ae82fe3aece 100644
--- a/include/uapi/linux/mdio.h
+++ b/include/uapi/linux/mdio.h
@@ -65,6 +65,8 @@
 #define MDIO_PCS_10GBRT_STAT2	33	/* 10GBASE-R/-T PCS status 2 */
 #define MDIO_AN_10GBT_CTRL	32	/* 10GBASE-T auto-negotiation control */
 #define MDIO_AN_10GBT_STAT	33	/* 10GBASE-T auto-negotiation status */
+#define MDIO_PMA_10T1L_STAT	2295	/* 10BASE-T1L PMA status */
+#define MDIO_PCS_10T1L_CTRL	2278	/* 10BASE-T1L PCS control */
 
 /* LASI (Link Alarm Status Interrupt) registers, defined by XENPAK MSA. */
 #define MDIO_PMA_LASI_RXCTRL	0x9000	/* RX_ALARM control */
@@ -262,6 +264,20 @@
 #define MDIO_AN_10GBT_STAT_MS		0x4000	/* Master/slave config */
 #define MDIO_AN_10GBT_STAT_MSFLT	0x8000	/* Master/slave config fault */
 
+/* 10BASE-T1L PMA status register. */
+#define MDIO_PMA_10T1L_STAT_LINK	0x0001	/* PMA receive link up */
+#define MDIO_PMA_10T1L_STAT_FAULT	0x0002	/* Fault condition detected */
+#define MDIO_PMA_10T1L_STAT_POLARITY	0x0004	/* Receive polarity is reversed */
+#define MDIO_PMA_10T1L_STAT_RECV_FAULT	0x0200	/* Able to detect fault on receive path */
+#define MDIO_PMA_10T1L_STAT_EEE		0x0400	/* PHY has EEE ability */
+#define MDIO_PMA_10T1L_STAT_LOW_POWER	0x0800	/* PMA has low-power ability */
+#define MDIO_PMA_10T1L_STAT_2V4_ABLE	0x1000	/* PHY has 2.4 Vpp operating mode ability */
+#define MDIO_PMA_10T1L_STAT_LB_ABLE	0x2000	/* PHY has loopback ability */
+
+/* 10BASE-T1L PCS control register. */
+#define MDIO_PCS_10T1L_CTRL_LB		0x4000	/* Enable PCS level loopback mode */
+#define MDIO_PCS_10T1L_CTRL_RESET	0x8000	/* PCS reset */
+
 /* EEE Supported/Advertisement/LP Advertisement registers.
  *
  * EEE capability Register (3.20), Advertisement (7.60) and
-- 
2.25.1

