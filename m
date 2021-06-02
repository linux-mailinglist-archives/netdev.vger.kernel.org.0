Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0CE43987EF
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 13:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232079AbhFBLWR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 07:22:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52955 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbhFBLWK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 07:22:10 -0400
Received: from mail-ed1-f71.google.com ([209.85.208.71])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1loOvB-0005Eh-Mk
        for netdev@vger.kernel.org; Wed, 02 Jun 2021 11:20:25 +0000
Received: by mail-ed1-f71.google.com with SMTP id c21-20020a0564021015b029038c3f08ce5aso1192935edu.18
        for <netdev@vger.kernel.org>; Wed, 02 Jun 2021 04:20:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Dg5RWJfPVjGhObprFebAP1b6q7PFdTvgviRzWEXH+s0=;
        b=bhUWs1V7oOUy5q2t//7AQgbIQWFW1NURiE6TCmSYNnXNpx71npE5iprlW5LNI1fVPz
         fk9AIXO+HCOEU6OW+QCYt+ILSGiDuKqxyPoQ5cVCqpubREwvDbR8NrRfV63cXmyZXxFF
         aVCBxqsldori68OWzJA2t7XqKg8mBDTzRdepe2v4bWdloIMR1EUwPBv/WCrRlL6RdEGx
         ur6rXHbi408VU47mkCj3RRelT5JSkrp8pSyJDK8eJsPYAXLfKO/FtjM5P5nCnZwCw8CO
         31+PpHBcylEbYkZjhqfZgtrbiYN5Bp8hG0rVtmX6X2t7j5IrfUwv2yPA6na3oYQiobnP
         11CA==
X-Gm-Message-State: AOAM533S+YWrJSQasXP/i5wKZMqyaCwncCGTEMEAh73XUSzOySDqC5Tl
        wCVh7Bqi4WzIXe9vMH0o3eebjWyAw83S8zCxdGrP6tYe37iZOxKl7xACq4WddF7OH9fINUIVXbW
        n+ZUIYcq9j6mGw1lY7SdCoBeNX2107YkrrQ==
X-Received: by 2002:a17:906:b6c5:: with SMTP id ec5mr33858443ejb.290.1622632825448;
        Wed, 02 Jun 2021 04:20:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxrFvwwDfEpK0N6mkxbqvhu2A9BYNI8VLGHKVpdxBN1fSXzF09em7UedqZPCBKEEY+ClkDoQw==
X-Received: by 2002:a17:906:b6c5:: with SMTP id ec5mr33858433ejb.290.1622632825310;
        Wed, 02 Jun 2021 04:20:25 -0700 (PDT)
Received: from localhost.localdomain (xdsl-188-155-185-9.adslplus.ch. [188.155.185.9])
        by smtp.gmail.com with ESMTPSA id jp6sm3699705ejb.85.2021.06.02.04.20.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 04:20:24 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Joe Perches <joe@perches.com>
Subject: [PATCH v2 2/2] nfc: mrvl: reduce the scope of local variables
Date:   Wed,  2 Jun 2021 13:20:11 +0200
Message-Id: <20210602112011.44473-2-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210602112011.44473-1-krzysztof.kozlowski@canonical.com>
References: <20210602112011.44473-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In two places the 'ep_desc' and 'skb' local variables are used only
within if() or for() block, so they scope can be reduced which makes the
entire code slightly easier to follow.  No functional change.

Suggested-by: Joe Perches <joe@perches.com>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

---

Changes since v1:
1. New patch
---
 drivers/nfc/nfcmrvl/usb.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/nfc/nfcmrvl/usb.c b/drivers/nfc/nfcmrvl/usb.c
index 6fec20abfd1e..ec6fd7a3f31f 100644
--- a/drivers/nfc/nfcmrvl/usb.c
+++ b/drivers/nfc/nfcmrvl/usb.c
@@ -68,7 +68,6 @@ static int nfcmrvl_inc_tx(struct nfcmrvl_usb_drv_data *drv_data)
 static void nfcmrvl_bulk_complete(struct urb *urb)
 {
 	struct nfcmrvl_usb_drv_data *drv_data = urb->context;
-	struct sk_buff *skb;
 	int err;
 
 	dev_dbg(&drv_data->udev->dev, "urb %p status %d count %d\n",
@@ -78,6 +77,8 @@ static void nfcmrvl_bulk_complete(struct urb *urb)
 		return;
 
 	if (!urb->status) {
+		struct sk_buff *skb;
+
 		skb = nci_skb_alloc(drv_data->priv->ndev, urb->actual_length,
 				    GFP_ATOMIC);
 		if (!skb) {
@@ -296,7 +297,6 @@ static void nfcmrvl_waker(struct work_struct *work)
 static int nfcmrvl_probe(struct usb_interface *intf,
 			 const struct usb_device_id *id)
 {
-	struct usb_endpoint_descriptor *ep_desc;
 	struct nfcmrvl_usb_drv_data *drv_data;
 	struct nfcmrvl_private *priv;
 	int i;
@@ -314,6 +314,8 @@ static int nfcmrvl_probe(struct usb_interface *intf,
 		return -ENOMEM;
 
 	for (i = 0; i < intf->cur_altsetting->desc.bNumEndpoints; i++) {
+		struct usb_endpoint_descriptor *ep_desc;
+
 		ep_desc = &intf->cur_altsetting->endpoint[i].desc;
 
 		if (!drv_data->bulk_tx_ep &&
-- 
2.27.0

