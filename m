Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90255E5A0C
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 13:47:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726318AbfJZLrn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 07:47:43 -0400
Received: from correo.us.es ([193.147.175.20]:46382 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726139AbfJZLrn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Oct 2019 07:47:43 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 059918C3C45
        for <netdev@vger.kernel.org>; Sat, 26 Oct 2019 13:47:38 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EA46AB8005
        for <netdev@vger.kernel.org>; Sat, 26 Oct 2019 13:47:37 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id DFAB1B7FFB; Sat, 26 Oct 2019 13:47:37 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7F038CA0F2;
        Sat, 26 Oct 2019 13:47:35 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 26 Oct 2019 13:47:35 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 502C942EE393;
        Sat, 26 Oct 2019 13:47:35 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 00/31] Netfilter/IPVS updates for net-next
Date:   Sat, 26 Oct 2019 13:47:02 +0200
Message-Id: <20191026114733.28111-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset contains Netfilter/IPVS updates for net-next,
more specifically:

* Updates for ipset:

1) Coding style fix for ipset comment extension, from Jeremy Sowden.

2) De-inline many functions in ipset, from Jeremy Sowden.

3) Move ipset function definition from header to source file.

4) Move ip_set_put_flags() to source, export it as a symbol, remove
   inline.

5) Move range_to_mask() to the source file where this is used.

6) Move ip_set_get_ip_port() to the source file where this is used.

* IPVS selftests and netns improvements:

7) Two patches to speedup ipvs netns dismantle, from Haishuang Yan.

8) Three patches to add selftest script for ipvs, also from
   Haishuang Yan.

* Conntrack updates and new nf_hook_slow_list() function:

9) Document ct ecache extension, from Florian Westphal.

10) Skip ct extensions from ctnetlink dump, from Florian.

11) Free ct extension immediately, from Florian.

12) Skip access to ecache extension from nf_ct_deliver_cached_events()
    this is not correct as reported by Syzbot.

13) Add and use nf_hook_slow_list(), from Florian.

* Flowtable infrastructure updates:

14) Move priority to nf_flowtable definition.

15) Dynamic allocation of per-device hooks in flowtables.

16) Allow to include netdevice only once in flowtable definitions.

17) Rise maximum number of devices per flowtable.

* Netfilter hardware offload infrastructure updates:

18) Add nft_flow_block_chain() helper function.

19) Pass callback list to nft_setup_cb_call().

20) Add nft_flow_cls_offload_setup() helper function.

21) Remove rules for the unregistered device via netdevice event.

22) Support for multiple devices in a basechain definition at the
    ingress hook.

22) Add nft_chain_offload_cmd() helper function.

23) Add nft_flow_block_offload_init() helper function.

24) Rewind in case of failing to bind multiple devices to hook.

25) Typo in IPv6 tproxy module description, from Norman Rasmussen.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git

Thank you.

----------------------------------------------------------------

The following changes since commit fbe3d0c77c83722d7f1c00924e0ed39df2d1d041:

  Merge branch 'create-netdevsim-instances-in-namespace' (2019-10-05 16:34:15 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git HEAD

for you to fetch changes up to 671312e1a05c579714bc08eb2ac3ad5a2c86a10e:

  netfilter: nf_tables_offload: unbind if multi-device binding fails (2019-10-26 12:36:44 +0200)

----------------------------------------------------------------
Florian Westphal (5):
      netfilter: ecache: document extension area access rules
      netfilter: ctnetlink: don't dump ct extensions of unconfirmed conntracks
      netfilter: conntrack: free extension area immediately
      netfilter: add and use nf_hook_slow_list()
      netfilter: ecache: don't look for ecache extension on dying/unconfirmed conntracks

Haishuang Yan (5):
      ipvs: batch __ip_vs_cleanup
      ipvs: batch __ip_vs_dev_cleanup
      selftests: netfilter: add ipvs test script
      selftests: netfilter: add ipvs nat test case
      selftests: netfilter: add ipvs tunnel test case

Jeremy Sowden (7):
      netfilter: ipset: add a coding-style fix to ip_set_ext_destroy.
      netfilter: ipset: remove inline from static functions in .c files.
      netfilter: ipset: move ip_set_comment functions from ip_set.h to ip_set_core.c.
      netfilter: ipset: move functions to ip_set_core.c.
      netfilter: ipset: make ip_set_put_flags extern.
      netfilter: ipset: move function to ip_set_bitmap_ip.c.
      netfilter: ipset: move ip_set_get_ip_port() to ip_set_bitmap_port.c.

Norman Rasmussen (1):
      netfilter: nft_tproxy: Fix typo in IPv6 module description.

Pablo Neira Ayuso (13):
      Merge tag 'ipvs-next-for-v5.5' of https://git.kernel.org/.../horms/ipvs-next
      netfilter: nf_flow_table: move priority to struct nf_flowtable
      netfilter: nf_tables: dynamically allocate hooks per net_device in flowtables
      netfilter: nf_tables: allow netdevice to be used only once per flowtable
      netfilter: nf_tables: increase maximum devices number per flowtable
      netfilter: nf_tables_offload: add nft_flow_block_chain()
      netfilter: nf_tables_offload: Pass callback list to nft_setup_cb_call()
      netfilter: nf_tables_offload: add nft_flow_cls_offload_setup()
      netfilter: nf_tables_offload: remove rules on unregistered device only
      netfilter: nf_tables: support for multiple devices per netdev hook
      netfilter: nf_tables_offload: add nft_chain_offload_cmd()
      netfilter: nf_tables_offload: add nft_flow_block_offload_init()
      netfilter: nf_tables_offload: unbind if multi-device binding fails

zhang kai (1):
      ipvs: no need to update skb route entry for local destination packets.

 include/linux/netfilter.h                      |  41 +-
 include/linux/netfilter/ipset/ip_set.h         | 196 +--------
 include/linux/netfilter/ipset/ip_set_bitmap.h  |  14 -
 include/linux/netfilter/ipset/ip_set_getport.h |   3 -
 include/net/ip_vs.h                            |   2 +-
 include/net/netfilter/nf_conntrack_extend.h    |  10 -
 include/net/netfilter/nf_flow_table.h          |   1 +
 include/net/netfilter/nf_tables.h              |  16 +-
 include/uapi/linux/netfilter/nf_tables.h       |   2 +
 net/ipv6/netfilter/nf_tproxy_ipv6.c            |   2 +-
 net/netfilter/core.c                           |  20 +
 net/netfilter/ipset/ip_set_bitmap_gen.h        |   2 +-
 net/netfilter/ipset/ip_set_bitmap_ip.c         |  26 +-
 net/netfilter/ipset/ip_set_bitmap_ipmac.c      |  18 +-
 net/netfilter/ipset/ip_set_bitmap_port.c       |  41 +-
 net/netfilter/ipset/ip_set_core.c              | 212 ++++++++-
 net/netfilter/ipset/ip_set_getport.c           |  28 --
 net/netfilter/ipset/ip_set_hash_gen.h          |   4 +-
 net/netfilter/ipset/ip_set_hash_ip.c           |  10 +-
 net/netfilter/ipset/ip_set_hash_ipmac.c        |   8 +-
 net/netfilter/ipset/ip_set_hash_ipmark.c       |   8 +-
 net/netfilter/ipset/ip_set_hash_ipport.c       |   8 +-
 net/netfilter/ipset/ip_set_hash_ipportip.c     |   8 +-
 net/netfilter/ipset/ip_set_hash_ipportnet.c    |  24 +-
 net/netfilter/ipset/ip_set_hash_mac.c          |   6 +-
 net/netfilter/ipset/ip_set_hash_net.c          |  24 +-
 net/netfilter/ipset/ip_set_hash_netiface.c     |  24 +-
 net/netfilter/ipset/ip_set_hash_netnet.c       |  28 +-
 net/netfilter/ipset/ip_set_hash_netport.c      |  24 +-
 net/netfilter/ipset/ip_set_hash_netportnet.c   |  28 +-
 net/netfilter/ipset/ip_set_list_set.c          |   4 +-
 net/netfilter/ipvs/ip_vs_core.c                |  47 +-
 net/netfilter/ipvs/ip_vs_ctl.c                 |  12 +-
 net/netfilter/ipvs/ip_vs_xmit.c                |  18 +-
 net/netfilter/nf_conntrack_core.c              |   2 -
 net/netfilter/nf_conntrack_ecache.c            |  23 +-
 net/netfilter/nf_conntrack_extend.c            |  21 +-
 net/netfilter/nf_conntrack_netlink.c           |  76 ++--
 net/netfilter/nf_tables_api.c                  | 572 +++++++++++++++++--------
 net/netfilter/nf_tables_offload.c              | 188 +++++---
 net/netfilter/nft_chain_filter.c               |  45 +-
 tools/testing/selftests/netfilter/Makefile     |   2 +-
 tools/testing/selftests/netfilter/ipvs.sh      | 228 ++++++++++
 43 files changed, 1346 insertions(+), 730 deletions(-)
 create mode 100755 tools/testing/selftests/netfilter/ipvs.sh
