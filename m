Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD13515F261
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 19:09:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392708AbgBNSIx convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 14 Feb 2020 13:08:53 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:53710 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731434AbgBNPyK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 10:54:10 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E247F15C5582F;
        Fri, 14 Feb 2020 07:54:09 -0800 (PST)
Date:   Fri, 14 Feb 2020 07:54:09 -0800 (PST)
Message-Id: <20200214.075409.535471157405842746.davem@davemloft.net>
To:     torvalds@linux-foundation.org
CC:     akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From:   David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 14 Feb 2020 07:54:10 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


1) Fix interrupt name truncation in mv88e6xxx dsa driver, from Andrew
   Lunn.

2) Process generic XDP even if SKB is cloned, from Toke
   Høiland-Jørgensen.

3) Fix leak of kernel memory to userspace in smc, from Eric Dumazet.

4) Add some missing netlink attribute validation to matchall and
   flower, from Davide Caratti.

5) Send icmp responses properly when NAT has been applied to the frame
   before we get to the tunnel emitting the icmp, from Jason
   A. Donenfeld.

6) Make sure there is enough SKB headroom when adding dsa tags for qca
   and ar9331.  From Per Forlin.

Please pull, thanks a lot!

The following changes since commit fdfa3a6778b194974df77b384cc71eb2e503639a:

  Merge tag 'scsi-misc' of git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi (2020-02-08 17:24:41 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git 

for you to fetch changes up to a1fa83bdab784fa0ff2e92870011c0dcdbd2f680:

  netdevice.h: fix all kernel-doc and Sphinx warnings (2020-02-14 07:38:24 -0800)

----------------------------------------------------------------
Akeem G Abodunrin (1):
      ice: Modify link message logging

Andrew Lunn (1):
      net: dsa: mv88e6xxx: Prevent truncation of longer interrupt names

Anirudh Venkataramanan (4):
      ice: Remove CONFIG_PCI_IOV wrap in ice_set_pf_caps
      ice: Use ice_pf_to_dev
      ice: Make print statements more compact
      ice: Cleanup ice_vsi_alloc_q_vectors

Arthur Kiyanovski (9):
      net: ena: fix potential crash when rxfh key is NULL
      net: ena: fix uses of round_jiffies()
      net: ena: add missing ethtool TX timestamping indication
      net: ena: fix incorrect default RSS key
      net: ena: rss: store hash function as values and not bits
      net: ena: fix incorrectly saving queue numbers when setting RSS indirection table
      net: ena: fix corruption of dev_idx_to_host_tbl
      net: ena: make ena rxfh support ETH_RSS_HASH_NO_CHANGE
      net: ena: ena-com.c: prevent NULL pointer dereference

Ben Shelton (1):
      ice: Use correct netif error function

Bjørn Mork (2):
      qmi_wwan: re-add DW5821e pre-production variant
      qmi_wwan: unconditionally reject 2 ep interfaces

Brett Creeley (3):
      i40e: Fix the conditional for i40e_vc_validate_vqs_bitmaps
      ice: Don't allow same value for Rx tail to be written twice
      ice: Remove ice_dev_onetime_setup()

Bruce Allan (2):
      ice: fix and consolidate logging of NVM/firmware version information
      ice: update Unit Load Status bitmask to check after reset

Chen Wandun (2):
      tipc: make three functions static
      mptcp: make the symbol 'mptcp_sk_clone_lock' static

Dave Ertman (2):
      ice: Fix DCB rebuild after reset
      ice: Fix switch between FW and SW LLDP

David S. Miller (8):
      Merge branch 'Bug-fixes-for-ENA-Ethernet-driver'
      Merge branch '100GbE' of git://git.kernel.org/.../jkirsher/net-queue
      Merge branch 'skip_sw-skip_hw-validation'
      Merge branch 'icmp-account-for-NAT-when-sending-icmps-from-ndo-layer'
      Merge branch 'hns3-fixes'
      Merge branch 'smc-fixes'
      Merge tag 'mac80211-for-net-2020-02-14' of git://git.kernel.org/.../jberg/mac80211
      Merge branch 'dsa-headroom'

Davide Caratti (2):
      net/sched: matchall: add missing validation of TCA_MATCHALL_FLAGS
      net/sched: flower: add missing validation of TCA_FLOWER_FLAGS

Eric Dumazet (1):
      net/smc: fix leak of kernel memory to user space

Firo Yang (1):
      enic: prevent waking up stopped tx queues over watchdog reset

Guangbin Huang (1):
      net: hns3: fix a copying IPv6 address error in hclge_fd_get_flow_tuples()

Hangbin Liu (1):
      net/flow_dissector: remove unexist field description

Jason A. Donenfeld (5):
      icmp: introduce helper for nat'd source address in network device context
      gtp: use icmp_ndo_send helper
      sunvnet: use icmp_ndo_send helper
      wireguard: device: use icmp_ndo_send helper
      xfrm: interface: use icmp_ndo_send helper

Johannes Berg (2):
      mac80211: use more bits for ack_frame_id
      mac80211: consider more elements in parsing CRC

Kunihiko Hayashi (1):
      net: ethernet: ave: Add capability of rgmii-id mode

Li RongQing (1):
      page_pool: refill page when alloc.count of pool is zero

Paul Greenwalt (1):
      ice: display supported and advertised link modes

Per Forlin (2):
      net: dsa: tag_qca: Make sure there is headroom for tag
      net: dsa: tag_ar9331: Make sure there is headroom for tag

Randy Dunlap (1):
      netdevice.h: fix all kernel-doc and Sphinx warnings

Sameeh Jubran (3):
      net: ena: rss: do not allocate key when not supported
      net: ena: rss: fix failure to get indirection table
      net: ena: ethtool: use correct value for crc32 hash

Sara Sharon (1):
      mac80211: fix quiet mode activation in action frames

Sergey Matyukevich (2):
      cfg80211: check wiphy driver existence for drvinfo report
      cfg80211: add missing policy for NL80211_ATTR_STATUS_CODE

Shay Bar (1):
      mac80211: fix wrong 160/80+80 MHz setting

Toke Høiland-Jørgensen (1):
      core: Don't skip generic XDP program execution for cloned SKBs

Tony Nguyen (2):
      ice: Remove possible null dereference
      ice: Trivial fixes

Tuong Lien (1):
      tipc: fix successful connect() but timed out

Ursula Braun (2):
      net/smc: transfer fasync_list in case of fallback
      net/smc: no peer ID in CLC decline for SMCD

William Dauchy (1):
      net, ip6_tunnel: enhance tunnel locate with link check

Yonglong Liu (1):
      net: hns3: fix VF bandwidth does not take effect in some case

Yufeng Mo (1):
      net: hns3: add management table after IMP reset

 drivers/net/dsa/mv88e6xxx/chip.h                        |  12 ++--
 drivers/net/ethernet/amazon/ena/ena_com.c               |  96 +++++++++++++++++-----------
 drivers/net/ethernet/amazon/ena/ena_com.h               |   9 +++
 drivers/net/ethernet/amazon/ena/ena_ethtool.c           |  46 ++++++++++++-
 drivers/net/ethernet/amazon/ena/ena_netdev.c            |   6 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.h            |   2 +
 drivers/net/ethernet/cisco/enic/enic_main.c             |   2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c |  22 +++++--
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c   |   2 +-
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c      |   4 +-
 drivers/net/ethernet/intel/ice/ice_adminq_cmd.h         |   1 +
 drivers/net/ethernet/intel/ice/ice_base.c               |  35 ++++------
 drivers/net/ethernet/intel/ice/ice_common.c             |  37 ++++-------
 drivers/net/ethernet/intel/ice/ice_common.h             |   2 -
 drivers/net/ethernet/intel/ice/ice_dcb.c                |   8 +--
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c            |  99 ++++++++++++----------------
 drivers/net/ethernet/intel/ice/ice_dcb_nl.c             |  20 +++---
 drivers/net/ethernet/intel/ice/ice_ethtool.c            | 355 +++++++++++------------------------------------------------------------------------------------------
 drivers/net/ethernet/intel/ice/ice_hw_autogen.h         |   7 +-
 drivers/net/ethernet/intel/ice/ice_lib.c                |  71 ++++++---------------
 drivers/net/ethernet/intel/ice/ice_lib.h                |   2 -
 drivers/net/ethernet/intel/ice/ice_main.c               | 195 +++++++++++++++++++++----------------------------------
 drivers/net/ethernet/intel/ice/ice_txrx.c               |  11 ++--
 drivers/net/ethernet/intel/ice/ice_txrx.h               |   4 +-
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c           |   2 +-
 drivers/net/ethernet/intel/ice/ice_type.h               |   2 +-
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c        |  67 +++++++------------
 drivers/net/ethernet/intel/ice/ice_xsk.c                |   4 +-
 drivers/net/ethernet/socionext/sni_ave.c                |   9 +++
 drivers/net/ethernet/sun/sunvnet_common.c               |  23 ++-----
 drivers/net/gtp.c                                       |   4 +-
 drivers/net/usb/qmi_wwan.c                              |  43 +++++--------
 drivers/net/wireguard/device.c                          |   4 +-
 include/linux/icmpv6.h                                  |   6 ++
 include/linux/netdevice.h                               |  16 ++++-
 include/net/flow_dissector.h                            |   1 -
 include/net/icmp.h                                      |   6 ++
 include/net/mac80211.h                                  |  11 ++--
 net/core/dev.c                                          |   4 +-
 net/core/page_pool.c                                    |  22 +++----
 net/dsa/tag_ar9331.c                                    |   2 +-
 net/dsa/tag_qca.c                                       |   2 +-
 net/ipv4/icmp.c                                         |  33 ++++++++++
 net/ipv6/ip6_icmp.c                                     |  34 ++++++++++
 net/ipv6/ip6_tunnel.c                                   |  68 ++++++++++++++------
 net/mac80211/cfg.c                                      |   2 +-
 net/mac80211/mlme.c                                     |   8 +--
 net/mac80211/tx.c                                       |   2 +-
 net/mac80211/util.c                                     |  34 +++++++---
 net/mptcp/protocol.c                                    |   2 +-
 net/sched/cls_flower.c                                  |   1 +
 net/sched/cls_matchall.c                                |   1 +
 net/smc/af_smc.c                                        |   2 +
 net/smc/smc_clc.c                                       |   4 +-
 net/smc/smc_diag.c                                      |   5 +-
 net/tipc/node.c                                         |   7 +-
 net/tipc/socket.c                                       |   2 +
 net/wireless/ethtool.c                                  |   8 ++-
 net/wireless/nl80211.c                                  |   1 +
 net/xfrm/xfrm_interface.c                               |   6 +-
 tools/testing/selftests/wireguard/netns.sh              |  11 ++++
 61 files changed, 648 insertions(+), 859 deletions(-)
