Return-Path: <netdev+bounces-8506-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B89F7245B7
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 16:22:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A88321C20935
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 14:22:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A6E62DBC1;
	Tue,  6 Jun 2023 14:21:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E29237B71
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 14:21:55 +0000 (UTC)
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::226])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B94F10DE;
	Tue,  6 Jun 2023 07:21:49 -0700 (PDT)
X-GND-Sasl: maxime.chevallier@bootlin.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
	t=1686061307;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=0t7vCoDVyHCVRpFFeRRHKOJSt4buQfDPbfcgodci2/g=;
	b=Otets2FxZ6YC88+Kr8E458uM6KI2S7033D4zHHmnZL5Hxe9rKBOhhd+zAM13BXEE/EkA5x
	8r8+XAhryxr3Swo2NHKuvmO/XKHWtOn5Fj+T21kxDfrWi9JyVLDI044iMe1lMLxhPc/57x
	msBDKmYXFW3M1OmkhJdGSEHk/sjr1ajbHl5vZHBgJBkgcbdKmeki0EsDJ3ewjVUesGsGHW
	vP8cFmRUH21u0XqWbYQQQx22/21u5JdFhWh048WANhHtWS36j9RlncVqXyou9Px93Toxl0
	RA5J0VgUHinnIPEbX6e/Ey0KHUjyu9vdg+1Impu53Lo3axJCd4mIBMr0CHCmuQ==
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
Received: by mail.gandi.net (Postfix) with ESMTPSA id 7FD25C0013;
	Tue,  6 Jun 2023 14:21:45 +0000 (UTC)
From: Maxime Chevallier <maxime.chevallier@bootlin.com>
To: davem@davemloft.net
Cc: Maxime Chevallier <maxime.chevallier@bootlin.com>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	alexis.lothore@bootlin.com,
	thomas.petazzoni@bootlin.com,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Jose Abreu <joabreu@synopsys.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Giuseppe Cavallaro <peppe.cavallaro@st.com>,
	Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next v2 0/3] Followup fixes for the dwmac and altera lynx conversion
Date: Tue,  6 Jun 2023 16:21:41 +0200
Message-Id: <20230606142144.308675-1-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Following the TSE PCS removal and port of altera_tse and dwmac_socfpga,
this series fixes some issues that slipped through the cracks.

Patch 1 fixes an unitialized struct in altera_tse

Patch 2 uses the correct Kconfig option for altera_tse

Patch 3 makes the Lynx PCS specific to dwmac_socfpga. This patch was
originally written by Russell, my modifications just moves the
#include<linux/pcs-lynx.h> around, to use it only in dwmac_socfpga.

Maxime Chevallier (3):
  net: altera-tse: Initialize the regmap_config struct before using it
  net: altera_tse: Use the correct Kconfig option for the PCS_LYNX
    depenency
  net: stmmac: make the pcs_lynx cleanup sequence specific to
    dwmac_socfpga

 drivers/net/ethernet/altera/Kconfig               |  2 +-
 drivers/net/ethernet/altera/altera_tse_main.c     |  1 +
 drivers/net/ethernet/stmicro/stmmac/common.h      |  1 -
 .../net/ethernet/stmicro/stmmac/dwmac-socfpga.c   | 15 ++++++++++++++-
 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c |  3 ---
 5 files changed, 16 insertions(+), 6 deletions(-)

-- 
2.40.1


