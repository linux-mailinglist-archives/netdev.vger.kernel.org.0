Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16F2719714B
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 02:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728113AbgC3Ah3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 20:37:29 -0400
Received: from correo.us.es ([193.147.175.20]:57224 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728043AbgC3Ah0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 29 Mar 2020 20:37:26 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 157C4EF440
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 02:37:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0207A100A44
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 02:37:25 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id EB37C100A4B; Mon, 30 Mar 2020 02:37:24 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 22F03100A44;
        Mon, 30 Mar 2020 02:37:23 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 30 Mar 2020 02:37:23 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id E846B42EF42A;
        Mon, 30 Mar 2020 02:37:22 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 22/26] netfilter: nft_set_bitmap: initialize set element extension in lookups
Date:   Mon, 30 Mar 2020 02:37:04 +0200
Message-Id: <20200330003708.54017-23-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200330003708.54017-1-pablo@netfilter.org>
References: <20200330003708.54017-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Otherwise, nft_lookup might dereference an uninitialized pointer to the
element extension.

Fixes: 665153ff5752 ("netfilter: nf_tables: add bitmap set type")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_set_bitmap.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nft_set_bitmap.c b/net/netfilter/nft_set_bitmap.c
index 1cb2e67e6e03..6829a497b4cc 100644
--- a/net/netfilter/nft_set_bitmap.c
+++ b/net/netfilter/nft_set_bitmap.c
@@ -81,6 +81,7 @@ static bool nft_bitmap_lookup(const struct net *net, const struct nft_set *set,
 	u32 idx, off;
 
 	nft_bitmap_location(set, key, &idx, &off);
+	*ext = NULL;
 
 	return nft_bitmap_active(priv->bitmap, idx, off, genmask);
 }
-- 
2.11.0

