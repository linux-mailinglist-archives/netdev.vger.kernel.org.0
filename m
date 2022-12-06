Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90382644188
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 11:49:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234216AbiLFKta (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 05:49:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230437AbiLFKt3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 05:49:29 -0500
Received: from forward101p.mail.yandex.net (forward101p.mail.yandex.net [IPv6:2a02:6b8:0:1472:2741:0:8b7:101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EFDD64CE
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 02:49:27 -0800 (PST)
Received: from iva8-7349aab11ef6.qloud-c.yandex.net (iva8-7349aab11ef6.qloud-c.yandex.net [IPv6:2a02:6b8:c0c:77a0:0:640:7349:aab1])
        by forward101p.mail.yandex.net (Yandex) with ESMTP id DC8CF59CDB63;
        Tue,  6 Dec 2022 13:49:25 +0300 (MSK)
Received: by iva8-7349aab11ef6.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id KnUKKV0YX8c1-DP2ttQIo;
        Tue, 06 Dec 2022 13:49:25 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1670323765;
        bh=nX5rRc1fYE1rUYGX4czhmXiyglfPlnnMYmPDIfaYWsI=;
        h=Message-Id:Date:Cc:Subject:To:From;
        b=WK3fA+FOCJEB15gwNSdsUK768K+sa5yZwNsulpHDlfd6eYEXrHzrXuFgePewB+z88
         mpsTm+QFta0iO1D0DehajL1WZ/SHFa6yjbuQvN2F+hJ8nMV8ERC5ipJlSVuJM24474
         s16qeLQ1SYkWydmYRmD6tVp9Exx2qMS3RX+9oeDQ=
Authentication-Results: iva8-7349aab11ef6.qloud-c.yandex.net; dkim=pass header.i=@yandex.ru
From:   Peter Kosyh <pkosyh@yandex.ru>
To:     Ping-Ke Shih <pkshih@realtek.com>
Cc:     Peter Kosyh <pkosyh@yandex.ru>, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
Subject: [PATCH] rtlwifi: btcoexist: fix conditions branches that are never executed
Date:   Tue,  6 Dec 2022 13:49:19 +0300
Message-Id: <20221206104919.739746-1-pkosyh@yandex.ru>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 40ca18823515 ("rtlwifi: btcoex: 23b 1ant: fine tune for wifi not
 connected") introduced never executed branches.

Compile test only.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Peter Kosyh <pkosyh@yandex.ru>
---
I'm not sure that patch do right thing! But these two places are really
never executed and should be fixed. I hope that Ping-Ka could check this.

 .../net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
index 70492929d7e4..039bbedb41c2 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
@@ -1903,7 +1903,7 @@ btc8723b1ant_action_wifi_not_conn_scan(struct btc_coexist *btcoexist)
 						true, 32);
 			halbtc8723b1ant_coex_table_with_type(btcoexist,
 							     NORMAL_EXEC, 4);
-		} else if (bt_link_info->a2dp_exist) {
+		} else if (bt_link_info->pan_exist) {
 			halbtc8723b1ant_ps_tdma(btcoexist, NORMAL_EXEC,
 						true, 22);
 			halbtc8723b1ant_coex_table_with_type(btcoexist,
@@ -1964,8 +1964,7 @@ static void btc8723b1ant_action_wifi_conn_scan(struct btc_coexist *btcoexist)
 						true, 32);
 			halbtc8723b1ant_coex_table_with_type(btcoexist,
 							     NORMAL_EXEC, 4);
-		} else if (bt_link_info->a2dp_exist &&
-			   bt_link_info->pan_exist) {
+		} else if (bt_link_info->pan_exist) {
 			halbtc8723b1ant_ps_tdma(btcoexist, NORMAL_EXEC,
 						true, 22);
 			halbtc8723b1ant_coex_table_with_type(btcoexist,
-- 
2.38.1

