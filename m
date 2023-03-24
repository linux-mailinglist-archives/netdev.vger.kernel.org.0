Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E00DE6C75C6
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 03:28:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231271AbjCXC2g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 22:28:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbjCXC2e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 22:28:34 -0400
Received: from ex01.ufhost.com (ex01.ufhost.com [61.152.239.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 036CD10DA;
        Thu, 23 Mar 2023 19:28:23 -0700 (PDT)
Received: from EXMBX166.cuchost.com (unknown [175.102.18.54])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "EXMBX166", Issuer "EXMBX166" (not verified))
        by ex01.ufhost.com (Postfix) with ESMTP id 61FCC24E094;
        Fri, 24 Mar 2023 10:28:21 +0800 (CST)
Received: from EXMBX162.cuchost.com (172.16.6.72) by EXMBX166.cuchost.com
 (172.16.6.76) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Fri, 24 Mar
 2023 10:28:21 +0800
Received: from starfive-sdk.starfivetech.com (171.223.208.138) by
 EXMBX162.cuchost.com (172.16.6.72) with Microsoft SMTP Server (TLS) id
 15.0.1497.42; Fri, 24 Mar 2023 10:28:20 +0800
From:   Samin Guo <samin.guo@starfivetech.com>
To:     <linux-kernel@vger.kernel.org>, <linux-riscv@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Jose Abreu <joabreu@synopsys.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Conor Dooley <conor@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>,
        Yanhong Wang <yanhong.wang@starfivetech.com>,
        Samin Guo <samin.guo@starfivetech.com>,
        Tommaso Merciai <tomm.merciai@gmail.com>
Subject: [PATCH v8 0/6] Add Ethernet driver for StarFive JH7110 SoC
Date:   Fri, 24 Mar 2023 10:28:13 +0800
Message-ID: <20230324022819.2324-1-samin.guo@starfivetech.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [171.223.208.138]
X-ClientProxiedBy: EXCAS064.cuchost.com (172.16.6.24) To EXMBX162.cuchost.com
 (172.16.6.72)
X-YovoleRuleAgent: yovoleflag
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds ethernet support for the StarFive JH7110 RISC-V SoC,
which includes a dwmac-5.20 MAC driver (from Synopsys DesignWare).
This series has been tested and works fine on VisionFive-2 v1.2A and
v1.3B SBC boards.

For more information and support, you can visit RVspace wiki[1].
You can simply review or test the patches at the link [2].
This patchset should be applied after the patchset [3] [4].

[1]: https://wiki.rvspace.org/
[2]: https://github.com/SaminGuo/linux/tree/vf2-6.3rc3-gmac
[3]: https://patchwork.kernel.org/project/linux-riscv/cover/20230320103750.60295-1-hal.feng@starfivetech.com
[4]: https://patchwork.kernel.org/project/linux-riscv/cover/20230315055813.94740-1-william.qiu@starfivetech.com

Changes since v7:
Patch 4:
- Constrained the reg/interrupts/interrupt-names properties (by Krzysztof Kozlowski)


Changes history:

Changes since v6:
- Sended network patches[patch 1,2,3,4,5,6] and riscv trees patches[patch 7,8] separately (by Jakub Kicinski)

Changes since v5:
- Dropped "depends on STMMAC_ETH" and compiled DWMAC_STARFIVE to m by default (by Emil)
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
v7 - https://patchwork.kernel.org/project/netdevbpf/cover/20230316043714.24279-1-samin.guo@starfivetech.com/

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
 .../bindings/net/starfive,jh7110-dwmac.yaml   | 144 +++++++++++++++
 MAINTAINERS                                   |   7 +
 drivers/net/ethernet/stmicro/stmmac/Kconfig   |  12 ++
 drivers/net/ethernet/stmicro/stmmac/Makefile  |   1 +
 .../ethernet/stmicro/stmmac/dwmac-starfive.c  | 168 ++++++++++++++++++
 .../ethernet/stmicro/stmmac/stmmac_platform.c |   3 +-
 7 files changed, 347 insertions(+), 5 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/starfive,jh7110-dwmac.yaml
 create mode 100644 drivers/net/ethernet/stmicro/stmmac/dwmac-starfive.c


base-commit: e8d018dd0257f744ca50a729e3d042cf2ec9da65
prerequisite-patch-id: 8a6f135bcabdad4a4bfb21f0c6a0ffd2bb57efe7
prerequisite-patch-id: 1da7255d6aeb5576ca810116a9323452be2202fa
prerequisite-patch-id: 50d53a21f91f4087fc80b6f1f72864adfb0002b9
prerequisite-patch-id: 0df3703af91c30f1ca2c47f5609012f2d7200028
prerequisite-patch-id: 89f049f951e5acf75aab92541992f816fd0acc0d
prerequisite-patch-id: 85c5bb437c383b2e68c79e59a439f01b7bcd963e
prerequisite-patch-id: 8600b156a235be2b3db53be3f834e7a370e2cfb9
prerequisite-patch-id: 1b2d0982b18da060c82134f05bf3ce16425bac8d
prerequisite-patch-id: 090ba4b78d47bc19204916e76fdbc70021785388
prerequisite-patch-id: a5d9e0f7d4f8163f566678894cf693015119f2d9
prerequisite-patch-id: 42d352fe14713b74951c4513128a0a494b2dce76
prerequisite-patch-id: bb939c0c7c26b08addfccd890f9d3974b6eaec53
prerequisite-patch-id: 4f10a3d827679eafbd3d49d2e21f31032dc9c418
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

