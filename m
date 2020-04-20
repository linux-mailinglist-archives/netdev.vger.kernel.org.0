Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF3881B08E8
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 14:10:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbgDTMKq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 08:10:46 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:2415 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726307AbgDTMKq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 08:10:46 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 263B7F4E03F22AA43B58;
        Mon, 20 Apr 2020 20:10:44 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.487.0; Mon, 20 Apr 2020
 20:10:36 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <kvalo@codeaurora.org>, <davem@davemloft.net>,
        <srirrama@codeaurora.org>, <ath11k@lists.infradead.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Jason Yan <yanaijie@huawei.com>
Subject: [PATCH] ath11k: remove conversion to bool in ath11k_dp_rxdesc_mpdu_valid()
Date:   Mon, 20 Apr 2020 20:37:18 +0800
Message-ID: <20200420123718.3384-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The '==' expression itself is bool, no need to convert it to bool again.
This fixes the following coccicheck warning:

drivers/net/wireless/ath/ath11k/dp_rx.c:255:46-51: WARNING: conversion
to bool not needed here

Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/net/wireless/ath/ath11k/dp_rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/dp_rx.c b/drivers/net/wireless/ath/ath11k/dp_rx.c
index 203fd44ff352..bbd7da48518f 100644
--- a/drivers/net/wireless/ath/ath11k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
@@ -252,7 +252,7 @@ static bool ath11k_dp_rxdesc_mpdu_valid(struct hal_rx_desc *rx_desc)
 	tlv_tag = FIELD_GET(HAL_TLV_HDR_TAG,
 			    __le32_to_cpu(rx_desc->mpdu_start_tag));
 
-	return tlv_tag == HAL_RX_MPDU_START ? true : false;
+	return tlv_tag == HAL_RX_MPDU_START;
 }
 
 static u32 ath11k_dp_rxdesc_get_ppduid(struct hal_rx_desc *rx_desc)
-- 
2.21.1

