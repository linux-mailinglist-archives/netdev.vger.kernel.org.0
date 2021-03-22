Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9295734536B
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 00:57:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230512AbhCVX5E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 19:57:04 -0400
Received: from mail.netfilter.org ([217.70.188.207]:58314 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbhCVX4h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 19:56:37 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id E8635630C3;
        Tue, 23 Mar 2021 00:56:28 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 00/10] Netfilter updates for net-next
Date:   Tue, 23 Mar 2021 00:56:18 +0100
Message-Id: <20210322235628.2204-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following batch contains Netfilter updates for net-next:

1) Split flowtable workqueues per events, from Oz Shlomo.

2) fall-through warnings for clang, from Gustavo A. R. Silva

3) Remove unused declaration in conntrack, from YueHaibing.

4) Consolidate skb_try_make_writable() in flowtable datapath,
   simplify some of the existing codebase.

5) Call dst_check() to fall back to static classic forwarding path.

6) Update table flags from commit phase.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git

Thanks!

----------------------------------------------------------------

The following changes since commit ebfbc46b35cb70b9fbd88f376d7a33b79f60adff:

  openvswitch: Warn over-mtu packets only if iface is UP. (2021-03-16 16:28:30 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git HEAD

for you to fetch changes up to 0ce7cf4127f14078ca598ba9700d813178a59409:

  netfilter: nftables: update table flags from the commit phase (2021-03-18 01:35:39 +0100)

----------------------------------------------------------------
Gustavo A. R. Silva (1):
      netfilter: Fix fall-through warnings for Clang

Oz Shlomo (1):
      netfilter: flowtable: separate replace, destroy and stats to different workqueues

Pablo Neira Ayuso (7):
      netfilter: flowtable: consolidate skb_try_make_writable() call
      netfilter: flowtable: move skb_try_make_writable() before NAT in IPv4
      netfilter: flowtable: move FLOW_OFFLOAD_DIR_MAX away from enumeration
      netfilter: flowtable: fast NAT functions never fail
      netfilter: flowtable: call dst_check() to fall back to classic forwarding
      netfilter: flowtable: refresh timeout after dst and writable checks
      netfilter: nftables: update table flags from the commit phase

YueHaibing (1):
      netfilter: conntrack: Remove unused variable declaration

 include/net/netfilter/ipv6/nf_conntrack_ipv6.h |   3 -
 include/net/netfilter/nf_flow_table.h          |  14 +-
 include/net/netfilter/nf_tables.h              |   9 +-
 net/netfilter/nf_conntrack_proto_dccp.c        |   1 +
 net/netfilter/nf_flow_table_core.c             |  57 ++----
 net/netfilter/nf_flow_table_ip.c               | 231 ++++++++++---------------
 net/netfilter/nf_flow_table_offload.c          |  44 ++++-
 net/netfilter/nf_tables_api.c                  |  32 ++--
 net/netfilter/nft_ct.c                         |   1 +
 9 files changed, 174 insertions(+), 218 deletions(-)
