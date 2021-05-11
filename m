Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8D1737A95D
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 16:33:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231800AbhEKOeb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 10:34:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231760AbhEKOea (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 10:34:30 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C9C2C061574
        for <netdev@vger.kernel.org>; Tue, 11 May 2021 07:33:23 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id b11-20020a7bc24b0000b0290148da0694ffso1346150wmj.2
        for <netdev@vger.kernel.org>; Tue, 11 May 2021 07:33:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Zezgoqt0zCsoq+uBC0Vp75VtG0oU7/1H5gH0gmp1xrI=;
        b=kGpUCDEonFPeib3U7RBkBi/ayMuh/zQVldHg9RW6dlTSShPXtZ+ZwU7mv8PwxalWHe
         TPKxCEpnvoiXJKLy/vKNwF7BFl87Ta700kSKBRz6Dx3S6h62GkvW4VTolncDScZPNyGC
         8JBRjUPOXEbiVcaF4YD/xfp3YSseaAVbsjj07dRex8t15EzOnOQPbC4j4z5Aa8yPt5uz
         P1uJD4NWhuJSGolNseWMSSmCb+G7w1vgQ1wfS+Cu2m9o0yb4gSGsIsH5hzCoprb53z0c
         smXqU3NfUj/AlK9aT0AKRKRbUP7GWiZJYwNNpY5Cl4NGx5w7gBdhn/pA6XBCQyyq9JCj
         +Z2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Zezgoqt0zCsoq+uBC0Vp75VtG0oU7/1H5gH0gmp1xrI=;
        b=QZfv0gO/K6G52UwynwiDrDrmdobaQZZr73FZ3BQcAb5cOzvgatKt1YDi0kr7Utm27A
         k3sTAAt8dSErv8sclxpym8/OI0qViDbvEGHGQUgQzxKR/osLLeMDfGdnSw7tjWCKn217
         OhLPPIzAzzwfNzbxCbtIZRQ/BVM5VScwR/v1ox7lcNhBzImLXIwvlPdU3ipFfV2u7Hpl
         oKCjz5s/QDlV/IeOGz3mT1HPDicjQyD5nQqKtz8IrPWYO7vQzNsLPJhlEjcY5hojcLiF
         nLE3JdUIR1Asr0ZZVp9KFudjRh4dGPMPcPMAXXXXd5ARwXXtpTCJi0B4Rxt1EIlw7gNm
         jxBQ==
X-Gm-Message-State: AOAM530sKjfO5HOXTMzZ52Ta+phtjTUKCuypOIiPdFXv8IzcF/aSfI4P
        Kdo1EBaO1oIKN5GleEp6mGVVuw==
X-Google-Smtp-Source: ABdhPJyPS2QgxsXk589qMWLQLZSNhCDgM15l222IM5KK+Ppra4X0hRgqNSmZQZ2K+9T0enL2xBjf0g==
X-Received: by 2002:a1c:7f4a:: with SMTP id a71mr5774948wmd.60.1620743601231;
        Tue, 11 May 2021 07:33:21 -0700 (PDT)
Received: from localhost.localdomain ([2a01:e0a:82c:5f0:ddef:1d66:be88:86cc])
        by smtp.gmail.com with ESMTPSA id j13sm27773018wrw.93.2021.05.11.07.33.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 May 2021 07:33:20 -0700 (PDT)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     oliver@neukum.org
Cc:     kuba@kernel.org, davem@davemloft.net, bjorn@mork.no,
        netdev@vger.kernel.org, aleksander@aleksander.es,
        Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH net-next v2 2/2] usb: class: cdc-wdm: WWAN framework integration
Date:   Tue, 11 May 2021 16:42:23 +0200
Message-Id: <1620744143-26075-2-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1620744143-26075-1-git-send-email-loic.poulain@linaro.org>
References: <1620744143-26075-1-git-send-email-loic.poulain@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The WWAN framework provides a unified way to handle WWAN/modems and its
control port(s). It has initially been introduced to support MHI/PCI
modems, offering the same control protocols as the USB variants such as
MBIM, QMI, AT... The WWAN framework exposes these control protocols as
character devices, similarly to cdc-wdm, but in a bus agnostic fashion.

This change adds registration of the USB modem cdc-wdm control endpoints
to the WWAN framework as standard control ports (wwanXpY...).

Exposing cdc-wdm through WWAN framework normally maintains backward
compatibility, e.g:
    $ qmicli --device-open-qmi -d /dev/wwan0p1QMI --dms-get-ids
instead of
    $ qmicli --device-open-qmi -d /dev/cdc-wdm0 --dms-get-ids

However, some tools may rely on cdc-wdm driver/device name for device
detection. It is then safer to keep the 'legacy' cdc-wdm character
device to prevent any breakage. This is handled in this change by
API mutual exclusion, only one access method can be used at a time,
either cdc-wdm chardev or WWAN API.

Note that unknown channel types (other than MBIM, AT or MBIM) are not
registered to the WWAN framework.

Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
---
 v2: - Fix pm runtime while ongoing transmission
     - Use WWAN port type instead of CDC specific ones
     - Change port_start ordering
     - Handle usb_submit_urb return value
     - Fix build issue reported by kernel-test-rebot

 drivers/net/usb/cdc_mbim.c       |   1 +
 drivers/net/usb/huawei_cdc_ncm.c |   1 +
 drivers/net/usb/qmi_wwan.c       |   3 +-
 drivers/usb/class/cdc-wdm.c      | 180 ++++++++++++++++++++++++++++++++++++++-
 include/linux/usb/cdc-wdm.h      |   3 +-
 5 files changed, 182 insertions(+), 6 deletions(-)

diff --git a/drivers/net/usb/cdc_mbim.c b/drivers/net/usb/cdc_mbim.c
index 5db6627..42fb750 100644
--- a/drivers/net/usb/cdc_mbim.c
+++ b/drivers/net/usb/cdc_mbim.c
@@ -168,6 +168,7 @@ static int cdc_mbim_bind(struct usbnet *dev, struct usb_interface *intf)
 		subdriver = usb_cdc_wdm_register(ctx->control,
 						 &dev->status->desc,
 						 le16_to_cpu(ctx->mbim_desc->wMaxControlMessage),
+						 WWAN_PORT_MBIM,
 						 cdc_mbim_wdm_manage_power);
 	if (IS_ERR(subdriver)) {
 		ret = PTR_ERR(subdriver);
diff --git a/drivers/net/usb/huawei_cdc_ncm.c b/drivers/net/usb/huawei_cdc_ncm.c
index a87f0da..849b773 100644
--- a/drivers/net/usb/huawei_cdc_ncm.c
+++ b/drivers/net/usb/huawei_cdc_ncm.c
@@ -96,6 +96,7 @@ static int huawei_cdc_ncm_bind(struct usbnet *usbnet_dev,
 		subdriver = usb_cdc_wdm_register(ctx->control,
 						 &usbnet_dev->status->desc,
 						 1024, /* wMaxCommand */
+						 WWAN_PORT_AT,
 						 huawei_cdc_ncm_wdm_manage_power);
 	if (IS_ERR(subdriver)) {
 		ret = PTR_ERR(subdriver);
diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 17a0505..11c898f 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -724,7 +724,8 @@ static int qmi_wwan_register_subdriver(struct usbnet *dev)
 
 	/* register subdriver */
 	subdriver = usb_cdc_wdm_register(info->control, &dev->status->desc,
-					 4096, &qmi_wwan_cdc_wdm_manage_power);
+					 4096, WWAN_PORT_QMI,
+					 &qmi_wwan_cdc_wdm_manage_power);
 	if (IS_ERR(subdriver)) {
 		dev_err(&info->control->dev, "subdriver registration failed\n");
 		rv = PTR_ERR(subdriver);
diff --git a/drivers/usb/class/cdc-wdm.c b/drivers/usb/class/cdc-wdm.c
index 508b1c3..457b00c 100644
--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -21,8 +21,10 @@
 #include <linux/uaccess.h>
 #include <linux/bitops.h>
 #include <linux/poll.h>
+#include <linux/skbuff.h>
 #include <linux/usb.h>
 #include <linux/usb/cdc.h>
+#include <linux/wwan.h>
 #include <asm/byteorder.h>
 #include <asm/unaligned.h>
 #include <linux/usb/cdc-wdm.h>
@@ -55,6 +57,7 @@ MODULE_DEVICE_TABLE (usb, wdm_ids);
 #define WDM_SUSPENDING		8
 #define WDM_RESETTING		9
 #define WDM_OVERFLOW		10
+#define WDM_WWAN_IN_USE		11
 
 #define WDM_MAX			16
 
@@ -106,6 +109,9 @@ struct wdm_device {
 
 	struct list_head	device_list;
 	int			(*manage_power)(struct usb_interface *, int);
+
+	enum wwan_port_type	wwanp_type;
+	struct wwan_port	*wwanp;
 };
 
 static struct usb_driver wdm_driver;
@@ -157,6 +163,8 @@ static void wdm_out_callback(struct urb *urb)
 	wake_up_all(&desc->wait);
 }
 
+static void wdm_wwan_rx(struct wdm_device *desc, int length);
+
 static void wdm_in_callback(struct urb *urb)
 {
 	unsigned long flags;
@@ -192,6 +200,11 @@ static void wdm_in_callback(struct urb *urb)
 		}
 	}
 
+	if (test_bit(WDM_WWAN_IN_USE, &desc->flags)) {
+		wdm_wwan_rx(desc, length);
+		goto out;
+	}
+
 	/*
 	 * only set a new error if there is no previous error.
 	 * Errors are only cleared during read/open
@@ -226,6 +239,7 @@ static void wdm_in_callback(struct urb *urb)
 		set_bit(WDM_READ, &desc->flags);
 		wake_up(&desc->wait);
 	}
+out:
 	spin_unlock_irqrestore(&desc->iuspin, flags);
 }
 
@@ -697,6 +711,11 @@ static int wdm_open(struct inode *inode, struct file *file)
 		goto out;
 	file->private_data = desc;
 
+	if (test_bit(WDM_WWAN_IN_USE, &desc->flags)) {
+		rv = -EBUSY;
+		goto out;
+	}
+
 	rv = usb_autopm_get_interface(desc->intf);
 	if (rv < 0) {
 		dev_err(&desc->intf->dev, "Error autopm - %d\n", rv);
@@ -792,6 +811,151 @@ static struct usb_class_driver wdm_class = {
 	.minor_base =	WDM_MINOR_BASE,
 };
 
+/* --- WWAN framework integration --- */
+#ifdef CONFIG_WWAN
+static int wdm_wwan_port_start(struct wwan_port *port)
+{
+	struct wdm_device *desc = wwan_port_get_drvdata(port);
+
+	/* The interface is both exposed via the WWAN framework and as a
+	 * legacy usbmisc chardev. If chardev is already open, just fail
+	 * to prevent concurrent usage. Otherwise, switch to WWAN mode.
+	 */
+	mutex_lock(&wdm_mutex);
+	if (desc->count) {
+		mutex_unlock(&wdm_mutex);
+		return -EBUSY;
+	}
+	set_bit(WDM_WWAN_IN_USE, &desc->flags);
+	mutex_unlock(&wdm_mutex);
+
+	desc->manage_power(desc->intf, 1);
+
+	/* tx is allowed */
+	wwan_port_txon(port);
+
+	/* Start getting events */
+	return usb_submit_urb(desc->validity, GFP_KERNEL);
+}
+
+static void wdm_wwan_port_stop(struct wwan_port *port)
+{
+	struct wdm_device *desc = wwan_port_get_drvdata(port);
+
+	/* Stop all transfers and disable WWAN mode */
+	kill_urbs(desc);
+	desc->manage_power(desc->intf, 0);
+	clear_bit(WDM_READ, &desc->flags);
+	clear_bit(WDM_WWAN_IN_USE, &desc->flags);
+}
+
+static void wdm_wwan_port_tx_complete(struct urb *urb)
+{
+	struct sk_buff *skb = urb->context;
+	struct wdm_device *desc = skb_shinfo(skb)->destructor_arg;
+
+	usb_autopm_put_interface(desc->intf);
+	wwan_port_txon(desc->wwanp);
+	kfree_skb(skb);
+}
+
+static int wdm_wwan_port_tx(struct wwan_port *port, struct sk_buff *skb)
+{
+	struct wdm_device *desc = wwan_port_get_drvdata(port);
+	struct usb_interface *intf = desc->intf;
+	struct usb_ctrlrequest *req = desc->orq;
+	int rv;
+
+	rv = usb_autopm_get_interface(intf);
+	if (rv)
+		return rv;
+
+	usb_fill_control_urb(
+		desc->command,
+		interface_to_usbdev(intf),
+		usb_sndctrlpipe(interface_to_usbdev(intf), 0),
+		(unsigned char *)req,
+		skb->data,
+		skb->len,
+		wdm_wwan_port_tx_complete,
+		skb
+	);
+
+	req->bRequestType = (USB_DIR_OUT | USB_TYPE_CLASS | USB_RECIP_INTERFACE);
+	req->bRequest = USB_CDC_SEND_ENCAPSULATED_COMMAND;
+	req->wValue = 0;
+	req->wIndex = desc->inum;
+	req->wLength = cpu_to_le16(skb->len);
+
+	skb_shinfo(skb)->destructor_arg = desc;
+
+	rv = usb_submit_urb(desc->command, GFP_KERNEL);
+	if (rv)
+		usb_autopm_put_interface(intf);
+	else /* One transfer at a time, stop TX until URB completion */
+		wwan_port_txoff(port);
+
+	return rv;
+}
+
+static struct wwan_port_ops wdm_wwan_port_ops = {
+	.start = wdm_wwan_port_start,
+	.stop = wdm_wwan_port_stop,
+	.tx = wdm_wwan_port_tx,
+};
+
+static void wdm_wwan_init(struct wdm_device *desc)
+{
+	struct usb_interface *intf = desc->intf;
+	struct wwan_port *port;
+
+	/* Only register to WWAN core if protocol/type is known */
+	if (desc->wwanp_type == WWAN_PORT_UNKNOWN) {
+		dev_info(&intf->dev, "Unknown control protocol\n");
+		return;
+	}
+
+	port = wwan_create_port(&intf->dev, desc->wwanp_type, &wdm_wwan_port_ops, desc);
+	if (IS_ERR(port)) {
+		dev_err(&intf->dev, "%s: Unable to create WWAN port\n",
+			dev_name(intf->usb_dev));
+		return;
+	}
+
+	desc->wwanp = port;
+}
+
+static void wdm_wwan_deinit(struct wdm_device *desc)
+{
+	if (!desc->wwanp)
+		return;
+
+	wwan_remove_port(desc->wwanp);
+	desc->wwanp = NULL;
+}
+
+static void wdm_wwan_rx(struct wdm_device *desc, int length)
+{
+	struct wwan_port *port = desc->wwanp;
+	struct sk_buff *skb;
+
+	/* Forward data to WWAN port */
+	skb = alloc_skb(length, GFP_ATOMIC);
+	if (!skb)
+		return;
+
+	memcpy(skb_put(skb, length), desc->inbuf, length);
+	wwan_port_rx(port, skb);
+
+	/* inbuf has been copied, it is safe to check for outstanding data */
+	schedule_work(&desc->service_outs_intr);
+}
+#else /* CONFIG_WWAN */
+static void wdm_wwan_init(struct wdm_device *desc) {}
+static void wdm_wwan_deinit(struct wdm_device *desc) {}
+static void wdm_wwan_rx(struct wdm_device *desc, int length) {}
+#endif /* CONFIG_WWAN */
+
 /* --- error handling --- */
 static void wdm_rxwork(struct work_struct *work)
 {
@@ -836,7 +1000,8 @@ static void service_interrupt_work(struct work_struct *work)
 /* --- hotplug --- */
 
 static int wdm_create(struct usb_interface *intf, struct usb_endpoint_descriptor *ep,
-		u16 bufsize, int (*manage_power)(struct usb_interface *, int))
+		      u16 bufsize, enum wwan_port_type type,
+		      int (*manage_power)(struct usb_interface *, int))
 {
 	int rv = -ENOMEM;
 	struct wdm_device *desc;
@@ -853,6 +1018,7 @@ static int wdm_create(struct usb_interface *intf, struct usb_endpoint_descriptor
 	/* this will be expanded and needed in hardware endianness */
 	desc->inum = cpu_to_le16((u16)intf->cur_altsetting->desc.bInterfaceNumber);
 	desc->intf = intf;
+	desc->wwanp_type = type;
 	INIT_WORK(&desc->rxwork, wdm_rxwork);
 	INIT_WORK(&desc->service_outs_intr, service_interrupt_work);
 
@@ -933,6 +1099,9 @@ static int wdm_create(struct usb_interface *intf, struct usb_endpoint_descriptor
 		goto err;
 	else
 		dev_info(&intf->dev, "%s: USB WDM device\n", dev_name(intf->usb_dev));
+
+	wdm_wwan_init(desc);
+
 out:
 	return rv;
 err:
@@ -977,7 +1146,7 @@ static int wdm_probe(struct usb_interface *intf, const struct usb_device_id *id)
 		goto err;
 	ep = &iface->endpoint[0].desc;
 
-	rv = wdm_create(intf, ep, maxcom, &wdm_manage_power);
+	rv = wdm_create(intf, ep, maxcom, WWAN_PORT_UNKNOWN, &wdm_manage_power);
 
 err:
 	return rv;
@@ -988,6 +1157,7 @@ static int wdm_probe(struct usb_interface *intf, const struct usb_device_id *id)
  * @intf: usb interface the subdriver will associate with
  * @ep: interrupt endpoint to monitor for notifications
  * @bufsize: maximum message size to support for read/write
+ * @type: Type/protocol of the transported data (MBIM, QMI...)
  * @manage_power: call-back invoked during open and release to
  *                manage the device's power
  * Create WDM usb class character device and associate it with intf
@@ -1005,12 +1175,12 @@ static int wdm_probe(struct usb_interface *intf, const struct usb_device_id *id)
  */
 struct usb_driver *usb_cdc_wdm_register(struct usb_interface *intf,
 					struct usb_endpoint_descriptor *ep,
-					int bufsize,
+					int bufsize, enum wwan_port_type type,
 					int (*manage_power)(struct usb_interface *, int))
 {
 	int rv;
 
-	rv = wdm_create(intf, ep, bufsize, manage_power);
+	rv = wdm_create(intf, ep, bufsize, type, manage_power);
 	if (rv < 0)
 		goto err;
 
@@ -1029,6 +1199,8 @@ static void wdm_disconnect(struct usb_interface *intf)
 	desc = wdm_find_device(intf);
 	mutex_lock(&wdm_mutex);
 
+	wdm_wwan_deinit(desc);
+
 	/* the spinlock makes sure no new urbs are generated in the callbacks */
 	spin_lock_irqsave(&desc->iuspin, flags);
 	set_bit(WDM_DISCONNECTING, &desc->flags);
diff --git a/include/linux/usb/cdc-wdm.h b/include/linux/usb/cdc-wdm.h
index 9b895f9..9f5a51f 100644
--- a/include/linux/usb/cdc-wdm.h
+++ b/include/linux/usb/cdc-wdm.h
@@ -12,11 +12,12 @@
 #ifndef __LINUX_USB_CDC_WDM_H
 #define __LINUX_USB_CDC_WDM_H
 
+#include <linux/wwan.h>
 #include <uapi/linux/usb/cdc-wdm.h>
 
 extern struct usb_driver *usb_cdc_wdm_register(struct usb_interface *intf,
 					struct usb_endpoint_descriptor *ep,
-					int bufsize,
+					int bufsize, enum wwan_port_type type,
 					int (*manage_power)(struct usb_interface *, int));
 
 #endif /* __LINUX_USB_CDC_WDM_H */
-- 
2.7.4

