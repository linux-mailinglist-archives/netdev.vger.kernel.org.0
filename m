Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8211633B2D
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 12:20:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232965AbiKVLUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 06:20:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232869AbiKVLTn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 06:19:43 -0500
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD3F752884;
        Tue, 22 Nov 2022 03:15:32 -0800 (PST)
X-UUID: 0eaf27726fcf41ca96a95bffa29fc7f2-20221122
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=B1Z+g58MrUghONvFYfzTqLxyQqEgKW0qabrUwXKdlLw=;
        b=qhjNaZPxXlINBuUn/OaUn+frB4iUsMdg+yKt3hxl7FDtawC87QIFYrS0v+j013klpDbcaP+yQJey1joGoEWSTqk3jsyWnPyH9nSkj+JQaKrBTVDLnvfAaIvITgSoN/GbVMeEz2kh+ysKXyBjCztQRE0SGD+7ds4VnaFwygKkbss=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.12,REQID:8ea36e96-807a-4cb6-a46b-125b7d45f0ee,IP:0,U
        RL:0,TC:0,Content:-25,EDM:0,RT:0,SF:95,FILE:0,BULK:0,RULE:Release_Ham,ACTI
        ON:release,TS:70
X-CID-INFO: VERSION:1.1.12,REQID:8ea36e96-807a-4cb6-a46b-125b7d45f0ee,IP:0,URL
        :0,TC:0,Content:-25,EDM:0,RT:0,SF:95,FILE:0,BULK:0,RULE:Spam_GS981B3D,ACTI
        ON:quarantine,TS:70
X-CID-META: VersionHash:62cd327,CLOUDID:4c3e7f2f-2938-482e-aafd-98d66723b8a9,B
        ulkID:221122191529Z45TKU6D,BulkQuantity:0,Recheck:0,SF:38|28|17|19|48,TC:n
        il,Content:0,EDM:-3,IP:nil,URL:0,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0
X-UUID: 0eaf27726fcf41ca96a95bffa29fc7f2-20221122
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw02.mediatek.com
        (envelope-from <yanchao.yang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1633777816; Tue, 22 Nov 2022 19:15:26 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.792.15; Tue, 22 Nov 2022 19:15:24 +0800
Received: from mcddlt001.gcn.mediatek.inc (10.19.240.15) by
 mtkmbs11n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.792.15 via Frontend Transport; Tue, 22 Nov 2022 19:15:22 +0800
From:   Yanchao Yang <yanchao.yang@mediatek.com>
To:     Loic Poulain <loic.poulain@linaro.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev ML <netdev@vger.kernel.org>,
        kernel ML <linux-kernel@vger.kernel.org>
CC:     MTK ML <linux-mediatek@lists.infradead.org>,
        Liang Lu <liang.lu@mediatek.com>,
        Haijun Liu <haijun.liu@mediatek.com>,
        Hua Yang <hua.yang@mediatek.com>,
        Ting Wang <ting.wang@mediatek.com>,
        Felix Chen <felix.chen@mediatek.com>,
        Mingliang Xu <mingliang.xu@mediatek.com>,
        Min Dong <min.dong@mediatek.com>,
        Aiden Wang <aiden.wang@mediatek.com>,
        Guohao Zhang <guohao.zhang@mediatek.com>,
        Chris Feng <chris.feng@mediatek.com>,
        Yanchao Yang <yanchao.yang@mediatek.com>,
        Lambert Wang <lambert.wang@mediatek.com>,
        Mingchuang Qiao <mingchuang.qiao@mediatek.com>,
        Xiayu Zhang <xiayu.zhang@mediatek.com>,
        Haozhe Chang <haozhe.chang@mediatek.com>,
        MediaTek Corporation <linuxwwan@mediatek.com>
Subject: [PATCH net-next v1 03/13] net: wwan: tmi: Add control plane transaction layer
Date:   Tue, 22 Nov 2022 19:11:42 +0800
Message-ID: <20221122111152.160377-4-yanchao.yang@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20221122111152.160377-1-yanchao.yang@mediatek.com>
References: <20221122111152.160377-1-yanchao.yang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: MediaTek Corporation <linuxwwan@mediatek.com>

The control plane implements TX services that reside in the transaction layer.
The services receive the packets from the port layer and call the corresponding
DMA components to transmit data to the device. Meanwhile, TX services receive
and manage the port control commands from the port layer.

The control plane implements RX services that reside in the transaction layer.
The services receive the downlink packets from the modem and transfer the
packets to the corresponding port layer interfaces.

Signed-off-by: Mingliang Xu <mingliang.xu@mediatek.com>
Signed-off-by: MediaTek Corporation <linuxwwan@mediatek.com>
---
 drivers/net/wwan/mediatek/Makefile         |  3 +-
 drivers/net/wwan/mediatek/mtk_ctrl_plane.c | 62 ++++++++++++++++++++++
 drivers/net/wwan/mediatek/mtk_ctrl_plane.h | 35 ++++++++++++
 drivers/net/wwan/mediatek/mtk_dev.c        |  8 +++
 drivers/net/wwan/mediatek/mtk_dev.h        |  1 +
 5 files changed, 108 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/wwan/mediatek/mtk_ctrl_plane.c
 create mode 100644 drivers/net/wwan/mediatek/mtk_ctrl_plane.h

diff --git a/drivers/net/wwan/mediatek/Makefile b/drivers/net/wwan/mediatek/Makefile
index 122a791e1683..69a9fb7d5b96 100644
--- a/drivers/net/wwan/mediatek/Makefile
+++ b/drivers/net/wwan/mediatek/Makefile
@@ -5,7 +5,8 @@ MODULE_NAME := mtk_tmi
 mtk_tmi-y = \
 	pcie/mtk_pci.o	\
 	mtk_dev.o	\
-	mtk_bm.o
+	mtk_bm.o	\
+	mtk_ctrl_plane.o
 
 ccflags-y += -I$(srctree)/$(src)/
 ccflags-y += -I$(srctree)/$(src)/pcie/
diff --git a/drivers/net/wwan/mediatek/mtk_ctrl_plane.c b/drivers/net/wwan/mediatek/mtk_ctrl_plane.c
new file mode 100644
index 000000000000..4c8f71223a11
--- /dev/null
+++ b/drivers/net/wwan/mediatek/mtk_ctrl_plane.c
@@ -0,0 +1,62 @@
+// SPDX-License-Identifier: BSD-3-Clause-Clear
+/*
+ * Copyright (c) 2022, MediaTek Inc.
+ */
+
+#include <linux/device.h>
+#include <linux/freezer.h>
+#include <linux/kthread.h>
+#include <linux/list.h>
+#include <linux/sched.h>
+#include <linux/wait.h>
+
+#include "mtk_bm.h"
+#include "mtk_ctrl_plane.h"
+
+int mtk_ctrl_init(struct mtk_md_dev *mdev)
+{
+	struct mtk_ctrl_blk *ctrl_blk;
+	int err;
+
+	ctrl_blk = devm_kzalloc(mdev->dev, sizeof(*ctrl_blk), GFP_KERNEL);
+	if (!ctrl_blk)
+		return -ENOMEM;
+
+	ctrl_blk->mdev = mdev;
+	mdev->ctrl_blk = ctrl_blk;
+
+	ctrl_blk->bm_pool = mtk_bm_pool_create(mdev, MTK_BUFF_SKB,
+					       VQ_MTU_3_5K, BUFF_3_5K_MAX_CNT, MTK_BM_LOW_PRIO);
+	if (!ctrl_blk->bm_pool) {
+		err = -ENOMEM;
+		goto err_free_mem;
+	}
+
+	ctrl_blk->bm_pool_63K = mtk_bm_pool_create(mdev, MTK_BUFF_SKB,
+						   VQ_MTU_63K, BUFF_63K_MAX_CNT, MTK_BM_LOW_PRIO);
+
+	if (!ctrl_blk->bm_pool_63K) {
+		err = -ENOMEM;
+		goto err_destroy_pool;
+	}
+
+	return 0;
+
+err_destroy_pool:
+	mtk_bm_pool_destroy(mdev, ctrl_blk->bm_pool);
+err_free_mem:
+	devm_kfree(mdev->dev, ctrl_blk);
+
+	return err;
+}
+
+int mtk_ctrl_exit(struct mtk_md_dev *mdev)
+{
+	struct mtk_ctrl_blk *ctrl_blk = mdev->ctrl_blk;
+
+	mtk_bm_pool_destroy(mdev, ctrl_blk->bm_pool);
+	mtk_bm_pool_destroy(mdev, ctrl_blk->bm_pool_63K);
+	devm_kfree(mdev->dev, ctrl_blk);
+
+	return 0;
+}
diff --git a/drivers/net/wwan/mediatek/mtk_ctrl_plane.h b/drivers/net/wwan/mediatek/mtk_ctrl_plane.h
new file mode 100644
index 000000000000..343766a2b39e
--- /dev/null
+++ b/drivers/net/wwan/mediatek/mtk_ctrl_plane.h
@@ -0,0 +1,35 @@
+/* SPDX-License-Identifier: BSD-3-Clause-Clear
+ *
+ * Copyright (c) 2022, MediaTek Inc.
+ */
+
+#ifndef __MTK_CTRL_PLANE_H__
+#define __MTK_CTRL_PLANE_H__
+
+#include <linux/kref.h>
+#include <linux/skbuff.h>
+
+#include "mtk_dev.h"
+
+#define VQ_MTU_3_5K			(0xE00)
+#define VQ_MTU_63K			(0xFC00)
+
+#define BUFF_3_5K_MAX_CNT		(100)
+#define BUFF_63K_MAX_CNT		(64)
+
+struct mtk_ctrl_trans {
+	struct mtk_ctrl_blk *ctrl_blk;
+	struct mtk_md_dev *mdev;
+};
+
+struct mtk_ctrl_blk {
+	struct mtk_md_dev *mdev;
+	struct mtk_ctrl_trans *trans;
+	struct mtk_bm_pool *bm_pool;
+	struct mtk_bm_pool *bm_pool_63K;
+};
+
+int mtk_ctrl_init(struct mtk_md_dev *mdev);
+int mtk_ctrl_exit(struct mtk_md_dev *mdev);
+
+#endif /* __MTK_CTRL_PLANE_H__ */
diff --git a/drivers/net/wwan/mediatek/mtk_dev.c b/drivers/net/wwan/mediatek/mtk_dev.c
index 513aac37cb9c..96b111be206a 100644
--- a/drivers/net/wwan/mediatek/mtk_dev.c
+++ b/drivers/net/wwan/mediatek/mtk_dev.c
@@ -4,6 +4,7 @@
  */
 
 #include "mtk_bm.h"
+#include "mtk_ctrl_plane.h"
 #include "mtk_dev.h"
 
 int mtk_dev_init(struct mtk_md_dev *mdev)
@@ -14,12 +15,19 @@ int mtk_dev_init(struct mtk_md_dev *mdev)
 	if (ret)
 		goto err_bm_init;
 
+	ret = mtk_ctrl_init(mdev);
+	if (ret)
+		goto err_ctrl_init;
+
+err_ctrl_init:
+	mtk_bm_exit(mdev);
 err_bm_init:
 	return ret;
 }
 
 void mtk_dev_exit(struct mtk_md_dev *mdev)
 {
+	mtk_ctrl_exit(mdev);
 	mtk_bm_exit(mdev);
 }
 
diff --git a/drivers/net/wwan/mediatek/mtk_dev.h b/drivers/net/wwan/mediatek/mtk_dev.h
index 0c4b727b9c53..d6e8e9b2e52a 100644
--- a/drivers/net/wwan/mediatek/mtk_dev.h
+++ b/drivers/net/wwan/mediatek/mtk_dev.h
@@ -130,6 +130,7 @@ struct mtk_md_dev {
 	u32 hw_ver;
 	int msi_nvecs;
 	char dev_str[MTK_DEV_STR_LEN];
+	void *ctrl_blk;
 	struct mtk_bm_ctrl *bm_ctrl;
 };
 
-- 
2.32.0

