Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B93C01B6EFD
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 09:28:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbgDXH16 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 03:27:58 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:17270 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726709AbgDXH15 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 03:27:57 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03O7PjVZ021054;
        Fri, 24 Apr 2020 00:27:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=URPU+6s7eCjL42xwy2pcao0FkC/NtsHgxEHLzKVDzGM=;
 b=OGxrzfoOhouKOHopJ2GyWg9Bf2L/3WniaiO3sqRzfjjzylKH1HCM6e2ZoU6XVq9O2bW8
 PlZltj+2xCnYfg8OlY27BrbdqbplbLSxABkGOV6r4Y5wswXCC92jgC1mrLH1EZ1VAIJf
 HMf5dfTElxyqlD0BQeDtnc2XnYK/S+NnejVjtr6OHYM/CYNh88QoSv6hZ1N/oxd0quoQ
 WVthucVDdOhK1P+Eja0tQ3AwD7QrdiLRDtJUiOkwDmPDKZ3lSjGYRYUwJKlJXYq/W2bF
 7yFgjNXUaZIaVmZs/s+GhtNInJo7JperELmJnIjGr18x2PVrjzvt/fj06/96U4rDs+Wd cQ== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 30kfdsb471-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 24 Apr 2020 00:27:55 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 24 Apr
 2020 00:27:53 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 24 Apr 2020 00:27:53 -0700
Received: from NN-LT0019.marvell.com (unknown [10.193.46.2])
        by maili.marvell.com (Postfix) with ESMTP id 3FEDB3F7040;
        Fri, 24 Apr 2020 00:27:50 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Nikita Danilov <ndanilov@marvell.com>,
        "Igor Russkikh" <irusskikh@marvell.com>
Subject: [PATCH net-next 05/17] net: atlantic: simplify hw_get_fw_version() usage
Date:   Fri, 24 Apr 2020 10:27:17 +0300
Message-ID: <20200424072729.953-6-irusskikh@marvell.com>
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

From: Nikita Danilov <ndanilov@marvell.com>

hw_get_fw_version() never fails, so this patch simplifies its
usage by utilizing return value instead of output argument.

Signed-off-by: Nikita Danilov <ndanilov@marvell.com>
Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 drivers/net/ethernet/aquantia/atlantic/aq_hw.h            | 2 +-
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c           | 6 +-----
 .../net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c  | 8 +++-----
 .../net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.h  | 2 +-
 4 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_hw.h b/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
index 84abce29d590..c0dada1075cf 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
@@ -259,7 +259,7 @@ struct aq_hw_ops {
 
 	struct aq_stats_s *(*hw_get_hw_stats)(struct aq_hw_s *self);
 
-	int (*hw_get_fw_version)(struct aq_hw_s *self, u32 *fw_version);
+	u32 (*hw_get_fw_version)(struct aq_hw_s *self);
 
 	int (*hw_set_offload)(struct aq_hw_s *self,
 			      struct aq_nic_cfg_s *aq_nic_cfg);
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
index 7f4d8abab951..57102f35e9f3 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -1032,11 +1032,7 @@ struct aq_nic_cfg_s *aq_nic_get_cfg(struct aq_nic_s *self)
 
 u32 aq_nic_get_fw_version(struct aq_nic_s *self)
 {
-	u32 fw_version = 0U;
-
-	self->aq_hw_ops->hw_get_fw_version(self->aq_hw, &fw_version);
-
-	return fw_version;
+	return self->aq_hw_ops->hw_get_fw_version(self->aq_hw);
 }
 
 int aq_nic_set_loopback(struct aq_nic_s *self)
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
index 7259bcb81e9b..bd1712ca9ef2 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
@@ -70,7 +70,7 @@ int hw_atl_utils_initfw(struct aq_hw_s *self, const struct aq_fw_ops **fw_ops)
 	hw_atl_utils_hw_chip_features_init(self,
 					   &self->chip_features);
 
-	hw_atl_utils_get_fw_version(self, &self->fw_ver_actual);
+	self->fw_ver_actual = hw_atl_utils_get_fw_version(self);
 
 	if (hw_atl_utils_ver_match(HW_ATL_FW_VER_1X,
 				   self->fw_ver_actual) == 0) {
@@ -915,11 +915,9 @@ int hw_atl_utils_hw_get_regs(struct aq_hw_s *self,
 	return 0;
 }
 
-int hw_atl_utils_get_fw_version(struct aq_hw_s *self, u32 *fw_version)
+u32 hw_atl_utils_get_fw_version(struct aq_hw_s *self)
 {
-	*fw_version = aq_hw_read_reg(self, 0x18U);
-
-	return 0;
+	return aq_hw_read_reg(self, HW_ATL_MPI_FW_VERSION);
 }
 
 static int aq_fw1x_set_wake_magic(struct aq_hw_s *self, bool wol_enabled,
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.h b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.h
index b15513914636..086627a96746 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.h
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.h
@@ -622,7 +622,7 @@ int hw_atl_utils_hw_set_power(struct aq_hw_s *self,
 
 int hw_atl_utils_hw_deinit(struct aq_hw_s *self);
 
-int hw_atl_utils_get_fw_version(struct aq_hw_s *self, u32 *fw_version);
+u32 hw_atl_utils_get_fw_version(struct aq_hw_s *self);
 
 int hw_atl_utils_update_stats(struct aq_hw_s *self);
 
-- 
2.17.1

