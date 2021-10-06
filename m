Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ECE1424A30
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 00:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239871AbhJFWvO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 18:51:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239847AbhJFWtl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 18:49:41 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE7E4C061755;
        Wed,  6 Oct 2021 15:47:48 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id x27so16692993lfu.5;
        Wed, 06 Oct 2021 15:47:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=x5tSavxkXnnQNIK+SRykXE36yWwG8532iIutwv16QZo=;
        b=SbG6MBVHc1y1eFW0qCtMKVE3iFEejABSEVxjX+bj+YeNbMSJA7TH/IMaMUR3qtbUTW
         mzseDec+Kz2KVobYtB4Z4S0U3bHORhTo1X+Qcoaro0G9wSgewBYUFjwvMITuugo6Holg
         yPYQMnRky7EoYPru5wGqKwMjhwf+O25w0isXxCyCt1KnKkmIQWKveIdm0Wr8w3hfUDyt
         jgvIhcmnUiAc6p0Oxe41NfSJjkwr+L/XBOwZiW4WNey+JW/92yDWin3dr0esMDkKV7Ej
         eq2j6Jf42odYtw87wwRkSnqzkahoXIPm6SflXGtUxg9Fb+Bv6h+msQshk81h7Gq/3uar
         9ovQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=x5tSavxkXnnQNIK+SRykXE36yWwG8532iIutwv16QZo=;
        b=KR1b4PR88jepjxjXmbZ9bzCSU0yD7i2qbe0ZtcpJ54GCJ9Vk+189e66EaF1vN87ZNG
         8jUMYTDOOGSF6ln5Hnm8XKp1U4F5r5nG6zs2lVXLWjXnoa7yd94g3AkEDdQS0Q1ybmlX
         K/I43ztuYxVU3QEgEQSvb1XVgRrOzE+6W/HLbIJ1RKerfsilZAq43VuInMO4AhQUliFK
         6QJT2HTPorxwJ81q9yrhcUcm/s3pWM+aO71KMpVTobFYoXOnyYfPYUuDfqWpGGHKZTJg
         BeJl/mCJ4duhGcHgvt4ln8WO4SVbt2XEHdVwoIomRrJPLFE9MRpKzCcwBCZUUTdAbFQU
         T9gw==
X-Gm-Message-State: AOAM5301UcOJWRt2w4SiXaoT9qWfTiEZyxEbfVEFgtJbK0z9VFFkG9RV
        Png7mkxKSURYiEbuc3Hy/Zc=
X-Google-Smtp-Source: ABdhPJxBXp4+p5NNkhsrVsgzNyMePehATcCjbUKLGgNJi67lvuz5tZtdUwqE9FGsrmDcSsiGo/N3Zg==
X-Received: by 2002:a2e:a595:: with SMTP id m21mr804936ljp.51.1633560467198;
        Wed, 06 Oct 2021 15:47:47 -0700 (PDT)
Received: from localhost.localdomain (h-155-4-129-96.NA.cust.bahnhof.se. [155.4.129.96])
        by smtp.gmail.com with ESMTPSA id p16sm2432052lji.75.2021.10.06.15.47.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 15:47:46 -0700 (PDT)
From:   Rikard Falkeborn <rikard.falkeborn@gmail.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-nfc@lists.01.org,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>
Subject: [PATCH 2/2] nfc: pn533: Constify pn533_phy_ops
Date:   Thu,  7 Oct 2021 00:47:38 +0200
Message-Id: <20211006224738.51354-3-rikard.falkeborn@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211006224738.51354-1-rikard.falkeborn@gmail.com>
References: <20211006224738.51354-1-rikard.falkeborn@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Neither the driver or the core modifies the pn533_phy_ops struct, so
make them const to allow the compiler to put the static structs in
read-only memory.

Signed-off-by: Rikard Falkeborn <rikard.falkeborn@gmail.com>
---
 drivers/nfc/pn533/i2c.c   | 2 +-
 drivers/nfc/pn533/pn533.c | 2 +-
 drivers/nfc/pn533/pn533.h | 4 ++--
 drivers/nfc/pn533/uart.c  | 2 +-
 drivers/nfc/pn533/usb.c   | 2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/nfc/pn533/i2c.c b/drivers/nfc/pn533/i2c.c
index f5610b6b9894..673eb5e9b887 100644
--- a/drivers/nfc/pn533/i2c.c
+++ b/drivers/nfc/pn533/i2c.c
@@ -156,7 +156,7 @@ static irqreturn_t pn533_i2c_irq_thread_fn(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
-static struct pn533_phy_ops i2c_phy_ops = {
+static const struct pn533_phy_ops i2c_phy_ops = {
 	.send_frame = pn533_i2c_send_frame,
 	.send_ack = pn533_i2c_send_ack,
 	.abort_cmd = pn533_i2c_abort_cmd,
diff --git a/drivers/nfc/pn533/pn533.c b/drivers/nfc/pn533/pn533.c
index da180335422c..787bcbd290f7 100644
--- a/drivers/nfc/pn533/pn533.c
+++ b/drivers/nfc/pn533/pn533.c
@@ -2733,7 +2733,7 @@ EXPORT_SYMBOL_GPL(pn533_finalize_setup);
 struct pn533 *pn53x_common_init(u32 device_type,
 				enum pn533_protocol_type protocol_type,
 				void *phy,
-				struct pn533_phy_ops *phy_ops,
+				const struct pn533_phy_ops *phy_ops,
 				struct pn533_frame_ops *fops,
 				struct device *dev)
 {
diff --git a/drivers/nfc/pn533/pn533.h b/drivers/nfc/pn533/pn533.h
index 5f94f38a2a08..09e35b8693f5 100644
--- a/drivers/nfc/pn533/pn533.h
+++ b/drivers/nfc/pn533/pn533.h
@@ -177,7 +177,7 @@ struct pn533 {
 
 	struct device *dev;
 	void *phy;
-	struct pn533_phy_ops *phy_ops;
+	const struct pn533_phy_ops *phy_ops;
 };
 
 typedef int (*pn533_send_async_complete_t) (struct pn533 *dev, void *arg,
@@ -232,7 +232,7 @@ struct pn533_phy_ops {
 struct pn533 *pn53x_common_init(u32 device_type,
 				enum pn533_protocol_type protocol_type,
 				void *phy,
-				struct pn533_phy_ops *phy_ops,
+				const struct pn533_phy_ops *phy_ops,
 				struct pn533_frame_ops *fops,
 				struct device *dev);
 
diff --git a/drivers/nfc/pn533/uart.c b/drivers/nfc/pn533/uart.c
index 77bb073f031a..2caf997f9bc9 100644
--- a/drivers/nfc/pn533/uart.c
+++ b/drivers/nfc/pn533/uart.c
@@ -123,7 +123,7 @@ static int pn532_dev_down(struct pn533 *dev)
 	return 0;
 }
 
-static struct pn533_phy_ops uart_phy_ops = {
+static const struct pn533_phy_ops uart_phy_ops = {
 	.send_frame = pn532_uart_send_frame,
 	.send_ack = pn532_uart_send_ack,
 	.abort_cmd = pn532_uart_abort_cmd,
diff --git a/drivers/nfc/pn533/usb.c b/drivers/nfc/pn533/usb.c
index bd7f7478d189..6f71ac72012e 100644
--- a/drivers/nfc/pn533/usb.c
+++ b/drivers/nfc/pn533/usb.c
@@ -429,7 +429,7 @@ static void pn533_send_complete(struct urb *urb)
 	}
 }
 
-static struct pn533_phy_ops usb_phy_ops = {
+static const struct pn533_phy_ops usb_phy_ops = {
 	.send_frame = pn533_usb_send_frame,
 	.send_ack = pn533_usb_send_ack,
 	.abort_cmd = pn533_usb_abort_cmd,
-- 
2.33.0

