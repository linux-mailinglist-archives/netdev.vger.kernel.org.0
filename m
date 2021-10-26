Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36F5343BA8F
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 21:17:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238619AbhJZTTj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 15:19:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235577AbhJZTTf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 15:19:35 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 449DAC061745
        for <netdev@vger.kernel.org>; Tue, 26 Oct 2021 12:17:11 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id z11-20020a1c7e0b000000b0030db7b70b6bso4180562wmc.1
        for <netdev@vger.kernel.org>; Tue, 26 Oct 2021 12:17:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cDQ6bg74xOCdLA37iiERl6+sKcKIWp7PrPN6h+6m8jk=;
        b=2UhQjMk+z9O1DWLNFDSUaWGe4pFE9/k/5WrMgI6BgJt8MEXqav12cvy7/b+zfVp51l
         jgkf/UyX9ElkmwqLEVncXPTrkDTdu9x0kAQhd2kKhGdjyRh/83FVJjWx2xz0LjKrDilD
         WvocIJOGQ11drv6L/Mdj1hO/qw1nuuec/QdrHoEludiTIvNOVUu79gt0+SWbmQUs6CWL
         tli/idp+i4sq62Mtl36VhKID1wzOBHnMqq9SjVRZfxofH82/rriFBP4afI3mBG+kVGxu
         N73oOuieMzYZACgBK4k+DyG01vJyudmvC+gMOmb2ecr2E5QNGZKe51xx/DwfT2QyeqZY
         /zDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cDQ6bg74xOCdLA37iiERl6+sKcKIWp7PrPN6h+6m8jk=;
        b=AXiQp3uu1R0YnlubcAJ5/0mPDfyoisyUwQ/LK0RyRmQz+QI+1CU+0WPYaiKJKehxQ7
         AzU/LlSIdelTQtYWeLzHyiFvBEmZSQY5z7ZyhdQ8tUeqOOzHBAQAuQCSlQkUxcE9ohXr
         to83dq7T2vsgu/l4Iuhjl6UiEeJ3kXpLKVX4FRgKl16ARBEDCTDKGJ3Oy4CfD9o4K5Ub
         IGemoMUuIJdyukiqZmN0SzBzBGZTLZ6+y+PJmb5bUubCkoVIO5/zrJjFqLgDWK1Zs5NQ
         z0y9bX/ThqBm2E6/Gsja1a5Vm7tMCGasx0aDNELcvQ9zv2k2Bmv++ln3I/5L6aNgqeRm
         Tujw==
X-Gm-Message-State: AOAM531cBt+jLi5dbkfD35N5zeqCzdNFk5rvtAHv60gA5GgFP2GMf04d
        rIhluzbcaEtehbw8F1n625k0hA==
X-Google-Smtp-Source: ABdhPJx2poGNP3xgh1lD28zcknAufRW6o2N9vY5fv+hetN1i39tVxS26VSMytlGeCIkzRdl73ASx9w==
X-Received: by 2002:a05:600c:4e91:: with SMTP id f17mr635618wmq.180.1635275829829;
        Tue, 26 Oct 2021 12:17:09 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id o194sm1584509wme.40.2021.10.26.12.17.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Oct 2021 12:17:09 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, kuba@kernel.org, linus.walleij@linaro.org,
        ulli.kroll@googlemail.com
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH] net: ethernet: cortina: permit to set mac address in DT
Date:   Tue, 26 Oct 2021 19:17:03 +0000
Message-Id: <20211026191703.1174086-1-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add ability of setting mac address in DT for cortina ethernet driver.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/net/ethernet/cortina/gemini.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/cortina/gemini.c b/drivers/net/ethernet/cortina/gemini.c
index 941f175fb911..f6aa2387a1af 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -2356,12 +2356,14 @@ static void gemini_port_save_mac_addr(struct gemini_ethernet_port *port)
 static int gemini_ethernet_port_probe(struct platform_device *pdev)
 {
 	char *port_names[2] = { "ethernet0", "ethernet1" };
+	struct device_node *np = pdev->dev.of_node;
 	struct gemini_ethernet_port *port;
 	struct device *dev = &pdev->dev;
 	struct gemini_ethernet *geth;
 	struct net_device *netdev;
 	struct device *parent;
 	unsigned int id;
+	u8 mac[ETH_ALEN];
 	int irq;
 	int ret;
 
@@ -2466,6 +2468,12 @@ static int gemini_ethernet_port_probe(struct platform_device *pdev)
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
2.32.0

