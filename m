Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D1D8EA03
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 20:20:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728940AbfD2ST7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 14:19:59 -0400
Received: from gateway21.websitewelcome.com ([192.185.45.175]:13233 "EHLO
        gateway21.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728844AbfD2ST7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 14:19:59 -0400
Received: from cm10.websitewelcome.com (cm10.websitewelcome.com [100.42.49.4])
        by gateway21.websitewelcome.com (Postfix) with ESMTP id 0B193400DF91E
        for <netdev@vger.kernel.org>; Mon, 29 Apr 2019 13:19:58 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id LAsfhLds12PzOLAsghq1XH; Mon, 29 Apr 2019 13:19:58 -0500
X-Authority-Reason: nr=8
Received: from [189.250.54.97] (port=59422 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.91)
        (envelope-from <gustavo@embeddedor.com>)
        id 1hLAsa-002u1o-LD; Mon, 29 Apr 2019 13:19:57 -0500
Date:   Mon, 29 Apr 2019 13:19:50 -0500
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Johannes Berg <johannes@sipsolutions.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH][next] mac80211_hwsim: mark expected switch fall-through
Message-ID: <20190429181950.GA20946@embeddedor>
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
X-Source-IP: 189.250.54.97
X-Source-L: No
X-Exim-ID: 1hLAsa-002u1o-LD
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [189.250.54.97]:59422
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

This patch fixes the following warning:

drivers/net/wireless/mac80211_hwsim.c: In function ‘init_mac80211_hwsim’:
drivers/net/wireless/mac80211_hwsim.c:3853:21: warning: this statement may fall through [-Wimplicit-fallthrough=]
    param.reg_strict = true;
    ~~~~~~~~~~~~~~~~~^~~~~~
drivers/net/wireless/mac80211_hwsim.c:3854:3: note: here
   case HWSIM_REGTEST_DRIVER_REG_ALL:
   ^~~~

Warning level 3 was used: -Wimplicit-fallthrough=3

This patch is part of the ongoing efforts to enable
-Wimplicit-fallthrough.

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 60ca13e0f15b..b5274d1f30fa 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -3851,6 +3851,7 @@ static int __init init_mac80211_hwsim(void)
 			break;
 		case HWSIM_REGTEST_STRICT_ALL:
 			param.reg_strict = true;
+			/* fall through */
 		case HWSIM_REGTEST_DRIVER_REG_ALL:
 			param.reg_alpha2 = hwsim_alpha2s[0];
 			break;
-- 
2.21.0

