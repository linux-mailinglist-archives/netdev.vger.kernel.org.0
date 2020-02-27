Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC25172AEB
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 23:12:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730107AbgB0WMX convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 27 Feb 2020 17:12:23 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:45842 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729773AbgB0WMX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 17:12:23 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E6BDE120ED555;
        Thu, 27 Feb 2020 14:12:22 -0800 (PST)
Date:   Thu, 27 Feb 2020 14:12:20 -0800 (PST)
Message-Id: <20200227.141220.1878875210756855090.davem@davemloft.net>
To:     torvalds@linux-foundation.org
CC:     akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From:   David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 27 Feb 2020 14:12:23 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


1) Fix leak in nl80211 AP start where we leak the ACL memory, from
   Johannes Berg.

2) Fix double mutex unlock in mac80211, from Andrei Otcheretianski.

3) Fix RCU stall in ipset, from Jozsef Kadlecsik.

4) Fix devlink locking in devlink_dpipe_table_register, from
   Madhuparna Bhowmik.

5) Fix race causing TX hang in ll_temac, from Esben Haabendal.

6) Stale eth hdr pointer in br_dev_xmit(), from Nikolay Aleksandrov.

7) Fix TX hash calculation bounds checking wrt. tc rules, from
   Amritha Nambiar.

8) Size netlink responses properly in schedule action code to take
   into consideration TCA_ACT_FLAGS.  From Jiri Pirko.

9) Fix firmware paths for mscc PHY driver, from Antoine Tenart.

10) Don't register stmmac notifier multiple times, from Aaro Koskinen.

11) Various rmnet bug fixes, from Taehee Yoo.

12) Fix vsock deadlock in vsock transport release, from Stefano
    Garzarella.

Please pull, thanks a lot.

The following changes since commit 0c0ddd6ae47c9238c18f475bcca675ca74c9dc31:

  Merge tag 'linux-watchdog-5.6-rc3' of git://www.linux-watchdog.org/linux-watchdog (2020-02-21 13:02:49 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git 

for you to fetch changes up to 3ee339eb28959629db33aaa2b8cde4c63c6289eb:

  net: dsa: mv88e6xxx: Fix masking of egress port (2020-02-27 12:29:09 -0800)

----------------------------------------------------------------
Aaro Koskinen (1):
      net: stmmac: fix notifier registration

Alex Maftei (amaftei) (1):
      sfc: fix timestamp reconstruction at 16-bit rollover points

Amit Cohen (1):
      mlxsw: pci: Wait longer before accessing the device after reset

Amritha Nambiar (1):
      net: Fix Tx hash bound checking

Andrei Otcheretianski (1):
      mac80211: Remove a redundant mutex unlock

Andrew Lunn (1):
      net: dsa: mv88e6xxx: Fix masking of egress port

Antoine Tenart (1):
      net: phy: mscc: fix firmware paths

Cong Wang (1):
      netfilter: xt_hashlimit: unregister proc file before releasing mutex

Daniele Palmas (1):
      net: usb: qmi_wwan: restore mtu min/max values after raw_ip switch

David S. Miller (6):
      Merge branch 'net-ll_temac-Bugfixes'
      Merge tag 'mac80211-for-net-2020-02-24' of git://git.kernel.org/.../jberg/mac80211
      Merge git://git.kernel.org/.../pablo/nf
      Merge branch 'hinic-BugFixes'
      Merge branch 'net-rmnet-fix-several-bugs'
      unix: It's CONFIG_PROC_FS not CONFIG_PROCFS

Eric Dumazet (1):
      ipv6: restrict IPV6_ADDRFORM operation

Esben Haabendal (4):
      net: ll_temac: Fix race condition causing TX hang
      net: ll_temac: Add more error handling of dma_map_single() calls
      net: ll_temac: Fix RX buffer descriptor handling on GFP_ATOMIC pressure
      net: ll_temac: Handle DMA halt condition caused by buffer underrun

Eugenio Pérez (1):
      vhost: Check docket sk_family instead of call getname

Florian Fainelli (2):
      net: phy: Avoid multiple suspends
      net: dsa: bcm_sf2: Forcibly configure IMP port for 1Gb/sec

Haiyang Zhang (1):
      hv_netvsc: Fix unwanted wakeup in netvsc_attach()

Jason A. Donenfeld (1):
      icmp: allow icmpv6_ndo_send to work with CONFIG_IPV6=n

Jiri Pirko (2):
      sched: act: count in the size of action flags bitfield
      mlx5: register lag notifier for init network namespace only

Johannes Berg (3):
      nl80211: fix potential leak in AP start
      cfg80211: check reg_rule for NULL in handle_channel_custom()
      nl80211: explicitly include if_vlan.h

Jonathan Lemon (1):
      bnxt_en: add newline to netdev_*() format strings

Jonathan Neuschäfer (1):
      docs: networking: phy: Rephrase paragraph for clarity

Jozsef Kadlecsik (2):
      netfilter: ipset: Fix "INFO: rcu detected stall in hash_xxx" reports
      netfilter: ipset: Fix forceadd evaluation path

Karsten Graul (1):
      net/smc: check for valid ib_client_data

Luo bin (3):
      hinic: fix a irq affinity bug
      hinic: fix a bug of setting hw_ioctxt
      hinic: fix a bug of rss configuration

Madhuparna Bhowmik (3):
      net: core: devlink.c: Hold devlink->lock from the beginning of devlink_dpipe_table_register()
      mac80211: rx: avoid RCU list traversal under mutex
      net: core: devlink.c: Use built-in RCU list checking

Marek Vasut (1):
      net: ks8851-ml: Fix IRQ handling and locking

Matteo Croce (1):
      ipv4: ensure rcu_read_lock() in cipso_v4_error()

Michal Kubecek (1):
      ethtool: limit bitset size

Neal Cardwell (1):
      tcp: fix TFO SYNACK undo to avoid double-timestamp-undo

Nicolas Saenz Julienne (1):
      net: bcmgenet: Clear ID_MODE_DIS in EXT_RGMII_OOB_CTRL when not needed

Nikolay Aleksandrov (1):
      net: bridge: fix stale eth hdr pointer in br_dev_xmit

Pablo Neira Ayuso (1):
      Merge branch 'master' of git://blackhole.kfki.hu/nf

Paolo Abeni (2):
      net: genetlink: return the error code when attribute parsing fails.
      mptcp: add dummy icsk_sync_mss()

Russell King (1):
      net: phy: marvell: don't interpret PHY status unless resolved

Stefano Brivio (3):
      selftests: nft_concat_range: Move option for 'list ruleset' before command
      nft_set_pipapo: Actually fetch key data in nft_pipapo_remove()
      selftests: nft_concat_range: Add test for reported add/flush/add issue

Stefano Garzarella (1):
      vsock: fix potential deadlock in transport->release()

Sudheesh Mavila (1):
      net: phy: corrected the return value for genphy_check_and_restart_aneg and genphy_c45_check_and_restart_aneg

Taehee Yoo (8):
      net: rmnet: fix NULL pointer dereference in rmnet_newlink()
      net: rmnet: fix NULL pointer dereference in rmnet_changelink()
      net: rmnet: fix suspicious RCU usage
      net: rmnet: remove rcu_read_lock in rmnet_force_unassociate_device()
      net: rmnet: do not allow to change mux id if mux id is duplicated
      net: rmnet: use upper/lower device infrastructure
      net: rmnet: fix bridge mode bugs
      net: rmnet: fix packet forwarding in rmnet bridge mode

Tobias Klauser (1):
      unix: define and set show_fdinfo only if procfs is enabled

Ursula Braun (1):
      net/smc: fix cleanup for linkgroup setup failures

yangerkun (1):
      slip: not call free_netdev before rtnl_unlock in slip_open

 Documentation/networking/phy.rst                      |   5 +-
 drivers/net/dsa/bcm_sf2.c                             |   3 +-
 drivers/net/dsa/mv88e6xxx/global1.c                   |   4 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c             |   4 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c     |  10 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c     |   4 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c          |  48 +++---
 drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c         |  10 +-
 drivers/net/ethernet/broadcom/genet/bcmmii.c          |   1 +
 drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c      |   1 +
 drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h      |   2 +-
 drivers/net/ethernet/huawei/hinic/hinic_hw_if.h       |   1 +
 drivers/net/ethernet/huawei/hinic/hinic_hw_qp.h       |   1 +
 drivers/net/ethernet/huawei/hinic/hinic_main.c        |   3 +-
 drivers/net/ethernet/huawei/hinic/hinic_rx.c          |   5 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c     |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c      |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag.c         |  11 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag.h         |   1 -
 drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h   |   2 +-
 drivers/net/ethernet/mellanox/mlxsw/pci_hw.h          |   2 +-
 drivers/net/ethernet/micrel/ks8851_mll.c              |  14 +-
 drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c    | 186 ++++++++++++------------
 drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h    |   3 +-
 drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c  |   7 +-
 drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c       |   8 -
 drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.h       |   1 -
 drivers/net/ethernet/sfc/ptp.c                        |  38 ++++-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c     |  13 +-
 drivers/net/ethernet/xilinx/ll_temac.h                |   4 +
 drivers/net/ethernet/xilinx/ll_temac_main.c           | 209 ++++++++++++++++++++++-----
 drivers/net/hyperv/netvsc.c                           |   2 +-
 drivers/net/hyperv/netvsc_drv.c                       |   3 +
 drivers/net/phy/marvell.c                             |   5 +
 drivers/net/phy/mscc.c                                |   4 +-
 drivers/net/phy/phy-c45.c                             |   6 +-
 drivers/net/phy/phy_device.c                          |  11 +-
 drivers/net/slip/slip.c                               |   3 +
 drivers/net/usb/qmi_wwan.c                            |   3 +
 drivers/vhost/net.c                                   |  10 +-
 include/linux/icmpv6.h                                |  16 +-
 include/linux/netfilter/ipset/ip_set.h                |  11 +-
 net/bridge/br_device.c                                |   6 +-
 net/core/dev.c                                        |   2 +
 net/core/devlink.c                                    |  38 +++--
 net/ethtool/bitset.c                                  |   3 +-
 net/ethtool/bitset.h                                  |   2 +
 net/ipv4/cipso_ipv4.c                                 |   7 +-
 net/ipv4/tcp_input.c                                  |   6 +-
 net/ipv6/ipv6_sockglue.c                              |  10 +-
 net/mac80211/mlme.c                                   |   6 +-
 net/mac80211/rx.c                                     |   2 +-
 net/mptcp/protocol.c                                  |   6 +
 net/netfilter/ipset/ip_set_core.c                     |  34 +++--
 net/netfilter/ipset/ip_set_hash_gen.h                 | 635 +++++++++++++++++++++++++++++++++++++++++++++++++++++++-------------------------
 net/netfilter/nft_set_pipapo.c                        |   6 +-
 net/netfilter/xt_hashlimit.c                          |  16 +-
 net/netlink/genetlink.c                               |   5 +-
 net/sched/act_api.c                                   |   1 +
 net/smc/af_smc.c                                      |  25 ++--
 net/smc/smc_core.c                                    |  12 ++
 net/smc/smc_core.h                                    |   2 +-
 net/smc/smc_ib.c                                      |   2 +
 net/unix/af_unix.c                                    |   4 +
 net/vmw_vsock/af_vsock.c                              |  20 ++-
 net/vmw_vsock/hyperv_transport.c                      |   3 -
 net/vmw_vsock/virtio_transport_common.c               |   2 -
 net/wireless/nl80211.c                                |   5 +-
 net/wireless/reg.c                                    |   2 +-
 tools/testing/selftests/netfilter/nft_concat_range.sh |  55 +++++--
 70 files changed, 1062 insertions(+), 536 deletions(-)
