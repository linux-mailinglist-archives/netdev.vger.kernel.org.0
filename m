Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FA41F8370
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 00:30:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727054AbfKKXaJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 18:30:09 -0500
Received: from correo.us.es ([193.147.175.20]:40994 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726924AbfKKXaJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Nov 2019 18:30:09 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B34331C43A8
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 00:30:04 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A3E42B8011
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 00:30:04 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 98A7CB7FFE; Tue, 12 Nov 2019 00:30:04 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B18E5B7FF2;
        Tue, 12 Nov 2019 00:30:02 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 12 Nov 2019 00:30:02 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 4588542EF4E0;
        Tue, 12 Nov 2019 00:30:02 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, paulb@mellanox.com,
        ozsh@mellanox.com, majd@mellanox.com, saeedm@mellanox.com
Subject: [PATCH net-next 2/6] netfilter: nf_flow_table: remove union from flow_offload structure
Date:   Tue, 12 Nov 2019 00:29:52 +0100
Message-Id: <20191111232956.24898-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191111232956.24898-1-pablo@netfilter.org>
References: <20191111232956.24898-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drivers do not have access to the flow_offload structure, hence remove
this union from this flow_offload object as well as the original comment
on top of it.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_flow_table.h | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 88c8cd248213..7f892d6c1a6d 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -74,10 +74,7 @@ struct flow_offload {
 	struct flow_offload_tuple_rhash		tuplehash[FLOW_OFFLOAD_DIR_MAX];
 	struct nf_conn				*ct;
 	u32					flags;
-	union {
-		/* Your private driver data here. */
-		u32		timeout;
-	};
+	u32					timeout;
 };
 
 #define NF_FLOW_TIMEOUT (30 * HZ)
-- 
2.11.0

