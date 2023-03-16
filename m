Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E14B86BC54B
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 05:37:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbjCPEha (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 00:37:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbjCPEhZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 00:37:25 -0400
Received: from ex01.ufhost.com (ex01.ufhost.com [61.152.239.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 273B9AA279;
        Wed, 15 Mar 2023 21:37:22 -0700 (PDT)
Received: from EXMBX165.cuchost.com (unknown [175.102.18.54])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "EXMBX165", Issuer "EXMBX165" (not verified))
        by ex01.ufhost.com (Postfix) with ESMTP id E834624E202;
        Thu, 16 Mar 2023 12:37:15 +0800 (CST)
Received: from EXMBX162.cuchost.com (172.16.6.72) by EXMBX165.cuchost.com
 (172.16.6.75) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Thu, 16 Mar
 2023 12:37:15 +0800
Received: from starfive-sdk.starfivetech.com (171.223.208.138) by
 EXMBX162.cuchost.com (172.16.6.72) with Microsoft SMTP Server (TLS) id
 15.0.1497.42; Thu, 16 Mar 2023 12:37:14 +0800
From:   Samin Guo <samin.guo@starfivetech.com>
To:     <linux-riscv@lists.infradead.org>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>,
        Yanhong Wang <yanhong.wang@starfivetech.com>,
        Samin Guo <samin.guo@starfivetech.com>,
        Tommaso Merciai <tomm.merciai@gmail.com>
Subject: [PATCH v7 0/6] Add Ethernet driver for StarFive JH7110 SoC
Date:   Thu, 16 Mar 2023 12:37:08 +0800
Message-ID: <20230316043714.24279-1-samin.guo@starfivetech.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [171.223.208.138]
X-ClientProxiedBy: EXCAS064.cuchost.com (172.16.6.24) To EXMBX162.cuchost.com
 (172.16.6.72)
X-YovoleRuleAgent: yovoleflag
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds ethernet support for the StarFive JH7110 RISC-V SoC.
The series includes MAC driver. The MAC version is dwmac-5.20 (from
Synopsys DesignWare).
The series has been tested on the VisionFive-2-v1.2A and
VisionFive-2-v1.3B board which equip with JH7110 SoC and works normally.

For more information and support, you can visit RVspace wiki[1].
You can simply review or test the patches at the link [2].
This patchset should be applied after the patchset [3] [4].

[1]: https://wiki.rvspace.org/
[2]: https://github.com/SaminGuo/linux/tree/vf2-6.3rc1-gmac-repost
[3]: https://patchwork.kernel.org/project/linux-riscv/cover/20230311090733.56918-1-hal.feng@starfivetech.com
[4]: https://patchwork.kernel.org/project/linux-riscv/cover/20230315055813.94740-1-william.qiu@starfivetech.com

Changes since v6:
- Sended network patches[patch 1,2,3,4,5,6] and riscv trees patches[patch 7,8] separately (by Jakub Kicinski)


Changes history:
Changes since v5:
- Droped "depends on STMMAC_ETH" and compiled DWMAC_STARFIVE to m by default (by Emil)
- Removed clk_gtx in struct starfive_dwmac due to this pointer is only set, but never read. (by Emil)
- Only setting the plat_dat->fix_mac_speed callback when it is needed (by Emil)
- Moved mdio/phy nodes from SOC .dtsi into board .dtsi (by Andrew)
- Modified the parameters passed by starfive,syscon (by Andrew && Emil)
    <syscon, offset, mask>  ==>  <syscon, offset, shift>
- Optimized the patchs(Fewer patches from 12 to 8)
    1)merged patch-7 into patch-4 (by Rob)
    2)merged patch-9 into patch-5
    2)merged patch-11,12 into patch-10
    3)Adjusted the patchs order
- Fixed the unevaluatedProperties property from true to false (by Rob)
- Replaced contains:enum with items:const for reset-names in snps,dwmac.yaml (by Rob)
- Tested-by: Tommaso Merciai <tomm.merciai@gmail.com>

Changes since v4:
- Supported both visionfive 2 v1.2A and visionfive 2 v1.3B.
- Reworded the maxitems number of resets property in 'snps,dwmac.yaml'.
- Suggested by Emil, dropped the _PLAT/_plat from the config/function/struct/file names.
- Suggested by Emil, added MODULE_DEVICE_TABLE().
- Suggested by Emil, dropped clk_gtxclk and use clk_tx_inv to set the clock frequency.
- Added phy interface mode configuration function.
- Rebased on tag v6.2.

Changes since v3:
- Reworded the maxitems number of resets property in 'snps,dwmac.yaml'
- Removed the unused code in 'dwmac-starfive-plat.c'.
- Reworded the return statement in 'starfive_eth_plat_fix_mac_speed' function.

Changes since v2:
- Renamed the dt-bindings 'starfive,jh71x0-dwmac.yaml' to 'starfive,jh7110-dwmac.yaml'.
- Reworded the commit messages.
- Reworded the example context in the dt-binding 'starfive,jh7110-dwmac.yaml'.
- Removed "starfive,jh7100-dwmac" compatible string and special initialization of jh7100.
- Removed the parts of YT8531,so dropped patch 5 and 6.
- Reworded the maxitems number of resets property in 'snps,dwmac.yaml'.

Changes since v1:
- Recovered the author of the 1st and 3rd patches back to Emil Renner Berthing.
- Added a new patch to update maxitems number of resets property in 'snps,dwmac.yaml'.
- Fixed the check errors reported by "make dt_binding_check".
- Renamed the dt-binding 'starfive,dwmac-plat.yaml' to 'starfive,jh71x0-dwmac.yaml'.
- Updated the example context in the dt-binding 'starfive,jh71x0-dwmac.yaml'.
- Added new dt-binding 'motorcomm,yt8531.yaml' to describe details of phy clock
  delay configuration parameters.
- Added more comments for PHY driver setting. For more details, see
  'motorcomm,yt8531.yaml'.
- Moved mdio device tree node from 'jh7110-starfive-visionfive-v2.dts' to 'jh7110.dtsi'.
- Re-worded the commit message of several patches.
- Renamed all the functions with starfive_eth_plat prefix in 'dwmac-starfive-plat.c'.
- Added "starfive,jh7100-dwmac" compatible string and special init to support JH7100.

Previous versions:
v1 - https://patchwork.kernel.org/project/linux-riscv/cover/20221201090242.2381-1-yanhong.wang@starfivetech.com/
v2 - https://patchwork.kernel.org/project/linux-riscv/cover/20221216070632.11444-1-yanhong.wang@starfivetech.com/
v3 - https://patchwork.kernel.org/project/linux-riscv/cover/20230106030001.1952-1-yanhong.wang@starfivetech.com/
v4 - https://patchwork.kernel.org/project/linux-riscv/cover/20230118061701.30047-1-yanhong.wang@starfivetech.com/
v5 - https://patchwork.kernel.org/project/netdevbpf/cover/20230303085928.4535-1-samin.guo@starfivetech.com/
v6 - https://patchwork.kernel.org/project/netdevbpf/cover/20230313034645.5469-1-samin.guo@starfivetech.com/

Emil Renner Berthing (2):
  dt-bindings: net: snps,dwmac: Add dwmac-5.20 version
  net: stmmac: platform: Add snps,dwmac-5.20 IP compatible string

Samin Guo (3):
  dt-bindings: net: snps,dwmac: Add 'ahb' reset/reset-name
  net: stmmac: Add glue layer for StarFive JH7110 SoC
  net: stmmac: starfive_dmac: Add phy interface settings

Yanhong Wang (1):
  dt-bindings: net: Add support StarFive dwmac

 .../devicetree/bindings/net/snps,dwmac.yaml   |  17 +-
 .../bindings/net/starfive,jh7110-dwmac.yaml   | 130 ++++++++++++++
 MAINTAINERS                                   |   7 +
 drivers/net/ethernet/stmicro/stmmac/Kconfig   |  12 ++
 drivers/net/ethernet/stmicro/stmmac/Makefile  |   1 +
 .../ethernet/stmicro/stmmac/dwmac-starfive.c  | 168 ++++++++++++++++++
 .../ethernet/stmicro/stmmac/stmmac_platform.c |   3 +-
 7 files changed, 333 insertions(+), 5 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/starfive,jh7110-dwmac.yaml
 create mode 100644 drivers/net/ethernet/stmicro/stmmac/dwmac-starfive.c


base-commit: 8ca09d5fa3549d142c2080a72a4c70ce389163cd
prerequisite-patch-id: 46cc850aa0e9e03ccf5ed23d8458babfca3d71af
prerequisite-patch-id: a6975e61ee5803fbd74b1c21ab925fd81c3c0eab
prerequisite-patch-id: ac150a8c622e858e088df8121093d448df49c245
prerequisite-patch-id: 044263ef2fb9f1e5a586edbf85d5f67814a28430
prerequisite-patch-id: 89f049f951e5acf75aab92541992f816fd0acc0d
prerequisite-patch-id: 9f3dbc9073eee89134e68977e941e457593c2757
prerequisite-patch-id: 8600b156a235be2b3db53be3f834e7a370e2cfb9
prerequisite-patch-id: 1b2d0982b18da060c82134f05bf3ce16425bac8d
prerequisite-patch-id: 090ba4b78d47bc19204916e76fdbc70021785388
prerequisite-patch-id: a5d9e0f7d4f8163f566678894cf693015119f2d9
prerequisite-patch-id: 4c12d958e3a3d629d86dddb1e4f099d8909393e0
prerequisite-patch-id: bb939c0c7c26b08addfccd890f9d3974b6eaec53
prerequisite-patch-id: 8f5c66dfb14403424044192f6fa05b347ad356a7
prerequisite-patch-id: fd93763b95469912bde9bdfa4cd827c8d5dba9c6
prerequisite-patch-id: 6987950c2eb4b3773b2df8f7934eff434244aeab
prerequisite-patch-id: 258ea5f9b8bf41b6981345dcc81795f25865d38f
prerequisite-patch-id: 8b6f2c9660c0ac0ee4e73e4c21aca8e6b75e81b9
prerequisite-patch-id: dbb0c0151b8bdf093e6ce79fd2fe3f60791a6e0b
prerequisite-patch-id: e7773c977a7b37692e9792b21cc4f17fa58f9215
prerequisite-patch-id: d57e95d31686772abc4c4d5aa1cadc344dc293cd
prerequisite-patch-id: 9f911969d0a550648493952c99096d26e05d4d83
prerequisite-patch-id: 999c243dca89d56d452aa52ea3e181358b5c1d80
prerequisite-patch-id: 1be0fb49e0fbe293ca8fa94601e191b13c8c67d9
--
2.17.1

