Return-Path: <netdev+bounces-6286-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A05047158B5
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 10:37:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4BAC12810EE
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 08:37:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1FB012B62;
	Tue, 30 May 2023 08:37:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5612125D3
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 08:37:33 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93AAEBF
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 01:37:31 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ore@pengutronix.de>)
	id 1q3uqy-0002xV-JO; Tue, 30 May 2023 10:37:16 +0200
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
	(envelope-from <ore@pengutronix.de>)
	id 1q3uqw-003pae-UH; Tue, 30 May 2023 10:37:14 +0200
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
	(envelope-from <ore@pengutronix.de>)
	id 1q3uqw-00AbUb-2J; Tue, 30 May 2023 10:37:14 +0200
From: Oleksij Rempel <o.rempel@pengutronix.de>
To: Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	=?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= <jerome.pouiller@silabs.com>
Cc: Oleksij Rempel <o.rempel@pengutronix.de>,
	kernel@pengutronix.de,
	linux-kernel@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org,
	devicetree@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH v2 0/3] Extend dt-bindings for PSE-PD controllers and update prtt1c dts
Date: Tue, 30 May 2023 10:37:10 +0200
Message-Id: <20230530083713.2527380-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

changes v2:
- extend ethernet-pse regexp in the PoDL PSE dt-bindings

This patch set comes in response to issues identified while adding PoDL
PSE support to the stm32 prtt1c device tree. The existing pse-pd device
tree bindings did not allow node name patterns like "ethernet-pse-0" and
"ethernet-pse-1", leading to validation failures.

To address these false positives in validation, the device tree bindings
are extended to support these node name patterns. Alongside this, an
example node is added to aid in the improved validation process.
Following these changes, the updated PoDL PSE regulator nodes are then
added to the stm32 prtt1c device tree.
 
Oleksij Rempel (3):
  dt-bindings: net: pse-pd: Update regex pattern for ethernet-pse nodes
  dt-bindings: net: pse-pd: Add "ethernet-pse-0" example to improve
    validation in podl-pse-regulator DT binding
  ARM: dts: stm32: prtt1c: Add PoDL PSE regulator nodes

 .../net/pse-pd/podl-pse-regulator.yaml        |  6 ++++
 .../bindings/net/pse-pd/pse-controller.yaml   |  2 +-
 arch/arm/boot/dts/stm32mp151a-prtt1c.dts      | 32 +++++++++++++++++++
 3 files changed, 39 insertions(+), 1 deletion(-)

-- 
2.39.2


