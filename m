Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 529131BF202
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 10:05:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbgD3IFR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 04:05:17 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:17118 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726705AbgD3IFP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 04:05:15 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03U8521c011039;
        Thu, 30 Apr 2020 01:05:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=Qx0UxwssRqToObZVwutPAPRtPJd3/oakzcmmQQQ40+k=;
 b=FVcstXu6r6cQQGN+X4IRinFNNC0BfmnG74szD4ix/EDU+n428VccUiu/TrTYl3zyJJXF
 4m/BDxYXpSTdFVCJU/oS62KxOEY0m0bsLlEsOAsvSh+5bDlO1PAItE5Hs9yTGNyggttF
 y/ZBO10yKcmWyVHpP7VcCZsdpbKNyZ3jfSuWh8w0EEEHtxsMDTo1I3PNw5lRqxHWLr46
 M7ktk2z47OJwTqySM9KrNcOkpF0846RbUDzJZ+gx5kPqQTQqoKPIOBXrWQz3MmEahZza
 RNC9zLSFnALPwNhYylO2e6clQ8cm1YXwgjlA8ouN2uipsm62p+XTm0NqdEzXHKFwHmPY Tw== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 30mjjqnsk3-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 30 Apr 2020 01:05:14 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 30 Apr
 2020 01:05:12 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 30 Apr 2020 01:05:12 -0700
Received: from NN-LT0019.marvell.com (unknown [10.193.46.2])
        by maili.marvell.com (Postfix) with ESMTP id 61DA63F7044;
        Thu, 30 Apr 2020 01:05:11 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Nikita Danilov <ndanilov@marvell.com>
Subject: [PATCH v2 net-next 05/17] net: atlantic: simplify hw_get_fw_version() usage
Date:   Thu, 30 Apr 2020 11:04:33 +0300
Message-ID: <20200430080445.1142-6-irusskikh@marvell.com>
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

From: Nikita Danilov <ndanilov@marvell.com>

hw_get_fw_version() never fails, so this patch simplifies its
usage by utilizing return value instead of output argument.

Signed-off-by: Nikita Danilov <ndanilov@marvell.com>
Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
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
2.20.1

