Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EF3F31017C
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 01:19:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231806AbhBEASY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 19:18:24 -0500
Received: from correo.us.es ([193.147.175.20]:40570 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231757AbhBEASR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 19:18:17 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 82CE32A3248
        for <netdev@vger.kernel.org>; Fri,  5 Feb 2021 01:17:32 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6EB2CDA78D
        for <netdev@vger.kernel.org>; Fri,  5 Feb 2021 01:17:32 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 63BA7DA78A; Fri,  5 Feb 2021 01:17:32 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 205A8DA72F;
        Fri,  5 Feb 2021 01:17:30 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 05 Feb 2021 01:17:30 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id E4E5742EF9E1;
        Fri,  5 Feb 2021 01:17:29 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 0/4] Netfilter fixes for net
Date:   Fri,  5 Feb 2021 01:17:23 +0100
Message-Id: <20210205001727.2125-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset contains Netfilter fixes for net:

1) Fix combination of --reap and --update in xt_recent that triggers
   UAF, from Jozsef Kadlecsik.

2) Fix current year in nft_meta selftest, from Fabian Frederick.

3) Fix possible UAF in the netns destroy path of nftables.

4) Fix incorrect checksum calculation when mangling ports in flowtable,
   from Sven Auhagen.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thanks!

----------------------------------------------------------------

The following changes since commit 44a674d6f79867d5652026f1cc11f7ba8a390183:

  Merge tag 'mlx5-fixes-2021-01-26' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux (2021-01-27 19:18:37 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to 8d6bca156e47d68551750a384b3ff49384c67be3:

  netfilter: flowtable: fix tcp and udp header checksum update (2021-02-04 01:10:14 +0100)

----------------------------------------------------------------
Fabian Frederick (1):
      selftests: netfilter: fix current year

Jozsef Kadlecsik (1):
      netfilter: xt_recent: Fix attempt to update deleted entry

Pablo Neira Ayuso (1):
      netfilter: nftables: fix possible UAF over chains from packet path in netns

Sven Auhagen (1):
      netfilter: flowtable: fix tcp and udp header checksum update

 net/netfilter/nf_flow_table_core.c            |  4 ++--
 net/netfilter/nf_tables_api.c                 | 25 +++++++++++++++++++------
 net/netfilter/xt_recent.c                     | 12 ++++++++++--
 tools/testing/selftests/netfilter/nft_meta.sh |  2 +-
 4 files changed, 32 insertions(+), 11 deletions(-)
