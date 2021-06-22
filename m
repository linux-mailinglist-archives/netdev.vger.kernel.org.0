Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C2643B0FBB
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 00:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbhFVWCz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 18:02:55 -0400
Received: from mail.netfilter.org ([217.70.188.207]:59230 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbhFVWCy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 18:02:54 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id B55A764252;
        Tue, 22 Jun 2021 23:59:12 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 0/8] Netfilter fixes for net
Date:   Tue, 22 Jun 2021 23:59:53 +0200
Message-Id: <20210622220001.198508-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset contains Netfilter fixes for net:

1) Nicolas Dichtel updates MAINTAINERS file to add Netfilter IRC channel.

2) Skip non-IPv6 packets in nft_exthdr.

3) Skip non-TCP packets in nft_osf.

4) Skip non-TCP/UDP packets in nft_tproxy.

5) Memleak in hardware offload infrastructure when counters are used
   for first time in a rule.

6) The VLAN transfer routine must use FLOW_DISSECTOR_KEY_BASIC instead
   of FLOW_DISSECTOR_KEY_CONTROL. Moreover, make a more robust check
   for 802.1q and 802.1ad to restore simple matching on transport
   protocols.

7) Fix bogus EPERM when listing a ruleset when table ownership flag
   is set on.

8) Honor table ownership flag when table is referenced by handle.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thank you!

----------------------------------------------------------------

The following changes since commit a4f0377db1254373513b992ff31a351a7111f0fd:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf (2021-06-15 15:26:07 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to e31f072ffab0397a328b31a9589dcf9733dc9c72:

  netfilter: nf_tables: do not allow to delete table with owner by handle (2021-06-22 12:15:05 +0200)

----------------------------------------------------------------
Nicolas Dichtel (1):
      MAINTAINERS: netfilter: add irc channel

Pablo Neira Ayuso (7):
      netfilter: nft_exthdr: check for IPv6 packet before further processing
      netfilter: nft_osf: check for TCP packet before further processing
      netfilter: nft_tproxy: restrict support to TCP and UDP transport protocols
      netfilter: nf_tables: memleak in hw offload abort path
      netfilter: nf_tables_offload: check FLOW_DISSECTOR_KEY_BASIC in VLAN transfer logic
      netfilter: nf_tables: skip netlink portID validation if zero
      netfilter: nf_tables: do not allow to delete table with owner by handle

 MAINTAINERS                       |  1 +
 net/netfilter/nf_tables_api.c     | 65 ++++++++++++++++++++++++---------------
 net/netfilter/nf_tables_offload.c | 34 +++++---------------
 net/netfilter/nft_exthdr.c        |  3 ++
 net/netfilter/nft_osf.c           |  5 +++
 net/netfilter/nft_tproxy.c        |  9 +++++-
 6 files changed, 65 insertions(+), 52 deletions(-)
