Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAAD96E0FB6
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 16:13:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230473AbjDMONN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 10:13:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230209AbjDMONM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 10:13:12 -0400
Received: from h1.cmg1.smtp.forpsi.com (h1.cmg1.smtp.forpsi.com [81.2.195.162])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7A1826BA
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 07:13:10 -0700 (PDT)
Received: from lenoch ([91.218.190.200])
        by cmgsmtp with ESMTPSA
        id mxhDpEho1Pm6CmxhEpKchO; Thu, 13 Apr 2023 16:13:08 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=triops.cz; s=f2019;
        t=1681395189; bh=eRHsidDVNRs2M1+VN+3eusBdsnRkuZeVQ3Wznm+7910=;
        h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
        b=MC58rDro3QaZCutFrj0WHj6AMq57eBtpWE6O41bh5fJUjjmyLu1RRztfUAVoGGIm5
         mJq2LpHH2ouNRlULgMzgaoXfqBri3k6nSzEV1dbpU0OoU9cLMZldC47D8gCWEciCbE
         mdGnWUtJsxbYBuKKofv21WdON4g8nDb2rD7Q2n44JQsIp82ifTWfV1FW7NTVWDj4Sp
         3DQmHjvUAfjQZNyAZQ4tnz5HCiBA6ZwDlg1vKZ1azfRmY8Bxu8caaViCF7YGCLXdPE
         PnLkYvnIRifxb6cKx/kf1lCGY6S4on7FgqA5ZXYaN/2hL7d07Zgz5KgYUxX0EJ0g41
         SUj5DKbXa07Dw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=triops.cz; s=f2019;
        t=1681395188; bh=eRHsidDVNRs2M1+VN+3eusBdsnRkuZeVQ3Wznm+7910=;
        h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
        b=UchwybpYIpHyKj+trxCOHoCZUjPb3waAUXRrYEuo3+12oBgK38Vo/mam3K7/D0mJZ
         3A4HlrBg0gQYSJBT5tqD9JeDJKkLj7YC8VwTh039DnEYrAMnVtNPAYpw2EUqKdPGKk
         0yZVP0fzwcrMfVRULkKgn0Vod7KH2RvvaGAd1Cn0zzYWMR2N63vMA0XuXQNjN3HEfz
         20ypBgHxX72bQLK3f2GM3lqg6Zjfsp43KSyz2bz9TvNHp6X1dsNVJOgkjtzgpwH83a
         uoc1UKgnV+/Ycw6j63TJeVJSpBuGl4fasv4HqdcR6w9GZh1C6H1/mt5u+e728QB8MX
         g0l0yt2cqAL0A==
Date:   Thu, 13 Apr 2023 16:13:07 +0200
From:   Ladislav Michl <oss-lists@triops.cz>
To:     linux-staging@lists.linux.dev
Cc:     netdev@vger.kernel.org, linux-mips@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>
Subject: [PATCH 1/3] staging: octeon: don't panic
Message-ID: <ZDgN8/IcFc3ZXkeC@lenoch>
References: <ZDgNexVTEfyGo77d@lenoch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZDgNexVTEfyGo77d@lenoch>
X-CMAE-Envelope: MS4wfGSUgvGZsGiQ2QUfSG2dtv0L2CVYoffxI9HjN0JXtcLfpSYUcAC7ZB69AlVV76rl0VWakwKvu6G7/t3O2WA6Fp7/duGQjp8acWlXACAAJGsz3GrZ7Mc1
 WvdolzbEu7ImGwif9zi5HE/jhkq39JDOgnHRqoKpWQdhPqPJk3xk1w1/8K9K+cGmwhZKVXBrb0hDu5EKCGcrkyB8D0mv/GL7irV+ml8o1ZnIWC6lytlsxd5v
 f2EgLEljqB/zI9R+5pyY8D5YqaAIwSgUA7oVHL2qsf1zBub9yLnfeqLZ5EPKBVMf
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ladislav Michl <ladis@linux-mips.org>

It is unfortunate to halt kernel just because no network
interfaces was registered.

Signed-off-by: Ladislav Michl <ladis@linux-mips.org>
---
 drivers/staging/octeon/ethernet-rx.c | 33 +++++++++++++++++++++++-----
 drivers/staging/octeon/ethernet-rx.h |  2 +-
 drivers/staging/octeon/ethernet-tx.c | 16 ++++++++------
 drivers/staging/octeon/ethernet-tx.h |  2 +-
 drivers/staging/octeon/ethernet.c    | 31 ++++++++++++++++++++++----
 5 files changed, 66 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/octeon/ethernet-rx.c b/drivers/staging/octeon/ethernet-rx.c
index 965330eec80a..24ae4b3bd58b 100644
--- a/drivers/staging/octeon/ethernet-rx.c
+++ b/drivers/staging/octeon/ethernet-rx.c
@@ -448,7 +448,7 @@ void cvm_oct_poll_controller(struct net_device *dev)
 }
 #endif
 
-void cvm_oct_rx_initialize(void)
+int cvm_oct_rx_initialize(void)
 {
 	int i;
 	struct net_device *dev_for_napi = NULL;
@@ -460,8 +460,11 @@ void cvm_oct_rx_initialize(void)
 		}
 	}
 
-	if (!dev_for_napi)
-		panic("No net_devices were allocated.");
+	if (!dev_for_napi) {
+		pr_err("No net_devices were allocated.");
+		return -ENODEV;
+	}
+
 
 	for (i = 0; i < ARRAY_SIZE(oct_rx_group); i++) {
 		int ret;
@@ -479,10 +482,28 @@ void cvm_oct_rx_initialize(void)
 		/* Register an IRQ handler to receive POW interrupts */
 		ret = request_irq(oct_rx_group[i].irq, cvm_oct_do_interrupt, 0,
 				  "Ethernet", &oct_rx_group[i].napi);
-		if (ret)
-			panic("Could not acquire Ethernet IRQ %d\n",
+		if (ret) {
+			int j;
+
+			pr_err("Could not acquire Ethernet IRQ %d\n",
 			      oct_rx_group[i].irq);
 
+			for (j = 0; j < i; j++) {
+				if (!(pow_receive_groups & BIT(j)))
+					continue;
+
+				cvmx_write_csr(OCTEON_IS_MODEL(OCTEON_CN68XX) ?
+						CVMX_SSO_WQ_INT_THRX(j) :
+						CVMX_POW_WQ_INT_THRX(j),
+						0);
+				free_irq(oct_rx_group[j].irq, cvm_oct_device);
+				netif_napi_del(&oct_rx_group[j].napi);
+			}
+
+			return ret;
+		}
+
+
 		disable_irq_nosync(oct_rx_group[i].irq);
 
 		/* Enable POW interrupt when our port has at least one packet */
@@ -518,6 +539,8 @@ void cvm_oct_rx_initialize(void)
 		napi_schedule(&oct_rx_group[i].napi);
 	}
 	atomic_inc(&oct_rx_ready);
+
+	return 0;
 }
 
 void cvm_oct_rx_shutdown(void)
diff --git a/drivers/staging/octeon/ethernet-rx.h b/drivers/staging/octeon/ethernet-rx.h
index ff6482fa20d6..9a98f662d813 100644
--- a/drivers/staging/octeon/ethernet-rx.h
+++ b/drivers/staging/octeon/ethernet-rx.h
@@ -6,7 +6,7 @@
  */
 
 void cvm_oct_poll_controller(struct net_device *dev);
-void cvm_oct_rx_initialize(void);
+int cvm_oct_rx_initialize(void);
 void cvm_oct_rx_shutdown(void);
 
 static inline void cvm_oct_rx_refill_pool(int fill_threshold)
diff --git a/drivers/staging/octeon/ethernet-tx.c b/drivers/staging/octeon/ethernet-tx.c
index a36e36701c74..c02b023ac8c0 100644
--- a/drivers/staging/octeon/ethernet-tx.c
+++ b/drivers/staging/octeon/ethernet-tx.c
@@ -694,19 +694,21 @@ static irqreturn_t cvm_oct_tx_cleanup_watchdog(int cpl, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-void cvm_oct_tx_initialize(void)
+int cvm_oct_tx_initialize(void)
 {
-	int i;
+	int ret;
 
 	/* Disable the interrupt.  */
 	cvmx_write_csr(CVMX_CIU_TIMX(1), 0);
 	/* Register an IRQ handler to receive CIU_TIMX(1) interrupts */
-	i = request_irq(OCTEON_IRQ_TIMER1,
-			cvm_oct_tx_cleanup_watchdog, 0,
-			"Ethernet", cvm_oct_device);
+	ret = request_irq(OCTEON_IRQ_TIMER1,
+			  cvm_oct_tx_cleanup_watchdog, 0,
+			  "Ethernet", cvm_oct_device);
+
+	if (ret)
+		pr_err("Could not acquire Ethernet IRQ %d\n", OCTEON_IRQ_TIMER1);
 
-	if (i)
-		panic("Could not acquire Ethernet IRQ %d\n", OCTEON_IRQ_TIMER1);
+	return ret;
 }
 
 void cvm_oct_tx_shutdown(void)
diff --git a/drivers/staging/octeon/ethernet-tx.h b/drivers/staging/octeon/ethernet-tx.h
index 6c524668f65a..b4e328a4b499 100644
--- a/drivers/staging/octeon/ethernet-tx.h
+++ b/drivers/staging/octeon/ethernet-tx.h
@@ -9,6 +9,6 @@ netdev_tx_t cvm_oct_xmit(struct sk_buff *skb, struct net_device *dev);
 netdev_tx_t cvm_oct_xmit_pow(struct sk_buff *skb, struct net_device *dev);
 int cvm_oct_transmit_qos(struct net_device *dev, void *work_queue_entry,
 			 int do_free, int qos);
-void cvm_oct_tx_initialize(void);
+int cvm_oct_tx_initialize(void);
 void cvm_oct_tx_shutdown(void);
 void cvm_oct_tx_shutdown_dev(struct net_device *dev);
diff --git a/drivers/staging/octeon/ethernet.c b/drivers/staging/octeon/ethernet.c
index f662739137b5..949ef51bf896 100644
--- a/drivers/staging/octeon/ethernet.c
+++ b/drivers/staging/octeon/ethernet.c
@@ -672,6 +672,8 @@ static void cvm_set_rgmii_delay(struct octeon_ethernet *priv, int iface,
 
 static int cvm_oct_probe(struct platform_device *pdev)
 {
+	int ret;
+	int port;
 	int num_interfaces;
 	int interface;
 	int fau = FAU_NUM_PACKET_BUFFERS_TO_FREE;
@@ -705,7 +707,6 @@ static int cvm_oct_probe(struct platform_device *pdev)
 	num_interfaces = cvmx_helper_get_number_of_interfaces();
 	for (interface = 0; interface < num_interfaces; interface++) {
 		int num_ports = cvmx_helper_ports_on_interface(interface);
-		int port;
 
 		for (port = cvmx_helper_get_ipd_port(interface, 0);
 		     port < cvmx_helper_get_ipd_port(interface, num_ports);
@@ -801,7 +802,6 @@ static int cvm_oct_probe(struct platform_device *pdev)
 		cvmx_helper_interface_mode_t imode =
 		    cvmx_helper_interface_get_mode(interface);
 		int num_ports = cvmx_helper_ports_on_interface(interface);
-		int port;
 		int port_index;
 
 		for (port_index = 0,
@@ -911,8 +911,15 @@ static int cvm_oct_probe(struct platform_device *pdev)
 		}
 	}
 
-	cvm_oct_tx_initialize();
-	cvm_oct_rx_initialize();
+	ret = cvm_oct_tx_initialize();
+	if (ret)
+		goto err;
+
+	ret = cvm_oct_rx_initialize();
+	if (ret) {
+		cvm_oct_tx_shutdown();
+		goto err;
+	}
 
 	/*
 	 * 150 uS: about 10 1500-byte packets at 1GE.
@@ -922,6 +929,22 @@ static int cvm_oct_probe(struct platform_device *pdev)
 	schedule_delayed_work(&cvm_oct_rx_refill_work, HZ);
 
 	return 0;
+
+err:
+	for (port = 0; port < TOTAL_NUMBER_OF_PORTS; port++) {
+		if (cvm_oct_device[port]) {
+			struct net_device *dev = cvm_oct_device[port];
+			struct octeon_ethernet *priv = netdev_priv(dev);
+
+			cancel_delayed_work_sync(&priv->port_periodic_work);
+
+			unregister_netdev(dev);
+			free_netdev(dev);
+			cvm_oct_device[port] = NULL;
+		}
+	}
+
+	return ret;
 }
 
 static int cvm_oct_remove(struct platform_device *pdev)
-- 
2.32.0

