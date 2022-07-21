Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 391A757C7A3
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 11:31:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbiGUJbM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 05:31:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231286AbiGUJbL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 05:31:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8C1E37FE47
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 02:31:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658395868;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=2J549jSb/9nKeNj3U2ZcSVr26a1nXfuLJfUG5WUlQj0=;
        b=PGMQRCPZt04praIaohMpLzvEM9ViLoIfkBtgOisHFh30hje1iLzwJl9ZDNvsK6aOfAUL3/
        HiODvBcEnLpzTVpVuCdqNusGUEecwUlBJXz0FDzFZ82TUgKALg56oODCe34yAPCH/7QFlG
        1Z84VyceE6GfPqGoTNIQ5No+VarJrFc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-275-DjPqsFovN-Olr3HITzQyeg-1; Thu, 21 Jul 2022 05:31:03 -0400
X-MC-Unique: DjPqsFovN-Olr3HITzQyeg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9ABA0811E75;
        Thu, 21 Jul 2022 09:31:02 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.194.129])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 72B351121314;
        Thu, 21 Jul 2022 09:31:01 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Networking for 5.19-rc8
Date:   Thu, 21 Jul 2022 11:30:51 +0200
Message-Id: <20220721093051.14504-1-pabeni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus!

Still no major regressions, most of the changes are still
due to data races fixes, plus the usual bunch of drivers
fixes.

The following changes since commit db886979683a8360ced9b24ab1125ad0c4d2cf76:

  x86/speculation: Use DECLARE_PER_CPU for x86_spec_ctrl_current (2022-07-14 14:52:43 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.19-rc8

for you to fetch changes up to 44484fa8eedf1c6e8f23ba2675b266abdd170a6e:

  Merge tag 'linux-can-fixes-for-5.19-20220720' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can (2022-07-20 11:13:54 +0100)

----------------------------------------------------------------
Networking fixes for 5.19-rc8, including fixes from can.

Previous releases - regressions:
  - tcp/udp: make early_demux back namespacified.

  - dsa: fix issues with vlan_filtering_is_global

Previous releases - always broken:
  - ip: fix data-races around ipv4_net_table (round 2, 3 & 4)

  - amt: fix validation and synchronization bugs

  - can: fix detection of mcp251863

  - eth: iavf: fix handling of dummy receive descriptors

  - eth: lan966x: fix issues with MAC table

  - eth: stmmac: dwmac-mediatek: fix clock issue

Misc:
  - dsa: update documentation

Signed-off-by: Paolo Abeni <pabeni@redhat.com>

----------------------------------------------------------------
Biao Huang (3):
      stmmac: dwmac-mediatek: fix clock issue
      net: stmmac: fix pm runtime issue in stmmac_dvr_remove()
      net: stmmac: fix unbalanced ptp clock issue in suspend/resume flow

David S. Miller (7):
      Merge branch 'net-sysctl-races-round2'
      Merge branch 'stmmac-dwmac-mediatec-clock-fix'
      Merge branch 'net-ipv4-sysctl-races-part-3'
      Merge branch 'dsa-docs'
      Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec
      Merge branch 'net-sysctl-races-round-4'
      Merge tag 'linux-can-fixes-for-5.19-20220720' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can

Dawid Lukwinski (1):
      i40e: Fix erroneous adapter reinitialization during recovery process

Hangyu Hua (1):
      xfrm: xfrm_policy: fix a possible double xfrm_pols_put() in xfrm_bundle_lookup()

Hayes Wang (1):
      r8152: fix a WOL issue

Horatiu Vultur (5):
      net: lan966x: Fix taking rtnl_lock while holding spin_lock
      net: lan966x: Fix usage of lan966x->mac_lock when entry is added
      net: lan966x: Fix usage of lan966x->mac_lock when entry is removed
      net: lan966x: Fix usage of lan966x->mac_lock inside lan966x_mac_irq_handler
      net: lan966x: Fix usage of lan966x->mac_lock when used by FDB

Hristo Venev (1):
      be2net: Fix buffer overflow in be_get_module_eeprom

Ido Schimmel (1):
      mlxsw: spectrum_router: Fix IPv4 nexthop gateway indication

Jakub Kicinski (4):
      Merge branch '1GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue
      Merge branch 'net-lan966x-fix-issues-with-mac-table'
      Merge branch 'fix-2-dsa-issues-with-vlan_filtering_is_global'
      Merge branch '40GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue

Junxiao Chang (1):
      net: stmmac: fix dma queue left shift overflow issue

Justin Stitt (1):
      net: ipv4: fix clang -Wformat warnings

Kuniyuki Iwashima (46):
      ip: Fix data-races around sysctl_ip_default_ttl.
      ip: Fix data-races around sysctl_ip_no_pmtu_disc.
      ip: Fix data-races around sysctl_ip_fwd_use_pmtu.
      ip: Fix data-races around sysctl_ip_fwd_update_priority.
      ip: Fix data-races around sysctl_ip_nonlocal_bind.
      ip: Fix a data-race around sysctl_ip_autobind_reuse.
      ip: Fix a data-race around sysctl_fwmark_reflect.
      tcp/dccp: Fix a data-race around sysctl_tcp_fwmark_accept.
      tcp: Fix data-races around sysctl_tcp_l3mdev_accept.
      tcp: Fix data-races around sysctl_tcp_mtu_probing.
      tcp: Fix data-races around sysctl_tcp_base_mss.
      tcp: Fix data-races around sysctl_tcp_min_snd_mss.
      tcp: Fix a data-race around sysctl_tcp_mtu_probe_floor.
      tcp: Fix a data-race around sysctl_tcp_probe_threshold.
      tcp: Fix a data-race around sysctl_tcp_probe_interval.
      tcp/udp: Make early_demux back namespacified.
      igmp: Fix data-races around sysctl_igmp_llm_reports.
      igmp: Fix a data-race around sysctl_igmp_max_memberships.
      igmp: Fix data-races around sysctl_igmp_max_msf.
      igmp: Fix data-races around sysctl_igmp_qrv.
      tcp: Fix data-races around keepalive sysctl knobs.
      tcp: Fix data-races around sysctl_tcp_syn(ack)?_retries.
      tcp: Fix data-races around sysctl_tcp_syncookies.
      tcp: Fix data-races around sysctl_tcp_migrate_req.
      tcp: Fix data-races around sysctl_tcp_reordering.
      tcp: Fix data-races around some timeout sysctl knobs.
      tcp: Fix a data-race around sysctl_tcp_notsent_lowat.
      tcp: Fix a data-race around sysctl_tcp_tw_reuse.
      tcp: Fix data-races around sysctl_max_syn_backlog.
      tcp: Fix data-races around sysctl_tcp_fastopen.
      tcp: Fix data-races around sysctl_tcp_fastopen_blackhole_timeout.
      ipv4: Fix a data-race around sysctl_fib_multipath_use_neigh.
      ipv4: Fix data-races around sysctl_fib_multipath_hash_policy.
      ipv4: Fix data-races around sysctl_fib_multipath_hash_fields.
      ip: Fix data-races around sysctl_ip_prot_sock.
      udp: Fix a data-race around sysctl_udp_l3mdev_accept.
      tcp: Fix data-races around sysctl knobs related to SYN option.
      tcp: Fix a data-race around sysctl_tcp_early_retrans.
      tcp: Fix data-races around sysctl_tcp_recovery.
      tcp: Fix a data-race around sysctl_tcp_thin_linear_timeouts.
      tcp: Fix data-races around sysctl_tcp_slow_start_after_idle.
      tcp: Fix a data-race around sysctl_tcp_retrans_collapse.
      tcp: Fix a data-race around sysctl_tcp_stdurg.
      tcp: Fix a data-race around sysctl_tcp_rfc1337.
      tcp: Fix a data-race around sysctl_tcp_abort_on_overflow.
      tcp: Fix data-races around sysctl_tcp_max_reordering.

Lennert Buytenhek (1):
      igc: Reinstate IGC_REMOVED logic and implement it properly

Liang He (2):
      net: dsa: microchip: ksz_common: Fix refcount leak bug
      can: rcar_canfd: Add missing of_node_put() in rcar_canfd_probe()

Lorenzo Bianconi (1):
      net: ethernet: mtk_ppe: fix possible NULL pointer dereference in mtk_flow_get_wdma_info

Maksym Glubokiy (1):
      net: prestera: acl: use proper mask for port selector

Marc Kleine-Budde (1):
      can: mcp251xfd: fix detection of mcp251863

Oleksij Rempel (2):
      net: dsa: sja1105: silent spi_device_id warnings
      net: dsa: vitesse-vsc73xx: silent spi_device_id warnings

Oz Shlomo (1):
      net/sched: cls_api: Fix flow action initialization

Paolo Abeni (1):
      Merge branch 'amt-fix-validation-and-synchronization-bugs'

Piotr Skajewski (1):
      ixgbe: Add locking to prevent panic when setting sriov_numvfs to zero

Przemyslaw Patynowski (4):
      iavf: Fix VLAN_V2 addition/rejection
      iavf: Disallow changing rx/tx-frames and rx/tx-frames-irq
      iavf: Fix handling of dummy receive descriptors
      iavf: Fix missing state logs

Sasha Neftin (2):
      e1000e: Enable GPT clock before sending message to CSME
      Revert "e1000e: Fix possible HW unit hang after an s0ix exit"

Taehee Yoo (8):
      amt: use workqueue for gateway side message handling
      amt: remove unnecessary locks
      amt: use READ_ONCE() in amt module
      amt: add missing regeneration nonce logic in request logic
      amt: drop unexpected advertisement message
      amt: drop unexpected query message
      amt: drop unexpected multicast data
      amt: do not use amt->nr_tunnels outside of lock

Tariq Toukan (1):
      net/tls: Fix race in TLS device down flow

Tom Rix (1):
      net: ethernet: mtk_eth_soc: fix off by one check of ARRAY_SIZE

Vladimir Oltean (17):
      docs: net: dsa: update probing documentation
      docs: net: dsa: document the shutdown behavior
      docs: net: dsa: rename tag_protocol to get_tag_protocol
      docs: net: dsa: add more info about the other arguments to get_tag_protocol
      docs: net: dsa: document change_tag_protocol
      docs: net: dsa: document the teardown method
      docs: net: dsa: document port_setup and port_teardown
      docs: net: dsa: document port_fast_age
      docs: net: dsa: remove port_bridge_tx_fwd_offload
      docs: net: dsa: remove port_vlan_dump
      docs: net: dsa: delete port_mdb_dump
      docs: net: dsa: add a section for address databases
      docs: net: dsa: re-explain what port_fdb_dump actually does
      docs: net: dsa: delete misinformation about -EOPNOTSUPP for FDB/MDB/VLAN
      docs: net: dsa: mention that VLANs are now refcounted on shared ports
      net: dsa: fix dsa_port_vlan_filtering when global
      net: dsa: fix NULL pointer dereference in dsa_port_reset_vlan_filtering

Wong Vee Khee (2):
      net: stmmac: switch to use interrupt for hw crosstimestamping
      net: stmmac: remove redunctant disable xPCS EEE call

Xin Long (1):
      Documentation: fix udp_wmem_min in ip-sysctl.rst

 Documentation/networking/dsa/dsa.rst               | 363 +++++++++++++++++----
 Documentation/networking/ip-sysctl.rst             |   6 +-
 drivers/net/amt.c                                  | 243 +++++++++++---
 drivers/net/can/rcar/rcar_canfd.c                  |   1 +
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c     |  18 +-
 drivers/net/dsa/microchip/ksz_common.c             |   5 +-
 drivers/net/dsa/sja1105/sja1105_main.c             |  16 +
 drivers/net/dsa/vitesse-vsc73xx-spi.c              |  10 +
 .../chelsio/inline_crypto/chtls/chtls_cm.c         |   6 +-
 drivers/net/ethernet/emulex/benet/be_cmds.c        |  10 +-
 drivers/net/ethernet/emulex/benet/be_cmds.h        |   2 +-
 drivers/net/ethernet/emulex/benet/be_ethtool.c     |  31 +-
 drivers/net/ethernet/intel/e1000e/hw.h             |   1 -
 drivers/net/ethernet/intel/e1000e/ich8lan.c        |   4 -
 drivers/net/ethernet/intel/e1000e/ich8lan.h        |   1 -
 drivers/net/ethernet/intel/e1000e/netdev.c         |  30 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |  13 +-
 drivers/net/ethernet/intel/iavf/iavf.h             |  14 +-
 drivers/net/ethernet/intel/iavf/iavf_ethtool.c     |  10 -
 drivers/net/ethernet/intel/iavf/iavf_main.c        |  11 +-
 drivers/net/ethernet/intel/iavf/iavf_txrx.c        |   7 +-
 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c    |  65 +++-
 drivers/net/ethernet/intel/igc/igc_main.c          |   3 +
 drivers/net/ethernet/intel/igc/igc_regs.h          |   5 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe.h           |   1 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |   3 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c     |   6 +
 .../ethernet/marvell/prestera/prestera_flower.c    |   6 +-
 drivers/net/ethernet/mediatek/mtk_ppe_offload.c    |   3 +
 drivers/net/ethernet/mediatek/mtk_wed.c            |   2 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_router.c  |   9 +-
 .../net/ethernet/microchip/lan966x/lan966x_mac.c   | 112 +++++--
 drivers/net/ethernet/netronome/nfp/flower/action.c |   2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c  |  25 +-
 .../net/ethernet/stmicro/stmmac/dwmac-mediatek.c   |  49 ++-
 drivers/net/ethernet/stmicro/stmmac/dwmac4.h       |   3 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c  |   7 +
 drivers/net/ethernet/stmicro/stmmac/stmmac.h       |   1 +
 .../net/ethernet/stmicro/stmmac/stmmac_ethtool.c   |   8 -
 .../net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c  |   5 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  22 +-
 .../net/ethernet/stmicro/stmmac/stmmac_platform.c  |   8 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c   |  12 +-
 drivers/net/usb/r8152.c                            |  16 +-
 include/linux/stmmac.h                             |   1 +
 include/net/amt.h                                  |  20 ++
 include/net/inet_hashtables.h                      |   2 +-
 include/net/inet_sock.h                            |   9 +-
 include/net/ip.h                                   |   6 +-
 include/net/protocol.h                             |   4 -
 include/net/route.h                                |   2 +-
 include/net/tcp.h                                  |  20 +-
 include/net/udp.h                                  |   4 +-
 net/core/filter.c                                  |   4 +-
 net/core/secure_seq.c                              |   4 +-
 net/core/sock_reuseport.c                          |   4 +-
 net/dsa/port.c                                     |   7 +-
 net/ipv4/af_inet.c                                 |  18 +-
 net/ipv4/ah4.c                                     |   2 +-
 net/ipv4/esp4.c                                    |   2 +-
 net/ipv4/fib_semantics.c                           |   2 +-
 net/ipv4/icmp.c                                    |   2 +-
 net/ipv4/igmp.c                                    |  49 +--
 net/ipv4/inet_connection_sock.c                    |   5 +-
 net/ipv4/ip_forward.c                              |   2 +-
 net/ipv4/ip_input.c                                |  37 ++-
 net/ipv4/ip_sockglue.c                             |   8 +-
 net/ipv4/netfilter/nf_reject_ipv4.c                |   4 +-
 net/ipv4/proc.c                                    |   2 +-
 net/ipv4/route.c                                   |  10 +-
 net/ipv4/syncookies.c                              |   9 +-
 net/ipv4/sysctl_net_ipv4.c                         |  65 +---
 net/ipv4/tcp.c                                     |  13 +-
 net/ipv4/tcp_fastopen.c                            |   9 +-
 net/ipv4/tcp_input.c                               |  51 +--
 net/ipv4/tcp_ipv4.c                                |   2 +-
 net/ipv4/tcp_metrics.c                             |   3 +-
 net/ipv4/tcp_minisocks.c                           |   4 +-
 net/ipv4/tcp_output.c                              |  29 +-
 net/ipv4/tcp_recovery.c                            |   6 +-
 net/ipv4/tcp_timer.c                               |  30 +-
 net/ipv6/af_inet6.c                                |   2 +-
 net/ipv6/ip6_input.c                               |  23 +-
 net/ipv6/syncookies.c                              |   3 +-
 net/ipv6/tcp_ipv6.c                                |   9 +-
 net/ipv6/udp.c                                     |   9 +-
 net/netfilter/nf_synproxy_core.c                   |   2 +-
 net/sched/cls_api.c                                |  16 +-
 net/sctp/protocol.c                                |   2 +-
 net/smc/smc_llc.c                                  |   2 +-
 net/tls/tls_device.c                               |   8 +-
 net/xfrm/xfrm_policy.c                             |   5 +-
 net/xfrm/xfrm_state.c                              |   2 +-
 93 files changed, 1117 insertions(+), 592 deletions(-)

