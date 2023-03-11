Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4B146B5FAA
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 19:19:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230517AbjCKSTg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 13:19:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230431AbjCKST1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 13:19:27 -0500
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98D1E59400;
        Sat, 11 Mar 2023 10:19:15 -0800 (PST)
Received: by mail-qt1-x836.google.com with SMTP id l13so9304741qtv.3;
        Sat, 11 Mar 2023 10:19:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678558754;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9PXLPzAtfehW08ZAXdSsYNbiCMYMth6hztWbsXm+Zsw=;
        b=SjvtErNmNuy5VCX0Ca+cNk4paRYsuCvEaTwQ3Xf4mtDdJBzBgOEhWwri+gl3uJl5cC
         pxjz1p27Xdl6vIJftlWoY7B1hUN1phH0LY2oQtjP7ppp2sKe2bJUSfGMbfb9rY+6mxYC
         TrUr0VxXfCbqCbV6ZYatpmyryGUDTPpRSQlRAbxO5gnC4S8v5c+5WqY2HGJzCk21qvLu
         y+loy/vIU8u0P3ndocyl9NEMmcfoFFSapL9jNyarjWsYDTcrGu6TqDOMKBHat5T1y8yV
         lqkBFvcOCCxRyUexYT7mHIU9HzZXqVng2GfZf8zVj/UOz9qnIGSxtWnOV9g0Z/mbi/0i
         KCvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678558754;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9PXLPzAtfehW08ZAXdSsYNbiCMYMth6hztWbsXm+Zsw=;
        b=VYOsvZO6sKv6JWCJcqCFQZr9/bZDoEDxxot3xtm7iGbUGEt1bUfLrxlULWy+lEf8g1
         ajOc3JcvdMkb2QSBADGHj9ytF10dX4Qf2jpkMWoiqKU1Asu5lSCCqqb7Gb3suUGMOBKi
         EyKUMY3wZTlMxLiFJhXV7ERUQz4PaAEf1bXLIOWz7YmcoNx/MeNt7f7Gsj2dWtYGKjsZ
         xB4gsU/1vhLhwvF0nx+m1GMYIaMcBhhq8bmwfHW3oHGZnIqT7EAH/0B8h6u9lrHvZ+sI
         Zv1J59SpO3KdQHVIrJS+omasFj3UfEbIX0Nyxz/+2rGcuD2wJoYwp0LkTeH0Acobi6Vg
         yZww==
X-Gm-Message-State: AO0yUKW2jqGJgvaGo51yt8oZsbvXbaqaRRxgYpAR/Y1MCZMNeA8UrCXw
        jK0izTr0SVgUh2bY4kRwCvg=
X-Google-Smtp-Source: AK7set/oTG2zBactjb5RHftrC5+lfbtLdHBQ0FgcPWQfnsR53fFBtbCSrF5PW9KZSaxBi6QpGVkKXQ==
X-Received: by 2002:a05:622a:1a86:b0:3bf:c355:9ad4 with SMTP id s6-20020a05622a1a8600b003bfc3559ad4mr50184397qtc.34.1678558754691;
        Sat, 11 Mar 2023 10:19:14 -0800 (PST)
Received: from localhost (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with UTF8SMTPSA id s20-20020a37a914000000b00741a984943fsm2213341qke.40.2023.03.11.10.19.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Mar 2023 10:19:14 -0800 (PST)
From:   Sean Anderson <seanga2@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Simon Horman <simon.horman@corigine.com>,
        Sean Anderson <seanga2@gmail.com>
Subject: [PATCH net-next v2 6/9] net: sunhme: Consolidate mac address initialization
Date:   Sat, 11 Mar 2023 13:19:02 -0500
Message-Id: <20230311181905.3593904-7-seanga2@gmail.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20230311181905.3593904-1-seanga2@gmail.com>
References: <20230311181905.3593904-1-seanga2@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
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
---

(no changes since v1)

 drivers/net/ethernet/sun/sunhme.c | 282 ++++++++++++++----------------
 1 file changed, 134 insertions(+), 148 deletions(-)

diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index 24101d3d5f85..c4280bce69d4 100644
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
 	struct quattro *qp = NULL;
-#ifdef CONFIG_SPARC
-	struct device_node *dp;
-#endif
+	struct device_node *dp = NULL;
 	struct happy_meal *hp;
 	struct net_device *dev;
 	void __iomem *hpreg_base;
 	struct resource *hpreg_res;
-	int i, qfe_slot = -1;
+	int qfe_slot = -1;
 	char prom_name[64];
-	u8 addr[ETH_ALEN];
 	int err;
 
 	/* Now make sure pci_dev cookie is there. */
@@ -2635,7 +2650,7 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 	SET_NETDEV_DEV(dev, &pdev->dev);
 
 	hp = netdev_priv(dev);
-
+	hp->dev = dev;
 	hp->happy_dev = pdev;
 	hp->dma_dev = &pdev->dev;
 
@@ -2671,35 +2686,7 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
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
@@ -2748,7 +2735,6 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 	timer_setup(&hp->happy_timer, happy_meal_timer, 0);
 
 	hp->irq = pdev->irq;
-	hp->dev = dev;
 	dev->netdev_ops = &hme_netdev_ops;
 	dev->watchdog_timeo = 5*HZ;
 	dev->ethtool_ops = &hme_ethtool_ops;
-- 
2.37.1

