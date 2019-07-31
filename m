Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88AA87C079
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 13:52:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727978AbfGaLwG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 07:52:06 -0400
Received: from correo.us.es ([193.147.175.20]:59282 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727209AbfGaLwG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Jul 2019 07:52:06 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0288B80767
        for <netdev@vger.kernel.org>; Wed, 31 Jul 2019 13:52:04 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E7461203F3
        for <netdev@vger.kernel.org>; Wed, 31 Jul 2019 13:52:03 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id DD055A6DA; Wed, 31 Jul 2019 13:52:03 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A7325DA708;
        Wed, 31 Jul 2019 13:52:01 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 31 Jul 2019 13:52:01 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [47.60.32.83])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 25FA84265A31;
        Wed, 31 Jul 2019 13:52:01 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 0/8] netfilter fixes for net
Date:   Wed, 31 Jul 2019 13:51:49 +0200
Message-Id: <20190731115157.27020-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset contains Netfilter fixes for your net tree:

1) memleak in ebtables from the error path for the 32/64 compat layer,
   from Florian Westphal.

2) Fix inverted meta ifname/ifidx matching when no interface is set
   on either from the input/output path, from Phil Sutter.

3) Remove goto label in nft_meta_bridge, also from Phil.

4) Missing include guard in xt_connlabel, from Masahiro Yamada.

5) Two patch to fix ipset destination MAC matching coming from
   Stephano Brivio, via Jozsef Kadlecsik.

6) Fix set rename and listing concurrency problem, from Shijie Luo.
   Patch also coming via Jozsef Kadlecsik.

7) ebtables 32/64 compat missing base chain policy in rule count,
   from Florian Westphal.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thanks!

----------------------------------------------------------------

The following changes since commit 0cea0e1148fe134a4a3aaf0b1496f09241fb943a:

  net: phy: sfp: hwmon: Fix scaling of RX power (2019-07-21 11:51:50 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to 7cdc4412284777c76c919e2ab33b3b8dbed18559:

  Merge branch 'master' of git://blackhole.kfki.hu/nf (2019-07-30 13:39:20 +0200)

----------------------------------------------------------------
Florian Westphal (1):
      netfilter: ebtables: also count base chain policies

Jozsef Kadlecsik (1):
      netfilter: ipset: Fix rename concurrency with listing

Masahiro Yamada (1):
      netfilter: add include guard to xt_connlabel.h

Pablo Neira Ayuso (1):
      Merge branch 'master' of git://blackhole.kfki.hu/nf

Phil Sutter (2):
      netfilter: nf_tables: Make nft_meta expression more robust
      netfilter: nft_meta_bridge: Eliminate 'out' label

Stefano Brivio (2):
      netfilter: ipset: Actually allow destination MAC address for hash:ip,mac sets too
      netfilter: ipset: Copy the right MAC address in bitmap:ip,mac and hash:ip,mac sets

Wenwen Wang (1):
      netfilter: ebtables: fix a memory leak bug in compat

 include/uapi/linux/netfilter/xt_connlabel.h |  6 ++++++
 net/bridge/netfilter/ebtables.c             | 32 ++++++++++++++++++-----------
 net/bridge/netfilter/nft_meta_bridge.c      | 10 ++-------
 net/netfilter/ipset/ip_set_bitmap_ipmac.c   |  2 +-
 net/netfilter/ipset/ip_set_core.c           |  2 +-
 net/netfilter/ipset/ip_set_hash_ipmac.c     |  6 +-----
 net/netfilter/nft_meta.c                    | 16 ++++-----------
 7 files changed, 35 insertions(+), 39 deletions(-)
