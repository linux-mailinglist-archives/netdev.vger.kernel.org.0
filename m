Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F20E2963B7
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 19:29:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2900134AbgJVR3i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 13:29:38 -0400
Received: from correo.us.es ([193.147.175.20]:54092 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2900086AbgJVR3g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Oct 2020 13:29:36 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D00731C438B
        for <netdev@vger.kernel.org>; Thu, 22 Oct 2020 19:29:34 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C1E8ADA72F
        for <netdev@vger.kernel.org>; Thu, 22 Oct 2020 19:29:34 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B6867DA730; Thu, 22 Oct 2020 19:29:34 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WELCOMELIST,USER_IN_WHITELIST autolearn=disabled
        version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A27E2DA722;
        Thu, 22 Oct 2020 19:29:31 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 22 Oct 2020 19:29:31 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 7488442EE38E;
        Thu, 22 Oct 2020 19:29:31 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 0/7] Netfilter fixes for net
Date:   Thu, 22 Oct 2020 19:29:18 +0200
Message-Id: <20201022172925.22770-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

The following patchset contains Netfilter fixes for net:

1) Update debugging in IPVS tcp protocol handler to make it easier
   to understand, from longguang.yue

2) Update TCP tracker to deal with keepalive packet after
   re-registration, from Franceso Ruggeri.

3) Missing IP6SKB_FRAGMENTED from netfilter fragment reassembly,
   from Georg Kohmann.

4) Fix bogus packet drop in ebtables nat extensions, from
   Thimothee Cocault.

5) Fix typo in flowtable documentation.

6) Reset skb timestamp in nft_fwd_netdev.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit df6afe2f7c19349de2ee560dc62ea4d9ad3ff889:

  nexthop: Fix performance regression in nexthop deletion (2020-10-19 20:07:15 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to c77761c8a59405cb7aa44188b30fffe13fbdd02d:

  netfilter: nf_fwd_netdev: clear timestamp in forwarding path (2020-10-22 14:49:36 +0200)

----------------------------------------------------------------
Francesco Ruggeri (1):
      netfilter: conntrack: connection timeout after re-register

Georg Kohmann (1):
      netfilter: Drop fragmented ndisc packets assembled in netfilter

Jeremy Sowden (1):
      docs: nf_flowtable: fix typo.

Pablo Neira Ayuso (1):
      netfilter: nf_fwd_netdev: clear timestamp in forwarding path

Saeed Mirzamohammadi (1):
      netfilter: nftables_offload: KASAN slab-out-of-bounds Read in nft_flow_rule_create

Timothée COCAULT (1):
      netfilter: ebtables: Fixes dropping of small packets in bridge nat

longguang.yue (1):
      ipvs: adjust the debug info in function set_tcp_state

 Documentation/networking/nf_flowtable.rst |  2 +-
 include/net/netfilter/nf_tables.h         |  6 ++++++
 net/bridge/netfilter/ebt_dnat.c           |  2 +-
 net/bridge/netfilter/ebt_redirect.c       |  2 +-
 net/bridge/netfilter/ebt_snat.c           |  2 +-
 net/ipv6/netfilter/nf_conntrack_reasm.c   |  1 +
 net/netfilter/ipvs/ip_vs_proto_tcp.c      | 10 ++++++----
 net/netfilter/nf_conntrack_proto_tcp.c    | 19 +++++++++++++------
 net/netfilter/nf_dup_netdev.c             |  1 +
 net/netfilter/nf_tables_api.c             |  6 +++---
 net/netfilter/nf_tables_offload.c         |  4 ++--
 net/netfilter/nft_fwd_netdev.c            |  1 +
 12 files changed, 37 insertions(+), 19 deletions(-)
