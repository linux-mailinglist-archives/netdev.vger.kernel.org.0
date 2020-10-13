Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5405928D720
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 01:46:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729988AbgJMXqI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 19:46:08 -0400
Received: from correo.us.es ([193.147.175.20]:59842 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729871AbgJMXqI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Oct 2020 19:46:08 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id CF92DE4BAC
        for <netdev@vger.kernel.org>; Wed, 14 Oct 2020 01:46:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BE81DDA72F
        for <netdev@vger.kernel.org>; Wed, 14 Oct 2020 01:46:05 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id BD27BDA78F; Wed, 14 Oct 2020 01:46:05 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B3E5BDA72F;
        Wed, 14 Oct 2020 01:46:03 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 14 Oct 2020 01:46:03 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 8B72D42EFB80;
        Wed, 14 Oct 2020 01:46:03 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 0/4] Netfilter fixes for net
Date:   Wed, 14 Oct 2020 01:45:55 +0200
Message-Id: <20201013234559.15113-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset contains Netfilter fixes for net:

1) Extend nf_queue selftest to cover re-queueing, non-gso mode and
   delayed queueing, from Florian Westphal.

2) Clear skb->tstamp in IPVS forwarding path, from Julian Anastasov.

3) Provide netlink extended error reporting for EEXIST case.

4) Missing VLAN offload tag and proto in log target.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Absolutely nothing urgent in this batch, you might consider pulling this
once net-next.git gets merged into net.git so this shows up in 5.10-rc.

Thank you.

----------------------------------------------------------------

The following changes since commit 874fb9e2ca949b443cc419a4f2227cafd4381d39:

  ipv4: Restore flowi4_oif update before call to xfrm_lookup_route (2020-10-10 11:38:59 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to 0d9826bc18ce356e8909919ad681ad65d0a6061e:

  netfilter: nf_log: missing vlan offload tag and proto (2020-10-14 01:25:14 +0200)

----------------------------------------------------------------
Florian Westphal (1):
      selftests: netfilter: extend nfqueue test case

Julian Anastasov (1):
      ipvs: clear skb->tstamp in forwarding path

Pablo Neira Ayuso (2):
      netfilter: nftables: extend error reporting for chain updates
      netfilter: nf_log: missing vlan offload tag and proto

 include/net/netfilter/nf_log.h                 |  1 +
 net/ipv4/netfilter/nf_log_arp.c                | 19 ++++++-
 net/ipv4/netfilter/nf_log_ipv4.c               |  6 ++-
 net/ipv6/netfilter/nf_log_ipv6.c               |  8 +--
 net/netfilter/ipvs/ip_vs_xmit.c                |  6 +++
 net/netfilter/nf_log_common.c                  | 12 +++++
 net/netfilter/nf_tables_api.c                  | 19 +++++--
 tools/testing/selftests/netfilter/nf-queue.c   | 61 ++++++++++++++++++----
 tools/testing/selftests/netfilter/nft_queue.sh | 70 +++++++++++++++++++++-----
 9 files changed, 168 insertions(+), 34 deletions(-)
