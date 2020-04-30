Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D7361BF200
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 10:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbgD3IFO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 04:05:14 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:28842 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726424AbgD3IFM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 04:05:12 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03U85443011213;
        Thu, 30 Apr 2020 01:05:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=8+QsHNwsVguzepb0Iynr19dvCx5TFFGx/3z0/+lkxF4=;
 b=xYOsUoE/h/MXyL0DyTyTh6bHfvvPEkVNr3YsaRkZeoe2glIWwvQ938ZL0olRTdOnfYqu
 DfSqSQUkNdNJp5+v2eyWeqfkw/wFhR8Jlr447lJ68y3BSSC+SJvEzsi+2Uf5IIofgkr5
 08yMJH2M96IxmtpXYcOEKmzA9dICmc6hSoYZjEqMxolexqP80OU4HfLQEebQp874g23O
 eAoZlz67TQXZ7Md0mtSpMJWSJFiGoBmDK+rPYvJIBs3ZUdqilEmXTV1FAdPUkWMtGlkQ
 +W8rvmocZEpG3bykldPnTy8PgFggKxcIHdi6I+/wuYwG0IA4WRR7iSFFsspnovT6MER7 wQ== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 30mjjqnsj0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 30 Apr 2020 01:05:11 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 30 Apr
 2020 01:05:09 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 30 Apr
 2020 01:05:09 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 30 Apr 2020 01:05:09 -0700
Received: from NN-LT0019.marvell.com (unknown [10.193.46.2])
        by maili.marvell.com (Postfix) with ESMTP id 537EC3F7040;
        Thu, 30 Apr 2020 01:05:07 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH v2 net-next 03/17] net: atlantic: add defines for 10M and EEE 100M link mode
Date:   Thu, 30 Apr 2020 11:04:31 +0300
Message-ID: <20200430080445.1142-4-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200430080445.1142-1-irusskikh@marvell.com>
References: <20200430080445.1142-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-30_02:2020-04-30,2020-04-30 signatures=0
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
2.20.1

