Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 049D822540E
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 22:16:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727101AbgGSUQX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 16:16:23 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:55650 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726989AbgGSUQS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 16:16:18 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06JKFl0S012732;
        Sun, 19 Jul 2020 13:16:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=9VWlGG5x0pzxlZudfNcUxuHnty7l0RzA4mHNso3M3xg=;
 b=kZeMihl9dphH1qo/wRmKLOjC4kQgPCuu4UP9kDllLXb1EtcAqBAdth7cNlNm5dlSlXw1
 Qx2R8JHZkwBNbYGTOKk5XJp48txAwAd6AD9ojx3HyTo+BlbNMD49b+X7AA78v5N5HsrW
 wAh2+IImghQP56vJh1bo4dh25UirYFhrixOVbumhtwkwGKyshnLXFsQHcETEplNqE3vh
 jNmt5uZ33u0tssCXISPhwANdDumRhhfDhatNwWwuH9eWyDhTlInWq1RYco6SRQNXLIuf
 BpxlzfQ96lKxoLMDtUopGNqGK/XtIEwaknRUBHT2J+ZRBj5zBt5k8CNwh3atLsrrkAq3 5g== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 32bxenbyum-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 19 Jul 2020 13:16:15 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 19 Jul
 2020 13:16:14 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 19 Jul
 2020 13:16:13 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 19 Jul 2020 13:16:13 -0700
Received: from NN-LT0049.marvell.com (NN-LT0049.marvell.com [10.193.54.6])
        by maili.marvell.com (Postfix) with ESMTP id C6C773F703F;
        Sun, 19 Jul 2020 13:16:08 -0700 (PDT)
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
        <QLogic-Storage-Upstream@marvell.com>, <netdev@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 net-next 12/14] qed: add missing loopback modes
Date:   Sun, 19 Jul 2020 23:14:51 +0300
Message-ID: <20200719201453.3648-13-alobakin@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200719201453.3648-1-alobakin@marvell.com>
References: <20200719201453.3648-1-alobakin@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-19_04:2020-07-17,2020-07-19 signatures=0
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

