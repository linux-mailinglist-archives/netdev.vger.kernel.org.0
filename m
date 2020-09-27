Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3F2927A342
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 22:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727196AbgI0T6E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 15:58:04 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:41944 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726884AbgI0T5e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Sep 2020 15:57:34 -0400
Message-Id: <20200927194921.948595516@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1601236651;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=oz7MMx0m+YY+xDPxolgjEAAvNxkqMEkx+5nIefnzl+w=;
        b=ABAxgXDpnDlG0Iml8NGidsjTDhZ+eA7uUHX1jdoAJ5LhUnn3435WseXwB6lsJP+8OVPO73
        op3/YKII8cBU49VJx6qwb1fYHXy3gfjigdThQJMxq+gmvxL+kXa7pOlK9iOXXQPGOOE1uw
        OkF/7YY3ZhdxwUhZ8ZGcRYt9Fu/Aa5s3U6qTW/fQI4ATOeEm4DmLa9sbhYMOsnkFK5A200
        vmPrLUeKrIcET+nzYoyRZORuQ3J0F38/3kY+D1zrGUl7sprauO/ELTgD6H/Jz5OC8ksD2L
        LKicMP7DamTEmDzyP6dV2aBydduGST9aDeVgYKnrK4P2oewaYm94my+D+EN4wQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1601236651;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=oz7MMx0m+YY+xDPxolgjEAAvNxkqMEkx+5nIefnzl+w=;
        b=SlxksY1DEj9Xd72qZhNr1PYdEXP1s7TeRioy++tK3x9WpjFqV+l/nEVl7L74WkCZoo3wiA
        TGnvuw6z6DcmmnAg==
Date:   Sun, 27 Sep 2020 21:49:07 +0200
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linuxfoundation.org>,
        Paul McKenney <paulmck@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        Christian Benvenuti <benve@cisco.com>,
        Govindarajulu Varadarajan <_govind@gmx.com>,
        Dave Miller <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-doc@vger.kernel.org,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Jay Cliburn <jcliburn@gmail.com>,
        Chris Snook <chris.snook@gmail.com>,
        Vishal Kulkarni <vishal@chelsio.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        intel-wired-lan@lists.osuosl.org,
        Shannon Nelson <snelson@pensando.io>,
        Pensando Drivers <drivers@pensando.io>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
        Edward Cree <ecree@solarflare.com>,
        Martin Habets <mhabets@solarflare.com>,
        Jon Mason <jdmason@kudzu.us>, Daniel Drake <dsd@gentoo.org>,
        Ulrich Kunitz <kune@deine-taler.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        Stanislaw Gruszka <stf_xl@wp.pl>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Jouni Malinen <j@w1.fi>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        libertas-dev@lists.infradead.org,
        Pascal Terjan <pterjan@google.com>,
        Ping-Ke Shih <pkshih@realtek.com>
Subject: [patch 21/35] net: usb: kaweth: Remove last user of kaweth_control()
References: <20200927194846.045411263@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-transfer-encoding: 8-bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

kaweth_async_set_rx_mode() invokes kaweth_contol() and has two callers:

- kaweth_open() which is invoked from preemptible context
.
- kaweth_start_xmit() which holds a spinlock and has bottom halfs disabled.

If called from kaweth_start_xmit() kaweth_async_set_rx_mode() obviously
cannot block, which means it can't call kaweth_control(). This is detected
with an in_interrupt() check.

Replace the in_interrupt() check in kaweth_async_set_rx_mode() with an
argument which is set true by the caller if the context is safe to sleep,
otherwise false.

Now kaweth_control() is only called from preemptible context which means
there is no need for GFP_ATOMIC allocations anymore. Replace it with
usb_control_msg(). Cleanup the code a bit while at it.

Finally remove kaweth_control() since the last user is gone.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org
Cc: netdev@vger.kernel.org

---
 drivers/net/usb/kaweth.c |  168 ++++-------------------------------------------
 1 file changed, 17 insertions(+), 151 deletions(-)

--- a/drivers/net/usb/kaweth.c
+++ b/drivers/net/usb/kaweth.c
@@ -103,10 +103,6 @@ static int kaweth_probe(
 		const struct usb_device_id *id	/* from id_table */
 	);
 static void kaweth_disconnect(struct usb_interface *intf);
-static int kaweth_internal_control_msg(struct usb_device *usb_dev,
-				       unsigned int pipe,
-				       struct usb_ctrlrequest *cmd, void *data,
-				       int len, int timeout);
 static int kaweth_suspend(struct usb_interface *intf, pm_message_t message);
 static int kaweth_resume(struct usb_interface *intf);
 
@@ -236,48 +232,6 @@ struct kaweth_device
 };
 
 /****************************************************************
- *     kaweth_control
- ****************************************************************/
-static int kaweth_control(struct kaweth_device *kaweth,
-			  unsigned int pipe,
-			  __u8 request,
-			  __u8 requesttype,
-			  __u16 value,
-			  __u16 index,
-			  void *data,
-			  __u16 size,
-			  int timeout)
-{
-	struct usb_ctrlrequest *dr;
-	int retval;
-
-	if(in_interrupt()) {
-		netdev_dbg(kaweth->net, "in_interrupt()\n");
-		return -EBUSY;
-	}
-
-	dr = kmalloc(sizeof(struct usb_ctrlrequest), GFP_ATOMIC);
-	if (!dr)
-		return -ENOMEM;
-
-	dr->bRequestType = requesttype;
-	dr->bRequest = request;
-	dr->wValue = cpu_to_le16(value);
-	dr->wIndex = cpu_to_le16(index);
-	dr->wLength = cpu_to_le16(size);
-
-	retval = kaweth_internal_control_msg(kaweth->dev,
-					     pipe,
-					     dr,
-					     data,
-					     size,
-					     timeout);
-
-	kfree(dr);
-	return retval;
-}
-
-/****************************************************************
  *     kaweth_read_configuration
  ****************************************************************/
 static int kaweth_read_configuration(struct kaweth_device *kaweth)
@@ -531,7 +485,8 @@ static int kaweth_resubmit_rx_urb(struct
 	return result;
 }
 
-static void kaweth_async_set_rx_mode(struct kaweth_device *kaweth);
+static void kaweth_async_set_rx_mode(struct kaweth_device *kaweth,
+				     bool may_sleep);
 
 /****************************************************************
  *     kaweth_usb_receive
@@ -661,7 +616,7 @@ static int kaweth_open(struct net_device
 
 	netif_start_queue(net);
 
-	kaweth_async_set_rx_mode(kaweth);
+	kaweth_async_set_rx_mode(kaweth, true);
 	return 0;
 
 err_out:
@@ -749,7 +704,7 @@ static netdev_tx_t kaweth_start_xmit(str
 
 	spin_lock_irq(&kaweth->device_lock);
 
-	kaweth_async_set_rx_mode(kaweth);
+	kaweth_async_set_rx_mode(kaweth, false);
 	netif_stop_queue(net);
 	if (IS_BLOCKED(kaweth->status)) {
 		goto skip;
@@ -826,36 +781,31 @@ static void kaweth_set_rx_mode(struct ne
 /****************************************************************
  *     kaweth_async_set_rx_mode
  ****************************************************************/
-static void kaweth_async_set_rx_mode(struct kaweth_device *kaweth)
+static void kaweth_async_set_rx_mode(struct kaweth_device *kaweth,
+				     bool may_sleep)
 {
-	int result;
+	int ret;
 	__u16 packet_filter_bitmap = kaweth->packet_filter_bitmap;
 
 	kaweth->packet_filter_bitmap = 0;
 	if (packet_filter_bitmap == 0)
 		return;
 
-	if (in_interrupt())
+	if (!may_sleep)
 		return;
 
-	result = kaweth_control(kaweth,
-				usb_sndctrlpipe(kaweth->dev, 0),
-				KAWETH_COMMAND_SET_PACKET_FILTER,
-				USB_TYPE_VENDOR | USB_DIR_OUT | USB_RECIP_DEVICE,
-				packet_filter_bitmap,
-				0,
-				(void *)&kaweth->scratch,
-				0,
-				KAWETH_CONTROL_TIMEOUT);
-
-	if(result < 0) {
+	ret = usb_control_msg(kaweth->dev, usb_sndctrlpipe(kaweth->dev, 0),
+			      KAWETH_COMMAND_SET_PACKET_FILTER,
+			      USB_TYPE_VENDOR | USB_DIR_OUT | USB_RECIP_DEVICE,
+			      packet_filter_bitmap, 0,
+			      &kaweth->scratch, 0,
+			      KAWETH_CONTROL_TIMEOUT);
+	if (ret < 0)
 		dev_err(&kaweth->intf->dev, "Failed to set Rx mode: %d\n",
-			result);
-	}
-	else {
+			ret);
+	else
 		netdev_dbg(kaweth->net, "Set Rx mode to %d\n",
 			   packet_filter_bitmap);
-	}
 }
 
 /****************************************************************
@@ -1163,88 +1113,4 @@ static void kaweth_disconnect(struct usb
 }
 
 
-// FIXME this completion stuff is a modified clone of
-// an OLD version of some stuff in usb.c ...
-struct usb_api_data {
-	wait_queue_head_t wqh;
-	int done;
-};
-
-/*-------------------------------------------------------------------*
- * completion handler for compatibility wrappers (sync control/bulk) *
- *-------------------------------------------------------------------*/
-static void usb_api_blocking_completion(struct urb *urb)
-{
-        struct usb_api_data *awd = (struct usb_api_data *)urb->context;
-
-	awd->done=1;
-	wake_up(&awd->wqh);
-}
-
-/*-------------------------------------------------------------------*
- *                         COMPATIBILITY STUFF                       *
- *-------------------------------------------------------------------*/
-
-// Starts urb and waits for completion or timeout
-static int usb_start_wait_urb(struct urb *urb, int timeout, int* actual_length)
-{
-	struct usb_api_data awd;
-        int status;
-
-        init_waitqueue_head(&awd.wqh);
-        awd.done = 0;
-
-        urb->context = &awd;
-        status = usb_submit_urb(urb, GFP_ATOMIC);
-        if (status) {
-                // something went wrong
-                usb_free_urb(urb);
-                return status;
-        }
-
-	if (!wait_event_timeout(awd.wqh, awd.done, timeout)) {
-                // timeout
-                dev_warn(&urb->dev->dev, "usb_control/bulk_msg: timeout\n");
-                usb_kill_urb(urb);  // remove urb safely
-                status = -ETIMEDOUT;
-        }
-	else {
-                status = urb->status;
-	}
-
-        if (actual_length) {
-                *actual_length = urb->actual_length;
-	}
-
-        usb_free_urb(urb);
-        return status;
-}
-
-/*-------------------------------------------------------------------*/
-// returns status (negative) or length (positive)
-static int kaweth_internal_control_msg(struct usb_device *usb_dev,
-				       unsigned int pipe,
-				       struct usb_ctrlrequest *cmd, void *data,
-				       int len, int timeout)
-{
-        struct urb *urb;
-        int retv;
-        int length = 0; /* shut up GCC */
-
-	urb = usb_alloc_urb(0, GFP_ATOMIC);
-        if (!urb)
-                return -ENOMEM;
-
-        usb_fill_control_urb(urb, usb_dev, pipe, (unsigned char*)cmd, data,
-			 len, usb_api_blocking_completion, NULL);
-
-        retv = usb_start_wait_urb(urb, timeout, &length);
-        if (retv < 0) {
-                return retv;
-	}
-        else {
-                return length;
-	}
-}
-
 module_usb_driver(kaweth_driver);

