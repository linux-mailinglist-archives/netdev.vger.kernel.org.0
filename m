Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA8FF3AD647
	for <lists+netdev@lfdr.de>; Sat, 19 Jun 2021 02:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234621AbhFSAhK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 20:37:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233796AbhFSAhK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 20:37:10 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E7BFC06175F;
        Fri, 18 Jun 2021 17:34:59 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id x19so5550861pln.2;
        Fri, 18 Jun 2021 17:34:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=tuSev6rXr3H43kdgvL2brbL342a/0ogOzgR1/5B17C4=;
        b=E/Gbei5dWYjFMVrO9dnt0YXEsn7OAMfqJXjRXvklYByfLHnNrNND05bZ9pUQ4yQnZD
         vcAKBnCr14rvYo7dvxeEp8AGIhr1jqqow6HvntjmDOUx9IidE6gz8QzfiU5fR5VcEYT0
         pAKhriqNRmZGfwln9OjuheXazsYb7ux8glinQJQgyrhC8RO0jH6CPQgS/MN1s16QYOBa
         LOZ2PB0A1F0BiBYynU0+IVnwahspT0BqP0q6wbDUF5+DIgZ7nvOVls6UoFVxWC5jspT5
         T78jvha7La2i4MCrnxAVVE8F4X67dK1AcXCXzEDyH60Azyye9tnw0mJRTIVpttyxn3hR
         A9UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=tuSev6rXr3H43kdgvL2brbL342a/0ogOzgR1/5B17C4=;
        b=tNv1xX3GjdiL/IjkGATXWnjIBbx93P7OPS1/kytgWE5ZFevbkfb/nPYHfPoy3KWGhz
         Ag8rtxp99aHWLPfOxL6KZp6IBTer/La05zwqndtNRkOC+wUPS6NLkDAJAPZya1rypJ8u
         Ge/8C+3+6dL3ZIZkYV1JzVqQmPTPBAD1MDYE0w4dznEjFleqO/Pg2Aoo7AzpzvdMnXE2
         zRpUQ2EQmBCUPqIUx8S4l25zRhf/WOzCfTaDF/Ytl/qJ68aPefmQbsg3Ra245wbSKvc9
         Bbp921IltuVXCOnzUOyZ4FhYyq19AkJ0Sl6tbFG/CfC7meBABN1T7I9KVtigj7Pehomm
         n6zA==
X-Gm-Message-State: AOAM530KjLjp0+8eMm+sXx186o4T/3Z9Cv5G+rWluWNhbrvSb8su0KK2
        uLe47Q6V88yhpaMhzoaxPps=
X-Google-Smtp-Source: ABdhPJw0h1XV2oLsM2VLJhJ/dV1kbF9l+3XRHBo3+ZQ6S4MdjBRX71fmv6KK4x69rVYuoewjvq0Pww==
X-Received: by 2002:a17:90a:b795:: with SMTP id m21mr13789145pjr.143.1624062899108;
        Fri, 18 Jun 2021 17:34:59 -0700 (PDT)
Received: from xplor.waratah.dyndns.org (222-152-189-137-fibre.sparkbb.co.nz. [222.152.189.137])
        by smtp.gmail.com with ESMTPSA id z3sm8850365pfb.127.2021.06.18.17.34.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 18 Jun 2021 17:34:58 -0700 (PDT)
Received: by xplor.waratah.dyndns.org (Postfix, from userid 1000)
        id 3B0EB3603E0; Sat, 19 Jun 2021 12:34:55 +1200 (NZST)
From:   Michael Schmitz <schmitzmic@gmail.com>
To:     linux-m68k@vger.kernel.org, geert@linux-m68k.org
Cc:     alex@kazik.de, Michael Schmitz <schmitzmic@gmail.com>,
        netdev@vger.kernel.org
Subject: [PATCH net-next v5 2/2] net/8390: apne.c - add 100 Mbit support to apne.c driver
Date:   Sat, 19 Jun 2021 12:34:51 +1200
Message-Id: <1624062891-22762-3-git-send-email-schmitzmic@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1624062891-22762-1-git-send-email-schmitzmic@gmail.com>
References: <1624062891-22762-1-git-send-email-schmitzmic@gmail.com>
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
 drivers/net/ethernet/8390/Kconfig |  4 ++++
 drivers/net/ethernet/8390/apne.c  | 33 +++++++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+)

diff --git a/drivers/net/ethernet/8390/Kconfig b/drivers/net/ethernet/8390/Kconfig
index 9f4b302..cf0d8b3 100644
--- a/drivers/net/ethernet/8390/Kconfig
+++ b/drivers/net/ethernet/8390/Kconfig
@@ -143,6 +143,10 @@ config APNE
 	  To compile this driver as a module, choose M here: the module
 	  will be called apne.
 
+	  The driver also supports 10/100Mbit cards (e.g. Netgear FA411,
+	  CNet Singlepoint). To activate 100 Mbit support at runtime or
+	  from the kernel command line, use the apne.100mbit module parameter.
+
 config PCMCIA_PCNET
 	tristate "NE2000 compatible PCMCIA support"
 	depends on PCMCIA
diff --git a/drivers/net/ethernet/8390/apne.c b/drivers/net/ethernet/8390/apne.c
index fe6c834..8223e15 100644
--- a/drivers/net/ethernet/8390/apne.c
+++ b/drivers/net/ethernet/8390/apne.c
@@ -120,6 +120,10 @@ static u32 apne_msg_enable;
 module_param_named(msg_enable, apne_msg_enable, uint, 0444);
 MODULE_PARM_DESC(msg_enable, "Debug message level (see linux/netdevice.h for bitmap)");
 
+static bool apne_100_mbit;
+module_param_named(100_mbit, apne_100_mbit, bool, 0644);
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
@@ -147,6 +156,20 @@ struct net_device * __init apne_probe(int unit)
 		return ERR_PTR(-ENODEV);
 	}
 
+	/* Reset card. Who knows what dain-bramaged state it was left in. */
+	{	unsigned long reset_start_time = jiffies;
+
+		outb(inb(IOBASE + NE_RESET), IOBASE + NE_RESET);
+
+		while ((inb(IOBASE + NE_EN0_ISR) & ENISR_RESET) == 0)
+			if (time_after(jiffies, reset_start_time + 2*HZ/100)) {
+				pr_info("Card not found (no reset ack).\n");
+				isa_type=ISA_TYPE_AG16;
+			}
+
+		outb(0xff, IOBASE + NE_EN0_ISR);		/* Ack all intr. */
+	}
+
 	dev = alloc_ei_netdev();
 	if (!dev)
 		return ERR_PTR(-ENOMEM);
@@ -590,6 +613,16 @@ static int init_pcmcia(void)
 #endif
 	u_long offset;
 
+	/* reset card (idea taken from CardReset by Artur Pogoda) */
+	if (isa_type == ISA_TYPE_AG16) {
+		u_char  tmp = gayle.intreq;
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

