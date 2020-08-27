Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C41B125463B
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 15:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728053AbgH0Npx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 09:45:53 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:59052 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726903AbgH0Npl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 09:45:41 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 07RDjANF022101;
        Thu, 27 Aug 2020 08:45:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1598535910;
        bh=5VjrUweBUoddKIWA5DoHoSgzJyOyTNTEfVyDIdJ2VIk=;
        h=From:To:CC:Subject:Date;
        b=sXob2MhH3tufPGq4B+lDTCnp2UgNk+1HVfyoLTkgNs+gUyAob0HeJNHhNWHH5fvyg
         kTXIKIa6R1sGK49mQgYhaLKFwav4GJSl6AlTAvrmp5JiEshZZJgGkkENnvGYqb8Vpq
         cHMXVlwQKhQyw8/TeTmhbu0vLn+zlWKwslvIL/6c=
Received: from DLEE113.ent.ti.com (dlee113.ent.ti.com [157.170.170.24])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 07RDjAdc108223
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 27 Aug 2020 08:45:10 -0500
Received: from DLEE101.ent.ti.com (157.170.170.31) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 27
 Aug 2020 08:45:10 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE101.ent.ti.com
 (157.170.170.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 27 Aug 2020 08:45:10 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 07RDj9xn058230;
        Thu, 27 Aug 2020 08:45:09 -0500
From:   Dan Murphy <dmurphy@ti.com>
To:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>, <robh@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Dan Murphy <dmurphy@ti.com>
Subject: [PATCH net-next v3 0/2] Enable Fiber on DP83822 PHY
Date:   Thu, 27 Aug 2020 08:45:07 -0500
Message-ID: <20200827134509.23854-1-dmurphy@ti.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello

The DP83822 Ethernet PHY has the ability to connect via a Fiber port.  The
derivative PHYs DP83825 and DP83826 do not have this ability. In fiber mode
the DP83822 disables auto negotiation and has a fixed 100Mbps speed with
support for full or half duplex modes.

A devicetree binding was added to set the signal polarity for the fiber
connection.  This property is only applicable if the FX_EN strap is set in
hardware other wise the signal loss detection is disabled on the PHY.

If the FX_EN is not strapped the device can be configured to run in fiber mode
via the device tree. All be it the PHY will not perform signal loss detection.

v2 review from a long time ago can be found here - https://lore.kernel.org/patchwork/patch/1270958/

Dan

Dan Murphy (2):
  dt-bindings: net: dp83822: Add TI dp83822 phy
  net: phy: DP83822: Add ability to advertise Fiber connection

 .../devicetree/bindings/net/ti,dp83822.yaml   |  80 +++++++
 drivers/net/phy/dp83822.c                     | 225 +++++++++++++++++-
 2 files changed, 298 insertions(+), 7 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/ti,dp83822.yaml

-- 
2.28.0

