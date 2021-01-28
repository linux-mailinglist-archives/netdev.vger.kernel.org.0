Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F5F7306DCD
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 07:48:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231330AbhA1Gp0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 01:45:26 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:29386 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231163AbhA1GpX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 01:45:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1611816323; x=1643352323;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=wbquCW1Jq03k67nXuZYtUVGGl7OP8Xn59g/GHZwYmIo=;
  b=mT21FZ5/nRR2HbiuoZAFhWF1T0MCLD+j3w38fjQjLGdRvQouBjKYyWbq
   g94lScJG9Tssuq4nrywHYQnJpEv6OVLnCasFRqIVF1B02V1PgGpwKWq3S
   O7alcJ/BGpTGSd5MVSc5K4cUym0QozkMFMubUDis115NO2QObGm10F7l9
   by7X0iYrsaywrgVkx6KEUYwWxszm2KX6SEV1hzhWfTQJNoLE9uMiGhr1q
   KgRoKwRBf//5lLX2a7x2HoUzo3Mu5I7dZqA6NGYk1HL1Xs5kTq1kFLvS6
   FEumXK1sg2zOviPGk1++jtRNMxuEA2dqphJFoSMd66BjA6hnqidr1MdnY
   w==;
IronPort-SDR: 0oUQu2ZK4/CNGl4u1Wd0ix9ZpibLAAeTYfWy1DplIhAk4Z3MafWlYLLzpNiGTtdvdYzT1RDBKG
 xvJTeMxPIMgoPbcd+QJb51YIpx4njhNxYtY97Bu13jLsCgqkDz/X0PRfCDLdtdHmMzu4WyTMXC
 LFab82ZhDmooemeSlFWYqJKrYJ1+6pWnFDbHbyE8/dNdUMnHdEG0JHxoPurCHif+nzDumIwBf4
 nfdfHDv+U5swzRw86lcWJKJHcW/kpePB193PHPzke9CoMp1I1ZPAlHxtQaW1lOSt1JdCvyN+Yx
 0eo=
X-IronPort-AV: E=Sophos;i="5.79,381,1602572400"; 
   d="scan'208";a="104520472"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Jan 2021 23:44:07 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 27 Jan 2021 23:44:06 -0700
Received: from CHE-LT-I21427U.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Wed, 27 Jan 2021 23:44:01 -0700
From:   Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
To:     <andrew@lunn.ch>, <olteanv@gmail.com>, <netdev@vger.kernel.org>,
        <robh+dt@kernel.org>
CC:     <kuba@kernel.org>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <davem@davemloft.net>,
        <UNGLinuxDriver@microchip.com>, <Woojung.Huh@microchip.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>
Subject: [PATCH net-next 0/8] net: dsa: microchip: DSA driver support for LAN937x switch
Date:   Thu, 28 Jan 2021 12:11:04 +0530
Message-ID: <20210128064112.372883-1-prasanna.vengateshan@microchip.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

LAN937x is a Multi-Port 100BASE-T1 Ethernet Physical Layer switch 
compliant with the IEEE 802.3bw-2015 specification. The device 
provides 100 Mbit/s transmit and receive capability over a single
Unshielded Twisted Pair (UTP) cable. LAN937x is successive revision
of KSZ series switch. This series of patches provide the DSA driver 
support for Microchip LAN937X switch and it configures through 
SPI interface.

This driver shares some of the functions from KSZ common
layer.

The LAN937x switch series family consists of following SKUs:
LAN9370:
  - 4 T1 Phys
  - 1 RGMII port
LAN9371:
  - 3 T1 Phys & 1 TX Phy
  - 2 RGMII ports
LAN9372:
  - 5 T1 Phys & 1 TX Phy
  - 2 RGMII ports
LAN9373:
  - 5 T1 Phys
  - 2 RGMII & 1 SGMII port
LAN9374:
  - 6 T1 Phys
  - 2 RGMII ports

More support will be added at a later stage.

Prasanna Vengateshan (8):
  dt-bindings: net: dsa: dt bindings for microchip lan937x
  net: dsa: microchip: add tag handling for Microchip LAN937x
  net: dsa: microchip: add DSA support for microchip lan937x
  net: dsa: microchip: add support for phylink management
  net: dsa: microchip: add support for ethtool port counters
  net: dsa: microchip: add support for port mirror operations
  net: dsa: microchip: add support for fdb and mdb management
  net: dsa: microchip: add support for vlan operations

 .../bindings/net/dsa/microchip,lan937x.yaml   |  115 ++
 MAINTAINERS                                   |    1 +
 drivers/net/dsa/microchip/Kconfig             |   12 +
 drivers/net/dsa/microchip/Makefile            |    5 +
 drivers/net/dsa/microchip/ksz_common.h        |    1 +
 drivers/net/dsa/microchip/lan937x_dev.c       |  895 ++++++++++++++
 drivers/net/dsa/microchip/lan937x_dev.h       |   79 ++
 drivers/net/dsa/microchip/lan937x_main.c      | 1037 +++++++++++++++++
 drivers/net/dsa/microchip/lan937x_reg.h       |  955 +++++++++++++++
 drivers/net/dsa/microchip/lan937x_spi.c       |  104 ++
 include/net/dsa.h                             |    2 +
 net/dsa/Kconfig                               |    4 +-
 net/dsa/tag_ksz.c                             |   74 ++
 13 files changed, 3282 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml
 create mode 100644 drivers/net/dsa/microchip/lan937x_dev.c
 create mode 100644 drivers/net/dsa/microchip/lan937x_dev.h
 create mode 100644 drivers/net/dsa/microchip/lan937x_main.c
 create mode 100644 drivers/net/dsa/microchip/lan937x_reg.h
 create mode 100644 drivers/net/dsa/microchip/lan937x_spi.c

-- 
2.25.1

