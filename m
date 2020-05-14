Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 049E71D387A
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 19:41:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726119AbgENRkh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 13:40:37 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:39590 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbgENRkh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 13:40:37 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 04EHeUgH072300;
        Thu, 14 May 2020 12:40:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1589478030;
        bh=T0S0PrMDnscedGj/aLkJ2AVh5rDA+PnvysBuppihou0=;
        h=From:To:CC:Subject:Date;
        b=nAH7WcTe+jm+ba5M7brbLLj/nWMada1X5c9r66KPNC68YQ0dDtH0iJvcoJtUpdPxr
         hBS4UjriMyT5B04Qc6TioicLZWL4seaAB0k+vl3Y12FK4e/f3scKL+WYe5wC59VGKK
         kAw/uFKlgWgXcztllzoUt/iPjvC6D+vkFja6Kd/s=
Received: from DFLE115.ent.ti.com (dfle115.ent.ti.com [10.64.6.36])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04EHeUqL092853;
        Thu, 14 May 2020 12:40:30 -0500
Received: from DFLE101.ent.ti.com (10.64.6.22) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 14
 May 2020 12:40:29 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE101.ent.ti.com
 (10.64.6.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 14 May 2020 12:40:30 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04EHeTb1127102;
        Thu, 14 May 2020 12:40:30 -0500
From:   Dan Murphy <dmurphy@ti.com>
To:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>
CC:     <robh@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Dan Murphy <dmurphy@ti.com>
Subject: [PATCH net-next 0/2] DP83822 Fiber enablement
Date:   Thu, 14 May 2020 12:30:53 -0500
Message-ID: <20200514173055.15013-1-dmurphy@ti.com>
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

The DP83822 Ethernet PHY has the ability to connect via a Fiber port.  The
DP83825 or DP83826 do not have this ability.  In order to keep the same
driver the DP83822 and the 825/826 phy_driver call backs need to be changed
so that the DP83822 has it's own call back for config_init and adds a probe
call back.

A devicetree binding was added to set the signal polarity for the fiber
connection.  This property is only applicable in fiber mode and is optional
in fiber mode.

Dan

Dan Murphy (2):
  dt-bindings: net: dp83822: Add TI dp83822 phy
  net: phy: DP83822: Add ability to advertise Fiber connection

 .../devicetree/bindings/net/ti,dp83822.yaml   |  49 ++++++
 drivers/net/phy/dp83822.c                     | 140 +++++++++++++++++-
 2 files changed, 181 insertions(+), 8 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/ti,dp83822.yaml

-- 
2.26.2

