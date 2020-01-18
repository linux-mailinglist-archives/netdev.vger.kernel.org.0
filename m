Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9331B14195F
	for <lists+netdev@lfdr.de>; Sat, 18 Jan 2020 21:14:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727085AbgARUOZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jan 2020 15:14:25 -0500
Received: from correo.us.es ([193.147.175.20]:48386 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726809AbgARUOZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Jan 2020 15:14:25 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E65402EFEA1
        for <netdev@vger.kernel.org>; Sat, 18 Jan 2020 21:14:22 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D5F1ADA702
        for <netdev@vger.kernel.org>; Sat, 18 Jan 2020 21:14:22 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id CB81EDA709; Sat, 18 Jan 2020 21:14:22 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C3867DA702;
        Sat, 18 Jan 2020 21:14:20 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 18 Jan 2020 21:14:20 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 9CA2641E4800;
        Sat, 18 Jan 2020 21:14:20 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 00/21] Netfilter updates for net-next
Date:   Sat, 18 Jan 2020 21:13:56 +0100
Message-Id: <20200118201417.334111-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset contains Netfilter updates for net-next, they are:

1) Incorrect uapi header comment in bitwise, from Jeremy Sowden.

2) Fetch flow statistics if flow is still active.

3) Restrict flow matching on hardware based on input device.

4) Add nf_flow_offload_work_alloc() helper function.

5) Remove the last client of the FLOW_OFFLOAD_DYING flag, use teardown
   instead.

6) Use atomic bitwise operation to operate with flow flags.

7) Add nf_flowtable_hw_offload() helper function to check for the
   NF_FLOWTABLE_HW_OFFLOAD flag.

8) Add NF_FLOW_HW_REFRESH to retry hardware offload from the flowtable
   software datapath.

9) Remove indirect calls in xt_hashlimit, from Florian Westphal.

10) Add nf_flow_offload_tuple() helper to consolidate code.

11) Add nf_flow_table_offload_cmd() helper function.

12) A few whitespace cleanups in nf_tables in bitwise and the bitmap/hash
    set types, from Jeremy Sowden.

13) Cleanup netlink attribute checks in bitwise, from Jeremy Sowden.

14) Replace goto by return in error path of nft_bitwise_dump(), from
    Jeremy Sowden.

15) Add bitwise operation netlink attribute, also from Jeremy.

16) Add nft_bitwise_init_bool(), from Jeremy Sowden.

17) Add nft_bitwise_eval_bool(), also from Jeremy.

18) Add nft_bitwise_dump_bool(), from Jeremy Sowden.

19) Disallow hardware offload for other that NFT_BITWISE_BOOL,
    from Jeremy Sowden.

20) Add NFTA_BITWISE_DATA netlink attribute, again from Jeremy.

21) Add support for bitwise shift operation, from Jeremy Sowden.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git

Thank you.

----------------------------------------------------------------

The following changes since commit 6bc8038035267d12df2bf78a8e1a5f07069fabb8:

  sfc: remove duplicated include from efx.c (2020-01-16 10:06:18 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git HEAD

for you to fetch changes up to 567d746b55bc66d3800c9ae91d50f0c5deb2fd93:

  netfilter: bitwise: add support for shifts. (2020-01-16 15:52:02 +0100)

----------------------------------------------------------------
Florian Westphal (1):
      netfilter: hashlimit: do not use indirect calls during gc

Jeremy Sowden (11):
      netfilter: nft_bitwise: correct uapi header comment.
      netfilter: nf_tables: white-space fixes.
      netfilter: bitwise: remove NULL comparisons from attribute checks.
      netfilter: bitwise: replace gotos with returns.
      netfilter: bitwise: add NFTA_BITWISE_OP netlink attribute.
      netfilter: bitwise: add helper for initializing boolean operations.
      netfilter: bitwise: add helper for evaluating boolean operations.
      netfilter: bitwise: add helper for dumping boolean operations.
      netfilter: bitwise: only offload boolean operations.
      netfilter: bitwise: add NFTA_BITWISE_DATA attribute.
      netfilter: bitwise: add support for shifts.

Pablo Neira Ayuso (9):
      netfilter: flowtable: fetch stats only if flow is still alive
      netfilter: flowtable: restrict flow dissector match on meta ingress device
      netfilter: flowtable: add nf_flow_offload_work_alloc()
      netfilter: flowtable: remove dying bit, use teardown bit instead
      netfilter: flowtable: use atomic bitwise operations for flow flags
      netfilter: flowtable: add nf_flowtable_hw_offload() helper function
      netfilter: flowtable: refresh flow if hardware offload fails
      netfilter: flowtable: add nf_flow_offload_tuple() helper
      netfilter: flowtable: add nf_flow_table_offload_cmd()

 include/net/netfilter/nf_flow_table.h    |  27 ++--
 include/uapi/linux/netfilter/nf_tables.h |  26 +++-
 net/netfilter/nf_flow_table_core.c       |  31 +++--
 net/netfilter/nf_flow_table_ip.c         |  21 ++-
 net/netfilter/nf_flow_table_offload.c    | 164 ++++++++++++----------
 net/netfilter/nft_bitwise.c              | 224 +++++++++++++++++++++++++------
 net/netfilter/nft_set_bitmap.c           |   4 +-
 net/netfilter/nft_set_hash.c             |   2 +-
 net/netfilter/xt_hashlimit.c             |  22 +--
 9 files changed, 352 insertions(+), 169 deletions(-)
