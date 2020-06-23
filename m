Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A149D2053C7
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 15:48:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732734AbgFWNst (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 09:48:49 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:50796 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732629AbgFWNst (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 09:48:49 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 05NDmg0A007402;
        Tue, 23 Jun 2020 08:48:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1592920122;
        bh=t3UKzHX3lCyR4eH6u/dGz7RzYpxhbfYkVViEKjM2usE=;
        h=From:To:CC:Subject:Date;
        b=wQdWuZFWRhSIojO1+GIh2PRHLwrOoN6rjBM+TgYLxNfZC1YmNfAW1kdpS4O/HJexY
         5X1HbehCSxU6tq0gPemLpGYqSwz7JJ24/JPTh9GZUmCsY+2mw3KwFFypif5pZcLZrT
         dDZE2SqVmCjL3dGq4yv+rsNIsR3N0HaoTovBb0bw=
Received: from DLEE115.ent.ti.com (dlee115.ent.ti.com [157.170.170.26])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 05NDmg8N003739
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 23 Jun 2020 08:48:42 -0500
Received: from DLEE109.ent.ti.com (157.170.170.41) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Tue, 23
 Jun 2020 08:48:42 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Tue, 23 Jun 2020 08:48:42 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 05NDmgVv011585;
        Tue, 23 Jun 2020 08:48:42 -0500
From:   Dan Murphy <dmurphy@ti.com>
To:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>, <robh@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Dan Murphy <dmurphy@ti.com>
Subject: [PATCH net-next v10 0/5] RGMII Internal delay common property
Date:   Tue, 23 Jun 2020 08:48:31 -0500
Message-ID: <20200623134836.21981-1-dmurphy@ti.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello

The RGMII internal delay is a common setting found in most RGMII capable PHY
devices.  It was found that many vendor specific device tree properties exist
to do the same function. This creates a common property to be used for PHY's
that have internal delays for the Rx and Tx paths.

If the internal delay is tunable then the caller needs to pass the internal
delay array and the return will be the index in the array that was found in
the firmware node.

If the internal delay is fixed then the caller only needs to indicate which
delay to return.  There is no need for a fixed delay to add device properties
since the value is not configurable. Per the ethernet-controller.yaml the
interface type indicates that the PHY should provide the delay.

This series contains examples of both a configurable delay and a fixed delay.

Dan Murphy (5):
  dt-bindings: net: Add tx and rx internal delays
  net: phy: Add a helper to return the index for of the internal delay
  dt-bindings: net: Add RGMII internal delay for DP83869
  net: dp83869: Add RGMII internal delay configuration
  net: phy: DP83822: Add setting the fixed internal delay

 .../devicetree/bindings/net/ethernet-phy.yaml |  12 +++
 .../devicetree/bindings/net/ti,dp83869.yaml   |  16 ++-
 drivers/net/phy/dp83822.c                     |  79 ++++++++++++--
 drivers/net/phy/dp83869.c                     |  53 +++++++++-
 drivers/net/phy/phy_device.c                  | 100 ++++++++++++++++++
 include/linux/phy.h                           |   4 +
 6 files changed, 250 insertions(+), 14 deletions(-)

-- 
2.26.2

