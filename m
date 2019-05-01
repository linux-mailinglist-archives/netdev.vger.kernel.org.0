Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB03C109DE
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 17:16:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbfEAPQU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 11:16:20 -0400
Received: from gateway24.websitewelcome.com ([192.185.51.61]:29300 "EHLO
        gateway24.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726481AbfEAPQU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 11:16:20 -0400
Received: from cm11.websitewelcome.com (cm11.websitewelcome.com [100.42.49.5])
        by gateway24.websitewelcome.com (Postfix) with ESMTP id C92EAA824
        for <netdev@vger.kernel.org>; Wed,  1 May 2019 10:16:18 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id Lqy2hm4FNdnCeLqy2hWBJD; Wed, 01 May 2019 10:16:18 -0500
X-Authority-Reason: nr=8
Received: from [189.250.119.203] (port=59360 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.91)
        (envelope-from <gustavo@embeddedor.com>)
        id 1hLqy1-001KSh-O8; Wed, 01 May 2019 10:16:17 -0500
Date:   Wed, 1 May 2019 10:16:15 -0500
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH][next] rtw88: phy: mark expected switch fall-throughs
Message-ID: <20190501151615.GA18557@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.9.4 (2018-02-28)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 189.250.119.203
X-Source-L: No
X-Exim-ID: 1hLqy1-001KSh-O8
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [189.250.119.203]:59360
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 5
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation to enabling -Wimplicit-fallthrough, mark switch
cases where we are expecting to fall through.

This patch fixes the following warnings:

drivers/net/wireless/realtek/rtw88/phy.c: In function ‘rtw_get_channel_group’:
./include/linux/compiler.h:77:22: warning: this statement may fall through [-Wimplicit-fallthrough=]
 # define unlikely(x) __builtin_expect(!!(x), 0)
                      ^~~~~~~~~~~~~~~~~~~~~~~~~~
./include/asm-generic/bug.h:125:2: note: in expansion of macro ‘unlikely’
  unlikely(__ret_warn_on);     \
  ^~~~~~~~
drivers/net/wireless/realtek/rtw88/phy.c:907:3: note: in expansion of macro ‘WARN_ON’
   WARN_ON(1);
   ^~~~~~~
drivers/net/wireless/realtek/rtw88/phy.c:908:2: note: here
  case 1:
  ^~~~
In file included from ./include/linux/bcd.h:5,
                 from drivers/net/wireless/realtek/rtw88/phy.c:5:
drivers/net/wireless/realtek/rtw88/phy.c: In function ‘phy_get_2g_tx_power_index’:
./include/linux/compiler.h:77:22: warning: this statement may fall through [-Wimplicit-fallthrough=]
 # define unlikely(x) __builtin_expect(!!(x), 0)
                      ^~~~~~~~~~~~~~~~~~~~~~~~~~
./include/asm-generic/bug.h:125:2: note: in expansion of macro ‘unlikely’
  unlikely(__ret_warn_on);     \
  ^~~~~~~~
drivers/net/wireless/realtek/rtw88/phy.c:1021:3: note: in expansion of macro ‘WARN_ON’
   WARN_ON(1);
   ^~~~~~~
drivers/net/wireless/realtek/rtw88/phy.c:1022:2: note: here
  case RTW_CHANNEL_WIDTH_20:
  ^~~~

Warning level 3 was used: -Wimplicit-fallthrough=3

This patch is part of the ongoing efforts to enable
-Wimplicit-fallthrough.

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/net/wireless/realtek/rtw88/phy.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/phy.c b/drivers/net/wireless/realtek/rtw88/phy.c
index 35a35dbca85f..4381b360b5b5 100644
--- a/drivers/net/wireless/realtek/rtw88/phy.c
+++ b/drivers/net/wireless/realtek/rtw88/phy.c
@@ -905,6 +905,7 @@ static u8 rtw_get_channel_group(u8 channel)
 	switch (channel) {
 	default:
 		WARN_ON(1);
+		/* fall through */
 	case 1:
 	case 2:
 	case 36:
@@ -1019,6 +1020,7 @@ static u8 phy_get_2g_tx_power_index(struct rtw_dev *rtwdev,
 	switch (bandwidth) {
 	default:
 		WARN_ON(1);
+		/* fall through */
 	case RTW_CHANNEL_WIDTH_20:
 		tx_power += pwr_idx_2g->ht_1s_diff.bw20 * factor;
 		if (above_2ss)
@@ -1062,6 +1064,7 @@ static u8 phy_get_5g_tx_power_index(struct rtw_dev *rtwdev,
 	switch (bandwidth) {
 	default:
 		WARN_ON(1);
+		/* fall through */
 	case RTW_CHANNEL_WIDTH_20:
 		tx_power += pwr_idx_5g->ht_1s_diff.bw20 * factor;
 		if (above_2ss)
-- 
2.21.0

