Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85151275400
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 11:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726704AbgIWJGz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 05:06:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbgIWJGz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 05:06:55 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BD74C0613CE;
        Wed, 23 Sep 2020 02:06:55 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id z18so14666709pfg.0;
        Wed, 23 Sep 2020 02:06:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=nCiWWFhPZHev6oEz8DjlpYK4lz9H8pn9x46uJm2Olsw=;
        b=MgLNdF2RgGy0Y7v89R1UC4S84n8EAycuEswaYSu7ys11XIGLnCTwJkdYnef+/EWOhd
         /+GVeEf22uDINRfdERiHGMYB1K9cob+LGc7P5L2mQ3vHYhBjGvxdCraFqL3QsVgaEX5Y
         GjM/RB9A/3VKzbT5O6Sk9mzQq7dRUggoiR+xaoNEtnSjftBJT7pJno+pzW6U5jQ5zSK3
         ufXxacUn3fLp7LtuiCdsO4MgpKX9DUXdwRgWf5UNwYs61XY+vmV5fmOlLWRoTTV/oHkQ
         pquXNlQstKZrAOQDbrDmbPtHBf7nU2JeM0cPG30QxBNWIOnK5MkXq7lqHQ8WB/V9ajc1
         wpbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=nCiWWFhPZHev6oEz8DjlpYK4lz9H8pn9x46uJm2Olsw=;
        b=EGczJgYdpt3p0OSfVn0QSPFZiMm97dpJcic9SDuE4nlG2NTyPNrao/0VxZFzBrSw4T
         iNQmWlI7/Q4YCmg4IhbvUWKnwv+g0++w0rGbnKl8nP0mUBQiUD0Q3eKT0lYN8eDyE0Jm
         0zeykyFDYmN+6uy+YT4xF9YXTZc4kgSli2tvYugTW4ZgkjVFsV2lXmoIBCu2rA/O9OOO
         lwBTUx5Z2IZ7j69Z+7zGDpzx2+oKzb30JtThE2E/ZEDFuTxH2FvhcBlVpCbkPncqVTpL
         0HF8iaYgD1FrqGByetp9AJm2kpfLQxs/PF/11yuU8wRrUb71JCot6J0/J4fAyWJZ71g1
         uBRw==
X-Gm-Message-State: AOAM530Q4I8ruBdRv7PNHR8WsVJNK6cOLlpvmPh9OfBJNUqEnbl1nj8O
        KHhdd+NnxB4ogb7vmL2srAY=
X-Google-Smtp-Source: ABdhPJyhgq8hJykGKP8WPG3DhPxvF42QE1aH6zDRXCfxkxSWkDChBSkLj4Om8/Pg4+SRnSpW7WE1CQ==
X-Received: by 2002:a62:e90b:0:b029:13e:b622:3241 with SMTP id j11-20020a62e90b0000b029013eb6223241mr7946741pfh.12.1600852014989;
        Wed, 23 Sep 2020 02:06:54 -0700 (PDT)
Received: from localhost.localdomain ([2405:205:c8e3:4b96:985a:95b9:e0cd:1d5e])
        by smtp.gmail.com with ESMTPSA id a13sm16496226pgq.41.2020.09.23.02.06.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2020 02:06:54 -0700 (PDT)
From:   Himadri Pandya <himadrispandya@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, oneukum@suse.com,
        pankaj.laxminarayan.bharadiya@intel.com, keescook@chromium.org,
        yuehaibing@huawei.com, petkan@nucleusys.com, ogiannou@gmail.com
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        gregkh@linuxfoundation.org,
        Himadri Pandya <himadrispandya@gmail.com>
Subject: [PATCH 4/4] net: rndis_host: use usb_control_msg_recv() and usb_control_msg_send()
Date:   Wed, 23 Sep 2020 14:35:19 +0530
Message-Id: <20200923090519.361-5-himadrispandya@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200923090519.361-1-himadrispandya@gmail.com>
References: <20200923090519.361-1-himadrispandya@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The new usb_control_msg_recv() and usb_control_msg_send() nicely wraps
usb_control_msg() with proper error check. Hence use the wrappers
instead of calling usb_control_msg() directly.

Signed-off-by: Himadri Pandya <himadrispandya@gmail.com>
---
 drivers/net/usb/rndis_host.c | 44 ++++++++++++++----------------------
 1 file changed, 17 insertions(+), 27 deletions(-)

diff --git a/drivers/net/usb/rndis_host.c b/drivers/net/usb/rndis_host.c
index 6fa7a009a24a..30fc4a7183d3 100644
--- a/drivers/net/usb/rndis_host.c
+++ b/drivers/net/usb/rndis_host.c
@@ -113,14 +113,13 @@ int rndis_command(struct usbnet *dev, struct rndis_msg_hdr *buf, int buflen)
 		buf->request_id = (__force __le32) xid;
 	}
 	master_ifnum = info->control->cur_altsetting->desc.bInterfaceNumber;
-	retval = usb_control_msg(dev->udev,
-		usb_sndctrlpipe(dev->udev, 0),
-		USB_CDC_SEND_ENCAPSULATED_COMMAND,
-		USB_TYPE_CLASS | USB_RECIP_INTERFACE,
-		0, master_ifnum,
-		buf, le32_to_cpu(buf->msg_len),
-		RNDIS_CONTROL_TIMEOUT_MS);
-	if (unlikely(retval < 0 || xid == 0))
+	retval = usb_control_msg_send(dev->udev, 0,
+				      USB_CDC_SEND_ENCAPSULATED_COMMAND,
+				      USB_TYPE_CLASS | USB_RECIP_INTERFACE,
+				      0, master_ifnum, buf,
+				      le32_to_cpu(buf->msg_len),
+				      RNDIS_CONTROL_TIMEOUT_MS);
+	if (unlikely(xid == 0))
 		return retval;
 
 	/* Some devices don't respond on the control channel until
@@ -139,14 +138,11 @@ int rndis_command(struct usbnet *dev, struct rndis_msg_hdr *buf, int buflen)
 	/* Poll the control channel; the request probably completed immediately */
 	rsp = le32_to_cpu(buf->msg_type) | RNDIS_MSG_COMPLETION;
 	for (count = 0; count < 10; count++) {
-		memset(buf, 0, CONTROL_BUFFER_SIZE);
-		retval = usb_control_msg(dev->udev,
-			usb_rcvctrlpipe(dev->udev, 0),
-			USB_CDC_GET_ENCAPSULATED_RESPONSE,
-			USB_DIR_IN | USB_TYPE_CLASS | USB_RECIP_INTERFACE,
-			0, master_ifnum,
-			buf, buflen,
-			RNDIS_CONTROL_TIMEOUT_MS);
+		retval = usb_control_msg_recv(dev->udev, 0,
+					      USB_CDC_GET_ENCAPSULATED_RESPONSE,
+					      USB_DIR_IN | USB_TYPE_CLASS | USB_RECIP_INTERFACE,
+					      0, master_ifnum, buf, buflen,
+					      RNDIS_CONTROL_TIMEOUT_MS);
 		if (likely(retval >= 8)) {
 			msg_type = le32_to_cpu(buf->msg_type);
 			msg_len = le32_to_cpu(buf->msg_len);
@@ -178,17 +174,11 @@ int rndis_command(struct usbnet *dev, struct rndis_msg_hdr *buf, int buflen)
 				msg->msg_type = cpu_to_le32(RNDIS_MSG_KEEPALIVE_C);
 				msg->msg_len = cpu_to_le32(sizeof *msg);
 				msg->status = cpu_to_le32(RNDIS_STATUS_SUCCESS);
-				retval = usb_control_msg(dev->udev,
-					usb_sndctrlpipe(dev->udev, 0),
-					USB_CDC_SEND_ENCAPSULATED_COMMAND,
-					USB_TYPE_CLASS | USB_RECIP_INTERFACE,
-					0, master_ifnum,
-					msg, sizeof *msg,
-					RNDIS_CONTROL_TIMEOUT_MS);
-				if (unlikely(retval < 0))
-					dev_dbg(&info->control->dev,
-						"rndis keepalive err %d\n",
-						retval);
+				retval = usb_control_msg_send(dev->udev, 0,
+							      USB_CDC_SEND_ENCAPSULATED_COMMAND,
+							      USB_TYPE_CLASS | USB_RECIP_INTERFACE,
+							      0, master_ifnum, msg, sizeof(*msg),
+							      RNDIS_CONTROL_TIMEOUT_MS);
 				}
 				break;
 			default:
-- 
2.17.1

