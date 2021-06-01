Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72B2E397C11
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 00:06:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234890AbhFAWIR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 18:08:17 -0400
Received: from mail.netfilter.org ([217.70.188.207]:39538 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234698AbhFAWIQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 18:08:16 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 3A46564175;
        Wed,  2 Jun 2021 00:05:27 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 00/16] Netfilter updates for net-next
Date:   Wed,  2 Jun 2021 00:06:13 +0200
Message-Id: <20210601220629.18307-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset contains Netfilter updates for net-next:

1) Support for SCTP chunks matching on nf_tables, from Phil Sutter.

2) Skip LDMXCSR, we don't need a valid MXCSR state. From Stefano Brivio.

3) CONFIG_RETPOLINE for nf_tables set lookups, from Florian Westphal.

4) A few Kconfig leading spaces removal, from Juerg Haefliger.

5) Remove spinlock from xt_limit, from Jason Baron.

6) Remove useless initialization in xt_CT, oneliner from Yang Li.

7) Tree-wide replacement of netlink_unicast() by nfnetlink_unicast().

8) Reduce footprint of several structures: xt_action_param,
   nft_pktinfo and nf_hook_state, from Florian.

10) Add nft_thoff() and nft_sk() helpers and use them, also from Florian.

11) Fix documentation in nf_tables pipapo avx2, from Florian Westphal.

12) Fix clang-12 fmt string warnings, also from Florian.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git

Thank you!

----------------------------------------------------------------

The following changes since commit af9207adb6d9986be6ed64e76705cf513087e724:

  Merge tag 'mlx5-updates-2021-05-26' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux (2021-05-27 17:14:23 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git HEAD

for you to fetch changes up to 8a1c08ad19b6ecb7254eca5c7275cb5d6fa1b0cb:

  netfilter: fix clang-12 fmt string warnings (2021-06-01 23:53:51 +0200)

----------------------------------------------------------------
Florian Westphal (10):
      netfilter: add and use nft_set_do_lookup helper
      netfilter: nf_tables: prefer direct calls for set lookups
      netfilter: x_tables: reduce xt_action_param by 8 byte
      netfilter: reduce size of nf_hook_state on 32bit platforms
      netfilter: nf_tables: add and use nft_sk helper
      netfilter: nf_tables: add and use nft_thoff helper
      netfilter: nf_tables: remove unused arg in nft_set_pktinfo_unspec()
      netfilter: nf_tables: remove xt_action_param from nft_pktinfo
      netfilter: nft_set_pipapo_avx2: fix up description warnings
      netfilter: fix clang-12 fmt string warnings

Jason Baron (1):
      netfilter: x_tables: improve limit_mt scalability

Juerg Haefliger (1):
      netfilter: Remove leading spaces in Kconfig

Pablo Neira Ayuso (1):
      netfilter: use nfnetlink_unicast()

Phil Sutter (1):
      netfilter: nft_exthdr: Support SCTP chunks

Stefano Brivio (1):
      netfilter: nft_set_pipapo_avx2: Skip LDMXCSR, we don't need a valid MXCSR state

Yang Li (1):
      netfilter: xt_CT: Remove redundant assignment to ret

 include/linux/netfilter.h                |  4 +-
 include/linux/netfilter/x_tables.h       |  2 +-
 include/net/netfilter/nf_tables.h        | 34 +++++++++++------
 include/net/netfilter/nf_tables_core.h   | 31 +++++++++++++++
 include/net/netfilter/nf_tables_ipv4.h   | 40 +++++++++-----------
 include/net/netfilter/nf_tables_ipv6.h   | 42 ++++++++++-----------
 include/uapi/linux/netfilter/nf_tables.h |  2 +
 net/ipv4/netfilter/nft_reject_ipv4.c     |  2 +-
 net/ipv6/netfilter/ip6_tables.c          |  2 +-
 net/ipv6/netfilter/nft_reject_ipv6.c     |  2 +-
 net/netfilter/Kconfig                    |  2 +-
 net/netfilter/ipset/ip_set_core.c        | 50 +++++-------------------
 net/netfilter/ipvs/Kconfig               |  2 +-
 net/netfilter/nf_conntrack_h323_main.c   |  2 +-
 net/netfilter/nf_conntrack_netlink.c     | 65 +++++++++-----------------------
 net/netfilter/nf_tables_core.c           |  2 +-
 net/netfilter/nf_tables_trace.c          |  6 +--
 net/netfilter/nfnetlink_acct.c           |  9 ++---
 net/netfilter/nfnetlink_cthelper.c       | 10 ++---
 net/netfilter/nfnetlink_cttimeout.c      | 34 +++++------------
 net/netfilter/nft_chain_filter.c         | 26 ++++++-------
 net/netfilter/nft_chain_nat.c            |  4 +-
 net/netfilter/nft_chain_route.c          |  4 +-
 net/netfilter/nft_compat.c               | 28 +++++++++-----
 net/netfilter/nft_exthdr.c               | 57 ++++++++++++++++++++++++++--
 net/netfilter/nft_flow_offload.c         |  2 +-
 net/netfilter/nft_lookup.c               | 35 ++++++++++++++++-
 net/netfilter/nft_objref.c               |  4 +-
 net/netfilter/nft_payload.c              | 10 ++---
 net/netfilter/nft_reject_inet.c          |  4 +-
 net/netfilter/nft_set_bitmap.c           |  5 ++-
 net/netfilter/nft_set_hash.c             | 17 +++++----
 net/netfilter/nft_set_pipapo.h           |  2 -
 net/netfilter/nft_set_pipapo_avx2.c      | 12 ++++--
 net/netfilter/nft_set_pipapo_avx2.h      |  2 -
 net/netfilter/nft_set_rbtree.c           |  5 ++-
 net/netfilter/nft_synproxy.c             |  4 +-
 net/netfilter/nft_tproxy.c               |  4 +-
 net/netfilter/xt_AUDIT.c                 |  2 +-
 net/netfilter/xt_CT.c                    |  1 -
 net/netfilter/xt_limit.c                 | 46 ++++++++++++----------
 41 files changed, 336 insertions(+), 281 deletions(-)
