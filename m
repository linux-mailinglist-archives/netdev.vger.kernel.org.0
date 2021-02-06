Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C6C13118A7
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 03:44:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231764AbhBFCnf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 21:43:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230307AbhBFCiZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 21:38:25 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A907C08EE0F;
        Fri,  5 Feb 2021 16:02:06 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id 8so4356688plc.10;
        Fri, 05 Feb 2021 16:02:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7eUvHbQJlx7NT0TXuM0/41KIAgE9PVpJRhkilORkcHY=;
        b=kxURiT0ZkwVQklC29EhfSO1y24pZJWQSJ5SDTQoPjoTDMq/EjbHZQGDoX9uio4nVkv
         OWBKZclFCXsqsoSBtSnkF1EaAfZlKf+nveuxhk4z4s4Hbzf11Rh1FiIvo5K1e38fsDg8
         ZZiE1dkomcm7lX+A1I9GgUObk/xQC3MepjN+cUGTcPGjN3pSPTto3gQRzk/TkweSIveK
         ISh/fN5Q1eM/MViJWMqAJ4iBQpyFqlQwrfO6X7zUY45QJNdSySzHd0J5rSNSUJ3yID8H
         uzIqx25Z8EFOsJTwDvb4a7FG5ZhefeKONf/Re4PsTXR5T1LE9aHYfmLO7xhFhsNIrHNR
         xCNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7eUvHbQJlx7NT0TXuM0/41KIAgE9PVpJRhkilORkcHY=;
        b=E5zPFEmR9kKGJ1wRNjGIW0NrdlxzkFqkyWWjjR88fTqzUVl2VBZNEs/gIuQN8L84RB
         ygHm9aZG676Gi+h+c1zGnLN0EUYppI4DecpbUX5lqdTQschM8K8+8NUxI+8WhGKmBrxz
         VKHSpMUp42fAwozOFyKRziV44U1sDcPZTxYlnaMMK2LSIkUTUY7DAJtQ2JcGtgMyB04p
         HLIT6GI+vDNK80+41juA8rXRya5RIBFQxV8498SoA3Avj5LWaEocouQ7Uma3y4wxz5pg
         eujnhh/5851shTELRENtESiXICD44tdu2SubC3DJqyJlVERR7bKmwbs0tVmVC1Y/AQbw
         n9pw==
X-Gm-Message-State: AOAM530K5OUvb/jsnsZEfhm+bwRjN4RlvdKp4zeZfI1wWfWr5goFlMjJ
        pJrkuPSFVilcNbwfUFQdHx8=
X-Google-Smtp-Source: ABdhPJyqQXDfWgdlw3ZizFtbVbAKR0GGoS6VnwYHkFAM12oiFr8LKkx88zj6IyhOgZzon45OHhwH2Q==
X-Received: by 2002:a17:902:e5ce:b029:e1:d1f:525f with SMTP id u14-20020a170902e5ceb02900e10d1f525fmr6319558plf.25.1612569725887;
        Fri, 05 Feb 2021 16:02:05 -0800 (PST)
Received: from amypc-samantha.home ([47.145.126.51])
        by smtp.gmail.com with ESMTPSA id r189sm11771724pgr.10.2021.02.05.16.02.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 16:02:05 -0800 (PST)
From:   Amy Parker <enbyamy@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, akpm@linux-foundation.org,
        rppt@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Amy Parker <enbyamy@gmail.com>
Subject: [PATCH 3/3] drivers/net/ethernet/amd: Break apart one-lined expressions
Date:   Fri,  5 Feb 2021 16:01:46 -0800
Message-Id: <20210206000146.616465-4-enbyamy@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210206000146.616465-1-enbyamy@gmail.com>
References: <20210206000146.616465-1-enbyamy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some expressions using C keywords - especially if expressions - are
crammed onto one line. The kernel style guide indicates not to do
this, as it harms readability. This patch splits these one-lined
statements into two lines.

Signed-off-by: Amy Parker <enbyamy@gmail.com>
---
 drivers/net/ethernet/amd/atarilance.c | 15 ++++++++++-----
 drivers/net/ethernet/amd/sun3lance.c  | 27 ++++++++++++++++++---------
 2 files changed, 28 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/amd/atarilance.c b/drivers/net/ethernet/amd/atarilance.c
index 9ec44cf4ba9c..3e264a52307e 100644
--- a/drivers/net/ethernet/amd/atarilance.c
+++ b/drivers/net/ethernet/amd/atarilance.c
@@ -481,27 +481,32 @@ static unsigned long __init lance_probe1( struct net_device *dev,
 
 	/* Test whether memory readable and writable */
 	PROBE_PRINT(( "lance_probe1: testing memory to be accessible\n" ));
-	if (!addr_accessible( memaddr, 1, 1 )) goto probe_fail;
+	if (!addr_accessible(memaddr, 1, 1))
+		goto probe_fail;
 
 	/* Written values should come back... */
 	PROBE_PRINT(( "lance_probe1: testing memory to be writable (1)\n" ));
 	save1 = *memaddr;
 	*memaddr = 0x0001;
-	if (*memaddr != 0x0001) goto probe_fail;
+	if (*memaddr != 0x0001)
+		goto probe_fail;
 	PROBE_PRINT(( "lance_probe1: testing memory to be writable (2)\n" ));
 	*memaddr = 0x0000;
-	if (*memaddr != 0x0000) goto probe_fail;
+	if (*memaddr != 0x0000)
+		goto probe_fail;
 	*memaddr = save1;
 
 	/* First port should be readable and writable */
 	PROBE_PRINT(( "lance_probe1: testing ioport to be accessible\n" ));
-	if (!addr_accessible( ioaddr, 1, 1 )) goto probe_fail;
+	if (!addr_accessible(ioaddr, 1, 1))
+		goto probe_fail;
 
 	/* and written values should be readable */
 	PROBE_PRINT(( "lance_probe1: testing ioport to be writeable\n" ));
 	save2 = ioaddr[1];
 	ioaddr[1] = 0x0001;
-	if (ioaddr[1] != 0x0001) goto probe_fail;
+	if (ioaddr[1] != 0x0001)
+		goto probe_fail;
 
 	/* The CSR0_INIT bit should not be readable */
 	PROBE_PRINT(( "lance_probe1: testing CSR0 register function (1)\n" ));
diff --git a/drivers/net/ethernet/amd/sun3lance.c b/drivers/net/ethernet/amd/sun3lance.c
index c7af742f63ad..88fce468e848 100644
--- a/drivers/net/ethernet/amd/sun3lance.c
+++ b/drivers/net/ethernet/amd/sun3lance.c
@@ -699,9 +699,12 @@ static irqreturn_t lance_interrupt( int irq, void *dev_id)
 			if (head->flag & TMD1_ERR) {
 				int status = head->misc;
 				dev->stats.tx_errors++;
-				if (status & TMD3_RTRY) dev->stats.tx_aborted_errors++;
-				if (status & TMD3_LCAR) dev->stats.tx_carrier_errors++;
-				if (status & TMD3_LCOL) dev->stats.tx_window_errors++;
+				if (status & TMD3_RTRY)
+					dev->stats.tx_aborted_errors++;
+				if (status & TMD3_LCAR)
+					dev->stats.tx_carrier_errors++;
+				if (status & TMD3_LCOL)
+					dev->stats.tx_window_errors++;
 				if (status & (TMD3_UFLO | TMD3_BUFF)) {
 					dev->stats.tx_fifo_errors++;
 					printk("%s: Tx FIFO error\n",
@@ -738,8 +741,10 @@ static irqreturn_t lance_interrupt( int irq, void *dev_id)
 		lance_rx( dev );
 
 	/* Log misc errors. */
-	if (csr0 & CSR0_BABL) dev->stats.tx_errors++; /* Tx babble. */
-	if (csr0 & CSR0_MISS) dev->stats.rx_errors++; /* Missed a Rx frame. */
+	if (csr0 & CSR0_BABL)
+		dev->stats.tx_errors++; /* Tx babble. */
+	if (csr0 & CSR0_MISS)
+		dev->stats.rx_errors++; /* Missed a Rx frame. */
 	if (csr0 & CSR0_MERR) {
 		DPRINTK( 1, ( "%s: Bus master arbitration failure (?!?), "
 			      "status %04x.\n", dev->name, csr0 ));
@@ -785,10 +790,14 @@ static int lance_rx( struct net_device *dev )
 			   buffers, with only the last correctly noting the error. */
 			if (status & RMD1_ENP)	/* Only count a general error at the */
 				dev->stats.rx_errors++; /* end of a packet.*/
-			if (status & RMD1_FRAM) dev->stats.rx_frame_errors++;
-			if (status & RMD1_OFLO) dev->stats.rx_over_errors++;
-			if (status & RMD1_CRC) dev->stats.rx_crc_errors++;
-			if (status & RMD1_BUFF) dev->stats.rx_fifo_errors++;
+			if (status & RMD1_FRAM)
+				dev->stats.rx_frame_errors++;
+			if (status & RMD1_OFLO)
+				dev->stats.rx_over_errors++;
+			if (status & RMD1_CRC)
+				dev->stats.rx_crc_errors++;
+			if (status & RMD1_BUFF)
+				dev->stats.rx_fifo_errors++;
 			head->flag &= (RMD1_ENP|RMD1_STP);
 		} else {
 			/* Malloc up new buffer, compatible with net-3. */
-- 
2.29.2

