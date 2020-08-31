Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A7AF257699
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 11:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726292AbgHaJg5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 05:36:57 -0400
Received: from correo.us.es ([193.147.175.20]:40338 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726167AbgHaJg5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Aug 2020 05:36:57 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 70E2215AEA5
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 11:36:54 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 62937DA72F
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 11:36:54 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 580F7DA78F; Mon, 31 Aug 2020 11:36:54 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3296CDA72F;
        Mon, 31 Aug 2020 11:36:52 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 31 Aug 2020 11:36:52 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 08C9942EF4E0;
        Mon, 31 Aug 2020 11:36:52 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 0/8] Netfilter fixes for net
Date:   Mon, 31 Aug 2020 11:36:40 +0200
Message-Id: <20200831093648.20765-1-pablo@netfilter.org>
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

1) Do not delete clash entries on reply, let them expire instead,
   from Florian Westphal.

2) Do not report EAGAIN to nfnetlink, otherwise this enters a busy loop.
   Update nfnetlink_unicast() to translate EAGAIN to ENOBUFS.

3) Remove repeated words in code comments, from Randy Dunlap.

4) Several patches for the flowtable selftests, from Fabian Frederick.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thank you.

----------------------------------------------------------------

The following changes since commit 5438dd45831ee33869779bd1919b05816ae4dbc9:

  net_sched: fix error path in red_init() (2020-08-28 07:16:46 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to c46172147ebbeb70094db48d76ab7945d96c638b:

  netfilter: conntrack: do not auto-delete clash entries on reply (2020-08-29 13:03:06 +0200)

----------------------------------------------------------------
Fabian Frederick (5):
      selftests: netfilter: fix header example
      selftests: netfilter: exit on invalid parameters
      selftests: netfilter: remove unused variable in make_file()
      selftests: netfilter: simplify command testing
      selftests: netfilter: add command usage

Florian Westphal (1):
      netfilter: conntrack: do not auto-delete clash entries on reply

Pablo Neira Ayuso (1):
      netfilter: nfnetlink: nfnetlink_unicast() reports EAGAIN instead of ENOBUFS

Randy Dunlap (1):
      netfilter: delete repeated words

 include/linux/netfilter/nfnetlink.h                |  3 +-
 net/ipv4/netfilter/nf_nat_pptp.c                   |  2 +-
 net/netfilter/nf_conntrack_pptp.c                  |  2 +-
 net/netfilter/nf_conntrack_proto_tcp.c             |  2 +-
 net/netfilter/nf_conntrack_proto_udp.c             | 26 ++++-----
 net/netfilter/nf_tables_api.c                      | 61 ++++++++++----------
 net/netfilter/nfnetlink.c                          | 11 +++-
 net/netfilter/nfnetlink_log.c                      |  3 +-
 net/netfilter/nfnetlink_queue.c                    |  2 +-
 net/netfilter/nft_flow_offload.c                   |  2 +-
 net/netfilter/xt_recent.c                          |  2 +-
 tools/testing/selftests/netfilter/nft_flowtable.sh | 67 ++++++++++++----------
 12 files changed, 92 insertions(+), 91 deletions(-)
