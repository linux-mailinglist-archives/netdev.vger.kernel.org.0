Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A85371B2153
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 10:17:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728483AbgDUIRX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 04:17:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728437AbgDUIRM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 04:17:12 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66388C061A10;
        Tue, 21 Apr 2020 01:17:12 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id z26so13002334ljz.11;
        Tue, 21 Apr 2020 01:17:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ialMFur7X9DPC+g1oI8+Dh4E5wgzi1y2UDjvZas+VmA=;
        b=i/Y02tiK0l6yFkhBoRWAQ8ngsHcCX2xSBJfxJBCKCAqshNvz+LHCKRSQOeBQSscDkp
         p2Ar6wq5imowYLqGgI3f3VLhVycp2WNHEFZOMea7PNS/6XwegC5mrJN5tIljf0EAoRvV
         bfipIepYuz9k8vEJSb+R/Xj5YVbE/W5ILgTUZhX2/rOJX/9W34BT2S3gN8X2Tka03bEM
         8e18akw6yCponIlt2G5gF7mRNBzbS46aAJqaqXUj6Osgp+CZwERfcBEXYvyozVwEcVN0
         45bW6IzA1SHguZHrUKsEyNZXu3ORrGCXWoAO5ofRxFV/d6hTkOrdKeQcmLBVIpRNXgBh
         XkzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ialMFur7X9DPC+g1oI8+Dh4E5wgzi1y2UDjvZas+VmA=;
        b=sYYbjlS8vByOf89CmqFepzZbW50W1ZgeVqDZfZJnc4/z6Rc/ifY/aFyw6EUXnN4Q5P
         tGxOIP8EIzWgsvernPet81Lltkq/cA7zeHyWSDfby0Xvel15mhFcYzIogV3C2csOFkhf
         nS9Cto5hnPVXmu9KaAq1Gwog3AgwOHMAeR5IUJ8Y/zOddYKn/0IdswDbyERYMhO9i10/
         y1L3RE1Mba7KXzjTtdABS+gWnCAKZBXJH5eqVcHwnAJJOFmQwtHl/civL9I7fzrUFqm/
         n7Ft9NtLTBKPn5nxrIVJFWM3UDo/lDA5xJbl5nvVrGayWpN6ZtFNnwKE3Gui3IkT3Kke
         35Lw==
X-Gm-Message-State: AGi0PuZlyNEbz/DZ5WjbMUvbclid8nb+zMCssGH+DnrLNTPsRIoYVufr
        snj1ItbGygCRFJPNJJTPjys=
X-Google-Smtp-Source: APiQypIznA9Jxu+DKX+UuSMPdggfsfkTowEcFTLr3ooT4JKu6jZ6T+ctpSYQn4/3cR9ftldZA0SfKg==
X-Received: by 2002:a2e:800f:: with SMTP id j15mr10309809ljg.27.1587457030910;
        Tue, 21 Apr 2020 01:17:10 -0700 (PDT)
Received: from localhost.localdomain ([87.200.95.144])
        by smtp.gmail.com with ESMTPSA id j13sm1472756lfb.19.2020.04.21.01.17.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2020 01:17:10 -0700 (PDT)
From:   Christian Hewitt <christianshewitt@gmail.com>
To:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-amlogic@lists.infradead.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Subject: [PATCH 3/3] Bluetooth: hci_qca: allow max-speed to be set for QCA9377 devices
Date:   Tue, 21 Apr 2020 08:16:56 +0000
Message-Id: <20200421081656.9067-4-christianshewitt@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200421081656.9067-1-christianshewitt@gmail.com>
References: <20200421081656.9067-1-christianshewitt@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the read of max-speed from device-tree out of the qca_is_wcn399x
if block so oper_speed can be set for QCA9377 devices as well.

Suggested-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Signed-off-by: Christian Hewitt <christianshewitt@gmail.com>
---
 drivers/bluetooth/hci_qca.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/bluetooth/hci_qca.c b/drivers/bluetooth/hci_qca.c
index 6f0350fbdcd6..b63ec7a0ac9e 100644
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -596,10 +596,12 @@ static int qca_open(struct hci_uart *hu)
 
 	if (hu->serdev) {
 		qcadev = serdev_device_get_drvdata(hu->serdev);
-		if (qca_is_wcn399x(qcadev->btsoc_type)) {
+
+		if (qca_is_wcn399x(qcadev->btsoc_type))
 			hu->init_speed = qcadev->init_speed;
+
+		if (qcadev->oper_speed)
 			hu->oper_speed = qcadev->oper_speed;
-		}
 	}
 
 	timer_setup(&qca->wake_retrans_timer, hci_ibs_wake_retrans_timeout, 0);
@@ -1865,6 +1867,11 @@ static int qca_serdev_probe(struct serdev_device *serdev)
 	serdev_device_set_drvdata(serdev, qcadev);
 	device_property_read_string(&serdev->dev, "firmware-name",
 					 &qcadev->firmware_name);
+	device_property_read_u32(&serdev->dev, "max-speed",
+				 &qcadev->oper_speed);
+	if (!qcadev->oper_speed)
+		BT_DBG("UART will pick default operating speed");
+
 	if (data && qca_is_wcn399x(data->soc_type)) {
 		qcadev->btsoc_type = data->soc_type;
 		qcadev->bt_power = devm_kzalloc(&serdev->dev,
@@ -1889,11 +1896,6 @@ static int qca_serdev_probe(struct serdev_device *serdev)
 			return PTR_ERR(qcadev->susclk);
 		}
 
-		device_property_read_u32(&serdev->dev, "max-speed",
-					 &qcadev->oper_speed);
-		if (!qcadev->oper_speed)
-			BT_DBG("UART will pick default operating speed");
-
 		err = hci_uart_register_device(&qcadev->serdev_hu, &qca_proto);
 		if (err) {
 			BT_ERR("wcn3990 serdev registration failed");
-- 
2.17.1

