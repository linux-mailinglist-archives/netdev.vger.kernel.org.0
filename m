Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7B872620D1
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 22:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730064AbgIHUQF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 16:16:05 -0400
Received: from correo.us.es ([193.147.175.20]:60742 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730083AbgIHPKD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Sep 2020 11:10:03 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0410A1F0CF4
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 17:09:54 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EAE24DA792
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 17:09:53 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id DFC1CDA793; Tue,  8 Sep 2020 17:09:53 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WELCOMELIST,USER_IN_WHITELIST autolearn=disabled
        version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C1F7DDA789;
        Tue,  8 Sep 2020 17:09:51 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 08 Sep 2020 17:09:51 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 98CF94301DE0;
        Tue,  8 Sep 2020 17:09:51 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 0/5] Netfilter fixes for net
Date:   Tue,  8 Sep 2020 17:09:42 +0200
Message-Id: <20200908150947.12623-1-pablo@netfilter.org>
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

1) Allow conntrack entries with l3num == NFPROTO_IPV4 or == NFPROTO_IPV6
   only via ctnetlink, from Will McVicker.

2) Batch notifications to userspace to improve netlink socket receive
   utilization.

3) Restore mark based dump filtering via ctnetlink, from Martin Willi.

4) nf_conncount_init() fails with -EPROTO with CONFIG_IPV6, from
   Eelco Chaudron.

5) Containers fail to match on meta skuid and skgid, use socket user_ns
   to retrieve meta skuid and skgid.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thank you.

----------------------------------------------------------------

The following changes since commit 19162fd4063a3211843b997a454b505edb81d5ce:

  hv_netvsc: Fix hibernation for mlx5 VF driver (2020-09-07 21:04:36 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to 0c92411bb81de9bc516d6924f50289d8d5f880e5:

  netfilter: nft_meta: use socket user_ns to retrieve skuid and skgid (2020-09-08 13:04:56 +0200)

----------------------------------------------------------------
Eelco Chaudron (1):
      netfilter: conntrack: nf_conncount_init is failing with IPv6 disabled

Martin Willi (1):
      netfilter: ctnetlink: fix mark based dump filtering regression

Pablo Neira Ayuso (2):
      netfilter: nf_tables: coalesce multiple notifications into one skbuff
      netfilter: nft_meta: use socket user_ns to retrieve skuid and skgid

Will McVicker (1):
      netfilter: ctnetlink: add a range check for l3/l4 protonum

 include/net/netns/nftables.h         |  1 +
 net/netfilter/nf_conntrack_netlink.c | 22 +++---------
 net/netfilter/nf_conntrack_proto.c   |  2 ++
 net/netfilter/nf_tables_api.c        | 70 +++++++++++++++++++++++++++++-------
 net/netfilter/nft_meta.c             |  4 +--
 5 files changed, 67 insertions(+), 32 deletions(-)
