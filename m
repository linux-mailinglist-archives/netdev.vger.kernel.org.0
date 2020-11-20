Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BB762BB53B
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 20:25:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732334AbgKTTZn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 14:25:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732125AbgKTTZm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 14:25:42 -0500
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3208C0613CF;
        Fri, 20 Nov 2020 11:25:42 -0800 (PST)
Received: by mail-oi1-x242.google.com with SMTP id v202so8505840oia.9;
        Fri, 20 Nov 2020 11:25:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aTAufQ4Bma92aLC+9C3RuWuBMCw2ydbQLMQwQOeoh60=;
        b=ggN2zpRiLcBcHenNDcik0CyDHlBuEGq3AxPp5EwOJOiagrgvndemkHHQw22add85W3
         GgCtP6kfgS5y3RhzO7tnAr+W0V90IlEFn7ostRBqXebuyL8QY28lU32EAJmsx5Elm4H8
         1RMxZI0dCbCMtfrff6aizhCb51pMPsUgFQ1aTS7EN5jqjIcDBCp/pORTguBNynqtlxMm
         0x+SeOB3r7Iurew3/nQIYi0IY6jcS4zASOZVBKkoOy+p5tnFmTzHaCqa42PsH6F9IWs3
         csZXVX8YPjtreCX+qkX90AqjaE3nBHS1ZOa5QMszceSrCFRoRdJsdn8u+b75V2WDNbiC
         uBTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aTAufQ4Bma92aLC+9C3RuWuBMCw2ydbQLMQwQOeoh60=;
        b=FBsjTUGM7Z0xLE1nNd8Nqfov1JqsOPk/0tZV46CVPi2mnNsOGgIZGZNNcVQACrBrGp
         pJHwUMDJvCIYl1LR7/EoFYXZch1BFx/ES9sdgsbq9zqhKbTTnnFV1CYhIH6WCM0y5Wo7
         s77aH5uhqFba8NPDISHO1rfyBXaEbF2IMpwZl7gJV6u7xwPXTdABUxnhfCGxDjhNOeVy
         rskohzSsg3t/KfL7hObzmXig/58L/DN9tPmDtcqXh2v+PFvKuud1TKhvWrLlT1KzFxR2
         WkRWyckBDwTZQIftRhq1S0/QH9p/xgbZtMFyghUDK84qCbXyYk2T4FmCJulJezKhkpci
         hFvw==
X-Gm-Message-State: AOAM531XPiGOAEfpmoiAeNZiQbe9SA9I13wBlbKdJcn6IHgGINf/ymmg
        CMYlkuomzUpkjisS2f6eILSDRPWzklb7wg==
X-Google-Smtp-Source: ABdhPJy7OIKUfpdGLvaD8t11c9aeGnHIGQio21epQrxLYHpxQroYfvLcbt9KXSXVr93jLryv+JAwxQ==
X-Received: by 2002:a05:6808:3da:: with SMTP id o26mr7475924oie.80.1605900341929;
        Fri, 20 Nov 2020 11:25:41 -0800 (PST)
Received: from proxmox.local.lan (2603-80a0-0e01-cc2f-0226-b9ff-fe41-ba6b.res6.spectrum.com. [2603:80a0:e01:cc2f:226:b9ff:fe41:ba6b])
        by smtp.googlemail.com with ESMTPSA id o28sm1271562oie.3.2020.11.20.11.25.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2020 11:25:41 -0800 (PST)
From:   Tom Seewald <tseewald@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ayush.sawal@chelsio.com, rajur@chelsio.com,
        Tom Seewald <tseewald@gmail.com>
Subject: [PATCH] cxgb4: Fix build failure when CONFIG_TLS=m
Date:   Fri, 20 Nov 2020 13:25:28 -0600
Message-Id: <20201120192528.615-1-tseewald@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201120073502.4beeb482@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
References: <20201120073502.4beeb482@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After commit 9d2e5e9eeb59 ("cxgb4/ch_ktls: decrypted bit is not enough")
whenever CONFIG_TLS=m and CONFIG_CHELSIO_T4=y, the following build
failure occurs:

ld: drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.o: in function
`cxgb_select_queue':
cxgb4_main.c:(.text+0x2dac): undefined reference to `tls_validate_xmit_skb'

Fix this by ensuring that if TLS is set to be a module, CHELSIO_T4 will
also be compiled as a module. As otherwise the cxgb4 driver will not be
able to access TLS' symbols.

Fixes: 9d2e5e9eeb59 ("cxgb4/ch_ktls: decrypted bit is not enough")
Signed-off-by: Tom Seewald <tseewald@gmail.com>
---
 drivers/net/ethernet/chelsio/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/chelsio/Kconfig b/drivers/net/ethernet/chelsio/Kconfig
index 87cc0ef68b31..8ba0e08e5e64 100644
--- a/drivers/net/ethernet/chelsio/Kconfig
+++ b/drivers/net/ethernet/chelsio/Kconfig
@@ -68,7 +68,7 @@ config CHELSIO_T3
 
 config CHELSIO_T4
 	tristate "Chelsio Communications T4/T5/T6 Ethernet support"
-	depends on PCI && (IPV6 || IPV6=n)
+	depends on PCI && (IPV6 || IPV6=n) && (TLS || TLS=n)
 	select FW_LOADER
 	select MDIO
 	select ZLIB_DEFLATE
-- 
2.20.1

