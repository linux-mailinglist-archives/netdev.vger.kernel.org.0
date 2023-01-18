Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A183671A48
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 12:17:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbjARLQ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 06:16:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbjARLQN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 06:16:13 -0500
X-Greylist: delayed 452 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 18 Jan 2023 02:29:31 PST
Received: from riemann.telenet-ops.be (riemann.telenet-ops.be [IPv6:2a02:1800:110:4::f00:10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 640147F99C
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 02:29:31 -0800 (PST)
Received: from xavier.telenet-ops.be (xavier.telenet-ops.be [IPv6:2a02:1800:120:4::f00:14])
        by riemann.telenet-ops.be (Postfix) with ESMTPS id 4Nxhd70RLgz4xTY9
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 11:21:47 +0100 (CET)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed50:4745:2e6d:e3a6:3327])
        by xavier.telenet-ops.be with bizsmtp
        id AAFN290042zf9gW01AFNxL; Wed, 18 Jan 2023 11:15:42 +0100
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtp (Exim 4.95)
        (envelope-from <geert@linux-m68k.org>)
        id 1pI5TQ-005aIN-M1;
        Wed, 18 Jan 2023 11:15:22 +0100
Received: from geert by rox.of.borg with local (Exim 4.95)
        (envelope-from <geert@linux-m68k.org>)
        id 1pI5TV-001JVg-Uw;
        Wed, 18 Jan 2023 11:15:21 +0100
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Madalin Bucur <madalin.bucur@nxp.com>,
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
        Vinod Koul <vkoul@kernel.org>,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Siddharth Vadapalli <s-vadapalli@ti.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-usb@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH treewide 0/7] phy: Add devm_of_phy_optional_get() helper
Date:   Wed, 18 Jan 2023 11:15:13 +0100
Message-Id: <cover.1674036164.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

	Hi all,

While there exist several optional_get() PHY helper functions, there is
no optional variant of devm_of_phy_get(), leading to several drivers
implementing this theirselves, sometimes in buggy ways.

Hence this series introduces a devm_of_phy_optional_get() helper(), and
converts existing users of devm_of_phy_get() where appropriate.

This series been compile-tested only, but the new helper itself has been
tested with a new user I am about to submit.

Thanks for your comments!

Geert Uytterhoeven (7):
  phy: Add devm_of_phy_optional_get() helper
  net: fman: memac: Convert to devm_of_phy_optional_get()
  net: lan966x: Convert to devm_of_phy_optional_get()
  net: ethernet: ti: am65-cpsw: Convert to devm_of_phy_optional_get()
  PCI: tegra: Convert to devm_of_phy_optional_get()
  usb: host: ehci-exynos: Convert to devm_of_phy_optional_get()
  usb: host: ohci-exynos: Convert to devm_of_phy_optional_get()

 .../net/ethernet/freescale/fman/fman_memac.c  |  8 +++---
 .../ethernet/microchip/lan966x/lan966x_main.c |  5 ++--
 drivers/net/ethernet/ti/am65-cpsw-nuss.c      |  6 ++---
 drivers/pci/controller/pci-tegra.c            |  5 +---
 drivers/phy/phy-core.c                        | 26 +++++++++++++++++++
 drivers/usb/host/ehci-exynos.c                | 24 +++++------------
 drivers/usb/host/ohci-exynos.c                | 24 +++++------------
 include/linux/phy/phy.h                       |  9 ++++++
 8 files changed, 59 insertions(+), 48 deletions(-)

-- 
2.34.1

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
