Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8DEF5254FE
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 20:40:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354663AbiELSj7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 14:39:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236560AbiELSj5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 14:39:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 895CA270C81;
        Thu, 12 May 2022 11:39:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42C73B82AD1;
        Thu, 12 May 2022 18:39:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2C83C385B8;
        Thu, 12 May 2022 18:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652380794;
        bh=Rz/Z+Jgxwqa59feEG34KThFDPHDKe+34W6blOO1kVXo=;
        h=From:To:Cc:Subject:Date:From;
        b=EQKW0KMG+8nIyASXUb35qmkEg4A3hgdYBmqs1zFLR+bP9Tm+RoUN9A4JettkJEp2B
         e19Iz+ZD5LkqqiyIrWzQl8x0kVzSgnLZDqPQ7OZzCwDUgTqG2Wvjnho7NK67qAUhIt
         ukhajKv40jvQ+DjweWfynDKEom/EEHK/Zk6UpZmUvKZrQh59Wm+V3fGC8uyMP1CK56
         zDN8BJsA8qq9Z/BSV1tV0Aa5F2nlcJDYWYC0AtwY/dIZAAI3F02CqMR/ezo+go88id
         iwjJLfYQtUve8sDbBXkuh5dzS7PqXxdlhewpOat2p3MHDg/3HfvqjbzHNdF+yHhW5t
         A2ZJWWouXJlPA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Networking for 5.18-rc7
Date:   Thu, 12 May 2022 11:39:52 -0700
Message-Id: <20220512183952.3455585-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus!

The following changes since commit 68533eb1fb197a413fd8612ebb88e111ade3beac:

  Merge tag 'net-5.18-rc6' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2022-05-05 09:45:12 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.18-rc7

for you to fetch changes up to 3740651bf7e200109dd42d5b2fb22226b26f960a:

  tls: Fix context leak on tls_device_down (2022-05-12 10:01:36 -0700)

----------------------------------------------------------------
Networking fixes for 5.18-rc7, including fixes from wireless,
and bluetooth. No outstanding fires.

Current release - regressions:

 - eth: atlantic: always deep reset on pm op, fix null-deref

Current release - new code bugs:

 - rds: use maybe_get_net() when acquiring refcount on TCP sockets
   [refinement of a previous fix]

 - eth: ocelot: mark traps with a bool instead of guessing type based
   on list membership

Previous releases - regressions:

 - net: fix skipping features in for_each_netdev_feature()

 - phy: micrel: fix null-derefs on suspend/resume and probe

 - bcmgenet: check for Wake-on-LAN interrupt probe deferral

Previous releases - always broken:

 - ipv4: drop dst in multicast routing path, prevent leaks

 - ping: fix address binding wrt vrf

 - net: fix wrong network header length when BPF protocol translation
   is used on skbs with a fraglist

 - bluetooth: fix the creation of hdev->name

 - rfkill: uapi: fix RFKILL_IOCTL_MAX_SIZE ioctl request definition

 - wifi: iwlwifi: iwl-dbg: use del_timer_sync() before freeing

 - wifi: ath11k: reduce the wait time of 11d scan and hw scan while
   adding an interface

 - mac80211: fix rx reordering with non explicit / psmp ack policy

 - mac80211: reset MBSSID parameters upon connection

 - nl80211: fix races in nl80211_set_tx_bitrate_mask()

 - tls: fix context leak on tls_device_down

 - sched: act_pedit: really ensure the skb is writable

 - batman-adv: don't skb_split skbuffs with frag_list

 - eth: ocelot: fix various issues with TC actions (null-deref; bad
   stats; ineffective drops; ineffective filter removal)

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Alexandra Winter (3):
      s390/ctcm: fix variable dereferenced before check
      s390/ctcm: fix potential memory leak
      s390/lcs: fix variable dereferenced before check

Amit Cohen (1):
      mlxsw: Avoid warning during ip6gre device removal

Anatolii Gerasymenko (1):
      ice: clear stale Tx queue settings before configuring

David S. Miller (2):
      Merge branch 'atlantic-fixes'
      Merge branch 's390-net-fixes'

Eric Dumazet (1):
      netlink: do not reset transport header in netlink_recvmsg()

Fabio Estevam (2):
      net: phy: micrel: Do not use kszphy_suspend/resume for KSZ8061
      net: phy: micrel: Pass .probe for KS8737

Felix Fietkau (1):
      mac80211: fix rx reordering with non explicit / psmp ack policy

Florian Fainelli (2):
      net: bcmgenet: Check for Wake-on-LAN interrupt probe deferral
      net: dsa: bcm_sf2: Fix Wake-on-LAN with mac_link_down()

Francesco Dolcini (1):
      net: phy: Fix race condition on link status change

Gleb Fotengauer-Malinovskiy (1):
      rfkill: uapi: fix RFKILL_IOCTL_MAX_SIZE ioctl request definition

Grant Grundler (4):
      net: atlantic: fix "frag[0] not initialized"
      net: atlantic: reduce scope of is_rsc_complete
      net: atlantic: add check for MAX_SKB_FRAGS
      net: atlantic: verify hw_head_ lies within TX buffer ring

Gregory Greenman (1):
      MAINTAINERS: update iwlwifi driver maintainer

Guangguan Wang (1):
      net/smc: non blocking recvmsg() return -EAGAIN when no data and signal_pending

Guenter Roeck (1):
      iwlwifi: iwl-dbg: Use del_timer_sync() before freeing

Itay Iellin (1):
      Bluetooth: Fix the creation of hdev->name

Ivan Vecera (1):
      ice: Fix race during aux device (un)plugging

Jakub Kicinski (6):
      Merge branch 'vrf-fix-address-binding-with-icmp-socket'
      Merge branch 'ocelot-vcap-fixes'
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue
      Merge tag 'batadv-net-pullrequest-20220508' of git://git.open-mesh.org/linux-merge
      Merge tag 'wireless-2022-05-11' of git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless
      Merge tag 'for-net-2022-05-11' of git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth

Jesse Brandeburg (1):
      dim: initialize all struct fields

Johannes Berg (3):
      mac80211_hwsim: fix RCU protected chanctx access
      mac80211_hwsim: call ieee80211_tx_prepare_skb under RCU protection
      nl80211: fix locking in nl80211_set_tx_bitrate_mask()

Jonathan Lemon (1):
      ptp: ocp: Use DIV64_U64_ROUND_UP for rounding.

Jonathan Toppins (1):
      MAINTAINERS: add missing files for bonding definition

Kalle Valo (1):
      mailmap: update Kalle Valo's email

Kees Cook (2):
      net: chelsio: cxgb4: Avoid potential negative array offset
      decnet: Use container_of() for struct dn_neigh casts

Kieran Frewen (2):
      nl80211: validate S1G channel width
      cfg80211: retrieve S1G operating channel number

Lina Wang (2):
      net: fix wrong network header length
      selftests net: add UDP GRO fraglist + bpf self-tests

Lokesh Dhoundiyal (1):
      ipv4: drop dst in multicast routing path

Manikanta Pubbisetty (1):
      mac80211: Reset MBSSID parameters upon connection

Manuel Ullmann (1):
      net: atlantic: always deep reset on pm op, fixing up my null deref regression

Maxim Mikityanskiy (1):
      tls: Fix context leak on tls_device_down

Michal Michalik (1):
      ice: fix PTP stale Tx timestamps cleanup

Nicolas Dichtel (2):
      ping: fix address binding wrt vrf
      selftests: add ping test with ping_group_range tuned

Paolo Abeni (1):
      net/sched: act_pedit: really ensure the skb is writable

Sven Eckelmann (1):
      batman-adv: Don't skb_split skbuffs with frag_list

Taehee Yoo (2):
      net: sfc: fix memory leak due to ptp channel
      net: sfc: ef10: fix memory leak in efx_ef10_mtd_probe()

Tariq Toukan (1):
      net: Fix features skip in for_each_netdev_feature()

Tetsuo Handa (1):
      net: rds: use maybe_get_net() when acquiring refcount on TCP sockets

Vladimir Oltean (6):
      net: mscc: ocelot: mark traps with a bool instead of keeping them in a list
      net: mscc: ocelot: fix last VCAP IS1/IS2 filter persisting in hardware when deleted
      net: mscc: ocelot: fix VCAP IS2 filters matching on both lookups
      net: mscc: ocelot: restrict tc-trap actions to VCAP IS2 lookup 0
      net: mscc: ocelot: avoid corrupting hardware counters when moving VCAP filters
      net: dsa: flush switchdev workqueue on bridge join error path

Wan Jiabing (1):
      net: phy: micrel: Fix incorrect variable type in micrel

Wen Gong (1):
      ath11k: reduce the wait time of 11d scan and hw scan while add interface

Xiaomeng Tong (1):
      i40e: i40e_main: fix a missing check on list iterator

Yang Yingliang (4):
      ionic: fix missing pci_release_regions() on error in ionic_probe()
      ethernet: tulip: fix missing pci_disable_device() on error in tulip_init_one()
      net: stmmac: fix missing pci_disable_device() on error in stmmac_pci_probe()
      net: ethernet: mediatek: ppe: fix wrong size passed to memset()

 .mailmap                                           |   1 +
 MAINTAINERS                                        |   5 +-
 drivers/net/dsa/bcm_sf2.c                          |   3 +
 drivers/net/dsa/ocelot/felix.c                     |   7 +-
 .../net/ethernet/aquantia/atlantic/aq_pci_func.c   |   4 +-
 drivers/net/ethernet/aquantia/atlantic/aq_ring.c   |  20 +-
 .../ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c  |   7 +
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |   4 +
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c         |  10 +-
 drivers/net/ethernet/dec/tulip/tulip_core.c        |   5 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |  27 +-
 drivers/net/ethernet/intel/ice/ice.h               |   1 +
 drivers/net/ethernet/intel/ice/ice_idc.c           |  25 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |   2 +
 drivers/net/ethernet/intel/ice/ice_ptp.c           |  10 +-
 drivers/net/ethernet/intel/ice/ice_virtchnl.c      |  68 +++--
 drivers/net/ethernet/mediatek/mtk_ppe.c            |   2 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_ipip.c    |  11 +-
 drivers/net/ethernet/mscc/ocelot.c                 |  11 +-
 drivers/net/ethernet/mscc/ocelot_flower.c          |   9 +-
 drivers/net/ethernet/mscc/ocelot_vcap.c            |   9 +-
 .../net/ethernet/pensando/ionic/ionic_bus_pci.c    |   3 +-
 drivers/net/ethernet/sfc/ef10.c                    |   5 +
 drivers/net/ethernet/sfc/efx_channels.c            |   7 +-
 drivers/net/ethernet/sfc/ptp.c                     |  14 +-
 drivers/net/ethernet/sfc/ptp.h                     |   1 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c   |   4 +-
 drivers/net/phy/micrel.c                           |  10 +-
 drivers/net/phy/phy.c                              |   7 +-
 drivers/net/wireless/ath/ath11k/core.c             |   1 +
 drivers/net/wireless/ath/ath11k/core.h             |  13 +-
 drivers/net/wireless/ath/ath11k/mac.c              |  71 +++--
 drivers/net/wireless/ath/ath11k/mac.h              |   2 +-
 drivers/net/wireless/ath/ath11k/reg.c              |  43 ++--
 drivers/net/wireless/ath/ath11k/reg.h              |   2 +-
 drivers/net/wireless/ath/ath11k/wmi.c              |  16 +-
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c   |   2 +-
 drivers/net/wireless/mac80211_hwsim.c              |  10 +-
 drivers/ptp/ptp_ocp.c                              |   2 +-
 drivers/s390/net/ctcm_mpc.c                        |   6 +-
 drivers/s390/net/ctcm_sysfs.c                      |   5 +-
 drivers/s390/net/lcs.c                             |   7 +-
 include/linux/netdev_features.h                    |   4 +-
 include/net/bluetooth/hci_core.h                   |   3 +
 include/net/tc_act/tc_pedit.h                      |   1 +
 include/soc/mscc/ocelot_vcap.h                     |   2 +-
 include/uapi/linux/rfkill.h                        |   2 +-
 lib/dim/net_dim.c                                  |  44 ++--
 net/batman-adv/fragmentation.c                     |  11 +
 net/bluetooth/hci_core.c                           |   6 +-
 net/core/skbuff.c                                  |   4 +-
 net/decnet/dn_dev.c                                |   4 +-
 net/decnet/dn_neigh.c                              |   3 +-
 net/decnet/dn_route.c                              |   4 +-
 net/dsa/port.c                                     |   1 +
 net/ipv4/ping.c                                    |  12 +-
 net/ipv4/route.c                                   |   1 +
 net/mac80211/mlme.c                                |   6 +
 net/mac80211/rx.c                                  |   3 +-
 net/netlink/af_netlink.c                           |   1 -
 net/rds/tcp.c                                      |  12 +-
 net/rds/tcp.h                                      |   2 +-
 net/rds/tcp_connect.c                              |   5 +-
 net/rds/tcp_listen.c                               |   5 +-
 net/sched/act_pedit.c                              |  26 +-
 net/smc/smc_rx.c                                   |   4 +-
 net/tls/tls_device.c                               |   3 +
 net/wireless/nl80211.c                             |  18 +-
 net/wireless/scan.c                                |   2 +-
 tools/testing/selftests/net/Makefile               |   3 +
 tools/testing/selftests/net/bpf/Makefile           |  14 +
 tools/testing/selftests/net/bpf/nat6to4.c          | 285 +++++++++++++++++++++
 tools/testing/selftests/net/fcnal-test.sh          |  12 +
 tools/testing/selftests/net/udpgro_frglist.sh      | 101 ++++++++
 74 files changed, 848 insertions(+), 228 deletions(-)
 create mode 100644 tools/testing/selftests/net/bpf/Makefile
 create mode 100644 tools/testing/selftests/net/bpf/nat6to4.c
 create mode 100755 tools/testing/selftests/net/udpgro_frglist.sh
