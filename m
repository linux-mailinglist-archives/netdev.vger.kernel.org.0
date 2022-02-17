Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 962B54BA92E
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 20:04:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244964AbiBQTEw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 14:04:52 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235094AbiBQTEw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 14:04:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BB288118C;
        Thu, 17 Feb 2022 11:04:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2A298B81EFF;
        Thu, 17 Feb 2022 19:04:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96C60C340E8;
        Thu, 17 Feb 2022 19:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645124673;
        bh=wkXrFTEKxeygcuRfHbiAkePfrPYzdrafp46VWXsmxU0=;
        h=From:To:Cc:Subject:Date:From;
        b=kgHXPLIXnYpCNP0IpNUJ0It6JyjOFYgBijYMtfALv1NTRLrba3DU4b9bTLiB1IZ4L
         NYLAv2zMPYJw+KYpTqvfOK7rUf/Jsc+3LRnAgqsREW3hyeRwg9Mxhztv3gZK/S15xX
         6VfgdwEL1Tmg59ajxhXOv3n0C8yJpPGWmMrkjzHYEv0ghLAFAxhrLdQTB7rFhgasEG
         9akDwBPwwz+pLZWVxMAZ60oXdFTN7cujhqM8tayz5uPiU2/SEPbJHIOFUTR4KYSEe2
         8V8GkOMSZwoA+yiE5Bv9Nv4m+ehLQgBPPegATaVHSFZpSIRcabsVYVMLi0O8RqrMDU
         Fi2lZTxD5zj3g==
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Networking for 5.17-rc5
Date:   Thu, 17 Feb 2022 11:04:32 -0800
Message-Id: <20220217190432.2253930-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus!

The following changes since commit f1baf68e1383f6ed93eb9cff2866d46562607a43:

  Merge tag 'net-5.17-rc4' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2022-02-10 16:01:22 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.17-rc5

for you to fetch changes up to a6ab75cec1e461f8a35559054c146c21428430b8:

  bonding: force carrier update when releasing slave (2022-02-17 10:55:21 -0800)

----------------------------------------------------------------
Networking fixes for 5.17-rc5, including fixes from wireless and
netfilter.

Current release - regressions:

 - dsa: lantiq_gswip: fix use after free in gswip_remove()

 - smc: avoid overwriting the copies of clcsock callback functions

Current release - new code bugs:

 - iwlwifi:
   - fix use-after-free when no FW is present
   - mei: fix the pskb_may_pull check in ipv4
   - mei: retry mapping the shared area
   - mvm: don't feed the hardware RFKILL into iwlmei

Previous releases - regressions:

 - ipv6: mcast: use rcu-safe version of ipv6_get_lladdr()

 - tipc: fix wrong publisher node address in link publications

 - iwlwifi: mvm: don't send SAR GEO command for 3160 devices,
   avoid FW assertion

 - bgmac: make idm and nicpm resource optional again

 - atl1c: fix tx timeout after link flap

Previous releases - always broken:

 - vsock: remove vsock from connected table when connect is
   interrupted by a signal

 - ping: change destination interface checks to match raw sockets

 - crypto: af_alg - get rid of alg_memory_allocated to avoid confusing
   semantics (and null-deref) after SO_RESERVE_MEM was added

 - ipv6: make exclusive flowlabel checks per-netns

 - bonding: force carrier update when releasing slave

 - sched: limit TC_ACT_REPEAT loops

 - bridge: multicast: notify switchdev driver whenever MC processing
   gets disabled because of max entries reached

 - wifi: brcmfmac: fix crash in brcm_alt_fw_path when WLAN not found

 - iwlwifi: fix locking when "HW not ready"

 - phy: mediatek: remove PHY mode check on MT7531

 - dsa: mv88e6xxx: flush switchdev FDB workqueue before removing VLAN

 - dsa: lan9303:
   - fix polarity of reset during probe
   - fix accelerated VLAN handling

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Alex Maydanik (1):
      net: fix documentation for kernel_getsockname

Alexey Khoroshilov (1):
      net: dsa: lantiq_gswip: fix use after free in gswip_remove()

Benjamin Beichler (1):
      mac80211_hwsim: report NOACK frames in tx_status

DENG Qingfang (1):
      net: phy: mediatek: remove PHY mode check on MT7531

Danie du Toit (1):
      nfp: flower: netdev offload check for ip6gretap

Daniele Palmas (1):
      net: usb: cdc_mbim: avoid altsetting toggling for Telit FN990

David S. Miller (3):
      Merge ra.kernel.org:/pub/scm/linux/kernel/git/netfilter/nf
      Merge tag 'wireless-2022-02-11' of git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless
      Merge tag 'ieee802154-for-net-2022-02-15' of git://git.kernel.org/pub/scm/linux/kernel/git/sschmidt/wpan

Emmanuel Grumbach (4):
      iwlwifi: mei: fix the pskb_may_pull check in ipv4
      iwlwifi: mei: retry mapping the shared area
      iwlwifi: mvm: don't feed the hardware RFKILL into iwlmei
      iwlwifi: mei: report RFKILL upon register when needed

Eric Dumazet (8):
      netfilter: xt_socket: fix a typo in socket_mt_destroy()
      drop_monitor: fix data-race in dropmon_net_event / trace_napi_poll_hit
      net_sched: add __rcu annotation to netdev->qdisc
      crypto: af_alg - get rid of alg_memory_allocated
      bonding: fix data-races around agg_select_timer
      net: sched: limit TC_ACT_REPEAT loops
      ipv4: fix data races in fib_alias_hw_flags_set
      ipv6: fix data-race in fib6_info_hw_flags_set / fib6_purge_rt

Florian Westphal (1):
      selftests: netfilter: add synproxy test

Gatis Peisenieks (1):
      atl1c: fix tx timeout after link flap on Mikrotik 10/25G NIC

Hangbin Liu (2):
      selftests: netfilter: fix exit value for nft_concat_range
      selftests: netfilter: disable rp_filter on router

Hangyu Hua (1):
      tipc: fix a bit overflow in tipc_crypto_key_rcv()

Ignat Korchagin (1):
      ipv6: mcast: use rcu-safe version of ipv6_get_lladdr()

JaeMan Park (1):
      mac80211_hwsim: initialize ieee80211_tx_info at hw_scan_work

Jeremy Kerr (1):
      mctp: serial: Cancel pending work from ndo_uninit handler

Jesse Brandeburg (1):
      ice: enable parsing IPSEC SPI headers for RSS

Jiasheng Jiang (1):
      mac80211: mlme: check for null after calling kmemdup

Johannes Berg (4):
      iwlwifi: pcie: fix locking when "HW not ready"
      iwlwifi: pcie: gen2: fix locking when "HW not ready"
      cfg80211: fix race in netlink owner interface destruction
      iwlwifi: fix use-after-free

Jon Maloy (2):
      tipc: fix wrong publisher node address in link publications
      tipc: fix wrong notification node addresses

Jonas Gorski (1):
      Revert "net: ethernet: bgmac: Use devm_platform_ioremap_resource_byname"

Kalle Valo (4):
      MAINTAINERS: mark ath6kl as orphan
      MAINTAINERS: change Loic as wcn36xx maintainer
      MAINTAINERS: hand over ath9k maintainership to Toke
      MAINTAINERS: add DT bindings files for ath10k and ath11k

Luca Coelho (2):
      iwlwifi: remove deprecated broadcast filtering feature
      iwlwifi: mvm: don't send SAR GEO command for 3160 devices

Mans Rullgard (3):
      net: dsa: lan9303: fix reset on probe
      net: dsa: lan9303: handle hwaccel VLAN tags
      net: dsa: lan9303: add VLAN IDs to master device

Miquel Raynal (1):
      net: ieee802154: ca8210: Fix lifs/sifs periods

Miri Korenblit (2):
      iwlwifi: mvm: fix condition which checks the version of rate_n_flags
      iwlwifi: fix iwl_legacy_rate_to_fw_idx

Nikolay Aleksandrov (1):
      MAINTAINERS: bridge: update my email

Oleksandr Mazur (1):
      net: bridge: multicast: notify switchdev driver whenever MC processing gets disabled

Oliver Neukum (2):
      USB: zaurus: support another broken Zaurus
      CDC-NCM: avoid overflow in sanity checking

Pablo Neira Ayuso (2):
      netfilter: nft_synproxy: unregister hooks on init error path
      selftests: netfilter: synproxy test requires nf_conntrack

Phil Elwell (1):
      brcmfmac: firmware: Fix crash in brcm_alt_fw_path

Radu Bulie (1):
      dpaa2-eth: Initialize mutex used in one step timestamping path

Seth Forshee (1):
      vsock: remove vsock from connected table when connect is interrupted by a signal

Tom Rix (2):
      dpaa2-switch: fix default return of dpaa2_switch_flower_parse_mirror_key
      mctp: fix use after free

Vladimir Oltean (2):
      net: dsa: mv88e6xxx: flush switchdev FDB workqueue before removing VLAN
      net: mscc: ocelot: fix use-after-free in ocelot_vlan_del()

Wen Gu (1):
      net/smc: Avoid overwriting the copies of clcsock callback functions

Willem de Bruijn (1):
      ipv6: per-netns exclusive flowlabel checks

Xin Long (1):
      ping: fix the dif and sdif check in ping_lookup

Zhang Changzhong (1):
      bonding: force carrier update when releasing slave

Zhang Yunkai (1):
      ipv4: add description about martian source

 MAINTAINERS                                        |  15 +-
 crypto/af_alg.c                                    |   3 -
 drivers/net/bonding/bond_3ad.c                     |  30 ++-
 drivers/net/bonding/bond_main.c                    |   5 +-
 drivers/net/dsa/Kconfig                            |   1 +
 drivers/net/dsa/lan9303-core.c                     |  13 +-
 drivers/net/dsa/lantiq_gswip.c                     |   2 +-
 drivers/net/dsa/mv88e6xxx/chip.c                   |   7 +
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c    |   2 +-
 drivers/net/ethernet/broadcom/bgmac-platform.c     |  23 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c   |   2 +-
 .../ethernet/freescale/dpaa2/dpaa2-switch-flower.c |   4 +-
 drivers/net/ethernet/intel/ice/ice_lib.c           |   6 +
 drivers/net/ethernet/mscc/ocelot.c                 |   6 +-
 drivers/net/ethernet/netronome/nfp/flower/cmsg.h   |   2 +
 drivers/net/ieee802154/ca8210.c                    |   4 +-
 drivers/net/mctp/mctp-serial.c                     |   9 +-
 drivers/net/netdevsim/fib.c                        |   4 +-
 drivers/net/phy/mediatek-ge.c                      |   3 -
 drivers/net/usb/cdc_ether.c                        |  12 ++
 drivers/net/usb/cdc_mbim.c                         |   5 +
 drivers/net/usb/cdc_ncm.c                          |   8 +-
 drivers/net/usb/zaurus.c                           |  12 ++
 .../broadcom/brcm80211/brcmfmac/firmware.c         |   6 +-
 drivers/net/wireless/intel/iwlwifi/Kconfig         |  13 --
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c       |  11 +-
 .../net/wireless/intel/iwlwifi/fw/api/commands.h   |   5 -
 drivers/net/wireless/intel/iwlwifi/fw/api/filter.h |  88 --------
 drivers/net/wireless/intel/iwlwifi/fw/api/rs.h     |   1 -
 drivers/net/wireless/intel/iwlwifi/fw/file.h       |   2 -
 drivers/net/wireless/intel/iwlwifi/fw/rs.c         |  33 +--
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h       |   3 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |   2 +
 drivers/net/wireless/intel/iwlwifi/mei/main.c      |  45 +++-
 drivers/net/wireless/intel/iwlwifi/mei/net.c       |   3 +-
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c   | 203 -----------------
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  | 240 ---------------------
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |  15 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |   1 -
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |   2 +-
 .../net/wireless/intel/iwlwifi/pcie/trans-gen2.c   |   3 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |   3 +-
 drivers/net/wireless/mac80211_hwsim.c              |  13 ++
 include/linux/netdevice.h                          |   2 +-
 include/net/addrconf.h                             |   2 -
 include/net/bond_3ad.h                             |   2 +-
 include/net/dsa.h                                  |   1 +
 include/net/ip6_fib.h                              |  10 +-
 include/net/ipv6.h                                 |   5 +-
 include/net/netns/ipv6.h                           |   3 +-
 net/bridge/br_multicast.c                          |   4 +
 net/core/drop_monitor.c                            |  11 +-
 net/core/rtnetlink.c                               |   6 +-
 net/dsa/dsa.c                                      |   1 +
 net/dsa/dsa_priv.h                                 |   1 -
 net/dsa/tag_lan9303.c                              |  21 +-
 net/ipv4/fib_frontend.c                            |   3 +
 net/ipv4/fib_lookup.h                              |   7 +-
 net/ipv4/fib_semantics.c                           |   6 +-
 net/ipv4/fib_trie.c                                |  22 +-
 net/ipv4/ping.c                                    |  11 +-
 net/ipv4/route.c                                   |   4 +-
 net/ipv6/addrconf.c                                |   4 +-
 net/ipv6/ip6_flowlabel.c                           |   4 +-
 net/ipv6/mcast.c                                   |   2 +-
 net/ipv6/route.c                                   |  19 +-
 net/mac80211/mlme.c                                |  29 ++-
 net/mctp/route.c                                   |  11 +-
 net/netfilter/nft_synproxy.c                       |   4 +-
 net/netfilter/xt_socket.c                          |   2 +-
 net/sched/act_api.c                                |  13 +-
 net/sched/cls_api.c                                |   6 +-
 net/sched/sch_api.c                                |  22 +-
 net/sched/sch_generic.c                            |  29 +--
 net/smc/af_smc.c                                   |  10 +-
 net/socket.c                                       |   4 +-
 net/tipc/crypto.c                                  |   2 +-
 net/tipc/node.c                                    |  13 +-
 net/vmw_vsock/af_vsock.c                           |   1 +
 net/wireless/core.c                                |  17 +-
 tools/testing/selftests/netfilter/Makefile         |   2 +-
 .../selftests/netfilter/nft_concat_range.sh        |   2 +-
 tools/testing/selftests/netfilter/nft_fib.sh       |   1 +
 tools/testing/selftests/netfilter/nft_synproxy.sh  | 117 ++++++++++
 85 files changed, 520 insertions(+), 788 deletions(-)
 create mode 100755 tools/testing/selftests/netfilter/nft_synproxy.sh
