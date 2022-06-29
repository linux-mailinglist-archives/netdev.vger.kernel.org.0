Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6042560714
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 19:14:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbiF2RN7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 13:13:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbiF2RN6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 13:13:58 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 204C33B3DC;
        Wed, 29 Jun 2022 10:13:58 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 0/3] Netfilter fixes for net
Date:   Wed, 29 Jun 2022 19:13:51 +0200
Message-Id: <20220629171354.208773-1-pablo@netfilter.org>
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

1) Restore set counter when one of the CPU loses race to add elements
   to sets.

2) After NF_STOLEN, skb might be there no more, update nftables trace
   infra to avoid access to skb in this case. From Florian Westphal.

3) nftables bridge might register a prerouting hook with zero priority,
   br_netfilter incorrectly skips it. Also from Florian.

Florian Westphal (2):
  netfilter: nf_tables: avoid skb access on nf_stolen
  netfilter: br_netfilter: do not skip all hooks with 0 priority

Pablo Neira Ayuso (1):
  netfilter: nft_dynset: restore set element counter when failing to update

 include/net/netfilter/nf_tables.h | 16 ++++++-----
 net/bridge/br_netfilter_hooks.c   | 21 ++++++++++++---
 net/netfilter/nf_tables_core.c    | 24 ++++++++++++++---
 net/netfilter/nf_tables_trace.c   | 44 +++++++++++++++++--------------
 net/netfilter/nft_set_hash.c      |  2 ++
 5 files changed, 75 insertions(+), 32 deletions(-)

-- 
2.30.2

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit cb8092d70a6f5f01ec1490fce4d35efed3ed996c:

  tipc: move bc link creation back to tipc_node_create (2022-06-27 11:51:56 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git HEAD

for you to fetch changes up to c2577862eeb0be94f151f2f1fff662b028061b00:

  netfilter: br_netfilter: do not skip all hooks with 0 priority (2022-06-27 19:23:27 +0200)

----------------------------------------------------------------
Florian Westphal (2):
      netfilter: nf_tables: avoid skb access on nf_stolen
      netfilter: br_netfilter: do not skip all hooks with 0 priority

Pablo Neira Ayuso (1):
      netfilter: nft_dynset: restore set element counter when failing to update

 include/net/netfilter/nf_tables.h | 16 ++++++++------
 net/bridge/br_netfilter_hooks.c   | 21 ++++++++++++++++---
 net/netfilter/nf_tables_core.c    | 24 ++++++++++++++++++---
 net/netfilter/nf_tables_trace.c   | 44 +++++++++++++++++++++------------------
 net/netfilter/nft_set_hash.c      |  2 ++
 5 files changed, 75 insertions(+), 32 deletions(-)
