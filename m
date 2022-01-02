Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AECA482C55
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 18:20:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbiABRUB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 12:20:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiABRUA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jan 2022 12:20:00 -0500
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4EAFC061761;
        Sun,  2 Jan 2022 09:19:59 -0800 (PST)
Received: by mail-lf1-x12f.google.com with SMTP id i31so70594274lfv.10;
        Sun, 02 Jan 2022 09:19:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zeIz7SpaGchv068gfQcu2/c3ylmt2DT39R9W0+3wJqA=;
        b=NFQTL8r5c4YsZSk6PoTHW83Yeme+g/ldhGk4UTcz00ptGs1dMmsi7iCjUuNLthFX9f
         kUQHyo0ua6nPyUPenu92NX+HCMioWfeHO+aHRudimuYSVLdjPyp6s3tWOp2okCVbYv1Z
         ADIZvlfVwu3LBBsJna993kECPGxWFpXfl/Ci2/XWzjj3vRDw1GWKlGhKa3RD0WyJhCtW
         QreJeWMsDZzSvIW+lrCk9Qd5Kp25ak3Iy6JzbSEYOJUIGof8Da7jRnoI35BYibaKQ7yA
         yrPFFIGR7k2wpnu/7TNP3Z2hFkKvzhwh1uKQw144FR+Q7yyKkhppFbselT0shpskkJ+P
         bJ3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zeIz7SpaGchv068gfQcu2/c3ylmt2DT39R9W0+3wJqA=;
        b=cV83Pk8I5uvVxWpAwzgeX87jfAnFpNCjipPnQbSZGHxaPm25Wos+6ePxcSjsFz3q/N
         LJHtrcl6gcBhHUlthMlpv2kHst1e8LRzyuqGfxl9n5EEPCBlpTYVI43lah+XUW+8fB46
         Gky5iW64w4xOjwBu6MAH1FM6/nM9TREuJQWQ8kLotTUY8lKSd7ila+rB18Z8/Ci8EUPV
         m6S882g6HpaZZs5yBGzccf4jfE0gxpD+rtvL+Pzb19uoRjVCuFhdwP47xGbQKwL0/KKE
         wDLDqBx+0ru6SNKLUchOKTv3teNmYaaxms4oBf1HpKEWJqeaBlakPwJ4/N/Kt8O4qjMI
         om2g==
X-Gm-Message-State: AOAM533vsdjUr46IRPxSQMH0Q+/KbUuAO9LF+5TyjZSw2vh8DVfPtzga
        72Ea3KQIQbemEMXA/t39ZMU=
X-Google-Smtp-Source: ABdhPJyglLbS47dxDNoj9LAWgXaANJ1ArO/SIIBU1yq01Qjf7OkvalYeZSX7iSvTqTGdTt64XdpiRQ==
X-Received: by 2002:a19:6042:: with SMTP id p2mr38331806lfk.381.1641143998046;
        Sun, 02 Jan 2022 09:19:58 -0800 (PST)
Received: from localhost.localdomain ([217.117.245.177])
        by smtp.gmail.com with ESMTPSA id s7sm2662018ljc.110.2022.01.02.09.19.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Jan 2022 09:19:57 -0800 (PST)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     stefan@datenfreihafen.org, alex.aring@gmail.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>, stable@vger.kernel.org,
        Alexander Potapenko <glider@google.com>
Subject: [PATCH RFT] ieee802154: atusb: move to new USB API
Date:   Sun,  2 Jan 2022 20:19:43 +0300
Message-Id: <20220102171943.28846-1-paskripkin@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <CAG_fn=VDEoQx5c7XzWX1yaYBd5y5FrG1aagrkv+SZ03c8TfQYQ@mail.gmail.com>
References: <CAG_fn=VDEoQx5c7XzWX1yaYBd5y5FrG1aagrkv+SZ03c8TfQYQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexander reported a use of uninitialized value in
atusb_set_extended_addr(), that is caused by reading 0 bytes via
usb_control_msg().

Since there is an API, that cannot read less bytes, than was requested,
let's move atusb driver to use it. It will fix all potintial bugs with
uninit values and make code more modern

Fail log:

BUG: KASAN: uninit-cmp in ieee802154_is_valid_extended_unicast_addr include/linux/ieee802154.h:310 [inline]
BUG: KASAN: uninit-cmp in atusb_set_extended_addr drivers/net/ieee802154/atusb.c:1000 [inline]
BUG: KASAN: uninit-cmp in atusb_probe.cold+0x29f/0x14db drivers/net/ieee802154/atusb.c:1056
Uninit value used in comparison: 311daa649a2003bd stack handle: 000000009a2003bd
 ieee802154_is_valid_extended_unicast_addr include/linux/ieee802154.h:310 [inline]
 atusb_set_extended_addr drivers/net/ieee802154/atusb.c:1000 [inline]
 atusb_probe.cold+0x29f/0x14db drivers/net/ieee802154/atusb.c:1056
 usb_probe_interface+0x314/0x7f0 drivers/usb/core/driver.c:396

Fixes: 7490b008d123 ("ieee802154: add support for atusb transceiver")
Cc: stable@vger.kernel.org # 5.9
Reported-by: Alexander Potapenko <glider@google.com>
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---
 drivers/net/ieee802154/atusb.c | 61 +++++++++++++++++++++-------------
 1 file changed, 38 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ieee802154/atusb.c b/drivers/net/ieee802154/atusb.c
index 23ee0b14cbfa..43befea0110f 100644
--- a/drivers/net/ieee802154/atusb.c
+++ b/drivers/net/ieee802154/atusb.c
@@ -80,10 +80,9 @@ struct atusb_chip_data {
  * in atusb->err and reject all subsequent requests until the error is cleared.
  */
 
-static int atusb_control_msg(struct atusb *atusb, unsigned int pipe,
-			     __u8 request, __u8 requesttype,
-			     __u16 value, __u16 index,
-			     void *data, __u16 size, int timeout)
+static int atusb_control_msg_recv(struct atusb *atusb, __u8 request, __u8 requesttype,
+				  __u16 value, __u16 index,
+				  void *data, __u16 size, int timeout)
 {
 	struct usb_device *usb_dev = atusb->usb_dev;
 	int ret;
@@ -91,8 +90,30 @@ static int atusb_control_msg(struct atusb *atusb, unsigned int pipe,
 	if (atusb->err)
 		return atusb->err;
 
-	ret = usb_control_msg(usb_dev, pipe, request, requesttype,
-			      value, index, data, size, timeout);
+	ret = usb_control_msg_recv(usb_dev, 0, request, requesttype,
+				   value, index, data, size, timeout, GFP_KERNEL);
+	if (ret < 0) {
+		atusb->err = ret;
+		dev_err(&usb_dev->dev,
+			"%s: req 0x%02x val 0x%x idx 0x%x, error %d\n",
+			__func__, request, value, index, ret);
+	}
+
+	return ret;
+}
+
+static int atusb_control_msg_send(struct atusb *atusb, __u8 request, __u8 requesttype,
+				  __u16 value, __u16 index,
+				  void *data, __u16 size, int timeout)
+{
+	struct usb_device *usb_dev = atusb->usb_dev;
+	int ret;
+
+	if (atusb->err)
+		return atusb->err;
+
+	ret = usb_control_msg_send(usb_dev, 0, request, requesttype,
+				   value, index, data, size, timeout, GFP_KERNEL);
 	if (ret < 0) {
 		atusb->err = ret;
 		dev_err(&usb_dev->dev,
@@ -107,8 +128,7 @@ static int atusb_command(struct atusb *atusb, u8 cmd, u8 arg)
 	struct usb_device *usb_dev = atusb->usb_dev;
 
 	dev_dbg(&usb_dev->dev, "%s: cmd = 0x%x\n", __func__, cmd);
-	return atusb_control_msg(atusb, usb_sndctrlpipe(usb_dev, 0),
-				 cmd, ATUSB_REQ_TO_DEV, arg, 0, NULL, 0, 1000);
+	return atusb_control_msg_send(atusb, cmd, ATUSB_REQ_TO_DEV, arg, 0, NULL, 0, 1000);
 }
 
 static int atusb_write_reg(struct atusb *atusb, u8 reg, u8 value)
@@ -116,9 +136,8 @@ static int atusb_write_reg(struct atusb *atusb, u8 reg, u8 value)
 	struct usb_device *usb_dev = atusb->usb_dev;
 
 	dev_dbg(&usb_dev->dev, "%s: 0x%02x <- 0x%02x\n", __func__, reg, value);
-	return atusb_control_msg(atusb, usb_sndctrlpipe(usb_dev, 0),
-				 ATUSB_REG_WRITE, ATUSB_REQ_TO_DEV,
-				 value, reg, NULL, 0, 1000);
+	return atusb_control_msg_send(atusb, ATUSB_REG_WRITE, ATUSB_REQ_TO_DEV,
+				      value, reg, NULL, 0, 1000);
 }
 
 static int atusb_read_reg(struct atusb *atusb, u8 reg)
@@ -133,9 +152,8 @@ static int atusb_read_reg(struct atusb *atusb, u8 reg)
 		return -ENOMEM;
 
 	dev_dbg(&usb_dev->dev, "%s: reg = 0x%x\n", __func__, reg);
-	ret = atusb_control_msg(atusb, usb_rcvctrlpipe(usb_dev, 0),
-				ATUSB_REG_READ, ATUSB_REQ_FROM_DEV,
-				0, reg, buffer, 1, 1000);
+	ret = atusb_control_msg_recv(atusb, ATUSB_REG_READ, ATUSB_REQ_FROM_DEV,
+				     0, reg, buffer, 1, 1000);
 
 	if (ret >= 0) {
 		value = buffer[0];
@@ -805,9 +823,8 @@ static int atusb_get_and_show_revision(struct atusb *atusb)
 		return -ENOMEM;
 
 	/* Get a couple of the ATMega Firmware values */
-	ret = atusb_control_msg(atusb, usb_rcvctrlpipe(usb_dev, 0),
-				ATUSB_ID, ATUSB_REQ_FROM_DEV, 0, 0,
-				buffer, 3, 1000);
+	ret = atusb_control_msg_recv(atusb, ATUSB_ID, ATUSB_REQ_FROM_DEV, 0, 0,
+				     buffer, 3, 1000);
 	if (ret >= 0) {
 		atusb->fw_ver_maj = buffer[0];
 		atusb->fw_ver_min = buffer[1];
@@ -861,9 +878,8 @@ static int atusb_get_and_show_build(struct atusb *atusb)
 	if (!build)
 		return -ENOMEM;
 
-	ret = atusb_control_msg(atusb, usb_rcvctrlpipe(usb_dev, 0),
-				ATUSB_BUILD, ATUSB_REQ_FROM_DEV, 0, 0,
-				build, ATUSB_BUILD_SIZE, 1000);
+	ret = atusb_control_msg_recv(atusb, ATUSB_BUILD, ATUSB_REQ_FROM_DEV, 0, 0,
+				     build, ATUSB_BUILD_SIZE, 1000);
 	if (ret >= 0) {
 		build[ret] = 0;
 		dev_info(&usb_dev->dev, "Firmware: build %s\n", build);
@@ -985,9 +1001,8 @@ static int atusb_set_extended_addr(struct atusb *atusb)
 		return -ENOMEM;
 
 	/* Firmware is new enough so we fetch the address from EEPROM */
-	ret = atusb_control_msg(atusb, usb_rcvctrlpipe(usb_dev, 0),
-				ATUSB_EUI64_READ, ATUSB_REQ_FROM_DEV, 0, 0,
-				buffer, IEEE802154_EXTENDED_ADDR_LEN, 1000);
+	ret = atusb_control_msg_recv(atusb, ATUSB_EUI64_READ, ATUSB_REQ_FROM_DEV, 0, 0,
+				     buffer, IEEE802154_EXTENDED_ADDR_LEN, 1000);
 	if (ret < 0) {
 		dev_err(&usb_dev->dev, "failed to fetch extended address, random address set\n");
 		ieee802154_random_extended_addr(&atusb->hw->phy->perm_extended_addr);
-- 
2.34.1

