Return-Path: <netdev+bounces-1297-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B0BA6FD375
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 03:14:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B9B6F1C20C5E
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 01:14:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 474E8387;
	Wed, 10 May 2023 01:14:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 378F1362
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 01:14:20 +0000 (UTC)
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA38949C1
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 18:14:18 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-ba22ced2e95so5123782276.1
        for <netdev@vger.kernel.org>; Tue, 09 May 2023 18:14:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683681258; x=1686273258;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=qOqGDzTkURO577fSp8WOhRoR3jJRideUr7iVGmeyqHs=;
        b=xedhgQH1kOQOp45XylLzsHR348koQkrD/gEj3zITMn82k/+QRF15uOHvwAqi2xcvTp
         AeIrjW02IPkZy9/gTP5HParySRgxB2TkPGJsQgU5xojtqX5698B+BANy5QFHQbT/ec8l
         L3QRR4R9QxGL16VvWqCrLpNxsAVbmvLjDend52SOlTquXDqFH901N14dZ70d75qgmDA/
         V3v1yQ/TrE4FEVhkofnFb9wnFUpFeHUroY8iD6cCBrVyk7Q5eGaUGQfmho+OCAaZ1wdi
         wcoM41dMYXIGIt/qTM8DG7nXKs6fX9fNHSc0CyC2FJruZqsDaMjGD2gzzpG0UGlerpmh
         WgAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683681258; x=1686273258;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qOqGDzTkURO577fSp8WOhRoR3jJRideUr7iVGmeyqHs=;
        b=A2jEhFzNoMicXMJ3yxkGgAFEJVYjWq4JQPtROpcCu4rO1kU+i8kWrxe0DiUxQvpkDr
         B2wa0rYfyAhEZOp7/A4OGoC3kfUKGWPadwkgTtiTjiqnc2m8vxkdeTbRrAgSpIn+58gI
         sBvXBVPO90ojxlgTbxmcLQ3A9sKcNZG7QUP24cvQ2LKkGydGwmDhkCMggG2VnuzHKvUB
         OjGw09iFHuxYfoXmmPflXhqWLAHSpjBtfQxrx5mtMLSi/UETYNoO6hfMYKqqsU45yp3B
         k/cV6Oc83734vfHpPTw7yiEQbKYDK0ta+sqOStIAmEUc7pSqaWBMKCQkRKxJ2z9s23j8
         8kvQ==
X-Gm-Message-State: AC+VfDzAxLF1KsAvQg0C2KItuhK5nGMdEzjbbX+i5mAlDJZ1m3n52cgq
	0CMpou912WJK585WSkRF+iTmN/OZrvGucIWQW3fwhDJBZQkaGmRQJaqxI/l1ZIfbrL8AKfpZ+Nr
	i85dGtAdvcqAyTeNgaoXSygKWp4TcFv4mecia9F1x0MHZn9Nmm64gP8hKVoepA2s1uoZlVsUbh8
	aMUw==
X-Google-Smtp-Source: ACHHUZ4b29aS05p7qErtc6eB8xmdp0mJFi/+jXKHX/Kk4QxXKU/ACaJWSWhNAcf4/a8PEWRnLzx0XgnvS4/rGLzLS38=
X-Received: from obsessiveorange-c2.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1b95])
 (user=benedictwong job=sendgmr) by 2002:a25:d897:0:b0:b9a:696a:770f with SMTP
 id p145-20020a25d897000000b00b9a696a770fmr10077298ybg.13.1683681258003; Tue,
 09 May 2023 18:14:18 -0700 (PDT)
Date: Wed, 10 May 2023 01:14:14 +0000
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.1.521.gf1e218fcd8-goog
Message-ID: <20230510011414.2599184-1-benedictwong@google.com>
Subject: [PATCH ipsec] xfrm: Check if_id in inbound policy/secpath match
From: Benedict Wong <benedictwong@google.com>
To: netdev@vger.kernel.org, steffen.klassert@secunet.com
Cc: nharold@google.com, benedictwong@google.com, evitayan@google.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This change ensures that if configured in the policy, the if_id set in
the policy and secpath states match during the inbound policy check.
Without this, there is potential for ambiguity where entries in the
secpath differing by only the if_id could be mismatched.

Notably, this is checked in the outbound direction when resolving
templates to SAs, but not on the inbound path when matching SAs and
policies.

Test: Tested against Android kernel unit tests & CTS
Signed-off-by: Benedict Wong <benedictwong@google.com>
---
 net/xfrm/xfrm_policy.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 21a3a1cd3d6d..6d15788b5123 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -3312,7 +3312,7 @@ xfrm_secpath_reject(int idx, struct sk_buff *skb, const struct flowi *fl)
 
 static inline int
 xfrm_state_ok(const struct xfrm_tmpl *tmpl, const struct xfrm_state *x,
-	      unsigned short family)
+	      unsigned short family, u32 if_id)
 {
 	if (xfrm_state_kern(x))
 		return tmpl->optional && !xfrm_state_addr_cmp(tmpl, x, tmpl->encap_family);
@@ -3323,7 +3323,8 @@ xfrm_state_ok(const struct xfrm_tmpl *tmpl, const struct xfrm_state *x,
 		(tmpl->allalgs || (tmpl->aalgos & (1<<x->props.aalgo)) ||
 		 !(xfrm_id_proto_match(tmpl->id.proto, IPSEC_PROTO_ANY))) &&
 		!(x->props.mode != XFRM_MODE_TRANSPORT &&
-		  xfrm_state_addr_cmp(tmpl, x, family));
+		  xfrm_state_addr_cmp(tmpl, x, family)) &&
+		(if_id == 0 || if_id == x->if_id);
 }
 
 /*
@@ -3335,7 +3336,7 @@ xfrm_state_ok(const struct xfrm_tmpl *tmpl, const struct xfrm_state *x,
  */
 static inline int
 xfrm_policy_ok(const struct xfrm_tmpl *tmpl, const struct sec_path *sp, int start,
-	       unsigned short family)
+	       unsigned short family, u32 if_id)
 {
 	int idx = start;
 
@@ -3345,7 +3346,7 @@ xfrm_policy_ok(const struct xfrm_tmpl *tmpl, const struct sec_path *sp, int star
 	} else
 		start = -1;
 	for (; idx < sp->len; idx++) {
-		if (xfrm_state_ok(tmpl, sp->xvec[idx], family))
+		if (xfrm_state_ok(tmpl, sp->xvec[idx], family, if_id))
 			return ++idx;
 		if (sp->xvec[idx]->props.mode != XFRM_MODE_TRANSPORT) {
 			if (start == -1)
@@ -3724,7 +3725,7 @@ int __xfrm_policy_check(struct sock *sk, int dir, struct sk_buff *skb,
 		 * are implied between each two transformations.
 		 */
 		for (i = xfrm_nr-1, k = 0; i >= 0; i--) {
-			k = xfrm_policy_ok(tpp[i], sp, k, family);
+			k = xfrm_policy_ok(tpp[i], sp, k, family, if_id);
 			if (k < 0) {
 				if (k < -1)
 					/* "-2 - errored_index" returned */
-- 
2.40.1.521.gf1e218fcd8-goog


