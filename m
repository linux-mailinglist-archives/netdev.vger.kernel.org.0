Return-Path: <netdev+bounces-1300-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 504796FD38F
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 03:30:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 77E741C20CA1
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 01:30:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 111CE362;
	Wed, 10 May 2023 01:30:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3F3E62E
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 01:30:32 +0000 (UTC)
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA5DB1BD
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 18:30:31 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-b9a7766d220so8304405276.2
        for <netdev@vger.kernel.org>; Tue, 09 May 2023 18:30:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683682231; x=1686274231;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AB1/f/4Ej/u3wsSSyk1BEVQhWTqASTHaI5BeOULP+v8=;
        b=NyaAJPtVy2iGKNcoLpPLvQSezOa5WxZ83pPaZApr8dQ3+bK83W5vnTSSNZ4vSIoUs2
         d/inGRPh7wmQbmgXfVsrusLUIKcsYUJXW5jLy6b7Dpe+dfxMNvcLYXagUqUMBdS8pREU
         aH1Q+jP3KxkYCSBWJRTrl+OIpmrei4woQrlvf6DuDQJ+bzxde37HxJzi079NmuNNLerj
         s/x4Z3wPN0ByHCMEF1FRso+v1pl6ATO5w/eYA7axOPcZC+cXW4mfZCQ5A1c7kTZRjsf8
         ZVq0uIUyum5CC1qXZQfLvPIuRBSyNhfb/q4KX4/lIb+NGGEM/PEnusr6V78DVlyhJaKd
         6LPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683682231; x=1686274231;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AB1/f/4Ej/u3wsSSyk1BEVQhWTqASTHaI5BeOULP+v8=;
        b=H54sxmDjR+xqTXDF0Ijy90INhbBID0Dq0570y1xhCzOtBXhs+k07N855l9fuUSLHpi
         c3ygLMpYMI+wHj8jV5saQqlXbv4hnZpKh+59XnuY7xppyXA5rxwOBbmT1P+D62qapG7d
         bppDUlhKt5ZW+IiHtRjXn7sam/ce6WDU/WelW/W02RdtojK7Z6paommW3aANTs4u0p2b
         9tzArs5wM4jOu17xfqnxnSSZKrmaFoFUgdzrBACovlswViKA1bZ7qHKx0fJ8OBM8s+Tf
         DExdWeaMTlSXqEFuNIhtNkrc1yrcdvNdBjPzpgCeSrHCqE7Ny7CGjtmtvceM/QTgJCCQ
         6jrg==
X-Gm-Message-State: AC+VfDytAf1+2u/egB1ritact/I1+o1nCPgdhPLdJf31q+C79KUEvkw1
	3bbatPo8m39K/dFkkhbh3EZGyj7CTKdFgZBxsK8XAm0O00KwdMzJQrOmT+4zsI9v8G3fvzt9GLz
	TMFsKLF4fEXOSsyD/soC7WtrPWVkJ0YhMJU1P3sXdkNUyenh6tHUmHTwu6bZDcbvQymuR0kGCVm
	v7ig==
X-Google-Smtp-Source: ACHHUZ7X2Sz2AFaqy+zMnZd/50JAyLu5rn2Z+j5KkF221d9mkXC0KtKkomRPg2eifEyDSbV4IhQqC78evHNZZ2/k2BE=
X-Received: from obsessiveorange-c2.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1b95])
 (user=benedictwong job=sendgmr) by 2002:a05:6902:11c9:b0:b9d:ed0f:b9db with
 SMTP id n9-20020a05690211c900b00b9ded0fb9dbmr10100843ybu.6.1683682230930;
 Tue, 09 May 2023 18:30:30 -0700 (PDT)
Date: Wed, 10 May 2023 01:30:21 +0000
In-Reply-To: <20230510013022.2602474-1-benedictwong@google.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20230510013022.2602474-1-benedictwong@google.com>
X-Mailer: git-send-email 2.40.1.521.gf1e218fcd8-goog
Message-ID: <20230510013022.2602474-2-benedictwong@google.com>
Subject: [PATCH ipsec 1/2] xfrm: Treat already-verified secpath entries as optional
From: Benedict Wong <benedictwong@google.com>
To: netdev@vger.kernel.org, steffen.klassert@secunet.com, 
	martin@strongswan.org
Cc: nharold@google.com, benedictwong@google.com, evitayan@google.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This change allows inbound traffic through nested IPsec tunnels to
successfully match policies and templates, while retaining the secpath
stack trace as necessary for netfilter policies.

Specifically, this patch marks secpath entries that have already matched
against a relevant policy as having been verified, allowing it to be
treated as optional and skipped after a tunnel decapsulation (during
which the src/dst/proto/etc may have changed, and the correct policy
chain no long be resolvable).

This approach is taken as opposed to the iteration in b0355dbbf13c,
where the secpath was cleared, since that breaks subsequent validations
that rely on the existence of the secpath entries (netfilter policies, or
transport-in-tunnel mode, where policies remain resolvable).

Fixes: b0355dbbf13c ("Fix XFRM-I support for nested ESP tunnels")
Test: Tested against Android Kernel Unit Tests
Test: Tested against Android CTS
Signed-off-by: Benedict Wong <benedictwong@google.com>
---
 include/net/xfrm.h     |  1 +
 net/xfrm/xfrm_input.c  |  1 +
 net/xfrm/xfrm_policy.c | 12 ++++++++++++
 3 files changed, 14 insertions(+)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 3e1f70e8e424..47ecf1d4719b 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1049,6 +1049,7 @@ struct xfrm_offload {
 struct sec_path {
 	int			len;
 	int			olen;
+	int			verified_cnt;
 
 	struct xfrm_state	*xvec[XFRM_MAX_DEPTH];
 	struct xfrm_offload	ovec[XFRM_MAX_OFFLOAD_DEPTH];
diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
index 436d29640ac2..9f294a20dcec 100644
--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -131,6 +131,7 @@ struct sec_path *secpath_set(struct sk_buff *skb)
 	memset(sp->ovec, 0, sizeof(sp->ovec));
 	sp->olen = 0;
 	sp->len = 0;
+	sp->verified_cnt = 0;
 
 	return sp;
 }
diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 6d15788b5123..ff58ce6c030c 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -3349,6 +3349,13 @@ xfrm_policy_ok(const struct xfrm_tmpl *tmpl, const struct sec_path *sp, int star
 		if (xfrm_state_ok(tmpl, sp->xvec[idx], family, if_id))
 			return ++idx;
 		if (sp->xvec[idx]->props.mode != XFRM_MODE_TRANSPORT) {
+			if (idx < sp->verified_cnt) {
+				/* Secpath entry previously verified, consider optional and
+				 * continue searching
+				 */
+				continue;
+			}
+
 			if (start == -1)
 				start = -2-idx;
 			break;
@@ -3723,6 +3730,9 @@ int __xfrm_policy_check(struct sock *sk, int dir, struct sk_buff *skb,
 		 * Order is _important_. Later we will implement
 		 * some barriers, but at the moment barriers
 		 * are implied between each two transformations.
+		 * Upon success, marks secpath entries as having been
+		 * verified to allow them to be skipped in future policy
+		 * checks (e.g. nested tunnels).
 		 */
 		for (i = xfrm_nr-1, k = 0; i >= 0; i--) {
 			k = xfrm_policy_ok(tpp[i], sp, k, family, if_id);
@@ -3741,6 +3751,8 @@ int __xfrm_policy_check(struct sock *sk, int dir, struct sk_buff *skb,
 		}
 
 		xfrm_pols_put(pols, npols);
+		sp->verified_cnt = k;
+
 		return 1;
 	}
 	XFRM_INC_STATS(net, LINUX_MIB_XFRMINPOLBLOCK);
-- 
2.40.1.521.gf1e218fcd8-goog


