Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11C92ECCB4
	for <lists+netdev@lfdr.de>; Sat,  2 Nov 2019 02:15:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728421AbfKBBOj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 21:14:39 -0400
Received: from ssl.serverraum.org ([176.9.125.105]:48721 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727814AbfKBBOP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 21:14:15 -0400
Received: from apollo.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:6257:18ff:fec4:ca34])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id CD348224C1;
        Sat,  2 Nov 2019 02:14:08 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc;
        s=mail2016061301; t=1572657253;
        bh=coap/IZFRQ4M2syEqYhwbUnfZttYrUZ66xrrwe3nm60=;
        h=From:To:Cc:Subject:Date:From;
        b=Be22zF5FD1O9jgvo3ulntDV80CWrh0L3745rj+Rsng7D/bvXHUYwn71K8UNqpSAer
         /9itjG7lg1wG/05NpqcaR4fhTBiA5vK9JJU7a94cbyl/OhNKrxLhMv1MRvGxYBOK44
         7T+yIpb+Sl4kwuI96Sfc5qr2mRnJK+wTLxnjicEs=
From:   Michael Walle <michael@walle.cc>
To:     linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Michael Walle <michael@walle.cc>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Simon Horman <simon.horman@netronome.com>
Subject: [PATCH 0/5] net: phy: at803x device tree binding
Date:   Sat,  2 Nov 2019 02:13:46 +0100
Message-Id: <20191102011351.6467-1-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.101.4 at web
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adds a device tree binding to configure the clock and the RGMII voltage.

Changes since the RFC:
 - renamed the Kconfig entry to "Qualcomm Atheros.." and reordered the
   item
 - renamed the prefix from atheros to qca
 - use the correct name AR803x (instead of AT803x) in new files and
   dt-bindings.
 - listed the PHY maintainers in the new schema. Hopefully, thats ok.
 - fixed a typo in the bindings schema
 - run dtb_checks and dt_binding_check and fixed the schema
 - dropped the rgmii-io-1v8 property; instead provide two regulators vddh
   and vddio, add one consumer vddio-supply
 - fix the clock settings for the AR8030/AR8035
 - only the AR8031 supports chaning the LDO and the PLL mode in software.
   Check if we have the correct PHY.
 - new patch to mention the AR8033 which is the same as the AR8031 just
   without PTP support
 - new patch which corrects any displayed PHY names and comments. Be
   consistent.

Michael Walle (5):
  net: phy: at803x: fix Kconfig description
  dt-bindings: net: phy: Add support for AT803X
  net: phy: at803x: add device tree binding
  net: phy: at803x: mention AR8033 as same as AR8031
  net: phy: at803x: fix the PHY names

 .../devicetree/bindings/net/qca,ar803x.yaml   | 111 +++++++
 MAINTAINERS                                   |   2 +
 drivers/net/phy/Kconfig                       |  10 +-
 drivers/net/phy/at803x.c                      | 301 +++++++++++++++++-
 include/dt-bindings/net/qca-ar803x.h          |  13 +
 5 files changed, 422 insertions(+), 15 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/qca,ar803x.yaml
 create mode 100644 include/dt-bindings/net/qca-ar803x.h

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Simon Horman <simon.horman@netronome.com>
-- 
2.20.1

