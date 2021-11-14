Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E25BD44FC7A
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 00:41:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234614AbhKNXng (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Nov 2021 18:43:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234884AbhKNXnN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Nov 2021 18:43:13 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEC8DC061746;
        Sun, 14 Nov 2021 15:40:18 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id g19so13455261pfb.8;
        Sun, 14 Nov 2021 15:40:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=09sMO+LJqbl5Sw2DVPqLyGqrmiPqa0N6paJ4QJ12P1k=;
        b=AYHT63eqgrbxMTeqWW46XtsnUN0v5Drq/uIH3nXM2moSLvpvsfH/lnoLmYefxEBuTq
         1IyQtO+/lPTkKAQAILiqk8QGQqHaweGv467lXl5Z0xAB0e13/hoRns55qJ6dxVCdX3lU
         jBvifuoUO7zZp1lQxvvR1rT72Tjmmz84SaYSYvD9WAd2WmKF5oa18z6Ii2L0OL6GkHjK
         RXAkIey6az5wEiGFbamSLAuFLfh/D4Uq+1CX32rqIjlImWOlaicxJaDEMI+ICwUcGB9g
         GKQPgXsrFaiNCHOAAbhkFa+VZcvfqwS6zUn4bWMBYCrcQpUIZUaqzKhiOffnPSvBJnxN
         pPMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=09sMO+LJqbl5Sw2DVPqLyGqrmiPqa0N6paJ4QJ12P1k=;
        b=2JPaXtVQIih/X+F9QsFIbSiXJPifgYZMtlNhCpflFYFP5ZkgRKbzxJj3xS2kcEe3OQ
         ZoczD7J8/g3fBLtue+V7AKFBypw+G/OCYv2/z+XOwRY5RnT9lzxMqIyEcbnpK2uyplL3
         D68AlBGUU2kE1QeWPFMsZ7bk2bW6tz8gC2aRrDjYPKiQDmOo4xbfzDUtuIrxCHEwDn1t
         jPJAylQdFb795LF+i8/l4YfNefCtL9RTUV7XAj6iPdmWScmLytTn/8dQpLAjSLVuz5ui
         OYJcwbsFwav7WzOjksstrDPZH6OBeqhdBXGmXK/tl/rrD6WmPTP/r5QpFUVr4Z0emE7A
         7IlQ==
X-Gm-Message-State: AOAM532rQMbZe5adb9LK6tYN2Kmd7WZJNF71b/dCdFVw9BuQmlJ73AXh
        pF2xVpBsMHJ8FR4c94nPLro=
X-Google-Smtp-Source: ABdhPJyb2ZjXCUz3qmtr0UsagmZfTKMAxAIvjiNTtrpyL83ZLZwe/EUqxKyDjJNB84sHvR3sH7WOfQ==
X-Received: by 2002:a65:6158:: with SMTP id o24mr21379416pgv.141.1636933218372;
        Sun, 14 Nov 2021 15:40:18 -0800 (PST)
Received: from xplor.waratah.dyndns.org (222-155-101-117-fibre.sparkbb.co.nz. [222.155.101.117])
        by smtp.gmail.com with ESMTPSA id d14sm9808970pgt.64.2021.11.14.15.40.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Nov 2021 15:40:17 -0800 (PST)
Received: by xplor.waratah.dyndns.org (Postfix, from userid 1000)
        id 1AFD336020A; Mon, 15 Nov 2021 12:40:14 +1300 (NZDT)
From:   Michael Schmitz <schmitzmic@gmail.com>
To:     linux-m68k@vger.kernel.org, geert@linux-m68k.org
Cc:     alex@kazik.de, Michael Schmitz <schmitzmic@gmail.com>,
        netdev@vger.kernel.org
Subject: [PATCH net v11 3/3] net/8390: apne.c - add 100 Mbit support to apne.c driver
Date:   Mon, 15 Nov 2021 12:40:05 +1300
Message-Id: <20211114234005.335-4-schmitzmic@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211114234005.335-1-schmitzmic@gmail.com>
References: <20211114234005.335-1-schmitzmic@gmail.com>
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
modules available

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
---
 drivers/net/ethernet/8390/Kconfig |  8 ++++
 drivers/net/ethernet/8390/apne.c  | 67 +++++++++++++++++++++++++++++++
 2 files changed, 75 insertions(+)

diff --git a/drivers/net/ethernet/8390/Kconfig b/drivers/net/ethernet/8390/Kconfig
index a4130e643342..c4f519a385f3 100644
--- a/drivers/net/ethernet/8390/Kconfig
+++ b/drivers/net/ethernet/8390/Kconfig
@@ -144,6 +144,14 @@ config APNE
 	  To compile this driver as a module, choose M here: the module
 	  will be called apne.
 
+	  The driver also supports 10/100Mbit cards (e.g. Netgear FA411,
+	  CNet Singlepoint). To activate 100 Mbit support, use the kernel
+	  option apne.100mbit=1 (builtin) at boot time, or the apne.100mbit
+	  module parameter. The driver can attempt to autoprobe 100 Mbit
+	  mode if the PCCARD and PCMCIA kernel configuration options are
+	  selected, so this option may not be necessary. Use apne.100mbit=0
+	  should autoprobe mis-detect a 100 Mbit card.
+
 config PCMCIA_PCNET
 	tristate "NE2000 compatible PCMCIA support"
 	depends on PCMCIA
diff --git a/drivers/net/ethernet/8390/apne.c b/drivers/net/ethernet/8390/apne.c
index da1ae37a9d73..6642e2f304b3 100644
--- a/drivers/net/ethernet/8390/apne.c
+++ b/drivers/net/ethernet/8390/apne.c
@@ -119,6 +119,48 @@ static u32 apne_msg_enable;
 module_param_named(msg_enable, apne_msg_enable, uint, 0444);
 MODULE_PARM_DESC(msg_enable, "Debug message level (see linux/netdevice.h for bitmap)");
 
+static int apne_100_mbit = -1;
+module_param_named(100_mbit, apne_100_mbit, int, 0444);
+MODULE_PARM_DESC(100_mbit, "Enable 100 Mbit support");
+
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
 static struct net_device * __init apne_probe(void)
 {
 	struct net_device *dev;
@@ -140,6 +182,13 @@ static struct net_device * __init apne_probe(void)
 
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
@@ -167,6 +216,14 @@ static struct net_device * __init apne_probe(void)
 
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
@@ -583,6 +640,16 @@ static int init_pcmcia(void)
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

