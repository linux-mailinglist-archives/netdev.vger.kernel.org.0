Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD642DDA84
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 22:03:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731579AbgLQVCq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 16:02:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:46616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727055AbgLQVCq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Dec 2020 16:02:46 -0500
From:   Jakub Kicinski <kuba@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Networking for 5.11-rc1
Date:   Thu, 17 Dec 2020 13:02:04 -0800
Message-Id: <20201217210204.1256850-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus,

quick PR with some fixes which already came in this week,
since I'm not planning on sending one next week.

Happy Holidays!

The following changes since commit 3db1a3fa98808aa90f95ec3e0fa2fc7abf28f5c9:

  Merge tag 'staging-5.11-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging (2020-12-15 14:18:40 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.11-rc1

for you to fetch changes up to 44d4775ca51805b376a8db5b34f650434a08e556:

  net/sched: sch_taprio: reset child qdiscs before freeing them (2020-12-17 10:57:57 -0800)

----------------------------------------------------------------
Networking fixes for 5.11-rc1.

Current release - always broken:

 - net/smc: fix access to parent of an ib device

 - devlink: use _BITUL() macro instead of BIT() in the UAPI header

 - handful of mptcp fixes

Previous release - regressions:

 - intel: AF_XDP: clear the status bits for the next_to_use descriptor

 - dpaa2-eth: fix the size of the mapped SGT buffer

Previous release - always broken:

 - mptcp: fix security context on server socket

 - ethtool: fix string set id check

 - ethtool: fix error paths in ethnl_set_channels()

 - lan743x: fix rx_napi_poll/interrupt ping-pong

 - qca: ar9331: fix sleeping function called from invalid context bug

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Björn Töpel (2):
      ice, xsk: clear the status bits for the next_to_use descriptor
      i40e, xsk: clear the status bits for the next_to_use descriptor

Bongsu Jeon (2):
      nfc: s3fwrn5: Remove the delay for NFC sleep
      nfc: s3fwrn5: Remove unused NCI prop commands

Christophe JAILLET (3):
      net: bcmgenet: Fix a resource leak in an error handling path in the probe functin
      net: mscc: ocelot: Fix a resource leak in the error handling path of the probe function
      net: allwinner: Fix some resources leak in the error handling path of the probe and in the remove function

Colin Ian King (2):
      net: nixge: fix spelling mistake in Kconfig: "Instuments" -> "Instruments"
      octeontx2-af: Fix undetected unmap PF error check

Dan Carpenter (1):
      qlcnic: Fix error code in probe

Davide Caratti (1):
      net/sched: sch_taprio: reset child qdiscs before freeing them

Geliang Tang (1):
      mptcp: clear use_ack and use_map when dropping other suboptions

Geoff Levand (1):
      net/connector: Add const qualifier to cb_id

Hoang Le (1):
      tipc: do sanity check payload of a netlink message

Ioana Ciornei (1):
      dpaa2-eth: fix the size of the mapped SGT buffer

Ivan Vecera (1):
      ethtool: fix error paths in ethnl_set_channels()

Jakub Kicinski (5):
      Merge branch 'i40e-ice-af_xdp-zc-fixes'
      Merge branch 'locked-version-of-netdev_notify_peers'
      phy: fix kdoc warning
      Merge branch 'nfc-s3fwrn5-refactor-the-s3fwrn5-module'
      Merge branch 'mptcp-a-bunch-of-assorted-fixes'

Karsten Graul (1):
      net/smc: fix access to parent of an ib device

Lijun Pan (3):
      net: core: introduce __netdev_notify_peers
      use __netdev_notify_peers in ibmvnic
      use __netdev_notify_peers in hyperv

Michal Kubecek (1):
      ethtool: fix string set id check

Oleksij Rempel (1):
      net: dsa: qca: ar9331: fix sleeping function called from invalid context bug

Paolo Abeni (4):
      mptcp: fix security context on server socket
      mptcp: properly annotate nested lock
      mptcp: push pending frames when subflow has free space
      mptcp: fix pending data accounting

Parav Pandit (1):
      net/mlx5: Fix compilation warning for 32-bit platform

Simon Horman (1):
      nfp: move indirect block cleanup to flower app stop callback

Sven Van Asbroeck (1):
      lan743x: fix rx_napi_poll/interrupt ping-pong

Tobias Klauser (1):
      devlink: use _BITUL() macro instead of BIT() in the UAPI header

Vincent Stehlé (1):
      net: korina: fix return value

 Documentation/driver-api/connector.rst             |  2 +-
 drivers/connector/cn_queue.c                       |  8 ++--
 drivers/connector/connector.c                      |  4 +-
 drivers/net/dsa/qca/ar9331.c                       | 33 ++++++++++++-----
 drivers/net/ethernet/allwinner/sun4i-emac.c        |  7 +++-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |  4 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c   |  2 +-
 drivers/net/ethernet/ibm/ibmvnic.c                 |  9 ++---
 drivers/net/ethernet/intel/i40e/i40e_xsk.c         |  5 ++-
 drivers/net/ethernet/intel/ice/ice_xsk.c           |  5 ++-
 drivers/net/ethernet/korina.c                      |  2 +-
 .../ethernet/marvell/octeontx2/af/rvu_devlink.c    |  3 +-
 drivers/net/ethernet/microchip/lan743x_main.c      | 43 ++++++++++++----------
 drivers/net/ethernet/mscc/ocelot_vsc7514.c         |  8 +++-
 drivers/net/ethernet/netronome/nfp/flower/main.c   |  6 +--
 drivers/net/ethernet/ni/Kconfig                    |  2 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c   |  1 +
 drivers/net/hyperv/netvsc_drv.c                    | 11 ++----
 drivers/nfc/s3fwrn5/nci.c                          | 25 -------------
 drivers/nfc/s3fwrn5/nci.h                          | 22 -----------
 drivers/nfc/s3fwrn5/phy_common.c                   |  3 +-
 include/linux/connector.h                          | 10 ++---
 include/linux/mlx5/mlx5_ifc.h                      |  6 +--
 include/linux/netdevice.h                          |  1 +
 include/linux/phy.h                                |  3 +-
 include/uapi/linux/devlink.h                       |  2 +-
 net/core/dev.c                                     | 22 ++++++++++-
 net/ethtool/channels.c                             |  6 ++-
 net/ethtool/strset.c                               |  2 +-
 net/mptcp/options.c                                | 15 +++++---
 net/mptcp/protocol.c                               | 11 +++---
 net/mptcp/protocol.h                               |  2 +-
 net/sched/sch_taprio.c                             | 17 ++++++++-
 net/smc/smc_ib.c                                   | 36 +++++++++++-------
 net/tipc/netlink_compat.c                          | 12 +++---
 tools/testing/selftests/net/mptcp/simult_flows.sh  |  6 +--
 36 files changed, 198 insertions(+), 158 deletions(-)
