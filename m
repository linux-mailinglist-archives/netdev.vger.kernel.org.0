Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F49E2221E0
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 13:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728296AbgGPL4e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 07:56:34 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:32888 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728655AbgGPL4c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 07:56:32 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06GBp71l006965;
        Thu, 16 Jul 2020 04:56:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=9VWlGG5x0pzxlZudfNcUxuHnty7l0RzA4mHNso3M3xg=;
 b=XDKfD2Dfetfvpq/fuvJgfyqRFdhNbTC9dBNRJznjtVMyngcmnjcGQ0zdO7XQoiXYHA02
 o1T0IHNuWPPrK+hjiPjIHbWbeErMHJcoh8M9yElnm6T1YI8xS0ItdnelGzvB4HJkh8U+
 sr3t5ArIfskqaKxIGGvCaxUbYSVKAUF+xktuvta2qDZf69vKFFqwRkKXV960J/ng9HcC
 LdPjHIChNPlIA2iKcDMRTHnTihgkWvDZ6NRMZU9t8ceiwFFIwtYd6ISvHkTNwyNcnJ8J
 GlIJEEyBVe1TAWbbid0SYKFiiPXxGOJ8bnLd8MN1E9Zpespsq2ZaF2ptP0bQK2v6mkcM Tw== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 328mmhyg3k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 16 Jul 2020 04:56:28 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 16 Jul
 2020 04:56:27 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 16 Jul
 2020 04:56:26 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 16 Jul 2020 04:56:26 -0700
Received: from NN-LT0049.marvell.com (NN-LT0049.marvell.com [10.193.54.6])
        by maili.marvell.com (Postfix) with ESMTP id EB3FB3F703F;
        Thu, 16 Jul 2020 04:56:21 -0700 (PDT)
From:   Alexander Lobakin <alobakin@marvell.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Alexander Lobakin <alobakin@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        "Ariel Elior" <aelior@marvell.com>,
        Denis Bolotin <denis.bolotin@marvell.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        <GR-everest-linux-l2@marvell.com>,
        <QLogic-Storage-Upstream@cavium.com>, <netdev@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next 11/13] qed: add missing loopback modes
Date:   Thu, 16 Jul 2020 14:54:44 +0300
Message-ID: <20200716115446.994-12-alobakin@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200716115446.994-1-alobakin@marvell.com>
References: <20200716115446.994-1-alobakin@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-16_05:2020-07-16,2020-07-16 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These modes are relevant only for several boards, but may be reported by
MFW as well as the others.

Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_hsi.h  |  5 +++++
 drivers/net/ethernet/qlogic/qed/qed_main.c | 19 +++++++++++++++++++
 include/linux/qed/qed_if.h                 |  5 +++++
 3 files changed, 29 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_hsi.h b/drivers/net/ethernet/qlogic/qed/qed_hsi.h
index debc55923251..5b81d5d42397 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_hsi.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_hsi.h
@@ -11554,6 +11554,11 @@ struct eth_phy_cfg {
 #define ETH_LOOPBACK_EXT_PHY			0x2
 #define ETH_LOOPBACK_EXT			0x3
 #define ETH_LOOPBACK_MAC			0x4
+#define ETH_LOOPBACK_CNIG_AH_ONLY_0123		0x5
+#define ETH_LOOPBACK_CNIG_AH_ONLY_2301		0x6
+#define ETH_LOOPBACK_PCS_AH_ONLY		0x7
+#define ETH_LOOPBACK_REVERSE_MAC_AH_ONLY	0x8
+#define ETH_LOOPBACK_INT_PHY_FEA_AH_ONLY	0x9
 
 	u32					eee_cfg;
 #define EEE_CFG_EEE_ENABLED			BIT(0)
diff --git a/drivers/net/ethernet/qlogic/qed/qed_main.c b/drivers/net/ethernet/qlogic/qed/qed_main.c
index 768d6ab5395f..ff8e41694f65 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_main.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
@@ -1586,6 +1586,25 @@ static int qed_set_link(struct qed_dev *cdev, struct qed_link_params *params)
 		case QED_LINK_LOOPBACK_MAC:
 			link_params->loopback_mode = ETH_LOOPBACK_MAC;
 			break;
+		case QED_LINK_LOOPBACK_CNIG_AH_ONLY_0123:
+			link_params->loopback_mode =
+				ETH_LOOPBACK_CNIG_AH_ONLY_0123;
+			break;
+		case QED_LINK_LOOPBACK_CNIG_AH_ONLY_2301:
+			link_params->loopback_mode =
+				ETH_LOOPBACK_CNIG_AH_ONLY_2301;
+			break;
+		case QED_LINK_LOOPBACK_PCS_AH_ONLY:
+			link_params->loopback_mode = ETH_LOOPBACK_PCS_AH_ONLY;
+			break;
+		case QED_LINK_LOOPBACK_REVERSE_MAC_AH_ONLY:
+			link_params->loopback_mode =
+				ETH_LOOPBACK_REVERSE_MAC_AH_ONLY;
+			break;
+		case QED_LINK_LOOPBACK_INT_PHY_FEA_AH_ONLY:
+			link_params->loopback_mode =
+				ETH_LOOPBACK_INT_PHY_FEA_AH_ONLY;
+			break;
 		default:
 			link_params->loopback_mode = ETH_LOOPBACK_NONE;
 			break;
diff --git a/include/linux/qed/qed_if.h b/include/linux/qed/qed_if.h
index 1b5286d454bf..9edd5de5645d 100644
--- a/include/linux/qed/qed_if.h
+++ b/include/linux/qed/qed_if.h
@@ -745,6 +745,11 @@ struct qed_link_params {
 #define QED_LINK_LOOPBACK_EXT_PHY		BIT(2)
 #define QED_LINK_LOOPBACK_EXT			BIT(3)
 #define QED_LINK_LOOPBACK_MAC			BIT(4)
+#define QED_LINK_LOOPBACK_CNIG_AH_ONLY_0123	BIT(5)
+#define QED_LINK_LOOPBACK_CNIG_AH_ONLY_2301	BIT(6)
+#define QED_LINK_LOOPBACK_PCS_AH_ONLY		BIT(7)
+#define QED_LINK_LOOPBACK_REVERSE_MAC_AH_ONLY	BIT(8)
+#define QED_LINK_LOOPBACK_INT_PHY_FEA_AH_ONLY	BIT(9)
 
 	struct qed_link_eee_params		eee;
 	u32					fec;
-- 
2.25.1

