Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFE75A925D
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:41:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730584AbfIDTgy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 15:36:54 -0400
Received: from correo.us.es ([193.147.175.20]:37882 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730686AbfIDTgx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Sep 2019 15:36:53 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3161F303D00
        for <netdev@vger.kernel.org>; Wed,  4 Sep 2019 21:36:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 254702DC7B
        for <netdev@vger.kernel.org>; Wed,  4 Sep 2019 21:36:50 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 1B008D1929; Wed,  4 Sep 2019 21:36:50 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 151AAD2B1D;
        Wed,  4 Sep 2019 21:36:48 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 04 Sep 2019 21:36:48 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id E04764265A5A;
        Wed,  4 Sep 2019 21:36:47 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 0/5] Netfilter fixes for net
Date:   Wed,  4 Sep 2019 21:36:41 +0200
Message-Id: <20190904193646.23830-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset contains Netfilter fixes for net:

1) br_netfilter drops IPv6 packets if ipv6 is disabled, from Leonardo Bras.

2) nft_socket hits BUG() due to illegal skb->sk caching, patch from
   Fernando Fernandez Mancera.

3) nft_fib_netdev could be called with ipv6 disabled, leading to crash
   in the fib lookup, also from Leonardo.

4) ctnetlink honors IPS_OFFLOAD flag, just like nf_conntrack sysctl does.

5) Properly set up flowtable entry timeout, otherwise immediate
   removal by garbage collector might occur.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit e33b4325e60e146c2317a8b548cbd633239ff83b:

  net: stmmac: dwmac-sun8i: Variable "val" in function sun8i_dwmac_set_syscon() could be uninitialized (2019-09-02 11:48:15 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to 110e48725db6262f260f10727d0fb2d3d25895e4:

  netfilter: nf_flow_table: set default timeout after successful insertion (2019-09-03 22:55:42 +0200)

----------------------------------------------------------------
Fernando Fernandez Mancera (1):
      netfilter: nft_socket: fix erroneous socket assignment

Leonardo Bras (2):
      netfilter: bridge: Drops IPv6 packets if IPv6 module is not loaded
      netfilter: nft_fib_netdev: Terminate rule eval if protocol=IPv6 and ipv6 module is disabled

Pablo Neira Ayuso (2):
      netfilter: ctnetlink: honor IPS_OFFLOAD flag
      netfilter: nf_flow_table: set default timeout after successful insertion

 net/bridge/br_netfilter_hooks.c      | 4 ++++
 net/netfilter/nf_conntrack_netlink.c | 7 +++++--
 net/netfilter/nf_flow_table_core.c   | 2 +-
 net/netfilter/nft_fib_netdev.c       | 3 +++
 net/netfilter/nft_socket.c           | 6 +++---
 5 files changed, 16 insertions(+), 6 deletions(-)
