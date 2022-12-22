Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 600A2653B8A
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 06:11:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234956AbiLVFK4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 00:10:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiLVFKw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 00:10:52 -0500
Received: from todd.t-8ch.de (todd.t-8ch.de [IPv6:2a01:4f8:c010:41de::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12ACD1705E;
        Wed, 21 Dec 2022 21:10:50 -0800 (PST)
From:   Thomas =?utf-8?q?Wei=C3=9Fschuh?= <linux@weissschuh.net>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=weissschuh.net;
        s=mail; t=1671685847;
        bh=+TwYUhNEMciEbKy4LBuWCzsBr/FmeYPjRzvFbPwU3T0=;
        h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
        b=dkHGyX+F319hDFe8JREAbJkgVdPhAr4CDz63BQACf6YbFBNMSaW7heWcM4okGjKAG
         OBKf9L99sesfe+Ip0v+vT3Q8tzrBjLPSxIYbFSG8JJVBMuF53J+cPWhdZ5zp82kOSl
         LZ3pBptvCET0wdj8JRs4FopuKnYTOapc1polxjus=
Date:   Thu, 22 Dec 2022 05:10:44 +0000
Subject: [PATCH 1/8] HID: letsketch: Use hid_is_usb()
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Message-Id: <20221222-hid-v1-1-f4a6c35487a5@weissschuh.net>
References: <20221222-hid-v1-0-f4a6c35487a5@weissschuh.net>
In-Reply-To: <20221222-hid-v1-0-f4a6c35487a5@weissschuh.net>
To:     Hans de Goede <hdegoede@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        David Rheinsberg <david.rheinsberg@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org,
        Thomas =?utf-8?q?Wei=C3=9Fschuh?= <linux@weissschuh.net>
X-Mailer: b4 0.11.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1671685844; l=678;
 i=linux@weissschuh.net; s=20221212; h=from:subject:message-id;
 bh=+TwYUhNEMciEbKy4LBuWCzsBr/FmeYPjRzvFbPwU3T0=;
 b=ez9SDwFeWSSaEcM4FNhQ2nLrcWuyDgqqhikUkJqh92wXbyM7rYsccOS2kygfF76KfaUeMS6jE1Iz
 ZglXQ5nOBeq8iiv0o2fqnHwdmsPPpSmbESbRSY99mMGlo0AQyMBT
X-Developer-Key: i=linux@weissschuh.net; a=ed25519;
 pk=KcycQgFPX2wGR5azS7RhpBqedglOZVgRPfdFSPB1LNw=
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Don't open code existing functionality.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
---
 drivers/hid/hid-letsketch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-letsketch.c b/drivers/hid/hid-letsketch.c
index 74d17cf518ba..97f047f18136 100644
--- a/drivers/hid/hid-letsketch.c
+++ b/drivers/hid/hid-letsketch.c
@@ -238,7 +238,7 @@ static int letsketch_probe(struct hid_device *hdev, const struct hid_device_id *
 	char buf[256];
 	int i, ret;
 
-	if (!hid_is_using_ll_driver(hdev, &usb_hid_driver))
+	if (!hid_is_usb(hdev))
 		return -ENODEV;
 
 	intf = to_usb_interface(hdev->dev.parent);

-- 
2.39.0
