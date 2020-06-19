Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE048201533
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 18:22:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405581AbgFSQTY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 12:19:24 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:49442 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390777AbgFSQSY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 12:18:24 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 05JGIFpK008140;
        Fri, 19 Jun 2020 11:18:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1592583496;
        bh=qGP6MS6+eG2DFpGVz1IWcoA6j9uBqfJ/c06oHe2JZGk=;
        h=From:To:CC:Subject:Date;
        b=JubHsdyNuL+CBY1m5AuqIfsbDEcOLDsJKcXUkqoCF7t29DDyKSK4OCt8nLu8/evaB
         iHdv5L5fVJWXM3c/NDNWSyK/mgdOhSdcofw1idFBiSQdUJV6KiqawOVTHjglM5XhHN
         3MaHalTAjHjyCi6KExoKVBFo0N/BeWbn7CLek6ss=
Received: from DLEE109.ent.ti.com (dlee109.ent.ti.com [157.170.170.41])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 05JGIFI1026425
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 19 Jun 2020 11:18:15 -0500
Received: from DLEE104.ent.ti.com (157.170.170.34) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 19
 Jun 2020 11:18:15 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE104.ent.ti.com
 (157.170.170.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 19 Jun 2020 11:18:15 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 05JGIF2Y034554;
        Fri, 19 Jun 2020 11:18:15 -0500
From:   Dan Murphy <dmurphy@ti.com>
To:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>, <robh@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Dan Murphy <dmurphy@ti.com>
Subject: [PATCH net-next v9 0/5] RGMII Internal delay common property
Date:   Fri, 19 Jun 2020 11:18:08 -0500
Message-ID: <20200619161813.2716-1-dmurphy@ti.com>
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

 .../devicetree/bindings/net/ethernet-phy.yaml |  13 +++
 .../devicetree/bindings/net/ti,dp83869.yaml   |  16 ++-
 drivers/net/phy/dp83822.c                     |  79 ++++++++++++--
 drivers/net/phy/dp83869.c                     |  53 +++++++++-
 drivers/net/phy/phy_device.c                  | 100 ++++++++++++++++++
 include/linux/phy.h                           |   4 +
 6 files changed, 251 insertions(+), 14 deletions(-)

-- 
2.26.2

