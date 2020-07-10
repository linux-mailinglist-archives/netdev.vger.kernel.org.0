Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7F1021B8D8
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 16:38:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728196AbgGJOht (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 10:37:49 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:47192 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726725AbgGJOht (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 10:37:49 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 06AEbdOo090306;
        Fri, 10 Jul 2020 09:37:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1594391859;
        bh=s/Z8V9mGX3gOoutpqf8o4ND8qHAKcSCacNptqGjaKUI=;
        h=From:To:CC:Subject:Date;
        b=WDvzP9jYBZUZkzu325ftwGkluhcMqAEvy+t5AUGlcTXz8nf6IwSn1k1iWbVe3McDK
         xhceuPIyQvRQo+L3ZAvZul8Zfhr24ZyIEUq+cDAeWEedokiaQAIgiEcs7u16oLp0Ux
         t8ecclIzVMmPtPYSvwHdFQPjXDayhMWQDbYiUiFc=
Received: from DLEE112.ent.ti.com (dlee112.ent.ti.com [157.170.170.23])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 06AEbdYm118635
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 10 Jul 2020 09:37:39 -0500
Received: from DLEE108.ent.ti.com (157.170.170.38) by DLEE112.ent.ti.com
 (157.170.170.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 10
 Jul 2020 09:37:39 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE108.ent.ti.com
 (157.170.170.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 10 Jul 2020 09:37:39 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 06AEbc0S083159;
        Fri, 10 Jul 2020 09:37:39 -0500
From:   Dan Murphy <dmurphy@ti.com>
To:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>, <robh@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Dan Murphy <dmurphy@ti.com>
Subject: [PATCH net-next v2 0/2] DP83822 Fiber enablement
Date:   Fri, 10 Jul 2020 09:37:31 -0500
Message-ID: <20200710143733.30751-1-dmurphy@ti.com>
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
via the device tree. All be it the PHY will not perfomr signal loss detection.

Dan

Dan Murphy (2):
  dt-bindings: net: dp83822: Add TI dp83822 phy
  net: phy: DP83822: Add ability to advertise Fiber connection

 .../devicetree/bindings/net/ti,dp83822.yaml   |  80 +++++++++
 drivers/net/phy/dp83822.c                     | 161 ++++++++++++++++++
 2 files changed, 241 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/ti,dp83822.yaml

-- 
2.27.0

