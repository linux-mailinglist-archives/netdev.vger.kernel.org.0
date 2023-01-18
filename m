Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28B0C671BF7
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 13:23:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbjARMX3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 07:23:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229767AbjARMXF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 07:23:05 -0500
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 371B450859;
        Wed, 18 Jan 2023 03:44:10 -0800 (PST)
X-UUID: 6adeeed0972511ed945fc101203acc17-20230118
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=pKUgvxbLZX9tcX5BwsfEkkvcXvcM9UnngeQJrj/BzXU=;
        b=lcgq11MccuMuURKUIM5ReYAcv5qI5mMvQz3mmoGmYI1B6NQYxCCctwwEtfWUqEaNPDZZIIrj+8/nnQF1WYXcKQIObtXBUDdTo9qjy+BelVkmojGaV7JuYmi1LKbXE1BHAeYfUSktTc22QZTpXXhYeg9FJ+eWn+bgaLSzBBfsRpQ=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.18,REQID:3ede5187-2a33-46fc-85e1-5d361e657e1b,IP:0,U
        RL:0,TC:0,Content:-25,EDM:0,RT:0,SF:95,FILE:0,BULK:0,RULE:Release_Ham,ACTI
        ON:release,TS:70
X-CID-INFO: VERSION:1.1.18,REQID:3ede5187-2a33-46fc-85e1-5d361e657e1b,IP:0,URL
        :0,TC:0,Content:-25,EDM:0,RT:0,SF:95,FILE:0,BULK:0,RULE:Spam_GS981B3D,ACTI
        ON:quarantine,TS:70
X-CID-META: VersionHash:3ca2d6b,CLOUDID:f0822df6-ff42-4fb0-b929-626456a83c14,B
        ulkID:230118194408PV16X6HD,BulkQuantity:0,Recheck:0,SF:38|28|17|19|48,TC:n
        il,Content:0,EDM:-3,IP:nil,URL:0,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:1,OS
        I:0,OSA:0
X-CID-BVR: 2,OSH
X-UUID: 6adeeed0972511ed945fc101203acc17-20230118
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw02.mediatek.com
        (envelope-from <yanchao.yang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1670927414; Wed, 18 Jan 2023 19:44:08 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.792.3;
 Wed, 18 Jan 2023 19:44:06 +0800
Received: from mcddlt001.gcn.mediatek.inc (10.19.240.15) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.792.15 via Frontend Transport; Wed, 18 Jan 2023 19:44:04 +0800
From:   Yanchao Yang <yanchao.yang@mediatek.com>
To:     Loic Poulain <loic.poulain@linaro.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev ML <netdev@vger.kernel.org>,
        kernel ML <linux-kernel@vger.kernel.org>
CC:     Intel experts <linuxwwan@intel.com>,
        Chetan <m.chetan.kumar@intel.com>,
        MTK ML <linux-mediatek@lists.infradead.org>,
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
        "Yanchao Yang" <yanchao.yang@mediatek.com>,
        Lambert Wang <lambert.wang@mediatek.com>,
        Mingchuang Qiao <mingchuang.qiao@mediatek.com>,
        Xiayu Zhang <xiayu.zhang@mediatek.com>,
        Haozhe Chang <haozhe.chang@mediatek.com>
Subject: [PATCH net-next v2 07/12] net: wwan: tmi: Introduce data plane hardware interface
Date:   Wed, 18 Jan 2023 19:38:54 +0800
Message-ID: <20230118113859.175836-8-yanchao.yang@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20230118113859.175836-1-yanchao.yang@mediatek.com>
References: <20230118113859.175836-1-yanchao.yang@mediatek.com>
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

Data Plane Modem AP Interface (DPMAIF) hardware layer provides hardware
abstraction for the upper layer (DPMAIF HIF). It implements functions to do the
data plane hardware's configuration, TX/RX control and interrupt handling.

Signed-off-by: Yanchao Yang <yanchao.yang@mediatek.com>
Signed-off-by: Hua Yang <hua.yang@mediatek.com>
---
 drivers/net/wwan/mediatek/Makefile            |    1 +
 drivers/net/wwan/mediatek/mtk_dpmaif_drv.h    |  277 +++
 .../wwan/mediatek/pcie/mtk_dpmaif_drv_t800.c  | 2115 +++++++++++++++++
 .../wwan/mediatek/pcie/mtk_dpmaif_reg_t800.h  |  368 +++
 4 files changed, 2761 insertions(+)
 create mode 100644 drivers/net/wwan/mediatek/mtk_dpmaif_drv.h
 create mode 100644 drivers/net/wwan/mediatek/pcie/mtk_dpmaif_drv_t800.c
 create mode 100644 drivers/net/wwan/mediatek/pcie/mtk_dpmaif_reg_t800.h

diff --git a/drivers/net/wwan/mediatek/Makefile b/drivers/net/wwan/mediatek/Makefile
index a6c1252dfe46..1049b0a0a339 100644
--- a/drivers/net/wwan/mediatek/Makefile
+++ b/drivers/net/wwan/mediatek/Makefile
@@ -8,6 +8,7 @@ mtk_tmi-y = \
 	mtk_ctrl_plane.o \
 	mtk_cldma.o \
 	pcie/mtk_cldma_drv_t800.o \
+	pcie/mtk_dpmaif_drv_t800.o \
 	mtk_port.o \
 	mtk_port_io.o \
 	mtk_fsm.o
diff --git a/drivers/net/wwan/mediatek/mtk_dpmaif_drv.h b/drivers/net/wwan/mediatek/mtk_dpmaif_drv.h
new file mode 100644
index 000000000000..29b6c99bba42
--- /dev/null
+++ b/drivers/net/wwan/mediatek/mtk_dpmaif_drv.h
@@ -0,0 +1,277 @@
+/* SPDX-License-Identifier: BSD-3-Clause-Clear
+ *
+ * Copyright (c) 2022, MediaTek Inc.
+ */
+
+#ifndef __MTK_DPMAIF_DRV_H__
+#define __MTK_DPMAIF_DRV_H__
+
+enum dpmaif_drv_dir {
+	DPMAIF_TX,
+	DPMAIF_RX,
+};
+
+enum mtk_data_hw_feature_type {
+	DATA_HW_F_LRO = BIT(0),
+	DATA_HW_F_FRAG = BIT(1),
+};
+
+enum dpmaif_drv_cmd {
+	DATA_HW_INTR_COALESCE_SET,
+	DATA_HW_HASH_GET,
+	DATA_HW_HASH_SET,
+	DATA_HW_HASH_KEY_SIZE_GET,
+	DATA_HW_INDIR_GET,
+	DATA_HW_INDIR_SET,
+	DATA_HW_INDIR_SIZE_GET,
+	DATA_HW_LRO_SET,
+};
+
+struct dpmaif_drv_intr {
+	enum dpmaif_drv_dir dir;
+	unsigned int q_mask;
+	unsigned int mode;
+	unsigned int pkt_threshold;
+	unsigned int time_threshold;
+};
+
+struct dpmaif_hpc_rule {
+	unsigned int type:4;
+	unsigned int flow_lab:20; /* only use for ipv6 */
+	unsigned int hop_lim:8; /* only use for ipv6 */
+	unsigned short src_port;
+	unsigned short dst_port;
+	union{
+		struct{
+			unsigned int v4src_addr;
+			unsigned int v4dst_addr;
+			unsigned int resv[6];
+		};
+		struct{
+			unsigned int v6src_addr3;
+			unsigned int v6dst_addr3;
+			unsigned int v6src_addr0;
+			unsigned int v6src_addr1;
+			unsigned int v6src_addr2;
+			unsigned int v6dst_addr0;
+			unsigned int v6dst_addr1;
+			unsigned int v6dst_addr2;
+		};
+	};
+};
+
+enum mtk_drv_err {
+	DATA_ERR_STOP_MAX = 10,
+	DATA_HW_REG_TIMEOUT,
+	DATA_HW_REG_CHK_FAIL,
+	DATA_FLOW_CHK_ERR,
+	DATA_DMA_MAP_ERR,
+	DATA_DL_ONCE_MORE,
+	DATA_PIT_SEQ_CHK_FAIL,
+	DATA_LOW_MEM_TYPE_MAX,
+	DATA_LOW_MEM_DRB,
+	DATA_LOW_MEM_SKB,
+};
+
+#define DPMAIF_RXQ_CNT_MAX 2
+#define DPMAIF_TXQ_CNT_MAX 5
+#define DPMAIF_IRQ_CNT_MAX 3
+
+#define DPMAIF_PIT_SEQ_MAX 251
+
+#define DPMAIF_HW_PKT_ALIGN	64
+#define DPMAIF_HW_BAT_RSVLEN	0
+
+enum {
+	DPMAIF_CLEAR_INTR,
+	DPMAIF_UNMASK_INTR,
+};
+
+enum dpmaif_drv_dlq_id {
+	DPMAIF_DLQ0 = 0,
+	DPMAIF_DLQ1,
+};
+
+struct dpmaif_drv_dlq {
+	bool q_started;
+	dma_addr_t pit_base;
+	u32 pit_size;
+};
+
+struct dpmaif_drv_ulq {
+	bool q_started;
+	dma_addr_t drb_base;
+	u32 drb_size;
+};
+
+struct dpmaif_drv_data_ring {
+	dma_addr_t normal_bat_base;
+	u32 normal_bat_size;
+	dma_addr_t frag_bat_base;
+	u32 frag_bat_size;
+	u32 normal_bat_remain_size;
+	u32 normal_bat_pkt_bufsz;
+	u32 frag_bat_pkt_bufsz;
+	u32 normal_bat_rsv_length;
+	u32 pkt_bid_max_cnt;
+	u32 pkt_alignment;
+	u32 mtu;
+	u32 chk_pit_num;
+	u32 chk_normal_bat_num;
+	u32 chk_frag_bat_num;
+};
+
+struct dpmaif_drv_property {
+	u32 features;
+	struct dpmaif_drv_dlq dlq[DPMAIF_RXQ_CNT_MAX];
+	struct dpmaif_drv_ulq ulq[DPMAIF_TXQ_CNT_MAX];
+	struct dpmaif_drv_data_ring ring;
+};
+
+enum dpmaif_drv_ring_type {
+	DPMAIF_PIT,
+	DPMAIF_BAT,
+	DPMAIF_FRAG,
+	DPMAIF_DRB,
+};
+
+enum dpmaif_drv_ring_idx {
+	DPMAIF_PIT_WIDX,
+	DPMAIF_PIT_RIDX,
+	DPMAIF_BAT_WIDX,
+	DPMAIF_BAT_RIDX,
+	DPMAIF_FRAG_WIDX,
+	DPMAIF_FRAG_RIDX,
+	DPMAIF_DRB_WIDX,
+	DPMAIF_DRB_RIDX,
+};
+
+struct dpmaif_drv_irq_en_mask {
+	u32 ap_ul_l2intr_en_mask;
+	u32 ap_dl_l2intr_en_mask;
+	u32 ap_udl_ip_busy_en_mask;
+};
+
+struct dpmaif_drv_info {
+	struct mtk_md_dev *mdev;
+	bool ulq_all_enable, dlq_all_enable;
+	struct dpmaif_drv_property drv_property;
+	struct dpmaif_drv_irq_en_mask drv_irq_en_mask;
+	struct dpmaif_drv_ops *drv_ops;
+};
+
+struct dpmaif_drv_cfg {
+	dma_addr_t drb_base[DPMAIF_TXQ_CNT_MAX];
+	u32 drb_cnt[DPMAIF_TXQ_CNT_MAX];
+	dma_addr_t pit_base[DPMAIF_RXQ_CNT_MAX];
+	u32 pit_cnt[DPMAIF_RXQ_CNT_MAX];
+	dma_addr_t normal_bat_base;
+	u32 normal_bat_cnt;
+	dma_addr_t frag_bat_base;
+	u32 frag_bat_cnt;
+	u32 normal_bat_buf_size;
+	u32 frag_bat_buf_size;
+	u32 max_mtu;
+	u32 features;
+};
+
+enum dpmaif_drv_intr_type {
+	DPMAIF_INTR_MIN = 0,
+	/* uplink part */
+	DPMAIF_INTR_UL_DONE,
+	/* downlink part */
+	DPMAIF_INTR_DL_BATCNT_LEN_ERR,
+	DPMAIF_INTR_DL_FRGCNT_LEN_ERR,
+	DPMAIF_INTR_DL_PITCNT_LEN_ERR,
+	DPMAIF_INTR_DL_DONE,
+	DPMAIF_INTR_MAX
+};
+
+#define DPMAIF_INTR_COUNT ((DPMAIF_INTR_MAX) - (DPMAIF_INTR_MIN) - 1)
+
+struct dpmaif_drv_intr_info {
+	unsigned char intr_cnt;
+	enum dpmaif_drv_intr_type intr_types[DPMAIF_INTR_COUNT];
+	/* it's a queue mask or queue index */
+	u32 intr_queues[DPMAIF_INTR_COUNT];
+};
+
+/* This structure defines the management hooks for dpmaif devices. */
+struct dpmaif_drv_ops {
+	/* Initialize dpmaif hardware. */
+	int (*init)(struct dpmaif_drv_info *drv_info, void *data);
+	/* Start dpmaif hardware transaction and unmask dpmaif interrupt. */
+	int (*start_queue)(struct dpmaif_drv_info *drv_info, enum dpmaif_drv_dir dir);
+	/* Stop dpmaif hardware transaction and mask dpmaif interrupt. */
+	int (*stop_queue)(struct dpmaif_drv_info *drv_info, enum dpmaif_drv_dir dir);
+	/* Check, mask and clear the dpmaif interrupts,
+	 * and then, collect interrupt information for data plane transaction layer.
+	 */
+	int (*intr_handle)(struct dpmaif_drv_info *drv_info, void *data, u8 irq_id);
+	/* Unmask or clear dpmaif interrupt. */
+	int (*intr_complete)(struct dpmaif_drv_info *drv_info, enum dpmaif_drv_intr_type type,
+			     u8 q_id, u64 data);
+	int (*clear_ip_busy)(struct dpmaif_drv_info *drv_info);
+	int (*send_doorbell)(struct dpmaif_drv_info *drv_info, enum dpmaif_drv_ring_type type,
+			     u8 q_id, u32 cnt);
+	int (*get_ring_idx)(struct dpmaif_drv_info *drv_info, enum dpmaif_drv_ring_idx index,
+			    u8 q_id);
+	int (*feature_cmd)(struct dpmaif_drv_info *drv_info, enum dpmaif_drv_cmd cmd, void *data);
+	void (*dump)(struct dpmaif_drv_info *drv_info);
+};
+
+static inline int mtk_dpmaif_drv_init(struct dpmaif_drv_info *drv_info, void *data)
+{
+	return drv_info->drv_ops->init(drv_info, data);
+}
+
+static inline int mtk_dpmaif_drv_start_queue(struct dpmaif_drv_info *drv_info,
+					     enum dpmaif_drv_dir dir)
+{
+	return drv_info->drv_ops->start_queue(drv_info, dir);
+}
+
+static inline int mtk_dpmaif_drv_stop_queue(struct dpmaif_drv_info *drv_info,
+					    enum dpmaif_drv_dir dir)
+{
+	return drv_info->drv_ops->stop_queue(drv_info, dir);
+}
+
+static inline int mtk_dpmaif_drv_intr_handle(struct dpmaif_drv_info *drv_info,
+					     void *data, u8 irq_id)
+{
+	return drv_info->drv_ops->intr_handle(drv_info, data, irq_id);
+}
+
+static inline int mtk_dpmaif_drv_intr_complete(struct dpmaif_drv_info *drv_info,
+					       enum dpmaif_drv_intr_type type, u8 q_id, u64 data)
+{
+	return drv_info->drv_ops->intr_complete(drv_info, type, q_id, data);
+}
+
+static inline int mtk_dpmaif_drv_clear_ip_busy(struct dpmaif_drv_info *drv_info)
+{
+	return drv_info->drv_ops->clear_ip_busy(drv_info);
+}
+
+static inline int mtk_dpmaif_drv_send_doorbell(struct dpmaif_drv_info *drv_info,
+					       enum dpmaif_drv_ring_type type, u8 q_id, u32 cnt)
+{
+	return drv_info->drv_ops->send_doorbell(drv_info, type, q_id, cnt);
+}
+
+static inline int mtk_dpmaif_drv_get_ring_idx(struct dpmaif_drv_info *drv_info,
+					      enum dpmaif_drv_ring_idx index, u8 q_id)
+{
+	return drv_info->drv_ops->get_ring_idx(drv_info, index, q_id);
+}
+
+static inline int mtk_dpmaif_drv_feature_cmd(struct dpmaif_drv_info *drv_info,
+					     enum dpmaif_drv_cmd cmd, void *data)
+{
+	return drv_info->drv_ops->feature_cmd(drv_info, cmd, data);
+}
+
+extern struct dpmaif_drv_ops dpmaif_drv_ops_t800;
+
+#endif
diff --git a/drivers/net/wwan/mediatek/pcie/mtk_dpmaif_drv_t800.c b/drivers/net/wwan/mediatek/pcie/mtk_dpmaif_drv_t800.c
new file mode 100644
index 000000000000..c9a1cb431cbe
--- /dev/null
+++ b/drivers/net/wwan/mediatek/pcie/mtk_dpmaif_drv_t800.c
@@ -0,0 +1,2115 @@
+// SPDX-License-Identifier: BSD-3-Clause-Clear
+/*
+ * Copyright (c) 2022, MediaTek Inc.
+ */
+
+#include <linux/delay.h>
+#include <linux/random.h>
+
+#include "mtk_dev.h"
+#include "mtk_dpmaif_drv.h"
+#include "mtk_dpmaif_reg_t800.h"
+
+#define DRV_TO_MDEV(__drv_info) ((__drv_info)->mdev)
+
+/* 2ms -> 2 * 1000 / 10 = 200 */
+#define POLL_MAX_TIMES		200
+#define POLL_INTERVAL_US	10
+
+static void mtk_dpmaif_drv_reset(struct dpmaif_drv_info *drv_info)
+{
+	mtk_hw_write32(DRV_TO_MDEV(drv_info), DPMAIF_AP_AO_RGU_ASSERT, DPMAIF_AP_AO_RST_BIT);
+	/* Delay 2 us to wait for hardware ready. */
+	udelay(2);
+	mtk_hw_write32(DRV_TO_MDEV(drv_info), DPMAIF_AP_RGU_ASSERT, DPMAIF_AP_RST_BIT);
+	udelay(2);
+	mtk_hw_write32(DRV_TO_MDEV(drv_info), DPMAIF_AP_AO_RGU_DEASSERT, DPMAIF_AP_AO_RST_BIT);
+	udelay(2);
+	mtk_hw_write32(DRV_TO_MDEV(drv_info), DPMAIF_AP_RGU_DEASSERT, DPMAIF_AP_RST_BIT);
+	udelay(2);
+}
+
+static bool mtk_dpmaif_drv_sram_init(struct dpmaif_drv_info *drv_info)
+{
+	u32 val, cnt = 0;
+	bool ret = true;
+
+	val = mtk_hw_read32(DRV_TO_MDEV(drv_info), NRL2_DPMAIF_AP_MISC_RSTR_CLR);
+	val |= DPMAIF_MEM_CLR_MASK;
+	mtk_hw_write32(DRV_TO_MDEV(drv_info), NRL2_DPMAIF_AP_MISC_RSTR_CLR, val);
+
+	do {
+		if (!(mtk_hw_read32(DRV_TO_MDEV(drv_info), NRL2_DPMAIF_AP_MISC_RSTR_CLR) &
+		     DPMAIF_MEM_CLR_MASK))
+			break;
+
+		cnt++;
+		udelay(POLL_INTERVAL_US);
+	} while (cnt < POLL_MAX_TIMES);
+
+	if (cnt >= POLL_MAX_TIMES) {
+		dev_err(DRV_TO_MDEV(drv_info)->dev, "Failed to initialize sram.\n");
+		return false;
+	}
+	return ret;
+}
+
+static bool mtk_dpmaif_drv_config(struct dpmaif_drv_info *drv_info)
+{
+	u32 val;
+
+	/* Reset dpmaif HW setting. */
+	mtk_dpmaif_drv_reset(drv_info);
+
+	/* Initialize dpmaif sram. */
+	if (!mtk_dpmaif_drv_sram_init(drv_info))
+		return false;
+
+	/* Set DPMAIF AP port mode. */
+	val = mtk_hw_read32(DRV_TO_MDEV(drv_info), DPMAIF_AO_DL_RDY_CHK_THRES);
+	val &= ~DPMAIF_PORT_MODE_MSK;
+	val |= DPMAIF_PORT_MODE_PCIE;
+	mtk_hw_write32(DRV_TO_MDEV(drv_info), DPMAIF_AO_DL_RDY_CHK_THRES, val);
+
+	/* Set CG enable. */
+	mtk_hw_write32(DRV_TO_MDEV(drv_info), NRL2_DPMAIF_AP_MISC_CG_EN, 0x7f);
+	return true;
+}
+
+static bool mtk_dpmaif_drv_init_intr(struct dpmaif_drv_info *drv_info)
+{
+	struct dpmaif_drv_irq_en_mask *irq_en_mask;
+	u32 cnt = 0, cfg;
+
+	irq_en_mask = &drv_info->drv_irq_en_mask;
+
+	/* Set SW UL interrupt. */
+	irq_en_mask->ap_ul_l2intr_en_mask = DPMAIF_AP_UL_L2INTR_EN_MASK;
+
+	/* Clear dummy status. */
+	mtk_hw_write32(DRV_TO_MDEV(drv_info), DPMAIF_PD_AP_UL_L2TISAR0, 0xFFFFFFFF);
+
+	/* Set HW UL interrupt enable mask. */
+	mtk_hw_write32(DRV_TO_MDEV(drv_info), DPMAIF_PD_AP_UL_L2TICR0,
+		       irq_en_mask->ap_ul_l2intr_en_mask);
+	mtk_hw_write32(DRV_TO_MDEV(drv_info), DPMAIF_PD_AP_UL_L2TISR0,
+		       ~(irq_en_mask->ap_ul_l2intr_en_mask));
+	mtk_hw_read32(DRV_TO_MDEV(drv_info), DPMAIF_PD_AP_UL_L2TISR0);
+
+	/* Check UL interrupt mask set done. */
+	do {
+		if (!((mtk_hw_read32(DRV_TO_MDEV(drv_info), DPMAIF_PD_AP_UL_L2TIMR0) &
+		     irq_en_mask->ap_ul_l2intr_en_mask) == irq_en_mask->ap_ul_l2intr_en_mask))
+			break;
+
+		cnt++;
+		udelay(POLL_INTERVAL_US);
+	} while (cnt < POLL_MAX_TIMES);
+
+	if (cnt >= POLL_MAX_TIMES) {
+		dev_err(DRV_TO_MDEV(drv_info)->dev, "Failed to set UL interrupt mask.\n");
+		return false;
+	}
+
+	/* Set SW DL interrupt. */
+	irq_en_mask->ap_dl_l2intr_en_mask = DPMAIF_AP_DL_L2INTR_EN_MASK;
+
+	/* Clear dummy status. */
+	mtk_hw_write32(DRV_TO_MDEV(drv_info), DPMAIF_PD_AP_DL_L2TISAR0, 0xFFFFFFFF);
+
+	/* Set HW DL interrupt enable mask. */
+	mtk_hw_write32(DRV_TO_MDEV(drv_info), DPMAIF_PD_AP_DL_L2TISR0,
+		       ~(irq_en_mask->ap_dl_l2intr_en_mask));
+	mtk_hw_read32(DRV_TO_MDEV(drv_info), DPMAIF_PD_AP_DL_L2TISR0);
+
+	/* Check DL interrupt mask set done. */
+	cnt = 0;
+	do {
+		if (!((mtk_hw_read32(DRV_TO_MDEV(drv_info), DPMAIF_PD_AP_DL_L2TIMR0) &
+		    irq_en_mask->ap_dl_l2intr_en_mask) == irq_en_mask->ap_dl_l2intr_en_mask))
+			break;
+
+		cnt++;
+		udelay(POLL_INTERVAL_US);
+	} while (cnt < POLL_MAX_TIMES);
+
+	if (cnt >= POLL_MAX_TIMES) {
+		dev_err(DRV_TO_MDEV(drv_info)->dev, "Failed to set DL interrupt mask\n");
+		return false;
+	}
+
+	/* Set SW AP IP busy. */
+	irq_en_mask->ap_udl_ip_busy_en_mask = DPMAIF_AP_UDL_IP_BUSY_EN_MASK;
+
+	/* Clear dummy status. */
+	mtk_hw_write32(DRV_TO_MDEV(drv_info), DPMAIF_PD_AP_IP_BUSY, 0xFFFFFFFF);
+
+	/* Set HW IP busy mask. */
+	mtk_hw_write32(DRV_TO_MDEV(drv_info), DPMAIF_PD_AP_DLUL_IP_BUSY_MASK,
+		       irq_en_mask->ap_udl_ip_busy_en_mask);
+
+	/* DLQ HPC setting. */
+	cfg = mtk_hw_read32(DRV_TO_MDEV(drv_info), NRL2_DPMAIF_AO_UL_AP_L1TIMR0);
+	cfg |= DPMAIF_DL_INT_Q2APTOP_MSK | DPMAIF_DL_INT_Q2TOQ1_MSK | DPMAIF_UL_TOP0_INT_MSK;
+	mtk_hw_write32(DRV_TO_MDEV(drv_info), NRL2_DPMAIF_AO_UL_AP_L1TIMR0, cfg);
+	mtk_hw_write32(DRV_TO_MDEV(drv_info), NRL2_DPMAIF_HPC_INTR_MASK, 0xffff);
+
+	dev_info(DRV_TO_MDEV(drv_info)->dev,
+		 "ul_mask=0x%08x, dl_mask=0x%08x, busy_mask=0x%08x\n",
+		 irq_en_mask->ap_ul_l2intr_en_mask,
+		 irq_en_mask->ap_dl_l2intr_en_mask,
+		 irq_en_mask->ap_udl_ip_busy_en_mask);
+	return true;
+}
+
+static void mtk_dpmaif_drv_set_property(struct dpmaif_drv_info *drv_info,
+					struct dpmaif_drv_cfg *drv_cfg)
+{
+	struct dpmaif_drv_property *drv_property = &drv_info->drv_property;
+	struct dpmaif_drv_data_ring *ring;
+	struct dpmaif_drv_dlq *dlq;
+	struct dpmaif_drv_ulq *ulq;
+	u32 i;
+
+	drv_property->features = drv_cfg->features;
+
+	for (i = 0; i < DPMAIF_DLQ_NUM; i++) {
+		dlq = &drv_property->dlq[i];
+		dlq->pit_base = drv_cfg->pit_base[i];
+		dlq->pit_size = drv_cfg->pit_cnt[i];
+		dlq->q_started = true;
+	}
+
+	for (i = 0; i < DPMAIF_ULQ_NUM; i++) {
+		ulq = &drv_property->ulq[i];
+		ulq->drb_base = drv_cfg->drb_base[i];
+		ulq->drb_size = drv_cfg->drb_cnt[i];
+		ulq->q_started = true;
+	}
+
+	ring = &drv_property->ring;
+
+	/* Normal bat setting. */
+	ring->normal_bat_base = drv_cfg->normal_bat_base;
+	ring->normal_bat_size = drv_cfg->normal_bat_cnt;
+	ring->normal_bat_pkt_bufsz = drv_cfg->normal_bat_buf_size;
+	ring->normal_bat_remain_size = DPMAIF_HW_BAT_REMAIN;
+	ring->normal_bat_rsv_length = DPMAIF_HW_BAT_RSVLEN;
+	ring->chk_normal_bat_num = DPMAIF_HW_CHK_BAT_NUM;
+
+	/* Frag bat setting. */
+	if (drv_property->features & DATA_HW_F_FRAG) {
+		ring->frag_bat_base = drv_cfg->frag_bat_base;
+		ring->frag_bat_size = drv_cfg->frag_bat_cnt;
+		ring->frag_bat_pkt_bufsz = drv_cfg->frag_bat_buf_size;
+		ring->chk_frag_bat_num = DPMAIF_HW_CHK_FRG_NUM;
+	}
+
+	ring->mtu = drv_cfg->max_mtu;
+	ring->pkt_bid_max_cnt = DPMAIF_HW_PKT_BIDCNT;
+	ring->pkt_alignment = DPMAIF_HW_PKT_ALIGN;
+	ring->chk_pit_num = DPMAIF_HW_CHK_PIT_NUM;
+}
+
+static void mtk_dpmaif_drv_init_common_hw(struct dpmaif_drv_info *drv_info)
+{
+	u32 val;
+
+	/* Config PCIe mode. */
+	mtk_hw_write32(DRV_TO_MDEV(drv_info), NRL2_DPMAIF_UL_RESERVE_AO_RW,
+		       DPMAIF_PCIE_MODE_SET_VALUE);
+
+	/* Bat cache enable. */
+	val = mtk_hw_read32(DRV_TO_MDEV(drv_info), DPMAIF_PD_DL_BAT_INIT_CON1);
+	val |= DPMAIF_DL_BAT_CACHE_PRI;
+	mtk_hw_write32(DRV_TO_MDEV(drv_info), DPMAIF_PD_DL_BAT_INIT_CON1, val);
+
+	/* Pit burst enable. */
+	val = mtk_hw_read32(DRV_TO_MDEV(drv_info), DPMAIF_AO_DL_RDY_CHK_THRES);
+	val |= DPMAIF_DL_BURST_PIT_EN;
+	mtk_hw_write32(DRV_TO_MDEV(drv_info), DPMAIF_AO_DL_RDY_CHK_THRES, val);
+}
+
+static void mtk_dpmaif_drv_set_hpc_cntl(struct dpmaif_drv_info *drv_info)
+{
+	u32 cfg = 0;
+
+	cfg = (DPMAIF_HPC_LRO_PATH_DF & 0x3) << 0;
+	cfg |= (DPMAIF_HPC_ADD_MODE_DF & 0x3) << 2;
+	cfg |= (DPMAIF_HASH_PRIME_DF & 0xf) << 4;
+	cfg |= (DPMAIF_HPC_TOTAL_NUM & 0xff) << 8;
+
+	/* Configuration include hpc dlq path,
+	 * hpc add mode, hash prime, hpc total number.
+	 */
+	mtk_hw_write32(DRV_TO_MDEV(drv_info), NRL2_DPMAIF_AO_DL_HPC_CNTL, cfg);
+}
+
+static void mtk_dpmaif_drv_set_agg_cfg(struct dpmaif_drv_info *drv_info)
+{
+	u32 cfg;
+
+	cfg = (DPMAIF_AGG_MAX_LEN_DF & 0xffff) << 0;
+	cfg |= (DPMAIF_AGG_TBL_ENT_NUM_DF & 0xffff) << 16;
+
+	/* Configuration include agg max length, agg table number. */
+	mtk_hw_write32(DRV_TO_MDEV(drv_info), NRL2_DPMAIF_AO_DL_LRO_AGG_CFG, cfg);
+
+	/* enable/disable AGG */
+	cfg = mtk_hw_read32(DRV_TO_MDEV(drv_info), NRL2_DPMAIF_AO_DL_RDY_CHK_FRG_THRES);
+	if (drv_info->drv_property.features & DATA_HW_F_LRO)
+		mtk_hw_write32(DRV_TO_MDEV(drv_info),
+			       NRL2_DPMAIF_AO_DL_RDY_CHK_FRG_THRES, cfg | (0xff << 20));
+	else
+		mtk_hw_write32(DRV_TO_MDEV(drv_info),
+			       NRL2_DPMAIF_AO_DL_RDY_CHK_FRG_THRES, cfg & 0xf00fffff);
+}
+
+static void mtk_dpmaif_drv_set_hash_bit_choose(struct dpmaif_drv_info *drv_info)
+{
+	u32 cfg;
+
+	cfg = (DPMAIF_LRO_HASH_BIT_CHOOSE_DF & 0x7) << 0;
+	mtk_hw_write32(DRV_TO_MDEV(drv_info), NRL2_DPMAIF_AO_DL_LROPIT_INIT_CON5, cfg);
+}
+
+static void mtk_dpmaif_drv_set_mid_pit_timeout_threshold(struct dpmaif_drv_info *drv_info)
+{
+	mtk_hw_write32(DRV_TO_MDEV(drv_info), NRL2_DPMAIF_AO_DL_LROPIT_TIMEOUT0,
+		       DPMAIF_MID_TIMEOUT_THRES_DF);
+}
+
+static void mtk_dpmaif_drv_set_dlq_timeout_threshold(struct dpmaif_drv_info *drv_info)
+{
+	u32 val, i;
+
+	for (i = 0; i < DPMAIF_HPC_MAX_TOTAL_NUM; i++) {
+		val = mtk_hw_read32(DRV_TO_MDEV(drv_info),
+				    NRL2_DPMAIF_AO_DL_LROPIT_TIMEOUT1 + 4 * (i / 2));
+
+		if (i % 2)
+			val = (val & 0xFFFF) | (DPMAIF_LRO_TIMEOUT_THRES_DF << 16);
+		else
+			val = (val & 0xFFFF0000) | (DPMAIF_LRO_TIMEOUT_THRES_DF);
+
+		mtk_hw_write32(DRV_TO_MDEV(drv_info),
+			       NRL2_DPMAIF_AO_DL_LROPIT_TIMEOUT1 + (4 * (i / 2)), val);
+	}
+}
+
+static void mtk_dpmaif_drv_set_dlq_start_prs_threshold(struct dpmaif_drv_info *drv_info)
+{
+	mtk_hw_write32(DRV_TO_MDEV(drv_info), NRL2_DPMAIF_AO_DL_LROPIT_TRIG_THRES,
+		       DPMAIF_LRO_PRS_THRES_DF & 0x3FFFF);
+}
+
+static void mtk_dpmaif_drv_toeplitz_hash_enable(struct dpmaif_drv_info *drv_info, u32 enable)
+{
+	mtk_hw_write32(DRV_TO_MDEV(drv_info), NRL2_REG_TOE_HASH_EN, enable);
+}
+
+static void mtk_dpmaif_drv_hash_default_value_set(struct dpmaif_drv_info *drv_info, u32 hash)
+{
+	u32 val = mtk_hw_read32(DRV_TO_MDEV(drv_info), NRL2_REG_HASH_CFG_CON);
+
+	mtk_hw_write32(DRV_TO_MDEV(drv_info), NRL2_REG_HASH_CFG_CON,
+		       (val & DPMAIF_HASH_DEFAULT_V_MASK) | hash);
+}
+
+static int mtk_dpmaif_drv_hash_sec_key_set(struct dpmaif_drv_info *drv_info, u8 *hash_key)
+{
+	u32 i, cnt = 0;
+	u32 index;
+	u32 val;
+
+	for (i = 0; i < DPMAIF_HASH_SEC_KEY_NUM / 4; i++) {
+		index = i << 2;
+		val = hash_key[index] << 24 | hash_key[index + 1] << 16 |
+			hash_key[index + 2] << 8 | hash_key[index + 3];
+		mtk_hw_write32(DRV_TO_MDEV(drv_info), NRL2_REG_HASH_SEC_KEY_0 + index, val);
+	}
+
+	mtk_hw_write32(DRV_TO_MDEV(drv_info), NRL2_REG_HASH_SEC_KEY_UPD, 1);
+
+	do {
+		if (!(mtk_hw_read32(DRV_TO_MDEV(drv_info), NRL2_REG_HASH_SEC_KEY_UPD)))
+			break;
+
+		cnt++;
+		udelay(POLL_INTERVAL_US);
+	} while (cnt < POLL_MAX_TIMES);
+
+	if (cnt >= POLL_MAX_TIMES)
+		return -DATA_HW_REG_TIMEOUT;
+
+	return 0;
+}
+
+static int mtk_dpmaif_drv_hash_sec_key_get(struct dpmaif_drv_info *drv_info, u8 *hash_key)
+{
+	u32 index;
+	u32 val;
+	u32 i;
+
+	for (i = 0; i < DPMAIF_HASH_SEC_KEY_NUM / 4; i++) {
+		index = i << 2;
+		val = mtk_hw_read32(DRV_TO_MDEV(drv_info), NRL2_REG_HASH_SEC_KEY_0 + index);
+		hash_key[index] = val >> 24 & 0xff;
+		hash_key[index + 1] = val >> 16 & 0xff;
+		hash_key[index + 2] = val >> 8 & 0xff;
+		hash_key[index + 3] = val & 0xff;
+	}
+
+	return 0;
+}
+
+static void mtk_dpmaif_drv_hash_bit_mask_set(struct dpmaif_drv_info *drv_info, u32 mask)
+{
+	u32 val = mtk_hw_read32(DRV_TO_MDEV(drv_info), NRL2_REG_HASH_CFG_CON);
+
+	mtk_hw_write32(DRV_TO_MDEV(drv_info), NRL2_REG_HASH_CFG_CON,
+		       (val & DPMAIF_HASH_BIT_MASK) | (mask << 8));
+}
+
+static void mtk_dpmaif_drv_hash_indir_mask_set(struct dpmaif_drv_info *drv_info, u32 mask)
+{
+	u32 val = mtk_hw_read32(DRV_TO_MDEV(drv_info), NRL2_REG_HASH_CFG_CON);
+
+	mtk_hw_write32(DRV_TO_MDEV(drv_info), NRL2_REG_HASH_CFG_CON,
+		       (val & DPMAIF_HASH_INDR_MASK) | (mask << 16));
+}
+
+static u32 mtk_dpmaif_drv_hash_indir_mask_get(struct dpmaif_drv_info *drv_info)
+{
+	u32 val = mtk_hw_read32(DRV_TO_MDEV(drv_info), NRL2_REG_HASH_CFG_CON);
+
+	return (val & (~DPMAIF_HASH_INDR_MASK)) >> 16;
+}
+
+static void mtk_dpmaif_drv_hpc_stats_thres_set(struct dpmaif_drv_info *drv_info, u32 thres)
+{
+	mtk_hw_write32(DRV_TO_MDEV(drv_info), NRL2_REG_HPC_STATS_THRES, thres);
+}
+
+static void mtk_dpmaif_drv_hpc_stats_time_cfg_set(struct dpmaif_drv_info *drv_info, u32 time_cfg)
+{
+	mtk_hw_write32(DRV_TO_MDEV(drv_info), NRL2_REG_HPC_STATS_TIMER_CFG, time_cfg);
+}
+
+static void mtk_dpmaif_drv_init_dl_hpc_hw(struct dpmaif_drv_info *drv_info)
+{
+	u8 hash_key[DPMAIF_HASH_SEC_KEY_NUM];
+
+	mtk_dpmaif_drv_set_hpc_cntl(drv_info);
+	mtk_dpmaif_drv_set_agg_cfg(drv_info);
+	mtk_dpmaif_drv_set_hash_bit_choose(drv_info);
+	mtk_dpmaif_drv_set_mid_pit_timeout_threshold(drv_info);
+	mtk_dpmaif_drv_set_dlq_timeout_threshold(drv_info);
+	mtk_dpmaif_drv_set_dlq_start_prs_threshold(drv_info);
+	mtk_dpmaif_drv_toeplitz_hash_enable(drv_info, DPMAIF_TOEPLITZ_HASH_EN);
+	mtk_dpmaif_drv_hash_default_value_set(drv_info, DPMAIF_HASH_DEFAULT_VALUE);
+	get_random_bytes(hash_key, sizeof(hash_key));
+	mtk_dpmaif_drv_hash_sec_key_set(drv_info, hash_key);
+	mtk_dpmaif_drv_hash_bit_mask_set(drv_info, DPMAIF_HASH_BIT_MASK_DF);
+	mtk_dpmaif_drv_hash_indir_mask_set(drv_info, DPMAIF_HASH_INDR_MASK_DF);
+	mtk_dpmaif_drv_hpc_stats_thres_set(drv_info, DPMAIF_HPC_STATS_THRESHOLD);
+	mtk_dpmaif_drv_hpc_stats_time_cfg_set(drv_info, DPMAIF_HPC_STATS_TIMER_CFG);
+}
+
+static void mtk_dpmaif_drv_dl_set_ao_remain_minsz(struct dpmaif_drv_info *drv_info, u32 sz)
+{
+	u32 val;
+
+	val = mtk_hw_read32(DRV_TO_MDEV(drv_info), DPMAIF_AO_DL_PKTINFO_CONO);
+	val &= ~DPMAIF_BAT_REMAIN_MINSZ_MSK;
+	val |= ((sz / DPMAIF_BAT_REMAIN_SZ_BASE) << 8) & DPMAIF_BAT_REMAIN_MINSZ_MSK;
+	mtk_hw_write32(DRV_TO_MDEV(drv_info), DPMAIF_AO_DL_PKTINFO_CONO, val);
+}
+
+static void mtk_dpmaif_drv_dl_set_ao_bat_bufsz(struct dpmaif_drv_info *drv_info, u32 buf_sz)
+{
+	u32 val;
+
+	val = mtk_hw_read32(DRV_TO_MDEV(drv_info), DPMAIF_AO_DL_PKTINFO_CON2);
+	val &= ~DPMAIF_BAT_BUF_SZ_MSK;
+	val |= ((buf_sz / DPMAIF_BAT_BUFFER_SZ_BASE) << 8) & DPMAIF_BAT_BUF_SZ_MSK;
+	mtk_hw_write32(DRV_TO_MDEV(drv_info), DPMAIF_AO_DL_PKTINFO_CON2, val);
+}
+
+static void mtk_dpmaif_drv_dl_set_ao_bat_rsv_length(struct dpmaif_drv_info *drv_info, u32 length)
+{
+	u32 val;
+
+	val = mtk_hw_read32(DRV_TO_MDEV(drv_info), DPMAIF_AO_DL_PKTINFO_CON2);
+	val &= ~DPMAIF_BAT_RSV_LEN_MSK;
+	val |= length & DPMAIF_BAT_RSV_LEN_MSK;
+	mtk_hw_write32(DRV_TO_MDEV(drv_info), DPMAIF_AO_DL_PKTINFO_CON2, val);
+}
+
+static void mtk_dpmaif_drv_dl_set_ao_bid_maxcnt(struct dpmaif_drv_info *drv_info, u32 cnt)
+{
+	u32 val;
+
+	val = mtk_hw_read32(DRV_TO_MDEV(drv_info), DPMAIF_AO_DL_PKTINFO_CONO);
+	val &= ~DPMAIF_BAT_BID_MAXCNT_MSK;
+	val |= (cnt << 16) & DPMAIF_BAT_BID_MAXCNT_MSK;
+	mtk_hw_write32(DRV_TO_MDEV(drv_info), DPMAIF_AO_DL_PKTINFO_CONO, val);
+}
+
+static void mtk_dpmaif_drv_dl_set_pkt_alignment(struct dpmaif_drv_info *drv_info,
+						bool enable, u32 mode)
+{
+	u32 val;
+
+	val = mtk_hw_read32(DRV_TO_MDEV(drv_info), DPMAIF_AO_DL_RDY_CHK_THRES);
+	val &= ~DPMAIF_PKT_ALIGN_MSK;
+	if (enable) {
+		val |= DPMAIF_PKT_ALIGN_EN;
+		val |= (mode << 22) & DPMAIF_PKT_ALIGN_MSK;
+	}
+	mtk_hw_write32(DRV_TO_MDEV(drv_info), DPMAIF_AO_DL_RDY_CHK_THRES, val);
+}
+
+static void mtk_dpmaif_drv_dl_set_pit_seqnum(struct dpmaif_drv_info *drv_info, u32 seq)
+{
+	u32 val;
+
+	val = mtk_hw_read32(DRV_TO_MDEV(drv_info), NRL2_DPMAIF_AO_DL_PIT_SEQ_END);
+	val &= ~DPMAIF_DL_PIT_SEQ_MSK;
+	val |= seq & DPMAIF_DL_PIT_SEQ_MSK;
+	mtk_hw_write32(DRV_TO_MDEV(drv_info), NRL2_DPMAIF_AO_DL_PIT_SEQ_END, val);
+}
+
+static void mtk_dpmaif_drv_dl_set_ao_mtu(struct dpmaif_drv_info *drv_info, u32 mtu_sz)
+{
+	mtk_hw_write32(DRV_TO_MDEV(drv_info), DPMAIF_AO_DL_PKTINFO_CON1, mtu_sz);
+}
+
+static void mtk_dpmaif_drv_dl_set_ao_pit_chknum(struct dpmaif_drv_info *drv_info, u32 number)
+{
+	u32 val;
+
+	val = mtk_hw_read32(DRV_TO_MDEV(drv_info), DPMAIF_AO_DL_PKTINFO_CON2);
+	val &= ~DPMAIF_PIT_CHK_NUM_MSK;
+	val |= (number << 24) & DPMAIF_PIT_CHK_NUM_MSK;
+	mtk_hw_write32(DRV_TO_MDEV(drv_info), DPMAIF_AO_DL_PKTINFO_CON2, val);
+}
+
+static void mtk_dpmaif_drv_dl_set_ao_bat_check_threshold(struct dpmaif_drv_info *drv_info, u32 size)
+{
+	u32 val;
+
+	val = mtk_hw_read32(DRV_TO_MDEV(drv_info), DPMAIF_AO_DL_RDY_CHK_THRES);
+	val &= ~DPMAIF_BAT_CHECK_THRES_MSK;
+	val |= (size << 16) & DPMAIF_BAT_CHECK_THRES_MSK;
+	mtk_hw_write32(DRV_TO_MDEV(drv_info), DPMAIF_AO_DL_RDY_CHK_THRES, val);
+}
+
+static void mtk_dpmaif_drv_dl_frg_ao_en(struct dpmaif_drv_info *drv_info, bool enable)
+{
+	u32 val;
+
+	val = mtk_hw_read32(DRV_TO_MDEV(drv_info), DPMAIF_AO_DL_FRG_CHK_THRES);
+	if (enable)
+		val |= DPMAIF_FRG_EN_MSK;
+	else
+		val &= ~DPMAIF_FRG_EN_MSK;
+	mtk_hw_write32(DRV_TO_MDEV(drv_info), DPMAIF_AO_DL_FRG_CHK_THRES, val);
+}
+
+static void mtk_dpmaif_drv_dl_set_ao_frg_bufsz(struct dpmaif_drv_info *drv_info, u32 buf_sz)
+{
+	u32 val;
+
+	val = mtk_hw_read32(DRV_TO_MDEV(drv_info), DPMAIF_AO_DL_FRG_CHK_THRES);
+	val &= ~DPMAIF_FRG_BUF_SZ_MSK;
+	val |= ((buf_sz / DPMAIF_FRG_BUFFER_SZ_BASE) << 8) & DPMAIF_FRG_BUF_SZ_MSK;
+	mtk_hw_write32(DRV_TO_MDEV(drv_info), DPMAIF_AO_DL_FRG_CHK_THRES, val);
+}
+
+static void mtk_dpmaif_drv_dl_set_ao_frg_check_threshold(struct dpmaif_drv_info *drv_info, u32 size)
+{
+	u32 val;
+
+	val = mtk_hw_read32(DRV_TO_MDEV(drv_info), DPMAIF_AO_DL_FRG_CHK_THRES);
+	val &= ~DPMAIF_FRG_CHECK_THRES_MSK;
+	val |= size & DPMAIF_FRG_CHECK_THRES_MSK;
+	mtk_hw_write32(DRV_TO_MDEV(drv_info), DPMAIF_AO_DL_FRG_CHK_THRES, val);
+}
+
+static void mtk_dpmaif_drv_dl_set_bat_base_addr(struct dpmaif_drv_info *drv_info, u64 addr)
+{
+	u32 lb_addr = (u32)(addr & 0xFFFFFFFF);
+	u32 hb_addr = (u32)(addr >> 32);
+
+	mtk_hw_write32(DRV_TO_MDEV(drv_info), DPMAIF_PD_DL_BAT_INIT_CON0, lb_addr);
+	mtk_hw_write32(DRV_TO_MDEV(drv_info), DPMAIF_PD_DL_BAT_INIT_CON3, hb_addr);
+}
+
+static void mtk_dpmaif_drv_dl_set_bat_size(struct dpmaif_drv_info *drv_info, u32 size)
+{
+	u32 val;
+
+	val = mtk_hw_read32(DRV_TO_MDEV(drv_info), DPMAIF_PD_DL_BAT_INIT_CON1);
+	val &= ~DPMAIF_BAT_SIZE_MSK;
+	val |= size & DPMAIF_BAT_SIZE_MSK;
+	mtk_hw_write32(DRV_TO_MDEV(drv_info), DPMAIF_PD_DL_BAT_INIT_CON1, val);
+}
+
+static void mtk_dpmaif_drv_dl_bat_en(struct dpmaif_drv_info *drv_info, bool enable)
+{
+	u32 val;
+
+	val = mtk_hw_read32(DRV_TO_MDEV(drv_info), DPMAIF_PD_DL_BAT_INIT_CON1);
+	if (enable)
+		val |= DPMAIF_BAT_EN_MSK;
+	else
+		val &= ~DPMAIF_BAT_EN_MSK;
+	mtk_hw_write32(DRV_TO_MDEV(drv_info), DPMAIF_PD_DL_BAT_INIT_CON1, val);
+}
+
+static void mtk_dpmaif_drv_dl_bat_init_done(struct dpmaif_drv_info *drv_info, bool frag_en)
+{
+	u32 cnt = 0, dl_bat_init;
+
+	dl_bat_init = DPMAIF_DL_BAT_INIT_ALLSET;
+	dl_bat_init |= DPMAIF_DL_BAT_INIT_EN;
+
+	if (frag_en)
+		dl_bat_init |= DPMAIF_DL_BAT_FRG_INIT;
+
+	do {
+		if (!(mtk_hw_read32(DRV_TO_MDEV(drv_info), DPMAIF_PD_DL_BAT_INIT) &
+		      DPMAIF_DL_BAT_INIT_NOT_READY)) {
+			mtk_hw_write32(DRV_TO_MDEV(drv_info), DPMAIF_PD_DL_BAT_INIT, dl_bat_init);
+			break;
+		}
+		cnt++;
+		udelay(POLL_INTERVAL_US);
+	} while (cnt < POLL_MAX_TIMES);
+
+	if (cnt >= POLL_MAX_TIMES) {
+		dev_err(DRV_TO_MDEV(drv_info)->dev, "Failed to initialize bat.\n");
+		return;
+	}
+
+	cnt = 0;
+	do {
+		if (!((mtk_hw_read32(DRV_TO_MDEV(drv_info), DPMAIF_PD_DL_BAT_INIT) &
+		    DPMAIF_DL_BAT_INIT_NOT_READY) == DPMAIF_DL_BAT_INIT_NOT_READY))
+			break;
+
+		cnt++;
+		udelay(POLL_INTERVAL_US);
+	} while (cnt < POLL_MAX_TIMES);
+
+	if (cnt >= POLL_MAX_TIMES) {
+		dev_err(DRV_TO_MDEV(drv_info)->dev, "Initialize bat is not ready.\n");
+		return;
+	}
+}
+
+static void mtk_dpmaif_drv_dl_set_pit_base_addr(struct dpmaif_drv_info *drv_info, u64 addr)
+{
+	u32 lb_addr = (u32)(addr & 0xFFFFFFFF);
+	u32 hb_addr = (u32)(addr >> 32);
+
+	mtk_hw_write32(DRV_TO_MDEV(drv_info), NRL2_DPMAIF_DL_LROPIT_INIT_CON0, lb_addr);
+	mtk_hw_write32(DRV_TO_MDEV(drv_info), NRL2_DPMAIF_DL_LROPIT_INIT_CON4, hb_addr);
+}
+
+static void mtk_dpmaif_drv_dl_set_pit_size(struct dpmaif_drv_info *drv_info, u32 size)
+{
+	u32 val;
+
+	val = mtk_hw_read32(DRV_TO_MDEV(drv_info), NRL2_DPMAIF_DL_LROPIT_INIT_CON1);
+	val &= ~DPMAIF_PIT_SIZE_MSK;
+	val |= size & DPMAIF_PIT_SIZE_MSK;
+	mtk_hw_write32(DRV_TO_MDEV(drv_info), NRL2_DPMAIF_DL_LROPIT_INIT_CON1, val);
+
+	mtk_hw_write32(DRV_TO_MDEV(drv_info), NRL2_DPMAIF_DL_LROPIT_INIT_CON2, 0);
+	mtk_hw_write32(DRV_TO_MDEV(drv_info), NRL2_DPMAIF_DL_LROPIT_INIT_CON3, 0);
+	mtk_hw_write32(DRV_TO_MDEV(drv_info), NRL2_DPMAIF_DL_LROPIT_INIT_CON5, 0);
+	mtk_hw_write32(DRV_TO_MDEV(drv_info), NRL2_DPMAIF_DL_LROPIT_INIT_CON6, 0);
+}
+
+static void mtk_dpmaif_drv_dl_pit_en(struct dpmaif_drv_info *drv_info, bool enable)
+{
+	u32 val;
+
+	val = mtk_hw_read32(DRV_TO_MDEV(drv_info), NRL2_DPMAIF_DL_LROPIT_INIT_CON3);
+	if (enable)
+		val |= DPMAIF_LROPIT_EN_MSK;
+	else
+		val &= ~DPMAIF_LROPIT_EN_MSK;
+	mtk_hw_write32(DRV_TO_MDEV(drv_info), NRL2_DPMAIF_DL_LROPIT_INIT_CON3, val);
+}
+
+static void mtk_dpmaif_drv_dl_pit_init_done(struct dpmaif_drv_info *drv_info, u32 pit_idx)
+{
+	int cnt = 0, dl_pit_init;
+
+	dl_pit_init = DPMAIF_DL_PIT_INIT_ALLSET;
+	dl_pit_init |= pit_idx << DPMAIF_LROPIT_CHAN_OFS;
+	dl_pit_init |= DPMAIF_DL_PIT_INIT_EN;
+
+	do {
+		if (!(mtk_hw_read32(DRV_TO_MDEV(drv_info), NRL2_DPMAIF_DL_LROPIT_INIT) &
+			DPMAIF_DL_PIT_INIT_NOT_READY)) {
+			mtk_hw_write32(DRV_TO_MDEV(drv_info),
+				       NRL2_DPMAIF_DL_LROPIT_INIT, dl_pit_init);
+			break;
+		}
+		udelay(POLL_INTERVAL_US);
+		cnt++;
+	} while (cnt < POLL_MAX_TIMES);
+
+	if (cnt >= POLL_MAX_TIMES) {
+		dev_err(DRV_TO_MDEV(drv_info)->dev, "Failed to initialize pit.\n");
+		return;
+	}
+
+	cnt = 0;
+	do {
+		if (!((mtk_hw_read32(DRV_TO_MDEV(drv_info), NRL2_DPMAIF_DL_LROPIT_INIT) &
+		    DPMAIF_DL_PIT_INIT_NOT_READY) == DPMAIF_DL_PIT_INIT_NOT_READY))
+			break;
+
+		udelay(POLL_INTERVAL_US);
+		cnt++;
+	} while (cnt < POLL_MAX_TIMES);
+
+	if (cnt >= POLL_MAX_TIMES) {
+		dev_err(DRV_TO_MDEV(drv_info)->dev, "Initialize pit is not ready.\n");
+		return;
+	}
+}
+
+static void mtk_dpmaif_drv_config_dlq_pit_hw(struct dpmaif_drv_info *drv_info, u8 q_num,
+					     struct dpmaif_drv_dlq *dlq)
+{
+	mtk_dpmaif_drv_dl_set_pit_base_addr(drv_info, (u64)dlq->pit_base);
+	mtk_dpmaif_drv_dl_set_pit_size(drv_info, dlq->pit_size);
+	mtk_dpmaif_drv_dl_pit_en(drv_info, true);
+	mtk_dpmaif_drv_dl_pit_init_done(drv_info, q_num);
+}
+
+static int mtk_dpmaif_drv_dlq_all_en(struct dpmaif_drv_info *drv_info, bool enable)
+{
+	u32 val, dl_bat_init, cnt = 0;
+
+	val = mtk_hw_read32(DRV_TO_MDEV(drv_info), DPMAIF_PD_DL_BAT_INIT_CON1);
+
+	if (enable)
+		val |= DPMAIF_BAT_EN_MSK;
+	else
+		val &= ~DPMAIF_BAT_EN_MSK;
+
+	mtk_hw_write32(DRV_TO_MDEV(drv_info), DPMAIF_PD_DL_BAT_INIT_CON1, val);
+	mtk_hw_read32(DRV_TO_MDEV(drv_info), DPMAIF_PD_DL_BAT_INIT_CON1);
+
+	dl_bat_init = DPMAIF_DL_BAT_INIT_ONLY_ENABLE_BIT;
+	dl_bat_init |= DPMAIF_DL_BAT_INIT_EN;
+
+	/* Update DL bat setting to HW */
+	do {
+		if (!(mtk_hw_read32(DRV_TO_MDEV(drv_info), DPMAIF_PD_DL_BAT_INIT) &
+			DPMAIF_DL_BAT_INIT_NOT_READY)) {
+			mtk_hw_write32(DRV_TO_MDEV(drv_info), DPMAIF_PD_DL_BAT_INIT, dl_bat_init);
+			break;
+		}
+		udelay(POLL_INTERVAL_US);
+		cnt++;
+	} while (cnt < POLL_MAX_TIMES);
+
+	if (cnt >= POLL_MAX_TIMES) {
+		dev_err(DRV_TO_MDEV(drv_info)->dev, "Failed to enable all dl queue.\n");
+		return -DATA_HW_REG_TIMEOUT;
+	}
+
+	/* Wait HW update done */
+	cnt = 0;
+	do {
+		if (!((mtk_hw_read32(DRV_TO_MDEV(drv_info), DPMAIF_PD_DL_BAT_INIT) &
+		    DPMAIF_DL_BAT_INIT_NOT_READY) == DPMAIF_DL_BAT_INIT_NOT_READY))
+			break;
+
+		udelay(POLL_INTERVAL_US);
+		cnt++;
+	} while (cnt < POLL_MAX_TIMES);
+
+	if (cnt >= POLL_MAX_TIMES) {
+		dev_err(DRV_TO_MDEV(drv_info)->dev, "Enable all dl queue is not ready.\n");
+		return -DATA_HW_REG_TIMEOUT;
+	}
+
+	return 0;
+}
+
+static bool mtk_dpmaif_drv_dl_idle_check(struct dpmaif_drv_info *drv_info)
+{
+	bool is_idle = false;
+	u32 dl_dbg_sta;
+
+	dl_dbg_sta = mtk_hw_read32(DRV_TO_MDEV(drv_info), DPMAIF_PD_DL_DBG_STA1);
+
+	/* If all the queues are idle, DL idle is true. */
+	if ((dl_dbg_sta & DPMAIF_DL_IDLE_STS) == DPMAIF_DL_IDLE_STS)
+		is_idle = true;
+
+	return is_idle;
+}
+
+static u32 mtk_dpmaif_drv_dl_get_wridx(struct dpmaif_drv_info *drv_info)
+{
+	return ((mtk_hw_read32(DRV_TO_MDEV(drv_info), DPMAIF_AO_DL_PIT_STA3)) &
+		DPMAIF_DL_PIT_WRIDX_MSK);
+}
+
+static u32 mtk_dpmaif_drv_dl_get_pit_ridx(struct dpmaif_drv_info *drv_info)
+{
+	return ((mtk_hw_read32(DRV_TO_MDEV(drv_info), DPMAIF_AO_DL_PIT_STA2)) &
+		DPMAIF_DL_PIT_WRIDX_MSK);
+}
+
+static void mtk_dpmaif_drv_dl_set_pkt_checksum(struct dpmaif_drv_info *drv_info)
+{
+	u32 val;
+
+	val = mtk_hw_read32(DRV_TO_MDEV(drv_info), DPMAIF_AO_DL_RDY_CHK_THRES);
+	val |= DPMAIF_DL_PKT_CHECKSUM_EN;
+	mtk_hw_write32(DRV_TO_MDEV(drv_info), DPMAIF_AO_DL_RDY_CHK_THRES, val);
+}
+
+static bool mtk_dpmaif_drv_config_dlq_hw(struct dpmaif_drv_info *drv_info)
+{
+	struct dpmaif_drv_property *drv_property = &drv_info->drv_property;
+	struct dpmaif_drv_data_ring *ring = &drv_property->ring;
+	struct dpmaif_drv_dlq *dlq;
+	u32 i;
+
+	mtk_dpmaif_drv_init_dl_hpc_hw(drv_info);
+	mtk_dpmaif_drv_dl_set_ao_remain_minsz(drv_info, ring->normal_bat_remain_size);
+	mtk_dpmaif_drv_dl_set_ao_bat_bufsz(drv_info, ring->normal_bat_pkt_bufsz);
+	mtk_dpmaif_drv_dl_set_ao_bat_rsv_length(drv_info, ring->normal_bat_rsv_length);
+	mtk_dpmaif_drv_dl_set_ao_bid_maxcnt(drv_info, ring->pkt_bid_max_cnt);
+
+	if (ring->pkt_alignment == 64)
+		mtk_dpmaif_drv_dl_set_pkt_alignment(drv_info, true, DPMAIF_PKT_ALIGN64_MODE);
+	else if (ring->pkt_alignment == 128)
+		mtk_dpmaif_drv_dl_set_pkt_alignment(drv_info, true, DPMAIF_PKT_ALIGN128_MODE);
+	else
+		mtk_dpmaif_drv_dl_set_pkt_alignment(drv_info, false, 0);
+
+	mtk_dpmaif_drv_dl_set_pit_seqnum(drv_info, DPMAIF_PIT_SEQ_MAX);
+	mtk_dpmaif_drv_dl_set_ao_mtu(drv_info, ring->mtu);
+	mtk_dpmaif_drv_dl_set_ao_pit_chknum(drv_info, ring->chk_pit_num);
+	mtk_dpmaif_drv_dl_set_ao_bat_check_threshold(drv_info, ring->chk_normal_bat_num);
+
+	/* Initialize frag bat. */
+	if (drv_property->features & DATA_HW_F_FRAG) {
+		mtk_dpmaif_drv_dl_frg_ao_en(drv_info, true);
+		mtk_dpmaif_drv_dl_set_ao_frg_bufsz(drv_info, ring->frag_bat_pkt_bufsz);
+		mtk_dpmaif_drv_dl_set_ao_frg_check_threshold(drv_info, ring->chk_frag_bat_num);
+		mtk_dpmaif_drv_dl_set_bat_base_addr(drv_info, (u64)ring->frag_bat_base);
+		mtk_dpmaif_drv_dl_set_bat_size(drv_info, ring->frag_bat_size);
+		mtk_dpmaif_drv_dl_bat_en(drv_info, true);
+		mtk_dpmaif_drv_dl_bat_init_done(drv_info, true);
+	}
+
+	/* Initialize normal bat. */
+	mtk_dpmaif_drv_dl_set_bat_base_addr(drv_info, (u64)ring->normal_bat_base);
+	mtk_dpmaif_drv_dl_set_bat_size(drv_info, ring->normal_bat_size);
+	mtk_dpmaif_drv_dl_bat_en(drv_info, false);
+	mtk_dpmaif_drv_dl_bat_init_done(drv_info, false);
+
+	/* Initialize pit information. */
+	for (i = 0; i < DPMAIF_DLQ_NUM; i++) {
+		dlq = &drv_property->dlq[i];
+		mtk_dpmaif_drv_config_dlq_pit_hw(drv_info, i, dlq);
+	}
+
+	if (mtk_dpmaif_drv_dlq_all_en(drv_info, true))
+		return false;
+	mtk_dpmaif_drv_dl_set_pkt_checksum(drv_info);
+	return true;
+}
+
+static void mtk_dpmaif_drv_ul_update_drb_size(struct dpmaif_drv_info *drv_info, u8 q_num, u32 size)
+{
+	u32 old_size;
+	u64 addr;
+
+	addr = DPMAIF_UL_DRBSIZE_ADDRH_N(q_num);
+
+	old_size = mtk_hw_read32(DRV_TO_MDEV(drv_info), addr);
+	old_size &= ~DPMAIF_DRB_SIZE_MSK;
+	old_size |= size & DPMAIF_DRB_SIZE_MSK;
+	mtk_hw_write32(DRV_TO_MDEV(drv_info), addr, old_size);
+}
+
+static void mtk_dpmaif_drv_ul_update_drb_base_addr(struct dpmaif_drv_info *drv_info,
+						   u8 q_num, u64 addr)
+{
+	u32 lb_addr = (u32)(addr & 0xFFFFFFFF);
+	u32 hb_addr = (u32)(addr >> 32);
+
+	mtk_hw_write32(DRV_TO_MDEV(drv_info), DPMAIF_ULQSAR_N(q_num), lb_addr);
+	mtk_hw_write32(DRV_TO_MDEV(drv_info), DPMAIF_UL_DRB_ADDRH_N(q_num), hb_addr);
+}
+
+static void mtk_dpmaif_drv_ul_rdy_en(struct dpmaif_drv_info *drv_info, u8 q_num, bool ready)
+{
+	u32 ul_rdy_en;
+
+	ul_rdy_en = mtk_hw_read32(DRV_TO_MDEV(drv_info), DPMAIF_PD_UL_CHNL_ARB0);
+	if (ready)
+		ul_rdy_en |= (1 << q_num);
+	else
+		ul_rdy_en &= ~(1 << q_num);
+
+	mtk_hw_write32(DRV_TO_MDEV(drv_info), DPMAIF_PD_UL_CHNL_ARB0, ul_rdy_en);
+}
+
+static void mtk_dpmaif_drv_ul_arb_en(struct dpmaif_drv_info *drv_info, u8 q_num, bool enable)
+{
+	u32 ul_arb_en;
+
+	ul_arb_en = mtk_hw_read32(DRV_TO_MDEV(drv_info), DPMAIF_PD_UL_CHNL_ARB0);
+	if (enable)
+		ul_arb_en |= (1 << (q_num + 8));
+	else
+		ul_arb_en &= ~(1 << (q_num + 8));
+
+	mtk_hw_write32(DRV_TO_MDEV(drv_info), DPMAIF_PD_UL_CHNL_ARB0, ul_arb_en);
+}
+
+static void mtk_dpmaif_drv_config_ulq_hw(struct dpmaif_drv_info *drv_info)
+{
+	struct dpmaif_drv_ulq *ulq;
+	u32 i;
+
+	for (i = 0; i < DPMAIF_ULQ_NUM; i++) {
+		ulq = &drv_info->drv_property.ulq[i];
+		mtk_dpmaif_drv_ul_update_drb_size(drv_info, i,
+						  (ulq->drb_size * DPMAIF_UL_DRB_ENTRY_WORD));
+		mtk_dpmaif_drv_ul_update_drb_base_addr(drv_info, i, (u64)ulq->drb_base);
+		mtk_dpmaif_drv_ul_rdy_en(drv_info, i, true);
+		mtk_dpmaif_drv_ul_arb_en(drv_info, i, true);
+	}
+}
+
+static bool mtk_dpmaif_drv_init_done(struct dpmaif_drv_info *drv_info)
+{
+	u32 val, cnt = 0;
+
+	/* Sync default value to SRAM. */
+	val = mtk_hw_read32(DRV_TO_MDEV(drv_info), NRL2_DPMAIF_AP_MISC_OVERWRITE_CFG);
+	val |= DPMAIF_SRAM_SYNC_MASK;
+	mtk_hw_write32(DRV_TO_MDEV(drv_info), NRL2_DPMAIF_AP_MISC_OVERWRITE_CFG, val);
+	do {
+		if (!(mtk_hw_read32(DRV_TO_MDEV(drv_info), NRL2_DPMAIF_AP_MISC_OVERWRITE_CFG) &
+		    DPMAIF_SRAM_SYNC_MASK))
+			break;
+
+		udelay(POLL_INTERVAL_US);
+		cnt++;
+	} while (cnt < POLL_MAX_TIMES);
+
+	if (cnt >= POLL_MAX_TIMES) {
+		dev_err(DRV_TO_MDEV(drv_info)->dev, "Failed to sync default value to sram\n");
+		return false;
+	}
+
+	/* UL configure done. */
+	mtk_hw_write32(DRV_TO_MDEV(drv_info), NRL2_DPMAIF_AO_UL_INIT_SET, DPMAIF_UL_INIT_DONE_MASK);
+
+	/* DL configure done. */
+	mtk_hw_write32(DRV_TO_MDEV(drv_info), NRL2_DPMAIF_AO_DL_INIT_SET, DPMAIF_DL_INIT_DONE_MASK);
+	return true;
+}
+
+static bool mtk_dpmaif_drv_cfg_hw(struct dpmaif_drv_info *drv_info)
+{
+	mtk_dpmaif_drv_init_common_hw(drv_info);
+	if (!mtk_dpmaif_drv_config_dlq_hw(drv_info))
+		return false;
+	mtk_dpmaif_drv_config_ulq_hw(drv_info);
+	if (!mtk_dpmaif_drv_init_done(drv_info))
+		return false;
+
+	drv_info->ulq_all_enable = true;
+	drv_info->dlq_all_enable = true;
+
+	return true;
+}
+
+static void mtk_dpmaif_drv_clr_ul_all_intr(struct dpmaif_drv_info *drv_info)
+{
+	mtk_hw_write32(DRV_TO_MDEV(drv_info), DPMAIF_PD_AP_UL_L2TISAR0, 0xFFFFFFFF);
+}
+
+static void mtk_dpmaif_drv_clr_dl_all_intr(struct dpmaif_drv_info *drv_info)
+{
+	mtk_hw_write32(DRV_TO_MDEV(drv_info), DPMAIF_PD_AP_DL_L2TISAR0, 0xFFFFFFFF);
+}
+
+static int mtk_dpmaif_drv_init_t800(struct dpmaif_drv_info *drv_info, void *data)
+{
+	struct dpmaif_drv_cfg *drv_cfg = data;
+
+	if (!drv_cfg) {
+		dev_err(DRV_TO_MDEV(drv_info)->dev, "Invalid parameter\n");
+		return -DATA_FLOW_CHK_ERR;
+	}
+
+	/* Initialize port mode and clock. */
+	if (!mtk_dpmaif_drv_config(drv_info))
+		return DATA_HW_REG_CHK_FAIL;
+
+	/* Initialize dpmaif interrupt. */
+	if (!mtk_dpmaif_drv_init_intr(drv_info))
+		return DATA_HW_REG_CHK_FAIL;
+
+	/* Get initialization information from trans layer. */
+	mtk_dpmaif_drv_set_property(drv_info, drv_cfg);
+
+	/* Configure HW queue setting. */
+	if (!mtk_dpmaif_drv_cfg_hw(drv_info))
+		return DATA_HW_REG_CHK_FAIL;
+
+	/* Clear all interrupt status. */
+	mtk_dpmaif_drv_clr_ul_all_intr(drv_info);
+	mtk_dpmaif_drv_clr_dl_all_intr(drv_info);
+
+	return 0;
+}
+
+static int mtk_dpmaif_drv_ulq_all_en(struct dpmaif_drv_info *drv_info, bool enable)
+{
+	u32 ul_arb_en;
+
+	ul_arb_en = mtk_hw_read32(DRV_TO_MDEV(drv_info), DPMAIF_PD_UL_CHNL_ARB0);
+	if (enable)
+		ul_arb_en |= DPMAIF_UL_ALL_QUE_ARB_EN;
+	else
+		ul_arb_en &= ~DPMAIF_UL_ALL_QUE_ARB_EN;
+
+	mtk_hw_write32(DRV_TO_MDEV(drv_info), DPMAIF_PD_UL_CHNL_ARB0, ul_arb_en);
+	mtk_hw_read32(DRV_TO_MDEV(drv_info), DPMAIF_PD_UL_CHNL_ARB0);
+
+	return 0;
+}
+
+static bool mtk_dpmaif_drv_ul_all_idle_check(struct dpmaif_drv_info *drv_info)
+{
+	bool is_idle = false;
+	u32 ul_dbg_sta;
+
+	ul_dbg_sta = mtk_hw_read32(DRV_TO_MDEV(drv_info), DPMAIF_PD_UL_DBG_STA2);
+	/* If all the queues are idle, UL idle is true. */
+	if ((ul_dbg_sta & DPMAIF_UL_IDLE_STS_MSK) == DPMAIF_UL_IDLE_STS)
+		is_idle = true;
+
+	return is_idle;
+}
+
+static int mtk_dpmaif_drv_unmask_ulq_intr(struct dpmaif_drv_info *drv_info, u32 q_num)
+{
+	u32 ui_que_done_mask;
+
+	ui_que_done_mask = (1 << (q_num + DP_UL_INT_DONE_OFFSET)) & DPMAIF_UL_INT_QDONE_MSK;
+	drv_info->drv_irq_en_mask.ap_ul_l2intr_en_mask |= ui_que_done_mask;
+	mtk_hw_write32(DRV_TO_MDEV(drv_info), DPMAIF_PD_AP_UL_L2TICR0, ui_que_done_mask);
+
+	return 0;
+}
+
+static int mtk_dpmaif_drv_ul_unmask_all_tx_done_intr(struct dpmaif_drv_info *drv_info)
+{
+	int ret;
+	u8 i;
+
+	for (i = 0; i < DPMAIF_ULQ_NUM; i++) {
+		ret = mtk_dpmaif_drv_unmask_ulq_intr(drv_info, i);
+		if (ret < 0)
+			break;
+	}
+
+	return ret;
+}
+
+static int mtk_dpmaif_drv_dl_unmask_rx_done_intr(struct dpmaif_drv_info *drv_info, u8 qno)
+{
+	u32 di_que_done_mask;
+
+	if (qno == DPMAIF_DLQ0)
+		di_que_done_mask = DPMAIF_DL_INT_DLQ0_QDONE_MSK;
+	else
+		di_que_done_mask = DPMAIF_DL_INT_DLQ1_QDONE_MSK;
+
+	drv_info->drv_irq_en_mask.ap_dl_l2intr_en_mask |= di_que_done_mask;
+	mtk_hw_write32(DRV_TO_MDEV(drv_info), DPMAIF_PD_AP_DL_L2TICR0, di_que_done_mask);
+
+	return 0;
+}
+
+static int mtk_dpmaif_drv_dl_unmask_all_rx_done_intr(struct dpmaif_drv_info *drv_info)
+{
+	int ret;
+	u8 i;
+
+	for (i = 0; i < DPMAIF_DLQ_NUM; i++) {
+		ret = mtk_dpmaif_drv_dl_unmask_rx_done_intr(drv_info, i);
+		if (ret < 0)
+			break;
+	}
+
+	return ret;
+}
+
+static int mtk_dpmaif_drv_dlq_mask_rx_done_intr(struct dpmaif_drv_info *drv_info, u8 qno)
+{
+	u32 cnt = 0, di_que_done_mask;
+
+	if (qno == DPMAIF_DLQ0)
+		di_que_done_mask = DPMAIF_DL_INT_DLQ0_QDONE_MSK;
+	else
+		di_que_done_mask = DPMAIF_DL_INT_DLQ1_QDONE_MSK;
+	mtk_hw_write32(DRV_TO_MDEV(drv_info), DPMAIF_PD_AP_DL_L2TISR0, di_que_done_mask);
+	mtk_hw_read32(DRV_TO_MDEV(drv_info), DPMAIF_PD_AP_DL_L2TISR0);
+
+	/* Check mask status. */
+	do {
+		if (!((mtk_hw_read32(DRV_TO_MDEV(drv_info), DPMAIF_PD_AP_DL_L2TIMR0) &
+		    di_que_done_mask) != di_que_done_mask))
+			break;
+
+		dev_err(DRV_TO_MDEV(drv_info)->dev, "Failed to mask dlq%u interrupt done-0x%08x\n",
+			qno, mtk_hw_read32(DRV_TO_MDEV(drv_info), DPMAIF_PD_AP_DL_L2TIMR0));
+		udelay(POLL_INTERVAL_US);
+		cnt++;
+	} while (cnt < POLL_MAX_TIMES);
+
+	if (cnt >= POLL_MAX_TIMES) {
+		dev_err(DRV_TO_MDEV(drv_info)->dev, "Failed to mask dlq0 interrupt done\n");
+		return -DATA_HW_REG_TIMEOUT;
+	}
+
+	drv_info->drv_irq_en_mask.ap_dl_l2intr_en_mask &= ~di_que_done_mask;
+
+	return 0;
+}
+
+static int mtk_dpmaif_drv_dl_mask_all_rx_done_intr(struct dpmaif_drv_info *drv_info)
+{
+	int ret;
+	u8 i;
+
+	for (i = 0; i < DPMAIF_DLQ_NUM; i++) {
+		ret = mtk_dpmaif_drv_dlq_mask_rx_done_intr(drv_info, i);
+		if (ret < 0)
+			break;
+	}
+
+	return ret;
+}
+
+static void mtk_dpmaif_drv_mask_dl_batcnt_len_err_intr(struct dpmaif_drv_info *drv_info, u32 q_num)
+{
+	drv_info->drv_irq_en_mask.ap_dl_l2intr_en_mask &= ~DPMAIF_DL_INT_BATCNT_LEN_ERR_MSK;
+	mtk_hw_write32(DRV_TO_MDEV(drv_info), DPMAIF_PD_AP_DL_L2TISR0,
+		       DPMAIF_DL_INT_BATCNT_LEN_ERR_MSK);
+	mtk_hw_read32(DRV_TO_MDEV(drv_info), DPMAIF_PD_AP_DL_L2TISR0);
+}
+
+static void mtk_dpmaif_drv_unmask_dl_batcnt_len_err_intr(struct dpmaif_drv_info *drv_info)
+{
+	drv_info->drv_irq_en_mask.ap_dl_l2intr_en_mask |= DPMAIF_DL_INT_BATCNT_LEN_ERR_MSK;
+	mtk_hw_write32(DRV_TO_MDEV(drv_info), DPMAIF_PD_AP_DL_L2TICR0,
+		       DPMAIF_DL_INT_BATCNT_LEN_ERR_MSK);
+}
+
+static int mtk_dpmaif_drv_mask_dl_frgcnt_len_err_intr(struct dpmaif_drv_info *drv_info, u32 q_num)
+{
+	drv_info->drv_irq_en_mask.ap_dl_l2intr_en_mask &= ~DPMAIF_DL_INT_FRG_LEN_ERR_MSK;
+	mtk_hw_write32(DRV_TO_MDEV(drv_info), DPMAIF_PD_AP_DL_L2TISR0,
+		       DPMAIF_DL_INT_FRG_LEN_ERR_MSK);
+	mtk_hw_read32(DRV_TO_MDEV(drv_info), DPMAIF_PD_AP_DL_L2TISR0);
+
+	return 0;
+}
+
+static void mtk_dpmaif_drv_unmask_dl_frgcnt_len_err_intr(struct dpmaif_drv_info *drv_info)
+{
+	drv_info->drv_irq_en_mask.ap_dl_l2intr_en_mask |= DPMAIF_DL_INT_FRG_LEN_ERR_MSK;
+	mtk_hw_write32(DRV_TO_MDEV(drv_info), DPMAIF_PD_AP_DL_L2TICR0,
+		       DPMAIF_DL_INT_FRG_LEN_ERR_MSK);
+}
+
+static int mtk_dpmaif_drv_dlq_mask_pit_cnt_len_err_intr(struct dpmaif_drv_info *drv_info, u8 qno)
+{
+	if (qno == DPMAIF_DLQ0)
+		mtk_hw_write32(DRV_TO_MDEV(drv_info), NRL2_DPMAIF_AO_UL_APDL_L2TIMSR0,
+			       DPMAIF_DL_INT_DLQ0_PITCNT_LEN_ERR_MSK);
+	else
+		mtk_hw_write32(DRV_TO_MDEV(drv_info), NRL2_DPMAIF_AO_UL_APDL_L2TIMSR0,
+			       DPMAIF_DL_INT_DLQ1_PITCNT_LEN_ERR_MSK);
+
+	mtk_hw_read32(DRV_TO_MDEV(drv_info), NRL2_DPMAIF_AO_UL_APDL_L2TIMSR0);
+
+	return 0;
+}
+
+static int mtk_dpmaif_drv_dlq_unmask_pit_cnt_len_err_intr(struct dpmaif_drv_info *drv_info, u8 qno)
+{
+	if (qno == DPMAIF_DLQ0)
+		mtk_hw_write32(DRV_TO_MDEV(drv_info), NRL2_DPMAIF_AO_UL_APDL_L2TIMCR0,
+			       DPMAIF_DL_INT_DLQ0_PITCNT_LEN_ERR_MSK);
+	else
+		mtk_hw_write32(DRV_TO_MDEV(drv_info), NRL2_DPMAIF_AO_UL_APDL_L2TIMCR0,
+			       DPMAIF_DL_INT_DLQ1_PITCNT_LEN_ERR_MSK);
+
+	return 0;
+}
+
+static int mtk_dpmaif_drv_start_queue_t800(struct dpmaif_drv_info *drv_info,
+					   enum dpmaif_drv_dir dir)
+{
+	int ret;
+
+	if (dir == DPMAIF_TX) {
+		if (unlikely(drv_info->ulq_all_enable)) {
+			dev_info(DRV_TO_MDEV(drv_info)->dev, "ulq all enabled\n");
+			return 0;
+		}
+
+		ret = mtk_dpmaif_drv_ulq_all_en(drv_info, true);
+		if (ret < 0)
+			return ret;
+
+		ret = mtk_dpmaif_drv_ul_unmask_all_tx_done_intr(drv_info);
+		if (ret < 0)
+			return ret;
+
+		drv_info->ulq_all_enable = true;
+	} else {
+		if (unlikely(drv_info->dlq_all_enable)) {
+			dev_info(DRV_TO_MDEV(drv_info)->dev, "dlq all enabled\n");
+			return 0;
+		}
+
+		ret = mtk_dpmaif_drv_dlq_all_en(drv_info, true);
+		if (ret < 0)
+			return ret;
+
+		ret = mtk_dpmaif_drv_dl_unmask_all_rx_done_intr(drv_info);
+		if (ret < 0)
+			return ret;
+
+		drv_info->dlq_all_enable = true;
+	}
+
+	return 0;
+}
+
+static int mtk_dpmaif_drv_stop_ulq(struct dpmaif_drv_info *drv_info)
+{
+	int cnt = 0;
+
+	/* Disable HW arb and check idle. */
+	mtk_dpmaif_drv_ulq_all_en(drv_info, false);
+	do {
+		if (++cnt >= POLL_MAX_TIMES) {
+			dev_err(DRV_TO_MDEV(drv_info)->dev, "Failed to stop ul queue, 0x%x\n",
+				mtk_hw_read32(DRV_TO_MDEV(drv_info), DPMAIF_PD_UL_DBG_STA2));
+			return -DATA_HW_REG_TIMEOUT;
+		}
+		udelay(POLL_INTERVAL_US);
+	} while (!mtk_dpmaif_drv_ul_all_idle_check(drv_info));
+
+	return 0;
+}
+
+static int mtk_dpmaif_drv_mask_ulq_intr(struct dpmaif_drv_info *drv_info, u32 q_num)
+{
+	u32 cnt = 0, ui_que_done_mask;
+
+	ui_que_done_mask = (1 << (q_num + DP_UL_INT_DONE_OFFSET)) & DPMAIF_UL_INT_QDONE_MSK;
+
+	mtk_hw_write32(DRV_TO_MDEV(drv_info), DPMAIF_PD_AP_UL_L2TISR0, ui_que_done_mask);
+	mtk_hw_read32(DRV_TO_MDEV(drv_info), DPMAIF_PD_AP_UL_L2TISR0);
+
+	do {
+		if (!((mtk_hw_read32(DRV_TO_MDEV(drv_info), DPMAIF_PD_AP_UL_L2TIMR0) &
+		    ui_que_done_mask) != ui_que_done_mask))
+			break;
+
+		dev_err(DRV_TO_MDEV(drv_info)->dev,
+			"Failed to mask ul%u interrupt done-0x%08x\n", q_num,
+			mtk_hw_read32(DRV_TO_MDEV(drv_info), DPMAIF_PD_AP_UL_L2TIMR0));
+		udelay(POLL_INTERVAL_US);
+		cnt++;
+	} while (cnt < POLL_MAX_TIMES);
+
+	if (cnt >= POLL_MAX_TIMES) {
+		dev_err(DRV_TO_MDEV(drv_info)->dev, "Failed to mask dlq0 interrupt done\n");
+		return -DATA_HW_REG_TIMEOUT;
+	}
+	drv_info->drv_irq_en_mask.ap_ul_l2intr_en_mask &= ~ui_que_done_mask;
+
+	return 0;
+}
+
+static void mtk_dpmaif_drv_ul_mask_multi_tx_done_intr(struct dpmaif_drv_info *drv_info, u8 q_mask)
+{
+	u32 i;
+
+	for (i = 0; i < DPMAIF_ULQ_NUM; i++) {
+		if (q_mask & (1 << i))
+			mtk_dpmaif_drv_mask_ulq_intr(drv_info, i);
+	}
+}
+
+static int mtk_dpmaif_drv_ul_mask_all_tx_done_intr(struct dpmaif_drv_info *drv_info)
+{
+	int ret;
+	u8 i;
+
+	for (i = 0; i < DPMAIF_ULQ_NUM; i++) {
+		ret = mtk_dpmaif_drv_mask_ulq_intr(drv_info, i);
+		if (ret < 0)
+			break;
+	}
+
+	return ret;
+}
+
+static int mtk_dpmaif_drv_stop_dlq(struct dpmaif_drv_info *drv_info)
+{
+	u32 cnt = 0, wridx, ridx;
+
+	/* Disable HW arb and check idle. */
+	mtk_dpmaif_drv_dlq_all_en(drv_info, false);
+	do {
+		if (++cnt >= POLL_MAX_TIMES) {
+			dev_err(DRV_TO_MDEV(drv_info)->dev, "Failed to stop dl queue, 0x%x\n",
+				mtk_hw_read32(DRV_TO_MDEV(drv_info), DPMAIF_PD_DL_DBG_STA1));
+			return -DATA_HW_REG_TIMEOUT;
+		}
+		udelay(POLL_INTERVAL_US);
+	} while (!mtk_dpmaif_drv_dl_idle_check(drv_info));
+
+	/* Check middle pit sync done. */
+	cnt = 0;
+	do {
+		wridx = mtk_dpmaif_drv_dl_get_wridx(drv_info);
+		ridx = mtk_dpmaif_drv_dl_get_pit_ridx(drv_info);
+		if (wridx == ridx)
+			break;
+
+		udelay(POLL_INTERVAL_US);
+		cnt++;
+	} while (cnt < POLL_MAX_TIMES);
+
+	if (cnt >= POLL_MAX_TIMES) {
+		dev_err(DRV_TO_MDEV(drv_info)->dev, "Failed to check middle pit sync\n");
+		return -DATA_HW_REG_TIMEOUT;
+	}
+
+	return 0;
+}
+
+static int mtk_dpmaif_drv_stop_queue_t800(struct dpmaif_drv_info *drv_info, enum dpmaif_drv_dir dir)
+{
+	int ret;
+
+	if (dir == DPMAIF_TX) {
+		if (unlikely(!drv_info->ulq_all_enable)) {
+			dev_info(DRV_TO_MDEV(drv_info)->dev, "ulq all disabled\n");
+			return 0;
+		}
+
+		ret = mtk_dpmaif_drv_stop_ulq(drv_info);
+		if (ret < 0)
+			return ret;
+
+		ret = mtk_dpmaif_drv_ul_mask_all_tx_done_intr(drv_info);
+		if (ret < 0)
+			return ret;
+
+		drv_info->ulq_all_enable = false;
+	} else {
+		if (unlikely(!drv_info->dlq_all_enable)) {
+			dev_info(DRV_TO_MDEV(drv_info)->dev, "dlq all disabled\n");
+			return 0;
+		}
+
+		ret = mtk_dpmaif_drv_stop_dlq(drv_info);
+		if (ret < 0)
+			return ret;
+
+		ret = mtk_dpmaif_drv_dl_mask_all_rx_done_intr(drv_info);
+		if (ret < 0)
+			return ret;
+
+		drv_info->dlq_all_enable = false;
+	}
+
+	return 0;
+}
+
+static u32 mtk_dpmaif_drv_get_dl_lv2_sts(struct dpmaif_drv_info *drv_info)
+{
+	return mtk_hw_read32(DRV_TO_MDEV(drv_info), DPMAIF_PD_AP_DL_L2TISAR0);
+}
+
+static u32 mtk_dpmaif_drv_get_ul_lv2_sts(struct dpmaif_drv_info *drv_info)
+{
+	return mtk_hw_read32(DRV_TO_MDEV(drv_info), DPMAIF_PD_AP_UL_L2TISAR0);
+}
+
+static u32 mtk_dpmaif_drv_get_ul_intr_mask(struct dpmaif_drv_info *drv_info)
+{
+	return mtk_hw_read32(DRV_TO_MDEV(drv_info), DPMAIF_PD_AP_UL_L2TIMR0);
+}
+
+static u32 mtk_dpmaif_drv_get_dl_intr_mask(struct dpmaif_drv_info *drv_info)
+{
+	return mtk_hw_read32(DRV_TO_MDEV(drv_info), DPMAIF_PD_AP_DL_L2TIMR0);
+}
+
+static bool mtk_dpmaif_drv_check_clr_ul_done_status(struct dpmaif_drv_info *drv_info, u8 qno)
+{
+	u32 val, l2tisar0;
+	bool ret = false;
+	/* get TX interrupt status. */
+	l2tisar0 = mtk_dpmaif_drv_get_ul_lv2_sts(drv_info);
+	val = l2tisar0 & DPMAIF_UL_INT_QDONE  & (1 << (DP_UL_INT_DONE_OFFSET + qno));
+
+	/* ulq status. */
+	if (val) {
+		/* clear ulq done status */
+		mtk_hw_write32(DRV_TO_MDEV(drv_info), DPMAIF_PD_AP_UL_L2TISAR0, val);
+		ret = true;
+	}
+
+	return ret;
+}
+
+static u32 mtk_dpmaif_drv_irq_src0_dl_filter(struct dpmaif_drv_info *drv_info, u32 l2risar0,
+					     u32 l2rimr0)
+{
+	if (l2rimr0 & DPMAIF_DL_INT_DLQ0_QDONE_MSK)
+		l2risar0 &= ~DPMAIF_DL_INT_DLQ0_QDONE;
+
+	if (l2rimr0 & DPMAIF_DL_INT_DLQ0_PITCNT_LEN_ERR_MSK)
+		l2risar0 &= ~DPMAIF_DL_INT_DLQ0_PITCNT_LEN_ERR;
+
+	if (l2rimr0 & DPMAIF_DL_INT_FRG_LEN_ERR_MSK)
+		l2risar0 &= ~DPMAIF_DL_INT_FRG_LEN_ERR;
+
+	if (l2rimr0 & DPMAIF_DL_INT_BATCNT_LEN_ERR_MSK)
+		l2risar0 &= ~DPMAIF_DL_INT_BATCNT_LEN_ERR;
+
+	return l2risar0;
+}
+
+static u32 mtk_dpmaif_drv_irq_src1_dl_filter(struct dpmaif_drv_info *drv_info, u32 l2risar0,
+					     u32 l2rimr0)
+{
+	if (l2rimr0 & DPMAIF_DL_INT_DLQ1_QDONE_MSK)
+		l2risar0 &= ~DPMAIF_DL_INT_DLQ1_QDONE;
+
+	if (l2rimr0 & DPMAIF_DL_INT_DLQ1_PITCNT_LEN_ERR_MSK)
+		l2risar0 &= ~DPMAIF_DL_INT_DLQ1_PITCNT_LEN_ERR;
+
+	return l2risar0;
+}
+
+static int mtk_dpmaif_drv_irq_src0(struct dpmaif_drv_info *drv_info,
+				   struct dpmaif_drv_intr_info *intr_info)
+{
+	u32 val, l2risar0, l2rimr0;
+
+	l2risar0 = mtk_dpmaif_drv_get_dl_lv2_sts(drv_info);
+	l2rimr0 = mtk_dpmaif_drv_get_dl_intr_mask(drv_info);
+
+	l2risar0 &= DPMAIF_SRC0_DL_STATUS_MASK;
+	if (l2risar0) {
+		/* Filter to get DL unmasked interrupts */
+		l2risar0 = mtk_dpmaif_drv_irq_src0_dl_filter(drv_info, l2risar0, l2rimr0);
+
+		val = l2risar0 & DPMAIF_DL_INT_BATCNT_LEN_ERR;
+		if (val) {
+			intr_info->intr_types[intr_info->intr_cnt] = DPMAIF_INTR_DL_BATCNT_LEN_ERR;
+			intr_info->intr_queues[intr_info->intr_cnt] = DPMAIF_DLQ0;
+			intr_info->intr_cnt++;
+			mtk_dpmaif_drv_mask_dl_batcnt_len_err_intr(drv_info, DPMAIF_DLQ0);
+		}
+
+		val = l2risar0 & DPMAIF_DL_INT_FRG_LEN_ERR;
+		if (val) {
+			intr_info->intr_types[intr_info->intr_cnt] = DPMAIF_INTR_DL_FRGCNT_LEN_ERR;
+			intr_info->intr_queues[intr_info->intr_cnt] = DPMAIF_DLQ0;
+			intr_info->intr_cnt++;
+			mtk_dpmaif_drv_mask_dl_frgcnt_len_err_intr(drv_info, DPMAIF_DLQ0);
+		}
+
+		val = l2risar0 & DPMAIF_DL_INT_DLQ0_PITCNT_LEN_ERR;
+		if (val) {
+			intr_info->intr_types[intr_info->intr_cnt] = DPMAIF_INTR_DL_PITCNT_LEN_ERR;
+			intr_info->intr_queues[intr_info->intr_cnt] = 0x01 << DPMAIF_DLQ0;
+			intr_info->intr_cnt++;
+			mtk_dpmaif_drv_dlq_mask_pit_cnt_len_err_intr(drv_info, DPMAIF_DLQ0);
+		}
+
+		val = l2risar0 & DPMAIF_DL_INT_DLQ0_QDONE;
+		if (val) {
+			if (!mtk_dpmaif_drv_dlq_mask_rx_done_intr(drv_info, DPMAIF_DLQ0)) {
+				intr_info->intr_types[intr_info->intr_cnt] = DPMAIF_INTR_DL_DONE;
+				intr_info->intr_queues[intr_info->intr_cnt] = 0x01 << DPMAIF_DLQ0;
+				intr_info->intr_cnt++;
+			}
+		}
+
+		/* Clear interrupt status. */
+		mtk_hw_write32(DRV_TO_MDEV(drv_info), DPMAIF_PD_AP_DL_L2TISAR0, l2risar0);
+	}
+
+	return 0;
+}
+
+static int mtk_dpmaif_drv_irq_src1(struct dpmaif_drv_info *drv_info,
+				   struct dpmaif_drv_intr_info *intr_info)
+{
+	u32 val, l2risar0, l2rimr0;
+
+	l2risar0 = mtk_dpmaif_drv_get_dl_lv2_sts(drv_info);
+	l2rimr0 = mtk_dpmaif_drv_get_dl_intr_mask(drv_info);
+
+	/* Check and process interrupt. */
+	l2risar0 &= DPMAIF_SRC1_DL_STATUS_MASK;
+	if (l2risar0) {
+		/* Filter to get DL unmasked interrupts */
+		l2risar0 = mtk_dpmaif_drv_irq_src1_dl_filter(drv_info, l2risar0, l2rimr0);
+
+		val = l2risar0 & DPMAIF_DL_INT_DLQ1_PITCNT_LEN_ERR;
+		if (val) {
+			intr_info->intr_types[intr_info->intr_cnt] = DPMAIF_INTR_DL_PITCNT_LEN_ERR;
+			intr_info->intr_queues[intr_info->intr_cnt] = 0x01 << DPMAIF_DLQ1;
+			intr_info->intr_cnt++;
+			mtk_dpmaif_drv_dlq_mask_pit_cnt_len_err_intr(drv_info, DPMAIF_DLQ1);
+		}
+
+		val = l2risar0 & DPMAIF_DL_INT_DLQ1_QDONE;
+		if (val) {
+			if (!mtk_dpmaif_drv_dlq_mask_rx_done_intr(drv_info, DPMAIF_DLQ1)) {
+				intr_info->intr_types[intr_info->intr_cnt] = DPMAIF_INTR_DL_DONE;
+				intr_info->intr_queues[intr_info->intr_cnt] = 0x01 << DPMAIF_DLQ1;
+				intr_info->intr_cnt++;
+			}
+		}
+
+		/* Clear interrupt status. */
+		mtk_hw_write32(DRV_TO_MDEV(drv_info), DPMAIF_PD_AP_DL_L2TISAR0, l2risar0);
+	}
+
+	return 0;
+}
+
+static int mtk_dpmaif_drv_irq_src2(struct dpmaif_drv_info *drv_info,
+				   struct dpmaif_drv_intr_info *intr_info)
+{
+	u32 l2tisar0, l2timr0;
+	u8 q_mask;
+	u32 val;
+
+	l2tisar0 = mtk_dpmaif_drv_get_ul_lv2_sts(drv_info);
+	l2timr0 = mtk_dpmaif_drv_get_ul_intr_mask(drv_info);
+
+	/* Check and process interrupt. */
+	l2tisar0 &= (~l2timr0);
+	if (l2tisar0) {
+		val = l2tisar0 & DPMAIF_UL_INT_QDONE;
+		if (val) {
+			q_mask = val >> DP_UL_INT_DONE_OFFSET & DPMAIF_ULQS;
+			mtk_dpmaif_drv_ul_mask_multi_tx_done_intr(drv_info, q_mask);
+			intr_info->intr_types[intr_info->intr_cnt] = DPMAIF_INTR_UL_DONE;
+			intr_info->intr_queues[intr_info->intr_cnt] = val >> DP_UL_INT_DONE_OFFSET;
+			intr_info->intr_cnt++;
+		}
+
+		/* clear interrupt status */
+		mtk_hw_write32(DRV_TO_MDEV(drv_info), DPMAIF_PD_AP_UL_L2TISAR0, l2tisar0);
+	}
+
+	return 0;
+}
+
+static int mtk_dpmaif_drv_intr_handle_t800(struct dpmaif_drv_info *drv_info, void *data, u8 irq_id)
+{
+	switch (irq_id) {
+	case MTK_IRQ_SRC_DPMAIF:
+		mtk_dpmaif_drv_irq_src0(drv_info, data);
+		break;
+	case MTK_IRQ_SRC_DPMAIF2:
+		mtk_dpmaif_drv_irq_src1(drv_info, data);
+		break;
+	case MTK_IRQ_SRC_DPMAIF3:
+		mtk_dpmaif_drv_irq_src2(drv_info, data);
+		break;
+	default:
+		break;
+	}
+
+	return 0;
+}
+
+static int mtk_dpmaif_drv_intr_complete_t800(struct dpmaif_drv_info *drv_info,
+					     enum dpmaif_drv_intr_type type, u8 q_id, u64 data)
+{
+	int ret = 0;
+
+	switch (type) {
+	case DPMAIF_INTR_UL_DONE:
+		if (data == DPMAIF_CLEAR_INTR)
+			mtk_dpmaif_drv_check_clr_ul_done_status(drv_info, q_id);
+		else
+			ret = mtk_dpmaif_drv_unmask_ulq_intr(drv_info, q_id);
+		break;
+	case DPMAIF_INTR_DL_BATCNT_LEN_ERR:
+		mtk_dpmaif_drv_unmask_dl_batcnt_len_err_intr(drv_info);
+		break;
+	case DPMAIF_INTR_DL_FRGCNT_LEN_ERR:
+		mtk_dpmaif_drv_unmask_dl_frgcnt_len_err_intr(drv_info);
+		break;
+	case DPMAIF_INTR_DL_PITCNT_LEN_ERR:
+		ret = mtk_dpmaif_drv_dlq_unmask_pit_cnt_len_err_intr(drv_info, q_id);
+		break;
+	case DPMAIF_INTR_DL_DONE:
+		ret = mtk_dpmaif_drv_dl_unmask_rx_done_intr(drv_info, q_id);
+		break;
+	default:
+		break;
+	}
+
+	return ret;
+}
+
+static int mtk_dpmaif_drv_clr_ip_busy_sts_t800(struct dpmaif_drv_info *drv_info)
+{
+	u32 ip_busy_sts;
+
+	/* Get AP IP busy status. */
+	ip_busy_sts = mtk_hw_read32(DRV_TO_MDEV(drv_info), DPMAIF_PD_AP_IP_BUSY);
+
+	/* Clear AP IP busy. */
+	mtk_hw_write32(DRV_TO_MDEV(drv_info), DPMAIF_PD_AP_IP_BUSY, ip_busy_sts);
+
+	return 0;
+}
+
+static int mtk_dpmaif_drv_dl_add_pit_cnt(struct dpmaif_drv_info *drv_info,
+					 u32 qno, u32 pit_remain_cnt)
+{
+	u32 cnt = 0, dl_update;
+
+	dl_update = pit_remain_cnt & 0x0003ffff;
+	dl_update |= DPMAIF_DL_ADD_UPDATE | (qno << DPMAIF_ADD_LRO_PIT_CHAN_OFS);
+
+	do {
+		if ((mtk_hw_read32(DRV_TO_MDEV(drv_info), NRL2_DPMAIF_DL_LROPIT_ADD) &
+			DPMAIF_DL_ADD_NOT_READY) == 0) {
+			mtk_hw_write32(DRV_TO_MDEV(drv_info), NRL2_DPMAIF_DL_LROPIT_ADD, dl_update);
+			break;
+		}
+
+		udelay(POLL_INTERVAL_US);
+		cnt++;
+	} while (cnt < POLL_MAX_TIMES);
+
+	if (cnt >= POLL_MAX_TIMES) {
+		dev_err(DRV_TO_MDEV(drv_info)->dev, "Failed to add dlq%u pit-1, cnt=%u\n",
+			qno, pit_remain_cnt);
+		return -DATA_HW_REG_TIMEOUT;
+	}
+
+	cnt = 0;
+	do {
+		if (!((mtk_hw_read32(DRV_TO_MDEV(drv_info), NRL2_DPMAIF_DL_LROPIT_ADD) &
+		     DPMAIF_DL_ADD_NOT_READY) == DPMAIF_DL_ADD_NOT_READY))
+			break;
+
+		cnt++;
+		udelay(POLL_INTERVAL_US);
+	} while (cnt < POLL_MAX_TIMES);
+
+	if (cnt >= POLL_MAX_TIMES) {
+		dev_err(DRV_TO_MDEV(drv_info)->dev, "Failed to add dlq%u pit-2, cnt=%u\n",
+			qno, pit_remain_cnt);
+		return false;
+	}
+
+	return 0;
+}
+
+static int mtk_dpmaif_drv_dl_add_bat_cnt(struct dpmaif_drv_info *drv_info, u32 bat_entry_cnt)
+{
+	u32 cnt = 0, dl_bat_update;
+
+	dl_bat_update = bat_entry_cnt & 0xffff;
+	dl_bat_update |= DPMAIF_DL_ADD_UPDATE;
+	do {
+		if ((mtk_hw_read32(DRV_TO_MDEV(drv_info), DPMAIF_PD_DL_BAT_ADD) &
+			DPMAIF_DL_ADD_NOT_READY) == 0) {
+			mtk_hw_write32(DRV_TO_MDEV(drv_info), DPMAIF_PD_DL_BAT_ADD, dl_bat_update);
+			break;
+		}
+
+		udelay(POLL_INTERVAL_US);
+		cnt++;
+	} while (cnt < POLL_MAX_TIMES);
+
+	if (cnt >= POLL_MAX_TIMES) {
+		dev_err(DRV_TO_MDEV(drv_info)->dev,
+			"Failed to add bat-1, cnt=%u\n", bat_entry_cnt);
+		return -DATA_HW_REG_TIMEOUT;
+	}
+
+	cnt = 0;
+	do {
+		if (!((mtk_hw_read32(DRV_TO_MDEV(drv_info), DPMAIF_PD_DL_BAT_ADD) &
+		       DPMAIF_DL_ADD_NOT_READY) == DPMAIF_DL_ADD_NOT_READY))
+			break;
+
+		cnt++;
+		udelay(POLL_INTERVAL_US);
+	} while (cnt < POLL_MAX_TIMES);
+
+	if (cnt >= POLL_MAX_TIMES) {
+		dev_err(DRV_TO_MDEV(drv_info)->dev, "Failed to add bat-2, cnt=%u\n",
+			bat_entry_cnt);
+		return -DATA_HW_REG_TIMEOUT;
+	}
+	return 0;
+}
+
+static int mtk_dpmaif_drv_dl_add_frg_cnt(struct dpmaif_drv_info *drv_info, u32 frg_entry_cnt)
+{
+	u32 cnt = 0, dl_frg_update;
+	int ret = 0;
+
+	dl_frg_update = frg_entry_cnt & 0xffff;
+	dl_frg_update |= DPMAIF_DL_FRG_ADD_UPDATE;
+	dl_frg_update |= DPMAIF_DL_ADD_UPDATE;
+
+	do {
+		if (!(mtk_hw_read32(DRV_TO_MDEV(drv_info), DPMAIF_PD_DL_BAT_ADD)
+		     & DPMAIF_DL_ADD_NOT_READY)) {
+			mtk_hw_write32(DRV_TO_MDEV(drv_info), DPMAIF_PD_DL_BAT_ADD, dl_frg_update);
+			break;
+		}
+
+		udelay(POLL_INTERVAL_US);
+		cnt++;
+	} while (cnt < POLL_MAX_TIMES);
+
+	if (cnt >= POLL_MAX_TIMES) {
+		dev_err(DRV_TO_MDEV(drv_info)->dev, "Failed to add frag bat-1, cnt=%u\n",
+			frg_entry_cnt);
+		return -DATA_HW_REG_TIMEOUT;
+	}
+
+	cnt = 0;
+	do {
+		if (!((mtk_hw_read32(DRV_TO_MDEV(drv_info), DPMAIF_PD_DL_BAT_ADD) &
+		       DPMAIF_DL_ADD_NOT_READY) == DPMAIF_DL_ADD_NOT_READY))
+			break;
+
+		cnt++;
+		udelay(POLL_INTERVAL_US);
+	} while (cnt < POLL_MAX_TIMES);
+
+	if (cnt >= POLL_MAX_TIMES) {
+		dev_err(DRV_TO_MDEV(drv_info)->dev, "Failed to add frag bat-2, cnt=%u\n",
+			frg_entry_cnt);
+		return -DATA_HW_REG_TIMEOUT;
+	}
+	return ret;
+}
+
+static int mtk_dpmaif_drv_ul_add_drb(struct dpmaif_drv_info *drv_info, u8 q_num, u32 drb_cnt)
+{
+	u32 drb_entry_cnt = drb_cnt * DPMAIF_UL_DRB_ENTRY_WORD;
+	u32 cnt = 0, ul_update;
+	u64 addr;
+
+	ul_update = drb_entry_cnt & 0x0000ffff;
+	ul_update |= DPMAIF_UL_ADD_UPDATE;
+
+	if (q_num == 4)
+		addr = NRL2_DPMAIF_UL_ADD_DESC_CH4;
+	else
+		addr = DPMAIF_ULQ_ADD_DESC_CH_N(q_num);
+
+	do {
+		if (!(mtk_hw_read32(DRV_TO_MDEV(drv_info), addr) & DPMAIF_UL_ADD_NOT_READY)) {
+			mtk_hw_write32(DRV_TO_MDEV(drv_info), addr, ul_update);
+			break;
+		}
+
+		udelay(POLL_INTERVAL_US);
+		cnt++;
+	} while (cnt < POLL_MAX_TIMES);
+
+	if (cnt >= POLL_MAX_TIMES) {
+		dev_err(DRV_TO_MDEV(drv_info)->dev, "Failed to add ulq%u drb-1, cnt=%u\n",
+			q_num, drb_cnt);
+		return -DATA_HW_REG_TIMEOUT;
+	}
+
+	cnt = 0;
+	do {
+		if (!((mtk_hw_read32(DRV_TO_MDEV(drv_info), addr) &
+		       DPMAIF_UL_ADD_NOT_READY) == DPMAIF_UL_ADD_NOT_READY))
+			break;
+
+		cnt++;
+		udelay(POLL_INTERVAL_US);
+	} while (cnt < POLL_MAX_TIMES);
+
+	if (cnt >= POLL_MAX_TIMES) {
+		dev_err(DRV_TO_MDEV(drv_info)->dev, "Failed to add ulq%u drb-2, cnt=%u\n",
+			q_num, drb_cnt);
+		return -DATA_HW_REG_TIMEOUT;
+	}
+	return 0;
+}
+
+static int mtk_dpmaif_drv_send_doorbell_t800(struct dpmaif_drv_info *drv_info,
+					     enum dpmaif_drv_ring_type type,
+					     u8 q_id, u32 cnt)
+{
+	int ret = 0;
+
+	switch (type) {
+	case DPMAIF_PIT:
+		ret = mtk_dpmaif_drv_dl_add_pit_cnt(drv_info, q_id, cnt);
+		break;
+	case DPMAIF_BAT:
+		ret = mtk_dpmaif_drv_dl_add_bat_cnt(drv_info, cnt);
+		break;
+	case DPMAIF_FRAG:
+		ret = mtk_dpmaif_drv_dl_add_frg_cnt(drv_info, cnt);
+		break;
+	case DPMAIF_DRB:
+		ret = mtk_dpmaif_drv_ul_add_drb(drv_info, q_id, cnt);
+		break;
+	default:
+		break;
+	}
+
+	return ret;
+}
+
+static int mtk_dpmaif_drv_dl_get_pit_wridx(struct dpmaif_drv_info *drv_info, u32 qno)
+{
+	u32 pit_wridx;
+
+	pit_wridx = (mtk_hw_read32(DRV_TO_MDEV(drv_info), NRL2_DPMAIF_AO_DL_LRO_STA5 + qno * 0x20))
+		    & DPMAIF_DL_PIT_WRIDX_MSK;
+	if (unlikely(pit_wridx >= drv_info->drv_property.dlq[qno].pit_size))
+		return -DATA_HW_REG_CHK_FAIL;
+
+	return pit_wridx;
+}
+
+static int mtk_dpmaif_drv_dl_get_pit_rdidx(struct dpmaif_drv_info *drv_info, u32 qno)
+{
+	u32 pit_rdidx;
+
+	pit_rdidx = (mtk_hw_read32(DRV_TO_MDEV(drv_info), NRL2_DPMAIF_AO_DL_LRO_STA6 + qno * 0x20))
+		    & DPMAIF_DL_PIT_WRIDX_MSK;
+	if (unlikely(pit_rdidx >= drv_info->drv_property.dlq[qno].pit_size))
+		return -DATA_HW_REG_CHK_FAIL;
+
+	return pit_rdidx;
+}
+
+static int mtk_dpmaif_drv_dl_get_bat_ridx(struct dpmaif_drv_info *drv_info)
+{
+	u32 bat_ridx;
+
+	bat_ridx = mtk_hw_read32(DRV_TO_MDEV(drv_info), DPMAIF_AO_DL_BAT_STA2) &
+		   DPMAIF_DL_BAT_WRIDX_MSK;
+
+	if (unlikely(bat_ridx >= drv_info->drv_property.ring.normal_bat_size))
+		return -DATA_HW_REG_CHK_FAIL;
+
+	return bat_ridx;
+}
+
+static int mtk_dpmaif_drv_dl_get_bat_wridx(struct dpmaif_drv_info *drv_info)
+{
+	u32 bat_wridx;
+
+	bat_wridx = mtk_hw_read32(DRV_TO_MDEV(drv_info), DPMAIF_AO_DL_BAT_STA3) &
+		    DPMAIF_DL_BAT_WRIDX_MSK;
+	if (unlikely(bat_wridx >= drv_info->drv_property.ring.normal_bat_size))
+		return -DATA_HW_REG_CHK_FAIL;
+
+	return bat_wridx;
+}
+
+static int mtk_dpmaif_drv_dl_get_frg_ridx(struct dpmaif_drv_info *drv_info)
+{
+	u32 frg_ridx;
+
+	frg_ridx = mtk_hw_read32(DRV_TO_MDEV(drv_info), DPMAIF_AO_DL_FRG_STA2) &
+		   DPMAIF_DL_FRG_WRIDX_MSK;
+	if (unlikely(frg_ridx >= drv_info->drv_property.ring.frag_bat_size))
+		return -DATA_HW_REG_CHK_FAIL;
+
+	return frg_ridx;
+}
+
+static int mtk_dpmaif_drv_ul_get_drb_ridx(struct dpmaif_drv_info *drv_info, u8 q_num)
+{
+	u32 drb_ridx;
+	u64 addr;
+
+	addr = DPMAIF_ULQ_STA0_N(q_num);
+
+	drb_ridx = mtk_hw_read32(DRV_TO_MDEV(drv_info), addr) >> 16;
+	drb_ridx = drb_ridx / DPMAIF_UL_DRB_ENTRY_WORD;
+
+	if (unlikely(drb_ridx >= drv_info->drv_property.ulq[q_num].drb_size))
+		return -DATA_HW_REG_CHK_FAIL;
+
+	return drb_ridx;
+}
+
+static int mtk_dpmaif_drv_get_ring_idx_t800(struct dpmaif_drv_info *drv_info,
+					    enum dpmaif_drv_ring_idx index, u8 q_id)
+{
+	int ret = 0;
+
+	switch (index) {
+	case DPMAIF_PIT_WIDX:
+		ret = mtk_dpmaif_drv_dl_get_pit_wridx(drv_info, q_id);
+		break;
+	case DPMAIF_PIT_RIDX:
+		ret = mtk_dpmaif_drv_dl_get_pit_rdidx(drv_info, q_id);
+		break;
+	case DPMAIF_BAT_WIDX:
+		ret = mtk_dpmaif_drv_dl_get_bat_wridx(drv_info);
+		break;
+	case DPMAIF_BAT_RIDX:
+		ret = mtk_dpmaif_drv_dl_get_bat_ridx(drv_info);
+		break;
+	case DPMAIF_FRAG_RIDX:
+		ret = mtk_dpmaif_drv_dl_get_frg_ridx(drv_info);
+		break;
+	case DPMAIF_DRB_RIDX:
+		ret = mtk_dpmaif_drv_ul_get_drb_ridx(drv_info, q_id);
+		break;
+	default:
+		break;
+	}
+
+	return ret;
+}
+
+static u32 mtk_dpmaif_drv_hash_indir_get(struct dpmaif_drv_info *drv_info, u32 *indir)
+{
+	u32 val = mtk_dpmaif_drv_hash_indir_mask_get(drv_info);
+	u8 i;
+
+	for (i = 0; i < DPMAIF_HASH_INDR_SIZE; i++) {
+		if (val & (0x01 << i))
+			indir[i] = 1;
+		else
+			indir[i] = 0;
+	}
+
+	return 0;
+}
+
+static u32 mtk_dpmaif_drv_hash_indir_set(struct dpmaif_drv_info *drv_info, u32 *indir)
+{
+	u32 val = 0;
+	u8 i;
+
+	for (i = 0; i < DPMAIF_HASH_INDR_SIZE; i++) {
+		if (indir[i])
+			val |= (0x01 << i);
+	}
+	mtk_dpmaif_drv_hash_indir_mask_set(drv_info, val);
+
+	return 0;
+}
+
+static u32 mtk_dpmaif_drv_5tuple_trig(struct dpmaif_drv_info *drv_info,
+				      struct dpmaif_hpc_rule *rule, u32 sw_add,
+				      u32 agg_en, u32 ovw_en)
+{
+	u32 cnt, i, *val = (u32 *)rule;
+
+	for (i = 0; i < sizeof(*rule) / sizeof(u32); i++)
+		mtk_hw_write32(DRV_TO_MDEV(drv_info),
+			       NRL2_DPMAIF_HPC_SW_ADD_RULE0 + 4 * i,
+			       *(val + i));
+
+	mtk_hw_write32(DRV_TO_MDEV(drv_info),
+		       NRL2_DPMAIF_HPC_SW_5TUPLE_TRIG,
+		       (ovw_en << 3) | (agg_en << 2) | (sw_add << 1) | 0x1);
+
+	/* wait hw 5-tuple process finish */
+	cnt = 0;
+	do {
+		if (!(mtk_hw_read32(DRV_TO_MDEV(drv_info), NRL2_DPMAIF_HPC_SW_5TUPLE_TRIG) & 0x1))
+			break;
+
+		cnt++;
+		udelay(POLL_INTERVAL_US);
+	} while (cnt < POLL_MAX_TIMES);
+
+	if (cnt >= POLL_MAX_TIMES) {
+		dev_err(DRV_TO_MDEV(drv_info)->dev, "Failed to 5tuple trigger\n");
+		return -DATA_HW_REG_TIMEOUT;
+	}
+	if (mtk_hw_read32(DRV_TO_MDEV(drv_info), NRL2_DPMAIF_HPC_5TUPLE_STS))
+		return -DATA_HW_REG_CHK_FAIL;
+
+	return 0;
+}
+
+static int mtk_dpmaif_drv_ul_set_delay_intr(struct dpmaif_drv_info *drv_info,
+					    u8 q_num, u8 mode, u32 time_us, u32 pkt_cnt)
+{
+	u32 ret = 0, cfg;
+
+	cfg = ((mode & 0x3) << 30) | ((pkt_cnt & 0x3fff) << 16) | (time_us & 0xffff);
+
+	switch (q_num) {
+	case 0:
+		mtk_hw_write32(DRV_TO_MDEV(drv_info), NRL2_DPMAIF_DLY_IRQ_TIMER3, cfg);
+		break;
+	case 1:
+		mtk_hw_write32(DRV_TO_MDEV(drv_info), NRL2_DPMAIF_DLY_IRQ_TIMER4, cfg);
+		break;
+	case 2:
+		mtk_hw_write32(DRV_TO_MDEV(drv_info), NRL2_DPMAIF_DLY_IRQ_TIMER5, cfg);
+		break;
+	case 3:
+		mtk_hw_write32(DRV_TO_MDEV(drv_info), NRL2_DPMAIF_DLY_IRQ_TIMER6, cfg);
+		break;
+	case 4:
+		mtk_hw_write32(DRV_TO_MDEV(drv_info), NRL2_DPMAIF_DLY_IRQ_TIMER7, cfg);
+		break;
+	default:
+		dev_err(DRV_TO_MDEV(drv_info)->dev, "Invalid ulq=%d!\n", q_num);
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
+static int mtk_dpmaif_drv_dl_set_delay_intr(struct dpmaif_drv_info *drv_info,
+					    u8 q_num, u8 mode, u32 time_us, u32 pkt_cnt)
+{
+	int ret = 0;
+	u32 cfg = 0;
+
+	cfg = ((mode & 0x3) << 30) | ((pkt_cnt & 0x3fff) << 16) | (time_us & 0xffff);
+
+	switch (q_num) {
+	case 0:
+		mtk_hw_write32(DRV_TO_MDEV(drv_info), NRL2_DPMAIF_AO_DL_DLY_IRQ_TIMER1, cfg);
+		break;
+	case 1:
+		mtk_hw_write32(DRV_TO_MDEV(drv_info), NRL2_DPMAIF_AO_DL_DLY_IRQ_TIMER2, cfg);
+		break;
+	default:
+		dev_info(DRV_TO_MDEV(drv_info)->dev, "Invalid dlq=%d!\n", q_num);
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
+static int mtk_dpmaif_drv_intr_coalesce_set(struct dpmaif_drv_info *drv_info,
+					    struct dpmaif_drv_intr *intr)
+{
+	u8 i;
+
+	if (intr->dir == DPMAIF_TX) {
+		for (i = 0; i < DPMAIF_ULQ_NUM; i++) {
+			if (intr->q_mask & (1 << i))
+				mtk_dpmaif_drv_ul_set_delay_intr(drv_info, i, intr->mode,
+								 intr->time_threshold,
+								 intr->pkt_threshold);
+		}
+	} else {
+		for (i = 0; i < DPMAIF_DLQ_NUM; i++) {
+			if (intr->q_mask & (1 << i))
+				mtk_dpmaif_drv_dl_set_delay_intr(drv_info, i, intr->mode,
+								 intr->time_threshold,
+								 intr->pkt_threshold);
+		}
+	}
+
+	return 0;
+}
+
+static int mtk_dpmaif_drv_feature_cmd_t800(struct dpmaif_drv_info *drv_info,
+					   enum dpmaif_drv_cmd cmd, void *data)
+{
+	int ret = 0;
+
+	switch (cmd) {
+	case DATA_HW_INTR_COALESCE_SET:
+		ret = mtk_dpmaif_drv_intr_coalesce_set(drv_info, data);
+		break;
+	case DATA_HW_HASH_GET:
+		ret = mtk_dpmaif_drv_hash_sec_key_get(drv_info, data);
+		break;
+	case DATA_HW_HASH_SET:
+		ret = mtk_dpmaif_drv_hash_sec_key_set(drv_info, data);
+		break;
+	case DATA_HW_HASH_KEY_SIZE_GET:
+		*(u32 *)data = DPMAIF_HASH_SEC_KEY_NUM;
+		break;
+	case DATA_HW_INDIR_GET:
+		ret = mtk_dpmaif_drv_hash_indir_get(drv_info, data);
+		break;
+	case DATA_HW_INDIR_SET:
+		ret = mtk_dpmaif_drv_hash_indir_set(drv_info, data);
+		break;
+	case DATA_HW_INDIR_SIZE_GET:
+		*(u32 *)data = DPMAIF_HASH_INDR_SIZE;
+		break;
+	case DATA_HW_LRO_SET:
+		ret = mtk_dpmaif_drv_5tuple_trig(drv_info, data, 1, 1, 1);
+		break;
+	default:
+		dev_info(DRV_TO_MDEV(drv_info)->dev, "Unsupport cmd=%d\n", cmd);
+		ret = -EOPNOTSUPP;
+		break;
+	}
+
+	return ret;
+}
+
+struct dpmaif_drv_ops dpmaif_drv_ops_t800 = {
+	.init = mtk_dpmaif_drv_init_t800,
+	.start_queue = mtk_dpmaif_drv_start_queue_t800,
+	.stop_queue = mtk_dpmaif_drv_stop_queue_t800,
+	.intr_handle = mtk_dpmaif_drv_intr_handle_t800,
+	.intr_complete = mtk_dpmaif_drv_intr_complete_t800,
+	.clear_ip_busy = mtk_dpmaif_drv_clr_ip_busy_sts_t800,
+	.send_doorbell = mtk_dpmaif_drv_send_doorbell_t800,
+	.get_ring_idx = mtk_dpmaif_drv_get_ring_idx_t800,
+	.feature_cmd = mtk_dpmaif_drv_feature_cmd_t800,
+};
diff --git a/drivers/net/wwan/mediatek/pcie/mtk_dpmaif_reg_t800.h b/drivers/net/wwan/mediatek/pcie/mtk_dpmaif_reg_t800.h
new file mode 100644
index 000000000000..8db2cd782a80
--- /dev/null
+++ b/drivers/net/wwan/mediatek/pcie/mtk_dpmaif_reg_t800.h
@@ -0,0 +1,368 @@
+/* SPDX-License-Identifier: BSD-3-Clause-Clear
+ *
+ * Copyright (c) 2022, MediaTek Inc.
+ */
+
+#ifndef __MTK_DPMAIF_DRV_T800_H__
+#define __MTK_DPMAIF_DRV_T800_H__
+
+#define DPMAIF_DEV_PD_BASE		(0x1022D000)
+#define DPMAIF_DEV_AO_BASE		(0x10011000)
+
+#define DPMAIF_PD_BASE			DPMAIF_DEV_PD_BASE
+#define DPMAIF_AO_BASE			DPMAIF_DEV_AO_BASE
+
+#define BASE_NADDR_NRL2_DPMAIF_UL	((unsigned long)(DPMAIF_PD_BASE))
+#define BASE_NADDR_NRL2_DPMAIF_DL	((unsigned long)(DPMAIF_PD_BASE + 0x100))
+#define BASE_NADDR_NRL2_DPMAIF_AP_MISC	((unsigned long)(DPMAIF_PD_BASE + 0x400))
+#define BASE_NADDR_NRL2_DPMAIF_PD_SRAM_UL	((unsigned long)(DPMAIF_PD_BASE + 0xD00))
+#define BASE_NADDR_NRL2_DPMAIF_PD_SRAM_DL	((unsigned long)(DPMAIF_PD_BASE + 0xC00))
+#define BASE_NADDR_NRL2_DPMAIF_DL_LRO_REMOVEAO_IDX	((unsigned long)(DPMAIF_PD_BASE + 0x900))
+#define BASE_NADDR_NRL2_DPMAIF_MMW_HPC		((unsigned long)(DPMAIF_PD_BASE + 0x600))
+#define BASE_NADDR_NRL2_DPMAIF_PD_SRAM_MISC2	((unsigned long)(DPMAIF_PD_BASE + 0xF00))
+#define BASE_NADDR_NRL2_DPMAIF_AO_UL		((unsigned long)(DPMAIF_AO_BASE))
+#define BASE_NADDR_NRL2_DPMAIF_AO_DL		((unsigned long)(DPMAIF_AO_BASE + 0x400))
+
+/* dpmaif uplink part registers. */
+#define NRL2_DPMAIF_UL_ADD_DESC		(BASE_NADDR_NRL2_DPMAIF_UL + 0x00)
+#define NRL2_DPMAIF_UL_DBG_STA2		(BASE_NADDR_NRL2_DPMAIF_UL + 0x88)
+#define NRL2_DPMAIF_UL_RESERVE_AO_RW	(BASE_NADDR_NRL2_DPMAIF_UL + 0xAC)
+#define NRL2_DPMAIF_UL_ADD_DESC_CH0	(BASE_NADDR_NRL2_DPMAIF_UL + 0xB0)
+#define NRL2_DPMAIF_UL_ADD_DESC_CH4	(BASE_NADDR_NRL2_DPMAIF_UL + 0xE0)
+
+/* dpmaif downlink part registers. */
+#define NRL2_DPMAIF_DL_BAT_INIT			(BASE_NADDR_NRL2_DPMAIF_DL + 0x00)
+#define NRL2_DPMAIF_DL_BAT_INIT			(BASE_NADDR_NRL2_DPMAIF_DL + 0x00)
+#define NRL2_DPMAIF_DL_BAT_ADD			(BASE_NADDR_NRL2_DPMAIF_DL + 0x04)
+#define NRL2_DPMAIF_DL_BAT_INIT_CON0		(BASE_NADDR_NRL2_DPMAIF_DL + 0x08)
+#define NRL2_DPMAIF_DL_BAT_INIT_CON1		(BASE_NADDR_NRL2_DPMAIF_DL + 0x0C)
+#define NRL2_DPMAIF_DL_BAT_INIT_CON3		(BASE_NADDR_NRL2_DPMAIF_DL + 0x50)
+#define NRL2_DPMAIF_DL_DBG_STA1			(BASE_NADDR_NRL2_DPMAIF_DL + 0xB4)
+
+/* dpmaif ap misc part registers. */
+#define NRL2_DPMAIF_AP_MISC_AP_L2TISAR0		(BASE_NADDR_NRL2_DPMAIF_AP_MISC + 0x00)
+#define NRL2_DPMAIF_AP_MISC_APDL_L2TISAR0	(BASE_NADDR_NRL2_DPMAIF_AP_MISC + 0x50)
+#define NRL2_DPMAIF_AP_MISC_AP_IP_BUSY		(BASE_NADDR_NRL2_DPMAIF_AP_MISC + 0x60)
+#define NRL2_DPMAIF_AP_MISC_CG_EN		(BASE_NADDR_NRL2_DPMAIF_AP_MISC + 0x68)
+#define NRL2_DPMAIF_AP_MISC_OVERWRITE_CFG	(BASE_NADDR_NRL2_DPMAIF_AP_MISC + 0x90)
+#define NRL2_DPMAIF_AP_MISC_RSTR_CLR		(BASE_NADDR_NRL2_DPMAIF_AP_MISC + 0x94)
+
+/* dpmaif uplink ao part registers. */
+#define NRL2_DPMAIF_AO_UL_INIT_SET		(BASE_NADDR_NRL2_DPMAIF_AO_UL + 0x0)
+#define NRL2_DPMAIF_AO_UL_CHNL_ARB0		(BASE_NADDR_NRL2_DPMAIF_AO_UL + 0x1C)
+#define NRL2_DPMAIF_AO_UL_AP_L2TIMR0		(BASE_NADDR_NRL2_DPMAIF_AO_UL + 0x80)
+#define NRL2_DPMAIF_AO_UL_AP_L2TIMCR0		(BASE_NADDR_NRL2_DPMAIF_AO_UL + 0x84)
+#define NRL2_DPMAIF_AO_UL_AP_L2TIMSR0		(BASE_NADDR_NRL2_DPMAIF_AO_UL + 0x88)
+#define NRL2_DPMAIF_AO_UL_AP_L1TIMR0		(BASE_NADDR_NRL2_DPMAIF_AO_UL + 0x8C)
+#define NRL2_DPMAIF_AO_UL_APDL_L2TIMR0		(BASE_NADDR_NRL2_DPMAIF_AO_UL + 0x90)
+#define NRL2_DPMAIF_AO_UL_APDL_L2TIMCR0		(BASE_NADDR_NRL2_DPMAIF_AO_UL + 0x94)
+#define NRL2_DPMAIF_AO_UL_APDL_L2TIMSR0		(BASE_NADDR_NRL2_DPMAIF_AO_UL + 0x98)
+#define NRL2_DPMAIF_AO_UL_AP_DL_UL_IP_BUSY_MASK	(BASE_NADDR_NRL2_DPMAIF_AO_UL + 0x9C)
+
+/* dpmaif uplink pd sram part registers. */
+#define NRL2_DPMAIF_AO_UL_CHNL0_CON0		(BASE_NADDR_NRL2_DPMAIF_PD_SRAM_UL + 0x10)
+#define NRL2_DPMAIF_AO_UL_CHNL0_CON1		(BASE_NADDR_NRL2_DPMAIF_PD_SRAM_UL + 0x14)
+#define NRL2_DPMAIF_AO_UL_CHNL0_CON2		(BASE_NADDR_NRL2_DPMAIF_PD_SRAM_UL + 0x18)
+#define NRL2_DPMAIF_DLY_IRQ_TIMER3		(BASE_NADDR_NRL2_DPMAIF_PD_SRAM_UL + 0x1C)
+#define NRL2_DPMAIF_DLY_IRQ_TIMER4		(BASE_NADDR_NRL2_DPMAIF_PD_SRAM_UL + 0x2C)
+#define NRL2_DPMAIF_DLY_IRQ_TIMER5		(BASE_NADDR_NRL2_DPMAIF_PD_SRAM_UL + 0x3C)
+#define NRL2_DPMAIF_DLY_IRQ_TIMER6		(BASE_NADDR_NRL2_DPMAIF_PD_SRAM_UL + 0x60)
+#define NRL2_DPMAIF_DLY_IRQ_TIMER7		(BASE_NADDR_NRL2_DPMAIF_PD_SRAM_UL + 0x64)
+#define NRL2_DPMAIF_AO_UL_CH0_STA		(BASE_NADDR_NRL2_DPMAIF_PD_SRAM_UL + 0xE0)
+
+/* dpmaif downlink ao part registers. */
+#define NRL2_DPMAIF_AO_DL_INIT_SET		(BASE_NADDR_NRL2_DPMAIF_AO_DL + 0x0)
+#define NRL2_DPMAIF_AO_DL_LROPIT_INIT_CON5	(BASE_NADDR_NRL2_DPMAIF_AO_DL + 0x28)
+#define NRL2_DPMAIF_AO_DL_LROPIT_TRIG_THRES	(BASE_NADDR_NRL2_DPMAIF_AO_DL + 0x34)
+
+/* dpmaif downlink pd sram part registers. */
+#define NRL2_DPMAIF_AO_DL_PKTINFO_CON0		(BASE_NADDR_NRL2_DPMAIF_PD_SRAM_DL + 0x0)
+#define NRL2_DPMAIF_AO_DL_PKTINFO_CON1		(BASE_NADDR_NRL2_DPMAIF_PD_SRAM_DL + 0x4)
+#define NRL2_DPMAIF_AO_DL_PKTINFO_CON2		(BASE_NADDR_NRL2_DPMAIF_PD_SRAM_DL + 0x8)
+#define NRL2_DPMAIF_AO_DL_RDY_CHK_THRES		(BASE_NADDR_NRL2_DPMAIF_PD_SRAM_DL + 0xC)
+#define NRL2_DPMAIF_AO_DL_RDY_CHK_FRG_THRES	(BASE_NADDR_NRL2_DPMAIF_PD_SRAM_DL + 0x10)
+#define NRL2_DPMAIF_AO_DL_LRO_AGG_CFG		(BASE_NADDR_NRL2_DPMAIF_PD_SRAM_DL + 0x20)
+#define NRL2_DPMAIF_AO_DL_LROPIT_TIMEOUT0	(BASE_NADDR_NRL2_DPMAIF_PD_SRAM_DL + 0x24)
+#define NRL2_DPMAIF_AO_DL_LROPIT_TIMEOUT1	(BASE_NADDR_NRL2_DPMAIF_PD_SRAM_DL + 0x28)
+#define NRL2_DPMAIF_AO_DL_HPC_CNTL		(BASE_NADDR_NRL2_DPMAIF_PD_SRAM_DL + 0x38)
+#define NRL2_DPMAIF_AO_DL_PIT_SEQ_END		(BASE_NADDR_NRL2_DPMAIF_PD_SRAM_DL + 0x40)
+#define NRL2_DPMAIF_AO_DL_DLY_IRQ_TIMER1	(BASE_NADDR_NRL2_DPMAIF_PD_SRAM_DL + 0x58)
+#define NRL2_DPMAIF_AO_DL_DLY_IRQ_TIMER2	(BASE_NADDR_NRL2_DPMAIF_PD_SRAM_DL + 0x5C)
+#define NRL2_DPMAIF_AO_DL_BAT_STA2		(BASE_NADDR_NRL2_DPMAIF_PD_SRAM_DL + 0xD8)
+#define NRL2_DPMAIF_AO_DL_BAT_STA3		(BASE_NADDR_NRL2_DPMAIF_PD_SRAM_DL + 0xDC)
+#define NRL2_DPMAIF_AO_DL_PIT_STA2		(BASE_NADDR_NRL2_DPMAIF_PD_SRAM_DL + 0xEC)
+#define NRL2_DPMAIF_AO_DL_PIT_STA3		(BASE_NADDR_NRL2_DPMAIF_PD_SRAM_DL + 0x60)
+#define NRL2_DPMAIF_AO_DL_FRGBAT_STA2		(BASE_NADDR_NRL2_DPMAIF_PD_SRAM_DL + 0x78)
+#define NRL2_DPMAIF_AO_DL_LRO_STA5		(BASE_NADDR_NRL2_DPMAIF_PD_SRAM_DL + 0xA4)
+#define NRL2_DPMAIF_AO_DL_LRO_STA6		(BASE_NADDR_NRL2_DPMAIF_PD_SRAM_DL + 0xA8)
+
+/* dpmaif hpc part registers. */
+#define NRL2_DPMAIF_HPC_SW_5TUPLE_TRIG		(BASE_NADDR_NRL2_DPMAIF_MMW_HPC + 0x030)
+#define NRL2_DPMAIF_HPC_5TUPLE_STS		(BASE_NADDR_NRL2_DPMAIF_MMW_HPC + 0x034)
+#define NRL2_DPMAIF_HPC_SW_ADD_RULE0		(BASE_NADDR_NRL2_DPMAIF_MMW_HPC + 0x060)
+#define NRL2_DPMAIF_HPC_INTR_MASK		(BASE_NADDR_NRL2_DPMAIF_MMW_HPC + 0x0F4)
+
+/* dpmaif LRO part registers. */
+#define NRL2_DPMAIF_DL_LROPIT_INIT		(BASE_NADDR_NRL2_DPMAIF_DL_LRO_REMOVEAO_IDX + 0x0)
+#define NRL2_DPMAIF_DL_LROPIT_ADD		(BASE_NADDR_NRL2_DPMAIF_DL_LRO_REMOVEAO_IDX + 0x10)
+#define NRL2_DPMAIF_DL_LROPIT_INIT_CON0		(BASE_NADDR_NRL2_DPMAIF_DL_LRO_REMOVEAO_IDX + 0x14)
+#define NRL2_DPMAIF_DL_LROPIT_INIT_CON1		(BASE_NADDR_NRL2_DPMAIF_DL_LRO_REMOVEAO_IDX + 0x18)
+#define NRL2_DPMAIF_DL_LROPIT_INIT_CON2		(BASE_NADDR_NRL2_DPMAIF_DL_LRO_REMOVEAO_IDX + 0x1C)
+#define NRL2_DPMAIF_DL_LROPIT_INIT_CON5		(BASE_NADDR_NRL2_DPMAIF_DL_LRO_REMOVEAO_IDX + 0x28)
+#define NRL2_DPMAIF_DL_LROPIT_INIT_CON3		(BASE_NADDR_NRL2_DPMAIF_DL_LRO_REMOVEAO_IDX + 0x20)
+#define NRL2_DPMAIF_DL_LROPIT_INIT_CON4		(BASE_NADDR_NRL2_DPMAIF_DL_LRO_REMOVEAO_IDX + 0x24)
+#define NRL2_DPMAIF_DL_LROPIT_INIT_CON6		(BASE_NADDR_NRL2_DPMAIF_DL_LRO_REMOVEAO_IDX + 0x2C)
+
+/* dpmaif pd sram misc2 part registers. */
+#define NRL2_REG_TOE_HASH_EN		(BASE_NADDR_NRL2_DPMAIF_PD_SRAM_MISC2 + 0x0)
+#define NRL2_REG_HASH_CFG_CON		(BASE_NADDR_NRL2_DPMAIF_PD_SRAM_MISC2 + 0x4)
+#define NRL2_REG_HASH_SEC_KEY_0		(BASE_NADDR_NRL2_DPMAIF_PD_SRAM_MISC2 + 0x8)
+#define NRL2_REG_HPC_STATS_THRES	(BASE_NADDR_NRL2_DPMAIF_PD_SRAM_MISC2 + 0x30)
+#define NRL2_REG_HPC_STATS_TIMER_CFG	(BASE_NADDR_NRL2_DPMAIF_PD_SRAM_MISC2 + 0x34)
+#define NRL2_REG_HASH_SEC_KEY_UPD	(BASE_NADDR_NRL2_DPMAIF_PD_SRAM_MISC2 + 0X70)
+
+/* dpmaif pd ul, ao ul config. */
+#define DPMAIF_PD_UL_CHNL_ARB0		NRL2_DPMAIF_AO_UL_CHNL_ARB0
+#define DPMAIF_PD_UL_CHNL0_CON0		NRL2_DPMAIF_AO_UL_CHNL0_CON0
+#define DPMAIF_PD_UL_CHNL0_CON1		NRL2_DPMAIF_AO_UL_CHNL0_CON1
+#define DPMAIF_PD_UL_CHNL0_CON2		NRL2_DPMAIF_AO_UL_CHNL0_CON2
+#define DPMAIF_PD_UL_ADD_DESC_CH	NRL2_DPMAIF_UL_ADD_DESC_CH0
+#define DPMAIF_PD_UL_DBG_STA2		NRL2_DPMAIF_UL_DBG_STA2
+
+/* dpmaif pd dl config. */
+#define DPMAIF_PD_DL_BAT_INIT		NRL2_DPMAIF_DL_BAT_INIT
+#define DPMAIF_PD_DL_BAT_ADD		NRL2_DPMAIF_DL_BAT_ADD
+#define DPMAIF_PD_DL_BAT_INIT_CON0	NRL2_DPMAIF_DL_BAT_INIT_CON0
+#define DPMAIF_PD_DL_BAT_INIT_CON1	NRL2_DPMAIF_DL_BAT_INIT_CON1
+#define DPMAIF_PD_DL_BAT_INIT_CON3	NRL2_DPMAIF_DL_BAT_INIT_CON3
+#define DPMAIF_PD_DL_DBG_STA1		NRL2_DPMAIF_DL_DBG_STA1
+
+/* dpmaif pd ap misc, ao ul misc config. */
+#define DPMAIF_PD_AP_UL_L2TISAR0	NRL2_DPMAIF_AP_MISC_AP_L2TISAR0
+#define DPMAIF_PD_AP_UL_L2TIMR0		NRL2_DPMAIF_AO_UL_AP_L2TIMR0
+#define DPMAIF_PD_AP_UL_L2TICR0		NRL2_DPMAIF_AO_UL_AP_L2TIMCR0
+#define DPMAIF_PD_AP_UL_L2TISR0		NRL2_DPMAIF_AO_UL_AP_L2TIMSR0
+#define DPMAIF_PD_AP_DL_L2TISAR0	NRL2_DPMAIF_AP_MISC_APDL_L2TISAR0
+#define DPMAIF_PD_AP_DL_L2TIMR0		NRL2_DPMAIF_AO_UL_APDL_L2TIMR0
+#define DPMAIF_PD_AP_DL_L2TICR0		NRL2_DPMAIF_AO_UL_APDL_L2TIMCR0
+#define DPMAIF_PD_AP_DL_L2TISR0		NRL2_DPMAIF_AO_UL_APDL_L2TIMSR0
+#define DPMAIF_PD_AP_IP_BUSY		NRL2_DPMAIF_AP_MISC_AP_IP_BUSY
+#define DPMAIF_PD_AP_DLUL_IP_BUSY_MASK	NRL2_DPMAIF_AO_UL_AP_DL_UL_IP_BUSY_MASK
+
+/* dpmaif ao dl config. */
+#define DPMAIF_AO_DL_PKTINFO_CONO	NRL2_DPMAIF_AO_DL_PKTINFO_CON0
+#define DPMAIF_AO_DL_PKTINFO_CON1	NRL2_DPMAIF_AO_DL_PKTINFO_CON1
+#define DPMAIF_AO_DL_PKTINFO_CON2	NRL2_DPMAIF_AO_DL_PKTINFO_CON2
+#define DPMAIF_AO_DL_RDY_CHK_THRES	NRL2_DPMAIF_AO_DL_RDY_CHK_THRES
+#define DPMAIF_AO_DL_BAT_STA2		NRL2_DPMAIF_AO_DL_BAT_STA2
+#define DPMAIF_AO_DL_BAT_STA3		NRL2_DPMAIF_AO_DL_BAT_STA3
+#define DPMAIF_AO_DL_PIT_STA2		NRL2_DPMAIF_AO_DL_PIT_STA2
+#define DPMAIF_AO_DL_PIT_STA3		NRL2_DPMAIF_AO_DL_PIT_STA3
+#define DPMAIF_AO_DL_FRG_CHK_THRES	NRL2_DPMAIF_AO_DL_RDY_CHK_FRG_THRES
+#define DPMAIF_AO_DL_FRG_STA2		NRL2_DPMAIF_AO_DL_FRGBAT_STA2
+
+/* DPMAIF AO register */
+#define DPMAIF_AP_RGU_ASSERT		0x10001120
+#define DPMAIF_AP_RGU_DEASSERT		0x10001124
+#define DPMAIF_AP_RST_BIT		BIT(4)
+#define DPMAIF_AP_AO_RGU_ASSERT		0x10001140
+#define DPMAIF_AP_AO_RGU_DEASSERT	0x10001144
+#define DPMAIF_AP_AO_RST_BIT		BIT(3)
+
+/* hw configuration */
+#define DPMAIF_ULQSAR_N(q_num)\
+	((DPMAIF_PD_UL_CHNL0_CON0) + (0x10 * (q_num)))
+
+#define DPMAIF_UL_DRBSIZE_ADDRH_N(q_num)\
+	((DPMAIF_PD_UL_CHNL0_CON1) + (0x10 * (q_num)))
+
+#define DPMAIF_UL_DRB_ADDRH_N(q_num)\
+	((DPMAIF_PD_UL_CHNL0_CON2) + (0x10 * (q_num)))
+
+#define DPMAIF_ULQ_STA0_N(q_num)\
+	((NRL2_DPMAIF_AO_UL_CH0_STA) + (0x04 * (q_num)))
+
+#define DPMAIF_ULQ_ADD_DESC_CH_N(q_num)\
+	((DPMAIF_PD_UL_ADD_DESC_CH) + (0x04 * (q_num)))
+
+#define DPMAIF_ULQS			0x1F
+
+#define DPMAIF_UL_ADD_NOT_READY		BIT(31)
+#define DPMAIF_UL_ADD_UPDATE		BIT(31)
+#define DPMAIF_UL_ALL_QUE_ARB_EN	(DPMAIF_ULQS << 8)
+
+#define DPMAIF_DL_ADD_UPDATE		BIT(31)
+#define DPMAIF_DL_ADD_NOT_READY		BIT(31)
+#define DPMAIF_DL_FRG_ADD_UPDATE	BIT(16)
+
+#define DPMAIF_DL_BAT_INIT_ALLSET	BIT(0)
+#define DPMAIF_DL_BAT_FRG_INIT		BIT(16)
+#define DPMAIF_DL_BAT_INIT_EN		BIT(31)
+#define DPMAIF_DL_BAT_INIT_NOT_READY	BIT(31)
+#define DPMAIF_DL_BAT_INIT_ONLY_ENABLE_BIT	0
+
+#define DPMAIF_DL_PIT_INIT_ALLSET	BIT(0)
+#define DPMAIF_DL_PIT_INIT_EN		BIT(31)
+#define DPMAIF_DL_PIT_INIT_NOT_READY	BIT(31)
+
+#define DPMAIF_PKT_ALIGN64_MODE		0
+#define DPMAIF_PKT_ALIGN128_MODE	1
+
+#define DPMAIF_BAT_REMAIN_SZ_BASE	16
+#define DPMAIF_BAT_BUFFER_SZ_BASE	128
+#define DPMAIF_FRG_BUFFER_SZ_BASE	128
+
+#define DPMAIF_PIT_SIZE_MSK		0x3FFFF
+
+#define DPMAIF_BAT_EN_MSK		BIT(16)
+#define DPMAIF_FRG_EN_MSK		BIT(28)
+#define DPMAIF_BAT_SIZE_MSK		0xFFFF
+
+#define DPMAIF_BAT_BID_MAXCNT_MSK	0xFFFF0000
+#define DPMAIF_BAT_REMAIN_MINSZ_MSK	0x0000FF00
+#define DPMAIF_PIT_CHK_NUM_MSK		0xFF000000
+#define DPMAIF_BAT_BUF_SZ_MSK		0x0001FF00
+#define DPMAIF_FRG_BUF_SZ_MSK		0x0001FF00
+#define DPMAIF_BAT_RSV_LEN_MSK		0x000000FF
+#define DPMAIF_PKT_ALIGN_MSK		(0x3 << 22)
+
+#define DPMAIF_BAT_CHECK_THRES_MSK	(0x3F << 16)
+#define DPMAIF_FRG_CHECK_THRES_MSK	0xFF
+#define DPMAIF_PKT_ALIGN_EN		BIT(23)
+#define DPMAIF_DRB_SIZE_MSK		0x0000FFFF
+
+#define DPMAIF_DL_PIT_WRIDX_MSK		0x3FFFF
+#define DPMAIF_DL_BAT_WRIDX_MSK		0x3FFFF
+#define DPMAIF_DL_FRG_WRIDX_MSK		0x3FFFF
+
+/* DPMAIF_PD_UL_DBG_STA2 */
+#define DPMAIF_UL_IDLE_STS_MSK		BIT(11)
+#define DPMAIF_UL_IDLE_STS		BIT(11)
+
+/* DPMAIF_PD_DL_DBG_STA1 */
+#define DPMAIF_DL_IDLE_STS		BIT(23)
+#define DPMAIF_DL_PKT_CHECKSUM_EN	BIT(31)
+#define DPMAIF_PORT_MODE_MSK		BIT(30)
+#define DPMAIF_PORT_MODE_PCIE		BIT(30)
+
+/* BASE_NADDR_NRL2_DPMAIF_WDMA */
+#define DPMAIF_DL_BAT_CACHE_PRI		BIT(22)
+#define DPMAIF_DL_BURST_PIT_EN		BIT(13)
+#define DPMAIF_MEM_CLR_MASK		BIT(0)
+#define DPMAIF_SRAM_SYNC_MASK		BIT(0)
+#define DPMAIF_UL_INIT_DONE_MASK	BIT(0)
+#define DPMAIF_DL_INIT_DONE_MASK	BIT(0)
+
+#define DPMAIF_DL_PIT_SEQ_MSK		0xFF
+#define DPMAIF_PCIE_MODE_SET_VALUE	0x55
+
+#define DPMAIF_UDL_IP_BUSY_MSK		BIT(0)
+
+#define DP_UL_INT_DONE_OFFSET		0
+#define DP_UL_INT_EMPTY_OFFSET		5
+#define DP_UL_INT_MD_NOTRDY_OFFSET	10
+#define DP_UL_INT_PWR_NOTRDY_OFFSET	15
+#define DP_UL_INT_LEN_ERR_OFFSET	20
+
+/* Enable and mask/unmaks UL interrupt */
+#define DPMAIF_UL_INT_QDONE_MSK			(DPMAIF_ULQS << DP_UL_INT_DONE_OFFSET)
+#define DPMAIF_UL_TOP0_INT_MSK			BIT(9)
+
+/* UL interrupt status */
+#define DPMAIF_UL_INT_QDONE		(DPMAIF_ULQS << DP_UL_INT_DONE_OFFSET)
+
+/* Enable and  Mask/unmask DL interrupt */
+#define DPMAIF_DL_INT_BATCNT_LEN_ERR_MSK	BIT(2)
+#define DPMAIF_DL_INT_FRG_LEN_ERR_MSK		BIT(7)
+#define DPMAIF_DL_INT_DLQ0_QDONE_MSK		BIT(8)
+#define DPMAIF_DL_INT_DLQ1_QDONE_MSK		BIT(9)
+#define DPMAIF_DL_INT_DLQ0_PITCNT_LEN_ERR_MSK	BIT(10)
+#define DPMAIF_DL_INT_DLQ1_PITCNT_LEN_ERR_MSK	BIT(11)
+#define DPMAIF_DL_INT_Q2TOQ1_MSK		BIT(24)
+#define DPMAIF_DL_INT_Q2APTOP_MSK		BIT(25)
+
+/* DL interrupt status */
+#define DPMAIF_DL_INT_DUMMY_STATUS		BIT(0)
+#define DPMAIF_DL_INT_BATCNT_LEN_ERR		BIT(2)
+#define DPMAIF_DL_INT_FRG_LEN_ERR		BIT(7)
+#define DPMAIF_DL_INT_DLQ0_PITCNT_LEN_ERR	BIT(8)
+#define DPMAIF_DL_INT_DLQ1_PITCNT_LEN_ERR	BIT(9)
+#define DPMAIF_DL_INT_DLQ0_QDONE		BIT(13)
+#define DPMAIF_DL_INT_DLQ1_QDONE		BIT(14)
+
+/* DPMAIF LRO HW configure */
+#define DPMAIF_HPC_LRO_PATH_DF			3
+/* 0: HPC rules add by HW; 1: HPC rules add by Host */
+#define DPMAIF_HPC_ADD_MODE_DF			0
+#define DPMAIF_HPC_TOTAL_NUM			8
+#define DPMAIF_HPC_MAX_TOTAL_NUM		8
+#define DPMAIF_AGG_MAX_LEN_DF			65535
+#define DPMAIF_AGG_TBL_ENT_NUM_DF		50
+#define DPMAIF_HASH_PRIME_DF			13
+#define DPMAIF_MID_TIMEOUT_THRES_DF		100
+#define DPMAIF_LRO_TIMEOUT_THRES_DF		100
+#define DPMAIF_LRO_PRS_THRES_DF			10
+#define DPMAIF_LRO_HASH_BIT_CHOOSE_DF		0
+
+#define DPMAIF_LROPIT_EN_MSK			0x100000
+#define DPMAIF_LROPIT_CHAN_OFS			16
+#define DPMAIF_ADD_LRO_PIT_CHAN_OFS		20
+
+#define DPMAIF_DL_PIT_BYTE_SIZE		16
+#define DPMAIF_DL_BAT_BYTE_SIZE		8
+#define DPMAIF_DL_FRG_BYTE_SIZE		8
+#define DPMAIF_UL_DRB_BYTE_SIZE		16
+
+#define DPMAIF_UL_DRB_ENTRY_WORD	(DPMAIF_UL_DRB_BYTE_SIZE >> 2)
+#define DPMAIF_DL_PIT_ENTRY_WORD	(DPMAIF_DL_PIT_BYTE_SIZE >> 2)
+#define DPMAIF_DL_BAT_ENTRY_WORD	(DPMAIF_DL_BAT_BYTE_SIZE >> 2)
+
+#define DPMAIF_HW_BAT_REMAIN		64
+#define DPMAIF_HW_PKT_BIDCNT		1
+
+#define DPMAIF_HW_CHK_BAT_NUM		62
+#define DPMAIF_HW_CHK_FRG_NUM		3
+#define DPMAIF_HW_CHK_PIT_NUM		(2 * DPMAIF_HW_CHK_BAT_NUM)
+
+#define DPMAIF_DLQ_NUM			2
+#define DPMAIF_ULQ_NUM			5
+#define DPMAIF_PKT_BIDCNT		1
+
+#define DPMAIF_TOEPLITZ_HASH_EN		1
+
+/* word num */
+#define DPMAIF_HASH_SEC_KEY_NUM		40
+#define DPMAIF_HASH_DEFAULT_VALUE	0
+#define DPMAIF_HASH_BIT_MASK_DF		0x7
+#define DPMAIF_HASH_INDR_MASK_DF	0xF0
+
+/* 10k */
+#define DPMAIF_HPC_STATS_THRESHOLD	0x2800
+
+/* 0x7A1- 1s: unit:512us */
+#define DPMAIF_HPC_STATS_TIMER_CFG	0
+
+#define DPMAIF_HASH_INDR_SIZE		(DPMAIF_HASH_BIT_MASK_DF + 1)
+#define DPMAIF_HASH_INDR_MASK		0xFF00FFFF
+#define DPMAIF_HASH_DEFAULT_V_MASK	0xFFFFFF00
+#define DPMAIF_HASH_BIT_MASK		0xFFFFF0FF
+
+/* dpmaif interrupt configuration */
+#define DPMAIF_AP_UL_L2INTR_EN_MASK DPMAIF_UL_INT_QDONE_MSK
+
+#define DPMAIF_AP_DL_L2INTR_EN_MASK\
+	(DPMAIF_DL_INT_DLQ0_QDONE_MSK | DPMAIF_DL_INT_DLQ1_QDONE_MSK |\
+	DPMAIF_DL_INT_DLQ0_PITCNT_LEN_ERR_MSK | DPMAIF_DL_INT_DLQ1_PITCNT_LEN_ERR_MSK |\
+	DPMAIF_DL_INT_BATCNT_LEN_ERR_MSK | DPMAIF_DL_INT_FRG_LEN_ERR_MSK)
+
+#define DPMAIF_AP_UDL_IP_BUSY_EN_MASK (DPMAIF_UDL_IP_BUSY_MSK)
+
+/* dpmaif interrupt mask status by interrupt source */
+#define DPMAIF_SRC0_DL_STATUS_MASK\
+	(DPMAIF_DL_INT_DLQ0_QDONE | DPMAIF_DL_INT_DLQ0_PITCNT_LEN_ERR |\
+	DPMAIF_DL_INT_BATCNT_LEN_ERR | DPMAIF_DL_INT_FRG_LEN_ERR | DPMAIF_DL_INT_DUMMY_STATUS)
+
+#define DPMAIF_SRC1_DL_STATUS_MASK\
+	(DPMAIF_DL_INT_DLQ1_QDONE | DPMAIF_DL_INT_DLQ1_PITCNT_LEN_ERR)
+
+#endif
-- 
2.32.0

