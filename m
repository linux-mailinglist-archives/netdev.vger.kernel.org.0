Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7331C3D3CE3
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 17:54:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235712AbhGWPN5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 11:13:57 -0400
Received: from mail.netfilter.org ([217.70.188.207]:57282 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235578AbhGWPNq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 11:13:46 -0400
Received: from localhost.localdomain (unknown [78.30.39.111])
        by mail.netfilter.org (Postfix) with ESMTPSA id 1B3A46244C;
        Fri, 23 Jul 2021 17:53:53 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 0/6] Netfilter fixes for net
Date:   Fri, 23 Jul 2021 17:54:06 +0200
Message-Id: <20210723155412.17916-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset contains Netfilter fixes for net:

1) Memleak in commit audit error path, from Dongliang Mu.

2) Avoid possible false sharing for flowtable timeout updates
   and nft_last use.

3) Adjust conntrack timestamp due to garbage collection delay,
   from Florian Westphal.

4) Fix nft_nat without layer 3 address for the inet family.

5) Fix compilation warning in nfnl_hook when ingress support
   is disabled, from Arnd Bergmann.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit 5f119ba1d5771bbf46d57cff7417dcd84d3084ba:

  net: decnet: Fix sleeping inside in af_decnet (2021-07-16 14:06:16 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to 217e26bd87b2930856726b48a4e71c768b8c9bf5:

  netfilter: nfnl_hook: fix unused variable warning (2021-07-23 14:45:03 +0200)

----------------------------------------------------------------
Arnd Bergmann (1):
      netfilter: nfnl_hook: fix unused variable warning

Dongliang Mu (1):
      netfilter: nf_tables: fix audit memory leak in nf_tables_commit

Florian Westphal (1):
      netfilter: conntrack: adjust stop timestamp to real expiry value

Pablo Neira Ayuso (3):
      netfilter: flowtable: avoid possible false sharing
      netfilter: nft_last: avoid possible false sharing
      netfilter: nft_nat: allow to specify layer 4 protocol NAT only

 net/netfilter/nf_conntrack_core.c  |  7 ++++++-
 net/netfilter/nf_flow_table_core.c |  6 +++++-
 net/netfilter/nf_tables_api.c      | 12 ++++++++++++
 net/netfilter/nfnetlink_hook.c     |  2 ++
 net/netfilter/nft_last.c           | 20 +++++++++++++-------
 net/netfilter/nft_nat.c            |  4 +++-
 6 files changed, 41 insertions(+), 10 deletions(-)
