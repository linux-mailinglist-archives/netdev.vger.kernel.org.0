Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0A9C6E9392
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 14:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234430AbjDTMBn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 08:01:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234046AbjDTMBm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 08:01:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22CDB49EB
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 05:00:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681992056;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=ZdDs9VSETt9cXg5NQexd8cC6M0i48XD3CttYZINmfEY=;
        b=GQvh8/rEmac1i54cIzxzfOEdEC/zCBmzP4frQuqCl2OSlL29h3oufCaFOdDYn3q/KUdLs3
        NB6XqR/DwYMKiCpF4fcGpjbRh91utgRf9XRkLbve1EqVCfbNRG4EJkE4th4eAcaud8WRBu
        IFcPPDhH/p//i3W0TVVGNsTg1jUbOHk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-496-VMP6XPrZPjCoSttm7buyqw-1; Thu, 20 Apr 2023 08:00:52 -0400
X-MC-Unique: VMP6XPrZPjCoSttm7buyqw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3B5CF8996F3;
        Thu, 20 Apr 2023 12:00:52 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.193.29])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1D6131410F1C;
        Thu, 20 Apr 2023 12:00:50 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Networking for 6.3-rc8
Date:   Thu, 20 Apr 2023 14:00:44 +0200
Message-Id: <20230420120044.288741-1-pabeni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus!

There are a few fixes for new code bugs, including the Mellanox one
noted in the last net PR. No known regressions outstanding.

The following changes since commit 829cca4d1783088e43bace57a555044cc937c554:

  Merge tag 'net-6.3-rc7' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2023-04-13 15:33:04 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.3-rc8

for you to fetch changes up to 927cdea5d2095287ddd5246e5aa68eb5d68db2be:

  net: bridge: switchdev: don't notify FDB entries with "master dynamic" (2023-04-20 09:20:14 +0200)

----------------------------------------------------------------
Networking fixes for 6.3-rc8, including fixes from netfilter and bpf

Current release - regressions:

  - sched: clear actions pointer in miss cookie init fail

  - mptcp: fix accept vs worker race

  - bpf: fix bpf_arch_text_poke() with new_addr == NULL on s390

  - eth: bnxt_en: fix a possible NULL pointer dereference in unload path

  - eth: veth: take into account peer device for NETDEV_XDP_ACT_NDO_XMIT xdp_features flag

Current release - new code bugs:

  - eth: revert "net/mlx5: Enable management PF initialization"

Previous releases - regressions:

  - netfilter: fix recent physdev match breakage

  - bpf: fix incorrect verifier pruning due to missing register precision taints

  - eth: virtio_net: fix overflow inside xdp_linearize_page()

  - eth: cxgb4: fix use after free bugs caused by circular dependency problem

  - eth: mlxsw: pci: fix possible crash during initialization

Previous releases - always broken:

  - sched: sch_qfq: prevent slab-out-of-bounds in qfq_activate_agg

  - netfilter: validate catch-all set elements

  - bridge: don't notify FDB entries with "master dynamic"

  - eth: bonding: fix memory leak when changing bond type to ethernet

  - eth: i40e: fix accessing vsi->active_filters without holding lock

Misc:

  - Mat is back as MPTCP co-maintainer

Signed-off-by: Paolo Abeni <pabeni@redhat.com>

----------------------------------------------------------------
Aleksandr Loktionov (2):
      i40e: fix accessing vsi->active_filters without holding lock
      i40e: fix i40e_setup_misc_vector() error handling

Alexander Aring (1):
      net: rpl: fix rpl header size calculation

Arnd Bergmann (1):
      hamradio: drop ISA_DMA_API dependency

Chen Aotian (1):
      netfilter: nf_tables: Modify nla_memdup's flag to GFP_KERNEL_ACCOUNT

Christophe JAILLET (1):
      net: dsa: microchip: ksz8795: Correctly handle huge frame configuration

Daniel Borkmann (1):
      bpf: Fix incorrect verifier pruning due to missing register precision taints

David S. Miller (1):
      Merge branch 'mptcp-fixes'

Ding Hui (1):
      sfc: Fix use-after-free due to selftest_work

Duoming Zhou (1):
      cxgb4: fix use after free bugs caused by circular dependency problem

Florian Westphal (2):
      netfilter: br_netfilter: fix recent physdev match breakage
      netfilter: nf_tables: fix ifdef to also consider nf_tables=m

Gwangun Jung (1):
      net: sched: sch_qfq: prevent slab-out-of-bounds in qfq_activate_agg

Ido Schimmel (2):
      bonding: Fix memory leak when changing bond type to Ethernet
      mlxsw: pci: Fix possible crash during initialization

Ilya Leoshkevich (1):
      s390/bpf: Fix bpf_arch_text_poke() with new_addr == NULL

Jacob Keller (1):
      ice: document RDMA devlink parameters

Jakub Kicinski (4):
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf
      Merge branch '40GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue
      Merge tag 'for-netdev' of https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf
      Revert "net/mlx5: Enable management PF initialization"

Kalesh AP (1):
      bnxt_en: Fix a possible NULL pointer dereference in unload path

Lorenzo Bianconi (1):
      veth: take into account peer device for NETDEV_XDP_ACT_NDO_XMIT xdp_features flag

Mat Martineau (1):
      MAINTAINERS: Resume MPTCP co-maintainer role

Matthieu Baerts (1):
      mailmap: add entries for Mat Martineau

Michael Chan (1):
      bnxt_en: Do not initialize PTP on older P3/P4 chips

Nikita Zhandarovich (1):
      mlxfw: fix null-ptr-deref in mlxfw_mfa2_tlv_next()

Pablo Neira Ayuso (2):
      netfilter: nf_tables: validate catch-all set elements
      netfilter: nf_tables: tighten netlink attribute requirements for catch-all elements

Paolo Abeni (3):
      Merge branch 'bnxt_en-bug-fixes'
      mptcp: stops worker on unaccepted sockets at listener close
      mptcp: fix accept vs worker race

Pedro Tammela (1):
      net/sched: clear actions pointer in miss cookie init fail

Sebastian Basierski (1):
      e1000e: Disable TSO on i219-LM card to increase speed

Seiji Nishikawa (1):
      net: vmxnet3: Fix NULL pointer dereference in vmxnet3_rq_rx_complete()

Vadim Fedorenko (1):
      bnxt_en: fix free-runnig PHC mode

Vladimir Oltean (1):
      net: bridge: switchdev: don't notify FDB entries with "master dynamic"

Xuan Zhuo (1):
      virtio_net: bugfix overflow inside xdp_linearize_page()

 .mailmap                                           |  2 +
 Documentation/networking/devlink/ice.rst           | 15 ++++
 MAINTAINERS                                        |  1 +
 arch/s390/net/bpf_jit_comp.c                       | 11 ++-
 drivers/net/bonding/bond_main.c                    |  7 +-
 drivers/net/dsa/microchip/ksz8795.c                |  2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  4 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c      | 19 ++---
 .../net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c   |  2 +-
 drivers/net/ethernet/intel/e1000e/netdev.c         | 51 +++++++-------
 drivers/net/ethernet/intel/i40e/i40e_main.c        |  9 ++-
 drivers/net/ethernet/mellanox/mlx5/core/dev.c      |  6 --
 drivers/net/ethernet/mellanox/mlx5/core/ecpf.c     |  8 ---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |  2 +-
 .../ethernet/mellanox/mlxfw/mlxfw_mfa2_tlv_multi.c |  2 +
 drivers/net/ethernet/mellanox/mlxsw/pci_hw.h       |  2 +-
 drivers/net/ethernet/sfc/efx.c                     |  1 -
 drivers/net/ethernet/sfc/efx_common.c              |  2 +
 drivers/net/hamradio/Kconfig                       |  2 +-
 drivers/net/veth.c                                 | 17 +++--
 drivers/net/virtio_net.c                           |  8 ++-
 drivers/net/vmxnet3/vmxnet3_drv.c                  |  2 +-
 include/linux/mlx5/driver.h                        |  5 --
 include/linux/skbuff.h                             |  5 +-
 include/net/netfilter/nf_tables.h                  |  4 ++
 kernel/bpf/verifier.c                              | 15 ++++
 net/bridge/br_netfilter_hooks.c                    | 17 +++--
 net/bridge/br_switchdev.c                          | 11 +++
 net/ipv6/rpl.c                                     |  3 +-
 net/mptcp/protocol.c                               | 74 +++++++++++++-------
 net/mptcp/protocol.h                               |  2 +
 net/mptcp/subflow.c                                | 80 +++++++++++++++++++++-
 net/netfilter/nf_tables_api.c                      | 69 ++++++++++++++++---
 net/netfilter/nft_lookup.c                         | 36 ++--------
 net/sched/cls_api.c                                |  3 +
 net/sched/sch_qfq.c                                | 13 ++--
 36 files changed, 351 insertions(+), 161 deletions(-)

