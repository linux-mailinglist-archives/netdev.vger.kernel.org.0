Return-Path: <netdev+bounces-9224-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F27EB728130
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 15:21:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4B5751C20FAE
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 13:21:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 452F512B88;
	Thu,  8 Jun 2023 13:21:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3038B12B9C
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 13:21:17 +0000 (UTC)
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 262231BD6
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 06:21:14 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id 5b1f17b1804b1-3f735259fa0so5313315e9.1
        for <netdev@vger.kernel.org>; Thu, 08 Jun 2023 06:21:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google; t=1686230472; x=1688822472;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7gFKa9O69PK+PsR17eSXRUsf4u+mlPVa86DBx+jj43Q=;
        b=E4kfzjF6nZ0wF9rrV3h9waQUQbC8N5mNdnn0mcMbM9TUZROyPEHiCRi76MCUAG4PbN
         sQIO50wLECEwLs9Wsh8PKXc7zvdYY6yLyd2vg8oeX0QJawQHYkZYerI4OG+sdc/uxQje
         KHpjbjFGOYKBD+qXAIXZGLYrM1rKbCdxP25iSLmBRzAsosajIalZhcjaayjG1twYXAuD
         CZETdSOCevHUe3sa4Ef9mbOPRiWaiMgbOuHxyiNg1w5DTzWRsaEH5Tx1pH7tCWgo+DvQ
         HxoZBFuH8u8ZTvz01ckLgVM006o5aDAthiwYbpZgRiiGh22L/rH2k4DJmwKRD1Y8ernG
         WO5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686230472; x=1688822472;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7gFKa9O69PK+PsR17eSXRUsf4u+mlPVa86DBx+jj43Q=;
        b=Kc+zb16H2TkhiPSBUM+51vOU1UsMK+hVAHj3KCRsJysk7Y3wB+eO79yuLU3rU09m60
         j1KHYvpDAYcCgC30s6EUhXnbl3soxMOyfswXw/fAVzGKj2C/pWr1I+tDrIFvcj8Cg9Ru
         Likh6WLyN1MOhIVnPr0UqIv/4LU5pB+DGm9mpEJZq72DSPjF71XjdM1hyjopO5rWZoQ2
         0rmtJjiGr/i1dqzpC4vb63mKA/d8lpNwBG7R6MzvwszfNJvo2F73qUKN2j6WvnQoUyi1
         Nl7Lo3DlYyXnw+xcDU2a24VZsZQG2MpAmA+g9BPD+z1voIi2dCnWdeFMmFf8R4P2DN8A
         0y3Q==
X-Gm-Message-State: AC+VfDzC8WgbZsFnD/NSYEZH39xfD+fpAd4dz7Bu8UZqmWv1fOG0c2pR
	HdeKOp5DQNRfeE5a3ujAnJ1oVA==
X-Google-Smtp-Source: ACHHUZ5ErMlFWY/OUjQNaAn65tolW2rwc31vqqkChytC/yutpz7gKV7MkASYD4fE/0/YptelSMwxmw==
X-Received: by 2002:a7b:c84c:0:b0:3f6:128:36a5 with SMTP id c12-20020a7bc84c000000b003f6012836a5mr1381810wml.10.1686230472470;
        Thu, 08 Jun 2023 06:21:12 -0700 (PDT)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id 16-20020a05600c021000b003f7f1b3aff1sm5001100wmi.26.2023.06.08.06.21.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jun 2023 06:21:12 -0700 (PDT)
From: Matthieu Baerts <matthieu.baerts@tessares.net>
Date: Thu, 08 Jun 2023 15:20:50 +0200
Subject: [PATCH net-next 2/4] mptcp: unify pm get_local_id interfaces
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230608-upstream-net-next-20230608-mptcp-unify-pm-interfaces-v1-2-b301717c9ff5@tessares.net>
References: <20230608-upstream-net-next-20230608-mptcp-unify-pm-interfaces-v1-0-b301717c9ff5@tessares.net>
In-Reply-To: <20230608-upstream-net-next-20230608-mptcp-unify-pm-interfaces-v1-0-b301717c9ff5@tessares.net>
To: mptcp@lists.linux.dev, Mat Martineau <martineau@kernel.org>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Geliang Tang <geliang.tang@suse.com>, 
 Matthieu Baerts <matthieu.baerts@tessares.net>
X-Mailer: b4 0.12.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=4622;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=tn1Eikl6cGHxV4McPMlmq9kj3EGuMT4TIu0o5dG+VYc=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBkgdXFFY+V5/S/ntKomdIzFWXBuGXZ1FTeoQ+Zf
 40xdMwPeT+JAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCZIHVxQAKCRD2t4JPQmmg
 c43TD/4+6+HGmxLfwEtatupGtboJRGks2iO20DsIlcDpFqXOHDlTEM4gR2ArlgKdVOFJmfdS+YE
 Q+xyN+VNYoNeAnHF6OXNStzwihTKHEBEE+hMXo/OD1RmIhCrrhSAIoeomLSr765OfvH6q+/8DAg
 kJJv3jJUjhDTTpfhL5meqYp3T/E0gSycklY4EM0dvEzUa2STYrri9BE14zJVYLTsKb7DicnvXwZ
 m6R0QxoT/eR9stCmqH2gi8Q//7lSZuRRPWTDh+zAKDvz0SsJyyfkhrZQw7puJJnPb7nlUcvHtfR
 vT04u2vYC+18dkGrVJJxiTq4gkkkXk4xd65QAWJxegRuoEU50Y/ZXg9++Fl4eUorIrRipBPou9i
 M0vqbDBaC74oUP5Te6gWwMzlaEU/ZROkHlHa1NqDFIgL+0jwujr4jFI3Hhq9iRGWMI8Xa1CGQLA
 OauclSl8BTUIn8hY6IsiLzLrXgHsRujKPTnCcQh6CHmc5I76G9D1Q8TeGG1mtYYKMLgJXqL8XOJ
 dHoSkDg0Q+j2Oya1TO/rNjOMqnDtw5rRmL0UjxYEiseixoolbUZIOovxIWz47BQY9w9PidV114G
 l7cBS58jIqrqb7e2TqyOpnLiTxzzSZdndnuGfcRscF+E5Hy/u0enLjUAYk+GHCNNN9u0zqSTXb3
 6T9BwH+atG1C46Q==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp;
 fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Geliang Tang <geliang.tang@suse.com>

This patch unifies the three PM get_local_id() interfaces:

mptcp_pm_nl_get_local_id() in mptcp/pm_netlink.c for the in-kernel PM and
mptcp_userspace_pm_get_local_id() in mptcp/pm_userspace.c for the
userspace PM.

They'll be switched in the common PM infterface mptcp_pm_get_local_id()
in mptcp/pm.c based on whether mptcp_pm_is_userspace() or not.

Also put together the declarations of these three functions in protocol.h.

Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 net/mptcp/pm.c         | 18 +++++++++++++++++-
 net/mptcp/pm_netlink.c | 22 +++-------------------
 net/mptcp/protocol.h   |  2 +-
 3 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/net/mptcp/pm.c b/net/mptcp/pm.c
index 7d03b5fd8200..5a027a46196c 100644
--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -400,7 +400,23 @@ bool mptcp_pm_rm_addr_signal(struct mptcp_sock *msk, unsigned int remaining,
 
 int mptcp_pm_get_local_id(struct mptcp_sock *msk, struct sock_common *skc)
 {
-	return mptcp_pm_nl_get_local_id(msk, skc);
+	struct mptcp_addr_info skc_local;
+	struct mptcp_addr_info msk_local;
+
+	if (WARN_ON_ONCE(!msk))
+		return -1;
+
+	/* The 0 ID mapping is defined by the first subflow, copied into the msk
+	 * addr
+	 */
+	mptcp_local_address((struct sock_common *)msk, &msk_local);
+	mptcp_local_address((struct sock_common *)skc, &skc_local);
+	if (mptcp_addresses_equal(&msk_local, &skc_local, false))
+		return 0;
+
+	if (mptcp_pm_is_userspace(msk))
+		return mptcp_userspace_pm_get_local_id(msk, &skc_local);
+	return mptcp_pm_nl_get_local_id(msk, &skc_local);
 }
 
 void mptcp_pm_subflow_chk_stale(const struct mptcp_sock *msk, struct sock *ssk)
diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index c55ed3dda0d8..315ad669eb3c 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -1055,33 +1055,17 @@ static int mptcp_pm_nl_create_listen_socket(struct sock *sk,
 	return 0;
 }
 
-int mptcp_pm_nl_get_local_id(struct mptcp_sock *msk, struct sock_common *skc)
+int mptcp_pm_nl_get_local_id(struct mptcp_sock *msk, struct mptcp_addr_info *skc)
 {
 	struct mptcp_pm_addr_entry *entry;
-	struct mptcp_addr_info skc_local;
-	struct mptcp_addr_info msk_local;
 	struct pm_nl_pernet *pernet;
 	int ret = -1;
 
-	if (WARN_ON_ONCE(!msk))
-		return -1;
-
-	/* The 0 ID mapping is defined by the first subflow, copied into the msk
-	 * addr
-	 */
-	mptcp_local_address((struct sock_common *)msk, &msk_local);
-	mptcp_local_address((struct sock_common *)skc, &skc_local);
-	if (mptcp_addresses_equal(&msk_local, &skc_local, false))
-		return 0;
-
-	if (mptcp_pm_is_userspace(msk))
-		return mptcp_userspace_pm_get_local_id(msk, &skc_local);
-
 	pernet = pm_nl_get_pernet_from_msk(msk);
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(entry, &pernet->local_addr_list, list) {
-		if (mptcp_addresses_equal(&entry->addr, &skc_local, entry->addr.port)) {
+		if (mptcp_addresses_equal(&entry->addr, skc, entry->addr.port)) {
 			ret = entry->addr.id;
 			break;
 		}
@@ -1095,7 +1079,7 @@ int mptcp_pm_nl_get_local_id(struct mptcp_sock *msk, struct sock_common *skc)
 	if (!entry)
 		return -ENOMEM;
 
-	entry->addr = skc_local;
+	entry->addr = *skc;
 	entry->addr.id = 0;
 	entry->addr.port = 0;
 	entry->ifindex = 0;
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 6e6cffc04ced..8a2e01d10582 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -916,13 +916,13 @@ bool mptcp_pm_add_addr_signal(struct mptcp_sock *msk, const struct sk_buff *skb,
 bool mptcp_pm_rm_addr_signal(struct mptcp_sock *msk, unsigned int remaining,
 			     struct mptcp_rm_list *rm_list);
 int mptcp_pm_get_local_id(struct mptcp_sock *msk, struct sock_common *skc);
+int mptcp_pm_nl_get_local_id(struct mptcp_sock *msk, struct mptcp_addr_info *skc);
 int mptcp_userspace_pm_get_local_id(struct mptcp_sock *msk, struct mptcp_addr_info *skc);
 
 void __init mptcp_pm_nl_init(void);
 void mptcp_pm_nl_work(struct mptcp_sock *msk);
 void mptcp_pm_nl_rm_subflow_received(struct mptcp_sock *msk,
 				     const struct mptcp_rm_list *rm_list);
-int mptcp_pm_nl_get_local_id(struct mptcp_sock *msk, struct sock_common *skc);
 unsigned int mptcp_pm_get_add_addr_signal_max(const struct mptcp_sock *msk);
 unsigned int mptcp_pm_get_add_addr_accept_max(const struct mptcp_sock *msk);
 unsigned int mptcp_pm_get_subflows_max(const struct mptcp_sock *msk);

-- 
2.40.1


