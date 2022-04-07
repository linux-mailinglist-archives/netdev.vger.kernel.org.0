Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 726F54F8709
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 20:21:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240306AbiDGSXz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 14:23:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346828AbiDGSXy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 14:23:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8244023009E
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 11:21:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649355712;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=HT6hWnHBxjkfGOyz8y4FNQZbi9LKgRDaVm7NguehLRo=;
        b=GBme23IY4DvBGA+9pPJDOvR0g8JppiLS1tthE4aCobOUP+YZ0EEvy56bqxO28lUFdtngZC
        ba+lXGzMF+spxCHASwZNSHB/X+ejjsv1GWLO38doyfnKBDlvTKt58NgA9ihyQk51y+ug4d
        n916YGqOLFH5anEs40YgZdgiYOXGy0s=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-56-tCo8doFOPgOQsPvWij2wYQ-1; Thu, 07 Apr 2022 14:21:49 -0400
X-MC-Unique: tCo8doFOPgOQsPvWij2wYQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1BE4138025FF;
        Thu,  7 Apr 2022 18:21:49 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.196.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 834C242D3A0;
        Thu,  7 Apr 2022 18:21:47 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Networking for 5.18-rc2
Date:   Thu,  7 Apr 2022 20:21:27 +0200
Message-Id: <20220407182127.55769-1-pabeni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus!

The following changes since commit 2975dbdc3989cd66a4cb5a7c5510de2de8ee4d14:

  Merge tag 'net-5.18-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2022-03-31 11:23:31 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.18-rc2

for you to fetch changes up to ec4eb8a86ade4d22633e1da2a7d85a846b7d1798:

  drivers: net: slip: fix NPD bug in sl_tx_timeout() (2022-04-06 23:00:16 -0700)

----------------------------------------------------------------
Networking fixes for 5.18-rc2, including fixes from bpf and netfilter

Current release - new code bugs:
  - mctp: correct mctp_i2c_header_create result

  - eth: fungible: fix reference to __udivdi3 on 32b builds

  - eth: micrel: remove latencies support lan8814

Previous releases - regressions:
  - bpf: resolve to prog->aux->dst_prog->type only for BPF_PROG_TYPE_EXT

  - vrf: fix packet sniffing for traffic originating from ip tunnels

  - rxrpc: fix a race in rxrpc_exit_net()

  - dsa: revert "net: dsa: stop updating master MTU from master.c"

  - eth: ice: fix MAC address setting

Previous releases - always broken:
  - tls: fix slab-out-of-bounds bug in decrypt_internal

  - bpf: support dual-stack sockets in bpf_tcp_check_syncookie

  - xdp: fix coalescing for page_pool fragment recycling

  - ovs: fix leak of nested actions

  - eth: sfc:
    - add missing xdp queue reinitialization
    - fix using uninitialized xdp tx_queue

  - eth: ice:
    - clear default forwarding VSI during VSI release
    - fix broken IFF_ALLMULTI handling
    - synchronize_rcu() when terminating rings

  - eth: qede: confirm skb is allocated before using

  - eth: aqc111: fix out-of-bounds accesses in RX fixup

  - eth: slip: fix NPD bug in sl_tx_timeout()

Signed-off-by: Paolo Abeni <pabeni@redhat.com>

----------------------------------------------------------------
Anatolii Gerasymenko (2):
      ice: Set txq_teid to ICE_INVAL_TEID on ring creation
      ice: Do not skip not enabled queues in ice_vc_dis_qs_msg

Andrew Lunn (1):
      net: ethernet: mv643xx: Fix over zealous checking of_get_mac_address()

Andy Chiu (4):
      net: axienet: setup mdio unconditionally
      net: axienet: factor out phy_node in struct axienet_local
      dt-bindings: net: add pcs-handle attribute
      net: axiemac: use a phandle to reference pcs_phy

Andy Gospodarek (1):
      bnxt_en: reserve space inside receive page for skb_shared_info

Bjorn Helgaas (1):
      docs: net: dsa: fix minor grammar and punctuation issues

Chen-Yu Tsai (1):
      net: stmmac: Fix unset max_speed difference between DT and non-DT platforms

David Ahern (1):
      ipv6: Fix stats accounting in ip6_pkt_drop

David S. Miller (7):
      Merge branch 'ice-fixups'
      Merge branch 'MCTP-fixes'
      Merge branch 'nexthop-route-deletye-warning'
      Merge branch 'micrel-lan8814-remove-latencies'
      Merge branch 'bnxt_en-fixes'
      Merge branch 'axienet-broken-link'
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue

Delyan Kratunov (1):
      bpftool: Explicit errno handling in skeletons

Dimitris Michailidis (1):
      net/fungible: Fix reference to __udivdi3 on 32b builds

Duoming Zhou (1):
      drivers: net: slip: fix NPD bug in sl_tx_timeout()

Eric Dumazet (1):
      rxrpc: fix a race in rxrpc_exit_net()

Eyal Birger (1):
      vrf: fix packet sniffing for traffic originating from ip tunnels

Florian Westphal (1):
      net: ipv6mr: fix unused variable warning with CONFIG_IPV6_PIMSM_V2=n

Haowen Bai (1):
      selftests/bpf: Fix warning comparing pointer to 0

Horatiu Vultur (4):
      dt-bindings: net: micrel: Revert latency support and timestamping check
      net: phy: micrel: Remove latency from driver
      net: phy: micrel: Remove DT option lan8814,ignore-ts
      net: micrel: Fix KS8851 Kconfig

Ilya Maximets (2):
      net: openvswitch: don't send internal clone attribute to the userspace.
      net: openvswitch: fix leak of nested actions

Ivan Vecera (3):
      ice: Clear default forwarding VSI during VSI release
      ice: Fix MAC address setting
      ice: Fix broken IFF_ALLMULTI handling

Jakub Kicinski (2):
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf
      Merge https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf

Jamie Bainbridge (2):
      sctp: count singleton chunks in assoc user stats
      qede: confirm skb is allocated before using

Jean-Philippe Brucker (1):
      skbuff: fix coalescing for page_pool fragment recycling

Jeremy Sowden (1):
      netfilter: bitwise: fix reduce comparisons

Jiri Olsa (1):
      bpf: Fix sparse warnings in kprobe_multi_resolve_syms

Maciej Fijalkowski (3):
      ice: synchronize_rcu() when terminating rings
      ice: xsk: fix VSI state check in ice_xsk_wakeup()
      ice: clear cmd_type_offset_bsz for TX rings

Manish Chopra (1):
      qed: fix ethtool register dump

Marcin Kozlowski (1):
      net: usb: aqc111: Fix out-of-bounds accesses in RX fixup

Martin Habets (1):
      sfc: Do not free an empty page_ring

Martin KaFai Lau (2):
      bpf: Resolve to prog->aux->dst_prog->type only for BPF_PROG_TYPE_EXT
      bpf: selftests: Test fentry tracing a struct_ops program

Masami Hiramatsu (1):
      rethook: Fix to use WRITE_ONCE() for rethook:: Handler

Matt Johnston (3):
      mctp: Fix check for dev_hard_header() result
      mctp i2c: correct mctp_i2c_header_create result
      mctp: Use output netdev to allocate skb headroom

Maxim Mikityanskiy (2):
      bpf: Support dual-stack sockets in bpf_tcp_check_syncookie
      bpf: Adjust bpf_tcp_check_syncookie selftest to test dual-stack sockets

Miaoqian Lin (1):
      dpaa2-ptp: Fix refcount leak in dpaa2_ptp_probe

Michael Walle (1):
      net: phy: mscc-miim: reject clause 45 register accesses

Nikolay Aleksandrov (3):
      net: ipv4: fix route with nexthop object delete warning
      selftests: net: add delete nexthop route warning test
      selftests: net: fix nexthop warning cleanup double ip typo

Paolo Abeni (1):
      Merge branch 'ice-bug-fixes'

Pavan Chebbi (1):
      bnxt_en: Synchronize tx when xdp redirects happen on same ring

Randy Dunlap (1):
      net: micrel: fix KS8851_MLL Kconfig

Ray Jui (1):
      bnxt_en: Prevent XDP redirect from running when stopping TX queue

Taehee Yoo (2):
      net: sfc: add missing xdp queue reinitialization
      net: sfc: fix using uninitialized xdp tx_queue

Tom Rix (1):
      stmmac: dwmac-loongson: change loongson_dwmac_driver from global to static

Vasily Averin (1):
      netfilter: nf_tables: memcg accounting for dynamically allocated objects

Vladimir Oltean (1):
      Revert "net: dsa: stop updating master MTU from master.c"

Xiaomeng Tong (1):
      myri10ge: fix an incorrect free for skb in myri10ge_sw_tso

Ziyang Xuan (1):
      net/tls: fix slab-out-of-bounds bug in decrypt_internal

 .../bindings/net/ethernet-controller.yaml          |   6 +
 Documentation/devicetree/bindings/net/micrel.txt   |  17 ---
 .../devicetree/bindings/net/xilinx_axienet.txt     |   8 +-
 Documentation/networking/dsa/dsa.rst               |  64 ++++-----
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |   7 +
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |   5 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c      |  14 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h      |   2 +
 drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.c   |   4 +-
 drivers/net/ethernet/fungible/funcore/fun_dev.c    |   4 +-
 drivers/net/ethernet/intel/ice/ice.h               |   3 +-
 drivers/net/ethernet/intel/ice/ice_fltr.c          |  44 +++++-
 drivers/net/ethernet/intel/ice/ice_lib.c           |   3 +
 drivers/net/ethernet/intel/ice/ice_main.c          | 127 ++++++++++++------
 drivers/net/ethernet/intel/ice/ice_virtchnl.c      |   4 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c           |   6 +-
 drivers/net/ethernet/marvell/mv643xx_eth.c         |   2 +-
 drivers/net/ethernet/micrel/Kconfig                |   2 +
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c   |   6 +-
 drivers/net/ethernet/qlogic/qed/qed_debug.c        |   2 +-
 drivers/net/ethernet/qlogic/qede/qede_fp.c         |   3 +
 drivers/net/ethernet/sfc/efx_channels.c            | 148 ++++++++++++---------
 drivers/net/ethernet/sfc/rx_common.c               |   3 +
 drivers/net/ethernet/sfc/tx.c                      |   3 +
 drivers/net/ethernet/sfc/tx_common.c               |   2 +
 .../net/ethernet/stmicro/stmmac/dwmac-loongson.c   |   2 +-
 .../net/ethernet/stmicro/stmmac/stmmac_platform.c  |   3 +-
 drivers/net/ethernet/xilinx/xilinx_axienet.h       |   2 -
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  |  33 ++---
 drivers/net/mctp/mctp-i2c.c                        |   2 +-
 drivers/net/mdio/mdio-mscc-miim.c                  |   6 +
 drivers/net/phy/micrel.c                           | 106 +--------------
 drivers/net/slip/slip.c                            |   2 +-
 drivers/net/usb/aqc111.c                           |   9 +-
 drivers/net/vrf.c                                  |  15 ++-
 include/linux/bpf_verifier.h                       |   4 +-
 include/net/mctp.h                                 |   2 -
 kernel/trace/bpf_trace.c                           |   4 +-
 kernel/trace/rethook.c                             |   2 +-
 net/core/filter.c                                  |  17 ++-
 net/core/skbuff.c                                  |  15 ++-
 net/dsa/master.c                                   |  25 +++-
 net/ipv4/fib_semantics.c                           |   7 +-
 net/ipv6/ip6mr.c                                   |   2 +-
 net/ipv6/route.c                                   |   2 +-
 net/mctp/af_mctp.c                                 |  46 +++++--
 net/mctp/route.c                                   |  16 ++-
 net/netfilter/nf_tables_api.c                      |   2 +-
 net/netfilter/nft_bitwise.c                        |   4 +-
 net/netfilter/nft_connlimit.c                      |   2 +-
 net/netfilter/nft_counter.c                        |   2 +-
 net/netfilter/nft_last.c                           |   2 +-
 net/netfilter/nft_limit.c                          |   2 +-
 net/netfilter/nft_quota.c                          |   2 +-
 net/openvswitch/actions.c                          |   2 +-
 net/openvswitch/flow_netlink.c                     |  99 +++++++++++++-
 net/rxrpc/net_ns.c                                 |   2 +-
 net/sctp/outqueue.c                                |   6 +-
 net/tls/tls_sw.c                                   |   2 +-
 tools/bpf/bpftool/gen.c                            |  22 ++-
 .../selftests/bpf/prog_tests/dummy_st_ops.c        |  23 ++++
 tools/testing/selftests/bpf/progs/map_ptr_kern.c   |   4 +-
 .../selftests/bpf/progs/trace_dummy_st_ops.c       |  21 +++
 .../selftests/bpf/test_tcp_check_syncookie_user.c  |  78 ++++++++---
 tools/testing/selftests/net/fib_nexthops.sh        |  14 ++
 65 files changed, 712 insertions(+), 388 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/trace_dummy_st_ops.c

