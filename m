Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83C55357E73
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 10:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230296AbhDHIxA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 04:53:00 -0400
Received: from m12-18.163.com ([220.181.12.18]:44653 "EHLO m12-18.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230211AbhDHIw6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 04:52:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=b5q0B
        ZMIyUtm8Qp3wgZ+qzq/qLDIUjP2PDeENPRELsw=; b=DEdP/EzlUA5ZoAoIlJuCj
        39Yj192OWfV8hUeOL4awyibgYFocOqYkSr3lxF/FIBjtQVSK6YgaEADByJIMcqeB
        zr4BjUTV+lf5DNJ6uqW3BgmOjrwadQKykzdOfg83QiKNT6BW+9or9fWD2SDRg+YC
        24htsy+fFxqf17q1kNfbPw=
Received: from localhost.localdomain (unknown [183.46.69.82])
        by smtp14 (Coremail) with SMTP id EsCowACHhfORw25giuVlcw--.64621S2;
        Thu, 08 Apr 2021 16:49:25 +0800 (CST)
From:   =?UTF-8?q?=C2=A0Zhongjun=20Tan?= <hbut_tan@163.com>
To:     steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, kuba@kernel.org, jmorris@namei.org,
        serge@hallyn.com, paul@paul-moore.com,
        stephen.smalley.work@gmail.com, eparis@parisplace.org,
        keescook@chromium.org, ebiederm@xmission.com,
        gregkh@linuxfoundation.org, dhowells@redhat.com,
        kpsingh@google.com, christian.brauner@ubuntu.com,
        zohar@linux.ibm.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        Zhongjun Tan <tanzhongjun@yulong.com>
Subject: [PATCH] selinux:Delete selinux_xfrm_policy_lookup()  useless argument
Date:   Thu,  8 Apr 2021 16:49:07 +0800
Message-Id: <20210408084907.841-1-hbut_tan@163.com>
X-Mailer: git-send-email 2.30.0.windows.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: EsCowACHhfORw25giuVlcw--.64621S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxtFWrWr43GrW7CrWkCrW5trb_yoW7GF48pF
        4DGFyUKr4UXa4UuFn7JFnruFnIg3yYka9rJrWkCw15tasrJr1rWws5JryakryFyrWUJFyI
        9w13CrZ5Gw45trDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jGZXrUUUUU=
X-Originating-IP: [183.46.69.82]
X-CM-SenderInfo: xkex3sxwdqqiywtou0bp/xtbBohVuxlaD-h7daQAAse
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhongjun Tan <tanzhongjun@yulong.com>

Delete selinux selinux_xfrm_policy_lookup() useless argument.

Signed-off-by: Zhongjun Tan <tanzhongjun@yulong.com>
---
 include/linux/lsm_hook_defs.h   | 3 +--
 include/linux/security.h        | 4 ++--
 net/xfrm/xfrm_policy.c          | 6 ++----
 security/security.c             | 4 ++--
 security/selinux/include/xfrm.h | 2 +-
 security/selinux/xfrm.c         | 2 +-
 6 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
index 04c0179..2adeea4 100644
--- a/include/linux/lsm_hook_defs.h
+++ b/include/linux/lsm_hook_defs.h
@@ -358,8 +358,7 @@
 	 struct xfrm_sec_ctx *polsec, u32 secid)
 LSM_HOOK(void, LSM_RET_VOID, xfrm_state_free_security, struct xfrm_state *x)
 LSM_HOOK(int, 0, xfrm_state_delete_security, struct xfrm_state *x)
-LSM_HOOK(int, 0, xfrm_policy_lookup, struct xfrm_sec_ctx *ctx, u32 fl_secid,
-	 u8 dir)
+LSM_HOOK(int, 0, xfrm_policy_lookup, struct xfrm_sec_ctx *ctx, u32 fl_secid)
 LSM_HOOK(int, 1, xfrm_state_pol_flow_match, struct xfrm_state *x,
 	 struct xfrm_policy *xp, const struct flowi_common *flic)
 LSM_HOOK(int, 0, xfrm_decode_session, struct sk_buff *skb, u32 *secid,
diff --git a/include/linux/security.h b/include/linux/security.h
index 06f7c50..24eda04 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -1681,7 +1681,7 @@ int security_xfrm_state_alloc_acquire(struct xfrm_state *x,
 				      struct xfrm_sec_ctx *polsec, u32 secid);
 int security_xfrm_state_delete(struct xfrm_state *x);
 void security_xfrm_state_free(struct xfrm_state *x);
-int security_xfrm_policy_lookup(struct xfrm_sec_ctx *ctx, u32 fl_secid, u8 dir);
+int security_xfrm_policy_lookup(struct xfrm_sec_ctx *ctx, u32 fl_secid);
 int security_xfrm_state_pol_flow_match(struct xfrm_state *x,
 				       struct xfrm_policy *xp,
 				       const struct flowi_common *flic);
@@ -1732,7 +1732,7 @@ static inline int security_xfrm_state_delete(struct xfrm_state *x)
 	return 0;
 }
 
-static inline int security_xfrm_policy_lookup(struct xfrm_sec_ctx *ctx, u32 fl_secid, u8 dir)
+static inline int security_xfrm_policy_lookup(struct xfrm_sec_ctx *ctx, u32 fl_secid)
 {
 	return 0;
 }
diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 156347f..d5d934e 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -1902,8 +1902,7 @@ static int xfrm_policy_match(const struct xfrm_policy *pol,
 
 	match = xfrm_selector_match(sel, fl, family);
 	if (match)
-		ret = security_xfrm_policy_lookup(pol->security, fl->flowi_secid,
-						  dir);
+		ret = security_xfrm_policy_lookup(pol->security, fl->flowi_secid);
 	return ret;
 }
 
@@ -2181,8 +2180,7 @@ static struct xfrm_policy *xfrm_sk_policy_lookup(const struct sock *sk, int dir,
 				goto out;
 			}
 			err = security_xfrm_policy_lookup(pol->security,
-						      fl->flowi_secid,
-						      dir);
+						      fl->flowi_secid);
 			if (!err) {
 				if (!xfrm_pol_hold_rcu(pol))
 					goto again;
diff --git a/security/security.c b/security/security.c
index b38155b..0c1c979 100644
--- a/security/security.c
+++ b/security/security.c
@@ -2466,9 +2466,9 @@ void security_xfrm_state_free(struct xfrm_state *x)
 	call_void_hook(xfrm_state_free_security, x);
 }
 
-int security_xfrm_policy_lookup(struct xfrm_sec_ctx *ctx, u32 fl_secid, u8 dir)
+int security_xfrm_policy_lookup(struct xfrm_sec_ctx *ctx, u32 fl_secid)
 {
-	return call_int_hook(xfrm_policy_lookup, 0, ctx, fl_secid, dir);
+	return call_int_hook(xfrm_policy_lookup, 0, ctx, fl_secid);
 }
 
 int security_xfrm_state_pol_flow_match(struct xfrm_state *x,
diff --git a/security/selinux/include/xfrm.h b/security/selinux/include/xfrm.h
index 0a6f34a..7415940 100644
--- a/security/selinux/include/xfrm.h
+++ b/security/selinux/include/xfrm.h
@@ -23,7 +23,7 @@ int selinux_xfrm_state_alloc_acquire(struct xfrm_state *x,
 				     struct xfrm_sec_ctx *polsec, u32 secid);
 void selinux_xfrm_state_free(struct xfrm_state *x);
 int selinux_xfrm_state_delete(struct xfrm_state *x);
-int selinux_xfrm_policy_lookup(struct xfrm_sec_ctx *ctx, u32 fl_secid, u8 dir);
+int selinux_xfrm_policy_lookup(struct xfrm_sec_ctx *ctx, u32 fl_secid);
 int selinux_xfrm_state_pol_flow_match(struct xfrm_state *x,
 				      struct xfrm_policy *xp,
 				      const struct flowi_common *flic);
diff --git a/security/selinux/xfrm.c b/security/selinux/xfrm.c
index 634f3db..be83e5c 100644
--- a/security/selinux/xfrm.c
+++ b/security/selinux/xfrm.c
@@ -150,7 +150,7 @@ static int selinux_xfrm_delete(struct xfrm_sec_ctx *ctx)
  * LSM hook implementation that authorizes that a flow can use a xfrm policy
  * rule.
  */
-int selinux_xfrm_policy_lookup(struct xfrm_sec_ctx *ctx, u32 fl_secid, u8 dir)
+int selinux_xfrm_policy_lookup(struct xfrm_sec_ctx *ctx, u32 fl_secid)
 {
 	int rc;
 
-- 
1.9.1


