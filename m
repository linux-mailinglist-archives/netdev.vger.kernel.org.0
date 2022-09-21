Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E85C5BFDEC
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 14:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230099AbiIUMci (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 08:32:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230027AbiIUMca (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 08:32:30 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2400C7E312;
        Wed, 21 Sep 2022 05:32:29 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MXd5Z2nVjzpV2Q;
        Wed, 21 Sep 2022 20:29:38 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 21 Sep
 2022 20:32:26 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <shuah@kernel.org>, <victor@mojatatu.com>
CC:     <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
        <shaozhengchao@huawei.com>
Subject: [PATCH -next, v3 03/10] net: hinic: remove unused functions
Date:   Wed, 21 Sep 2022 20:33:51 +0800
Message-ID: <20220921123358.63442-4-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220921123358.63442-1-shaozhengchao@huawei.com>
References: <20220921123358.63442-1-shaozhengchao@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hinic_hwdev_max_num_qpas() and hinic_msix_attr_get() are no longer called,
remove them. Also the macro HINIC_MSIX_ATTR_GET is also not called, remove
it.

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 .../net/ethernet/huawei/hinic/hinic_hw_dev.c  |  7 ----
 .../net/ethernet/huawei/hinic/hinic_hw_dev.h  |  2 --
 .../net/ethernet/huawei/hinic/hinic_hw_if.c   | 33 -------------------
 .../net/ethernet/huawei/hinic/hinic_hw_if.h   |  9 -----
 4 files changed, 51 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
index 641a20da6bb8..4239013a3817 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
@@ -1041,13 +1041,6 @@ void hinic_free_hwdev(struct hinic_hwdev *hwdev)
 	hinic_free_hwif(hwdev->hwif);
 }
 
-int hinic_hwdev_max_num_qps(struct hinic_hwdev *hwdev)
-{
-	struct hinic_cap *nic_cap = &hwdev->nic_cap;
-
-	return nic_cap->max_qps;
-}
-
 /**
  * hinic_hwdev_num_qps - return the number QPs available for use
  * @hwdev: the NIC HW device
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
index afa7b5e9601c..d2d89b0a5ef0 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
@@ -566,8 +566,6 @@ struct hinic_hwdev *hinic_init_hwdev(struct pci_dev *pdev, struct devlink *devli
 
 void hinic_free_hwdev(struct hinic_hwdev *hwdev);
 
-int hinic_hwdev_max_num_qps(struct hinic_hwdev *hwdev);
-
 int hinic_hwdev_num_qps(struct hinic_hwdev *hwdev);
 
 struct hinic_sq *hinic_hwdev_get_sq(struct hinic_hwdev *hwdev, int i);
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_if.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_if.c
index fe91942ff86a..88567305d06e 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_if.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_if.c
@@ -57,39 +57,6 @@ int hinic_msix_attr_set(struct hinic_hwif *hwif, u16 msix_index,
 	return 0;
 }
 
-/**
- * hinic_msix_attr_get - get message attribute of msix entry
- * @hwif: the HW interface of a pci function device
- * @msix_index: msix_index
- * @pending_limit: the maximum pending interrupt events (unit 8)
- * @coalesc_timer: coalesc period for interrupt (unit 8 us)
- * @lli_timer: replenishing period for low latency credit (unit 8 us)
- * @lli_credit_limit: maximum credits for low latency msix messages (unit 8)
- * @resend_timer: maximum wait for resending msix (unit coalesc period)
- *
- * Return 0 - Success, negative - Failure
- **/
-int hinic_msix_attr_get(struct hinic_hwif *hwif, u16 msix_index,
-			u8 *pending_limit, u8 *coalesc_timer,
-			u8 *lli_timer, u8 *lli_credit_limit,
-			u8 *resend_timer)
-{
-	u32 addr, val;
-
-	if (!VALID_MSIX_IDX(&hwif->attr, msix_index))
-		return -EINVAL;
-
-	addr = HINIC_CSR_MSIX_CTRL_ADDR(msix_index);
-	val  = hinic_hwif_read_reg(hwif, addr);
-
-	*pending_limit    = HINIC_MSIX_ATTR_GET(val, PENDING_LIMIT);
-	*coalesc_timer    = HINIC_MSIX_ATTR_GET(val, COALESC_TIMER);
-	*lli_timer        = HINIC_MSIX_ATTR_GET(val, LLI_TIMER);
-	*lli_credit_limit = HINIC_MSIX_ATTR_GET(val, LLI_CREDIT);
-	*resend_timer     = HINIC_MSIX_ATTR_GET(val, RESEND_TIMER);
-	return 0;
-}
-
 /**
  * hinic_msix_attr_cnt_clear - clear message attribute counters for msix entry
  * @hwif: the HW interface of a pci function device
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_if.h b/drivers/net/ethernet/huawei/hinic/hinic_hw_if.h
index c06f2253151e..3d588896a367 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_if.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_if.h
@@ -131,10 +131,6 @@
 	(((u32)(val) & HINIC_MSIX_##member##_MASK) <<           \
 	 HINIC_MSIX_##member##_SHIFT)
 
-#define HINIC_MSIX_ATTR_GET(val, member)                        \
-	(((val) >> HINIC_MSIX_##member##_SHIFT) &               \
-	 HINIC_MSIX_##member##_MASK)
-
 #define HINIC_MSIX_CNT_RESEND_TIMER_SHIFT                       29
 
 #define HINIC_MSIX_CNT_RESEND_TIMER_MASK                        0x1
@@ -269,11 +265,6 @@ int hinic_msix_attr_set(struct hinic_hwif *hwif, u16 msix_index,
 			u8 lli_timer_cfg, u8 lli_credit_limit,
 			u8 resend_timer);
 
-int hinic_msix_attr_get(struct hinic_hwif *hwif, u16 msix_index,
-			u8 *pending_limit, u8 *coalesc_timer_cfg,
-			u8 *lli_timer, u8 *lli_credit_limit,
-			u8 *resend_timer);
-
 void hinic_set_msix_state(struct hinic_hwif *hwif, u16 msix_idx,
 			  enum hinic_msix_state flag);
 
-- 
2.17.1

