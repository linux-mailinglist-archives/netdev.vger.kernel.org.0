Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C91CB17C520
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 19:15:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbgCFSPU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 13:15:20 -0500
Received: from correo.us.es ([193.147.175.20]:40724 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726307AbgCFSPT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Mar 2020 13:15:19 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4AB4E15AEA3
        for <netdev@vger.kernel.org>; Fri,  6 Mar 2020 19:15:01 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3B04ADA3A8
        for <netdev@vger.kernel.org>; Fri,  6 Mar 2020 19:15:01 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 2FCB6DA3A1; Fri,  6 Mar 2020 19:15:01 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4FB6DDA3C4;
        Fri,  6 Mar 2020 19:14:59 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 06 Mar 2020 19:14:59 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 2BAF14301DE0;
        Fri,  6 Mar 2020 19:14:59 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 00/11] Netfilter fixes for net
Date:   Fri,  6 Mar 2020 19:15:02 +0100
Message-Id: <20200306181513.656594-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset contains Netfilter fixes for net:

1) Patches to bump position index from sysctl seq_next,
   from Vasilin Averin.

2) Release flowtable hook from error path, from Florian Westphal.

3) Patches to add missing netlink attribute validation,
   from Jakub Kicinski.

4) Missing NFTA_CHAIN_FLAGS in nf_tables_fill_chain_info().

5) Infinite loop in module autoload if extension is not available,
   from Florian Westphal.

6) Missing module ownership in inet/nat chain type definition.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thank you.

----------------------------------------------------------------

The following changes since commit f8a0fea9518c5ff7c37679504bd9eeabeae8ee36:

  docs: networking: net_failover: Fix a few typos (2020-03-03 16:07:02 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to 6a42cefb25d8bdc1b391f4a53c78c32164eea2dd:

  netfilter: nft_chain_nat: inet family is missing module ownership (2020-03-06 18:00:43 +0100)

----------------------------------------------------------------
Florian Westphal (2):
      netfilter: nf_tables: free flowtable hooks on hook register error
      netfilter: nf_tables: fix infinite loop when expr is not available

Jakub Kicinski (3):
      netfilter: cthelper: add missing attribute validation for cthelper
      netfilter: nft_payload: add missing attribute validation for payload csum flags
      netfilter: nft_tunnel: add missing attribute validation for tunnels

Pablo Neira Ayuso (2):
      netfilter: nf_tables: dump NFTA_CHAIN_FLAGS attribute
      netfilter: nft_chain_nat: inet family is missing module ownership

Vasily Averin (4):
      netfilter: nf_conntrack: ct_cpu_seq_next should increase position index
      netfilter: synproxy: synproxy_cpu_seq_next should increase position index
      netfilter: xt_recent: recent_seq_next should increase position index
      netfilter: x_tables: xt_mttg_seq_next should increase position index

 net/netfilter/nf_conntrack_standalone.c |  2 +-
 net/netfilter/nf_synproxy_core.c        |  2 +-
 net/netfilter/nf_tables_api.c           | 22 ++++++++++++++--------
 net/netfilter/nfnetlink_cthelper.c      |  2 ++
 net/netfilter/nft_chain_nat.c           |  1 +
 net/netfilter/nft_payload.c             |  1 +
 net/netfilter/nft_tunnel.c              |  2 ++
 net/netfilter/x_tables.c                |  6 +++---
 net/netfilter/xt_recent.c               |  2 +-
 9 files changed, 26 insertions(+), 14 deletions(-)
