Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 590C26E964
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 18:45:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727717AbfGSQp3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 12:45:29 -0400
Received: from mail.us.es ([193.147.175.20]:49376 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728449AbfGSQp3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Jul 2019 12:45:29 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 54A54BAEE2
        for <netdev@vger.kernel.org>; Fri, 19 Jul 2019 18:45:27 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3E08A1150CE
        for <netdev@vger.kernel.org>; Fri, 19 Jul 2019 18:45:27 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 3B4C91150D8; Fri, 19 Jul 2019 18:45:27 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7433F1150CE;
        Fri, 19 Jul 2019 18:45:22 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 19 Jul 2019 18:45:22 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [47.60.47.94])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id DAA4B4265A2F;
        Fri, 19 Jul 2019 18:45:21 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 00/14] Netfilter fixes for net
Date:   Fri, 19 Jul 2019 18:45:03 +0200
Message-Id: <20190719164517.29496-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following patchset contains Netfilter fixes for net:

1) Fix a deadlock when module is requested via netlink_bind()
   in nfnetlink, from Florian Westphal.

2) Fix ipt_rpfilter and ip6t_rpfilter with VRF, from Miaohe Lin.

3) Skip master comparison in SIP helper to fix expectation clash
   under two valid scenarios, from xiao ruizhu.

4) Remove obsolete comments in nf_conntrack codebase, from
   Yonatan Goldschmidt.

5) Fix redirect extension module autoload, from Christian Hesse.

6) Fix incorrect mssg option sent to client in synproxy,
   from Fernando Fernandez.

7) Fix incorrect window calculations in TCP conntrack, from
   Florian Westphal.

8) Don't bail out when updating basechain policy due to recent
   offload works, also from Florian.

9) Allow symhash to use modulus 1 as other hash extensions do,
   from Laura.Garcia.

10) Missing NAT chain module autoload for the inet family,
    from Phil Sutter.

11) Fix missing adjustment of TCP RST packet in synproxy,
    from Fernando Fernandez.

12) Skip EAGAIN path when nft_meta_bridge is built-in or
    not selected.

13) Conntrack bridge does not depend on nf_tables_bridge.

14) Turn NF_TABLES_BRIDGE into tristate to fix possible
    link break of nft_meta_bridge, from Arnd Bergmann.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit 76104862cccaeaa84fdd23e39f2610a96296291c:

  sky2: Disable MSI on P5W DH Deluxe (2019-07-14 13:45:54 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to dfee0e99bcff718fa14d973c41f161220fdcb7d5:

  netfilter: bridge: make NF_TABLES_BRIDGE tristate (2019-07-19 18:08:14 +0200)

----------------------------------------------------------------
Arnd Bergmann (1):
      netfilter: bridge: make NF_TABLES_BRIDGE tristate

Christian Hesse (1):
      netfilter: nf_tables: fix module autoload for redir

Fernando Fernandez Mancera (2):
      netfilter: synproxy: fix erroneous tcp mss option
      netfilter: synproxy: fix rst sequence number mismatch

Florian Westphal (3):
      netfilter: nfnetlink: avoid deadlock due to synchronous request_module
      netfilter: conntrack: always store window size un-scaled
      netfilter: nf_tables: don't fail when updating base chain policy

Laura Garcia Liebana (1):
      netfilter: nft_hash: fix symhash with modulus one

Miaohe Lin (1):
      netfilter: Fix rpfilter dropping vrf packets by mistake

Pablo Neira Ayuso (2):
      netfilter: nft_meta: skip EAGAIN if nft_meta_bridge is not a module
      netfilter: bridge: NF_CONNTRACK_BRIDGE does not depend on NF_TABLES_BRIDGE

Phil Sutter (1):
      netfilter: nf_tables: Support auto-loading for inet nat

Yonatan Goldschmidt (1):
      netfilter: Update obsolete comments referring to ip_conntrack

xiao ruizhu (1):
      netfilter: nf_conntrack_sip: fix expectation clash

 include/linux/netfilter/nf_conntrack_h323_asn1.h |  3 +--
 include/net/netfilter/nf_conntrack_expect.h      | 12 ++++++++---
 include/net/netfilter/nf_conntrack_synproxy.h    |  1 +
 net/bridge/netfilter/Kconfig                     |  6 +++---
 net/ipv4/netfilter/ipt_CLUSTERIP.c               |  4 ++--
 net/ipv4/netfilter/ipt_SYNPROXY.c                |  2 ++
 net/ipv4/netfilter/ipt_rpfilter.c                |  1 +
 net/ipv4/netfilter/nf_nat_h323.c                 | 12 +++++------
 net/ipv6/netfilter/ip6t_SYNPROXY.c               |  2 ++
 net/ipv6/netfilter/ip6t_rpfilter.c               |  8 ++++++--
 net/netfilter/Kconfig                            |  6 ++----
 net/netfilter/ipvs/ip_vs_nfct.c                  |  2 +-
 net/netfilter/nf_conntrack_amanda.c              |  2 +-
 net/netfilter/nf_conntrack_broadcast.c           |  2 +-
 net/netfilter/nf_conntrack_core.c                |  4 +---
 net/netfilter/nf_conntrack_expect.c              | 26 +++++++++++++++++-------
 net/netfilter/nf_conntrack_ftp.c                 |  2 +-
 net/netfilter/nf_conntrack_h323_asn1.c           |  5 ++---
 net/netfilter/nf_conntrack_h323_main.c           | 18 ++++++++--------
 net/netfilter/nf_conntrack_irc.c                 |  2 +-
 net/netfilter/nf_conntrack_netlink.c             |  4 ++--
 net/netfilter/nf_conntrack_pptp.c                |  4 ++--
 net/netfilter/nf_conntrack_proto_gre.c           |  2 --
 net/netfilter/nf_conntrack_proto_icmp.c          |  2 +-
 net/netfilter/nf_conntrack_proto_tcp.c           |  8 +++++---
 net/netfilter/nf_conntrack_sane.c                |  2 +-
 net/netfilter/nf_conntrack_sip.c                 | 10 ++++++---
 net/netfilter/nf_conntrack_tftp.c                |  2 +-
 net/netfilter/nf_nat_amanda.c                    |  2 +-
 net/netfilter/nf_nat_core.c                      |  2 +-
 net/netfilter/nf_nat_ftp.c                       |  2 +-
 net/netfilter/nf_nat_irc.c                       |  2 +-
 net/netfilter/nf_nat_sip.c                       |  8 +++++---
 net/netfilter/nf_nat_tftp.c                      |  2 +-
 net/netfilter/nf_synproxy_core.c                 |  8 ++++----
 net/netfilter/nf_tables_api.c                    |  2 ++
 net/netfilter/nfnetlink.c                        |  2 +-
 net/netfilter/nft_chain_filter.c                 |  2 +-
 net/netfilter/nft_chain_nat.c                    |  3 +++
 net/netfilter/nft_ct.c                           |  2 +-
 net/netfilter/nft_hash.c                         |  2 +-
 net/netfilter/nft_meta.c                         |  2 +-
 net/netfilter/nft_redir.c                        |  2 +-
 net/netfilter/nft_synproxy.c                     |  2 ++
 44 files changed, 117 insertions(+), 82 deletions(-)

