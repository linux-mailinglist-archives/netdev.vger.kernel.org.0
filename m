Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E63451FC8
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 02:14:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729230AbfFYAMp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 20:12:45 -0400
Received: from mail.us.es ([193.147.175.20]:37984 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726631AbfFYAMp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jun 2019 20:12:45 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E674AC04AA
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 02:12:41 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D48ADDA707
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 02:12:41 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C9F9CDA705; Tue, 25 Jun 2019 02:12:41 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AA62BDA701;
        Tue, 25 Jun 2019 02:12:39 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 25 Jun 2019 02:12:39 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 7E7804265A2F;
        Tue, 25 Jun 2019 02:12:39 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 00/26] Netfilter updates for net-next
Date:   Tue, 25 Jun 2019 02:12:07 +0200
Message-Id: <20190625001233.22057-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patches contains Netfilter updates for net-next:

1) .br_defrag indirection depends on CONFIG_NF_DEFRAG_IPV6, from wenxu.

2) Remove unnecessary memset() in ipset, from Florent Fourcot.

3) Merge control plane addition and deletion in ipset, also from Florent.

4) A few missing check for nla_parse() in ipset, from Aditya Pakki
   and Jozsef Kadlecsik.

5) Incorrect cleanup in error path of xt_set version 3, from Jozsef.

6) Memory accounting problems when resizing in ipset, from Stefano Brivio.

7) Jozsef updates his email to @netfilter.org, this batch comes with a
   conflict resolution with recent SPDX header updates.

8) Add to create custom conntrack expectations via nftables, from
   Stephane Veyret.

9) A lookup optimization for conntrack, from Florian Westphal.

10) Check for supported flags in xt_owner.

11) Support for pernet sysctl in br_netfilter, patches
    from Christian Brauner.

12) Patches to move common synproxy infrastructure to nf_synproxy.c,
    to prepare the synproxy support for nf_tables, patches from
    Fernando Fernandez Mancera.

13) Support to restore expiration time in set element, from Laura Garcia.

14) Fix recent rewrite of netfilter IPv6 to avoid indirections
    when CONFIG_IPV6 is unset, from Arnd Bergmann.

15) Always reset vlan tag on skbuff fraglist when refragmenting in
    bridge conntrack, from wenxu.

16) Support to match IPv4 options in nf_tables, from Stephen Suryaputra.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git

This batch comes with a conflict resolution between a patch to remove
the GPL disclaimer by SPDX tags and Jozsef Kladecsik's email update.

Thanks.

----------------------------------------------------------------

The following changes since commit 045df37e743c7448931131988e99e8fe0cc92a54:

  Merge branch 'cxgb4-Reference-count-MPS-TCAM-entries-within-a-PF' (2019-06-24 14:54:06 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git HEAD

for you to fetch changes up to 1c5ba67d2277ac2faf37c61076e8b5fa312be492:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next (2019-06-25 01:32:59 +0200)

----------------------------------------------------------------
Aditya Pakki (1):
      netfilter: ipset: fix a missing check of nla_parse

Arnd Bergmann (2):
      netfilter: synproxy: fix building syncookie calls
      netfilter: fix nf_conntrack_bridge/ipv6 link error

Christian Brauner (3):
      netfilter: bridge: port sysctls to use brnf_net
      netfilter: bridge: namespace bridge netfilter sysctls
      netfilter: bridge: prevent UAF in brnf_exit_net()

Colin Ian King (1):
      netfilter: synproxy: ensure zero is returned on non-error return path

Fernando Fernandez Mancera (4):
      netfilter: synproxy: add common uapi for SYNPROXY infrastructure
      netfilter: synproxy: remove module dependency on IPv6 SYNPROXY
      netfilter: synproxy: extract SYNPROXY infrastructure from {ipt, ip6t}_SYNPROXY
      netfilter: synproxy: fix manual bump of the reference counter

Florent Fourcot (2):
      netfilter: ipset: remove useless memset() calls
      netfilter: ipset: merge uadd and udel functions

Florian Westphal (1):
      netfilter: conntrack: small conntrack lookup optimization

Jozsef Kadlecsik (3):
      netfilter: ipset: Fix the last missing check of nla_parse_deprecated()
      netfilter: ipset: Fix error path in set_target_v3_checkentry()
      Update my email address

Laura Garcia Liebana (1):
      netfilter: nf_tables: enable set expiration time for set elements

Pablo Neira Ayuso (4):
      netfilter: xt_owner: bail out with EINVAL in case of unsupported flags
      Merge branch 'master' of git://blackhole.kfki.hu/nf-next
      netfilter: synproxy: use nf_cookie_v6_check() from core
      Merge git://git.kernel.org/.../davem/net-next

Stefano Brivio (1):
      ipset: Fix memory accounting for hash types on resize

Stephen Suryaputra (1):
      netfilter: nf_tables: add support for matching IPv4 options

Stéphane Veyret (2):
      netfilter: nft_ct: add ct expectations support
      netfilter: nft_ct: fix null pointer in ct expectations support

wenxu (2):
      netfilter: ipv6: Fix undefined symbol nf_ct_frag6_gather
      netfilter: bridge: Fix non-untagged fragment packet

 CREDITS                                        |   2 +-
 MAINTAINERS                                    |   2 +-
 include/linux/jhash.h                          |   2 +-
 include/linux/netfilter/ipset/ip_set.h         |   2 +-
 include/linux/netfilter/ipset/ip_set_counter.h |   3 +-
 include/linux/netfilter/ipset/ip_set_skbinfo.h |   3 +-
 include/linux/netfilter/ipset/ip_set_timeout.h |   3 +-
 include/linux/netfilter_ipv6.h                 |  54 +-
 include/net/netfilter/br_netfilter.h           |   3 +-
 include/net/netfilter/nf_conntrack.h           |   7 +-
 include/net/netfilter/nf_conntrack_synproxy.h  |  13 +-
 include/net/netfilter/nf_synproxy.h            |  44 ++
 include/net/netfilter/nf_tables.h              |   2 +-
 include/uapi/linux/netfilter/ipset/ip_set.h    |   2 +-
 include/uapi/linux/netfilter/nf_SYNPROXY.h     |  19 +
 include/uapi/linux/netfilter/nf_tables.h       |  16 +-
 include/uapi/linux/netfilter/xt_SYNPROXY.h     |  18 +-
 include/uapi/linux/netfilter/xt_owner.h        |   5 +
 net/bridge/br_netfilter_hooks.c                | 247 ++++---
 net/bridge/br_netfilter_ipv6.c                 |   2 +-
 net/bridge/netfilter/nf_conntrack_bridge.c     |   2 +
 net/ipv4/ip_options.c                          |   1 +
 net/ipv4/netfilter/ipt_SYNPROXY.c              | 395 +----------
 net/ipv4/netfilter/iptable_raw.c               |   2 +-
 net/ipv4/netfilter/nf_nat_h323.c               |   2 +-
 net/ipv6/netfilter.c                           |   8 +-
 net/ipv6/netfilter/ip6t_SYNPROXY.c             | 420 +-----------
 net/ipv6/netfilter/ip6table_raw.c              |   2 +-
 net/netfilter/ipset/ip_set_bitmap_gen.h        |   3 +-
 net/netfilter/ipset/ip_set_bitmap_ip.c         |   4 +-
 net/netfilter/ipset/ip_set_bitmap_ipmac.c      |   3 +-
 net/netfilter/ipset/ip_set_bitmap_port.c       |   5 +-
 net/netfilter/ipset/ip_set_core.c              |  97 +--
 net/netfilter/ipset/ip_set_getport.c           |   6 +-
 net/netfilter/ipset/ip_set_hash_gen.h          |   5 +-
 net/netfilter/ipset/ip_set_hash_ip.c           |   5 +-
 net/netfilter/ipset/ip_set_hash_ipmark.c       |   4 +-
 net/netfilter/ipset/ip_set_hash_ipport.c       |   5 +-
 net/netfilter/ipset/ip_set_hash_ipportip.c     |   5 +-
 net/netfilter/ipset/ip_set_hash_ipportnet.c    |   5 +-
 net/netfilter/ipset/ip_set_hash_mac.c          |   5 +-
 net/netfilter/ipset/ip_set_hash_net.c          |   5 +-
 net/netfilter/ipset/ip_set_hash_netiface.c     |   5 +-
 net/netfilter/ipset/ip_set_hash_netnet.c       |   2 +-
 net/netfilter/ipset/ip_set_hash_netport.c      |   5 +-
 net/netfilter/ipset/ip_set_hash_netportnet.c   |   3 +-
 net/netfilter/ipset/ip_set_list_set.c          |   5 +-
 net/netfilter/nf_conntrack_core.c              |  25 +-
 net/netfilter/nf_conntrack_h323_main.c         |   2 +-
 net/netfilter/nf_conntrack_proto_tcp.c         |   2 +-
 net/netfilter/nf_synproxy_core.c               | 896 ++++++++++++++++++++++++-
 net/netfilter/nf_tables_api.c                  |  26 +-
 net/netfilter/nft_ct.c                         | 142 +++-
 net/netfilter/nft_dynset.c                     |   2 +-
 net/netfilter/nft_exthdr.c                     | 133 ++++
 net/netfilter/xt_iprange.c                     |   4 +-
 net/netfilter/xt_owner.c                       |   3 +
 net/netfilter/xt_set.c                         |  45 +-
 58 files changed, 1611 insertions(+), 1127 deletions(-)
 create mode 100644 include/net/netfilter/nf_synproxy.h
 create mode 100644 include/uapi/linux/netfilter/nf_SYNPROXY.h
