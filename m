Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62620646A2F
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 09:12:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbiLHIMF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 03:12:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbiLHIMB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 03:12:01 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CABA05654F;
        Thu,  8 Dec 2022 00:12:00 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id jn7so797190plb.13;
        Thu, 08 Dec 2022 00:12:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0GbBuAv7YkpRPrYej1n/dTHTQXaEfO/DfSmjGAaefU4=;
        b=TzzNFzXhmb+jTb3KAIgvWhqVZneiIiWuEMcLzlPWqT0WtktgVQQcdHgTlyWu+L3L4/
         +p9GJ1jUpEW9UnxiKFlBvOCMkSB/0cEyxhECBjuofAcc0wPFmrHvlGNNqA2e4swjLEut
         iA6p5+HTaVtjBVUS+5H8jpmYlm4O6oMT0MpNlbDw2IaFaJ9NQ+A7HIo83J9+SKOt1Dfy
         ah6GpCO/NfOMyaSB+rJkOgaP49NfaExW5C9sStHQ3nimdViVktIBlFRzesqrg/PGyxCe
         KRWSNZKqGbJABNQQL8VHcKAx4AZ+9oKUO+RBLxbQhdTYbIKPvAWPhZo7wbag8sTxrvZH
         lbRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0GbBuAv7YkpRPrYej1n/dTHTQXaEfO/DfSmjGAaefU4=;
        b=c/PPcSdkyYO7SjAiAUqIQl8DVGc6k6pt9rKWkHc/oZUYoaY7ilLd1G8+kzkRIwGPCq
         uBEmLbseSYIXf3c0KlecVZneQL6RUNBYDAOYDtAVj6B/yDLKMuaGfoqg3PDSCp6rGaLG
         He27VW/Q+W/z951L4ILV55/JFrJQdbQf7NmI/BzVTCHG1KziMTAYNGe8X88YThdEE3yM
         OdgMmhhi6UpSYrzDINwc14RzAxkCkYtzcoq9WPutDGWgqF6lJkjl9y9fJvuKwnRTyn3t
         lmbPcaznPQR3eICmw9N7zFyc63O/8OsVmZdr7wcv0lJDyJtZaELlyW9EGq2XkHLInBzA
         DDSw==
X-Gm-Message-State: ANoB5pk0oOVyhwwfN/8Gz8HQ9qd4wNMmUpNGaPfjUUvwTYjQRmUeGYZr
        CLBe647VF2lONTwmRPacnjg=
X-Google-Smtp-Source: AA0mqf4v+10yeuc5ZehzvAJqNEdeHWLFcCVk502K4ZANGUAFPLLWAQM9Z2JqVAZcjJkq30PbOhkuPg==
X-Received: by 2002:a17:902:ce07:b0:180:f32c:7501 with SMTP id k7-20020a170902ce0700b00180f32c7501mr2005292plg.0.1670487120063;
        Thu, 08 Dec 2022 00:12:00 -0800 (PST)
Received: from XH22050090-L.ad.ts.tri-ad.global ([103.175.111.222])
        by smtp.gmail.com with ESMTPSA id b12-20020a1709027e0c00b00188f07c9eedsm15735729plm.176.2022.12.08.00.11.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 00:11:59 -0800 (PST)
Sender: Vincent Mailhol <vincent.mailhol@gmail.com>
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org
Cc:     Martin Elshuber <martin.elshuber@theobroma-systems.com>,
        Jakob Unterwurzacher <jakob.unterwurzacher@theobroma-systems.com>,
        Maximilian Schneider <mws@schneidersoft.net>,
        Peter Fink <pfink@christ-es.de>,
        Jeroen Hofstee <jhofstee@victronenergy.com>,
        =?UTF-8?q?Christoph=20M=C3=B6hring?= <cmoehring@christ-es.de>,
        John Whittington <git@jbrengineering.co.uk>,
        Vasanth Sadhasivan <vasanth.sadhasivan@samsara.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH 2/2] can: gs_usb: remove gs_can::iface
Date:   Thu,  8 Dec 2022 17:11:42 +0900
Message-Id: <20221208081142.16936-3-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221208081142.16936-1-mailhol.vincent@wanadoo.fr>
References: <20221208081142.16936-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The iface field of struct gs_can is only used to retrieve the
usb_device which is already available in gs_can::udev.

Replace each occurrence of interface_to_usbdev(dev->iface) with
dev->udev. This done, remove gs_can::iface.

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
 drivers/net/can/usb/gs_usb.c | 29 +++++++++--------------------
 1 file changed, 9 insertions(+), 20 deletions(-)

diff --git a/drivers/net/can/usb/gs_usb.c b/drivers/net/can/usb/gs_usb.c
index 838744d2ce34..d476c2884008 100644
--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -299,7 +299,6 @@ struct gs_can {
 
 	struct net_device *netdev;
 	struct usb_device *udev;
-	struct usb_interface *iface;
 
 	struct can_bittiming_const bt_const, data_bt_const;
 	unsigned int channel;	/* channel number */
@@ -383,8 +382,7 @@ static int gs_cmd_reset(struct gs_can *dev)
 		.mode = GS_CAN_MODE_RESET,
 	};
 
-	return usb_control_msg_send(interface_to_usbdev(dev->iface), 0,
-				    GS_USB_BREQ_MODE,
+	return usb_control_msg_send(dev->udev, 0, GS_USB_BREQ_MODE,
 				    USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_INTERFACE,
 				    dev->channel, 0, &dm, sizeof(dm), 1000,
 				    GFP_KERNEL);
@@ -396,8 +394,7 @@ static inline int gs_usb_get_timestamp(const struct gs_can *dev,
 	__le32 timestamp;
 	int rc;
 
-	rc = usb_control_msg_recv(interface_to_usbdev(dev->iface), 0,
-				  GS_USB_BREQ_TIMESTAMP,
+	rc = usb_control_msg_recv(dev->udev, 0, GS_USB_BREQ_TIMESTAMP,
 				  USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_INTERFACE,
 				  dev->channel, 0,
 				  &timestamp, sizeof(timestamp),
@@ -674,8 +671,7 @@ static int gs_usb_set_bittiming(struct net_device *netdev)
 	};
 
 	/* request bit timings */
-	return usb_control_msg_send(interface_to_usbdev(dev->iface), 0,
-				    GS_USB_BREQ_BITTIMING,
+	return usb_control_msg_send(dev->udev, 0, GS_USB_BREQ_BITTIMING,
 				    USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_INTERFACE,
 				    dev->channel, 0, &dbt, sizeof(dbt), 1000,
 				    GFP_KERNEL);
@@ -698,8 +694,7 @@ static int gs_usb_set_data_bittiming(struct net_device *netdev)
 		request = GS_USB_BREQ_QUIRK_CANTACT_PRO_DATA_BITTIMING;
 
 	/* request data bit timings */
-	return usb_control_msg_send(interface_to_usbdev(dev->iface), 0,
-				    request,
+	return usb_control_msg_send(dev->udev, 0, request,
 				    USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_INTERFACE,
 				    dev->channel, 0, &dbt, sizeof(dbt), 1000,
 				    GFP_KERNEL);
@@ -941,8 +936,7 @@ static int gs_can_open(struct net_device *netdev)
 	/* finally start device */
 	dev->can.state = CAN_STATE_ERROR_ACTIVE;
 	dm.flags = cpu_to_le32(flags);
-	rc = usb_control_msg_send(interface_to_usbdev(dev->iface), 0,
-				  GS_USB_BREQ_MODE,
+	rc = usb_control_msg_send(dev->udev, 0, GS_USB_BREQ_MODE,
 				  USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_INTERFACE,
 				  dev->channel, 0, &dm, sizeof(dm), 1000,
 				  GFP_KERNEL);
@@ -969,8 +963,7 @@ static int gs_usb_get_state(const struct net_device *netdev,
 	struct gs_device_state ds;
 	int rc;
 
-	rc = usb_control_msg_recv(interface_to_usbdev(dev->iface), 0,
-				  GS_USB_BREQ_GET_STATE,
+	rc = usb_control_msg_recv(dev->udev, 0, GS_USB_BREQ_GET_STATE,
 				  USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_INTERFACE,
 				  dev->channel, 0,
 				  &ds, sizeof(ds),
@@ -1064,8 +1057,7 @@ static int gs_usb_set_identify(struct net_device *netdev, bool do_identify)
 	else
 		imode.mode = cpu_to_le32(GS_CAN_IDENTIFY_OFF);
 
-	return usb_control_msg_send(interface_to_usbdev(dev->iface), 0,
-				    GS_USB_BREQ_IDENTIFY,
+	return usb_control_msg_send(dev->udev, 0, GS_USB_BREQ_IDENTIFY,
 				    USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_INTERFACE,
 				    dev->channel, 0, &imode, sizeof(imode), 100,
 				    GFP_KERNEL);
@@ -1118,8 +1110,7 @@ static int gs_usb_get_termination(struct net_device *netdev, u16 *term)
 	struct gs_device_termination_state term_state;
 	int rc;
 
-	rc = usb_control_msg_recv(interface_to_usbdev(dev->iface), 0,
-				  GS_USB_BREQ_GET_TERMINATION,
+	rc = usb_control_msg_recv(dev->udev, 0, GS_USB_BREQ_GET_TERMINATION,
 				  USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_INTERFACE,
 				  dev->channel, 0,
 				  &term_state, sizeof(term_state), 1000,
@@ -1145,8 +1136,7 @@ static int gs_usb_set_termination(struct net_device *netdev, u16 term)
 	else
 		term_state.state = cpu_to_le32(GS_CAN_TERMINATION_STATE_OFF);
 
-	return usb_control_msg_send(interface_to_usbdev(dev->iface), 0,
-				    GS_USB_BREQ_SET_TERMINATION,
+	return usb_control_msg_send(dev->udev, 0, GS_USB_BREQ_SET_TERMINATION,
 				    USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_INTERFACE,
 				    dev->channel, 0,
 				    &term_state, sizeof(term_state), 1000,
@@ -1210,7 +1200,6 @@ static struct gs_can *gs_make_candev(unsigned int channel,
 	dev->bt_const.brp_inc = le32_to_cpu(bt_const.brp_inc);
 
 	dev->udev = interface_to_usbdev(intf);
-	dev->iface = intf;
 	dev->netdev = netdev;
 	dev->channel = channel;
 
-- 
2.25.1

