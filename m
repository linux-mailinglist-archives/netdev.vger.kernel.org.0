Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9179488D1F
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 00:17:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237423AbiAIXRD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 18:17:03 -0500
Received: from mail.netfilter.org ([217.70.188.207]:42112 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237404AbiAIXQ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 18:16:58 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id AA342607C1;
        Mon, 10 Jan 2022 00:14:06 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 12/32] netfilter: conntrack: Use max() instead of doing it manually
Date:   Mon, 10 Jan 2022 00:16:20 +0100
Message-Id: <20220109231640.104123-13-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220109231640.104123-1-pablo@netfilter.org>
References: <20220109231640.104123-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

Fix following coccicheck warning:

./include/net/netfilter/nf_conntrack.h:282:16-17: WARNING opportunity
for max().

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 871489df63c6..a4a14f3a5e38 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -279,7 +279,7 @@ static inline unsigned long nf_ct_expires(const struct nf_conn *ct)
 {
 	s32 timeout = READ_ONCE(ct->timeout) - nfct_time_stamp;
 
-	return timeout > 0 ? timeout : 0;
+	return max(timeout, 0);
 }
 
 static inline bool nf_ct_is_expired(const struct nf_conn *ct)
-- 
2.30.2

