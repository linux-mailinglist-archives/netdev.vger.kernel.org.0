Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 743274F8970
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 00:14:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231539AbiDGV2R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 17:28:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231467AbiDGV2N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 17:28:13 -0400
Received: from sonic305-28.consmr.mail.ne1.yahoo.com (sonic305-28.consmr.mail.ne1.yahoo.com [66.163.185.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD1C319B05A
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 14:26:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1649366770; bh=KzbFwwhuwjYfTBU4tfTxK1dAwBTSVWuzxkwCQg5qsUw=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=oSMFN1NXgj5nT4hKPSc4GG+4fnWK1CZ5bjUbH8NTGAm2xjEvWr+dyqPBM8nnflIDINXN6kldvhV2L6KESnmzDIKZ+brRuUkxAz5eRGoew5pSKjHRQuGYiOK9V9nSDgnezN1ln+oMlR40e3vdM70FVRvHbM+aZgxhXOdnmNuyY3ScIgiclZJf1PlpzVHOMAbwNcaLDeNVzJw2rI56tblV2b9KExw8NSmlQeFLJRQzLR7U3I0d3gp5W2IXbRTVIf55ZhLATcW72j4vJ7Lq4LWHE4C0rkl6cxNzV50aGh4u8dY8Q3Ed97vHQ44tP9jdE1+7eOgZV0E6yy4HY5sUbs2nsw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1649366770; bh=xDz3OU9PDS8Hz3vIt1H+suPQtNOH14jBaooUb2W5sc8=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=kLrtIzaVzKmcpaXa6VckGZznZoYy7j7+KWT1RGKrgmsE1nodjlQcYCrizD2SwhIZDe4AtA03VLPDUxewf14n1+wayQgGn95bRNNAtnPivYtvGQVQdZQDhSIAKr+rQWWqXowLXCFltKw59+wd6qVims93HSqne5yNGo/0uCaDxpl59TMeHq68y2zhu/YiqL9nNhkvnz90hQwq5IRLNJUU5O9derX04otTJhfzqIyxp6ZnfskKJMdT5RwaqNht+cFj8wh7cat5JNrbywsZ/ZoObW0B+ZWyCyFb4h8BKvglGBwZn2thmIUuLi86GBWgbtOPvkNWyQSMPaw9d/NAN3ywiw==
X-YMail-OSG: MzyUCcgVM1ltKIjPm6j7qa.8FIaE6f6l9wXggunUKktQq5N72GVK1ey1w1qZZbc
 xg9pb.0AgGm2ZmHNKflOpl6ZyT7YG_Lv3YoC14bNlfWUas03qKKM2yk4aSHnUjjZbv4yO8gbho3K
 rikpppNY51LNf_XTBbLcUIO.tdXBxPmC.4TicHa6YNbf3HpnZQAVAJ2PyUWRTcTg077MLbulL5_Q
 mYjDuEItFlOWudyI_EWutNBXzXT5Y4RL8kWgirywC7.38_zUNnu_VHH9FMG2SbdX6oM1AW7r4K8A
 Sst7dlSSI2NhttzYzlb0qMvUyYJt_oSS_deIFDs1kGTUTnnZ4CDEx4lg6mugQqU801z5gz3qp.tl
 TU7cXj4B5gcZT2kIpvXGnUvrFDCekX6ua8u_BSVLRbLSAFXfPgZ9PGqkda4En3pxLtwBzMXkQjCC
 DYsmsH1.by7_dVtXlJfxzYagZPLmIUf7T5KKFSpV.FEdSNGItRbLT2PMfoEJmgDCR.5cY1PSEJVe
 4mTf5PRtYHGJ95abB_86el.9L5zsjZ1LQ_KW.fOUud84UobC6bwPaPfrC9mJuZ51_gk3ZlrGK7_h
 EnkvsQQxNd4.ebaiI7jZjQB..l8yBhOGh1Sm3AI0gOrCJFfW_11tC5vACVmn5j8qNxVCPHkXPqjK
 xHX6HiGvT4WUYhPHHnZyhkWujjMXnhXaK8yqqC_qhG_iFZGk7t3PY7LMN9oITyx9iEsQkKq4EZx2
 QmCfoKhk.cb2yiqLbuCCwssu7dTSZMlBzBesIZPlEvLPRiGtvdO8N1oTKB1BJwME9ufVL3fYWmvS
 mBFoyUBbsIstgI9KhIUAFnTwx5VlJapGi79vO7RL0nrKULsAEk224O8wkTRl0WYQhJzlUcKV1ggh
 6rdJ1Rrjomsz.jMgmDN4JipHcdCrUVkXVyqfT1_P8syoxhk6UwVolEwdM741Z7SVtosR1b5Xadk5
 flkfMTlOs7D1OoEENmJDD_u2.kIbSumkVyNAhR3Uxjvfulp12eQV1CK1Zuaerrjjs9qsj14X7rar
 nPT7EcR.AZn9eCIzY2xbeErQFryYTyjYR53qfhovE9THT9m.VNCpAPrna6UZgD8924nheQbpbEPk
 iaXqmYmp7scZ49Nh2n3Ucon3b71O8tojVZ9Qwm_s0ZceyK.aw8A6qiTan__N1C8iJ6YetyXp9irU
 r20ihzZAHE6UI6arba0q.PINjAezaoD2vA2W.1sQZOkMtX6qJAlUKVBV5xbtphfvQV9uQtVgUjgb
 JwGgZCy4x736XzDB1Uit.RmXgbBChy0tfPkbAQNzSJGYyE.CCQTYz2lxHthzhelwHppBZvGByDrM
 W2ETLeMBmAhgDPJ5v4H9RgS6PsN1UE9qx6XDdatO6zN0mc0kTfQIdMts6hFORf0mJoXZJh6QHPXc
 LzLurR4AbLAaqzY9rkUl9iVHvlwwsxFZJEXBGLQa7.dfQ.6L72qwuEvOVRNKYhMh2xRZlSqIUWbB
 OcuwWSChxeb92yIjhcwNblydWxgZ3_bQcm4aXMXKDapayZ.RBYfE9Ssxpt42KpzONeSF9hd73jmJ
 DQkOCHVOFLWJDOvuy0DfKIXpa9zvPd8fBiG9mFOWrCYQvpjsXWZZwwNw5NOkS0DJf17pYt5Bal6q
 .yfLXPwWqMdiOOj7XDh6QpEArmGvkg2Y_eLf2MKqebD_FZewxIpjkwVJXvWu0i1PgyX74vePzQXG
 S06FhHovs00kiUG3RvVQ1ZNnbOhpGfIXNjSZlzYsRSkMpr7Vz441Vi2N9kZDQ9hmLCSy8Dil.NmT
 g1qjvrsq08RSARU51K1dfANh5BN9fyvFUWhLpxdoU_iTCZTWqCsKssV.2PP2uUi99iZz0OHzRDKc
 3u26ZrFEiJIxBVftFpWQVtF5P.3V1nxYDFXaTxyl8oMj7bON2YEnwhNMqG7bqiaKtZK4xMQnY0cH
 5eX7dYbpEA6lC8XCXOXofZzNqOj8G6aXDhLXv6XWXHxw1Kycl1qGISQBa8ipcMJezK6SVaL6JNuo
 2fvZAI.KmW4z11OabV3UlHFMkON3TJ0uaQmerAuqp6jRf6vbRs7AGOFHViK1Fmwe19Jd1hkUJWqh
 trsndhZigYiDLrg4YZNqlfrxMJzODSkOJATUp0f3pQBTJjEKEtuTtNe0nL802lsxi.djUXWG17mW
 DhNIfqzzuRmxy2ewK0m_DxdxiKgYMFRyGqy5GWCwUtJhFPz2UAG8BREffj9aI2c7UVV2CNATtHD1
 4E1d4lr8.saw36tQUImulFcEVULXS_Z0KG.gSlkti9rE3iqVKLEleDorvkhmqoAcxCI5kbf8OhrQ
 9wyU-
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic305.consmr.mail.ne1.yahoo.com with HTTP; Thu, 7 Apr 2022 21:26:10 +0000
Received: by hermes--canary-production-bf1-665cdb9985-zm65g (VZM Hermes SMTP Server) with ESMTPA ID 1b8a787888cf9c0809abffd2a20a44f0;
          Thu, 07 Apr 2022 21:26:04 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     casey@schaufler-ca.com, linux-audit@redhat.com,
        keescook@chromium.org, john.johansen@canonical.com,
        penguin-kernel@i-love.sakura.ne.jp, paul@paul-moore.com,
        stephen.smalley.work@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [PATCH v34 08/29] LSM: Use lsmblob in security_secctx_to_secid
Date:   Thu,  7 Apr 2022 14:22:09 -0700
Message-Id: <20220407212230.12893-9-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220407212230.12893-1-casey@schaufler-ca.com>
References: <20220407212230.12893-1-casey@schaufler-ca.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
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

