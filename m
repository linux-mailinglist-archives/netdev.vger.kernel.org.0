Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C45EF27DB29
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 23:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728391AbgI2Vyl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 17:54:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727740AbgI2Vyk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 17:54:40 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 892FDC0613D0
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 14:54:40 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id x201so5660128qkb.11
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 14:54:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=xHo033oar0KgYc4e1ROf65XOwizUiV3znFMSkSu+y78=;
        b=pU+wH0opGREdfVhc3VSiSME5TJWZYmy/jOWNVDwwtSS5v6hYxIdKLs0rpmZs1XmjUx
         w+vtdrFion68m7I360d33S6IkOnmXMIK3sYDtMzdmb/YVsX1lrDjxcqgUROfYWyvC2T+
         HJuEdM3x7yI7Ttqm+kQdzbSC6/3e54kFH6EFas/uy037Nxu5q/8EKKFV0GATrJBLgp2F
         lO6baOWhOQGzuqwVXvCJi+xfw5tz49QTqjCmjZgMVfrlJHu4Frkrt+u61HA0F5adV9N9
         PRR1j5iABgdkGsS23Kl3Lpxvgw8CwiJ8km7Ox/rlwPdPDom/WmSVWGIW1sdDs788eguG
         GtNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=xHo033oar0KgYc4e1ROf65XOwizUiV3znFMSkSu+y78=;
        b=qqjvrNVmhA/IGA9LeAujG7RZYURQCyNEtH/DiPSbVCFvVrQozIwa55dhV/IE/bqB5g
         1v7wCnDjIXuySADyGunG82Pk5CKSMgUK0te94Aq4qPY+VBtraI4L1oSi0dokYk409G7t
         tURgflVIyTDrGzADSNrQM/5xjoR1AU9sDN2EcU4BL1EfweU8wRgVwRWOGMda4B5sKtH7
         WLgfbTE/CyU3vvR0MQDQJSflTituC7+zTLeh+qBwnMciYVV4ngjSje5Yu/ziHDMeM7Zd
         U7/UCTpNzfY55UEuKZ0WuqjyAfm/23Wl5HKqnRo4tbbZpFKuPbwuAgjSCTllDtRFdOnB
         TSIA==
X-Gm-Message-State: AOAM530C6se6TY5tHaSZud0HhP5PQULS77UkduXL8WY61d6xc0fL6xCM
        11EGDwX22uu7sm0v+qqm2d8N
X-Google-Smtp-Source: ABdhPJw/6NYT2k3x6xGaYNBrYodwIdaQqNXOTPmefZeuiRKMRPi60CfDM1jnBuTF6NOsQPWaOfgVWw==
X-Received: by 2002:a37:4e45:: with SMTP id c66mr6729503qkb.36.1601416479560;
        Tue, 29 Sep 2020 14:54:39 -0700 (PDT)
Received: from localhost (pool-96-230-24-152.bstnma.fios.verizon.net. [96.230.24.152])
        by smtp.gmail.com with ESMTPSA id z131sm6251880qkb.59.2020.09.29.14.54.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2020 14:54:38 -0700 (PDT)
Subject: [RFC PATCH] lsm,selinux: pass the family information along with xfrm
 flow
From:   Paul Moore <paul@paul-moore.com>
To:     selinux@vger.kernel.org, linux-security-module@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>, netdev@vger.kernel.org
Date:   Tue, 29 Sep 2020 17:54:37 -0400
Message-ID: <160141647786.7997.5490924406329369782.stgit@sifl>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As pointed out by Herbert in a recent related patch, the LSM hooks
should pass the address family in addition to the xfrm flow as the
family information is needed to safely access the flow.

While this is not technically a problem for the current LSM/SELinux
code as it only accesses fields common to all address families, we
should still pass the address family so that the LSM hook isn't
inherently flawed.  An alternate solution could be to simply pass
the LSM secid instead of flow, but this introduces the problem of
the LSM hook callers sending the wrong secid which would be much
worse.

Reported-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Paul Moore <paul@paul-moore.com>
---
 include/linux/lsm_hook_defs.h   |    2 +-
 include/linux/lsm_hooks.h       |    1 +
 include/linux/security.h        |    7 +++++--
 net/xfrm/xfrm_state.c           |    4 ++--
 security/security.c             |    5 +++--
 security/selinux/include/xfrm.h |    3 ++-
 security/selinux/xfrm.c         |    3 ++-
 7 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
index 2a8c74d99015..e3c3b5d20469 100644
--- a/include/linux/lsm_hook_defs.h
+++ b/include/linux/lsm_hook_defs.h
@@ -349,7 +349,7 @@ LSM_HOOK(int, 0, xfrm_state_delete_security, struct xfrm_state *x)
 LSM_HOOK(int, 0, xfrm_policy_lookup, struct xfrm_sec_ctx *ctx, u32 fl_secid,
 	 u8 dir)
 LSM_HOOK(int, 1, xfrm_state_pol_flow_match, struct xfrm_state *x,
-	 struct xfrm_policy *xp, const struct flowi *fl)
+	 struct xfrm_policy *xp, const struct flowi *fl, unsigned short family)
 LSM_HOOK(int, 0, xfrm_decode_session, struct sk_buff *skb, u32 *secid,
 	 int ckall)
 #endif /* CONFIG_SECURITY_NETWORK_XFRM */
diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
index 9e2e3e63719d..ea088aacfdad 100644
--- a/include/linux/lsm_hooks.h
+++ b/include/linux/lsm_hooks.h
@@ -1093,6 +1093,7 @@
  *	@x contains the state to match.
  *	@xp contains the policy to check for a match.
  *	@fl contains the flow to check for a match.
+ *	@family the flow's address family.
  *	Return 1 if there is a match.
  * @xfrm_decode_session:
  *	@skb points to skb to decode.
diff --git a/include/linux/security.h b/include/linux/security.h
index 0a0a03b36a3b..701b41eb090c 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -1625,7 +1625,8 @@ void security_xfrm_state_free(struct xfrm_state *x);
 int security_xfrm_policy_lookup(struct xfrm_sec_ctx *ctx, u32 fl_secid, u8 dir);
 int security_xfrm_state_pol_flow_match(struct xfrm_state *x,
 				       struct xfrm_policy *xp,
-				       const struct flowi *fl);
+				       const struct flowi *fl,
+				       unsigned short family);
 int security_xfrm_decode_session(struct sk_buff *skb, u32 *secid);
 void security_skb_classify_flow(struct sk_buff *skb, struct flowi *fl);
 
@@ -1679,7 +1680,9 @@ static inline int security_xfrm_policy_lookup(struct xfrm_sec_ctx *ctx, u32 fl_s
 }
 
 static inline int security_xfrm_state_pol_flow_match(struct xfrm_state *x,
-			struct xfrm_policy *xp, const struct flowi *fl)
+						     struct xfrm_policy *xp,
+						     const struct flowi *fl,
+						     unsigned short family)
 {
 	return 1;
 }
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 69520ad3d83b..f90d2f1da44a 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -1020,7 +1020,7 @@ static void xfrm_state_look_at(struct xfrm_policy *pol, struct xfrm_state *x,
 	if (x->km.state == XFRM_STATE_VALID) {
 		if ((x->sel.family &&
 		     !xfrm_selector_match(&x->sel, fl, x->sel.family)) ||
-		    !security_xfrm_state_pol_flow_match(x, pol, fl))
+		    !security_xfrm_state_pol_flow_match(x, pol, fl, family))
 			return;
 
 		if (!*best ||
@@ -1033,7 +1033,7 @@ static void xfrm_state_look_at(struct xfrm_policy *pol, struct xfrm_state *x,
 	} else if (x->km.state == XFRM_STATE_ERROR ||
 		   x->km.state == XFRM_STATE_EXPIRED) {
 		if (xfrm_selector_match(&x->sel, fl, x->sel.family) &&
-		    security_xfrm_state_pol_flow_match(x, pol, fl))
+		    security_xfrm_state_pol_flow_match(x, pol, fl, family))
 			*error = -ESRCH;
 	}
 }
diff --git a/security/security.c b/security/security.c
index 70a7ad357bc6..62dd0af7c6bc 100644
--- a/security/security.c
+++ b/security/security.c
@@ -2391,7 +2391,8 @@ int security_xfrm_policy_lookup(struct xfrm_sec_ctx *ctx, u32 fl_secid, u8 dir)
 
 int security_xfrm_state_pol_flow_match(struct xfrm_state *x,
 				       struct xfrm_policy *xp,
-				       const struct flowi *fl)
+				       const struct flowi *fl,
+				       unsigned short family)
 {
 	struct security_hook_list *hp;
 	int rc = LSM_RET_DEFAULT(xfrm_state_pol_flow_match);
@@ -2407,7 +2408,7 @@ int security_xfrm_state_pol_flow_match(struct xfrm_state *x,
 	 */
 	hlist_for_each_entry(hp, &security_hook_heads.xfrm_state_pol_flow_match,
 				list) {
-		rc = hp->hook.xfrm_state_pol_flow_match(x, xp, fl);
+		rc = hp->hook.xfrm_state_pol_flow_match(x, xp, fl, family);
 		break;
 	}
 	return rc;
diff --git a/security/selinux/include/xfrm.h b/security/selinux/include/xfrm.h
index a0b465316292..36907dd06647 100644
--- a/security/selinux/include/xfrm.h
+++ b/security/selinux/include/xfrm.h
@@ -26,7 +26,8 @@ int selinux_xfrm_state_delete(struct xfrm_state *x);
 int selinux_xfrm_policy_lookup(struct xfrm_sec_ctx *ctx, u32 fl_secid, u8 dir);
 int selinux_xfrm_state_pol_flow_match(struct xfrm_state *x,
 				      struct xfrm_policy *xp,
-				      const struct flowi *fl);
+				      const struct flowi *fl,
+				      unsigned short family);
 
 #ifdef CONFIG_SECURITY_NETWORK_XFRM
 extern atomic_t selinux_xfrm_refcount;
diff --git a/security/selinux/xfrm.c b/security/selinux/xfrm.c
index 7314196185d1..5beb30237d3a 100644
--- a/security/selinux/xfrm.c
+++ b/security/selinux/xfrm.c
@@ -175,7 +175,8 @@ int selinux_xfrm_policy_lookup(struct xfrm_sec_ctx *ctx, u32 fl_secid, u8 dir)
  */
 int selinux_xfrm_state_pol_flow_match(struct xfrm_state *x,
 				      struct xfrm_policy *xp,
-				      const struct flowi *fl)
+				      const struct flowi *fl,
+				      unsigned short family)
 {
 	u32 state_sid;
 

