Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3AEC454375
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 10:18:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234932AbhKQJUw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 04:20:52 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:1237 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230077AbhKQJUv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 04:20:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1637140673; x=1668676673;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=J+I72B2PR5lV6ZvwttahWxWaIqt+EPaSWT8Cp4zOtLU=;
  b=yZrVDrTPggTMt4EBZAFOLuPZtETPnOYLg4CUE0BXe16kcoYyg9TAiEDZ
   dQ+dcqgsDWp9YSbUoXAe78tp/910eXzfMd26YALqCfi4yQsgbfLIB8LsL
   eUr9ZCSO1Gmv241W3CIHLgUe/Ry+T/24sD5Som1a2PP/+uVD1Yk4DO5mT
   LI8GOcp0tE1MwjOI8BymvR6/slz7C07lBsl3Lbet0zAMP0xfI4g5ecUm6
   SG2XGaMnop7ARyOaqlUNP0511FJ462Etzf51r8uKXsmeO0/2P/Winf8H5
   tGJwUXPdqXsdkzcwbh6zsLeWxlhhmgGSn9eoE3/ixnmlsQnvu2IURZHuI
   g==;
IronPort-SDR: VGGArQUpKP/6NM/TSsBtQ5KOxgidw04xrL8pfnnJ1bMVby9L7F6ljq8jDuNPBs23oOhUdzLmrj
 BKRb2Home8mf1ynNQEde9HHXYGSkhwoZZ83T5wCrpGfqp+hr9ZeR/KMGOUFmUgmJi+Kqn/0Pmi
 mRWiqjYzrYoAvY7lqVyj+FdBfUZWlgfjjkTG8Vlsdn3JXiaNNNp69q4/fiqLXZiU7FH9wGVjpl
 tUEAni8Fo/S5b6DY50lI53bQMRLLvoUCGv6lg1rdbnwEREN5hv4RijwlenLKyvncXXm1Sw2lv2
 wmhNo+1MyG9vlzxI6ihuxr5h
X-IronPort-AV: E=Sophos;i="5.87,241,1631602800"; 
   d="scan'208";a="76705735"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Nov 2021 02:17:52 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Wed, 17 Nov 2021 02:17:51 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Wed, 17 Nov 2021 02:17:50 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <p.zabel@pengutronix.de>, <linux@armlinux.org.uk>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 0/5] net: lan966x: Add lan966x switch driver
Date:   Wed, 17 Nov 2021 10:18:53 +0100
Message-ID: <20211117091858.1971414-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series add support for Microchip lan966x driver

The lan966x switch is a multi-port Gigabit AVB/TSN Ethernet Switch with
two integrated 10/100/1000Base-T PHYs. In addition to the integrated PHYs,
it supports up to 2RGMII/RMII, up to 3BASE-X/SERDES/2.5GBASE-X and up to
2 Quad-SGMII/Quad-USGMII interfaces.

Intially it adds support only for the ports to behave as simple
NIC cards. In the future patches it would be extended with other
functionality like Switchdev, PTP, Frame DMA, VCAP, etc.

Horatiu Vultur (5):
  dt-bindings: net: lan966x: Add lan966x-switch bindings
  net: lan966x: add the basic lan966x driver
  net: lan966x: add port module support
  net: lan966x: add mactable support
  net: lan966x: add ethtool configuration and statistics

 .../net/microchip,lan966x-switch.yaml         | 149 +++
 drivers/net/ethernet/microchip/Kconfig        |   1 +
 drivers/net/ethernet/microchip/Makefile       |   1 +
 .../net/ethernet/microchip/lan966x/Kconfig    |   7 +
 .../net/ethernet/microchip/lan966x/Makefile   |   9 +
 .../microchip/lan966x/lan966x_ethtool.c       | 664 ++++++++++++
 .../ethernet/microchip/lan966x/lan966x_ifh.h  | 173 ++++
 .../ethernet/microchip/lan966x/lan966x_mac.c  |  95 ++
 .../ethernet/microchip/lan966x/lan966x_main.c | 950 ++++++++++++++++++
 .../ethernet/microchip/lan966x/lan966x_main.h | 205 ++++
 .../microchip/lan966x/lan966x_phylink.c       | 116 +++
 .../ethernet/microchip/lan966x/lan966x_port.c | 472 +++++++++
 .../ethernet/microchip/lan966x/lan966x_regs.h | 730 ++++++++++++++
 13 files changed, 3572 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml
 create mode 100644 drivers/net/ethernet/microchip/lan966x/Kconfig
 create mode 100644 drivers/net/ethernet/microchip/lan966x/Makefile
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_ethtool.c
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_ifh.h
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_mac.c
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_main.c
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_main.h
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_phylink.c
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_port.c
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_regs.h

-- 
2.33.0

