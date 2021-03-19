Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DB533411E6
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 02:07:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232069AbhCSBGc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 21:06:32 -0400
Received: from mail.netfilter.org ([217.70.188.207]:52576 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231422AbhCSBGO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 21:06:14 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 77B9862C13;
        Fri, 19 Mar 2021 02:06:09 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 0/9] Netfilter fixes for net
Date:   Fri, 19 Mar 2021 02:05:59 +0100
Message-Id: <20210319010608.9758-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

1) Several patches to testore use of memory barriers instead of RCU to
   ensure consistent access to ruleset, from Mark Tomlinson.

2) Fix dump of expectation via ctnetlink, from Florian Westphal.

3) GRE helper works for IPv6, from Ludovic Senecaux.

4) Set error on unsupported flowtable flags.

5) Use delayed instead of deferrable workqueue in the flowtable,
   from Yinjun Zhang.

6) Fix spurious EEXIST in case of add-after-delete flowtable in
   the same batch.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thanks!

----------------------------------------------------------------

The following changes since commit a25f822285420486f5da434efc8d940d42a83bce:

  flow_dissector: fix byteorder of dissected ICMP ID (2021-03-14 14:30:20 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to 86fe2c19eec4728fd9a42ba18f3b47f0d5f9fd7c:

  netfilter: nftables: skip hook overlap logic if flowtable is stale (2021-03-18 01:08:54 +0100)

----------------------------------------------------------------
Florian Westphal (1):
      netfilter: ctnetlink: fix dump of the expect mask attribute

Ludovic Senecaux (1):
      netfilter: conntrack: Fix gre tunneling over ipv6

Mark Tomlinson (3):
      Revert "netfilter: x_tables: Update remaining dereference to RCU"
      Revert "netfilter: x_tables: Switch synchronization to RCU"
      netfilter: x_tables: Use correct memory barriers.

Pablo Neira Ayuso (3):
      netfilter: nftables: report EOPNOTSUPP on unsupported flowtable flags
      netfilter: nftables: allow to update flowtable flags
      netfilter: nftables: skip hook overlap logic if flowtable is stale

Yinjun Zhang (1):
      netfilter: flowtable: Make sure GC works periodically in idle system

 include/linux/netfilter/x_tables.h     |  7 ++---
 include/net/netfilter/nf_tables.h      |  3 +++
 net/ipv4/netfilter/arp_tables.c        | 16 +++++------
 net/ipv4/netfilter/ip_tables.c         | 16 +++++------
 net/ipv6/netfilter/ip6_tables.c        | 16 +++++------
 net/netfilter/nf_conntrack_netlink.c   |  1 +
 net/netfilter/nf_conntrack_proto_gre.c |  3 ---
 net/netfilter/nf_flow_table_core.c     |  2 +-
 net/netfilter/nf_tables_api.c          | 22 ++++++++++++++-
 net/netfilter/x_tables.c               | 49 +++++++++++++++++++++++-----------
 10 files changed, 86 insertions(+), 49 deletions(-)
