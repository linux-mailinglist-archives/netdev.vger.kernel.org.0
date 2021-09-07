Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE382402EDE
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 21:16:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345993AbhIGTRs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 15:17:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:60690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230203AbhIGTRr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Sep 2021 15:17:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 16BCA61078;
        Tue,  7 Sep 2021 19:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631042201;
        bh=DlHg95VgQSElSt6/0Sc/u+Hq68FladoFR5xqaxcIUdc=;
        h=From:To:Cc:Subject:Date:From;
        b=lL9VZtWyaEU+KpvnlVWpU/8tKdP/rNfDZS4CI/wkvUGU1sR5HTbyUOft3kAfZ3sZh
         bs20kHEq6sNcm0SsODJGCBPKRZ31KaPF8vZwzhchapORJn6m2sF9mVqzMkghQ59lTo
         JE3WE65xy1GQXiM6aSnnVb+a07NUr4Wop66B2kicBH4tjAbO3Xct/Qs89c2m63p7wl
         NCvM4eEIZoRZ0WJtv9URSiIrNAW0zAiI0FEmSmIvJzv03AMUAVuY2KQ9aE/3TQhacJ
         RfKpFO9INPKetQgUDGoSUWyspm9XXIUlH00vSRWUzQDhUYg6hszaonx3zV/ZZnQURo
         teN3/h5qcYgEA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Networking for 5.15-rc1
Date:   Tue,  7 Sep 2021 12:16:40 -0700
Message-Id: <20210907191640.1569636-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus!

The following changes since commit 9e9fb7655ed585da8f468e29221f0ba194a5f613:

  Merge tag 'net-next-5.15' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next (2021-08-31 16:43:06 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.15-rc1

for you to fetch changes up to 0f77f2defaf682eb7e7ef623168e49c74ae529e3:

  ieee802154: Remove redundant initialization of variable ret (2021-09-07 14:06:08 +0100)

----------------------------------------------------------------
Networking stragglers and fixes for 5.15-rc1, including changes from netfilter,
wireless and can.

Current release - regressions:

 - qrtr: revert check in qrtr_endpoint_post(), fixes audio and wifi

 - ip_gre: validate csum_start only on pull

 - bnxt_en: fix 64-bit doorbell operation on 32-bit kernels

 - ionic: fix double use of queue-lock, fix a sleeping in atomic

 - can: c_can: fix null-ptr-deref on ioctl()

 - cs89x0: disable compile testing on powerpc

Current release - new code bugs:

 - bridge: mcast: fix vlan port router deadlock, consistently disable BH

Previous releases - regressions:

 - dsa: tag_rtl4_a: fix egress tags, only port 0 was working

 - mptcp: fix possible divide by zero

 - netfilter: nft_ct: protect nft_ct_pcpu_template_refcnt with mutex

 - netfilter: socket: icmp6: fix use-after-scope

 - stmmac: fix MAC not working when system resume back with WoL active

Previous releases - always broken:

 - ip/ip6_gre: use the same logic as SIT interfaces when computing v6LL
               address

 - seg6: set fc_nlinfo in nh_create_ipv4, nh_create_ipv6

 - mptcp: only send extra TCP acks in eligible socket states

 - dsa: lantiq_gswip: fix maximum frame length

 - stmmac: fix overall budget calculation for rxtx_napi

 - bnxt_en: fix firmware version reporting via devlink

 - renesas: sh_eth: add missing barrier to fix freeing wrong tx descriptor

Stragglers:

 - netfilter: conntrack: switch to siphash

 - netfilter: refuse insertion if chain has grown too large

 - ncsi: add get MAC address command to get Intel i210 MAC address

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Andy Shevchenko (2):
      net: wwan: iosm: Replace io.*64_lo_hi() with regular accessors
      net: wwan: iosm: Unify IO accessors used in the driver

Antonio Quartulli (1):
      ip/ip6_gre: use the same logic as SIT interfaces when computing v6LL address

Arnd Bergmann (1):
      net: cs89x0: disable compile testing on powerpc

Benjamin Hesmans (1):
      netfilter: socket: icmp6: fix use-after-scope

Carlo Lobrano (1):
      net: usb: qmi_wwan: add Telit 0x1060 composition

Christophe JAILLET (3):
      octeontx2-af: Add a 'rvu_free_bitmap()' function
      octeontx2-af: Fix some memory leaks in the error handling path of 'cgx_lmac_init()'
      iwlwifi: pnvm: Fix a memory leak in 'iwl_pnvm_get_from_fs()'

Colin Ian King (7):
      net: 3com: 3c59x: clean up inconsistent indenting
      drivers: net: smc911x: clean up inconsistent indenting
      skbuff: clean up inconsistent indenting
      tipc: clean up inconsistent indenting
      seg6_iptunnel: Remove redundant initialization of variable err
      bonding: 3ad: pass parameter bond_params by reference
      ieee802154: Remove redundant initialization of variable ret

Dan Carpenter (2):
      net: qrtr: revert check in qrtr_endpoint_post()
      ionic: fix a sleeping in atomic bug

Daniele Palmas (1):
      net: usb: cdc_mbim: avoid altsetting toggling for Telit LN920

David Decotigny (1):
      bonding: complain about missing route only once for A/B ARP probes

David S. Miller (5):
      Merge branch 'bnxt_en-fixes'
      Merge branch 'bonding-fix'
      Merge tag 'wireless-drivers-2021-09-07' of git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers
      Merge tag 'linux-can-fixes-for-5.15-20210907' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can
      Merge branch 'stmmac-wol-fix'

Dinghao Liu (1):
      qlcnic: Remove redundant unlock in qlcnic_pinit_from_rom

Edwin Peer (3):
      bnxt_en: fix kernel doc warnings in bnxt_hwrm.c
      bnxt_en: fix stored FW_PSID version masks
      bnxt_en: fix read of stored FW_PSID version on P5 devices

Eric Dumazet (2):
      pktgen: remove unused variable
      fq_codel: reject silly quantum parameters

Florian Westphal (3):
      netfilter: conntrack: sanitize table size default settings
      netfilter: conntrack: switch to siphash
      netfilter: refuse insertion if chain has grown too large

Geert Uytterhoeven (1):
      net/sun3_82586: Fix return value of sun3_82586_probe()

Geetha sowjanya (1):
      octeontx2-pf: cn10K: Reserve LMTST lines per core

Heiner Kallweit (1):
      cxgb3: fix oops on module removal

Ivan Mikhaylov (1):
      net/ncsi: add get MAC address command to get Intel i210 MAC address

Jakub Kicinski (4):
      Merge branch 'mptcp-prevent-tcp_push-crash-and-selftest-temp-file-buildup'
      selftests: add simple GSO GRE test
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf
      net: create netdev->dev_addr assignment helpers

Jan Hoffmann (1):
      net: dsa: lantiq_gswip: fix maximum frame length

Jason Wang (1):
      net: qcom/emac: Replace strlcpy with strscpy

Jiwon Kim (1):
      ipv6: change return type from int to void for mld_process_v2

Joakim Zhang (1):
      net: stmmac: fix MAC not working when system resume back with WoL active

Jussi Maki (2):
      bonding: Fix negative jump label count on nested bonding
      selftests/bpf: Test XDP bonding nest and unwind

Justin M. Forbes (1):
      iwlwifi Add support for ax201 in Samsung Galaxy Book Flex2 Alpha

Linus Walleij (1):
      net: dsa: tag_rtl4_a: Fix egress tags

Luca Coelho (1):
      iwlwifi: bump FW API to 66 for AX devices

Marc Kleine-Budde (1):
      can: rcar_canfd: add __maybe_unused annotation to silence warning

Mat Martineau (1):
      mptcp: Only send extra TCP acks in eligible socket states

Matthieu Baerts (1):
      selftests: mptcp: clean tmp files in simult_flows

Michael Chan (4):
      bnxt_en: Fix 64-bit doorbell operation on 32-bit kernels
      bnxt_en: Fix asic.rev in devlink dev info command
      bnxt_en: Fix UDP tunnel logic
      bnxt_en: Fix possible unintended driver initiated error recovery

Nikolay Aleksandrov (1):
      net: bridge: mcast: fix vlan port router deadlock

Paolo Abeni (1):
      mptcp: fix possible divide by zero

Pavel Skripkin (1):
      netfilter: nft_ct: protect nft_ct_pcpu_template_refcnt with mutex

Rafał Miłecki (3):
      net: dsa: b53: Fix calculating number of switch ports
      net: dsa: b53: Set correct number of ports in the DSA struct
      net: dsa: b53: Fix IMP port setup on BCM5301x

Randy Dunlap (1):
      iwlwifi: fix printk format warnings in uefi.c

Russell King (Oracle) (1):
      net: phylink: add suspend/resume support

Ryoga Saito (1):
      Set fc_nlinfo in nh_create_ipv4, nh_create_ipv6

Shannon Nelson (1):
      ionic: fix double use of queue-lock

Smadar Fuks (1):
      octeontx2-af: Add additional register check to rvu_poll_reg()

Song Yoong Siang (1):
      net: stmmac: Fix overall budget calculation for rxtx_napi

Stefano Garzarella (1):
      MAINTAINERS: add VM SOCKETS (AF_VSOCK) entry

Tetsuo Handa (1):
      flow: fix object-size-mismatch warning in flowi{4,6}_to_flowi_common()

Tong Zhang (1):
      can: c_can: fix null-ptr-deref on ioctl()

Wan Jiabing (2):
      net: ixp46x: Remove duplicate include of module.h
      mptcp: Fix duplicated argument in protocol.h

Willem de Bruijn (2):
      ip_gre: validate csum_start only on pull
      ip6_gre: Revert "ip6_gre: add validation for csum_start"

Yang Li (1):
      ethtool: Fix an error code in cxgb2.c

Yoshihiro Shimoda (1):
      net: renesas: sh_eth: Fix freeing wrong tx descriptor

Ziyang Xuan (1):
      net: hso: add failure handler for add_net_device

chongjiapeng (1):
      net: hns3: make hclgevf_cmd_caps_bit_map0 and hclge_cmd_caps_bit_map0 static

zhaoxiao (1):
      stmmac: dwmac-loongson:Fix missing return value

王贇 (1):
      net: remove the unnecessary check in cipso_v4_doi_free

 Documentation/networking/nf_conntrack-sysctl.rst   |  13 +-
 MAINTAINERS                                        |  20 +-
 drivers/net/bonding/bond_3ad.c                     |   8 +-
 drivers/net/bonding/bond_main.c                    |  17 +-
 drivers/net/can/c_can/c_can_ethtool.c              |   4 +-
 drivers/net/can/rcar/rcar_canfd.c                  |   2 +-
 drivers/net/dsa/b53/b53_common.c                   |  34 ++-
 drivers/net/dsa/b53/b53_priv.h                     |   1 +
 drivers/net/dsa/lantiq_gswip.c                     |   3 +-
 drivers/net/ethernet/3com/3c59x.c                  |   2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  67 +++---
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |  37 ++--
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c  |  51 +++--
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h  |   4 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c     |  14 +-
 drivers/net/ethernet/chelsio/cxgb/cxgb2.c          |   1 +
 drivers/net/ethernet/chelsio/cxgb3/sge.c           |   3 +
 drivers/net/ethernet/cirrus/Kconfig                |   2 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c |   2 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c   |   2 +-
 drivers/net/ethernet/i825xx/sun3_82586.c           |   2 +-
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c    |   8 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |  17 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |   1 +
 drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c |  42 ++--
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   |   5 -
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |  28 +--
 .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  |   4 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |  12 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.h |   2 -
 .../net/ethernet/pensando/ionic/ionic_ethtool.c    |   5 +
 drivers/net/ethernet/pensando/ionic/ionic_lif.c    |  12 +-
 .../net/ethernet/pensando/ionic/ionic_rx_filter.c  |   2 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_init.c   |   1 -
 drivers/net/ethernet/qualcomm/emac/emac-ethtool.c  |   2 +-
 drivers/net/ethernet/renesas/sh_eth.c              |   1 +
 drivers/net/ethernet/smsc/smc911x.c                |  12 +-
 .../net/ethernet/stmicro/stmmac/dwmac-loongson.c   |   4 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  46 ++--
 drivers/net/ethernet/xscale/ptp_ixp46x.c           |   1 -
 drivers/net/phy/phylink.c                          |  82 +++++++
 drivers/net/usb/cdc_mbim.c                         |   5 +
 drivers/net/usb/hso.c                              |  11 +-
 drivers/net/usb/qmi_wwan.c                         |   1 +
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c     |   2 +-
 drivers/net/wireless/intel/iwlwifi/fw/pnvm.c       |   6 +-
 drivers/net/wireless/intel/iwlwifi/fw/uefi.c       |   4 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |   1 +
 drivers/net/wwan/iosm/iosm_ipc_mmio.c              |  30 +--
 include/linux/etherdevice.h                        |  12 ++
 include/linux/netdevice.h                          |  18 ++
 include/linux/netfilter/nf_conntrack_common.h      |   1 +
 include/linux/phylink.h                            |   3 +
 include/linux/soc/marvell/octeontx2/asm.h          |  11 +-
 include/net/flow.h                                 |   4 +-
 include/uapi/linux/netfilter/nfnetlink_conntrack.h |   1 +
 include/uapi/linux/pkt_sched.h                     |   2 +
 net/bridge/br_multicast.c                          |   4 +-
 net/core/pktgen.c                                  |   1 -
 net/core/skbuff.c                                  |   2 +-
 net/dsa/tag_rtl4_a.c                               |   7 +-
 net/ipv4/cipso_ipv4.c                              |  18 +-
 net/ipv4/ip_gre.c                                  |   9 +-
 net/ipv4/nexthop.c                                 |   2 +
 net/ipv6/addrconf.c                                |  28 ++-
 net/ipv6/ip6_gre.c                                 |   2 -
 net/ipv6/mcast.c                                   |  10 +-
 net/ipv6/netfilter/nf_socket_ipv6.c                |   4 +-
 net/ipv6/seg6_iptunnel.c                           |   2 +-
 net/mac802154/iface.c                              |   2 +-
 net/mptcp/pm_netlink.c                             |  10 +-
 net/mptcp/protocol.c                               |  97 ++++-----
 net/mptcp/protocol.h                               |   3 +-
 net/ncsi/internal.h                                |   3 +
 net/ncsi/ncsi-manage.c                             |  25 ++-
 net/ncsi/ncsi-pkt.h                                |   6 +
 net/ncsi/ncsi-rsp.c                                |  42 ++++
 net/netfilter/nf_conntrack_core.c                  | 103 +++++----
 net/netfilter/nf_conntrack_expect.c                |  25 ++-
 net/netfilter/nf_conntrack_netlink.c               |   4 +-
 net/netfilter/nf_conntrack_standalone.c            |   4 +-
 net/netfilter/nf_nat_core.c                        |  18 +-
 net/netfilter/nft_ct.c                             |   9 +-
 net/qrtr/qrtr.c                                    |   2 +-
 net/sched/sch_fq_codel.c                           |  12 +-
 net/tipc/socket.c                                  |   2 +-
 .../testing/selftests/bpf/prog_tests/xdp_bonding.c |  74 ++++++-
 tools/testing/selftests/net/Makefile               |   1 +
 tools/testing/selftests/net/gre_gso.sh             | 236 +++++++++++++++++++++
 tools/testing/selftests/net/mptcp/simult_flows.sh  |   4 +-
 90 files changed, 1068 insertions(+), 391 deletions(-)
 create mode 100755 tools/testing/selftests/net/gre_gso.sh
