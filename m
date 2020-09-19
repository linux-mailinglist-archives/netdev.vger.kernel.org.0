Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72AA5270B7C
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 09:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726168AbgISHkH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 03:40:07 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:40330 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726041AbgISHkG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 19 Sep 2020 03:40:06 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 5814EAF5231C63F9B5B7;
        Sat, 19 Sep 2020 15:40:04 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Sat, 19 Sep 2020 15:39:54 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] net: neterion: Remove set but not used variable
Date:   Sat, 19 Sep 2020 15:40:47 +0800
Message-ID: <20200919074047.26278-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.175.138.68]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/net/ethernet/neterion/vxge/vxge-traffic.c: In function vxge_hw_vpath_intr_disable:
drivers/net/ethernet/neterion/vxge/vxge-traffic.c:160:6: warning: variable ‘val64’ set but not used [-Wunused-but-set-variable]

drivers/net/ethernet/neterion/vxge/vxge-traffic.c: In function vxge_hw_vpath_intr_enable:
drivers/net/ethernet/neterion/vxge/vxge-traffic.c:33:6: warning: variable ‘val64’ set but not used [-Wunused-but-set-variable]

drivers/net/ethernet/neterion/vxge/vxge-traffic.c: In function vxge_hw_device_flush_io:
drivers/net/ethernet/neterion/vxge/vxge-traffic.c:490:6: warning: variable ‘val32’ set but not used [-Wunused-but-set-variable]

drivers/net/ethernet/neterion/vxge/vxge-traffic.c: In function vxge_hw_vpath_poll_rx:
drivers/net/ethernet/neterion/vxge/vxge-traffic.c:2378:6: warning: variable ‘val64’ set but not used [-Wunused-but-set-variable]

these variable is never used, so remove it.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 .../net/ethernet/neterion/vxge/vxge-traffic.c    | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/neterion/vxge/vxge-traffic.c b/drivers/net/ethernet/neterion/vxge/vxge-traffic.c
index 709d20d9938f..03793e6c4a05 100644
--- a/drivers/net/ethernet/neterion/vxge/vxge-traffic.c
+++ b/drivers/net/ethernet/neterion/vxge/vxge-traffic.c
@@ -30,8 +30,6 @@
  */
 enum vxge_hw_status vxge_hw_vpath_intr_enable(struct __vxge_hw_vpath_handle *vp)
 {
-	u64 val64;
-
 	struct __vxge_hw_virtualpath *vpath;
 	struct vxge_hw_vpath_reg __iomem *vp_reg;
 	enum vxge_hw_status status = VXGE_HW_OK;
@@ -84,7 +82,7 @@ enum vxge_hw_status vxge_hw_vpath_intr_enable(struct __vxge_hw_vpath_handle *vp)
 	__vxge_hw_pio_mem_write32_upper((u32)VXGE_HW_INTR_MASK_ALL,
 			&vp_reg->xgmac_vp_int_status);
 
-	val64 = readq(&vp_reg->vpath_general_int_status);
+	readq(&vp_reg->vpath_general_int_status);
 
 	/* Mask unwanted interrupts */
 
@@ -157,8 +155,6 @@ enum vxge_hw_status vxge_hw_vpath_intr_enable(struct __vxge_hw_vpath_handle *vp)
 enum vxge_hw_status vxge_hw_vpath_intr_disable(
 			struct __vxge_hw_vpath_handle *vp)
 {
-	u64 val64;
-
 	struct __vxge_hw_virtualpath *vpath;
 	enum vxge_hw_status status = VXGE_HW_OK;
 	struct vxge_hw_vpath_reg __iomem *vp_reg;
@@ -179,7 +175,7 @@ enum vxge_hw_status vxge_hw_vpath_intr_disable(
 		(u32)VXGE_HW_INTR_MASK_ALL,
 		&vp_reg->vpath_general_int_mask);
 
-	val64 = VXGE_HW_TIM_CLR_INT_EN_VP(1 << (16 - vpath->vp_id));
+	VXGE_HW_TIM_CLR_INT_EN_VP(1 << (16 - vpath->vp_id));
 
 	writeq(VXGE_HW_INTR_MASK_ALL, &vp_reg->kdfcctl_errors_mask);
 
@@ -487,9 +483,7 @@ void vxge_hw_device_unmask_all(struct __vxge_hw_device *hldev)
  */
 void vxge_hw_device_flush_io(struct __vxge_hw_device *hldev)
 {
-	u32 val32;
-
-	val32 = readl(&hldev->common_reg->titan_general_int_status);
+	readl(&hldev->common_reg->titan_general_int_status);
 }
 
 /**
@@ -2375,7 +2369,6 @@ enum vxge_hw_status vxge_hw_vpath_poll_rx(struct __vxge_hw_ring *ring)
 	u8 t_code;
 	enum vxge_hw_status status = VXGE_HW_OK;
 	void *first_rxdh;
-	u64 val64 = 0;
 	int new_count = 0;
 
 	ring->cmpl_cnt = 0;
@@ -2403,8 +2396,7 @@ enum vxge_hw_status vxge_hw_vpath_poll_rx(struct __vxge_hw_ring *ring)
 			}
 			writeq(VXGE_HW_PRC_RXD_DOORBELL_NEW_QW_CNT(new_count),
 				&ring->vp_reg->prc_rxd_doorbell);
-			val64 =
-			  readl(&ring->common_reg->titan_general_int_status);
+			readl(&ring->common_reg->titan_general_int_status);
 			ring->doorbell_cnt = 0;
 		}
 	}
-- 
2.17.1

