Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CE106A50ED
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 03:11:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbjB1CLt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 21:11:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjB1CLs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 21:11:48 -0500
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC1772748C;
        Mon, 27 Feb 2023 18:11:46 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R261e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046056;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0Vch.eGG_1677550293;
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0Vch.eGG_1677550293)
          by smtp.aliyun-inc.com;
          Tue, 28 Feb 2023 10:11:43 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     pkshih@realtek.com
Cc:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH] rtlwifi: rtl8192se: Remove the unused variable bcntime_cfg
Date:   Tue, 28 Feb 2023 10:11:32 +0800
Message-Id: <20230228021132.88910-1-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Variable bcntime_cfg is not effectively used, so delete it.

drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c:1555:6: warning: variable 'bcntime_cfg' set but not used.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=4240
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c
index bd0b7e365edb..e1eb9d8203ab 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c
@@ -1552,7 +1552,6 @@ void rtl92se_set_beacon_related_registers(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
-	u16 bcntime_cfg = 0;
 	u16 bcn_cw = 6, bcn_ifs = 0xf;
 	u16 atim_window = 2;
 
@@ -1576,13 +1575,6 @@ void rtl92se_set_beacon_related_registers(struct ieee80211_hw *hw)
 	 * other ad hoc STA */
 	rtl_write_byte(rtlpriv, BCN_ERR_THRESH, 100);
 
-	/* Beacon Time Configuration */
-	if (mac->opmode == NL80211_IFTYPE_ADHOC)
-		bcntime_cfg |= (bcn_cw << BCN_TCFG_CW_SHIFT);
-
-	/* TODO: bcn_ifs may required to be changed on ASIC */
-	bcntime_cfg |= bcn_ifs << BCN_TCFG_IFS;
-
 	/*for beacon changed */
 	rtl92s_phy_set_beacon_hwreg(hw, mac->beacon_interval);
 }
-- 
2.20.1.7.g153144c

