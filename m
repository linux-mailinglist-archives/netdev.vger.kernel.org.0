Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F0A44B52CC
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 15:08:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354615AbiBNOIf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 09:08:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233557AbiBNOIc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 09:08:32 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46AE82ACA;
        Mon, 14 Feb 2022 06:08:24 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id E2138210F9;
        Mon, 14 Feb 2022 14:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1644847702; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=LNgU2/TJ32LMaRjH5/bFlTFRrwxbTuUloB22no9O++8=;
        b=EDeDstbblMYM3sn5sKYtajQTBbO0ywVQ2dZrhn33a2Jno9zraWdQ+4p6th8n7BasNslfyt
        YZz0ReIOgnTYREZ4qFI8hnspevKYIgy1Ko722avcsHc1Uieny7m//7YgnfZSRnqIgiLHSQ
        04aIvFijxcsBJwDA02Btprnl7G204Gg=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8486413B3A;
        Mon, 14 Feb 2022 14:08:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id nz1bHlZiCmIBPAAAMHmgww
        (envelope-from <oneukum@suse.com>); Mon, 14 Feb 2022 14:08:22 +0000
From:   Oliver Neukum <oneukum@suse.com>
To:     linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, gregKH@linuxfoundation.org
Cc:     Oliver Neukum <oneukum@suse.com>,
        Ross Maynard <bids.7405@bigpond.com>
Subject: [PATCHv3] USB: zaurus: support another broken Zaurus
Date:   Mon, 14 Feb 2022 15:08:18 +0100
Message-Id: <20220214140818.26600-1-oneukum@suse.com>
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

v2: added Reporter and Link
v3: checkpatch issues

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
index 8e717a0b559b..7984f2157d22 100644
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
+	.match_flags    =   USB_DEVICE_ID_MATCH_INT_INFO
+			    | USB_DEVICE_ID_MATCH_DEVICE,
+	.idVendor		= 0x04DD,
+	.idProduct		= 0x9032,	/* SL-6000 */
+	ZAURUS_FAKE_INTERFACE,
+	.driver_info = (unsigned long)&bogus_mdlm_info,
 }, {
 	.match_flags    =   USB_DEVICE_ID_MATCH_INT_INFO
 		 | USB_DEVICE_ID_MATCH_DEVICE,
-- 
2.34.1

