Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B3364BDF0B
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 18:49:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380075AbiBUQSb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 11:18:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380060AbiBUQS3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 11:18:29 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C152427148;
        Mon, 21 Feb 2022 08:18:05 -0800 (PST)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 5D421642DE;
        Mon, 21 Feb 2022 17:17:08 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH nf 0/5] Netfilter fixes for net
Date:   Mon, 21 Feb 2022 17:17:52 +0100
Message-Id: <20220221161757.250801-1-pablo@netfilter.org>
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

The following patchset contains Netfilter fixes for net:

1) Missing #ifdef CONFIG_IP6_NF_IPTABLES in recent xt_socket fix.

2) Fix incorrect flow action array size in nf_tables.

3) Unregister flowtable hooks from netns exit path.

4) Fix missing limit object release, from Florian Westphal.

5) Memleak in nf_tables object update path, also from Florian.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit 143de8d97d79316590475dc2a84513c63c863ddf:

  tipc: fix a bit overflow in tipc_crypto_key_rcv() (2022-02-13 12:12:25 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git HEAD

for you to fetch changes up to 33170d18fd2c5f660ebdad1a5436a611bd749320:

  netfilter: nf_tables: fix memory leak during stateful obj update (2022-02-21 15:52:14 +0100)

----------------------------------------------------------------
Florian Westphal (2):
      netfilter: nft_limit: fix stateful object memory leak
      netfilter: nf_tables: fix memory leak during stateful obj update

Pablo Neira Ayuso (3):
      netfilter: xt_socket: missing ifdef CONFIG_IP6_NF_IPTABLES dependency
      netfilter: nf_tables_offload: incorrect flow offload action array size
      netfilter: nf_tables: unregister flowtable hooks on netns exit

 include/net/netfilter/nf_tables.h         |  2 +-
 include/net/netfilter/nf_tables_offload.h |  2 --
 net/netfilter/nf_tables_api.c             | 14 +++++++++++---
 net/netfilter/nf_tables_offload.c         |  3 ++-
 net/netfilter/nft_dup_netdev.c            |  6 ++++++
 net/netfilter/nft_fwd_netdev.c            |  6 ++++++
 net/netfilter/nft_immediate.c             | 12 +++++++++++-
 net/netfilter/nft_limit.c                 | 18 ++++++++++++++++++
 net/netfilter/xt_socket.c                 |  2 ++
 9 files changed, 57 insertions(+), 8 deletions(-)
