Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CEC9235161
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 11:13:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728770AbgHAJN0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Aug 2020 05:13:26 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:54410 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725876AbgHAJN0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 1 Aug 2020 05:13:26 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id D4254CCF6278C7BA1681;
        Sat,  1 Aug 2020 17:13:19 +0800 (CST)
Received: from huawei.com (10.175.101.6) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.487.0; Sat, 1 Aug 2020
 17:13:13 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     <johannes@sipsolutions.net>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linmiaohe@huawei.com>
Subject: [PATCH] nl80211: use eth_zero_addr() to clear mac address
Date:   Sat, 1 Aug 2020 17:15:49 +0800
Message-ID: <1596273349-24333-1-git-send-email-linmiaohe@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

Use eth_zero_addr() to clear mac address instead of memset().

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 net/wireless/nl80211.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 7fbca0854265..c88f9d09cb25 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -10394,8 +10394,7 @@ static int nl80211_connect(struct sk_buff *skb, struct genl_info *info)
 			memcpy(dev->ieee80211_ptr->disconnect_bssid,
 			       connect.bssid, ETH_ALEN);
 		else
-			memset(dev->ieee80211_ptr->disconnect_bssid,
-			       0, ETH_ALEN);
+			eth_zero_addr(dev->ieee80211_ptr->disconnect_bssid);
 	}
 
 	wdev_unlock(dev->ieee80211_ptr);
-- 
2.19.1

