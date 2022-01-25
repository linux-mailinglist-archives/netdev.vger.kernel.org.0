Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD2E49BDB2
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 22:08:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232933AbiAYVIS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 16:08:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232926AbiAYVIR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 16:08:17 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88D65C06173B
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 13:08:17 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id k18so22170408wrg.11
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 13:08:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hRIN485mlrcj7PPVRMy8ZYW6DMVN6CxvBD0Qt81l1Tg=;
        b=OyrpCheu4IWP3j94dt4Uj0kEGkstoBwoUm3UKy4oBO/VlamYoAx7eXnGkILTYYfZET
         qNOfhb6jxPfdU7QvlE+v86iAHDqGuezVfhMCghFT82VEoD+y56loVkSRbajLF7bMLjO6
         dtK76w2qWtUxZL7WnMFU3sAHQpW6kwpWQ6S/wGpVoNeVjtbXTaZ7nZJxTd7UKUMISICo
         UxkVjmFGtrM40o9rlhHO+EiKnnSsf8iym9+S2oWqwdWgvr2khPWrdzYHY8Onr9t1lPDj
         lm21C5eOszRzEvDVYlGFIB+7pTBN0N6JV01e64GFbFugK+rmcdgd7k8cqGTQEl/pSnW3
         ZyiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hRIN485mlrcj7PPVRMy8ZYW6DMVN6CxvBD0Qt81l1Tg=;
        b=qvn7COLq6HzWEm49BgjocijdiURZx2V8GV8VGJ6qrS81e5xR5wbfqXNw0G1QT/SMXE
         JUBAxrllqkGmbx6fiotVgUOsiOTcPsT2MGIiaoyd1WOS58BhSp3obRgvkXGxgbhVKTlI
         jeqGYAP4qOdbOotRF2Fc+f9qQ9cSr3Y8+cv3+IEY2Y5UFDRHGLnitFCuZXaSRq88JfmO
         mtyq4Vt+8TxcjcY27pzIqYXg7gRp/wjfgt9BQ7TIzbtohQRAU/AlVeVC85XvhFQikHoM
         U8O/2YSXye8BAS5pJXEmZAMyHwzVwFx2jbuC/zj9TXMs8fXARFieVTzOrmi0tnpQ2B4n
         AOlA==
X-Gm-Message-State: AOAM533S6gf+H8vIAwkuEHc+HiGKApKVPYONJ3KEPfmHKGJhXhuDmxJo
        RTsATRTsx/I/4gTSw9DMbf9jkeHF+6T3iA==
X-Google-Smtp-Source: ABdhPJww6SSNDfbkoVqhrP5f+frAHLa703i6C7GEUir+k8Tg6t0E8oOm4/LyTIQR7+h5rj2QqFOwaw==
X-Received: by 2002:adf:cc8c:: with SMTP id p12mr18853884wrj.677.1643144896183;
        Tue, 25 Jan 2022 13:08:16 -0800 (PST)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id a14sm19140853wri.25.2022.01.25.13.08.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 13:08:15 -0800 (PST)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, kuba@kernel.org, linus.walleij@linaro.org,
        ulli.kroll@googlemail.com
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v2] net: ethernet: cortina: permit to set mac address in DT
Date:   Tue, 25 Jan 2022 21:08:11 +0000
Message-Id: <20220125210811.54350-1-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add ability of setting mac address in DT for cortina ethernet driver.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
---
Changes since v1:
- fixed reverse christmas tree of the mac variable

 drivers/net/ethernet/cortina/gemini.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/cortina/gemini.c b/drivers/net/ethernet/cortina/gemini.c
index c78b99a497df..8014eb33937c 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -2363,11 +2363,13 @@ static void gemini_port_save_mac_addr(struct gemini_ethernet_port *port)
 static int gemini_ethernet_port_probe(struct platform_device *pdev)
 {
 	char *port_names[2] = { "ethernet0", "ethernet1" };
+	struct device_node *np = pdev->dev.of_node;
 	struct gemini_ethernet_port *port;
 	struct device *dev = &pdev->dev;
 	struct gemini_ethernet *geth;
 	struct net_device *netdev;
 	struct device *parent;
+	u8 mac[ETH_ALEN];
 	unsigned int id;
 	int irq;
 	int ret;
@@ -2473,6 +2475,12 @@ static int gemini_ethernet_port_probe(struct platform_device *pdev)
 	netif_napi_add(netdev, &port->napi, gmac_napi_poll,
 		       DEFAULT_NAPI_WEIGHT);
 
+	ret = of_get_mac_address(np, mac);
+	if (!ret) {
+		dev_info(dev, "Setting macaddr from DT %pM\n", mac);
+		memcpy(port->mac_addr, mac, ETH_ALEN);
+	}
+
 	if (is_valid_ether_addr((void *)port->mac_addr)) {
 		eth_hw_addr_set(netdev, (u8 *)port->mac_addr);
 	} else {
-- 
2.34.1

