Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9C17503096
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 01:09:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354802AbiDOVZX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 17:25:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353959AbiDOVY1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 17:24:27 -0400
Received: from sonic305-28.consmr.mail.ne1.yahoo.com (sonic305-28.consmr.mail.ne1.yahoo.com [66.163.185.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33F46D557D
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 14:21:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1650057699; bh=KzbFwwhuwjYfTBU4tfTxK1dAwBTSVWuzxkwCQg5qsUw=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=hSiJfrWFbHdl9LZfihf5S2AllUB5Qm7fOY1kkQw686UfN/qntdyQrepvqmGKxfWCIN48ZY0Q7fhoaEGNua5S/VCYrf/yuS/tiHmuVhnQFmqNHuaSigeXZQkg6Fj/vM9pekjYisjJ7rcTqbKmbBZ8x+dBxhLsj/w+2e/fay6ovP8/3YCOLie3e+aXz+QHZsd+yYWtUpALrTYkzFOBb17O2SkCoBRTdK8j8cLgHUbE0d7Z8SEjt+TrslbFxnxrk+6cX9cpdVOXlKvB4sUUam5Lo46L3H+xf+FzalsyKVATuJ6sQ/0THk1cx9hHFl9OnrEhZrpUm2syTEthdIxt4xiOTA==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1650057699; bh=mVf3QpWqgRjD+PbmoMDGV6gWcwVi0wKV73OxI+rp4Ox=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=ioclYtID+oEIQ1WYd555hBg30Ic/x/tEz0mXXR6HgcVtZmIV8/2jqHIyczOYa3eg0m/gCMIN5pdiXiUxaymT9Zf+TwQU75rooAouB9PbSQtyDlmXLlj7QqAl237HdMyyKot1OsTviCk8csmqhczb8J2Y8+Rwr3+8Rf9leYJrL7KutFGTDEyLr7TGi+hBdQnbiI5pAmDpbX7ZJZeWu2vfoffqzSymVr3oeD1VBbPHC0sEgCA6BwMSjzWWjwGiqCijov1a+MEDdSP2D/nPtm208D7Osr+dbdrC5tZDBYmUqzQDjkpkqeUPc9teXzU+SUh/2+k8buqxNauKjJhSqZlmzw==
X-YMail-OSG: aIXsmEEVM1k05ipWROgmw4DdM0fAIMtlMj_x9XSOp030ZAqEqSen.2SOgMrPgQB
 r0aSqB8QU._hWWYecQD09iOwjYmJ1CU9iPhPNUxIBurTXYyeBSvCD0M_ouTt7vDFWO1.n17amyD7
 Gq08iqe1xYujmhj277uCwHseSiDPSc3NOYdPxEa1s4puyc_6WZk5PmspZbY3ZT7nxcRPgzP0e7pa
 4hK7SCgvfDzRUCp6iJuQ1zzyu8e5Vv9ev7rhJzzgON9E5FSESQEOaHrlgvWeKL3XqmREX77bzyi0
 zoisxBMrz18yzAIzfuRBPvYz_TMNWKl4X15rJTDeH8Mj3gDeVvcNi1lDme0ciuCAGdyx1BZUb2tQ
 Jax5aFmXnQwWzkrOSw706LPJfZID7MU0zLtx_OY.0Sy0wBstvBKJ3NXHeQ6I4_07rbaEqDS_yKMF
 _gYml.8vFvhTu5BpBIgJ1s80FF508BVkWVH_CxkgfjYfu3SOXXeIvXzbQI6RgjVSLD35visIBuAV
 zO528D5xZYr_6P5RZUwoOJfNJTKeU8BSibYdhTIdNpSBQ7d2OVFyZyPUatqpKksJ3DUrpRKkozsl
 RpFCU0AyZgQz0NtQKBPgMFZhYAOWgulFzWxSaOsvF2NcqaYYrqUpAjFxzjgOqssa9NSezDwS.zF8
 BpscLvKDdzFgDV47CiN07l0RoIm7yOPq__7JWSqVQmFPzupt.z7NRH02zDGz.AcejofU3bQmmZVq
 iUG11J8KOWqgDmSPptSohaON.6MpRtBkyrfVyDqPuNAuOA4mmDRghaRNI5zxjK7JyI33dTpukSjx
 _jogT.Ii4LAn4pKr3ZpiHvvGcgmX0n5AHwMQdgtKALuLnr.gOtu72mRmVmNBtTI1oN140XbQgYhy
 dQ3aa_9H_z7BsmjhPRse1bEIgtSvDBY4OCMe2POoz4D93J79ChOAW8VIrM4vdCLjoGuSjn.FmgqK
 iQvu5GZBFdmHVSZGUa32BT9p51Ekko34EFdsCdDapkog71Ee6zFOemuajxMGSF6.lphG_jdp180K
 Q85gQ4AxQ0xy7f9nZ6wAW0kOzb7NCixOCiQbXk.X9k1N33EOTDkhFpMoL.9wuqHJ6i8GtfKqwnVk
 3PFUcx6qhXqfFeNG2btIIcLNt_HdFMVe532.7aa3wknNOlT0_StWSglZuPa1FwhRORyopHrxxwYE
 WdO1GKtsA80PmYkt86xqO3njYb2EFx80T6.alDbrWs52UaPEpZw2EqbqdiuLI_GPlIs97sRkFQzb
 z9HyTM9dI0hwK4mxRlrkeac0iOknFEpMzkFo.oZCSBTKJpFbHdacGtxr3KpniL3mg8fOwOLK6hpf
 jRHtVi37zDRYEdtbsHYaIbLA_tZ3iEX.J3FIPspl8hbjPHUErH6f.VbZdJmLJ2uRrji02D7jdn8i
 BfwoFf.PFRTRa9v6W3hEP7VkmX1H8cskpTS8M7m8MhDViezKmOJaGpzhMWVPxgB806VeZ3mNnvZc
 ZxcmeroSfIlyo9s8_Z5JZ0kPwAVhp0Hbzq8GgAi70iVoG272orvqBQh1fOByQ18WX31YzvqZCoYX
 APKavoxzzMQwvZizcNJVAwaPyN9wW8ejcbbvv.bXQrnpXu5V51KQb8XlYzYG9YvBMnGF.mlxRKF4
 Irz.kMZ.9IRNJcV0C1yB_q9vg2QlkQ61TKAarS2T49o7oab.iCohUkQ164WF6gcrwFLyreV4eAYe
 FxAOvEr5YuDg6xRDk9GsyPRr3A96vg_yzk1ArpUYWcZnlaQ2pA9MTXv.bsnZ9XUB5ySC647ftUjS
 dAJWAzw8640SsyYCwTjylLznPtjYWKlzuX4v_y8RBB28CBN3LxUd7PwhLZ5ojU6vwH0Vt3teXZkp
 .Xf5nXEiDpsFdbsYMjrNRZXimvS2ZLb7SQ5R8o2jb9ktOXQxUv3HWQZFN326xMQlzA2GSBqmnBfC
 JGNAQs7t.j7t7lbj5rxPJekRDIl_fKDe9XkkeehF13bQvc1caVvWH3BS9x0hhRHffbtyjehL.WZ6
 5qf4ZQgKW_PQPOS9AGqz98nTlaw.6OMWfrBg6jqT0vtlAnb0tA81XU5Atd7Sg7vvREn3FQC4qqT3
 t6LVqdMfmO8ldI.xP51qLFYDwk6voR8OIqNv3wKEvI1WRNwKhMJtzaB0Rw6HZVGrLRtAlDxRVBvD
 bOhgwJMAU5d6DKMD1Gk4YTFBlgJqnnyt5r3HTvnvX57zLBFP7r7RKkQWXgGizDJuAbIrFUlyNuiK
 CO2CDuz9h.70YHcafYkPS1UR.lpBt7l.6GwL.wYcLARh3AuB.xBnr2cLyd3pwVJAW1EJRoA9Pcaw
 XjdRcl1P7WN.4h.GxEhbcTcEx9HLeXXWhpMFIN4obsm23BejgWKbxwKiDh_bINSgYWI9y4MoVeQ-
 -
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic305.consmr.mail.ne1.yahoo.com with HTTP; Fri, 15 Apr 2022 21:21:39 +0000
Received: by hermes--canary-production-bf1-5f49dbcd6-b5q4c (VZM Hermes SMTP Server) with ESMTPA ID c91982c747db758d7776974a874b1b0e;
          Fri, 15 Apr 2022 21:21:33 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     casey@schaufler-ca.com, linux-audit@redhat.com,
        keescook@chromium.org, john.johansen@canonical.com,
        penguin-kernel@i-love.sakura.ne.jp, paul@paul-moore.com,
        stephen.smalley.work@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [PATCH v34 08/29] LSM: Use lsmblob in security_secctx_to_secid
Date:   Fri, 15 Apr 2022 14:17:40 -0700
Message-Id: <20220415211801.12667-9-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220415211801.12667-1-casey@schaufler-ca.com>
References: <20220415211801.12667-1-casey@schaufler-ca.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change the security_secctx_to_secid interface to use a lsmblob
structure in place of the single u32 secid in support of
module stacking. Change its callers to do the same.

The security module hook is unchanged, still passing back a secid.
The infrastructure passes the correct entry from the lsmblob.

Acked-by: Paul Moore <paul@paul-moore.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Cc: netdev@vger.kernel.org
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/security.h          | 26 ++++++++++++++++++--
 kernel/cred.c                     |  4 +---
 net/netfilter/nft_meta.c          | 10 ++++----
 net/netfilter/xt_SECMARK.c        |  7 +++++-
 net/netlabel/netlabel_unlabeled.c | 23 +++++++++++-------
 security/security.c               | 40 ++++++++++++++++++++++++++-----
 6 files changed, 85 insertions(+), 25 deletions(-)

diff --git a/include/linux/security.h b/include/linux/security.h
index e9f185e9162a..310edbdaa14f 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -199,6 +199,27 @@ static inline bool lsmblob_equal(const struct lsmblob *bloba,
 extern int lsm_name_to_slot(char *name);
 extern const char *lsm_slot_to_name(int slot);
 
+/**
+ * lsmblob_value - find the first non-zero value in an lsmblob structure.
+ * @blob: Pointer to the data
+ *
+ * This needs to be used with extreme caution, as the cases where
+ * it is appropriate are rare.
+ *
+ * Return the first secid value set in the lsmblob.
+ * There should only be one.
+ */
+static inline u32 lsmblob_value(const struct lsmblob *blob)
+{
+	int i;
+
+	for (i = 0; i < LSMBLOB_ENTRIES; i++)
+		if (blob->secid[i])
+			return blob->secid[i];
+
+	return 0;
+}
+
 /* These functions are in security/commoncap.c */
 extern int cap_capable(const struct cred *cred, struct user_namespace *ns,
 		       int cap, unsigned int opts);
@@ -529,7 +550,8 @@ int security_setprocattr(const char *lsm, const char *name, void *value,
 int security_netlink_send(struct sock *sk, struct sk_buff *skb);
 int security_ismaclabel(const char *name);
 int security_secid_to_secctx(u32 secid, char **secdata, u32 *seclen);
-int security_secctx_to_secid(const char *secdata, u32 seclen, u32 *secid);
+int security_secctx_to_secid(const char *secdata, u32 seclen,
+			     struct lsmblob *blob);
 void security_release_secctx(char *secdata, u32 seclen);
 void security_inode_invalidate_secctx(struct inode *inode);
 int security_inode_notifysecctx(struct inode *inode, void *ctx, u32 ctxlen);
@@ -1384,7 +1406,7 @@ static inline int security_secid_to_secctx(u32 secid, char **secdata, u32 *secle
 
 static inline int security_secctx_to_secid(const char *secdata,
 					   u32 seclen,
-					   u32 *secid)
+					   struct lsmblob *blob)
 {
 	return -EOPNOTSUPP;
 }
diff --git a/kernel/cred.c b/kernel/cred.c
index 3925d38f49f4..adea727744f4 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -791,14 +791,12 @@ EXPORT_SYMBOL(set_security_override);
 int set_security_override_from_ctx(struct cred *new, const char *secctx)
 {
 	struct lsmblob blob;
-	u32 secid;
 	int ret;
 
-	ret = security_secctx_to_secid(secctx, strlen(secctx), &secid);
+	ret = security_secctx_to_secid(secctx, strlen(secctx), &blob);
 	if (ret < 0)
 		return ret;
 
-	lsmblob_init(&blob, secid);
 	return set_security_override(new, &blob);
 }
 EXPORT_SYMBOL(set_security_override_from_ctx);
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index ac4859241e17..fc0028c9e33d 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -860,21 +860,21 @@ static const struct nla_policy nft_secmark_policy[NFTA_SECMARK_MAX + 1] = {
 
 static int nft_secmark_compute_secid(struct nft_secmark *priv)
 {
-	u32 tmp_secid = 0;
+	struct lsmblob blob;
 	int err;
 
-	err = security_secctx_to_secid(priv->ctx, strlen(priv->ctx), &tmp_secid);
+	err = security_secctx_to_secid(priv->ctx, strlen(priv->ctx), &blob);
 	if (err)
 		return err;
 
-	if (!tmp_secid)
+	if (!lsmblob_is_set(&blob))
 		return -ENOENT;
 
-	err = security_secmark_relabel_packet(tmp_secid);
+	err = security_secmark_relabel_packet(lsmblob_value(&blob));
 	if (err)
 		return err;
 
-	priv->secid = tmp_secid;
+	priv->secid = lsmblob_value(&blob);
 	return 0;
 }
 
diff --git a/net/netfilter/xt_SECMARK.c b/net/netfilter/xt_SECMARK.c
index 498a0bf6f044..87ca3a537d1c 100644
--- a/net/netfilter/xt_SECMARK.c
+++ b/net/netfilter/xt_SECMARK.c
@@ -42,13 +42,14 @@ secmark_tg(struct sk_buff *skb, const struct xt_secmark_target_info_v1 *info)
 
 static int checkentry_lsm(struct xt_secmark_target_info_v1 *info)
 {
+	struct lsmblob blob;
 	int err;
 
 	info->secctx[SECMARK_SECCTX_MAX - 1] = '\0';
 	info->secid = 0;
 
 	err = security_secctx_to_secid(info->secctx, strlen(info->secctx),
-				       &info->secid);
+				       &blob);
 	if (err) {
 		if (err == -EINVAL)
 			pr_info_ratelimited("invalid security context \'%s\'\n",
@@ -56,6 +57,10 @@ static int checkentry_lsm(struct xt_secmark_target_info_v1 *info)
 		return err;
 	}
 
+	/* xt_secmark_target_info can't be changed to use lsmblobs because
+	 * it is exposed as an API. Use lsmblob_value() to get the one
+	 * value that got set by security_secctx_to_secid(). */
+	info->secid = lsmblob_value(&blob);
 	if (!info->secid) {
 		pr_info_ratelimited("unable to map security context \'%s\'\n",
 				    info->secctx);
diff --git a/net/netlabel/netlabel_unlabeled.c b/net/netlabel/netlabel_unlabeled.c
index 8490e46359ae..f3e2cde76919 100644
--- a/net/netlabel/netlabel_unlabeled.c
+++ b/net/netlabel/netlabel_unlabeled.c
@@ -880,7 +880,7 @@ static int netlbl_unlabel_staticadd(struct sk_buff *skb,
 	void *addr;
 	void *mask;
 	u32 addr_len;
-	u32 secid;
+	struct lsmblob blob;
 	struct netlbl_audit audit_info;
 
 	/* Don't allow users to add both IPv4 and IPv6 addresses for a
@@ -904,13 +904,18 @@ static int netlbl_unlabel_staticadd(struct sk_buff *skb,
 	ret_val = security_secctx_to_secid(
 		                  nla_data(info->attrs[NLBL_UNLABEL_A_SECCTX]),
 				  nla_len(info->attrs[NLBL_UNLABEL_A_SECCTX]),
-				  &secid);
+				  &blob);
 	if (ret_val != 0)
 		return ret_val;
 
+	/* netlbl_unlhsh_add will be changed to pass a struct lsmblob *
+	 * instead of a u32 later in this patch set. security_secctx_to_secid()
+	 * will only be setting one entry in the lsmblob struct, so it is
+	 * safe to use lsmblob_value() to get that one value. */
+
 	return netlbl_unlhsh_add(&init_net,
-				 dev_name, addr, mask, addr_len, secid,
-				 &audit_info);
+				 dev_name, addr, mask, addr_len,
+				 lsmblob_value(&blob), &audit_info);
 }
 
 /**
@@ -931,7 +936,7 @@ static int netlbl_unlabel_staticadddef(struct sk_buff *skb,
 	void *addr;
 	void *mask;
 	u32 addr_len;
-	u32 secid;
+	struct lsmblob blob;
 	struct netlbl_audit audit_info;
 
 	/* Don't allow users to add both IPv4 and IPv6 addresses for a
@@ -953,13 +958,15 @@ static int netlbl_unlabel_staticadddef(struct sk_buff *skb,
 	ret_val = security_secctx_to_secid(
 		                  nla_data(info->attrs[NLBL_UNLABEL_A_SECCTX]),
 				  nla_len(info->attrs[NLBL_UNLABEL_A_SECCTX]),
-				  &secid);
+				  &blob);
 	if (ret_val != 0)
 		return ret_val;
 
+	/* security_secctx_to_secid() will only put one secid into the lsmblob
+	 * so it's safe to use lsmblob_value() to get the secid. */
 	return netlbl_unlhsh_add(&init_net,
-				 NULL, addr, mask, addr_len, secid,
-				 &audit_info);
+				 NULL, addr, mask, addr_len,
+				 lsmblob_value(&blob), &audit_info);
 }
 
 /**
diff --git a/security/security.c b/security/security.c
index e9f1487af0e5..f814a41c5d9f 100644
--- a/security/security.c
+++ b/security/security.c
@@ -2211,10 +2211,22 @@ int security_secid_to_secctx(u32 secid, char **secdata, u32 *seclen)
 }
 EXPORT_SYMBOL(security_secid_to_secctx);
 
-int security_secctx_to_secid(const char *secdata, u32 seclen, u32 *secid)
+int security_secctx_to_secid(const char *secdata, u32 seclen,
+			     struct lsmblob *blob)
 {
-	*secid = 0;
-	return call_int_hook(secctx_to_secid, 0, secdata, seclen, secid);
+	struct security_hook_list *hp;
+	int rc;
+
+	lsmblob_init(blob, 0);
+	hlist_for_each_entry(hp, &security_hook_heads.secctx_to_secid, list) {
+		if (WARN_ON(hp->lsmid->slot < 0 || hp->lsmid->slot >= lsm_slot))
+			continue;
+		rc = hp->hook.secctx_to_secid(secdata, seclen,
+					      &blob->secid[hp->lsmid->slot]);
+		if (rc != 0)
+			return rc;
+	}
+	return 0;
 }
 EXPORT_SYMBOL(security_secctx_to_secid);
 
@@ -2365,10 +2377,26 @@ int security_socket_getpeersec_stream(struct socket *sock, char __user *optval,
 				optval, optlen, len);
 }
 
-int security_socket_getpeersec_dgram(struct socket *sock, struct sk_buff *skb, u32 *secid)
+int security_socket_getpeersec_dgram(struct socket *sock, struct sk_buff *skb,
+				     u32 *secid)
 {
-	return call_int_hook(socket_getpeersec_dgram, -ENOPROTOOPT, sock,
-			     skb, secid);
+	struct security_hook_list *hp;
+	int rc = -ENOPROTOOPT;
+
+	/*
+	 * Only one security module should provide a real hook for
+	 * this. A stub or bypass like is used in BPF should either
+	 * (somehow) leave rc unaltered or return -ENOPROTOOPT.
+	 */
+	hlist_for_each_entry(hp, &security_hook_heads.socket_getpeersec_dgram,
+			     list) {
+		if (WARN_ON(hp->lsmid->slot < 0 || hp->lsmid->slot >= lsm_slot))
+			continue;
+		rc = hp->hook.socket_getpeersec_dgram(sock, skb, secid);
+		if (rc != -ENOPROTOOPT)
+			break;
+	}
+	return rc;
 }
 EXPORT_SYMBOL(security_socket_getpeersec_dgram);
 
-- 
2.35.1

