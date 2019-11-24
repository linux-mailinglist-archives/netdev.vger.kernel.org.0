Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5101B1082AA
	for <lists+netdev@lfdr.de>; Sun, 24 Nov 2019 10:43:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726994AbfKXJn2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Nov 2019 04:43:28 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:35241 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726792AbfKXJn0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Nov 2019 04:43:26 -0500
Received: by mail-pj1-f65.google.com with SMTP id s8so5106499pji.2;
        Sun, 24 Nov 2019 01:43:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=e4HNvCgeIsWWXZD/Eb73dwrTgcSGPA1KF9adoLiVXgQ=;
        b=RX0LhMW0c34hZGGERWZdBTSwJLJJLYhk8AMFtl2DdGL3cMAd7SKwDMHT8u/cHh0BlD
         49ujQVAeHoTVjwjEg7+JsYcLPh6gXUApIWpTecrRZAuBUjltNiKkGPDxpFj39tiTPok4
         WXsUdaNlAsQwcooR+Gg0Aq0M/rNXZ1shMQzstKLCStpGlsrdPMFF3cpB76i2IxWIN8UZ
         knhbcdBLXpHOIpY7qY46j3/sfEOkhLCIU6xAu+ecvQdR2VA2bJP0ZUJ1q1r9oUh4ORJy
         9Ci32TDpY7Excyx21/duoxiUV4ypov4V9Tb1+DsZEsUM+WBAL40/xTPXXxCKOTJZ693f
         vNdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=e4HNvCgeIsWWXZD/Eb73dwrTgcSGPA1KF9adoLiVXgQ=;
        b=YsbPl52qS0w5HZMfcKdr7wATs/Pi5znBDelaiidVbDG3Ye81VxU5ntI6NfMLo9TgnB
         zJO3WKsn6QyiNpOQIpzbwTqNVhe0S4gOHYh+TsHzZzEcYyaMgsP5b1uj7SUVRs5a4O4a
         sRyVh+52xKcYMm2Y0cVfcosmlPQDCRO8HxczYZ8jE/j6yW0R1lIGvXb2MaVXLYI54tJB
         LZRgh/NFhRnigtoJN1Jqw49ue1qlBK7peKcelRRycbf6I5BroorlcIOBs1hAq0riRGwD
         /UWi0DJROslBQqyVW9WyJQmEPG3QHI/1jZI8jYsPKO8f2Cr/1284nPK4q1zuDaHC++HZ
         k7Rg==
X-Gm-Message-State: APjAAAVmTSaPEf067fK3iKWVh8bpjzHM9KSIo5TVAhP7MR7Ke4zU7h8U
        QlgRjFXaRpn0mtoRkHUrj18=
X-Google-Smtp-Source: APXvYqw3R6TUZ4frJfO7zIs+k7QvzozCY9KnMn0pk5y5hemv7TyHcSNwnQY0dSTIac90wNDxouqt6A==
X-Received: by 2002:a17:90a:e28a:: with SMTP id d10mr32053918pjz.116.1574588605847;
        Sun, 24 Nov 2019 01:43:25 -0800 (PST)
Received: from debian.net.fpt ([2405:4800:58f7:550c:6dad:1b5f:afc6:7758])
        by smtp.gmail.com with ESMTPSA id c3sm4091213pfi.91.2019.11.24.01.43.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Nov 2019 01:43:25 -0800 (PST)
From:   Phong Tran <tranmanphong@gmail.com>
To:     davem@davemloft.net, keescook@chromium.org
Cc:     kvalo@codeaurora.org, saeedm@mellanox.com,
        jeffrey.t.kirsher@intel.com, luciano.coelho@intel.com,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Phong Tran <tranmanphong@gmail.com>
Subject: [PATCH 2/5] drivers: net: usbnet: Fix -Wcast-function-type
Date:   Sun, 24 Nov 2019 16:43:03 +0700
Message-Id: <20191124094306.21297-3-tranmanphong@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191124094306.21297-1-tranmanphong@gmail.com>
References: <20191124094306.21297-1-tranmanphong@gmail.com>
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
 drivers/net/usb/usbnet.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index dde05e2fdc3e..d10a5e6d0917 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -1573,6 +1573,12 @@ static void usbnet_bh (struct timer_list *t)
 	}
 }
 
+static void usbnet_bh_tasklet (unsigned long data)
+{
+	struct timer_list *t = (struct timer_list *)data;
+	usbnet_bh(t);
+}
+
 
 /*-------------------------------------------------------------------------
  *
@@ -1700,7 +1706,7 @@ usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
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

