Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 741A259B81D
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 05:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232570AbiHVDoy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Aug 2022 23:44:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232533AbiHVDox (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Aug 2022 23:44:53 -0400
Received: from mail-m965.mail.126.com (mail-m965.mail.126.com [123.126.96.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F08E21DA40;
        Sun, 21 Aug 2022 20:44:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=8gltV
        +vzpxkeIlThBVdl+wrepht7HkRmfUlaR5myKzQ=; b=Mgst45uwvWmKFJcf562YY
        hEaBaGJEPUORBIZv/J8Z/N0/SvyTSzb6U4K9Yh4I6nWK+XaT/lTj6YoreLa5tU0r
        YZD/pt+JJ+Ecia71KDDwbv9rgy0qXu6YchDecwxHPJVFdtOPmPYjeT70vDjvFCVB
        6I7hwI8Oa0YXQsrsAJyEEI=
Received: from localhost.localdomain (unknown [39.99.236.58])
        by smtp10 (Coremail) with SMTP id NuRpCgB3XREH+wJjyV1lAQ--.42651S2;
        Mon, 22 Aug 2022 11:42:00 +0800 (CST)
From:   Hongbin Wang <wh_bin@126.com>
To:     steffen.klassert@secunet.com
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] xfrm: Drop unused argument
Date:   Sun, 21 Aug 2022 23:41:47 -0400
Message-Id: <20220822034147.2284570-1-wh_bin@126.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: NuRpCgB3XREH+wJjyV1lAQ--.42651S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxAFWUury7AFWrZFWxZr18Krg_yoW5GF4rpF
        WDG3s0krWDXw12kw1xGF48CF13try0kwsFkrWrC3sYk345K34ruw1rJryjvFySyw1rJrW7
        Xw4avrW8Ka1UJr7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UFQ6AUUUUU=
X-Originating-IP: [39.99.236.58]
X-CM-SenderInfo: xzkbuxbq6rjloofrz/1tbiGAhlolpEHvWnVQAAsQ
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drop unused argument from xfrm_policy_match,
__xfrm_policy_eval_candidates and xfrm_policy_eval_candidates.
No functional changes intended.

Signed-off-by: Hongbin Wang <wh_bin@126.com>
---
 net/xfrm/xfrm_policy.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index f1a0bab920a5..6264680b1f08 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -1889,7 +1889,7 @@ EXPORT_SYMBOL(xfrm_policy_walk_done);
  */
 static int xfrm_policy_match(const struct xfrm_policy *pol,
 			     const struct flowi *fl,
-			     u8 type, u16 family, int dir, u32 if_id)
+			     u8 type, u16 family, u32 if_id)
 {
 	const struct xfrm_selector *sel = &pol->selector;
 	int ret = -ESRCH;
@@ -2014,7 +2014,7 @@ static struct xfrm_policy *
 __xfrm_policy_eval_candidates(struct hlist_head *chain,
 			      struct xfrm_policy *prefer,
 			      const struct flowi *fl,
-			      u8 type, u16 family, int dir, u32 if_id)
+			      u8 type, u16 family, u32 if_id)
 {
 	u32 priority = prefer ? prefer->priority : ~0u;
 	struct xfrm_policy *pol;
@@ -2028,7 +2028,7 @@ __xfrm_policy_eval_candidates(struct hlist_head *chain,
 		if (pol->priority > priority)
 			break;
 
-		err = xfrm_policy_match(pol, fl, type, family, dir, if_id);
+		err = xfrm_policy_match(pol, fl, type, family, if_id);
 		if (err) {
 			if (err != -ESRCH)
 				return ERR_PTR(err);
@@ -2053,7 +2053,7 @@ static struct xfrm_policy *
 xfrm_policy_eval_candidates(struct xfrm_pol_inexact_candidates *cand,
 			    struct xfrm_policy *prefer,
 			    const struct flowi *fl,
-			    u8 type, u16 family, int dir, u32 if_id)
+			    u8 type, u16 family, u32 if_id)
 {
 	struct xfrm_policy *tmp;
 	int i;
@@ -2061,8 +2061,7 @@ xfrm_policy_eval_candidates(struct xfrm_pol_inexact_candidates *cand,
 	for (i = 0; i < ARRAY_SIZE(cand->res); i++) {
 		tmp = __xfrm_policy_eval_candidates(cand->res[i],
 						    prefer,
-						    fl, type, family, dir,
-						    if_id);
+						    fl, type, family, if_id);
 		if (!tmp)
 			continue;
 
@@ -2101,7 +2100,7 @@ static struct xfrm_policy *xfrm_policy_lookup_bytype(struct net *net, u8 type,
 
 	ret = NULL;
 	hlist_for_each_entry_rcu(pol, chain, bydst) {
-		err = xfrm_policy_match(pol, fl, type, family, dir, if_id);
+		err = xfrm_policy_match(pol, fl, type, family, if_id);
 		if (err) {
 			if (err == -ESRCH)
 				continue;
@@ -2120,7 +2119,7 @@ static struct xfrm_policy *xfrm_policy_lookup_bytype(struct net *net, u8 type,
 		goto skip_inexact;
 
 	pol = xfrm_policy_eval_candidates(&cand, ret, fl, type,
-					  family, dir, if_id);
+					  family, if_id);
 	if (pol) {
 		ret = pol;
 		if (IS_ERR(pol))
-- 
2.25.1

