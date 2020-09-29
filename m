Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDBCB27D8D7
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 22:39:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730054AbgI2UjK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 16:39:10 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:49690 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729375AbgI2UgE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 16:36:04 -0400
Message-Id: <20200929203501.384359804@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1601411762;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=fic2oF38maLPjPgIPYA9CNGhq9WYNsn4UUVLjOIQ4Yc=;
        b=DsOiiyLnllJKv8DXD1ITRdFwttZavH4BitIxzxhOTLKbM3lFF+1Uy1bhGv2oWrUg038FUI
        IpkF7hWFGSKqKyu3vlZfdCWRAsxpfcuPQivMhcDL29MWeXAr99TUc5J+jZ0OnwchOglAfT
        HEeU6CwQwamjWVo4nxnsJdNpCTXW6ysfCLORlvzVb0lShFeBhRg9kyQHHAQA554LEALUsO
        yawJTzO61XnnOGqrXdnKma8Pg9IrJcWeWcgFg7NI9YtvHYMMSeC0ZhjKYyl3B4pNpDc3vP
        JXYT9WRa47XoB1N5GFk9s4eFPHwj1TvJhQdB3sbArhGNNueV/S3EmNAMQevysQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1601411762;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=fic2oF38maLPjPgIPYA9CNGhq9WYNsn4UUVLjOIQ4Yc=;
        b=aTr/bQVceg0LVg317+omnTdQBuqT2WpvaGqxz6OuJWvQIe93iXRiXC9t4tZxlEDWJDn0LI
        yCuQHq64Gj46/3CQ==
Date:   Tue, 29 Sep 2020 22:25:28 +0200
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Paul McKenney <paulmck@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Christian Benvenuti <benve@cisco.com>,
        Govindarajulu Varadarajan <_govind@gmx.com>,
        Dave Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-doc@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Jay Cliburn <jcliburn@gmail.com>,
        Chris Snook <chris.snook@gmail.com>,
        Vishal Kulkarni <vishal@chelsio.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        intel-wired-lan@lists.osuosl.org,
        Shannon Nelson <snelson@pensando.io>,
        Pensando Drivers <drivers@pensando.io>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
        Edward Cree <ecree@solarflare.com>,
        Martin Habets <mhabets@solarflare.com>,
        Jon Mason <jdmason@kudzu.us>, Daniel Drake <dsd@gentoo.org>,
        Ulrich Kunitz <kune@deine-taler.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, linux-usb@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        Stanislaw Gruszka <stf_xl@wp.pl>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Jouni Malinen <j@w1.fi>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        libertas-dev@lists.infradead.org,
        Pascal Terjan <pterjan@google.com>,
        Ping-Ke Shih <pkshih@realtek.com>
Subject: [patch V2 19/36] net: vxge: Remove in_interrupt() conditionals
References: <20200929202509.673358734@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-transfer-encoding: 8-bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

vxge_os_dma_malloc() and vxge_os_dma_malloc_async() are both called from
callchains which use GFP_KERNEL allocations unconditionally or have other
requirements to be called from fully preemptible task context..

vxge_os_dma_malloc():
  1)  __vxge_hw_blockpool_create() <- GFP_KERNEL
	
  2)  __vxge_hw_mempool_grow() <- vzalloc()
        __vxge_hw_blockpool_malloc()

vxge_os_dma_malloc_async():
  1  __vxge_hw_mempool_grow() <- vzalloc()
      __vxge_hw_blockpool_malloc()
	__vxge_hw_blockpool_blocks_add()

  2)  vxge_hw_vpath_open()	<- vzalloc()
	__vxge_hw_blockpool_block_allocate()

That means neither of these functions needs a conditional allocation mode.

Remove the in_interrupt() conditional and use GFP_KERNEL.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>


---
 drivers/net/ethernet/neterion/vxge/vxge-config.c |    9 +--------
 drivers/net/ethernet/neterion/vxge/vxge-config.h |    7 +------
 2 files changed, 2 insertions(+), 14 deletions(-)

--- a/drivers/net/ethernet/neterion/vxge/vxge-config.c
+++ b/drivers/net/ethernet/neterion/vxge/vxge-config.c
@@ -2303,16 +2303,9 @@ static void vxge_hw_blockpool_block_add(
 static inline void
 vxge_os_dma_malloc_async(struct pci_dev *pdev, void *devh, unsigned long size)
 {
-	gfp_t flags;
 	void *vaddr;
 
-	if (in_interrupt())
-		flags = GFP_ATOMIC | GFP_DMA;
-	else
-		flags = GFP_KERNEL | GFP_DMA;
-
-	vaddr = kmalloc((size), flags);
-
+	vaddr = kmalloc(size, GFP_KERNEL | GFP_DMA);
 	vxge_hw_blockpool_block_add(devh, vaddr, size, pdev, pdev);
 }
 
--- a/drivers/net/ethernet/neterion/vxge/vxge-config.h
+++ b/drivers/net/ethernet/neterion/vxge/vxge-config.h
@@ -1899,18 +1899,13 @@ static inline void *vxge_os_dma_malloc(s
 			struct pci_dev **p_dmah,
 			struct pci_dev **p_dma_acch)
 {
-	gfp_t flags;
 	void *vaddr;
 	unsigned long misaligned = 0;
 	int realloc_flag = 0;
 	*p_dma_acch = *p_dmah = NULL;
 
-	if (in_interrupt())
-		flags = GFP_ATOMIC | GFP_DMA;
-	else
-		flags = GFP_KERNEL | GFP_DMA;
 realloc:
-	vaddr = kmalloc((size), flags);
+	vaddr = kmalloc(size, GFP_KERNEL | GFP_DMA);
 	if (vaddr == NULL)
 		return vaddr;
 	misaligned = (unsigned long)VXGE_ALIGN((unsigned long)vaddr,


