Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC3DE51FB1
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 02:14:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730004AbfFYAOR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 20:14:17 -0400
Received: from mail.us.es ([193.147.175.20]:38016 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729416AbfFYAMx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jun 2019 20:12:53 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E6B35C04AB
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 02:12:51 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D6FFFDA70B
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 02:12:51 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id CC7C2DA704; Tue, 25 Jun 2019 02:12:51 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BC847DA704;
        Tue, 25 Jun 2019 02:12:49 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 25 Jun 2019 02:12:49 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 88AD84265A2F;
        Tue, 25 Jun 2019 02:12:49 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 17/26] netfilter: synproxy: ensure zero is returned on non-error return path
Date:   Tue, 25 Jun 2019 02:12:24 +0200
Message-Id: <20190625001233.22057-18-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190625001233.22057-1-pablo@netfilter.org>
References: <20190625001233.22057-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Currently functions nf_synproxy_{ipc4|ipv6}_init return an uninitialized
garbage value in variable ret on a successful return.  Fix this by
returning zero on success.

Addresses-Coverity: ("Uninitialized scalar variable")
Fixes: d7f9b2f18eae ("netfilter: synproxy: extract SYNPROXY infrastructure from {ipt, ip6t}_SYNPROXY")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_synproxy_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_synproxy_core.c b/net/netfilter/nf_synproxy_core.c
index 50677285f82e..7bf5202e3222 100644
--- a/net/netfilter/nf_synproxy_core.c
+++ b/net/netfilter/nf_synproxy_core.c
@@ -798,7 +798,7 @@ int nf_synproxy_ipv4_init(struct synproxy_net *snet, struct net *net)
 	}
 
 	snet->hook_ref4++;
-	return err;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(nf_synproxy_ipv4_init);
 
@@ -1223,7 +1223,7 @@ nf_synproxy_ipv6_init(struct synproxy_net *snet, struct net *net)
 	}
 
 	snet->hook_ref6++;
-	return err;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(nf_synproxy_ipv6_init);
 
-- 
2.11.0

