Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3046D6060D3
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 15:01:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbiJTNBi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 09:01:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbiJTNBg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 09:01:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D0481BF207
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 06:01:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666270893;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=boz0mjP9HzHGnihw8bMwD1zsGSVQM8PZMj4EPnj2Odk=;
        b=DK3cE72/8zE86gPUEA45Xsh6T8T1Llvqli0NNuGTAC4ixUHin+RXzzZHA9dJFysQ1lsQOx
        QyUXgZc+4n+JIDykOCn8B4egehe6X5hinwjhgfOozE1U9afaaQJKPKNSDQpYEWLOKU0sjr
        Vxlp0HR9iLxNngNYDJHmXjnjT8J5hQQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-260-p-p6r2FDMM2s5GNRlRdGAw-1; Thu, 20 Oct 2022 09:01:32 -0400
X-MC-Unique: p-p6r2FDMM2s5GNRlRdGAw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8CC5E29AB405;
        Thu, 20 Oct 2022 13:01:31 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.194.216])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 642E81121315;
        Thu, 20 Oct 2022 13:01:30 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Networking for 6.1-rc2
Date:   Thu, 20 Oct 2022 15:01:14 +0200
Message-Id: <20221020130114.34410-1-pabeni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus!

There is a small conflict with your current tree between:
  7e3cf0843fe5 ("treewide: use get_random_{u8,u16}() when possible, part 1")
  69421bf98482 ("udp: Update reuse->has_conns under reuseport_lock.")

with trivial solution - accept new code from both commits.

The following changes since commit 66ae04368efbe20eb8951c9a76158f99ce672f25:

  Merge tag 'net-6.1-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2022-10-13 10:51:01 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.1-rc2

for you to fetch changes up to 7f378c03aa4952507521174fb0da7b24a9ad0be6:

  net: phy: dp83822: disable MDI crossover status change interrupt (2022-10-19 18:46:17 -0700)

----------------------------------------------------------------
Networking fixes for 6.1-rc2, including fixes from netfilter

Current release - regressions:
  - revert "net: fix cpu_max_bits_warn() usage in netif_attrmask_next{,_and}"

  - revert "net: sched: fq_codel: remove redundant resource cleanup in fq_codel_init()"

  - dsa: uninitialized variable in dsa_slave_netdevice_event()

  - eth: sunhme: uninitialized variable in happy_meal_init()

Current release - new code bugs:
  - eth: octeontx2: fix resource not freed after malloc

Previous releases - regressions:
  - sched: fix return value of qdisc ingress handling on success

  - sched: fix race condition in qdisc_graft()

  - udp: update reuse->has_conns under reuseport_lock.

  - tls: strp: make sure the TCP skbs do not have overlapping data

  - hsr: avoid possible NULL deref in skb_clone()

  - tipc: fix an information leak in tipc_topsrv_kern_subscr

  - phylink: add mac_managed_pm in phylink_config structure

  - eth: i40e: fix DMA mappings leak

  - eth: hyperv: fix a RX-path warning

  - eth: mtk: fix memory leaks

Previous releases - always broken:
  - sched: cake: fix null pointer access issue when cake_init() fails

----------------------------------------------------------------
Alexander Potapenko (1):
      tipc: fix an information leak in tipc_topsrv_kern_subscr

Brett Creeley (1):
      ionic: catch NULL pointer issue on reconfig

Cezar Bulinaru (1):
      net: hv_netvsc: Fix a warning triggered by memcpy in rndis_filter

Christian Marangi (2):
      net: dsa: qca8k: fix inband mgmt for big-endian systems
      net: dsa: qca8k: fix ethtool autocast mib for big-endian systems

Dan Carpenter (3):
      net/smc: Fix an error code in smc_lgr_create()
      sunhme: Uninitialized variable in happy_meal_init()
      net: dsa: uninitialized variable in dsa_slave_netdevice_event()

David S. Miller (4):
      Merge branch 'phylink_set_mac_pm'
      Merge branch 'mtk_eth_wed-leak-fixes'
      Merge branch 'qdisc-null-deref'
      Merge branch 'qdisc-ingress-success'

Eric Dumazet (3):
      skmsg: pass gfp argument to alloc_sk_msg()
      net: hsr: avoid possible NULL deref in skb_clone()
      net: sched: fix race condition in qdisc_graft()

Felix Riemann (1):
      net: phy: dp83822: disable MDI crossover status change interrupt

Guillaume Nault (1):
      netfilter: rpfilter/fib: Set ->flowic_uid correctly for user namespaces.

Harini Katakam (1):
      net: phy: dp83867: Extend RX strap quirk for SGMII mode

Jakub Kicinski (4):
      tls: strp: make sure the TCP skbs do not have overlapping data
      Revert "net: fix cpu_max_bits_warn() usage in netif_attrmask_next{,_and}"
      genetlink: fix kdoc warnings
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf

Jan Sokolowski (1):
      i40e: Fix DMA mappings leak

Jiapeng Chong (1):
      net: ethernet: mediatek: ppe: Remove the unused function mtk_foe_entry_usable()

Jonathan Cooper (1):
      sfc: Change VF mac via PF as first preference if available.

Krzysztof Kozlowski (1):
      MAINTAINERS: nfc: s3fwrn5: Drop Krzysztof Opasiak

Kuniyuki Iwashima (1):
      udp: Update reuse->has_conns under reuseport_lock.

Manank Patel (1):
      ethernet: marvell: octeontx2 Fix resource not freed after malloc

Mark Tomlinson (1):
      tipc: Fix recognition of trial period

Pablo Neira Ayuso (1):
      netfilter: nf_tables: relax NFTA_SET_ELEM_KEY_END set flags requirements

Palmer Dabbelt (1):
      MAINTAINERS: git://github -> https://github.com for petkan

Paul Blakey (2):
      net: Fix return value of qdisc ingress handling on success
      selftests: add selftest for chaining of tc ingress handling to egress

Pieter Jansen van Vuuren (1):
      sfc: include vport_id in filter spec hash and equal()

Shenwei Wang (2):
      net: phylink: add mac_managed_pm in phylink_config structure
      net: stmmac: Enable mac_managed_pm phylink config

Vikas Gupta (1):
      bnxt_en: fix memory leak in bnxt_nvm_test()

Xiaobo Liu (1):
      net/atm: fix proc_mpc_write incorrect return value

Yang Yingliang (5):
      net: ethernet: mtk_eth_soc: fix possible memory leak in mtk_probe()
      net: ethernet: mtk_eth_wed: add missing put_device() in mtk_wed_add_hw()
      net: ethernet: mtk_eth_wed: add missing of_node_put()
      wwan_hwsim: fix possible memory leak in wwan_hwsim_dev_new()
      net: hns: fix possible memory leak in hnae_ae_register()

Zhengchao Shao (4):
      ip6mr: fix UAF issue in ip6mr_sk_done() when addrconf_init_net() failed
      net: sched: cake: fix null pointer access issue when cake_init() fails
      Revert "net: sched: fq_codel: remove redundant resource cleanup in fq_codel_init()"
      net: sched: sfb: fix null pointer access issue when sfb_init() fails

zhangxiangqian (1):
      net: macvlan: change schedule system_wq to system_unbound_wq

 .../bindings/net/nfc/samsung,s3fwrn5.yaml          |  1 -
 MAINTAINERS                                        |  5 +-
 drivers/net/dsa/qca/qca8k-8xxx.c                   | 83 ++++++++++++++--------
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c  | 11 +--
 drivers/net/ethernet/hisilicon/hns/hnae.c          |  4 +-
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c     |  3 -
 drivers/net/ethernet/intel/i40e/i40e_main.c        | 16 +++--
 drivers/net/ethernet/intel/i40e/i40e_txrx.c        | 13 ++--
 drivers/net/ethernet/intel/i40e/i40e_txrx.h        |  1 -
 drivers/net/ethernet/intel/i40e/i40e_xsk.c         | 67 ++++++++++++++---
 drivers/net/ethernet/intel/i40e/i40e_xsk.h         |  2 +-
 .../ethernet/marvell/octeontx2/nic/cn10k_macsec.c  |  2 +
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        | 17 +++--
 drivers/net/ethernet/mediatek/mtk_ppe.c            |  6 --
 drivers/net/ethernet/mediatek/mtk_wed.c            | 15 +++-
 drivers/net/ethernet/pensando/ionic/ionic_lif.c    | 12 ++--
 drivers/net/ethernet/sfc/ef10.c                    | 58 +++++++--------
 drivers/net/ethernet/sfc/filter.h                  |  4 +-
 drivers/net/ethernet/sfc/rx_common.c               | 10 +--
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  1 +
 drivers/net/ethernet/sun/sunhme.c                  |  2 +-
 drivers/net/hyperv/rndis_filter.c                  |  6 +-
 drivers/net/macvlan.c                              |  2 +-
 drivers/net/phy/dp83822.c                          |  3 +-
 drivers/net/phy/dp83867.c                          |  8 +++
 drivers/net/phy/phylink.c                          |  3 +
 drivers/net/wwan/wwan_hwsim.c                      |  2 +-
 include/linux/dsa/tag_qca.h                        |  8 +--
 include/linux/netdevice.h                          | 10 +--
 include/linux/phylink.h                            |  2 +
 include/net/genetlink.h                            |  8 ++-
 include/net/sock_reuseport.h                       | 11 ++-
 net/atm/mpoa_proc.c                                |  3 +-
 net/core/dev.c                                     |  4 ++
 net/core/skmsg.c                                   |  8 +--
 net/core/sock_reuseport.c                          | 16 +++++
 net/dsa/slave.c                                    |  2 +-
 net/hsr/hsr_forward.c                              | 12 ++--
 net/ipv4/datagram.c                                |  2 +-
 net/ipv4/netfilter/ipt_rpfilter.c                  |  1 +
 net/ipv4/netfilter/nft_fib_ipv4.c                  |  1 +
 net/ipv4/udp.c                                     |  2 +-
 net/ipv6/addrconf.c                                |  2 +
 net/ipv6/datagram.c                                |  2 +-
 net/ipv6/netfilter/ip6t_rpfilter.c                 |  1 +
 net/ipv6/netfilter/nft_fib_ipv6.c                  |  2 +
 net/ipv6/udp.c                                     |  2 +-
 net/netfilter/nf_tables_api.c                      |  5 +-
 net/sched/sch_api.c                                |  5 +-
 net/sched/sch_cake.c                               |  4 ++
 net/sched/sch_fq_codel.c                           | 25 ++++---
 net/sched/sch_sfb.c                                |  3 +-
 net/smc/smc_core.c                                 |  3 +-
 net/tipc/discover.c                                |  2 +-
 net/tipc/topsrv.c                                  |  2 +-
 net/tls/tls_strp.c                                 | 32 +++++++--
 tools/testing/selftests/net/Makefile               |  1 +
 .../selftests/net/test_ingress_egress_chaining.sh  | 79 ++++++++++++++++++++
 58 files changed, 432 insertions(+), 185 deletions(-)
 create mode 100644 tools/testing/selftests/net/test_ingress_egress_chaining.sh

