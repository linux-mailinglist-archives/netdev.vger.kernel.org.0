Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 500C62D8A95
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 00:10:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408193AbgLLXJN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 18:09:13 -0500
Received: from correo.us.es ([193.147.175.20]:46732 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391009AbgLLXGG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Dec 2020 18:06:06 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A3C39303D08
        for <netdev@vger.kernel.org>; Sun, 13 Dec 2020 00:05:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 96214DA78D
        for <netdev@vger.kernel.org>; Sun, 13 Dec 2020 00:05:09 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 8B868DA704; Sun, 13 Dec 2020 00:05:09 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WELCOMELIST,USER_IN_WHITELIST autolearn=disabled
        version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 284E5DA704;
        Sun, 13 Dec 2020 00:05:07 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 13 Dec 2020 00:05:07 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id F1FC74265A5A;
        Sun, 13 Dec 2020 00:05:06 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 00/10] Netfilter/IPVS updates for net-next
Date:   Sun, 13 Dec 2020 00:05:03 +0100
Message-Id: <20201212230513.3465-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub, David,

The following patchset contains Netfilter updates for net-next:

1) Missing dependencies in NFT_BRIDGE_REJECT, from Randy Dunlap.

2) Use atomic_inc_return() instead of atomic_add_return() in IPVS,
   from Yejune Deng.

3) Simplify check for overquota in xt_nfacct, from Kaixu Xia.

4) Move nfnl_acct_list away from struct net, from Miao Wang.

5) Pass actual sk in reject actions, from Jan Engelhardt.

6) Add timeout and protoinfo to ctnetlink destroy events,
   from Florian Westphal.

7) Four patches to generalize set infrastructure to support
   for multiple expressions per set element.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git

Thanks!

----------------------------------------------------------------

The following changes since commit f9e425e99b0756c1479042afe761073779df2a30:

  octeontx2-af: Add support for RSS hashing based on Transport protocol field (2020-11-21 16:05:22 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git HEAD

for you to fetch changes up to 48b0ae046ee96eac999839f6d26c624b8c93ed66:

  netfilter: nftables: netlink support for several set element expressions (2020-12-12 19:20:52 +0100)

----------------------------------------------------------------
Florian Westphal (1):
      netfilter: ctnetlink: add timeout and protoinfo to destroy events

Jan Engelhardt (1):
      netfilter: use actual socket sk for REJECT action

Kaixu Xia (1):
      netfilter: Remove unnecessary conversion to bool

Pablo Neira Ayuso (4):
      netfilter: nftables: generalize set expressions support
      netfilter: nftables: move nft_expr before nft_set
      netfilter: nftables: generalize set extension to support for several expressions
      netfilter: nftables: netlink support for several set element expressions

Randy Dunlap (1):
      netfilter: nft_reject_bridge: fix build errors due to code movement

Wang Shanker (1):
      netfilter: nfnl_acct: remove data from struct net

Yejune Deng (1):
      ipvs: replace atomic_add_return()

 include/net/net_namespace.h                  |   3 -
 include/net/netfilter/ipv4/nf_reject.h       |   4 +-
 include/net/netfilter/ipv6/nf_reject.h       |   5 +-
 include/net/netfilter/nf_conntrack_l4proto.h |   2 +-
 include/net/netfilter/nf_tables.h            |  95 ++++++----
 include/uapi/linux/netfilter/nf_tables.h     |   6 +
 net/bridge/netfilter/Kconfig                 |   2 +
 net/ipv4/netfilter/ipt_REJECT.c              |   3 +-
 net/ipv4/netfilter/nf_reject_ipv4.c          |   6 +-
 net/ipv4/netfilter/nft_reject_ipv4.c         |   3 +-
 net/ipv6/netfilter/ip6t_REJECT.c             |   2 +-
 net/ipv6/netfilter/nf_reject_ipv6.c          |   5 +-
 net/ipv6/netfilter/nft_reject_ipv6.c         |   3 +-
 net/netfilter/ipvs/ip_vs_core.c              |   2 +-
 net/netfilter/ipvs/ip_vs_sync.c              |   4 +-
 net/netfilter/nf_conntrack_netlink.c         |  31 ++--
 net/netfilter/nf_conntrack_proto_dccp.c      |  13 +-
 net/netfilter/nf_conntrack_proto_sctp.c      |  13 +-
 net/netfilter/nf_conntrack_proto_tcp.c       |  13 +-
 net/netfilter/nf_tables_api.c                | 250 ++++++++++++++++++++++-----
 net/netfilter/nfnetlink_acct.c               |  38 +++-
 net/netfilter/nft_dynset.c                   | 156 ++++++++++++++---
 net/netfilter/nft_reject_inet.c              |   6 +-
 net/netfilter/nft_set_hash.c                 |  27 ++-
 net/netfilter/xt_nfacct.c                    |   2 +-
 25 files changed, 534 insertions(+), 160 deletions(-)
