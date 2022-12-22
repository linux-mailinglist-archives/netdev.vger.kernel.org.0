Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3DBA653BAC
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 06:11:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235103AbiLVFLY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 00:11:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234935AbiLVFK4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 00:10:56 -0500
Received: from todd.t-8ch.de (todd.t-8ch.de [IPv6:2a01:4f8:c010:41de::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 381B31658E;
        Wed, 21 Dec 2022 21:10:54 -0800 (PST)
From:   Thomas =?utf-8?q?Wei=C3=9Fschuh?= <linux@weissschuh.net>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=weissschuh.net;
        s=mail; t=1671685851;
        bh=3tt57RWBYX5CpuseBTCAV7ztLBfuQPQBKVNcrS3Coqo=;
        h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
        b=epcg2+BoRcWGmGGExUkIbvMK3fOGUjiEpfuFMiP5Tk8cnxTRWIzvBWidu537lLYcD
         XHcmWj/niC/YYxHl2d9Tp0CCnRI/ez+gg1Vk9vrfKrMDW/6mLdadFHCPQe40DB5U0f
         LMgI6Wat2IpMhJynmRD6LU6BVfS5HjScNkZKUq7I=
Date:   Thu, 22 Dec 2022 05:10:50 +0000
Subject: [PATCH 7/8] HID: Unexport struct i2c_hid_ll_driver
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Message-Id: <20221222-hid-v1-7-f4a6c35487a5@weissschuh.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1671685845; l=1468;
 i=linux@weissschuh.net; s=20221212; h=from:subject:message-id;
 bh=3tt57RWBYX5CpuseBTCAV7ztLBfuQPQBKVNcrS3Coqo=;
 b=osblnINoh9h3TCBJu+R5RiGx1YADyMfECKm+DAviSnAPrv2sUjAeix34W7wZKB3wMhcCKrZ6KPas
 ScB0DkgNAuPTRFqHvN9l+muu7v+WUErl0i20VnRMX4+88j1EYq/f
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
 drivers/hid/i2c-hid/i2c-hid-core.c | 3 +--
 include/linux/hid.h                | 2 --
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/hid/i2c-hid/i2c-hid-core.c b/drivers/hid/i2c-hid/i2c-hid-core.c
index b86b62f97108..fc5a0dd4eb92 100644
--- a/drivers/hid/i2c-hid/i2c-hid-core.c
+++ b/drivers/hid/i2c-hid/i2c-hid-core.c
@@ -842,7 +842,7 @@ static void i2c_hid_close(struct hid_device *hid)
 	clear_bit(I2C_HID_STARTED, &ihid->flags);
 }
 
-struct hid_ll_driver i2c_hid_ll_driver = {
+static struct hid_ll_driver i2c_hid_ll_driver = {
 	.parse = i2c_hid_parse,
 	.start = i2c_hid_start,
 	.stop = i2c_hid_stop,
@@ -851,7 +851,6 @@ struct hid_ll_driver i2c_hid_ll_driver = {
 	.output_report = i2c_hid_output_report,
 	.raw_request = i2c_hid_raw_request,
 };
-EXPORT_SYMBOL_GPL(i2c_hid_ll_driver);
 
 static int i2c_hid_init_irq(struct i2c_client *client)
 {
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 21017e1ddbdb..60a092150bc6 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -853,8 +853,6 @@ struct hid_ll_driver {
 	bool (*may_wakeup)(struct hid_device *hdev);
 };
 
-extern struct hid_ll_driver i2c_hid_ll_driver;
-
 extern bool hid_is_usb(const struct hid_device *hdev);
 
 #define	PM_HINT_FULLON	1<<5

-- 
2.39.0
