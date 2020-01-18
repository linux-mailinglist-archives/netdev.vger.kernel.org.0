Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72A5414197F
	for <lists+netdev@lfdr.de>; Sat, 18 Jan 2020 21:15:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727162AbgARUOz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jan 2020 15:14:55 -0500
Received: from correo.us.es ([193.147.175.20]:48466 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726838AbgARUOc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Jan 2020 15:14:32 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 66A472EFEB0
        for <netdev@vger.kernel.org>; Sat, 18 Jan 2020 21:14:31 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 59A33DA711
        for <netdev@vger.kernel.org>; Sat, 18 Jan 2020 21:14:31 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 4F331DA701; Sat, 18 Jan 2020 21:14:31 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 587F0DA701;
        Sat, 18 Jan 2020 21:14:29 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 18 Jan 2020 21:14:29 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 2905741E4800;
        Sat, 18 Jan 2020 21:14:29 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 13/21] netfilter: bitwise: remove NULL comparisons from attribute checks.
Date:   Sat, 18 Jan 2020 21:14:09 +0100
Message-Id: <20200118201417.334111-14-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200118201417.334111-1-pablo@netfilter.org>
References: <20200118201417.334111-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeremy Sowden <jeremy@azazel.net>

In later patches, we will be adding more checks.  In order to be
consistent and prevent complaints from checkpatch.pl, replace the
existing comparisons with NULL with logical NOT operators.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_bitwise.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index e8ca1ec105f8..85605fb1e360 100644
--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -52,11 +52,11 @@ static int nft_bitwise_init(const struct nft_ctx *ctx,
 	u32 len;
 	int err;
 
-	if (tb[NFTA_BITWISE_SREG] == NULL ||
-	    tb[NFTA_BITWISE_DREG] == NULL ||
-	    tb[NFTA_BITWISE_LEN] == NULL ||
-	    tb[NFTA_BITWISE_MASK] == NULL ||
-	    tb[NFTA_BITWISE_XOR] == NULL)
+	if (!tb[NFTA_BITWISE_SREG] ||
+	    !tb[NFTA_BITWISE_DREG] ||
+	    !tb[NFTA_BITWISE_LEN]  ||
+	    !tb[NFTA_BITWISE_MASK] ||
+	    !tb[NFTA_BITWISE_XOR])
 		return -EINVAL;
 
 	err = nft_parse_u32_check(tb[NFTA_BITWISE_LEN], U8_MAX, &len);
-- 
2.11.0

