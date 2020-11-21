Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 746A22BBEEF
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 13:36:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727714AbgKUMgP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Nov 2020 07:36:15 -0500
Received: from correo.us.es ([193.147.175.20]:60548 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727191AbgKUMgO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Nov 2020 07:36:14 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D0C68EBAC3
        for <netdev@vger.kernel.org>; Sat, 21 Nov 2020 13:36:13 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C289CDA791
        for <netdev@vger.kernel.org>; Sat, 21 Nov 2020 13:36:13 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B81E7DA78C; Sat, 21 Nov 2020 13:36:13 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WELCOMELIST,USER_IN_WHITELIST autolearn=disabled
        version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8B11BDA730;
        Sat, 21 Nov 2020 13:36:11 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 21 Nov 2020 13:36:11 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 626324265A5A;
        Sat, 21 Nov 2020 13:36:11 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 0/4] Netfilter fixes for net
Date:   Sat, 21 Nov 2020 13:35:57 +0100
Message-Id: <20201121123601.21733-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset contains Netfilter fixes for net:

1) Fix missing control data in flow dissector, otherwise IP address
   matching in hardware offload infra does not work.

2) Fix hardware offload match on prefix IP address when userspace
   does not send a bitwise expression to represent the prefix.

3) Insufficient validation of IPSET_ATTR_IPADDR_IPV6 reported
   by syzbot.

4) Remove spurious reports on nf_tables when lockdep gets disabled,
   from Florian Westphal.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thank you.

----------------------------------------------------------------

The following changes since commit 849920c703392957f94023f77ec89ca6cf119d43:

  devlink: Add missing genlmsg_cancel() in devlink_nl_sb_port_pool_fill() (2020-11-14 16:23:19 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to 986fbd9842ba114c74b4fb61c4dc146d87a55316:

  netfilter: nf_tables: avoid false-postive lockdep splat (2020-11-20 10:18:39 +0100)

----------------------------------------------------------------
Eric Dumazet (1):
      netfilter: ipset: prevent uninit-value in hash_ip6_add

Florian Westphal (1):
      netfilter: nf_tables: avoid false-postive lockdep splat

Pablo Neira Ayuso (2):
      netfilter: nftables_offload: set address type in control dissector
      netfilter: nftables_offload: build mask based from the matching bytes

 include/net/netfilter/nf_tables_offload.h |  7 ++++
 net/netfilter/ipset/ip_set_core.c         |  3 +-
 net/netfilter/nf_tables_api.c             |  3 +-
 net/netfilter/nf_tables_offload.c         | 18 ++++++++
 net/netfilter/nft_cmp.c                   |  8 ++--
 net/netfilter/nft_meta.c                  | 16 +++----
 net/netfilter/nft_payload.c               | 70 +++++++++++++++++++++++--------
 7 files changed, 93 insertions(+), 32 deletions(-)
