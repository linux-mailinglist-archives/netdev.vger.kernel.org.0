Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF1F32CD396
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 11:32:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388875AbgLCKbg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 05:31:36 -0500
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:9744 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388276AbgLCKbf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 05:31:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1606991494; x=1638527494;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=VRZtzYzIm8sP/EKvVuEBEAUAPyYPpdrvQLMNkzM7rx8=;
  b=t2oI6MljHuGIVYkt7fKjLmmWJ9b/JWE3AfJeEMX4kb2WSI/kaqI6V9yH
   qO3d+vFV1CS436mnNgUDmkAOxMCtQ85tuJzxq1W+0ER3im0rLY0i5GczP
   4PtfnuaAgD7HKmbGkepqtIoNYgZbr/lDFAzy7g/Uc5F9E9DNfACDCJT+c
   bOnceP4a5658iEuPDjGHJGVN8m+tqs0HwsQGYt1sNJ5Gub2yOV3c4vPZ0
   joPCsrKJtG1OAcXJdsH4AejSXCkZUcPrvAypXJt3sqIANbj2sSZwPIovx
   TxZhdRUqth1nGSWTnFLcmOiFMzRAWU98gj74kZ7pSYIe/ZupnUFW1KpF2
   Q==;
IronPort-SDR: SD3wbxuJfUjxEjG3A1FLrLYMh2wNnOZVo6nzOC91aFfXpty6J+0PjthV7510FlgZwQCtJNTKgK
 IVXZ4mzDX6AUzc2yE+2+LJnbuLgrzQGh67xGdEonXCUjYyGso15w2So6vi2qDozzotFBMRx96N
 g2L1K6IbgAsAVlGkC5fTwitZXdhUEIfbx0VPBvniLJjomohhRXE79wxvtEstxYjMXM/26k3MEK
 DHhpde1h9liY81xXqlF/dJEDvEV/6KLTgCfl14b26e2vmmR8aeMJjMHPy5Q8213i3FbwhbnS0t
 VqI=
X-IronPort-AV: E=Sophos;i="5.78,389,1599548400"; 
   d="scan'208";a="105989315"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 03 Dec 2020 03:30:28 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 3 Dec 2020 03:30:28 -0700
Received: from mchp-dev-shegelun.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Thu, 3 Dec 2020 03:30:26 -0700
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>
CC:     Steen Hegelund <steen.hegelund@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip UNG Driver List <UNGLinuxDriver@microchip.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v8 0/4] Adding the Sparx5 Serdes driver
Date:   Thu, 3 Dec 2020 11:30:11 +0100
Message-ID: <20201203103015.3735373-1-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding the Sparx5 Serdes driver

This series of patches provides the serdes driver for the Microchip Sparx5
ethernet switch.

The serdes driver supports the 10G and 25G serdes instances available in the
Sparx5.

The Sparx5 serdes support several interface modes with several speeds and also
allows the client to change the mode and the speed according to changing in the
environment such as changing cables from DAC to fiber.

The serdes driver is to be used by the Sparx5 switchdev driver that
will follow in subsequent series.

History:
--------
v7 -> v8:
    Provide the IO targets as offsets from the start of the IO range
    Initialise resource index

v6 -> v7:
    This series changes the way the IO targets are provided to the driver.
    Now only one IO range is available in the DT, and the driver has a table
    to map its targets (as their order is still not sequential), thus reducing
    the DT needed information and binding requirements.
    The register access macros have been converted to functions.

    - Bindings:
      - reg prop: minItems set to 1
      - reg-names prop: removed
    - Driver
      - Use one IO range and map targets via this.
      - Change register access macros to use functions.
      - Provided a new header files with reg access functions.
    - Device tree
      - Provide only one IO range

v5 -> v6:
     Series error: This had the same content as v5

v4 -> v5:
    - Bindings:
      - Removed .yaml from compatible string
      - reg prop: removed description and added minItems
      - reg-names prop: removed description and added const name list and minItems
      - #phy-cells prop: removed description and added maxItems
    - Configuration interface
      - Removed include of linux/phy.h
      - Added include of linux/types.h
    - Driver
       - Added include of linux/phy.h

v3 -> v4:
    - Add a reg-names item to the binding description
    - Add a clocks item to the binding description
    - Removed the clock parameter from the configuration interface
    - Use the clock dt node to get the coreclock, and using that when 
      doing the actual serdes configuration
    - Added a clocks entry with a system clock reference to the serdes node in
      the device tree

v2 -> v3:
    - Sorted the Kconfig sourced folders
    - Sorted the Makefile included folders
    - Changed the configuration interface documentation to use kernel style

v1 -> v2: Fixed kernel test robot warnings
    - Made these structures static:
      - media_presets_25g
      - mode_presets_25g
      - media_presets_10g
      - mode_presets_10g
    - Removed these duplicate initializations:
      - sparx5_sd25g28_params.cfg_rx_reserve_15_8
      - sparx5_sd25g28_params.cfg_pi_en
      - sparx5_sd25g28_params.cfg_cdrck_en
      - sparx5_sd10g28_params.cfg_cdrck_en

Lars Povlsen (2):
  dt-bindings: phy: Add sparx5-serdes bindings
  arm64: dts: sparx5: Add Sparx5 serdes driver node

Steen Hegelund (2):
  phy: Add ethernet serdes configuration option
  phy: Add Sparx5 ethernet serdes PHY driver

 .../bindings/phy/microchip,sparx5-serdes.yaml |  100 +
 arch/arm64/boot/dts/microchip/sparx5.dtsi     |    8 +
 drivers/phy/Kconfig                           |    3 +-
 drivers/phy/Makefile                          |    1 +
 drivers/phy/microchip/Kconfig                 |   12 +
 drivers/phy/microchip/Makefile                |    6 +
 drivers/phy/microchip/sparx5_serdes.c         | 2434 +++++++++++++++
 drivers/phy/microchip/sparx5_serdes.h         |  129 +
 drivers/phy/microchip/sparx5_serdes_regs.h    | 2695 +++++++++++++++++
 include/linux/phy/phy-ethernet-serdes.h       |   30 +
 include/linux/phy/phy.h                       |    4 +
 11 files changed, 5421 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/phy/microchip,sparx5-serdes.yaml
 create mode 100644 drivers/phy/microchip/Kconfig
 create mode 100644 drivers/phy/microchip/Makefile
 create mode 100644 drivers/phy/microchip/sparx5_serdes.c
 create mode 100644 drivers/phy/microchip/sparx5_serdes.h
 create mode 100644 drivers/phy/microchip/sparx5_serdes_regs.h
 create mode 100644 include/linux/phy/phy-ethernet-serdes.h

-- 
2.29.2

