Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AF3F294128
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 19:12:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395240AbgJTRMe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 13:12:34 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:56214 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390192AbgJTRMe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 13:12:34 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 09KHCSWk128324;
        Tue, 20 Oct 2020 12:12:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1603213948;
        bh=8YIAG/JStqk5FZkFuOHiQFT++/VhUn6Exl7HRTRoABs=;
        h=From:To:CC:Subject:Date;
        b=wY+y/cyNnhXUnTgtgK2ZaKV8s9K11CGFAWSw1SUYUl5igk8bl0oc9/Gl/aU3WTwCg
         0okoJMgZkLS5nXHfNfrq939LULio5DNoEIDSwzo0h2w4nmyb/cjsU9d9P1isKEcrEN
         iwv1l5Qccx+8vwF+SNQAG/dZIAYS1yAmG5N0uBkA=
Received: from DLEE114.ent.ti.com (dlee114.ent.ti.com [157.170.170.25])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 09KHCSiN098909
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 20 Oct 2020 12:12:28 -0500
Received: from DLEE101.ent.ti.com (157.170.170.31) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Tue, 20
 Oct 2020 12:12:28 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE101.ent.ti.com
 (157.170.170.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Tue, 20 Oct 2020 12:12:28 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 09KHCSmb048165;
        Tue, 20 Oct 2020 12:12:28 -0500
From:   Dan Murphy <dmurphy@ti.com>
To:     <davem@davemloft.net>, <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Dan Murphy <dmurphy@ti.com>
Subject: [PATCH net-next v2 0/3] DP83TD510 Single Pair 10Mbps Ethernet PHY
Date:   Tue, 20 Oct 2020 12:12:18 -0500
Message-ID: <20201020171221.730-1-dmurphy@ti.com>
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

Dan Murphy (3):
  ethtool: Add 10base-T1L link mode entries
  dt-bindings: dp83td510: Add binding for DP83TD510 Ethernet PHY
  net: phy: dp83td510: Add support for the DP83TD510 Ethernet PHY

 .../devicetree/bindings/net/ti,dp83td510.yaml |  72 +++
 drivers/net/phy/Kconfig                       |   6 +
 drivers/net/phy/Makefile                      |   1 +
 drivers/net/phy/dp83td510.c                   | 600 ++++++++++++++++++
 drivers/net/phy/phy-core.c                    |   4 +-
 include/uapi/linux/ethtool.h                  |   2 +
 net/ethtool/common.c                          |   2 +
 net/ethtool/linkmodes.c                       |   2 +
 8 files changed, 688 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/net/ti,dp83td510.yaml
 create mode 100644 drivers/net/phy/dp83td510.c

-- 
2.28.0.585.ge1cfff676549

