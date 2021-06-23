Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8984B3B1F28
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 19:03:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbhFWRF1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 13:05:27 -0400
Received: from mail.netfilter.org ([217.70.188.207]:33500 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbhFWRF1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 13:05:27 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 5D1C064275;
        Wed, 23 Jun 2021 19:01:43 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 0/6] Netfilter updates for net-next
Date:   Wed, 23 Jun 2021 19:02:55 +0200
Message-Id: <20210623170301.59973-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset contains Netfilter updates for net-next:

1) Skip non-SCTP packets in the new SCTP chunk support for nft_exthdr,
   from Phil Sutter.

2) Simplify TCP option sanity check for TCP packets, also from Phil.

3) Add a new expression to store when the rule has been used last time.

4) Pass the hook state object to log function, from Florian Westphal.

5) Document the new sysctl knobs to tune the flowtable timeouts,
   from Oz Shlomo.

6) Fix snprintf error check in the new nfnetlink_hook infrastructure,
   from Dan Carpenter.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git

Thank you!

----------------------------------------------------------------

The following changes since commit c7654495916e109f76a67fd3ae68f8fa70ab4faa:

  net: chelsio: cxgb4: use eth_zero_addr() to assign zero address (2021-06-16 00:53:17 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git HEAD

for you to fetch changes up to 24610ed80df65a564d6165d15505a950d05f9f5a:

  netfilter: nfnetlink_hook: fix check for snprintf() overflow (2021-06-21 22:05:29 +0200)

----------------------------------------------------------------
Dan Carpenter (1):
      netfilter: nfnetlink_hook: fix check for snprintf() overflow

Florian Westphal (1):
      netfilter: conntrack: pass hook state to log functions

Oz Shlomo (1):
      docs: networking: Update connection tracking offload sysctl parameters

Pablo Neira Ayuso (1):
      netfilter: nf_tables: add last expression

Phil Sutter (2):
      netfilter: nft_exthdr: Search chunks in SCTP packets only
      netfilter: nft_extdhr: Drop pointless check of tprot_set

 Documentation/networking/nf_conntrack-sysctl.rst | 24 +++++++
 include/net/netfilter/nf_conntrack_l4proto.h     | 20 +++---
 include/net/netfilter/nf_tables_core.h           |  1 +
 include/uapi/linux/netfilter/nf_tables.h         | 15 ++++
 net/netfilter/Makefile                           |  2 +-
 net/netfilter/nf_conntrack_proto.c               | 16 +++--
 net/netfilter/nf_conntrack_proto_dccp.c          | 14 ++--
 net/netfilter/nf_conntrack_proto_icmp.c          |  7 +-
 net/netfilter/nf_conntrack_proto_icmpv6.c        |  3 +-
 net/netfilter/nf_conntrack_proto_sctp.c          |  2 +-
 net/netfilter/nf_conntrack_proto_tcp.c           | 23 ++++---
 net/netfilter/nf_conntrack_proto_udp.c           |  6 +-
 net/netfilter/nf_tables_core.c                   |  1 +
 net/netfilter/nfnetlink_hook.c                   |  4 +-
 net/netfilter/nft_exthdr.c                       |  7 +-
 net/netfilter/nft_last.c                         | 87 ++++++++++++++++++++++++
 16 files changed, 184 insertions(+), 48 deletions(-)
 create mode 100644 net/netfilter/nft_last.c
