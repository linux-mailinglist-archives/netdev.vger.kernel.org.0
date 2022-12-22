Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D643B653BA4
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 06:11:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231221AbiLVFLF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 00:11:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234942AbiLVFK4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 00:10:56 -0500
Received: from todd.t-8ch.de (todd.t-8ch.de [IPv6:2a01:4f8:c010:41de::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8F22167EA;
        Wed, 21 Dec 2022 21:10:54 -0800 (PST)
From:   Thomas =?utf-8?q?Wei=C3=9Fschuh?= <linux@weissschuh.net>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=weissschuh.net;
        s=mail; t=1671685851;
        bh=KNDYF1vETUCv281B3wbscifz4EYdRKLnRT85P8QGRws=;
        h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
        b=n5IDgDSgJ5Ft1nF8p7+fU1/gjFaYNms0ca7zuYALHWWAbIhrWhLcBASZkKCvQ0947
         fYurq0cMzFzNMk96ev9jnrGRWWj4bd1BF26Ct/acvIpq0JAv+fYpVvGflq5o0vNbJR
         rUlHKN6n/c2XGX6Smjaq1ugRhTBew55yFB8lHujg=
Date:   Thu, 22 Dec 2022 05:10:49 +0000
Subject: [PATCH 6/8] HID: Unexport struct hidp_hid_driver
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Message-Id: <20221222-hid-v1-6-f4a6c35487a5@weissschuh.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1671685845; l=1398;
 i=linux@weissschuh.net; s=20221212; h=from:subject:message-id;
 bh=KNDYF1vETUCv281B3wbscifz4EYdRKLnRT85P8QGRws=;
 b=/j3ygvhvFnOJULkdDMIiuq/c9IGI+in3/gju7WW3oMVJqQB8gWnhTYfiOIas7RwHuyv55bC8Ja/X
 MPkr7wWnAOo8Xb1xC5QrYW+9yzNGJOVrbkxXKNcJN6fTqBptKkmK
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
 include/linux/hid.h       | 1 -
 net/bluetooth/hidp/core.c | 3 +--
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/include/linux/hid.h b/include/linux/hid.h
index 3fcc47a9d0e8..21017e1ddbdb 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -854,7 +854,6 @@ struct hid_ll_driver {
 };
 
 extern struct hid_ll_driver i2c_hid_ll_driver;
-extern struct hid_ll_driver hidp_hid_driver;
 
 extern bool hid_is_usb(const struct hid_device *hdev);
 
diff --git a/net/bluetooth/hidp/core.c b/net/bluetooth/hidp/core.c
index cc20e706c639..c4a741f6ed5c 100644
--- a/net/bluetooth/hidp/core.c
+++ b/net/bluetooth/hidp/core.c
@@ -739,7 +739,7 @@ static void hidp_stop(struct hid_device *hid)
 	hid->claimed = 0;
 }
 
-struct hid_ll_driver hidp_hid_driver = {
+static struct hid_ll_driver hidp_hid_driver = {
 	.parse = hidp_parse,
 	.start = hidp_start,
 	.stop = hidp_stop,
@@ -748,7 +748,6 @@ struct hid_ll_driver hidp_hid_driver = {
 	.raw_request = hidp_raw_request,
 	.output_report = hidp_output_report,
 };
-EXPORT_SYMBOL_GPL(hidp_hid_driver);
 
 /* This function sets up the hid device. It does not add it
    to the HID system. That is done in hidp_add_connection(). */

-- 
2.39.0
