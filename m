Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C10A22C3B0
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 12:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727045AbgGXKul (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 06:50:41 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:21255 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726258AbgGXKul (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 06:50:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1595587840; x=1627123840;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Cjr/7u8Jt+g43O7HIK5/mtqne7V97GTeq84I0iqVAyA=;
  b=hlvVCqDRzZtiX1z2ku06iJlUf6TYOHpD65Euzp7RXa8D7zEdyE9PKEpT
   FUC1dBXoXvwLzQCHwBQSi/7mAgWftzCPDjdjGLeO4wqShl8bOAiZz6uNN
   EnlIzrAoYVgDfZuW4FeYseivcG715u+syOAozDxxwKALBDSgqeWAar32V
   M9ASAHDk9WK8XZmi+8rpLmCrmaMIkPZPX6aGSPoPT/Jak/fWgU58A8MhR
   1axXpVRQYD96fbxwGjmmSB6rVrAH4ucD9cg84Qvstva2lDO9EI5Tn3YrD
   RTWGYRmFLk+mYBiTnICy9HMPBavIQ/UEQuTD/Q4mQJr3zzW3+nSw+0V6t
   w==;
IronPort-SDR: Pm4IvCKiSg3ZSJ/8dcjM5M+TLfCkbchDw56GMxBVvpCg5r0rdbPyrRkqOcqQaQcNA3G6eGZQL4
 3nVwr8MyspQAgqqWOGs51HChOEqTVdz6XgomyBKhHdreoJkzZEQJOKt4Xr67yEaDQDKYKta8Je
 QDzC2roOJyM2rClgZpEElxZAysXtk02tnqrh04aXcJ1BXSWqWp+LRYOBG1vV73QsA6f8S/WGzb
 MYBmosfbRjOKoBCniRYmDySOH1PuUOUQCprmRZIrhz+qq8TFRsmktnTzcFYzVAwF17H1tONTvB
 2Qc=
X-IronPort-AV: E=Sophos;i="5.75,390,1589266800"; 
   d="scan'208";a="85236913"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Jul 2020 03:50:40 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 24 Jul 2020 03:50:40 -0700
Received: from rob-ult-m19940.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Fri, 24 Jul 2020 03:49:55 -0700
From:   Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC:     <nicolas.ferre@microchip.com>, <claudiu.beznea@microchip.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <f.fainelli@gmail.com>, <robh+dt@kernel.org>,
        <alexandre.belloni@bootlin.com>, <ludovic.desroches@microchip.com>,
        "Codrin Ciubotariu" <codrin.ciubotariu@microchip.com>
Subject: [PATCH net-next v3 0/7] Add an MDIO sub-node under MACB
Date:   Fri, 24 Jul 2020 13:50:26 +0300
Message-ID: <20200724105033.2124881-1-codrin.ciubotariu@microchip.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changes in v3:
 - in patch 3/7, moved the checking for mdio node at the beginning of
   the macb_mdiobus_register(). This allows to probe the MDIO devices
   even if macb is a fixed-link
 - added tags received on v2

Changes in v2:
 - renamed patch 2/7 from "macb: bindings doc: use an MDIO node as a
   container for PHY nodes" to "dt-bindings: net: macb: use an MDIO
   node as a container for PHY nodes"
 - added back a newline removed by mistake in patch 3/7

Codrin Ciubotariu (7):
  net: macb: use device-managed devm_mdiobus_alloc()
  dt-bindings: net: macb: use an MDIO node as a container for PHY nodes
  net: macb: parse PHY nodes found under an MDIO node
  ARM: dts: at91: sama5d2: add an mdio sub-node to macb
  ARM: dts: at91: sama5d3: add an mdio sub-node to macb
  ARM: dts: at91: sama5d4: add an mdio sub-node to macb
  ARM: dts: at91: sam9x60: add an mdio sub-node to macb

 Documentation/devicetree/bindings/net/macb.txt | 15 ++++++++++++---
 arch/arm/boot/dts/at91-sam9x60ek.dts           |  8 ++++++--
 arch/arm/boot/dts/at91-sama5d27_som1.dtsi      | 16 ++++++++++------
 arch/arm/boot/dts/at91-sama5d27_wlsom1.dtsi    | 17 ++++++++++-------
 arch/arm/boot/dts/at91-sama5d2_ptc_ek.dts      | 13 ++++++++-----
 arch/arm/boot/dts/at91-sama5d2_xplained.dts    | 12 ++++++++----
 arch/arm/boot/dts/at91-sama5d3_xplained.dts    | 16 ++++++++++++----
 arch/arm/boot/dts/at91-sama5d4_xplained.dts    | 12 ++++++++----
 drivers/net/ethernet/cadence/macb_main.c       | 18 ++++++++++++------
 9 files changed, 86 insertions(+), 41 deletions(-)

-- 
2.25.1

