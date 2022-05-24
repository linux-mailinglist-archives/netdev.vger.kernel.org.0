Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B1FC532694
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 11:38:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234452AbiEXJhw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 05:37:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231389AbiEXJhu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 05:37:50 -0400
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C626B64BF1;
        Tue, 24 May 2022 02:37:47 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0VEHf2Gg_1653385055;
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0VEHf2Gg_1653385055)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 24 May 2022 17:37:45 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     davem@davemloft.net
Cc:     edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH] r8152: Return true/false (not 1/0) from bool functions
Date:   Tue, 24 May 2022 17:37:33 +0800
Message-Id: <20220524093733.9537-1-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Return statements in functions returning bool should use true/false
instead of 1/0.

Clean the following coccicheck warning:

./drivers/net/usb/r8152.c:9579:10-11: WARNING: return of 0/1 in function
'rtl8152_supports_lenovo_macpassthru' with return type bool.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/net/usb/r8152.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 7389d6ef8569..7b7704b4b500 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -9576,15 +9576,15 @@ static bool rtl8152_supports_lenovo_macpassthru(struct usb_device *udev)
 		case DEVICE_ID_THINKPAD_USB_C_DOCK_GEN2:
 		case DEVICE_ID_THINKPAD_USB_C_DOCK_GEN3:
 		case DEVICE_ID_THINKPAD_USB_C_DONGLE:
-			return 1;
+			return true;
 		}
 	} else if (vendor_id == VENDOR_ID_REALTEK && parent_vendor_id == VENDOR_ID_LENOVO) {
 		switch (product_id) {
 		case 0x8153:
-			return 1;
+			return true;
 		}
 	}
-	return 0;
+	return false;
 }
 
 static int rtl8152_probe(struct usb_interface *intf,
-- 
2.20.1.7.g153144c

