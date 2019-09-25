Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3C15BE65D
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 22:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392838AbfIYUaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 16:30:23 -0400
Received: from correo.us.es ([193.147.175.20]:44552 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388515AbfIYUaW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Sep 2019 16:30:22 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8B300C5140
        for <netdev@vger.kernel.org>; Wed, 25 Sep 2019 22:30:16 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7B2F2B8017
        for <netdev@vger.kernel.org>; Wed, 25 Sep 2019 22:30:16 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 6166AA7E3D; Wed, 25 Sep 2019 22:30:12 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 61BA3A7E34;
        Wed, 25 Sep 2019 22:30:10 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 25 Sep 2019 22:30:10 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 3707C4265A5A;
        Wed, 25 Sep 2019 22:30:10 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 0/5] Netfilter fixes for net
Date:   Wed, 25 Sep 2019 22:29:58 +0200
Message-Id: <20190925203003.20112-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset contains Netfilter fixes for net:

1) Add NFT_CHAIN_POLICY_UNSET to replace hardcoded -1 to
   specify that the chain policy is unset. The chain policy
   field is actually defined as an 8-bit unsigned integer.

2) Remove always true condition reported by smatch in
   chain policy check.

3) Fix element lookup on dynamic sets, from Florian Westphal.

4) Use __u8 in ebtables uapi header, from Masahiro Yamada.

5) Bogus EBUSY when removing flowtable after chain flush,
   from Laura Garcia Liebana.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit 864668bfc374dfbf4851ec828b9049e08f9057b1:

  selftests: Add test cases for `ip nexthop flush proto XX` (2019-09-19 18:35:55 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to 9b05b6e11d5e93a3a517cadc12b9836e0470c255:

  netfilter: nf_tables: bogus EBUSY when deleting flowtable after flush (2019-09-25 11:01:19 +0200)

----------------------------------------------------------------
Florian Westphal (1):
      netfilter: nf_tables: allow lookups in dynamic sets

Laura Garcia Liebana (1):
      netfilter: nf_tables: bogus EBUSY when deleting flowtable after flush

Masahiro Yamada (1):
      netfilter: ebtables: use __u8 instead of uint8_t in uapi header

Pablo Neira Ayuso (2):
      netfilter: nf_tables: add NFT_CHAIN_POLICY_UNSET and use it
      netfilter: nf_tables_offload: fix always true policy is unset check

 include/net/netfilter/nf_tables.h              |  6 ++++++
 include/uapi/linux/netfilter_bridge/ebtables.h |  6 +++---
 net/netfilter/nf_tables_api.c                  | 25 ++++++++++++++++++++++---
 net/netfilter/nf_tables_offload.c              |  2 +-
 net/netfilter/nft_flow_offload.c               | 19 +++++++++++++++++++
 net/netfilter/nft_lookup.c                     |  3 ---
 usr/include/Makefile                           |  1 -
 7 files changed, 51 insertions(+), 11 deletions(-)
