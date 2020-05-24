Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD1021DFC10
	for <lists+netdev@lfdr.de>; Sun, 24 May 2020 02:09:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388167AbgEXAG4 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 23 May 2020 20:06:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388094AbgEXAG4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 May 2020 20:06:56 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8572C061A0E;
        Sat, 23 May 2020 17:06:55 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 467A212873833;
        Sat, 23 May 2020 17:06:55 -0700 (PDT)
Date:   Sat, 23 May 2020 17:06:54 -0700 (PDT)
Message-Id: <20200523.170654.66302705884131064.davem@davemloft.net>
To:     torvalds@linux-foundation.org
CC:     akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From:   David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 23 May 2020 17:06:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


1) Fix RCU warnings in ipv6 multicast router code, from Madhuparna Bhowmik.

2) Nexthop attributes aren't being checked properly because of
   mis-initialized iterator, from David Ahern.

3) Revert iop_idents_reserve() change as it caused performance
   regressions and was just working around what is really a UBSAN bug
   in the compiler.  From Yuqi Jin.

4) Read MAC address properly from ROM in bmac driver (double iteration
   proceeds past end of address array), from Jeremy Kerr.

5) Add Microsoft Surface device IDs to r8152, from Marc Payne.

6) Prevent reference to freed SKB in __netif_receive_skb_core(), from
   Boris Sukholitko.

7) Fix ACK discard behavior in rxrpc, from David Howells.

8) Preserve flow hash across packet scrubbing in wireguard, from
   Jason A. Donenfeld.

9) Cap option length properly for SO_BINDTODEVICE in AX25, from Eric
   Dumazet.

10) Fix encryption error checking in kTLS code, from Vadim Fedorenko.

11) Missing BPF prog ref release in flow dissector, from Jakub
    Sitnicki.

12) dst_cache must be used with BH disabled in tipc, from Eric Dumazet.

13) Fix use after free in mlxsw driver, from Jiri Pirko.

14) Order kTLS key destruction properly in mlx5 driver, from Tariq
    Toukan.

15) Check devm_platform_ioremap_resource() return value properly in several
    drivers, from Tiezhu Yang.

Please pull, thanks a lot!

The following changes since commit f85c1598ddfe83f61d0656bd1d2025fa3b148b99:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2020-05-15 13:10:06 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git 

for you to fetch changes up to 539d39ad0c61b35f69565a037d7586deaf6d6166:

  net: smsc911x: Fix runtime PM imbalance on error (2020-05-23 16:52:17 -0700)

----------------------------------------------------------------
Alex Elder (1):
      net: ipa: don't be a hog in gsi_channel_poll()

Amit Cohen (1):
      selftests: mlxsw: qos_mc_aware: Specify arping timeout as an integer

Andrii Nakryiko (1):
      bpf: Prevent mmap()'ing read-only maps as writable

Antoine Tenart (1):
      net: phy: mscc: fix initialization of the MACsec protocol mode

Boris Sukholitko (1):
      __netif_receive_skb_core: pass skb by reference

Claudiu Manoil (1):
      felix: Fix initialization of ioremap resources

DENG Qingfang (1):
      net: dsa: mt7530: fix roaming from DSA user ports

David Ahern (1):
      nexthop: Fix attribute checking for groups

David Howells (4):
      rxrpc: Fix the excessive initial retransmission timeout
      rxrpc: Trace discarded ACKs
      rxrpc: Fix ack discard
      rxrpc: Fix a warning

David S. Miller (10):
      Merge tag 'wireless-drivers-2020-05-19' of git://git.kernel.org/.../kvalo/wireless-drivers
      Merge branch 'wireguard-fixes'
      Merge branch 'net-ethernet-ti-fix-some-return-value-check'
      Merge branch 'net-tls-fix-encryption-error-path'
      Merge git://git.kernel.org/.../bpf/bpf
      Merge tag 'rxrpc-fixes-20200520' of git://git.kernel.org/.../dhowells/linux-fs
      Merge branch 'netdevsim-Two-small-fixes'
      Merge branch 'mlxsw-Various-fixes'
      Merge tag 'rxrpc-fixes-20200523-v2' of git://git.kernel.org/.../dhowells/linux-fs
      Merge tag 'mlx5-fixes-2020-05-22' of git://git.kernel.org/.../saeed/linux

Dinghao Liu (1):
      net: smsc911x: Fix runtime PM imbalance on error

Eran Ben Elisha (2):
      net/mlx5: Fix a race when moving command interface to events mode
      net/mlx5: Avoid processing commands before cmdif is ready

Eric Dumazet (2):
      ax25: fix setsockopt(SO_BINDTODEVICE)
      tipc: block BH before using dst_cache

Grygorii Strashko (1):
      net: ethernet: ti: cpsw: fix ASSERT_RTNL() warning during suspend

Heiner Kallweit (1):
      r8169: fix OCP access on RTL8117

Ido Schimmel (2):
      netdevsim: Ensure policer drop counter always increases
      selftests: netdevsim: Always initialize 'RET' variable

Jakub Sitnicki (1):
      flow_dissector: Drop BPF flow dissector prog ref on netns cleanup

Jason A. Donenfeld (4):
      wireguard: selftests: use newer iproute2 for gcc-10
      wireguard: noise: read preshared key while taking lock
      wireguard: queueing: preserve flow hash across packet scrubbing
      wireguard: noise: separate receive counter from send counter

Jere Leppänen (1):
      sctp: Start shutdown on association restart if in SHUTDOWN-SENT state and socket is closed

Jeremy Kerr (1):
      net: bmac: Fix read of MAC address from ROM

Jiri Pirko (1):
      mlxsw: spectrum: Fix use-after-free of split/unsplit/type_set in case reload fails

Jonathan McDowell (1):
      net: ethernet: stmmac: Enable interface clocks on probe for IPQ806x

KP Singh (1):
      security: Fix hook iteration for secid_to_secctx

Kurt Kanzenbach (1):
      dt-bindings: net: dsa: b53: Add missing size and address cells to example

Leon Romanovsky (1):
      net: phy: propagate an error back to the callers of phy_sfp_probe

Leon Yu (1):
      net: stmmac: don't attach interface until resume finishes

Luca Coelho (1):
      iwlwifi: pcie: handle QuZ configs with killer NICs as well

Madhuparna Bhowmik (1):
      ipv6: Fix suspicious RCU usage warning in ip6mr

Manivannan Sadhasivam (1):
      net: qrtr: Fix passing invalid reference to qrtr_local_enqueue()

Maor Dickman (1):
      net/mlx5e: Fix allowed tc redirect merged eswitch offload cases

Marc Payne (1):
      r8152: support additional Microsoft Surface Ethernet Adapter variant

Martin KaFai Lau (1):
      net: inet_csk: Fix so_reuseport bind-address cache in tb->fast*

Michal Kubecek (1):
      ethtool: count header size in reply size estimate

Moshe Shemesh (3):
      net/mlx5: Add command entry handling completion
      net/mlx5: Fix memory leak in mlx5_events_init
      net/mlx5e: Update netdev txq on completions during closure

Neil Horman (1):
      sctp: Don't add the shutdown timer if its already been added

Qiushi Wu (3):
      net: sun: fix missing release regions in cas_init_one().
      rxrpc: Fix a memory leak in rxkad_verify_response()
      net/mlx4_core: fix a memory leak bug.

Roi Dayan (5):
      net/mlx5e: Fix inner tirs handling
      net/mlx5: Fix cleaning unmanaged flow tables
      net/mlx5: Don't maintain a case of del_sw_func being null
      net/mlx5: Annotate mutex destroy for root ns
      net/mlx5e: CT: Correctly get flow rule

Roman Mashak (1):
      net sched: fix reporting the first-time use timestamp

Russell King (1):
      net: mvpp2: fix RX hashing for non-10G ports

Sabrina Dubroca (1):
      net: don't return invalid table id error when we fall back to PF_UNSPEC

Shay Drory (1):
      net/mlx5: Fix error flow in case of function_setup failure

Stephen Worley (1):
      net: nlmsg_cancel() if put fails for nhmsg

Tang Bin (1):
      net: sgi: ioc3-eth: Fix return value check in ioc3eth_probe()

Tariq Toukan (1):
      net/mlx5e: kTLS, Destroy key object after destroying the TIS

Tiezhu Yang (1):
      net: Fix return value about devm_platform_ioremap_resource()

Todd Malsbary (2):
      mptcp: use rightmost 64 bits in ADD_ADDR HMAC
      mptcp: use untruncated hash in ADD_ADDR HMAC

Vadim Fedorenko (3):
      net/tls: fix encryption error checking
      net/tls: free record only on encryption error
      net: ipip: fix wrong address family in init error path

Valentin Longchamp (1):
      net/ethernet/freescale: rework quiesce/activate for ucc_geth

Vladimir Oltean (1):
      net: mscc: ocelot: fix address ageing time (again)

Wei Yongjun (2):
      net: ethernet: ti: fix some return value check of cpsw_ale_create()
      net: ethernet: ti: am65-cpsw-nuss: fix error handling of am65_cpsw_nuss_probe

Yuqi Jin (1):
      net: revert "net: get rid of an signed integer overflow in ip_idents_reserve()"

 Documentation/devicetree/bindings/net/dsa/b53.txt             |   3 +
 drivers/net/can/ifi_canfd/ifi_canfd.c                         |   5 +-
 drivers/net/can/sun4i_can.c                                   |   2 +-
 drivers/net/dsa/b53/b53_srab.c                                |   2 +-
 drivers/net/dsa/mt7530.c                                      |   9 +--
 drivers/net/dsa/mt7530.h                                      |   1 +
 drivers/net/dsa/ocelot/felix.c                                |  23 ++++---
 drivers/net/dsa/ocelot/felix.h                                |   6 +-
 drivers/net/dsa/ocelot/felix_vsc9959.c                        |  22 +++----
 drivers/net/ethernet/apple/bmac.c                             |   2 +-
 drivers/net/ethernet/freescale/ucc_geth.c                     |  13 ++--
 drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c                |   2 +-
 drivers/net/ethernet/marvell/pxa168_eth.c                     |   2 +-
 drivers/net/ethernet/mellanox/mlx4/fw.c                       |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c                 |  59 +++++++++++++++--
 drivers/net/ethernet/mellanox/mlx5/core/en.h                  |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c            |   5 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h            |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c       |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c             |  12 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c              |  12 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.h              |   7 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c               |  40 ++++++++++--
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c               |   9 ++-
 drivers/net/ethernet/mellanox/mlx5/core/eq.c                  |   3 +
 drivers/net/ethernet/mellanox/mlx5/core/events.c              |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c             |  30 +++++----
 drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c         |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c                |   7 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c                |  14 +++-
 drivers/net/ethernet/mellanox/mlxsw/switchx2.c                |   8 +++
 drivers/net/ethernet/mscc/ocelot.c                            |   2 +-
 drivers/net/ethernet/realtek/r8169_main.c                     |  17 ++++-
 drivers/net/ethernet/sgi/ioc3-eth.c                           |   8 +--
 drivers/net/ethernet/smsc/smsc911x.c                          |   9 +--
 drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c           |  13 ++++
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c             |   4 +-
 drivers/net/ethernet/sun/cassini.c                            |   3 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c                      |   3 +-
 drivers/net/ethernet/ti/cpsw.c                                |   4 ++
 drivers/net/ethernet/ti/cpsw_ale.c                            |   2 +-
 drivers/net/ethernet/ti/cpsw_priv.c                           |   4 +-
 drivers/net/ethernet/ti/netcp_ethss.c                         |   4 +-
 drivers/net/ipa/gsi.c                                         |   1 +
 drivers/net/netdevsim/dev.c                                   |   3 +-
 drivers/net/phy/mscc/mscc.h                                   |   2 +
 drivers/net/phy/mscc/mscc_mac.h                               |   6 +-
 drivers/net/phy/mscc/mscc_macsec.c                            |  16 +++--
 drivers/net/phy/mscc/mscc_macsec.h                            |   3 +-
 drivers/net/phy/mscc/mscc_main.c                              |   4 ++
 drivers/net/phy/phy_device.c                                  |   4 +-
 drivers/net/usb/cdc_ether.c                                   |  11 +++-
 drivers/net/usb/r8152.c                                       |   1 +
 drivers/net/wireguard/messages.h                              |   2 +-
 drivers/net/wireguard/noise.c                                 |  22 +++----
 drivers/net/wireguard/noise.h                                 |  14 ++--
 drivers/net/wireguard/queueing.h                              |  10 ++-
 drivers/net/wireguard/receive.c                               |  44 ++++++-------
 drivers/net/wireguard/selftest/counter.c                      |  17 +++--
 drivers/net/wireguard/send.c                                  |  19 +++---
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c                 |   4 ++
 fs/afs/fs_probe.c                                             |  18 ++----
 fs/afs/vl_probe.c                                             |  18 ++----
 include/linux/mlx5/driver.h                                   |  16 +++++
 include/net/act_api.h                                         |   3 +-
 include/net/af_rxrpc.h                                        |   2 +-
 include/net/ip_fib.h                                          |   1 -
 include/trace/events/rxrpc.h                                  |  52 ++++++++++++---
 kernel/bpf/syscall.c                                          |  17 ++++-
 net/ax25/af_ax25.c                                            |   6 +-
 net/core/dev.c                                                |  20 ++++--
 net/core/flow_dissector.c                                     |  26 ++++++--
 net/dsa/tag_mtk.c                                             |  15 +++++
 net/ethtool/netlink.c                                         |   4 +-
 net/ethtool/strset.c                                          |   1 -
 net/ipv4/fib_frontend.c                                       |   3 +-
 net/ipv4/inet_connection_sock.c                               |  43 +++++++------
 net/ipv4/ipip.c                                               |   2 +-
 net/ipv4/ipmr.c                                               |   2 +-
 net/ipv4/nexthop.c                                            |   3 +-
 net/ipv4/route.c                                              |  14 ++--
 net/ipv6/ip6_fib.c                                            |   2 +-
 net/ipv6/ip6mr.c                                              |   5 +-
 net/mptcp/crypto.c                                            |  24 +++----
 net/mptcp/options.c                                           |   9 +--
 net/mptcp/protocol.h                                          |   1 -
 net/mptcp/subflow.c                                           |  15 +++--
 net/qrtr/qrtr.c                                               |   2 +-
 net/rxrpc/Makefile                                            |   1 +
 net/rxrpc/ar-internal.h                                       |  25 +++++---
 net/rxrpc/call_accept.c                                       |   2 +-
 net/rxrpc/call_event.c                                        |  22 +++----
 net/rxrpc/input.c                                             |  44 +++++++++++--
 net/rxrpc/misc.c                                              |   5 --
 net/rxrpc/output.c                                            |   9 +--
 net/rxrpc/peer_event.c                                        |  46 -------------
 net/rxrpc/peer_object.c                                       |  12 ++--
 net/rxrpc/proc.c                                              |   8 +--
 net/rxrpc/rtt.c                                               | 195 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 net/rxrpc/rxkad.c                                             |   3 +-
 net/rxrpc/sendmsg.c                                           |  26 +++-----
 net/rxrpc/sysctl.c                                            |   9 ---
 net/sctp/sm_sideeffect.c                                      |  14 +++-
 net/sctp/sm_statefuns.c                                       |   9 +--
 net/tipc/udp_media.c                                          |   6 +-
 net/tls/tls_sw.c                                              |  17 +++--
 security/security.c                                           |  16 ++++-
 tools/testing/selftests/bpf/prog_tests/mmap.c                 |  13 +++-
 tools/testing/selftests/bpf/progs/test_mmap.c                 |   8 +++
 tools/testing/selftests/drivers/net/mlxsw/qos_mc_aware.sh     |   2 +-
 tools/testing/selftests/drivers/net/netdevsim/devlink_trap.sh |   4 ++
 tools/testing/selftests/wireguard/qemu/Makefile               |   2 +-
 112 files changed, 940 insertions(+), 454 deletions(-)
 create mode 100644 net/rxrpc/rtt.c
