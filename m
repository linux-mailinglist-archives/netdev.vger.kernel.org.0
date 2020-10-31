Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD5DC2A1974
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 19:22:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728238AbgJaSV7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 14:21:59 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56534 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726736AbgJaSV7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 31 Oct 2020 14:21:59 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kYvVl-004XRs-Fq; Sat, 31 Oct 2020 19:21:57 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next] net: netfilter: Add __printf() attribute
Date:   Sat, 31 Oct 2020 19:21:44 +0100
Message-Id: <20201031182144.1081847-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

nft_request_module calls vsnprintf() using parameters passed to it.
Make the function with __printf() attribute so the compiler can check
the format and arguments.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 net/netfilter/nf_tables_api.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 65cb8e3c13d9..522a9d28754b 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -581,7 +581,8 @@ struct nft_module_request {
 };
 
 #ifdef CONFIG_MODULES
-static int nft_request_module(struct net *net, const char *fmt, ...)
+static __printf(2, 3) int nft_request_module(struct net *net, const char *fmt,
+					     ...)
 {
 	char module_name[MODULE_NAME_LEN];
 	struct nft_module_request *req;
-- 
2.28.0

