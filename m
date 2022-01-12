Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8164F48BF6B
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 09:02:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351351AbiALICu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 03:02:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237577AbiALICq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 03:02:46 -0500
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D502BC06173F;
        Wed, 12 Jan 2022 00:02:45 -0800 (PST)
Received: by mail-qk1-x72a.google.com with SMTP id g2so1682844qkp.1;
        Wed, 12 Jan 2022 00:02:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fEPQyCI2iAGnV/flpHmxN8cgiikDpxO3IF0QpPNhHt8=;
        b=Qv8pzXgpnahAZ2tocraw2jBKKW13lGm8sSUL1rp8X9HElta0D7lWdhip9BZEbcoATb
         FK58lWytLL6bBM2TBkS2i9+T5sCUiDp2VegN5tnjchfGH3nYAVvGve0C0yV+29KwYdWo
         lln5i691UN4vUP3UApxfO99BMZYs2S/YFIUvdwskovoKL27w6UWBFYNh5QVjGNsE5pr8
         in0mhVNJsY2BHCQfM4pzbG6cStBNdaYTOp62bdx0DLg59tzQbstw0COhJBtgqaysMB0l
         D2DzalC8gfsF4QH4cZLz+NmturZ6GwU3/cU6o7HdH6CRNVbObu6sIXPX8AR0F1FzvSnZ
         iv4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fEPQyCI2iAGnV/flpHmxN8cgiikDpxO3IF0QpPNhHt8=;
        b=j1GRBUh2hlqu8YBl0HeUybv9qrjcDXU1dFdQ/bQwl14S09bYT/YtFZALRo4Y0noEpc
         D7nkdFiwzBCGnNzY1hnlLz4s6RAY9jHUeJXsSx9awsYGeCSp4TPjMSYAdHdOPqOilQWS
         XtfkZJFaLnvG9/weXuF0rX0poElUeCqvqSG0ruOD+csV9EAVFly+JeoJurt/zAZdn3rH
         omQfeTg75nv63BmKm7swdvecNJw2l2gZ02UKmaw9RJtyNE+D4DKHXhD+/CF5eWIjTRv0
         FroDLG4XLugDW5+CwSn3DZKhOFfQdYwpNzY8d8Lx1v6FKe7PmAbVJpx/htLa7YaZXnN1
         zwUg==
X-Gm-Message-State: AOAM5317ahC4WEFmIiYJuAXjsmRqeyqAkgLh9EFPf/6fKYKm5Tf0kqSM
        LBxVRiWbRl3fnJRPQXW4Yf/ie6LRKRE=
X-Google-Smtp-Source: ABdhPJwqqFZfp2eYqPdYqUcLz07ftrZhspenPI+mT+uQmPCNwVbZOaDzbJsJWJ3FWPV/wjCBNerE6w==
X-Received: by 2002:a05:620a:24c1:: with SMTP id m1mr5592354qkn.373.1641974564774;
        Wed, 12 Jan 2022 00:02:44 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id ay15sm4262587qkb.63.2022.01.12.00.02.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jan 2022 00:02:44 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     davem@davemloft.net
Cc:     kuba@kernel.org, linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>, CGEL ZTE <cgel.zte@gmail.com>
Subject: [PATCH] drivers/net/usb: remove redundant ret variable
Date:   Wed, 12 Jan 2022 08:02:38 +0000
Message-Id: <20220112080238.666933-1-chi.minghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Minghao Chi <chi.minghao@zte.com.cn>

Return value from __aqc111_write_cmd() directly instead
of taking this in another redundant variable.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
Signed-off-by: CGEL ZTE <cgel.zte@gmail.com>
---
 drivers/net/usb/aqc111.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/usb/aqc111.c b/drivers/net/usb/aqc111.c
index ea06d10e1c21..22b5d84abe3c 100644
--- a/drivers/net/usb/aqc111.c
+++ b/drivers/net/usb/aqc111.c
@@ -110,12 +110,8 @@ static int __aqc111_write_cmd(struct usbnet *dev, u8 cmd, u8 reqtype,
 static int aqc111_write_cmd_nopm(struct usbnet *dev, u8 cmd, u16 value,
 				 u16 index, u16 size, void *data)
 {
-	int ret;
-
-	ret = __aqc111_write_cmd(dev, cmd, USB_DIR_OUT | USB_TYPE_VENDOR |
+	return  __aqc111_write_cmd(dev, cmd, USB_DIR_OUT | USB_TYPE_VENDOR |
 				 USB_RECIP_DEVICE, value, index, size, data);
-
-	return ret;
 }
 
 static int aqc111_write_cmd(struct usbnet *dev, u8 cmd, u16 value,
-- 
2.25.1

