Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F38D44B1236
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 16:59:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243893AbiBJP7O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 10:59:14 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243877AbiBJP7O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 10:59:14 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 795C9E5D;
        Thu, 10 Feb 2022 07:59:15 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 33A2E1F391;
        Thu, 10 Feb 2022 15:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1644508754; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=YOI5IXCChR4iS9iMg/60P0pB3y6d34dpo7NowlPvL2M=;
        b=DNoTXdIg1t3T2A4tawxZehKP6lDR7yhLCwrT0LXExc89l/T7URVAB6GDN3jvEn4iVPJR5A
        LZV6aGISH5DLv6VeD1eNQRUC73t5I/V7IcC9Q/yKk+Yuf51PGG3ri8/dBLu/PXpMIlhyj0
        /7txhUtZ0wdx6BR5gWMYE1XDogEp3Jc=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D11B813BEF;
        Thu, 10 Feb 2022 15:59:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id FJpiMVE2BWJdIwAAMHmgww
        (envelope-from <oneukum@suse.com>); Thu, 10 Feb 2022 15:59:13 +0000
From:   Oliver Neukum <oneukum@suse.com>
To:     linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, gregKH@linuxfoundation.org
Cc:     Oliver Neukum <oneukum@suse.com>,
        Ross Maynard <bids.7405@bigpond.com>
Subject: [PATCHv2] USB: zaurus: support another broken Zaurus
Date:   Thu, 10 Feb 2022 16:59:11 +0100
Message-Id: <20220210155911.15973-1-oneukum@suse.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This SL-6000 says Direct Line, not Ethernet

v2: added Reporter and Link

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Reported-by: Ross Maynard <bids.7405@bigpond.com>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=215361
---
 drivers/net/usb/cdc_ether.c | 12 ++++++++++++
 drivers/net/usb/zaurus.c    | 12 ++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/drivers/net/usb/cdc_ether.c b/drivers/net/usb/cdc_ether.c
index eb3817d70f2b..9b4dfa3001d6 100644
--- a/drivers/net/usb/cdc_ether.c
+++ b/drivers/net/usb/cdc_ether.c
@@ -583,6 +583,11 @@ static const struct usb_device_id	products[] = {
 	.bInterfaceSubClass	= USB_CDC_SUBCLASS_ETHERNET, \
 	.bInterfaceProtocol	= USB_CDC_PROTO_NONE
 
+#define ZAURUS_FAKE_INTERFACE \
+	.bInterfaceClass	= USB_CLASS_COMM, \
+	.bInterfaceSubClass	= USB_CDC_SUBCLASS_MDLM, \
+	.bInterfaceProtocol	= USB_CDC_PROTO_NONE
+
 /* SA-1100 based Sharp Zaurus ("collie"), or compatible;
  * wire-incompatible with true CDC Ethernet implementations.
  * (And, it seems, needlessly so...)
@@ -636,6 +641,13 @@ static const struct usb_device_id	products[] = {
 	.idProduct              = 0x9032,	/* SL-6000 */
 	ZAURUS_MASTER_INTERFACE,
 	.driver_info		= 0,
+}, {
+	.match_flags    =   USB_DEVICE_ID_MATCH_INT_INFO
+		 | USB_DEVICE_ID_MATCH_DEVICE,
+	.idVendor               = 0x04DD,
+	.idProduct              = 0x9032,	/* SL-6000 */
+	ZAURUS_FAKE_INTERFACE,
+	.driver_info		= 0,
 }, {
 	.match_flags    =   USB_DEVICE_ID_MATCH_INT_INFO
 		 | USB_DEVICE_ID_MATCH_DEVICE,
diff --git a/drivers/net/usb/zaurus.c b/drivers/net/usb/zaurus.c
index 8e717a0b559b..5289b6e31713 100644
--- a/drivers/net/usb/zaurus.c
+++ b/drivers/net/usb/zaurus.c
@@ -256,6 +256,11 @@ static const struct usb_device_id	products [] = {
 	.bInterfaceSubClass	= USB_CDC_SUBCLASS_ETHERNET, \
 	.bInterfaceProtocol	= USB_CDC_PROTO_NONE
 
+#define ZAURUS_FAKE_INTERFACE \
+	.bInterfaceClass	= USB_CLASS_COMM, \
+	.bInterfaceSubClass	= USB_CDC_SUBCLASS_MDLM, \
+	.bInterfaceProtocol	= USB_CDC_PROTO_NONE
+
 /* SA-1100 based Sharp Zaurus ("collie"), or compatible. */
 {
 	.match_flags	=   USB_DEVICE_ID_MATCH_INT_INFO
@@ -313,6 +318,13 @@ static const struct usb_device_id	products [] = {
 	.idProduct              = 0x9032,	/* SL-6000 */
 	ZAURUS_MASTER_INTERFACE,
 	.driver_info = ZAURUS_PXA_INFO,
+}, {
+        .match_flags    =   USB_DEVICE_ID_MATCH_INT_INFO
+                 | USB_DEVICE_ID_MATCH_DEVICE,
+        .idVendor		= 0x04DD,
+        .idProduct		= 0x9032,	/* SL-6000 */
+        ZAURUS_FAKE_INTERFACE,
+        .driver_info = (unsigned long) &bogus_mdlm_info,
 }, {
 	.match_flags    =   USB_DEVICE_ID_MATCH_INT_INFO
 		 | USB_DEVICE_ID_MATCH_DEVICE,
-- 
2.34.1

