Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 930D929592F
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 09:28:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2508538AbgJVH20 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 03:28:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2506485AbgJVH20 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 03:28:26 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F9CCC0613CE;
        Thu, 22 Oct 2020 00:28:26 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id f38so132253pgm.2;
        Thu, 22 Oct 2020 00:28:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fStkQlxg3T/4rnLy7CIFn3fN0C2GhcUNEwg9KOFvQCM=;
        b=tORqHMws4mDs3nMt9NhE6zKmAzpY9rmmkEvO0itdM4symptPVltZ4WpyTU1B3Tnz3e
         OYI0wx8g/Q0pWodeUZVizGj510htYgfnxYvPvBnt1HhmuJkcVxLwHRoj42babJh3pYnC
         ZPhBm0qqGoGwjZRHE2hpPKrwz7Re5SuMcni+rYvOfPEomCiWW3SfHHqWc6VR5NWf0dKz
         b8TQnLrqBUXbMtaeO3zPrv9bGRss/svPP2QCi9dMsOiPgPgGDFVC54DxkeoLNazFXN5p
         ACUXxtCz1FErQd1+CQjX8HDYFo6GyUmBZPkE0ul3paRMuq5RXNkvmvpN5Blsi5K13VHU
         V1xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fStkQlxg3T/4rnLy7CIFn3fN0C2GhcUNEwg9KOFvQCM=;
        b=qmHReVBefORj8TA9XaAdyGvNjn+wR58KMdmXrqIy9p4GrgCJtknuXcjurZYIdWvO4f
         CS4iCb478V/L/QDV9CxMPuoF4Ub/mM7PxpVi4I6LwN8txZgzHhnahxv6AKLAeewyGkwJ
         juwHKEmIDvcf2vDgd5uviMtlRzgg+pBiHtlFTR0MjdL+hnMAtvMMPIM//H5XEvmGztl+
         tu+HH6SSOwohBKvS3/4qCaUlxS5CFWHww7NNdThASJlEbRlJUAw0MmsWogtpSR5RaLAt
         IT7n4++en9JQ6bQtI0kj0i+QnPzg2mLUa5k3RMkhaMU1eGuu4ynOzIbeWUQcZpb+OlsQ
         1zFw==
X-Gm-Message-State: AOAM531brpjFidUv+zyes9ptnFl3GjlzQzbCq1+dWtaA6fLP0HCD0rBf
        mH9njwrzKlyQNsbRqIsNjdj3mybnNwY=
X-Google-Smtp-Source: ABdhPJxMkG9Imblx2hHqnY2MJj4X1rzoJ4B80t7i0RznUPm+cwsyphu9gvvXJKdJq2p4F2cj68CmUQ==
X-Received: by 2002:a63:c00c:: with SMTP id h12mr1144361pgg.237.1603351705469;
        Thu, 22 Oct 2020 00:28:25 -0700 (PDT)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:4020:7b75:f94b:e415])
        by smtp.gmail.com with ESMTPSA id w6sm1103759pfj.137.2020.10.22.00.28.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2020 00:28:24 -0700 (PDT)
From:   Xie He <xie.he.0141@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>
Cc:     Xie He <xie.he.0141@gmail.com>
Subject: [PATCH net RFC] net: Clear IFF_TX_SKB_SHARING for all Ethernet devices using skb_padto
Date:   Thu, 22 Oct 2020 00:28:14 -0700
Message-Id: <20201022072814.91560-1-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ether_setup function adds the IFF_TX_SKB_SHARING flag to the
device. This flag indicates that it is safe to transmit shared skbs to
the device.

However, this is not true for many Ethernet devices. Many Ethernet
drivers would call skb_pad or skb_padto on the transmission path,
which modify the skb. So it would not be safe to transmit shared skbs to
these devices.

I grepped "skb_padto" under "drivers/net/ethernet", and attempted to fix
all drivers that show up, by clearing the IFF_TX_SKB_SHARING flag for
them.

This patch only tries to fix drivers under "drivers/net/ethernet" that
use "skb_padto". There are other drivers in the kernel also need to be
fixed. It's hard for me to cover all because they are too many.

Another simpler solution is to simply remove IFF_TX_SKB_SHARING from
ether_setup. That would solve all problems and may also make the code
cleaner. So I'm not sure this patch is the best solution. This is why
I'm sending this as a RFC.

For any source file that calls "skb_padto", I searched "alloc_etherdev"
in it. Once found, I added the flag clearing code after it.

Some files that call "skb_padto" don't have "alloc_etherdev" in it,
because the dev is allocated in other files in the same directory.
These files include:

1. drivers/net/ethernet/natsemi/sonic.c:

skb_padto called in sonic_send_packet.
sonic_send_packet is used in xtsonic.c, macsonic.c, jazzsonic.c.

2. drivers/net/ethernet/arc/emac_main.c:

skb_padto called in arc_emac_tx.
arc_emac_tx is used as arc_emac_netdev_ops.ndo_start_xmit.
arc_emac_netdev_ops is used in arc_emac_probe.
arc_emac_probe is used in emac_rockchip.c and emac_arc.c.

Also, the following file is skipped because I couldn't find the
corresponding dev allocation code.

drivers/net/ethernet/i825xx/lib82596.c:

skb_padto called in i596_start_xmit.
i596_start_xmit is used as i596_netdev_ops.ndo_start_xmit.
i596_netdev_ops is used in i82596_probe.
i82596_probe is used nowhere in this file,
and because it is a static function, it cannot be used anywhere else.

Fixes: 550fd08c2ceb ("net: Audit drivers to identify those needing IFF_TX_SKB_SHARING cleared")
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
---
 drivers/net/ethernet/adaptec/starfire.c           | 2 ++
 drivers/net/ethernet/amd/a2065.c                  | 2 ++
 drivers/net/ethernet/amd/ariadne.c                | 2 ++
 drivers/net/ethernet/amd/atarilance.c             | 3 +++
 drivers/net/ethernet/amd/declance.c               | 2 ++
 drivers/net/ethernet/amd/lance.c                  | 5 +++++
 drivers/net/ethernet/apm/xgene/xgene_enet_main.c  | 2 ++
 drivers/net/ethernet/arc/emac_arc.c               | 3 +++
 drivers/net/ethernet/arc/emac_rockchip.c          | 3 +++
 drivers/net/ethernet/fujitsu/fmvj18x_cs.c         | 3 +++
 drivers/net/ethernet/i825xx/82596.c               | 2 ++
 drivers/net/ethernet/i825xx/ether1.c              | 2 ++
 drivers/net/ethernet/intel/igc/igc_main.c         | 2 ++
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c | 2 ++
 drivers/net/ethernet/marvell/skge.c               | 2 ++
 drivers/net/ethernet/natsemi/jazzsonic.c          | 2 ++
 drivers/net/ethernet/natsemi/macsonic.c           | 2 ++
 drivers/net/ethernet/natsemi/xtsonic.c            | 2 ++
 drivers/net/ethernet/packetengines/yellowfin.c    | 2 ++
 drivers/net/ethernet/seeq/ether3.c                | 2 ++
 drivers/net/ethernet/seeq/sgiseeq.c               | 2 ++
 drivers/net/ethernet/sis/sis190.c                 | 2 ++
 drivers/net/ethernet/smsc/epic100.c               | 2 ++
 drivers/net/ethernet/smsc/smc9194.c               | 2 ++
 drivers/net/ethernet/sun/cassini.c                | 3 +++
 drivers/net/ethernet/ti/cpmac.c                   | 2 ++
 drivers/net/ethernet/ti/cpsw.c                    | 4 ++++
 drivers/net/ethernet/ti/cpsw_new.c                | 2 ++
 drivers/net/ethernet/ti/davinci_emac.c            | 2 ++
 drivers/net/ethernet/ti/netcp_core.c              | 2 ++
 drivers/net/ethernet/ti/tlan.c                    | 3 +++
 drivers/net/ethernet/via/via-rhine.c              | 3 +++
 drivers/net/ethernet/via/via-velocity.c           | 2 ++
 drivers/net/ethernet/xircom/xirc2ps_cs.c          | 3 +++
 34 files changed, 81 insertions(+)

diff --git a/drivers/net/ethernet/adaptec/starfire.c b/drivers/net/ethernet/adaptec/starfire.c
index 555299737b51..66c2a29d736f 100644
--- a/drivers/net/ethernet/adaptec/starfire.c
+++ b/drivers/net/ethernet/adaptec/starfire.c
@@ -655,16 +655,18 @@ static int starfire_init_one(struct pci_dev *pdev,
 		dev_err(d, "no PCI MEM resources, aborting\n");
 		return -ENODEV;
 	}
 
 	dev = alloc_etherdev(sizeof(*np));
 	if (!dev)
 		return -ENOMEM;
 
+	dev->priv_flags &= ~IFF_TX_SKB_SHARING;
+
 	SET_NETDEV_DEV(dev, &pdev->dev);
 
 	irq = pdev->irq;
 
 	if (pci_request_regions (pdev, DRV_NAME)) {
 		dev_err(d, "cannot reserve PCI resources, aborting\n");
 		goto err_out_free_netdev;
 	}
diff --git a/drivers/net/ethernet/amd/a2065.c b/drivers/net/ethernet/amd/a2065.c
index 2f808dbc8b0e..75c87efae7d6 100644
--- a/drivers/net/ethernet/amd/a2065.c
+++ b/drivers/net/ethernet/amd/a2065.c
@@ -695,16 +695,18 @@ static int a2065_init_one(struct zorro_dev *z,
 
 	dev = alloc_etherdev(sizeof(struct lance_private));
 	if (dev == NULL) {
 		release_mem_region(base_addr, sizeof(struct lance_regs));
 		release_mem_region(mem_start, A2065_RAM_SIZE);
 		return -ENOMEM;
 	}
 
+	dev->priv_flags &= ~IFF_TX_SKB_SHARING;
+
 	priv = netdev_priv(dev);
 
 	r1->name = dev->name;
 	r2->name = dev->name;
 
 	serial = be32_to_cpu(z->rom.er_SerialNumber);
 	dev->dev_addr[0] = 0x00;
 	if (z->id != ZORRO_PROD_AMERISTAR_A2065) {	/* Commodore */
diff --git a/drivers/net/ethernet/amd/ariadne.c b/drivers/net/ethernet/amd/ariadne.c
index 5e0f645f5bde..1d8036ae107d 100644
--- a/drivers/net/ethernet/amd/ariadne.c
+++ b/drivers/net/ethernet/amd/ariadne.c
@@ -731,16 +731,18 @@ static int ariadne_init_one(struct zorro_dev *z,
 
 	dev = alloc_etherdev(sizeof(struct ariadne_private));
 	if (dev == NULL) {
 		release_mem_region(base_addr, sizeof(struct Am79C960));
 		release_mem_region(mem_start, ARIADNE_RAM_SIZE);
 		return -ENOMEM;
 	}
 
+	dev->priv_flags &= ~IFF_TX_SKB_SHARING;
+
 	r1->name = dev->name;
 	r2->name = dev->name;
 
 	serial = be32_to_cpu(z->rom.er_SerialNumber);
 	dev->dev_addr[0] = 0x00;
 	dev->dev_addr[1] = 0x60;
 	dev->dev_addr[2] = 0x30;
 	dev->dev_addr[3] = (serial >> 16) & 0xff;
diff --git a/drivers/net/ethernet/amd/atarilance.c b/drivers/net/ethernet/amd/atarilance.c
index 961796abab35..36de5d438c32 100644
--- a/drivers/net/ethernet/amd/atarilance.c
+++ b/drivers/net/ethernet/amd/atarilance.c
@@ -377,16 +377,19 @@ struct net_device * __init atarilance_probe(int unit)
 	if (!MACH_IS_ATARI || found)
 		/* Assume there's only one board possible... That seems true, since
 		 * the Riebl/PAM board's address cannot be changed. */
 		return ERR_PTR(-ENODEV);
 
 	dev = alloc_etherdev(sizeof(struct lance_private));
 	if (!dev)
 		return ERR_PTR(-ENOMEM);
+
+	dev->priv_flags &= ~IFF_TX_SKB_SHARING;
+
 	if (unit >= 0) {
 		sprintf(dev->name, "eth%d", unit);
 		netdev_boot_setup_check(dev);
 	}
 
 	for( i = 0; i < N_LANCE_ADDR; ++i ) {
 		if (lance_probe1( dev, &lance_addr_list[i] )) {
 			found = 1;
diff --git a/drivers/net/ethernet/amd/declance.c b/drivers/net/ethernet/amd/declance.c
index 7282ce55ffb8..304baa8f0ecf 100644
--- a/drivers/net/ethernet/amd/declance.c
+++ b/drivers/net/ethernet/amd/declance.c
@@ -1051,16 +1051,18 @@ static int dec_lance_probe(struct device *bdev, const int type)
 	}
 
 	dev = alloc_etherdev(sizeof(struct lance_private));
 	if (!dev) {
 		ret = -ENOMEM;
 		goto err_out;
 	}
 
+	dev->priv_flags &= ~IFF_TX_SKB_SHARING;
+
 	/*
 	 * alloc_etherdev ensures the data structures used by the LANCE
 	 * are aligned.
 	 */
 	lp = netdev_priv(dev);
 	spin_lock_init(&lp->lock);
 
 	lp->type = type;
diff --git a/drivers/net/ethernet/amd/lance.c b/drivers/net/ethernet/amd/lance.c
index aff44241988c..096faab45680 100644
--- a/drivers/net/ethernet/amd/lance.c
+++ b/drivers/net/ethernet/amd/lance.c
@@ -337,16 +337,19 @@ int __init init_module(void)
 			if (this_dev != 0) /* only complain once */
 				break;
 			printk(KERN_NOTICE "lance.c: Module autoprobing not allowed. Append \"io=0xNNN\" value(s).\n");
 			return -EPERM;
 		}
 		dev = alloc_etherdev(0);
 		if (!dev)
 			break;
+
+		dev->priv_flags &= ~IFF_TX_SKB_SHARING;
+
 		dev->irq = irq[this_dev];
 		dev->base_addr = io[this_dev];
 		dev->dma = dma[this_dev];
 		if (do_lance_probe(dev) == 0) {
 			dev_lance[found++] = dev;
 			continue;
 		}
 		free_netdev(dev);
@@ -436,16 +439,18 @@ static int __init do_lance_probe(struct net_device *dev)
 struct net_device * __init lance_probe(int unit)
 {
 	struct net_device *dev = alloc_etherdev(0);
 	int err;
 
 	if (!dev)
 		return ERR_PTR(-ENODEV);
 
+	dev->priv_flags &= ~IFF_TX_SKB_SHARING;
+
 	sprintf(dev->name, "eth%d", unit);
 	netdev_boot_setup_check(dev);
 
 	err = do_lance_probe(dev);
 	if (err)
 		goto out;
 	return dev;
 out:
diff --git a/drivers/net/ethernet/apm/xgene/xgene_enet_main.c b/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
index 5f1fc6582d74..e50e16cfcf9e 100644
--- a/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
+++ b/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
@@ -2019,16 +2019,18 @@ static int xgene_enet_probe(struct platform_device *pdev)
 	const struct of_device_id *of_id;
 	int ret;
 
 	ndev = alloc_etherdev_mqs(sizeof(struct xgene_enet_pdata),
 				  XGENE_NUM_TX_RING, XGENE_NUM_RX_RING);
 	if (!ndev)
 		return -ENOMEM;
 
+	dev->priv_flags &= ~IFF_TX_SKB_SHARING;
+
 	pdata = netdev_priv(ndev);
 
 	pdata->pdev = pdev;
 	pdata->ndev = ndev;
 	SET_NETDEV_DEV(ndev, dev);
 	platform_set_drvdata(pdev, pdata);
 	ndev->netdev_ops = &xgene_ndev_ops;
 	xgene_enet_set_ethtool_ops(ndev);
diff --git a/drivers/net/ethernet/arc/emac_arc.c b/drivers/net/ethernet/arc/emac_arc.c
index 800620b8f10d..0b00dc4c891b 100644
--- a/drivers/net/ethernet/arc/emac_arc.c
+++ b/drivers/net/ethernet/arc/emac_arc.c
@@ -25,16 +25,19 @@ static int emac_arc_probe(struct platform_device *pdev)
 	int err;
 
 	if (!dev->of_node)
 		return -ENODEV;
 
 	ndev = alloc_etherdev(sizeof(struct arc_emac_priv));
 	if (!ndev)
 		return -ENOMEM;
+
+	dev->priv_flags &= ~IFF_TX_SKB_SHARING;
+
 	platform_set_drvdata(pdev, ndev);
 	SET_NETDEV_DEV(ndev, dev);
 
 	priv = netdev_priv(ndev);
 	priv->drv_name = DRV_NAME;
 
 	err = of_get_phy_mode(dev->of_node, &interface);
 	if (err) {
diff --git a/drivers/net/ethernet/arc/emac_rockchip.c b/drivers/net/ethernet/arc/emac_rockchip.c
index 48ecdf15eddc..c998efac2c42 100644
--- a/drivers/net/ethernet/arc/emac_rockchip.c
+++ b/drivers/net/ethernet/arc/emac_rockchip.c
@@ -101,16 +101,19 @@ static int emac_rockchip_probe(struct platform_device *pdev)
 	int err;
 
 	if (!pdev->dev.of_node)
 		return -ENODEV;
 
 	ndev = alloc_etherdev(sizeof(struct rockchip_priv_data));
 	if (!ndev)
 		return -ENOMEM;
+
+	dev->priv_flags &= ~IFF_TX_SKB_SHARING;
+
 	platform_set_drvdata(pdev, ndev);
 	SET_NETDEV_DEV(ndev, dev);
 
 	priv = netdev_priv(ndev);
 	priv->emac.drv_name = DRV_NAME;
 	priv->emac.set_mac_speed = emac_rockchip_set_mac_speed;
 
 	err = of_get_phy_mode(dev->of_node, &interface);
diff --git a/drivers/net/ethernet/fujitsu/fmvj18x_cs.c b/drivers/net/ethernet/fujitsu/fmvj18x_cs.c
index a7b7a4aace79..820bbb8002f6 100644
--- a/drivers/net/ethernet/fujitsu/fmvj18x_cs.c
+++ b/drivers/net/ethernet/fujitsu/fmvj18x_cs.c
@@ -235,16 +235,19 @@ static int fmvj18x_probe(struct pcmcia_device *link)
     struct net_device *dev;
 
     dev_dbg(&link->dev, "fmvj18x_attach()\n");
 
     /* Make up a FMVJ18x specific data structure */
     dev = alloc_etherdev(sizeof(struct local_info));
     if (!dev)
 	return -ENOMEM;
+
+	dev->priv_flags &= ~IFF_TX_SKB_SHARING;
+
     lp = netdev_priv(dev);
     link->priv = dev;
     lp->p_dev = link;
     lp->base = NULL;
 
     /* The io structure describes IO port mapping */
     link->resource[0]->end = 32;
     link->resource[0]->flags |= IO_DATA_PATH_WIDTH_AUTO;
diff --git a/drivers/net/ethernet/i825xx/82596.c b/drivers/net/ethernet/i825xx/82596.c
index fc8c7cd67471..8f36f63120fd 100644
--- a/drivers/net/ethernet/i825xx/82596.c
+++ b/drivers/net/ethernet/i825xx/82596.c
@@ -1135,16 +1135,18 @@ struct net_device * __init i82596_probe(int unit)
 	if (probed)
 		return ERR_PTR(-ENODEV);
 	probed++;
 
 	dev = alloc_etherdev(0);
 	if (!dev)
 		return ERR_PTR(-ENOMEM);
 
+	dev->priv_flags &= ~IFF_TX_SKB_SHARING;
+
 	if (unit >= 0) {
 		sprintf(dev->name, "eth%d", unit);
 		netdev_boot_setup_check(dev);
 	} else {
 		dev->base_addr = io;
 		dev->irq = irq;
 	}
 
diff --git a/drivers/net/ethernet/i825xx/ether1.c b/drivers/net/ethernet/i825xx/ether1.c
index a0bfb509e002..58c3e098d943 100644
--- a/drivers/net/ethernet/i825xx/ether1.c
+++ b/drivers/net/ethernet/i825xx/ether1.c
@@ -995,16 +995,18 @@ ether1_probe(struct expansion_card *ec, const struct ecard_id *id)
 		goto out;
 
 	dev = alloc_etherdev(sizeof(struct ether1_priv));
 	if (!dev) {
 		ret = -ENOMEM;
 		goto release;
 	}
 
+	dev->priv_flags &= ~IFF_TX_SKB_SHARING;
+
 	SET_NETDEV_DEV(dev, &ec->dev);
 
 	dev->irq = ec->irq;
 	priv(dev)->base = ecardm_iomap(ec, ECARD_RES_IOCFAST, 0, 0);
 	if (!priv(dev)->base) {
 		ret = -ENOMEM;
 		goto free;
 	}
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 9112dff075cf..e6341c5b30ff 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -5021,16 +5021,18 @@ static int igc_probe(struct pci_dev *pdev,
 
 	err = -ENOMEM;
 	netdev = alloc_etherdev_mq(sizeof(struct igc_adapter),
 				   IGC_MAX_TX_QUEUES);
 
 	if (!netdev)
 		goto err_alloc_etherdev;
 
+	netdev->priv_flags &= ~IFF_TX_SKB_SHARING;
+
 	SET_NETDEV_DEV(netdev, &pdev->dev);
 
 	pci_set_drvdata(pdev, netdev);
 	adapter = netdev_priv(netdev);
 	adapter->netdev = netdev;
 	adapter->pdev = pdev;
 	hw = &adapter->hw;
 	hw->back = adapter;
diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
index 82fce27f682b..f996ebb44013 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -4547,16 +4547,18 @@ static int ixgbevf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	netdev = alloc_etherdev_mq(sizeof(struct ixgbevf_adapter),
 				   MAX_TX_QUEUES);
 	if (!netdev) {
 		err = -ENOMEM;
 		goto err_alloc_etherdev;
 	}
 
+	netdev->priv_flags &= ~IFF_TX_SKB_SHARING;
+
 	SET_NETDEV_DEV(netdev, &pdev->dev);
 
 	adapter = netdev_priv(netdev);
 
 	adapter->netdev = netdev;
 	adapter->pdev = pdev;
 	hw = &adapter->hw;
 	hw->back = adapter;
diff --git a/drivers/net/ethernet/marvell/skge.c b/drivers/net/ethernet/marvell/skge.c
index 8a9c0f490bfb..3dcc286525d0 100644
--- a/drivers/net/ethernet/marvell/skge.c
+++ b/drivers/net/ethernet/marvell/skge.c
@@ -3804,16 +3804,18 @@ static struct net_device *skge_devinit(struct skge_hw *hw, int port,
 				       int highmem)
 {
 	struct skge_port *skge;
 	struct net_device *dev = alloc_etherdev(sizeof(*skge));
 
 	if (!dev)
 		return NULL;
 
+	dev->priv_flags &= ~IFF_TX_SKB_SHARING;
+
 	SET_NETDEV_DEV(dev, &hw->pdev->dev);
 	dev->netdev_ops = &skge_netdev_ops;
 	dev->ethtool_ops = &skge_ethtool_ops;
 	dev->watchdog_timeo = TX_WATCHDOG;
 	dev->irq = hw->pdev->irq;
 
 	/* MTU range: 60 - 9000 */
 	dev->min_mtu = ETH_ZLEN;
diff --git a/drivers/net/ethernet/natsemi/jazzsonic.c b/drivers/net/ethernet/natsemi/jazzsonic.c
index ce3eca5d152b..670c35059b49 100644
--- a/drivers/net/ethernet/natsemi/jazzsonic.c
+++ b/drivers/net/ethernet/natsemi/jazzsonic.c
@@ -183,16 +183,18 @@ static int jazz_sonic_probe(struct platform_device *pdev)
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res)
 		return -ENODEV;
 
 	dev = alloc_etherdev(sizeof(struct sonic_local));
 	if (!dev)
 		return -ENOMEM;
 
+	dev->priv_flags &= ~IFF_TX_SKB_SHARING;
+
 	lp = netdev_priv(dev);
 	lp->device = &pdev->dev;
 	SET_NETDEV_DEV(dev, &pdev->dev);
 	platform_set_drvdata(pdev, dev);
 
 	netdev_boot_setup_check(dev);
 
 	dev->base_addr = res->start;
diff --git a/drivers/net/ethernet/natsemi/macsonic.c b/drivers/net/ethernet/natsemi/macsonic.c
index 776b7d264dc3..7fb0fb74348d 100644
--- a/drivers/net/ethernet/natsemi/macsonic.c
+++ b/drivers/net/ethernet/natsemi/macsonic.c
@@ -488,16 +488,18 @@ static int mac_sonic_platform_probe(struct platform_device *pdev)
 	struct net_device *dev;
 	struct sonic_local *lp;
 	int err;
 
 	dev = alloc_etherdev(sizeof(struct sonic_local));
 	if (!dev)
 		return -ENOMEM;
 
+	dev->priv_flags &= ~IFF_TX_SKB_SHARING;
+
 	lp = netdev_priv(dev);
 	lp->device = &pdev->dev;
 	SET_NETDEV_DEV(dev, &pdev->dev);
 	platform_set_drvdata(pdev, dev);
 
 	err = mac_onboard_sonic_probe(dev);
 	if (err)
 		goto out;
diff --git a/drivers/net/ethernet/natsemi/xtsonic.c b/drivers/net/ethernet/natsemi/xtsonic.c
index afa166ff7aef..256346b6f74a 100644
--- a/drivers/net/ethernet/natsemi/xtsonic.c
+++ b/drivers/net/ethernet/natsemi/xtsonic.c
@@ -206,16 +206,18 @@ int xtsonic_probe(struct platform_device *pdev)
 		return -ENODEV;
 
 	if ((resirq = platform_get_resource(pdev, IORESOURCE_IRQ, 0)) == NULL)
 		return -ENODEV;
 
 	if ((dev = alloc_etherdev(sizeof(struct sonic_local))) == NULL)
 		return -ENOMEM;
 
+	dev->priv_flags &= ~IFF_TX_SKB_SHARING;
+
 	lp = netdev_priv(dev);
 	lp->device = &pdev->dev;
 	platform_set_drvdata(pdev, dev);
 	SET_NETDEV_DEV(dev, &pdev->dev);
 	netdev_boot_setup_check(dev);
 
 	dev->base_addr = resmem->start;
 	dev->irq = resirq->start;
diff --git a/drivers/net/ethernet/packetengines/yellowfin.c b/drivers/net/ethernet/packetengines/yellowfin.c
index d1dd9bc1bc7f..2d3e5f682158 100644
--- a/drivers/net/ethernet/packetengines/yellowfin.c
+++ b/drivers/net/ethernet/packetengines/yellowfin.c
@@ -394,16 +394,18 @@ static int yellowfin_init_one(struct pci_dev *pdev,
 
 	i = pci_enable_device(pdev);
 	if (i) return i;
 
 	dev = alloc_etherdev(sizeof(*np));
 	if (!dev)
 		return -ENOMEM;
 
+	dev->priv_flags &= ~IFF_TX_SKB_SHARING;
+
 	SET_NETDEV_DEV(dev, &pdev->dev);
 
 	np = netdev_priv(dev);
 
 	if (pci_request_regions(pdev, DRV_NAME))
 		goto err_out_free_netdev;
 
 	pci_set_master (pdev);
diff --git a/drivers/net/ethernet/seeq/ether3.c b/drivers/net/ethernet/seeq/ether3.c
index 65c98837ec45..7c2e304fd51d 100644
--- a/drivers/net/ethernet/seeq/ether3.c
+++ b/drivers/net/ethernet/seeq/ether3.c
@@ -757,16 +757,18 @@ ether3_probe(struct expansion_card *ec, const struct ecard_id *id)
 		goto out;
 
 	dev = alloc_etherdev(sizeof(struct dev_priv));
 	if (!dev) {
 		ret = -ENOMEM;
 		goto release;
 	}
 
+	dev->priv_flags &= ~IFF_TX_SKB_SHARING;
+
 	SET_NETDEV_DEV(dev, &ec->dev);
 
 	priv(dev)->base = ecardm_iomap(ec, ECARD_RES_MEMC, 0, 0);
 	if (!priv(dev)->base) {
 		ret = -ENOMEM;
 		goto free;
 	}
 
diff --git a/drivers/net/ethernet/seeq/sgiseeq.c b/drivers/net/ethernet/seeq/sgiseeq.c
index 37ff25a84030..15713035a08a 100644
--- a/drivers/net/ethernet/seeq/sgiseeq.c
+++ b/drivers/net/ethernet/seeq/sgiseeq.c
@@ -738,16 +738,18 @@ static int sgiseeq_probe(struct platform_device *pdev)
 	int err;
 
 	dev = alloc_etherdev(sizeof (struct sgiseeq_private));
 	if (!dev) {
 		err = -ENOMEM;
 		goto err_out;
 	}
 
+	dev->priv_flags &= ~IFF_TX_SKB_SHARING;
+
 	platform_set_drvdata(pdev, dev);
 	SET_NETDEV_DEV(dev, &pdev->dev);
 	sp = netdev_priv(dev);
 
 	/* Make private data page aligned */
 	sr = dma_alloc_noncoherent(&pdev->dev, sizeof(*sp->srings),
 			&sp->srings_dma, DMA_BIDIRECTIONAL, GFP_KERNEL);
 	if (!sr) {
diff --git a/drivers/net/ethernet/sis/sis190.c b/drivers/net/ethernet/sis/sis190.c
index 676b193833c0..ae0f3c253f9e 100644
--- a/drivers/net/ethernet/sis/sis190.c
+++ b/drivers/net/ethernet/sis/sis190.c
@@ -1467,16 +1467,18 @@ static struct net_device *sis190_init_board(struct pci_dev *pdev)
 	int rc;
 
 	dev = alloc_etherdev(sizeof(*tp));
 	if (!dev) {
 		rc = -ENOMEM;
 		goto err_out_0;
 	}
 
+	dev->priv_flags &= ~IFF_TX_SKB_SHARING;
+
 	SET_NETDEV_DEV(dev, &pdev->dev);
 
 	tp = netdev_priv(dev);
 	tp->dev = dev;
 	tp->msg_enable = netif_msg_init(debug.msg_enable, SIS190_MSG_DEFAULT);
 
 	rc = pci_enable_device(pdev);
 	if (rc < 0) {
diff --git a/drivers/net/ethernet/smsc/epic100.c b/drivers/net/ethernet/smsc/epic100.c
index 51cd7dca91cd..d57dd762040b 100644
--- a/drivers/net/ethernet/smsc/epic100.c
+++ b/drivers/net/ethernet/smsc/epic100.c
@@ -352,16 +352,18 @@ static int epic_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto err_out_disable;
 
 	ret = -ENOMEM;
 
 	dev = alloc_etherdev(sizeof (*ep));
 	if (!dev)
 		goto err_out_free_res;
 
+	dev->priv_flags &= ~IFF_TX_SKB_SHARING;
+
 	SET_NETDEV_DEV(dev, &pdev->dev);
 
 	ioaddr = pci_iomap(pdev, EPIC_BAR, 0);
 	if (!ioaddr) {
 		dev_err(&pdev->dev, "ioremap failed\n");
 		goto err_out_free_netdev;
 	}
 
diff --git a/drivers/net/ethernet/smsc/smc9194.c b/drivers/net/ethernet/smsc/smc9194.c
index 4b2330deed47..bc4600567b08 100644
--- a/drivers/net/ethernet/smsc/smc9194.c
+++ b/drivers/net/ethernet/smsc/smc9194.c
@@ -691,16 +691,18 @@ struct net_device * __init smc_init(int unit)
 {
 	struct net_device *dev = alloc_etherdev(sizeof(struct smc_local));
 	struct devlist *smcdev = smc_devlist;
 	int err = 0;
 
 	if (!dev)
 		return ERR_PTR(-ENODEV);
 
+	dev->priv_flags &= ~IFF_TX_SKB_SHARING;
+
 	if (unit >= 0) {
 		sprintf(dev->name, "eth%d", unit);
 		netdev_boot_setup_check(dev);
 		io = dev->base_addr;
 		irq = dev->irq;
 	}
 
 	if (io > 0x1ff) {	/* Check a single specified location. */
diff --git a/drivers/net/ethernet/sun/cassini.c b/drivers/net/ethernet/sun/cassini.c
index 9ff894ba8d3e..0bcc4a02dc6e 100644
--- a/drivers/net/ethernet/sun/cassini.c
+++ b/drivers/net/ethernet/sun/cassini.c
@@ -4911,16 +4911,19 @@ static int cas_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto err_out_disable_pdev;
 	}
 
 	dev = alloc_etherdev(sizeof(*cp));
 	if (!dev) {
 		err = -ENOMEM;
 		goto err_out_disable_pdev;
 	}
+
+	dev->priv_flags &= ~IFF_TX_SKB_SHARING;
+
 	SET_NETDEV_DEV(dev, &pdev->dev);
 
 	err = pci_request_regions(pdev, dev->name);
 	if (err) {
 		dev_err(&pdev->dev, "Cannot obtain PCI resources, aborting\n");
 		goto err_out_free_netdev;
 	}
 	pci_set_master(pdev);
diff --git a/drivers/net/ethernet/ti/cpmac.c b/drivers/net/ethernet/ti/cpmac.c
index c20715107075..e662f4f951a0 100644
--- a/drivers/net/ethernet/ti/cpmac.c
+++ b/drivers/net/ethernet/ti/cpmac.c
@@ -1084,16 +1084,18 @@ static int cpmac_probe(struct platform_device *pdev)
 		phy_id = pdev->id;
 	}
 	mdio_bus_id[sizeof(mdio_bus_id) - 1] = '\0';
 
 	dev = alloc_etherdev_mq(sizeof(*priv), CPMAC_QUEUES);
 	if (!dev)
 		return -ENOMEM;
 
+	dev->priv_flags &= ~IFF_TX_SKB_SHARING;
+
 	SET_NETDEV_DEV(dev, &pdev->dev);
 	platform_set_drvdata(pdev, dev);
 	priv = netdev_priv(dev);
 
 	priv->pdev = pdev;
 	mem = platform_get_resource_byname(pdev, IORESOURCE_MEM, "regs");
 	if (!mem) {
 		rc = -ENODEV;
diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index 9fd1f77190ad..077917741d3a 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -1449,16 +1449,18 @@ static int cpsw_probe_dual_emac(struct cpsw_priv *priv)
 
 	ndev = devm_alloc_etherdev_mqs(cpsw->dev, sizeof(struct cpsw_priv),
 				       CPSW_MAX_QUEUES, CPSW_MAX_QUEUES);
 	if (!ndev) {
 		dev_err(cpsw->dev, "cpsw: error allocating net_device\n");
 		return -ENOMEM;
 	}
 
+	dev->priv_flags &= ~IFF_TX_SKB_SHARING;
+
 	priv_sl2 = netdev_priv(ndev);
 	priv_sl2->cpsw = cpsw;
 	priv_sl2->ndev = ndev;
 	priv_sl2->dev  = &ndev->dev;
 	priv_sl2->msg_enable = netif_msg_init(debug_level, CPSW_DEBUG);
 
 	if (is_valid_ether_addr(data->slave_data[1].mac_addr)) {
 		memcpy(priv_sl2->mac_addr, data->slave_data[1].mac_addr,
@@ -1629,16 +1631,18 @@ static int cpsw_probe(struct platform_device *pdev)
 	/* setup netdev */
 	ndev = devm_alloc_etherdev_mqs(dev, sizeof(struct cpsw_priv),
 				       CPSW_MAX_QUEUES, CPSW_MAX_QUEUES);
 	if (!ndev) {
 		dev_err(dev, "error allocating net_device\n");
 		goto clean_cpts;
 	}
 
+	dev->priv_flags &= ~IFF_TX_SKB_SHARING;
+
 	priv = netdev_priv(ndev);
 	priv->cpsw = cpsw;
 	priv->ndev = ndev;
 	priv->dev  = dev;
 	priv->msg_enable = netif_msg_init(debug_level, CPSW_DEBUG);
 	priv->emac_port = 0;
 
 	if (is_valid_ether_addr(data->slave_data[0].mac_addr)) {
diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
index f779d2e1b5c5..c4a12f1d9672 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -1387,16 +1387,18 @@ static int cpsw_create_ports(struct cpsw_common *cpsw)
 		ndev = devm_alloc_etherdev_mqs(dev, sizeof(struct cpsw_priv),
 					       CPSW_MAX_QUEUES,
 					       CPSW_MAX_QUEUES);
 		if (!ndev) {
 			dev_err(dev, "error allocating net_device\n");
 			return -ENOMEM;
 		}
 
+		dev->priv_flags &= ~IFF_TX_SKB_SHARING;
+
 		priv = netdev_priv(ndev);
 		priv->cpsw = cpsw;
 		priv->ndev = ndev;
 		priv->dev  = dev;
 		priv->msg_enable = netif_msg_init(debug_level, CPSW_DEBUG);
 		priv->emac_port = i + 1;
 
 		if (is_valid_ether_addr(slave_data->mac_addr)) {
diff --git a/drivers/net/ethernet/ti/davinci_emac.c b/drivers/net/ethernet/ti/davinci_emac.c
index c7031e1960d4..2816fd3f40f2 100644
--- a/drivers/net/ethernet/ti/davinci_emac.c
+++ b/drivers/net/ethernet/ti/davinci_emac.c
@@ -1786,16 +1786,18 @@ static int davinci_emac_probe(struct platform_device *pdev)
 	devm_clk_put(&pdev->dev, emac_clk);
 
 	/* TODO: Probe PHY here if possible */
 
 	ndev = alloc_etherdev(sizeof(struct emac_priv));
 	if (!ndev)
 		return -ENOMEM;
 
+	dev->priv_flags &= ~IFF_TX_SKB_SHARING;
+
 	platform_set_drvdata(pdev, ndev);
 	priv = netdev_priv(ndev);
 	priv->pdev = pdev;
 	priv->ndev = ndev;
 	priv->msg_enable = netif_msg_init(debug_level, DAVINCI_EMAC_DEBUG);
 
 	spin_lock_init(&priv->lock);
 
diff --git a/drivers/net/ethernet/ti/netcp_core.c b/drivers/net/ethernet/ti/netcp_core.c
index d7a144b4a09f..793990f11736 100644
--- a/drivers/net/ethernet/ti/netcp_core.c
+++ b/drivers/net/ethernet/ti/netcp_core.c
@@ -1972,16 +1972,18 @@ static int netcp_create_interface(struct netcp_device *netcp_device,
 	int ret = 0;
 
 	ndev = alloc_etherdev_mqs(sizeof(*netcp), 1, 1);
 	if (!ndev) {
 		dev_err(dev, "Error allocating netdev\n");
 		return -ENOMEM;
 	}
 
+	dev->priv_flags &= ~IFF_TX_SKB_SHARING;
+
 	ndev->features |= NETIF_F_SG;
 	ndev->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
 	ndev->hw_features = ndev->features;
 	ndev->vlan_features |=  NETIF_F_SG;
 
 	/* MTU range: 68 - 9486 */
 	ndev->min_mtu = ETH_MIN_MTU;
 	ndev->max_mtu = NETCP_MAX_FRAME_SIZE - (ETH_HLEN + ETH_FCS_LEN);
diff --git a/drivers/net/ethernet/ti/tlan.c b/drivers/net/ethernet/ti/tlan.c
index 267c080ee084..6b5902f9e468 100644
--- a/drivers/net/ethernet/ti/tlan.c
+++ b/drivers/net/ethernet/ti/tlan.c
@@ -463,16 +463,19 @@ static int tlan_probe1(struct pci_dev *pdev, long ioaddr, int irq, int rev,
 	}
 #endif  /*  CONFIG_PCI  */
 
 	dev = alloc_etherdev(sizeof(struct tlan_priv));
 	if (dev == NULL) {
 		rc = -ENOMEM;
 		goto err_out_regions;
 	}
+
+	dev->priv_flags &= ~IFF_TX_SKB_SHARING;
+
 	SET_NETDEV_DEV(dev, &pdev->dev);
 
 	priv = netdev_priv(dev);
 
 	priv->pci_dev = pdev;
 	priv->dev = dev;
 
 	/* Is this a PCI device? */
diff --git a/drivers/net/ethernet/via/via-rhine.c b/drivers/net/ethernet/via/via-rhine.c
index 73ca597ebd1b..e995097bf7b5 100644
--- a/drivers/net/ethernet/via/via-rhine.c
+++ b/drivers/net/ethernet/via/via-rhine.c
@@ -908,16 +908,19 @@ static int rhine_init_one_common(struct device *hwdev, u32 quirks,
 		goto err_out;
 	}
 
 	dev = alloc_etherdev(sizeof(struct rhine_private));
 	if (!dev) {
 		rc = -ENOMEM;
 		goto err_out;
 	}
+
+	dev->priv_flags &= ~IFF_TX_SKB_SHARING;
+
 	SET_NETDEV_DEV(dev, hwdev);
 
 	rp = netdev_priv(dev);
 	rp->dev = dev;
 	rp->quirks = quirks;
 	rp->pioaddr = pioaddr;
 	rp->base = ioaddr;
 	rp->irq = irq;
diff --git a/drivers/net/ethernet/via/via-velocity.c b/drivers/net/ethernet/via/via-velocity.c
index b65767f9e499..b5e6cb501024 100644
--- a/drivers/net/ethernet/via/via-velocity.c
+++ b/drivers/net/ethernet/via/via-velocity.c
@@ -2775,16 +2775,18 @@ static int velocity_probe(struct device *dev, int irq,
 		dev_notice(dev, "already found %d NICs.\n", velocity_nics);
 		return -ENODEV;
 	}
 
 	netdev = alloc_etherdev(sizeof(struct velocity_info));
 	if (!netdev)
 		goto out;
 
+	netdev->priv_flags &= ~IFF_TX_SKB_SHARING;
+
 	/* Chain it all together */
 
 	SET_NETDEV_DEV(netdev, dev);
 	vptr = netdev_priv(netdev);
 
 	pr_info_once("%s Ver. %s\n", VELOCITY_FULL_DRV_NAM, VELOCITY_VERSION);
 	pr_info_once("Copyright (c) 2002, 2003 VIA Networking Technologies, Inc.\n");
 	pr_info_once("Copyright (c) 2004 Red Hat Inc.\n");
diff --git a/drivers/net/ethernet/xircom/xirc2ps_cs.c b/drivers/net/ethernet/xircom/xirc2ps_cs.c
index 3e337142b516..aff199831a6e 100644
--- a/drivers/net/ethernet/xircom/xirc2ps_cs.c
+++ b/drivers/net/ethernet/xircom/xirc2ps_cs.c
@@ -477,16 +477,19 @@ xirc2ps_probe(struct pcmcia_device *link)
     struct local_info *local;
 
     dev_dbg(&link->dev, "attach()\n");
 
     /* Allocate the device structure */
     dev = alloc_etherdev(sizeof(struct local_info));
     if (!dev)
 	    return -ENOMEM;
+
+	dev->priv_flags &= ~IFF_TX_SKB_SHARING;
+
     local = netdev_priv(dev);
     local->dev = dev;
     local->p_dev = link;
     link->priv = dev;
 
     /* General socket configuration */
     link->config_index = 1;
 
-- 
2.25.1

