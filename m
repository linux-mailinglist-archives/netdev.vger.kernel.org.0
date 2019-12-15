Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7218911FAEA
	for <lists+netdev@lfdr.de>; Sun, 15 Dec 2019 20:59:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbfLOT7H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Dec 2019 14:59:07 -0500
Received: from mta-p6.oit.umn.edu ([134.84.196.206]:40376 "EHLO
        mta-p6.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726260AbfLOT7H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Dec 2019 14:59:07 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-p6.oit.umn.edu (Postfix) with ESMTP id 47bZwp2JNdz9vZ5l
        for <netdev@vger.kernel.org>; Sun, 15 Dec 2019 19:59:06 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p6.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p6.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id iw4gFJnF52f7 for <netdev@vger.kernel.org>;
        Sun, 15 Dec 2019 13:59:06 -0600 (CST)
Received: from mail-yw1-f71.google.com (mail-yw1-f71.google.com [209.85.161.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p6.oit.umn.edu (Postfix) with ESMTPS id 47bZwp1Fhxz9vZ6K
        for <netdev@vger.kernel.org>; Sun, 15 Dec 2019 13:59:06 -0600 (CST)
Received: by mail-yw1-f71.google.com with SMTP id q187so4120091ywg.12
        for <netdev@vger.kernel.org>; Sun, 15 Dec 2019 11:59:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8TUcX1RfgZ492tOYJ5s68irOhl6zZB85wQRSq77/peo=;
        b=cV5bO+pKRY3btcUkVNBJcD4tq59cy1Fw6Mlknr43a6PVbLbDvgGPoljM6wBB31iIpc
         GccTGzcaJFMK+3ciJ0/vehKwYAKe2k10CyxyUOykIzZvsAlFGOumqum5zzu2IZo8dpaf
         8EU+bceJKoUvtPFzXXVDlI2OpZT0FAJIjiHWHSpv65KIHuVKTmMhO4++QXY/aqByf/YM
         cFkpC8M45swPp8XtL3huRukcVd+wbtMXpS1L4p1icFdHEQ4TGu+9+zCUcPnDK6+PqOtF
         MyzvvX5jQ1++SHaKIWskUqeJj73fcBFv4ltA2E30iv9uJdI4QGD9IauPZ1j5gGOoOQ77
         1vIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8TUcX1RfgZ492tOYJ5s68irOhl6zZB85wQRSq77/peo=;
        b=L8o0++845/g/am1CrGC4Wpf0MSPQ8GAJyorSPEfyU149X7g6PRAC9bULQ3QA+hE3c5
         NnvTCxBsgCQ9qc+sD1tJYeBWs30BTkGLJ8aIitF3LxGUNHsf/XbotUKEAhWxJhNKKTwQ
         ZIuUvKpYlXOw2tik4CFdr5FRdS/2s6PfcjrBFHMS++S3o1t06peY8a5slf6uczNT9ulz
         bL+xmwKfBPFtoajMaCezxx/noTrMamsX9iOkBPGzj91pEGGdAztkdcABBPVDxWYyHYbD
         4rq0JZka/EdPQ6vFw4lvF9qLD/2N1miaaUtximXKWsFXYjeuO/KKPLFdhPZEiab7M3Ih
         By7Q==
X-Gm-Message-State: APjAAAWBuf023ZzrAO//EtL/OhmgetCkSoFt+wiYtX+BvfOkUU/h/z9r
        gbFNmQ+XRiGYVQIN2JuJP9TGgkUpcGDDrdJKIMvPGjEvGwhvCXiZZDKDmc5T7eTs5Q65wEcxPv6
        YtK6tExffwG2Ecjpcr51g
X-Received: by 2002:a25:3009:: with SMTP id w9mr6023068ybw.47.1576439945684;
        Sun, 15 Dec 2019 11:59:05 -0800 (PST)
X-Google-Smtp-Source: APXvYqy5IqUJNnB0dOatc0l9p5iHfoI+NtpfRKhivnJlbv9QIJmKpopWGOVWyNhfXIUi8AuGJKEmdg==
X-Received: by 2002:a25:3009:: with SMTP id w9mr6023058ybw.47.1576439945472;
        Sun, 15 Dec 2019 11:59:05 -0800 (PST)
Received: from cs-u-syssec1.dtc.umn.edu (cs-u-syssec1.cs.umn.edu. [128.101.106.66])
        by smtp.gmail.com with ESMTPSA id d126sm1059071ywf.28.2019.12.15.11.59.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Dec 2019 11:59:05 -0800 (PST)
From:   Aditya Pakki <pakki001@umn.edu>
To:     pakki001@umn.edu
Cc:     kjlu@umn.edu, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] orinoco: avoid assertion in case of NULL pointer
Date:   Sun, 15 Dec 2019 13:58:58 -0600
Message-Id: <20191215195900.6109-1-pakki001@umn.edu>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In ezusb_init, if upriv is NULL, the code crashes. However, the caller
in ezusb_probe can handle the error and print the failure message.
The patch replaces the BUG_ON call to error return.

Signed-off-by: Aditya Pakki <pakki001@umn.edu>
---
 drivers/net/wireless/intersil/orinoco/orinoco_usb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intersil/orinoco/orinoco_usb.c b/drivers/net/wireless/intersil/orinoco/orinoco_usb.c
index 40a8b941ad5c..813de06c03de 100644
--- a/drivers/net/wireless/intersil/orinoco/orinoco_usb.c
+++ b/drivers/net/wireless/intersil/orinoco/orinoco_usb.c
@@ -1361,7 +1361,8 @@ static int ezusb_init(struct hermes *hw)
 	int retval;
 
 	BUG_ON(in_interrupt());
-	BUG_ON(!upriv);
+	if (!upriv)
+		return -EINVAL;
 
 	upriv->reply_count = 0;
 	/* Write the MAGIC number on the simulated registers to keep
-- 
2.20.1

