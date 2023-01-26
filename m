Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65AA167CAEB
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 13:29:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237074AbjAZM3Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 07:29:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236966AbjAZM3X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 07:29:23 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D9964900B
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 04:28:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674736114;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=LHHI1z3/Zi2ZVpvIelVqZ7oFqL4vmSAmqEC9YF9uobE=;
        b=ZYu9IH4+I675TXls9H/WRhKd7qY4LG466XjX0/sEoECy4gWxW/PjP8ch//jiTHsd3WenV4
        X/OyQA1x2aHA3yBwI4kjy8vA5+oXGbjoVp2IxWZNIDP/865ZKgNC0A5nftZYPAy4PoU6RJ
        59fYvfPbUpJoBlueV7EvNfEnWTCTqL0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-641-vru26c0CNEWub7a1oHUaCw-1; Thu, 26 Jan 2023 07:28:33 -0500
X-MC-Unique: vru26c0CNEWub7a1oHUaCw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1AA4629ABA18;
        Thu, 26 Jan 2023 12:28:33 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.192.60])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F0C442026D76;
        Thu, 26 Jan 2023 12:28:31 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Networking for 6.2-rc6
Date:   Thu, 26 Jan 2023 13:26:43 +0100
Message-Id: <20230126122643.379852-1-pabeni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus!

Notably, this includes the fix for the mctp issue you have been
notified of.

There are no known pending regressions to the better of my knowledge.

The following changes since commit 5deaa98587aca2f0e7605388e89cfa1df4bad5cb:

  Merge tag 'net-6.2-rc5-2' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2023-01-20 09:58:44 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.2-rc6

for you to fetch changes up to 7083df59abbc2b7500db312cac706493be0273ff:

  net: mdio-mux-meson-g12a: force internal PHY off on mux switch (2023-01-25 22:46:51 -0800)

----------------------------------------------------------------
Networking fixes for 6.2-rc6, including fixes from netfilter.

Current release - regressions:

  - sched: sch_taprio: do not schedule in taprio_reset()

Previous releases - regressions:

  - core: fix UaF in netns ops registration error path

  - ipv4: prevent potential spectre v1 gadgets

  - ipv6: fix reachability confirmation with proxy_ndp

  - netfilter: fix for the set rbtree

  - eth: fec: use page_pool_put_full_page when freeing rx buffers

  - eth: iavf: fix temporary deadlock and failure to set MAC address

Previous releases - always broken:

 - netlink: prevent potential spectre v1 gadgets

 - netfilter: fixes for SCTP connection tracking

 - mctp: struct sock lifetime fixes

 - eth: ravb: fix possible hang if RIS2_QFF1 happen

 - eth: tg3: resolve deadlock in tg3_reset_task() during EEH

Misc:

 - Mat stepped out as MPTCP co-maintainer

Signed-off-by: Paolo Abeni <pabeni@redhat.com>

----------------------------------------------------------------
Ahmad Fatoum (1):
      net: dsa: microchip: fix probe of I2C-connected KSZ8563

Alexandru Tachici (1):
      net: ethernet: adi: adin1110: Fix multicast offloading

David Christensen (1):
      net/tg3: resolve deadlock in tg3_reset_task() during EEH

David S. Miller (3):
      Merge branch 'ethtool-mac-merge'
      Merge branch 'ravb-fixes'
      Merge branch 'mptcp-fixes'

Eric Dumazet (7):
      netlink: prevent potential spectre v1 gadgets
      netlink: annotate data races around nlk->portid
      netlink: annotate data races around dst_portid and dst_group
      netlink: annotate data races around sk_state
      ipv4: prevent potential spectre v1 gadget in ip_metrics_convert()
      ipv4: prevent potential spectre v1 gadget in fib_metrics_match()
      net/sched: sch_taprio: do not schedule in taprio_reset()

Gergely Risko (1):
      ipv6: fix reachability confirmation with proxy_ndp

Gerhard Engleder (1):
      tsnep: Fix TX queue stop/wake for multiple queues

Haiyang Zhang (1):
      net: mana: Fix IRQ name - add PCI and queue number

Hyunwoo Kim (1):
      net/x25: Fix to not accept on connected socket

Ivan Vecera (1):
      docs: networking: Fix bridge documentation URL

Jakub Kicinski (4):
      Merge branch 'netlink-annotate-various-data-races'
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf
      Merge branch '40GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf

Jeremy Kerr (3):
      net: mctp: add an explicit reference from a mctp_sk_key to sock
      net: mctp: move expiry timer delete to unhash
      net: mctp: mark socks as dead on unhash, prevent re-add

Jerome Brunet (1):
      net: mdio-mux-meson-g12a: force internal PHY off on mux switch

Kuniyuki Iwashima (1):
      netrom: Fix use-after-free of a listening socket.

Marcelo Ricardo Leitner (1):
      sctp: fail if no bound addresses can be used for a given scope

Marcin Szycik (1):
      iavf: Move netdev_update_features() into watchdog task

Mat Martineau (1):
      MAINTAINERS: Update MPTCP maintainer list and CREDITS

Michal Schmidt (1):
      iavf: fix temporary deadlock and failure to set MAC address

Pablo Neira Ayuso (2):
      netfilter: nft_set_rbtree: Switch to node list walk for overlap detection
      netfilter: nft_set_rbtree: skip elements in transaction from garbage collection

Paolo Abeni (3):
      net: fix UaF in netns ops registration error path
      Revert "Merge branch 'ethtool-mac-merge'"
      net: mctp: hold key reference when looking up a general key

Paul M Stillwell Jr (1):
      ice: move devlink port creation/deletion

Sriram Yagnaraman (4):
      netfilter: conntrack: fix vtag checks for ABORT/SHUTDOWN_COMPLETE
      netfilter: conntrack: fix bug in for_each_sctp_chunk
      Revert "netfilter: conntrack: add sctp DATA_SENT state"
      netfilter: conntrack: unify established states for SCTP paths

Stefan Assmann (1):
      iavf: schedule watchdog immediately when changing primary MAC

Vladimir Oltean (1):
      net: ethtool: netlink: introduce ethnl_update_bool()

Wei Fang (1):
      net: fec: Use page_pool_put_full_page when freeing rx buffers

Yoshihiro Shimoda (3):
      net: ethernet: renesas: rswitch: Fix ethernet-ports handling
      net: ravb: Fix lack of register setting after system resumed for Gen3
      net: ravb: Fix possible hang if RIS2_QFF1 happen

 CREDITS                                            |   7 +
 Documentation/networking/bridge.rst                |   2 +-
 Documentation/networking/nf_conntrack-sysctl.rst   |  10 +-
 MAINTAINERS                                        |   1 -
 drivers/net/dsa/microchip/ksz9477_i2c.c            |   2 +-
 drivers/net/ethernet/adi/adin1110.c                |   2 +-
 drivers/net/ethernet/broadcom/tg3.c                |   8 +-
 drivers/net/ethernet/engleder/tsnep_main.c         |  15 +-
 drivers/net/ethernet/freescale/fec_main.c          |   2 +-
 drivers/net/ethernet/intel/iavf/iavf.h             |   2 +-
 drivers/net/ethernet/intel/iavf/iavf_ethtool.c     |  10 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c        | 113 ++++---
 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c    |  10 +-
 drivers/net/ethernet/intel/ice/ice_lib.c           |   3 -
 drivers/net/ethernet/intel/ice/ice_main.c          |  25 +-
 drivers/net/ethernet/microsoft/mana/gdma_main.c    |   9 +-
 drivers/net/ethernet/renesas/ravb_main.c           |  10 +-
 drivers/net/ethernet/renesas/rswitch.c             |  22 +-
 drivers/net/ethernet/renesas/rswitch.h             |  12 +
 drivers/net/mdio/mdio-mux-meson-g12a.c             |  23 +-
 include/net/mana/gdma.h                            |   3 +
 include/uapi/linux/netfilter/nf_conntrack_sctp.h   |   3 +-
 include/uapi/linux/netfilter/nfnetlink_cttimeout.h |   3 +-
 lib/nlattr.c                                       |   3 +
 net/core/net_namespace.c                           |   2 +-
 net/ipv4/fib_semantics.c                           |   2 +
 net/ipv4/metrics.c                                 |   2 +
 net/ipv6/ip6_output.c                              |  15 +-
 net/mctp/af_mctp.c                                 |  10 +-
 net/mctp/route.c                                   |  34 ++-
 net/netfilter/nf_conntrack_proto_sctp.c            | 170 +++++------
 net/netfilter/nf_conntrack_standalone.c            |  16 -
 net/netfilter/nft_set_rbtree.c                     | 332 +++++++++++++--------
 net/netlink/af_netlink.c                           |  38 ++-
 net/netrom/nr_timer.c                              |   1 +
 net/sched/sch_taprio.c                             |   1 -
 net/sctp/bind_addr.c                               |   6 +
 net/x25/af_x25.c                                   |   6 +
 38 files changed, 535 insertions(+), 400 deletions(-)

