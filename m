Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FFAC44A56F
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 05:03:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241611AbhKIEF4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 23:05:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241554AbhKIEFz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 23:05:55 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 541C5C061766;
        Mon,  8 Nov 2021 20:03:10 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id x64so18199686pfd.6;
        Mon, 08 Nov 2021 20:03:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=kAuO5ooPU8TLNx2EW1f8fYVxvYhBxZvwhhvYKlAMheA=;
        b=mSuCI7wxuVuYQTWTj7JgFwhSn3OCda0/akQFwMBIB/ESmN5RZY0/ZzHIKFqWWobkDb
         WMpR4g3g3DhT2xAZ1BzZrczZNICGFsqu4sCqXNzIeUBsN8rPrmAawvFpQXageJkMAl3J
         Nl6lAGi/dgPvy8BXg8eyhENktuJPO5fEOl3oYVsHG3v0HoR4lfNv/dGo6L/zhMDGpjvo
         NSjB/jdZEutFZXlsbVNDYabkvcQvx9b0kLOuB0KSEk1NJgArUCBK5UDIvs3B+pnhJ4LI
         aSycIh7/g5/AIRbkFoytTuezdbZwqW+KbdxCabwOQBgWX1Q7n3Ly7ZeO1cWNE2tFjRWB
         yUig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=kAuO5ooPU8TLNx2EW1f8fYVxvYhBxZvwhhvYKlAMheA=;
        b=1oFB3i39BowlJwwuZh3nLzsXBf3pn7tyOr4Ezguen3z+fY+bf76m3x8Jng9XF9ks3v
         Y500pz0+DxSZms9JK7cnu80FpmEY1x2XElk16QLRblnUClYUSgKKHM3YlsuHPs/MPOLr
         PVNxnqE9aAqZdJaGxFEzDSP7itn8mjSF9Gtmw2E6RJ5AvKIOWy8i/r96nN5mlZQZAZ2J
         UNyEjZmPxQuq89amsTITTntvs+GOn+0hj/P1va7qDJv21U8/OS54txq2+hQFdHpW+SQx
         H7KjczTZlaGk8d4HUyS2JJVsazQ1ScJbA0hRBYRCJKytxa7M5t7ra/oQG4iqiWszDJq9
         IcOQ==
X-Gm-Message-State: AOAM532QD5oTEaacb5yJi+aU7bXRjrDn3dgCsiOpHMguGefLMaIuIKXp
        Lhgpls/UezS71PM8SjoqpIhkKaycInw=
X-Google-Smtp-Source: ABdhPJwt31lDug783W5Bu1kC1By9kWEAtVfuBJU0At5FzfaNL2YLMbs2HpjvmTiMIkGcxGjD4+OILA==
X-Received: by 2002:a05:6a00:847:b0:49f:9d3c:9b4b with SMTP id q7-20020a056a00084700b0049f9d3c9b4bmr31065204pfk.16.1636430589881;
        Mon, 08 Nov 2021 20:03:09 -0800 (PST)
Received: from xplor.waratah.dyndns.org (222-155-101-117-fibre.sparkbb.co.nz. [222.155.101.117])
        by smtp.gmail.com with ESMTPSA id v12sm788963pjs.0.2021.11.08.20.03.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Nov 2021 20:03:09 -0800 (PST)
Received: by xplor.waratah.dyndns.org (Postfix, from userid 1000)
        id D73BF36030E; Tue,  9 Nov 2021 17:03:05 +1300 (NZDT)
From:   Michael Schmitz <schmitzmic@gmail.com>
To:     linux-m68k@vger.kernel.org, geert@linux-m68k.org
Cc:     alex@kazik.de, Michael Schmitz <schmitzmic@gmail.com>,
        netdev@vger.kernel.org
Subject: [PATCH net v9 3/3] net/8390: apne.c - add 100 Mbit support to apne.c driver
Date:   Tue,  9 Nov 2021 17:02:42 +1300
Message-Id: <20211109040242.11615-4-schmitzmic@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211109040242.11615-1-schmitzmic@gmail.com>
References: <20211109040242.11615-1-schmitzmic@gmail.com>
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

Changes from v8:

Geert Uytterhoeven:
- cistpl.h definitions now provided through amipcmcia.h
- really change module parameter to (signed) int

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
 drivers/net/ethernet/8390/apne.c  | 68 +++++++++++++++++++++++++++++++
 2 files changed, 77 insertions(+)

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
index da1ae37a9d73..74dcad8563d4 100644
--- a/drivers/net/ethernet/8390/apne.c
+++ b/drivers/net/ethernet/8390/apne.c
@@ -87,6 +87,7 @@ static void apne_block_output(struct net_device *dev, const int count,
 static irqreturn_t apne_interrupt(int irq, void *dev_id);
 
 static int init_pcmcia(void);
+static int pcmcia_is_16bit(void);
 
 /* IO base address used for nic */
 
@@ -119,6 +120,10 @@ static u32 apne_msg_enable;
 module_param_named(msg_enable, apne_msg_enable, uint, 0444);
 MODULE_PARM_DESC(msg_enable, "Debug message level (see linux/netdevice.h for bitmap)");
 
+static int apne_100_mbit = -1;
+module_param_named(100_mbit, apne_100_mbit, int, 0444);
+MODULE_PARM_DESC(100_mbit, "Enable 100 Mbit support");
+
 static struct net_device * __init apne_probe(void)
 {
 	struct net_device *dev;
@@ -140,6 +145,13 @@ static struct net_device * __init apne_probe(void)
 
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
@@ -167,6 +179,14 @@ static struct net_device * __init apne_probe(void)
 
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
@@ -583,6 +603,16 @@ static int init_pcmcia(void)
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
@@ -616,4 +646,42 @@ static int init_pcmcia(void)
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

