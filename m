Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A3F0485A30
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 21:45:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244179AbiAEUpe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 15:45:34 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:55716 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231591AbiAEUpd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 15:45:33 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6608BB81D6D;
        Wed,  5 Jan 2022 20:45:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0A16C36AE9;
        Wed,  5 Jan 2022 20:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641415531;
        bh=G7G9G+DNY8AQXWaodNb7uY5xeH89Trio4fhtqX8RDis=;
        h=From:To:Cc:Subject:Date:From;
        b=tNFzoQ4NpV/Bn6E2XIV+Yaa6ujiMyq6eqcmvNSIZV2avo7ACXhMzgh/brzF+5BUoD
         PjTmA9DsNSjNBN8Jjz41/QX99go6ZAydjktxW8Jp7yZSTxF9y2+kfnIjeF/QGBYcfX
         QPw506ttW3X0Rfp7IH9HeKAq/1Ass2e+a7mFnqrV3Wpf8frKNKXRHJIutyEwn2iWfL
         2xWOSbz0FjJeevsEotlbvF8so9tzzoupYElQSd4brcFhFUIlWbU0tySa1Db3GbwuRn
         NVimxwXzwfXGcfQCVxDj9aFaO787tmHCKGm5TvqCozRK+5QxevYb/3whoLWAdlwHun
         PQwYKjfPVDBEQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Networking for 5.16-final
Date:   Wed,  5 Jan 2022 12:45:30 -0800
Message-Id: <20220105204530.3706167-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus!

One last PR, turns out some of the recent fixes did more harm than good.

The following changes since commit 74c78b4291b4466b44a57b3b7c3b98ad02628686:

  Merge tag 'net-5.16-rc8' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2021-12-30 11:12:12 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.16-final

for you to fetch changes up to db54c12a3d7e3eedd37aa08efc9362e905f07716:

  selftests: set amt.sh executable (2022-01-05 10:27:19 -0800)

----------------------------------------------------------------
Networking fixes for 5.16-final, including fixes from bpf, and WiFi.

Current release - regressions:

  - Revert "xsk: Do not sleep in poll() when need_wakeup set",
    made the problem worse

  - Revert "net: phy: fixed_phy: Fix NULL vs IS_ERR() checking in
    __fixed_phy_register", broke EPROBE_DEFER handling

  - Revert "net: usb: r8152: Add MAC pass-through support for more
    Lenovo Docks", broke setups without a Lenovo dock

Current release - new code bugs:

  - selftests: set amt.sh executable

Previous releases - regressions:

  - batman-adv: mcast: don't send link-local multicast to mcast routers

Previous releases - always broken:

  - ipv4/ipv6: check attribute length for RTA_FLOW / RTA_GATEWAY

  - sctp: hold endpoint before calling cb in
	sctp_transport_lookup_process

  - mac80211: mesh: embed mesh_paths and mpp_paths into
    ieee80211_if_mesh to avoid complicated handling of sub-object
    allocation failures

  - seg6: fix traceroute in the presence of SRv6

  - tipc: fix a kernel-infoleak in __tipc_sendmsg()

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Aaron Ma (1):
      Revert "net: usb: r8152: Add MAC passthrough support for more Lenovo Docks"

Andrew Lunn (3):
      seg6: export get_srh() for ICMP handling
      icmp: ICMPV6: Examine invoking packet for Segment Route Headers.
      udp6: Use Segment Routing Header for dest address if present

Arthur Kiyanovski (3):
      net: ena: Fix undefined state when tx request id is out of bounds
      net: ena: Fix wrong rx request id by resetting device
      net: ena: Fix error handling when calculating max IO queues number

Christoph Hellwig (1):
      netrom: fix copying in user data in nr_setsockopt

Colin Ian King (1):
      bpf, selftests: Fix spelling mistake "tained" -> "tainted"

David Ahern (7):
      ipv4: Check attribute length for RTA_GATEWAY in multipath route
      ipv4: Check attribute length for RTA_FLOW in multipath route
      ipv6: Check attribute length for RTA_GATEWAY in multipath route
      ipv6: Check attribute length for RTA_GATEWAY when deleting multipath route
      lwtunnel: Validate RTA_ENCAP_TYPE attribute length
      ipv6: Continue processing multipath route even if gateway attribute is invalid
      ipv6: Do cleanup if attribute validation fails in multipath route

David S. Miller (4):
      Merge branch 'mpr-len-checks' David Ahern says:
      Merge branch 'ena-fixes'
      Merge branch 'srv6-traceroute'
      Merge branch '40GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue

Di Zhu (1):
      i40e: fix use-after-free in i40e_sync_filters_subtask()

Eric Dumazet (1):
      sch_qfq: prevent shift-out-of-bounds in qfq_init_qdisc

Florian Fainelli (1):
      Revert "net: phy: fixed_phy: Fix NULL vs IS_ERR() checking in __fixed_phy_register"

Gagan Kumar (1):
      mctp: Remove only static neighbour on RTM_DELNEIGH

Haimin Zhang (1):
      net ticp:fix a kernel-infoleak in __tipc_sendmsg()

Jakub Kicinski (4):
      Merge https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf
      Merge tag 'batadv-net-pullrequest-20220103' of git://git.open-mesh.org/linux-merge
      Merge tag 'mac80211-for-net-2022-01-04' of git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211
      Merge tag 'ieee802154-for-net-2022-01-05' of git://git.kernel.org/pub/scm/linux/kernel/git/sschmidt/wpan

Jedrzej Jagielski (1):
      i40e: Fix incorrect netdev's real number of RX/TX queues

Jianguo Wu (1):
      selftests: net: udpgro_fwd.sh: explicitly checking the available ping feature

Karen Sornek (1):
      iavf: Fix limit of total number of queues to active queues of VF

Linus Lüssing (1):
      batman-adv: mcast: don't send link-local multicast to mcast routers

Magnus Karlsson (1):
      Revert "xsk: Do not sleep in poll() when need_wakeup set"

Markus Koch (1):
      net/fsl: Remove leftover definition in xgmac_mdio

Martin Habets (1):
      sfc: The RX page_ring is optional

Mateusz Palczewski (2):
      i40e: Fix to not show opcode msg on unsuccessful VF MAC change
      i40e: Fix for displaying message regarding NVM version

Pavel Skripkin (2):
      mac80211: mesh: embedd mesh_paths and mpp_paths into ieee80211_if_mesh
      ieee802154: atusb: fix uninit value in atusb_set_extended_addr

Taehee Yoo (1):
      selftests: set amt.sh executable

Thomas Toye (1):
      rndis_host: support Hytera digital radios

Tom Rix (1):
      mac80211: initialize variable have_higher_than_11mbit

Xin Long (1):
      sctp: hold endpoint before calling cb in sctp_transport_lookup_process

 drivers/net/ethernet/amazon/ena/ena_netdev.c       | 49 +++++++-----
 drivers/net/ethernet/freescale/xgmac_mdio.c        |  1 -
 drivers/net/ethernet/intel/i40e/i40e_main.c        | 60 ++++++++++++---
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c | 40 ++++++++--
 drivers/net/ethernet/intel/iavf/iavf_main.c        |  5 +-
 drivers/net/ethernet/sfc/falcon/rx.c               |  5 ++
 drivers/net/ethernet/sfc/rx_common.c               |  5 ++
 drivers/net/ieee802154/atusb.c                     | 10 ++-
 drivers/net/phy/fixed_phy.c                        |  4 +-
 drivers/net/usb/r8152.c                            |  9 ++-
 drivers/net/usb/rndis_host.c                       |  5 ++
 include/linux/ipv6.h                               |  2 +
 include/net/sctp/sctp.h                            |  3 +-
 include/net/seg6.h                                 | 21 +++++
 net/batman-adv/multicast.c                         | 15 ++--
 net/batman-adv/multicast.h                         | 10 ++-
 net/batman-adv/soft-interface.c                    |  7 +-
 net/core/lwtunnel.c                                |  4 +
 net/ipv4/fib_semantics.c                           | 49 ++++++++++--
 net/ipv6/icmp.c                                    |  6 +-
 net/ipv6/route.c                                   | 32 +++++++-
 net/ipv6/seg6.c                                    | 59 ++++++++++++++
 net/ipv6/seg6_local.c                              | 33 +-------
 net/ipv6/udp.c                                     |  3 +-
 net/mac80211/ieee80211_i.h                         | 24 +++++-
 net/mac80211/mesh.h                                | 22 +-----
 net/mac80211/mesh_pathtbl.c                        | 89 ++++++++--------------
 net/mac80211/mlme.c                                |  2 +-
 net/mctp/neigh.c                                   |  9 ++-
 net/netrom/af_netrom.c                             |  2 +-
 net/sched/sch_qfq.c                                |  6 +-
 net/sctp/diag.c                                    | 46 +++++------
 net/sctp/socket.c                                  | 22 ++++--
 net/tipc/socket.c                                  |  2 +
 net/xdp/xsk.c                                      |  4 +-
 .../selftests/bpf/verifier/value_ptr_arith.c       |  2 +-
 tools/testing/selftests/net/amt.sh                 |  0
 tools/testing/selftests/net/udpgro_fwd.sh          |  3 +-
 38 files changed, 441 insertions(+), 229 deletions(-)
 mode change 100644 => 100755 tools/testing/selftests/net/amt.sh
