Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0201B2242C0
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 20:03:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728071AbgGQSCT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 14:02:19 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:1772 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728041AbgGQSCS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 14:02:18 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06HHvnDG010391;
        Fri, 17 Jul 2020 11:02:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=ZL19dBGjPJnvIJDF+/jrEyd3dDaKFBYvM335tnpRkSQ=;
 b=SZgvh/qzP5le2oYS38oBVaJv66wv58z1S/5c0vvkDXAkQX+HQUvicmIJFj7G34aeAZvk
 WnDvIhWA4FT2iOHrfsW0GHDaVhlkPIphQNsWEkKZlHg06yXODyw1zb1s0qj/+c/+m79Y
 vqZIwbCX+JdKQVxrJkwwvAEx+iYt62XqzC0XorfdQekEnS2yZwRZjfLJXGwHPhW7URlA
 oAEhHAc/D11c/fcuyKJvmGsXBht8lAJw5aYLFFUpoh7yggu4kB/NSuikeTupTw5IFRfW
 xnP1jNEq3COjRbc+rfrt0oS6sDCafkl5eEmTg/HyOzdFhDrtutafhzU6SZp+dY1rNo+N TA== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 328mmj5hh1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 17 Jul 2020 11:02:14 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 17 Jul
 2020 11:02:13 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 17 Jul
 2020 11:02:12 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 17 Jul 2020 11:02:12 -0700
Received: from NN-LT0044.marvell.com (unknown [10.193.54.8])
        by maili.marvell.com (Postfix) with ESMTP id 389973F7041;
        Fri, 17 Jul 2020 11:02:09 -0700 (PDT)
From:   Mark Starovoytov <mstarovoitov@marvell.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Igor Russkikh <irusskikh@marvell.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Mark Starovoytov <mstarovoitov@marvell.com>
Subject: [PATCH net-next 1/2] net: atlantic: align return value of ver_match function with function name
Date:   Fri, 17 Jul 2020 21:01:46 +0300
Message-ID: <20200717180147.8854-2-mstarovoitov@marvell.com>
X-Mailer: git-send-email 2.26.2.windows.1
In-Reply-To: <20200717180147.8854-1-mstarovoitov@marvell.com>
References: <20200717180147.8854-1-mstarovoitov@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-17_09:2020-07-17,2020-07-17 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch aligns the return value of hw_atl_utils_ver_match function with
its name.
Change the return type to bool, because it's better aligned with the actual
usage. Return true when the version matches, false otherwise.

Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 .../aquantia/atlantic/hw_atl/hw_atl_utils.c   | 29 +++++++++----------
 .../aquantia/atlantic/hw_atl/hw_atl_utils.h   |  2 +-
 .../aquantia/atlantic/hw_atl2/hw_atl2_utils.c |  3 +-
 3 files changed, 15 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
index bf4c41cc312b..22f68e4a638c 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
@@ -72,14 +72,11 @@ int hw_atl_utils_initfw(struct aq_hw_s *self, const struct aq_fw_ops **fw_ops)
 
 	self->fw_ver_actual = hw_atl_utils_get_fw_version(self);
 
-	if (hw_atl_utils_ver_match(HW_ATL_FW_VER_1X,
-				   self->fw_ver_actual) == 0) {
+	if (hw_atl_utils_ver_match(HW_ATL_FW_VER_1X, self->fw_ver_actual)) {
 		*fw_ops = &aq_fw_1x_ops;
-	} else if (hw_atl_utils_ver_match(HW_ATL_FW_VER_2X,
-					  self->fw_ver_actual) == 0) {
+	} else if (hw_atl_utils_ver_match(HW_ATL_FW_VER_2X, self->fw_ver_actual)) {
 		*fw_ops = &aq_fw_2x_ops;
-	} else if (hw_atl_utils_ver_match(HW_ATL_FW_VER_3X,
-					  self->fw_ver_actual) == 0) {
+	} else if (hw_atl_utils_ver_match(HW_ATL_FW_VER_3X, self->fw_ver_actual)) {
 		*fw_ops = &aq_fw_2x_ops;
 	} else {
 		aq_pr_err("Bad FW version detected: %x\n",
@@ -262,9 +259,9 @@ int hw_atl_utils_soft_reset(struct aq_hw_s *self)
 	/* FW 1.x may bootup in an invalid POWER state (WOL feature).
 	 * We should work around this by forcing its state back to DEINIT
 	 */
-	if (!hw_atl_utils_ver_match(HW_ATL_FW_VER_1X,
-				    aq_hw_read_reg(self,
-						   HW_ATL_MPI_FW_VERSION))) {
+	if (hw_atl_utils_ver_match(HW_ATL_FW_VER_1X,
+				   aq_hw_read_reg(self,
+						  HW_ATL_MPI_FW_VERSION))) {
 		int err = 0;
 
 		hw_atl_utils_mpi_set_state(self, MPI_DEINIT);
@@ -434,20 +431,20 @@ int hw_atl_write_fwsettings_dwords(struct aq_hw_s *self, u32 offset, u32 *p,
 					     p, cnt, MCP_AREA_SETTINGS);
 }
 
-int hw_atl_utils_ver_match(u32 ver_expected, u32 ver_actual)
+bool hw_atl_utils_ver_match(u32 ver_expected, u32 ver_actual)
 {
 	const u32 dw_major_mask = 0xff000000U;
 	const u32 dw_minor_mask = 0x00ffffffU;
-	int err = 0;
+	bool ver_match;
 
-	err = (dw_major_mask & (ver_expected ^ ver_actual)) ? -EOPNOTSUPP : 0;
-	if (err < 0)
+	ver_match = (dw_major_mask & (ver_expected ^ ver_actual)) ? false : true;
+	if (!ver_match)
 		goto err_exit;
-	err = ((dw_minor_mask & ver_expected) > (dw_minor_mask & ver_actual)) ?
-		-EOPNOTSUPP : 0;
+	ver_match = ((dw_minor_mask & ver_expected) > (dw_minor_mask & ver_actual)) ?
+		false : true;
 
 err_exit:
-	return err;
+	return ver_match;
 }
 
 static int hw_atl_utils_init_ucp(struct aq_hw_s *self,
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.h b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.h
index 0b4b54fc1de0..f5901f8e3907 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.h
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.h
@@ -635,7 +635,7 @@ int hw_atl_utils_fw_rpc_call(struct aq_hw_s *self, unsigned int rpc_size);
 int hw_atl_utils_fw_rpc_wait(struct aq_hw_s *self,
 			     struct hw_atl_utils_fw_rpc **rpc);
 
-int hw_atl_utils_ver_match(u32 ver_expected, u32 ver_actual);
+bool hw_atl_utils_ver_match(u32 ver_expected, u32 ver_actual);
 
 extern const struct aq_fw_ops aq_fw_1x_ops;
 extern const struct aq_fw_ops aq_fw_2x_ops;
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils.c
index f3766780e975..0fe6257d9c08 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils.c
@@ -36,8 +36,7 @@ int hw_atl2_utils_initfw(struct aq_hw_s *self, const struct aq_fw_ops **fw_ops)
 
 	self->fw_ver_actual = hw_atl2_utils_get_fw_version(self);
 
-	if (hw_atl_utils_ver_match(HW_ATL2_FW_VER_1X,
-				   self->fw_ver_actual) == 0) {
+	if (hw_atl_utils_ver_match(HW_ATL2_FW_VER_1X, self->fw_ver_actual)) {
 		*fw_ops = &aq_a2_fw_ops;
 	} else {
 		aq_pr_err("Bad FW version detected: %x, but continue\n",
-- 
2.25.1

