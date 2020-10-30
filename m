Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 578002A0C7F
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 18:30:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727290AbgJ3RaC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 13:30:02 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:58274 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726904AbgJ3RaB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 13:30:01 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 09UHTqWK053560;
        Fri, 30 Oct 2020 12:29:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1604078992;
        bh=Zmb+rJO51gJljmJKDg9ATgo4QTdbYtTtaS+87OtvIWU=;
        h=From:To:CC:Subject:Date;
        b=qlOlKoZ0/c3sDrehhJToCM0xM0Oe11Yy+2HoumRWDNSpyL/xfEH0lJEWWYQP1B0La
         vDjaCU6SEBe8pLJ/D9Z0FJwkCcWmKSdYfr1CNZEVCDEAQTsj5hZdPIEzor/HLx6gKc
         NRZcyLsnWo5gLQhk7BYyXpx1iATdyvtu/5O6toRg=
Received: from DLEE108.ent.ti.com (dlee108.ent.ti.com [157.170.170.38])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 09UHTqRV056282
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 30 Oct 2020 12:29:52 -0500
Received: from DLEE110.ent.ti.com (157.170.170.21) by DLEE108.ent.ti.com
 (157.170.170.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 30
 Oct 2020 12:29:51 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE110.ent.ti.com
 (157.170.170.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 30 Oct 2020 12:29:51 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 09UHTpNC046294;
        Fri, 30 Oct 2020 12:29:51 -0500
From:   Dan Murphy <dmurphy@ti.com>
To:     <davem@davemloft.net>, <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <robh@kernel.org>
CC:     <devicetree@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Dan Murphy <dmurphy@ti.com>
Subject: [PATCH net-next v3 0/4] DP83TD510 Single Pair 10Mbps Ethernet PHY
Date:   Fri, 30 Oct 2020 12:29:46 -0500
Message-ID: <20201030172950.12767-1-dmurphy@ti.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello

The DP83TD510 is an Ethernet PHY supporting single pair of twisted wires. The
PHY is capable of 10Mbps communication over long distances and exceeds the
IEEE 802.3cg 10BASE-T1L single-pair Ethernet specification.  The PHY supports
various voltage level signalling and can be forced to support a specific
voltage or allowed to perfrom auto negotiation on the voltage level. The
default for the PHY is auto negotiation but if the PHY is forced to a specific
voltage then the LP must also support the same voltage.

Add the 10BASE-T1L linkmodes for ethtool to properly advertise the PHY's
capability.

Dan

Dan Murphy (4):
  ethtool: Add 10base-T1L link mode entries
  dt-bindings: net: Add Rx/Tx output configuration for 10base T1L
  dt-bindings: dp83td510: Add binding for DP83TD510 Ethernet PHY
  net: phy: dp83td510: Add support for the DP83TD510 Ethernet PHY

 .../devicetree/bindings/net/ethernet-phy.yaml |   5 +
 .../devicetree/bindings/net/ti,dp83td510.yaml |  62 ++
 drivers/net/phy/Kconfig                       |   6 +
 drivers/net/phy/Makefile                      |   1 +
 drivers/net/phy/dp83td510.c                   | 681 ++++++++++++++++++
 drivers/net/phy/phy-core.c                    |   4 +-
 include/uapi/linux/ethtool.h                  |   2 +
 net/ethtool/common.c                          |   2 +
 net/ethtool/linkmodes.c                       |   2 +
 9 files changed, 764 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/net/ti,dp83td510.yaml
 create mode 100644 drivers/net/phy/dp83td510.c

-- 
2.28.0.585.ge1cfff676549

