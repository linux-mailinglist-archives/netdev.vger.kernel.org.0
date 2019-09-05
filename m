Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA07FAA7E2
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 18:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390731AbfIEQEI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 12:04:08 -0400
Received: from correo.us.es ([193.147.175.20]:53014 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731857AbfIEQEH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Sep 2019 12:04:07 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D2CB51228C5
        for <netdev@vger.kernel.org>; Thu,  5 Sep 2019 18:04:03 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C3EF9B8001
        for <netdev@vger.kernel.org>; Thu,  5 Sep 2019 18:04:03 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B8B44A7D59; Thu,  5 Sep 2019 18:04:03 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AD266B7FF2;
        Thu,  5 Sep 2019 18:04:01 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 05 Sep 2019 18:04:01 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 81EC742EE38E;
        Thu,  5 Sep 2019 18:04:01 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 0/8] Netfilter updates for net-next
Date:   Thu,  5 Sep 2019 18:03:52 +0200
Message-Id: <20190905160400.25399-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset contains Netfilter updates for net-next:

1) Add nft_reg_store64() and nft_reg_load64() helpers, from Ander Juaristi.

2) Time matching support, also from Ander Juaristi.

3) VLAN support for nfnetlink_log, from Michael Braun.

4) Support for set element deletions from the packet path, also from Ander.

5) Remove __read_mostly from conntrack spinlock, from Li RongQing.

6) Support for updating stateful objects, this also includes the initial
   client for this infrastructure: the quota extension. A follow up fix
   for the control plane also comes in this batch. Patches from
   Fernando Fernandez Mancera.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git

Thanks.

----------------------------------------------------------------

The following changes since commit 0846e1616f0f3365cea732e82e2383932fe644e5:

  cirrus: cs89x0: remove set but not used variable 'lp' (2019-08-25 19:48:59 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git HEAD

for you to fetch changes up to aa4095a156b56b00ca202d482b40d191ef5c54e8:

  netfilter: nf_tables: fix possible null-pointer dereference in object update (2019-09-05 13:40:27 +0200)

----------------------------------------------------------------
Ander Juaristi (3):
      netfilter: nf_tables: Introduce new 64-bit helper register functions
      netfilter: nft_meta: support for time matching
      netfilter: nft_dynset: support for element deletion

Fernando Fernandez Mancera (3):
      netfilter: nf_tables: Introduce stateful object update operation
      netfilter: nft_quota: add quota object update support
      netfilter: nf_tables: fix possible null-pointer dereference in object update

Li RongQing (1):
      netfilter: not mark a spinlock as __read_mostly

Michael Braun (1):
      netfilter: nfnetlink_log: add support for VLAN information

 include/net/netfilter/nf_tables.h            | 44 ++++++++++++---
 include/uapi/linux/netfilter/nf_tables.h     |  7 +++
 include/uapi/linux/netfilter/nfnetlink_log.h | 11 ++++
 net/netfilter/nf_conntrack_core.c            |  3 +-
 net/netfilter/nf_conntrack_labels.c          |  2 +-
 net/netfilter/nf_tables_api.c                | 81 +++++++++++++++++++++++++---
 net/netfilter/nfnetlink_log.c                | 57 ++++++++++++++++++++
 net/netfilter/nft_byteorder.c                |  9 ++--
 net/netfilter/nft_dynset.c                   |  6 +++
 net/netfilter/nft_meta.c                     | 46 ++++++++++++++++
 net/netfilter/nft_quota.c                    | 29 +++++++---
 net/netfilter/nft_set_hash.c                 | 19 +++++++
 12 files changed, 285 insertions(+), 29 deletions(-)
