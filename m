Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C38649EF03
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 00:52:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343847AbiA0Xwm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 18:52:42 -0500
Received: from mail.netfilter.org ([217.70.188.207]:42990 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239508AbiA0Xwl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 18:52:41 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 3CC3B60676;
        Fri, 28 Jan 2022 00:49:35 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 0/8] Netfilter fixes for net
Date:   Fri, 28 Jan 2022 00:52:27 +0100
Message-Id: <20220127235235.656931-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset contains Netfilter fixes for net:

1) Remove leftovers from flowtable modules, from Geert Uytterhoeven.

2) Missing refcount increment of conntrack template in nft_ct,
   from Florian Westphal.

3) Reduce nft_zone selftest time, also from Florian.

4) Add selftest to cover stateless NAT on fragments, from Florian Westphal.

5) Do not set net_device when for reject packets from the bridge path,
   from Phil Sutter.

6) Cancel register tracking info on nft_byteorder operations.

7) Extend nft_concat_range selftest to cover set reload with no elements,
   from Florian Westphal.

8) Remove useless update of pointer in chain blob builder, reported
   by kbuild test robot.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit 2f61353cd2f789a4229b6f5c1c24a40a613357bb:

  net: hns3: handle empty unknown interrupt for VF (2022-01-25 13:08:05 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to b07f413732549e5a96e891411fbb5980f2d8e5a1:

  netfilter: nf_tables: remove assignment with no effect in chain blob builder (2022-01-27 17:50:56 +0100)

----------------------------------------------------------------
Florian Westphal (4):
      netfilter: nft_ct: fix use after free when attaching zone template
      selftests: netfilter: reduce zone stress test running time
      selftests: netfilter: check stateless nat udp checksum fixup
      selftests: nft_concat_range: add test for reload with no element add/del

Geert Uytterhoeven (1):
      netfilter: Remove flowtable relics

Pablo Neira Ayuso (2):
      netfilter: nft_byteorder: track register operations
      netfilter: nf_tables: remove assignment with no effect in chain blob builder

Phil Sutter (1):
      netfilter: nft_reject_bridge: Fix for missing reply from prerouting

 net/bridge/netfilter/nft_reject_bridge.c           |   8 +-
 net/ipv4/netfilter/Kconfig                         |   4 -
 net/ipv6/netfilter/Kconfig                         |   4 -
 net/ipv6/netfilter/Makefile                        |   3 -
 net/ipv6/netfilter/nf_flow_table_ipv6.c            |   0
 net/netfilter/nf_tables_api.c                      |   1 -
 net/netfilter/nft_byteorder.c                      |  12 ++
 net/netfilter/nft_ct.c                             |   5 +-
 .../selftests/netfilter/nft_concat_range.sh        |  72 +++++++++-
 tools/testing/selftests/netfilter/nft_nat.sh       | 152 +++++++++++++++++++++
 .../testing/selftests/netfilter/nft_zones_many.sh  |  12 +-
 11 files changed, 249 insertions(+), 24 deletions(-)
 delete mode 100644 net/ipv6/netfilter/nf_flow_table_ipv6.c
