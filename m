Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE767C934A
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 23:10:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729316AbfJBVKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 17:10:20 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:32774 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728055AbfJBVKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 17:10:19 -0400
Received: by mail-pg1-f193.google.com with SMTP id q1so362028pgb.0
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 14:10:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VU7lDjXw814MQ0DeTMyHn/kUA4iHgoSaznCrLWxr/sg=;
        b=OVXCaVEkIktkYP/4+fONxdKP+c0SAXDOyM0DtLY9KlPQrKBJ6YMGkW21hqeIYVarZP
         WRP9jLlTt+W+kda5v9FL1fVVn6GmUSMRXo/LP0hfPanw9q/O2FAosJ9XqcovOCAHGVx/
         /MOmBeybmzbZRa7gDqP9zZuYeeLlB/qFwUbPY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VU7lDjXw814MQ0DeTMyHn/kUA4iHgoSaznCrLWxr/sg=;
        b=r0dZtC56v7fDsmXXmVuoRoulyuOUdz+RARSsvSs6ptb1I/9YRxv3sVW8b2EgpitQZA
         lKdttcsECxFkv23L/M7H6Y/3eyq0xWtU316xgDLz1deE4ZYaynOPNn7yKY2ZxuQ+a66y
         Or0+wsbnLwl02DQv/KFdjWIp/A9JRv0c4mPETqdMDolYfRiHGWgpFzE2MTdITdHRm44o
         rjEASGo3HGURE48JPt2aXY+PElnAiFhwTpIb42NrUgQT11B8cKQc0vNRnZNHfMup5QJA
         9pnmAL9QI8v5goz9fjQzAQkNsXovCLleVjGy8uYPHvvxia+pFswL8vh7eJ8W37mLnybf
         06tg==
X-Gm-Message-State: APjAAAW/2rT3N6P6c71uEfutxJPOF/UCfnIOHlOW8/2PrwwoMkqQK0L5
        OyRdtoyiXmrJiDAcLet1DexWGA==
X-Google-Smtp-Source: APXvYqxb/yNHsZJ26wb8HWkWwq8MSaX6c8e2gs7BDqn+QWQU0kyJgAx1ZYU0JUA+WnZUJl1m0lWDcQ==
X-Received: by 2002:a62:7d81:: with SMTP id y123mr7034233pfc.133.1570050619153;
        Wed, 02 Oct 2019 14:10:19 -0700 (PDT)
Received: from pmalani2.mtv.corp.google.com ([2620:15c:202:201:172e:4646:c089:ce59])
        by smtp.gmail.com with ESMTPSA id w6sm400684pfj.17.2019.10.02.14.10.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2019 14:10:18 -0700 (PDT)
From:   Prashant Malani <pmalani@chromium.org>
To:     hayeswang@realtek.com
Cc:     grundler@chromium.org, netdev@vger.kernel.org,
        nic_swsd@realtek.com, Prashant Malani <pmalani@chromium.org>
Subject: [PATCH net-next] r8152: Add identifier names for function pointers
Date:   Wed,  2 Oct 2019 14:09:33 -0700
Message-Id: <20191002210933.122122-1-pmalani@chromium.org>
X-Mailer: git-send-email 2.23.0.581.g78d2f28ef7-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Checkpatch throws warnings for function pointer declarations which lack
identifier names.

An example of such a warning is:

WARNING: function definition argument 'struct r8152 *' should
also have an identifier name
739: FILE: drivers/net/usb/r8152.c:739:
+               void (*init)(struct r8152 *);

So, fix those warnings by adding the identifier names.

While we are at it, also fix a character limit violation which was
causing another checkpatch warning.

Change-Id: Idec857ce2dc9592caf3173188be1660052c052ce
Signed-off-by: Prashant Malani <pmalani@chromium.org>
Reviewed-by: Grant Grundler <grundler@chromium.org>
---
 drivers/net/usb/r8152.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 08726090570e1..d2688c80968a5 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -736,16 +736,16 @@ struct r8152 {
 	struct tasklet_struct tx_tl;
 
 	struct rtl_ops {
-		void (*init)(struct r8152 *);
-		int (*enable)(struct r8152 *);
-		void (*disable)(struct r8152 *);
-		void (*up)(struct r8152 *);
-		void (*down)(struct r8152 *);
-		void (*unload)(struct r8152 *);
-		int (*eee_get)(struct r8152 *, struct ethtool_eee *);
-		int (*eee_set)(struct r8152 *, struct ethtool_eee *);
-		bool (*in_nway)(struct r8152 *);
-		void (*hw_phy_cfg)(struct r8152 *);
+		void (*init)(struct r8152 *tp);
+		int (*enable)(struct r8152 *tp);
+		void (*disable)(struct r8152 *tp);
+		void (*up)(struct r8152 *tp);
+		void (*down)(struct r8152 *tp);
+		void (*unload)(struct r8152 *tp);
+		int (*eee_get)(struct r8152 *tp, struct ethtool_eee *eee);
+		int (*eee_set)(struct r8152 *tp, struct ethtool_eee *eee);
+		bool (*in_nway)(struct r8152 *tp);
+		void (*hw_phy_cfg)(struct r8152 *tp);
 		void (*autosuspend_en)(struct r8152 *tp, bool enable);
 	} rtl_ops;
 
@@ -5634,7 +5634,8 @@ static int rtl8152_probe(struct usb_interface *intf,
 	}
 
 	if (le16_to_cpu(udev->descriptor.bcdDevice) == 0x3011 && udev->serial &&
-	    (!strcmp(udev->serial, "000001000000") || !strcmp(udev->serial, "000002000000"))) {
+	    (!strcmp(udev->serial, "000001000000") ||
+	     !strcmp(udev->serial, "000002000000"))) {
 		dev_info(&udev->dev, "Dell TB16 Dock, disable RX aggregation");
 		set_bit(DELL_TB_RX_AGG_BUG, &tp->flags);
 	}
-- 
2.23.0.581.g78d2f28ef7-goog

