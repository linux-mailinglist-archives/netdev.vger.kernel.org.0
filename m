Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 974E15BB0C1
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 18:03:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbiIPQDM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 12:03:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbiIPQC7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 12:02:59 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 372D8B56F0;
        Fri, 16 Sep 2022 09:02:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=E5lZqpNZZVWfKLJBZ+eoYKwNMWdNSTIEnNRwpbD9DFg=; b=iSy64FvyeAFmJiazFIMHlx5xJ9
        1s2EUpL0A4RsYVXKdUEhn1nFrhZH3KhHqOypAgUXOJfrrC9fa/dcWfh1dXQGtSJosDans8bmOtsxj
        5nCichWTEYVkZmJHndw5lkpTCcCZiiJiYTt38EqvmMsKMTqduCq2quNM+ivLHqheEAzcBWggQv6ev
        DuvUQqZ9IBFesCTQTh3lchv7zZUjpM6C33EuU2bmODueaW1NBPZ8EqZIqg1G/uRI/46F9tlv5l7ai
        1jzPUDfIZ+fP6xkk1dB3AhOeg8/JX7L1xqRimccg91S0ha3/Ka528mZThqZ/T1Mk2YnSiHip3PFCA
        mSk9dgeA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:48780 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1oZDno-0006ul-CT; Fri, 16 Sep 2022 17:02:52 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1oZDnn-0077aS-NA; Fri, 16 Sep 2022 17:02:51 +0100
In-Reply-To: <YySd3pASZKUh4leX@shell.armlinux.org.uk>
References: <YySd3pASZKUh4leX@shell.armlinux.org.uk>
From:   Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
To:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>
Cc:     Alyssa Rosenzweig <alyssa@rosenzweig.io>, asahi@lists.linux.dev,
        brcm80211-dev-list.pdl@broadcom.com,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Hector Martin <marcan@marcan.st>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        "Rafa__ Mi__ecki" <zajec5@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        SHA-cyfmac-dev-list@infineon.com, Sven Peter <sven@svenpeter.dev>
Subject: [PATCH wireless-next v3 06/12] brcmfmac: of: Fetch Apple properties
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1oZDnn-0077aS-NA@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Fri, 16 Sep 2022 17:02:51 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hector Martin <marcan@marcan.st>

On Apple ARM64 platforms, firmware selection requires two properties
that come from system firmware: the module-instance (aka "island", a
codename representing a given hardware platform) and the antenna-sku.
We map Apple's module codenames to board_types in the form
"apple,<module-instance>".

The mapped board_type is added to the DTS file in that form, while the
antenna-sku is forwarded by our bootloader from the Apple Device Tree
into the FDT. Grab them from the DT so firmware selection can use
them.

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Hector Martin <marcan@marcan.st>
Reviewed-by: Alvin Šipraga <alsi@bang-olufsen.dk>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 .../wireless/broadcom/brcm80211/brcmfmac/common.h    |  1 +
 .../net/wireless/broadcom/brcm80211/brcmfmac/of.c    | 12 +++++++++++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h
index 6c5a22a32a96..aa25abffcc7d 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h
@@ -53,6 +53,7 @@ struct brcmf_mp_device {
 	struct brcmfmac_pd_cc *country_codes;
 	const char	*board_type;
 	unsigned char	mac[ETH_ALEN];
+	const char	*antenna_sku;
 	union {
 		struct brcmfmac_sdio_pd sdio;
 	} bus;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
index 79388d49c256..a83699de01ec 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
@@ -70,14 +70,24 @@ void brcmf_of_probe(struct device *dev, enum brcmf_bus_type bus_type,
 {
 	struct brcmfmac_sdio_pd *sdio = &settings->bus.sdio;
 	struct device_node *root, *np = dev->of_node;
+	const char *prop;
 	int irq;
 	int err;
 	u32 irqf;
 	u32 val;
 
+	/* Apple ARM64 platforms have their own idea of board type, passed in
+	 * via the device tree. They also have an antenna SKU parameter
+	 */
+	if (!of_property_read_string(np, "brcm,board-type", &prop))
+		settings->board_type = prop;
+
+	if (!of_property_read_string(np, "apple,antenna-sku", &prop))
+		settings->antenna_sku = prop;
+
 	/* Set board-type to the first string of the machine compatible prop */
 	root = of_find_node_by_path("/");
-	if (root) {
+	if (root && !settings->board_type) {
 		char *board_type;
 		const char *tmp;
 
-- 
2.30.2

