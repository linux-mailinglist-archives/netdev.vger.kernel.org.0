Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F262397C23
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 00:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235005AbhFAWIa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 18:08:30 -0400
Received: from mail.netfilter.org ([217.70.188.207]:39552 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234922AbhFAWIU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 18:08:20 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 91AB164194;
        Wed,  2 Jun 2021 00:05:31 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 07/16] netfilter: xt_CT: Remove redundant assignment to ret
Date:   Wed,  2 Jun 2021 00:06:20 +0200
Message-Id: <20210601220629.18307-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210601220629.18307-1-pablo@netfilter.org>
References: <20210601220629.18307-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yang Li <yang.lee@linux.alibaba.com>

Variable 'ret' is set to zero but this value is never read as it is
overwritten with a new value later on, hence it is a redundant
assignment and can be removed

Clean up the following clang-analyzer warning:

net/netfilter/xt_CT.c:175:2: warning: Value stored to 'ret' is never read [clang-analyzer-deadcode.DeadStores]

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_CT.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/netfilter/xt_CT.c b/net/netfilter/xt_CT.c
index d4deee39158b..12404d221026 100644
--- a/net/netfilter/xt_CT.c
+++ b/net/netfilter/xt_CT.c
@@ -172,7 +172,6 @@ static int xt_ct_tg_check(const struct xt_tgchk_param *par,
 		goto err2;
 	}
 
-	ret = 0;
 	if ((info->ct_events || info->exp_events) &&
 	    !nf_ct_ecache_ext_add(ct, info->ct_events, info->exp_events,
 				  GFP_KERNEL)) {
-- 
2.30.2

