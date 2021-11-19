Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97B104569E8
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 07:06:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232972AbhKSGJw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 01:09:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232853AbhKSGJv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Nov 2021 01:09:51 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73810C061574;
        Thu, 18 Nov 2021 22:06:50 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id gt5so7144899pjb.1;
        Thu, 18 Nov 2021 22:06:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=B8WPDjGUJRE2JeDwvnKl9Yuv3HNoht+a+JZRzhwjgYM=;
        b=jyfuIOS93hRvJPy2pWBYQGz9lWWdjRV78nk2Ui3E3VnbSd9tzXthXMdhTQjt6Mq6N3
         0ICpRaoKaky9F7KlV+fDeyzNixMDu8KCh9Dntd5o6mej28nmUooXJMWuCVlAD/qQwWkn
         4Rr5eHetyL1BbdkIVYEqT+Y55jK310mTlKYOV3p6x3h+lnRBHXpSCea2Zms6cRLQhdOE
         5CgOSuZEUDfcMACz5YCQjUZcalyO5tP4V3qjVI5jcP6TE4uXHAY3X+NM9l2eiCoXdsgQ
         uiKBpLNMfCBUyY0ADf1bj4RhBrUKV6clMHc3PiDNZLAbk2h5th2zNku0wD2c25lxzhVT
         SsaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=B8WPDjGUJRE2JeDwvnKl9Yuv3HNoht+a+JZRzhwjgYM=;
        b=7Cj+wi5cB5tgwqPHEFQp4YhgywV/VzXdzh0GLstVy6ngDwPnt+DDAsct6yb5dWVeDg
         JpWnLGXpsjni8nHEOq6cotuqbO4RDeOIj936S1xFV6761ngrsFuxW2dJBoFC2Eb+0HTl
         Y47odMIhhhK+XWMarg8tRQhKMIthLQPjOdo4z/VdIOOKOOWEeIcpVhNNWm2JhUj4ELbA
         oIVnTKRDugvejVUEzLJ/7SabiVZhNejNaMx3LFRUQBYuVBrqvFhBzRsAJwMd7UYoRbax
         7kV0d4002CkbVr/LtJdv2xsi7f9JkiECjuQNmvgNAFy9tR31Nx+rcX8XR/K1o08/xcEj
         kKpA==
X-Gm-Message-State: AOAM533PK18bT1LKaFbyHhK1eiNn2HYsK0StmcgroHCKouIffKZsCVf3
        iv3T54eiOU8n/p0uBxjhl4g=
X-Google-Smtp-Source: ABdhPJw29E8Wi55EDUBTxk+TlZ+S/KNM4nO9zSuHxAPA0BiA/aOUHCKGTk5KXZq/rneDxG1uW4WppQ==
X-Received: by 2002:a17:902:82c9:b0:142:401f:dc9 with SMTP id u9-20020a17090282c900b00142401f0dc9mr74235446plz.43.1637302010002;
        Thu, 18 Nov 2021 22:06:50 -0800 (PST)
Received: from xplor.waratah.dyndns.org (222-155-101-117-fibre.sparkbb.co.nz. [222.155.101.117])
        by smtp.gmail.com with ESMTPSA id k1sm1560360pfu.31.2021.11.18.22.06.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 22:06:49 -0800 (PST)
Received: by xplor.waratah.dyndns.org (Postfix, from userid 1000)
        id 357C9360310; Fri, 19 Nov 2021 19:06:46 +1300 (NZDT)
From:   Michael Schmitz <schmitzmic@gmail.com>
To:     linux-m68k@vger.kernel.org, geert@linux-m68k.org
Cc:     alex@kazik.de, Michael Schmitz <schmitzmic@gmail.com>,
        netdev@vger.kernel.org
Subject: [PATCH net v12 3/3] net/8390: apne.c - add 100 Mbit support to apne.c driver
Date:   Fri, 19 Nov 2021 19:06:32 +1300
Message-Id: <20211119060632.8583-4-schmitzmic@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211119060632.8583-1-schmitzmic@gmail.com>
References: <20211119060632.8583-1-schmitzmic@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add module parameter, IO mode autoprobe and PCMCIA reset code
required to support 100 Mbit PCMCIA ethernet cards on Amiga.

10 Mbit and 100 Mbit mode are supported by the same module.
Use the core PCMCIA cftable parser to detect 16 bit cards,
and automatically enable 16 bit ISA IO access for those cards
by changing isa_type at runtime. The user must select PCCARD
and PCMCIA in the kernel config to make the necessary support
modules available.

Code to reset the PCMCIA hardware required for 16 bit cards is
also added to the driver probe.

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

Changes from v11:

Geert Uytterhoeven:
- use IS_REACHABLE() for PCMCIA dependent code
- use container_of() instead of cast in pcmcia_parse_tuple()
  call
- set isa_type and apne_100_mbit correctly if autoprobe fails
- reset isa_type and apne_100_mbit on module exit

Joe Perches:
- use pr_debug and co. to avoid #ifdef DEBUG

Changes from v9:

- avoid pcmcia_is_16bit() forward declaration

Randy Dunlap:
- do not select PCCARD and PCMCIA options when selecting APNE

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

set ISA_TYPE_AG if 16 bit autoprobe failed; reset to sane state on module
exit
---
 drivers/net/ethernet/8390/Kconfig |  8 +++
 drivers/net/ethernet/8390/apne.c  | 82 +++++++++++++++++++++++++++++++
 2 files changed, 90 insertions(+)

diff --git a/drivers/net/ethernet/8390/Kconfig b/drivers/net/ethernet/8390/Kconfig
index a4130e643342..24163902d139 100644
--- a/drivers/net/ethernet/8390/Kconfig
+++ b/drivers/net/ethernet/8390/Kconfig
@@ -144,6 +144,14 @@ config APNE
 	  To compile this driver as a module, choose M here: the module
 	  will be called apne.
 
+	  The driver also supports 10/100Mbit cards (e.g. Netgear FA411,
+	  CNet Singlepoint). To activate 100 Mbit support, use the kernel
+	  option apne.100mbit=1 (builtin) at boot time, or the apne.100mbit
+	  module parameter. The driver will attempt to autoprobe 100 Mbit
+	  mode if the PCCARD and PCMCIA kernel configuration options are
+	  selected, so this option may not be necessary. Use apne.100mbit=0
+	  should autoprobe mis-detect a 100 Mbit card.
+
 config PCMCIA_PCNET
 	tristate "NE2000 compatible PCMCIA support"
 	depends on PCMCIA
diff --git a/drivers/net/ethernet/8390/apne.c b/drivers/net/ethernet/8390/apne.c
index da1ae37a9d73..ed7e97bd260b 100644
--- a/drivers/net/ethernet/8390/apne.c
+++ b/drivers/net/ethernet/8390/apne.c
@@ -119,6 +119,45 @@ static u32 apne_msg_enable;
 module_param_named(msg_enable, apne_msg_enable, uint, 0444);
 MODULE_PARM_DESC(msg_enable, "Debug message level (see linux/netdevice.h for bitmap)");
 
+static int apne_100_mbit = -1;
+module_param_named(100_mbit, apne_100_mbit, int, 0444);
+MODULE_PARM_DESC(100_mbit, "Enable 100 Mbit support");
+
+#if IS_REACHABLE(CONFIG_PCMCIA)
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
+	else
+		print_hex_dump_debug("cftable: ", DUMP_PREFIX_NONE, 8,
+				sizeof(char), cftuple, cftuple_len, false);
+
+	/* build tuple_t struct and call pcmcia_parse_tuple */
+	cftable_tuple.DesiredTuple = CISTPL_CFTABLE_ENTRY;
+	cftable_tuple.TupleCode = CISTPL_CFTABLE_ENTRY;
+	cftable_tuple.TupleData = &cftuple[2];
+	cftable_tuple.TupleDataLen = cftuple_len - 2;
+	cftable_tuple.TupleDataMax = cftuple_len - 2;
+
+	if (pcmcia_parse_tuple(&cftable_tuple, container_of(&cftable_entry,
+				cisparse_t, cftable_entry)))
+		return 0;
+
+	pr_debug("IO flags: %x\n", cftable_entry.io.flags);
+
+	if (cftable_entry.io.flags & CISTPL_IO_16BIT)
+		return 1;
+
+	return 0;
+}
+#endif
+
 static struct net_device * __init apne_probe(void)
 {
 	struct net_device *dev;
@@ -140,6 +179,17 @@ static struct net_device * __init apne_probe(void)
 
 	pr_info("Looking for PCMCIA ethernet card : ");
 
+	if (apne_100_mbit == 1)
+		isa_type = ISA_TYPE_AG16;
+	else if (apne_100_mbit == 0)
+		isa_type = ISA_TYPE_AG;
+	else
+#if IS_REACHABLE(CONFIG_PCMCIA)
+		pr_cont(" (autoprobing 16 bit mode) ");
+#else
+		pr_cont(" (no 16 bit autoprobe support) ");
+#endif
+
 	/* check if a card is inserted */
 	if (!(PCMCIA_INSERTED)) {
 		pr_cont("NO PCMCIA card inserted\n");
@@ -167,6 +217,19 @@ static struct net_device * __init apne_probe(void)
 
 	pr_cont("ethernet PCMCIA card inserted\n");
 
+#if IS_REACHABLE(CONFIG_PCMCIA)
+	if (apne_100_mbit < 0) {
+		if (pcmcia_is_16bit()) {
+			pr_info("16-bit PCMCIA card detected!\n");
+			isa_type = ISA_TYPE_AG16;
+			apne_100_mbit = 1;
+		} else {
+			isa_type = ISA_TYPE_AG;
+			apne_100_mbit = 0;
+		}
+	}
+#endif
+
 	if (!init_pcmcia()) {
 		/* XXX: shouldn't we re-enable irq here? */
 		free_netdev(dev);
@@ -193,6 +256,10 @@ static struct net_device * __init apne_probe(void)
 	pcmcia_reset();
 	release_region(IOBASE, 0x20);
 	free_netdev(dev);
+#if IS_REACHABLE(CONFIG_PCMCIA)
+	isa_type = ISA_TYPE_AG;
+	apne_100_mbit = -1;
+#endif
 	return ERR_PTR(err);
 }
 
@@ -570,6 +637,11 @@ static void __exit apne_module_exit(void)
 	release_region(IOBASE, 0x20);
 
 	free_netdev(apne_dev);
+
+#if IS_REACHABLE(CONFIG_PCMCIA)
+	isa_type = ISA_TYPE_AG;
+	apne_100_mbit = -1;
+#endif
 }
 module_init(apne_module_init);
 module_exit(apne_module_exit);
@@ -583,6 +655,16 @@ static int init_pcmcia(void)
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
-- 
2.17.1

