Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA57869A813
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 10:25:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbjBQJZs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 04:25:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbjBQJZq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 04:25:46 -0500
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D93846186C;
        Fri, 17 Feb 2023 01:25:40 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R571e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046056;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0Vbs.nP9_1676625932;
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0Vbs.nP9_1676625932)
          by smtp.aliyun-inc.com;
          Fri, 17 Feb 2023 17:25:37 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     pkshih@realtek.com
Cc:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH] rtlwifi: rtl8192de: Remove the unused variable bcnfunc_enable
Date:   Fri, 17 Feb 2023 17:25:29 +0800
Message-Id: <20230217092529.105899-1-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Variable bcnfunc_enable is not effectively used, so delete it.

drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c:1050:5: warning: variable 'bcnfunc_enable' set but not used.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=4110
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c
index 2aecb2583f75..df1e36fbc348 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c
@@ -1047,7 +1047,6 @@ static int _rtl92de_set_media_status(struct ieee80211_hw *hw,
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	u8 bt_msr = rtl_read_byte(rtlpriv, MSR);
 	enum led_ctl_mode ledaction = LED_CTL_NO_LINK;
-	u8 bcnfunc_enable;
 
 	bt_msr &= 0xfc;
 
@@ -1064,31 +1063,26 @@ static int _rtl92de_set_media_status(struct ieee80211_hw *hw,
 			"Set HW_VAR_MEDIA_STATUS: No such media status(%x)\n",
 			type);
 	}
-	bcnfunc_enable = rtl_read_byte(rtlpriv, REG_BCN_CTRL);
 	switch (type) {
 	case NL80211_IFTYPE_UNSPECIFIED:
 		bt_msr |= MSR_NOLINK;
 		ledaction = LED_CTL_LINK;
-		bcnfunc_enable &= 0xF7;
 		rtl_dbg(rtlpriv, COMP_INIT, DBG_TRACE,
 			"Set Network type to NO LINK!\n");
 		break;
 	case NL80211_IFTYPE_ADHOC:
 		bt_msr |= MSR_ADHOC;
-		bcnfunc_enable |= 0x08;
 		rtl_dbg(rtlpriv, COMP_INIT, DBG_TRACE,
 			"Set Network type to Ad Hoc!\n");
 		break;
 	case NL80211_IFTYPE_STATION:
 		bt_msr |= MSR_INFRA;
 		ledaction = LED_CTL_LINK;
-		bcnfunc_enable &= 0xF7;
 		rtl_dbg(rtlpriv, COMP_INIT, DBG_TRACE,
 			"Set Network type to STA!\n");
 		break;
 	case NL80211_IFTYPE_AP:
 		bt_msr |= MSR_AP;
-		bcnfunc_enable |= 0x08;
 		rtl_dbg(rtlpriv, COMP_INIT, DBG_TRACE,
 			"Set Network type to AP!\n");
 		break;
-- 
2.20.1.7.g153144c

