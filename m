Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F14003D0A88
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 10:32:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235743AbhGUHk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 03:40:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236340AbhGUHfH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 03:35:07 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7952C061768;
        Wed, 21 Jul 2021 01:15:26 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id bt15so1225336pjb.2;
        Wed, 21 Jul 2021 01:15:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MgjA2vJFskd6x2wpgCUFeYbkoYVrc9BhPET/CTsdEz4=;
        b=G87wvhCz3ULoGIXC9Dkx65FFoV4E0OsDqQUJuQrxOCl0j4LciOHTO5lLPQuJZZBFrG
         toPK9TBhH7mt3TR6uk+ZQi74kWJULeHOlJ93jSSBWgClYh7xVmSIIriS3TbdcBb6+ILS
         gguZFSre6pNvWlO+MelGWikWsEuxUCr/KXMgf7pSLut00S7SGnMXkz36aMCLDKROTzlV
         04OHE5KEV5i9QpYOgCifln7dP1XaHkFMzUsCi1cRYyOgCpGxAIeNDwD+UxRs2kABev5h
         xJ5cmJU17dbM5RxMGZYpn8l6C/J9B/8aTRfHQsZAtbZsjMOWixt3wFDDJjoyJBX6WMHn
         WIpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MgjA2vJFskd6x2wpgCUFeYbkoYVrc9BhPET/CTsdEz4=;
        b=GZdWRwHQkTTNY6uEaa1f/NS9HLk5WVb5RH3mzMhg6aw4t9JurKu9VCjhOoRjR0qcQB
         4m0zcmP9/LZ3NxiLpEntLQHaSca/OdVnm8I0T2ykwQ1Wf1K736l+hjQLhHlIpWc1eEiB
         72x5rv8Zwcl0chTiq7M6jIhRu0rOshRawuLoQd/s4lH8jZFuT0JTdJqgQ/xznYeUC1XN
         L2YvLSj7ES73DcaV3EYC2Yrnu9og/CYQKalIe5McPVeKKvDU3FJpNBrz67Xh2B0umZwx
         d+iAABGg70i11xZrUAyqGW+mAJcjjsDlakEKdfrLct/xWQdVFwIvSCd3cxPrf2XsP/LR
         Fzsw==
X-Gm-Message-State: AOAM5303B6dDmWmryJxAT8R+L8jFjmrFf05J8r8lYDbFoAT3FeoUebGa
        5Am2aiJurce1M81ZQthLjJM=
X-Google-Smtp-Source: ABdhPJyv7JbkERnfVNQ461Jz9CqrooFOBTKhncq6VlJ+g77pUdG+qBiJ7XBE4KXoxQefD5a24dNqsg==
X-Received: by 2002:a17:90a:7546:: with SMTP id q64mr2744117pjk.174.1626855326235;
        Wed, 21 Jul 2021 01:15:26 -0700 (PDT)
Received: from localhost.localdomain ([154.16.166.166])
        by smtp.gmail.com with ESMTPSA id g1sm28391398pgs.23.2021.07.21.01.15.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 01:15:25 -0700 (PDT)
From:   Dongliang Mu <mudongliangabcd@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Johan Hovold <johan@kernel.org>,
        Oliver Neukum <oneukum@suse.com>,
        Dongliang Mu <mudongliangabcd@gmail.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Anirudh Rayabharam <mail@anirudhrb.com>
Cc:     syzbot+44d53c7255bb1aea22d2@syzkaller.appspotmail.com,
        Rustam Kovhaev <rkovhaev@gmail.com>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RESEND PATCH V3 1/2] usb: hso: fix error handling code of hso_create_net_device
Date:   Wed, 21 Jul 2021 16:14:56 +0800
Message-Id: <20210721081510.1516058-1-mudongliangabcd@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current error handling code of hso_create_net_device is
hso_free_net_device, no matter which errors lead to. For example,
WARNING in hso_free_net_device [1].

Fix this by refactoring the error handling code of
hso_create_net_device by handling different errors by different code.

[1] https://syzkaller.appspot.com/bug?id=66eff8d49af1b28370ad342787413e35bbe76efe

Reported-by: syzbot+44d53c7255bb1aea22d2@syzkaller.appspotmail.com
Fixes: 5fcfb6d0bfcd ("hso: fix bailout in error case of probe")
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
---
v1->v2: change labels according to the comment of Dan Carpenter
v2->v3: change the style of error handling labels

 drivers/net/usb/hso.c | 33 +++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
index 63006838bdcc..dec96e8ab567 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -2495,7 +2495,7 @@ static struct hso_device *hso_create_net_device(struct usb_interface *interface,
 			   hso_net_init);
 	if (!net) {
 		dev_err(&interface->dev, "Unable to create ethernet device\n");
-		goto exit;
+		goto err_hso_dev;
 	}
 
 	hso_net = netdev_priv(net);
@@ -2508,13 +2508,13 @@ static struct hso_device *hso_create_net_device(struct usb_interface *interface,
 				      USB_DIR_IN);
 	if (!hso_net->in_endp) {
 		dev_err(&interface->dev, "Can't find BULK IN endpoint\n");
-		goto exit;
+		goto err_net;
 	}
 	hso_net->out_endp = hso_get_ep(interface, USB_ENDPOINT_XFER_BULK,
 				       USB_DIR_OUT);
 	if (!hso_net->out_endp) {
 		dev_err(&interface->dev, "Can't find BULK OUT endpoint\n");
-		goto exit;
+		goto err_net;
 	}
 	SET_NETDEV_DEV(net, &interface->dev);
 	SET_NETDEV_DEVTYPE(net, &hso_type);
@@ -2523,18 +2523,18 @@ static struct hso_device *hso_create_net_device(struct usb_interface *interface,
 	for (i = 0; i < MUX_BULK_RX_BUF_COUNT; i++) {
 		hso_net->mux_bulk_rx_urb_pool[i] = usb_alloc_urb(0, GFP_KERNEL);
 		if (!hso_net->mux_bulk_rx_urb_pool[i])
-			goto exit;
+			goto err_mux_bulk_rx;
 		hso_net->mux_bulk_rx_buf_pool[i] = kzalloc(MUX_BULK_RX_BUF_SIZE,
 							   GFP_KERNEL);
 		if (!hso_net->mux_bulk_rx_buf_pool[i])
-			goto exit;
+			goto err_mux_bulk_rx;
 	}
 	hso_net->mux_bulk_tx_urb = usb_alloc_urb(0, GFP_KERNEL);
 	if (!hso_net->mux_bulk_tx_urb)
-		goto exit;
+		goto err_mux_bulk_rx;
 	hso_net->mux_bulk_tx_buf = kzalloc(MUX_BULK_TX_BUF_SIZE, GFP_KERNEL);
 	if (!hso_net->mux_bulk_tx_buf)
-		goto exit;
+		goto err_free_tx_urb;
 
 	add_net_device(hso_dev);
 
@@ -2542,7 +2542,7 @@ static struct hso_device *hso_create_net_device(struct usb_interface *interface,
 	result = register_netdev(net);
 	if (result) {
 		dev_err(&interface->dev, "Failed to register device\n");
-		goto exit;
+		goto err_free_tx_buf;
 	}
 
 	hso_log_port(hso_dev);
@@ -2550,8 +2550,21 @@ static struct hso_device *hso_create_net_device(struct usb_interface *interface,
 	hso_create_rfkill(hso_dev, interface);
 
 	return hso_dev;
-exit:
-	hso_free_net_device(hso_dev, true);
+
+err_free_tx_buf:
+	remove_net_device(hso_dev);
+	kfree(hso_net->mux_bulk_tx_buf);
+err_free_tx_urb:
+	usb_free_urb(hso_net->mux_bulk_tx_urb);
+err_mux_bulk_rx:
+	for (i = 0; i < MUX_BULK_RX_BUF_COUNT; i++) {
+		usb_free_urb(hso_net->mux_bulk_rx_urb_pool[i]);
+		kfree(hso_net->mux_bulk_rx_buf_pool[i]);
+	}
+err_net:
+	free_netdev(net);
+err_hso_dev:
+	kfree(hso_dev);
 	return NULL;
 }
 
-- 
2.25.1

