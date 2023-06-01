Return-Path: <netdev+bounces-7100-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CAA9719F6C
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 16:15:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A644C1C2103D
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 14:15:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA0F121CD9;
	Thu,  1 Jun 2023 14:15:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C405621063
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 14:15:07 +0000 (UTC)
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [217.70.183.200])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1435E186;
	Thu,  1 Jun 2023 07:15:03 -0700 (PDT)
X-GND-Sasl: maxime.chevallier@bootlin.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
	t=1685628902;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=GSKLVXScyIF80afcNDZ6IMVCbvZLfc7MWeR4l9bPXxU=;
	b=mnFKeur3xvzXNWe+lohQggL53A5bU6z/ZYAUAhvbL0gAHMssf0rrMoxwiDw1jXWBh201qN
	qKNCEwltHUbaIMLwubDM+Bzi+kZBo4ZbAcd37YLuZuSPEYouIH3X9svIG2VCRBfB8M/lVv
	ow2Kq5fY4/yMVrLgVPXfK0lrBAcnzw54zOWiagHKb7gD0UArUb1Mfp3txaoPLYR9F1eWYc
	yH4vRcW0ds3uqdAjboRXpFfJ+IFB1XSNSZsPDmbMErdR/Xtm9LURg/cI9DrZotzHBhffXW
	rtxNuiALfAdN4iLIM4fyF1ux7TQngMSm5d7NFsZmexBomO1Ss44Gi5UdZGQQhw==
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
X-GND-Sasl: maxime.chevallier@bootlin.com
Received: by mail.gandi.net (Postfix) with ESMTPSA id 926642000C;
	Thu,  1 Jun 2023 14:14:55 +0000 (UTC)
From: Maxime Chevallier <maxime.chevallier@bootlin.com>
To: Mark Brown <broonie@kernel.org>,
	davem@davemloft.net
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
Subject: [PATCH net-next v4 0/4] net: add a regmap-based mdio driver and drop TSE PCS
Date: Thu,  1 Jun 2023 16:14:50 +0200
Message-Id: <20230601141454.67858-1-maxime.chevallier@bootlin.com>
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
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello everyone,

This is the V4 of a series that follows-up on the work [1] aiming to drop the
altera TSE PCS driver, as it turns out to be a version of the Lynx PCS exposed
as a memory-mapped block, instead of living on an MDIO bus.

One step of this removal involved creating a regmap-based mdio driver
that translates MDIO accesses into the actual underlying bus that
exposes the register. The register layout must of course match the
standard MDIO layout, but we can now account for differences in stride
with recent work on the regmap subsystem [2].

Sorry for repeating this, but I didn't hear anything on this matter in previous
iterations, Mark, Net maintainers, this series depends on the patch
e12ff2876493 that was recently merged into the regmap tree [3].

For this series to be usable in net-next, this patch must be applied
beforehand. Should Mark create a tag that would then be merged into
net-next ? Or should we just wait for the next release to merge this
into net-next ?

This series introduces a new MDIO driver, and uses it to convert Altera
TSE from the actual TSE PCS driver to Lynx PCS.

Since it turns out dwmac_socfpga also uses a TSE PCS block, port that
driver to Lynx as well.

Changes in V4 :
 - Use new pcs_lynx_create/destroy helpers added by Russell
 - Rework the cleanup sequence to avoid leaking data
 - Rework a bit KConfig to properly select dependencies
 - Fix a few hiccups with misplaced hunks in 2 commits

Changes in V3 :
 - Use a dedicated struct for the mii bus's priv data, to avoid
   duplicating the whole struct mdio_regmap_config, from which 2 fields
   only are necessary after init, as suggested by Russell
 - Use ~0 instead of ~0UL for the no-scan bitmask, following Simon's
   review.

Changes in V2 :
 - Use phy_mask to avoid unnecessarily scanning the whole mdio bus
 - Go one step further and completely disable scanning if users
   set the .autoscan flag to false, in case the mdiodevice isn't an
   actual PHY (a PCS for example).

Thanks,

Maxime

[1] : https://lore.kernel.org/all/20230324093644.464704-1-maxime.chevallier@bootlin.com/
[2] : https://lore.kernel.org/all/20230407152604.105467-1-maxime.chevallier@bootlin.com/#t
[3] : https://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git/commit/?id=e12ff28764937dd58c8613f16065da60da149048

Maxime Chevallier (4):
  net: mdio: Introduce a regmap-based mdio driver
  net: ethernet: altera-tse: Convert to mdio-regmap and use PCS Lynx
  net: pcs: Drop the TSE PCS driver
  net: stmmac: dwmac-sogfpga: use the lynx pcs driver

 MAINTAINERS                                   |  14 +-
 drivers/net/ethernet/altera/Kconfig           |   2 +
 drivers/net/ethernet/altera/altera_tse_main.c |  57 +++-
 drivers/net/ethernet/stmicro/stmmac/Kconfig   |   3 +
 drivers/net/ethernet/stmicro/stmmac/Makefile  |   2 +-
 .../ethernet/stmicro/stmmac/altr_tse_pcs.c    | 257 ------------------
 .../ethernet/stmicro/stmmac/altr_tse_pcs.h    |  29 --
 drivers/net/ethernet/stmicro/stmmac/common.h  |   2 +
 .../ethernet/stmicro/stmmac/dwmac-socfpga.c   |  91 +++++--
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  12 +-
 .../net/ethernet/stmicro/stmmac/stmmac_mdio.c |   3 +
 drivers/net/mdio/Kconfig                      |  11 +
 drivers/net/mdio/Makefile                     |   1 +
 drivers/net/mdio/mdio-regmap.c                |  93 +++++++
 drivers/net/pcs/Kconfig                       |   6 -
 drivers/net/pcs/Makefile                      |   1 -
 drivers/net/pcs/pcs-altera-tse.c              | 160 -----------
 include/linux/mdio/mdio-regmap.h              |  26 ++
 include/linux/pcs-altera-tse.h                |  17 --
 19 files changed, 271 insertions(+), 516 deletions(-)
 delete mode 100644 drivers/net/ethernet/stmicro/stmmac/altr_tse_pcs.c
 delete mode 100644 drivers/net/ethernet/stmicro/stmmac/altr_tse_pcs.h
 create mode 100644 drivers/net/mdio/mdio-regmap.c
 delete mode 100644 drivers/net/pcs/pcs-altera-tse.c
 create mode 100644 include/linux/mdio/mdio-regmap.h
 delete mode 100644 include/linux/pcs-altera-tse.h

-- 
2.40.1


