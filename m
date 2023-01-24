Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5705967A143
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 19:38:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233524AbjAXSiJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 13:38:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233594AbjAXSiF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 13:38:05 -0500
Received: from baptiste.telenet-ops.be (baptiste.telenet-ops.be [IPv6:2a02:1800:120:4::f00:13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C10B3250F
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 10:37:58 -0800 (PST)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed50:2f4a:8573:c294:b2ce])
        by baptiste.telenet-ops.be with bizsmtp
        id CidZ2900756uRqi01idZ8U; Tue, 24 Jan 2023 19:37:55 +0100
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtp (Exim 4.95)
        (envelope-from <geert@linux-m68k.org>)
        id 1pKOAe-007HCM-Gm;
        Tue, 24 Jan 2023 19:37:33 +0100
Received: from geert by rox.of.borg with local (Exim 4.95)
        (envelope-from <geert@linux-m68k.org>)
        id 1pKOAn-002n0Z-0R;
        Tue, 24 Jan 2023 19:37:33 +0100
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Vinod Koul <vkoul@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Thierry Reding <thierry.reding@gmail.com>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        Rob Herring <robh@kernel.org>,
        =?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kw@linux.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Siddharth Vadapalli <s-vadapalli@ti.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     linux-phy@lists.infradead.org, linux-doc@vger.kernel.org,
        netdev@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH v2 1/9] phy: Remove unused phy_optional_get()
Date:   Tue, 24 Jan 2023 19:37:20 +0100
Message-Id: <df61992b1d66bccf4e6e1eafae94a7f7d7629f34.1674584626.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1674584626.git.geert+renesas@glider.be>
References: <cover.1674584626.git.geert+renesas@glider.be>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There were never any upstream users of this function since its
introduction almost 10 years ago.

Besides, the dummy for phy_optional_get() should have returned NULL
instead of an error code.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
This is v2 of "phy: Return NULL if the PHY is optional (part two)".
---
 Documentation/driver-api/phy/phy.rst | 11 +++++------
 drivers/phy/phy-core.c               | 21 ---------------------
 include/linux/phy/phy.h              |  7 -------
 3 files changed, 5 insertions(+), 34 deletions(-)

diff --git a/Documentation/driver-api/phy/phy.rst b/Documentation/driver-api/phy/phy.rst
index 8e8b3e8f95238d18..26467dd4f291505e 100644
--- a/Documentation/driver-api/phy/phy.rst
+++ b/Documentation/driver-api/phy/phy.rst
@@ -103,7 +103,6 @@ it. This framework provides the following APIs to get a reference to the PHY.
 ::
 
 	struct phy *phy_get(struct device *dev, const char *string);
-	struct phy *phy_optional_get(struct device *dev, const char *string);
 	struct phy *devm_phy_get(struct device *dev, const char *string);
 	struct phy *devm_phy_optional_get(struct device *dev,
 					  const char *string);
@@ -111,15 +110,15 @@ it. This framework provides the following APIs to get a reference to the PHY.
 					     struct device_node *np,
 					     int index);
 
-phy_get, phy_optional_get, devm_phy_get and devm_phy_optional_get can
-be used to get the PHY. In the case of dt boot, the string arguments
+phy_get, devm_phy_get and devm_phy_optional_get can be used to get the PHY.
+In the case of dt boot, the string arguments
 should contain the phy name as given in the dt data and in the case of
 non-dt boot, it should contain the label of the PHY.  The two
 devm_phy_get associates the device with the PHY using devres on
 successful PHY get. On driver detach, release function is invoked on
-the devres data and devres data is freed. phy_optional_get and
-devm_phy_optional_get should be used when the phy is optional. These
-two functions will never return -ENODEV, but instead returns NULL when
+the devres data and devres data is freed.
+devm_phy_optional_get should be used when the phy is optional. This
+function will never return -ENODEV, but instead returns NULL when
 the phy cannot be found.Some generic drivers, such as ehci, may use multiple
 phys and for such drivers referencing phy(s) by name(s) does not make sense. In
 this case, devm_of_phy_get_by_index can be used to get a phy reference based on
diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
index d93ddf1262c5178b..672f5c86588609f3 100644
--- a/drivers/phy/phy-core.c
+++ b/drivers/phy/phy-core.c
@@ -766,27 +766,6 @@ struct phy *phy_get(struct device *dev, const char *string)
 }
 EXPORT_SYMBOL_GPL(phy_get);
 
-/**
- * phy_optional_get() - lookup and obtain a reference to an optional phy.
- * @dev: device that requests this phy
- * @string: the phy name as given in the dt data or the name of the controller
- * port for non-dt case
- *
- * Returns the phy driver, after getting a refcount to it; or
- * NULL if there is no such phy.  The caller is responsible for
- * calling phy_put() to release that count.
- */
-struct phy *phy_optional_get(struct device *dev, const char *string)
-{
-	struct phy *phy = phy_get(dev, string);
-
-	if (PTR_ERR(phy) == -ENODEV)
-		phy = NULL;
-
-	return phy;
-}
-EXPORT_SYMBOL_GPL(phy_optional_get);
-
 /**
  * devm_phy_get() - lookup and obtain a reference to a phy.
  * @dev: device that requests this phy
diff --git a/include/linux/phy/phy.h b/include/linux/phy/phy.h
index b1413757fcc3b89b..1b4f9be21e01f4c7 100644
--- a/include/linux/phy/phy.h
+++ b/include/linux/phy/phy.h
@@ -250,7 +250,6 @@ static inline void phy_set_bus_width(struct phy *phy, int bus_width)
 	phy->attrs.bus_width = bus_width;
 }
 struct phy *phy_get(struct device *dev, const char *string);
-struct phy *phy_optional_get(struct device *dev, const char *string);
 struct phy *devm_phy_get(struct device *dev, const char *string);
 struct phy *devm_phy_optional_get(struct device *dev, const char *string);
 struct phy *devm_of_phy_get(struct device *dev, struct device_node *np,
@@ -426,12 +425,6 @@ static inline struct phy *phy_get(struct device *dev, const char *string)
 	return ERR_PTR(-ENOSYS);
 }
 
-static inline struct phy *phy_optional_get(struct device *dev,
-					   const char *string)
-{
-	return ERR_PTR(-ENOSYS);
-}
-
 static inline struct phy *devm_phy_get(struct device *dev, const char *string)
 {
 	return ERR_PTR(-ENOSYS);
-- 
2.34.1

