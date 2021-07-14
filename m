Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C59E93C8133
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 11:14:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238938AbhGNJRV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 05:17:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238971AbhGNJRR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 05:17:17 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68100C06175F;
        Wed, 14 Jul 2021 02:14:26 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id l11so1175744pji.5;
        Wed, 14 Jul 2021 02:14:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Omd/xmMsedzAfyZeu1JPMqyvYANwg1OTgXgLY4V+rRo=;
        b=mimqfYEfgpUrvcWumZukcmsTf+MVhbT+TCXF+ei9UjWoDoQDV7bb2mzBntAWaih1cC
         3LK00hUcSr1GwL8rcGwXOZ5Z5q2Sy18VpPzeGKEEhw1/sNCR1L0RHg5hmqY5yU6mS7dq
         0Z5EMAb+xGndaZGZz0z8EQRyXnSMIW52/5koroXSfuQWHDuJXjV6EwoRIJg+gbaN7Gff
         4e1pb7H/JJ+rGnUjoodHgEaJKceKeApzsZOC3LJe3x7iJBtIFc1I/IuKHVG4GpdNftFf
         BW9ouVAIG4O7ShFoO/f3uuuNOK/TPNwHUaeNvTsEUGvpOUNbzGMfbg32ByjOALNmIAIY
         ZI1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Omd/xmMsedzAfyZeu1JPMqyvYANwg1OTgXgLY4V+rRo=;
        b=tFRc1lcuMlB+u9grFxeHQk/vCWElb2+ztBb9/UBR0iHFYstAKW4Di0VJcUhoK1mDQh
         xlwinmmPTrcTro5H9z0ICQuKfVnEMZ5/ev3BAuuGbLjSvZuLWlhp8/9jlstdbaHM3RT+
         /Y/YI47C8vZyMmmY2T8DrRtSukNPnorxJ1zyIcSED/h24KEmNSQE7BQ3jfkf2UxRC1ep
         HYAGbQmcNTZUKHyc+6kLrhK6V+pgvswo/0KIrLjGAic9S1iBw42e1JkuuS85xbbltBWY
         HBLl8nKtQ+f30lfMsOY7oMu4kOEehXThZoPiSpK7N66vjyyBfcIgpg/jp8Eemnnq1iQD
         hvSw==
X-Gm-Message-State: AOAM532t61bctCpsOMycIhlSiKvbOZtYEc3qv1w2EJJmolkyTm3j/ut7
        IBjWaysnTMKUyh7Tek9pXQw=
X-Google-Smtp-Source: ABdhPJxUNo/W1JmruJT0Jefh9KaqfoQoqy4p9eOLwkKvbA+eRKrWi6WGmys9U5L0lzy1OoqlSaZ++g==
X-Received: by 2002:a17:90b:11d4:: with SMTP id gv20mr816075pjb.87.1626254065784;
        Wed, 14 Jul 2021 02:14:25 -0700 (PDT)
Received: from localhost.localdomain ([154.16.166.218])
        by smtp.gmail.com with ESMTPSA id d67sm1921191pfd.81.2021.07.14.02.14.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jul 2021 02:14:25 -0700 (PDT)
From:   Dongliang Mu <mudongliangabcd@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hovold <johan@kernel.org>,
        Oliver Neukum <oneukum@suse.com>,
        Anirudh Rayabharam <mail@anirudhrb.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Rustam Kovhaev <rkovhaev@gmail.com>,
        Zheng Yongjun <zhengyongjun3@huawei.com>,
        Emil Renner Berthing <kernel@esmil.dk>
Cc:     Dongliang Mu <mudongliangabcd@gmail.com>,
        syzbot+44d53c7255bb1aea22d2@syzkaller.appspotmail.com,
        YueHaibing <yuehaibing@huawei.com>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/2] usb: hso: fix error handling code of hso_create_net_device
Date:   Wed, 14 Jul 2021 17:13:22 +0800
Message-Id: <20210714091327.677458-1-mudongliangabcd@gmail.com>
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
index 54ef8492ca01..39c4e88eab62 100644
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

