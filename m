Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 695B7189322
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 01:41:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727500AbgCRAlO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 20:41:14 -0400
Received: from correo.us.es ([193.147.175.20]:45604 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727259AbgCRAkP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Mar 2020 20:40:15 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 936F127F8AA
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 01:39:45 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 85072DA3A5
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 01:39:45 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 7AA4FDA39F; Wed, 18 Mar 2020 01:39:45 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 98738DA3AA;
        Wed, 18 Mar 2020 01:39:43 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 18 Mar 2020 01:39:43 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 71A0A426CCB9;
        Wed, 18 Mar 2020 01:39:43 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 09/29] netfilter: bitwise: use more descriptive variable-names.
Date:   Wed, 18 Mar 2020 01:39:36 +0100
Message-Id: <20200318003956.73573-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200318003956.73573-1-pablo@netfilter.org>
References: <20200318003956.73573-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeremy Sowden <jeremy@azazel.net>

Name the mask and xor data variables, "mask" and "xor," instead of "d1"
and "d2."

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_bitwise.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index 0ed2281f03be..bc37d6c59db4 100644
--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -93,7 +93,7 @@ static const struct nla_policy nft_bitwise_policy[NFTA_BITWISE_MAX + 1] = {
 static int nft_bitwise_init_bool(struct nft_bitwise *priv,
 				 const struct nlattr *const tb[])
 {
-	struct nft_data_desc d1, d2;
+	struct nft_data_desc mask, xor;
 	int err;
 
 	if (tb[NFTA_BITWISE_DATA])
@@ -103,29 +103,29 @@ static int nft_bitwise_init_bool(struct nft_bitwise *priv,
 	    !tb[NFTA_BITWISE_XOR])
 		return -EINVAL;
 
-	err = nft_data_init(NULL, &priv->mask, sizeof(priv->mask), &d1,
+	err = nft_data_init(NULL, &priv->mask, sizeof(priv->mask), &mask,
 			    tb[NFTA_BITWISE_MASK]);
 	if (err < 0)
 		return err;
-	if (d1.type != NFT_DATA_VALUE || d1.len != priv->len) {
+	if (mask.type != NFT_DATA_VALUE || mask.len != priv->len) {
 		err = -EINVAL;
 		goto err1;
 	}
 
-	err = nft_data_init(NULL, &priv->xor, sizeof(priv->xor), &d2,
+	err = nft_data_init(NULL, &priv->xor, sizeof(priv->xor), &xor,
 			    tb[NFTA_BITWISE_XOR]);
 	if (err < 0)
 		goto err1;
-	if (d2.type != NFT_DATA_VALUE || d2.len != priv->len) {
+	if (xor.type != NFT_DATA_VALUE || xor.len != priv->len) {
 		err = -EINVAL;
 		goto err2;
 	}
 
 	return 0;
 err2:
-	nft_data_release(&priv->xor, d2.type);
+	nft_data_release(&priv->xor, xor.type);
 err1:
-	nft_data_release(&priv->mask, d1.type);
+	nft_data_release(&priv->mask, mask.type);
 	return err;
 }
 
-- 
2.11.0

