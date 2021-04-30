Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CAAC36F84A
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 12:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229559AbhD3KIC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 06:08:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbhD3KIB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Apr 2021 06:08:01 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A6E7C06174A
        for <netdev@vger.kernel.org>; Fri, 30 Apr 2021 03:07:13 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id i21-20020a05600c3555b029012eae2af5d4so1387414wmq.4
        for <netdev@vger.kernel.org>; Fri, 30 Apr 2021 03:07:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=wAAGefM9sm57xiN8JQJSPXwevk+dd6E4rB1SsM48CbU=;
        b=Llp3Dr743bzV60MTDHCrO3FxpemA4WuzUbDP+bvDBtekrEk5qOnHD2iBnyVRdA1V33
         ENaPaiDhf63nPz3+zSXhwxXQeJd+tlN1CJ9gg98ucDHuWWoDqc7LhP6+TBg20U2b3pNG
         25dLavMX1/FeWqvCqol6GS8HH5rqv4qv6H2R3Fjnhg9xo0IIA23pohHF8TyAm97FwED3
         Gu9/m828PIRwe3jfASUwXayMoTIQ9nNgP813lOFK/Xoo4HSXdIqBzHje4OUvQjo/Ux3t
         rmQJO42RloFFA/bHJJTlYeT0BDeskx0pC4ksgRF5oR2MHn/m4q+ydpGK8gDnhZhr/J+i
         NBbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=wAAGefM9sm57xiN8JQJSPXwevk+dd6E4rB1SsM48CbU=;
        b=hRWg+6mWYj1Qboi+jxC1ipN+1Z+ID+9uOlwpHaIG5UZ+or56icKPv8PPYSpijOcBDH
         jN2bbvcRrdfBvFNdOTvY971JesKRi0idv6ISGROG7DMMG7Ait3etuepB2/b4hkFBzA9P
         yg0nJKnd8uQhW4IT79xSCynNy+/VITC9jc96Q+y3TLScrLbHIGF1zfgPCVeF4LrxZeuE
         BSpAygX6qq9WmLAnHTq/PriRRcOWyd5Yn62E/4WQNNlTZLDhEY7pDfMxjg0fm7pD23f4
         eoBuJ8cwD/Vg1zqwlVvDF/JTP+rksvEOiR9QE6i5aJwUhnbbwGCeI+8ihFcBMqbgd7+j
         1I4w==
X-Gm-Message-State: AOAM531WFEr4xn6wJXz6v2U1M7zF0rS/MxAUizL1c1DTeAV1mgHatQzr
        wKIiFX9CzaXCsFtI8t0E6O2v+g==
X-Google-Smtp-Source: ABdhPJxw86oLMz/XYV0lthPwKxtBCHZ9hTpK4WiXhlfrjF5G+/0OnGaJyDhZgpZS7xqcitNHj/2DVg==
X-Received: by 2002:a1c:540b:: with SMTP id i11mr15822473wmb.40.1619777231980;
        Fri, 30 Apr 2021 03:07:11 -0700 (PDT)
Received: from localhost.localdomain ([2a01:e0a:82c:5f0:f8f5:7ac7:d0f:4a85])
        by smtp.gmail.com with ESMTPSA id a15sm2192069wrx.9.2021.04.30.03.07.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 30 Apr 2021 03:07:11 -0700 (PDT)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     oliver@neukum.org
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org, kuba@kernel.org,
        bjorn@mork.no, Loic Poulain <loic.poulain@linaro.org>
Subject: [RFC net-next 1/2] usb: class: cdc-wdm: add control type
Date:   Fri, 30 Apr 2021 12:16:22 +0200
Message-Id: <1619777783-24116-1-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add type parameter to usb_cdc_wdm_register function in order to
specify which control protocol the cdc-wdm channel is transporting.
It will be required for exposing the channel(s) through WWAN framework.

Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
---
 drivers/net/usb/cdc_mbim.c       |  1 +
 drivers/net/usb/huawei_cdc_ncm.c |  1 +
 drivers/net/usb/qmi_wwan.c       |  3 ++-
 drivers/usb/class/cdc-wdm.c      | 13 +++++++++----
 include/linux/usb/cdc-wdm.h      | 16 +++++++++++++++-
 5 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/drivers/net/usb/cdc_mbim.c b/drivers/net/usb/cdc_mbim.c
index 5db6627..63b134b 100644
--- a/drivers/net/usb/cdc_mbim.c
+++ b/drivers/net/usb/cdc_mbim.c
@@ -168,6 +168,7 @@ static int cdc_mbim_bind(struct usbnet *dev, struct usb_interface *intf)
 		subdriver = usb_cdc_wdm_register(ctx->control,
 						 &dev->status->desc,
 						 le16_to_cpu(ctx->mbim_desc->wMaxControlMessage),
+						 USB_CDC_WDM_MBIM,
 						 cdc_mbim_wdm_manage_power);
 	if (IS_ERR(subdriver)) {
 		ret = PTR_ERR(subdriver);
diff --git a/drivers/net/usb/huawei_cdc_ncm.c b/drivers/net/usb/huawei_cdc_ncm.c
index a87f0da..388a46b 100644
--- a/drivers/net/usb/huawei_cdc_ncm.c
+++ b/drivers/net/usb/huawei_cdc_ncm.c
@@ -96,6 +96,7 @@ static int huawei_cdc_ncm_bind(struct usbnet *usbnet_dev,
 		subdriver = usb_cdc_wdm_register(ctx->control,
 						 &usbnet_dev->status->desc,
 						 1024, /* wMaxCommand */
+						 USB_CDC_WDM_AT,
 						 huawei_cdc_ncm_wdm_manage_power);
 	if (IS_ERR(subdriver)) {
 		ret = PTR_ERR(subdriver);
diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 17a0505..fa38471 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -724,7 +724,8 @@ static int qmi_wwan_register_subdriver(struct usbnet *dev)
 
 	/* register subdriver */
 	subdriver = usb_cdc_wdm_register(info->control, &dev->status->desc,
-					 4096, &qmi_wwan_cdc_wdm_manage_power);
+					 4096, USB_CDC_WDM_QMI,
+					 &qmi_wwan_cdc_wdm_manage_power);
 	if (IS_ERR(subdriver)) {
 		dev_err(&info->control->dev, "subdriver registration failed\n");
 		rv = PTR_ERR(subdriver);
diff --git a/drivers/usb/class/cdc-wdm.c b/drivers/usb/class/cdc-wdm.c
index 508b1c3..b59f146 100644
--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -106,6 +106,8 @@ struct wdm_device {
 
 	struct list_head	device_list;
 	int			(*manage_power)(struct usb_interface *, int);
+
+	enum usb_cdc_wdm_type	type;
 };
 
 static struct usb_driver wdm_driver;
@@ -836,7 +838,8 @@ static void service_interrupt_work(struct work_struct *work)
 /* --- hotplug --- */
 
 static int wdm_create(struct usb_interface *intf, struct usb_endpoint_descriptor *ep,
-		u16 bufsize, int (*manage_power)(struct usb_interface *, int))
+		      u16 bufsize, enum usb_cdc_wdm_type type,
+		      int (*manage_power)(struct usb_interface *, int))
 {
 	int rv = -ENOMEM;
 	struct wdm_device *desc;
@@ -853,6 +856,7 @@ static int wdm_create(struct usb_interface *intf, struct usb_endpoint_descriptor
 	/* this will be expanded and needed in hardware endianness */
 	desc->inum = cpu_to_le16((u16)intf->cur_altsetting->desc.bInterfaceNumber);
 	desc->intf = intf;
+	desc->type = type;
 	INIT_WORK(&desc->rxwork, wdm_rxwork);
 	INIT_WORK(&desc->service_outs_intr, service_interrupt_work);
 
@@ -977,7 +981,7 @@ static int wdm_probe(struct usb_interface *intf, const struct usb_device_id *id)
 		goto err;
 	ep = &iface->endpoint[0].desc;
 
-	rv = wdm_create(intf, ep, maxcom, &wdm_manage_power);
+	rv = wdm_create(intf, ep, maxcom, USB_CDC_WDM_UNKNOWN, &wdm_manage_power);
 
 err:
 	return rv;
@@ -988,6 +992,7 @@ static int wdm_probe(struct usb_interface *intf, const struct usb_device_id *id)
  * @intf: usb interface the subdriver will associate with
  * @ep: interrupt endpoint to monitor for notifications
  * @bufsize: maximum message size to support for read/write
+ * @type: Type/protocol of the transported data (MBIM, QMI...)
  * @manage_power: call-back invoked during open and release to
  *                manage the device's power
  * Create WDM usb class character device and associate it with intf
@@ -1005,12 +1010,12 @@ static int wdm_probe(struct usb_interface *intf, const struct usb_device_id *id)
  */
 struct usb_driver *usb_cdc_wdm_register(struct usb_interface *intf,
 					struct usb_endpoint_descriptor *ep,
-					int bufsize,
+					int bufsize, enum usb_cdc_wdm_type type,
 					int (*manage_power)(struct usb_interface *, int))
 {
 	int rv;
 
-	rv = wdm_create(intf, ep, bufsize, manage_power);
+	rv = wdm_create(intf, ep, bufsize, type, manage_power);
 	if (rv < 0)
 		goto err;
 
diff --git a/include/linux/usb/cdc-wdm.h b/include/linux/usb/cdc-wdm.h
index 9b895f9..ba9702d 100644
--- a/include/linux/usb/cdc-wdm.h
+++ b/include/linux/usb/cdc-wdm.h
@@ -14,9 +14,23 @@
 
 #include <uapi/linux/usb/cdc-wdm.h>
 
+/**
+ * enum usb_cdc_wdm_type - CDC WDM endpoint type
+ * @USB_CDC_WDM_UNKNOWN: Unknown type
+ * @USB_CDC_WDM_MBIM: Mobile Broadband Interface Model control
+ * @USB_CDC_WDM_QMI: Qualcomm Modem Interface for modem control
+ * @USB_CDC_WDM_AT: AT commands interface
+ */
+enum usb_cdc_wdm_type {
+	USB_CDC_WDM_UNKNOWN,
+	USB_CDC_WDM_MBIM,
+	USB_CDC_WDM_QMI,
+	USB_CDC_WDM_AT
+};
+
 extern struct usb_driver *usb_cdc_wdm_register(struct usb_interface *intf,
 					struct usb_endpoint_descriptor *ep,
-					int bufsize,
+					int bufsize, enum usb_cdc_wdm_type type,
 					int (*manage_power)(struct usb_interface *, int));
 
 #endif /* __LINUX_USB_CDC_WDM_H */
-- 
2.7.4

