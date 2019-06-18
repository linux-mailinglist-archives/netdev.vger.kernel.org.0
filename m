Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 155AA4A392
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 16:13:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729325AbfFRONX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 10:13:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50878 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725919AbfFRONX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 10:13:23 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1hdErQ-0004CO-0g; Tue, 18 Jun 2019 14:13:20 +0000
From:   Colin King <colin.king@canonical.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S . Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] netfilter: synproxy: ensure zero is returned on non-error return path
Date:   Tue, 18 Jun 2019 15:13:19 +0100
Message-Id: <20190618141319.14961-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Currently function nf_synproxy_ipv6_init returns an uninitialized
garbage value in variable ret on a successful return.  Fix this by
returning zero on success.

Addresses-Coverity: ("Uninitialized scalar variable")
Fixes: d7f9b2f18eae ("netfilter: synproxy: extract SYNPROXY infrastructure from {ipt, ip6t}_SYNPROXY")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 net/netfilter/nf_synproxy_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_synproxy_core.c b/net/netfilter/nf_synproxy_core.c
index 50677285f82e..701f880d01e6 100644
--- a/net/netfilter/nf_synproxy_core.c
+++ b/net/netfilter/nf_synproxy_core.c
@@ -1223,7 +1223,7 @@ nf_synproxy_ipv6_init(struct synproxy_net *snet, struct net *net)
 	}
 
 	snet->hook_ref6++;
-	return err;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(nf_synproxy_ipv6_init);
 
-- 
2.20.1

