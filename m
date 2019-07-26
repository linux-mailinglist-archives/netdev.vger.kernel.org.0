Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABFC17679D
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 15:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727169AbfGZNfk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 09:35:40 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:41419 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726265AbfGZNfk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 09:35:40 -0400
Received: by mail-pg1-f196.google.com with SMTP id x15so14464511pgg.8;
        Fri, 26 Jul 2019 06:35:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5vo7sld/uL/U9JDdD3PiiYj0frOzh5KbSziKzqfPl7Y=;
        b=bvaxc3gCcfame+Q7d7uO/NY/FkQ9rJUTag603siglBaLoqGN8SEYdK3RHmkYQCG+p9
         84Em6VvzsTR1HT9pWwSAOEMm4sIvfSxX8z3M37/QctZRxtzNv6el8uI9JIlefP/x7P16
         BOXigXPT75K1aiUumlTzYWOttmQITS9EZmRE3/W1cxVsHTZZ+JmnWKlr64+ADPFuVDvr
         pW4cAmx09+P9Yx79zqCMLjb6ZNQ+oglWkm9wFL+PwMH2VSFpmdHEDraifefvotPNk2cW
         vexG7n+hzYmIvjNJ1gXVN4fHgCAUnCJHa75ism5eSt7znXqBuNSD5dCrY1SpxweiQ43Q
         ndjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5vo7sld/uL/U9JDdD3PiiYj0frOzh5KbSziKzqfPl7Y=;
        b=JskinGmQNG7rtZr207huu1YrBRX/8OhbPd27X6tpGnSHFJW9M38En5qTYAJw8BQ2Vz
         zIJKKh81MtPj6HXwjSvlty8LCWj3Jj90qfzFSq8LN7CpciOAbqK0GOhc0HAH4KIZ3thS
         wIcbeztx1cnsXnVuvk0Hb6Q43uSAa9eCY7w6ueDfrgUNjwqT0qHxeFmko1yc4DRkADQ1
         3zmbKBuWrJETqs/+2Kizi5GmGPNUXjhr1R9SXlCkWMe0NpV4NDl5KdEFBviRZFtqEf0c
         CEhQOS7FQzARLqIzKP+N93U6uuB1HdCT3znuFL1jCjdg0oquqZV10EyIckLrsxu/OuJP
         FqNw==
X-Gm-Message-State: APjAAAVsqIaCzyTVvAlSbXE85vlnT2skuV1BZINKjHB3LtvRNgbebBUQ
        Nycy8fLvd4t5Sfkwoz6vWZo=
X-Google-Smtp-Source: APXvYqwhYbxf/AS6zqCEVHvWXkXBuk3Vw3cw5lSS4pUZzVW7r+G1zlxB1zhXY8PgnPc7IOU0LHy/YQ==
X-Received: by 2002:a62:be0c:: with SMTP id l12mr22452326pff.224.1564148139716;
        Fri, 26 Jul 2019 06:35:39 -0700 (PDT)
Received: from debian.net.fpt ([2405:4800:58f7:1782:e03a:f6b:ecba:b51])
        by smtp.gmail.com with ESMTPSA id 137sm64940745pfz.112.2019.07.26.06.35.37
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 26 Jul 2019 06:35:39 -0700 (PDT)
From:   Phong Tran <tranmanphong@gmail.com>
To:     pebolle@tiscali.nl, isdn@linux-pingi.de, gregkh@linuxfoundation.org
Cc:     gigaset307x-common@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Phong Tran <tranmanphong@gmail.com>,
        syzbot+35b1c403a14f5c89eba7@syzkaller.appspotmail.com
Subject: [PATCH] isdn/gigaset: check endpoint null in gigaset_probe
Date:   Fri, 26 Jul 2019 20:35:28 +0700
Message-Id: <20190726133528.11063-1-tranmanphong@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This fixed the potential reference NULL pointer while using variable
endpoint.

Reported-by: syzbot+35b1c403a14f5c89eba7@syzkaller.appspotmail.com
Tested by syzbot:
https://groups.google.com/d/msg/syzkaller-bugs/wnHG8eRNWEA/Qn2HhjNdBgAJ

Signed-off-by: Phong Tran <tranmanphong@gmail.com>
---
 drivers/isdn/gigaset/usb-gigaset.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/isdn/gigaset/usb-gigaset.c b/drivers/isdn/gigaset/usb-gigaset.c
index 1b9b43659bdf..2e011f3db59e 100644
--- a/drivers/isdn/gigaset/usb-gigaset.c
+++ b/drivers/isdn/gigaset/usb-gigaset.c
@@ -703,6 +703,10 @@ static int gigaset_probe(struct usb_interface *interface,
 	usb_set_intfdata(interface, cs);
 
 	endpoint = &hostif->endpoint[0].desc;
+        if (!endpoint) {
+		dev_err(cs->dev, "Couldn't get control endpoint\n");
+		return -ENODEV;
+	}
 
 	buffer_size = le16_to_cpu(endpoint->wMaxPacketSize);
 	ucs->bulk_out_size = buffer_size;
@@ -722,6 +726,11 @@ static int gigaset_probe(struct usb_interface *interface,
 	}
 
 	endpoint = &hostif->endpoint[1].desc;
+        if (!endpoint) {
+		dev_err(cs->dev, "Endpoint not available\n");
+		retval = -ENODEV;
+		goto error;
+	}
 
 	ucs->busy = 0;
 
-- 
2.20.1

