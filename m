Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45E55642571
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 10:09:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbiLEJJ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 04:09:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbiLEJIf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 04:08:35 -0500
X-Greylist: delayed 808 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 05 Dec 2022 01:08:17 PST
Received: from forward105j.mail.yandex.net (forward105j.mail.yandex.net [5.45.198.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95DBA11C3D;
        Mon,  5 Dec 2022 01:08:17 -0800 (PST)
Received: from myt6-bd59def10a3e.qloud-c.yandex.net (myt6-bd59def10a3e.qloud-c.yandex.net [IPv6:2a02:6b8:c12:2487:0:640:bd59:def1])
        by forward105j.mail.yandex.net (Yandex) with ESMTP id 6B5204ECA42D;
        Mon,  5 Dec 2022 11:53:48 +0300 (MSK)
Received: by myt6-bd59def10a3e.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id hrRE5NnYLGk1-jjaJR5Oi;
        Mon, 05 Dec 2022 11:53:47 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1670230427;
        bh=nlHUmVYpdftndnegSElvuzQFYDoRyQq2iItNKu1ivvk=;
        h=Message-Id:Date:Cc:Subject:To:From;
        b=gKqBBB63dzgbuvZ/QR3Kl0SILSBrpIp/v4Z2BgpD9dtEXRleuFo893iPsY2DYSKdZ
         bRSRu9NjS/KSl/Qjwk3ZK9Ys9/HSuK/jLPLSneX+vn26L+thpCFlUOYafomEmEjFnj
         e1eKxRk/mXiXOHotxWwuk2ZTvLuqE52gwCrrii7c=
Authentication-Results: myt6-bd59def10a3e.qloud-c.yandex.net; dkim=pass header.i=@yandex.ru
From:   Peter Kosyh <pkosyh@yandex.ru>
To:     Ping-Ke Shih <pkshih@realtek.com>
Cc:     Peter Kosyh <pkosyh@yandex.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Kalle Valo <kvalo@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
Subject: [PATCH] rtlwifi: rtl8192se: remove redundant rtl_get_bbreg call
Date:   Mon,  5 Dec 2022 11:53:42 +0300
Message-Id: <20221205085342.677329-1-pkosyh@yandex.ru>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extra rtl_get_bbreg looks like redundant reading. The read has
already been done in the "else" branch. Compile test only.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Peter Kosyh <pkosyh@yandex.ru>
---
If this code is important for the operation of the hardware, then it would
be nice to comment on it.

 drivers/net/wireless/realtek/rtlwifi/rtl8192se/phy.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/phy.c
index aaa004d4d6d0..09591a0b5a81 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/phy.c
@@ -115,9 +115,6 @@ static u32 _rtl92s_phy_rf_serial_read(struct ieee80211_hw *hw,
 		retvalue = rtl_get_bbreg(hw, pphyreg->rf_rb,
 					 BLSSI_READBACK_DATA);
 
-	retvalue = rtl_get_bbreg(hw, pphyreg->rf_rb,
-				 BLSSI_READBACK_DATA);
-
 	rtl_dbg(rtlpriv, COMP_RF, DBG_TRACE, "RFR-%d Addr[0x%x]=0x%x\n",
 		rfpath, pphyreg->rf_rb, retvalue);
 
-- 
2.38.1

