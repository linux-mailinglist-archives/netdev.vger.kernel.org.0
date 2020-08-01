Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5210623515A
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 11:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728643AbgHAJKc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Aug 2020 05:10:32 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:9309 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725876AbgHAJKb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 1 Aug 2020 05:10:31 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id A583C5CD1EA15CCC1FE4;
        Sat,  1 Aug 2020 17:10:11 +0800 (CST)
Received: from huawei.com (10.175.101.6) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.487.0; Sat, 1 Aug 2020
 17:10:03 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     <johannes@sipsolutions.net>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linmiaohe@huawei.com>
Subject: [PATCH] mac80211: use eth_zero_addr() to clear mac address
Date:   Sat, 1 Aug 2020 17:12:38 +0800
Message-ID: <1596273158-24183-1-git-send-email-linmiaohe@huawei.com>
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
 net/mac80211/trace.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 1b4709694d2a..50ab5b9d8eab 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -22,7 +22,8 @@
 #define LOCAL_PR_ARG	__entry->wiphy_name
 
 #define STA_ENTRY	__array(char, sta_addr, ETH_ALEN)
-#define STA_ASSIGN	(sta ? memcpy(__entry->sta_addr, sta->addr, ETH_ALEN) : memset(__entry->sta_addr, 0, ETH_ALEN))
+#define STA_ASSIGN	(sta ? memcpy(__entry->sta_addr, sta->addr, ETH_ALEN) : \
+				eth_zero_addr(__entry->sta_addr))
 #define STA_NAMED_ASSIGN(s)	memcpy(__entry->sta_addr, (s)->addr, ETH_ALEN)
 #define STA_PR_FMT	" sta:%pM"
 #define STA_PR_ARG	__entry->sta_addr
-- 
2.19.1

