Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 995374163E6
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 19:10:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242354AbhIWRLJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 13:11:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:40168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242418AbhIWRLH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Sep 2021 13:11:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E458E610C9;
        Thu, 23 Sep 2021 17:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632416976;
        bh=X9e2tJCK4eGWf1aSCHtDuXM+1MoEWo38GqGdb4wtohE=;
        h=From:To:Cc:Subject:Date:From;
        b=bOi4qw+/ZzQ3qbBiP6Ldz6fArnDl3EY/bnppLOGXbn0s2ThMh4cIaTFr27az9a9Jf
         lymPt0qLoH5f1kf/zeRg8Xua8J7hk6F60Ia6hG5Q5kGOO16mICwTgmy40UJ4XUcaDo
         ti7wl6dNoLMTYG9UdSdPwmVapI6lDJz7ZUGchO+uGTigj9XWKVacYhmiFqwScsmrAY
         vdcicLsRvO7Ualb6NM2hEbUI3ikV7HwD2b7OQXVOWp4eA4uxpM1t6hGP++r9oBxb2s
         a9TYsSCMAtUj0ZCmiU+YR8KykBYXYfasur7HNT4IlQC4QiOXvF4epHyRJJKb5+Is4u
         sFecOJTMod3/w==
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Networking for 5.15-rc3
Date:   Thu, 23 Sep 2021 10:09:35 -0700
Message-Id: <20210923170935.1703615-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus!

The following changes since commit fc0c0548c1a2e676d3a928aaed70f2d4d254e395:

  Merge tag 'net-5.15-rc2' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2021-09-16 13:05:42 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.15-rc3

for you to fetch changes up to 4d88c339c423eefe2fd48215016cb0c75fcb4c4d:

  atlantic: Fix issue in the pm resume flow. (2021-09-23 13:24:14 +0100)

----------------------------------------------------------------
Networking fixes for 5.15-rc3.

Current release - regressions:

 - dsa: bcm_sf2: fix array overrun in bcm_sf2_num_active_ports()

Previous releases - regressions:

 - introduce a shutdown method to mdio device drivers, and make DSA
   switch drivers compatible with masters disappearing on shutdown;
   preventing infinite reference wait

 - fix issues in mdiobus users related to ->shutdown vs ->remove

 - virtio-net: fix pages leaking when building skb in big mode

 - xen-netback: correct success/error reporting for the SKB-with-fraglist

 - dsa: tear down devlink port regions when tearing down the devlink
        port on error

 - nexthop: fix division by zero while replacing a resilient group

 - hns3: check queue, vf, vlan ids range before using

Previous releases - always broken:

 - napi: fix race against netpoll causing NAPI getting stuck

 - mlx4_en: ensure link operstate is updated even if link comes up
            before netdev registration

 - bnxt_en: fix TX timeout when TX ring size is set to the smallest

 - enetc: fix illegal access when reading affinity_hint;
          prevent oops on sysfs access

 - mtk_eth_soc: avoid creating duplicate offload entries

Misc:

 - core: correct the sock::sk_lock.owned lockdep annotations

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Alejandro Concepcion-Rodriguez (1):
      docs: net: dsa: sja1105: fix reference to sja1105.txt

Alexandra Winter (2):
      s390/qeth: Fix deadlock in remove_discipline
      s390/qeth: fix deadlock during failing recovery

Arnd Bergmann (1):
      ptp: ocp: add COMMON_CLK dependency

Aya Levin (1):
      net/mlx4_en: Don't allow aRFS for encapsulated packets

Christian Lamparter (1):
      net: bgmac-bcma: handle deferred probe error due to mac-address

Claudiu Manoil (2):
      enetc: Fix illegal access when reading affinity_hint
      enetc: Fix uninitialized struct dim_sample field usage

Colin Foster (2):
      net: mscc: ocelot: remove buggy and useless write to ANA_PFC_PFC_CFG
      net: mscc: ocelot: remove buggy duplicate write to DEV_CLOCK_CFG

David S. Miller (5):
      Merge branch 'dsa-shutdown'
      Merge branch 'ocelot-phylink-fixes'
      Merge branch 'hns3-fixes'
      Merge branch 'smc-fixes'
      Merge branch 'dsa-devres'

Felix Fietkau (1):
      net: ethernet: mtk_eth_soc: avoid creating duplicate offload entries

Florian Fainelli (1):
      net: dsa: bcm_sf2: Fix array overrun in bcm_sf2_num_active_ports()

Guvenc Gulce (1):
      MAINTAINERS: remove Guvenc Gulce as net/smc maintainer

Ido Schimmel (2):
      nexthop: Fix division by zero while replacing a resilient group
      nexthop: Fix memory leaks in nexthop notification chain listeners

Jakub Kicinski (1):
      Merge branch 's390-qeth-fixes-2021-09-21'

Jan Beulich (1):
      xen-netback: correct success/error reporting for the SKB-with-fraglist case

Jason Wang (1):
      virtio-net: fix pages leaking when building skb in big mode

Jian Shen (2):
      net: hns3: fix change RSS 'hfunc' ineffective issue
      net: hns3: fix inconsistent vf id print

Jiaran Zhang (1):
      net: hns3: fix misuse vf id and vport id in some logs

Johan Hovold (1):
      net: hso: fix muxed tty registration

Julian Wiedmann (1):
      s390/qeth: fix NULL deref in qeth_clear_working_pool_list()

Karsten Graul (2):
      net/smc: add missing error check in smc_clc_prfx_set()
      net/smc: fix 'workqueue leaked lock' in smc_conn_abort_work

Krzysztof Kozlowski (1):
      net: freescale: drop unneeded MODULE_ALIAS

Lama Kayal (1):
      net/mlx4_en: Resolve bad operstate value

Mark Brown (1):
      nfc: st-nci: Add SPI ID matching DT compatible

Masanari Iida (1):
      Doc: networking: Fox a typo in ice.rst

Michael Chan (1):
      bnxt_en: Fix TX timeout when TX ring size is set to the smallest

Paolo Abeni (1):
      mptcp: ensure tx skbs always have the MPTCP ext

Randy Dunlap (1):
      igc: fix build errors for PTP

Shai Malin (1):
      qed: rdma - don't wait for resources under hw error recovery flow

Shuah Khan (2):
      selftests: net: af_unix: Fix incorrect args in test result msg
      selftests: net: af_unix: Fix makefile to use TEST_GEN_PROGS

Sudarsana Reddy Kalluru (1):
      atlantic: Fix issue in the pm resume flow.

Thomas Gleixner (1):
      net: core: Correct the sock::sk_lock.owned lockdep annotations

Vladimir Oltean (11):
      net: update NXP copyright text
      net: mdio: introduce a shutdown method to mdio device drivers
      net: dsa: be compatible with masters which unregister on shutdown
      net: dsa: hellcreek: be compatible with masters which unregister on shutdown
      net: dsa: microchip: ksz8863: be compatible with masters which unregister on shutdown
      net: dsa: xrs700x: be compatible with masters which unregister on shutdown
      net: dsa: tear down devlink port regions when tearing down the devlink port on error
      net: dsa: fix dsa_tree_setup error path
      net: dsa: don't allocate the slave_mii_bus using devres
      net: dsa: realtek: register the MDIO bus under devres
      net: mscc: ocelot: fix forwarding from BLOCKING ports remaining enabled

Xuan Zhuo (1):
      napi: fix race inside napi_enable

Yufeng Mo (2):
      net: hns3: check queue id range before using
      net: hns3: fix a return value error in hclge_get_reset_status()

liaoguojia (1):
      net: hns3: check vlan id before using it

 .../device_drivers/ethernet/intel/ice.rst          |   2 +-
 Documentation/networking/dsa/sja1105.rst           |   2 +-
 MAINTAINERS                                        |   1 -
 arch/s390/include/asm/ccwgroup.h                   |   2 +-
 drivers/net/dsa/b53/b53_mdio.c                     |  21 +++-
 drivers/net/dsa/b53/b53_mmap.c                     |  13 +++
 drivers/net/dsa/b53/b53_priv.h                     |   5 +
 drivers/net/dsa/b53/b53_spi.c                      |  13 +++
 drivers/net/dsa/b53/b53_srab.c                     |  21 +++-
 drivers/net/dsa/bcm_sf2.c                          |  14 ++-
 drivers/net/dsa/dsa_loop.c                         |  22 +++-
 drivers/net/dsa/hirschmann/hellcreek.c             |  16 +++
 drivers/net/dsa/lan9303-core.c                     |   6 ++
 drivers/net/dsa/lan9303.h                          |   1 +
 drivers/net/dsa/lan9303_i2c.c                      |  24 ++++-
 drivers/net/dsa/lan9303_mdio.c                     |  15 +++
 drivers/net/dsa/lantiq_gswip.c                     |  18 ++++
 drivers/net/dsa/microchip/ksz8795_spi.c            |  11 +-
 drivers/net/dsa/microchip/ksz8863_smi.c            |  13 +++
 drivers/net/dsa/microchip/ksz9477_i2c.c            |  14 ++-
 drivers/net/dsa/microchip/ksz9477_spi.c            |   8 +-
 drivers/net/dsa/mt7530.c                           |  18 ++++
 drivers/net/dsa/mv88e6060.c                        |  18 ++++
 drivers/net/dsa/mv88e6xxx/chip.c                   |  38 ++++++-
 drivers/net/dsa/mv88e6xxx/devlink.c                |  73 ++-----------
 drivers/net/dsa/mv88e6xxx/devlink.h                |   6 +-
 drivers/net/dsa/ocelot/felix.c                     |   2 +-
 drivers/net/dsa/ocelot/felix.h                     |   2 +-
 drivers/net/dsa/ocelot/felix_vsc9959.c             |  22 +++-
 drivers/net/dsa/ocelot/seville_vsc9953.c           |  20 +++-
 drivers/net/dsa/qca/ar9331.c                       |  18 ++++
 drivers/net/dsa/qca8k.c                            |  18 ++++
 drivers/net/dsa/realtek-smi-core.c                 |  22 +++-
 drivers/net/dsa/sja1105/sja1105_clocking.c         |   2 +-
 drivers/net/dsa/sja1105/sja1105_devlink.c          |   2 +-
 drivers/net/dsa/sja1105/sja1105_flower.c           |   2 +-
 drivers/net/dsa/sja1105/sja1105_main.c             |  21 +++-
 drivers/net/dsa/sja1105/sja1105_mdio.c             |   2 +-
 drivers/net/dsa/sja1105/sja1105_spi.c              |   2 +-
 drivers/net/dsa/sja1105/sja1105_static_config.c    |   2 +-
 drivers/net/dsa/sja1105/sja1105_static_config.h    |   2 +-
 drivers/net/dsa/sja1105/sja1105_vl.c               |   2 +-
 drivers/net/dsa/sja1105/sja1105_vl.h               |   2 +-
 drivers/net/dsa/vitesse-vsc73xx-core.c             |   6 ++
 drivers/net/dsa/vitesse-vsc73xx-platform.c         |  22 +++-
 drivers/net/dsa/vitesse-vsc73xx-spi.c              |  22 +++-
 drivers/net/dsa/vitesse-vsc73xx.h                  |   1 +
 drivers/net/dsa/xrs700x/xrs700x.c                  |   6 ++
 drivers/net/dsa/xrs700x/xrs700x.h                  |   1 +
 drivers/net/dsa/xrs700x/xrs700x_i2c.c              |  18 ++++
 drivers/net/dsa/xrs700x/xrs700x_mdio.c             |  18 ++++
 .../net/ethernet/aquantia/atlantic/aq_pci_func.c   |   4 +-
 drivers/net/ethernet/broadcom/bgmac-bcma.c         |   2 +
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |   8 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |   5 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  |   2 +-
 drivers/net/ethernet/freescale/enetc/enetc.c       |   7 +-
 drivers/net/ethernet/freescale/enetc/enetc_ierb.c  |   2 +-
 drivers/net/ethernet/freescale/enetc/enetc_ierb.h  |   2 +-
 drivers/net/ethernet/freescale/fec_main.c          |   1 -
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c |   8 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  80 ++++++++++-----
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c |  10 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c  |   2 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |  52 ++++++----
 drivers/net/ethernet/intel/Kconfig                 |   1 +
 drivers/net/ethernet/mediatek/mtk_ppe_offload.c    |   3 +
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c     |  50 +++++----
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h       |   1 -
 drivers/net/ethernet/mscc/ocelot.c                 |  21 ++--
 drivers/net/ethernet/mscc/ocelot_devlink.c         |   2 +-
 drivers/net/ethernet/mscc/ocelot_mrp.c             |   2 +-
 drivers/net/ethernet/mscc/ocelot_net.c             |   2 +-
 drivers/net/ethernet/qlogic/qed/qed_iwarp.c        |   8 ++
 drivers/net/ethernet/qlogic/qed/qed_roce.c         |   8 ++
 drivers/net/pcs/pcs-xpcs-nxp.c                     |   2 +-
 drivers/net/phy/mdio_device.c                      |  11 ++
 drivers/net/usb/hso.c                              |  12 +--
 drivers/net/virtio_net.c                           |   4 +
 drivers/net/vxlan.c                                |   2 +-
 drivers/net/xen-netback/netback.c                  |   2 +-
 drivers/nfc/st-nci/spi.c                           |   1 +
 drivers/ptp/Kconfig                                |   1 +
 drivers/s390/cio/ccwgroup.c                        |  10 +-
 drivers/s390/net/qeth_core.h                       |   1 -
 drivers/s390/net/qeth_core_main.c                  |  22 ++--
 drivers/s390/net/qeth_l2_main.c                    |   1 -
 drivers/s390/net/qeth_l3_main.c                    |   1 -
 include/linux/dsa/ocelot.h                         |   2 +-
 include/linux/mdio.h                               |   3 +
 include/linux/packing.h                            |   2 +-
 include/net/dsa.h                                  |   9 ++
 include/net/sock.h                                 |   1 +
 lib/packing.c                                      |   2 +-
 net/core/dev.c                                     |  16 +--
 net/core/sock.c                                    |  37 ++++---
 net/dsa/dsa2.c                                     | 114 +++++++++++++++++++--
 net/dsa/tag_ocelot.c                               |   2 +-
 net/dsa/tag_ocelot_8021q.c                         |   2 +-
 net/ipv4/nexthop.c                                 |  21 +++-
 net/mptcp/protocol.c                               |   4 +-
 net/smc/smc_clc.c                                  |   3 +-
 net/smc/smc_core.c                                 |   2 +
 .../drivers/net/ocelot/tc_flower_chains.sh         |   2 +-
 tools/testing/selftests/net/af_unix/Makefile       |   5 +-
 .../testing/selftests/net/af_unix/test_unix_oob.c  |   5 +-
 106 files changed, 932 insertions(+), 285 deletions(-)
