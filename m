Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4826A456598
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 23:26:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231907AbhKRW3b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 17:29:31 -0500
Received: from mail.netfilter.org ([217.70.188.207]:58256 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230378AbhKRW3b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 17:29:31 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 034C764972;
        Thu, 18 Nov 2021 23:24:21 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 00/11] Netfilter fixes for net
Date:   Thu, 18 Nov 2021 23:26:07 +0100
Message-Id: <20211118222618.433273-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset contains Netfilter/IPVS fixes for net:

1) Add selftest for vrf+conntrack, from Florian Westphal.

2) Extend nfqueue selftest to cover nfqueue, also from Florian.

3) Remove duplicated include in nft_payload, from Wan Jiabing.

4) Several improvements to the nat port shadowing selftest,
   from Phil Sutter.

5) Fix filtering of reply tuple in ctnetlink, from Florent Fourcot.

6) Do not override error with -EINVAL in filter setup path, also
   from Florent.

7) Honor sysctl_expire_nodest_conn regardless conn_reuse_mode for
   reused connections, from yangxingwu.

8) Replace snprintf() by sysfs_emit() in xt_IDLETIMER as reported
   by Coccinelle, from Jing Yao.

9) Incorrect IPv6 tunnel match in flowtable offload, from Will
   Mortensen.

10) Switch port shadow selftest to use socat, from Florian Westphal.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit c45231a7668d6b632534f692b10592ea375b55b0:

  litex_liteeth: Fix a double free in the remove function (2021-11-07 21:51:17 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to a2acf0c0e2da29950d0361a3b5ea05e8d0351dfe:

  selftests: nft_nat: switch port shadow test cases to socat (2021-11-15 12:02:11 +0100)

----------------------------------------------------------------
Florent Fourcot (2):
      netfilter: ctnetlink: fix filtering with CTA_TUPLE_REPLY
      netfilter: ctnetlink: do not erase error code with EINVAL

Florian Westphal (3):
      selftests: netfilter: add a vrf+conntrack testcase
      selftests: netfilter: extend nfqueue tests to cover vrf device
      selftests: nft_nat: switch port shadow test cases to socat

Jing Yao (1):
      netfilter: xt_IDLETIMER: replace snprintf in show functions with sysfs_emit

Phil Sutter (2):
      selftests: nft_nat: Improve port shadow test stability
      selftests: nft_nat: Simplify port shadow notrack test

Wan Jiabing (1):
      netfilter: nft_payload: Remove duplicated include in nft_payload.c

Will Mortensen (1):
      netfilter: flowtable: fix IPv6 tunnel addr match

yangxingwu (1):
      netfilter: ipvs: Fix reuse connection if RS weight is 0

 Documentation/networking/ipvs-sysctl.rst           |   3 +-
 net/netfilter/ipvs/ip_vs_core.c                    |   8 +-
 net/netfilter/nf_conntrack_netlink.c               |   6 +-
 net/netfilter/nf_flow_table_offload.c              |   4 +-
 net/netfilter/nft_payload.c                        |   1 -
 net/netfilter/xt_IDLETIMER.c                       |   4 +-
 tools/testing/selftests/netfilter/Makefile         |   3 +-
 tools/testing/selftests/netfilter/conntrack_vrf.sh | 219 +++++++++++++++++++++
 tools/testing/selftests/netfilter/nft_nat.sh       |  33 +++-
 tools/testing/selftests/netfilter/nft_queue.sh     |  54 +++++
 10 files changed, 309 insertions(+), 26 deletions(-)
 create mode 100755 tools/testing/selftests/netfilter/conntrack_vrf.sh
