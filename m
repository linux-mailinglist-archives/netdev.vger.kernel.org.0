Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CA893ADC11
	for <lists+netdev@lfdr.de>; Sun, 20 Jun 2021 01:24:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbhFSX05 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Jun 2021 19:26:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbhFSX0x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Jun 2021 19:26:53 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F29A9C06175F;
        Sat, 19 Jun 2021 16:24:41 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id z3-20020a17090a3983b029016bc232e40bso7998668pjb.4;
        Sat, 19 Jun 2021 16:24:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=/OxDFjyIZue4441K5bnV8O0AZvbxViOWb16xjWvcGDY=;
        b=ImhjxiU4rDRAMvBQ3mFI4q+fg8NJysZdmFB/4hhFfVextgH/9xEbwuDFna8MTzQbQE
         WMyyT6l+t63re4kPCUZLrhWopX+52ic7qc0JUpzGwLwYbz0N40w75fAORS3kK3S+4CPC
         0p2BsabsRG1yljZiBbM94nAOtlO5ZxUKp4y3ArYD8UTOPtsdeauwX4pDneJQ8z3Gfwro
         Rx5QcVVsAcRDRLD+GYS3wax8WXKw03WBZCKjXsF9AL4kLTGNSODRj6FOtP8O67LLgX3v
         Ef+3u9Rn2AaeVXn0yJNKyRKNvorMx1DcqXWH/QirMfQBKqMkVmcgWKAjtofx9bbCKmyd
         dKzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=/OxDFjyIZue4441K5bnV8O0AZvbxViOWb16xjWvcGDY=;
        b=XmHFLGxCimwyeT8eW4E2X2ulNfL/M2WZhlYq3RS47lMl1aoXzda6QZgtyC7lHuL/FH
         R/GjWX/+/DtRaGw9FeRRW8OIP09ftFZ7exJcxqj3qOjFHQ/YenPD0T1Nl1fY9v03uLa9
         PmuAt5bTdREHZPKzbJvbtNb2cmwdPlZX+AKOyfSKk5XHcj0S/zZ+6juR7GUP5lge9VR3
         7hG3r++i8pENMnMAahdLtmQDpWPNnZFQsz2a43b7vb0kLsHaxKAqK+bpafDS6mbckhCd
         hJ+x6Tk4Qe7VbhMy/M0vJ/bVZF35ZIXnigs9AP0meB6no/3rKr1/fJ2SlamprkrxkTBB
         5DKQ==
X-Gm-Message-State: AOAM531XBa63N+Hwhxoy+jWmWBYUo6srITTff4BZx7Xq7x7ia80hIGI1
        cWEi9tF482pnDKTnKqtv1RQy5Q9ad3I=
X-Google-Smtp-Source: ABdhPJyU3zjDdh0XWCIVYgYa2poXzLdl8M95TVoDHuv0I2U017n2ZK4j44blHNh6xAgeM7GuLvUtZA==
X-Received: by 2002:a17:90b:955:: with SMTP id dw21mr18440615pjb.28.1624145081483;
        Sat, 19 Jun 2021 16:24:41 -0700 (PDT)
Received: from xplor.waratah.dyndns.org (222-152-189-137-fibre.sparkbb.co.nz. [222.152.189.137])
        by smtp.gmail.com with ESMTPSA id i13sm6006844pjl.2.2021.06.19.16.24.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 19 Jun 2021 16:24:41 -0700 (PDT)
Received: by xplor.waratah.dyndns.org (Postfix, from userid 1000)
        id 2946E3603E0; Sun, 20 Jun 2021 11:24:37 +1200 (NZST)
From:   Michael Schmitz <schmitzmic@gmail.com>
To:     linux-m68k@vger.kernel.org, geert@linux-m68k.org
Cc:     alex@kazik.de, Michael Schmitz <schmitzmic@gmail.com>,
        netdev@vger.kernel.org
Subject: [PATCH netdev v6 2/3] net/8390: apne.c - add 100 Mbit support to apne.c driver
Date:   Sun, 20 Jun 2021 11:24:32 +1200
Message-Id: <1624145073-12674-3-git-send-email-schmitzmic@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1624145073-12674-1-git-send-email-schmitzmic@gmail.com>
References: <1624145073-12674-1-git-send-email-schmitzmic@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add module parameter and PCMCIA reset code required to
support 100 Mbit PCMCIA ethernet cards on Amiga.

10 Mbit and 100 Mbit mode are supported by the same module.
A module parameter switches Amiga ISA IO accessors to word
access by changing isa_type at runtime. Code to reset the
PCMCIA hardware required for 16 bit cards is also added to
the driver probe.

This patch depends on patch "m68k: io_mm.h - add APNE 100
MBit support" sent to linux-m68k, and must not be applied
before that one!

Patch modified after patch "[PATCH RFC net-next] Amiga PCMCIA
100 MBit card support" submitted to netdev 2018/09/16 by Alex
Kazik <alex@kazik.de>.

CC: netdev@vger.kernel.org
Link: https://lore.kernel.org/r/1622958877-2026-1-git-send-email-schmitzmic@gmail.com
Tested-by: Alex Kazik <alex@kazik.de>
Signed-off-by: Michael Schmitz <schmitzmic@gmail.com>

--
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
 drivers/net/ethernet/8390/Kconfig |  5 +++++
 drivers/net/ethernet/8390/apne.c  | 18 ++++++++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/drivers/net/ethernet/8390/Kconfig b/drivers/net/ethernet/8390/Kconfig
index 9f4b302..4c3f7b6 100644
--- a/drivers/net/ethernet/8390/Kconfig
+++ b/drivers/net/ethernet/8390/Kconfig
@@ -143,6 +143,11 @@ config APNE
 	  To compile this driver as a module, choose M here: the module
 	  will be called apne.
 
+	  The driver also supports 10/100Mbit cards (e.g. Netgear FA411,
+	  CNet Singlepoint). To activate 100 Mbit support, use the kernel
+	  option apne.100mbit=1 (builtin) at boot time, or the apne.100mbit
+	  module parameter.
+
 config PCMCIA_PCNET
 	tristate "NE2000 compatible PCMCIA support"
 	depends on PCMCIA
diff --git a/drivers/net/ethernet/8390/apne.c b/drivers/net/ethernet/8390/apne.c
index fe6c834..4dd721e 100644
--- a/drivers/net/ethernet/8390/apne.c
+++ b/drivers/net/ethernet/8390/apne.c
@@ -120,6 +120,10 @@ static u32 apne_msg_enable;
 module_param_named(msg_enable, apne_msg_enable, uint, 0444);
 MODULE_PARM_DESC(msg_enable, "Debug message level (see linux/netdevice.h for bitmap)");
 
+static bool apne_100_mbit;
+module_param_named(100_mbit, apne_100_mbit, bool, 0444);
+MODULE_PARM_DESC(100_mbit, "Enable 100 Mbit support");
+
 struct net_device * __init apne_probe(int unit)
 {
 	struct net_device *dev;
@@ -139,6 +143,11 @@ struct net_device * __init apne_probe(int unit)
 	if ( !(AMIGAHW_PRESENT(PCMCIA)) )
 		return ERR_PTR(-ENODEV);
 
+	if (apne_100_mbit)
+		isa_type = ISA_TYPE_AG16;
+	else
+		isa_type = ISA_TYPE_AG;
+
 	pr_info("Looking for PCMCIA ethernet card : ");
 
 	/* check if a card is inserted */
@@ -590,6 +599,15 @@ static int init_pcmcia(void)
 #endif
 	u_long offset;
 
+	/* reset card (idea taken from CardReset by Artur Pogoda) */
+	if (isa_type == ISA_TYPE_AG16) {
+		u_char tmp = gayle.intreq;
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

