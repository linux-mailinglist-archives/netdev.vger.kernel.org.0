Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9BF6109FA4
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 14:54:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728090AbfKZNyh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 08:54:37 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:44035 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727374AbfKZNyg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 08:54:36 -0500
Received: by mail-pj1-f65.google.com with SMTP id w8so8322509pjh.11;
        Tue, 26 Nov 2019 05:54:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7z4jzenWhd0UApMYWS0PPwEvZ4lV+LKdoL7sPLRETfg=;
        b=rwa38Tt5sE2SwqbB2LxzonQx7Dr4BlBhg2zTHHQ9R2novDl3ns4Kr5O5ZiSxl7IHw+
         JxW/1unXoSU0s+ecxGRYNBDAR7zo9FPsKFiu3iRoteOtKtpkm48TitALEbta97EvzHYX
         rTLKBc/AmAk84u6/J+MswbfozOY01grnkbgJCXwnS54Qmk5JWcwOAyx6yg9RMJzh1n/N
         vNOxGYmeCNbPY6C/D2VVGKbNH7syGSY5nGGRmkbhWV2pcLIgSg+dNN/fWcRXRKzPvqjY
         HXPLtpJqkXZ0/n5AbhfYHxJaRmnFPOM/YnPkwpmEBKzatmmnmxmsWPigv5I74ApjMeD1
         z6vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7z4jzenWhd0UApMYWS0PPwEvZ4lV+LKdoL7sPLRETfg=;
        b=uH+wre1Hj8QrH7O8HOvmgwNKpRUYYVzE5wbfg6KidsFf6Oex6pGoNayIcUKK6sUDXC
         ZzoV4TFRi0sFiO1Xs3EuiJByRt+v5SzxIe1dCwwGNgkTGHJDTJV3q0A07VGVQplzOaqd
         uBHQ+ua2l7JcOvsCAev0+H7J92N2ZfaPrJSA+dZ0usipyJo80CWCU0m1UlbXt+QrHQY8
         YLAhuWvpAbFPMnv7FSaRG1qPX/kzvszqahcP6ejTJRpCID1dq3dZwtw8WKu9wppPJTRW
         7kIz5KfULV9XgJqK08nm+xHnapi3YtTnUvU5C5Rxr2fjtCopebnfIiIOxC/oIIHg7f7C
         fe4A==
X-Gm-Message-State: APjAAAUtUC8t0PFUq3w2MK5trtyPvaV6uKCwWzrXb/pWNUeAQ2MuSfVW
        J76MooNwgXUDkLgYUjVtP4E=
X-Google-Smtp-Source: APXvYqz3dLRYqY9DA8JuhOo9VI1HldHEbKnZGcH7/gkoUYh514c7/QqpY2S0OSRx/zKKAUrHUSEcLg==
X-Received: by 2002:a17:90a:a616:: with SMTP id c22mr7240491pjq.46.1574776474943;
        Tue, 26 Nov 2019 05:54:34 -0800 (PST)
Received: from debian.net.fpt ([2405:4800:58f7:2f79:ce3b:4b9:a68f:959f])
        by smtp.gmail.com with ESMTPSA id v3sm13018499pfi.26.2019.11.26.05.54.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 05:54:34 -0800 (PST)
From:   Phong Tran <tranmanphong@gmail.com>
To:     davem@davemloft.net
Cc:     alexios.zavras@intel.com, allison@lohutok.net, benquike@gmail.com,
        gregkh@linuxfoundation.org, johan@kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, oneukum@suse.com, tglx@linutronix.de,
        tranmanphong@gmail.com
Subject: [Patch v2 2/2] net: usbnet: Fix -Wcast-function-type
Date:   Tue, 26 Nov 2019 20:54:13 +0700
Message-Id: <20191126135413.19929-3-tranmanphong@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191126135413.19929-1-tranmanphong@gmail.com>
References: <20191125.110708.76766634808358006.davem@davemloft.net>
 <20191126135413.19929-1-tranmanphong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

correct usage prototype of callback in tasklet_init().
Report by https://github.com/KSPP/linux/issues/20

Signed-off-by: Phong Tran <tranmanphong@gmail.com>
---
 drivers/net/usb/usbnet.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index dde05e2fdc3e..30e511c2c8d0 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -1573,6 +1573,13 @@ static void usbnet_bh (struct timer_list *t)
 	}
 }
 
+static void usbnet_bh_tasklet(unsigned long data)
+{
+	struct timer_list *t = (struct timer_list *)data;
+
+	usbnet_bh(t);
+}
+
 
 /*-------------------------------------------------------------------------
  *
@@ -1700,7 +1707,7 @@ usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
 	skb_queue_head_init (&dev->txq);
 	skb_queue_head_init (&dev->done);
 	skb_queue_head_init(&dev->rxq_pause);
-	dev->bh.func = (void (*)(unsigned long))usbnet_bh;
+	dev->bh.func = usbnet_bh_tasklet;
 	dev->bh.data = (unsigned long)&dev->delay;
 	INIT_WORK (&dev->kevent, usbnet_deferred_kevent);
 	init_usb_anchor(&dev->deferred);
-- 
2.20.1

