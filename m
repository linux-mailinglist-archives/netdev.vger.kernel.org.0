Return-Path: <netdev+bounces-8824-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 37BF6725DFB
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 14:08:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 926031C20DE9
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 12:08:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3710533CB5;
	Wed,  7 Jun 2023 12:08:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BF9730B90
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 12:08:19 +0000 (UTC)
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::224])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5921E1BD5;
	Wed,  7 Jun 2023 05:08:17 -0700 (PDT)
X-GND-Sasl: maxime.chevallier@bootlin.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
	t=1686139695;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=zDOmdelsTF8Z6hYisJ6LU6CbovJMoLnJ7YdYJmDf1ok=;
	b=DBOeENL1aunjzqB9GnjIuX+NQpbFPAUgX9U+zqJRBmOJxQGc3aLUl/x4yyNnyA690SBdsT
	fam6eB4E74ikXWnKneFeZPBdZrRCANi7s9PH7c0FWqcZH0cHTe8CJz1RF01/C0CE2/R9VA
	1DNMpqioOz63xeQNMQ7bvPttk78uEDN4jFs27talQoWIv2XSz1mwGISQwhHHokvoI7V23v
	TzE+M1fHhUwA8RcIdjhwKAk/D0q4YnDxGjsWd70t4sYyrQsrQJPgqcp5X76RO/9E52rNUN
	b1PGPonop4DMBh2o4mt27FHFm7zQGDDg9b018BjLUdHqKPNf4HyVKITkegFcEQ==
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
X-GND-Sasl: maxime.chevallier@bootlin.com
Received: by mail.gandi.net (Postfix) with ESMTPSA id 2CF07E0009;
	Wed,  7 Jun 2023 12:08:11 +0000 (UTC)
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
	Simon Horman <simon.horman@corigine.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Feiyang Chen <chenfeiyang@loongson.cn>
Subject: [PATCH net-next v4 0/5] Followup fixes for the dwmac and altera lynx conversion
Date: Wed,  7 Jun 2023 15:59:36 +0200
Message-Id: <20230607135941.407054-1-maxime.chevallier@bootlin.com>
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

Hello everyone,

Here's yet another version of the cleanup series for the TSE PCS replacement
by PCS Lynx. It includes Kconfig fixups, some missing initialisations
and a slight rework suggested by Russell for the dwmac cleanup sequence,
along with more explicit zeroing of local structures as per MAciej's
review.

V3->V4 :
 - Zero mdio_regmap_config objects
 - Make regmap config more local in dwmac_socfpga
V2->V3 :
 - Fix uninitialized .autoscan field for mdio regmap configuration in
   both altera_tse and dwmac_socfpga
V1->V2 : 
 - Fix a Kconfig inconsistency
 - rework the dwmac_socfpga cleanup sequence

Maxime Chevallier (5):
  net: altera-tse: Initialize local structs before using it
  net: altera_tse: Use the correct Kconfig option for the PCS_LYNX
    dependency
  net: stmmac: make the pcs_lynx cleanup sequence specific to
    dwmac_socfpga
  net: altera_tse: explicitly disable autoscan on the regmap-mdio bus
  net: dwmac_socfpga: initialize local data for mdio regmap
    configuration

 drivers/net/ethernet/altera/Kconfig           |  2 +-
 drivers/net/ethernet/altera/altera_tse_main.c |  3 ++
 drivers/net/ethernet/stmicro/stmmac/common.h  |  1 -
 .../ethernet/stmicro/stmmac/dwmac-socfpga.c   | 29 ++++++++++++++-----
 .../net/ethernet/stmicro/stmmac/stmmac_mdio.c |  3 --
 5 files changed, 26 insertions(+), 12 deletions(-)

-- 
2.40.1


