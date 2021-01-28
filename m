Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A8073081C8
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 00:23:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231699AbhA1XWy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 18:22:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:48652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229774AbhA1XWx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 18:22:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 34EBA64DD6;
        Thu, 28 Jan 2021 23:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611876131;
        bh=PCfH0ofy004if1sl+D9tfCExYu2MXYS6WGM13x7Vfl4=;
        h=From:To:Cc:Subject:Date:From;
        b=J/8sbrv2FuLnxCd5e5v5lAgqu9ttmixdXkFQa/bbd80tVzCBmgnLDSp9uG58yGEeR
         MbprpcZR5A0PIxOZ2355hbBZGphTe8RJ4RHo9Py6wvHwlwRVNRwHJ1ohOg5Mb4DkmO
         Ta4qiuFNjebGzZbJAVITySenGHQ/ca3xgIJptbJmuW7kC+jD+dk+OFAq2WQ/1piW3e
         jUtUajM62yi4hyYgk4D2dsqHhwjSK/y9fDN9y54qII8PKFFidxf+yZUzFqSmqSWmbO
         V43REqOJhVM86tdIPpLk/plOTqQVvTXmMyvWJgQmRSkA2kMKRwaBzWu7jLe7GF3UFy
         yboaEAaL2VoqA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Networking for 5.11-rc6
Date:   Thu, 28 Jan 2021 15:22:10 -0800
Message-Id: <20210128232210.1524674-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following changes since commit 75439bc439e0f02903b48efce84876ca92da97bd:

  Merge tag 'net-5.11-rc5' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2021-01-20 11:52:21 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.11-rc6

for you to fetch changes up to b8323f7288abd71794cd7b11a4c0a38b8637c8b5:

  rxrpc: Fix memory leak in rxrpc_lookup_local (2021-01-28 13:12:14 -0800)

----------------------------------------------------------------
Networking fixes for 5.11-rc6, including fixes from can, xfrm, wireless,
wireless-drivers and netfilter trees. Nothing scary, Intel WiFi-related
fixes seemed most notable to the users.

Current release - regressions:

 - dsa: microchip: ksz8795: fix KSZ8794 port map again to program
                            the CPU port correctly

Current release - new code bugs:

 - iwlwifi: pcie: reschedule in long-running memory reads

Previous releases - regressions:

 - iwlwifi: dbg: don't try to overwrite read-only FW data

 - iwlwifi: provide gso_type to GSO packets

 - octeontx2: make sure the buffer is 128 byte aligned

 - tcp: make TCP_USER_TIMEOUT accurate for zero window probes

 - xfrm: fix wraparound in xfrm_policy_addr_delta()

 - xfrm: fix oops in xfrm_replay_advance_bmp due to a race between CPUs
         in presence of packet reorder

 - tcp: fix TLP timer not set when CA_STATE changes from DISORDER
        to OPEN

 - wext: fix NULL-ptr-dereference with cfg80211's lack of commit()

Previous releases - always broken:

 - igc: fix link speed advertising

 - stmmac: configure EHL PSE0 GbE and PSE1 GbE to 32 bits DMA addressing

 - team: protect features update by RCU to avoid deadlock

 - xfrm: fix disable_xfrm sysctl when used on xfrm interfaces themselves

 - fec: fix temporary RMII clock reset on link up

 - can: dev: prevent potential information leak in can_fill_info()

Misc:

 - mrp: fix bad packing of MRP test packet structures

 - uapi: fix big endian definition of ipv6_rpl_sr_hdr

 - add David Ahern to IPv4/IPv6 maintainers

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Brett Creeley (2):
      ice: Don't allow more channels than LAN MSI-X available
      ice: Fix MSI-X vector fallback logic

Cong Wang (1):
      af_key: relax availability checks for skb size calculation

Corinna Vinschen (1):
      igc: fix link speed advertising

Dan Carpenter (1):
      can: dev: prevent potential information leak in can_fill_info()

Daniel Jurgens (1):
      net/mlx5: Maintain separate page trees for ECPF and PF functions

Danielle Ratson (1):
      selftests: forwarding: Specify interface when invoking mausezahn

Emmanuel Grumbach (3):
      iwlwifi: fix the NMI flow for old devices
      iwlwifi: queue: don't crash if txq->entries is NULL
      iwlwifi: pcie: add a NULL check in iwl_pcie_txq_unmap

Enke Chen (1):
      tcp: make TCP_USER_TIMEOUT accurate for zero window probes

Eric Dumazet (1):
      iwlwifi: provide gso_type to GSO packets

Eyal Birger (1):
      xfrm: fix disable_xfrm sysctl when used on xfrm interfaces

Giacinto Cifelli (2):
      net: usb: qmi_wwan: added support for Thales Cinterion PLSx3 modem family
      net: usb: cdc_ether: added support for Thales Cinterion PLSx3 modem family.

Gregory Greenman (1):
      iwlwifi: mvm: invalidate IDs of internal stations at mvm start

Henry Tieman (1):
      ice: fix FDir IPv6 flexbyte

Ido Schimmel (1):
      mlxsw: spectrum_span: Do not overwrite policer configuration

Ivan Vecera (1):
      team: protect features update by RCU to avoid deadlock

Jakub Kicinski (12):
      Merge branch 'master' of git://git.kernel.org/.../klassert/ipsec
      Merge branch 'fix-and-move-definitions-of-mrp-data-structures'
      Merge tag 'wireless-drivers-2021-01-26' of git://git.kernel.org/.../kvalo/wireless-drivers
      Merge tag 'mac80211-for-net-2021-01-26' of git://git.kernel.org/.../jberg/mac80211
      MAINTAINERS: add David Ahern to IPv4/IPv6 maintainers
      Merge branch 'net-fec-fix-temporary-rmii-clock-reset-on-link-up'
      Merge branch '100GbE' of git://git.kernel.org/.../tnguy/net-queue
      MAINTAINERS: add missing header for bonding
      Merge tag 'linux-can-fixes-for-5.11-20210127' of git://git.kernel.org/.../mkl/linux-can
      Merge git://git.kernel.org/.../pablo/nf
      Merge tag 'mlx5-fixes-2021-01-26' of git://git.kernel.org/.../saeed/linux
      Merge branch 'mlxsw-various-fixes'

Johannes Berg (13):
      iwlwifi: mvm: take mutex for calling iwl_mvm_get_sync_time()
      iwlwifi: pcie: avoid potential PNVM leaks
      iwlwifi: pnvm: don't skip everything when not reloading
      iwlwifi: pnvm: don't try to load after failures
      iwlwifi: pcie: set LTR on more devices
      iwlwifi: pcie: fix context info memory leak
      iwlwifi: pcie: use jiffies for memory read spin time limit
      iwlwifi: pcie: reschedule in long-running memory reads
      iwlwifi: mvm: guard against device removal in reprobe
      iwlwifi: queue: bail out on invalid freeing
      wext: fix NULL-ptr-dereference with cfg80211's lack of commit()
      mac80211: pause TX while changing interface type
      staging: rtl8723bs: fix wireless regulatory API misuse

Justin Iurman (1):
      uapi: fix big endian definition of ipv6_rpl_sr_hdr

Kevin Hao (1):
      net: octeontx2: Make sure the buffer is 128 byte aligned

Laurent Badel (1):
      net: fec: Fix temporary RMII clock reset on link up

Lijun Pan (1):
      ibmvnic: Ensure that CRQ entry read are correctly ordered

Lorenzo Bianconi (3):
      mt7601u: fix rx buffer refcounting
      mt76: mt7663s: fix rx buffer refcounting
      mt7601u: fix kernel crash unplugging the device

Luca Coelho (1):
      iwlwifi: pcie: add rules to match Qu with Hr2

Maor Dickman (2):
      net/mlx5e: Reduce tc unsupported key print level
      net/mlx5e: Disable hw-tc-offload when MLX5_CLS_ACT config is disabled

Marek Vasut (2):
      net: dsa: microchip: ksz8795: Fix KSZ8794 port map again
      net: dsa: microchip: Adjust reset release timing to match reference reset circuit

Matt Chen (1):
      iwlwifi: mvm: fix the return type for DSM functions 1 and 2

Matti Gottlieb (1):
      iwlwifi: Fix IWL_SUBDEVICE_NO_160 macro to use the correct bit.

Maxim Mikityanskiy (4):
      net/mlx5e: Fix IPSEC stats
      net/mlx5e: Correctly handle changing the number of queues when the interface is down
      net/mlx5e: Revert parameters on errors when changing trust state without reset
      net/mlx5e: Revert parameters on errors when changing MTU and LRO state without reset

Nathan Chancellor (1):
      mt76: Fix queue ID variable types after mcu queue split

Nick Nunley (2):
      ice: Implement flow for IPv6 next header (extension header)
      ice: update dev_addr in ice_set_mac_address even if HW filter exists

Pablo Neira Ayuso (3):
      netfilter: nft_dynset: honor stateful expressions in set definition
      netfilter: nft_dynset: add timeout extension to template
      netfilter: nft_dynset: dump expressions when set definition contains no expressions

Pali Rohár (1):
      doc: networking: ip-sysctl: Document conf/all/disable_ipv6 and conf/default/disable_ipv6

Pan Bian (7):
      net: stmmac: dwmac-intel-plat: remove config data on error
      net: fec: put child node on error path
      net: dsa: bcm_sf2: put device node before return
      chtls: Fix potential resource leak
      NFC: fix possible resource leak
      NFC: fix resource leak when target index is invalid
      net/mlx5e: free page before return

Parav Pandit (1):
      net/mlx5e: E-switch, Fix rate calculation for overflow

Paul Blakey (2):
      net/mlx5e: Fix CT rule + encap slow path offload and deletion
      net/mlx5: CT: Fix incorrect removal of tuple_nat_node from nat rhashtable

Pengcheng Yang (1):
      tcp: fix TLP timer not set when CA_STATE changes from DISORDER to OPEN

Po-Hsu Lin (1):
      selftests: xfrm: fix test return value override issue in xfrm_policy.sh

Rasmus Villemoes (3):
      net: mrp: fix definitions of MRP test packets
      net: mrp: move struct definitions out of uapi
      net: switchdev: don't set port_obj_info->handled true when -EOPNOTSUPP

Roi Dayan (1):
      net/mlx5: Fix memory leak on flow table creation error flow

Sara Sharon (1):
      iwlwifi: mvm: skip power command when unbinding vif during CSA

Shaul Triebitz (1):
      iwlwifi: mvm: clear IN_D3 after wowlan status cmd

Shay Bar (1):
      mac80211: 160MHz with extended NSS BW in CSA

Shmulik Ladkani (1):
      xfrm: Fix oops in xfrm_replay_advance_bmp

Stefan Assmann (1):
      i40e: acquire VSI pointer only after VF is initialized

Takashi Iwai (1):
      iwlwifi: dbg: Don't touch the tlv data

Takeshi Misawa (1):
      rxrpc: Fix memory leak in rxrpc_lookup_local

Vadim Fedorenko (1):
      net: decnet: fix netdev refcount leaking on error path

Visa Hankala (1):
      xfrm: Fix wraparound in xfrm_policy_addr_delta()

Voon Weifeng (1):
      stmmac: intel: Configure EHL PSE0 GbE and PSE1 GbE to 32 bits DMA addressing

Xie He (1):
      net: lapb: Add locking to the lapb module

 Documentation/networking/ip-sysctl.rst             | 12 +++
 MAINTAINERS                                        |  2 +
 drivers/net/can/dev.c                              |  2 +-
 drivers/net/dsa/bcm_sf2.c                          |  8 +-
 drivers/net/dsa/microchip/ksz8795.c                | 30 +++++---
 drivers/net/dsa/microchip/ksz_common.c             |  4 +-
 .../chelsio/inline_crypto/chtls/chtls_cm.c         |  7 +-
 drivers/net/ethernet/freescale/fec.h               |  5 ++
 drivers/net/ethernet/freescale/fec_main.c          |  9 ++-
 drivers/net/ethernet/ibm/ibmvnic.c                 |  6 ++
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c | 11 +--
 drivers/net/ethernet/intel/ice/ice.h               |  4 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c       |  8 +-
 drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c  |  8 +-
 drivers/net/ethernet/intel/ice/ice_lib.c           | 14 ++--
 drivers/net/ethernet/intel/ice/ice_main.c          | 16 ++--
 drivers/net/ethernet/intel/ice/ice_txrx.c          |  9 ++-
 drivers/net/ethernet/intel/igc/igc_ethtool.c       | 24 ++++--
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   |  3 +-
 .../net/ethernet/mellanox/mlx5/core/en/health.c    |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 20 +++--
 .../mellanox/mlx5/core/en_accel/ipsec_stats.c      |  4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c | 13 ++--
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |  8 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 39 +++++++---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  2 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 22 ++++--
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |  1 +
 .../net/ethernet/mellanox/mlx5/core/pagealloc.c    | 58 +++++++++------
 .../net/ethernet/mellanox/mlxsw/spectrum_span.c    |  6 ++
 .../net/ethernet/mellanox/mlxsw/spectrum_span.h    |  1 +
 .../net/ethernet/stmicro/stmmac/dwmac-intel-plat.c |  4 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c  |  2 +
 drivers/net/team/team.c                            |  6 +-
 drivers/net/usb/cdc_ether.c                        |  6 ++
 drivers/net/usb/qmi_wwan.c                         |  1 +
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c     | 25 +++++++
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c       | 65 ++++++++++++----
 drivers/net/wireless/intel/iwlwifi/fw/acpi.h       |  7 +-
 drivers/net/wireless/intel/iwlwifi/fw/pnvm.c       | 56 +++++++-------
 drivers/net/wireless/intel/iwlwifi/iwl-config.h    |  7 +-
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c   |  7 --
 drivers/net/wireless/intel/iwlwifi/iwl-io.c        |  9 ++-
 drivers/net/wireless/intel/iwlwifi/iwl-io.h        | 10 ++-
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h      |  6 ++
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |  6 +-
 .../net/wireless/intel/iwlwifi/mvm/debugfs-vif.c   |  3 +
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        | 25 ++++---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |  3 +
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |  7 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |  6 ++
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |  3 +
 .../wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c   | 53 ++++++++-----
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      | 10 +++
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    | 14 ++--
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       |  5 ++
 drivers/net/wireless/intel/iwlwifi/queue/tx.c      | 55 +++++++-------
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c    |  2 +-
 .../net/wireless/mediatek/mt76/mt7615/sdio_txrx.c  |  9 +--
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c    | 10 +--
 drivers/net/wireless/mediatek/mt7601u/dma.c        |  5 +-
 drivers/staging/rtl8723bs/include/rtw_wifi_regd.h  |  6 +-
 drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c  |  6 +-
 drivers/staging/rtl8723bs/os_dep/wifi_regd.c       | 10 +--
 include/net/lapb.h                                 |  2 +
 include/net/netfilter/nf_tables.h                  |  2 +
 include/net/tcp.h                                  |  3 +-
 include/uapi/linux/mrp_bridge.h                    | 86 ----------------------
 include/uapi/linux/rpl.h                           |  6 +-
 net/bridge/br_private_mrp.h                        | 29 ++++++++
 net/decnet/dn_route.c                              |  2 +-
 net/ipv4/tcp_input.c                               | 14 ++--
 net/ipv4/tcp_output.c                              |  2 +
 net/ipv4/tcp_recovery.c                            |  5 +-
 net/ipv4/tcp_timer.c                               | 18 +++++
 net/key/af_key.c                                   |  6 +-
 net/lapb/lapb_iface.c                              | 70 ++++++++++++++----
 net/lapb/lapb_timer.c                              | 30 +++++++-
 net/mac80211/ieee80211_i.h                         |  1 +
 net/mac80211/iface.c                               |  6 ++
 net/mac80211/spectmgmt.c                           | 10 ++-
 net/netfilter/nf_tables_api.c                      |  5 +-
 net/netfilter/nft_dynset.c                         | 41 +++++++----
 net/nfc/netlink.c                                  |  1 +
 net/nfc/rawsock.c                                  |  2 +-
 net/rxrpc/call_accept.c                            |  1 +
 net/switchdev/switchdev.c                          | 23 +++---
 net/wireless/wext-core.c                           |  5 +-
 net/xfrm/xfrm_input.c                              |  2 +-
 net/xfrm/xfrm_policy.c                             | 30 +++++---
 .../selftests/net/forwarding/router_mpath_nh.sh    |  2 +-
 .../selftests/net/forwarding/router_multipath.sh   |  2 +-
 tools/testing/selftests/net/xfrm_policy.sh         | 45 ++++++++++-
 93 files changed, 817 insertions(+), 441 deletions(-)
