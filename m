Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96C4E3458F5
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 08:42:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbhCWHlh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 03:41:37 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:14007 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbhCWHk7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 03:40:59 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4F4NXg21przrWWq;
        Tue, 23 Mar 2021 15:38:59 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.498.0; Tue, 23 Mar 2021 15:40:50 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, <linuxarm@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 4/8] net: hns: remove unused config_half_duplex()
Date:   Tue, 23 Mar 2021 15:41:05 +0800
Message-ID: <1616485269-57044-5-git-send-email-tanhuazhong@huawei.com>
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

Since config_half_duplex() in struct mac_driver is unused,
so remove it.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_gmac.c  | 9 ---------
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.h   | 2 --
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_xgmac.c | 1 -
 3 files changed, 12 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_gmac.c b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_gmac.c
index 8907c08..f387a85 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_gmac.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_gmac.c
@@ -171,14 +171,6 @@ static void hns_gmac_tx_loop_pkt_dis(void *mac_drv)
 	dsaf_write_dev(drv, GMAC_TX_LOOP_PKT_PRI_REG, tx_loop_pkt_pri);
 }
 
-static void hns_gmac_set_duplex_type(void *mac_drv, u8 newval)
-{
-	struct mac_driver *drv = (struct mac_driver *)mac_drv;
-
-	dsaf_set_dev_bit(drv, GMAC_DUPLEX_TYPE_REG,
-			 GMAC_DUPLEX_TYPE_B, !!newval);
-}
-
 static void hns_gmac_get_duplex_type(void *mac_drv,
 				     enum hns_gmac_duplex_mdoe *duplex_mode)
 {
@@ -730,7 +722,6 @@ void *hns_gmac_config(struct hns_mac_cb *mac_cb, struct mac_params *mac_param)
 	mac_drv->set_an_mode = hns_gmac_config_an_mode;
 	mac_drv->config_loopback = hns_gmac_config_loopback;
 	mac_drv->config_pad_and_crc = hns_gmac_config_pad_and_crc;
-	mac_drv->config_half_duplex = hns_gmac_set_duplex_type;
 	mac_drv->get_info = hns_gmac_get_info;
 	mac_drv->autoneg_stat = hns_gmac_autoneg_stat;
 	mac_drv->get_pause_enable = hns_gmac_get_pausefrm_cfg;
diff --git a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.h b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.h
index 9771ba8..8943ffab 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.h
+++ b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.h
@@ -364,8 +364,6 @@ struct mac_driver {
 	void (*config_max_frame_length)(void *mac_drv, u16 newval);
 	/*config PAD and CRC enable */
 	void (*config_pad_and_crc)(void *mac_drv, u8 newval);
-	/* config duplex mode*/
-	void (*config_half_duplex)(void *mac_drv, u8 newval);
 	/*config tx pause time,if pause_time is zero,disable tx pause enable*/
 	void (*set_tx_auto_pause_frames)(void *mac_drv, u16 pause_time);
 	/* config rx mode for promiscuous*/
diff --git a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_xgmac.c b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_xgmac.c
index 8efc966..1c9159a 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_xgmac.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_xgmac.c
@@ -799,7 +799,6 @@ void *hns_xgmac_config(struct hns_mac_cb *mac_cb, struct mac_params *mac_param)
 	mac_drv->set_an_mode = NULL;
 	mac_drv->config_loopback = NULL;
 	mac_drv->config_pad_and_crc = hns_xgmac_config_pad_and_crc;
-	mac_drv->config_half_duplex = NULL;
 	mac_drv->mac_free = hns_xgmac_free;
 	mac_drv->adjust_link = NULL;
 	mac_drv->set_tx_auto_pause_frames = hns_xgmac_set_tx_auto_pause_frames;
-- 
2.7.4

