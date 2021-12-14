Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F32CC474DBC
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 23:12:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232684AbhLNWLw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 17:11:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbhLNWLv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 17:11:51 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68EABC061574;
        Tue, 14 Dec 2021 14:11:51 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id g19so18990162pfb.8;
        Tue, 14 Dec 2021 14:11:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wRt3Fh01KA5eeSEw2iv3iHWOrv3eO/SBn/6JbKjZZEE=;
        b=h9rGd1j8L/8dqrG8q0zTLIbjQHvjSy/P7DrrvztSzKAH+x6p+fLt55yceKseki+Alt
         /WEvEdLOicqCtB3krTMHJGixoa/SLelPAqRRF3rEZqjx1UetM9yimn8pW1IxKa+KW1W8
         Mofz622KuoKmnceiI8R0rzCAUpCPMUUJIiMAWyz0bSXkP1oQK5FlRQmKMa+nbRhIOSWm
         uZqc6XtSj0A/SG3pU/r9DP7dJVGwWU/966EH5et2LjBNUlG+sBHtbFA35tfG9PvdGIpB
         Q5cGiWD39A9VYPG46CWMgLF7WrB3OpO8CNC/HvPNu0ZCuD4U0s3veKUzGIbjdRdB0+gz
         yZDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wRt3Fh01KA5eeSEw2iv3iHWOrv3eO/SBn/6JbKjZZEE=;
        b=gz7IIInVybz6QeevD3c7Q7hvWBE2u3QqAdH+fI9ZWs2J6+EOZrDYJKK5H9KmzBBGnv
         3nGdJmHfPOLC4hQVv+MwsNOjuN0uDWQR5cPETXMsVyW104uUjeoNwElLPgyaGXHWiAM2
         V+wqTFaRQPbcIiJ07Spk+nIVsdRqZtpEi6+1JhPupf/b3ZG74zSOErMLsm0lKPo8hzlZ
         VQ6uj1PUmo2AnkiGeiHGNIid3zn6N23uILV8vkqnzGxCAZ+i7t49pGZwvlMLvVSiGJqp
         7pgPuo8dY4cGtMg7OOGWJIDHU3kTpLk2mU7pQqPdovjd03tZ7B0vGAH/LqiJcDZR31jG
         2rmA==
X-Gm-Message-State: AOAM532eAUqvlyDX1ggF8fchTwj15OFKOiZ2NvH7TPXdpR8dlJ4jExEa
        A3eqkiolPkSSsZKzJmuQFnM=
X-Google-Smtp-Source: ABdhPJxLs3nQOphmY57FIE3V1CmWt0eb1aiFiqi5g4C3nfWbf0ZxtA+Egy99Bm8IZtfn1c3yoeSRXg==
X-Received: by 2002:a63:131d:: with SMTP id i29mr3515419pgl.493.1639519910996;
        Tue, 14 Dec 2021 14:11:50 -0800 (PST)
Received: from devoptiplex ([70.102.108.170])
        by smtp.gmail.com with ESMTPSA id f4sm84181pfj.61.2021.12.14.14.11.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 14:11:50 -0800 (PST)
From:   Greg Jesionowski <jesionowskigreg@gmail.com>
Cc:     woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Jesionowski <jesionowskigreg@gmail.com>
Subject: [PATCH] net: usb: lan78xx: add Allied Telesis AT29M2-AF
Date:   Tue, 14 Dec 2021 15:10:27 -0700
Message-Id: <20211214221027.305784-1-jesionowskigreg@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds the vendor and product IDs for the AT29M2-AF which is a
lan7801-based device.

Signed-off-by: Greg Jesionowski <jesionowskigreg@gmail.com>
---
 drivers/net/usb/lan78xx.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index f20376c1ef3f..474a720e8957 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -76,6 +76,8 @@
 #define LAN7801_USB_PRODUCT_ID		(0x7801)
 #define LAN78XX_EEPROM_MAGIC		(0x78A5)
 #define LAN78XX_OTP_MAGIC		(0x78F3)
+#define AT29M2AF_USB_VENDOR_ID		(0x07C9)
+#define AT29M2AF_USB_PRODUCT_ID	(0x0012)
 
 #define	MII_READ			1
 #define	MII_WRITE			0
@@ -4734,6 +4736,10 @@ static const struct usb_device_id products[] = {
 	/* LAN7801 USB Gigabit Ethernet Device */
 	USB_DEVICE(LAN78XX_USB_VENDOR_ID, LAN7801_USB_PRODUCT_ID),
 	},
+	{
+	/* ATM2-AF USB Gigabit Ethernet Device */
+	USB_DEVICE(AT29M2AF_USB_VENDOR_ID, AT29M2AF_USB_PRODUCT_ID),
+	},
 	{},
 };
 MODULE_DEVICE_TABLE(usb, products);
-- 
2.25.1

