Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 041B0362DD5
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 07:07:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbhDQFHc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Apr 2021 01:07:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:55174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229547AbhDQFHa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Apr 2021 01:07:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2FA966100B;
        Sat, 17 Apr 2021 05:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618636024;
        bh=qSBjz0b2IBA7Dnh5gZ6sz585Th5xe5X5U4mdt53y1Pg=;
        h=From:To:Cc:Subject:Date:From;
        b=B9WN3GqjBLjMCN5iqiez6keeaQmD6eZDnOoZyDa5aYQLGFKuUk8X+8Q8LnvGb/cAa
         98kvxG/In22gxsyEr4+fjM9sjIa5FfGUGeI8cbCK9hIESoJcT2XyJQtx7nP/2/4vyI
         Bvg4q+J+gNASaW9Lbm7tjWy1tgC9uanN+YLoxic01wQLAKH/GYusMDK5Px8o+g8KMR
         PWQP7t/WldkQHfqFwQC+tZK1Jl2oBNbqM0tTuUxwPrGlPzjWoOfLt6EC/+efWv0sil
         R4fwV5Jc1UCkLApBiAUDcCaE/wQ4/FA4RNkxSCZWcC9CXhpQekdUeCmXAb7JvwkLT4
         yp65OVDdNy7Ew==
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Networking for 5.12-rc8
Date:   Fri, 16 Apr 2021 22:07:03 -0700
Message-Id: <20210417050703.610514-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following changes since commit 4e04e7513b0fa2fe8966a1c83fb473f1667e2810:

  Merge tag 'net-5.12-rc7' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2021-04-09 15:26:51 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.12-rc8

for you to fetch changes up to f2764bd4f6a8dffaec3e220728385d9756b3c2cb:

  netlink: don't call ->netlink_bind with table lock held (2021-04-16 17:01:04 -0700)

----------------------------------------------------------------
Networking fixes for 5.12-rc8, including fixes from netfilter,
and bpf. BPF verifier changes stand out, otherwise things have
slowed down.

Current release - regressions:

 - gro: ensure frag0 meets IP header alignment

 - Revert "net: stmmac: re-init rx buffers when mac resume back"

 - ethernet: macb: fix the restore of cmp registers

Previous releases - regressions:

 - ixgbe: Fix NULL pointer dereference in ethtool loopback test

 - ixgbe: fix unbalanced device enable/disable in suspend/resume

 - phy: marvell: fix detection of PHY on Topaz switches

 - make tcp_allowed_congestion_control readonly in non-init netns

 - xen-netback: Check for hotplug-status existence before watching

Previous releases - always broken:

 - bpf: mitigate a speculative oob read of up to map value size by
        tightening the masking window

 - sctp: fix race condition in sctp_destroy_sock

 - sit, ip6_tunnel: Unregister catch-all devices

 - netfilter: nftables: clone set element expression template

 - netfilter: flowtable: fix NAT IPv6 offload mangling

 - net: geneve: check skb is large enough for IPv4/IPv6 header

 - netlink: don't call ->netlink_bind with table lock held

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Alexander Duyck (1):
      ixgbe: Fix NULL pointer dereference in ethtool loopback test

Aya Levin (2):
      net/mlx5: Fix setting of devlink traps in switchdev mode
      net/mlx5e: Fix setting of RS FEC mode

Christophe JAILLET (1):
      net: davicom: Fix regulator not turned off on failed probe

Ciara Loftus (1):
      libbpf: Fix potential NULL pointer dereference

Claudiu Beznea (1):
      net: macb: fix the restore of cmp registers

Colin Ian King (1):
      ice: Fix potential infinite loop when using u8 loop counter

Daniel Borkmann (9):
      bpf: Use correct permission flag for mixed signed bounds arithmetic
      bpf: Move off_reg into sanitize_ptr_alu
      bpf: Ensure off_reg has no mixed signed bounds for all types
      bpf: Rework ptr_limit into alu_limit and add common error path
      bpf: Improve verifier error messages for users
      bpf: Refactor and streamline bounds check into helper
      bpf: Move sanitize_val_alu out of op switch
      bpf: Tighten speculative pointer arithmetic mask
      bpf: Update selftests to reflect new error states

David S. Miller (7):
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf
      Merge branch 'catch-all-devices'
      Merge branch 'ibmvnic-napi-fixes'
      Merge branch '10GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue
      Merge tag 'mlx5-fixes-2021-04-14' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge branch 'ch_tlss-fixes'
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf

Eric Dumazet (2):
      netfilter: nft_limit: avoid possible divide error in nft_limit_init
      gro: ensure frag0 meets IP header alignment

Florian Westphal (4):
      netfilter: bridge: add pre_exit hooks for ebtable unregistration
      netfilter: arp_tables: add pre_exit hook for table unregister
      netfilter: x_tables: fix compat match/target pad out-of-bound write
      netlink: don't call ->netlink_bind with table lock held

Heiner Kallweit (1):
      r8169: don't advertise pause in jumbo mode

Hristo Venev (2):
      net: sit: Unregister catch-all devices
      net: ip6_tunnel: Unregister catch-all devices

Jakub Kicinski (2):
      ethtool: fix kdoc attr name
      ethtool: pause: make sure we init driver stats

Jason Xing (1):
      i40e: fix the panic when running bpf in xdpdrv mode

Joakim Zhang (1):
      MAINTAINERS: update maintainer entry for freescale fec driver

Jonathon Reinhart (1):
      net: Make tcp_allowed_congestion_control readonly in non-init netns

Lijun Pan (5):
      ibmvnic: correctly use dev_consume/free_skb_irq
      ibmvnic: avoid calling napi_disable() twice
      ibmvnic: remove duplicate napi_schedule call in do_reset function
      ibmvnic: remove duplicate napi_schedule call in open function
      MAINTAINERS: update my email

Michael Brown (1):
      xen-netback: Check for hotplug-status existence before watching

Nicolas Dichtel (2):
      doc: move seg6_flowlabel to seg6-sysctl.rst
      vrf: fix a comment about loopback device

Or Cohen (1):
      net/sctp: fix race condition in sctp_destroy_sock

Pablo Neira Ayuso (3):
      netfilter: flowtable: fix NAT IPv6 offload mangling
      netfilter: conntrack: do not print icmpv6 as unknown via /proc
      netfilter: nftables: clone set element expression template

Pali Rohár (1):
      net: phy: marvell: fix detection of PHY on Topaz switches

Phillip Potter (1):
      net: geneve: check skb is large enough for IPv4/IPv6 header

Thierry Reding (1):
      Revert "net: stmmac: re-init rx buffers when mac resume back"

Vinay Kumar Yadav (4):
      ch_ktls: Fix kernel panic
      ch_ktls: fix device connection close
      ch_ktls: tcb close causes tls connection failure
      ch_ktls: do not send snd_una update to TCB in middle

Wan Jiabing (1):
      cavium/liquidio: Fix duplicate argument

Yongxin Liu (1):
      ixgbe: fix unbalanced device enable/disable in suspend/resume

wenxu (1):
      net/mlx5e: fix ingress_ifindex check in mlx5e_flower_parse_meta

 Documentation/networking/ip-sysctl.rst             |  15 --
 Documentation/networking/seg6-sysctl.rst           |  13 ++
 MAINTAINERS                                        |   4 +-
 drivers/net/dsa/mv88e6xxx/chip.c                   |  30 ++-
 drivers/net/ethernet/cadence/macb_main.c           |   2 +-
 drivers/net/ethernet/cavium/liquidio/cn66xx_regs.h |   2 +-
 .../chelsio/inline_crypto/ch_ktls/chcr_ktls.c      | 102 +--------
 drivers/net/ethernet/davicom/dm9000.c              |   6 +-
 drivers/net/ethernet/ibm/ibmvnic.c                 |  25 +--
 drivers/net/ethernet/intel/i40e/i40e_main.c        |   6 +
 drivers/net/ethernet/intel/ice/ice_dcb.c           |   4 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |  14 +-
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c  |   5 +
 drivers/net/ethernet/mellanox/mlx5/core/en/port.c  |  23 +--
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |   3 +
 drivers/net/ethernet/realtek/r8169_main.c          |   9 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  84 +-------
 drivers/net/geneve.c                               |   6 +
 drivers/net/phy/marvell.c                          |  32 ++-
 drivers/net/vrf.c                                  |  10 +-
 drivers/net/xen-netback/xenbus.c                   |  12 +-
 include/linux/marvell_phy.h                        |   5 +-
 include/linux/netfilter_arp/arp_tables.h           |   5 +-
 include/linux/netfilter_bridge/ebtables.h          |   5 +-
 kernel/bpf/verifier.c                              | 230 ++++++++++++++-------
 net/bridge/netfilter/ebtable_broute.c              |   8 +-
 net/bridge/netfilter/ebtable_filter.c              |   8 +-
 net/bridge/netfilter/ebtable_nat.c                 |   8 +-
 net/bridge/netfilter/ebtables.c                    |  30 ++-
 net/core/dev.c                                     |   3 +-
 net/ethtool/netlink.h                              |   6 +-
 net/ethtool/pause.c                                |   8 +-
 net/ipv4/netfilter/arp_tables.c                    |  11 +-
 net/ipv4/netfilter/arptable_filter.c               |  10 +-
 net/ipv4/netfilter/ip_tables.c                     |   2 +
 net/ipv4/sysctl_net_ipv4.c                         |  16 +-
 net/ipv6/ip6_tunnel.c                              |  10 +
 net/ipv6/netfilter/ip6_tables.c                    |   2 +
 net/ipv6/sit.c                                     |   4 +-
 net/netfilter/nf_conntrack_standalone.c            |   1 +
 net/netfilter/nf_flow_table_offload.c              |   6 +-
 net/netfilter/nf_tables_api.c                      |  46 +++--
 net/netfilter/nft_limit.c                          |   4 +-
 net/netfilter/x_tables.c                           |  10 +-
 net/netlink/af_netlink.c                           |   4 +-
 net/sctp/socket.c                                  |  13 +-
 tools/lib/bpf/xsk.c                                |   5 +-
 tools/testing/selftests/bpf/verifier/bounds.c      |   5 -
 .../selftests/bpf/verifier/bounds_deduction.c      |  21 +-
 .../bpf/verifier/bounds_mix_sign_unsign.c          |  13 --
 tools/testing/selftests/bpf/verifier/map_ptr.c     |   4 +-
 tools/testing/selftests/bpf/verifier/unpriv.c      |   2 +-
 .../selftests/bpf/verifier/value_ptr_arith.c       |   6 +-
 53 files changed, 479 insertions(+), 439 deletions(-)
