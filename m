Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FB386D386A
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 16:31:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230516AbjDBObx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 10:31:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230241AbjDBObs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 10:31:48 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DB0912054
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 07:31:25 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1piyjM-0002tW-Lv; Sun, 02 Apr 2023 16:30:52 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1piyjD-008TQM-5v; Sun, 02 Apr 2023 16:30:43 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1piyjC-009zBI-BL; Sun, 02 Apr 2023 16:30:42 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Vinod Koul <vkoul@kernel.org>, Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Samuel Holland <samuel@sholland.org>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>
Cc:     Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Bhupesh Sharma <bhupesh.sharma@linaro.org>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de,
        linux-amlogic@lists.infradead.org, linux-oxnas@groups.io,
        linux-sunxi@lists.linux.dev, linux-mediatek@lists.infradead.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH net-next 00/11] net: stmmac: Convert to platform remove callback returning void
Date:   Sun,  2 Apr 2023 16:30:14 +0200
Message-Id: <20230402143025.2524443-1-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=3027; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=2S8iDuofW67/ny3bI4GsEkxdI4rVopUa4vtAe1AT45s=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBkKZFtalM3e5vgpcp2bO9QfXXotzevy7zlzaW6S v6ELfAMxDeJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZCmRbQAKCRCPgPtYfRL+ Th1PCACf4rIZGqr7Q1fHE0q/GWziKMJqR85AtxSGXJLhzT7CQSsyTXjBwYVABzW53zfy7pCrr4T HXZsWp66M/nk9P5mpeaDTcUcTPF6Qs/NTHteV/BXG4fj6e6WI8rrYF+KM04pO7+oF6oguY4imfS fwj5GYmyLZIFPP/iQjUjtQ9EHVBjDYDZw7rgDnX9S0aT6ntEGHpOtyknrs9kXNI832Squ9C+XCP s0fDZLuIuFx9EEAo3qRBbBheDH0kO3cs1Gg2Dq9MPf/PxvjH7KAtCymq/Kmlp1vFkRa+j88Wy5w a9Bnr4Pih92GDV2Y6wNv/CXK5iG5ZlZVUwGFiMn21RZaY50D
X-Developer-Key: i=u.kleine-koenig@pengutronix.de; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

this series adapts the platform drivers below
drivers/net/ethernet/stmicro to use the .remove_new() callback. Compared
to the traditional .remove() callback .remove_new() returns no value.
This is a good thing because the driver core doesn't (and cannot) cope
for errors during remove. The only effect of a non-zero return value in
.remove() is that the driver core emits a warning. The device is removed
anyhow and an early return from .remove() usually yields a resource
leak.

The first three commits make sure that the various remove callbacks
(obviously) always return zero. After that all drivers are converted to
.remove_new().

Uwe Kleine-König (11):
  net: stmmac: Make stmmac_pltfr_remove() return void
  net: stmmac: dwmac-visconti: Make visconti_eth_clock_remove() return void
  net: stmmac: dwmac-qcom-ethqos: Drop an if with an always false condition
  net: stmmac: dwmac-visconti: Convert to platform remove callback returning void
  net: stmmac: dwmac-dwc-qos-eth: Convert to platform remove callback returning void
  net: stmmac: dwmac-qcom-ethqos: Convert to platform remove callback returning void
  net: stmmac: dwmac-rk: Convert to platform remove callback returning void
  net: stmmac: dwmac-sti: Convert to platform remove callback returning void
  net: stmmac: dwmac-stm32: Convert to platform remove callback returning void
  net: stmmac: dwmac-sun8i: Convert to platform remove callback returning void
  net: stmmac: dwmac-tegra: Convert to platform remove callback returning void

 .../ethernet/stmicro/stmmac/dwmac-anarion.c   |  2 +-
 .../stmicro/stmmac/dwmac-dwc-qos-eth.c        |  6 ++----
 .../ethernet/stmicro/stmmac/dwmac-generic.c   |  2 +-
 .../net/ethernet/stmicro/stmmac/dwmac-imx.c   |  2 +-
 .../ethernet/stmicro/stmmac/dwmac-ingenic.c   |  2 +-
 .../stmicro/stmmac/dwmac-intel-plat.c         |  9 +++------
 .../ethernet/stmicro/stmmac/dwmac-ipq806x.c   |  2 +-
 .../ethernet/stmicro/stmmac/dwmac-lpc18xx.c   |  2 +-
 .../ethernet/stmicro/stmmac/dwmac-mediatek.c  |  9 +++------
 .../net/ethernet/stmicro/stmmac/dwmac-meson.c |  2 +-
 .../ethernet/stmicro/stmmac/dwmac-meson8b.c   |  2 +-
 .../net/ethernet/stmicro/stmmac/dwmac-oxnas.c |  2 +-
 .../stmicro/stmmac/dwmac-qcom-ethqos.c        | 15 ++++-----------
 .../net/ethernet/stmicro/stmmac/dwmac-rk.c    |  6 ++----
 .../ethernet/stmicro/stmmac/dwmac-socfpga.c   |  2 +-
 .../net/ethernet/stmicro/stmmac/dwmac-sti.c   |  6 ++----
 .../net/ethernet/stmicro/stmmac/dwmac-stm32.c |  6 ++----
 .../net/ethernet/stmicro/stmmac/dwmac-sun8i.c |  6 ++----
 .../net/ethernet/stmicro/stmmac/dwmac-sunxi.c |  2 +-
 .../net/ethernet/stmicro/stmmac/dwmac-tegra.c |  6 ++----
 .../ethernet/stmicro/stmmac/dwmac-visconti.c  | 19 +++++--------------
 .../ethernet/stmicro/stmmac/stmmac_platform.c |  4 +---
 .../ethernet/stmicro/stmmac/stmmac_platform.h |  2 +-
 23 files changed, 40 insertions(+), 76 deletions(-)

base-commit: fe15c26ee26efa11741a7b632e9f23b01aca4cc6
-- 
2.39.2

