Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 340016C83CC
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 18:53:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231953AbjCXRws (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 13:52:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231215AbjCXRwX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 13:52:23 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37DED19F2F;
        Fri, 24 Mar 2023 10:51:50 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id a5so2188954qto.6;
        Fri, 24 Mar 2023 10:51:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679680306;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cz49CpZ6Czp6rKLA4pkCmIY69gIAhzpolYioE4Fl79A=;
        b=jLv7vk6ZbnpKiJEeZSLVNRy7Pz+8MYfFjPLgeObJV3k20+pcmvM9ptmaC8zMDTb+gH
         tSB7xuPfOVStUwfjeQjIGzZhJhyLB7CNp0WrjySWxAeY3bm5z1Wvd/MkSg1gBhNBEzgU
         rOCDVgY4/a/b2IxbEwrQhGdOhQ8XH3tLy39gJjXU1cCV5ukUlDQtFBcWf3EuRzkMXd8x
         9tbVARQxw6HhvromBUfOUtPUDR6zuqcw3g4No5jyjXh3FuX4++4m5JTPW1GtkcnSKXnK
         EZOb891Yupks59wMYRjsdho6MAQ6gDTdsDJxXcHkbBUAh7B8MH2BDgWpSOE1J9AmSFp/
         5Ekg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679680306;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cz49CpZ6Czp6rKLA4pkCmIY69gIAhzpolYioE4Fl79A=;
        b=PREbOxA9ISgh/WhWoxF/U6rlcPRV9i8BDnHw4rMRvQ9TAx16Y3bFXiZwt829BDiGrt
         B9DwbNbORsG+uYkQJUZB5KbSxa1+4IOSMDcSnhpCpiXXsAZMnuRBjLLnMwPLnrcTAZcu
         dM0uP7QFUfzEBq0rPwyDXK0Sm+YskRFAZkH6lLZ1msWdfnHJMUUGz7sKBQwATsyv7k2G
         EnB95nLS65h0HVDHvvz9wt74h8CDwqXU11I6AKcgfvKQ+llBYMs8lA2A5i1jfib6gG+y
         H0cRNv8V+Zg0cpK19qv3c3nthfT2QdpaJwzgHjN3pcDTCEBL85+SajE1bl4DCBImzw8o
         DRVQ==
X-Gm-Message-State: AAQBX9c1bGwWDJlig/8wzrmLSjWTxtreZi+u/PAUO7dUiEz2OVJbUIf/
        o/WfDU/iDbmphUWsqMhr2AY=
X-Google-Smtp-Source: AK7set/tRbFPxDixm6AkThORbLNMHpQo5dCEjXGqddxm/xWiDjkX4dqSyERXRalT8Mbk/UYNHnY2ow==
X-Received: by 2002:ac8:5a09:0:b0:3e2:905:3331 with SMTP id n9-20020ac85a09000000b003e209053331mr6693166qta.51.1679680306056;
        Fri, 24 Mar 2023 10:51:46 -0700 (PDT)
Received: from localhost (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with UTF8SMTPSA id w8-20020a05620a148800b0073bb0ef3a8esm14418663qkj.21.2023.03.24.10.51.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Mar 2023 10:51:45 -0700 (PDT)
From:   Sean Anderson <seanga2@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Simon Horman <simon.horman@corigine.com>,
        linux-kernel@vger.kernel.org, Sean Anderson <seanga2@gmail.com>
Subject: [PATCH net-next v4 07/10] net: sunhme: Consolidate mac address initialization
Date:   Fri, 24 Mar 2023 13:51:33 -0400
Message-Id: <20230324175136.321588-8-seanga2@gmail.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20230324175136.321588-1-seanga2@gmail.com>
References: <20230324175136.321588-1-seanga2@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mac address initialization is braodly the same between PCI and SBUS,
and one was clearly copied from the other. Consolidate them. We still have
to have some ifdefs because pci_(un)map_rom is only implemented for PCI,
and idprom is only implemented for SPARC.

Signed-off-by: Sean Anderson <seanga2@gmail.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---

Changes in v4:
- Tweak variable order for yuletide

 drivers/net/ethernet/sun/sunhme.c | 282 ++++++++++++++----------------
 1 file changed, 134 insertions(+), 148 deletions(-)

diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index 9cd3448aca3e..4fe67623b924 100644
--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -2304,6 +2304,133 @@ static const struct net_device_ops hme_netdev_ops = {
 	.ndo_validate_addr	= eth_validate_addr,
 };
 
+#ifdef CONFIG_PCI
+static int is_quattro_p(struct pci_dev *pdev)
+{
+	struct pci_dev *busdev = pdev->bus->self;
+	struct pci_dev *this_pdev;
+	int n_hmes;
+
+	if (!busdev || busdev->vendor != PCI_VENDOR_ID_DEC ||
+	    busdev->device != PCI_DEVICE_ID_DEC_21153)
+		return 0;
+
+	n_hmes = 0;
+	list_for_each_entry(this_pdev, &pdev->bus->devices, bus_list) {
+		if (this_pdev->vendor == PCI_VENDOR_ID_SUN &&
+		    this_pdev->device == PCI_DEVICE_ID_SUN_HAPPYMEAL)
+			n_hmes++;
+	}
+
+	if (n_hmes != 4)
+		return 0;
+
+	return 1;
+}
+
+/* Fetch MAC address from vital product data of PCI ROM. */
+static int find_eth_addr_in_vpd(void __iomem *rom_base, int len, int index, unsigned char *dev_addr)
+{
+	int this_offset;
+
+	for (this_offset = 0x20; this_offset < len; this_offset++) {
+		void __iomem *p = rom_base + this_offset;
+
+		if (readb(p + 0) != 0x90 ||
+		    readb(p + 1) != 0x00 ||
+		    readb(p + 2) != 0x09 ||
+		    readb(p + 3) != 0x4e ||
+		    readb(p + 4) != 0x41 ||
+		    readb(p + 5) != 0x06)
+			continue;
+
+		this_offset += 6;
+		p += 6;
+
+		if (index == 0) {
+			int i;
+
+			for (i = 0; i < 6; i++)
+				dev_addr[i] = readb(p + i);
+			return 1;
+		}
+		index--;
+	}
+	return 0;
+}
+
+static void __maybe_unused get_hme_mac_nonsparc(struct pci_dev *pdev,
+						unsigned char *dev_addr)
+{
+	size_t size;
+	void __iomem *p = pci_map_rom(pdev, &size);
+
+	if (p) {
+		int index = 0;
+		int found;
+
+		if (is_quattro_p(pdev))
+			index = PCI_SLOT(pdev->devfn);
+
+		found = readb(p) == 0x55 &&
+			readb(p + 1) == 0xaa &&
+			find_eth_addr_in_vpd(p, (64 * 1024), index, dev_addr);
+		pci_unmap_rom(pdev, p);
+		if (found)
+			return;
+	}
+
+	/* Sun MAC prefix then 3 random bytes. */
+	dev_addr[0] = 0x08;
+	dev_addr[1] = 0x00;
+	dev_addr[2] = 0x20;
+	get_random_bytes(&dev_addr[3], 3);
+}
+#endif /* !(CONFIG_SPARC) */
+
+static void happy_meal_addr_init(struct happy_meal *hp,
+				 struct device_node *dp, int qfe_slot)
+{
+	int i;
+
+	for (i = 0; i < 6; i++) {
+		if (macaddr[i] != 0)
+			break;
+	}
+
+	if (i < 6) { /* a mac address was given */
+		u8 addr[ETH_ALEN];
+
+		for (i = 0; i < 6; i++)
+			addr[i] = macaddr[i];
+		eth_hw_addr_set(hp->dev, addr);
+		macaddr[5]++;
+	} else {
+#ifdef CONFIG_SPARC
+		const unsigned char *addr;
+		int len;
+
+		/* If user did not specify a MAC address specifically, use
+		 * the Quattro local-mac-address property...
+		 */
+		if (qfe_slot != -1) {
+			addr = of_get_property(dp, "local-mac-address", &len);
+			if (addr && len == 6) {
+				eth_hw_addr_set(hp->dev, addr);
+				return;
+			}
+		}
+
+		eth_hw_addr_set(hp->dev, idprom->id_ethaddr);
+#else
+		u8 addr[ETH_ALEN];
+
+		get_hme_mac_nonsparc(hp->happy_dev, addr);
+		eth_hw_addr_set(hp->dev, addr);
+#endif
+	}
+}
+
 #ifdef CONFIG_SBUS
 static int happy_meal_sbus_probe_one(struct platform_device *op, int is_qfe)
 {
@@ -2311,8 +2438,7 @@ static int happy_meal_sbus_probe_one(struct platform_device *op, int is_qfe)
 	struct quattro *qp = NULL;
 	struct happy_meal *hp;
 	struct net_device *dev;
-	int i, qfe_slot = -1;
-	u8 addr[ETH_ALEN];
+	int qfe_slot = -1;
 	int err;
 
 	sbus_dp = op->dev.parent->of_node;
@@ -2337,34 +2463,11 @@ static int happy_meal_sbus_probe_one(struct platform_device *op, int is_qfe)
 		return -ENOMEM;
 	SET_NETDEV_DEV(dev, &op->dev);
 
-	/* If user did not specify a MAC address specifically, use
-	 * the Quattro local-mac-address property...
-	 */
-	for (i = 0; i < 6; i++) {
-		if (macaddr[i] != 0)
-			break;
-	}
-	if (i < 6) { /* a mac address was given */
-		for (i = 0; i < 6; i++)
-			addr[i] = macaddr[i];
-		eth_hw_addr_set(dev, addr);
-		macaddr[5]++;
-	} else {
-		const unsigned char *addr;
-		int len;
-
-		addr = of_get_property(dp, "local-mac-address", &len);
-
-		if (qfe_slot != -1 && addr && len == ETH_ALEN)
-			eth_hw_addr_set(dev, addr);
-		else
-			eth_hw_addr_set(dev, idprom->id_ethaddr);
-	}
-
 	hp = netdev_priv(dev);
-
+	hp->dev = dev;
 	hp->happy_dev = op;
 	hp->dma_dev = &op->dev;
+	happy_meal_addr_init(hp, dp, qfe_slot);
 
 	spin_lock_init(&hp->happy_lock);
 
@@ -2442,7 +2545,6 @@ static int happy_meal_sbus_probe_one(struct platform_device *op, int is_qfe)
 
 	timer_setup(&hp->happy_timer, happy_meal_timer, 0);
 
-	hp->dev = dev;
 	dev->netdev_ops = &hme_netdev_ops;
 	dev->watchdog_timeo = 5*HZ;
 	dev->ethtool_ops = &hme_ethtool_ops;
@@ -2495,104 +2597,17 @@ static int happy_meal_sbus_probe_one(struct platform_device *op, int is_qfe)
 #endif
 
 #ifdef CONFIG_PCI
-#ifndef CONFIG_SPARC
-static int is_quattro_p(struct pci_dev *pdev)
-{
-	struct pci_dev *busdev = pdev->bus->self;
-	struct pci_dev *this_pdev;
-	int n_hmes;
-
-	if (busdev == NULL ||
-	    busdev->vendor != PCI_VENDOR_ID_DEC ||
-	    busdev->device != PCI_DEVICE_ID_DEC_21153)
-		return 0;
-
-	n_hmes = 0;
-	list_for_each_entry(this_pdev, &pdev->bus->devices, bus_list) {
-		if (this_pdev->vendor == PCI_VENDOR_ID_SUN &&
-		    this_pdev->device == PCI_DEVICE_ID_SUN_HAPPYMEAL)
-			n_hmes++;
-	}
-
-	if (n_hmes != 4)
-		return 0;
-
-	return 1;
-}
-
-/* Fetch MAC address from vital product data of PCI ROM. */
-static int find_eth_addr_in_vpd(void __iomem *rom_base, int len, int index, unsigned char *dev_addr)
-{
-	int this_offset;
-
-	for (this_offset = 0x20; this_offset < len; this_offset++) {
-		void __iomem *p = rom_base + this_offset;
-
-		if (readb(p + 0) != 0x90 ||
-		    readb(p + 1) != 0x00 ||
-		    readb(p + 2) != 0x09 ||
-		    readb(p + 3) != 0x4e ||
-		    readb(p + 4) != 0x41 ||
-		    readb(p + 5) != 0x06)
-			continue;
-
-		this_offset += 6;
-		p += 6;
-
-		if (index == 0) {
-			int i;
-
-			for (i = 0; i < 6; i++)
-				dev_addr[i] = readb(p + i);
-			return 1;
-		}
-		index--;
-	}
-	return 0;
-}
-
-static void get_hme_mac_nonsparc(struct pci_dev *pdev, unsigned char *dev_addr)
-{
-	size_t size;
-	void __iomem *p = pci_map_rom(pdev, &size);
-
-	if (p) {
-		int index = 0;
-		int found;
-
-		if (is_quattro_p(pdev))
-			index = PCI_SLOT(pdev->devfn);
-
-		found = readb(p) == 0x55 &&
-			readb(p + 1) == 0xaa &&
-			find_eth_addr_in_vpd(p, (64 * 1024), index, dev_addr);
-		pci_unmap_rom(pdev, p);
-		if (found)
-			return;
-	}
-
-	/* Sun MAC prefix then 3 random bytes. */
-	dev_addr[0] = 0x08;
-	dev_addr[1] = 0x00;
-	dev_addr[2] = 0x20;
-	get_random_bytes(&dev_addr[3], 3);
-}
-#endif /* !(CONFIG_SPARC) */
-
 static int happy_meal_pci_probe(struct pci_dev *pdev,
 				const struct pci_device_id *ent)
 {
+	struct device_node *dp = NULL;
 	struct quattro *qp = NULL;
-#ifdef CONFIG_SPARC
-	struct device_node *dp;
-#endif
 	struct happy_meal *hp;
 	struct net_device *dev;
 	void __iomem *hpreg_base;
 	struct resource *hpreg_res;
-	int i, qfe_slot = -1;
 	char prom_name[64];
-	u8 addr[ETH_ALEN];
+	int qfe_slot = -1;
 	int err = -ENODEV;
 
 	/* Now make sure pci_dev cookie is there. */
@@ -2634,7 +2649,7 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 	SET_NETDEV_DEV(dev, &pdev->dev);
 
 	hp = netdev_priv(dev);
-
+	hp->dev = dev;
 	hp->happy_dev = pdev;
 	hp->dma_dev = &pdev->dev;
 
@@ -2670,35 +2685,7 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 		goto err_out_clear_quattro;
 	}
 
-	for (i = 0; i < 6; i++) {
-		if (macaddr[i] != 0)
-			break;
-	}
-	if (i < 6) { /* a mac address was given */
-		for (i = 0; i < 6; i++)
-			addr[i] = macaddr[i];
-		eth_hw_addr_set(dev, addr);
-		macaddr[5]++;
-	} else {
-#ifdef CONFIG_SPARC
-		const unsigned char *addr;
-		int len;
-
-		if (qfe_slot != -1 &&
-		    (addr = of_get_property(dp, "local-mac-address", &len))
-			!= NULL &&
-		    len == 6) {
-			eth_hw_addr_set(dev, addr);
-		} else {
-			eth_hw_addr_set(dev, idprom->id_ethaddr);
-		}
-#else
-		u8 addr[ETH_ALEN];
-
-		get_hme_mac_nonsparc(pdev, addr);
-		eth_hw_addr_set(dev, addr);
-#endif
-	}
+	happy_meal_addr_init(hp, dp, qfe_slot);
 
 	/* Layout registers. */
 	hp->gregs      = (hpreg_base + 0x0000UL);
@@ -2747,7 +2734,6 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 	timer_setup(&hp->happy_timer, happy_meal_timer, 0);
 
 	hp->irq = pdev->irq;
-	hp->dev = dev;
 	dev->netdev_ops = &hme_netdev_ops;
 	dev->watchdog_timeo = 5*HZ;
 	dev->ethtool_ops = &hme_ethtool_ops;
-- 
2.37.1

