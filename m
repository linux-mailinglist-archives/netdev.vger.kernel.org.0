Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C108C671BF5
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 13:23:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230228AbjARMXX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 07:23:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230298AbjARMWf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 07:22:35 -0500
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59EB15A370;
        Wed, 18 Jan 2023 03:43:47 -0800 (PST)
X-UUID: 5c7e6906972511ed945fc101203acc17-20230118
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=8jXe6U6aaHCWxNHJRPEPqExtIBHsAbwrri5/2+NIk88=;
        b=DK5y41NajGUa2CVckXmZ/wSm5LJwL1Bb7JmzkjdatMvYBG6Wn+DN8GHmuss/L26MGVSjxipR0jePh3YSBYjB5i6j+Ix8mQ14VM1+FSR1b5WYJ5qzxWYLYjOSqCWctnKgdDB7LpAm827yLlpLbHjHEqH/AH/FMRRzOJFfZNMuWEk=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.18,REQID:7c1201e3-25b3-493d-97ea-fe38109dcfdb,IP:0,U
        RL:0,TC:0,Content:-25,EDM:0,RT:0,SF:95,FILE:0,BULK:0,RULE:Release_Ham,ACTI
        ON:release,TS:70
X-CID-INFO: VERSION:1.1.18,REQID:7c1201e3-25b3-493d-97ea-fe38109dcfdb,IP:0,URL
        :0,TC:0,Content:-25,EDM:0,RT:0,SF:95,FILE:0,BULK:0,RULE:Spam_GS981B3D,ACTI
        ON:quarantine,TS:70
X-CID-META: VersionHash:3ca2d6b,CLOUDID:5eb60355-dd49-462e-a4be-2143a3ddc739,B
        ulkID:23011819434418W3QN5G,BulkQuantity:0,Recheck:0,SF:38|28|17|19|48,TC:n
        il,Content:0,EDM:-3,IP:nil,URL:11|1,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0
        ,OSI:0,OSA:0
X-CID-BVR: 0
X-UUID: 5c7e6906972511ed945fc101203acc17-20230118
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw02.mediatek.com
        (envelope-from <yanchao.yang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 2057251155; Wed, 18 Jan 2023 19:43:43 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.792.15; Wed, 18 Jan 2023 19:43:42 +0800
Received: from mcddlt001.gcn.mediatek.inc (10.19.240.15) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.792.15 via Frontend Transport; Wed, 18 Jan 2023 19:43:40 +0800
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
Subject: [PATCH net-next v2 06/12] net: wwan: tmi: Add AT & MBIM WWAN ports
Date:   Wed, 18 Jan 2023 19:38:53 +0800
Message-ID: <20230118113859.175836-7-yanchao.yang@mediatek.com>
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

Adds AT & MBIM ports to the port infrastructure.
The WWAN initialization method is responsible for creating the
corresponding ports using the WWAN framework infrastructure. The
implemented WWAN port operations are start, stop, tx, tx_blocking
and tx_poll.
Adds Modem Logging (MDLog) port to collect modem logs for debugging
purposes. MDLog is supported by the RelayFs interface. MDLog allows
user-space APPs to control logging via MBIM command and to collect logs
via the RelayFs interface, while port infrastructure facilitates
communication between the driver and the modem.

Signed-off-by: Yanchao Yang <yanchao.yang@mediatek.com>
Signed-off-by: Felix Chen <felix.chen@mediatek.com>
---
 drivers/net/wwan/mediatek/mtk_ctrl_plane.c |   3 +
 drivers/net/wwan/mediatek/mtk_ctrl_plane.h |   2 +-
 drivers/net/wwan/mediatek/mtk_fsm.c        |   9 +
 drivers/net/wwan/mediatek/mtk_port.c       | 106 ++++-
 drivers/net/wwan/mediatek/mtk_port.h       |  81 +++-
 drivers/net/wwan/mediatek/mtk_port_io.c    | 478 ++++++++++++++++++++-
 drivers/net/wwan/mediatek/mtk_port_io.h    |  11 +
 drivers/net/wwan/mediatek/pcie/mtk_pci.c   |  18 +-
 8 files changed, 699 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wwan/mediatek/mtk_ctrl_plane.c b/drivers/net/wwan/mediatek/mtk_ctrl_plane.c
index 06932feb6bed..16626a083793 100644
--- a/drivers/net/wwan/mediatek/mtk_ctrl_plane.c
+++ b/drivers/net/wwan/mediatek/mtk_ctrl_plane.c
@@ -17,6 +17,9 @@
 static const struct virtq vq_tbl[] = {
 	{VQ(0), CLDMA0, TXQ(0), RXQ(0), VQ_MTU_3_5K, VQ_MTU_3_5K, TX_REQ_NUM, RX_REQ_NUM},
 	{VQ(1), CLDMA1, TXQ(0), RXQ(0), VQ_MTU_3_5K, VQ_MTU_3_5K, TX_REQ_NUM, RX_REQ_NUM},
+	{VQ(2), CLDMA1, TXQ(2), RXQ(2), VQ_MTU_3_5K, VQ_MTU_3_5K, TX_REQ_NUM, RX_REQ_NUM},
+	{VQ(3), CLDMA1, TXQ(5), RXQ(5), VQ_MTU_3_5K, VQ_MTU_3_5K, TX_REQ_NUM, RX_REQ_NUM},
+	{VQ(4), CLDMA1, TXQ(7), RXQ(7), VQ_MTU_3_5K, VQ_MTU_63K, TX_REQ_NUM, RX_REQ_NUM},
 };
 
 static int mtk_ctrl_get_hif_id(unsigned char peer_id)
diff --git a/drivers/net/wwan/mediatek/mtk_ctrl_plane.h b/drivers/net/wwan/mediatek/mtk_ctrl_plane.h
index 0885a434616e..f8216020448f 100644
--- a/drivers/net/wwan/mediatek/mtk_ctrl_plane.h
+++ b/drivers/net/wwan/mediatek/mtk_ctrl_plane.h
@@ -13,7 +13,7 @@
 #include "mtk_fsm.h"
 
 #define VQ(N)				(N)
-#define VQ_NUM				(2)
+#define VQ_NUM				(5)
 #define TX_REQ_NUM			(16)
 #define RX_REQ_NUM			(TX_REQ_NUM)
 
diff --git a/drivers/net/wwan/mediatek/mtk_fsm.c b/drivers/net/wwan/mediatek/mtk_fsm.c
index cbcf2c9749c9..46feb3148342 100644
--- a/drivers/net/wwan/mediatek/mtk_fsm.c
+++ b/drivers/net/wwan/mediatek/mtk_fsm.c
@@ -97,6 +97,7 @@ enum ctrl_msg_id {
 	CTRL_MSG_MDEE = 4,
 	CTRL_MSG_MDEE_REC_OK = 6,
 	CTRL_MSG_MDEE_PASS = 8,
+	CTRL_MSG_UNIFIED_PORT_CFG = 11,
 };
 
 struct ctrl_msg_header {
@@ -416,6 +417,14 @@ static int mtk_fsm_md_ctrl_msg_handler(void *__fsm, struct sk_buff *skb)
 	case CTRL_MSG_MDEE_PASS:
 		mtk_fsm_evt_submit(fsm->mdev, FSM_EVT_MDEE, FSM_F_MDEE_PASS, NULL, 0, 0);
 		break;
+	case CTRL_MSG_UNIFIED_PORT_CFG:
+		mtk_port_tbl_update(fsm->mdev, skb->data + sizeof(*ctrl_msg_h));
+		ret = mtk_port_internal_write(hs_info->ctrl_port, skb);
+		if (ret <= 0)
+			dev_err(fsm->mdev->dev, "Unable to send port config ack message.\n");
+		else
+			need_free_data = false;
+		break;
 	default:
 		dev_err(fsm->mdev->dev, "Invalid control message id\n");
 	}
diff --git a/drivers/net/wwan/mediatek/mtk_port.c b/drivers/net/wwan/mediatek/mtk_port.c
index 6a7447ab385e..85474285f1e7 100644
--- a/drivers/net/wwan/mediatek/mtk_port.c
+++ b/drivers/net/wwan/mediatek/mtk_port.c
@@ -45,6 +45,9 @@ DEFINE_MUTEX(port_mngr_grp_mtx);
 static DEFINE_IDA(ccci_dev_ids);
 
 static const struct mtk_port_cfg port_cfg[] = {
+	{CCCI_UART2_TX, CCCI_UART2_RX, VQ(3), PORT_TYPE_WWAN, "AT", PORT_F_ALLOW_DROP},
+	{CCCI_MD_LOG_TX, CCCI_MD_LOG_RX, VQ(4), PORT_TYPE_RELAYFS, "MDLog", PORT_F_DFLT},
+	{CCCI_MBIM_TX, CCCI_MBIM_RX, VQ(2), PORT_TYPE_WWAN, "MBIM", PORT_F_ALLOW_DROP},
 	{CCCI_CONTROL_TX, CCCI_CONTROL_RX, VQ(1), PORT_TYPE_INTERNAL, "MDCTRL", PORT_F_ALLOW_DROP},
 	{CCCI_SAP_CONTROL_TX, CCCI_SAP_CONTROL_RX, VQ(0), PORT_TYPE_INTERNAL, "SAPCTRL",
 	 PORT_F_ALLOW_DROP},
@@ -302,11 +305,101 @@ static void mtk_port_tbl_destroy(struct mtk_port_mngr *port_mngr, struct mtk_sta
 	} while (tbl_type < PORT_TBL_MAX);
 }
 
+/**
+ * mtk_port_tbl_update() - Update port radix tree table.
+ * @mdev: pointer to mtk_md_dev.
+ * @data: pointer to config data from device.
+ *
+ * This function called when host driver received a control message from device.
+ *
+ * Return: 0 on success and failure value on error.
+ */
+int mtk_port_tbl_update(struct mtk_md_dev *mdev, void *data)
+{
+	struct mtk_port_cfg_header *cfg_hdr = data;
+	struct mtk_port_cfg_hif_info *hif_info;
+	struct mtk_port_cfg_ch_info *ch_info;
+	struct mtk_port_mngr *port_mngr;
+	struct mtk_ctrl_blk *ctrl_blk;
+	int parsed_data_len = 0;
+	struct mtk_port *port;
+	int ret = 0;
+
+	if (unlikely(!mdev || !cfg_hdr)) {
+		ret = -EINVAL;
+		goto end;
+	}
+
+	ctrl_blk = mdev->ctrl_blk;
+	port_mngr = ctrl_blk->port_mngr;
+
+	if (cfg_hdr->msg_type != PORT_CFG_MSG_REQUEST) {
+		dev_warn(mdev->dev, "Invalid msg_type: %d\n", cfg_hdr->msg_type);
+		ret = -EPROTO;
+		goto end;
+	}
+
+	if (cfg_hdr->is_enable != 1) {
+		dev_warn(mdev->dev, "Invalid enable flag: %d\n", cfg_hdr->is_enable);
+		ret = -EPROTO;
+		goto end;
+	}
+	switch (cfg_hdr->cfg_type) {
+	case PORT_CFG_CH_INFO:
+		while (parsed_data_len < le16_to_cpu(cfg_hdr->port_config_len)) {
+			ch_info = (struct mtk_port_cfg_ch_info *)(cfg_hdr->data + parsed_data_len);
+			parsed_data_len += sizeof(*ch_info);
+
+			port = mtk_port_search_by_id(port_mngr, le16_to_cpu(ch_info->dl_ch_id));
+			if (port) {
+				continue;
+			} else {
+				dev_warn(mdev->dev,
+					 "It's not supported the extended port(%s),ch: 0x%x\n",
+					 ch_info->port_name, le16_to_cpu(ch_info->dl_ch_id));
+			}
+		}
+		cfg_hdr->msg_type = PORT_CFG_MSG_RESPONSE;
+		break;
+	case PORT_CFG_HIF_INFO:
+		hif_info = (struct mtk_port_cfg_hif_info *)cfg_hdr->data;
+		/* Clean up all the mark of the vqs before next paint, because if
+		 * clean up at end of case PORT_CFG_CH_INFO, the ch_info may be
+		 * NULL when cfg_hdr->port_config_len is 0, that will lead to can
+		 * not get peer_id.
+		 */
+		mtk_ctrl_vq_color_cleanup(port_mngr->ctrl_blk, hif_info->peer_id);
+
+		while (parsed_data_len < le16_to_cpu(cfg_hdr->port_config_len)) {
+			hif_info = (struct mtk_port_cfg_hif_info *)
+				   (cfg_hdr->data + parsed_data_len);
+			parsed_data_len += sizeof(*hif_info);
+			/* Color vq means that mark the vq to configure to the port */
+			mtk_ctrl_vq_color_paint(port_mngr->ctrl_blk,
+						hif_info->peer_id,
+						hif_info->ul_hw_queue_id,
+						hif_info->dl_hw_queue_id,
+						le32_to_cpu(hif_info->ul_hw_queue_mtu),
+						le32_to_cpu(hif_info->dl_hw_queue_mtu));
+		}
+		cfg_hdr->msg_type = PORT_CFG_MSG_RESPONSE;
+		break;
+	default:
+		dev_warn(mdev->dev, "Unsupported cfg_type: %d\n", cfg_hdr->cfg_type);
+		cfg_hdr->is_enable = 0;
+		ret = -EPROTO;
+		break;
+	}
+
+end:
+	return ret;
+}
+
 static struct mtk_stale_list *mtk_port_stale_list_create(struct mtk_port_mngr *port_mngr)
 {
 	struct mtk_stale_list *s_list;
 
-	/* cannot use devm_kzalloc here, because should pair with the free operation which
+	/* can not use devm_kzalloc here, because should pair with the free operation which
 	 * may be no dev pointer.
 	 */
 	s_list = kzalloc(sizeof(*s_list), GFP_KERNEL);
@@ -508,7 +601,7 @@ static int mtk_port_tx_complete(struct sk_buff *skb)
 	return 0;
 }
 
-static int mtk_port_status_check(struct mtk_port *port)
+int mtk_port_status_check(struct mtk_port *port)
 {
 	/* If port is enable, it must on port_mngr's port_tbl, so the mdev must exist. */
 	if (!test_bit(PORT_S_ENABLE, &port->status)) {
@@ -1153,6 +1246,13 @@ void mtk_port_mngr_fsm_state_handler(struct mtk_fsm_param *fsm_param, void *arg)
 			}
 			port->enable = true;
 			ports_ops[port->info.type]->enable(port);
+			port = mtk_port_search_by_id(port_mngr, CCCI_MD_LOG_RX);
+			if (!port) {
+				dev_err(port_mngr->ctrl_blk->mdev->dev, "Failed to find MD LOG port\n");
+				goto err;
+			}
+			port->enable = true;
+			ports_ops[port->info.type]->enable(port);
 		} else if (flag & FSM_F_MDEE_CLEARQ_DONE) {
 			/* the time 2000ms recommended by device-end
 			 * it's for wait device prepares the data
@@ -1184,7 +1284,7 @@ void mtk_port_mngr_fsm_state_handler(struct mtk_fsm_param *fsm_param, void *arg)
  * And then it will initialize port table and register fsm callback.
  *
  * Return:
- * * 0:			-success to initialize mtk_port_mngr
+ * * 0:		-success to initialize mtk_port_mngr
  * * -ENOMEM:	-alloc memory for structure failed
  */
 int mtk_port_mngr_init(struct mtk_ctrl_blk *ctrl_blk)
diff --git a/drivers/net/wwan/mediatek/mtk_port.h b/drivers/net/wwan/mediatek/mtk_port.h
index 9ab1c392cde9..32ff28788773 100644
--- a/drivers/net/wwan/mediatek/mtk_port.h
+++ b/drivers/net/wwan/mediatek/mtk_port.h
@@ -26,6 +26,7 @@
 #define MTK_PORT_NAME_HDR	"wwanD"
 #define MTK_DFLT_MAX_DEV_CNT	(10)
 #define MTK_DFLT_PORT_NAME_LEN	(20)
+#define MTK_DFLT_FULL_NAME_LEN	(50)
 
 /* Mapping MTK_PEER_ID and mtk_port_tbl index */
 #define MTK_PORT_TBL_TYPE(ch)	(MTK_PEER_ID(ch) - 1)
@@ -65,6 +66,12 @@ enum mtk_ccci_ch {
 	/* to MD */
 	CCCI_CONTROL_RX = 0x2000,
 	CCCI_CONTROL_TX = 0x2001,
+	CCCI_UART2_RX = 0x200A,
+	CCCI_UART2_TX = 0x200C,
+	CCCI_MD_LOG_RX = 0x202A,
+	CCCI_MD_LOG_TX = 0x202B,
+	CCCI_MBIM_RX = 0x20D0,
+	CCCI_MBIM_TX = 0x20D1,
 };
 
 enum mtk_port_flag {
@@ -82,6 +89,8 @@ enum mtk_port_tbl {
 
 enum mtk_port_type {
 	PORT_TYPE_INTERNAL,
+	PORT_TYPE_WWAN,
+	PORT_TYPE_RELAYFS,
 	PORT_TYPE_MAX
 };
 
@@ -90,14 +99,31 @@ struct mtk_internal_port {
 	int (*recv_cb)(void *arg, struct sk_buff *skb);
 };
 
+struct mtk_wwan_port {
+	/* w_lock Protect wwan_port when recv data and disable port at the same time */
+	struct mutex w_lock;
+	int w_type;
+	void *w_port;
+};
+
+struct mtk_relayfs_port {
+	struct dentry *ctrl_file;
+	struct dentry *d_wwan;
+	struct rchan *rc;
+	atomic_t is_full;
+	char ctrl_file_name[MTK_DFLT_FULL_NAME_LEN];
+};
+
 /**
  * union mtk_port_priv - Contains private data for different type of ports.
- * @cdev: private data for character device port.
  * @i_priv: private data for internal other user.
+ * @w_priv: private data for wwan port.
+ * @rf_priv: private data for relayfs port
  */
 union mtk_port_priv {
-	struct cdev *cdev;
 	struct mtk_internal_port i_priv;
+	struct mtk_wwan_port w_priv;
+	struct mtk_relayfs_port rf_priv;
 };
 
 /**
@@ -209,6 +235,55 @@ struct mtk_port_enum_msg {
 	u8 data[];
 } __packed;
 
+enum mtk_port_cfg_type {
+	PORT_CFG_CH_INFO = 4,
+	PORT_CFG_HIF_INFO,
+};
+
+enum mtk_port_cfg_msg_type {
+	PORT_CFG_MSG_REQUEST = 1,
+	PORT_CFG_MSG_RESPONSE,
+};
+
+struct mtk_port_cfg_ch_info {
+	__le16 dl_ch_id;
+	u8 dl_hw_queue_id;
+	u8 ul_hw_queue_id;
+	u8 reserve[2];
+	u8 peer_id;
+	u8 reserved;
+	u8 port_name_len;
+	char port_name[20];
+} __packed;
+
+struct mtk_port_cfg_hif_info {
+	u8 dl_hw_queue_id;
+	u8 ul_hw_queue_id;
+	u8 peer_id;
+	u8 reserved;
+	__le32 dl_hw_queue_mtu;
+	__le32 ul_hw_queue_mtu;
+} __packed;
+
+/**
+ * struct mtk_port_cfg_header - Message from device to configure unified port
+ * @port_config_len: data length.
+ * @cfg_type:  4:Channel info/ 5:Hif info
+ * @msg_type:  1:request/ 2:response
+ * @is_enable: 0:disable/ 1:enable
+ * @reserve: reserve bytes.
+ * @data: the data is channel config information @ref mtk_port_cfg_ch_info or
+ * hif config information @ref mtk_port_cfg_hif_info, following the cfg_type value.
+ */
+struct mtk_port_cfg_header {
+	__le16 port_config_len;
+	u8 cfg_type;
+	u8 msg_type;
+	u8 is_enable;
+	u8 reserve[3];
+	u8 data[];
+} __packed;
+
 struct mtk_ccci_header {
 	__le32 packet_header;
 	__le32 packet_len;
@@ -223,8 +298,10 @@ struct mtk_port *mtk_port_search_by_name(struct mtk_port_mngr *port_mngr, char *
 void mtk_port_stale_list_grp_cleanup(void);
 int mtk_port_add_header(struct sk_buff *skb);
 struct mtk_ccci_header *mtk_port_strip_header(struct sk_buff *skb);
+int mtk_port_status_check(struct mtk_port *port);
 int mtk_port_send_data(struct mtk_port *port, void *data);
 int mtk_port_status_update(struct mtk_md_dev *mdev, void *data);
+int mtk_port_tbl_update(struct mtk_md_dev *mdev, void *data);
 int mtk_port_vq_enable(struct mtk_port *port);
 int mtk_port_vq_disable(struct mtk_port *port);
 void mtk_port_mngr_fsm_state_handler(struct mtk_fsm_param *fsm_param, void *arg);
diff --git a/drivers/net/wwan/mediatek/mtk_port_io.c b/drivers/net/wwan/mediatek/mtk_port_io.c
index 050ec0a1bb04..1116370c8d6b 100644
--- a/drivers/net/wwan/mediatek/mtk_port_io.c
+++ b/drivers/net/wwan/mediatek/mtk_port_io.c
@@ -3,9 +3,25 @@
  * Copyright (c) 2022, MediaTek Inc.
  */
 
+#ifdef CONFIG_COMPAT
+#include <linux/compat.h>
+#endif
+#include <linux/debugfs.h>
+#include <linux/kernel.h>
+#include <linux/poll.h>
+#include <linux/relay.h>
+#include <linux/slab.h>
+#include <linux/wait.h>
+#include <linux/wwan.h>
+
 #include "mtk_port_io.h"
 
+#define MTK_CCCI_CLASS_NAME		"ccci_node"
 #define MTK_DFLT_READ_TIMEOUT		(1 * HZ)
+#define MTK_RELAYFS_N_SUB_BUFF		16
+#define MTK_RELAYFS_CTRL_FILE_PERM	0600
+
+static void *ccci_class;
 
 static int mtk_port_get_locked(struct mtk_port *port)
 {
@@ -34,6 +50,34 @@ static void mtk_port_put_locked(struct mtk_port *port)
 	mutex_unlock(&port_mngr_grp_mtx);
 }
 
+/**
+ * mtk_port_io_init() - Function for initialize device driver.
+ * Create ccci_class and register each type of device driver into kernel.
+ * This function called at driver module initialize.
+ *
+ * Return:.
+ * * 0:	success
+ * * error value if initialization failed
+ */
+int mtk_port_io_init(void)
+{
+	ccci_class = class_create(THIS_MODULE, MTK_CCCI_CLASS_NAME);
+	if (IS_ERR(ccci_class))
+		return PTR_ERR(ccci_class);
+	return 0;
+}
+
+/**
+ * mtk_port_io_exit() - Function for delete device driver.
+ * Unregister each type of device driver from kernel, and destroyccci_class.
+ *
+ * This function called at driver module exit.
+ */
+void mtk_port_io_exit(void)
+{
+	class_destroy(ccci_class);
+}
+
 static void mtk_port_struct_init(struct mtk_port *port)
 {
 	port->tx_seq = 0;
@@ -45,6 +89,23 @@ static void mtk_port_struct_init(struct mtk_port *port)
 	init_waitqueue_head(&port->trb_wq);
 	init_waitqueue_head(&port->rx_wq);
 	mutex_init(&port->read_buf_lock);
+	mutex_init(&port->write_lock);
+}
+
+static int mtk_port_copy_data_from(void *to, union user_buf from, unsigned int len,
+				   unsigned int offset, bool from_user_space)
+{
+	int ret = 0;
+
+	if (from_user_space) {
+		ret = copy_from_user(to, from.ubuf + offset, len);
+		if (ret)
+			ret = -EFAULT;
+	} else {
+		memcpy(to, from.kbuf + offset, len);
+	}
+
+	return ret;
 }
 
 static int mtk_port_internal_init(struct mtk_port *port)
@@ -77,7 +138,7 @@ static int mtk_port_internal_enable(struct mtk_port *port)
 
 	if (test_bit(PORT_S_ENABLE, &port->status)) {
 		dev_info(port->port_mngr->ctrl_blk->mdev->dev,
-			 "Skip to enable port( %s )\n", port->info.name);
+			 "Skip to enable port(%s)\n", port->info.name);
 		return 0;
 	}
 
@@ -171,6 +232,56 @@ static void mtk_port_common_close(struct mtk_port *port)
 	skb_queue_purge(&port->rx_skb_list);
 }
 
+static int mtk_port_common_write(struct mtk_port *port, union user_buf buf, unsigned int len,
+				 bool from_user_space)
+{
+	unsigned int tx_cnt, left_cnt = len;
+	struct sk_buff *skb;
+	int ret;
+
+start_write:
+	ret = mtk_port_status_check(port);
+	if (ret)
+		goto end_write;
+
+	skb = __dev_alloc_skb(port->tx_mtu, GFP_KERNEL);
+	if (!skb) {
+		dev_err(port->port_mngr->ctrl_blk->mdev->dev,
+			"Failed to alloc skb for port(%s)\n", port->info.name);
+		ret = -ENOMEM;
+		goto end_write;
+	}
+
+	if (!(port->info.flags & PORT_F_RAW_DATA)) {
+		/* Reserve enough buf len for ccci header */
+		skb_reserve(skb, sizeof(struct mtk_ccci_header));
+	}
+
+	tx_cnt = min(left_cnt, port->tx_mtu);
+	ret = mtk_port_copy_data_from(skb_put(skb, tx_cnt), buf, tx_cnt, len - left_cnt,
+				      from_user_space);
+	if (ret) {
+		dev_err(port->port_mngr->ctrl_blk->mdev->dev,
+			"Failed to copy data for port(%s)\n", port->info.name);
+		dev_kfree_skb_any(skb);
+		goto end_write;
+	}
+
+	ret = mtk_port_send_data(port, skb);
+	if (ret < 0)
+		goto end_write;
+
+	left_cnt -= ret;
+	if (left_cnt) {
+		dev_dbg(port->port_mngr->ctrl_blk->mdev->dev,
+			"Port(%s) send %dBytes, but still left %dBytes to send\n",
+			port->info.name, ret, left_cnt);
+		goto start_write;
+	}
+end_write:
+	return (len > left_cnt) ? (len - left_cnt) : ret;
+}
+
 /**
  * mtk_port_internal_open() - Function for open internal port.
  * @mdev: pointer to mtk_md_dev.
@@ -205,7 +316,10 @@ void *mtk_port_internal_open(struct mtk_md_dev *mdev, char *name, int flag)
 		goto err;
 	}
 
-	port->info.flags |= PORT_F_BLOCKING;
+	if (flag & O_NONBLOCK)
+		port->info.flags &= ~PORT_F_BLOCKING;
+	else
+		port->info.flags |= PORT_F_BLOCKING;
 err:
 	return port;
 }
@@ -289,6 +403,346 @@ void mtk_port_internal_recv_register(void *i_port,
 	priv->recv_cb = cb;
 }
 
+static int mtk_port_wwan_open(struct wwan_port *w_port)
+{
+	struct mtk_port *port;
+	int ret;
+
+	port = wwan_port_get_drvdata(w_port);
+	ret = mtk_port_get_locked(port);
+	if (ret)
+		return ret;
+
+	ret = mtk_port_common_open(port);
+	if (ret)
+		mtk_port_put_locked(port);
+
+	return ret;
+}
+
+static void mtk_port_wwan_close(struct wwan_port *w_port)
+{
+	struct mtk_port *port = wwan_port_get_drvdata(w_port);
+
+	mtk_port_common_close(port);
+	mtk_port_put_locked(port);
+}
+
+static int mtk_port_wwan_write(struct wwan_port *w_port, struct sk_buff *skb)
+{
+	struct mtk_port *port = wwan_port_get_drvdata(w_port);
+	union user_buf user_buf;
+
+	port->info.flags &= ~PORT_F_BLOCKING;
+	user_buf.kbuf = (void *)skb->data;
+	return mtk_port_common_write(port, user_buf, skb->len, false);
+}
+
+static int mtk_port_wwan_write_blocking(struct wwan_port *w_port, struct sk_buff *skb)
+{
+	struct mtk_port *port = wwan_port_get_drvdata(w_port);
+	union user_buf user_buf;
+
+	port->info.flags |= PORT_F_BLOCKING;
+	user_buf.kbuf = (void *)skb->data;
+	return mtk_port_common_write(port, user_buf, skb->len, false);
+}
+
+static __poll_t mtk_port_wwan_poll(struct wwan_port *w_port, struct file *file,
+				   struct poll_table_struct *poll)
+{
+	struct mtk_port *port = wwan_port_get_drvdata(w_port);
+	struct mtk_ctrl_blk *ctrl_blk;
+	__poll_t mask = 0;
+
+	if (mtk_port_status_check(port))
+		goto end_poll;
+
+	ctrl_blk = port->port_mngr->ctrl_blk;
+	poll_wait(file, &port->trb_wq, poll);
+	if (!VQ_LIST_FULL(ctrl_blk->trans, port->info.vq_id))
+		mask |= EPOLLOUT | EPOLLWRNORM;
+	else
+		dev_info(ctrl_blk->mdev->dev, "VQ(%d) skb_list_len is %d\n",
+			 port->info.vq_id, ctrl_blk->trans->skb_list[port->info.vq_id].qlen);
+
+end_poll:
+	return mask;
+}
+
+static const struct wwan_port_ops wwan_ops = {
+	.start = mtk_port_wwan_open,
+	.stop = mtk_port_wwan_close,
+	.tx = mtk_port_wwan_write,
+	.tx_blocking = mtk_port_wwan_write_blocking,
+	.tx_poll = mtk_port_wwan_poll,
+};
+
+static int mtk_port_wwan_init(struct mtk_port *port)
+{
+	mtk_port_struct_init(port);
+	port->enable = false;
+
+	mutex_init(&port->priv.w_priv.w_lock);
+
+	switch (port->info.rx_ch) {
+	case CCCI_MBIM_RX:
+		port->priv.w_priv.w_type = WWAN_PORT_MBIM;
+		break;
+	case CCCI_UART2_RX:
+		port->priv.w_priv.w_type = WWAN_PORT_AT;
+		break;
+	default:
+		port->priv.w_priv.w_type = WWAN_PORT_UNKNOWN;
+		break;
+	}
+
+	return 0;
+}
+
+static int mtk_port_wwan_exit(struct mtk_port *port)
+{
+	if (test_bit(PORT_S_ENABLE, &port->status))
+		ports_ops[port->info.type]->disable(port);
+
+	pr_err("[TMI] WWAN port(%s) exit is complete\n", port->info.name);
+
+	return 0;
+}
+
+static int mtk_port_wwan_enable(struct mtk_port *port)
+{
+	struct mtk_port_mngr *port_mngr;
+	int ret = 0;
+
+	port_mngr = port->port_mngr;
+
+	if (test_bit(PORT_S_ENABLE, &port->status)) {
+		dev_err(port_mngr->ctrl_blk->mdev->dev,
+			"Skip to enable port( %s )\n", port->info.name);
+		goto end;
+	}
+
+	ret = mtk_port_vq_enable(port);
+	if (ret && ret != -EBUSY)
+		goto end;
+
+	port->priv.w_priv.w_port = wwan_create_port(port_mngr->ctrl_blk->mdev->dev,
+						    port->priv.w_priv.w_type, &wwan_ops, port);
+	if (IS_ERR(port->priv.w_priv.w_port)) {
+		dev_err(port_mngr->ctrl_blk->mdev->dev,
+			"Failed to create wwan port for (%s)\n", port->info.name);
+		ret = PTR_ERR(port->priv.w_priv.w_port);
+		goto end;
+	}
+
+	set_bit(PORT_S_RDWR, &port->status);
+	set_bit(PORT_S_ENABLE, &port->status);
+	dev_info(port_mngr->ctrl_blk->mdev->dev,
+		 "Port(%s) enable is complete\n", port->info.name);
+
+	return 0;
+end:
+	return ret;
+}
+
+static int mtk_port_wwan_disable(struct mtk_port *port)
+{
+	struct wwan_port *w_port;
+
+	if (!test_and_clear_bit(PORT_S_ENABLE, &port->status)) {
+		dev_info(port->port_mngr->ctrl_blk->mdev->dev,
+			 "Skip to disable port(%s)\n", port->info.name);
+		return 0;
+	}
+
+	clear_bit(PORT_S_RDWR, &port->status);
+	w_port = port->priv.w_priv.w_port;
+	/* When the port is being disabled, port manager may receive RX data
+	 * and try to call wwan_port_rx(). So the w_lock is to protect w_port
+	 * from using by disable flow and receive flow at the same time.
+	 */
+	mutex_lock(&port->priv.w_priv.w_lock);
+	port->priv.w_priv.w_port = NULL;
+	mutex_unlock(&port->priv.w_priv.w_lock);
+
+	wwan_remove_port(w_port);
+
+	mtk_port_vq_disable(port);
+
+	dev_info(port->port_mngr->ctrl_blk->mdev->dev,
+		 "Port(%s) disable is complete\n", port->info.name);
+
+	return 0;
+}
+
+static int mtk_port_wwan_recv(struct mtk_port *port, struct sk_buff *skb)
+{
+	if (!test_bit(PORT_S_OPEN, &port->status)) {
+		/* If current port is not opened by any user, the received data will be dropped */
+		dev_warn_ratelimited(port->port_mngr->ctrl_blk->mdev->dev,
+				     "Unabled to recv: (%s) not opened\n", port->info.name);
+		goto drop_data;
+	}
+
+	/* Protect w_port from using by disable flow and receive flow at the same time. */
+	mutex_lock(&port->priv.w_priv.w_lock);
+	if (!port->priv.w_priv.w_port) {
+		mutex_unlock(&port->priv.w_priv.w_lock);
+		dev_warn_ratelimited(port->port_mngr->ctrl_blk->mdev->dev,
+				     "Invalid (%s) wwan_port, drop packet\n", port->info.name);
+		goto drop_data;
+	}
+
+	wwan_port_rx(port->priv.w_priv.w_port, skb);
+	mutex_unlock(&port->priv.w_priv.w_lock);
+	return 0;
+
+drop_data:
+	dev_kfree_skb_any(skb);
+	return -ENXIO;
+}
+
+static struct dentry *trace_create_buf_file_handler(const char *filename, struct dentry *parent,
+						    umode_t mode, struct rchan_buf *buf,
+						    int *is_global)
+{
+	*is_global = 1;
+	return debugfs_create_file(filename, mode, parent, buf, &relay_file_operations);
+}
+
+static int trace_remove_buf_file_handler(struct dentry *dentry)
+{
+	debugfs_remove_recursive(dentry);
+	return 0;
+}
+
+static int trace_subbuf_start_handler(struct rchan_buf *buf, void *subbuf,
+				      void *prev_subbuf, size_t prev_padding)
+{
+	struct mtk_port *port = buf->chan->private_data;
+
+	if (relay_buf_full(buf)) {
+		pr_err_ratelimited("Failed to write relayfs buffer");
+		atomic_set(&port->priv.rf_priv.is_full, 1);
+		return 0;
+	}
+	atomic_set(&port->priv.rf_priv.is_full, 0);
+	return 1;
+}
+
+static struct rchan_callbacks relay_callbacks = {
+	.subbuf_start = trace_subbuf_start_handler,
+	.create_buf_file = trace_create_buf_file_handler,
+	.remove_buf_file = trace_remove_buf_file_handler,
+};
+
+static int mtk_port_relayfs_enable(struct mtk_port *port)
+{
+	struct dentry *debugfs_pdev = wwan_get_debugfs_dir(port->port_mngr->ctrl_blk->mdev->dev);
+	int ret;
+
+	if (IS_ERR_OR_NULL(debugfs_pdev)) {
+		dev_err(port->port_mngr->ctrl_blk->mdev->dev,
+			"Failed to get wwan debugfs dentry port(%s)\n", port->info.name);
+		return 0;
+	}
+	port->priv.rf_priv.d_wwan = debugfs_pdev;
+
+	if (test_bit(PORT_S_ENABLE, &port->status)) {
+		dev_info(port->port_mngr->ctrl_blk->mdev->dev,
+			 "Skip to enable port( %s )\n", port->info.name);
+		return 0;
+	}
+
+	ret = mtk_port_vq_enable(port);
+	if (ret && ret != -EBUSY)
+		goto err_open_vq;
+
+	dev_info(port->port_mngr->ctrl_blk->mdev->dev,
+		 "Port(%s) enable is complete, rx_buf_size: %d * %d\n",
+		 port->info.name, port->rx_mtu, MTK_RELAYFS_N_SUB_BUFF);
+	port->priv.rf_priv.rc = relay_open(port->info.name,
+					   debugfs_pdev,
+					   port->rx_mtu,
+					   MTK_RELAYFS_N_SUB_BUFF,
+					   &relay_callbacks, port);
+	if (!port->priv.rf_priv.rc)
+		goto err_open_relay;
+
+	set_bit(PORT_S_RDWR, &port->status);
+	set_bit(PORT_S_ENABLE, &port->status);
+	/* Open port and allow to receive data */
+	ret = mtk_port_common_open(port);
+	if (ret)
+		goto err_open_port;
+	port->info.flags &= ~PORT_F_BLOCKING;
+	return 0;
+
+err_open_port:
+	relay_close(port->priv.rf_priv.rc);
+err_open_relay:
+	mtk_port_vq_disable(port);
+err_open_vq:
+	wwan_put_debugfs_dir(port->priv.rf_priv.d_wwan);
+	return ret;
+}
+
+static int mtk_port_relayfs_disable(struct mtk_port *port)
+{
+	if (!test_and_clear_bit(PORT_S_ENABLE, &port->status)) {
+		dev_info(port->port_mngr->ctrl_blk->mdev->dev,
+			 "Skip to disable port(%s)\n", port->info.name);
+		goto out;
+	}
+	clear_bit(PORT_S_RDWR, &port->status);
+	mtk_port_common_close(port);
+
+	relay_close(port->priv.rf_priv.rc);
+	wwan_put_debugfs_dir(port->priv.rf_priv.d_wwan);
+	mtk_port_vq_disable(port);
+	dev_info(port->port_mngr->ctrl_blk->mdev->dev,
+		 "Port(%s) disable is complete\n", port->info.name);
+out:
+	return 0;
+}
+
+static int mtk_port_relayfs_recv(struct mtk_port *port, struct sk_buff *skb)
+{
+	struct mtk_relayfs_port *relayfs_port = &port->priv.rf_priv;
+
+	while (test_bit(PORT_S_OPEN, &port->status) && test_bit(PORT_S_ENABLE, &port->status)) {
+		__relay_write(relayfs_port->rc, skb->data, skb->len);
+		if (atomic_read(&port->priv.rf_priv.is_full)) {
+			msleep(20);
+			continue;
+		} else {
+			break;
+		}
+	}
+
+	dev_kfree_skb_any(skb);
+	return 0;
+}
+
+static int mtk_port_relayfs_init(struct mtk_port *port)
+{
+	mtk_port_struct_init(port);
+	port->enable = false;
+	atomic_set(&port->priv.rf_priv.is_full, 0);
+
+	return 0;
+}
+
+static int mtk_port_relayfs_exit(struct mtk_port *port)
+{
+	if (test_bit(PORT_S_ENABLE, &port->status))
+		ports_ops[port->info.type]->disable(port);
+
+	pr_err("[TMI] RelayFS Port(%s) exit is complete\n", port->info.name);
+	return 0;
+}
+
 static const struct port_ops port_internal_ops = {
 	.init = mtk_port_internal_init,
 	.exit = mtk_port_internal_exit,
@@ -298,6 +752,26 @@ static const struct port_ops port_internal_ops = {
 	.recv = mtk_port_internal_recv,
 };
 
+static const struct port_ops port_wwan_ops = {
+	.init = mtk_port_wwan_init,
+	.exit = mtk_port_wwan_exit,
+	.reset = mtk_port_reset,
+	.enable = mtk_port_wwan_enable,
+	.disable = mtk_port_wwan_disable,
+	.recv = mtk_port_wwan_recv,
+};
+
+static const struct port_ops port_relayfs_ops = {
+	.init = mtk_port_relayfs_init,
+	.exit = mtk_port_relayfs_exit,
+	.reset = mtk_port_reset,
+	.enable = mtk_port_relayfs_enable,
+	.disable = mtk_port_relayfs_disable,
+	.recv = mtk_port_relayfs_recv,
+};
+
 const struct port_ops *ports_ops[PORT_TYPE_MAX] = {
 	&port_internal_ops,
+	&port_wwan_ops,
+	&port_relayfs_ops
 };
diff --git a/drivers/net/wwan/mediatek/mtk_port_io.h b/drivers/net/wwan/mediatek/mtk_port_io.h
index 30e1d4149881..034b5a2d8f12 100644
--- a/drivers/net/wwan/mediatek/mtk_port_io.h
+++ b/drivers/net/wwan/mediatek/mtk_port_io.h
@@ -9,9 +9,12 @@
 #include <linux/netdevice.h>
 #include <linux/skbuff.h>
 
+#include "mtk_ctrl_plane.h"
+#include "mtk_dev.h"
 #include "mtk_port.h"
 
 #define MTK_RX_BUF_SIZE			(1024 * 1024)
+#define MTK_RX_BUF_MAX_SIZE		(2 * 1024 * 1024)
 
 extern struct mutex port_mngr_grp_mtx;
 
@@ -24,6 +27,14 @@ struct port_ops {
 	int (*recv)(struct mtk_port *port, struct sk_buff *skb);
 };
 
+union user_buf {
+	void __user *ubuf;
+	void *kbuf;
+};
+
+int mtk_port_io_init(void);
+void mtk_port_io_exit(void);
+
 void *mtk_port_internal_open(struct mtk_md_dev *mdev, char *name, int flag);
 int mtk_port_internal_close(void *i_port);
 int mtk_port_internal_write(void *i_port, struct sk_buff *skb);
diff --git a/drivers/net/wwan/mediatek/pcie/mtk_pci.c b/drivers/net/wwan/mediatek/pcie/mtk_pci.c
index 5a821e55771f..5b91da25eb08 100644
--- a/drivers/net/wwan/mediatek/pcie/mtk_pci.c
+++ b/drivers/net/wwan/mediatek/pcie/mtk_pci.c
@@ -1129,13 +1129,29 @@ static struct pci_driver mtk_pci_drv = {
 
 static int __init mtk_drv_init(void)
 {
-	return pci_register_driver(&mtk_pci_drv);
+	int ret;
+
+	ret = mtk_port_io_init();
+	if (ret)
+		goto err_init_devid;
+
+	ret = pci_register_driver(&mtk_pci_drv);
+	if (ret)
+		goto err_pci_drv;
+
+	return 0;
+err_pci_drv:
+	mtk_port_io_exit();
+err_init_devid:
+
+	return ret;
 }
 module_init(mtk_drv_init);
 
 static void __exit mtk_drv_exit(void)
 {
 	pci_unregister_driver(&mtk_pci_drv);
+	mtk_port_io_exit();
 	mtk_port_stale_list_grp_cleanup();
 }
 module_exit(mtk_drv_exit);
-- 
2.32.0

