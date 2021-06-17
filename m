Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43AB43ABF08
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 00:38:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232691AbhFQWkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 18:40:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231617AbhFQWkP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 18:40:15 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BD0AC061760;
        Thu, 17 Jun 2021 15:38:07 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id h12so6185565pfe.2;
        Thu, 17 Jun 2021 15:38:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=9p230PT0VwRcEwxqxQuqXJx7HHDnXHNrxCP/OPwqSbo=;
        b=ryDam/OKuPPVjk5EBuA+gOuxhPWRKZBPC2bcm0FuipR4ulI4evXJmTEqLhbeG2Cu47
         Y9pW6WGWzqbmM/yDHTzvVvOjaUwOj0XxxgymQC/U+1utzCBUc69bZQKmBDIGrvExcHhH
         8NR+KA9mg7hP1pvmGEFW0UV4ifRX/NA9PL09Gb/T7/xF0RnzD1UaNSnk0AvIlPqvHDbC
         mePO7lT4om/NCqAcoL4KVTKfO7hXMdgaXazw3uXRHHiUNI+gyBIkfJVSwRIvdzZ9zDPw
         g/Uz4lGV97Qd5tlMAGiNpaCa9XXNt1Iuv4Bwx3xBi47gXa4XFvRYiPIFR23BEtm3KR6v
         +DlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=9p230PT0VwRcEwxqxQuqXJx7HHDnXHNrxCP/OPwqSbo=;
        b=Lpz+DdS+IPgWdaD5lGA207C0bR4opYpSUNvCjb4xvkR7gFa9dEty8L1xhU2dtXiTer
         htRzioKG8vlv7CuLE75aW7ryyxwA/hQuWH8W0m6XzobjUF5KVisNYKQYob6jbBp8D6bJ
         ZdHF1ldGqLnRXa74aovcyZcWC64DRyv9z8YbIRdQYvOkMxu0RITTdv1+Ir9TvQW9gfkt
         JZPzDJe8uogXoABw/Kvw/8mWuFd2kB3YZu0taT3rzpJ0ghkXwFQMpptyosbrxGEteF4T
         4ctUVVMPoUplNx0+l6/c85L/g8Dj2G0FAKGbEkAA7Sis8k9+UiUFG7naxzJ7m9uVwacb
         fkwQ==
X-Gm-Message-State: AOAM531VQLxviTeF/BfRedc77Ny+93eUQZrYSdWeVW26dDcX/hodNRdo
        0Ur0iQab+4IWxHDpvfO54FE6tanMQfE=
X-Google-Smtp-Source: ABdhPJwtWmvUBo/UQrqi9t+Q877nHOxIZ4MDUex9T06VWUx13yCRhzYKcTYoCYnqqDx1h9h7QGLB1w==
X-Received: by 2002:a63:5442:: with SMTP id e2mr7006717pgm.365.1623969486835;
        Thu, 17 Jun 2021 15:38:06 -0700 (PDT)
Received: from xplor.waratah.dyndns.org (222-152-189-137-fibre.sparkbb.co.nz. [222.152.189.137])
        by smtp.gmail.com with ESMTPSA id z6sm6406421pgs.24.2021.06.17.15.38.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Jun 2021 15:38:06 -0700 (PDT)
Received: by xplor.waratah.dyndns.org (Postfix, from userid 1000)
        id F0B953603E0; Fri, 18 Jun 2021 10:38:02 +1200 (NZST)
From:   Michael Schmitz <schmitzmic@gmail.com>
To:     linux-m68k@vger.kernel.org, geert@linux-m68k.org
Cc:     alex@kazik.de, Michael Schmitz <schmitzmic@gmail.com>,
        netdev@vger.kernel.org
Subject: [PATCH net-next v4 2/2] net/8390: apne.c - add 100 Mbit support to apne.c driver
Date:   Fri, 18 Jun 2021 10:37:59 +1200
Message-Id: <1623969479-29657-3-git-send-email-schmitzmic@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1623969479-29657-1-git-send-email-schmitzmic@gmail.com>
References: <1623969479-29657-1-git-send-email-schmitzmic@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add Kconfig option, module parameter and PCMCIA reset code
required to support 100 Mbit PCMCIA ethernet cards on Amiga.

10 Mbit and 100 Mbit mode are supported by the same module.
A module parameter switches Amiga ISA IO accessors to word
access by changing isa_type at runtime. Additional code to
reset the PCMCIA hardware is also added to the driver probe.

Patch modified after patch "[PATCH RFC net-next] Amiga PCMCIA
100 MBit card support" submitted to netdev 2018/09/16 by Alex
Kazik <alex@kazik.de>.

CC: netdev@vger.kernel.org
Link: https://lore.kernel.org/r/1622958877-2026-1-git-send-email-schmitzmic@gmail.com
Tested-by: Alex Kazik <alex@kazik.de>
Signed-off-by: Michael Schmitz <schmitzmic@gmail.com>

--
Changes from v3:

- change module parameter name to match Kconfig help

Finn Thain:
- fix coding style in new card reset code block
- allow reset of isa_type by module parameter

Changes from v1:

- fix module parameter name in Kconfig help text

Alex Kazik:
- change module parameter type to bool, fix module parameter
  permission

Changes from RFC:

Geert Uytterhoeven:
- change APNE_100MBIT to depend on APNE
- change '---help---' to 'help' (former no longer supported)
- fix whitespace errors
- fix module_param_named() arg count
- protect all added code by #ifdef CONFIG_APNE_100MBIT
---
 drivers/net/ethernet/8390/Kconfig | 12 ++++++++++++
 drivers/net/ethernet/8390/apne.c  | 25 +++++++++++++++++++++++++
 2 files changed, 37 insertions(+)

diff --git a/drivers/net/ethernet/8390/Kconfig b/drivers/net/ethernet/8390/Kconfig
index 9f4b302..6e4db63 100644
--- a/drivers/net/ethernet/8390/Kconfig
+++ b/drivers/net/ethernet/8390/Kconfig
@@ -143,6 +143,18 @@ config APNE
 	  To compile this driver as a module, choose M here: the module
 	  will be called apne.
 
+config APNE100MBIT
+	bool "PCMCIA NE2000 100MBit support"
+	depends on APNE
+	default n
+	help
+	  This changes the driver to support 10/100Mbit cards (e.g. Netgear
+	  FA411, CNet Singlepoint). 10 MBit cards and 100 MBit cards are
+	  supported by the same driver.
+
+	  To activate 100 Mbit support at runtime or from the kernel
+	  command line, use the apne.100mbit module parameter.
+
 config PCMCIA_PCNET
 	tristate "NE2000 compatible PCMCIA support"
 	depends on PCMCIA
diff --git a/drivers/net/ethernet/8390/apne.c b/drivers/net/ethernet/8390/apne.c
index fe6c834..d294f0c 100644
--- a/drivers/net/ethernet/8390/apne.c
+++ b/drivers/net/ethernet/8390/apne.c
@@ -120,6 +120,12 @@ static u32 apne_msg_enable;
 module_param_named(msg_enable, apne_msg_enable, uint, 0444);
 MODULE_PARM_DESC(msg_enable, "Debug message level (see linux/netdevice.h for bitmap)");
 
+#ifdef CONFIG_APNE100MBIT
+static bool apne_100_mbit;
+module_param_named(100_mbit, apne_100_mbit, bool, 0444);
+MODULE_PARM_DESC(100_mbit, "Enable 100 Mbit support");
+#endif
+
 struct net_device * __init apne_probe(int unit)
 {
 	struct net_device *dev;
@@ -139,6 +145,13 @@ struct net_device * __init apne_probe(int unit)
 	if ( !(AMIGAHW_PRESENT(PCMCIA)) )
 		return ERR_PTR(-ENODEV);
 
+#ifdef CONFIG_APNE100MBIT
+	if (apne_100_mbit)
+		isa_type = ISA_TYPE_AG16;
+	else
+		isa_type = ISA_TYPE_AG;
+#endif
+
 	pr_info("Looking for PCMCIA ethernet card : ");
 
 	/* check if a card is inserted */
@@ -590,6 +603,18 @@ static int init_pcmcia(void)
 #endif
 	u_long offset;
 
+#ifdef CONFIG_APNE100MBIT
+	/* reset card (idea taken from CardReset by Artur Pogoda) */
+	{
+		u_char  tmp = gayle.intreq;
+
+		gayle.intreq = 0xff;
+		mdelay(1);
+		gayle.intreq = tmp;
+		mdelay(300);
+	}
+#endif
+
 	pcmcia_reset();
 	pcmcia_program_voltage(PCMCIA_0V);
 	pcmcia_access_speed(PCMCIA_SPEED_250NS);
-- 
2.7.4

