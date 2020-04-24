Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D50C91B6EFB
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 09:28:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbgDXH1x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 03:27:53 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:51618 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725898AbgDXH1w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 03:27:52 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03O7QKUs021188;
        Fri, 24 Apr 2020 00:27:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=u7zThq1ErvSL6SbWosO2GprPk2fsWYMyEf/7kHYgx0I=;
 b=L/d8er38J1g43uKnTBIKJsNF0he9yRxcnjDQd1NlgKb9zdVNTbKCpfOfwcSVEWUqnumw
 zQzjOFktulV5NerjQIRRqrqEnznHVj3jnvYsf4/QzTAH0GYIDG5xuMcQiLc9hscskfg4
 /OV1j5396+k2bo8vVQKIfOglz7MYJMLXaVaC9MzhQNTi+2GsCP3v/dbAz0cn5qJ9OOWV
 XWoS7YOphkjhF/qoufhhMbWtANQsGmTD8Can7WSfw7K6kPqrD9gKsh6wS9l4swQeSu/S
 64Fprt5XSpcIVu0YwyoOcnB1Ujz634AgbEAVU4+OXU8r+awVAPyLEqtiq8GM2DhZyJ0+ ig== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 30kfdsb46p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 24 Apr 2020 00:27:50 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 24 Apr
 2020 00:27:48 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 24 Apr 2020 00:27:48 -0700
Received: from NN-LT0019.marvell.com (unknown [10.193.46.2])
        by maili.marvell.com (Postfix) with ESMTP id A77333F7040;
        Fri, 24 Apr 2020 00:27:46 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH net-next 03/17] net: atlantic: add defines for 10M and EEE 100M link mode
Date:   Fri, 24 Apr 2020 10:27:15 +0300
Message-ID: <20200424072729.953-4-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200424072729.953-1-irusskikh@marvell.com>
References: <20200424072729.953-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-24_02:2020-04-23,2020-04-24 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds defines for 10M and EEE 100M link modes, which are
supported by A2.

10M support is added in this patch series.
EEE is out of scope, but will be added in a follow-up series.

Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
---
 .../ethernet/aquantia/atlantic/aq_common.h    | 22 ++++++++++---------
 .../ethernet/aquantia/atlantic/aq_ethtool.c   |  3 +++
 .../net/ethernet/aquantia/atlantic/aq_nic.c   | 12 ++++++++++
 3 files changed, 27 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_common.h b/drivers/net/ethernet/aquantia/atlantic/aq_common.h
index 1261e7c7a01e..53620ba6d7a6 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_common.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_common.h
@@ -50,16 +50,18 @@
 #define AQ_HWREV_1	1
 #define AQ_HWREV_2	2
 
-#define AQ_NIC_RATE_10G        BIT(0)
-#define AQ_NIC_RATE_5G         BIT(1)
-#define AQ_NIC_RATE_5GSR       BIT(2)
-#define AQ_NIC_RATE_2GS        BIT(3)
-#define AQ_NIC_RATE_1G         BIT(4)
-#define AQ_NIC_RATE_100M       BIT(5)
+#define AQ_NIC_RATE_10G		BIT(0)
+#define AQ_NIC_RATE_5G		BIT(1)
+#define AQ_NIC_RATE_5GSR	BIT(2)
+#define AQ_NIC_RATE_2GS		BIT(3)
+#define AQ_NIC_RATE_1G		BIT(4)
+#define AQ_NIC_RATE_100M	BIT(5)
+#define AQ_NIC_RATE_10M		BIT(6)
 
-#define AQ_NIC_RATE_EEE_10G	BIT(6)
-#define AQ_NIC_RATE_EEE_5G	BIT(7)
-#define AQ_NIC_RATE_EEE_2GS	BIT(8)
-#define AQ_NIC_RATE_EEE_1G	BIT(9)
+#define AQ_NIC_RATE_EEE_10G	BIT(7)
+#define AQ_NIC_RATE_EEE_5G	BIT(8)
+#define AQ_NIC_RATE_EEE_2GS	BIT(9)
+#define AQ_NIC_RATE_EEE_1G	BIT(10)
+#define AQ_NIC_RATE_EEE_100M	BIT(11)
 
 #endif /* AQ_COMMON_H */
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
index 7241cf92b43a..0c9dd8edc062 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
@@ -611,6 +611,9 @@ static enum hw_atl_fw2x_rate eee_mask_to_ethtool_mask(u32 speed)
 	if (speed & AQ_NIC_RATE_EEE_1G)
 		rate |= SUPPORTED_1000baseT_Full;
 
+	if (speed & AQ_NIC_RATE_EEE_100M)
+		rate |= SUPPORTED_100baseT_Full;
+
 	return rate;
 }
 
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
index a369705a786a..80dd744dcbd1 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -885,6 +885,10 @@ void aq_nic_get_link_ksettings(struct aq_nic_s *self,
 		ethtool_link_ksettings_add_link_mode(cmd, supported,
 						     100baseT_Full);
 
+	if (self->aq_nic_cfg.aq_hw_caps->link_speed_msk & AQ_NIC_RATE_10M)
+		ethtool_link_ksettings_add_link_mode(cmd, supported,
+						     10baseT_Full);
+
 	if (self->aq_nic_cfg.aq_hw_caps->flow_control) {
 		ethtool_link_ksettings_add_link_mode(cmd, supported,
 						     Pause);
@@ -924,6 +928,10 @@ void aq_nic_get_link_ksettings(struct aq_nic_s *self,
 		ethtool_link_ksettings_add_link_mode(cmd, advertising,
 						     100baseT_Full);
 
+	if (self->aq_nic_cfg.link_speed_msk  & AQ_NIC_RATE_10M)
+		ethtool_link_ksettings_add_link_mode(cmd, advertising,
+						     10baseT_Full);
+
 	if (self->aq_nic_cfg.fc.cur & AQ_NIC_FC_RX)
 		ethtool_link_ksettings_add_link_mode(cmd, advertising,
 						     Pause);
@@ -954,6 +962,10 @@ int aq_nic_set_link_ksettings(struct aq_nic_s *self,
 		speed = cmd->base.speed;
 
 		switch (speed) {
+		case SPEED_10:
+			rate = AQ_NIC_RATE_10M;
+			break;
+
 		case SPEED_100:
 			rate = AQ_NIC_RATE_100M;
 			break;
-- 
2.17.1

