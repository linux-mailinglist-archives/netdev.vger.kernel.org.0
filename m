Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD45843E61D
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 18:29:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbhJ1QcG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 12:32:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:52210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229594AbhJ1QcD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 12:32:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 130636103C;
        Thu, 28 Oct 2021 16:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635438576;
        bh=f5mWwUgfXt3U7aduUw/7LrrDfMIVI+t3AwFS3yz6ZtM=;
        h=From:To:Cc:Subject:Date:From;
        b=CZMZy2NbrWSwJUVw6yqNisPqj+hN7A1iSIUrT29fC/J9JiK8ALMwnHjOF7MVW1dv1
         kT8DWVzntOO8x0wD5yV44hkxG59fp641ldAAICkW0DtNqNA1coqDPc2D/6WuGYOKYv
         2CM/tMGSI+3mOAS4gao0HF1uMznEKXgGE2QVzJcg/Gmo+uPXd3iz7xu0npwf2ETW+v
         O9leM3vJGh05WhUMm628MDkHEPzIwiCZSTyKDUt7kQsEsyp2wM/Bhv7/fXVSGHRLfA
         VxVQAaAtp+QYnfAa2gz9TUGw5BXTWPPZrbJZ3NY/ABGJlbjZgOW1WXwP4p+8FyzsYB
         SSvx4PugW6lKA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, daniel@iogearbox.net, toke@toke.dk,
        johannes@sipsolutions.net, bpf@vger.kernel.org
Subject: [GIT PULL] Networking for 5.15-rc8
Date:   Thu, 28 Oct 2021 09:29:12 -0700
Message-Id: <20211028162912.1660341-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus!

The diffstat is what it is but we have no known regressions to
fix for 5.15, nor do any of the changes here call for additional
testing time.

The following changes since commit 64222515138e43da1fcf288f0289ef1020427b87:

  Merge tag 'drm-fixes-2021-10-22' of git://anongit.freedesktop.org/drm/drm (2021-10-21 19:06:08 -1000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.15-rc8

for you to fetch changes up to 35392da51b1ab7ba0c63de0a553e2a93c2314266:

  Revert "net: hns3: fix pause config problem after autoneg disabled" (2021-10-28 08:23:03 -0700)

----------------------------------------------------------------
Networking fixes for 5.15-rc8/final, including fixes from WiFi
(mac80211), and BPF.

Current release - regressions:

 - skb_expand_head: adjust skb->truesize to fix socket memory
   accounting

 - mptcp: fix corrupt receiver key in MPC + data + checksum

Previous releases - regressions:

 - multicast: calculate csum of looped-back and forwarded packets

 - cgroup: fix memory leak caused by missing cgroup_bpf_offline

 - cfg80211: fix management registrations locking, prevent list
   corruption

 - cfg80211: correct false positive in bridge/4addr mode check

 - tcp_bpf: fix race in the tcp_bpf_send_verdict resulting in reusing
   previous verdict

Previous releases - always broken:

 - sctp: enhancements for the verification tag, prevent attackers
   from killing SCTP sessions

 - tipc: fix size validations for the MSG_CRYPTO type

 - mac80211: mesh: fix HE operation element length check, prevent
   out of bound access

 - tls: fix sign of socket errors, prevent positive error codes
   being reported from read()/write()

 - cfg80211: scan: extend RCU protection in cfg80211_add_nontrans_list()

 - implement ->sock_is_readable() for UDP and AF_UNIX, fix poll()
   for sockets in a BPF sockmap

 - bpf: fix potential race in tail call compatibility check resulting
   in two operations which would make the map incompatible succeeding

 - bpf: prevent increasing bpf_jit_limit above max

 - bpf: fix error usage of map_fd and fdget() in generic batch update

 - phy: ethtool: lock the phy for consistency of results

 - prevent infinite while loop in skb_tx_hash() when Tx races with
   driver reconfiguring the queue <> traffic class mapping

 - usbnet: fixes for bad HW conjured by syzbot

 - xen: stop tx queues during live migration, prevent UAF

 - net-sysfs: initialize uid and gid before calling net_ns_get_ownership

 - mlxsw: prevent Rx stalls under memory pressure

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Alexei Starovoitov (2):
      Merge branch 'Fix up bpf_jit_limit some more'
      Merge branch 'sock_map: fix ->poll() and update selftests'

Andrew Lunn (4):
      phy: phy_ethtool_ksettings_get: Lock the phy for consistency
      phy: phy_ethtool_ksettings_set: Move after phy_start_aneg
      phy: phy_start_aneg: Add an unlocked version
      phy: phy_ethtool_ksettings_set: Lock the PHY while changing settings

Björn Töpel (1):
      riscv, bpf: Fix potential NULL dereference

Cong Wang (3):
      net: Rename ->stream_memory_read to ->sock_is_readable
      skmsg: Extract and reuse sk_msg_is_readable()
      net: Implement ->sock_is_readable() for UDP and AF_UNIX

Cyril Strejc (1):
      net: multicast: calculate csum of looped-back and forwarded packets

Daniel Jordan (2):
      net/tls: Fix flipped sign in tls_err_abort() calls
      net/tls: Fix flipped sign in async_wait.err assignment

Dave Ertman (1):
      ice: Respond to a NETDEV_UNREGISTER event for LAG

David S. Miller (5):
      Merge branch 'ksettings-locking-fixes'
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue
      Merge branch 'hns3-fixes'
      Merge branch 'SMC-fixes'
      Merge branch 'octeontx2-debugfs-fixes'

Davide Caratti (1):
      mptcp: fix corrupt receiver key in MPC + data + checksum

Dongli Zhang (2):
      xen/netfront: stop tx queues during live migration
      vmxnet3: do not stop tx queues after netif_device_detach()

Florian Westphal (1):
      fcnal-test: kill hanging ping/nettest binaries on cleanup

Guangbin Huang (5):
      net: hns3: fix pause config problem after autoneg disabled
      net: hns3: ignore reset event before initialization process is done
      net: hns3: expand buffer len for some debugfs command
      net: hns3: adjust string spaces of some parameters of tx bd info in debugfs
      Revert "net: hns3: fix pause config problem after autoneg disabled"

Ido Schimmel (1):
      mlxsw: pci: Recycle received packet upon allocation failure

Jakub Kicinski (4):
      Merge tag 'mac80211-for-net-2021-10-21' of git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211
      Merge branch 'sctp-enhancements-for-the-verification-tag'
      Merge https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf
      Merge tag 'mac80211-for-net-2021-10-27' of git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211

Janghyub Seo (1):
      r8169: Add device 10ec:8162 to driver r8169

Janusz Dziedzic (1):
      cfg80211: correct bridge/4addr mode check

Jie Wang (2):
      net: hns3: fix data endian problem of some functions of debugfs
      net: hns3: add more string spaces for dumping packets number of queue info in debugfs

Johan Hovold (1):
      net: lan78xx: fix division by zero in send path

Johannes Berg (3):
      mac80211: mesh: fix HE operation element length check
      cfg80211: scan: fix RCU in cfg80211_add_nontrans_list()
      cfg80211: fix management registrations locking

Krzysztof Kozlowski (1):
      nfc: port100: fix using -ERRNO as command type mask

Liu Jian (1):
      tcp_bpf: Fix one concurrency problem in the tcp_bpf_send_verdict function

Lorenz Bauer (3):
      bpf: Define bpf_jit_alloc_exec_limit for riscv JIT
      bpf: Define bpf_jit_alloc_exec_limit for arm64 JIT
      bpf: Prevent increasing bpf_jit_limit above max

Max VA (1):
      tipc: fix size validations for the MSG_CRYPTO type

Michael Chan (1):
      net: Prevent infinite while loop in skb_tx_hash()

Pavel Skripkin (1):
      net: batman-adv: fix error handling

Quanyang Wang (1):
      cgroup: Fix memory leak caused by missing cgroup_bpf_offline

Rakesh Babu (1):
      octeontx2-af: Display all enabled PF VF rsrc_alloc entries.

Rakesh Babu Saladi (1):
      octeontx2-af: Fix possible null pointer dereference.

Randy Dunlap (1):
      ptp: Document the PTP_CLK_MAGIC ioctl number

Subbaraya Sundeep (1):
      octeontx2-af: Check whether ipolicers exists

Tejun Heo (1):
      bpf: Move BPF_MAP_TYPE for INODE_STORAGE and TASK_STORAGE outside of CONFIG_NET

Toke Høiland-Jørgensen (1):
      bpf: Fix potential race in tail call compatibility check

Tony Lu (1):
      net/smc: Fix smc_link->llc_testlink_time overflow

Trevor Woerner (1):
      net: nxp: lpc_eth.c: avoid hang when bringing interface down

Vadym Kochan (1):
      MAINTAINERS: please remove myself from the Prestera driver

Vasily Averin (1):
      skb_expand_head() adjust skb->truesize incorrectly

Wang Hai (1):
      usbnet: fix error return code in usbnet_probe()

Wen Gu (1):
      net/smc: Correct spelling mistake to TCPF_SYN_RECV

Xin Long (8):
      sctp: use init_tag from inithdr for ABORT chunk
      sctp: fix the processing for INIT chunk
      sctp: fix the processing for INIT_ACK chunk
      sctp: fix the processing for COOKIE_ECHO chunk
      sctp: add vtag check in sctp_sf_violation
      sctp: add vtag check in sctp_sf_do_8_5_1_E_sa
      sctp: add vtag check in sctp_sf_ootb
      net-sysfs: initialize uid and gid before calling net_ns_get_ownership

Xu Kuohai (1):
      bpf: Fix error usage of map_fd and fdget() in generic_map_update_batch()

Yongxin Liu (1):
      ice: check whether PTP is initialized in ice_ptp_release()

Yu Xiao (1):
      nfp: bpf: relax prog rejection for mtu check through max_pkt_offset

Yucong Sun (1):
      selftests/bpf: Use recv_timeout() instead of retries

Yufeng Mo (1):
      net: hns3: change hclge/hclgevf workqueue to WQ_UNBOUND mode

Yuiko Oshino (3):
      net: ethernet: microchip: lan743x: Fix driver crash when lan743x_pm_resume fails
      net: ethernet: microchip: lan743x: Fix dma allocation failure by using dma_set_mask_and_coherent
      net: ethernet: microchip: lan743x: Fix skb allocation failure

 Documentation/userspace-api/ioctl/ioctl-number.rst |   1 +
 MAINTAINERS                                        |   1 -
 arch/arm64/net/bpf_jit_comp.c                      |   5 +
 arch/riscv/net/bpf_jit_core.c                      |   8 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |  16 +--
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c |  30 ++---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  35 +----
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |   1 -
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |   5 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h  |   1 +
 drivers/net/ethernet/intel/ice/ice_lag.c           |  18 +--
 drivers/net/ethernet/intel/ice/ice_ptp.c           |   3 +
 .../ethernet/marvell/octeontx2/af/rvu_debugfs.c    | 148 ++++++++++++++++-----
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |   3 +
 drivers/net/ethernet/mellanox/mlxsw/pci.c          |  25 ++--
 drivers/net/ethernet/microchip/lan743x_main.c      |  35 ++++-
 drivers/net/ethernet/netronome/nfp/bpf/main.c      |  16 ++-
 drivers/net/ethernet/netronome/nfp/bpf/main.h      |   2 +
 drivers/net/ethernet/netronome/nfp/bpf/offload.c   |  17 ++-
 drivers/net/ethernet/nxp/lpc_eth.c                 |   5 +-
 drivers/net/ethernet/realtek/r8169_main.c          |   1 +
 drivers/net/phy/phy.c                              | 140 +++++++++++--------
 drivers/net/usb/lan78xx.c                          |   6 +
 drivers/net/usb/usbnet.c                           |   1 +
 drivers/net/vmxnet3/vmxnet3_drv.c                  |   1 -
 drivers/net/xen-netfront.c                         |   8 ++
 drivers/nfc/port100.c                              |   4 +-
 include/linux/bpf.h                                |   7 +-
 include/linux/bpf_types.h                          |   8 +-
 include/linux/filter.h                             |   1 +
 include/linux/skmsg.h                              |   1 +
 include/net/cfg80211.h                             |   2 -
 include/net/mptcp.h                                |   4 +
 include/net/sock.h                                 |   8 +-
 include/net/tls.h                                  |  11 +-
 include/net/udp.h                                  |   5 +-
 kernel/bpf/arraymap.c                              |   1 +
 kernel/bpf/core.c                                  |  24 ++--
 kernel/bpf/syscall.c                               |  11 +-
 kernel/cgroup/cgroup.c                             |   4 +-
 net/batman-adv/bridge_loop_avoidance.c             |   8 +-
 net/batman-adv/main.c                              |  56 +++++---
 net/batman-adv/network-coding.c                    |   4 +-
 net/batman-adv/translation-table.c                 |   4 +-
 net/core/dev.c                                     |   9 +-
 net/core/net-sysfs.c                               |   4 +-
 net/core/skbuff.c                                  |  36 +++--
 net/core/skmsg.c                                   |  14 ++
 net/core/sock_destructor.h                         |  12 ++
 net/core/sysctl_net_core.c                         |   2 +-
 net/ipv4/tcp.c                                     |   5 +-
 net/ipv4/tcp_bpf.c                                 |  27 ++--
 net/ipv4/udp.c                                     |   3 +
 net/ipv4/udp_bpf.c                                 |   1 +
 net/mac80211/mesh.c                                |   9 +-
 net/mptcp/options.c                                |  39 +++---
 net/sctp/sm_statefuns.c                            | 139 +++++++++++--------
 net/smc/af_smc.c                                   |   2 +-
 net/smc/smc_llc.c                                  |   2 +-
 net/tipc/crypto.c                                  |  32 +++--
 net/tls/tls_main.c                                 |   4 +-
 net/tls/tls_sw.c                                   |  21 ++-
 net/unix/af_unix.c                                 |   4 +
 net/unix/unix_bpf.c                                |   2 +
 net/wireless/core.c                                |   2 +-
 net/wireless/core.h                                |   2 +
 net/wireless/mlme.c                                |  26 ++--
 net/wireless/scan.c                                |   7 +-
 net/wireless/util.c                                |  14 +-
 .../selftests/bpf/prog_tests/sockmap_listen.c      |  75 +++--------
 tools/testing/selftests/net/fcnal-test.sh          |   3 +
 71 files changed, 738 insertions(+), 453 deletions(-)
 create mode 100644 net/core/sock_destructor.h
