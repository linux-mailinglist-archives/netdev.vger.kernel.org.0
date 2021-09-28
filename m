Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA0C341A92D
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 08:59:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239136AbhI1HAy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 03:00:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239125AbhI1HAs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 03:00:48 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D760C061604;
        Mon, 27 Sep 2021 23:59:09 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id s11so20149287pgr.11;
        Mon, 27 Sep 2021 23:59:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=rB5ViCOzEE2Xa9uSqRfylCMGhvfsfQ80A7DvZwI1S28=;
        b=nj52mrxpqNqOif05A2VEPmQwSsUdBbC6ERfCDJeo1wC73DA5L3h5Gyavyu89WuQQA7
         GrXFRhbfZtACt5OMpC9ZKaxmTrczVxKmkRMm9a0lIQnEAzrPOd6QLbJSG6d0aW+x+QKt
         8Uwq/wiwK3e+bZLvXXqVW8kN1XsX0w9bEoU5z5iOSZoZRfxVbK75oRidke9TpV6O/737
         dlv8zTkYhJt80XQY2tPH0KzybVCYoi7xSxHDbqlKIZ73LKl8BQBSqSv58V7xckrK4gWE
         SCvIwhxR9p4PdQouO/ij+mrt2UNYGPaOXhAiHfuIzet7yQhrU4WqsvivP4r9PnmP2WN3
         VB3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=rB5ViCOzEE2Xa9uSqRfylCMGhvfsfQ80A7DvZwI1S28=;
        b=V+sB6wb5NCEaA4v6aQxL1njv4vZ6CQb2UuWXqWOfe7YocjLZHGaP8Kjg3kCgZXIMc+
         gRCiOrNQX0FafVYlCUfrKRRj53vJWQpjM0NXTxizopDOriV/y5D3Y6M6WEriIbqLWmvN
         f7MFH29n9nMq8UFGUgp58snEEwHpEUlb7BHvTKSaY70KFPKHbn0CU0+lR2s5JueK04vs
         7p00staOMf4Rfkxr3gtnRKMcW5LevlITo3ZP2QE6Hfax2+GnJfM3NDONoNjkdESl2ur5
         xh20q6//6Prwsox42ZxP6QA++MAWCRvNdlYJ+CJqCIY0onlJ0Z5ZWXafp5u+knOCJiXY
         EVuA==
X-Gm-Message-State: AOAM531GQg5ByC1MMRlIm/B9SONZ+PIjek/XM1tG3SvLW/WV0/GVul3U
        pUGTCXoqZJjTLbY4VKrpQTs=
X-Google-Smtp-Source: ABdhPJxqim03NkUJjOx5q8YW4/WexvtpgVagPkFQLhF6lIihyBvbFiIMp//D1xDlwSfrLeese9W1Og==
X-Received: by 2002:a63:4c0e:: with SMTP id z14mr3181447pga.427.1632812348812;
        Mon, 27 Sep 2021 23:59:08 -0700 (PDT)
Received: from xplor.waratah.dyndns.org (222-155-4-20-adsl.sparkbb.co.nz. [222.155.4.20])
        by smtp.gmail.com with ESMTPSA id b17sm20352152pgl.61.2021.09.27.23.59.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Sep 2021 23:59:08 -0700 (PDT)
Received: by xplor.waratah.dyndns.org (Postfix, from userid 1000)
        id 1E4FE36042A; Tue, 28 Sep 2021 19:59:05 +1300 (NZDT)
From:   Michael Schmitz <schmitzmic@gmail.com>
To:     linux-m68k@vger.kernel.org, geert@linux-m68k.org
Cc:     alex@kazik.de, Michael Schmitz <schmitzmic@gmail.com>,
        netdev@vger.kernel.org
Subject: [PATCH v7 3/3] net/8390: apne.c - add 100 Mbit support to apne.c driver
Date:   Tue, 28 Sep 2021 19:57:46 +1300
Message-Id: <20210928065825.15533-4-schmitzmic@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210928065825.15533-1-schmitzmic@gmail.com>
References: <20210928065825.15533-1-schmitzmic@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add module parameter, IO mode autoprobe and PCMCIA reset code
required to support 100 Mbit PCMCIA ethernet cards on Amiga.

Select core PCMCIA support modules for use by APNE driver.

10 Mbit and 100 Mbit mode are supported by the same module.
Use the core PCMCIA cftable parser to detect 16 bit cards,
and automatically enable 16 bit ISA IO access for those cards
by changing isa_type at runtime. Code to reset the PCMCIA
hardware required for 16 bit cards is also added to the driver
probe.

An optional module parameter switches Amiga ISA IO accessors
to 8 or 16 bit access in case autoprobe fails.

Patch modified after patch "[PATCH RFC net-next] Amiga PCMCIA
100 MBit card support" submitted to netdev 2018/09/16 by Alex
Kazik <alex@kazik.de>.

CC: netdev@vger.kernel.org
Link: https://lore.kernel.org/r/1622958877-2026-1-git-send-email-schmitzmic@gmail.com
Tested-by: Alex Kazik <alex@kazik.de>
Signed-off-by: Michael Schmitz <schmitzmic@gmail.com>

--

Changes from v7:

- move 'select' for PCCARD and PCMCIA to 8390 Kconfig, so
  Amiga pcmcia.c may remain built-in while core PCMCIA
  code can be built as modules if APNE driver is a module.
- move 16 bit mode autoprobe code from amiga/pcmcia.c to this
  driver, to allow the core PCMCIA code we depend on to be
  built as modules.
- change module parameter type from bool to int to allow for
  tri-state semantics (autoprobe, 8 bit, 16 bit).

Changes from v6:

- use 16 bit mode autoprobe based on PCMCIA config table data

Changes from v5:

- move autoprobe code to new patch in this series

Geert Uytterhoeven:
- reword Kconfig help text

Finn Thain:
- style fixes, use msec_to_jiffies in timeout calc

Alex Kazik:
- revert module parameter permission change

Changes from v4:

Geert Uytterhoeven:
- remove APNE100MBIT config option, always include 16 bit support
- change module parameter permissions
- try autoprobing for 16 bit mode early on in device probe

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

change module parameter - 0 for 8 bit, 1 for 16 bit, else autoprobe
---
 drivers/net/ethernet/8390/Kconfig |  9 ++++
 drivers/net/ethernet/8390/apne.c  | 69 +++++++++++++++++++++++++++++++
 2 files changed, 78 insertions(+)

diff --git a/drivers/net/ethernet/8390/Kconfig b/drivers/net/ethernet/8390/Kconfig
index a4130e643342..b22c3cf96560 100644
--- a/drivers/net/ethernet/8390/Kconfig
+++ b/drivers/net/ethernet/8390/Kconfig
@@ -136,6 +136,8 @@ config NE2K_PCI
 config APNE
 	tristate "PCMCIA NE2000 support"
 	depends on AMIGA_PCMCIA
+	select PCCARD
+	select PCMCIA
 	select CRC32
 	help
 	  If you have a PCMCIA NE2000 compatible adapter, say Y.  Otherwise,
@@ -144,6 +146,13 @@ config APNE
 	  To compile this driver as a module, choose M here: the module
 	  will be called apne.
 
+	  The driver also supports 10/100Mbit cards (e.g. Netgear FA411,
+	  CNet Singlepoint). To activate 100 Mbit support, use the kernel
+	  option apne.100mbit=1 (builtin) at boot time, or the apne.100mbit
+	  module parameter. The driver will attempt to autoprobe 100 Mbit
+	  mode, so this option may not be necessary. Use apne.100mbit=0
+	  should autoprobe mis-detect a 100 Mbit card.
+
 config PCMCIA_PCNET
 	tristate "NE2000 compatible PCMCIA support"
 	depends on PCMCIA
diff --git a/drivers/net/ethernet/8390/apne.c b/drivers/net/ethernet/8390/apne.c
index da1ae37a9d73..115c008a129c 100644
--- a/drivers/net/ethernet/8390/apne.c
+++ b/drivers/net/ethernet/8390/apne.c
@@ -38,6 +38,7 @@
 #include <linux/etherdevice.h>
 #include <linux/interrupt.h>
 #include <linux/jiffies.h>
+#include <pcmcia/cistpl.h>
 
 #include <asm/io.h>
 #include <asm/setup.h>
@@ -87,6 +88,7 @@ static void apne_block_output(struct net_device *dev, const int count,
 static irqreturn_t apne_interrupt(int irq, void *dev_id);
 
 static int init_pcmcia(void);
+static int pcmcia_is_16bit(void);
 
 /* IO base address used for nic */
 
@@ -119,6 +121,10 @@ static u32 apne_msg_enable;
 module_param_named(msg_enable, apne_msg_enable, uint, 0444);
 MODULE_PARM_DESC(msg_enable, "Debug message level (see linux/netdevice.h for bitmap)");
 
+static u32 apne_100_mbit = -1;
+module_param_named(100_mbit, apne_100_mbit, uint, 0444);
+MODULE_PARM_DESC(100_mbit, "Enable 100 Mbit support");
+
 static struct net_device * __init apne_probe(void)
 {
 	struct net_device *dev;
@@ -140,6 +146,13 @@ static struct net_device * __init apne_probe(void)
 
 	pr_info("Looking for PCMCIA ethernet card : ");
 
+	if (apne_100_mbit == 1)
+		isa_type = ISA_TYPE_AG16;
+	else if (apne_100_mbit == 0)
+		isa_type = ISA_TYPE_AG;
+	else
+		pr_cont(" (autoprobing 16 bit mode) ");
+
 	/* check if a card is inserted */
 	if (!(PCMCIA_INSERTED)) {
 		pr_cont("NO PCMCIA card inserted\n");
@@ -167,6 +180,14 @@ static struct net_device * __init apne_probe(void)
 
 	pr_cont("ethernet PCMCIA card inserted\n");
 
+#if IS_ENABLED(CONFIG_PCMCIA)
+	if (apne_100_mbit < 0 && pcmcia_is_16bit()) {
+		pr_info("16-bit PCMCIA card detected!\n");
+		isa_type = ISA_TYPE_AG16;
+		apne_100_mbit = 1;
+	}
+#endif
+
 	if (!init_pcmcia()) {
 		/* XXX: shouldn't we re-enable irq here? */
 		free_netdev(dev);
@@ -583,6 +604,16 @@ static int init_pcmcia(void)
 #endif
 	u_long offset;
 
+	/* reset card (idea taken from CardReset by Artur Pogoda) */
+	if (isa_type == ISA_TYPE_AG16) {
+		u_char tmp = gayle.intreq;
+
+		gayle.intreq = 0xff;
+		mdelay(1);
+		gayle.intreq = tmp;
+		mdelay(300);
+	}
+
 	pcmcia_reset();
 	pcmcia_program_voltage(PCMCIA_0V);
 	pcmcia_access_speed(PCMCIA_SPEED_250NS);
@@ -616,4 +647,42 @@ static int init_pcmcia(void)
 	return 1;
 }
 
+#if IS_ENABLED(CONFIG_PCMCIA)
+static int pcmcia_is_16bit(void)
+{
+	u_char cftuple[258];
+	int cftuple_len;
+	tuple_t cftable_tuple;
+	cistpl_cftable_entry_t cftable_entry;
+
+	cftuple_len = pcmcia_copy_tuple(CISTPL_CFTABLE_ENTRY, cftuple, 256);
+	if (cftuple_len < 3)
+		return 0;
+#ifdef DEBUG
+	else
+		print_hex_dump(KERN_WARNING, "cftable: ", DUMP_PREFIX_NONE, 8,
+			       sizeof(char), cftuple, cftuple_len, false);
+#endif
+
+	/* build tuple_t struct and call pcmcia_parse_tuple */
+	cftable_tuple.DesiredTuple = CISTPL_CFTABLE_ENTRY;
+	cftable_tuple.TupleCode = CISTPL_CFTABLE_ENTRY;
+	cftable_tuple.TupleData = &cftuple[2];
+	cftable_tuple.TupleDataLen = cftuple_len - 2;
+	cftable_tuple.TupleDataMax = cftuple_len - 2;
+
+	if (pcmcia_parse_tuple(&cftable_tuple, (cisparse_t *)&cftable_entry))
+		return 0;
+
+#ifdef DEBUG
+	pr_info("IO flags: %x\n", cftable_entry.io.flags);
+#endif
+
+	if (cftable_entry.io.flags & CISTPL_IO_16BIT)
+		return 1;
+
+	return 0;
+}
+#endif
+
 MODULE_LICENSE("GPL");
-- 
2.17.1

