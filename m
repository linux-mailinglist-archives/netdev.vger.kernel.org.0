Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07571653B90
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 06:11:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235007AbiLVFLA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 00:11:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234939AbiLVFK4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 00:10:56 -0500
Received: from todd.t-8ch.de (todd.t-8ch.de [IPv6:2a01:4f8:c010:41de::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E34F2165B2;
        Wed, 21 Dec 2022 21:10:54 -0800 (PST)
From:   Thomas =?utf-8?q?Wei=C3=9Fschuh?= <linux@weissschuh.net>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=weissschuh.net;
        s=mail; t=1671685851;
        bh=6D4t7+JXnsI1DZVJH2nKSPANnSWnoNUa6Jai4hAGGu0=;
        h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
        b=q5AqM4c+GY8WS6WkXYvHnj9n88nW4RLtbP/bIVz5vGdSs8bg194M4EbvKBEU34+F5
         eUX/KtMRAmD3EjJtYDRO8hEBI0AOlzsvVkAI/L4duw0OhcHG4El57ywfk1T6s8PtnT
         PEVkRt8ZCYM/c7PiaPR1F/z+L1oXeVAw4Ff41bsY=
Date:   Thu, 22 Dec 2022 05:10:48 +0000
Subject: [PATCH 5/8] HID: Unexport struct uhid_hid_driver
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Message-Id: <20221222-hid-v1-5-f4a6c35487a5@weissschuh.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1671685845; l=1385;
 i=linux@weissschuh.net; s=20221212; h=from:subject:message-id;
 bh=6D4t7+JXnsI1DZVJH2nKSPANnSWnoNUa6Jai4hAGGu0=;
 b=ueKsApjEc+dHlbV5vxODk6cHsdKukzb8/qpLEcck8VMUonrilUZkvyjDis9pnwrHNt9/RpmXQMV9
 cQwA8HBrBT1Wf/ImQaWGcl8NtV+HDRASjrB+h5PYMZU+iR0qrbwa
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

As there are no external users this implementation detail does not need
to be exported.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
---
 drivers/hid/uhid.c  | 3 +--
 include/linux/hid.h | 1 -
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/hid/uhid.c b/drivers/hid/uhid.c
index 2a918aeb0af1..6cec0614fc98 100644
--- a/drivers/hid/uhid.c
+++ b/drivers/hid/uhid.c
@@ -387,7 +387,7 @@ static int uhid_hid_output_report(struct hid_device *hid, __u8 *buf,
 	return uhid_hid_output_raw(hid, buf, count, HID_OUTPUT_REPORT);
 }
 
-struct hid_ll_driver uhid_hid_driver = {
+static struct hid_ll_driver uhid_hid_driver = {
 	.start = uhid_hid_start,
 	.stop = uhid_hid_stop,
 	.open = uhid_hid_open,
@@ -396,7 +396,6 @@ struct hid_ll_driver uhid_hid_driver = {
 	.raw_request = uhid_hid_raw_request,
 	.output_report = uhid_hid_output_report,
 };
-EXPORT_SYMBOL_GPL(uhid_hid_driver);
 
 #ifdef CONFIG_COMPAT
 
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 170cad696541..3fcc47a9d0e8 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -855,7 +855,6 @@ struct hid_ll_driver {
 
 extern struct hid_ll_driver i2c_hid_ll_driver;
 extern struct hid_ll_driver hidp_hid_driver;
-extern struct hid_ll_driver uhid_hid_driver;
 
 extern bool hid_is_usb(const struct hid_device *hdev);
 

-- 
2.39.0
