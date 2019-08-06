Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB9AD82C2C
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 09:01:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731867AbfHFG74 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 02:59:56 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:22502 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731735AbfHFG7z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 02:59:55 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x766jkIK027701;
        Mon, 5 Aug 2019 23:59:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=eNQSYxylLcmTd9J3CCEC/LYQVaj7fekN8m1QLuFfJ0Q=;
 b=kggiCRrr9LZ9bIYRgvHMkUodGQa2R38X6PUhvjQym4EbQwbG6WLsCb0g+f0KZUtEBkkq
 9xXOiKx8OwBPfmJi2VLRWkQi2WGbSCX3hYGuaMb6P0+8F9RtGFFCX+tIU1VDXWklEpWg
 Go8ZulxUfBAmj242QVrv8V/Kkym9k+Gw6F9IQyOo31IwKKY+TSfT0kdKJWaM4mYRNhFa
 uROh1fJDMaj1JPJcjQ8Ltl7cB8PWMoMwzWqvla6snhoh0wOXbA6fanYQ9Qh5D1dWIi+r
 +akH5ubXRKuLmnbbrihWGP+Pvev3SY8hJ0u4xhKX6sqmTFBfsrGuDiEtx4l7XEoW+hwX Jg== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 2u57mr23x5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 05 Aug 2019 23:59:54 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Mon, 5 Aug
 2019 23:59:53 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Mon, 5 Aug 2019 23:59:53 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 1C0AD3F7040;
        Mon,  5 Aug 2019 23:59:53 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id x766xqSr019110;
        Mon, 5 Aug 2019 23:59:52 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id x766xqUD019109;
        Mon, 5 Aug 2019 23:59:52 -0700
From:   Rahul Verma <rahulv@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <aelior@marvell.com>,
        <mkalderon@marvell.com>
Subject: [PATCH net-next v2 1/1] qed: Add new ethtool supported port types based on media.
Date:   Mon, 5 Aug 2019 23:59:50 -0700
Message-ID: <20190806065950.19073-1-rahulv@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:5.22.84,1.0.8
 definitions=2019-08-06_03:2019-07-31,2019-08-06 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Supported ports in ethtool <eth1> are displayed based on media type.
For media type fibre and twinaxial, port type is "FIBRE". Media type
Base-T is "TP" and media KR is "Backplane".

V1->V2:
Corrected the subject.

Signed-off-by: Rahul Verma <rahulv@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_main.c      | 6 +++++-
 drivers/net/ethernet/qlogic/qede/qede_ethtool.c | 3 ++-
 include/linux/qed/qed_if.h                      | 2 +-
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_main.c b/drivers/net/ethernet/qlogic/qed/qed_main.c
index 829dd60..e5ac8bd 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_main.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
@@ -1688,6 +1688,7 @@ static void qed_fill_link_capability(struct qed_hwfn *hwfn,
 
 	switch (media_type) {
 	case MEDIA_DA_TWINAX:
+		*if_capability |= QED_LM_FIBRE_BIT;
 		if (capability & NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_20G)
 			*if_capability |= QED_LM_20000baseKR2_Full_BIT;
 		/* For DAC media multiple speed capabilities are supported*/
@@ -1707,6 +1708,7 @@ static void qed_fill_link_capability(struct qed_hwfn *hwfn,
 			*if_capability |= QED_LM_100000baseCR4_Full_BIT;
 		break;
 	case MEDIA_BASE_T:
+		*if_capability |= QED_LM_TP_BIT;
 		if (board_cfg & NVM_CFG1_PORT_PORT_TYPE_EXT_PHY) {
 			if (capability &
 			    NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_1G) {
@@ -1718,6 +1720,7 @@ static void qed_fill_link_capability(struct qed_hwfn *hwfn,
 			}
 		}
 		if (board_cfg & NVM_CFG1_PORT_PORT_TYPE_MODULE) {
+			*if_capability |= QED_LM_FIBRE_BIT;
 			if (tcvr_type == ETH_TRANSCEIVER_TYPE_1000BASET)
 				*if_capability |= QED_LM_1000baseT_Full_BIT;
 			if (tcvr_type == ETH_TRANSCEIVER_TYPE_10G_BASET)
@@ -1728,6 +1731,7 @@ static void qed_fill_link_capability(struct qed_hwfn *hwfn,
 	case MEDIA_SFPP_10G_FIBER:
 	case MEDIA_XFP_FIBER:
 	case MEDIA_MODULE_FIBER:
+		*if_capability |= QED_LM_FIBRE_BIT;
 		if (capability &
 		    NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_1G) {
 			if ((tcvr_type == ETH_TRANSCEIVER_TYPE_1G_LX) ||
@@ -1770,6 +1774,7 @@ static void qed_fill_link_capability(struct qed_hwfn *hwfn,
 
 		break;
 	case MEDIA_KR:
+		*if_capability |= QED_LM_Backplane_BIT;
 		if (capability & NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_20G)
 			*if_capability |= QED_LM_20000baseKR2_Full_BIT;
 		if (capability &
@@ -1821,7 +1826,6 @@ static void qed_fill_link(struct qed_hwfn *hwfn,
 		if_link->link_up = true;
 
 	/* TODO - at the moment assume supported and advertised speed equal */
-	if_link->supported_caps = QED_LM_FIBRE_BIT;
 	if (link_caps.default_speed_autoneg)
 		if_link->supported_caps |= QED_LM_Autoneg_BIT;
 	if (params.pause.autoneg ||
diff --git a/drivers/net/ethernet/qlogic/qede/qede_ethtool.c b/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
index e85f9fe..abcee47 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
@@ -424,12 +424,13 @@ struct qede_link_mode_mapping {
 };
 
 static const struct qede_link_mode_mapping qed_lm_map[] = {
+	{QED_LM_FIBRE_BIT, ETHTOOL_LINK_MODE_FIBRE_BIT},
 	{QED_LM_Autoneg_BIT, ETHTOOL_LINK_MODE_Autoneg_BIT},
 	{QED_LM_Asym_Pause_BIT, ETHTOOL_LINK_MODE_Asym_Pause_BIT},
 	{QED_LM_Pause_BIT, ETHTOOL_LINK_MODE_Pause_BIT},
 	{QED_LM_1000baseT_Full_BIT, ETHTOOL_LINK_MODE_1000baseT_Full_BIT},
 	{QED_LM_10000baseT_Full_BIT, ETHTOOL_LINK_MODE_10000baseT_Full_BIT},
-	{QED_LM_2500baseX_Full_BIT, ETHTOOL_LINK_MODE_2500baseX_Full_BIT},
+	{QED_LM_TP_BIT, ETHTOOL_LINK_MODE_TP_BIT},
 	{QED_LM_Backplane_BIT, ETHTOOL_LINK_MODE_Backplane_BIT},
 	{QED_LM_1000baseKX_Full_BIT, ETHTOOL_LINK_MODE_1000baseKX_Full_BIT},
 	{QED_LM_10000baseKX4_Full_BIT, ETHTOOL_LINK_MODE_10000baseKX4_Full_BIT},
diff --git a/include/linux/qed/qed_if.h b/include/linux/qed/qed_if.h
index eef02e6..2302136 100644
--- a/include/linux/qed/qed_if.h
+++ b/include/linux/qed/qed_if.h
@@ -689,7 +689,7 @@ enum qed_link_mode_bits {
 	QED_LM_40000baseLR4_Full_BIT = BIT(9),
 	QED_LM_50000baseKR2_Full_BIT = BIT(10),
 	QED_LM_100000baseKR4_Full_BIT = BIT(11),
-	QED_LM_2500baseX_Full_BIT = BIT(12),
+	QED_LM_TP_BIT = BIT(12),
 	QED_LM_Backplane_BIT = BIT(13),
 	QED_LM_1000baseKX_Full_BIT = BIT(14),
 	QED_LM_10000baseKX4_Full_BIT = BIT(15),
-- 
1.8.3.1

