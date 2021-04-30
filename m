Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C0FD36F84C
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 12:07:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbhD3KIE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 06:08:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbhD3KID (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Apr 2021 06:08:03 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 542B8C06174A
        for <netdev@vger.kernel.org>; Fri, 30 Apr 2021 03:07:15 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id x5so19631241wrv.13
        for <netdev@vger.kernel.org>; Fri, 30 Apr 2021 03:07:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=PDnfVuA/JjrNJVnGCOpMCSMgyBp4BBB6tbf0UxNJ/kE=;
        b=LoTVZ8D7BEz3yq3hBHaLdUYIjRe2HkhxmZZQtVf+Ljobzl3EEYoWXht3ninBE0plDI
         VlYk2FX/dDzdVy7mbHRueAA0xXYIQYHtmdZxe1Ljr7YhZfWJQqAIclUwmMECDN8v0uei
         iItyCxk5saOW0GvKFl77pYGDEIVtKDCyHVCGHPKR2OrCYfFUz61i0nGJ8MeHI8hVqVO0
         dNeNVPUODgbXmGVIEWfvLDDSs891AlteEMQpWYSlgE0nZ10kz3yHlhz21EJobpFJGFHh
         lf3Afffy22hXGxFHxoXpOwCEU/3P/KE7BotnAy14t9w9+vZH0a8Zo5CicY7Cd5c2Dc1e
         vCuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=PDnfVuA/JjrNJVnGCOpMCSMgyBp4BBB6tbf0UxNJ/kE=;
        b=bKLBpPDFJbV9T6m6A1u9t+/YxSA8ERcLp4Bpw7jd+XBiB37caPMgHBvA8+Mn8ca6qc
         lU3KpEeebSJyyD+RRPZKh+BEddisHQoqfi8uGhyBCQbFvxgkj9ldWAGy1ZCHX/XN4D8a
         E47v++f4kE+ssV5Q7kGzIWtbmJnt0ddmhIHydfIemBUQpUCvXZv4cn0LqyYmGZKMMfrt
         tSYHrreXQQFmRShye45s+RcMbGwXBphazVkH3rSTym2/ImbbufacIH93Uz0Bblr8fgD5
         A5QlQ+9gN7k4SWJ28GrjdMrDeK2qVsKJ60UbjvPFd8I4OzYOwJ6deLOY8fulMp1cFQ6n
         tXJQ==
X-Gm-Message-State: AOAM530mNrsrRvJwauhXEcVnXOwHBvc5t3GW1kaqR3rybhf2HJu4ENkJ
        G3IYcZp6C2MTTxMbAHL3l7pvchIHIP2ttRRn
X-Google-Smtp-Source: ABdhPJxTdVoNcnHiBB1W/YXmHOtVq0J77k7fIQNm7fMRvBR1p4eVCejkZpOK9DNhdNO6ivtt54NIfg==
X-Received: by 2002:a5d:674c:: with SMTP id l12mr5619361wrw.357.1619777233992;
        Fri, 30 Apr 2021 03:07:13 -0700 (PDT)
Received: from localhost.localdomain ([2a01:e0a:82c:5f0:f8f5:7ac7:d0f:4a85])
        by smtp.gmail.com with ESMTPSA id a15sm2192069wrx.9.2021.04.30.03.07.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 30 Apr 2021 03:07:13 -0700 (PDT)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     oliver@neukum.org
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org, kuba@kernel.org,
        bjorn@mork.no, Loic Poulain <loic.poulain@linaro.org>
Subject: [RFC net-next 2/2] usb: class: cdc-wdm: WWAN framework integration
Date:   Fri, 30 Apr 2021 12:16:23 +0200
Message-Id: <1619777783-24116-2-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1619777783-24116-1-git-send-email-loic.poulain@linaro.org>
References: <1619777783-24116-1-git-send-email-loic.poulain@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The WWAN framework provides a unified way to handle WWAN/modems and
control port(s). It has initially been introduced to support MHI/PCI
modems, offering the same control protocols as the USB variants,
such as MBIM, QMI, AT... The WWAN framework exposes these control
protocols as character devices, similarly to cdc-wdm, but in a
bus agnostic fashion.

It would then make sense to migrate cdc-wdm to this unified framework
and register the USB modem control endpoints as standard WWAN control
ports.

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
 drivers/usb/class/cdc-wdm.c | 171 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 170 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/class/cdc-wdm.c b/drivers/usb/class/cdc-wdm.c
index b59f146..7b798b5 100644
--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -23,6 +23,7 @@
 #include <linux/poll.h>
 #include <linux/usb.h>
 #include <linux/usb/cdc.h>
+#include <linux/wwan.h>
 #include <asm/byteorder.h>
 #include <asm/unaligned.h>
 #include <linux/usb/cdc-wdm.h>
@@ -55,6 +56,7 @@ MODULE_DEVICE_TABLE (usb, wdm_ids);
 #define WDM_SUSPENDING		8
 #define WDM_RESETTING		9
 #define WDM_OVERFLOW		10
+#define WDM_WWAN_IN_USE		11
 
 #define WDM_MAX			16
 
@@ -108,6 +110,7 @@ struct wdm_device {
 	int			(*manage_power)(struct usb_interface *, int);
 
 	enum usb_cdc_wdm_type	type;
+	struct wwan_port	*wwanp;
 };
 
 static struct usb_driver wdm_driver;
@@ -203,7 +206,23 @@ static void wdm_in_callback(struct urb *urb)
 	if (desc->rerr == 0 && status != -EPIPE)
 		desc->rerr = status;
 
-	if (length + desc->length > desc->wMaxCommand) {
+	if (test_bit(WDM_WWAN_IN_USE, &desc->flags)) {
+		struct wwan_port *port = desc->wwanp;
+		struct sk_buff *skb;
+
+		/* Forward data to WWAN port */
+		skb = alloc_skb(length, GFP_ATOMIC);
+		if (skb) {
+			memcpy(skb_put(skb, length), desc->inbuf, length);
+			wwan_port_rx(port, skb);
+		} else {
+			dev_err(&desc->intf->dev,
+				"Unable to alloc skb, response discarded\n");
+		}
+
+		/* inbuf has been copied, it is safe to check for outstanding data */
+		schedule_work(&desc->service_outs_intr);
+	} else if (length + desc->length > desc->wMaxCommand) {
 		/* The buffer would overflow */
 		set_bit(WDM_OVERFLOW, &desc->flags);
 	} else {
@@ -699,6 +718,11 @@ static int wdm_open(struct inode *inode, struct file *file)
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
@@ -794,6 +818,146 @@ static struct usb_class_driver wdm_class = {
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
+	/* Start getting events */
+	usb_submit_urb(desc->validity, GFP_KERNEL);
+
+	/* tx is allowed */
+	wwan_port_txon(port);
+
+	return 0;
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
+	struct wwan_port *port = skb_shinfo(skb)->destructor_arg;
+
+	/* Allow new command transfer */
+	wwan_port_txon(port);
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
+	skb_shinfo(skb)->destructor_arg = port;
+
+	rv = usb_submit_urb(desc->command, GFP_KERNEL);
+	if (!rv) /* One transfer at a time, stop TX until URB completion */
+		wwan_port_txoff(port);
+
+	usb_autopm_put_interface(intf);
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
+	switch (desc->type) {
+	case USB_CDC_WDM_MBIM:
+		port = wwan_create_port(&intf->dev, WWAN_PORT_MBIM,
+					&wdm_wwan_port_ops, desc);
+		break;
+	case USB_CDC_WDM_QMI:
+		port = wwan_create_port(&intf->dev, WWAN_PORT_QMI,
+					&wdm_wwan_port_ops, desc);
+		break;
+	case USB_CDC_WDM_AT:
+		port = wwan_create_port(&intf->dev, WWAN_PORT_AT,
+					&wdm_wwan_port_ops, desc);
+		break;
+	default:
+		dev_info(&intf->dev, "Unknown control protocol\n");
+		return;
+	}
+
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
+#else /* CONFIG_WWAN */
+static void wdm_wwan_init(struct wdm_device *desc) {}
+static void wdm_wwan_deinit(struct wdm_device *desc) {}
+#endif /* CONFIG_WWAN */
+
 /* --- error handling --- */
 static void wdm_rxwork(struct work_struct *work)
 {
@@ -937,6 +1101,9 @@ static int wdm_create(struct usb_interface *intf, struct usb_endpoint_descriptor
 		goto err;
 	else
 		dev_info(&intf->dev, "%s: USB WDM device\n", dev_name(intf->usb_dev));
+
+	wdm_wwan_init(desc);
+
 out:
 	return rv;
 err:
@@ -1034,6 +1201,8 @@ static void wdm_disconnect(struct usb_interface *intf)
 	desc = wdm_find_device(intf);
 	mutex_lock(&wdm_mutex);
 
+	wdm_wwan_deinit(desc);
+
 	/* the spinlock makes sure no new urbs are generated in the callbacks */
 	spin_lock_irqsave(&desc->iuspin, flags);
 	set_bit(WDM_DISCONNECTING, &desc->flags);
-- 
2.7.4

