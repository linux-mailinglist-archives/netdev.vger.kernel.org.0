Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE382397C33
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 00:07:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235143AbhFAWIv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 18:08:51 -0400
Received: from mail.netfilter.org ([217.70.188.207]:39572 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234949AbhFAWIX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 18:08:23 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id BF573641A1;
        Wed,  2 Jun 2021 00:05:34 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 16/16] netfilter: fix clang-12 fmt string warnings
Date:   Wed,  2 Jun 2021 00:06:29 +0200
Message-Id: <20210601220629.18307-17-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210601220629.18307-1-pablo@netfilter.org>
References: <20210601220629.18307-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

nf_conntrack_h323_main.c:198:6: warning: format specifies type 'unsigned short' but
xt_AUDIT.c:121:9: warning: format specifies type 'unsigned char' but the argument has type 'int' [-Wformat]

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_h323_main.c | 2 +-
 net/netfilter/xt_AUDIT.c               | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_h323_main.c b/net/netfilter/nf_conntrack_h323_main.c
index aafaff00baf1..2eb31ffb3d14 100644
--- a/net/netfilter/nf_conntrack_h323_main.c
+++ b/net/netfilter/nf_conntrack_h323_main.c
@@ -194,7 +194,7 @@ static int get_tpkt_data(struct sk_buff *skb, unsigned int protoff,
 		if (tcpdatalen == 4) {	/* Separate TPKT header */
 			/* Netmeeting sends TPKT header and data separately */
 			pr_debug("nf_ct_h323: separate TPKT header indicates "
-				 "there will be TPKT data of %hu bytes\n",
+				 "there will be TPKT data of %d bytes\n",
 				 tpktlen - 4);
 			info->tpkt_len[dir] = tpktlen - 4;
 			return 0;
diff --git a/net/netfilter/xt_AUDIT.c b/net/netfilter/xt_AUDIT.c
index 9cdc16b0d0d8..b6a015aee0ce 100644
--- a/net/netfilter/xt_AUDIT.c
+++ b/net/netfilter/xt_AUDIT.c
@@ -117,7 +117,7 @@ static int audit_tg_check(const struct xt_tgchk_param *par)
 	const struct xt_audit_info *info = par->targinfo;
 
 	if (info->type > XT_AUDIT_TYPE_MAX) {
-		pr_info_ratelimited("Audit type out of range (valid range: 0..%hhu)\n",
+		pr_info_ratelimited("Audit type out of range (valid range: 0..%u)\n",
 				    XT_AUDIT_TYPE_MAX);
 		return -ERANGE;
 	}
-- 
2.30.2

