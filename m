Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84F0619843E
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 21:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728000AbgC3TWt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 15:22:49 -0400
Received: from correo.us.es ([193.147.175.20]:48526 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728440AbgC3TWE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Mar 2020 15:22:04 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id EF6351022AA
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 21:21:57 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D932EFF6F2
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 21:21:57 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D5B5FFF6FC; Mon, 30 Mar 2020 21:21:46 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E8B1B2067E;
        Mon, 30 Mar 2020 21:21:42 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 30 Mar 2020 21:21:42 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id C1BA942EF4E1;
        Mon, 30 Mar 2020 21:21:42 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 11/28] netfilter: nf_tables: add enum nft_flowtable_flags to uapi
Date:   Mon, 30 Mar 2020 21:21:19 +0200
Message-Id: <20200330192136.230459-12-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200330192136.230459-1-pablo@netfilter.org>
References: <20200330192136.230459-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Expose the NFT_FLOWTABLE_HW_OFFLOAD flag through uapi.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_flow_table.h    |  2 +-
 include/uapi/linux/netfilter/nf_tables.h | 10 ++++++++++
 net/netfilter/nf_tables_api.c            |  2 +-
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index f523ea87b6ae..4beb7f13bc50 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -62,7 +62,7 @@ struct nf_flowtable_type {
 };
 
 enum nf_flowtable_flags {
-	NF_FLOWTABLE_HW_OFFLOAD		= 0x1,
+	NF_FLOWTABLE_HW_OFFLOAD		= 0x1,	/* NFT_FLOWTABLE_HW_OFFLOAD */
 };
 
 struct nf_flowtable {
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 4e3a5971d4ee..717ee3aa05d7 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1554,6 +1554,16 @@ enum nft_object_attributes {
 #define NFTA_OBJ_MAX		(__NFTA_OBJ_MAX - 1)
 
 /**
+ * enum nft_flowtable_flags - nf_tables flowtable flags
+ *
+ * @NFT_FLOWTABLE_HW_OFFLOAD: flowtable hardware offload is enabled
+ */
+enum nft_flowtable_flags {
+	NFT_FLOWTABLE_HW_OFFLOAD	= 0x1,
+	NFT_FLOWTABLE_MASK		= NFT_FLOWTABLE_HW_OFFLOAD
+};
+
+/**
  * enum nft_flowtable_attributes - nf_tables flow table netlink attributes
  *
  * @NFTA_FLOWTABLE_TABLE: name of the table containing the expression (NLA_STRING)
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index c5332a313283..ace325218edb 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6375,7 +6375,7 @@ static int nf_tables_newflowtable(struct net *net, struct sock *nlsk,
 	if (nla[NFTA_FLOWTABLE_FLAGS]) {
 		flowtable->data.flags =
 			ntohl(nla_get_be32(nla[NFTA_FLOWTABLE_FLAGS]));
-		if (flowtable->data.flags & ~NF_FLOWTABLE_HW_OFFLOAD)
+		if (flowtable->data.flags & ~NFT_FLOWTABLE_MASK)
 			goto err3;
 	}
 
-- 
2.11.0

