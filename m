Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F32A5448F2
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 12:33:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231833AbiFIKdH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 06:33:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234267AbiFIKdF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 06:33:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7BF9020FC7A
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 03:33:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654770782;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=eRxdTz4yW41CxfjCE2W/eUQxQ161Gux1wh2V1ifzQhM=;
        b=NsBh5gedf6sB7uQaSBNZANKp+TGLDqCcYtlrN/HJ7aydRDosledalYi+8uqRkruDAu1UZt
        RJ4Mplmk/oOLFo5bvoA71jUkTVStD+Ka//C9jaNtW/rfM4vr8fPJ7GJzXmE2j28/Rl8pxM
        dzVL87EGIjtdh3FRh1mC3Y9HaNobX+s=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-558-cQ4B6-3CMMaDJGtvDBFMRg-1; Thu, 09 Jun 2022 06:32:51 -0400
X-MC-Unique: cQ4B6-3CMMaDJGtvDBFMRg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 56C81811E7A;
        Thu,  9 Jun 2022 10:32:51 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.193.201])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2E4031415100;
        Thu,  9 Jun 2022 10:32:50 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Networking for 5.19-rc2
Date:   Thu,  9 Jun 2022 12:32:02 +0200
Message-Id: <20220609103202.21091-1-pabeni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus!

The following changes since commit 58f9d52ff689a262bec7f5713c07f5a79e115168:

  Merge tag 'net-5.19-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2022-06-02 12:50:16 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.19-rc2

for you to fetch changes up to 647df0d41b6bd8f4987dde6e8d8d0aba5b082985:

  net: amd-xgbe: fix clang -Wformat warning (2022-06-08 21:12:03 -0700)

----------------------------------------------------------------
Networking fixes for 5.19-rc2, including fixes from bpf and netfilter.

Current release - regressions:
  - eth: amt: fix possible null-ptr-deref in amt_rcv()

Previous releases - regressions:
  - tcp: use alloc_large_system_hash() to allocate table_perturb

  - af_unix: fix a data-race in unix_dgram_peer_wake_me()

  - nfc: st21nfca: fix memory leaks in EVT_TRANSACTION handling

  - eth: ixgbe: fix unexpected VLAN rx in promisc mode on VF

Previous releases - always broken:
  - ipv6: fix signed integer overflow in __ip6_append_data

  - netfilter:
    - nat: really support inet nat without l3 address
    - nf_tables: memleak flow rule from commit path

  - bpf: fix calling global functions from BPF_PROG_TYPE_EXT programs

  - openvswitch: fix misuse of the cached connection on tuple changes

  - nfc: nfcmrvl: fix memory leak in nfcmrvl_play_deferred

  - eth: altera: fix refcount leak in altera_tse_mdio_create

Misc:
  - add Quentin Monnet to bpftool maintainers

Signed-off-by: Paolo Abeni <pabeni@redhat.com>

----------------------------------------------------------------
Alvin Šipraga (1):
      net: dsa: realtek: rtl8365mb: fix GMII caps for ports with internal PHY

Arnd Bergmann (1):
      au1000_eth: stop using virt_to_bus()

Chen Lin (1):
      net: ethernet: mtk_eth_soc: fix misuse of mem alloc interface netdev[napi]_alloc_frag

Christophe JAILLET (1):
      stmmac: intel: Fix an error handling path in intel_eth_pci_probe()

Dan Carpenter (1):
      bpf: Use safer kvmalloc_array() where possible

Eric Dumazet (1):
      bpf, arm64: Clear prog->jited_len along prog->jited

Florian Westphal (1):
      netfilter: nat: really support inet nat without l3 address

Gal Pressman (1):
      net/mlx4_en: Fix wrong return value on ioctl EEPROM query failure

Ilya Maximets (1):
      net: openvswitch: fix misuse of the cached connection on tuple changes

Jakub Kicinski (7):
      Merge branch 'amt-fix-several-bugs-in-amt_rcv'
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf
      Merge branch 'net-unexport-some-symbols-that-are-annotated-__init'
      Merge branch 'split-nfc-st21nfca-refactor-evt_transaction-into-3'
      Merge https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf
      Merge branch 'mv88e6xxx-fixes-for-reading-serdes-state'
      Merge branch '10GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue

Justin Stitt (1):
      net: amd-xgbe: fix clang -Wformat warning

Kuniyuki Iwashima (1):
      af_unix: Fix a data-race in unix_dgram_peer_wake_me().

Lina Wang (1):
      selftests net: fix bpf build error

Maciej Fijalkowski (1):
      xsk: Fix handling of invalid descriptors in XSK TX batching API

Marek Behún (1):
      net: dsa: mv88e6xxx: use BMSR_ANEGCOMPLETE bit for filling an_complete

Martin Faltesek (3):
      nfc: st21nfca: fix incorrect validating logic in EVT_TRANSACTION
      nfc: st21nfca: fix memory leaks in EVT_TRANSACTION handling
      nfc: st21nfca: fix incorrect sizing calculations in EVT_TRANSACTION

Masahiro Yamada (3):
      net: mdio: unexport __init-annotated mdio_bus_init()
      net: xfrm: unexport __init-annotated xfrm4_protocol_init()
      net: ipv6: unexport __init-annotated seg6_hmac_init()

Miaoqian Lin (3):
      net: ethernet: bgmac: Fix refcount leak in bcma_mdio_mii_register
      net: dsa: lantiq_gswip: Fix refcount leak in gswip_gphy_fw_list
      net: altera: Fix refcount leak in altera_tse_mdio_create

Muchun Song (1):
      tcp: use alloc_large_system_hash() to allocate table_perturb

Olivier Matz (2):
      ixgbe: fix bcast packets Rx on VF after promisc removal
      ixgbe: fix unexpected VLAN Rx in promisc mode on VF

Pablo Neira Ayuso (6):
      netfilter: nf_tables: use kfree_rcu(ptr, rcu) to release hooks in clean_net path
      netfilter: nf_tables: delete flowtable hooks via transaction list
      netfilter: nf_tables: always initialize flowtable hook list in transaction
      netfilter: nf_tables: release new hooks on unsupported flowtable flags
      netfilter: nf_tables: memleak flow rule from commit path
      netfilter: nf_tables: bail out early if hardware offload is not supported

Quentin Monnet (1):
      MAINTAINERS: Add a maintainer for bpftool

Russell King (Oracle) (2):
      net: dsa: mv88e6xxx: fix BMSR error to be consistent with others
      net: dsa: mv88e6xxx: correctly report serdes link failure

Taehee Yoo (3):
      amt: fix wrong usage of pskb_may_pull()
      amt: fix possible null-ptr-deref in amt_rcv()
      amt: fix wrong type string definition

Tan Tee Min (1):
      net: phy: dp83867: retrigger SGMII AN when link change

Toke Høiland-Jørgensen (2):
      bpf: Fix calling global functions from BPF_PROG_TYPE_EXT programs
      selftests/bpf: Add selftest for calling global functions from freplace

Wang Yufen (2):
      ipv6: Fix signed integer overflow in __ip6_append_data
      ipv6: Fix signed integer overflow in l2tp_ip6_sendmsg

Willem de Bruijn (1):
      ip_gre: test csum_start instead of transport header

Xiaohui Zhang (1):
      nfc: nfcmrvl: Fix memory leak in nfcmrvl_play_deferred

 MAINTAINERS                                        |  7 +++
 arch/arm64/net/bpf_jit_comp.c                      |  1 +
 drivers/net/amt.c                                  | 59 +++++++++++++++-------
 drivers/net/dsa/lantiq_gswip.c                     |  4 +-
 drivers/net/dsa/mv88e6xxx/serdes.c                 | 35 +++++++------
 drivers/net/dsa/realtek/rtl8365mb.c                | 38 ++++----------
 drivers/net/ethernet/altera/altera_tse_main.c      |  6 ++-
 drivers/net/ethernet/amd/au1000_eth.c              | 22 ++++----
 drivers/net/ethernet/amd/au1000_eth.h              |  4 +-
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c           |  2 +-
 drivers/net/ethernet/broadcom/bgmac-bcma-mdio.c    |  1 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c     |  8 +--
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        | 21 +++++++-
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c    |  2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c  |  4 +-
 drivers/net/phy/dp83867.c                          | 29 +++++++++++
 drivers/net/phy/mdio_bus.c                         |  1 -
 drivers/nfc/nfcmrvl/usb.c                          | 16 +++++-
 drivers/nfc/st21nfca/se.c                          | 53 ++++++++++---------
 include/net/flow_offload.h                         |  1 +
 include/net/ipv6.h                                 |  4 +-
 include/net/netfilter/nf_tables.h                  |  1 -
 include/net/netfilter/nf_tables_offload.h          |  2 +-
 kernel/bpf/btf.c                                   |  3 +-
 kernel/trace/bpf_trace.c                           |  8 +--
 net/core/flow_offload.c                            |  6 +++
 net/ipv4/inet_hashtables.c                         | 10 ++--
 net/ipv4/ip_gre.c                                  | 11 ++--
 net/ipv4/xfrm4_protocol.c                          |  1 -
 net/ipv6/ip6_output.c                              |  6 +--
 net/ipv6/seg6_hmac.c                               |  1 -
 net/l2tp/l2tp_ip6.c                                |  5 +-
 net/netfilter/nf_tables_api.c                      | 54 +++++++++-----------
 net/netfilter/nf_tables_offload.c                  | 23 ++++++++-
 net/netfilter/nft_nat.c                            |  3 +-
 net/openvswitch/actions.c                          |  6 +++
 net/openvswitch/conntrack.c                        |  4 +-
 net/unix/af_unix.c                                 |  2 +-
 net/xdp/xsk.c                                      |  5 +-
 net/xdp/xsk_queue.h                                |  8 ---
 .../selftests/bpf/prog_tests/fexit_bpf2bpf.c       | 14 +++++
 .../selftests/bpf/progs/freplace_global_func.c     | 18 +++++++
 tools/testing/selftests/net/bpf/Makefile           |  4 +-
 tools/testing/selftests/netfilter/nft_nat.sh       | 43 ++++++++++++++++
 44 files changed, 367 insertions(+), 189 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/freplace_global_func.c

