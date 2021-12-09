Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC52246DF34
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 01:08:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241307AbhLIAM0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 19:12:26 -0500
Received: from mail.netfilter.org ([217.70.188.207]:41714 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238311AbhLIAM0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 19:12:26 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 220AA605BA;
        Thu,  9 Dec 2021 01:06:30 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 0/7] Netfilter fixes for net
Date:   Thu,  9 Dec 2021 01:08:40 +0100
Message-Id: <20211209000847.102598-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset contains Netfilter fixes for net:

1) Fix bogus compilter warning in nfnetlink_queue, from Florian Westphal.

2) Don't run conntrack on vrf with !dflt qdisc, from Nicolas Dichtel.

3) Fix nft_pipapo bucket load in AVX2 lookup routine for six 8-bit
   groups, from Stefano Brivio.

4) Break rule evaluation on malformed TCP options.

5) Use socat instead of nc in selftests/netfilter/nft_zones_many.sh,
   also from Florian

6) Fix KCSAN data-race in conntrack timeout updates, from Eric Dumazet.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit 34d8778a943761121f391b7921f79a7adbe1feaf:

  MAINTAINERS: s390/net: add Alexandra and Wenjia as maintainer (2021-11-30 12:20:07 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to 802a7dc5cf1bef06f7b290ce76d478138408d6b1:

  netfilter: conntrack: annotate data-races around ct->timeout (2021-12-08 01:29:15 +0100)

----------------------------------------------------------------
Eric Dumazet (1):
      netfilter: conntrack: annotate data-races around ct->timeout

Florian Westphal (2):
      netfilter: nfnetlink_queue: silence bogus compiler warning
      selftests: netfilter: switch zone stress to socat

Nicolas Dichtel (1):
      vrf: don't run conntrack on vrf with !dflt qdisc

Pablo Neira Ayuso (1):
      netfilter: nft_exthdr: break evaluation if setting TCP option fails

Stefano Brivio (2):
      nft_set_pipapo: Fix bucket load in AVX2 lookup routine for six 8-bit groups
      selftests: netfilter: Add correctness test for mac,net set type

 drivers/net/vrf.c                                  |  8 +++---
 include/net/netfilter/nf_conntrack.h               |  6 ++---
 net/netfilter/nf_conntrack_core.c                  |  6 ++---
 net/netfilter/nf_conntrack_netlink.c               |  2 +-
 net/netfilter/nf_flow_table_core.c                 |  4 +--
 net/netfilter/nfnetlink_queue.c                    |  2 +-
 net/netfilter/nft_exthdr.c                         | 11 +++++---
 net/netfilter/nft_set_pipapo_avx2.c                |  2 +-
 tools/testing/selftests/netfilter/conntrack_vrf.sh | 30 +++++++++++++++++++---
 .../selftests/netfilter/nft_concat_range.sh        | 24 ++++++++++++++---
 .../testing/selftests/netfilter/nft_zones_many.sh  | 19 +++++++++-----
 11 files changed, 82 insertions(+), 32 deletions(-)
