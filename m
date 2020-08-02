Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0DB42359DE
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 20:32:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbgHBScB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 14:32:01 -0400
Received: from correo.us.es ([193.147.175.20]:45718 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725917AbgHBScB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 2 Aug 2020 14:32:01 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B9D24DA704
        for <netdev@vger.kernel.org>; Sun,  2 Aug 2020 20:31:58 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A8420DA73D
        for <netdev@vger.kernel.org>; Sun,  2 Aug 2020 20:31:58 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 9D951DA789; Sun,  2 Aug 2020 20:31:58 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WELCOMELIST,USER_IN_WHITELIST autolearn=disabled
        version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 53B98DA73D;
        Sun,  2 Aug 2020 20:31:56 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 02 Aug 2020 20:31:56 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (120.205.137.78.rev.vodafone.pt [78.137.205.120])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 792714265A2F;
        Sun,  2 Aug 2020 20:31:55 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 0/7] Netfilter updates for net-next
Date:   Sun,  2 Aug 2020 20:31:41 +0200
Message-Id: <20200802183149.2808-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

1) UAF in chain binding support from previous batch, from Dan Carpenter.

2) Queue up delayed work to expire connections with no destination,
   from Andrew Sy Kim.

3) Use fallthrough pseudo-keyword, from Gustavo A. R. Silva.

4) Replace HTTP links with HTTPS, from Alexander A. Klimov.

5) Remove superfluous null header checks in ip6tables, from
   Gaurav Singh.

6) Add extended netlink error reporting for expression.

7) Report EEXIST on overlapping chain, set elements and flowtable
   devices.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git

Thank you.

----------------------------------------------------------------

The following changes since commit 4ff91fa0a3acd072c9a46ebe08a6e2471ddd3c95:

  Merge branch 'udp_tunnel-NIC-RX-port-offload-infrastructure' (2020-07-14 17:04:28 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git HEAD

for you to fetch changes up to 77a92189ecfd061616ad531d386639aab7baaad9:

  netfilter: nf_tables: report EEXIST on overlaps (2020-08-02 19:53:45 +0200)

----------------------------------------------------------------
Alexander A. Klimov (1):
      netfilter: Replace HTTP links with HTTPS ones

Andrew Sy Kim (1):
      ipvs: queue delayed work to expire no destination connections if expire_nodest_conn=1

Dan Carpenter (1):
      netfilter: nf_tables: Fix a use after free in nft_immediate_destroy()

Gaurav Singh (1):
      netfilter: ip6tables: Remove redundant null checks

Gustavo A. R. Silva (1):
      netfilter: Use fallthrough pseudo-keyword

Pablo Neira Ayuso (2):
      netfilter: nf_tables: extended netlink error reporting for expressions
      netfilter: nf_tables: report EEXIST on overlaps

 include/net/ip_vs.h                        | 29 ++++++++++++++++++
 include/uapi/linux/netfilter/xt_connmark.h |  2 +-
 net/bridge/netfilter/ebtables.c            |  2 +-
 net/decnet/netfilter/dn_rtmsg.c            |  2 +-
 net/ipv6/netfilter/ip6t_ah.c               |  3 +-
 net/ipv6/netfilter/ip6t_frag.c             |  3 +-
 net/ipv6/netfilter/ip6t_hbh.c              |  3 +-
 net/ipv6/netfilter/ip6t_rt.c               |  3 +-
 net/netfilter/Kconfig                      |  2 +-
 net/netfilter/ipset/ip_set_core.c          |  2 +-
 net/netfilter/ipvs/ip_vs_conn.c            | 39 +++++++++++++++++++++++++
 net/netfilter/ipvs/ip_vs_core.c            | 47 +++++++++++++-----------------
 net/netfilter/ipvs/ip_vs_ctl.c             | 22 ++++++++++++++
 net/netfilter/nf_conntrack_h323_asn1.c     |  6 ++--
 net/netfilter/nf_conntrack_proto.c         |  2 +-
 net/netfilter/nf_conntrack_proto_tcp.c     |  2 +-
 net/netfilter/nf_conntrack_standalone.c    |  2 +-
 net/netfilter/nf_nat_core.c                | 12 ++++----
 net/netfilter/nf_synproxy_core.c           |  6 ++--
 net/netfilter/nf_tables_api.c              | 31 +++++++++++---------
 net/netfilter/nf_tables_core.c             |  2 +-
 net/netfilter/nfnetlink_acct.c             |  2 +-
 net/netfilter/nfnetlink_cttimeout.c        |  2 +-
 net/netfilter/nft_cmp.c                    |  4 +--
 net/netfilter/nft_ct.c                     |  6 ++--
 net/netfilter/nft_fib.c                    |  2 +-
 net/netfilter/nft_immediate.c              |  4 +--
 net/netfilter/nft_payload.c                |  2 +-
 net/netfilter/nft_set_pipapo.c             |  4 +--
 net/netfilter/utils.c                      |  8 ++---
 net/netfilter/x_tables.c                   |  2 +-
 net/netfilter/xt_CONNSECMARK.c             |  2 +-
 net/netfilter/xt_connmark.c                |  2 +-
 net/netfilter/xt_nfacct.c                  |  2 +-
 net/netfilter/xt_time.c                    |  2 +-
 35 files changed, 173 insertions(+), 93 deletions(-)
