Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 481721D2F6C
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 14:19:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727805AbgENMTX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 08:19:23 -0400
Received: from correo.us.es ([193.147.175.20]:54236 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725955AbgENMTV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 May 2020 08:19:21 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BD7D115AEA9
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 14:19:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AD0ECDA71A
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 14:19:18 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A8950DA716; Thu, 14 May 2020 14:19:18 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A4825DA709;
        Thu, 14 May 2020 14:19:16 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 14 May 2020 14:19:16 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 7FDB642EF42B;
        Thu, 14 May 2020 14:19:16 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 0/6] Netfilter fixes for net
Date:   Thu, 14 May 2020 14:19:07 +0200
Message-Id: <20200514121913.24519-1-pablo@netfilter.org>
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

1) Fix gcc-10 compilation warning in nf_conntrack, from Arnd Bergmann.

2) Add NF_FLOW_HW_PENDING to avoid races between stats and deletion
   commands, from Paul Blakey.

3) Remove WQ_MEM_RECLAIM from the offload workqueue, from Roi Dayan.

4) Infinite loop when removing nf_conntrack module, from Florian Westphal.

5) Set NF_FLOW_TEARDOWN bit on expiration to avoid races when refreshing
   the timeout from the software path.

6) Missing nft_set_elem_expired() check in the rbtree, from Phil Sutter.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thank you.

----------------------------------------------------------------

The following changes since commit 3047211ca11bf77b3ecbce045c0aa544d934b945:

  net: dsa: loop: Add module soft dependency (2020-05-10 11:24:20 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to 340eaff651160234bdbce07ef34b92a8e45cd540:

  netfilter: nft_set_rbtree: Add missing expired checks (2020-05-12 13:19:34 +0200)

----------------------------------------------------------------
Arnd Bergmann (1):
      netfilter: conntrack: avoid gcc-10 zero-length-bounds warning

Florian Westphal (1):
      netfilter: conntrack: fix infinite loop on rmmod

Pablo Neira Ayuso (1):
      netfilter: flowtable: set NF_FLOW_TEARDOWN flag on entry expiration

Paul Blakey (1):
      netfilter: flowtable: Add pending bit for offload work

Phil Sutter (1):
      netfilter: nft_set_rbtree: Add missing expired checks

Roi Dayan (1):
      netfilter: flowtable: Remove WQ_MEM_RECLAIM from workqueue

 include/net/netfilter/nf_conntrack.h  |  2 +-
 include/net/netfilter/nf_flow_table.h |  1 +
 net/netfilter/nf_conntrack_core.c     | 17 ++++++++++++++---
 net/netfilter/nf_flow_table_core.c    |  8 +++++---
 net/netfilter/nf_flow_table_offload.c | 10 ++++++++--
 net/netfilter/nft_set_rbtree.c        | 11 +++++++++++
 6 files changed, 40 insertions(+), 9 deletions(-)
