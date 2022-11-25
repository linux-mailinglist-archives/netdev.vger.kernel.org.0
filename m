Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD661639164
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 23:30:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbiKYWaj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 17:30:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229796AbiKYWah (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 17:30:37 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D0BC2F663
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 14:30:26 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id v8so8062814edi.3
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 14:30:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3+iaKMj6vM07FzBDqChWLVnPYDyo0Nn9qPkX/3MkG3E=;
        b=6OgZaR2nQdc6rEQXwfoAcYKQhdg7Ctyin9pg3pUVi2fxz/fg46y/29DSKmXnC43RY6
         LP9LxxRlU/YIhVE1bRT6pZTQGaykUSH3onQrR6AeXDRGYy09+qNbGDzN5PJq8ioQndez
         fGoOi1zucvr8SwkugTzkQH2Tw/dLOm3t4fIurw9gI/ubbkcE4N6CagOPWNYa/6hAwTuM
         i7GawJpEG4l+uye6o50ERLfTygP5guTbLWQ0vTLzrZ/6H+LZI/X6KopvjzPeO5/1GhBr
         jTSgZlPIG7Rrprl3S69/QhN/KfjYeza0ILtxBluWs+lJgQqd7NFSagmid+nM310JkmC5
         gvNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3+iaKMj6vM07FzBDqChWLVnPYDyo0Nn9qPkX/3MkG3E=;
        b=7lP94sioLjgKobFbdAyOvUcshd6Br3osDH9lIBZ83SqxukUeQhD2q9vP4y6ELYBeSM
         p08MuTmPp61lc8uiw+4b5/SzguQT9yPaiBVr20XzseQoJbPg4WeDbKnP7RzrkuEX7nyc
         O+D1mFx7Q5x0IWgUFRI9LzumHhk4MI68E9nP9sJ9aRN73CMM1h5sTVPKK7hEjfBNIP8K
         /WG8Dl39BEmfeP0lPlylIhdoa6dr7XCDSnSx7ucKNFg9Lo8ZZoJ6+eNbHGyG0104iWli
         6I0INPqrDa1J/KeX4WHjH1XU6dAKV9Wuh60dvoHyt5gzu7LgF29PLH9wcI+J0LDveCU3
         hxRg==
X-Gm-Message-State: ANoB5pmbUleYph2xWzIOj+vCZfzbDuOx3wse9Y2Kd5sWgil/j6qagPOb
        flcA3Qd5neggNGwD4NltH2MOMQ==
X-Google-Smtp-Source: AA0mqf75aQmXuIJnzqonR/GCwbME0YlsXfN07/qo5e850KEL7NG8uGVa0nxL2T/30u0bF5A+2Ag5mw==
X-Received: by 2002:aa7:c7c4:0:b0:467:4a80:719b with SMTP id o4-20020aa7c7c4000000b004674a80719bmr20818257eds.174.1669415425720;
        Fri, 25 Nov 2022 14:30:25 -0800 (PST)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id q1-20020a056402248100b0046267f8150csm2254612eda.19.2022.11.25.14.30.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Nov 2022 14:30:25 -0800 (PST)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Dmytro Shytyi <dmytro@shytyi.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, mptcp@lists.linux.dev
Subject: [PATCH net-next 4/8] mptcp: implement delayed seq generation for passive fastopen
Date:   Fri, 25 Nov 2022 23:29:50 +0100
Message-Id: <20221125222958.958636-5-matthieu.baerts@tessares.net>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221125222958.958636-1-matthieu.baerts@tessares.net>
References: <20221125222958.958636-1-matthieu.baerts@tessares.net>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=7192; i=matthieu.baerts@tessares.net;
 h=from:subject; bh=LzNK76T2xhDCrjtYhvmmyVzad5gtt3rl6eOeAbZ4HpY=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBjgUHPfkkPLmIR4DfOXhjCycprC2hlqfrj+njIAVPu
 IT0uQ7OJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCY4FBzwAKCRD2t4JPQmmgcz9gD/
 0dgTUCsYbxFNJeyyTZcv7c2uj7NVuPjJJ9R2YGWhkpgAIDRunLfyEKeJ7+3x0fUv6ITA+8UXRJTyP9
 toGuj+XeOqk3v6KhcDjP58v42jRN9HdFnjlCPgX+N3zZwfrO4HWs/ix97ajq7GxqgYkyFafwdCxnDp
 lfMsXHXea7rK3f0/UySE6UdGj6aV0Rr0NgDyVwUF7yMJYeIrjqVVpPN7WE3Id4N9fe13WC3ZPZtfO9
 fDfefwfsLocr5Bxhx1oWUnhhs34MyTZPVhHVD2UlOf9xmwWuhf5K3N+iAjR50BHvRBd3nm93MFczUZ
 IMYxIuqVyTMC1GvNd19RUbsajltR3+B5SpX8LKu46UGRPPPVlRSiNdQj2fCZ4DSWYWiO6APkAKSpnR
 4P12Nd6oVx5LI28jgEpRfl1KqKtNLORG/19RaAlpRCXLzNM6r9jm6y0b+yrT+zga0gihOwup1d9ClL
 ip05Ftw0Tqa0pHXEajObG97+3W5clw5YUl7Hj5615zp2CG78IxuWFn29BTYpu3sOwFEybz6HIUNLWX
 RALDryaVLMOiCYZ9Nmw/8wplMXRtn5efaZ1aGGkPpvdRTfjOAR0tu2v52/Y5Ceqm1vJR+mwnXZiwmx
 66afhU1E0cM4PGgqHoyz/Vwo1TS4ICWDKynqjC9jXE5k5larSEpcPWKkqNCQ==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp; fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmytro Shytyi <dmytro@shytyi.net>

With fastopen in place, the first subflow socket is created before the
MPC handshake completes, and we need to properly initialize the sequence
numbers at MPC ACK reception.

Co-developed-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Co-developed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Dmytro Shytyi <dmytro@shytyi.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 net/mptcp/Makefile   |  2 +-
 net/mptcp/fastopen.c | 28 ++++++++++++++++++++++++++++
 net/mptcp/options.c  |  9 ++++++---
 net/mptcp/protocol.c |  9 ---------
 net/mptcp/protocol.h | 16 +++++++++++++++-
 net/mptcp/subflow.c  |  5 ++++-
 6 files changed, 54 insertions(+), 15 deletions(-)
 create mode 100644 net/mptcp/fastopen.c

diff --git a/net/mptcp/Makefile b/net/mptcp/Makefile
index 6e7df47c9584..a3829ce548f9 100644
--- a/net/mptcp/Makefile
+++ b/net/mptcp/Makefile
@@ -2,7 +2,7 @@
 obj-$(CONFIG_MPTCP) += mptcp.o
 
 mptcp-y := protocol.o subflow.o options.o token.o crypto.o ctrl.o pm.o diag.o \
-	   mib.o pm_netlink.o sockopt.o pm_userspace.o
+	   mib.o pm_netlink.o sockopt.o pm_userspace.o fastopen.o
 
 obj-$(CONFIG_SYN_COOKIES) += syncookies.o
 obj-$(CONFIG_INET_MPTCP_DIAG) += mptcp_diag.o
diff --git a/net/mptcp/fastopen.c b/net/mptcp/fastopen.c
new file mode 100644
index 000000000000..19c332af0834
--- /dev/null
+++ b/net/mptcp/fastopen.c
@@ -0,0 +1,28 @@
+// SPDX-License-Identifier: GPL-2.0
+/* MPTCP Fast Open Mechanism
+ *
+ * Copyright (c) 2021-2022, Dmytro SHYTYI
+ */
+
+#include "protocol.h"
+
+void mptcp_fastopen_gen_msk_ackseq(struct mptcp_sock *msk, struct mptcp_subflow_context *subflow,
+				   const struct mptcp_options_received *mp_opt)
+{
+	struct sock *sk = (struct sock *)msk;
+	struct sk_buff *skb;
+
+	mptcp_data_lock(sk);
+	skb = skb_peek_tail(&sk->sk_receive_queue);
+	if (skb) {
+		WARN_ON_ONCE(MPTCP_SKB_CB(skb)->end_seq);
+		pr_debug("msk %p moving seq %llx -> %llx end_seq %llx -> %llx", sk,
+			 MPTCP_SKB_CB(skb)->map_seq, MPTCP_SKB_CB(skb)->map_seq + msk->ack_seq,
+			 MPTCP_SKB_CB(skb)->end_seq, MPTCP_SKB_CB(skb)->end_seq + msk->ack_seq);
+		MPTCP_SKB_CB(skb)->map_seq += msk->ack_seq;
+		MPTCP_SKB_CB(skb)->end_seq += msk->ack_seq;
+	}
+
+	pr_debug("msk=%p ack_seq=%llx", msk, msk->ack_seq);
+	mptcp_data_unlock(sk);
+}
diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index ae076468fcb9..5ded85e2c374 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -939,7 +939,7 @@ static bool check_fully_established(struct mptcp_sock *msk, struct sock *ssk,
 		    subflow->mp_join && (mp_opt->suboptions & OPTIONS_MPTCP_MPJ) &&
 		    !subflow->request_join)
 			tcp_send_ack(ssk);
-		goto fully_established;
+		goto check_notify;
 	}
 
 	/* we must process OoO packets before the first subflow is fully
@@ -950,6 +950,8 @@ static bool check_fully_established(struct mptcp_sock *msk, struct sock *ssk,
 	if (TCP_SKB_CB(skb)->seq != subflow->ssn_offset + 1) {
 		if (subflow->mp_join)
 			goto reset;
+		if (subflow->is_mptfo && mp_opt->suboptions & OPTION_MPTCP_MPC_ACK)
+			goto set_fully_established;
 		return subflow->mp_capable;
 	}
 
@@ -961,7 +963,7 @@ static bool check_fully_established(struct mptcp_sock *msk, struct sock *ssk,
 		 */
 		subflow->fully_established = 1;
 		WRITE_ONCE(msk->fully_established, true);
-		goto fully_established;
+		goto check_notify;
 	}
 
 	/* If the first established packet does not contain MP_CAPABLE + data
@@ -980,11 +982,12 @@ static bool check_fully_established(struct mptcp_sock *msk, struct sock *ssk,
 	if (mp_opt->deny_join_id0)
 		WRITE_ONCE(msk->pm.remote_deny_join_id0, true);
 
+set_fully_established:
 	if (unlikely(!READ_ONCE(msk->pm.server_side)))
 		pr_warn_once("bogus mpc option on established client sk");
 	mptcp_subflow_fully_established(subflow, mp_opt);
 
-fully_established:
+check_notify:
 	/* if the subflow is not already linked into the conn_list, we can't
 	 * notify the PM: this subflow is still on the listener queue
 	 * and the PM possibly acquiring the subflow lock could race with
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 00de7f4fce10..a12ee763e52c 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -36,15 +36,6 @@ struct mptcp6_sock {
 };
 #endif
 
-struct mptcp_skb_cb {
-	u64 map_seq;
-	u64 end_seq;
-	u32 offset;
-	u8  has_rxtstamp:1;
-};
-
-#define MPTCP_SKB_CB(__skb)	((struct mptcp_skb_cb *)&((__skb)->cb[0]))
-
 enum {
 	MPTCP_CMSG_TS = BIT(0),
 	MPTCP_CMSG_INQ = BIT(1),
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index b5abea3d1a9c..618ac85abaaf 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -126,6 +126,15 @@
 #define MPTCP_CONNECTED		6
 #define MPTCP_RESET_SCHEDULER	7
 
+struct mptcp_skb_cb {
+	u64 map_seq;
+	u64 end_seq;
+	u32 offset;
+	u8  has_rxtstamp:1;
+};
+
+#define MPTCP_SKB_CB(__skb)	((struct mptcp_skb_cb *)&((__skb)->cb[0]))
+
 static inline bool before64(__u64 seq1, __u64 seq2)
 {
 	return (__s64)(seq1 - seq2) < 0;
@@ -471,7 +480,9 @@ struct mptcp_subflow_context {
 		disposable : 1,	    /* ctx can be free at ulp release time */
 		stale : 1,	    /* unable to snd/rcv data, do not use for xmit */
 		local_id_valid : 1, /* local_id is correctly initialized */
-		valid_csum_seen : 1;        /* at least one csum validated */
+		valid_csum_seen : 1,        /* at least one csum validated */
+		is_mptfo : 1,	    /* subflow is doing TFO */
+		__unused : 8;
 	enum mptcp_data_avail data_avail;
 	u32	remote_nonce;
 	u64	thmac;
@@ -829,6 +840,9 @@ void mptcp_event_addr_announced(const struct sock *ssk, const struct mptcp_addr_
 void mptcp_event_addr_removed(const struct mptcp_sock *msk, u8 id);
 bool mptcp_userspace_pm_active(const struct mptcp_sock *msk);
 
+void mptcp_fastopen_gen_msk_ackseq(struct mptcp_sock *msk, struct mptcp_subflow_context *subflow,
+				   const struct mptcp_options_received *mp_opt);
+
 static inline bool mptcp_pm_should_add_signal(struct mptcp_sock *msk)
 {
 	return READ_ONCE(msk->pm.addr_signal) &
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 470e12ce0950..21cf26edb79a 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -664,6 +664,9 @@ void mptcp_subflow_fully_established(struct mptcp_subflow_context *subflow,
 	subflow_set_remote_key(msk, subflow, mp_opt);
 	subflow->fully_established = 1;
 	WRITE_ONCE(msk->fully_established, true);
+
+	if (subflow->is_mptfo)
+		mptcp_fastopen_gen_msk_ackseq(msk, subflow, mp_opt);
 }
 
 static struct sock *subflow_syn_recv_sock(const struct sock *sk,
@@ -779,7 +782,7 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 			/* with OoO packets we can reach here without ingress
 			 * mpc option
 			 */
-			if (mp_opt.suboptions & OPTIONS_MPTCP_MPC)
+			if (mp_opt.suboptions & OPTION_MPTCP_MPC_ACK)
 				mptcp_subflow_fully_established(ctx, &mp_opt);
 		} else if (ctx->mp_join) {
 			struct mptcp_sock *owner;
-- 
2.37.2

