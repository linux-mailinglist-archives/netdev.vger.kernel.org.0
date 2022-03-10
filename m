Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59F7C4D5608
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 00:56:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345045AbiCJX4D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 18:56:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345013AbiCJXzy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 18:55:54 -0500
Received: from sonic304-28.consmr.mail.ne1.yahoo.com (sonic304-28.consmr.mail.ne1.yahoo.com [66.163.191.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B520719E01A
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 15:54:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1646956490; bh=cMoIwmLyMoRpd3TVJBV17iDlYLCrNiGFgnFrMEkzeXQ=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=miejDwqdm6ACE/ZgPztkXJhdHCjUvjj6vIoM4RBdF9YOmgLqOmb09I3FGcakcWS72F97+llN4d1pKEmXtuDAKZz3nyuJegZdLqgpnNlrDSyCI7fvZALn1Uu+ZQXo9ZgfXPiCHgU2WI0tz/yWBdXDXlCUHnJNsLfw2dKOJxaZoeU0Jx2i2d1a1lmelVi/13Uc02L/s5EFUfxAH8ut7qLTa5TCbmPXumFCjcwKd0VJIKAq4+YAvfQpIK3L6R5w+1gtlIJpKbnkehu6nggJDuAKITK0mWG1wtX/f83lVo56W7RgVUHX//qDdxHPWgGW8Fj2prpWOjX9YOAYafAoSlC/7A==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1646956490; bh=+UdwixZ0KEODQzQd0c6ddrC7HwP7QXi2nsTAU9FzkmB=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=ay3NBsQGcy4TL9VxBoTfuY/W9Tjaig0wdqKHRw1ofmc+L1XKXMiPYK0y6tbc84F7t/Aa9X232nv6MfJVyL+RgTqHoULYoUjf6jQ1Z+WFZ2l1A5y900rHcRVE2L1bLOxk9ciIwCM/VqquDNbVMlmHm0cGjbvTTus2aHcpYgcm5kseuZJIlNCneqlneeJiedAvYWDUUHCTHv/Bk4gipeYvZESS/8cXdzR7sVa3ozOgmufly1PPc9n0PjhWNU/7kmLjvU2d/kCjQyOIpBy3D8k6lnlTcT9byGRjLeHFEfIyaDdyeWhpxMWUzD7XFbhO/uwJbQp5qvZ4FFXp4sKlbUjsZw==
X-YMail-OSG: .T.ucoQVM1nr4udtqKmeb8nWazk3xvRdE0RiHI_7hm.1OD8PMeBYoQdGLeQIUTt
 tQr_J6x7zAEJvxwZSFKWveZD5SrEVrPYimNNaxkUPNpCjXkAi3LMHQMrO211PpBtX.2U.kk_FXtB
 Ci99AgWVEcRFe4sAu3PTzmotI2TrY56yL6ny84KfiZWsK1lV1GjKnHyBNUghRzt_Yk3lHcWPFtsp
 KjYqDljcYmmTQUJHuqqkXJCgutv57aZCtwBqIHYOvwKda3XrsPLUyvVhMGL44QZnu_yJIera6g3G
 ttU7KhQscmI3MfGH3wqkKwhrIbuNE6s2y_sI6VN.ZdQ45oNarRkHhrXKqUOLN.SQszCxbRyCvZhq
 4QzGk8.jqL_K8mRuSAmDP3gAVGdNb3JYkY4uw5o7TIUpkBZYMB1sE9cbozsk3znnfBZFTreOiyyO
 ihGdeyChhS.7OsqpeYiKM.PrI1izp_G0zJxW8hsSWMSfIIjK97KIL_eS6aD_627qlpI3ZEMgCG9J
 PfVULrIa8r4oTsKjZoYh.02XHA9Sn8KEoq0JvXGmMtscioIEYRKA8Qf.HTJxOmbgfpl0vnXE42q1
 DR5W3BxKwlB.HfgwSItNN82YWtedIRchvxtZPEhbBxM1l2.qyPQTcSGUMySE7pQkw6i.mGb1pTiK
 KN6nQRVqpWqvrk53RbsoAor3IE5A1FGKSYfuwnuGWkgcXuyFvOIA1chWi8ZE9P_A_bCy86g9k5mA
 MhZpz1TeGOiMWZkpEWvNYh2baYIKQOxQH1dvaGjJ.aB0QDmYA4L7ZUVyU0XwkU0lrY.JWSCSGBvx
 8jc1PaPg6YMV8IzFcajGXgj78gV91dO.3q6k0EewjuzETDspDnI33UakUT17.Pagrd9xMBnvuGui
 RXPKGYPcs.kbBUvRufBT2GejHPMK3s327eXgpUT4ePitnmrbXCariS7VNIwLqq0e29N2u8XG5wrK
 wNcfdKuI0Rb5Joj8d6RzwrMxchGmwr8Saf15SK6tTM6BEN5kHaobVsTcesGcODfe2fzOrnakKyir
 9YC6MEVdQvDHtiPh5QFsZwcqNojBkwQ5U6UTfKwdOi0QXAkqjikUUK1h5PCtTAeXV66yleHdiAOj
 CcLnVK86UigHDUXZOf6lQsSjrCZKA2mF2eecFm0dOiSsW_aNXx0Xl4gL22EhABOAT1qXdybR94hR
 Rg6sq2BbXfyJ4vf1j.2aaPoHjEr9.TSqt4ieVlSs4vSAFCODCmVUk5AnVTPXNhz2uvrq6l0ZhI76
 Kx.hb6WEPXBlnQ13o43LD5IJdrlx6xgVRGAxXbQZl.zaB1DlTht8u_V4AW6Zs6HOZMNhHOH3b0EC
 6LLzUeWhqd1mIjOOtcnQVwr2NMEUzoG5ANzpiy_HwizzYu88c7KiXyI2ERRXpDDDlvL17.iiy2ix
 UJwJr9nFmnnBIZ0Gmgh1s4kZ4dadSo3K2oYzjvKp4cSqaknCmDMOoJKU2o9eks.6hKh1vB6OTsTD
 OvnEp_h7fIRzUhG.sv15z9xOsQHQfJLD_BM6DxNfGu3hHuoCRu.VoSLZaqNROTKKPsst9RkCMOXp
 6tmbvDTZiHPcodNgtUVVayGbBBNdN9Ha7vf_t9vPtCq3Hz8uuGlbLKCufzSa1awepMbLQ2whNiNC
 fVfb8O36T68drj0sZSFf3XZpN97b.kLde2GSQXVK13c8Pwwsx_.uGZhuqFOvI6CrVBrUnJgGAIki
 65ORqGQM8NBQzLhv.3i5.LsrlR.BDwpulZb7pTwUksSnk2GtQrBB.9Rpe6Zno1L9hpPB80lwpZ47
 _dtJFbpaNYnd7DPhuXqG.iQEkrW1MdUORKB0fpIPJKEIUHUGEa9zTVglfAx2_f82oBU_3F6N4uZv
 R_zJ5DxABAYoWBPzfhCe_FfwpxHjz0mOyYCGClEMieS_oIUBt8hwbhnG0eX2VrzcynubkhGoClZn
 cHqi1m4pmC8MWQnrIx15kx.0tcMNemXBDR5sCYGUaHwe7KnRPphOXtnMLMuM5gYnryjamA.rq8s9
 Cy4EtRQ6MPYPddxGqEadXWbhBlvAZAxCd75fjcfQGMJQZcMVygLks9r5NG0.oikEW3OVsQNKx6Pm
 bowCM4Dg9Dkzr1JzqdHjAeIVlg_HRp5nQH1Gw96muwTibq4HzDsEWYyYhGqGRdAHtmvms0BTtAJn
 4641yEmIbTmDsFVtFqHQ1m4usHeOdIWMea66sy.2u8qRwrrNgj6Dqo2mDUZjIJLW7tS6TlyJ4O_3
 K7AQVFchCdUsYMsxsTQbLoaGhCIk7IfUeKWtVm3RvXpSxLwkcXReuPhHnyah7y9xNjS6vRX.orMw
 zVETReBPYtpeGDbxYP.unvohPLH70iY7U_EwYJRrjANFvtBwn5hmcdUI-
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic304.consmr.mail.ne1.yahoo.com with HTTP; Thu, 10 Mar 2022 23:54:50 +0000
Received: by kubenode520.mail-prod1.omega.bf1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 8cf1c259c50308b34237c785a039407c;
          Thu, 10 Mar 2022 23:54:44 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     casey@schaufler-ca.com, linux-audit@redhat.com,
        keescook@chromium.org, john.johansen@canonical.com,
        penguin-kernel@i-love.sakura.ne.jp, paul@paul-moore.com,
        stephen.smalley.work@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [PATCH v33 16/29] LSM: Use lsmcontext in security_secid_to_secctx
Date:   Thu, 10 Mar 2022 15:46:19 -0800
Message-Id: <20220310234632.16194-17-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220310234632.16194-1-casey@schaufler-ca.com>
References: <20220310234632.16194-1-casey@schaufler-ca.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace the (secctx,seclen) pointer pair with a single
lsmcontext pointer to allow return of the LSM identifier
along with the context and context length. This allows
security_release_secctx() to know how to release the
context. Callers have been modified to use or save the
returned data from the new structure.

security_secid_to_secctx() will now return the length value
if the passed lsmcontext pointer is NULL.

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Cc: netdev@vger.kernel.org
Cc: linux-audit@redhat.com
Cc: netfilter-devel@vger.kernel.org
---
 drivers/android/binder.c                | 26 ++++++---------
 include/linux/security.h                |  4 +--
 include/net/scm.h                       |  9 ++----
 kernel/audit.c                          | 42 +++++++++++--------------
 kernel/auditsc.c                        | 31 +++++++-----------
 net/ipv4/ip_sockglue.c                  |  8 ++---
 net/netfilter/nf_conntrack_netlink.c    | 18 ++++-------
 net/netfilter/nf_conntrack_standalone.c |  7 ++---
 net/netfilter/nfnetlink_queue.c         |  5 ++-
 net/netlabel/netlabel_unlabeled.c       | 40 +++++++----------------
 net/netlabel/netlabel_user.c            |  7 ++---
 security/security.c                     | 29 +++++++++++++++--
 12 files changed, 99 insertions(+), 127 deletions(-)

diff --git a/drivers/android/binder.c b/drivers/android/binder.c
index 2125b4b795da..b0b0c132a247 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -2723,9 +2723,7 @@ static void binder_transaction(struct binder_proc *proc,
 	binder_size_t last_fixup_min_off = 0;
 	struct binder_context *context = proc->context;
 	int t_debug_id = atomic_inc_return(&binder_last_id);
-	char *secctx = NULL;
-	u32 secctx_sz = 0;
-	struct lsmcontext scaff; /* scaffolding */
+	struct lsmcontext lsmctx = { };
 	struct list_head sgc_head;
 	struct list_head pf_head;
 	const void __user *user_buffer = (const void __user *)
@@ -2985,14 +2983,14 @@ static void binder_transaction(struct binder_proc *proc,
 		size_t added_size;
 
 		security_cred_getsecid(proc->cred, &blob);
-		ret = security_secid_to_secctx(&blob, &secctx, &secctx_sz);
+		ret = security_secid_to_secctx(&blob, &lsmctx);
 		if (ret) {
 			return_error = BR_FAILED_REPLY;
 			return_error_param = ret;
 			return_error_line = __LINE__;
 			goto err_get_secctx_failed;
 		}
-		added_size = ALIGN(secctx_sz, sizeof(u64));
+		added_size = ALIGN(lsmctx.len, sizeof(u64));
 		extra_buffers_size += added_size;
 		if (extra_buffers_size < added_size) {
 			/* integer overflow of extra_buffers_size */
@@ -3019,24 +3017,22 @@ static void binder_transaction(struct binder_proc *proc,
 		t->buffer = NULL;
 		goto err_binder_alloc_buf_failed;
 	}
-	if (secctx) {
+	if (lsmctx.context) {
 		int err;
 		size_t buf_offset = ALIGN(tr->data_size, sizeof(void *)) +
 				    ALIGN(tr->offsets_size, sizeof(void *)) +
 				    ALIGN(extra_buffers_size, sizeof(void *)) -
-				    ALIGN(secctx_sz, sizeof(u64));
+				    ALIGN(lsmctx.len, sizeof(u64));
 
 		t->security_ctx = (uintptr_t)t->buffer->user_data + buf_offset;
 		err = binder_alloc_copy_to_buffer(&target_proc->alloc,
 						  t->buffer, buf_offset,
-						  secctx, secctx_sz);
+						  lsmctx.context, lsmctx.len);
 		if (err) {
 			t->security_ctx = 0;
 			WARN_ON(1);
 		}
-		lsmcontext_init(&scaff, secctx, secctx_sz, 0);
-		security_release_secctx(&scaff);
-		secctx = NULL;
+		security_release_secctx(&lsmctx);
 	}
 	t->buffer->debug_id = t->debug_id;
 	t->buffer->transaction = t;
@@ -3080,7 +3076,7 @@ static void binder_transaction(struct binder_proc *proc,
 	off_end_offset = off_start_offset + tr->offsets_size;
 	sg_buf_offset = ALIGN(off_end_offset, sizeof(void *));
 	sg_buf_end_offset = sg_buf_offset + extra_buffers_size -
-		ALIGN(secctx_sz, sizeof(u64));
+		ALIGN(lsmctx.len, sizeof(u64));
 	off_min = 0;
 	for (buffer_offset = off_start_offset; buffer_offset < off_end_offset;
 	     buffer_offset += sizeof(binder_size_t)) {
@@ -3435,10 +3431,8 @@ static void binder_transaction(struct binder_proc *proc,
 	binder_alloc_free_buf(&target_proc->alloc, t->buffer);
 err_binder_alloc_buf_failed:
 err_bad_extra_size:
-	if (secctx) {
-		lsmcontext_init(&scaff, secctx, secctx_sz, 0);
-		security_release_secctx(&scaff);
-	}
+	if (lsmctx.context)
+		security_release_secctx(&lsmctx);
 err_get_secctx_failed:
 	kfree(tcomplete);
 	binder_stats_deleted(BINDER_STAT_TRANSACTION_COMPLETE);
diff --git a/include/linux/security.h b/include/linux/security.h
index 11c4d088f7a8..1bb26971f825 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -597,7 +597,7 @@ int security_setprocattr(const char *lsm, const char *name, void *value,
 			 size_t size);
 int security_netlink_send(struct sock *sk, struct sk_buff *skb);
 int security_ismaclabel(const char *name);
-int security_secid_to_secctx(struct lsmblob *blob, char **secdata, u32 *seclen);
+int security_secid_to_secctx(struct lsmblob *blob, struct lsmcontext *cp);
 int security_secctx_to_secid(const char *secdata, u32 seclen,
 			     struct lsmblob *blob);
 void security_release_secctx(struct lsmcontext *cp);
@@ -1451,7 +1451,7 @@ static inline int security_ismaclabel(const char *name)
 }
 
 static inline int security_secid_to_secctx(struct lsmblob *blob,
-					   char **secdata, u32 *seclen)
+					   struct lsmcontext *cp)
 {
 	return -EOPNOTSUPP;
 }
diff --git a/include/net/scm.h b/include/net/scm.h
index f273c4d777ec..b77a52f93389 100644
--- a/include/net/scm.h
+++ b/include/net/scm.h
@@ -94,8 +94,6 @@ static inline void scm_passec(struct socket *sock, struct msghdr *msg, struct sc
 {
 	struct lsmcontext context;
 	struct lsmblob lb;
-	char *secdata;
-	u32 seclen;
 	int err;
 
 	if (test_bit(SOCK_PASSSEC, &sock->flags)) {
@@ -103,12 +101,11 @@ static inline void scm_passec(struct socket *sock, struct msghdr *msg, struct sc
 		 * and the infrastructure will know which it is.
 		 */
 		lsmblob_init(&lb, scm->secid);
-		err = security_secid_to_secctx(&lb, &secdata, &seclen);
+		err = security_secid_to_secctx(&lb, &context);
 
 		if (!err) {
-			put_cmsg(msg, SOL_SOCKET, SCM_SECURITY, seclen, secdata);
-			/*scaffolding*/
-			lsmcontext_init(&context, secdata, seclen, 0);
+			put_cmsg(msg, SOL_SOCKET, SCM_SECURITY, context.len,
+				 context.context);
 			security_release_secctx(&context);
 		}
 	}
diff --git a/kernel/audit.c b/kernel/audit.c
index 5aa2ee06c9e4..03824cca058c 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1188,9 +1188,6 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 	struct audit_buffer	*ab;
 	u16			msg_type = nlh->nlmsg_type;
 	struct audit_sig_info   *sig_data;
-	char			*ctx = NULL;
-	u32			len;
-	struct lsmcontext	scaff; /* scaffolding */
 
 	err = audit_netlink_ok(skb, msg_type);
 	if (err)
@@ -1438,33 +1435,33 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 		kfree(new);
 		break;
 	}
-	case AUDIT_SIGNAL_INFO:
-		len = 0;
+	case AUDIT_SIGNAL_INFO: {
+		struct lsmcontext context = { };
+
 		if (lsmblob_is_set(&audit_sig_lsm)) {
-			err = security_secid_to_secctx(&audit_sig_lsm, &ctx,
-						       &len);
+			err = security_secid_to_secctx(&audit_sig_lsm,
+						       &context);
 			if (err)
 				return err;
 		}
-		sig_data = kmalloc(struct_size(sig_data, ctx, len), GFP_KERNEL);
+		sig_data = kmalloc(struct_size(sig_data, ctx, context.len),
+				   GFP_KERNEL);
 		if (!sig_data) {
-			if (lsmblob_is_set(&audit_sig_lsm)) {
-				lsmcontext_init(&scaff, ctx, len, 0);
-				security_release_secctx(&scaff);
-			}
+			if (lsmblob_is_set(&audit_sig_lsm))
+				security_release_secctx(&context);
 			return -ENOMEM;
 		}
 		sig_data->uid = from_kuid(&init_user_ns, audit_sig_uid);
 		sig_data->pid = audit_sig_pid;
 		if (lsmblob_is_set(&audit_sig_lsm)) {
-			memcpy(sig_data->ctx, ctx, len);
-			lsmcontext_init(&scaff, ctx, len, 0);
-			security_release_secctx(&scaff);
+			memcpy(sig_data->ctx, context.context, context.len);
+			security_release_secctx(&context);
 		}
-		audit_send_reply(skb, seq, AUDIT_SIGNAL_INFO, 0, 0,
-				 sig_data, struct_size(sig_data, ctx, len));
+		audit_send_reply(skb, seq, AUDIT_SIGNAL_INFO, 0, 0, sig_data,
+				 struct_size(sig_data, ctx, context.len));
 		kfree(sig_data);
 		break;
+	}
 	case AUDIT_TTY_GET: {
 		struct audit_tty_status s;
 		unsigned int t;
@@ -2147,17 +2144,15 @@ void audit_log_key(struct audit_buffer *ab, char *key)
 
 int audit_log_task_context(struct audit_buffer *ab)
 {
-	char *ctx = NULL;
-	unsigned len;
 	int error;
 	struct lsmblob blob;
-	struct lsmcontext scaff; /* scaffolding */
+	struct lsmcontext context;
 
 	security_current_getsecid_subj(&blob);
 	if (!lsmblob_is_set(&blob))
 		return 0;
 
-	error = security_secid_to_secctx(&blob, &ctx, &len);
+	error = security_secid_to_secctx(&blob, &context);
 
 	if (error) {
 		if (error != -EINVAL)
@@ -2165,9 +2160,8 @@ int audit_log_task_context(struct audit_buffer *ab)
 		return 0;
 	}
 
-	audit_log_format(ab, " subj=%s", ctx);
-	lsmcontext_init(&scaff, ctx, len, 0);
-	security_release_secctx(&scaff);
+	audit_log_format(ab, " subj=%s", context.context);
+	security_release_secctx(&context);
 	return 0;
 
 error_path:
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 1626d8aabe83..7858da40a767 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -1121,9 +1121,7 @@ static int audit_log_pid_context(struct audit_context *context, pid_t pid,
 				 struct lsmblob *blob, char *comm)
 {
 	struct audit_buffer *ab;
-	struct lsmcontext lsmcxt;
-	char *ctx = NULL;
-	u32 len;
+	struct lsmcontext lsmctx;
 	int rc = 0;
 
 	ab = audit_log_start(context, GFP_KERNEL, AUDIT_OBJ_PID);
@@ -1134,13 +1132,12 @@ static int audit_log_pid_context(struct audit_context *context, pid_t pid,
 			 from_kuid(&init_user_ns, auid),
 			 from_kuid(&init_user_ns, uid), sessionid);
 	if (lsmblob_is_set(blob)) {
-		if (security_secid_to_secctx(blob, &ctx, &len)) {
+		if (security_secid_to_secctx(blob, &lsmctx)) {
 			audit_log_format(ab, " obj=(none)");
 			rc = 1;
 		} else {
-			audit_log_format(ab, " obj=%s", ctx);
-			lsmcontext_init(&lsmcxt, ctx, len, 0); /*scaffolding*/
-			security_release_secctx(&lsmcxt);
+			audit_log_format(ab, " obj=%s", lsmctx.context);
+			security_release_secctx(&lsmctx);
 		}
 	}
 	audit_log_format(ab, " ocomm=");
@@ -1353,7 +1350,6 @@ static void audit_log_fcaps(struct audit_buffer *ab, struct audit_names *name)
 
 static void show_special(struct audit_context *context, int *call_panic)
 {
-	struct lsmcontext lsmcxt;
 	struct audit_buffer *ab;
 	int i;
 
@@ -1378,17 +1374,15 @@ static void show_special(struct audit_context *context, int *call_panic)
 				 from_kgid(&init_user_ns, context->ipc.gid),
 				 context->ipc.mode);
 		if (osid) {
-			char *ctx = NULL;
-			u32 len;
+			struct lsmcontext lsmcxt;
 			struct lsmblob blob;
 
 			lsmblob_init(&blob, osid);
-			if (security_secid_to_secctx(&blob, &ctx, &len)) {
+			if (security_secid_to_secctx(&blob, &lsmcxt)) {
 				audit_log_format(ab, " osid=%u", osid);
 				*call_panic = 1;
 			} else {
-				audit_log_format(ab, " obj=%s", ctx);
-				lsmcontext_init(&lsmcxt, ctx, len, 0);
+				audit_log_format(ab, " obj=%s", lsmcxt.context);
 				security_release_secctx(&lsmcxt);
 			}
 		}
@@ -1543,20 +1537,17 @@ static void audit_log_name(struct audit_context *context, struct audit_names *n,
 				 MAJOR(n->rdev),
 				 MINOR(n->rdev));
 	if (n->osid != 0) {
-		char *ctx = NULL;
-		u32 len;
 		struct lsmblob blob;
-		struct lsmcontext lsmcxt;
+		struct lsmcontext lsmctx;
 
 		lsmblob_init(&blob, n->osid);
-		if (security_secid_to_secctx(&blob, &ctx, &len)) {
+		if (security_secid_to_secctx(&blob, &lsmctx)) {
 			audit_log_format(ab, " osid=%u", n->osid);
 			if (call_panic)
 				*call_panic = 2;
 		} else {
-			audit_log_format(ab, " obj=%s", ctx);
-			lsmcontext_init(&lsmcxt, ctx, len, 0); /* scaffolding */
-			security_release_secctx(&lsmcxt);
+			audit_log_format(ab, " obj=%s", lsmctx.context);
+			security_release_secctx(&lsmctx);
 		}
 	}
 
diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index 70ca4510ea35..ad5be7707bca 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -132,8 +132,7 @@ static void ip_cmsg_recv_security(struct msghdr *msg, struct sk_buff *skb)
 {
 	struct lsmcontext context;
 	struct lsmblob lb;
-	char *secdata;
-	u32 seclen, secid;
+	u32 secid;
 	int err;
 
 	err = security_socket_getpeersec_dgram(NULL, skb, &secid);
@@ -141,12 +140,11 @@ static void ip_cmsg_recv_security(struct msghdr *msg, struct sk_buff *skb)
 		return;
 
 	lsmblob_init(&lb, secid);
-	err = security_secid_to_secctx(&lb, &secdata, &seclen);
+	err = security_secid_to_secctx(&lb, &context);
 	if (err)
 		return;
 
-	put_cmsg(msg, SOL_IP, SCM_SECURITY, seclen, secdata);
-	lsmcontext_init(&context, secdata, seclen, 0); /* scaffolding */
+	put_cmsg(msg, SOL_IP, SCM_SECURITY, context.len, context.context);
 	security_release_secctx(&context);
 }
 
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 212e12b53adb..9626e2b0ef12 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -339,8 +339,7 @@ static int ctnetlink_dump_mark(struct sk_buff *skb, const struct nf_conn *ct)
 static int ctnetlink_dump_secctx(struct sk_buff *skb, const struct nf_conn *ct)
 {
 	struct nlattr *nest_secctx;
-	int len, ret;
-	char *secctx;
+	int ret;
 	struct lsmblob blob;
 	struct lsmcontext context;
 
@@ -348,7 +347,7 @@ static int ctnetlink_dump_secctx(struct sk_buff *skb, const struct nf_conn *ct)
 	 * security_secid_to_secctx() will know which security module
 	 * to use to create the secctx.  */
 	lsmblob_init(&blob, ct->secmark);
-	ret = security_secid_to_secctx(&blob, &secctx, &len);
+	ret = security_secid_to_secctx(&blob, &context);
 	if (ret)
 		return 0;
 
@@ -357,13 +356,12 @@ static int ctnetlink_dump_secctx(struct sk_buff *skb, const struct nf_conn *ct)
 	if (!nest_secctx)
 		goto nla_put_failure;
 
-	if (nla_put_string(skb, CTA_SECCTX_NAME, secctx))
+	if (nla_put_string(skb, CTA_SECCTX_NAME, context.context))
 		goto nla_put_failure;
 	nla_nest_end(skb, nest_secctx);
 
 	ret = 0;
 nla_put_failure:
-	lsmcontext_init(&context, secctx, len, 0); /* scaffolding */
 	security_release_secctx(&context);
 	return ret;
 }
@@ -656,15 +654,11 @@ static inline size_t ctnetlink_acct_size(const struct nf_conn *ct)
 static inline int ctnetlink_secctx_size(const struct nf_conn *ct)
 {
 #ifdef CONFIG_NF_CONNTRACK_SECMARK
-	int len, ret;
+	int len;
 	struct lsmblob blob;
 
-	/* lsmblob_init() puts ct->secmark into all of the secids in blob.
-	 * security_secid_to_secctx() will know which security module
-	 * to use to create the secctx.  */
-	lsmblob_init(&blob, ct->secmark);
-	ret = security_secid_to_secctx(&blob, NULL, &len);
-	if (ret)
+	len = security_secid_to_secctx(&blob, NULL);
+	if (len <= 0)
 		return 0;
 
 	return nla_total_size(0) /* CTA_SECCTX */
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 3b6ba86783f6..36338660df3c 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -176,19 +176,16 @@ static void ct_seq_stop(struct seq_file *s, void *v)
 static void ct_show_secctx(struct seq_file *s, const struct nf_conn *ct)
 {
 	int ret;
-	u32 len;
-	char *secctx;
 	struct lsmblob blob;
 	struct lsmcontext context;
 
 	lsmblob_init(&blob, ct->secmark);
-	ret = security_secid_to_secctx(&blob, &secctx, &len);
+	ret = security_secid_to_secctx(&blob, &context);
 	if (ret)
 		return;
 
-	seq_printf(s, "secctx=%s ", secctx);
+	seq_printf(s, "secctx=%s ", context.context);
 
-	lsmcontext_init(&context, secctx, len, 0); /* scaffolding */
 	security_release_secctx(&context);
 }
 #else
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index d986bae1587b..625cd787ffc1 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -306,6 +306,7 @@ static u32 nfqnl_get_sk_secctx(struct sk_buff *skb, char **secdata)
 	u32 seclen = 0;
 #if IS_ENABLED(CONFIG_NETWORK_SECMARK)
 	struct lsmblob blob;
+	struct lsmcontext context = { };
 
 	if (!skb || !sk_fullsock(skb->sk))
 		return 0;
@@ -317,10 +318,12 @@ static u32 nfqnl_get_sk_secctx(struct sk_buff *skb, char **secdata)
 		 * blob. security_secid_to_secctx() will know which security
 		 * module to use to create the secctx.  */
 		lsmblob_init(&blob, skb->secmark);
-		security_secid_to_secctx(&blob, secdata, &seclen);
+		security_secid_to_secctx(&blob, &context);
+		*secdata = context.context;
 	}
 
 	read_unlock_bh(&skb->sk->sk_callback_lock);
+	seclen = context.len;
 #endif
 	return seclen;
 }
diff --git a/net/netlabel/netlabel_unlabeled.c b/net/netlabel/netlabel_unlabeled.c
index a8e9ee202245..46706889a6f7 100644
--- a/net/netlabel/netlabel_unlabeled.c
+++ b/net/netlabel/netlabel_unlabeled.c
@@ -375,8 +375,6 @@ int netlbl_unlhsh_add(struct net *net,
 	struct netlbl_unlhsh_iface *iface;
 	struct audit_buffer *audit_buf = NULL;
 	struct lsmcontext context;
-	char *secctx = NULL;
-	u32 secctx_len;
 	struct lsmblob blob;
 
 	if (addr_len != sizeof(struct in_addr) &&
@@ -444,12 +442,9 @@ int netlbl_unlhsh_add(struct net *net,
 		 * security_secid_to_secctx() will know which security module
 		 * to use to create the secctx.  */
 		lsmblob_init(&blob, secid);
-		if (security_secid_to_secctx(&blob,
-					     &secctx,
-					     &secctx_len) == 0) {
-			audit_log_format(audit_buf, " sec_obj=%s", secctx);
-			/* scaffolding */
-			lsmcontext_init(&context, secctx, secctx_len, 0);
+		if (security_secid_to_secctx(&blob, &context) == 0) {
+			audit_log_format(audit_buf, " sec_obj=%s",
+					 context.context);
 			security_release_secctx(&context);
 		}
 		audit_log_format(audit_buf, " res=%u", ret_val == 0 ? 1 : 0);
@@ -482,8 +477,6 @@ static int netlbl_unlhsh_remove_addr4(struct net *net,
 	struct audit_buffer *audit_buf;
 	struct net_device *dev;
 	struct lsmcontext context;
-	char *secctx;
-	u32 secctx_len;
 	struct lsmblob blob;
 
 	spin_lock(&netlbl_unlhsh_lock);
@@ -509,11 +502,9 @@ static int netlbl_unlhsh_remove_addr4(struct net *net,
 		if (entry != NULL)
 			lsmblob_init(&blob, entry->secid);
 		if (entry != NULL &&
-		    security_secid_to_secctx(&blob,
-					     &secctx, &secctx_len) == 0) {
-			audit_log_format(audit_buf, " sec_obj=%s", secctx);
-			/* scaffolding */
-			lsmcontext_init(&context, secctx, secctx_len, 0);
+		    security_secid_to_secctx(&blob, &context) == 0) {
+			audit_log_format(audit_buf, " sec_obj=%s",
+					 context.context);
 			security_release_secctx(&context);
 		}
 		audit_log_format(audit_buf, " res=%u", entry != NULL ? 1 : 0);
@@ -552,8 +543,6 @@ static int netlbl_unlhsh_remove_addr6(struct net *net,
 	struct audit_buffer *audit_buf;
 	struct net_device *dev;
 	struct lsmcontext context;
-	char *secctx;
-	u32 secctx_len;
 	struct lsmblob blob;
 
 	spin_lock(&netlbl_unlhsh_lock);
@@ -578,10 +567,9 @@ static int netlbl_unlhsh_remove_addr6(struct net *net,
 		if (entry != NULL)
 			lsmblob_init(&blob, entry->secid);
 		if (entry != NULL &&
-		    security_secid_to_secctx(&blob,
-					     &secctx, &secctx_len) == 0) {
-			audit_log_format(audit_buf, " sec_obj=%s", secctx);
-			lsmcontext_init(&context, secctx, secctx_len, 0);
+		    security_secid_to_secctx(&blob, &context) == 0) {
+			audit_log_format(audit_buf, " sec_obj=%s",
+					 context.context);
 			security_release_secctx(&context);
 		}
 		audit_log_format(audit_buf, " res=%u", entry != NULL ? 1 : 0);
@@ -1104,8 +1092,6 @@ static int netlbl_unlabel_staticlist_gen(u32 cmd,
 	struct lsmcontext context;
 	void *data;
 	u32 secid;
-	char *secctx;
-	u32 secctx_len;
 	struct lsmblob blob;
 
 	data = genlmsg_put(cb_arg->skb, NETLINK_CB(cb_arg->nl_cb->skb).portid,
@@ -1165,15 +1151,13 @@ static int netlbl_unlabel_staticlist_gen(u32 cmd,
 	 * security_secid_to_secctx() will know which security module
 	 * to use to create the secctx.  */
 	lsmblob_init(&blob, secid);
-	ret_val = security_secid_to_secctx(&blob, &secctx, &secctx_len);
+	ret_val = security_secid_to_secctx(&blob, &context);
 	if (ret_val != 0)
 		goto list_cb_failure;
 	ret_val = nla_put(cb_arg->skb,
 			  NLBL_UNLABEL_A_SECCTX,
-			  secctx_len,
-			  secctx);
-	/* scaffolding */
-	lsmcontext_init(&context, secctx, secctx_len, 0);
+			  context.len,
+			  context.context);
 	security_release_secctx(&context);
 	if (ret_val != 0)
 		goto list_cb_failure;
diff --git a/net/netlabel/netlabel_user.c b/net/netlabel/netlabel_user.c
index ef139d8ae7cd..951ba0639d20 100644
--- a/net/netlabel/netlabel_user.c
+++ b/net/netlabel/netlabel_user.c
@@ -85,8 +85,6 @@ struct audit_buffer *netlbl_audit_start_common(int type,
 {
 	struct audit_buffer *audit_buf;
 	struct lsmcontext context;
-	char *secctx;
-	u32 secctx_len;
 	struct lsmblob blob;
 
 	if (audit_enabled == AUDIT_OFF)
@@ -102,9 +100,8 @@ struct audit_buffer *netlbl_audit_start_common(int type,
 
 	lsmblob_init(&blob, audit_info->secid);
 	if (audit_info->secid != 0 &&
-	    security_secid_to_secctx(&blob, &secctx, &secctx_len) == 0) {
-		audit_log_format(audit_buf, " subj=%s", secctx);
-		lsmcontext_init(&context, secctx, secctx_len, 0);/*scaffolding*/
+	    security_secid_to_secctx(&blob, &context) == 0) {
+		audit_log_format(audit_buf, " subj=%s", context.context);
 		security_release_secctx(&context);
 	}
 
diff --git a/security/security.c b/security/security.c
index 163cf0ae2429..d56fcb794ff4 100644
--- a/security/security.c
+++ b/security/security.c
@@ -2330,18 +2330,41 @@ int security_ismaclabel(const char *name)
 }
 EXPORT_SYMBOL(security_ismaclabel);
 
-int security_secid_to_secctx(struct lsmblob *blob, char **secdata, u32 *seclen)
+/**
+ * security_secid_to_secctx - convert secid to secctx
+ * @blob: set of secids
+ * @cp: lsm context into which result is put
+ *
+ * Translate secid information into a secctx string.
+ * Return a negative value on error.
+ * If cp is NULL return the length of the string.
+ * Otherwise, return 0.
+ */
+int security_secid_to_secctx(struct lsmblob *blob, struct lsmcontext *cp)
 {
 	struct security_hook_list *hp;
 	int ilsm = lsm_task_ilsm(current);
 
+	if (cp)
+		memset(cp, 0, sizeof(*cp));
+
 	hlist_for_each_entry(hp, &security_hook_heads.secid_to_secctx, list) {
 		if (WARN_ON(hp->lsmid->slot < 0 || hp->lsmid->slot >= lsm_slot))
 			continue;
-		if (ilsm == LSMBLOB_INVALID || ilsm == hp->lsmid->slot)
+		if (ilsm == LSMBLOB_INVALID || ilsm == hp->lsmid->slot) {
+			if (!cp) {
+				int len;
+				int rc;
+				rc = hp->hook.secid_to_secctx(
+					blob->secid[hp->lsmid->slot],
+					NULL, &len);
+				return rc ? rc : len;
+			}
+			cp->slot = hp->lsmid->slot;
 			return hp->hook.secid_to_secctx(
 					blob->secid[hp->lsmid->slot],
-					secdata, seclen);
+					&cp->context, &cp->len);
+		}
 	}
 
 	return LSM_RET_DEFAULT(secid_to_secctx);
-- 
2.31.1

