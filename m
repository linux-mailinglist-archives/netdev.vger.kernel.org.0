Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBF3D211536
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 23:35:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727926AbgGAVfP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 17:35:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727856AbgGAVfF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 17:35:05 -0400
Received: from mout0.freenet.de (mout0.freenet.de [IPv6:2001:748:100:40::2:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86269C08C5C1;
        Wed,  1 Jul 2020 14:35:05 -0700 (PDT)
Received: from [195.4.92.165] (helo=mjail2.freenet.de)
        by mout0.freenet.de with esmtpa (ID viktor.jaegerskuepper@freenet.de) (port 25) (Exim 4.92 #3)
        id 1jqkNi-0007b5-Gv; Wed, 01 Jul 2020 23:35:02 +0200
Received: from [::1] (port=37846 helo=mjail2.freenet.de)
        by mjail2.freenet.de with esmtpa (ID viktor.jaegerskuepper@freenet.de) (Exim 4.92 #3)
        id 1jqkNi-0007cY-Fc; Wed, 01 Jul 2020 23:35:02 +0200
Received: from sub5.freenet.de ([195.4.92.124]:55734)
        by mjail2.freenet.de with esmtpa (ID viktor.jaegerskuepper@freenet.de) (Exim 4.92 #3)
        id 1jqkLO-00079j-GP; Wed, 01 Jul 2020 23:32:38 +0200
Received: from p200300e70725c1007461df5dd0c38276.dip0.t-ipconnect.de ([2003:e7:725:c100:7461:df5d:d0c3:8276]:59406 helo=[127.0.0.1])
        by sub5.freenet.de with esmtpsa (ID viktor.jaegerskuepper@freenet.de) (TLSv1.2:ECDHE-RSA-CHACHA20-POLY1305:256) (port 465) (Exim 4.92 #3)
        id 1jqkLN-0001xg-LJ; Wed, 01 Jul 2020 23:32:38 +0200
Subject: [PATCH v2] Revert "ath9k: Fix general protection fault in
 ath9k_hif_usb_rx_cb"
To:     Roman Mamedov <rm@romanrm.net>, Kalle Valo <kvalo@codeaurora.org>
Cc:     Qiujun Huang <hqjagain@gmail.com>, ath9k-devel@qca.qualcomm.com,
        davem@davemloft.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        anenbupt@gmail.com, syzkaller-bugs@googlegroups.com
References: <20200404041838.10426-1-hqjagain@gmail.com>
 <20200404041838.10426-6-hqjagain@gmail.com> <20200621020428.6417d6fb@natsu>
 <87lfkff9qe.fsf@codeaurora.org>
 <53940af0-d156-3117-ac86-2f3ccaee9513@freenet.de>
 <20200702005603.495c5d98@natsu>
From:   =?UTF-8?B?VmlrdG9yIErDpGdlcnNrw7xwcGVy?= 
        <viktor_jaegerskuepper@freenet.de>
Message-ID: <09616727-e09a-73af-7ee0-33d59278ff44@freenet.de>
Date:   Wed, 1 Jul 2020 23:32:28 +0200
MIME-Version: 1.0
In-Reply-To: <20200702005603.495c5d98@natsu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US-large
Content-Transfer-Encoding: 8bit
X-Originated-At: 2003:e7:725:c100:7461:df5d:d0c3:8276!59406
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 2bbcaaee1fcb ("ath9k: Fix general protection fault
in ath9k_hif_usb_rx_cb") because the driver gets stuck like this:

  [    5.778803] usb 1-5: Manufacturer: ATHEROS
  [   21.697488] usb 1-5: ath9k_htc: Firmware ath9k_htc/htc_9271-1.4.0.fw requested
  [   21.701377] usbcore: registered new interface driver ath9k_htc
  [   22.053705] usb 1-5: ath9k_htc: Transferred FW: ath9k_htc/htc_9271-1.4.0.fw, size: 51008
  [   22.306182] ath9k_htc 1-5:1.0: ath9k_htc: HTC initialized with 33 credits
  [  115.708513] ath9k_htc: Failed to initialize the device
  [  115.708683] usb 1-5: ath9k_htc: USB layer deinitialized

Reported-by: Roman Mamedov <rm@romanrm.net>
Ref: https://bugzilla.kernel.org/show_bug.cgi?id=208251
Fixes: 2bbcaaee1fcb ("ath9k: Fix general protection fault in ath9k_hif_usb_rx_cb")
Tested-by: Viktor Jägersküpper <viktor_jaegerskuepper@freenet.de>
Signed-off-by: Viktor Jägersküpper <viktor_jaegerskuepper@freenet.de>
---
Changes:
  - Use correct line indentations (Thanks, Roman!)
  - Use shorter commit reference in commit log
---
 drivers/net/wireless/ath/ath9k/hif_usb.c | 48 ++++++------------------
 drivers/net/wireless/ath/ath9k/hif_usb.h |  5 ---
 2 files changed, 11 insertions(+), 42 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index 4ed21dad6a8e..6049d3766c64 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -643,9 +643,9 @@ static void ath9k_hif_usb_rx_stream(struct hif_device_usb *hif_dev,
 
 static void ath9k_hif_usb_rx_cb(struct urb *urb)
 {
-	struct rx_buf *rx_buf = (struct rx_buf *)urb->context;
-	struct hif_device_usb *hif_dev = rx_buf->hif_dev;
-	struct sk_buff *skb = rx_buf->skb;
+	struct sk_buff *skb = (struct sk_buff *) urb->context;
+	struct hif_device_usb *hif_dev =
+		usb_get_intfdata(usb_ifnum_to_if(urb->dev, 0));
 	int ret;
 
 	if (!skb)
@@ -685,15 +685,14 @@ static void ath9k_hif_usb_rx_cb(struct urb *urb)
 	return;
 free:
 	kfree_skb(skb);
-	kfree(rx_buf);
 }
 
 static void ath9k_hif_usb_reg_in_cb(struct urb *urb)
 {
-	struct rx_buf *rx_buf = (struct rx_buf *)urb->context;
-	struct hif_device_usb *hif_dev = rx_buf->hif_dev;
-	struct sk_buff *skb = rx_buf->skb;
+	struct sk_buff *skb = (struct sk_buff *) urb->context;
 	struct sk_buff *nskb;
+	struct hif_device_usb *hif_dev =
+		usb_get_intfdata(usb_ifnum_to_if(urb->dev, 0));
 	int ret;
 
 	if (!skb)
@@ -751,7 +750,6 @@ static void ath9k_hif_usb_reg_in_cb(struct urb *urb)
 	return;
 free:
 	kfree_skb(skb);
-	kfree(rx_buf);
 	urb->context = NULL;
 }
 
@@ -797,7 +795,7 @@ static int ath9k_hif_usb_alloc_tx_urbs(struct hif_device_usb *hif_dev)
 	init_usb_anchor(&hif_dev->mgmt_submitted);
 
 	for (i = 0; i < MAX_TX_URB_NUM; i++) {
-		tx_buf = kzalloc(sizeof(*tx_buf), GFP_KERNEL);
+		tx_buf = kzalloc(sizeof(struct tx_buf), GFP_KERNEL);
 		if (!tx_buf)
 			goto err;
 
@@ -834,9 +832,8 @@ static void ath9k_hif_usb_dealloc_rx_urbs(struct hif_device_usb *hif_dev)
 
 static int ath9k_hif_usb_alloc_rx_urbs(struct hif_device_usb *hif_dev)
 {
-	struct rx_buf *rx_buf = NULL;
-	struct sk_buff *skb = NULL;
 	struct urb *urb = NULL;
+	struct sk_buff *skb = NULL;
 	int i, ret;
 
 	init_usb_anchor(&hif_dev->rx_submitted);
@@ -844,12 +841,6 @@ static int ath9k_hif_usb_alloc_rx_urbs(struct hif_device_usb *hif_dev)
 
 	for (i = 0; i < MAX_RX_URB_NUM; i++) {
 
-		rx_buf = kzalloc(sizeof(*rx_buf), GFP_KERNEL);
-		if (!rx_buf) {
-			ret = -ENOMEM;
-			goto err_rxb;
-		}
-
 		/* Allocate URB */
 		urb = usb_alloc_urb(0, GFP_KERNEL);
 		if (urb == NULL) {
@@ -864,14 +855,11 @@ static int ath9k_hif_usb_alloc_rx_urbs(struct hif_device_usb *hif_dev)
 			goto err_skb;
 		}
 
-		rx_buf->hif_dev = hif_dev;
-		rx_buf->skb = skb;
-
 		usb_fill_bulk_urb(urb, hif_dev->udev,
 				  usb_rcvbulkpipe(hif_dev->udev,
 						  USB_WLAN_RX_PIPE),
 				  skb->data, MAX_RX_BUF_SIZE,
-				  ath9k_hif_usb_rx_cb, rx_buf);
+				  ath9k_hif_usb_rx_cb, skb);
 
 		/* Anchor URB */
 		usb_anchor_urb(urb, &hif_dev->rx_submitted);
@@ -897,8 +885,6 @@ static int ath9k_hif_usb_alloc_rx_urbs(struct hif_device_usb *hif_dev)
 err_skb:
 	usb_free_urb(urb);
 err_urb:
-	kfree(rx_buf);
-err_rxb:
 	ath9k_hif_usb_dealloc_rx_urbs(hif_dev);
 	return ret;
 }
@@ -910,21 +896,14 @@ static void ath9k_hif_usb_dealloc_reg_in_urbs(struct hif_device_usb *hif_dev)
 
 static int ath9k_hif_usb_alloc_reg_in_urbs(struct hif_device_usb *hif_dev)
 {
-	struct rx_buf *rx_buf = NULL;
-	struct sk_buff *skb = NULL;
 	struct urb *urb = NULL;
+	struct sk_buff *skb = NULL;
 	int i, ret;
 
 	init_usb_anchor(&hif_dev->reg_in_submitted);
 
 	for (i = 0; i < MAX_REG_IN_URB_NUM; i++) {
 
-		rx_buf = kzalloc(sizeof(*rx_buf), GFP_KERNEL);
-		if (!rx_buf) {
-			ret = -ENOMEM;
-			goto err_rxb;
-		}
-
 		/* Allocate URB */
 		urb = usb_alloc_urb(0, GFP_KERNEL);
 		if (urb == NULL) {
@@ -939,14 +918,11 @@ static int ath9k_hif_usb_alloc_reg_in_urbs(struct hif_device_usb *hif_dev)
 			goto err_skb;
 		}
 
-		rx_buf->hif_dev = hif_dev;
-		rx_buf->skb = skb;
-
 		usb_fill_int_urb(urb, hif_dev->udev,
 				  usb_rcvintpipe(hif_dev->udev,
 						  USB_REG_IN_PIPE),
 				  skb->data, MAX_REG_IN_BUF_SIZE,
-				  ath9k_hif_usb_reg_in_cb, rx_buf, 1);
+				  ath9k_hif_usb_reg_in_cb, skb, 1);
 
 		/* Anchor URB */
 		usb_anchor_urb(urb, &hif_dev->reg_in_submitted);
@@ -972,8 +948,6 @@ static int ath9k_hif_usb_alloc_reg_in_urbs(struct hif_device_usb *hif_dev)
 err_skb:
 	usb_free_urb(urb);
 err_urb:
-	kfree(rx_buf);
-err_rxb:
 	ath9k_hif_usb_dealloc_reg_in_urbs(hif_dev);
 	return ret;
 }
diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.h b/drivers/net/wireless/ath/ath9k/hif_usb.h
index 5985aa15ca93..a94e7e1c86e9 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.h
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.h
@@ -86,11 +86,6 @@ struct tx_buf {
 	struct list_head list;
 };
 
-struct rx_buf {
-	struct sk_buff *skb;
-	struct hif_device_usb *hif_dev;
-};
-
 #define HIF_USB_TX_STOP  BIT(0)
 #define HIF_USB_TX_FLUSH BIT(1)
 
--
2.27.0
