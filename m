Return-Path: <netdev+bounces-9225-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 55987728135
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 15:22:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 64CE81C21022
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 13:22:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DDB112B9C;
	Thu,  8 Jun 2023 13:21:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5058813ADC
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 13:21:19 +0000 (UTC)
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3834526B3
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 06:21:15 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id 5b1f17b1804b1-3f735bfcbbbso3902775e9.2
        for <netdev@vger.kernel.org>; Thu, 08 Jun 2023 06:21:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google; t=1686230473; x=1688822473;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NSwaV8frgP+BsYdMJSEI28hJ+VH7kpitse/TkoXMDpU=;
        b=rilF142TtI9Re4yJ+CLPrruyPWByld4nvPKVBApP6xKp7kfR/KIPO7c/SrdtN47Q2t
         mC5TJOAvOuCUI8WGcjXz9Tm88ijvKDPIbP+3JC/hb/Zy87bgCL3c44YDbMA8WNFW9Kzo
         fE71XZWZ8NBkgj1pFJGWeSfTbDSSEnOIg5QaYpq4ZK+vK/AQ3ZcCSsm5aMcC2PbQUXUW
         0KhA8ueN+rZ+pPOuOo5ym32tsBWQGQjOhBzrC5Uk7i0NWeaudcsFVC5UBH8X22aa5VSA
         6liaOy2NBmOsNouz/JU8m6rLnBcVroho8ZxBWJ2m5NElSDZZpjVZRbkIhfko52Wg4u/8
         OPiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686230473; x=1688822473;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NSwaV8frgP+BsYdMJSEI28hJ+VH7kpitse/TkoXMDpU=;
        b=Vw2T/IfVq++ZlmSkPVupOF87dN1g25mpKENqsYb2Ak7sksld81F7AFRDowSrRb/44f
         50oJfhyf5Ld7ms70CAORpSmBw4gBNNYcrpTqZLAJ9hxzDxe+agrkiIAp6IbBDgw6WMh9
         JIoXMdalBCgKXVY8IfSDQaAJO/GETfab4RWVK8Y8LVEq++4og/IrPW938H8nRaw+oMHI
         5mttgZB6k7mg6n7yB8OV5+ZRazhOtgMa7hDupAPuhqE5rnm7/b0YahbRODFp1WeFUFgu
         Ml/apSq/nZ25PZC+hy3NVAJcIgyss1DDrvx3h0AHebXHumKL/t1gVvughgoEovhVypum
         Q97Q==
X-Gm-Message-State: AC+VfDxe5+PYFBkI1Y37bIGdRo0KaW5dc+fRozjm9TCZBnAcgLc5E+W2
	xdzd5en5RkByqf1lTohsBYA/xw==
X-Google-Smtp-Source: ACHHUZ4ENJUz1YdroCW/FRdhUz0xLpU9qz/hy7P4iAZi3MrjLSaexl/UcNwLN69N/+sQbEAHDeFZGA==
X-Received: by 2002:a1c:7c0d:0:b0:3f6:f152:1183 with SMTP id x13-20020a1c7c0d000000b003f6f1521183mr1441901wmc.37.1686230473699;
        Thu, 08 Jun 2023 06:21:13 -0700 (PDT)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id 16-20020a05600c021000b003f7f1b3aff1sm5001100wmi.26.2023.06.08.06.21.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jun 2023 06:21:13 -0700 (PDT)
From: Matthieu Baerts <matthieu.baerts@tessares.net>
Date: Thu, 08 Jun 2023 15:20:51 +0200
Subject: [PATCH net-next 3/4] mptcp: unify pm get_flags_and_ifindex_by_id
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230608-upstream-net-next-20230608-mptcp-unify-pm-interfaces-v1-3-b301717c9ff5@tessares.net>
References: <20230608-upstream-net-next-20230608-mptcp-unify-pm-interfaces-v1-0-b301717c9ff5@tessares.net>
In-Reply-To: <20230608-upstream-net-next-20230608-mptcp-unify-pm-interfaces-v1-0-b301717c9ff5@tessares.net>
To: mptcp@lists.linux.dev, Mat Martineau <martineau@kernel.org>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Geliang Tang <geliang.tang@suse.com>, 
 Matthieu Baerts <matthieu.baerts@tessares.net>
X-Mailer: b4 0.12.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=4069;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=5nDr9M7v5Mf80NDixMM7FPrdaFJMIldEDth/6RZgYhg=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBkgdXFgoTtiSJCP9CGOJ/S5Y8wlsdZcfEsuGk0z
 vqPlL1i0HOJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCZIHVxQAKCRD2t4JPQmmg
 c+sWD/91DLbuH2odrwHtoGbvYHh6JKcUMBF4JZuuj8Kqa91+9NrVaGqdy0inki2k9/vpH46Rvqu
 O0kABJTas7MMPwIYvxVQoY2VBdwNnKh65ADv4UCzElb/jIph6yr0EEQrAOZ8FhnhiQyfP1pLglP
 lsGwBvPrIUJkLMsWt8aaYBHb3Sg+dXN4OehZGULDnl2KbE633yMRr8+hn9hsHf0S0Y5sjIfJLGF
 pokZUAhDySwtRC284Oq/ea5AXYmrmzT7Js0I+dIFk3nTbw7JwMP3aZ8UPeC2dbZL/+WxSbyFQXF
 aXkEUkorTeesliyUHgx13TaEO45kUWECEhxQndDiIN/eXE5OBxn0CeyRXt82OAcwQs/INUQksON
 PbGW1Hnbxnzj6bvVNG+jHKVBs70D/r4watCKjJYRVqeoC++ndJ4HrDJuPdP1HFnbuW3HKUpTYw5
 tKYQarydPhmD2btUaqUQB/aXPyegTC0RGAklanVIB8NLbKuRdcfKYJm1bhV8dKGYaI6F/WvNxnK
 yH765OZy6x667VWlcWdOrWufpAl9aJKSmjIQOxP6PaJNvZYpTnjlZRhQ+Uta5odYgyIYE8xyQ+p
 HHHOdad02GNDw4Fy5hraX1YRnBat/kScnEw9dXLkrT2BZaBLCYxw1WvyjnnFmJHtgOugXCCoUjL
 kXa3DTfQ6B062Lw==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp;
 fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Geliang Tang <geliang.tang@suse.com>

This patch unifies the three PM get_flags_and_ifindex_by_id() interfaces:

mptcp_pm_nl_get_flags_and_ifindex_by_id() in mptcp/pm_netlink.c for the
in-kernel PM and mptcp_userspace_pm_get_flags_and_ifindex_by_id() in
mptcp/pm_userspace.c for the userspace PM.

They'll be switched in the common PM infterface
mptcp_pm_get_flags_and_ifindex_by_id() in mptcp/pm.c based on whether
mptcp_pm_is_userspace() or not.

Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 net/mptcp/pm.c           | 14 ++++++++++++++
 net/mptcp/pm_netlink.c   | 27 ++++++++-------------------
 net/mptcp/pm_userspace.c |  3 ---
 net/mptcp/protocol.h     |  2 ++
 4 files changed, 24 insertions(+), 22 deletions(-)

diff --git a/net/mptcp/pm.c b/net/mptcp/pm.c
index 5a027a46196c..2d04598dde05 100644
--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -419,6 +419,20 @@ int mptcp_pm_get_local_id(struct mptcp_sock *msk, struct sock_common *skc)
 	return mptcp_pm_nl_get_local_id(msk, &skc_local);
 }
 
+int mptcp_pm_get_flags_and_ifindex_by_id(struct mptcp_sock *msk, unsigned int id,
+					 u8 *flags, int *ifindex)
+{
+	*flags = 0;
+	*ifindex = 0;
+
+	if (!id)
+		return 0;
+
+	if (mptcp_pm_is_userspace(msk))
+		return mptcp_userspace_pm_get_flags_and_ifindex_by_id(msk, id, flags, ifindex);
+	return mptcp_pm_nl_get_flags_and_ifindex_by_id(msk, id, flags, ifindex);
+}
+
 void mptcp_pm_subflow_chk_stale(const struct mptcp_sock *msk, struct sock *ssk)
 {
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(ssk);
diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 315ad669eb3c..e8b32d369f11 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -1356,31 +1356,20 @@ static int mptcp_nl_cmd_add_addr(struct sk_buff *skb, struct genl_info *info)
 	return ret;
 }
 
-int mptcp_pm_get_flags_and_ifindex_by_id(struct mptcp_sock *msk, unsigned int id,
-					 u8 *flags, int *ifindex)
+int mptcp_pm_nl_get_flags_and_ifindex_by_id(struct mptcp_sock *msk, unsigned int id,
+					    u8 *flags, int *ifindex)
 {
 	struct mptcp_pm_addr_entry *entry;
 	struct sock *sk = (struct sock *)msk;
 	struct net *net = sock_net(sk);
 
-	*flags = 0;
-	*ifindex = 0;
-
-	if (id) {
-		if (mptcp_pm_is_userspace(msk))
-			return mptcp_userspace_pm_get_flags_and_ifindex_by_id(msk,
-									      id,
-									      flags,
-									      ifindex);
-
-		rcu_read_lock();
-		entry = __lookup_addr_by_id(pm_nl_get_pernet(net), id);
-		if (entry) {
-			*flags = entry->flags;
-			*ifindex = entry->ifindex;
-		}
-		rcu_read_unlock();
+	rcu_read_lock();
+	entry = __lookup_addr_by_id(pm_nl_get_pernet(net), id);
+	if (entry) {
+		*flags = entry->flags;
+		*ifindex = entry->ifindex;
 	}
+	rcu_read_unlock();
 
 	return 0;
 }
diff --git a/net/mptcp/pm_userspace.c b/net/mptcp/pm_userspace.c
index 27a275805c06..e1df3a4a4f23 100644
--- a/net/mptcp/pm_userspace.c
+++ b/net/mptcp/pm_userspace.c
@@ -85,9 +85,6 @@ int mptcp_userspace_pm_get_flags_and_ifindex_by_id(struct mptcp_sock *msk,
 {
 	struct mptcp_pm_addr_entry *entry, *match = NULL;
 
-	*flags = 0;
-	*ifindex = 0;
-
 	spin_lock_bh(&msk->pm.lock);
 	list_for_each_entry(entry, &msk->pm.userspace_pm_local_addr_list, list) {
 		if (id == entry->addr.id) {
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 8a2e01d10582..607cbd2ccb98 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -822,6 +822,8 @@ mptcp_lookup_anno_list_by_saddr(const struct mptcp_sock *msk,
 int mptcp_pm_get_flags_and_ifindex_by_id(struct mptcp_sock *msk,
 					 unsigned int id,
 					 u8 *flags, int *ifindex);
+int mptcp_pm_nl_get_flags_and_ifindex_by_id(struct mptcp_sock *msk, unsigned int id,
+					    u8 *flags, int *ifindex);
 int mptcp_userspace_pm_get_flags_and_ifindex_by_id(struct mptcp_sock *msk,
 						   unsigned int id,
 						   u8 *flags, int *ifindex);

-- 
2.40.1


