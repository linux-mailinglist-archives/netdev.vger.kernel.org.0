Return-Path: <netdev+bounces-8825-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 60ECD725E01
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 14:08:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9140C280DD0
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 12:08:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C493434443;
	Wed,  7 Jun 2023 12:08:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B95A130B90
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 12:08:21 +0000 (UTC)
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::224])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF3F51BD4;
	Wed,  7 Jun 2023 05:08:19 -0700 (PDT)
X-GND-Sasl: maxime.chevallier@bootlin.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
	t=1686139698;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6WgS2itewXgwIqmxjlbCVju713PZbtSt5czOzpTuXBA=;
	b=INw8V+2UyFA/SPRFanuth0K/BngfjNL1jgchzheesyHYptmp5GvGnc+eRJ3pkV5Gs1jTRf
	u000j3TuffrZhH+D4bfp2tGaxRae2v5NO547fXC+VWipEBuHWo1969nY0W7t6xUtCWbJGo
	9lPidmLHPTrqJxsOs0RFWaFWlI45okDOx6QBUJTYWugXu4nEN2ohE5cMINXi+rMJRRF6ua
	jn0ivkiOYqYr8+Dors43NrstoqhZbrv8fAgd+F4GTPi9pQpuVDtQIDTIrX8SMb0ofGrr97
	26hwkPgxT8FC8tdyYIP4qg6TNqjAmUlJkobM+Bcz/EUrW9m6mfi1D5M8TQaDRQ==
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
Received: by mail.gandi.net (Postfix) with ESMTPSA id EAB9DE000D;
	Wed,  7 Jun 2023 12:08:15 +0000 (UTC)
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
Subject: [PATCH net-next v4 1/5] net: altera-tse: Initialize local structs before using it
Date: Wed,  7 Jun 2023 15:59:37 +0200
Message-Id: <20230607135941.407054-2-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230607135941.407054-1-maxime.chevallier@bootlin.com>
References: <20230607135941.407054-1-maxime.chevallier@bootlin.com>
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

The regmap_config and mdio_regmap_config objects needs to be zeroed before
using them. This will cause spurious errors at probe time as config->pad_bits
is containing random uninitialized data.

Fixes: db48abbaa18e ("net: ethernet: altera-tse: Convert to mdio-regmap and use PCS Lynx")
Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
---
V3->V4 : Also zero "mrc" from Maciej's review
V2->V3 : No changes
V1->V2 : No changes

 drivers/net/ethernet/altera/altera_tse_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/altera/altera_tse_main.c b/drivers/net/ethernet/altera/altera_tse_main.c
index d866c0f1b503..215f9fb89c5b 100644
--- a/drivers/net/ethernet/altera/altera_tse_main.c
+++ b/drivers/net/ethernet/altera/altera_tse_main.c
@@ -1255,6 +1255,8 @@ static int altera_tse_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_free_netdev;
 
+	memset(&pcs_regmap_cfg, 0, sizeof(pcs_regmap_cfg));
+	memset(&mrc, 0, sizeof(mrc));
 	/* SGMII PCS address space. The location can vary depending on how the
 	 * IP is integrated. We can have a resource dedicated to it at a specific
 	 * address space, but if it's not the case, we fallback to the mdiophy0
-- 
2.40.1


