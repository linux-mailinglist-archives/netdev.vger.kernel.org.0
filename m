Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F106B1B51DE
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 03:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726499AbgDWBes (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 21:34:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbgDWBeq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 21:34:46 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20997C03C1AA;
        Wed, 22 Apr 2020 18:34:46 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id u15so4517428ljd.3;
        Wed, 22 Apr 2020 18:34:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=G/DeIfTtEEjBtBecf4XcPLs4Cf8wCiNe7uM2NSD391A=;
        b=cbXkS909FJhTEQvWCuDzuQzaA0NsuulPznjrsSh2fseMwmYC9aqjcVnQQRHBxMTVhI
         9umfMk5Oioqb9J/NQvDFcGkpkb8LwVeE7Q8ZqQhgdHdges9SF+H48RBNlFto9zTe9nPt
         rX19Rjzhz8h9r6GH9DayRPMprtydudX2lnKvHOH8KqTOO+irilhzeEqvA1JqmZ/yTyuZ
         IThNyyZF/Q4IqP/hZ0+DAibGHUkJw8huJzTCOsd0/BBKaqB1YRVlb7y9po5ZIQqlIU9P
         ZPJB46QxH2eLJjlZIDH2BFMuGl23H/C3Tc88PAg5vAbAGdAhSqFJzvdenRrz8bffHAcT
         f13g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=G/DeIfTtEEjBtBecf4XcPLs4Cf8wCiNe7uM2NSD391A=;
        b=dGA3TXx65lyY3qJKe5wAGxf5Fs+a2IKsgi9qZUL5ITUMzyGBPaophxJpNxEmrikSkI
         V/Xt6KTRnPbEs9u5nb5X7C350JmiC2T4Jg2DMzdXobnh1L9Mi26H58eEHr1Vr67brC9v
         7l1BGf3tZ8Qxcakj6jy1eb4KpW+zlOpCN5IKJ4lOWBMZxLwq7iTPWowLCEdAKkqU8BA6
         FICcwYfjoNg+pKLbStF9MY4FT7ra4btNBzv5xIkH7lJds4VczmJ5OaBRihs/1JcqUxTo
         EqIPSQgqlUKsbnQsUWJZYkicxaHMK/IIwmQFqOOVVAKxiVFuxhS5VjRPZB7FotMSO1Sf
         7arA==
X-Gm-Message-State: AGi0PuYEzFmi4r1769Gy8ga0G0iQ2+68MHMh/ZYQfJCsQwcg+Daun1W8
        rDqyljeDvqcWZC/bWuWgaYA=
X-Google-Smtp-Source: APiQypLEtOmKh2USJECy+faxyw6KIO3K2LuNbi6t5dbfIDcM6sEn5dFCwSCsnaBlpW8RcqdtOAUciA==
X-Received: by 2002:a05:651c:119a:: with SMTP id w26mr891073ljo.53.1587605684557;
        Wed, 22 Apr 2020 18:34:44 -0700 (PDT)
Received: from localhost.localdomain ([87.200.95.144])
        by smtp.gmail.com with ESMTPSA id h21sm564967lfp.1.2020.04.22.18.34.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2020 18:34:44 -0700 (PDT)
From:   Christian Hewitt <christianshewitt@gmail.com>
To:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-amlogic@lists.infradead.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        Christian Hewitt <christianshewitt@gmail.com>
Subject: [PATCH v2 3/3] Bluetooth: hci_qca: allow max-speed to be set for QCA9377 devices
Date:   Thu, 23 Apr 2020 01:34:30 +0000
Message-Id: <20200423013430.21399-4-christianshewitt@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200423013430.21399-1-christianshewitt@gmail.com>
References: <20200423013430.21399-1-christianshewitt@gmail.com>
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
index 072983dc07e3..b3fd07a6f812 100644
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -597,10 +597,12 @@ static int qca_open(struct hci_uart *hu)
 
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
@@ -1871,6 +1873,11 @@ static int qca_serdev_probe(struct serdev_device *serdev)
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
@@ -1895,11 +1902,6 @@ static int qca_serdev_probe(struct serdev_device *serdev)
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

