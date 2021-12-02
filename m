Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1A5A466741
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 16:52:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359238AbhLBP4M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 10:56:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347568AbhLBP4L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 10:56:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 313A0C06174A;
        Thu,  2 Dec 2021 07:52:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A25066269A;
        Thu,  2 Dec 2021 15:52:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D62C8C00446;
        Thu,  2 Dec 2021 15:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638460368;
        bh=61+1vZmZIUtSyCSp8kogJPu/diYxfU0sBE6zxeIG3lI=;
        h=From:To:Cc:Subject:Date:From;
        b=A4xq9biNRVJZT1cUco5IouJElCQrPHPAgSgPBEc/Qg7sGfhnLz6Ue/dTVoUhloJC+
         EcWAOsdpWPotKdr7zwZtUIVjIDUPkGHgY+QwIbI/usYOs+gd4xkrAKKQsmi4Icku6c
         ZJLKpZJemixiPaOCJRxJaXM/KNk0uAIPWN/Jt8nc8Ueo1zYbtAWsG/MQfo9VEFH5yd
         1anUSB8R+Yc75Sz8OyjfgNhNWZRLxUe+d+CT+WewlsPmguJ6tcfhkJ9+b4EKfhVx+V
         QJ8Yht98DhGOqiCuUV2BtECpv7BcA/h/2/9gTbl0mGeEbVQ9pcJRYruV0s9WxUHFdU
         n4q2be+B2stiw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvalo@codeaurora.org
Subject: [GIT PULL] Networking for 5.16-rc4
Date:   Thu,  2 Dec 2021 07:51:58 -0800
Message-Id: <20211202155158.791350-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus!

Mostly scattered driver changes this week, with one big clump in mv88e6xxx.
Nothing of note, really.

The following changes since commit c5c17547b778975b3d83a73c8d84e8fb5ecf3ba5:

  Merge tag 'net-5.16-rc3' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2021-11-26 12:58:53 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.16-rc4

for you to fetch changes up to 88362ebfd7fb569c78d5cb507aa9d3c8fc203839:

  net: dsa: b53: Add SPI ID table (2021-12-02 13:05:17 +0000)

----------------------------------------------------------------
Networking fixes for 5.16-rc4, including fixes from wireless,
and wireguard.

Current release - regressions:

 - smc: keep smc_close_final()'s error code during active close

Current release - new code bugs:

 - iwlwifi: various static checker fixes (int overflow, leaks, missing
   error codes)

 - rtw89: fix size of firmware header before transfer, avoid crash

 - mt76: fix timestamp check in tx_status; fix pktid leak;

 - mscc: ocelot: fix missing unlock on error in ocelot_hwstamp_set()

Previous releases - regressions:

 - smc: fix list corruption in smc_lgr_cleanup_early

 - ipv4: convert fib_num_tclassid_users to atomic_t

Previous releases - always broken:

 - tls: fix authentication failure in CCM mode

 - vrf: reset IPCB/IP6CB when processing outbound pkts, prevent
   incorrect processing

 - dsa: mv88e6xxx: fixes for various device errata

 - rds: correct socket tunable error in rds_tcp_tune()

 - ipv6: fix memory leak in fib6_rule_suppress

 - wireguard: reset peer src endpoint when netns exits

 - wireguard: improve resilience to DoS around incoming handshakes

 - tcp: fix page frag corruption on page fault which involves TCP

 - mpls: fix missing attributes in delete notifications

 - mt7915: fix NULL pointer dereference with ad-hoc mode

Misc:

 - rt2x00: be more lenient about EPROTO errors during start

 - mlx4_en: update reported link modes for 1/10G

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Amir Tzin (1):
      net/mlx5: Fix use after free in mlx5_health_wait_pci_up

Arnd Bergmann (2):
      iwlwifi: pcie: fix constant-conversion warning
      siphash: use _unaligned version by default

Aya Levin (1):
      net/mlx5: Fix access to a non-supported register

Ben Ben-Ishay (1):
      net/mlx5e: SHAMPO, Fix constant expression result

Benjamin Poirier (2):
      net: mpls: Fix notifications when deleting a device
      net: mpls: Remove rcu protection from nh_dev

Christophe JAILLET (2):
      iwlwifi: Fix memory leaks in error handling path
      net: marvell: mvpp2: Fix the computation of shared CPUs

David S. Miller (5):
      Merge branch 'mpls-notifications'
      Merge branch 'atlantic-fixes'
      Merge branch 'mv88e6xxx-fixes'
      Merge tag 'mlx5-fixes-2021-11-30' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge tag 'wireless-drivers-2021-12-01' of git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers

Deren Wu (1):
      mt76: fix timestamp check in tx_status

Dmitry Bogdanov (2):
      atlantic: Increase delay for fw transactions
      atlantic: Fix statistics logic for production hardware

Dmytro Linkin (2):
      net/mlx5: E-switch, Respect BW share of the new group
      net/mlx5: E-Switch, Check group pointer before reading bw_share value

Dongliang Mu (1):
      dpaa2-eth: destroy workqueue at the end of remove function

Dust Li (1):
      net/smc: fix wrong list_del in smc_lgr_cleanup_early

Eiichi Tsukata (2):
      rxrpc: Fix rxrpc_peer leak in rxrpc_look_up_bundle()
      rxrpc: Fix rxrpc_local leak in rxrpc_lookup_peer()

Eric Dumazet (3):
      net: annotate data-races on txq->xmit_lock_owner
      net: avoid uninit-value from tcp_conn_request
      ipv4: convert fib_num_tclassid_users to atomic_t

Erik Ekman (1):
      net/mlx4_en: Update reported link modes for 1/10G

Florian Fainelli (1):
      net: dsa: b53: Add SPI ID table

Gal Pressman (1):
      net/mlx5: Fix too early queueing of log timestamp work

Gustavo A. R. Silva (1):
      wireguard: ratelimiter: use kvcalloc() instead of kvzalloc()

Harshit Mogalapalli (1):
      net: netlink: af_netlink: Prevent empty skb by adding a check on len.

Jakub Kicinski (2):
      Merge branch 'wireguard-siphash-patches-for-5-16-rc6'
      Merge tag 'rxrpc-fixes-20211129' of git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs

Jason A. Donenfeld (6):
      wireguard: allowedips: add missing __rcu annotation to satisfy sparse
      wireguard: selftests: increase default dmesg log size
      wireguard: selftests: actually test for routing loops
      wireguard: device: reset peer src endpoint when netns exits
      wireguard: receive: use ring buffer for incoming handshakes
      wireguard: receive: drop handshakes if queue lock is contended

Jeremy Kerr (1):
      mctp: test: fix skb free in test device tx

Jiapeng Chong (1):
      gro: Fix inconsistent indenting

Karsten Graul (1):
      MAINTAINERS: s390/net: add Alexandra and Wenjia as maintainer

Li Zhijian (2):
      wireguard: selftests: rename DEBUG_PI_LIST to DEBUG_PLIST
      selftests: net: Correct case name

Lorenzo Bianconi (3):
      mt76: mt7915: fix NULL pointer dereference in mt7915_get_phy_mode
      mt76: fix possible pktid leak
      mt76: fix key pointer overwrite in mt7921s_write_txwi/mt7663_usb_sdio_write_txwi

Luiz Angelo Daros de Luca (1):
      net: dsa: realtek-smi: fix indirect reg access for ports>3

Maciej Fijalkowski (1):
      ice: xsk: clear status_error0 for each allocated desc

Maor Dickman (1):
      net/mlx5: E-Switch, Use indirect table only if all destinations support it

Maor Gottlieb (1):
      net/mlx5: Lag, Fix recreation of VF LAG

Marek Behún (6):
      net: dsa: mv88e6xxx: Fix application of erratum 4.8 for 88E6393X
      net: dsa: mv88e6xxx: Drop unnecessary check in mv88e6393x_serdes_erratum_4_6()
      net: dsa: mv88e6xxx: Save power by disabling SerDes trasmitter and receiver
      net: dsa: mv88e6xxx: Add fix for erratum 5.2 of 88E6393X family
      net: dsa: mv88e6xxx: Fix inband AN for 2500base-x on 88E6393X family
      net: dsa: mv88e6xxx: Link in pcs_get_state() if AN is bypassed

Mark Bloch (1):
      net/mlx5: E-Switch, fix single FDB creation on BlueField

Matt Johnston (1):
      mctp: Don't let RTM_DELROUTE delete local routes

Mordechay Goodstein (1):
      iwlwifi: mvm: retry init flow if failed

Moshe Shemesh (1):
      net/mlx5: Move MODIFY_RQT command to ignore list in internal error state

Nikita Danilov (2):
      atlatnic: enable Nbase-t speeds with base-t
      atlantic: Add missing DIDs and fix 115c.

Ole Ernst (1):
      USB: NO_LPM quirk Lenovo Powered USB-C Travel Hub

Paolo Abeni (1):
      tcp: fix page frag corruption on page fault

Ping-Ke Shih (1):
      rtw89: update partition size of firmware header on skb->data

Raed Salem (2):
      net/mlx5e: IPsec: Fix Software parser inner l3 type setting in case of encapsulation
      net/mlx5e: Fix missing IPsec statistics on uplink representor

Randy Dunlap (2):
      wireguard: main: rename 'mod_init' & 'mod_exit' functions to be module-specific
      natsemi: xtensa: fix section mismatch warnings

Sameer Saurabh (3):
      atlantic: Fix to display FW bundle version instead of FW mac version.
      Remove Half duplex mode speed capabilities.
      atlantic: Remove warn trace message.

Stanislaw Gruszka (1):
      rt2x00: do not mark device gone on EPROTO errors during start

Stephen Suryaputra (1):
      vrf: Reset IPCB/IP6CB when processing outbound pkts in vrf dev xmit

Sukadev Bhattiprolu (2):
      ibmvnic: drop bad optimization in reuse_rx_pools()
      ibmvnic: drop bad optimization in reuse_tx_pools()

Sven Schuchmann (1):
      net: usb: lan78xx: lan78xx_phy_init(): use PHY_POLL instead of "0" if no IRQ is available

Tariq Toukan (1):
      net/mlx5e: Sync TIR params updates against concurrent create/modify

Tianhao Chai (1):
      ethernet: aquantia: Try MAC address from device tree

Tianjia Zhang (1):
      net/tls: Fix authentication failure in CCM mode

Tony Lu (1):
      net/smc: Keep smc_close_final rc during active close

Vincent Whitchurch (1):
      net: stmmac: Avoid DMA_CHAN_CONTROL write if no Split Header support

Wei Yongjun (1):
      net: mscc: ocelot: fix missing unlock on error in ocelot_hwstamp_set()

William Kucharski (1):
      net/rds: correct socket tunable error in rds_tcp_tune()

Xiayu Zhang (1):
      Fix Comment of ETH_P_802_3_MIN

Zhou Qingyang (3):
      net: qlogic: qlcnic: Fix a NULL pointer dereference in qlcnic_83xx_add_rings()
      net/mlx4_en: Fix an use-after-free bug in mlx4_en_try_alloc_resources()
      octeontx2-af: Fix a memleak bug in rvu_mbox_init()

chongjiapeng (1):
      iwlwifi: Fix missing error code in iwl_pci_probe()

msizanoen1 (1):
      ipv6: fix memory leak in fib6_rule_suppress

Łukasz Bartosik (1):
      iwlwifi: fix warnings produced by kernel debug options

 MAINTAINERS                                        |   6 +-
 drivers/net/dsa/b53/b53_spi.c                      |  14 ++
 drivers/net/dsa/mv88e6xxx/serdes.c                 | 252 ++++++++++++++++++---
 drivers/net/dsa/mv88e6xxx/serdes.h                 |   4 +
 drivers/net/dsa/rtl8365mb.c                        |   9 +-
 drivers/net/ethernet/aquantia/atlantic/aq_common.h |  27 +--
 drivers/net/ethernet/aquantia/atlantic/aq_hw.h     |   2 +
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c    |  34 ++-
 .../net/ethernet/aquantia/atlantic/aq_pci_func.c   |   7 +-
 drivers/net/ethernet/aquantia/atlantic/aq_vec.c    |   3 -
 .../aquantia/atlantic/hw_atl/hw_atl_utils.c        |  15 +-
 .../aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c   |   3 -
 .../ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c   |  22 +-
 .../ethernet/aquantia/atlantic/hw_atl2/hw_atl2.h   |   2 +
 .../aquantia/atlantic/hw_atl2/hw_atl2_utils.h      |  38 +++-
 .../aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c   | 110 +++++++--
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c   |   2 +
 drivers/net/ethernet/ibm/ibmvnic.c                 |  28 +--
 drivers/net/ethernet/intel/ice/ice_xsk.c           |   1 +
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |   2 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |   2 +-
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c    |   6 +-
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c     |   9 +-
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en/rx_res.c    |  41 +++-
 .../net/ethernet/mellanox/mlx5/core/en/rx_res.h    |   6 +-
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.c       |   2 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c |  24 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |   4 +
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |   8 +-
 drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c  |   4 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |  20 +-
 drivers/net/ethernet/mellanox/mlx5/core/health.c   |   5 +-
 .../net/ethernet/mellanox/mlx5/core/lag/port_sel.c |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/lib/tout.c |   5 +-
 drivers/net/ethernet/mellanox/mlx5/core/lib/tout.h |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |  30 +--
 drivers/net/ethernet/mscc/ocelot.c                 |   4 +-
 drivers/net/ethernet/natsemi/xtsonic.c             |   2 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c    |  10 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  11 +-
 drivers/net/usb/lan78xx.c                          |   2 +-
 drivers/net/vrf.c                                  |   2 +
 drivers/net/wireguard/allowedips.c                 |   2 +-
 drivers/net/wireguard/device.c                     |  39 ++--
 drivers/net/wireguard/device.h                     |   9 +-
 drivers/net/wireguard/main.c                       |   8 +-
 drivers/net/wireguard/queueing.c                   |   6 +-
 drivers/net/wireguard/queueing.h                   |   2 +-
 drivers/net/wireguard/ratelimiter.c                |   4 +-
 drivers/net/wireguard/receive.c                    |  39 ++--
 drivers/net/wireguard/socket.c                     |   2 +-
 drivers/net/wireless/intel/iwlwifi/fw/uefi.c       |   6 +
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |  22 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.h       |   3 +
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |  24 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |   3 +
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |   5 +
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |  10 +-
 .../net/wireless/mediatek/mt76/mt7615/pci_mac.c    |   3 +-
 .../net/wireless/mediatek/mt76/mt7615/usb_sdio.c   |  28 +--
 .../net/wireless/mediatek/mt76/mt76x02_usb_core.c  |   8 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c    |  15 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c    |   4 +-
 .../net/wireless/mediatek/mt76/mt7921/sdio_mac.c   |  21 +-
 drivers/net/wireless/mediatek/mt76/tx.c            |   2 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00usb.c     |   3 +
 drivers/net/wireless/realtek/rtw89/fw.c            |   2 +-
 drivers/net/wireless/realtek/rtw89/fw.h            |   6 +-
 drivers/usb/core/quirks.c                          |   3 +
 include/linux/mlx5/mlx5_ifc.h                      |   5 +-
 include/linux/netdevice.h                          |  19 +-
 include/linux/siphash.h                            |  14 +-
 include/net/busy_poll.h                            |   2 +-
 include/net/dst_cache.h                            |  11 +
 include/net/fib_rules.h                            |   4 +-
 include/net/ip_fib.h                               |   2 +-
 include/net/netns/ipv4.h                           |   2 +-
 include/net/sock.h                                 |  30 ++-
 include/uapi/linux/if_ether.h                      |   2 +-
 lib/siphash.c                                      |  12 +-
 net/core/dev.c                                     |   5 +-
 net/core/dst_cache.c                               |  19 ++
 net/core/fib_rules.c                               |   2 +-
 net/ipv4/fib_frontend.c                            |   2 +-
 net/ipv4/fib_rules.c                               |   5 +-
 net/ipv4/fib_semantics.c                           |   4 +-
 net/ipv6/fib6_rules.c                              |   4 +-
 net/ipv6/ip6_offload.c                             |   6 +-
 net/mctp/route.c                                   |   9 +-
 net/mctp/test/utils.c                              |   2 +-
 net/mpls/af_mpls.c                                 |  97 +++++---
 net/mpls/internal.h                                |   2 +-
 net/netlink/af_netlink.c                           |   5 +
 net/rds/tcp.c                                      |   2 +-
 net/rxrpc/conn_client.c                            |  14 +-
 net/rxrpc/peer_object.c                            |  14 +-
 net/smc/smc_close.c                                |   8 +-
 net/smc/smc_core.c                                 |   7 +-
 net/tls/tls_sw.c                                   |   4 +-
 tools/testing/selftests/net/fcnal-test.sh          |   4 +-
 tools/testing/selftests/wireguard/netns.sh         |  30 ++-
 .../testing/selftests/wireguard/qemu/debug.config  |   2 +-
 .../testing/selftests/wireguard/qemu/kernel.config |   1 +
 104 files changed, 1000 insertions(+), 412 deletions(-)
