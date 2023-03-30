Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 525D86D0FFB
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 22:29:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbjC3U3j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 16:29:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbjC3U3i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 16:29:38 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC09910FD;
        Thu, 30 Mar 2023 13:29:37 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1phyto-0000gP-3U; Thu, 30 Mar 2023 22:29:32 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        <netfilter-devel@vger.kernel.org>
Subject: [PATCH net-next 0/4] netfilter updates for net-next
Date:   Thu, 30 Mar 2023 22:29:24 +0200
Message-Id: <20230330202928.28705-1-fw@strlen.de>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

This pull request contains changes for the *net-next* tree.

1. No need to disable BH in nfnetlink proc handler, freeing happens
   via call_rcu.
2. Expose classid in nfetlink_queue, from Eric Sage.
3. Fix nfnetlink message description comments, from Matthieu De Beule.
4. Allow removal of offloaded connections via ctnetlink, from Paul Blakey.

The following changes since commit da617cd8d90608582eb8d0b58026f31f1a9bfb1d:

  smsc911x: remove superfluous variable init (2023-03-30 15:35:33 +0200)

are available in the Git repository at:

  ssh://git@gitolite.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next 

for you to fetch changes up to 9b7c68b3911aef84afa4cbfc31bce20f10570d51:

  netfilter: ctnetlink: Support offloaded conntrack entry deletion (2023-03-30 22:20:09 +0200)

----------------------------------------------------------------
Eric Sage (1):
      netfilter: nfnetlink_queue: enable classid socket info retrieval

Florian Westphal (1):
      netfilter: nfnetlink_log: remove rcu_bh usage

Matthieu De Beule (1):
      netfilter: Correct documentation errors in nf_tables.h

Paul Blakey (1):
      netfilter: ctnetlink: Support offloaded conntrack entry deletion

 include/uapi/linux/netfilter/nf_tables.h       |  8 +++---
 include/uapi/linux/netfilter/nfnetlink_queue.h |  1 +
 net/netfilter/nf_conntrack_netlink.c           |  8 ------
 net/netfilter/nfnetlink_log.c                  | 36 ++++++++++++++++----------
 net/netfilter/nfnetlink_queue.c                | 20 ++++++++++++++
 5 files changed, 48 insertions(+), 25 deletions(-)
