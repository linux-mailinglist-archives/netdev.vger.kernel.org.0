Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05548203436
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 12:01:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727860AbgFVKBZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 06:01:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727841AbgFVKBX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 06:01:23 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD3F8C061797
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 03:01:21 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id c3so15967285wru.12
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 03:01:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eg4utbhrf/3v6wZhuPotuFpmqRh7IC4ZAOzFVoP+DSU=;
        b=MxEnyo505JlU2NM71Ns3rqf71HG9d+3e0DSgBr4zrwK8k/6QZkxukBWBPbXD0U7DOU
         LTkBY0EmU2E4b1wfmzJjeUMAcwEQbL6bY0Hxl0Zle/ZEIhZf9HVji4mYG9zx7e5CQY4u
         CCATyRl6NEWhTBKaJ58QnmPlrIe3Dpoz9v76MGezVbZdpfDsY8bQjSRNfPy0117mdmc7
         ZWOILTIDUcfXtXy0/X7HXWgBFDWAUDVKV9VQFgANzt2cc9PVEsPMYZoVDpe/q0TWrtQm
         vP1dPPAeTocwkUNR3FXFR7z6gj9eEexFguHwDu10Lr43tHqCkUMFiBLt0giJs6h4sjhU
         4RRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eg4utbhrf/3v6wZhuPotuFpmqRh7IC4ZAOzFVoP+DSU=;
        b=i1Ux/XGFTFyEVr2/sj7o+6EBSfegSRTiqp9x49Jm9FgspMnys5U3c9Ax/TaIxdFTBd
         +2gwU7nXlrXyKiQ04tfmgsBvc1tpl/1S0NW3T4fzp95xsn11puGndMDdx7/9Zy0pJukm
         MitCWe26S8gF0PfYBiotwhTEBcY2IRoMej7PnmOEI+95V5aAKBLJkF0ju+i5O2PIF6Kn
         2fF12nPkqINWA/NPnrfZHhKXxQlOMTdL8PLtGqE07sXGIRVUETnCg5hv0/JhVd7rYffl
         N4ENKfF2Ax4JUW9czYD03dCSi+Xe4tscEuupgEZkuqEAMC54RR5l0RGGxRUSQD2ViTZb
         +wWg==
X-Gm-Message-State: AOAM531AcFQeOUhbFsbaU+yC2HiV0PQwx1pcGKhSP+QT+ZVshJ5ScGiV
        bY+Q1Bv/2HnuriqzP8eNL+ALLQ==
X-Google-Smtp-Source: ABdhPJzUx9/chMNKmLzAYZpTwQ9uy6yZYRBRjyWPOHP+aXvq3C4Pttlm2e9Adw57f6qs+y2AureErg==
X-Received: by 2002:adf:dd83:: with SMTP id x3mr16132134wrl.292.1592820080518;
        Mon, 22 Jun 2020 03:01:20 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id x205sm16822187wmx.21.2020.06.22.03.01.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 03:01:20 -0700 (PDT)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     Jonathan Corbet <corbet@lwn.net>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, devicetree@vger.kernel.org,
        Fabien Parent <fparent@baylibre.com>,
        Stephane Le Provost <stephane.leprovost@mediatek.com>,
        Pedro Tsai <pedro.tsai@mediatek.com>,
        Andrew Perepech <andrew.perepech@mediatek.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 09/11] of: mdio: remove the 'extern' keyword from function declarations
Date:   Mon, 22 Jun 2020 12:00:54 +0200
Message-Id: <20200622100056.10151-10-brgl@bgdev.pl>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200622100056.10151-1-brgl@bgdev.pl>
References: <20200622100056.10151-1-brgl@bgdev.pl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

The 'extern' keyword in headers doesn't have any benefit. Remove them
all from the of_mdio.h header.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 include/linux/of_mdio.h | 37 ++++++++++++++++++-------------------
 1 file changed, 18 insertions(+), 19 deletions(-)

diff --git a/include/linux/of_mdio.h b/include/linux/of_mdio.h
index 0f61a4ac6bcf..ba8e157f24ad 100644
--- a/include/linux/of_mdio.h
+++ b/include/linux/of_mdio.h
@@ -12,27 +12,26 @@
 #include <linux/of.h>
 
 #if IS_ENABLED(CONFIG_OF_MDIO)
-extern bool of_mdiobus_child_is_phy(struct device_node *child);
-extern int of_mdiobus_register(struct mii_bus *mdio, struct device_node *np);
-extern struct phy_device *of_phy_find_device(struct device_node *phy_np);
-extern struct phy_device *of_phy_connect(struct net_device *dev,
-					 struct device_node *phy_np,
-					 void (*hndlr)(struct net_device *),
-					 u32 flags, phy_interface_t iface);
-extern struct phy_device *
+bool of_mdiobus_child_is_phy(struct device_node *child);
+int of_mdiobus_register(struct mii_bus *mdio, struct device_node *np);
+struct phy_device *of_phy_find_device(struct device_node *phy_np);
+struct phy_device *
+of_phy_connect(struct net_device *dev, struct device_node *phy_np,
+	       void (*hndlr)(struct net_device *), u32 flags,
+	       phy_interface_t iface);
+struct phy_device *
 of_phy_get_and_connect(struct net_device *dev, struct device_node *np,
 		       void (*hndlr)(struct net_device *));
-struct phy_device *of_phy_attach(struct net_device *dev,
-				 struct device_node *phy_np, u32 flags,
-				 phy_interface_t iface);
-
-extern struct mii_bus *of_mdio_find_bus(struct device_node *mdio_np);
-extern int of_phy_register_fixed_link(struct device_node *np);
-extern void of_phy_deregister_fixed_link(struct device_node *np);
-extern bool of_phy_is_fixed_link(struct device_node *np);
-extern int of_mdiobus_phy_device_register(struct mii_bus *mdio,
-				     struct phy_device *phy,
-				     struct device_node *child, u32 addr);
+struct phy_device *
+of_phy_attach(struct net_device *dev, struct device_node *phy_np,
+	      u32 flags, phy_interface_t iface);
+
+struct mii_bus *of_mdio_find_bus(struct device_node *mdio_np);
+int of_phy_register_fixed_link(struct device_node *np);
+void of_phy_deregister_fixed_link(struct device_node *np);
+bool of_phy_is_fixed_link(struct device_node *np);
+int of_mdiobus_phy_device_register(struct mii_bus *mdio, struct phy_device *phy,
+				   struct device_node *child, u32 addr);
 
 static inline int of_mdio_parse_addr(struct device *dev,
 				     const struct device_node *np)
-- 
2.26.1

