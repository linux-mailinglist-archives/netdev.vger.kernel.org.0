Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 578E33458F9
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 08:42:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbhCWHln (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 03:41:43 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:14431 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbhCWHlJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 03:41:09 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4F4NYB0hPWzkdh3;
        Tue, 23 Mar 2021 15:39:26 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.498.0; Tue, 23 Mar 2021 15:40:52 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, <linuxarm@huawei.com>,
        Yonglong Liu <liuyonglong@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 8/8] net: hns: remove redundant variable initialization
Date:   Tue, 23 Mar 2021 15:41:09 +0800
Message-ID: <1616485269-57044-9-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1616485269-57044-1-git-send-email-tanhuazhong@huawei.com>
References: <1616485269-57044-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yonglong Liu <liuyonglong@huawei.com>

There are some variables in HNS driver will not being referenced
before assigned, so there is no need to init them.

Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns/hns_ae_adapt.c   |  2 +-
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c   |  2 +-
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c  | 16 ++++++++--------
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_rcb.c   |  4 ++--
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_xgmac.c |  2 +-
 drivers/net/ethernet/hisilicon/hns/hns_enet.c       |  4 ++--
 drivers/net/ethernet/hisilicon/hns_mdio.c           |  4 ++--
 7 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns/hns_ae_adapt.c b/drivers/net/ethernet/hisilicon/hns/hns_ae_adapt.c
index 78217ff..c615fbf 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_ae_adapt.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_ae_adapt.c
@@ -630,7 +630,7 @@ static void hns_ae_update_stats(struct hnae_handle *handle,
 	struct hnae_vf_cb *vf_cb = hns_ae_get_vf_cb(handle);
 	u64 tx_bytes = 0, rx_bytes = 0, tx_packets = 0, rx_packets = 0;
 	u64 rx_errors = 0, tx_errors = 0, tx_dropped = 0;
-	u64 rx_missed_errors = 0;
+	u64 rx_missed_errors;
 
 	dsaf_dev = hns_ae_get_dsaf_dev(handle->dev);
 	if (!dsaf_dev)
diff --git a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c
index 4a44813..f4cf569 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c
@@ -1202,7 +1202,7 @@ void hns_mac_get_regs(struct hns_mac_cb *mac_cb, void *data)
 
 void hns_set_led_opt(struct hns_mac_cb *mac_cb)
 {
-	int nic_data = 0;
+	int nic_data;
 	int txpkts, rxpkts;
 
 	txpkts = mac_cb->txpkt_for_led - mac_cb->hw_stats.tx_good_pkts;
diff --git a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c
index 87d3db4..c2a6061 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c
@@ -1613,7 +1613,7 @@ int hns_dsaf_set_mac_uc_entry(
 	struct dsaf_device *dsaf_dev,
 	struct dsaf_drv_mac_single_dest_entry *mac_entry)
 {
-	u16 entry_index = DSAF_INVALID_ENTRY_IDX;
+	u16 entry_index;
 	struct dsaf_drv_tbl_tcam_key mac_key;
 	struct dsaf_tbl_tcam_ucast_cfg mac_data;
 	struct dsaf_drv_priv *priv =
@@ -1679,7 +1679,7 @@ int hns_dsaf_rm_mac_addr(
 	struct dsaf_device *dsaf_dev,
 	struct dsaf_drv_mac_single_dest_entry *mac_entry)
 {
-	u16 entry_index = DSAF_INVALID_ENTRY_IDX;
+	u16 entry_index;
 	struct dsaf_tbl_tcam_ucast_cfg mac_data;
 	struct dsaf_drv_tbl_tcam_key mac_key;
 
@@ -1751,7 +1751,7 @@ static void hns_dsaf_mc_mask_bit_clear(char *dst, const char *src)
 int hns_dsaf_add_mac_mc_port(struct dsaf_device *dsaf_dev,
 			     struct dsaf_drv_mac_single_dest_entry *mac_entry)
 {
-	u16 entry_index = DSAF_INVALID_ENTRY_IDX;
+	u16 entry_index;
 	struct dsaf_drv_tbl_tcam_key mac_key;
 	struct dsaf_drv_tbl_tcam_key mask_key;
 	struct dsaf_tbl_tcam_data *pmask_key = NULL;
@@ -1861,7 +1861,7 @@ int hns_dsaf_add_mac_mc_port(struct dsaf_device *dsaf_dev,
 int hns_dsaf_del_mac_entry(struct dsaf_device *dsaf_dev, u16 vlan_id,
 			   u8 in_port_num, u8 *addr)
 {
-	u16 entry_index = DSAF_INVALID_ENTRY_IDX;
+	u16 entry_index;
 	struct dsaf_drv_tbl_tcam_key mac_key;
 	struct dsaf_drv_priv *priv =
 	    (struct dsaf_drv_priv *)hns_dsaf_dev_priv(dsaf_dev);
@@ -1910,7 +1910,7 @@ int hns_dsaf_del_mac_entry(struct dsaf_device *dsaf_dev, u16 vlan_id,
 int hns_dsaf_del_mac_mc_port(struct dsaf_device *dsaf_dev,
 			     struct dsaf_drv_mac_single_dest_entry *mac_entry)
 {
-	u16 entry_index = DSAF_INVALID_ENTRY_IDX;
+	u16 entry_index;
 	struct dsaf_drv_tbl_tcam_key mac_key;
 	struct dsaf_drv_priv *priv = hns_dsaf_dev_priv(dsaf_dev);
 	struct dsaf_drv_soft_mac_tbl *soft_mac_entry = priv->soft_mac_tbl;
@@ -2264,7 +2264,7 @@ void hns_dsaf_update_stats(struct dsaf_device *dsaf_dev, u32 node_num)
  */
 void hns_dsaf_get_regs(struct dsaf_device *ddev, u32 port, void *data)
 {
-	u32 i = 0;
+	u32 i;
 	u32 j;
 	u32 *p = data;
 	u32 reg_tmp;
@@ -2768,7 +2768,7 @@ static void set_promisc_tcam_enable(struct dsaf_device *dsaf_dev, u32 port)
 	struct dsaf_drv_mac_single_dest_entry mask_entry;
 	struct dsaf_drv_tbl_tcam_key temp_key, mask_key;
 	struct dsaf_drv_soft_mac_tbl *soft_mac_entry;
-	u16 entry_index = DSAF_INVALID_ENTRY_IDX;
+	u16 entry_index;
 	struct dsaf_drv_tbl_tcam_key mac_key;
 	struct hns_mac_cb *mac_cb;
 	u8 addr[ETH_ALEN] = {0};
@@ -2870,7 +2870,7 @@ static void set_promisc_tcam_disable(struct dsaf_device *dsaf_dev, u32 port)
 	struct dsaf_tbl_tcam_data tbl_tcam_data_uc = {0, 0};
 	struct dsaf_tbl_tcam_data tbl_tcam_mask = {0, 0};
 	struct dsaf_drv_soft_mac_tbl *soft_mac_entry;
-	u16 entry_index = DSAF_INVALID_ENTRY_IDX;
+	u16 entry_index;
 	struct dsaf_drv_tbl_tcam_key mac_key;
 	u8 addr[ETH_ALEN] = {0};
 
diff --git a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_rcb.c b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_rcb.c
index 37c8eff..5d5dc69 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_rcb.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_rcb.c
@@ -974,7 +974,7 @@ void hns_rcb_get_common_regs(struct rcb_common_cb *rcb_com, void *data)
 	bool is_dbg = HNS_DSAF_IS_DEBUG(rcb_com->dsaf_dev);
 	u32 reg_tmp;
 	u32 reg_num_tmp;
-	u32 i = 0;
+	u32 i;
 
 	/*rcb common registers */
 	regs[0] = dsaf_read_dev(rcb_com, RCB_COM_CFG_ENDIAN_REG);
@@ -1045,7 +1045,7 @@ void hns_rcb_get_ring_regs(struct hnae_queue *queue, void *data)
 	u32 *regs = data;
 	struct ring_pair_cb *ring_pair
 		= container_of(queue, struct ring_pair_cb, q);
-	u32 i = 0;
+	u32 i;
 
 	/*rcb ring registers */
 	regs[0] = dsaf_read_dev(queue, RCB_RING_RX_RING_BASEADDR_L_REG);
diff --git a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_xgmac.c b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_xgmac.c
index 1c9159a..be52acd 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_xgmac.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_xgmac.c
@@ -482,7 +482,7 @@ static void hns_xgmac_get_link_status(void *mac_drv, u32 *link_stat)
  */
 static void hns_xgmac_get_regs(void *mac_drv, void *data)
 {
-	u32 i = 0;
+	u32 i;
 	struct mac_driver *drv = (struct mac_driver *)mac_drv;
 	u32 *regs = data;
 	u64 qtmp;
diff --git a/drivers/net/ethernet/hisilicon/hns/hns_enet.c b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
index c66a7a5..7a1a0a9 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
@@ -872,7 +872,7 @@ static int hns_nic_rx_poll_one(struct hns_nic_ring_data *ring_data,
 static bool hns_nic_rx_fini_pro(struct hns_nic_ring_data *ring_data)
 {
 	struct hnae_ring *ring = ring_data->ring;
-	int num = 0;
+	int num;
 	bool rx_stopped;
 
 	hns_update_rx_rate(ring);
@@ -1881,7 +1881,7 @@ static void hns_nic_set_rx_mode(struct net_device *ndev)
 static void hns_nic_get_stats64(struct net_device *ndev,
 				struct rtnl_link_stats64 *stats)
 {
-	int idx = 0;
+	int idx;
 	u64 tx_bytes = 0;
 	u64 rx_bytes = 0;
 	u64 tx_pkts = 0;
diff --git a/drivers/net/ethernet/hisilicon/hns_mdio.c b/drivers/net/ethernet/hisilicon/hns_mdio.c
index 883d0d7..3e54017 100644
--- a/drivers/net/ethernet/hisilicon/hns_mdio.c
+++ b/drivers/net/ethernet/hisilicon/hns_mdio.c
@@ -279,7 +279,7 @@ static int hns_mdio_write(struct mii_bus *bus,
 static int hns_mdio_read(struct mii_bus *bus, int phy_id, int regnum)
 {
 	int ret;
-	u16 reg_val = 0;
+	u16 reg_val;
 	u8 devad = ((regnum >> 16) & 0x1f);
 	u8 is_c45 = !!(regnum & MII_ADDR_C45);
 	u16 reg = (u16)(regnum & 0xffff);
@@ -420,7 +420,7 @@ static int hns_mdio_probe(struct platform_device *pdev)
 {
 	struct hns_mdio_device *mdio_dev;
 	struct mii_bus *new_bus;
-	int ret = -ENODEV;
+	int ret;
 
 	if (!pdev) {
 		dev_err(NULL, "pdev is NULL!\r\n");
-- 
2.7.4

