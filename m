Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37DCD3AAB08
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 07:29:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbhFQFbD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 01:31:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbhFQFbC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 01:31:02 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 472F9C061574;
        Wed, 16 Jun 2021 22:28:55 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id h1so2322694plt.1;
        Wed, 16 Jun 2021 22:28:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=aZxZQhd0Q8r7isZC7zXuPgUVtNUa9gCiihLnz96JFNU=;
        b=HEY3LEgVjI4/pG9Rj8SolPOsGuIrJFDnRUb5yi1PI/6v3BQUvqeZkJEGYvH6s5pVk5
         aol6hUVFO5lpYTW0iKwDPVtbkKalx9WG9jynBGUdJsx85i3XAOzM2PUaacuZa5Y4S2iS
         b5EcF+vTVaXdkH9MDVJ5QQxyWeXPQnDZkzu2p5Ihr/trH3PSjYEFwBvJn3M713eTTgtv
         SD0SITJXFGVD003qma2FMrLlfKJx4glQgjrz87yXYdUsDvkEVsquRM7nX4wgz9yKe/aV
         RWjNAeLB+080dSGfK4N9FOB3kqDPqQtsFg6W/2RzK+n5hTo7SNjRPGhDMQcPRXuf5GKQ
         9FjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=aZxZQhd0Q8r7isZC7zXuPgUVtNUa9gCiihLnz96JFNU=;
        b=QkkZYAIvM4yP+8Fh8AtBxigWLbZMN1LxzauUoPMzowrkWZvolEwD+9nfCCOiIBeUbq
         L83hyAEA101rDJlGem4SdfDCk7QFk1Z9TNSQyt6hDTVRaLRnLBQOF9Mfuq9BfRrxSiZv
         Z6b+u8xNdoak5vc2/DB+yl6tKjMbHi8qKnqOBeNl3SXgNlMEOqe0rbiO7Qd0bnrCy3bC
         rdKCVrNHpKlelTw+oZ6gHapqg42mge+l2eymEzadkL+jJ8IoJIqmQlYoxV5MRB7kJRAP
         fD07+3GiPRH7BAmrZbyXmQANLZPj3MW6uKG4a95dO3xpZgTQXTY4hgzsf+Rq4gLnAGcE
         SKVg==
X-Gm-Message-State: AOAM530a7N2H7hL6SAiX5VItxKY5vO2BHtGd7kJKA2XkZo+y0AAGdfjW
        1lAI/JqFBlt33XMYmI3RYHeu5ahUe+fLbw==
X-Google-Smtp-Source: ABdhPJz4DbU2jw6hIaMgCn1iNp1n0K8BgQSP+asbCqDnDJryVGb+kxwwqeYd6ToJ56Qro/hd4PcbIQ==
X-Received: by 2002:a17:902:ff11:b029:114:37a7:21ad with SMTP id f17-20020a170902ff11b029011437a721admr2848386plj.68.1623907734897;
        Wed, 16 Jun 2021 22:28:54 -0700 (PDT)
Received: from xplor.waratah.dyndns.org (222-152-189-137-fibre.sparkbb.co.nz. [222.152.189.137])
        by smtp.gmail.com with ESMTPSA id q24sm4121470pgk.32.2021.06.16.22.28.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Jun 2021 22:28:54 -0700 (PDT)
Received: by xplor.waratah.dyndns.org (Postfix, from userid 1000)
        id 1ED1336040F; Thu, 17 Jun 2021 17:28:51 +1200 (NZST)
From:   Michael Schmitz <schmitzmic@gmail.com>
To:     linux-m68k@vger.kernel.org, geert@linux-m68k.org
Cc:     alex@kazik.de, Michael Schmitz <schmitzmic@gmail.com>,
        netdev@vger.kernel.org
Subject: [PATCH net-next v3 2/2] net/8390: apne.c - add 100 Mbit support to apne.c driver
Date:   Thu, 17 Jun 2021 17:28:32 +1200
Message-Id: <1623907712-29366-3-git-send-email-schmitzmic@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1623907712-29366-1-git-send-email-schmitzmic@gmail.com>
References: <1623907712-29366-1-git-send-email-schmitzmic@gmail.com>
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
Tested-by: Alex Kazik <alex@kazik.de>
Signed-off-by: Michael Schmitz <schmitzmic@gmail.com>

--
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
 drivers/net/ethernet/8390/apne.c  | 21 +++++++++++++++++++++
 2 files changed, 33 insertions(+)

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
index fe6c834..59e41ad 100644
--- a/drivers/net/ethernet/8390/apne.c
+++ b/drivers/net/ethernet/8390/apne.c
@@ -120,6 +120,12 @@ static u32 apne_msg_enable;
 module_param_named(msg_enable, apne_msg_enable, uint, 0444);
 MODULE_PARM_DESC(msg_enable, "Debug message level (see linux/netdevice.h for bitmap)");
 
+#ifdef CONFIG_APNE100MBIT
+static bool apne_100_mbit;
+module_param_named(apne_100_mbit_msg, apne_100_mbit, bool, 0444);
+MODULE_PARM_DESC(apne_100_mbit_msg, "Enable 100 Mbit support");
+#endif
+
 struct net_device * __init apne_probe(int unit)
 {
 	struct net_device *dev;
@@ -139,6 +145,11 @@ struct net_device * __init apne_probe(int unit)
 	if ( !(AMIGAHW_PRESENT(PCMCIA)) )
 		return ERR_PTR(-ENODEV);
 
+#ifdef CONFIG_APNE100MBIT
+	if (apne_100_mbit)
+		isa_type = ISA_TYPE_AG16;
+#endif
+
 	pr_info("Looking for PCMCIA ethernet card : ");
 
 	/* check if a card is inserted */
@@ -590,6 +601,16 @@ static int init_pcmcia(void)
 #endif
 	u_long offset;
 
+#ifdef CONFIG_APNE100MBIT
+	/* reset card (idea taken from CardReset by Artur Pogoda) */
+	{
+		u_char  tmp = gayle.intreq;
+
+		gayle.intreq = 0xff;    mdelay(1);
+		gayle.intreq = tmp;     mdelay(300);
+	}
+#endif
+
 	pcmcia_reset();
 	pcmcia_program_voltage(PCMCIA_0V);
 	pcmcia_access_speed(PCMCIA_SPEED_250NS);
-- 
2.7.4

