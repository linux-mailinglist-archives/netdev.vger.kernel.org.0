Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DB293119BE
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 04:18:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232116AbhBFDRg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 22:17:36 -0500
Received: from correo.us.es ([193.147.175.20]:53512 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231362AbhBFDH5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Feb 2021 22:07:57 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C62D8191932
        for <netdev@vger.kernel.org>; Sat,  6 Feb 2021 02:50:15 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B42D8DA704
        for <netdev@vger.kernel.org>; Sat,  6 Feb 2021 02:50:15 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A8F70DA78B; Sat,  6 Feb 2021 02:50:15 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 774C4DA704;
        Sat,  6 Feb 2021 02:50:13 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 06 Feb 2021 02:50:13 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 4B25C42E0F80;
        Sat,  6 Feb 2021 02:50:13 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 7/7] netfilter: nftables: remove redundant assignment of variable err
Date:   Sat,  6 Feb 2021 02:50:05 +0100
Message-Id: <20210206015005.23037-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210206015005.23037-1-pablo@netfilter.org>
References: <20210206015005.23037-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The variable err is being assigned a value that is never read,
the same error number is being returned at the error return
path via label err1.  Clean up the code by removing the assignment.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_cmp.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/netfilter/nft_cmp.c b/net/netfilter/nft_cmp.c
index 3640eea8a87b..eb6a43a180bb 100644
--- a/net/netfilter/nft_cmp.c
+++ b/net/netfilter/nft_cmp.c
@@ -266,10 +266,8 @@ nft_cmp_select_ops(const struct nft_ctx *ctx, const struct nlattr * const tb[])
 	if (err < 0)
 		return ERR_PTR(err);
 
-	if (desc.type != NFT_DATA_VALUE) {
-		err = -EINVAL;
+	if (desc.type != NFT_DATA_VALUE)
 		goto err1;
-	}
 
 	if (desc.len <= sizeof(u32) && (op == NFT_CMP_EQ || op == NFT_CMP_NEQ))
 		return &nft_cmp_fast_ops;
-- 
2.20.1

