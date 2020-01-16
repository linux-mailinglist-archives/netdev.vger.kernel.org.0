Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC8E13DAAE
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 13:58:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbgAPM4n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 07:56:43 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:41436 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726018AbgAPM4n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 07:56:43 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id EAAFBB592AAA10E88C27;
        Thu, 16 Jan 2020 20:56:40 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.439.0; Thu, 16 Jan 2020 20:56:31 +0800
From:   Chen Zhou <chenzhou10@huawei.com>
To:     <johannes@sipsolutions.net>, <davem@davemloft.net>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <chenzhou10@huawei.com>
Subject: [PATCH -next] mac80111: fix build error without CONFIG_ATH11K_DEBUGFS
Date:   Thu, 16 Jan 2020 20:51:55 +0800
Message-ID: <20200116125155.166749-1-chenzhou10@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If CONFIG_ATH11K_DEBUGFS is n, build fails:

drivers/net/wireless/ath/ath11k/debugfs_sta.c: In function ath11k_dbg_sta_open_htt_peer_stats:
drivers/net/wireless/ath/ath11k/debugfs_sta.c:416:4: error: struct ath11k has no member named debug
  ar->debug.htt_stats.stats_req = stats_req;
      ^~
and many more similar messages.

Select ATH11K_DEBUGFS under config MAC80211_DEBUGFS to fix this.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Chen Zhou <chenzhou10@huawei.com>
---
 net/mac80211/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
index 0c93b1b..0f2c2b8 100644
--- a/net/mac80211/Kconfig
+++ b/net/mac80211/Kconfig
@@ -77,6 +77,7 @@ config MAC80211_LEDS
 
 config MAC80211_DEBUGFS
 	bool "Export mac80211 internals in DebugFS"
+	select ATH11K_DEBUGFS
 	depends on MAC80211 && DEBUG_FS
 	---help---
 	  Select this to see extensive information about
-- 
2.7.4

