Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A2E52B6FD7
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 21:17:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731513AbgKQUQL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 15:16:11 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:51068 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726851AbgKQUQK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 15:16:10 -0500
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 0AHKG20J065922;
        Tue, 17 Nov 2020 14:16:02 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1605644162;
        bh=gGrYoD9iSXXe6ylPSSoWK2G1ukRk1mCo7mwklCw0+OU=;
        h=From:To:CC:Subject:Date;
        b=sXxBbKP2rSUZ5xxRQayjIJ6QcBX5Me/Rx1oNZC743VtvbCOVPofmBP+67e1b+ahlA
         99hn2T2q9vqAjsC99Y5UCBbcMkz2/uNp/+eB0OVcApDoXZRR1cKajC8Zuv2n/CHvlj
         0uYVkxi3MGaDcCyZsTCZi0Xa1btJUu/q1SJPfZ0U=
Received: from DLEE115.ent.ti.com (dlee115.ent.ti.com [157.170.170.26])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 0AHKG2ob015633
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 17 Nov 2020 14:16:02 -0600
Received: from DLEE106.ent.ti.com (157.170.170.36) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Tue, 17
 Nov 2020 14:16:01 -0600
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE106.ent.ti.com
 (157.170.170.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Tue, 17 Nov 2020 14:16:01 -0600
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 0AHKG1JI052496;
        Tue, 17 Nov 2020 14:16:01 -0600
From:   Dan Murphy <dmurphy@ti.com>
To:     <davem@davemloft.net>, <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <robh@kernel.org>, <ciorneiioana@gmail.com>
CC:     <devicetree@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Dan Murphy <dmurphy@ti.com>
Subject: [PATCH net-next v4 0/4] DP83TD510 Single Pair 10Mbps Ethernet PHY
Date:   Tue, 17 Nov 2020 14:15:51 -0600
Message-ID: <20201117201555.26723-1-dmurphy@ti.com>
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

 .../devicetree/bindings/net/ethernet-phy.yaml |   6 +
 .../devicetree/bindings/net/ti,dp83td510.yaml |  64 +++
 drivers/net/phy/Kconfig                       |   6 +
 drivers/net/phy/Makefile                      |   1 +
 drivers/net/phy/dp83td510.c                   | 505 ++++++++++++++++++
 drivers/net/phy/phy-core.c                    |   4 +-
 include/uapi/linux/ethtool.h                  |   2 +
 net/ethtool/common.c                          |   2 +
 net/ethtool/linkmodes.c                       |   2 +
 9 files changed, 591 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/net/ti,dp83td510.yaml
 create mode 100644 drivers/net/phy/dp83td510.c

-- 
2.29.2

