Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71D13226DFA
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 20:10:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732880AbgGTSK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 14:10:29 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:52700 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729172AbgGTSJ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 14:09:57 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06KHtqIK024225;
        Mon, 20 Jul 2020 11:09:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=gOpE0CIDsE22VHBlzAJWjIPURA1X1fT9iugm/XZK37A=;
 b=evoSqL4drodhzRWJczD9jkhtdE53ZSrQxQlL6ljDB042kWwAPkVP9f9bBIdZLtfA5So1
 jTmUzBjHfXujrXNJ2R5zXQLUSweu//YQ5XJ0MCJ5ZJwDi4MNk9P18h4YG1J4dtEMWfVu
 wxkY+rW0kkfdNLqg6p1T8hmWiJ50QiRuSSws9sAu5BalWrUZyilgOA0xEduQFbjY4eej
 b1QCP6n+O4ZimT+3lHy/dUkauKMeNrcwqUjijJxcCvsSF+g71/FgvH8V9TWIc+vHG3Xn
 jOUISvTYUH3fLH2INr6XoDA2dP5ezaxFCLbj0XeWeMiJt/2mVsgT2bfSybdGqLY1knFX Ow== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 32c0kkf91f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 20 Jul 2020 11:09:51 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 20 Jul
 2020 11:09:50 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 20 Jul
 2020 11:09:48 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 20 Jul 2020 11:09:48 -0700
Received: from NN-LT0049.marvell.com (NN-LT0049.marvell.com [10.193.54.6])
        by maili.marvell.com (Postfix) with ESMTP id 3DFDB3F7040;
        Mon, 20 Jul 2020 11:09:43 -0700 (PDT)
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
Subject: [PATCH v3 net-next 13/16] qed: add support for new port modes
Date:   Mon, 20 Jul 2020 21:08:12 +0300
Message-ID: <20200720180815.107-14-alobakin@marvell.com>
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

These ports ship on new boards revisions and are supported by newer
firmware versions.

Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_dev.c | 5 +++++
 drivers/net/ethernet/qlogic/qed/qed_hsi.h | 5 +++++
 2 files changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_dev.c b/drivers/net/ethernet/qlogic/qed/qed_dev.c
index eaf37822fed7..66a520099c44 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_dev.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_dev.c
@@ -4004,6 +4004,11 @@ static int qed_hw_get_nvm_info(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
 	case NVM_CFG1_GLOB_NETWORK_PORT_MODE_2X10G:
 	case NVM_CFG1_GLOB_NETWORK_PORT_MODE_1X25G:
 	case NVM_CFG1_GLOB_NETWORK_PORT_MODE_4X25G:
+	case NVM_CFG1_GLOB_NETWORK_PORT_MODE_AHP_2X50G_R1:
+	case NVM_CFG1_GLOB_NETWORK_PORT_MODE_AHP_4X50G_R1:
+	case NVM_CFG1_GLOB_NETWORK_PORT_MODE_AHP_1X100G_R2:
+	case NVM_CFG1_GLOB_NETWORK_PORT_MODE_AHP_2X100G_R2:
+	case NVM_CFG1_GLOB_NETWORK_PORT_MODE_AHP_1X100G_R4:
 		break;
 	default:
 		DP_NOTICE(p_hwfn, "Unknown port mode in 0x%08x\n", core_cfg);
diff --git a/drivers/net/ethernet/qlogic/qed/qed_hsi.h b/drivers/net/ethernet/qlogic/qed/qed_hsi.h
index a4a845579fd2..debc55923251 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_hsi.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_hsi.h
@@ -13015,6 +13015,11 @@ struct nvm_cfg1_glob {
 #define NVM_CFG1_GLOB_NETWORK_PORT_MODE_1X25G			0xd
 #define NVM_CFG1_GLOB_NETWORK_PORT_MODE_4X25G			0xe
 #define NVM_CFG1_GLOB_NETWORK_PORT_MODE_2X10G			0xf
+#define NVM_CFG1_GLOB_NETWORK_PORT_MODE_AHP_2X50G_R1		0x11
+#define NVM_CFG1_GLOB_NETWORK_PORT_MODE_AHP_4X50G_R1		0x12
+#define NVM_CFG1_GLOB_NETWORK_PORT_MODE_AHP_1X100G_R2		0x13
+#define NVM_CFG1_GLOB_NETWORK_PORT_MODE_AHP_2X100G_R2		0x14
+#define NVM_CFG1_GLOB_NETWORK_PORT_MODE_AHP_1X100G_R4		0x15
 
 	u32							e_lane_cfg1;
 	u32							e_lane_cfg2;
-- 
2.25.1

