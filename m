Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF459B1C2C
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 13:31:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387600AbfIMLbP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 07:31:15 -0400
Received: from correo.us.es ([193.147.175.20]:42426 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387431AbfIMLbO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Sep 2019 07:31:14 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 265E64FFE0B
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 13:31:09 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 13A6BA7E30
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 13:31:09 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 07E34A7E2E; Fri, 13 Sep 2019 13:31:09 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B7D0BA7E1D;
        Fri, 13 Sep 2019 13:31:06 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 13 Sep 2019 13:31:06 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 8444042EE38F;
        Fri, 13 Sep 2019 13:31:06 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 00/27] Netfilter updates for net-next
Date:   Fri, 13 Sep 2019 13:30:35 +0200
Message-Id: <20190913113102.15776-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset contains Netfilter updates for net-next:

1) Fix error path of nf_tables_updobj(), from Dan Carpenter.

2) Move large structure away from stack in the nf_tables offload
   infrastructure, from Arnd Bergmann.

3) Move indirect flow_block logic to nf_tables_offload.

4) Support for synproxy objects, from Fernando Fernandez Mancera.

5) Support for fwd and dup offload.

6) Add __nft_offload_get_chain() helper, this implicitly fixes missing
   mutex and check for offload flags in the indirect block support,
   patch from wenxu.

7) Remove rules on device unregistration, from wenxu. This includes
   two preparation patches to reuse nft_flow_offload_chain() and
   nft_flow_offload_rule().

Large batch from Jeremy Sowden to make a second pass to the
CONFIG_HEADER_TEST support and a bit of housekeeping:

8) Missing include guard in conntrack label header, from Jeremy Sowden.

9) A few coding style errors: trailing whitespace, incorrect indent in
   Kconfig, and semicolons at the end of function definitions.

10) Remove unused ipt_init() and ip6t_init() declarations.

11) Inline xt_hashlimit, ebt_802_3 and xt_physdev headers. They are
    only used once.

12) Update include directive in several netfilter files.

13) Remove unused include/net/netfilter/ipv6/nf_conntrack_icmpv6.h.

14) Move nf_ip6_ext_hdr() to include/linux/netfilter_ipv6.h

15) Move several synproxy structure definitions to nf_synproxy.h

16) Move nf_bridge_frag_data structure to include/linux/netfilter_bridge.h

17) Clean up static inline definitions in nf_conntrack_ecache.h.

18) Replace defined(CONFIG...) || defined(CONFIG...MODULE) with IS_ENABLED(CONFIG...).

19) Missing inline function conditional definitions based on Kconfig
    preferences in synproxy and nf_conntrack_timeout.

20) Update br_nf_pre_routing_ipv6() definition.

21) Move conntrack code in linux/skbuff.h to nf_conntrack headers.

22) Several patches to remove superfluous CONFIG_NETFILTER and
    CONFIG_NF_CONNTRACK checks in headers, coming from the initial batch
    support for CONFIG_HEADER_TEST for netfilter.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git

Thanks.

----------------------------------------------------------------

The following changes since commit 6703a605b5ab33502d7a327de880188013d7c377:

  Merge branch 'net-tls-small-TX-offload-optimizations' (2019-09-07 18:10:34 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git HEAD

for you to fetch changes up to 0d32e7048d927418300b9f5415ca546e44621ef1:

  netfilter: conntrack: remove two unused functions from nf_conntrack_timestamp.h. (2019-09-13 12:48:09 +0200)

----------------------------------------------------------------
Arnd Bergmann (1):
      netfilter: nf_tables_offload: avoid excessive stack usage

Dan Carpenter (1):
      netfilter: nf_tables: Fix an Oops in nf_tables_updobj() error handling

Fernando Fernandez Mancera (1):
      netfilter: nft_synproxy: add synproxy stateful object support

Jeremy Sowden (18):
      netfilter: fix include guards.
      netfilter: fix coding-style errors.
      netfilter: ip_tables: remove unused function declarations.
      netfilter: inline xt_hashlimit, ebt_802_3 and xt_physdev headers
      netfilter: update include directives.
      netfilter: remove nf_conntrack_icmpv6.h header.
      netfilter: move inline nf_ip6_ext_hdr() function to a more appropriate header.
      netfilter: synproxy: move code between headers.
      netfilter: move nf_bridge_frag_data struct definition to a more appropriate header.
      netfilter: conntrack: use consistent style when defining inline functions
      netfilter: replace defined(CONFIG...) || defined(CONFIG...MODULE) with IS_ENABLED(CONFIG...).
      netfilter: conntrack: wrap two inline functions in config checks.
      netfilter: br_netfilter: update stub br_nf_pre_routing_ipv6 parameter to `void *priv`.
      netfilter: conntrack: move code to linux/nf_conntrack_common.h.
      netfilter: conntrack: remove CONFIG_NF_CONNTRACK check from nf_conntrack_acct.h.
      netfilter: remove CONFIG_NETFILTER checks from headers.
      netfilter: conntrack: remove CONFIG_NF_CONNTRACK checks from nf_conntrack_zones.h.
      netfilter: conntrack: remove two unused functions from nf_conntrack_timestamp.h.

Pablo Neira Ayuso (2):
      netfilter: nf_tables_offload: move indirect flow_block callback logic to core
      netfilter: nft_{fwd,dup}_netdev: add offload support

wenxu (4):
      netfilter: nf_tables_offload: add __nft_offload_get_chain function
      netfilter: nf_tables_offload: refactor the nft_flow_offload_chain function
      netfilter: nf_tables_offload: refactor the nft_flow_offload_rule function
      netfilter: nf_tables_offload: remove rules when the device unregisters

 include/linux/netfilter.h                        |   4 +-
 include/linux/netfilter/ipset/ip_set_getport.h   |   2 +-
 include/linux/netfilter/nf_conntrack_common.h    |  20 +++
 include/linux/netfilter/x_tables.h               |   8 +-
 include/linux/netfilter/xt_hashlimit.h           |  11 --
 include/linux/netfilter/xt_physdev.h             |   8 -
 include/linux/netfilter_arp/arp_tables.h         |   2 -
 include/linux/netfilter_bridge.h                 |   7 +
 include/linux/netfilter_bridge/ebt_802_3.h       |  12 --
 include/linux/netfilter_bridge/ebtables.h        |   3 +-
 include/linux/netfilter_ipv4/ip_tables.h         |   9 +-
 include/linux/netfilter_ipv6.h                   |  28 +++-
 include/linux/netfilter_ipv6/ip6_tables.h        |  20 +--
 include/linux/skbuff.h                           |  32 ++--
 include/net/netfilter/br_netfilter.h             |   4 +-
 include/net/netfilter/ipv6/nf_conntrack_icmpv6.h |  21 ---
 include/net/netfilter/nf_conntrack.h             |  25 +--
 include/net/netfilter/nf_conntrack_acct.h        |   4 +-
 include/net/netfilter/nf_conntrack_bridge.h      |  11 +-
 include/net/netfilter/nf_conntrack_core.h        |   8 +-
 include/net/netfilter/nf_conntrack_ecache.h      |  84 ++++++----
 include/net/netfilter/nf_conntrack_expect.h      |   2 +-
 include/net/netfilter/nf_conntrack_extend.h      |   2 +-
 include/net/netfilter/nf_conntrack_l4proto.h     |  16 +-
 include/net/netfilter/nf_conntrack_labels.h      |  11 +-
 include/net/netfilter/nf_conntrack_synproxy.h    |  41 +----
 include/net/netfilter/nf_conntrack_timeout.h     |   4 +
 include/net/netfilter/nf_conntrack_timestamp.h   |  16 --
 include/net/netfilter/nf_conntrack_tuple.h       |   4 +-
 include/net/netfilter/nf_conntrack_zones.h       |   6 +-
 include/net/netfilter/nf_dup_netdev.h            |   6 +
 include/net/netfilter/nf_flow_table.h            |   6 +-
 include/net/netfilter/nf_nat.h                   |  21 +--
 include/net/netfilter/nf_nat_masquerade.h        |   1 +
 include/net/netfilter/nf_queue.h                 |   4 -
 include/net/netfilter/nf_synproxy.h              |  44 +++++-
 include/net/netfilter/nf_tables.h                |   8 -
 include/net/netfilter/nf_tables_offload.h        |  10 +-
 include/uapi/linux/netfilter/nf_tables.h         |   3 +-
 net/bridge/netfilter/ebt_802_3.c                 |   8 +-
 net/bridge/netfilter/nf_conntrack_bridge.c       |  15 +-
 net/ipv4/netfilter/Kconfig                       |   8 +-
 net/ipv4/netfilter/Makefile                      |   2 +-
 net/ipv6/netfilter.c                             |   4 +-
 net/ipv6/netfilter/ip6t_ipv6header.c             |   4 +-
 net/ipv6/netfilter/nf_log_ipv6.c                 |   4 +-
 net/ipv6/netfilter/nf_socket_ipv6.c              |   1 -
 net/netfilter/Kconfig                            |   8 +-
 net/netfilter/Makefile                           |   2 +-
 net/netfilter/nf_conntrack_ecache.c              |   1 +
 net/netfilter/nf_conntrack_expect.c              |   2 +
 net/netfilter/nf_conntrack_helper.c              |   5 +-
 net/netfilter/nf_conntrack_proto_icmpv6.c        |   1 -
 net/netfilter/nf_conntrack_standalone.c          |   1 -
 net/netfilter/nf_conntrack_timeout.c             |   1 +
 net/netfilter/nf_dup_netdev.c                    |  21 +++
 net/netfilter/nf_flow_table_core.c               |   1 +
 net/netfilter/nf_nat_core.c                      |   6 +-
 net/netfilter/nf_tables_api.c                    |  25 +--
 net/netfilter/nf_tables_offload.c                | 186 ++++++++++++++++++-----
 net/netfilter/nft_dup_netdev.c                   |  12 ++
 net/netfilter/nft_flow_offload.c                 |   3 +-
 net/netfilter/nft_fwd_netdev.c                   |  12 ++
 net/netfilter/nft_synproxy.c                     | 143 ++++++++++++++---
 net/netfilter/xt_connlimit.c                     |   2 +
 net/netfilter/xt_hashlimit.c                     |   7 +-
 net/netfilter/xt_physdev.c                       |   5 +-
 net/sched/act_ct.c                               |   2 +-
 68 files changed, 603 insertions(+), 417 deletions(-)
 delete mode 100644 include/linux/netfilter/xt_hashlimit.h
 delete mode 100644 include/linux/netfilter/xt_physdev.h
 delete mode 100644 include/linux/netfilter_bridge/ebt_802_3.h
 delete mode 100644 include/net/netfilter/ipv6/nf_conntrack_icmpv6.h
