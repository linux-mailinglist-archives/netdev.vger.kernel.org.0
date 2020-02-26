Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE8DE170BEB
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 23:54:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727181AbgBZWyw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 17:54:52 -0500
Received: from correo.us.es ([193.147.175.20]:36380 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727329AbgBZWyw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Feb 2020 17:54:52 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9144C1C4387
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 23:54:39 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 83089DA3A0
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 23:54:39 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 78C2BDA390; Wed, 26 Feb 2020 23:54:39 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8607CDA72F;
        Wed, 26 Feb 2020 23:54:37 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 26 Feb 2020 23:54:37 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 60D8842EF4E0;
        Wed, 26 Feb 2020 23:54:37 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 0/6] Netfilter fixes for net
Date:   Wed, 26 Feb 2020 23:54:36 +0100
Message-Id: <20200226225442.9598-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset contains Netfilter fixes:

1) Perform garbage collection from workqueue to fix rcu detected
   stall in ipset hash set types, from Jozsef Kadlecsik.

2) Fix the forceadd evaluation path, also from Jozsef.

3) Fix nft_set_pipapo selftest, from Stefano Brivio.

4) Crash when add-flush-add element in pipapo set, also from Stefano.
   Add test to cover this crash.

5) Remove sysctl entry under mutex in hashlimit, from Cong Wang.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thank you.

----------------------------------------------------------------

The following changes since commit 3614d05b5e6baf487e88fb114d884da172edd61a:

  Merge tag 'mac80211-for-net-2020-02-24' of git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211 (2020-02-24 15:43:38 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to 99b79c3900d4627672c85d9f344b5b0f06bc2a4d:

  netfilter: xt_hashlimit: unregister proc file before releasing mutex (2020-02-26 23:25:07 +0100)

----------------------------------------------------------------
Cong Wang (1):
      netfilter: xt_hashlimit: unregister proc file before releasing mutex

Jozsef Kadlecsik (2):
      netfilter: ipset: Fix "INFO: rcu detected stall in hash_xxx" reports
      netfilter: ipset: Fix forceadd evaluation path

Pablo Neira Ayuso (1):
      Merge branch 'master' of git://blackhole.kfki.hu/nf

Stefano Brivio (3):
      selftests: nft_concat_range: Move option for 'list ruleset' before command
      nft_set_pipapo: Actually fetch key data in nft_pipapo_remove()
      selftests: nft_concat_range: Add test for reported add/flush/add issue

 include/linux/netfilter/ipset/ip_set.h             |  11 +-
 net/netfilter/ipset/ip_set_core.c                  |  34 +-
 net/netfilter/ipset/ip_set_hash_gen.h              | 635 ++++++++++++++-------
 net/netfilter/nft_set_pipapo.c                     |   6 +-
 net/netfilter/xt_hashlimit.c                       |  16 +-
 .../selftests/netfilter/nft_concat_range.sh        |  55 +-
 6 files changed, 529 insertions(+), 228 deletions(-)
