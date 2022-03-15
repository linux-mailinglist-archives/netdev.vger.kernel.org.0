Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5135F4D975A
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 10:15:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346427AbiCOJQf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 05:16:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346117AbiCOJQd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 05:16:33 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 405564BBAF;
        Tue, 15 Mar 2022 02:15:21 -0700 (PDT)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 431D862FFF;
        Tue, 15 Mar 2022 10:12:58 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH nf-next 0/6] Netfilter updates for net-next
Date:   Tue, 15 Mar 2022 10:15:07 +0100
Message-Id: <20220315091513.66544-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset contains Netfilter updates for net-next:

1) Revert CHECKSUM_UNNECESSARY for UDP packet from conntrack.

2) Reject unsupported families when creating tables, from Phil Sutter.

3) GRE support for the flowtable, from Toshiaki Makita.

4) Add GRE offload support for act_ct, also from Toshiaki.

5) Update mlx5 driver to support for GRE flowtable offload,
   from Toshiaki Makita.

6) Oneliner to clean up incorrect indentation in nf_conntrack_bridge,
   from Jiapeng Chong.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git

Special request of mine: Would it be possible to merge net into net-next?

Many thanks

----------------------------------------------------------------

The following changes since commit ef132dc40a28e07ba10b707b505781ffca46b97f:

  Merge branch 'nfc-llcp-cleanups' (2022-03-03 10:43:37 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git HEAD

for you to fetch changes up to 334ff12284fc56bdc5af6d310c6381d96906f5a0:

  netfilter: bridge: clean up some inconsistent indenting (2022-03-07 12:42:37 +0100)

----------------------------------------------------------------
Florian Westphal (1):
      Revert "netfilter: conntrack: mark UDP zero checksum as CHECKSUM_UNNECESSARY"

Jiapeng Chong (1):
      netfilter: bridge: clean up some inconsistent indenting

Phil Sutter (1):
      netfilter: nf_tables: Reject tables of unsupported family

Toshiaki Makita (3):
      netfilter: flowtable: Support GRE
      act_ct: Support GRE offload
      net/mlx5: Support GRE conntrack offload

 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |  21 ++--
 net/bridge/netfilter/nf_conntrack_bridge.c         |   2 +-
 net/netfilter/nf_conntrack_proto_udp.c             |   4 +-
 net/netfilter/nf_flow_table_core.c                 |  10 +-
 net/netfilter/nf_flow_table_ip.c                   |  62 +++++++++--
 net/netfilter/nf_flow_table_offload.c              |  22 ++--
 net/netfilter/nf_tables_api.c                      |  27 +++++
 net/netfilter/nft_flow_offload.c                   |  13 +++
 net/sched/act_ct.c                                 | 115 ++++++++++++++++-----
 9 files changed, 223 insertions(+), 53 deletions(-)
