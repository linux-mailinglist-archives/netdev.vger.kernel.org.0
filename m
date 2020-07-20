Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33DCD226DF1
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 20:10:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389365AbgGTSKE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 14:10:04 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:27324 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389352AbgGTSKC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 14:10:02 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06KHtqIL024225;
        Mon, 20 Jul 2020 11:09:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=iUovK0mCKmnx/XdhQ2oHEjXNjkIUmgaq8v42E8rM5sA=;
 b=Z+AJgNq8e+8V+bx0pqk9ds25x11cXLA127kpWLs5hMELCTjinjXENn5tuswefOFlEW2K
 J4ylT+5KsRgZ8fTFKop8uZoVM5S9tWtykW5ESPT3MP2ez/MHH4SOL5L44GEeFz3NpsZi
 zS/ur9EL0V/m5E0qrDMyqrvWHpB4k1gF5TxWou9eaKRJOcZg+RmP/l6yVo3vWu1fvE55
 xwE10SWYKKzRximWL31IbAOcK9Nt6NJ8xXqk/E8HvYYYDM72lp0JqEif+oXOJRIhG6vI
 DpT5I4sLyHqjJzRDzsBiJyqU23W/iJ/rGEzU/kNhWTV7Jw63Kb0Tp7QL3CwRDgKa9DqP SQ== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 32c0kkf91v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 20 Jul 2020 11:09:56 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 20 Jul
 2020 11:09:55 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 20 Jul
 2020 11:09:53 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 20 Jul 2020 11:09:53 -0700
Received: from NN-LT0049.marvell.com (NN-LT0049.marvell.com [10.193.54.6])
        by maili.marvell.com (Postfix) with ESMTP id 0D69D3F7041;
        Mon, 20 Jul 2020 11:09:48 -0700 (PDT)
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
        Andrew Lunn <andrew@lunn.ch>,
        <GR-everest-linux-l2@marvell.com>,
        <QLogic-Storage-Upstream@marvell.com>, <netdev@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 net-next 14/16] qed: add missing loopback modes
Date:   Mon, 20 Jul 2020 21:08:13 +0300
Message-ID: <20200720180815.107-15-alobakin@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200720180815.107-1-alobakin@marvell.com>
References: <20200720180815.107-1-alobakin@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-20_09:2020-07-20,2020-07-20 signatures=0
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
index 91e7cfc544f0..fea155c6ff11 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_main.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
@@ -1587,6 +1587,25 @@ static int qed_set_link(struct qed_dev *cdev, struct qed_link_params *params)
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
index f0b4cdc79299..2e780159a5fb 100644
--- a/include/linux/qed/qed_if.h
+++ b/include/linux/qed/qed_if.h
@@ -696,6 +696,11 @@ struct qed_link_params {
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

