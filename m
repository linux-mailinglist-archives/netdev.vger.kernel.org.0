Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E17B53C7FCF
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 10:11:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238456AbhGNIOl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 04:14:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238398AbhGNIOk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 04:14:40 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3378DC06175F;
        Wed, 14 Jul 2021 01:11:49 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id y17so1572686pgf.12;
        Wed, 14 Jul 2021 01:11:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vcI74ijnf4LIifxIqiDc51FiY2t+xKmqpG5BxGMZfd4=;
        b=e3LGc2uGmgh8b8NL0RXnr7jMvPs/r1poq5wBhlg3cvTniumhdhoGPBTizUaP/lnsPg
         hzWiFSk3/AWc18q5YtnW5IfC4eFo02jaRjpF4R2wnUNeqS9/cTw5TyS38gOBVEAJ7sqh
         rQoBFKjmRk55BArhTcilvklXKOIjsm5iqkxKokcT63E1gM8KQ54sfweuhNbA3VWDHQq1
         Nv+7uA3nY6PxHKQJ/rkABcPTchfG6S0DHNQZXGED8DZmNr6XUmBbCtvsL2oq+LbmjQEc
         F99K0jzpLur+ok4FfJQ2j/VXniSZ174VYrphuONd6em5lkBcW/4J1vE8ZQfwkEldkLeR
         lpkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vcI74ijnf4LIifxIqiDc51FiY2t+xKmqpG5BxGMZfd4=;
        b=iO00bHXqPFYse+ELxizk/gyADFxsVMWhUnuAsAo0KA57RyMiJjTGrehyUxT6iainno
         OnO3MW0ntYijIQc5Bx7E9pRu+qeotBylipzOz2MqKlefntZgIfvw3NmyGdThgBSWB5Mz
         +vImd541yzFcF8c9HMILGmaxPViB3AuXKOcb7HtWgnNLxUJg6B0G7xWMXhUYFZyQmal8
         +J0qzMRF4if4cOqoTUqiPRJn7oEGUbACs3ylShJ417Ry9ZNdFGjdfMoQCTvpLsipwb1m
         VBq4VMWFmKLmoNvJRadYEBJAeU2k8/iKNtKMvlmyqKWcEw/xSGt3l5zRfSsz+04TGiRQ
         g8zg==
X-Gm-Message-State: AOAM533CsEiKiDkxryWhI3ROTl/UlYzYJVS1+c8z1s4kn9V5JERE/rTy
        Jkkoc1mstJeEpsDOWunHDfs=
X-Google-Smtp-Source: ABdhPJz5ljEe2fRBvE/8vVluA/KFz4z7b4AWD9D4sAJe7RzlGUzEmi/9fy7+1zZcPv0eW4/Lh4I+Mg==
X-Received: by 2002:a62:a507:0:b029:30d:82e1:ce14 with SMTP id v7-20020a62a5070000b029030d82e1ce14mr8982240pfm.29.1626250308658;
        Wed, 14 Jul 2021 01:11:48 -0700 (PDT)
Received: from localhost.localdomain ([154.16.166.218])
        by smtp.gmail.com with ESMTPSA id n4sm1722090pff.51.2021.07.14.01.11.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jul 2021 01:11:48 -0700 (PDT)
From:   Dongliang Mu <mudongliangabcd@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hovold <johan@kernel.org>,
        Oliver Neukum <oneukum@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Dongliang Mu <mudongliangabcd@gmail.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Anirudh Rayabharam <mail@anirudhrb.com>
Cc:     syzbot+44d53c7255bb1aea22d2@syzkaller.appspotmail.com,
        Zheng Yongjun <zhengyongjun3@huawei.com>,
        Emil Renner Berthing <kernel@esmil.dk>,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] usb: hso: fix error handling code of hso_create_net_device
Date:   Wed, 14 Jul 2021 16:11:22 +0800
Message-Id: <20210714081127.675743-1-mudongliangabcd@gmail.com>
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
+		goto err_mux_bulk_tx;
 
 	add_net_device(hso_dev);
 
@@ -2542,7 +2542,7 @@ static struct hso_device *hso_create_net_device(struct usb_interface *interface,
 	result = register_netdev(net);
 	if (result) {
 		dev_err(&interface->dev, "Failed to register device\n");
-		goto exit;
+		goto err_register;
 	}
 
 	hso_log_port(hso_dev);
@@ -2550,8 +2550,21 @@ static struct hso_device *hso_create_net_device(struct usb_interface *interface,
 	hso_create_rfkill(hso_dev, interface);
 
 	return hso_dev;
-exit:
-	hso_free_net_device(hso_dev, true);
+
+err_register:
+	remove_net_device(hso_dev);
+	kfree(hso_net->mux_bulk_tx_buf);
+err_mux_bulk_tx:
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

