Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E53313A9361
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 08:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231741AbhFPG6E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 02:58:04 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:10088 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232113AbhFPG5t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 02:57:49 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G4bV66Z8WzZfYN;
        Wed, 16 Jun 2021 14:52:46 +0800 (CST)
Received: from dggpeml500017.china.huawei.com (7.185.36.243) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 16 Jun 2021 14:55:40 +0800
Received: from huawei.com (10.175.103.91) by dggpeml500017.china.huawei.com
 (7.185.36.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Wed, 16 Jun
 2021 14:55:40 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <pkshih@realtek.com>, <davem@davemloft.net>
Subject: [PATCH net-next] rtlwifi: Use eth_broadcast_addr() to assign broadcast address
Date:   Wed, 16 Jun 2021 14:59:25 +0800
Message-ID: <20210616065925.2246719-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500017.china.huawei.com (7.185.36.243)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Using eth_broadcast_addr() to assign broadcast address insetad
of an inefficient copy from an array that contains the all-ones
broadcast address.

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/net/wireless/realtek/rtlwifi/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/core.c b/drivers/net/wireless/realtek/rtlwifi/core.c
index 8efe2f5e5b9f..d2b647930814 100644
--- a/drivers/net/wireless/realtek/rtlwifi/core.c
+++ b/drivers/net/wireless/realtek/rtlwifi/core.c
@@ -1655,7 +1655,7 @@ static int rtl_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 			memcpy(rtlpriv->sec.key_buf[key_idx],
 			       key->key, key->keylen);
 			rtlpriv->sec.key_len[key_idx] = key->keylen;
-			memcpy(mac_addr, bcast_addr, ETH_ALEN);
+			eth_broadcast_addr(mac_addr);
 		} else {	/* pairwise key */
 			rtl_dbg(rtlpriv, COMP_SEC, DBG_DMESG,
 				"set pairwise key\n");
-- 
2.25.1

