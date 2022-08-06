Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C523C58B3D8
	for <lists+netdev@lfdr.de>; Sat,  6 Aug 2022 06:43:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237027AbiHFEnh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Aug 2022 00:43:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237074AbiHFEne (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Aug 2022 00:43:34 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ACF918E23
        for <netdev@vger.kernel.org>; Fri,  5 Aug 2022 21:43:33 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id t9-20020a056a00138900b0052dc8a1b97dso2033281pfg.2
        for <netdev@vger.kernel.org>; Fri, 05 Aug 2022 21:43:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=ksj5htphiHNaE181xzXeGA/bCeETxlKD0FLY5gM8ThQ=;
        b=sYDrcxFstUMZVY+6cEu6wjNfTACFuZw368gb/teDZTgV0YLr9aFdkRpKOdGOscuEsR
         Xq5ise8QTyrXZJw1FDp4joGAKXEfjvgKvA112uaWfr02kKh/OvW8GN2lA42Uw5LoPniN
         Uw4HCuJ0dykfRjDCxXB3oVyb5DF4kwgOhRnhzx+2tBNqM7ZQpVVpNl4nKXvD0LTvH1AT
         dgFvNK1QctXV4nTL6tcU3wx4RoBFGByORU1a7GpVeGk7Bg1MGimOhudGwRpzTNjikmnj
         lfIyjwyb+vuHyMbfE3M1Sbym5wsMhb8yaJWMhm2UCWNy1F8IimB17fF9XCDAQ04qiDRc
         uMdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=ksj5htphiHNaE181xzXeGA/bCeETxlKD0FLY5gM8ThQ=;
        b=RhaxvCFhHZ8z3amct/qsk5zFgP6XtwVyiE6oDUUsC3Z2fEpsi/S3p7nxb8Q70uqCSS
         GMgeRyUlOeAKwjDSLRECM/8ENPUITr5YIWlrzztF/nnzMRJDAEtX9XqGAIV6HS9m9QtT
         2Mx9+Uu82EuTxP59Xfu6VFdqq5g+ZiHjMjFbz5PZV8th3sJeCA8iDXMk8BA6zvozMX/p
         Gi2YLiaD2MzyIu9OvppU54fSUyfZVCK+xIYHKlSW03UhhVzGpgdsxXpkkspwAT4HuZaV
         TFwEYLc1yMhicoxDLRu+Fu8C8g2w2nKYF3xy/Jz5U8wrFJ5ujGGhaYRrnHKp3p1FsYsn
         YNzg==
X-Gm-Message-State: ACgBeo2pRz8Zfi7cohGwSBZESLvNxAxNhr807IFO/MwoKZZuhCLKUMy2
        enxjE+Ampz/cVE7Zqe9K0uRUwYslCmZUUfLN9/000ugEq21XeBO7Kh8TnOGb6nXc+uvZXJ2kvC2
        ILP565vZKBEJmzDNfOYNkZ5W8Fhaa6AvE8ni6tqFo5UJEIjtrikhbIsx3hFldm8Fu26PfX3vDnp
        nDuw==
X-Google-Smtp-Source: AA6agR6ZXanUI9MjWXF8u4khm4tcLTYmdcWeYiBTvUCfe2qRBVOUwi4enPp7LIfKc9V7jHYW+5MfqeKPuTBxCP16psU=
X-Received: from obsessiveorange-c1.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3039])
 (user=benedictwong job=sendgmr) by 2002:aa7:982f:0:b0:52d:9787:c5c5 with SMTP
 id q15-20020aa7982f000000b0052d9787c5c5mr9846711pfl.24.1659761012388; Fri, 05
 Aug 2022 21:43:32 -0700 (PDT)
Reply-To: Benedict Wong <benedictwong@google.com>
Date:   Sat,  6 Aug 2022 04:43:07 +0000
In-Reply-To: <20220806044307.4007851-1-benedictwong@google.com>
Message-Id: <20220806044307.4007851-3-benedictwong@google.com>
Mime-Version: 1.0
References: <20220806044307.4007851-1-benedictwong@google.com>
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
Subject: [RFC ipsec 2/2] xfrm: Skip checking of already-verified secpath entries
From:   Benedict Wong <benedictwong@google.com>
To:     netdev@vger.kernel.org
Cc:     nharold@google.com, benedictwong@google.com, lorenzo@google.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change fixes a bug where inbound packets to nested IPsec tunnels
fails to pass policy checks due to the inner tunnel's policy checks
not having a reference to the outer policy/template. This causes the
policy check to fail, since the first entries in the secpath correlate
to the outer tunnel, while the templates being verified are for the
inner tunnel.

In order to ensure that the appropriate policy and template context is
searchable, the policy checks must be done incrementally after each
decryption step. As such, this marks secpath entries as having been
successfully matched, skipping these on subsequent policy checks.

By skipping the immediate error return in the case where the secpath
entry had previously been validated, this change allows secpath entries
that matched a policy/template previously, while still requiring that
each searched template find a match in the secpath.

For security:
- All templates must have matching secpath entries
  - Unchanged by current patch; templates that do not match any secpath
    entry still return -1. This patch simply allows skipping earlier
    blocks of verified secpath entries
- All entries (except trailing transport mode entries) must have a
  matching template
  - Unvalidated entries, including transport-mode entries still return
    the errored index if it does not match the correct template.

Test: Tested against Android Kernel Unit Tests
Signed-off-by: Benedict Wong <benedictwong@google.com>
Change-Id: Ic32831cb00151d0de2e465f18ec37d5f7b680e54
---
 include/net/xfrm.h     |  1 +
 net/xfrm/xfrm_input.c  |  3 ++-
 net/xfrm/xfrm_policy.c | 11 ++++++++++-
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index c39d910d4b45..a2f2840aba6b 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1031,6 +1031,7 @@ struct xfrm_offload {
 struct sec_path {
 	int			len;
 	int			olen;
+	int			verified_cnt;
 
 	struct xfrm_state	*xvec[XFRM_MAX_DEPTH];
 	struct xfrm_offload	ovec[XFRM_MAX_OFFLOAD_DEPTH];
diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
index b24df8a44585..895935077a91 100644
--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -129,6 +129,7 @@ struct sec_path *secpath_set(struct sk_buff *skb)
 	memset(sp->ovec, 0, sizeof(sp->ovec));
 	sp->olen = 0;
 	sp->len = 0;
+	sp->verified_cnt = 0;
 
 	return sp;
 }
@@ -587,7 +588,7 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 
 		// If nested tunnel, check outer states before context is lost.
 		if (x->outer_mode.flags & XFRM_MODE_FLAG_TUNNEL
-				&& sp->len > 0
+				&& sp->len > sp->verified_cnt
 				&& !xfrm_policy_check(NULL, XFRM_POLICY_IN, skb, family)) {
 			goto drop;
 		}
diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index f1a0bab920a5..ee620a856c6f 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -3261,7 +3261,7 @@ xfrm_state_ok(const struct xfrm_tmpl *tmpl, const struct xfrm_state *x,
  */
 static inline int
 xfrm_policy_ok(const struct xfrm_tmpl *tmpl, const struct sec_path *sp, int start,
-	       unsigned short family)
+			   unsigned short family)
 {
 	int idx = start;
 
@@ -3274,6 +3274,11 @@ xfrm_policy_ok(const struct xfrm_tmpl *tmpl, const struct sec_path *sp, int star
 		if (xfrm_state_ok(tmpl, sp->xvec[idx], family))
 			return ++idx;
 		if (sp->xvec[idx]->props.mode != XFRM_MODE_TRANSPORT) {
+			if (idx < sp->verified_cnt) {
+				// Secpath entry previously verified, continue searching
+				continue;
+			}
+
 			if (start == -1)
 				start = -2-idx;
 			break;
@@ -3650,6 +3655,8 @@ int __xfrm_policy_check(struct sock *sk, int dir, struct sk_buff *skb,
 		 * Order is _important_. Later we will implement
 		 * some barriers, but at the moment barriers
 		 * are implied between each two transformations.
+		 * Skips verifying secpath entries that have already been
+		 * verified in the past.
 		 */
 		for (i = xfrm_nr-1, k = 0; i >= 0; i--) {
 			k = xfrm_policy_ok(tpp[i], sp, k, family);
@@ -3668,6 +3675,8 @@ int __xfrm_policy_check(struct sock *sk, int dir, struct sk_buff *skb,
 		}
 
 		xfrm_pols_put(pols, npols);
+		sp->verified_cnt = k;
+
 		return 1;
 	}
 	XFRM_INC_STATS(net, LINUX_MIB_XFRMINPOLBLOCK);
-- 
2.37.1.559.g78731f0fdb-goog

