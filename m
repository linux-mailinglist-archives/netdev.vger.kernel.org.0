Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0411A5A3722
	for <lists+netdev@lfdr.de>; Sat, 27 Aug 2022 13:03:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233626AbiH0LDG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Aug 2022 07:03:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbiH0LDF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Aug 2022 07:03:05 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B36779A98E;
        Sat, 27 Aug 2022 04:03:03 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id i188-20020a1c3bc5000000b003a7b6ae4eb2so669750wma.4;
        Sat, 27 Aug 2022 04:03:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=ZBVxYAfDaqJMz8mjI8QWlW9FodyIHzxvNuvatUR69V0=;
        b=EWRmJBFcVOH8fXDsx6wqlvalLaW3FbexNZvYg3ZojKv72IfamhdCVM/TtNUA/6Mtuq
         tZC4UGB7d4cHHZ0Z0wiqG0gZTmO5/+Qp+3YYJAs2Khjk+oTNvG0y4SXrefYXO3HNaGmB
         Jbt+m+j4augHtVM6NeMrZZycvbR7bjCuaVue6VWtpnJxQi3vyN1pndP3ntf+irUM5TkP
         pyi1al51EM+/2nOYUv6oe4HeBWMNE8FQfdU3lz8HZ79EVufb5xmXu27oFbSUO2zglSDB
         TatBCxZSMkVkRHved0KSYYE78LjjFTG6rWVHmeYkvRg2niV8J6HVowOUuQVgEWdpmfMK
         sOrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=ZBVxYAfDaqJMz8mjI8QWlW9FodyIHzxvNuvatUR69V0=;
        b=xwEN64aEa0UjyO01v3LEshWOmje2MQmjUYdnnfCH9fkOaCsNlnCGlEpI6ODR7AX3J6
         6HHnP0q1XkjsdWXV0n76o6ffBixaH6nDfsWJRshjpyT46GtTSCwRzwqKdov8mBYWtqjE
         19Q+HQ+5pQFtyB9qoPuglLk3JSW7OytJMlLqNasqnZHH68w8bgUItWHZqS+P2+6+jitQ
         oQ1+LPUnxuT+HqV0/dTq8XhN/7/LrgLDKuatdviGf86HGVC3NDhM3kNLYEqUnjOUqLUW
         /HgNdLerNmbcTp1KzKzOX3vWLHOiSFQmKAIJzUxl4HIOx11azUmxaElVNUNGQNNLNFQZ
         POoA==
X-Gm-Message-State: ACgBeo2E8sg5oTf5V3Aw1e0gUQ3S+l+tG9ofY+e5r5VRVSjOcX8h3adN
        NdKako3wiQVLl9QYUkjPu5s=
X-Google-Smtp-Source: AA6agR4gZ+DRS/ZILUxySNqQaH7Ckv8ujePZSra2f2R+l6cxEWbaJKu1lE6OHAF3af2XlGFrg4j0jg==
X-Received: by 2002:a05:600c:a02:b0:39c:97cc:82e3 with SMTP id z2-20020a05600c0a0200b0039c97cc82e3mr2040506wmp.97.1661598182265;
        Sat, 27 Aug 2022 04:03:02 -0700 (PDT)
Received: from localhost.localdomain ([84.255.184.228])
        by smtp.gmail.com with ESMTPSA id z17-20020adfd0d1000000b00222ed7ea203sm2000678wrh.100.2022.08.27.04.02.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Aug 2022 04:03:00 -0700 (PDT)
From:   Mazin Al Haddad <mazinalhaddad05@gmail.com>
To:     pontus.fuchs@gmail.com
Cc:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        skhan@linuxfoundation.org,
        Mazin Al Haddad <mazinalhaddad05@gmail.com>,
        syzbot+1bc2c2afd44f820a669f@syzkaller.appspotmail.com
Subject: [PATCH v3] ar5523: check endpoints type and direction in probe()
Date:   Sat, 27 Aug 2022 14:01:49 +0300
Message-Id: <20220827110148.203104-1-mazinalhaddad05@gmail.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes a bug reported by syzbot, where a warning occurs in usb_submit_urb()
due to the wrong endpoint type. There is no check for both the number
of endpoints and the type.

Fix it by adding a check for the number of endpoints and the
direction/type of the endpoints. If the endpoints do not match -ENODEV is
returned.

usb 1-1: BOGUS urb xfer, pipe 3 != type 1
WARNING: CPU: 1 PID: 71 at drivers/usb/core/urb.c:502 usb_submit_urb+0xed2/0x18a0 drivers/usb/core/urb.c:502
Modules linked in:
CPU: 1 PID: 71 Comm: kworker/1:2 Not tainted 5.19.0-rc7-syzkaller-00150-g32f02a211b0a #0
Hardware name: Google Compute Engine/Google Compute Engine, BIOS Google 06/29/2022
Workqueue: usb_hub_wq hub_event
Call Trace:
 <TASK>
 ar5523_cmd+0x420/0x790 drivers/net/wireless/ath/ar5523/ar5523.c:275
 ar5523_cmd_read drivers/net/wireless/ath/ar5523/ar5523.c:302 [inline]
 ar5523_host_available drivers/net/wireless/ath/ar5523/ar5523.c:1376 [inline]
 ar5523_probe+0xc66/0x1da0 drivers/net/wireless/ath/ar5523/ar5523.c:1655

Link: https://syzkaller.appspot.com/bug?extid=1bc2c2afd44f820a669f
Reported-and-tested-by: syzbot+1bc2c2afd44f820a669f@syzkaller.appspotmail.com
Signed-off-by: Mazin Al Haddad <mazinalhaddad05@gmail.com>
---
v2->v3 changes:
 - Make use of helper functions instead of checking for direction
	 and type manually. 

 drivers/net/wireless/ath/ar5523/ar5523.c | 38 ++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/drivers/net/wireless/ath/ar5523/ar5523.c b/drivers/net/wireless/ath/ar5523/ar5523.c
index 6f937d2cc126..69979e8f99fd 100644
--- a/drivers/net/wireless/ath/ar5523/ar5523.c
+++ b/drivers/net/wireless/ath/ar5523/ar5523.c
@@ -1581,8 +1581,46 @@ static int ar5523_probe(struct usb_interface *intf,
 	struct usb_device *dev = interface_to_usbdev(intf);
 	struct ieee80211_hw *hw;
 	struct ar5523 *ar;
+	struct usb_host_interface *host = intf->cur_altsetting;
+	struct usb_endpoint_descriptor *cmd_tx, *cmd_rx, *data_tx, *data_rx;
 	int error = -ENOMEM;
 
+	if (host->desc.bNumEndpoints != 4) {
+		dev_err(&dev->dev, "Wrong number of endpoints\n");
+		return -ENODEV;
+	}
+
+	for (int i = 0; i < host->desc.bNumEndpoints; ++i) {
+		struct usb_endpoint_descriptor *ep = &host->endpoint[i].desc;
+
+		if (usb_endpoint_is_bulk_out(ep)) {
+			if (!cmd_tx) {
+				if (ep->bEndpointAddress == AR5523_CMD_TX_PIPE)
+					cmd_tx = ep;
+			}
+			if (!data_tx) {
+				if (ep->bEndpointAddress == AR5523_DATA_TX_PIPE)
+					data_tx = ep;
+				}
+		}
+
+		if (usb_endpoint_is_bulk_in(ep)) {
+			if (!cmd_rx) {
+				if (ep->bEndpointAddress == AR5523_CMD_RX_PIPE)
+					cmd_rx = ep;
+			}
+			if (!data_rx) {
+				if (ep->bEndpointAddress == AR5523_DATA_RX_PIPE)
+					data_rx = ep;
+			}
+		}
+	}
+
+	if (!cmd_tx || !data_tx || !cmd_rx || !data_rx) {
+		dev_warn("wrong number of endpoints\n");
+		return -ENODEV;
+	}
+
 	/*
 	 * Load firmware if the device requires it.  This will return
 	 * -ENXIO on success and we'll get called back afer the usb
-- 
2.37.2

