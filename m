Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8017B1A1838
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 00:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726395AbgDGW3o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 18:29:44 -0400
Received: from correo.us.es ([193.147.175.20]:53126 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726380AbgDGW3o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Apr 2020 18:29:44 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C37D3F2DE5
        for <netdev@vger.kernel.org>; Wed,  8 Apr 2020 00:29:41 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B58864EA8F
        for <netdev@vger.kernel.org>; Wed,  8 Apr 2020 00:29:41 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id AA647FA551; Wed,  8 Apr 2020 00:29:41 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BECB7DA736;
        Wed,  8 Apr 2020 00:29:39 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 08 Apr 2020 00:29:39 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 9A2ED4251480;
        Wed,  8 Apr 2020 00:29:39 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 0/7] Netfilter fixes for net
Date:   Wed,  8 Apr 2020 00:29:29 +0200
Message-Id: <20200407222936.206295-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

The following patchset contains Netfilter fixes for net, they are:

1) Fix spurious overlap condition in the rbtree tree, from Stefano Brivio.

2) Fix possible uninitialized pointer dereference in nft_lookup.

3) IDLETIMER v1 target matches the Android layout, from
   Maciej Zenczykowski.

4) Dangling pointer in nf_tables_set_alloc_name, from Eric Dumazet.

5) Fix RCU warning splat in ipset find_set_type(), from Amol Grover.

6) Report EOPNOTSUPP on unsupported set flags and object types in sets.

7) Add NFT_SET_CONCAT flag to provide consistent error reporting
   when users defines set with ranges in concatenations in old kernels.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thank you.

----------------------------------------------------------------

The following changes since commit 0452800f6db4ed0a42ffb15867c0acfd68829f6a:

  net: dsa: mt7530: fix null pointer dereferencing in port5 setup (2020-04-03 16:10:32 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to ef516e8625ddea90b3a0313f3a0b0baa83db7ac2:

  netfilter: nf_tables: reintroduce the NFT_SET_CONCAT flag (2020-04-07 18:23:04 +0200)

----------------------------------------------------------------
Amol Grover (1):
      netfilter: ipset: Pass lockdep expression to RCU lists

Eric Dumazet (1):
      netfilter: nf_tables: do not leave dangling pointer in nf_tables_set_alloc_name

Maciej Żenczykowski (1):
      netfilter: xt_IDLETIMER: target v1 - match Android layout

Pablo Neira Ayuso (3):
      netfilter: nf_tables: do not update stateful expressions if lookup is inverted
      netfilter: nf_tables: report EOPNOTSUPP on unsupported flags/object type
      netfilter: nf_tables: reintroduce the NFT_SET_CONCAT flag

Stefano Brivio (1):
      netfilter: nft_set_rbtree: Drop spurious condition for overlap detection on insertion

 include/net/netfilter/nf_tables.h           |  2 +-
 include/uapi/linux/netfilter/nf_tables.h    |  2 ++
 include/uapi/linux/netfilter/xt_IDLETIMER.h |  1 +
 net/netfilter/ipset/ip_set_core.c           |  3 ++-
 net/netfilter/nf_tables_api.c               |  7 ++++---
 net/netfilter/nft_lookup.c                  | 12 +++++++-----
 net/netfilter/nft_set_bitmap.c              |  1 -
 net/netfilter/nft_set_rbtree.c              | 23 +++++++++++------------
 net/netfilter/xt_IDLETIMER.c                |  3 +++
 9 files changed, 31 insertions(+), 23 deletions(-)
