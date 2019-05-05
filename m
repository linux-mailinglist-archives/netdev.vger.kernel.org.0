Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D8E6142FF
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 01:33:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727925AbfEEXdP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 19:33:15 -0400
Received: from mail.us.es ([193.147.175.20]:34062 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727593AbfEEXdO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 May 2019 19:33:14 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 08BB011ED83
        for <netdev@vger.kernel.org>; Mon,  6 May 2019 01:33:13 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EAAB5DA709
        for <netdev@vger.kernel.org>; Mon,  6 May 2019 01:33:12 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E0839DA707; Mon,  6 May 2019 01:33:12 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CC94BDA704;
        Mon,  6 May 2019 01:33:10 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 06 May 2019 01:33:10 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 9D1544265A31;
        Mon,  6 May 2019 01:33:10 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 00/12] Netfilter updates for net-next
Date:   Mon,  6 May 2019 01:32:53 +0200
Message-Id: <20190505233305.13650-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

The following batch contains Netfilter updates for net-next, they are:

1) Move nft_expr_clone() to nft_dynset, from Paul Gortmaker.

2) Do not include module.h from net/netfilter/nf_tables.h,
   also from Paul.

3) Restrict conntrack sysctl entries to boolean, from Tonghao Zhang.

4) Several patches to add infrastructure to autoload NAT helper
   modules from their respective conntrack helper, this also includes
   the first client of this code in OVS, patches from Flavio Leitner.

5) Add support to match for conntrack ID, from Brett Mastbergen.

6) Spelling fix in connlabel, from Colin Ian King.

7) Use struct_size() from hashlimit, from Gustavo A. R. Silva.

8) Add optimized version of nf_inet_addr_mask(), from Li RongQing.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git

Thanks!

----------------------------------------------------------------

The following changes since commit 7a1d8390d015a13c42b1effa1f22fda0858fe6f9:

  net: phy: micrel: make sure the factory test bit is cleared (2019-04-29 23:17:21 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git HEAD

for you to fetch changes up to 522e4077e8dcdfc5b8e96469d3bc2324bc5d6466:

  netfilter: slightly optimize nf_inet_addr_mask (2019-05-06 01:18:58 +0200)

----------------------------------------------------------------
Brett Mastbergen (1):
      netfilter: nft_ct: Add ct id support

Colin Ian King (1):
      netfilter: connlabels: fix spelling mistake "trackling" -> "tracking"

Flavio Leitner (4):
      netfilter: use macros to create module aliases.
      netfilter: add API to manage NAT helpers.
      netfilter: nf_nat: register NAT helpers.
      openvswitch: load and reference the NAT helper.

Gustavo A. R. Silva (1):
      netfilter: xt_hashlimit: use struct_size() helper

Li RongQing (1):
      netfilter: slightly optimize nf_inet_addr_mask

Paul Gortmaker (3):
      netfilter: nf_tables: relocate header content to consumer
      netfilter: nf_tables: fix implicit include of module.h
      netfilter: nf_tables: drop include of module.h from nf_tables.h

Tonghao Zhang (1):
      netfilter: conntrack: limit sysctl setting for boolean options

 include/linux/netfilter.h                   |  9 +++
 include/net/netfilter/nf_conntrack_helper.h | 24 ++++++++
 include/net/netfilter/nf_tables.h           | 20 +------
 include/net/netns/conntrack.h               |  6 +-
 include/uapi/linux/netfilter/nf_tables.h    |  2 +
 net/ipv4/netfilter/nf_nat_h323.c            |  2 +-
 net/ipv4/netfilter/nf_nat_pptp.c            |  2 +-
 net/netfilter/nf_conntrack_amanda.c         |  8 ++-
 net/netfilter/nf_conntrack_ftp.c            | 18 +++---
 net/netfilter/nf_conntrack_helper.c         | 86 +++++++++++++++++++++++++++++
 net/netfilter/nf_conntrack_irc.c            |  6 +-
 net/netfilter/nf_conntrack_sane.c           | 12 ++--
 net/netfilter/nf_conntrack_sip.c            | 28 +++++-----
 net/netfilter/nf_conntrack_standalone.c     | 48 +++++++++++-----
 net/netfilter/nf_conntrack_tftp.c           | 18 +++---
 net/netfilter/nf_nat_amanda.c               |  9 ++-
 net/netfilter/nf_nat_ftp.c                  |  9 ++-
 net/netfilter/nf_nat_irc.c                  |  9 ++-
 net/netfilter/nf_nat_sip.c                  |  9 ++-
 net/netfilter/nf_nat_tftp.c                 |  9 ++-
 net/netfilter/nf_tables_set_core.c          |  1 +
 net/netfilter/nft_ct.c                      |  8 +++
 net/netfilter/nft_dynset.c                  | 17 ++++++
 net/netfilter/xt_connlabel.c                |  2 +-
 net/netfilter/xt_hashlimit.c                |  3 +-
 net/openvswitch/conntrack.c                 | 26 +++++++--
 26 files changed, 302 insertions(+), 89 deletions(-)
