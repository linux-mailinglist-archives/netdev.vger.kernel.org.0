Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56F6C3119B6
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 04:18:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232289AbhBFDQv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 22:16:51 -0500
Received: from correo.us.es ([193.147.175.20]:53510 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231423AbhBFDH5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Feb 2021 22:07:57 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6902F191904
        for <netdev@vger.kernel.org>; Sat,  6 Feb 2021 02:50:12 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 58B37DA78E
        for <netdev@vger.kernel.org>; Sat,  6 Feb 2021 02:50:12 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 4B215DA78B; Sat,  6 Feb 2021 02:50:12 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WELCOMELIST,USER_IN_WHITELIST autolearn=disabled
        version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D9CC2DA730;
        Sat,  6 Feb 2021 02:50:09 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 06 Feb 2021 02:50:09 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id A9D7242E0F80;
        Sat,  6 Feb 2021 02:50:09 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 0/7] Netfilter/IPVS updates for net-next
Date:   Sat,  6 Feb 2021 02:49:58 +0100
Message-Id: <20210206015005.23037-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset contains Netfilter/IPVS updates for net-next:

1) Remove indirection and use nf_ct_get() instead from nfnetlink_log
   and nfnetlink_queue, from Florian Westphal.

2) Add weighted random twos choice least-connection scheduling for IPVS,
   from Darby Payne.

3) Add a __hash placeholder in the flow tuple structure to identify
   the field to be included in the rhashtable key hash calculation.

4) Add a new nft_parse_register_load() and nft_parse_register_store()
   to consolidate register load and store in the core.

5) Statify nft_parse_register() since it has no more module clients.

6) Remove redundant assignment in nft_cmp, from Colin Ian King.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git

Thanks!

----------------------------------------------------------------

The following changes since commit a61e4b60761fa7fa2cfde6682760763537ce5549:

  Merge branch 'net-dsa-hellcreek-add-taprio-offloading' (2021-01-23 21:25:18 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git HEAD

for you to fetch changes up to 626899a02e6afcd4b2ce5c0551092e3554cec4aa:

  netfilter: nftables: remove redundant assignment of variable err (2021-02-06 02:43:07 +0100)

----------------------------------------------------------------
Colin Ian King (1):
      netfilter: nftables: remove redundant assignment of variable err

Darby Payne (1):
      ipvs: add weighted random twos choice algorithm

Florian Westphal (1):
      netfilter: ctnetlink: remove get_ct indirection

Pablo Neira Ayuso (4):
      netfilter: flowtable: add hash offset field to tuple
      netfilter: nftables: add nft_parse_register_load() and use it
      netfilter: nftables: add nft_parse_register_store() and use it
      netfilter: nftables: statify nft_parse_register()

 include/linux/netfilter.h              |   2 -
 include/net/netfilter/nf_flow_table.h  |   4 +
 include/net/netfilter/nf_tables.h      |  11 ++-
 include/net/netfilter/nf_tables_core.h |  12 +--
 include/net/netfilter/nft_fib.h        |   2 +-
 include/net/netfilter/nft_meta.h       |   4 +-
 net/bridge/netfilter/nft_meta_bridge.c |   5 +-
 net/ipv4/netfilter/nft_dup_ipv4.c      |  18 ++---
 net/ipv6/netfilter/nft_dup_ipv6.c      |  18 ++---
 net/netfilter/ipvs/Kconfig             |  11 +++
 net/netfilter/ipvs/Makefile            |   1 +
 net/netfilter/ipvs/ip_vs_twos.c        | 139 +++++++++++++++++++++++++++++++++
 net/netfilter/nf_conntrack_netlink.c   |   7 --
 net/netfilter/nf_flow_table_core.c     |   6 +-
 net/netfilter/nf_tables_api.c          |  55 ++++++++++---
 net/netfilter/nfnetlink_log.c          |   8 +-
 net/netfilter/nfnetlink_queue.c        |  10 ++-
 net/netfilter/nft_bitwise.c            |  23 +++---
 net/netfilter/nft_byteorder.c          |  14 ++--
 net/netfilter/nft_cmp.c                |  12 +--
 net/netfilter/nft_ct.c                 |  12 ++-
 net/netfilter/nft_dup_netdev.c         |   6 +-
 net/netfilter/nft_dynset.c             |  12 +--
 net/netfilter/nft_exthdr.c             |  14 ++--
 net/netfilter/nft_fib.c                |   5 +-
 net/netfilter/nft_fwd_netdev.c         |  18 ++---
 net/netfilter/nft_hash.c               |  25 +++---
 net/netfilter/nft_immediate.c          |   6 +-
 net/netfilter/nft_lookup.c             |  14 ++--
 net/netfilter/nft_masq.c               |  18 ++---
 net/netfilter/nft_meta.c               |   8 +-
 net/netfilter/nft_nat.c                |  35 ++++-----
 net/netfilter/nft_numgen.c             |  15 ++--
 net/netfilter/nft_objref.c             |   6 +-
 net/netfilter/nft_osf.c                |   8 +-
 net/netfilter/nft_payload.c            |  10 +--
 net/netfilter/nft_queue.c              |  12 +--
 net/netfilter/nft_range.c              |   6 +-
 net/netfilter/nft_redir.c              |  18 ++---
 net/netfilter/nft_rt.c                 |   7 +-
 net/netfilter/nft_socket.c             |   7 +-
 net/netfilter/nft_tproxy.c             |  14 ++--
 net/netfilter/nft_tunnel.c             |   8 +-
 net/netfilter/nft_xfrm.c               |   7 +-
 44 files changed, 406 insertions(+), 247 deletions(-)
 create mode 100644 net/netfilter/ipvs/ip_vs_twos.c
