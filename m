Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A87AE692F84
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 09:45:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbjBKIpb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Feb 2023 03:45:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjBKIpa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Feb 2023 03:45:30 -0500
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D84970734;
        Sat, 11 Feb 2023 00:44:59 -0800 (PST)
X-UUID: 5bd50e62a9e811eda06fc9ecc4dadd91-20230211
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=giOZWMea9NeArDizvXVeZbpn2CI1IBx9j6TNvzgo88g=;
        b=cL0akxnLdXx+SkhFAabn/5G1jSKQh54Z1ZkJX9KBunYYBfwfWn5EbmPZ8pCDP4wMwj5dGl+gSsrkMbPWucpBDsnnKj86cXy/MFmyyABKOCCHZZeeykHyi+n0YagNnkwC23rvv0qswRiSF5iotA7hvbfu/8bhzphhq5sa+mPje1Q=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.19,REQID:7654c83e-f20f-4014-a5e9-eda6da9221a8,IP:0,U
        RL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
        N:release,TS:-25
X-CID-META: VersionHash:885ddb2,CLOUDID:9793f756-dd49-462e-a4be-2143a3ddc739,B
        ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:11|1,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0
X-CID-BVR: 0
X-UUID: 5bd50e62a9e811eda06fc9ecc4dadd91-20230211
Received: from mtkmbs11n1.mediatek.inc [(172.21.101.185)] by mailgw01.mediatek.com
        (envelope-from <yanchao.yang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1043659035; Sat, 11 Feb 2023 16:44:55 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 mtkmbs13n1.mediatek.inc (172.21.101.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.792.15; Sat, 11 Feb 2023 16:44:54 +0800
Received: from mcddlt001.gcn.mediatek.inc (10.19.240.15) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.792.15 via Frontend Transport; Sat, 11 Feb 2023 16:44:52 +0800
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
        Yanchao Yang <yanchao.yang@mediatek.com>,
        Lambert Wang <lambert.wang@mediatek.com>,
        Mingchuang Qiao <mingchuang.qiao@mediatek.com>,
        Xiayu Zhang <xiayu.zhang@mediatek.com>,
        Haozhe Chang <haozhe.chang@mediatek.com>
Subject: [PATCH net-next v3 09/10] net: wwan: tmi: Introduce WWAN interface
Date:   Sat, 11 Feb 2023 16:37:31 +0800
Message-ID: <20230211083732.193650-10-yanchao.yang@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20230211083732.193650-1-yanchao.yang@mediatek.com>
References: <20230211083732.193650-1-yanchao.yang@mediatek.com>
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

Creates the WWAN interface which implements the wwan_ops for registration with
the WWAN framework. WWAN interface also implements the net_device_ops functions
used by the network devices. Network device operations include open, stop,
start transmission and get states.

Signed-off-by: Yanchao Yang <yanchao.yang@mediatek.com>
Signed-off-by: Hua Yang <hua.yang@mediatek.com>
---
 drivers/net/wwan/mediatek/Makefile         |   3 +-
 drivers/net/wwan/mediatek/mtk_data_plane.h |  12 +
 drivers/net/wwan/mediatek/mtk_dpmaif.c     |  63 ++-
 drivers/net/wwan/mediatek/mtk_wwan.c       | 589 +++++++++++++++++++++
 4 files changed, 662 insertions(+), 5 deletions(-)
 create mode 100644 drivers/net/wwan/mediatek/mtk_wwan.c

diff --git a/drivers/net/wwan/mediatek/Makefile b/drivers/net/wwan/mediatek/Makefile
index 8c37a7f9d598..9fa5ee39b4a9 100644
--- a/drivers/net/wwan/mediatek/Makefile
+++ b/drivers/net/wwan/mediatek/Makefile
@@ -12,7 +12,8 @@ mtk_tmi-y = \
 	mtk_port.o \
 	mtk_port_io.o \
 	mtk_fsm.o \
-	mtk_dpmaif.o
+	mtk_dpmaif.o \
+	mtk_wwan.o
 
 ccflags-y += -I$(srctree)/$(src)/
 ccflags-y += -I$(srctree)/$(src)/pcie/
diff --git a/drivers/net/wwan/mediatek/mtk_data_plane.h b/drivers/net/wwan/mediatek/mtk_data_plane.h
index f6d665c6b84b..ba7ff25c2001 100644
--- a/drivers/net/wwan/mediatek/mtk_data_plane.h
+++ b/drivers/net/wwan/mediatek/mtk_data_plane.h
@@ -23,6 +23,7 @@ enum mtk_data_feature {
 
 struct mtk_data_blk {
 	struct mtk_md_dev *mdev;
+	struct mtk_wwan_ctlb *wcb;
 	struct mtk_dpmaif_ctlb *dcb;
 };
 
@@ -83,9 +84,20 @@ struct mtk_data_trans_info {
 	struct napi_struct **napis;
 };
 
+struct mtk_data_port_ops {
+	int (*init)(struct mtk_data_blk *data_blk, struct mtk_data_trans_info *trans_info);
+	void (*exit)(struct mtk_data_blk *data_blk);
+	int (*recv)(struct mtk_data_blk *data_blk, struct sk_buff *skb,
+		    unsigned char q_id, unsigned char if_id);
+	void (*notify)(struct mtk_data_blk *data_blk, enum mtk_data_evt evt, u64 data);
+};
+
+int mtk_wwan_cmd_execute(struct net_device *dev, enum mtk_data_cmd_type cmd, void *data);
+u16 mtk_wwan_select_queue(struct net_device *dev, struct sk_buff *skb, struct net_device *sb_dev);
 int mtk_data_init(struct mtk_md_dev *mdev);
 int mtk_data_exit(struct mtk_md_dev *mdev);
 
+extern struct mtk_data_port_ops data_port_ops;
 extern struct mtk_data_trans_ops data_trans_ops;
 
 #endif /* __MTK_DATA_PLANE_H__ */
diff --git a/drivers/net/wwan/mediatek/mtk_dpmaif.c b/drivers/net/wwan/mediatek/mtk_dpmaif.c
index e5696ee0fd6e..ae7b6966d325 100644
--- a/drivers/net/wwan/mediatek/mtk_dpmaif.c
+++ b/drivers/net/wwan/mediatek/mtk_dpmaif.c
@@ -343,13 +343,14 @@ enum dpmaif_dump_flag {
 
 struct mtk_dpmaif_ctlb {
 	struct mtk_data_blk *data_blk;
+	struct mtk_data_port_ops *port_ops;
 	struct dpmaif_drv_info *drv_info;
 	struct napi_struct *napi[DPMAIF_RXQ_CNT_MAX];
 
 	enum dpmaif_state dpmaif_state;
 	bool dpmaif_user_ready;
 	bool trans_enabled;
-	struct mutex trans_ctl_lock; /* protect structure fields */
+	struct mutex trans_ctl_lock;/* protect structure fields */
 	const struct dpmaif_res_cfg *res_cfg;
 
 	struct dpmaif_cmd_srv cmd_srv;
@@ -1158,6 +1159,8 @@ static int mtk_dpmaif_tx_rel_internal(struct dpmaif_txq *txq,
 		txq->drb_rel_rd_idx = cur_idx;
 
 		atomic_inc(&txq->budget);
+		if (atomic_read(&txq->budget) > txq->drb_cnt / 8)
+			dcb->port_ops->notify(dcb->data_blk, DATA_EVT_TX_START, (u64)1 << txq->id);
 	}
 
 	*real_rel_cnt = i;
@@ -2180,6 +2183,38 @@ static int mtk_dpmaif_irq_exit(struct mtk_dpmaif_ctlb *dcb)
 	return 0;
 }
 
+static int mtk_dpmaif_port_init(struct mtk_dpmaif_ctlb *dcb)
+{
+	struct mtk_data_trans_info trans_info;
+	struct dpmaif_rxq *rxq;
+	int ret;
+	int i;
+
+	memset(&trans_info, 0x00, sizeof(struct mtk_data_trans_info));
+	trans_info.txq_cnt = dcb->res_cfg->txq_cnt;
+	trans_info.rxq_cnt = dcb->res_cfg->rxq_cnt;
+	trans_info.max_mtu = dcb->bat_info.max_mtu;
+
+	for (i = 0; i < trans_info.rxq_cnt; i++) {
+		rxq = &dcb->rxqs[i];
+		dcb->napi[i] = &rxq->napi;
+	}
+	trans_info.napis = dcb->napi;
+
+	dcb->port_ops = &data_port_ops;
+	ret = dcb->port_ops->init(dcb->data_blk, &trans_info);
+	if (ret < 0)
+		dev_err(DCB_TO_DEV(dcb),
+			"Failed to initialize data port layer, ret=%d\n", ret);
+
+	return ret;
+}
+
+static void mtk_dpmaif_port_exit(struct mtk_dpmaif_ctlb *dcb)
+{
+	dcb->port_ops->exit(dcb->data_blk);
+}
+
 static int mtk_dpmaif_hw_init(struct mtk_dpmaif_ctlb *dcb)
 {
 	struct dpmaif_bat_ring *bat_ring;
@@ -2284,9 +2319,14 @@ static int mtk_dpmaif_stop(struct mtk_dpmaif_ctlb *dcb)
 
 	dcb->dpmaif_state = DPMAIF_STATE_PWROFF;
 
+	dcb->port_ops->notify(dcb->data_blk, DATA_EVT_TX_STOP, 0xff);
+
 	mtk_dpmaif_tx_srvs_stop(dcb);
 
 	mtk_dpmaif_trans_ctl(dcb, false);
+
+	dcb->port_ops->notify(dcb->data_blk, DATA_EVT_RX_STOP, 0xff);
+
 out:
 	return 0;
 }
@@ -2304,6 +2344,8 @@ static void mtk_dpmaif_fsm_callback(struct mtk_fsm_param *fsm_param, void *data)
 	case FSM_STATE_OFF:
 		mtk_dpmaif_stop(dcb);
 
+		dcb->port_ops->notify(dcb->data_blk, DATA_EVT_UNREG_DEV, 0);
+
 		flush_work(&dcb->cmd_srv.work);
 
 		mtk_dpmaif_sw_reset(dcb);
@@ -2313,6 +2355,7 @@ static void mtk_dpmaif_fsm_callback(struct mtk_fsm_param *fsm_param, void *data)
 			mtk_dpmaif_start(dcb);
 		break;
 	case FSM_STATE_READY:
+		dcb->port_ops->notify(dcb->data_blk, DATA_EVT_REG_DEV, 0);
 		break;
 	default:
 		break;
@@ -2385,6 +2428,12 @@ static int mtk_dpmaif_sw_init(struct mtk_data_blk *data_blk, const struct dpmaif
 		goto err_init_drv_res;
 	}
 
+	ret = mtk_dpmaif_port_init(dcb);
+	if (ret < 0) {
+		dev_err(DCB_TO_DEV(dcb), "Failed to initialize data port, ret=%d\n", ret);
+		goto err_init_port;
+	}
+
 	ret = mtk_dpmaif_fsm_init(dcb);
 	if (ret < 0) {
 		dev_err(DCB_TO_DEV(dcb), "Failed to initialize dpmaif fsm, ret=%d\n", ret);
@@ -2402,6 +2451,8 @@ static int mtk_dpmaif_sw_init(struct mtk_data_blk *data_blk, const struct dpmaif
 err_init_irq:
 	mtk_dpmaif_fsm_exit(dcb);
 err_init_fsm:
+	mtk_dpmaif_port_exit(dcb);
+err_init_port:
 	mtk_dpmaif_drv_res_exit(dcb);
 err_init_drv_res:
 	mtk_dpmaif_cmd_srvs_exit(dcb);
@@ -2429,6 +2480,8 @@ static int mtk_dpmaif_sw_exit(struct mtk_data_blk *data_blk)
 
 	mtk_dpmaif_irq_exit(dcb);
 	mtk_dpmaif_fsm_exit(dcb);
+
+	mtk_dpmaif_port_exit(dcb);
 	mtk_dpmaif_drv_res_exit(dcb);
 	mtk_dpmaif_cmd_srvs_exit(dcb);
 	mtk_dpmaif_tx_srvs_exit(dcb);
@@ -2568,7 +2621,6 @@ static int mtk_dpmaif_rx_set_data_to_skb(struct dpmaif_rxq *rxq, struct dpmaif_p
 	if (FIELD_GET(PIT_PD_HD_OFFSET, le32_to_cpu(pit_info->pd_footer)) != 0)
 		data_len += (FIELD_GET(PIT_PD_HD_OFFSET, le32_to_cpu(pit_info->pd_footer)) * 4);
 
-	/* Check and rebuild skb. */
 	new_skb->len = 0;
 	skb_reset_tail_pointer(new_skb);
 	skb_reserve(new_skb, data_offset);
@@ -2686,6 +2738,7 @@ static int mtk_dpmaif_rx_skb(struct dpmaif_rxq *rxq, struct dpmaif_rx_record *rx
 
 	skb_record_rx_queue(new_skb, rxq->id);
 
+	ret = dcb->port_ops->recv(dcb->data_blk, new_skb, rxq->id, rx_record->cur_ch_id);
 	dcb->traffic_stats.rx_packets[rxq->id]++;
 out:
 	return ret;
@@ -2917,10 +2970,12 @@ static int mtk_dpmaif_send_pkt(struct mtk_dpmaif_ctlb *dcb, struct sk_buff *skb,
 
 	vq = &dcb->tx_vqs[vq_id];
 	srv_id = dcb->res_cfg->tx_vq_srv_map[vq_id];
-	if (likely(skb_queue_len(&vq->list) < vq->max_len))
+	if (likely(skb_queue_len(&vq->list) < vq->max_len)) {
 		skb_queue_tail(&vq->list, skb);
-	else
+	} else {
+		dcb->port_ops->notify(dcb->data_blk, DATA_EVT_TX_STOP, (u64)1 << vq_id);
 		ret = -EBUSY;
+	}
 
 	mtk_dpmaif_wake_up_tx_srv(&dcb->tx_srvs[srv_id]);
 
diff --git a/drivers/net/wwan/mediatek/mtk_wwan.c b/drivers/net/wwan/mediatek/mtk_wwan.c
new file mode 100644
index 000000000000..a9249758edd0
--- /dev/null
+++ b/drivers/net/wwan/mediatek/mtk_wwan.c
@@ -0,0 +1,589 @@
+// SPDX-License-Identifier: BSD-3-Clause-Clear
+/*
+ * Copyright (c) 2022, MediaTek Inc.
+ */
+
+#include <linux/completion.h>
+#include <linux/etherdevice.h>
+#include <linux/netdevice.h>
+#include <linux/skbuff.h>
+#include <linux/types.h>
+#include <linux/wwan.h>
+#include <net/pkt_sched.h>
+#include <uapi/linux/if.h>
+#include <uapi/linux/if_arp.h>
+#include <uapi/linux/if_link.h>
+
+#include "mtk_data_plane.h"
+#include "mtk_dev.h"
+
+#define MTK_NETDEV_MAX		20
+#define MTK_DFLT_INTF_ID	0
+#define MTK_NETDEV_WDT (HZ)
+#define MTK_CMD_WDT (HZ)
+#define MTK_MAX_INTF_ID (MTK_NETDEV_MAX - 1)
+#define MTK_NAPI_POLL_WEIGHT	128
+
+static unsigned int napi_budget = MTK_NAPI_POLL_WEIGHT;
+
+struct mtk_wwan_instance {
+	struct mtk_wwan_ctlb *wcb;
+	struct rtnl_link_stats64 stats;
+	unsigned long long tx_busy;
+	struct net_device *netdev;
+	unsigned int intf_id;
+};
+
+struct mtk_wwan_ctlb {
+	struct mtk_data_blk *data_blk;
+	struct mtk_md_dev *mdev;
+	struct mtk_data_trans_ops *trans_ops;
+	struct mtk_wwan_instance __rcu *wwan_inst[MTK_NETDEV_MAX];
+	struct napi_struct **napis;
+	struct net_device dummy_dev;
+
+	u32 cap;
+	atomic_t napi_enabled;
+	unsigned int max_mtu;
+	unsigned int active_cnt;
+	unsigned char txq_num;
+	unsigned char rxq_num;
+	bool reg_done;
+};
+
+static void mtk_wwan_set_skb(struct sk_buff *skb, struct net_device *netdev)
+{
+	unsigned int pkt_type;
+
+	pkt_type = skb->data[0] & 0xF0;
+
+	if (pkt_type == IPV4_VERSION)
+		skb->protocol = htons(ETH_P_IP);
+	else
+		skb->protocol = htons(ETH_P_IPV6);
+
+	skb->dev = netdev;
+}
+
+static int mtk_wwan_data_recv(struct mtk_data_blk *data_blk, struct sk_buff *skb,
+			      unsigned char q_id, unsigned char intf_id)
+{
+	struct mtk_wwan_instance *wwan_inst;
+	struct net_device *netdev;
+	struct napi_struct *napi;
+
+	if (unlikely(!data_blk || !data_blk->wcb))
+		goto err_rx;
+
+	if (intf_id > MTK_MAX_INTF_ID) {
+		dev_err(data_blk->mdev->dev, "Invalid interface id=%d\n", intf_id);
+		goto err_rx;
+	}
+
+	rcu_read_lock();
+	wwan_inst = rcu_dereference(data_blk->wcb->wwan_inst[intf_id]);
+
+	if (unlikely(!wwan_inst)) {
+		dev_err(data_blk->mdev->dev, "Invalid pointer wwan_inst is NULL\n");
+		rcu_read_unlock();
+		goto err_rx;
+	}
+
+	napi = data_blk->wcb->napis[q_id];
+	netdev = wwan_inst->netdev;
+
+	mtk_wwan_set_skb(skb, netdev);
+
+	wwan_inst->stats.rx_packets++;
+	wwan_inst->stats.rx_bytes += skb->len;
+
+	napi_gro_receive(napi, skb);
+
+	rcu_read_unlock();
+	return 0;
+
+err_rx:
+	dev_kfree_skb_any(skb);
+	return -EINVAL;
+}
+
+static void mtk_wwan_napi_enable(struct mtk_wwan_ctlb *wcb)
+{
+	int i;
+
+	if (atomic_cmpxchg(&wcb->napi_enabled, 0, 1) == 0) {
+		for (i = 0; i < wcb->rxq_num; i++)
+			napi_enable(wcb->napis[i]);
+	}
+}
+
+static void mtk_wwan_napi_disable(struct mtk_wwan_ctlb *wcb)
+{
+	int i;
+
+	if (atomic_cmpxchg(&wcb->napi_enabled, 1, 0) == 1) {
+		for (i = 0; i < wcb->rxq_num; i++) {
+			napi_synchronize(wcb->napis[i]);
+			napi_disable(wcb->napis[i]);
+		}
+	}
+}
+
+static int mtk_wwan_open(struct net_device *dev)
+{
+	struct mtk_wwan_instance *wwan_inst = wwan_netdev_drvpriv(dev);
+	struct mtk_wwan_ctlb *wcb = wwan_inst->wcb;
+	struct mtk_data_trans_ctl trans_ctl;
+	int ret;
+
+	if (wcb->active_cnt == 0) {
+		mtk_wwan_napi_enable(wcb);
+		trans_ctl.enable = true;
+		ret = mtk_wwan_cmd_execute(dev, DATA_CMD_TRANS_CTL, &trans_ctl);
+		if (ret < 0) {
+			dev_err(wcb->mdev->dev, "Failed to enable trans\n");
+			goto err_ctl;
+		}
+	}
+
+	wcb->active_cnt++;
+
+	netif_tx_start_all_queues(dev);
+	netif_carrier_on(dev);
+
+	return 0;
+
+err_ctl:
+	mtk_wwan_napi_disable(wcb);
+	return ret;
+}
+
+static int mtk_wwan_stop(struct net_device *dev)
+{
+	struct mtk_wwan_instance *wwan_inst = wwan_netdev_drvpriv(dev);
+	struct mtk_wwan_ctlb *wcb = wwan_inst->wcb;
+	struct mtk_data_trans_ctl trans_ctl;
+	int ret;
+
+	netif_carrier_off(dev);
+	netif_tx_disable(dev);
+
+	if (wcb->active_cnt == 1) {
+		trans_ctl.enable = false;
+		ret = mtk_wwan_cmd_execute(dev, DATA_CMD_TRANS_CTL, &trans_ctl);
+		if (ret < 0)
+			dev_err(wcb->mdev->dev, "Failed to disable trans\n");
+		mtk_wwan_napi_disable(wcb);
+	}
+	wcb->active_cnt--;
+
+	return 0;
+}
+
+static netdev_tx_t mtk_wwan_start_xmit(struct sk_buff *skb, struct net_device *dev)
+{
+	struct mtk_wwan_instance *wwan_inst = wwan_netdev_drvpriv(dev);
+	unsigned int intf_id = wwan_inst->intf_id;
+	unsigned int skb_len = skb->len;
+	int ret;
+
+	if (unlikely(skb->len > dev->mtu)) {
+		dev_err(wwan_inst->wcb->mdev->dev,
+			"Failed to write skb,netdev=%s,len=0x%x,MTU=0x%x\n",
+			dev->name, skb->len, dev->mtu);
+		goto err_tx;
+	}
+
+	skb_set_queue_mapping(skb, 0);
+
+	ret = wwan_inst->wcb->trans_ops->send(wwan_inst->wcb->data_blk, DATA_PKT, skb, intf_id);
+	if (ret == -EBUSY) {
+		wwan_inst->tx_busy++;
+		return NETDEV_TX_BUSY;
+	} else if (ret == -EINVAL) {
+		goto err_tx;
+	}
+
+	wwan_inst->stats.tx_packets++;
+	wwan_inst->stats.tx_bytes += skb_len;
+	goto out;
+
+err_tx:
+	wwan_inst->stats.tx_errors++;
+	wwan_inst->stats.tx_dropped++;
+	dev_kfree_skb_any(skb);
+out:
+	return NETDEV_TX_OK;
+}
+
+static void mtk_wwan_get_stats(struct net_device *dev, struct rtnl_link_stats64 *stats)
+{
+	struct mtk_wwan_instance *wwan_inst = wwan_netdev_drvpriv(dev);
+
+	memcpy(stats, &wwan_inst->stats, sizeof(*stats));
+}
+
+static const struct net_device_ops mtk_netdev_ops = {
+	.ndo_open = mtk_wwan_open,
+	.ndo_stop = mtk_wwan_stop,
+	.ndo_start_xmit = mtk_wwan_start_xmit,
+	.ndo_get_stats64 = mtk_wwan_get_stats,
+};
+
+static void mtk_wwan_cmd_complete(void *data)
+{
+	struct mtk_data_cmd *event;
+	struct sk_buff *skb = data;
+
+	event = (struct mtk_data_cmd *)skb->data;
+	complete(&event->done);
+}
+
+static int mtk_wwan_cmd_check(struct net_device *dev, enum mtk_data_cmd_type cmd)
+{
+	int ret = 0;
+
+	switch (cmd) {
+	case DATA_CMD_TRANS_DUMP:
+		fallthrough;
+	case DATA_CMD_TRANS_CTL:
+		break;
+	default:
+		ret = -EOPNOTSUPP;
+		break;
+	}
+
+	return ret;
+}
+
+static struct sk_buff *mtk_wwan_cmd_alloc(enum mtk_data_cmd_type cmd, unsigned int len)
+
+{
+	struct mtk_data_cmd *event;
+	struct sk_buff *skb;
+
+	skb = dev_alloc_skb(sizeof(*event) + len);
+	if (unlikely(!skb))
+		return NULL;
+
+	skb_put(skb, len + sizeof(*event));
+	event = (struct mtk_data_cmd *)skb->data;
+	event->cmd = cmd;
+	event->len = len;
+
+	init_completion(&event->done);
+	event->data_complete = mtk_wwan_cmd_complete;
+
+	return skb;
+}
+
+static int mtk_wwan_cmd_send(struct net_device *dev, struct sk_buff *skb)
+{
+	struct mtk_wwan_instance *wwan_inst = wwan_netdev_drvpriv(dev);
+	struct mtk_data_cmd *event = (struct mtk_data_cmd *)skb->data;
+	int ret;
+
+	ret = wwan_inst->wcb->trans_ops->send(wwan_inst->wcb->data_blk, DATA_CMD, skb, 0);
+	if (ret < 0)
+		return ret;
+
+	if (!wait_for_completion_timeout(&event->done, MTK_CMD_WDT))
+		return -ETIMEDOUT;
+
+	if (event->ret < 0)
+		return event->ret;
+
+	return 0;
+}
+
+int mtk_wwan_cmd_execute(struct net_device *dev,
+			 enum mtk_data_cmd_type cmd, void *data)
+{
+	struct mtk_wwan_instance *wwan_inst;
+	struct sk_buff *skb;
+	int ret;
+
+	if (mtk_wwan_cmd_check(dev, cmd))
+		return -EOPNOTSUPP;
+
+	skb = mtk_wwan_cmd_alloc(cmd, sizeof(void *));
+	if (unlikely(!skb))
+		return -ENOMEM;
+
+	SKB_TO_CMD_DATA(skb) = data;
+
+	ret = mtk_wwan_cmd_send(dev, skb);
+	if (ret < 0) {
+		wwan_inst = wwan_netdev_drvpriv(dev);
+		dev_err(wwan_inst->wcb->mdev->dev,
+			"Failed to excute command:ret=%d,cmd=%d\n", ret, cmd);
+	}
+
+	if (likely(skb))
+		dev_kfree_skb_any(skb);
+
+	return ret;
+}
+
+static int mtk_wwan_start_txq(struct mtk_wwan_ctlb *wcb, u32 qmask)
+{
+	struct mtk_wwan_instance *wwan_inst;
+	struct net_device *dev;
+	int i;
+
+	rcu_read_lock();
+	for (i = 0; i < MTK_NETDEV_MAX; i++) {
+		wwan_inst = rcu_dereference(wcb->wwan_inst[i]);
+		if (!wwan_inst)
+			continue;
+
+		dev = wwan_inst->netdev;
+
+		if (!(dev->flags & IFF_UP))
+			continue;
+
+		netif_tx_wake_all_queues(dev);
+		netif_carrier_on(dev);
+	}
+	rcu_read_unlock();
+
+	return 0;
+}
+
+static int mtk_wwan_stop_txq(struct mtk_wwan_ctlb *wcb, u32 qmask)
+{
+	struct mtk_wwan_instance *wwan_inst;
+	struct net_device *dev;
+	int i;
+
+	rcu_read_lock();
+	for (i = 0; i < MTK_NETDEV_MAX; i++) {
+		wwan_inst = rcu_dereference(wcb->wwan_inst[i]);
+		if (!wwan_inst)
+			continue;
+
+		dev = wwan_inst->netdev;
+
+		if (!(dev->flags & IFF_UP))
+			continue;
+
+		netif_carrier_off(dev);
+		netif_tx_stop_all_queues(dev);
+	}
+	rcu_read_unlock();
+
+	return 0;
+}
+
+static void mtk_wwan_napi_exit(struct mtk_wwan_ctlb *wcb)
+{
+	int i;
+
+	for (i = 0; i < wcb->rxq_num; i++) {
+		if (!wcb->napis[i])
+			continue;
+		netif_napi_del(wcb->napis[i]);
+	}
+}
+
+static int mtk_wwan_napi_init(struct mtk_wwan_ctlb *wcb, struct net_device *dev)
+{
+	int i;
+
+	for (i = 0; i < wcb->rxq_num; i++) {
+		if (!wcb->napis[i]) {
+			dev_err(wcb->mdev->dev, "Invalid napi pointer, napi=%d", i);
+			goto err;
+		}
+		netif_napi_add_weight(dev, wcb->napis[i], wcb->trans_ops->poll, napi_budget);
+	}
+
+	return 0;
+
+err:
+	for (--i; i >= 0; i--)
+		netif_napi_del(wcb->napis[i]);
+	return -EINVAL;
+}
+
+static void mtk_wwan_setup(struct net_device *dev)
+{
+	dev->watchdog_timeo = MTK_NETDEV_WDT;
+	dev->mtu = ETH_DATA_LEN;
+	dev->min_mtu = ETH_MIN_MTU;
+
+	dev->features = NETIF_F_SG;
+	dev->hw_features = NETIF_F_SG;
+
+	dev->features |= NETIF_F_HW_CSUM;
+	dev->hw_features |= NETIF_F_HW_CSUM;
+
+	dev->features |= NETIF_F_RXCSUM;
+	dev->hw_features |= NETIF_F_RXCSUM;
+
+	dev->features |= NETIF_F_GRO;
+	dev->hw_features |= NETIF_F_GRO;
+
+	dev->features |= NETIF_F_RXHASH;
+	dev->hw_features |= NETIF_F_RXHASH;
+
+	dev->addr_len = ETH_ALEN;
+	dev->tx_queue_len = DEFAULT_TX_QUEUE_LEN;
+
+	dev->flags = IFF_NOARP;
+	dev->type = ARPHRD_NONE;
+
+	dev->needs_free_netdev = true;
+
+	dev->netdev_ops = &mtk_netdev_ops;
+}
+
+static int mtk_wwan_newlink(void *ctxt, struct net_device *dev, u32 intf_id,
+			    struct netlink_ext_ack *extack)
+{
+	struct mtk_wwan_instance *wwan_inst = wwan_netdev_drvpriv(dev);
+	struct mtk_wwan_ctlb *wcb = ctxt;
+	int ret;
+
+	if (intf_id > MTK_MAX_INTF_ID) {
+		ret = -EINVAL;
+		goto err;
+	}
+
+	dev->max_mtu = wcb->max_mtu;
+
+	wwan_inst->wcb = wcb;
+	wwan_inst->netdev = dev;
+	wwan_inst->intf_id = intf_id;
+
+	if (rcu_access_pointer(wcb->wwan_inst[intf_id])) {
+		ret = -EBUSY;
+		goto err;
+	}
+
+	ret = register_netdevice(dev);
+	if (ret)
+		goto err;
+
+	rcu_assign_pointer(wcb->wwan_inst[intf_id], wwan_inst);
+
+	netif_device_attach(dev);
+
+	return 0;
+err:
+	return ret;
+}
+
+static void mtk_wwan_dellink(void *ctxt, struct net_device *dev,
+			     struct list_head *head)
+{
+	struct mtk_wwan_instance *wwan_inst = wwan_netdev_drvpriv(dev);
+	int intf_id = wwan_inst->intf_id;
+	struct mtk_wwan_ctlb *wcb = ctxt;
+
+	if (WARN_ON(rcu_access_pointer(wcb->wwan_inst[intf_id]) != wwan_inst))
+		return;
+
+	RCU_INIT_POINTER(wcb->wwan_inst[intf_id], NULL);
+	unregister_netdevice_queue(dev, head);
+}
+
+static const struct wwan_ops mtk_wwan_ops = {
+	.priv_size = sizeof(struct mtk_wwan_instance),
+	.setup = mtk_wwan_setup,
+	.newlink = mtk_wwan_newlink,
+	.dellink = mtk_wwan_dellink,
+};
+
+static void mtk_wwan_notify(struct mtk_data_blk *data_blk, enum mtk_data_evt evt, u64 data)
+{
+	struct mtk_wwan_ctlb *wcb;
+
+	if (unlikely(!data_blk || !data_blk->wcb))
+		return;
+
+	wcb = data_blk->wcb;
+
+	switch (evt) {
+	case DATA_EVT_TX_START:
+		mtk_wwan_start_txq(wcb, data);
+		break;
+	case DATA_EVT_TX_STOP:
+		mtk_wwan_stop_txq(wcb, data);
+		break;
+	case DATA_EVT_RX_STOP:
+		mtk_wwan_napi_disable(wcb);
+		break;
+	case DATA_EVT_REG_DEV:
+		if (!wcb->reg_done) {
+			wwan_register_ops(wcb->mdev->dev, &mtk_wwan_ops, wcb, MTK_DFLT_INTF_ID);
+			wcb->reg_done = true;
+		}
+		break;
+	case DATA_EVT_UNREG_DEV:
+		if (wcb->reg_done) {
+			wwan_unregister_ops(wcb->mdev->dev);
+			wcb->reg_done = false;
+		}
+		break;
+	default:
+		break;
+	}
+}
+
+static int mtk_wwan_init(struct mtk_data_blk *data_blk, struct mtk_data_trans_info *trans_info)
+{
+	struct mtk_wwan_ctlb *wcb;
+	int ret;
+
+	if (unlikely(!data_blk || !trans_info))
+		return -EINVAL;
+
+	wcb = devm_kzalloc(data_blk->mdev->dev, sizeof(*wcb), GFP_KERNEL);
+	if (unlikely(!wcb))
+		return -ENOMEM;
+
+	wcb->trans_ops = &data_trans_ops;
+	wcb->mdev = data_blk->mdev;
+	wcb->data_blk = data_blk;
+	wcb->napis = trans_info->napis;
+	wcb->max_mtu = trans_info->max_mtu;
+	wcb->cap = trans_info->cap;
+	wcb->rxq_num = trans_info->rxq_cnt;
+	wcb->txq_num = trans_info->txq_cnt;
+	atomic_set(&wcb->napi_enabled, 0);
+	init_dummy_netdev(&wcb->dummy_dev);
+
+	data_blk->wcb = wcb;
+
+	ret = mtk_wwan_napi_init(wcb, &wcb->dummy_dev);
+	if (ret < 0)
+		goto err_napi_init;
+
+	return 0;
+err_napi_init:
+	devm_kfree(data_blk->mdev->dev, wcb);
+	data_blk->wcb = NULL;
+
+	return ret;
+}
+
+static void mtk_wwan_exit(struct mtk_data_blk *data_blk)
+{
+	struct mtk_wwan_ctlb *wcb;
+
+	if (unlikely(!data_blk || !data_blk->wcb))
+		return;
+
+	wcb = data_blk->wcb;
+	mtk_wwan_napi_exit(wcb);
+	devm_kfree(data_blk->mdev->dev, wcb);
+	data_blk->wcb = NULL;
+}
+
+struct mtk_data_port_ops data_port_ops = {
+	.init = mtk_wwan_init,
+	.exit = mtk_wwan_exit,
+	.recv = mtk_wwan_data_recv,
+	.notify = mtk_wwan_notify,
+};
-- 
2.32.0

