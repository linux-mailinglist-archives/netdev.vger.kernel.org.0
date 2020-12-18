Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 396BC2DE249
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 13:05:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbgLRME7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 07:04:59 -0500
Received: from correo.us.es ([193.147.175.20]:51904 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726519AbgLRME7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Dec 2020 07:04:59 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C771FEB46E
        for <netdev@vger.kernel.org>; Fri, 18 Dec 2020 13:03:58 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B3A64DA855
        for <netdev@vger.kernel.org>; Fri, 18 Dec 2020 13:03:58 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A7F33DA84F; Fri, 18 Dec 2020 13:03:58 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WELCOMELIST,USER_IN_WHITELIST autolearn=disabled
        version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 845B7DA78A;
        Fri, 18 Dec 2020 13:03:56 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 18 Dec 2020 13:03:56 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 4DFD642DF562;
        Fri, 18 Dec 2020 13:03:56 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 0/4] Netfilter fixes for net
Date:   Fri, 18 Dec 2020 13:04:05 +0100
Message-Id: <20201218120409.3659-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub, David,

The following patchset contains Netfilter fixes for net:

1) Incorrect loop in error path of nft_set_elem_expr_clone(),
   from Colin Ian King.

2) Missing xt_table_get_private_protected() to access table
   private data in x_tables, from Subash Abhinov Kasiviswanathan.

3) Possible oops in ipset hash type resize, from Vasily Averin.

4) Fix shift-out-of-bounds in ipset hash type, also from Vasily.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thanks!

----------------------------------------------------------------

The following changes since commit 3db1a3fa98808aa90f95ec3e0fa2fc7abf28f5c9:

  Merge tag 'staging-5.11-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging (2020-12-15 14:18:40 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to 5c8193f568ae16f3242abad6518dc2ca6c8eef86:

  netfilter: ipset: fix shift-out-of-bounds in htable_bits() (2020-12-17 19:44:52 +0100)

----------------------------------------------------------------
Colin Ian King (1):
      netfilter: nftables: fix incorrect increment of loop counter

Subash Abhinov Kasiviswanathan (1):
      netfilter: x_tables: Update remaining dereference to RCU

Vasily Averin (2):
      netfilter: ipset: fixes possible oops in mtype_resize
      netfilter: ipset: fix shift-out-of-bounds in htable_bits()

 net/ipv4/netfilter/arp_tables.c       |  2 +-
 net/ipv4/netfilter/ip_tables.c        |  2 +-
 net/ipv6/netfilter/ip6_tables.c       |  2 +-
 net/netfilter/ipset/ip_set_hash_gen.h | 42 +++++++++++++++--------------------
 net/netfilter/nf_tables_api.c         |  4 ++--
 5 files changed, 23 insertions(+), 29 deletions(-)
