Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C3612E8DE4
	for <lists+netdev@lfdr.de>; Sun,  3 Jan 2021 20:31:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727485AbhACTaJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jan 2021 14:30:09 -0500
Received: from correo.us.es ([193.147.175.20]:40754 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725840AbhACTaI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 3 Jan 2021 14:30:08 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 89DBCDA737
        for <netdev@vger.kernel.org>; Sun,  3 Jan 2021 20:28:51 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7C039DA704
        for <netdev@vger.kernel.org>; Sun,  3 Jan 2021 20:28:51 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 71AD6DA84B; Sun,  3 Jan 2021 20:28:51 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WELCOMELIST,USER_IN_WHITELIST autolearn=disabled
        version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4609DDA722;
        Sun,  3 Jan 2021 20:28:49 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 03 Jan 2021 20:28:49 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 15981426CC84;
        Sun,  3 Jan 2021 20:28:49 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 0/3] Netfilter fixes for net
Date:   Sun,  3 Jan 2021 20:29:17 +0100
Message-Id: <20210103192920.18639-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub, David,

The following patchset contains Netfilter fixes for net:

1) Missing sanitization of rateest userspace string, bug has been
   triggered by syzbot, patch from Florian Westphal.

2) Report EOPNOTSUPP on missing set features in nft_dynset, otherwise
   error reporting to userspace via EINVAL is misleading since this is
   reserved for malformed netlink requests.

3) New binaries with old kernels might silently accept several set
   element expressions. New binaries set on the NFT_SET_EXPR and
   NFT_DYNSET_F_EXPR flags to request for several expressions per
   element, hence old kernels which do not support for this bail out
   with EOPNOTSUPP.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thanks!

P.S: Best wishes for 2021.

----------------------------------------------------------------

The following changes since commit 1f45dc22066797479072978feeada0852502e180:

  ibmvnic: continue fatal error reset after passive init (2020-12-23 12:56:10 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to b4e70d8dd9ea6bd5d5fb3122586f652326ca09cd:

  netfilter: nftables: add set expression flags (2020-12-28 10:50:26 +0100)

----------------------------------------------------------------
Florian Westphal (1):
      netfilter: xt_RATEEST: reject non-null terminated string from userspace

Pablo Neira Ayuso (2):
      netfilter: nft_dynset: report EOPNOTSUPP on missing set feature
      netfilter: nftables: add set expression flags

 include/uapi/linux/netfilter/nf_tables.h |  3 +++
 net/netfilter/nf_tables_api.c            |  6 +++++-
 net/netfilter/nft_dynset.c               | 15 ++++++++++-----
 net/netfilter/xt_RATEEST.c               |  3 +++
 4 files changed, 21 insertions(+), 6 deletions(-)
