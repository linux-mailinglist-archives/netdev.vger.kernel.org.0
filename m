Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DEF14954E
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 00:42:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728625AbfFQWmd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 18:42:33 -0400
Received: from mail.us.es ([193.147.175.20]:36168 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727027AbfFQWmb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 18:42:31 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 88448BEBA6
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 00:42:29 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 79361DA703
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 00:42:29 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 6E8DBDA707; Tue, 18 Jun 2019 00:42:29 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 62F09DA703;
        Tue, 18 Jun 2019 00:42:27 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 18 Jun 2019 00:42:27 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 16F944265A32;
        Tue, 18 Jun 2019 00:42:27 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 1/3] netfilter: nf_tables: fix module autoload with inet family
Date:   Tue, 18 Jun 2019 00:42:21 +0200
Message-Id: <20190617224223.1004-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190617224223.1004-1-pablo@netfilter.org>
References: <20190617224223.1004-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use MODULE_ALIAS_NFT_EXPR() to make happy the inet family with nat.

Fixes: 63ce3940f3ab ("netfilter: nft_redir: add inet support")
Fixes: 071657d2c38c ("netfilter: nft_masq: add inet support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_masq.c  | 3 +--
 net/netfilter/nft_redir.c | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nft_masq.c b/net/netfilter/nft_masq.c
index 86fd90085eaf..8c1612d6bc2c 100644
--- a/net/netfilter/nft_masq.c
+++ b/net/netfilter/nft_masq.c
@@ -307,5 +307,4 @@ module_exit(nft_masq_module_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Arturo Borrero Gonzalez <arturo@debian.org>");
-MODULE_ALIAS_NFT_AF_EXPR(AF_INET6, "masq");
-MODULE_ALIAS_NFT_AF_EXPR(AF_INET, "masq");
+MODULE_ALIAS_NFT_EXPR("masq");
diff --git a/net/netfilter/nft_redir.c b/net/netfilter/nft_redir.c
index da74fdc4a684..8787e9f8ed71 100644
--- a/net/netfilter/nft_redir.c
+++ b/net/netfilter/nft_redir.c
@@ -294,5 +294,4 @@ module_exit(nft_redir_module_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Arturo Borrero Gonzalez <arturo@debian.org>");
-MODULE_ALIAS_NFT_AF_EXPR(AF_INET, "redir");
-MODULE_ALIAS_NFT_AF_EXPR(AF_INET6, "redir");
+MODULE_ALIAS_NFT_EXPR("nat");
-- 
2.11.0

