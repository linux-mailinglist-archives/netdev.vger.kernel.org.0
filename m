Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8D2E27A351
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 22:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbgI0T6k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 15:58:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726652AbgI0T6B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Sep 2020 15:58:01 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE5A2C0613DC;
        Sun, 27 Sep 2020 12:57:35 -0700 (PDT)
Message-Id: <20200927194922.153285901@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1601236654;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=xXgylEXhoyPkkzLOzIChZbSpGTn4L/d7DXfPRgoXSY4=;
        b=MmrDX5myreQt48S80hWpo/Yp+JNeEpTHJMbYoGYGoNahaxv8+XaCgfNX8I8mTqg+lY0ctK
        VQfwRtSieZawPzmXMc+cGAPhUFVRj8YhyWngvL23n3Zh2DXaPd7XobVdnUW3hYwffNmhlT
        s0RID8k+6IFztvwAzhnxSeAz1/ZfMjK8rvpE9JtNpkWUFTgRaDIj1Ncu8RQFPTbJzhwfS9
        xaYPVMPdZkBIBS7Z/gBkXBxJ+V8MSQnhDKXakKMsIwVgXZ5ehbv6G56k2nB+XqTgeqdd5g
        NUIx2d+kIj4QEe6ZEbdm9LYHBDMvOSi1bo+beeUUqOKYN6S0qtNH0ilRuFRQ+A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1601236654;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=xXgylEXhoyPkkzLOzIChZbSpGTn4L/d7DXfPRgoXSY4=;
        b=r39VYfmvzaPSRa9PpYTzy7aHOCBZ7xtp16DpqXE7uoAXCDOasGHJS/te/cnNshJB0sp6am
        8MqRRVIVhpJdN6AA==
Date:   Sun, 27 Sep 2020 21:49:09 +0200
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linuxfoundation.org>,
        Paul McKenney <paulmck@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Christian Benvenuti <benve@cisco.com>,
        Govindarajulu Varadarajan <_govind@gmx.com>,
        Dave Miller <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-doc@vger.kernel.org,
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
Subject: [patch 23/35] net: wan/lmc: Remove lmc_trace()
References: <20200927194846.045411263@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-transfer-encoding: 8-bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

lmc_trace() was first introduced in commit e7a392d5158af ("Import
2.3.99pre6-5") and was not touched ever since.

The reason for looking at this was to get rid of the in_interrupt() usage,
but while looking at it the following observations were made:

 - At least lmc_get_stats() (->ndo_get_stats()) is invoked with disabled
   preemption which is not detected by the in_interrupt() check, which
   would cause schedule() to be called from invalid context.

 - The code is hidden behind #ifdef LMC_TRACE which is not defined within
   the kernel and wasn't at the time it was introduced.

 - Three jiffies don't match 50ms. msleep() would be a better match which
   would also avoid the schedule() invocation. But why have it to begin
   with?

 - Nobody would do something like this today. Either netdev_dbg() or
   trace_printk() or a trace event would be used.  If only the functions
   related to this driver are interesting then ftrace can be used with
   filtering.

As it is obviously broken for years, simply remove it.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org

---
 drivers/net/wan/lmc/lmc_debug.c |   18 ------
 drivers/net/wan/lmc/lmc_debug.h |    1 
 drivers/net/wan/lmc/lmc_main.c  |  105 +++-------------------------------------
 drivers/net/wan/lmc/lmc_media.c |    4 -
 drivers/net/wan/lmc/lmc_proto.c |   16 ------
 5 files changed, 8 insertions(+), 136 deletions(-)

--- a/drivers/net/wan/lmc/lmc_debug.c
+++ b/drivers/net/wan/lmc/lmc_debug.c
@@ -62,22 +62,4 @@ void lmcEventLog(u32 EventNum, u32 arg2,
 }
 #endif  /*  DEBUG  */
 
-void lmc_trace(struct net_device *dev, char *msg){
-#ifdef LMC_TRACE
-    unsigned long j = jiffies + 3; /* Wait for 50 ms */
-
-    if(in_interrupt()){
-        printk("%s: * %s\n", dev->name, msg);
-//        while(time_before(jiffies, j+10))
-//            ;
-    }
-    else {
-        printk("%s: %s\n", dev->name, msg);
-        while(time_before(jiffies, j))
-            schedule();
-    }
-#endif
-}
-
-
 /* --------------------------- end if_lmc_linux.c ------------------------ */
--- a/drivers/net/wan/lmc/lmc_debug.h
+++ b/drivers/net/wan/lmc/lmc_debug.h
@@ -48,6 +48,5 @@ extern u32 lmcEventLogBuf[LMC_EVENTLOGSI
 
 void lmcConsoleLog(char *type, unsigned char *ucData, int iLen);
 void lmcEventLog(u32 EventNum, u32 arg2, u32 arg3);
-void lmc_trace(struct net_device *dev, char *msg);
 
 #endif
--- a/drivers/net/wan/lmc/lmc_main.c
+++ b/drivers/net/wan/lmc/lmc_main.c
@@ -113,8 +113,6 @@ int lmc_ioctl(struct net_device *dev, st
     u16 regVal;
     unsigned long flags;
 
-    lmc_trace(dev, "lmc_ioctl in");
-
     /*
      * Most functions mess with the structure
      * Disable interrupts while we do the polling
@@ -619,8 +617,6 @@ int lmc_ioctl(struct net_device *dev, st
         break;
     }
 
-    lmc_trace(dev, "lmc_ioctl out");
-
     return ret;
 }
 
@@ -634,8 +630,6 @@ static void lmc_watchdog(struct timer_li
     u32 ticks;
     unsigned long flags;
 
-    lmc_trace(dev, "lmc_watchdog in");
-
     spin_lock_irqsave(&sc->lmc_lock, flags);
 
     if(sc->check != 0xBEAFCAFE){
@@ -782,9 +776,6 @@ static void lmc_watchdog(struct timer_li
     add_timer (&sc->timer);
 
     spin_unlock_irqrestore(&sc->lmc_lock, flags);
-
-    lmc_trace(dev, "lmc_watchdog out");
-
 }
 
 static int lmc_attach(struct net_device *dev, unsigned short encoding,
@@ -813,8 +804,6 @@ static int lmc_init_one(struct pci_dev *
 	int err;
 	static int cards_found;
 
-	/* lmc_trace(dev, "lmc_init_one in"); */
-
 	err = pcim_enable_device(pdev);
 	if (err) {
 		printk(KERN_ERR "lmc: pci enable failed: %d\n", err);
@@ -955,7 +944,6 @@ static int lmc_init_one(struct pci_dev *
     sc->lmc_ok = 0;
     sc->last_link_status = 0;
 
-    lmc_trace(dev, "lmc_init_one out");
     return 0;
 }
 
@@ -981,8 +969,6 @@ static int lmc_open(struct net_device *d
     lmc_softc_t *sc = dev_to_sc(dev);
     int err;
 
-    lmc_trace(dev, "lmc_open in");
-
     lmc_led_on(sc, LMC_DS3_LED0);
 
     lmc_dec_reset(sc);
@@ -992,17 +978,14 @@ static int lmc_open(struct net_device *d
     LMC_EVENT_LOG(LMC_EVENT_RESET2, lmc_mii_readreg(sc, 0, 16),
 		  lmc_mii_readreg(sc, 0, 17));
 
-    if (sc->lmc_ok){
-        lmc_trace(dev, "lmc_open lmc_ok out");
+    if (sc->lmc_ok)
         return 0;
-    }
 
     lmc_softreset (sc);
 
     /* Since we have to use PCI bus, this should work on x86,alpha,ppc */
     if (request_irq (dev->irq, lmc_interrupt, IRQF_SHARED, dev->name, dev)){
         printk(KERN_WARNING "%s: could not get irq: %d\n", dev->name, dev->irq);
-        lmc_trace(dev, "lmc_open irq failed out");
         return -EAGAIN;
     }
     sc->got_irq = 1;
@@ -1078,8 +1061,6 @@ static int lmc_open(struct net_device *d
     sc->timer.expires = jiffies + HZ;
     add_timer (&sc->timer);
 
-    lmc_trace(dev, "lmc_open out");
-
     return 0;
 }
 
@@ -1091,8 +1072,6 @@ static void lmc_running_reset (struct ne
 {
     lmc_softc_t *sc = dev_to_sc(dev);
 
-    lmc_trace(dev, "lmc_running_reset in");
-
     /* stop interrupts */
     /* Clear the interrupt mask */
     LMC_CSR_WRITE (sc, csr_intr, 0x00000000);
@@ -1114,8 +1093,6 @@ static void lmc_running_reset (struct ne
 
     sc->lmc_cmdmode |= (TULIP_CMD_TXRUN | TULIP_CMD_RXRUN);
     LMC_CSR_WRITE (sc, csr_command, sc->lmc_cmdmode);
-
-    lmc_trace(dev, "lmc_running_reset_out");
 }
 
 
@@ -1128,16 +1105,12 @@ static int lmc_close(struct net_device *
     /* not calling release_region() as we should */
     lmc_softc_t *sc = dev_to_sc(dev);
 
-    lmc_trace(dev, "lmc_close in");
-
     sc->lmc_ok = 0;
     sc->lmc_media->set_link_status (sc, 0);
     del_timer (&sc->timer);
     lmc_proto_close(sc);
     lmc_ifdown (dev);
 
-    lmc_trace(dev, "lmc_close out");
-
     return 0;
 }
 
@@ -1149,8 +1122,6 @@ static int lmc_ifdown (struct net_device
     u32 csr6;
     int i;
 
-    lmc_trace(dev, "lmc_ifdown in");
-
     /* Don't let anything else go on right now */
     //    dev->start = 0;
     netif_stop_queue(dev);
@@ -1200,8 +1171,6 @@ static int lmc_ifdown (struct net_device
     netif_wake_queue(dev);
     sc->extra_stats.tx_tbusy0++;
 
-    lmc_trace(dev, "lmc_ifdown out");
-
     return 0;
 }
 
@@ -1220,8 +1189,6 @@ static irqreturn_t lmc_interrupt (int ir
     int max_work = LMC_RXDESCS;
     int handled = 0;
 
-    lmc_trace(dev, "lmc_interrupt in");
-
     spin_lock(&sc->lmc_lock);
 
     /*
@@ -1264,12 +1231,10 @@ static irqreturn_t lmc_interrupt (int ir
             lmc_running_reset (dev);
             break;
         }
-        
-        if (csr & TULIP_STS_RXINTR){
-            lmc_trace(dev, "rx interrupt");
+
+        if (csr & TULIP_STS_RXINTR)
             lmc_rx (dev);
-            
-        }
+
         if (csr & (TULIP_STS_TXINTR | TULIP_STS_TXNOBUF | TULIP_STS_TXSTOPPED)) {
 
 	    int		n_compl = 0 ;
@@ -1389,7 +1354,6 @@ static irqreturn_t lmc_interrupt (int ir
 
     spin_unlock(&sc->lmc_lock);
 
-    lmc_trace(dev, "lmc_interrupt out");
     return IRQ_RETVAL(handled);
 }
 
@@ -1401,8 +1365,6 @@ static netdev_tx_t lmc_start_xmit(struct
     int entry;
     unsigned long flags;
 
-    lmc_trace(dev, "lmc_start_xmit in");
-
     spin_lock_irqsave(&sc->lmc_lock, flags);
 
     /* normal path, tbusy known to be zero */
@@ -1477,7 +1439,6 @@ static netdev_tx_t lmc_start_xmit(struct
 
     spin_unlock_irqrestore(&sc->lmc_lock, flags);
 
-    lmc_trace(dev, "lmc_start_xmit_out");
     return NETDEV_TX_OK;
 }
 
@@ -1493,8 +1454,6 @@ static int lmc_rx(struct net_device *dev
     struct sk_buff *skb, *nsb;
     u16 len;
 
-    lmc_trace(dev, "lmc_rx in");
-
     lmc_led_on(sc, LMC_DS3_LED3);
 
     rxIntLoopCnt = 0;		/* debug -baz */
@@ -1673,9 +1632,6 @@ static int lmc_rx(struct net_device *dev
     lmc_led_off(sc, LMC_DS3_LED3);
 
 skip_out_of_mem:
-
-    lmc_trace(dev, "lmc_rx out");
-
     return 0;
 }
 
@@ -1684,16 +1640,12 @@ static struct net_device_stats *lmc_get_
     lmc_softc_t *sc = dev_to_sc(dev);
     unsigned long flags;
 
-    lmc_trace(dev, "lmc_get_stats in");
-
     spin_lock_irqsave(&sc->lmc_lock, flags);
 
     sc->lmc_device->stats.rx_missed_errors += LMC_CSR_READ(sc, csr_missed_frames) & 0xffff;
 
     spin_unlock_irqrestore(&sc->lmc_lock, flags);
 
-    lmc_trace(dev, "lmc_get_stats out");
-
     return &sc->lmc_device->stats;
 }
 
@@ -1712,12 +1664,8 @@ unsigned lmc_mii_readreg (lmc_softc_t *
     int command = (0xf6 << 10) | (devaddr << 5) | regno;
     int retval = 0;
 
-    lmc_trace(sc->lmc_device, "lmc_mii_readreg in");
-
     LMC_MII_SYNC (sc);
 
-    lmc_trace(sc->lmc_device, "lmc_mii_readreg: done sync");
-
     for (i = 15; i >= 0; i--)
     {
         int dataval = (command & (1 << i)) ? 0x20000 : 0;
@@ -1730,8 +1678,6 @@ unsigned lmc_mii_readreg (lmc_softc_t *
         /* __SLOW_DOWN_IO; */
     }
 
-    lmc_trace(sc->lmc_device, "lmc_mii_readreg: done1");
-
     for (i = 19; i > 0; i--)
     {
         LMC_CSR_WRITE (sc, csr_9, 0x40000);
@@ -1743,8 +1689,6 @@ unsigned lmc_mii_readreg (lmc_softc_t *
         /* __SLOW_DOWN_IO; */
     }
 
-    lmc_trace(sc->lmc_device, "lmc_mii_readreg out");
-
     return (retval >> 1) & 0xffff;
 }
 
@@ -1753,8 +1697,6 @@ void lmc_mii_writereg (lmc_softc_t * con
     int i = 32;
     int command = (0x5002 << 16) | (devaddr << 23) | (regno << 18) | data;
 
-    lmc_trace(sc->lmc_device, "lmc_mii_writereg in");
-
     LMC_MII_SYNC (sc);
 
     i = 31;
@@ -1787,16 +1729,12 @@ void lmc_mii_writereg (lmc_softc_t * con
         /* __SLOW_DOWN_IO; */
         i--;
     }
-
-    lmc_trace(sc->lmc_device, "lmc_mii_writereg out");
 }
 
 static void lmc_softreset (lmc_softc_t * const sc) /*fold00*/
 {
     int i;
 
-    lmc_trace(sc->lmc_device, "lmc_softreset in");
-
     /* Initialize the receive rings and buffers. */
     sc->lmc_txfull = 0;
     sc->lmc_next_rx = 0;
@@ -1871,55 +1809,40 @@ static void lmc_softreset (lmc_softc_t *
     }
     sc->lmc_txring[i - 1].buffer2 = virt_to_bus (&sc->lmc_txring[0]);
     LMC_CSR_WRITE (sc, csr_txlist, virt_to_bus (sc->lmc_txring));
-
-    lmc_trace(sc->lmc_device, "lmc_softreset out");
 }
 
 void lmc_gpio_mkinput(lmc_softc_t * const sc, u32 bits) /*fold00*/
 {
-    lmc_trace(sc->lmc_device, "lmc_gpio_mkinput in");
     sc->lmc_gpio_io &= ~bits;
     LMC_CSR_WRITE(sc, csr_gp, TULIP_GP_PINSET | (sc->lmc_gpio_io));
-    lmc_trace(sc->lmc_device, "lmc_gpio_mkinput out");
 }
 
 void lmc_gpio_mkoutput(lmc_softc_t * const sc, u32 bits) /*fold00*/
 {
-    lmc_trace(sc->lmc_device, "lmc_gpio_mkoutput in");
     sc->lmc_gpio_io |= bits;
     LMC_CSR_WRITE(sc, csr_gp, TULIP_GP_PINSET | (sc->lmc_gpio_io));
-    lmc_trace(sc->lmc_device, "lmc_gpio_mkoutput out");
 }
 
 void lmc_led_on(lmc_softc_t * const sc, u32 led) /*fold00*/
 {
-    lmc_trace(sc->lmc_device, "lmc_led_on in");
-    if((~sc->lmc_miireg16) & led){ /* Already on! */
-        lmc_trace(sc->lmc_device, "lmc_led_on aon out");
+    if ((~sc->lmc_miireg16) & led) /* Already on! */
         return;
-    }
-    
+
     sc->lmc_miireg16 &= ~led;
     lmc_mii_writereg(sc, 0, 16, sc->lmc_miireg16);
-    lmc_trace(sc->lmc_device, "lmc_led_on out");
 }
 
 void lmc_led_off(lmc_softc_t * const sc, u32 led) /*fold00*/
 {
-    lmc_trace(sc->lmc_device, "lmc_led_off in");
-    if(sc->lmc_miireg16 & led){ /* Already set don't do anything */
-        lmc_trace(sc->lmc_device, "lmc_led_off aoff out");
+    if (sc->lmc_miireg16 & led) /* Already set don't do anything */
         return;
-    }
-    
+
     sc->lmc_miireg16 |= led;
     lmc_mii_writereg(sc, 0, 16, sc->lmc_miireg16);
-    lmc_trace(sc->lmc_device, "lmc_led_off out");
 }
 
 static void lmc_reset(lmc_softc_t * const sc) /*fold00*/
 {
-    lmc_trace(sc->lmc_device, "lmc_reset in");
     sc->lmc_miireg16 |= LMC_MII16_FIFO_RESET;
     lmc_mii_writereg(sc, 0, 16, sc->lmc_miireg16);
 
@@ -1955,13 +1878,11 @@ static void lmc_reset(lmc_softc_t * cons
     sc->lmc_media->init(sc);
 
     sc->extra_stats.resetCount++;
-    lmc_trace(sc->lmc_device, "lmc_reset out");
 }
 
 static void lmc_dec_reset(lmc_softc_t * const sc) /*fold00*/
 {
     u32 val;
-    lmc_trace(sc->lmc_device, "lmc_dec_reset in");
 
     /*
      * disable all interrupts
@@ -2017,14 +1938,11 @@ static void lmc_dec_reset(lmc_softc_t *
     val = LMC_CSR_READ(sc, csr_sia_general);
     val |= (TULIP_WATCHDOG_TXDISABLE | TULIP_WATCHDOG_RXDISABLE);
     LMC_CSR_WRITE(sc, csr_sia_general, val);
-
-    lmc_trace(sc->lmc_device, "lmc_dec_reset out");
 }
 
 static void lmc_initcsrs(lmc_softc_t * const sc, lmc_csrptr_t csr_base, /*fold00*/
                          size_t csr_size)
 {
-    lmc_trace(sc->lmc_device, "lmc_initcsrs in");
     sc->lmc_csrs.csr_busmode	        = csr_base +  0 * csr_size;
     sc->lmc_csrs.csr_txpoll		= csr_base +  1 * csr_size;
     sc->lmc_csrs.csr_rxpoll		= csr_base +  2 * csr_size;
@@ -2041,7 +1959,6 @@ static void lmc_initcsrs(lmc_softc_t * c
     sc->lmc_csrs.csr_13		        = csr_base + 13 * csr_size;
     sc->lmc_csrs.csr_14		        = csr_base + 14 * csr_size;
     sc->lmc_csrs.csr_15		        = csr_base + 15 * csr_size;
-    lmc_trace(sc->lmc_device, "lmc_initcsrs out");
 }
 
 static void lmc_driver_timeout(struct net_device *dev, unsigned int txqueue)
@@ -2050,8 +1967,6 @@ static void lmc_driver_timeout(struct ne
     u32 csr6;
     unsigned long flags;
 
-    lmc_trace(dev, "lmc_driver_timeout in");
-
     spin_lock_irqsave(&sc->lmc_lock, flags);
 
     printk("%s: Xmitter busy|\n", dev->name);
@@ -2094,8 +2009,4 @@ static void lmc_driver_timeout(struct ne
 bug_out:
 
     spin_unlock_irqrestore(&sc->lmc_lock, flags);
-
-    lmc_trace(dev, "lmc_driver_timeout out");
-
-
 }
--- a/drivers/net/wan/lmc/lmc_media.c
+++ b/drivers/net/wan/lmc/lmc_media.c
@@ -1026,7 +1026,6 @@ lmc_t1_get_link_status (lmc_softc_t * co
    * led3 red    = Loss of Signal (LOS) or out of frame (OOF)
    *               conditions detected on T3 receive signal
    */
-    lmc_trace(sc->lmc_device, "lmc_t1_get_link_status in");
     lmc_led_on(sc, LMC_DS3_LED2);
 
     lmc_mii_writereg (sc, 0, 17, T1FRAMER_ALARM1_STATUS);
@@ -1120,9 +1119,6 @@ lmc_t1_get_link_status (lmc_softc_t * co
     lmc_mii_writereg (sc, 0, 17, T1FRAMER_ALARM2_STATUS);
     sc->lmc_xinfo.t1_alarm2_status = lmc_mii_readreg (sc, 0, 18);
 
-    
-    lmc_trace(sc->lmc_device, "lmc_t1_get_link_status out");
-
     return ret;
 }
 
--- a/drivers/net/wan/lmc/lmc_proto.c
+++ b/drivers/net/wan/lmc/lmc_proto.c
@@ -47,7 +47,6 @@
 // attach
 void lmc_proto_attach(lmc_softc_t *sc) /*FOLD00*/
 {
-    lmc_trace(sc->lmc_device, "lmc_proto_attach in");
     if (sc->if_type == LMC_NET) {
             struct net_device *dev = sc->lmc_device;
             /*
@@ -57,12 +56,10 @@ void lmc_proto_attach(lmc_softc_t *sc) /
             dev->hard_header_len = 0;
             dev->addr_len = 0;
         }
-    lmc_trace(sc->lmc_device, "lmc_proto_attach out");
 }
 
 int lmc_proto_ioctl(lmc_softc_t *sc, struct ifreq *ifr, int cmd)
 {
-	lmc_trace(sc->lmc_device, "lmc_proto_ioctl");
 	if (sc->if_type == LMC_PPP)
 		return hdlc_ioctl(sc->lmc_device, ifr, cmd);
 	return -EOPNOTSUPP;
@@ -72,32 +69,23 @@ int lmc_proto_open(lmc_softc_t *sc)
 {
 	int ret = 0;
 
-	lmc_trace(sc->lmc_device, "lmc_proto_open in");
-
 	if (sc->if_type == LMC_PPP) {
 		ret = hdlc_open(sc->lmc_device);
 		if (ret < 0)
 			printk(KERN_WARNING "%s: HDLC open failed: %d\n",
 			       sc->name, ret);
 	}
-
-	lmc_trace(sc->lmc_device, "lmc_proto_open out");
 	return ret;
 }
 
 void lmc_proto_close(lmc_softc_t *sc)
 {
-	lmc_trace(sc->lmc_device, "lmc_proto_close in");
-
 	if (sc->if_type == LMC_PPP)
 		hdlc_close(sc->lmc_device);
-
-	lmc_trace(sc->lmc_device, "lmc_proto_close out");
 }
 
 __be16 lmc_proto_type(lmc_softc_t *sc, struct sk_buff *skb) /*FOLD00*/
 {
-    lmc_trace(sc->lmc_device, "lmc_proto_type in");
     switch(sc->if_type){
     case LMC_PPP:
 	    return hdlc_type_trans(skb, sc->lmc_device);
@@ -113,13 +101,10 @@ void lmc_proto_close(lmc_softc_t *sc)
         return htons(ETH_P_802_2);
         break;
     }
-    lmc_trace(sc->lmc_device, "lmc_proto_tye out");
-
 }
 
 void lmc_proto_netif(lmc_softc_t *sc, struct sk_buff *skb) /*FOLD00*/
 {
-    lmc_trace(sc->lmc_device, "lmc_proto_netif in");
     switch(sc->if_type){
     case LMC_PPP:
     case LMC_NET:
@@ -129,5 +114,4 @@ void lmc_proto_netif(lmc_softc_t *sc, st
     case LMC_RAW:
         break;
     }
-    lmc_trace(sc->lmc_device, "lmc_proto_netif out");
 }

