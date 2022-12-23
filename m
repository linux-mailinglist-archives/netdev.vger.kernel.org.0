Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D473E654B72
	for <lists+netdev@lfdr.de>; Fri, 23 Dec 2022 04:00:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235667AbiLWDA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 22:00:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbiLWDA1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 22:00:27 -0500
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [63.216.63.35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0F66275EC;
        Thu, 22 Dec 2022 19:00:26 -0800 (PST)
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mxhk.zte.com.cn (FangMail) with ESMTPS id 4NdX3s3sfHz5PkHg;
        Fri, 23 Dec 2022 11:00:25 +0800 (CST)
Received: from szxlzmapp03.zte.com.cn ([10.5.231.207])
        by mse-fl2.zte.com.cn with SMTP id 2BN30HKW067276;
        Fri, 23 Dec 2022 11:00:17 +0800 (+08)
        (envelope-from yang.yang29@zte.com.cn)
Received: from mapi (szxlzmapp02[null])
        by mapi (Zmail) with MAPI id mid14;
        Fri, 23 Dec 2022 11:00:18 +0800 (CST)
Date:   Fri, 23 Dec 2022 11:00:18 +0800 (CST)
X-Zmail-TransId: 2b0463a519c2ffffffffd73bde3c
X-Mailer: Zmail v1.0
Message-ID: <202212231100187262916@zte.com.cn>
Mime-Version: 1.0
From:   <yang.yang29@zte.com.cn>
To:     <kvalo@kernel.org>
Cc:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <xu.panda@zte.com.cn>,
        <yang.yang29@zte.com.cn>
Subject: =?UTF-8?B?W1BBVENIIG5ldC1uZXh0XSB3bGNvcmU6IHVzZSBzdHJzY3B5KCkgdG8gaW5zdGVhZCBvZiBzdHJuY3B5KCk=?=
Content-Type: text/plain;
        charset="UTF-8"
X-MAIL: mse-fl2.zte.com.cn 2BN30HKW067276
X-Fangmail-Gw-Spam-Type: 0
X-FangMail-Miltered: at cgslv5.04-192.168.250.138.novalocal with ID 63A519C9.001 by FangMail milter!
X-FangMail-Envelope: 1671764425/4NdX3s3sfHz5PkHg/63A519C9.001/10.5.228.133/[10.5.228.133]/mse-fl2.zte.com.cn/<yang.yang29@zte.com.cn>
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 63A519C9.001/4NdX3s3sfHz5PkHg
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
 drivers/net/wireless/ti/wlcore/boot.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/boot.c b/drivers/net/wireless/ti/wlcore/boot.c
index 85abd0a2d1c9..f481c2e3dbc8 100644
--- a/drivers/net/wireless/ti/wlcore/boot.c
+++ b/drivers/net/wireless/ti/wlcore/boot.c
@@ -41,12 +41,9 @@ static int wlcore_boot_parse_fw_ver(struct wl1271 *wl,
 {
 	int ret;

-	strncpy(wl->chip.fw_ver_str, static_data->fw_version,
+	strscpy(wl->chip.fw_ver_str, static_data->fw_version,
 		sizeof(wl->chip.fw_ver_str));

-	/* make sure the string is NULL-terminated */
-	wl->chip.fw_ver_str[sizeof(wl->chip.fw_ver_str) - 1] = '\0';
-
 	ret = sscanf(wl->chip.fw_ver_str + 4, "%u.%u.%u.%u.%u",
 		     &wl->chip.fw_ver[0], &wl->chip.fw_ver[1],
 		     &wl->chip.fw_ver[2], &wl->chip.fw_ver[3],
-- 
2.15.2
