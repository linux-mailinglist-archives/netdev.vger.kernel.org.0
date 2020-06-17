Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C85E41FD442
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 20:20:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbgFQSUf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 14:20:35 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:37718 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726926AbgFQSUf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 14:20:35 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 05HIKQHL058158;
        Wed, 17 Jun 2020 13:20:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1592418026;
        bh=gjguookD1gAKAn+pIRuOJSIn2idst37qv+P6Ar7on0M=;
        h=From:To:CC:Subject:Date;
        b=taeEBQ9XJPXyFyan3fkd7jaBExqLuhNXlfQTn3559Hf2wXDnwoTKS7o5ZPO3lhrCI
         /vkNRItvQAyvQ2uq4UfMF2/0I3mWcgILl4BCTL6sJaWVlhFT9qZpZuqwB2hI8zf6PO
         o5PhDiJobhoslmgBgXpOftWZMhvg5HNUsV1HhvjE=
Received: from DLEE113.ent.ti.com (dlee113.ent.ti.com [157.170.170.24])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 05HIKQY7127043;
        Wed, 17 Jun 2020 13:20:26 -0500
Received: from DLEE111.ent.ti.com (157.170.170.22) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 17
 Jun 2020 13:20:25 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE111.ent.ti.com
 (157.170.170.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 17 Jun 2020 13:20:26 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 05HIKPlW129353;
        Wed, 17 Jun 2020 13:20:25 -0500
From:   Dan Murphy <dmurphy@ti.com>
To:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>, <robh@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Dan Murphy <dmurphy@ti.com>
Subject: [PATCH net-next v7 0/6] RGMII Internal delay common property
Date:   Wed, 17 Jun 2020 13:20:13 -0500
Message-ID: <20200617182019.6790-1-dmurphy@ti.com>
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
delay to return and if the value is defined then the value in the firmware is
returned.

This series contains examples of both a configurable delay and a fixed delay.

Dan Murphy (6):
  dt-bindings: net: Add tx and rx internal delays
  net: phy: Add a helper to return the index for of the internal delay
  dt-bindings: net: Add RGMII internal delay for DP83869
  net: dp83869: Add RGMII internal delay configuration
  dt-bindings: net: dp83822: Add TI dp83822 phy
  net: phy: DP83822: Add ability to advertise Fiber connection

 .../devicetree/bindings/net/ethernet-phy.yaml |  11 ++
 .../devicetree/bindings/net/ti,dp83822.yaml   |  51 +++++++++
 .../devicetree/bindings/net/ti,dp83869.yaml   |  16 ++-
 drivers/net/phy/dp83822.c                     | 108 ++++++++++++++++--
 drivers/net/phy/dp83869.c                     |  53 ++++++++-
 drivers/net/phy/phy_device.c                  |  68 +++++++++++
 include/linux/phy.h                           |   4 +
 7 files changed, 299 insertions(+), 12 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/ti,dp83822.yaml

-- 
2.26.2

