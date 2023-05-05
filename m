Return-Path: <netdev+bounces-639-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FBEB6F8B98
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 23:49:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 796391C21A1D
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 21:49:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64D57FBE4;
	Fri,  5 May 2023 21:49:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60785DF71
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 21:49:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCBC7C4339B;
	Fri,  5 May 2023 21:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683323358;
	bh=unYNDvEC27rA57Olp50XGY/VQhkogxfy74i10B/Ekuc=;
	h=From:To:Cc:Subject:Date:From;
	b=MhzdebxQHGJpkd3fj39DGmU7qAQAP+co5EgxqXIDKdHGH31gOQ44WZFqku4d5D07G
	 1qSy7VjugN2MT5BGvlzdEi3G9hEYhyOKoGVg50nojN54uEzjvewC861IPWeDlWHgsG
	 WaSCKK0BV8zdrLmdL2D1jMYW9jPgcEkXBbmGbyymFwPeeB3qPqJ8QzWEv4UogoMOh4
	 xEz6344p3kliHX/xJRWicXD2RdB78vFWBkbLf9pmVNngPMeVv52+2YVNbVOzRzbIFp
	 bEp8cYIND0eI4v271QjK+KPww7FaqxXZpBrWP0l1YY2kPSankxyLc1htB2LFxUoqWy
	 Qzg5B61+2i5+A==
From: Jakub Kicinski <kuba@kernel.org>
To: torvalds@linux-foundation.org
Cc: kuba@kernel.org,
	davem@davemloft.net,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	pabeni@redhat.com
Subject: [GIT PULL] Networking for v6.4-rc1
Date: Fri,  5 May 2023 14:49:17 -0700
Message-Id: <20230505214917.1453870-1-kuba@kernel.org>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Linus!

The following changes since commit 6e98b09da931a00bf4e0477d0fa52748bf28fcce:

  Merge tag 'net-next-6.4' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next (2023-04-26 16:07:23 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git net-6.4-rc1

for you to fetch changes up to 644bca1d48139ad77570c24d22bafaf8e438cf03:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next (2023-05-05 13:35:45 -0700)

----------------------------------------------------------------
Including fixes from netfilter.

Current release - regressions:

 - sched: act_pedit: free pedit keys on bail from offset check

Current release - new code bugs:

 - pds_core:
  - Kconfig fixes (DEBUGFS and AUXILIARY_BUS)
  - fix mutex double unlock in error path

Previous releases - regressions:

 - sched: cls_api: remove block_cb from driver_list before freeing

 - nf_tables: fix ct untracked match breakage

 - eth: mtk_eth_soc: drop generic vlan rx offload

 - sched: flower: fix error handler on replace

Previous releases - always broken:

 - tcp: fix skb_copy_ubufs() vs BIG TCP

 - ipv6: fix skb hash for some RST packets

 - af_packet: don't send zero-byte data in packet_sendmsg_spkt()

 - rxrpc: timeout handling fixes after moving client call connection
   to the I/O thread

 - ixgbe: fix panic during XDP_TX with > 64 CPUs

 - igc: RMW the SRRCTL register to prevent losing timestamp config

 - dsa: mt7530: fix corrupt frames using TRGMII on 40 MHz XTAL MT7621

 - r8152:
   - fix flow control issue of RTL8156A
   - fix the poor throughput for 2.5G devices
   - move setting r8153b_rx_agg_chg_indicate() to fix coalescing
   - enable autosuspend

 - ncsi: clear Tx enable mode when handling a Config required AEN

 - octeontx2-pf: macsec: fixes for CN10KB ASIC rev

Misc:

 - 9p: remove INET dependency

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Andrea Mayer (1):
      selftests: srv6: make srv6_end_dt46_l3vpn_test more robust

Andy Moreton (1):
      sfc: Fix module EEPROM reporting for QSFP modules

Angelo Dureghello (1):
      net: dsa: mv88e6xxx: add mv88e6321 rsvd2cpu

Antoine Tenart (1):
      net: ipv6: fix skb hash for some RST packets

Arınç ÜNAL (2):
      net: dsa: mt7530: fix corrupt frames using trgmii on 40 MHz XTAL MT7621
      net: dsa: mt7530: fix network connectivity with multiple CPU ports

Christophe JAILLET (1):
      mISDN: Use list_count_nodes()

Cong Wang (1):
      sit: update dev->needed_headroom in ipip6_tunnel_bind_dev()

Cosmo Chou (1):
      net/ncsi: clear Tx enable mode when handling a Config required AEN

David Howells (4):
      rxrpc: Fix potential data race in rxrpc_wait_to_be_connected()
      rxrpc: Fix hard call timeout units
      rxrpc: Make it so that a waiting process can be aborted
      rxrpc: Fix timeout of a call that hasn't yet been granted a channel

David S. Miller (5):
      Merge branch 'r8152-fixes'
      Merge branch 'rxrpc-timeout-fixes'
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf
      Merge branch 'octeontx2-af-fixes'
      Merge branch 'tc-action-fixes'

Eric Dumazet (1):
      tcp: fix skb_copy_ubufs() vs BIG TCP

Felix Fietkau (1):
      net: ethernet: mtk_eth_soc: drop generic vlan rx offload, only use DSA untagging

Florian Fainelli (1):
      net: bcmgenet: Remove phy_stop() from bcmgenet_netif_stop()

Florian Westphal (1):
      netfilter: nf_tables: fix ct untracked match breakage

Geetha sowjanya (4):
      octeonxt2-af: mcs: Fix per port bypass config
      octeontx2-af: mcs: Config parser to skip 8B header
      octeontx2-af: mcs: Fix MCS block interrupt
      octeontx2-af: Secure APR table update with the lock

Hariprasad Kelam (1):
      octeontx2-af: Add validation for lmac type

Hayes Wang (4):
      r8152: fix flow control issue of RTL8156A
      r8152: fix the poor throughput for 2.5G devices
      r8152: move setting r8153b_rx_agg_chg_indicate()
      r8152: fix the autosuspend doesn't work

Ido Schimmel (1):
      ethtool: Fix uninitialized number of lanes

Ivan Vecera (1):
      net/sched: flower: Fix wrong handle assignment during filter change

Jakub Kicinski (1):
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next

Jason Andryuk (1):
      9p: Remove INET dependency

Jeremy Sowden (1):
      selftests: netfilter: fix libmnl pkg-config usage

John Hickey (1):
      ixgbe: Fix panic during XDP_TX with > 64 CPUs

Kuniyuki Iwashima (1):
      af_packet: Don't send zero-byte data in packet_sendmsg_spkt().

Lorenzo Bianconi (1):
      bonding: add xdp_features support

Martin Habets (1):
      sfc: Add back mailing list

Michal Swiatkowski (1):
      ice: block LAN in case of VF to VF offload

Pablo Neira Ayuso (2):
      netfilter: nf_tables: hit ENOENT on unexisting chain/flowtable update with missing attributes
      netfilter: nf_tables: deactivate anonymous set from preparation phase

Paolo Abeni (2):
      Merge branch 'macsec-fixes-for-cn10kb'
      Merge tag 'nf-23-05-03' of git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf

Pedro Tammela (1):
      net/sched: act_pedit: free pedit keys on bail from offset check

Ratheesh Kannoth (6):
      octeontx2-af: Fix start and end bit for scan config
      octeontx2-af: Fix depth of cam and mem table.
      octeontx2-pf: Increase the size of dmac filter flows
      octeontx2-af: Update/Fix NPC field hash extract feature
      octeontx2-af: Fix issues with NPC field hash extract
      octeontx2-af: Skip PFs if not enabled

Shannon Nelson (5):
      ionic: remove noise from ethtool rxnfc error msg
      ionic: catch failure from devlink_alloc
      pds_core: remove CONFIG_DEBUG_FS from makefile
      pds_core: add AUXILIARY_BUS and NET_DEVLINK to Kconfig
      pds_core: fix mutex double unlock in error path

Shenwei Wang (1):
      net: fec: correct the counting of XDP sent frames

Song Yoong Siang (1):
      igc: read before write to SRRCTL register

Subbaraya Sundeep (8):
      octeontx2-af: mcs: Write TCAM_DATA and TCAM_MASK registers at once
      octeontx2-pf: mcs: Fix NULL pointer dereferences
      octeontx2-pf: mcs: Match macsec ethertype along with DMAC
      octeontx2-pf: mcs: Clear stats before freeing resource
      octeontx2-pf: mcs: Fix shared counters logic
      octeontx2-pf: mcs: Do not reset PN while updating secy
      octeontx2-pf: Disable packet I/O for graceful exit
      octeontx2-vf: Detach LF resources on probe cleanup

Suman Ghosh (1):
      octeontx2-af: Update correct mask to filter IPv4 fragments

Tom Rix (1):
      net: atlantic: Define aq_pm_ops conditionally on CONFIG_PM

Victor Nogueira (1):
      net/sched: act_mirred: Add carrier check

Vlad Buslov (4):
      net/sched: cls_api: remove block_cb from driver_list before freeing
      net/sched: flower: fix filter idr initialization
      Revert "net/sched: flower: Fix wrong handle assignment during filter change"
      net/sched: flower: fix error handler on replace

Wei Fang (1):
      net: enetc: check the index of the SFI rather than the handle

Wenliang Wang (1):
      virtio_net: suppress cpu stall when free_unused_bufs

wuych (1):
      atlantic:hw_atl2:hw_atl2_utils_fw: Remove unnecessary (void*) conversions

 MAINTAINERS                                        |   1 +
 drivers/isdn/mISDN/dsp_cmx.c                       |  15 +--
 drivers/net/bonding/bond_main.c                    |  29 +++++
 drivers/net/bonding/bond_options.c                 |   2 +
 drivers/net/dsa/mt7530.c                           |  14 ++-
 drivers/net/dsa/mv88e6xxx/chip.c                   |   1 +
 drivers/net/ethernet/amd/Kconfig                   |   2 +
 drivers/net/ethernet/amd/pds_core/Makefile         |   3 +-
 drivers/net/ethernet/amd/pds_core/main.c           |  21 ++--
 .../net/ethernet/aquantia/atlantic/aq_pci_func.c   |   2 +
 .../aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c   |   4 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |   1 -
 drivers/net/ethernet/freescale/enetc/enetc_qos.c   |   2 +-
 drivers/net/ethernet/freescale/fec_main.c          |  13 ++-
 drivers/net/ethernet/intel/ice/ice_tc_lib.c        |   3 +-
 drivers/net/ethernet/intel/igc/igc_base.h          |  11 +-
 drivers/net/ethernet/intel/igc/igc_main.c          |   7 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c       |   3 -
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |   6 +-
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c    |   8 ++
 drivers/net/ethernet/marvell/octeontx2/af/mbox.c   |   5 +-
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |  19 +++-
 drivers/net/ethernet/marvell/octeontx2/af/mcs.c    | 110 +++++++++---------
 drivers/net/ethernet/marvell/octeontx2/af/mcs.h    |  26 ++---
 .../ethernet/marvell/octeontx2/af/mcs_cnf10kb.c    |  63 +++++++++++
 .../net/ethernet/marvell/octeontx2/af/mcs_reg.h    |   6 +-
 .../net/ethernet/marvell/octeontx2/af/mcs_rvu_if.c |  37 ++++++
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |  49 ++++++--
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |   1 +
 .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c    |   2 +
 .../net/ethernet/marvell/octeontx2/af/rvu_cn10k.c  |  13 ++-
 .../ethernet/marvell/octeontx2/af/rvu_debugfs.c    |   5 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c |  26 +++--
 .../net/ethernet/marvell/octeontx2/af/rvu_npc_fs.h |   4 +
 .../ethernet/marvell/octeontx2/af/rvu_npc_hash.c   | 125 ++++++++++++---------
 .../ethernet/marvell/octeontx2/af/rvu_npc_hash.h   |  10 +-
 .../ethernet/marvell/octeontx2/nic/cn10k_macsec.c  |  48 +++++---
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |   6 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |  14 ++-
 .../net/ethernet/marvell/octeontx2/nic/otx2_tc.c   |   2 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_vf.c   |   2 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        | 106 +++++++----------
 drivers/net/ethernet/mediatek/mtk_eth_soc.h        |   1 -
 .../net/ethernet/pensando/ionic/ionic_devlink.c    |   2 +
 .../net/ethernet/pensando/ionic/ionic_ethtool.c    |   2 +-
 drivers/net/ethernet/sfc/mcdi_port_common.c        |  11 +-
 drivers/net/usb/r8152.c                            |  85 +++++++++-----
 drivers/net/virtio_net.c                           |   2 +
 fs/9p/Kconfig                                      |   2 +-
 fs/9p/vfs_addr.c                                   |   1 -
 fs/9p/vfs_dentry.c                                 |   1 -
 fs/9p/vfs_dir.c                                    |   1 -
 fs/9p/vfs_file.c                                   |   1 -
 fs/9p/vfs_inode.c                                  |   1 -
 fs/9p/vfs_inode_dotl.c                             |   1 -
 fs/9p/vfs_super.c                                  |   1 -
 fs/afs/afs.h                                       |   4 +-
 fs/afs/internal.h                                  |   2 +-
 fs/afs/rxrpc.c                                     |   8 +-
 include/net/af_rxrpc.h                             |  21 ++--
 include/net/bonding.h                              |   1 +
 include/net/netfilter/nf_tables.h                  |   1 +
 net/9p/Kconfig                                     |   2 +
 net/core/skbuff.c                                  |  20 +++-
 net/ethtool/ioctl.c                                |   2 +-
 net/ipv6/sit.c                                     |   8 +-
 net/ipv6/tcp_ipv6.c                                |   2 +-
 net/ncsi/ncsi-aen.c                                |   1 +
 net/netfilter/nf_tables_api.c                      |  41 +++++--
 net/netfilter/nft_ct_fast.c                        |  14 ++-
 net/netfilter/nft_dynset.c                         |   2 +-
 net/netfilter/nft_lookup.c                         |   2 +-
 net/netfilter/nft_objref.c                         |   2 +-
 net/packet/af_packet.c                             |   2 +-
 net/rxrpc/af_rxrpc.c                               |   3 +
 net/rxrpc/ar-internal.h                            |   1 +
 net/rxrpc/call_object.c                            |   9 +-
 net/rxrpc/sendmsg.c                                |  22 ++--
 net/sched/act_mirred.c                             |   2 +-
 net/sched/act_pedit.c                              |   4 +-
 net/sched/cls_api.c                                |   1 +
 net/sched/cls_flower.c                             |   9 +-
 .../selftests/net/srv6_end_dt46_l3vpn_test.sh      |  10 +-
 tools/testing/selftests/netfilter/Makefile         |   7 +-
 84 files changed, 735 insertions(+), 407 deletions(-)

