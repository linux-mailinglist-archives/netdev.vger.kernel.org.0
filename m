Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E26753458F6
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 08:42:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230041AbhCWHlj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 03:41:39 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:14006 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229961AbhCWHk7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 03:40:59 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4F4NXg2nygzrWvj;
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
Subject: [PATCH net-next 1/8] net: hns: remove unused get_autoneg()
Date:   Tue, 23 Mar 2021 15:41:02 +0800
Message-ID: <1616485269-57044-2-git-send-email-tanhuazhong@huawei.com>
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

Since get_autoneg() in struct hnae_ae_ops is unused, so remove it.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns/hnae.h         |  3 ---
 drivers/net/ethernet/hisilicon/hns/hns_ae_adapt.c | 12 ------------
 2 files changed, 15 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns/hnae.h b/drivers/net/ethernet/hisilicon/hns/hnae.h
index 6ab9458..b1dd933 100644
--- a/drivers/net/ethernet/hisilicon/hns/hnae.h
+++ b/drivers/net/ethernet/hisilicon/hns/hnae.h
@@ -416,8 +416,6 @@ enum hnae_media_type {
  *   get tx and rx of pause frame use
  * set_autoneg()
  *   set auto autonegotiation of pause frame use
- * get_autoneg()
- *   get auto autonegotiation of pause frame use
  * set_pauseparam()
  *   set tx and rx of pause frame use
  * get_coalesce_usecs()
@@ -488,7 +486,6 @@ struct hnae_ae_ops {
 	void (*get_pauseparam)(struct hnae_handle *handle,
 			       u32 *auto_neg, u32 *rx_en, u32 *tx_en);
 	int (*set_autoneg)(struct hnae_handle *handle, u8 enable);
-	int (*get_autoneg)(struct hnae_handle *handle);
 	int (*set_pauseparam)(struct hnae_handle *handle,
 			      u32 auto_neg, u32 rx_en, u32 tx_en);
 	void (*get_coalesce_usecs)(struct hnae_handle *handle,
diff --git a/drivers/net/ethernet/hisilicon/hns/hns_ae_adapt.c b/drivers/net/ethernet/hisilicon/hns/hns_ae_adapt.c
index b98244f..72b2a5f 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_ae_adapt.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_ae_adapt.c
@@ -502,17 +502,6 @@ static void hns_ae_set_promisc_mode(struct hnae_handle *handle, u32 en)
 	hns_mac_set_promisc(mac_cb, (u8)!!en);
 }
 
-static int hns_ae_get_autoneg(struct hnae_handle *handle)
-{
-	u32     auto_neg;
-
-	assert(handle);
-
-	hns_mac_get_autoneg(hns_get_mac_cb(handle), &auto_neg);
-
-	return auto_neg;
-}
-
 static int hns_ae_set_pauseparam(struct hnae_handle *handle,
 				 u32 autoneg, u32 rx_en, u32 tx_en)
 {
@@ -966,7 +955,6 @@ static struct hnae_ae_ops hns_dsaf_ops = {
 	.get_ring_bdnum_limit = hns_ae_get_ring_bdnum_limit,
 	.get_pauseparam = hns_ae_get_pauseparam,
 	.set_autoneg = hns_ae_set_autoneg,
-	.get_autoneg = hns_ae_get_autoneg,
 	.set_pauseparam = hns_ae_set_pauseparam,
 	.get_coalesce_usecs = hns_ae_get_coalesce_usecs,
 	.get_max_coalesced_frames = hns_ae_get_max_coalesced_frames,
-- 
2.7.4

