Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2721023520A
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 14:24:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728997AbgHAMYa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Aug 2020 08:24:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728505AbgHAMY2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Aug 2020 08:24:28 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C09D0C06174A;
        Sat,  1 Aug 2020 05:24:27 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id c16so13635239ejx.12;
        Sat, 01 Aug 2020 05:24:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=bG2JE9axjD8+1CxaVpKNmxH/0vdTkJVbn2KxUvFFaz4=;
        b=B4zX48MKM98OUqRQH2btOaTqQ+4ZBBdc71SUsPcKtP3UNPJeBOiRRZ3umH0Gqic3VR
         GB0OxXzbXXdW8FGraOn/kPQftWEZ+Uw+UpPMrnJHa7iam+pzis9+Jq2iW78XAXNyFo6s
         J2pTNBilXsubMUsM9hS8Paz5mGFKJcsoqhinBL3c5owR97ATgzHjM3MwRhll/jbYM7Sr
         syMquosNWbae4/7CwHFqNsGG1zI9Ik6aRfFVR6cWd64bCM6sO03wq3dpjZDh7zgKDxJZ
         wkydMXxg54UJ4/tdMtHh6cDckza/LubMIvWbHtLtOT6bkgr2/xaY9+X8SrzDXBeHXKCQ
         z/Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=bG2JE9axjD8+1CxaVpKNmxH/0vdTkJVbn2KxUvFFaz4=;
        b=DpJVltEze/jzY9sdKJPrGUDKUh1fSUO3+nRX24UEHO+5c33ewHMUExY637wET483X3
         ABvwsthWjNtLa8pOpdoIiuRDs6g4dj3tNnjTQGrxTGYr0ZWaDnPZsnDi4Z/pjMHKwnVZ
         a8yDxA/G9JJnu6xj5wmNsG4pZln8HJ6OTSbhADo3zZ0DRcukHI4fxwTn0KRM1K9O20H9
         swAr2CrqsFtJ+zSBRTp7jij94J2oMnfCFZ/GwppKbr+uho0ducG2l374/+py3JWiS1Go
         HeG7DWcLiu9L1xI/L+/RRE1D805h8T2gAqRIRqENjCypgSApo2Y78H4+pbBpdLwJdq08
         6kgQ==
X-Gm-Message-State: AOAM532fO+q5G2tbNLh8pvl42L4FWFwy+UYeCsI3e8QJPYryli3r2LRB
        nq7A+lAzOoSwo5sElszVig8=
X-Google-Smtp-Source: ABdhPJzLq4qTsUepRwe72zKrmXKw3yVmfhCLVZDkxGgraWLLzl4jYz3H1vxQA8mVW398Mu9CELP63w==
X-Received: by 2002:a17:906:1104:: with SMTP id h4mr8389690eja.456.1596284666483;
        Sat, 01 Aug 2020 05:24:26 -0700 (PDT)
Received: from net.saheed (95C84E0A.dsl.pool.telekom.hu. [149.200.78.10])
        by smtp.gmail.com with ESMTPSA id a101sm12083131edf.76.2020.08.01.05.24.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2020 05:24:26 -0700 (PDT)
From:   "Saheed O. Bolarinwa" <refactormyself@gmail.com>
To:     helgaas@kernel.org, Chas Williams <3chas3@gmail.com>
Cc:     "Saheed O. Bolarinwa" <refactormyself@gmail.com>,
        bjorn@helgaas.com, skhan@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org
Subject: [RFC PATCH 02/17] atm: Drop uses of pci_read_config_*() return value
Date:   Sat,  1 Aug 2020 13:24:31 +0200
Message-Id: <20200801112446.149549-3-refactormyself@gmail.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20200801112446.149549-1-refactormyself@gmail.com>
References: <20200801112446.149549-1-refactormyself@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The return value of pci_read_config_*() may not indicate a device error.
However, the value read by these functions is more likely to indicate
this kind of error. This presents two overlapping ways of reporting
errors and complicates error checking.

It is possible to move to one single way of checking for error if the
dependency on the return value of these functions is removed, then it
can later be made to return void.

Remove all uses of the return value of pci_read_config_*().
Check the actual value read for ~0. In this case, ~0 is an invalid
value thus it indicates some kind of error.

Suggested-by: Bjorn Helgaas <bjorn@helgaas.com>
Signed-off-by: Saheed O. Bolarinwa <refactormyself@gmail.com>
---
 drivers/atm/eni.c      |  3 ++-
 drivers/atm/he.c       | 12 +++++++----
 drivers/atm/idt77252.c |  9 ++++++---
 drivers/atm/iphase.c   | 46 +++++++++++++++++++++++-------------------
 drivers/atm/lanai.c    |  4 ++--
 drivers/atm/nicstar.c  |  3 ++-
 drivers/atm/zatm.c     |  9 +++++----
 7 files changed, 50 insertions(+), 36 deletions(-)

diff --git a/drivers/atm/eni.c b/drivers/atm/eni.c
index 17d47ad03ab7..5beed8a25fa2 100644
--- a/drivers/atm/eni.c
+++ b/drivers/atm/eni.c
@@ -1585,7 +1585,8 @@ static char * const media_name[] = {
   } })
 #define GET_SEPROM \
   ({ if (!error && !pci_error) { \
-    pci_error = pci_read_config_byte(eni_dev->pci_dev,PCI_TONGA_CTRL,&tonga); \
+	pci_read_config_byte(eni_dev->pci_dev, PCI_TONGA_CTRL, &tonga); \
+	pci_error = (tonga == (u8)~0) ? -1 : 0; \
     udelay(10); /* 10 usecs */ \
   } })
 
diff --git a/drivers/atm/he.c b/drivers/atm/he.c
index 8af793f5e811..8727ae7746fb 100644
--- a/drivers/atm/he.c
+++ b/drivers/atm/he.c
@@ -995,7 +995,8 @@ static int he_start(struct atm_dev *dev)
 	 */
 
 	/* 4.3 pci bus controller-specific initialization */
-	if (pci_read_config_dword(pci_dev, GEN_CNTL_0, &gen_cntl_0) != 0) {
+	pci_read_config_dword(pci_dev, GEN_CNTL_0, &gen_cntl_0);
+	if (gen_cntl_0 == (u32)~0) {
 		hprintk("can't read GEN_CNTL_0\n");
 		return -EINVAL;
 	}
@@ -1005,7 +1006,8 @@ static int he_start(struct atm_dev *dev)
 		return -EINVAL;
 	}
 
-	if (pci_read_config_word(pci_dev, PCI_COMMAND, &command) != 0) {
+	pci_read_config_word(pci_dev, PCI_COMMAND, &command);
+	if (command == (u16)~0) {
 		hprintk("can't read PCI_COMMAND.\n");
 		return -EINVAL;
 	}
@@ -1016,7 +1018,8 @@ static int he_start(struct atm_dev *dev)
 		return -EINVAL;
 	}
 
-	if (pci_read_config_byte(pci_dev, PCI_CACHE_LINE_SIZE, &cache_size)) {
+	pci_read_config_byte(pci_dev, PCI_CACHE_LINE_SIZE, &cache_size);
+	if (cache_size == (u8)~0) {
 		hprintk("can't read cache line size?\n");
 		return -EINVAL;
 	}
@@ -1027,7 +1030,8 @@ static int he_start(struct atm_dev *dev)
 			hprintk("can't set cache line size to %d\n", cache_size);
 	}
 
-	if (pci_read_config_byte(pci_dev, PCI_LATENCY_TIMER, &timer)) {
+	pci_read_config_byte(pci_dev, PCI_LATENCY_TIMER, &timer);
+	if (timer == (u8)~0) {
 		hprintk("can't read latency timer?\n");
 		return -EINVAL;
 	}
diff --git a/drivers/atm/idt77252.c b/drivers/atm/idt77252.c
index df51680e8931..f4b0c2ecae62 100644
--- a/drivers/atm/idt77252.c
+++ b/drivers/atm/idt77252.c
@@ -3271,7 +3271,8 @@ static int init_card(struct atm_dev *dev)
 
 	/* Set PCI Retry-Timeout and TRDY timeout */
 	IPRINTK("%s: Checking PCI retries.\n", card->name);
-	if (pci_read_config_byte(pcidev, 0x40, &pci_byte) != 0) {
+	pci_read_config_byte(pcidev, 0x40, &pci_byte);
+	if (pci_byte == (u_char)~0) {
 		printk("%s: can't read PCI retry timeout.\n", card->name);
 		deinit_card(card);
 		return -1;
@@ -3287,7 +3288,8 @@ static int init_card(struct atm_dev *dev)
 		}
 	}
 	IPRINTK("%s: Checking PCI TRDY.\n", card->name);
-	if (pci_read_config_byte(pcidev, 0x41, &pci_byte) != 0) {
+	pci_read_config_byte(pcidev, 0x41, &pci_byte);
+	if (pci_byte == (u_char)~0) {
 		printk("%s: can't read PCI TRDY timeout.\n", card->name);
 		deinit_card(card);
 		return -1;
@@ -3535,7 +3537,8 @@ static int idt77252_preset(struct idt77252_dev *card)
 
 	XPRINTK("%s: Enable PCI master and memory access for SAR.\n",
 		card->name);
-	if (pci_read_config_word(card->pcidev, PCI_COMMAND, &pci_command)) {
+	pci_read_config_word(card->pcidev, PCI_COMMAND, &pci_command);
+	if (pci_command == (u16)~0) {
 		printk("%s: can't read PCI_COMMAND.\n", card->name);
 		deinit_card(card);
 		return -1;
diff --git a/drivers/atm/iphase.c b/drivers/atm/iphase.c
index 8c7a996d1f16..d3f2fac3a7d1 100644
--- a/drivers/atm/iphase.c
+++ b/drivers/atm/iphase.c
@@ -2287,25 +2287,29 @@ static int get_esi(struct atm_dev *dev)
 	return 0;  
 }  
 	  
-static int reset_sar(struct atm_dev *dev)  
-{  
-	IADEV *iadev;  
-	int i, error = 1;  
-	unsigned int pci[64];  
-	  
-	iadev = INPH_IA_DEV(dev);  
-	for(i=0; i<64; i++)  
-	  if ((error = pci_read_config_dword(iadev->pci,  
-				i*4, &pci[i])) != PCIBIOS_SUCCESSFUL)  
-  	      return error;  
-	writel(0, iadev->reg+IPHASE5575_EXT_RESET);  
-	for(i=0; i<64; i++)  
-	  if ((error = pci_write_config_dword(iadev->pci,  
-					i*4, pci[i])) != PCIBIOS_SUCCESSFUL)  
-	    return error;  
-	udelay(5);  
-	return 0;  
-}  
+static int reset_sar(struct atm_dev *dev)
+{
+	IADEV *iadev;
+	int i, error = 1;
+	unsigned int pci[64];
+
+	iadev = INPH_IA_DEV(dev);
+	for (i = 0; i < 64; i++) {
+		pci_read_config_dword(iadev->pci, i*4, &pci[i]);
+		if (pci[i] == (u32)~0)
+			return error;
+	}
+
+	writel(0, iadev->reg+IPHASE5575_EXT_RESET);
+	for (i = 0; i < 64; i++) {
+		error = pci_write_config_dword(iadev->pci, i*4, pci[i]);
+		if (error != PCIBIOS_SUCCESSFUL)
+			return error;
+	}
+
+	udelay(5);
+	return 0;
+}
 	  
 	  
 static int ia_init(struct atm_dev *dev)
@@ -2328,8 +2332,8 @@ static int ia_init(struct atm_dev *dev)
 	real_base = pci_resource_start (iadev->pci, 0);
 	iadev->irq = iadev->pci->irq;
 		  
-	error = pci_read_config_word(iadev->pci, PCI_COMMAND, &command);
-	if (error) {
+	pci_read_config_word(iadev->pci, PCI_COMMAND, &command);
+	if (command == (u16)~0) {
 		printk(KERN_ERR DEV_LABEL "(itf %d): init error 0x%x\n",  
 				dev->number,error);  
 		return -EINVAL;  
diff --git a/drivers/atm/lanai.c b/drivers/atm/lanai.c
index 645a6bc1df88..aafe1f934385 100644
--- a/drivers/atm/lanai.c
+++ b/drivers/atm/lanai.c
@@ -1097,8 +1097,8 @@ static void pcistatus_check(struct lanai_dev *lanai, int clearonly)
 {
 	u16 s;
 	int result;
-	result = pci_read_config_word(lanai->pci, PCI_STATUS, &s);
-	if (result != PCIBIOS_SUCCESSFUL) {
+	pci_read_config_word(lanai->pci, PCI_STATUS, &s);
+	if (s == (u16)~0) {
 		printk(KERN_ERR DEV_LABEL "(itf %d): can't read PCI_STATUS: "
 		    "%d\n", lanai->number, result);
 		return;
diff --git a/drivers/atm/nicstar.c b/drivers/atm/nicstar.c
index 7af74fb450a0..74f49f54e024 100644
--- a/drivers/atm/nicstar.c
+++ b/drivers/atm/nicstar.c
@@ -399,7 +399,8 @@ static int ns_init_card(int i, struct pci_dev *pcidev)
 
 	pci_set_master(pcidev);
 
-	if (pci_read_config_byte(pcidev, PCI_LATENCY_TIMER, &pci_latency) != 0) {
+	pci_read_config_byte(pcidev, PCI_LATENCY_TIMER, &pci_latency);
+	if (pci_latency == (u8)~0) {
 		printk("nicstar%d: can't read PCI latency timer.\n", i);
 		error = 6;
 		ns_init_card_error(card, error);
diff --git a/drivers/atm/zatm.c b/drivers/atm/zatm.c
index 57f97b95a453..8106ee20a94c 100644
--- a/drivers/atm/zatm.c
+++ b/drivers/atm/zatm.c
@@ -1112,11 +1112,11 @@ static void eprom_set(struct zatm_dev *zatm_dev, unsigned long value,
 static unsigned long eprom_get(struct zatm_dev *zatm_dev, unsigned short cmd)
 {
 	unsigned int value;
-	int error;
 
-	if ((error = pci_read_config_dword(zatm_dev->pci_dev,cmd,&value)))
+	pci_read_config_dword(zatm_dev->pci_dev, cmd, &value);
+	if (value == (u64)~0)
 		printk(KERN_ERR DEV_LABEL ": PCI read failed (0x%02x)\n",
-		    error);
+		    value);
 	return value;
 }
 
@@ -1197,7 +1197,8 @@ static int zatm_init(struct atm_dev *dev)
 	pci_dev = zatm_dev->pci_dev;
 	zatm_dev->base = pci_resource_start(pci_dev, 0);
 	zatm_dev->irq = pci_dev->irq;
-	if ((error = pci_read_config_word(pci_dev,PCI_COMMAND,&command))) {
+	pci_read_config_word(pci_dev, PCI_COMMAND, &command);
+	if (command == (u16)~0) {
 		printk(KERN_ERR DEV_LABEL "(itf %d): init error 0x%02x\n",
 		    dev->number,error);
 		return -EINVAL;
-- 
2.18.4

