Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D92C4656217
	for <lists+netdev@lfdr.de>; Mon, 26 Dec 2022 12:14:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231979AbiLZLOT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Dec 2022 06:14:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229960AbiLZLOS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Dec 2022 06:14:18 -0500
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 556342DC1;
        Mon, 26 Dec 2022 03:14:17 -0800 (PST)
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mxct.zte.com.cn (FangMail) with ESMTPS id 4NgZtH4XSkz4xpyB;
        Mon, 26 Dec 2022 19:14:15 +0800 (CST)
Received: from szxlzmapp04.zte.com.cn ([10.5.231.166])
        by mse-fl2.zte.com.cn with SMTP id 2BQBE3HI073008;
        Mon, 26 Dec 2022 19:14:03 +0800 (+08)
        (envelope-from yang.yang29@zte.com.cn)
Received: from mapi (szxlzmapp01[null])
        by mapi (Zmail) with MAPI id mid14;
        Mon, 26 Dec 2022 19:14:06 +0800 (CST)
Date:   Mon, 26 Dec 2022 19:14:06 +0800 (CST)
X-Zmail-TransId: 2b0363a981fe61526202
X-Mailer: Zmail v1.0
Message-ID: <202212261914060599112@zte.com.cn>
Mime-Version: 1.0
From:   <yang.yang29@zte.com.cn>
To:     <kvalo@kernel.org>
Cc:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <xu.panda@zte.com.cn>, <yang.yang29@zte.com.cn>
Subject: =?UTF-8?B?W1BBVENIIHdpcmVsZXNzLW5leHQgdjJdIHdsMTh4eDogdXNlIHN0cnNjcHkoKSB0byBpbnN0ZWFkIG9mIHN0cm5jcHkoKQ==?=
Content-Type: text/plain;
        charset="UTF-8"
X-MAIL: mse-fl2.zte.com.cn 2BQBE3HI073008
X-Fangmail-Gw-Spam-Type: 0
X-FangMail-Miltered: at cgslv5.04-192.168.251.13.novalocal with ID 63A98207.001 by FangMail milter!
X-FangMail-Envelope: 1672053255/4NgZtH4XSkz4xpyB/63A98207.001/10.5.228.133/[10.5.228.133]/mse-fl2.zte.com.cn/<yang.yang29@zte.com.cn>
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 63A98207.001/4NgZtH4XSkz4xpyB
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xu Panda <xu.panda@zte.com.cn>

The implementation of strscpy() is more robust and safer.
That's now the recommended way to copy NUL-terminated strings.

Signed-off-by: Xu Panda <xu.panda@zte.com.cn>
Signed-off-by: Yang Yang <yang.yang29@zte.com>
---
change for v2
 - use the right tag of wireless-next. 
---
 drivers/net/wireless/ti/wl18xx/main.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 0b3cf8477c6c..1e4a430d1543 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -1516,12 +1516,9 @@ static int wl18xx_handle_static_data(struct wl1271 *wl,
 	struct wl18xx_static_data_priv *static_data_priv =
 		(struct wl18xx_static_data_priv *) static_data->priv;

-	strncpy(wl->chip.phy_fw_ver_str, static_data_priv->phy_version,
+	strscpy(wl->chip.phy_fw_ver_str, static_data_priv->phy_version,
 		sizeof(wl->chip.phy_fw_ver_str));

-	/* make sure the string is NULL-terminated */
-	wl->chip.phy_fw_ver_str[sizeof(wl->chip.phy_fw_ver_str) - 1] = '\0';
-
 	wl1271_info("PHY firmware version: %s", static_data_priv->phy_version);

 	return 0;
-- 
2.15.2
