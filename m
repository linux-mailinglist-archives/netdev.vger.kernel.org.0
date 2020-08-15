Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D28BE245440
	for <lists+netdev@lfdr.de>; Sun, 16 Aug 2020 00:18:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728091AbgHOWS5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Aug 2020 18:18:57 -0400
Received: from correo.us.es ([193.147.175.20]:38936 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728864AbgHOWSx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 15 Aug 2020 18:18:53 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3C7FBDA886
        for <netdev@vger.kernel.org>; Sat, 15 Aug 2020 12:32:14 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2BF09DA704
        for <netdev@vger.kernel.org>; Sat, 15 Aug 2020 12:32:14 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 21822DA840; Sat, 15 Aug 2020 12:32:14 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WELCOMELIST,USER_IN_WHITELIST autolearn=disabled
        version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DF921DA704;
        Sat, 15 Aug 2020 12:32:11 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 15 Aug 2020 12:32:11 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [213.143.48.187])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id F0A6942EF4E0;
        Sat, 15 Aug 2020 12:32:10 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 0/8] Netfilter fixes for net
Date:   Sat, 15 Aug 2020 12:31:53 +0200
Message-Id: <20200815103201.1768-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset contains Netfilter fixes for net:

1) Endianness issue in IPv4 option support in nft_exthdr,
   from Stephen Suryaputra.

2) Removes the waitcount optimization in nft_compat,
   from Florian Westphal.

3) Remove ipv6 -> nf_defrag_ipv6 module dependency, from
   Florian Westphal.

4) Memleak in chain binding support, also from Florian.

5) Simplify nft_flowtable.sh selftest, from Fabian Frederick.

6) Optional MTU arguments for selftest nft_flowtable.sh,
   also from Fabian.

7) Remove noise error report when killing process in
   selftest nft_flowtable.sh, from Fabian Frederick.

8) Reject bogus getsockopt option length in ebtables,
   from Florian Westphal.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thank you.

----------------------------------------------------------------

The following changes since commit 7c7ab580db49cc7befe5f4b91bb1920cd6b07575:

  net: Convert to use the fallthrough macro (2020-08-08 14:29:09 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to 5c04da55c754c44937b3d19c6522f9023fd5c5d5:

  netfilter: ebtables: reject bogus getopt len value (2020-08-14 11:59:08 +0200)

----------------------------------------------------------------
Fabian Frederick (3):
      selftests: netfilter: add checktool function
      selftests: netfilter: add MTU arguments to flowtables
      selftests: netfilter: kill running process only

Florian Westphal (4):
      netfilter: nft_compat: remove flush counter optimization
      netfilter: avoid ipv6 -> nf_defrag_ipv6 module dependency
      netfilter: nf_tables: free chain context when BINDING flag is missing
      netfilter: ebtables: reject bogus getopt len value

Stephen Suryaputra (1):
      netfilter: nf_tables: nft_exthdr: the presence return value should be little-endian

 include/linux/netfilter_ipv6.h                     | 18 ------
 net/bridge/netfilter/ebtables.c                    |  4 ++
 net/bridge/netfilter/nf_conntrack_bridge.c         |  8 ++-
 net/ipv6/netfilter.c                               |  3 -
 net/netfilter/nf_tables_api.c                      |  6 +-
 net/netfilter/nft_compat.c                         | 37 +++++------
 net/netfilter/nft_exthdr.c                         |  4 +-
 tools/testing/selftests/netfilter/nft_flowtable.sh | 73 +++++++++++++---------
 8 files changed, 73 insertions(+), 80 deletions(-)
