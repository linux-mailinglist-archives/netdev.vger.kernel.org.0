Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27DA73FA84A
	for <lists+netdev@lfdr.de>; Sun, 29 Aug 2021 05:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233384AbhH2DNQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Aug 2021 23:13:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233061AbhH2DNP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Aug 2021 23:13:15 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EDCFC0613D9;
        Sat, 28 Aug 2021 20:12:24 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id r2so9862351pgl.10;
        Sat, 28 Aug 2021 20:12:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=d71jISmGCCIVKCzFqHTHchQvoA2vzoLtxdLeqOiM5fQ=;
        b=Xq+flMaguv35xN6MNO+zimEQYNw3992mFP4bmgT3nGMet9ae9oGALYwueLTJyifU7C
         4GQfG3noRx6m2AszauY558M4nt3fVSI6qVrD5zP2jXaq4o0rfUVyFvQYglIWZd8GEojo
         j73KoHuvnJnqHokc3YlK9qC7aWVlZjwX/myI7CJtLDVNxPcrPFvxiAAVRTcenNedCTTJ
         rX1ucGqxaeAKXZ6CsFqnp7mbVyiCUlfREAK/0l92EXZccQD0udoG21rl1OV8q6YLPbUW
         8WL5/JqwLdGq6SEiA7Ljfq1vNZai3W58749q1CcPuJU/HIjTBfY3DwJ95ODY4bNWA3we
         VKhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=d71jISmGCCIVKCzFqHTHchQvoA2vzoLtxdLeqOiM5fQ=;
        b=J6pKH8pHhCKvGc0Q7t4WoN2YiJi2GIDrwVayBdMqdU+Nn59PgATxpLeDj7+qL7dFGu
         DDoPKX2tcKcAyWna+8oXPoy4aV0XVLkpM9/+F0CYyhTGOu7kiIngcE1cAzC3iaSTiEky
         82UDFUUrLQUURhs3awyRzjiJmylzAs9/4PhQr8j8dA2XqPqYUVcCxOyDi8PWic2CGIi3
         f02HkvPmZ9S1skZkf2IE634lDxDp/IV4OZ0/h+ZdzbbWvjTp/aEnNbE8QKVL56tZpxU0
         pDRo7BeRZ2DUO4QyAz1ywiBx25Lfv2zMt7MGWdbL0c2pVK7k2chRsq5wo/clSDyyP9kz
         6vKw==
X-Gm-Message-State: AOAM533r70+eB+aRDZqt8dKV3V+CiDgPjDprn5I8DvyklSJIvlBtGDgo
        ND6vcsJwlTf3U0HdTJOLFzWK/2FQFA8=
X-Google-Smtp-Source: ABdhPJyi1CA67ZXmfV7C3AKWpYpLDGMG2CToFVxzuHeSoxLWheCRL62O9TzlO5IxM1vhjdZwjbrM/g==
X-Received: by 2002:a63:2d07:: with SMTP id t7mr1928365pgt.101.1630206744013;
        Sat, 28 Aug 2021 20:12:24 -0700 (PDT)
Received: from xplor.waratah.dyndns.org (222-155-6-212-adsl.sparkbb.co.nz. [222.155.6.212])
        by smtp.gmail.com with ESMTPSA id 141sm11827922pgg.16.2021.08.28.20.12.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 28 Aug 2021 20:12:23 -0700 (PDT)
Received: by xplor.waratah.dyndns.org (Postfix, from userid 1000)
        id 4DCA73603E5; Sun, 29 Aug 2021 15:12:20 +1200 (NZST)
From:   Michael Schmitz <schmitzmic@gmail.com>
To:     linux-m68k@vger.kernel.org, geert@linux-m68k.org
Cc:     alex@kazik.de, Michael Schmitz <schmitzmic@gmail.com>,
        netdev@vger.kernel.org
Subject: [PATCH net v7 4/4] net/8390: apne.c - add 100 Mbit support to apne.c driver
Date:   Sun, 29 Aug 2021 15:11:50 +1200
Message-Id: <1630206710-5954-5-git-send-email-schmitzmic@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1630206710-5954-1-git-send-email-schmitzmic@gmail.com>
References: <1630206710-5954-1-git-send-email-schmitzmic@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add module parameter, IO mode autoprobe and PCMCIA reset code
required to support 100 Mbit PCMCIA ethernet cards on Amiga.

10 Mbit and 100 Mbit mode are supported by the same module.
Use the PCMCIA cftable parser to detect 16 bit cards,
and automatically enable 16 bit ISA IO access for those cards
by changing isa_type at runtime.

An optional module parameter switches Amiga ISA IO accessors
to 16 bit access in case autoprobe fails. Code to reset the
PCMCIA hardware required for 16 bit cards is also added to
the driver probe.

Patch modified after patch "[PATCH RFC net-next] Amiga PCMCIA
100 MBit card support" submitted to netdev 2018/09/16 by Alex
Kazik <alex@kazik.de>.

CC: netdev@vger.kernel.org
Link: https://lore.kernel.org/r/1622958877-2026-1-git-send-email-schmitzmic@gmail.com
Tested-by: Alex Kazik <alex@kazik.de>
Signed-off-by: Michael Schmitz <schmitzmic@gmail.com>

--
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
 drivers/net/ethernet/8390/Kconfig |  6 ++++++
 drivers/net/ethernet/8390/apne.c  | 26 ++++++++++++++++++++++++++
 2 files changed, 32 insertions(+)

diff --git a/drivers/net/ethernet/8390/Kconfig b/drivers/net/ethernet/8390/Kconfig
index 9f4b302..270323e 100644
--- a/drivers/net/ethernet/8390/Kconfig
+++ b/drivers/net/ethernet/8390/Kconfig
@@ -143,6 +143,12 @@ config APNE
 	  To compile this driver as a module, choose M here: the module
 	  will be called apne.
 
+	  The driver also supports 10/100Mbit cards (e.g. Netgear FA411,
+	  CNet Singlepoint). To activate 100 Mbit support, use the kernel
+	  option apne.100mbit=1 (builtin) at boot time, or the apne.100mbit
+	  module parameter. The driver will attempt to autoprobe 100 Mbit
+	  mode. so this option may not be necessary.
+
 config PCMCIA_PCNET
 	tristate "NE2000 compatible PCMCIA support"
 	depends on PCMCIA
diff --git a/drivers/net/ethernet/8390/apne.c b/drivers/net/ethernet/8390/apne.c
index fe6c834..cf93b65 100644
--- a/drivers/net/ethernet/8390/apne.c
+++ b/drivers/net/ethernet/8390/apne.c
@@ -38,6 +38,7 @@
 #include <linux/etherdevice.h>
 #include <linux/interrupt.h>
 #include <linux/jiffies.h>
+#include <pcmcia/cistpl.h>
 
 #include <asm/io.h>
 #include <asm/setup.h>
@@ -120,6 +121,10 @@ static u32 apne_msg_enable;
 module_param_named(msg_enable, apne_msg_enable, uint, 0444);
 MODULE_PARM_DESC(msg_enable, "Debug message level (see linux/netdevice.h for bitmap)");
 
+static bool apne_100_mbit;
+module_param_named(100_mbit, apne_100_mbit, bool, 0444);
+MODULE_PARM_DESC(100_mbit, "Enable 100 Mbit support");
+
 struct net_device * __init apne_probe(int unit)
 {
 	struct net_device *dev;
@@ -139,6 +144,11 @@ struct net_device * __init apne_probe(int unit)
 	if ( !(AMIGAHW_PRESENT(PCMCIA)) )
 		return ERR_PTR(-ENODEV);
 
+	if (apne_100_mbit)
+		isa_type = ISA_TYPE_AG16;
+	else
+		isa_type = ISA_TYPE_AG;
+
 	pr_info("Looking for PCMCIA ethernet card : ");
 
 	/* check if a card is inserted */
@@ -172,6 +182,12 @@ struct net_device * __init apne_probe(int unit)
 
 	pr_cont("ethernet PCMCIA card inserted\n");
 
+	if (pcmcia_is_16bit()) {
+		pr_info("16-bit PCMCIA card detected!\n");
+		isa_type = ISA_TYPE_AG16;
+		apne_100_mbit = 1;
+	}
+
 	if (!init_pcmcia()) {
 		/* XXX: shouldn't we re-enable irq here? */
 		free_netdev(dev);
@@ -590,6 +606,16 @@ static int init_pcmcia(void)
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
2.7.4

