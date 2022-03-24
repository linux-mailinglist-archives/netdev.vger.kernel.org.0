Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BE884E624E
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 12:18:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349778AbiCXLTS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 07:19:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347044AbiCXLTK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 07:19:10 -0400
Received: from mx0a-00128a01.pphosted.com (mx0a-00128a01.pphosted.com [148.163.135.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B2C0A66DF;
        Thu, 24 Mar 2022 04:17:39 -0700 (PDT)
Received: from pps.filterd (m0167089.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22OAv4aE015957;
        Thu, 24 Mar 2022 07:17:14 -0400
Received: from nwd2mta4.analog.com ([137.71.173.58])
        by mx0a-00128a01.pphosted.com (PPS) with ESMTPS id 3f0denc076-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Mar 2022 07:17:13 -0400
Received: from ASHBMBX8.ad.analog.com (ASHBMBX8.ad.analog.com [10.64.17.5])
        by nwd2mta4.analog.com (8.14.7/8.14.7) with ESMTP id 22OBHB0p032729
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 24 Mar 2022 07:17:11 -0400
Received: from ASHBCASHYB4.ad.analog.com (10.64.17.132) by
 ASHBMBX8.ad.analog.com (10.64.17.5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.14; Thu, 24 Mar 2022 07:17:10 -0400
Received: from ASHBMBX8.ad.analog.com (10.64.17.5) by
 ASHBCASHYB4.ad.analog.com (10.64.17.132) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.14; Thu, 24 Mar 2022 07:17:10 -0400
Received: from zeus.spd.analog.com (10.66.68.11) by ashbmbx8.ad.analog.com
 (10.64.17.5) with Microsoft SMTP Server id 15.2.986.14 via Frontend
 Transport; Thu, 24 Mar 2022 07:17:10 -0400
Received: from localhost.localdomain ([10.48.65.12])
        by zeus.spd.analog.com (8.15.1/8.15.1) with ESMTP id 22OBGjPc000657;
        Thu, 24 Mar 2022 07:17:03 -0400
From:   <alexandru.tachici@analog.com>
To:     <andrew@lunn.ch>
CC:     <o.rempel@pengutronix.de>, <alexandru.tachici@analog.com>,
        <davem@davemloft.net>, <devicetree@vger.kernel.org>,
        <hkallweit1@gmail.com>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux@armlinux.org.uk>,
        <netdev@vger.kernel.org>, <robh+dt@kernel.org>
Subject: [PATCH v5 3/7] net: phy: Add BaseT1 auto-negotiation registers
Date:   Thu, 24 Mar 2022 13:26:16 +0200
Message-ID: <20220324112620.46963-4-alexandru.tachici@analog.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220324112620.46963-1-alexandru.tachici@analog.com>
References: <20220324112620.46963-1-alexandru.tachici@analog.com>
MIME-Version: 1.0
Content-Type: text/plain
X-ADIRuleOP-NewSCL: Rule Triggered
X-Proofpoint-GUID: a63rB424cG2d_tpFKDEWu0P0Rn19rOXW
X-Proofpoint-ORIG-GUID: a63rB424cG2d_tpFKDEWu0P0Rn19rOXW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-24_03,2022-03-24_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 impostorscore=0
 malwarescore=0 mlxlogscore=623 priorityscore=1501 adultscore=0 bulkscore=0
 clxscore=1015 suspectscore=0 mlxscore=0 phishscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203240067
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexandru Tachici <alexandru.tachici@analog.com>

Added BASE-T1 AN advertisement register (Registers 7.514, 7.515, and
7.516) and BASE-T1 AN LP Base Page ability register (Registers 7.517,
7.518, and 7.519).

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Alexandru Tachici <alexandru.tachici@analog.com>
---
 include/uapi/linux/mdio.h | 40 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/include/uapi/linux/mdio.h b/include/uapi/linux/mdio.h
index 0b2eba36dd7c..fa3515257f54 100644
--- a/include/uapi/linux/mdio.h
+++ b/include/uapi/linux/mdio.h
@@ -70,6 +70,14 @@
 #define MDIO_B10L_PMA_CTRL	2294	/* 10BASE-T1L PMA control */
 #define MDIO_PMA_10T1L_STAT	2295	/* 10BASE-T1L PMA status */
 #define MDIO_PCS_10T1L_CTRL	2278	/* 10BASE-T1L PCS control */
+#define MDIO_AN_T1_CTRL		512	/* BASE-T1 AN control */
+#define MDIO_AN_T1_STAT		513	/* BASE-T1 AN status */
+#define MDIO_AN_T1_ADV_L	514	/* BASE-T1 AN advertisement register [15:0] */
+#define MDIO_AN_T1_ADV_M	515	/* BASE-T1 AN advertisement register [31:16] */
+#define MDIO_AN_T1_ADV_H	516	/* BASE-T1 AN advertisement register [47:32] */
+#define MDIO_AN_T1_LP_L		517	/* BASE-T1 AN LP Base Page ability register [15:0] */
+#define MDIO_AN_T1_LP_M		518	/* BASE-T1 AN LP Base Page ability register [31:16] */
+#define MDIO_AN_T1_LP_H		519	/* BASE-T1 AN LP Base Page ability register [47:32] */
 
 /* LASI (Link Alarm Status Interrupt) registers, defined by XENPAK MSA. */
 #define MDIO_PMA_LASI_RXCTRL	0x9000	/* RX_ALARM control */
@@ -293,6 +301,38 @@
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
+/* BASE-T1 AN LP Base Page ability register [15:0] */
+#define MDIO_AN_T1_LP_L_PAUSE_CAP	LPA_PAUSE_CAP
+#define MDIO_AN_T1_LP_L_PAUSE_ASYM	LPA_PAUSE_ASYM
+#define MDIO_AN_T1_LP_L_FORCE_MS	0x1000	/* LP Force Master/slave Configuration */
+#define MDIO_AN_T1_LP_L_REMOTE_FAULT	LPA_RFAULT
+#define MDIO_AN_T1_LP_L_ACK		LPA_LPACK
+#define MDIO_AN_T1_LP_L_NEXT_PAGE_REQ	LPA_NPAGE
+
+/* BASE-T1 AN LP Base Page ability register [31:16] */
+#define MDIO_AN_T1_LP_M_MST		0x0010	/* LP master preference */
+#define MDIO_AN_T1_LP_M_B10L		0x4000	/* LP is compatible with 10BASE-T1L */
+
+/* BASE-T1 AN LP Base Page ability register [47:32] */
+#define MDIO_AN_T1_LP_H_10L_TX_HI_REQ	0x1000	/* 10BASE-T1L High Level LP Transmit Request */
+#define MDIO_AN_T1_LP_H_10L_TX_HI	0x2000	/* 10BASE-T1L High Level LP Transmit Ability */
+
 /* EEE Supported/Advertisement/LP Advertisement registers.
  *
  * EEE capability Register (3.20), Advertisement (7.60) and
-- 
2.25.1

