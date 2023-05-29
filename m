Return-Path: <netdev+bounces-6010-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C39EA7145DA
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 10:02:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 66747280E06
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 08:02:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 843862112;
	Mon, 29 May 2023 08:02:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77EC81845
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 08:02:39 +0000 (UTC)
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [217.70.183.195])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B85CAF;
	Mon, 29 May 2023 01:02:35 -0700 (PDT)
X-GND-Sasl: alexis.lothore@bootlin.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
	t=1685347354;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=qQ93j6RUPrDaNV794pTv4bcf5lffw4EDkmv0DGtDjJg=;
	b=eq8CkUATRwgWk7FOADOn1SaW8m6CvvXfihw/OjPnMLJHXXe1c0jK49EC8WpBggQFJDZcFv
	L/q4b8KDcdFz4KPMjwHlzgTuqMw8bIye7SRLMXaoDtgQo66Ufa5wN5fyrcY3toXFiGn9O9
	7/di0HFc1lpEyZ1yg64OTyTLy6N66VuYs/gBN2/KuFZvpmc0deMKm4xnfqI/3QnRbGqEvw
	kXlD9zooNkqHTxnMbv6ja+7QgHf4i/IDD4fIxXlSGoHg3n4er0agJNlh6KU9/AI9gKs2wl
	MnXmqIy4U2ZQu4sV/R53z/Nqhht5d0bhC4+fpxfK68QMs1RFcvJg5bWjS/lhew==
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
Received: by mail.gandi.net (Postfix) with ESMTPSA id 652076000A;
	Mon, 29 May 2023 08:02:32 +0000 (UTC)
From: =?UTF-8?q?Alexis=20Lothor=C3=A9?= <alexis.lothore@bootlin.com>
To: Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Richard Cochran <richardcochran@gmail.com>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Russell King <linux@armlinux.org.uk>
Cc: linux-kernel@vger.kernel.org ,
	netdev@vger.kernel.org ,
	devicetree@vger.kernel.org ,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
	paul.arola@telus.com ,
	scott.roberts@telus.com ,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	=?UTF-8?q?Alexis=20Lothor=C3=A9?= <alexis.lothore@bootlin.com>
Subject: [PATCH net-next v4 0/7] net: dsa: mv88e6xxx: add 88E6361 support
Date: Mon, 29 May 2023 10:02:39 +0200
Message-Id: <20230529080246.82953-1-alexis.lothore@bootlin.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This series brings initial support for Marvell 88E6361 switch.

MV88E6361 is a 8 ports switch with 5 integrated Gigabit PHYs and 3
2.5Gigabit SerDes interfaces. It is in fact a new variant in the
88E639X/88E6193X/88E6191X family with a subset of existing features:
- port 0: MII, RMII, RGMII, 1000BaseX, 2500BaseX
- port 3 to 7: triple speed internal phys
- port 9 and 10: 1000BaseX, 25000BaseX

Since said family is already well supported in mv88e6xxx driver, adding
initial support for this new switch mostly consists in finding the ID
exposed in its identification register, adding a proper description
in switch description tables in mv88e6xxx driver, and enforcing 88E6361
specificities in mv88e6393x_XXX methods.

- first 4 commits introduce an internal phy offset field for switches which
  have internal phys but not starting from port 0
- 5th commit is a fix on existing switches based on first commits
- 6th commit is a slight modification to prepare 886361 support
- last commit introduces 88E6361 support in 88E6393X family

This initial support has been tested with two samples of a custom board
with the following hardware configuration:
- a main CPU connected to MV88E6361 using port 0 as CPU port
- port 9 wired to a SFP cage
- port 10 wired to a G.Hn transceiver

The following setup was used:
PC <-ethernet-> (copper SFP) - Board 1 - (G.hn) <-phone line(RJ11)-> (G.hn) Board 2

The unit 1 has been configured to bridge SFP port and G.hn port together,
which allowed to successfully ping Board 2 from PC.

Changes since v3:
- fix SoB
- reorder switch id list

Changes since v2:
- add Reviewed-By tags for untouched patches
- remove whitespace
- reorganized some conditions to avoid weird line split

Changes since v1:
- rework mv88e6xxx_port_ppu_updates to use internal helper
- add internal phys offset field to manage switches which do not have
  internal PHYs right on first ports
- fix 88E639X/88E6193X/88E6191X internal phy layout
- enforce 88E6361 features in mv88e6393x_port_set_speed_duplex
- enforce 88E6361 features in mv88e6393x_port_max_speed_mode
- enforce 88E6361 features in mv88e6393x_phylink_get_caps
- add Reviewed-By and Acked-By on untouched patch

Alexis Lothoré (7):
  dt-bindings: net: dsa: marvell: add MV88E6361 switch to compatibility
    list
  net: dsa: mv88e6xxx: pass directly chip structure to
    mv88e6xxx_phy_is_internal
  net: dsa: mv88e6xxx: use mv88e6xxx_phy_is_internal in
    mv88e6xxx_port_ppu_updates
  net: dsa: mv88e6xxx: add field to specify internal phys layout
  net: dsa: mv88e6xxx: fix 88E6393X family internal phys layout
  net: dsa: mv88e6xxx: pass mv88e6xxx_chip structure to
    port_max_speed_mode
  net: dsa: mv88e6xxx: enable support for 88E6361 switch

 .../devicetree/bindings/net/dsa/marvell.txt   |  2 +-
 drivers/net/dsa/mv88e6xxx/chip.c              | 69 ++++++++++++++-----
 drivers/net/dsa/mv88e6xxx/chip.h              | 11 ++-
 drivers/net/dsa/mv88e6xxx/global2.c           |  5 +-
 drivers/net/dsa/mv88e6xxx/port.c              | 26 +++++--
 drivers/net/dsa/mv88e6xxx/port.h              | 13 ++--
 6 files changed, 94 insertions(+), 32 deletions(-)

-- 
2.40.1


