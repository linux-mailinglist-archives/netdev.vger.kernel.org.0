Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 431793886B3
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 07:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238373AbhESFiZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 01:38:25 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:3032 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243243AbhESFgD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 01:36:03 -0400
Received: from dggems701-chm.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FlM2H0JzDzmX9s;
        Wed, 19 May 2021 13:32:23 +0800 (CST)
Received: from dggemi760-chm.china.huawei.com (10.1.198.146) by
 dggems701-chm.china.huawei.com (10.3.19.178) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 19 May 2021 13:34:38 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi760-chm.china.huawei.com (10.1.198.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 19 May 2021 13:34:38 +0800
From:   Hui Tang <tanghui20@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Hui Tang <tanghui20@huawei.com>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH 15/20] net: smsc: remove leading spaces before tabs
Date:   Wed, 19 May 2021 13:30:48 +0800
Message-ID: <1621402253-27200-16-git-send-email-tanghui20@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1621402253-27200-1-git-send-email-tanghui20@huawei.com>
References: <1621402253-27200-1-git-send-email-tanghui20@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggemi760-chm.china.huawei.com (10.1.198.146)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are a few leading spaces before tabs and remove it by running the
following commard:

	$ find . -name '*.c' | xargs sed -r -i 's/^[ ]+\t/\t/'
	$ find . -name '*.h' | xargs sed -r -i 's/^[ ]+\t/\t/'

Cc: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Hui Tang <tanghui20@huawei.com>
---
 drivers/net/ethernet/smsc/smc9194.c | 42 ++++++++++++++++++-------------------
 drivers/net/ethernet/smsc/smc91x.c  | 14 ++++++-------
 2 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/smsc/smc9194.c b/drivers/net/ethernet/smsc/smc9194.c
index 4b2330d..bf7c8c8 100644
--- a/drivers/net/ethernet/smsc/smc9194.c
+++ b/drivers/net/ethernet/smsc/smc9194.c
@@ -182,8 +182,8 @@ struct smc_local {
 	struct sk_buff * saved_skb;
 
 	/*
- 	 . This keeps track of how many packets that I have
- 	 . sent out.  When an TX_EMPTY interrupt comes, I know
+	 . This keeps track of how many packets that I have
+	 . sent out.  When an TX_EMPTY interrupt comes, I know
 	 . that all of these have been sent.
 	*/
 	int	packets_waiting;
@@ -343,7 +343,7 @@ static void smc_reset( int ioaddr )
 
 	/* Note:  It doesn't seem that waiting for the MMU busy is needed here,
 	   but this is a place where future chipsets _COULD_ break.  Be wary
- 	   of issuing another MMU command right after this */
+	   of issuing another MMU command right after this */
 
 	outb( 0, ioaddr + INT_MASK );
 }
@@ -521,9 +521,9 @@ static netdev_tx_t smc_wait_to_send_packet(struct sk_buff *skb,
 	SMC_SELECT_BANK( 2 );
 	outw( MC_ALLOC | numPages, ioaddr + MMU_CMD );
 	/*
- 	. Performance Hack
+	. Performance Hack
 	.
- 	. wait a short amount of time.. if I can send a packet now, I send
+	. wait a short amount of time.. if I can send a packet now, I send
 	. it now.  Otherwise, I enable an interrupt and wait for one to be
 	. available.
 	.
@@ -540,17 +540,17 @@ static netdev_tx_t smc_wait_to_send_packet(struct sk_buff *skb,
 		if ( status & IM_ALLOC_INT ) {
 			/* acknowledge the interrupt */
 			outb( IM_ALLOC_INT, ioaddr + INTERRUPT );
-  			break;
+			break;
 		}
-   	} while ( -- time_out );
+	} while ( -- time_out );
 
-   	if ( !time_out ) {
+	if ( !time_out ) {
 		/* oh well, wait until the chip finds memory later */
 		SMC_ENABLE_INT( IM_ALLOC_INT );
 		PRINTK2((CARDNAME": memory allocation deferred.\n"));
 		/* it's deferred, but I'll handle it later */
 		return NETDEV_TX_OK;
-   	}
+	}
 	/* or YES! I can send the packet now.. */
 	smc_hardware_send_packet(dev);
 	netif_wake_queue(dev);
@@ -616,7 +616,7 @@ static void smc_hardware_send_packet( struct net_device * dev )
 #endif
 
 	/* send the packet length ( +6 for status, length and ctl byte )
- 	   and the status word ( set to zeros ) */
+	   and the status word ( set to zeros ) */
 #ifdef USE_32_BIT
 	outl(  (length +6 ) << 16 , ioaddr + DATA_1 );
 #else
@@ -629,8 +629,8 @@ static void smc_hardware_send_packet( struct net_device * dev )
 	/* send the actual data
 	 . I _think_ it's faster to send the longs first, and then
 	 . mop up by sending the last word.  It depends heavily
- 	 . on alignment, at least on the 486.  Maybe it would be
- 	 . a good idea to check which is optimal?  But that could take
+	 . on alignment, at least on the 486.  Maybe it would be
+	 . a good idea to check which is optimal?  But that could take
 	 . almost as much time as is saved?
 	*/
 #ifdef USE_32_BIT
@@ -757,7 +757,7 @@ static int __init smc_findirq(int ioaddr)
 	outb( IM_ALLOC_INT, ioaddr + INT_MASK );
 
 	/*
- 	 . Allocate 512 bytes of memory.  Note that the chip was just
+	 . Allocate 512 bytes of memory.  Note that the chip was just
 	 . reset so all the memory is available
 	*/
 	outw( MC_ALLOC | 1, ioaddr + MMU_CMD );
@@ -871,7 +871,7 @@ static int __init smc_probe(struct net_device *dev, int ioaddr)
 		goto err_out;
 	}
 	/* The above MIGHT indicate a device, but I need to write to further
- 	 	test this.  */
+		test this.  */
 	outw( 0x0, ioaddr + BANK_SELECT );
 	bank = inw( ioaddr + BANK_SELECT );
 	if ( (bank & 0xFF00 ) != 0x3300 ) {
@@ -879,7 +879,7 @@ static int __init smc_probe(struct net_device *dev, int ioaddr)
 		goto err_out;
 	}
 	/* well, we've already written once, so hopefully another time won't
- 	   hurt.  This time, I need to switch the bank register to bank 1,
+	   hurt.  This time, I need to switch the bank register to bank 1,
 	   so I can access the base address register */
 	SMC_SELECT_BANK(1);
 	base_address_register = inw( ioaddr + BASE );
@@ -917,7 +917,7 @@ static int __init smc_probe(struct net_device *dev, int ioaddr)
 	dev->base_addr = ioaddr;
 
 	/*
- 	 . Get the MAC address ( bank 1, regs 4 - 9 )
+	 . Get the MAC address ( bank 1, regs 4 - 9 )
 	*/
 	SMC_SELECT_BANK( 1 );
 	for ( i = 0; i < 6; i += 2 ) {
@@ -938,8 +938,8 @@ static int __init smc_probe(struct net_device *dev, int ioaddr)
 
 	/*
 	 Now, I want to find out more about the chip.  This is sort of
- 	 redundant, but it's cleaner to have it in both, rather than having
- 	 one VERY long probe procedure.
+	 redundant, but it's cleaner to have it in both, rather than having
+	 one VERY long probe procedure.
 	*/
 	SMC_SELECT_BANK(3);
 	revision_register  = inw( ioaddr + REVISION );
@@ -967,7 +967,7 @@ static int __init smc_probe(struct net_device *dev, int ioaddr)
 	/*
 	 . If dev->irq is 0, then the device has to be banged on to see
 	 . what the IRQ is.
- 	 .
+	 .
 	 . This banging doesn't always detect the IRQ, for unknown reasons.
 	 . a workaround is to reset the chip and try again.
 	 .
@@ -978,7 +978,7 @@ static int __init smc_probe(struct net_device *dev, int ioaddr)
 	 .
 	 . Specifying an IRQ is done with the assumption that the user knows
 	 . what (s)he is doing.  No checking is done!!!!
- 	 .
+	 .
 	*/
 	if ( dev->irq < 2 ) {
 		int	trials;
@@ -1070,7 +1070,7 @@ static int smc_open(struct net_device *dev)
 	}
 
 	/*
-  		According to Becker, I have to set the hardware address
+		According to Becker, I have to set the hardware address
 		at this point, because the (l)user can set it with an
 		ioctl.  Easily done...
 	*/
diff --git a/drivers/net/ethernet/smsc/smc91x.c b/drivers/net/ethernet/smsc/smc91x.c
index cbde83f..813ea94 100644
--- a/drivers/net/ethernet/smsc/smc91x.c
+++ b/drivers/net/ethernet/smsc/smc91x.c
@@ -671,19 +671,19 @@ smc_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 		status = SMC_GET_INT(lp);
 		if (status & IM_ALLOC_INT) {
 			SMC_ACK_INT(lp, IM_ALLOC_INT);
-  			break;
+			break;
 		}
-   	} while (--poll_count);
+	} while (--poll_count);
 
 	smc_special_unlock(&lp->lock, flags);
 
 	lp->pending_tx_skb = skb;
-   	if (!poll_count) {
+	if (!poll_count) {
 		/* oh well, wait until the chip finds memory later */
 		netif_stop_queue(dev);
 		DBG(2, dev, "TX memory allocation deferred.\n");
 		SMC_ENABLE_INT(lp, IM_ALLOC_INT);
-   	} else {
+	} else {
 		/*
 		 * Allocation succeeded: push packet to the chip's own memory
 		 * immediately.
@@ -1790,7 +1790,7 @@ static int smc_findirq(struct smc_local *lp)
 	SMC_SET_INT_MASK(lp, IM_ALLOC_INT);
 
 	/*
- 	 * Allocate 512 bytes of memory.  Note that the chip was just
+	 * Allocate 512 bytes of memory.  Note that the chip was just
 	 * reset so all the memory is available
 	 */
 	SMC_SET_MMU_CMD(lp, MC_ALLOC | 1);
@@ -1998,8 +1998,8 @@ static int smc_probe(struct net_device *dev, void __iomem *ioaddr,
 
 	/* Grab the IRQ */
 	retval = request_irq(dev->irq, smc_interrupt, irq_flags, dev->name, dev);
-      	if (retval)
-      		goto err_out;
+	if (retval)
+		goto err_out;
 
 #ifdef CONFIG_ARCH_PXA
 #  ifdef SMC_USE_PXA_DMA
-- 
2.8.1

