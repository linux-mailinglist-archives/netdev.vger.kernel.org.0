Return-Path: <netdev+bounces-7215-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0AD4371F160
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 20:09:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8450D1C20F15
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 18:09:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 158714823D;
	Thu,  1 Jun 2023 18:09:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FABF48231
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 18:09:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 590C3C4339B;
	Thu,  1 Jun 2023 18:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685642947;
	bh=dIwYEg96yGLD4ElpWIa1Ug5TAjETECGYdsK4YI5RVMw=;
	h=From:To:Cc:Subject:Date:From;
	b=qX86AF4rW4ZSCe6VhEzWnZA8Xh3lTwQqkQa9fSDoQnELIYMJEvPoYuV/xOX066IOI
	 4CrN7/fvsOBikmRyHH6mw2sSltGIiAt1BCjn3bniaSBW5NjVDsZVc2g9ATTwYm12Je
	 ygkU/UAEEVdgyivSMj2s0PDMFQLG9n3gFhNoJMK5OWFkrrZECuoA5b4AtZpmeccl1s
	 hint7jIFBucslBPKoeUn8IDhrXItLrpMWhgXoz4BtMHJpz6ZFEKxKa12XEMVCUU82S
	 XCKMGtulsuG+4lAzo/OvLtmfZVPtpI7c9yDGY7m+Q7oFEj7wtr0BSDtJc5ODe6cpae
	 Og3bLS0HX8PXg==
From: Jakub Kicinski <kuba@kernel.org>
To: torvalds@linux-foundation.org
Cc: kuba@kernel.org,
	davem@davemloft.net,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	pabeni@redhat.com
Subject: [GIT PULL] Networking for v6.4-rc5
Date: Thu,  1 Jun 2023 11:09:06 -0700
Message-Id: <20230601180906.238637-1-kuba@kernel.org>
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

Happy Wear a Dress Day.

The following changes since commit 50fb587e6a56dba74c3c56a7a09c48bff25cc5fa:

  Merge tag 'net-6.4-rc4' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2023-05-25 10:55:26 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git net-6.4-rc5

for you to fetch changes up to a451b8eb96e521ebabc9c53fefa2bcfad6f80f25:

  Merge tag 'mlx5-fixes-2023-05-31' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux (2023-06-01 10:15:43 -0700)

----------------------------------------------------------------
Fairly standard-sized batch of fixes, accounting for the lack of
sub-tree submissions this week. The mlx5 IRQ fixes are notable,
people were complaining about that. No fires burning.

Current release - regressions:

 - eth: mlx5e:
   - multiple fixes for dynamic IRQ allocation
   - prevent encap offload when neigh update is running

 - eth: mana: fix perf regression: remove rx_cqes, tx_cqes counters

Current release - new code bugs:

 - eth: mlx5e: DR, add missing mutex init/destroy in pattern manager

Previous releases - always broken:

 - tcp: deny tcp_disconnect() when threads are waiting

 - sched: prevent ingress Qdiscs from getting installed in random
   locations in the hierarchy and moving around

 - sched: flower: fix possible OOB write in fl_set_geneve_opt()

 - netlink: fix NETLINK_LIST_MEMBERSHIPS length report

 - udp6: fix race condition in udp6_sendmsg & connect

 - tcp: fix mishandling when the sack compression is deferred

 - rtnetlink: validate link attributes set at creation time

 - mptcp: fix connect timeout handling

 - eth: stmmac: fix call trace when stmmac_xdp_xmit() is invoked

 - eth: amd-xgbe: fix the false linkup in xgbe_phy_status

 - eth: mlx5e:
   - fix corner cases in internal buffer configuration
   - drain health before unregistering devlink

 - usb: qmi_wwan: set DTR quirk for BroadMobi BM818

Misc:

 - tcp: return user_mss for TCP_MAXSEG in CLOSE/LISTEN state if user_mss set

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Andreas Svensson (1):
      net: dsa: mv88e6xxx: Increase wait after reset deactivation

Bagas Sanjaya (4):
      Documentation: net/mlx5: Wrap vnic reporter devlink commands in code blocks
      Documentation: net/mlx5: Use bullet and definition lists for vnic counters description
      Documentation: net/mlx5: Add blank line separator before numbered lists
      Documentation: net/mlx5: Wrap notes in admonition blocks

Bert Karwatzki (1):
      net: ipa: Use correct value for IPA_STATUS_SIZE

Cambda Zhu (1):
      tcp: Return user_mss for TCP_MAXSEG in CLOSE/LISTEN state if user_mss set

Chris Mi (2):
      net/mlx5e: Extract remaining tunnel encap code to dedicated file
      net/mlx5e: Prevent encap offload when neigh update is running

Chuck Lever (1):
      net/mlx5: Ensure af_desc.mask is properly initialized

Dan Carpenter (1):
      net/mlx5: Fix check for allocation failure in comp_irqs_request_pci()

David Howells (1):
      rxrpc: Truncate UTS_RELEASE for rxrpc version

Dmytro Linkin (1):
      net/mlx5e: Don't attach netdev profile while handling internal error

Dragos Tatulea (1):
      net/mlx5e: Use query_special_contexts cmd only once per mdev

Edward Cree (1):
      sfc: fix error unwinds in TC offload

Eric Dumazet (3):
      netrom: fix info-leak in nr_write_internal()
      af_packet: do not use READ_ONCE() in packet_bind()
      tcp: deny tcp_disconnect() when threads are waiting

Haiyang Zhang (1):
      net: mana: Fix perf regression: remove rx_cqes, tx_cqes counters

Hangyu Hua (1):
      net/sched: flower: fix possible OOB write in fl_set_geneve_opt()

Jakub Kicinski (8):
      tools: ynl: avoid dict errors on older Python versions
      Merge tag 'mlx5-fixes-2023-05-24' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      tls: improve lockless access safety of tls_err_abort()
      netlink: specs: correct types of legacy arrays
      Merge branch 'net-sched-fixes-for-sch_ingress-and-sch_clsact'
      Merge branch 'rtnetlink-a-couple-of-fixes-in-linkmsg-validation'
      Merge branch 'mptcp-fixes-for-connect-timeout-access-annotations-and-subflow-init'
      Merge tag 'mlx5-fixes-2023-05-31' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux

Jianbo Liu (1):
      net/mlx5e: Move Ethernet driver debugfs to profile init callback

Kuniyuki Iwashima (1):
      af_packet: Fix data-races of pkt_sk(sk)->num.

Maciej Fijalkowski (1):
      ice: recycle/free all of the fragments from multi-buffer frame

Maher Sanalla (2):
      net/mlx5e: Consider internal buffers size in port buffer calculations
      net/mlx5e: Do not update SBCM when prio2buffer command is invalid

Matthieu Baerts (8):
      selftests: mptcp: join: avoid using 'cmp --bytes'
      selftests: mptcp: connect: skip if MPTCP is not supported
      selftests: mptcp: pm nl: skip if MPTCP is not supported
      selftests: mptcp: join: skip if MPTCP is not supported
      selftests: mptcp: diag: skip if MPTCP is not supported
      selftests: mptcp: simult flows: skip if MPTCP is not supported
      selftests: mptcp: sockopt: skip if MPTCP is not supported
      selftests: mptcp: userspace pm: skip if MPTCP is not supported

Moshe Shemesh (1):
      net/mlx5: Read embedded cpu after init bit cleared

Niklas Schnelle (1):
      net/mlx5: Fix setting of irq->map.index for static IRQ case

Osama Muhammad (1):
      nfcsim.c: Fix error checking for debugfs_create_dir

Paolo Abeni (8):
      Merge branch 'two-fixes-for-smcrv2'
      Merge branch 'selftests-mptcp-skip-tests-not-supported-by-old-kernels-part-1'
      mptcp: fix connect timeout handling
      mptcp: add annotations around msk->subflow accesses
      mptcp: consolidate passive msk socket initialization
      mptcp: fix data race around msk->first access
      mptcp: add annotations around sk->sk_shutdown accesses
      mptcp: fix active subflow finalization

Pedro Tammela (1):
      net/netlink: fix NETLINK_LIST_MEMBERSHIPS length report

Peilin Ye (4):
      net/sched: sch_ingress: Only create under TC_H_INGRESS
      net/sched: sch_clsact: Only create under TC_H_CLSACT
      net/sched: Reserve TC_H_INGRESS (TC_H_CLSACT) for ingress (clsact) Qdiscs
      net/sched: Prohibit regrafting ingress or clsact Qdiscs

Raju Rangoju (1):
      amd-xgbe: fix the false linkup in xgbe_phy_status

Saeed Mahameed (1):
      net/mlx5e: Fix error handling in mlx5e_refresh_tirs

Sebastian Krzyszkowiak (1):
      net: usb: qmi_wwan: Set DTR quirk for BroadMobi BM818

Shay Drory (4):
      net/mlx5: Drain health before unregistering devlink
      net/mlx5: SF, Drain health before removing device
      net/mlx5: fw_tracer, Fix event handling
      net/mlx5: Remove rmap also in case dynamic MSIX not supported

Thomas Bogendoerfer (1):
      net: mellanox: mlxbf_gige: Fix skb_panic splat under memory pressure

Vlad Buslov (1):
      net/mlx5: Fix post parse infra to only parse every action once

Vladislav Efanov (1):
      udp6: Fix race condition in udp6_sendmsg & connect

Wei Fang (1):
      net: stmmac: fix call trace when stmmac_xdp_xmit() is invoked

Wen Gu (2):
      net/smc: Scan from current RMB list when no position specified
      net/smc: Don't use RMBs not mapped to new link in SMCRv2 ADD LINK

Xin Long (3):
      rtnetlink: call validate_linkmsg in rtnl_create_link
      rtnetlink: move IFLA_GSO_ tb check to validate_linkmsg
      rtnetlink: add the missing IFLA_GRO_ tb check in validate_linkmsg

Xu Liang (1):
      net: phy: mxl-gpy: extend interrupt fix to all impacted variants

Yevgeny Kliteynik (1):
      net/mlx5: DR, Add missing mutex init/destroy in pattern manager

Yoshihiro Shimoda (1):
      net: renesas: rswitch: Fix return value in error path of xmit

Zhengchao Shao (1):
      net: sched: fix NULL pointer dereference in mq_attach

fuyuanli (1):
      tcp: fix mishandling when the sack compression is deferred.

 Documentation/netlink/specs/ethtool.yaml           |  32 ++---
 .../ethernet/mellanox/mlx5/devlink.rst             |  60 +++++----
 drivers/net/dsa/mv88e6xxx/chip.c                   |   2 +-
 drivers/net/ethernet/amd/xgbe/xgbe-mdio.c          |  12 +-
 drivers/net/ethernet/intel/ice/ice_txrx.c          |   2 +-
 .../ethernet/mellanox/mlx5/core/diag/fw_tracer.c   |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   1 +
 .../ethernet/mellanox/mlx5/core/en/port_buffer.c   |  44 ++++---
 .../ethernet/mellanox/mlx5/core/en/port_buffer.h   |   8 +-
 .../ethernet/mellanox/mlx5/core/en/tc/act/act.c    |   7 +-
 .../ethernet/mellanox/mlx5/core/en/tc/act/act.h    |   2 +-
 .../ethernet/mellanox/mlx5/core/en/tc_tun_encap.c  | 120 +++++++++++++++---
 .../ethernet/mellanox/mlx5/core/en/tc_tun_encap.h  |   9 ++
 .../net/ethernet/mellanox/mlx5/core/en_common.c    |  11 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c |   7 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  69 +++++-----
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |   6 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  97 ++------------
 drivers/net/ethernet/mellanox/mlx5/core/eq.c       |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   9 +-
 drivers/net/ethernet/mellanox/mlx5/core/mr.c       |  21 ++++
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c  |  13 +-
 .../ethernet/mellanox/mlx5/core/sf/dev/driver.c    |   1 +
 .../ethernet/mellanox/mlx5/core/steering/dr_ptrn.c |   3 +
 .../ethernet/mellanox/mlxbf_gige/mlxbf_gige_rx.c   |  13 +-
 drivers/net/ethernet/microsoft/mana/mana_en.c      |  10 --
 drivers/net/ethernet/microsoft/mana/mana_ethtool.c |   2 -
 drivers/net/ethernet/renesas/rswitch.c             |   2 +-
 drivers/net/ethernet/sfc/tc.c                      |  27 ++--
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   3 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_xdp.c   |   6 +
 drivers/net/ipa/ipa_endpoint.c                     |   2 +-
 drivers/net/phy/mxl-gpy.c                          |  16 +--
 drivers/net/usb/qmi_wwan.c                         |   2 +-
 drivers/nfc/nfcsim.c                               |   4 -
 include/linux/mlx5/driver.h                        |   1 +
 include/net/mana/mana.h                            |   2 -
 include/net/sock.h                                 |   4 +
 include/net/tcp.h                                  |   1 +
 net/core/rtnetlink.c                               |  54 +++++---
 net/core/sock.c                                    |   2 +-
 net/ipv4/af_inet.c                                 |   2 +
 net/ipv4/inet_connection_sock.c                    |   1 +
 net/ipv4/tcp.c                                     |   9 +-
 net/ipv4/tcp_input.c                               |   2 +-
 net/ipv4/tcp_timer.c                               |  16 ++-
 net/mptcp/protocol.c                               | 140 ++++++++++++---------
 net/mptcp/protocol.h                               |  15 ++-
 net/mptcp/subflow.c                                |  28 +----
 net/netlink/af_netlink.c                           |   2 +-
 net/netrom/nr_subr.c                               |   7 +-
 net/packet/af_packet.c                             |   8 +-
 net/packet/diag.c                                  |   2 +-
 net/rxrpc/af_rxrpc.c                               |   1 +
 net/rxrpc/ar-internal.h                            |   1 +
 net/rxrpc/local_event.c                            |  11 +-
 net/sched/cls_flower.c                             |   3 +
 net/sched/sch_api.c                                |  16 ++-
 net/sched/sch_ingress.c                            |  16 ++-
 net/smc/smc_llc.c                                  |   9 +-
 net/tls/tls_strp.c                                 |   4 +-
 net/tls/tls_sw.c                                   |   4 +-
 tools/net/ynl/lib/ynl.py                           |   5 +-
 tools/testing/selftests/net/mptcp/Makefile         |   2 +-
 tools/testing/selftests/net/mptcp/diag.sh          |   4 +
 tools/testing/selftests/net/mptcp/mptcp_connect.sh |   4 +
 tools/testing/selftests/net/mptcp/mptcp_join.sh    |  17 ++-
 tools/testing/selftests/net/mptcp/mptcp_lib.sh     |  40 ++++++
 tools/testing/selftests/net/mptcp/mptcp_sockopt.sh |   4 +
 tools/testing/selftests/net/mptcp/pm_netlink.sh    |   4 +
 tools/testing/selftests/net/mptcp/simult_flows.sh  |   4 +
 tools/testing/selftests/net/mptcp/userspace_pm.sh  |   4 +
 72 files changed, 648 insertions(+), 428 deletions(-)
 create mode 100644 tools/testing/selftests/net/mptcp/mptcp_lib.sh

