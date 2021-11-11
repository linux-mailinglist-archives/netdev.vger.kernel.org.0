Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE2EE44DA89
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 17:33:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234245AbhKKQgE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 11:36:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:46894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234185AbhKKQgD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Nov 2021 11:36:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EDE9F61252;
        Thu, 11 Nov 2021 16:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636648394;
        bh=fxa0SiPymvceVau7hlxDituyficBURVk7mxizEUap/A=;
        h=From:To:Cc:Subject:Date:From;
        b=sU4ZKMEUWG9QK521gaMh4buJAGK6By/I4ALTrDShM/SH7247tYno3JuGKByEdNh9i
         Bx7nRNs9uMc+f3kNiD+UIa5FxZD3VlgynEhGEdIrvdPaOg5Q2DZn3ZGz0OEN2k8CeR
         1EM/7jsnucb1G5ZSla1VywoQFMY26z238afBMDKPR/DYdH+4opl6ZRXYaL8KpwnXJ7
         39sf70JNiqqvkdJjGBw2Ejp8N4lElDNZts8NYm8v2PyyugYckLyRgQ6L4xX6939UP2
         04GFbcHFdNjSiM2s1pSWSDCHgjJ1SzLfeuRYaol3o3Ud5ADbGNxdwEkm8IrLgHBeMw
         PcjtggcIk0yeQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        netfilter-devel@vger.kernel.org, linux-can@vger.kernel.org
Subject: [GIT PULL] Networking for 5.16-rc1
Date:   Thu, 11 Nov 2021 08:33:01 -0800
Message-Id: <20211111163301.1930617-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus!

The following changes since commit cc0356d6a02e064387c16a83cb96fe43ef33181e:

  Merge tag 'x86_core_for_v5.16_rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip (2021-11-02 07:56:47 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.16-rc1

for you to fetch changes up to d336509cb9d03970911878bb77f0497f64fda061:

  selftests/net: udpgso_bench_rx: fix port argument (2021-11-11 12:24:26 +0000)

----------------------------------------------------------------
Networking fixes for 5.16-rc1, including fixes from bpf, can
and netfilter.

Current release - regressions:

 - bpf: do not reject when the stack read size is different
   from the tracked scalar size

 - net: fix premature exit from NAPI state polling in napi_disable()

 - riscv, bpf: fix RV32 broken build, and silence RV64 warning

Current release - new code bugs:

 - net: fix possible NULL deref in sock_reserve_memory

 - amt: fix error return code in amt_init(); fix stopping the workqueue

 - ax88796c: use the correct ioctl callback

Previous releases - always broken:

 - bpf: stop caching subprog index in the bpf_pseudo_func insn

 - security: fixups for the security hooks in sctp

 - nfc: add necessary privilege flags in netlink layer, limit operations
   to admin only

 - vsock: prevent unnecessary refcnt inc for non-blocking connect

 - net/smc: fix sk_refcnt underflow on link down and fallback

 - nfnetlink_queue: fix OOB when mac header was cleared

 - can: j1939: ignore invalid messages per standard

 - bpf, sockmap:
   - fix race in ingress receive verdict with redirect to self
   - fix incorrect sk_skb data_end access when src_reg = dst_reg
   - strparser, and tls are reusing qdisc_skb_cb and colliding

 - ethtool: fix ethtool msg len calculation for pause stats

 - vlan: fix a UAF in vlan_dev_real_dev() when ref-holder tries
   to access an unregistering real_dev

 - udp6: make encap_rcv() bump the v6 not v4 stats

 - drv: prestera: add explicit padding to fix m68k build

 - drv: felix: fix broken VLAN-tagged PTP under VLAN-aware bridge

 - drv: mvpp2: fix wrong SerDes reconfiguration order

Misc & small latecomers:

 - ipvs: auto-load ipvs on genl access

 - mctp: sanity check the struct sockaddr_mctp padding fields

 - libfs: support RENAME_EXCHANGE in simple_rename()

 - avoid double accounting for pure zerocopy skbs

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Aleksander Jan Bajkowski (1):
      net: ethernet: lantiq_etop: Fix compilation error

Alexander Lobakin (1):
      net: fix premature exit from NAPI state polling in napi_disable()

Alexei Starovoitov (1):
      Merge branch 'bpf: Fix out-of-bound issue when jit-ing bpf_pseudo_func'

Alexey Khoroshilov (1):
      sctp: remove unreachable code from sctp_sf_violation_chunk()

Anders Roxell (1):
      selftests: net: tls: remove unused variable and code

Andrea Righi (2):
      selftests: net: properly support IPv6 in GSO GRE test
      selftests: net: test_vxlan_under_vrf: fix HV connectivity test

Andrii Nakryiko (1):
      selftests/bpf: Make netcnt selftests serial to avoid spurious failures

Ansuel Smith (1):
      net: dsa: qca8k: make sure PAD0 MAC06 exchange is disabled

Arnd Bergmann (4):
      octeontx2-pf: select CONFIG_NET_DEVLINK
      ax88796c: fix ioctl callback
      octeontx2-nicvf: fix ioctl callback
      amt: add IPV6 Kconfig dependency

Björn Töpel (1):
      riscv, bpf: Fix RV32 broken build, and silence RV64 warning

Brett Creeley (4):
      ice: Fix VF true promiscuous mode
      ice: Remove toggling of antispoof for VF trusted promiscuous mode
      ice: Fix not stopping Tx queues for VFs
      ice: Fix race conditions between virtchnl handling and VF ndo ops

Chengfeng Ye (1):
      nfc: pn533: Fix double free when pn533_fill_fragment_skbs() fails

Christophe JAILLET (2):
      litex_liteeth: Fix a double free in the remove function
      net: ethernet: ti: cpsw_ale: Fix access to un-initialized memory

Colin Ian King (1):
      net: mana: Fix spelling mistake "calledd" -> "called"

Dan Carpenter (3):
      gve: Fix off by one in gve_tx_timeout()
      gve: fix unmatched u64_stats_update_end()
      net/mlx5: Lag, fix a potential Oops with mlx5_lag_create_definer()

David S. Miller (4):
      Merge branch 'kselftests-net-missing'
      Merge branch 'sctp-=security-hook-fixes'
      Merge tag 'linux-can-fixes-for-5.16-20211106' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can
      Merge branch 'hns3-fixes'

Dust Li (1):
      net/smc: fix sk_refcnt underflow on linkdown and fallback

Eiichi Tsukata (1):
      vsock: prevent unnecessary refcnt inc for nonblocking connect

Eric Dumazet (4):
      net: add and use skb_unclone_keeptruesize() helper
      net: fix possible NULL deref in sock_reserve_memory
      llc: fix out-of-bound array index in llc_sk_dev_hash()
      net/sched: sch_taprio: fix undefined behavior in ktime_mono_to_any

Eugene Syromiatnikov (2):
      mctp: handle the struct sockaddr_mctp padding fields
      mctp: handle the struct sockaddr_mctp_ext padding field

Florian Westphal (1):
      netfilter: nfnetlink_queue: fix OOB when mac header was cleared

Geert Uytterhoeven (1):
      net: marvell: prestera: Add explicit padding

Guangbin Huang (4):
      net: hns3: fix failed to add reuse multicast mac addr to hardware when mc mac table is full
      net: hns3: fix some mac statistics is always 0 in device version V2
      net: hns3: remove check VF uc mac exist when set by PF
      net: hns3: allow configure ETS bandwidth of all TCs

Guo Zhengkui (1):
      devlink: fix flexible_array.cocci warning

Hangbin Liu (9):
      kselftests/net: add missed icmp.sh test to Makefile
      kselftests/net: add missed setup_loopback.sh/setup_veth.sh to Makefile
      kselftests/net: add missed SRv6 tests
      kselftests/net: add missed vrf_strict_mode_test.sh test to Makefile
      kselftests/net: add missed toeplitz.sh/toeplitz_client.sh to Makefile
      selftests/bpf/xdp_redirect_multi: Put the logs to tmp folder
      selftests/bpf/xdp_redirect_multi: Use arping to accurate the arp number
      selftests/bpf/xdp_redirect_multi: Give tcpdump a chance to terminate cleanly
      selftests/bpf/xdp_redirect_multi: Limit the tests in netns

Heiner Kallweit (1):
      net: phy: fix duplex out of sync problem while changing settings

Huang Guobin (1):
      bonding: Fix a use-after-free problem when bond_sysfs_slave_add() failed

Jakub Kicinski (7):
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf
      ethtool: fix ethtool msg len calculation for pause stats
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue
      Merge branch 'mctp-sockaddr-padding-check-initialisation-fixup'
      net: ax88796c: hide ax88796c_dt_ids if !CONFIG_OF
      Merge https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf
      Merge https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf

Jean Sacren (1):
      net: sungem_phy: fix code indentation

Jiapeng Chong (1):
      amt: Remove duplicate include

Jie Wang (2):
      net: hns3: fix ROCE base interrupt vector initialization bug
      net: hns3: fix pfc packet number incorrect after querying pfc parameters

John Fastabend (4):
      bpf, sockmap: Use stricter sk state checks in sk_lookup_assign
      bpf, sockmap: Remove unhash handler for BPF sockmap usage
      bpf, sockmap: Fix race in ingress receive verdict with redirect to self
      bpf: sockmap, strparser, and tls are reusing qdisc_skb_cb and colliding

Jussi Maki (1):
      bpf, sockmap: sk_skb data_end access incorrect when src_reg = dst_reg

Kleber Sacilotto de Souza (1):
      selftests/net: Fix reuseport_bpf_numa by skipping unavailable nodes

Krzysztof Kozlowski (1):
      nfc: port100: lower verbosity of cancelled URB messages

Leonard Crestez (1):
      tcp: Use BIT() for OPTION_* constants

Lin Ma (3):
      NFC: add necessary privilege flags in netlink layer
      hamradio: defer ax25 kfree after unregister_netdev
      hamradio: defer 6pack kfree after unregister_netdev

Lorenz Bauer (4):
      libfs: Move shmem_exchange to simple_rename_exchange
      libfs: Support RENAME_EXCHANGE in simple_rename()
      selftests/bpf: Convert test_bpffs to ASSERT macros
      selftests/bpf: Test RENAME_EXCHANGE and RENAME_NOREPLACE on bpffs

M Chetan Kumar (1):
      net: wwan: iosm: fix compilation warning

Marc Kleine-Budde (2):
      can: mcp251xfd: mcp251xfd_irq(): add missing can_rx_offload_threaded_irq_finish() in case of bus off
      can: mcp251xfd: mcp251xfd_chip_start(): fix error handling for mcp251xfd_chip_rx_int_enable()

Marek Behún (2):
      net: dsa: mv88e6xxx: Don't support >1G speeds on 6191X on ports other than 10
      net: marvell: mvpp2: Fix wrong SerDes reconfiguration order

Martin KaFai Lau (4):
      bpf: Do not reject when the stack read size is different from the tracked scalar size
      selftests/bpf: Verifier test on refill from a smaller spill
      bpf: Stop caching subprog index in the bpf_pseudo_func insn
      bpf: selftest: Trigger a DCE on the whole subprog

Maxim Kiselev (1):
      net: davinci_emac: Fix interrupt pacing disable

Mehrdad Arshad Rad (1):
      libbpf: Fix lookup_and_delete_elem_flags error reporting

Menglong Dong (2):
      net: udp6: replace __UDP_INC_STATS() with __UDP6_INC_STATS()
      net: udp: correct the document for udp_mem

Nghia Le (1):
      ipv6: remove useless assignment to newinet in tcp_v6_syn_recv_sock()

Petr Machata (1):
      selftests: forwarding: Fix packet matching in mirroring selftests

Quentin Monnet (1):
      bpftool: Install libbpf headers for the bootstrap version, too

Rahul Lakkireddy (1):
      cxgb4: fix eeprom len when diagnostics not implemented

Randy Dunlap (1):
      net: hisilicon: fix hsn3_ethtool kernel-doc warnings

Shay Agroskin (1):
      MAINTAINERS: Update ENA maintainers information

Stephane Grosjean (2):
      can: peak_usb: always ask for BERR reporting for PCAN-USB devices
      can: peak_usb: exchange the order of information messages

Sylwester Dziedziuch (1):
      ice: Fix replacing VF hardware MAC to existing MAC filter

Taehee Yoo (1):
      amt: use cancel_delayed_work() instead of flush_delayed_work() in amt_fini()

Talal Ahmad (1):
      net: avoid double accounting for pure zerocopy skbs

Thomas Weißschuh (1):
      ipvs: autoload ipvs on genl access

Tony Lu (1):
      net/smc: Print function name in smcr_link_down tracepoint

Vincent Mailhol (1):
      can: etas_es58x: es58x_rx_err_msg(): fix memory leak in error path

Vladimir Oltean (2):
      net: dsa: felix: fix broken VLAN-tagged PTP under VLAN-aware bridge
      net: stmmac: allow a tc-taprio base-time of zero

Volodymyr Mytnyk (2):
      net: marvell: prestera: fix patchwork build problems
      net: marvell: prestera: fix hw structure laid out

Wan Jiabing (1):
      bnxt_en: avoid newline at end of message in NL_SET_ERR_MSG_MOD

Willem de Bruijn (1):
      selftests/net: udpgso_bench_rx: fix port argument

Xin Long (4):
      security: pass asoc to sctp_assoc_request and sctp_sk_clone
      security: call security_sctp_assoc_request in sctp_sf_do_5_1D_ce
      security: add sctp_assoc_established hook
      security: implement sctp_assoc_established hook in selinux

Xu Wang (1):
      net: ethernet: litex: Remove unnecessary print function dev_err()

Yang Guang (2):
      octeontx2-af: use swap() to make code cleaner
      sfc: use swap() to make code cleaner

Yang Li (1):
      amt: Fix NULL but dereferenced coccicheck error

Yang Yingliang (1):
      amt: fix error return code in amt_init()

Yufeng Mo (2):
      net: hns3: sync rx ring head in echo common pull
      net: hns3: fix kernel crash when unload VF while it is being reset

Yuiko Oshino (1):
      net: phy: microchip_t1: add lan87xx_config_rgmii_delay for lan87xx phy

Zhang Changzhong (3):
      can: j1939: j1939_tp_cmd_recv(): ignore abort message in the BAM transport
      can: j1939: j1939_can_recv(): ignore messages with invalid source address
      can: j1939: j1939_tp_cmd_recv(): check the dst address of TP.CM_BAM

Zhang Mingyu (2):
      net:ipv6:Remove unneeded semicolon
      amt: remove duplicate include in amt.c

Ziyang Xuan (1):
      net: vlan: fix a UAF in vlan_dev_real_dev()

luo penghao (1):
      tg3: Remove redundant assignments

 Documentation/networking/ip-sysctl.rst             |   6 +-
 Documentation/security/SCTP.rst                    |  65 +++++-----
 MAINTAINERS                                        |   5 +-
 arch/riscv/mm/extable.c                            |   4 +-
 arch/riscv/net/bpf_jit_comp64.c                    |   2 +
 drivers/net/Kconfig                                |   1 +
 drivers/net/amt.c                                  |  11 +-
 drivers/net/bonding/bond_sysfs_slave.c             |  36 ++----
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c     |   6 +-
 drivers/net/can/usb/etas_es58x/es58x_core.c        |   6 +-
 drivers/net/can/usb/peak_usb/pcan_usb.c            |  27 ++--
 drivers/net/dsa/mv88e6xxx/chip.c                   |   5 +-
 drivers/net/dsa/ocelot/felix.c                     |   9 +-
 drivers/net/dsa/qca8k.c                            |   8 ++
 drivers/net/dsa/qca8k.h                            |   1 +
 drivers/net/ethernet/asix/ax88796c_main.c          |   4 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c  |   2 +-
 drivers/net/ethernet/broadcom/tg3.c                |   1 -
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c |   7 +-
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.h         |   2 +
 drivers/net/ethernet/google/gve/gve_main.c         |   2 +-
 drivers/net/ethernet/google/gve/gve_rx.c           |   3 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |   7 +
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |   6 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c |   1 +
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |   1 +
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c |  20 ++-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 106 ++++++---------
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |   8 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c  |  77 +++++------
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h  |   4 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c   |  32 +++++
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h   |   9 ++
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |  10 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h  |   4 +-
 drivers/net/ethernet/intel/ice/ice.h               |   5 +-
 drivers/net/ethernet/intel/ice/ice_base.c          |   2 +-
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c   | 141 ++++++++++----------
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h   |   5 +
 drivers/net/ethernet/lantiq_etop.c                 |   2 +-
 drivers/net/ethernet/litex/litex_liteeth.c         |   5 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |  38 +++---
 drivers/net/ethernet/marvell/octeontx2/Kconfig     |   1 +
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    |   4 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_vf.c   |   2 +-
 .../ethernet/marvell/prestera/prestera_ethtool.c   |   3 +-
 .../net/ethernet/marvell/prestera/prestera_hw.c    | 144 ++++++++++++---------
 .../net/ethernet/marvell/prestera/prestera_main.c  |   6 +-
 .../net/ethernet/marvell/prestera/prestera_pci.c   |   3 +-
 .../net/ethernet/mellanox/mlx5/core/lag/port_sel.c |   2 +-
 drivers/net/ethernet/microsoft/mana/gdma_main.c    |   2 +-
 drivers/net/ethernet/sfc/falcon/efx.c              |   8 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c    |   2 -
 drivers/net/ethernet/ti/cpsw_ale.c                 |   6 +-
 drivers/net/ethernet/ti/davinci_emac.c             |  16 ++-
 drivers/net/hamradio/6pack.c                       |   6 +-
 drivers/net/hamradio/mkiss.c                       |   9 +-
 drivers/net/phy/microchip_t1.c                     |  44 ++++++-
 drivers/net/phy/phy.c                              |   7 +-
 drivers/net/sungem_phy.c                           |   2 +-
 drivers/net/wwan/iosm/iosm_ipc_imem_ops.c          |   2 -
 drivers/nfc/pn533/pn533.c                          |   6 +-
 drivers/nfc/port100.c                              |   6 +-
 fs/libfs.c                                         |  29 ++++-
 include/linux/bpf.h                                |   6 +
 include/linux/dsa/ocelot.h                         |   1 +
 include/linux/ethtool_netlink.h                    |   3 +
 include/linux/fs.h                                 |   2 +
 include/linux/lsm_hook_defs.h                      |   6 +-
 include/linux/lsm_hooks.h                          |  13 +-
 include/linux/security.h                           |  17 ++-
 include/linux/skbuff.h                             |  35 ++++-
 include/linux/skmsg.h                              |  12 ++
 include/net/llc.h                                  |   4 +-
 include/net/sctp/structs.h                         |  20 +--
 include/net/strparser.h                            |  20 ++-
 include/net/tcp.h                                  |   8 +-
 include/uapi/linux/ethtool_netlink.h               |   4 +-
 kernel/bpf/core.c                                  |   7 +
 kernel/bpf/verifier.c                              |  55 +++-----
 mm/shmem.c                                         |  24 +---
 net/8021q/vlan.c                                   |   3 -
 net/8021q/vlan_dev.c                               |   3 +
 net/can/j1939/main.c                               |   7 +
 net/can/j1939/transport.c                          |  11 ++
 net/core/datagram.c                                |   3 +-
 net/core/dev.c                                     |   7 +-
 net/core/devlink.c                                 |   2 +-
 net/core/filter.c                                  |  64 +++++++--
 net/core/skbuff.c                                  |  17 +--
 net/core/sock.c                                    |   2 +-
 net/core/sock_map.c                                |   6 -
 net/dsa/tag_ocelot.c                               |   3 +
 net/ethtool/pause.c                                |   3 +-
 net/ipv4/tcp.c                                     |  22 +++-
 net/ipv4/tcp_bpf.c                                 |  48 ++++++-
 net/ipv4/tcp_output.c                              |  27 ++--
 net/ipv6/seg6.c                                    |   2 +-
 net/ipv6/tcp_ipv6.c                                |   1 -
 net/ipv6/udp.c                                     |   6 +-
 net/mctp/af_mctp.c                                 |  24 +++-
 net/netfilter/ipvs/ip_vs_ctl.c                     |   2 +
 net/netfilter/nfnetlink_queue.c                    |   2 +-
 net/nfc/netlink.c                                  |  15 +++
 net/sched/sch_taprio.c                             |  27 ++--
 net/sctp/sm_statefuns.c                            |  34 ++---
 net/sctp/socket.c                                  |   5 +-
 net/smc/af_smc.c                                   |  18 ++-
 net/smc/smc_tracepoint.h                           |   2 +-
 net/strparser/strparser.c                          |  10 +-
 net/vmw_vsock/af_vsock.c                           |   2 +
 security/security.c                                |  15 ++-
 security/selinux/hooks.c                           |  34 +++--
 security/selinux/include/netlabel.h                |   4 +-
 security/selinux/netlabel.c                        |  18 +--
 tools/bpf/bpftool/Makefile                         |  32 +++--
 tools/lib/bpf/bpf.c                                |   4 +-
 tools/testing/selftests/bpf/prog_tests/netcnt.c    |   2 +-
 .../testing/selftests/bpf/prog_tests/test_bpffs.c  |  85 ++++++++++--
 .../selftests/bpf/progs/for_each_array_map_elem.c  |  12 ++
 .../selftests/bpf/test_xdp_redirect_multi.sh       |  62 +++++----
 tools/testing/selftests/bpf/verifier/spill_fill.c  |  17 +++
 tools/testing/selftests/bpf/xdp_redirect_multi.c   |   4 +-
 tools/testing/selftests/net/Makefile               |   9 +-
 .../net/forwarding/mirror_gre_bridge_1d_vlan.sh    |   2 +-
 .../selftests/net/forwarding/mirror_gre_changes.sh |   2 +-
 .../net/forwarding/mirror_gre_vlan_bridge_1q.sh    |  13 +-
 .../testing/selftests/net/forwarding/mirror_lib.sh |   3 +-
 .../selftests/net/forwarding/mirror_vlan.sh        |   4 +-
 tools/testing/selftests/net/gre_gso.sh             |   9 +-
 tools/testing/selftests/net/reuseport_bpf_numa.c   |   4 +
 .../testing/selftests/net/test_vxlan_under_vrf.sh  |   2 +
 tools/testing/selftests/net/tls.c                  |   3 -
 tools/testing/selftests/net/udpgso_bench_rx.c      |  11 +-
 134 files changed, 1242 insertions(+), 730 deletions(-)
