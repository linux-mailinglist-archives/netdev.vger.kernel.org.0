Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B23CB21D6EF
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 15:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730182AbgGMNYn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 09:24:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729961AbgGMNXF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 09:23:05 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86EF6C061755;
        Mon, 13 Jul 2020 06:23:04 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id z17so13651943edr.9;
        Mon, 13 Jul 2020 06:23:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Od1uE36VZZcVYLn0QSD8NtzuxQxsefbubYclE4nvIkY=;
        b=e7SRK/dskLXTgSYSlQ2o7Q4GwDjhmiP9X6vyk4ZKZEDu/qgVrpUvAqt9H0nYD8+O6G
         tS9IxLNysoC0AJatrwEo44o4SAxid1FlUkUtT0nJX2TYfohWaenFiCs0a+bBJoPZ4PrQ
         olkimNUMz/4c2WhWYTiMwpSVPAxiMCziBsQ1kHrgdn1HkxRuu4IMfbWw8/CJ3QROjQOj
         kmSCNf1U1Jh9w/9rKB7mUu3WCIIc/quDAXu4oBtvdAJaugj9OAo5B/Olh3qgInDhjr0W
         kZ9WFKb+55kYxv090/oS2lbVBG/glVDJxIHRBePzwE74mGECDU7wwOU4oYCIY1k3Arja
         1khg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Od1uE36VZZcVYLn0QSD8NtzuxQxsefbubYclE4nvIkY=;
        b=oxk7hlzXsUbGG75z38ScGWBp/6FacRpa79zDqNQk2XOvw3fQyjchVgHYtaugniEmj0
         89iXDs6pti7Gw4sPfYtAshmHFrfjduV4VgHy9j1A8KoMe7/joRfPZHBvYyN11XA+Iajc
         nZ56SwEFf3MnAuS37lSPzumnikNb50nKPH3AJfbCKMmR4Q3iAnFW71jMn89Ej8vJ5McN
         ROhl1gIwy69PVW8hk6tPj4/WcX8sDKfJft7UYxafNuDjf7Y8rpK3KXw/amFg9oF/LtEA
         7CKAeucgFtu17nG2xRhq6djMpyEMFUyauy5420P1OgEPA7qidRLcKVGm6DpcVtoYQezX
         McQg==
X-Gm-Message-State: AOAM53134dvafH8epqpW2a4mXN2dFDSW/nzaAEjNCXST9IAAPLjWBQ5m
        Fdx7KynyGBEc4rdPxbLDuZY=
X-Google-Smtp-Source: ABdhPJxpNR6rRgsPQS5aE3w3IDF8VLZSwN1M0ZM5Th2IbtF+Dj00cjehb0zQNQGy6XXrKpQDJRU0Hw==
X-Received: by 2002:aa7:da8a:: with SMTP id q10mr29025674eds.139.1594646583291;
        Mon, 13 Jul 2020 06:23:03 -0700 (PDT)
Received: from net.saheed (54007186.dsl.pool.telekom.hu. [84.0.113.134])
        by smtp.gmail.com with ESMTPSA id n9sm11806540edr.46.2020.07.13.06.23.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 06:23:02 -0700 (PDT)
From:   "Saheed O. Bolarinwa" <refactormyself@gmail.com>
To:     helgaas@kernel.org, Chas Williams <3chas3@gmail.com>
Cc:     "Saheed O. Bolarinwa" <refactormyself@gmail.com>,
        bjorn@helgaas.com, skhan@linuxfoundation.org,
        linux-pci@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org
Subject: [RFC PATCH 19/35] atm: Change PCIBIOS_SUCCESSFUL to 0
Date:   Mon, 13 Jul 2020 14:22:31 +0200
Message-Id: <20200713122247.10985-20-refactormyself@gmail.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20200713122247.10985-1-refactormyself@gmail.com>
References: <20200713122247.10985-1-refactormyself@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In reference to the PCI spec (Chapter 2), PCIBIOS* is an x86 concept.
Their scope should be limited within arch/x86.

Change all PCIBIOS_SUCCESSFUL to 0

Signed-off-by: "Saheed O. Bolarinwa" <refactormyself@gmail.com>
---
 drivers/atm/iphase.c | 4 ++--
 drivers/atm/lanai.c  | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/atm/iphase.c b/drivers/atm/iphase.c
index 8c7a996d1f16..b01cc491540d 100644
--- a/drivers/atm/iphase.c
+++ b/drivers/atm/iphase.c
@@ -2296,12 +2296,12 @@ static int reset_sar(struct atm_dev *dev)
 	iadev = INPH_IA_DEV(dev);  
 	for(i=0; i<64; i++)  
 	  if ((error = pci_read_config_dword(iadev->pci,  
-				i*4, &pci[i])) != PCIBIOS_SUCCESSFUL)  
+				i*4, &pci[i])) != 0)
   	      return error;  
 	writel(0, iadev->reg+IPHASE5575_EXT_RESET);  
 	for(i=0; i<64; i++)  
 	  if ((error = pci_write_config_dword(iadev->pci,  
-					i*4, pci[i])) != PCIBIOS_SUCCESSFUL)  
+					i*4, pci[i])) != 0)
 	    return error;  
 	udelay(5);  
 	return 0;  
diff --git a/drivers/atm/lanai.c b/drivers/atm/lanai.c
index 645a6bc1df88..2b82ae30dd74 100644
--- a/drivers/atm/lanai.c
+++ b/drivers/atm/lanai.c
@@ -1098,7 +1098,7 @@ static void pcistatus_check(struct lanai_dev *lanai, int clearonly)
 	u16 s;
 	int result;
 	result = pci_read_config_word(lanai->pci, PCI_STATUS, &s);
-	if (result != PCIBIOS_SUCCESSFUL) {
+	if (result != 0) {
 		printk(KERN_ERR DEV_LABEL "(itf %d): can't read PCI_STATUS: "
 		    "%d\n", lanai->number, result);
 		return;
@@ -1109,7 +1109,7 @@ static void pcistatus_check(struct lanai_dev *lanai, int clearonly)
 	if (s == 0)
 		return;
 	result = pci_write_config_word(lanai->pci, PCI_STATUS, s);
-	if (result != PCIBIOS_SUCCESSFUL)
+	if (result != 0)
 		printk(KERN_ERR DEV_LABEL "(itf %d): can't write PCI_STATUS: "
 		    "%d\n", lanai->number, result);
 	if (clearonly)
@@ -1949,7 +1949,7 @@ static int lanai_pci_start(struct lanai_dev *lanai)
 		return result;
 	/* Set latency timer to zero as per lanai docs */
 	result = pci_write_config_byte(pci, PCI_LATENCY_TIMER, 0);
-	if (result != PCIBIOS_SUCCESSFUL) {
+	if (result != 0) {
 		printk(KERN_ERR DEV_LABEL "(itf %d): can't write "
 		    "PCI_LATENCY_TIMER: %d\n", lanai->number, result);
 		return -EINVAL;
-- 
2.18.2

