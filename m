Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB10561CF5
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 12:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725977AbfGHKcp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 06:32:45 -0400
Received: from mail.us.es ([193.147.175.20]:34234 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725869AbfGHKco (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jul 2019 06:32:44 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BB95CBAE86
        for <netdev@vger.kernel.org>; Mon,  8 Jul 2019 12:32:42 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id ACE6DA0AAC
        for <netdev@vger.kernel.org>; Mon,  8 Jul 2019 12:32:42 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id AC2B9DA704; Mon,  8 Jul 2019 12:32:42 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 98181FB37C;
        Mon,  8 Jul 2019 12:32:40 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 08 Jul 2019 12:32:40 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 683D34265A31;
        Mon,  8 Jul 2019 12:32:40 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 00/15] Netfilter/IPVS updates for net-next
Date:   Mon,  8 Jul 2019 12:32:22 +0200
Message-Id: <20190708103237.28061-1-pablo@netfilter.org>
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

The following patchset contains Netfilter/IPVS updates for net-next:

1) Move bridge keys in nft_meta to nft_meta_bridge, from wenxu.

2) Support for bridge pvid matching, from wenxu.

3) Support for bridge vlan protocol matching, also from wenxu.

4) Add br_vlan_get_pvid_rcu(), to fetch the bridge port pvid
   from packet path.

5) Prefer specific family extension in nf_tables.

6) Autoload specific family extension in case it is missing.

7) Add synproxy support to nf_tables, from Fernando Fernandez Mancera.

8) Support for GRE encapsulation in IPVS, from Vadim Fedorenko.

9) ICMP handling for GRE encapsulation, from Julian Anastasov.

10) Remove unused parameter in nf_queue, from Florian Westphal.

11) Replace seq_printf() by seq_puts() in nf_log, from Markus Elfring.

12) Rename nf_SYNPROXY.h => nf_synproxy.h before this header becomes
    public.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git

Thanks.

----------------------------------------------------------------

The following changes since commit 77cf8edbc0e7db6d68d1a49cf954849fb92cfa7c:

  tipc: simplify stale link failure criteria (2019-06-25 13:28:57 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git HEAD

for you to fetch changes up to 0ef1efd1354d732d040f29b2005420f83fcdd8f4:

  netfilter: nf_tables: force module load in case select_ops() returns -EAGAIN (2019-07-06 08:37:36 +0200)

----------------------------------------------------------------
Fernando Fernandez Mancera (1):
      netfilter: nf_tables: Add synproxy support

Florian Westphal (1):
      netfilter: nf_queue: remove unused hook entries pointer

Julian Anastasov (1):
      ipvs: strip gre tunnel headers from icmp errors

Markus Elfring (1):
      netfilter: nf_log: Replace a seq_printf() call by seq_puts() in seq_show()

Pablo Neira Ayuso (5):
      netfilter: rename nf_SYNPROXY.h to nf_synproxy.h
      bridge: add br_vlan_get_pvid_rcu()
      netfilter: nf_tables: add nft_expr_type_request_module()
      netfilter: nf_tables: __nft_expr_type_get() selects specific family type
      netfilter: nf_tables: force module load in case select_ops() returns -EAGAIN

Vadim Fedorenko (1):
      ipvs: allow tunneling with gre encapsulation

wenxu (5):
      netfilter: nft_meta: move bridge meta keys into nft_meta_bridge
      netfilter: nft_meta_bridge: Remove the br_private.h header
      netfilter: nft_meta_bridge: add NFT_META_BRI_IIFPVID support
      bridge: add br_vlan_get_proto()
      netfilter: nft_meta_bridge: Add NFT_META_BRI_IIFVPROTO support

 include/linux/if_bridge.h                          |  12 +
 include/net/netfilter/nf_conntrack_synproxy.h      |   1 +
 include/net/netfilter/nf_queue.h                   |   3 +-
 include/net/netfilter/nf_synproxy.h                |   5 +
 include/net/netfilter/nft_meta.h                   |  44 ++++
 include/uapi/linux/ip_vs.h                         |   1 +
 .../netfilter/{nf_SYNPROXY.h => nf_synproxy.h}     |   4 +
 include/uapi/linux/netfilter/nf_tables.h           |  20 ++
 include/uapi/linux/netfilter/xt_SYNPROXY.h         |   2 +-
 net/bridge/br_input.c                              |   2 +-
 net/bridge/br_vlan.c                               |  29 ++-
 net/bridge/netfilter/Kconfig                       |   6 +
 net/bridge/netfilter/Makefile                      |   1 +
 net/bridge/netfilter/nft_meta_bridge.c             | 163 ++++++++++++
 net/netfilter/Kconfig                              |  11 +
 net/netfilter/Makefile                             |   1 +
 net/netfilter/core.c                               |   2 +-
 net/netfilter/ipvs/ip_vs_core.c                    |  46 +++-
 net/netfilter/ipvs/ip_vs_ctl.c                     |   1 +
 net/netfilter/ipvs/ip_vs_xmit.c                    |  66 ++++-
 net/netfilter/nf_log.c                             |   2 +-
 net/netfilter/nf_queue.c                           |   8 +-
 net/netfilter/nf_synproxy_core.c                   |   2 +-
 net/netfilter/nf_tables_api.c                      |  36 ++-
 net/netfilter/nf_tables_core.c                     |   1 +
 net/netfilter/nft_meta.c                           |  85 +++---
 net/netfilter/nft_synproxy.c                       | 287 +++++++++++++++++++++
 27 files changed, 757 insertions(+), 84 deletions(-)
 create mode 100644 include/net/netfilter/nft_meta.h
 rename include/uapi/linux/netfilter/{nf_SYNPROXY.h => nf_synproxy.h} (71%)
 create mode 100644 net/bridge/netfilter/nft_meta_bridge.c
 create mode 100644 net/netfilter/nft_synproxy.c
