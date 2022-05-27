Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAD30535D17
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 11:22:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243031AbiE0JUc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 05:20:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239205AbiE0JUa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 05:20:30 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3508076289;
        Fri, 27 May 2022 02:20:29 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com
Subject: [PATCH net 0/4] Netfilter fixes for net
Date:   Fri, 27 May 2022 11:20:19 +0200
Message-Id: <20220527092023.327441-1-pablo@netfilter.org>
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

The following contain more Netfilter fixes for net:

1) syzbot warning in nfnetlink bind, from Florian.

2) Refetch conntrack after __nf_conntrack_confirm(), from Florian Westphal.

3) Move struct nf_ct_timeout back at the bottom of the ctnl_time, to
   where it before recent update, also from Florian.

4) Add NL_SET_BAD_ATTR() to nf_tables netlink for proper set element
   commands error reporting.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit 02ded5a173619b11728b8bf75a3fd995a2c1ff28:

  net: dsa: mv88e6xxx: Fix refcount leak in mv88e6xxx_mdios_register (2022-05-27 08:02:33 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git HEAD

for you to fetch changes up to b53c116642502b0c85ecef78bff4f826a7dd4145:

  netfilter: nf_tables: set element extended ACK reporting support (2022-05-27 11:16:38 +0200)

----------------------------------------------------------------
Florian Westphal (3):
      netfilter: nfnetlink: fix warn in nfnetlink_unbind
      netfilter: conntrack: re-fetch conntrack after insertion
      netfilter: cttimeout: fix slab-out-of-bounds read in cttimeout_net_exit

Pablo Neira Ayuso (1):
      netfilter: nf_tables: set element extended ACK reporting support

 include/net/netfilter/nf_conntrack_core.h |  7 ++++++-
 net/netfilter/nf_tables_api.c             | 12 +++++++++---
 net/netfilter/nfnetlink.c                 | 24 +++++-------------------
 net/netfilter/nfnetlink_cttimeout.c       |  5 +++--
 4 files changed, 23 insertions(+), 25 deletions(-)
