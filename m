Return-Path: <netdev+bounces-9226-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 32B1D72813A
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 15:22:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DC1C12815AF
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 13:22:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D624A14273;
	Thu,  8 Jun 2023 13:21:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C373614271
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 13:21:19 +0000 (UTC)
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33B5C2718
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 06:21:16 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id 5b1f17b1804b1-3f735259fa0so5313665e9.1
        for <netdev@vger.kernel.org>; Thu, 08 Jun 2023 06:21:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google; t=1686230474; x=1688822474;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5dgkaWGIfYIbjljhSSlh7Bmui4uwpN0SWAU+QRT80As=;
        b=qVAR2ecucVW+p4KXptaFvsaVrHzHixMpWlKsxEGJts241bm/oGRDCL1YLdMk7NZlka
         c16QlEhOhb8Xok7xMrxaLudpRz5AioYlJqP6RKZtwORKwyqWuRO6ydKSGlSQ+0Hrw13F
         iE855DdN7YYdoEtLEHn0GSSjAq+NTa1uVvWAocNBhMojymEbsxj3zjmUfhSM8CI8L3M7
         UHttyyevHVgcUnAPGH3o6YvlrqMIiIj/PRX02FESZJqggOR3gU01o5+Nzqjat3GISqjL
         t9yo+J7RIiSAI16EgWM7bpAeEQDhPbcPWP/eUrzXdgvJGsWP2Iwsk8aAflxOTEPGaOjB
         pjSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686230474; x=1688822474;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5dgkaWGIfYIbjljhSSlh7Bmui4uwpN0SWAU+QRT80As=;
        b=PGJciNybFh75qtrnwcE1RmfCccgX42pTqa+4DWbQbK3QGHD5A/LS1T+4IZcthG821o
         M+fpufsyvdkxZr9GS6ZBqDrX01jRCqAWUo/N85NZjMezzzAfg9CF2DrRoIJD/ubfG9ph
         i+KHPcQtm5thM3zGqyz5SBD3mWhLmk24fU1duHvGHJmgXQgPHZJvOV6k69Q4QDWlJRvr
         vt4jqLtMclLbYl94WPhGvKNSHrE/0ZcoVRznIecF6ixjzM658Iw5nWrX3PSDt3sn40g+
         Gekj/nWF/xuEN6+aeB2t9JXPm1/wlXHzmBRf8DzeNi6nMCwk8yc4ahnMNoIBlvnfwZ4D
         kbOQ==
X-Gm-Message-State: AC+VfDyHMsQtgXV+7AzVDWv60XkFpwUyh+L1ndJqiuAHyPK3W1CLLdNX
	rRR+p4FFHONLbVbGcso9gIEkYw==
X-Google-Smtp-Source: ACHHUZ7GKhT4PGtrRwd2EjBY7POS6tiFhG/vYnfkIR8eZzcVxZVyeRyLRmYaK/m2Lo+UOWjBhvqiBA==
X-Received: by 2002:a7b:c019:0:b0:3f7:f884:7be4 with SMTP id c25-20020a7bc019000000b003f7f8847be4mr1412169wmb.21.1686230474701;
        Thu, 08 Jun 2023 06:21:14 -0700 (PDT)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id 16-20020a05600c021000b003f7f1b3aff1sm5001100wmi.26.2023.06.08.06.21.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jun 2023 06:21:14 -0700 (PDT)
From: Matthieu Baerts <matthieu.baerts@tessares.net>
Date: Thu, 08 Jun 2023 15:20:52 +0200
Subject: [PATCH net-next 4/4] mptcp: unify pm set_flags interfaces
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230608-upstream-net-next-20230608-mptcp-unify-pm-interfaces-v1-4-b301717c9ff5@tessares.net>
References: <20230608-upstream-net-next-20230608-mptcp-unify-pm-interfaces-v1-0-b301717c9ff5@tessares.net>
In-Reply-To: <20230608-upstream-net-next-20230608-mptcp-unify-pm-interfaces-v1-0-b301717c9ff5@tessares.net>
To: mptcp@lists.linux.dev, Mat Martineau <martineau@kernel.org>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Geliang Tang <geliang.tang@suse.com>, 
 Matthieu Baerts <matthieu.baerts@tessares.net>
X-Mailer: b4 0.12.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=5515;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=nAiGoxd4O08hlaui72f0yC95azIdQnaelnxY4OLX1JU=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBkgdXFAQhBRtbu0GqjM4u9CPn+H7ZdGkwZJFZpk
 Fge/YuAqXCJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCZIHVxQAKCRD2t4JPQmmg
 czUoD/48REKp6Kc18uG+cTTanHAy8TD8YOPHfsBVfzp8iXOdGJrzHrvKaRllLEOIKNk9XMLEtBF
 hu5b+Fz5MftBaMTRX1WRjRF/zwZ+XcB74rSt0vvm6GxwXTqdD0XN9jBPAHyNmMl55mFXCPnma4c
 O1PhcLJ4fbuivb5JdIw6D8XLDovfPrB4tKqxPK5hSi2q63uEFSnRU4pdgs3Z7djtxHPNcl6WNyF
 3Hy7SQHDnmEhIxgA3MKDMQhoM4dsWl+XDUdwETLHVmxHhneIc5jZRpL71h3yV5WNH2VNAqjo3R6
 erxFonYMx1LsV2sisNO05Z9oG2BmJYFdFiMk3+NqQpdFaTHBK9gaCMUp3MpqlHazQFjDobUGy0o
 22SjA3QugvXcorEBskWRvfaHLj/PvSjf31GXoSIY+PifxXDH13Dt56YeGLmwuaA4ZJrFYZ23C0C
 B16P3w193SPyZRaYvpggSr6XARWYhFw0szX2wNCWY/ZTBnc9UriVeeaNeBa4jEO+0wWdmeREnPi
 AE+lc8/MQIsFkIOBH6mg9cXciLLQRXJF3U6R9f2Y+HAHrMrGqkcGYxwRde+Nc2E00VV681sj77l
 FCX0QW8EOlPvgCdZ3ke5W46s1tbkdjnNsRueVKA1nSLLQxAvMjX4GNdfCjJqd0rH0YoHNZfUo7i
 5HguWofxWARmYNw==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp;
 fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Geliang Tang <geliang.tang@suse.com>

This patch unifies the three PM set_flags() interfaces:

mptcp_pm_nl_set_flags() in mptcp/pm_netlink.c for the in-kernel PM and
mptcp_userspace_pm_set_flags() in mptcp/pm_userspace.c for the
userspace PM.

They'll be switched in the common PM infterface mptcp_pm_set_flags() in
mptcp/pm.c based on whether token is NULL or not.

Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 net/mptcp/pm.c         |  9 +++++++
 net/mptcp/pm_netlink.c | 70 +++++++++++++++++++++++++++-----------------------
 net/mptcp/protocol.h   |  4 +++
 3 files changed, 51 insertions(+), 32 deletions(-)

diff --git a/net/mptcp/pm.c b/net/mptcp/pm.c
index 2d04598dde05..36bf9196168b 100644
--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -433,6 +433,15 @@ int mptcp_pm_get_flags_and_ifindex_by_id(struct mptcp_sock *msk, unsigned int id
 	return mptcp_pm_nl_get_flags_and_ifindex_by_id(msk, id, flags, ifindex);
 }
 
+int mptcp_pm_set_flags(struct net *net, struct nlattr *token,
+		       struct mptcp_pm_addr_entry *loc,
+		       struct mptcp_pm_addr_entry *rem, u8 bkup)
+{
+	if (token)
+		return mptcp_userspace_pm_set_flags(net, token, loc, rem, bkup);
+	return mptcp_pm_nl_set_flags(net, loc, bkup);
+}
+
 void mptcp_pm_subflow_chk_stale(const struct mptcp_sock *msk, struct sock *ssk)
 {
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(ssk);
diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index e8b32d369f11..13be9205d36d 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -1864,18 +1864,50 @@ static int mptcp_nl_set_flags(struct net *net,
 	return ret;
 }
 
+int mptcp_pm_nl_set_flags(struct net *net, struct mptcp_pm_addr_entry *addr, u8 bkup)
+{
+	struct pm_nl_pernet *pernet = pm_nl_get_pernet(net);
+	u8 changed, mask = MPTCP_PM_ADDR_FLAG_BACKUP |
+			   MPTCP_PM_ADDR_FLAG_FULLMESH;
+	struct mptcp_pm_addr_entry *entry;
+	u8 lookup_by_id = 0;
+
+	if (addr->addr.family == AF_UNSPEC) {
+		lookup_by_id = 1;
+		if (!addr->addr.id)
+			return -EOPNOTSUPP;
+	}
+
+	spin_lock_bh(&pernet->lock);
+	entry = __lookup_addr(pernet, &addr->addr, lookup_by_id);
+	if (!entry) {
+		spin_unlock_bh(&pernet->lock);
+		return -EINVAL;
+	}
+	if ((addr->flags & MPTCP_PM_ADDR_FLAG_FULLMESH) &&
+	    (entry->flags & MPTCP_PM_ADDR_FLAG_SIGNAL)) {
+		spin_unlock_bh(&pernet->lock);
+		return -EINVAL;
+	}
+
+	changed = (addr->flags ^ entry->flags) & mask;
+	entry->flags = (entry->flags & ~mask) | (addr->flags & mask);
+	*addr = *entry;
+	spin_unlock_bh(&pernet->lock);
+
+	mptcp_nl_set_flags(net, &addr->addr, bkup, changed);
+	return 0;
+}
+
 static int mptcp_nl_cmd_set_flags(struct sk_buff *skb, struct genl_info *info)
 {
-	struct mptcp_pm_addr_entry addr = { .addr = { .family = AF_UNSPEC }, }, *entry;
 	struct mptcp_pm_addr_entry remote = { .addr = { .family = AF_UNSPEC }, };
+	struct mptcp_pm_addr_entry addr = { .addr = { .family = AF_UNSPEC }, };
 	struct nlattr *attr_rem = info->attrs[MPTCP_PM_ATTR_ADDR_REMOTE];
 	struct nlattr *token = info->attrs[MPTCP_PM_ATTR_TOKEN];
 	struct nlattr *attr = info->attrs[MPTCP_PM_ATTR_ADDR];
-	struct pm_nl_pernet *pernet = genl_info_pm_nl(info);
-	u8 changed, mask = MPTCP_PM_ADDR_FLAG_BACKUP |
-			   MPTCP_PM_ADDR_FLAG_FULLMESH;
 	struct net *net = sock_net(skb->sk);
-	u8 bkup = 0, lookup_by_id = 0;
+	u8 bkup = 0;
 	int ret;
 
 	ret = mptcp_pm_parse_entry(attr, info, false, &addr);
@@ -1890,34 +1922,8 @@ static int mptcp_nl_cmd_set_flags(struct sk_buff *skb, struct genl_info *info)
 
 	if (addr.flags & MPTCP_PM_ADDR_FLAG_BACKUP)
 		bkup = 1;
-	if (addr.addr.family == AF_UNSPEC) {
-		lookup_by_id = 1;
-		if (!addr.addr.id)
-			return -EOPNOTSUPP;
-	}
 
-	if (token)
-		return mptcp_userspace_pm_set_flags(net, token, &addr, &remote, bkup);
-
-	spin_lock_bh(&pernet->lock);
-	entry = __lookup_addr(pernet, &addr.addr, lookup_by_id);
-	if (!entry) {
-		spin_unlock_bh(&pernet->lock);
-		return -EINVAL;
-	}
-	if ((addr.flags & MPTCP_PM_ADDR_FLAG_FULLMESH) &&
-	    (entry->flags & MPTCP_PM_ADDR_FLAG_SIGNAL)) {
-		spin_unlock_bh(&pernet->lock);
-		return -EINVAL;
-	}
-
-	changed = (addr.flags ^ entry->flags) & mask;
-	entry->flags = (entry->flags & ~mask) | (addr.flags & mask);
-	addr = *entry;
-	spin_unlock_bh(&pernet->lock);
-
-	mptcp_nl_set_flags(net, &addr.addr, bkup, changed);
-	return 0;
+	return mptcp_pm_set_flags(net, token, &addr, &remote, bkup);
 }
 
 static void mptcp_nl_mcast_send(struct net *net, struct sk_buff *nlskb, gfp_t gfp)
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 607cbd2ccb98..1e7465bb66d5 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -827,6 +827,10 @@ int mptcp_pm_nl_get_flags_and_ifindex_by_id(struct mptcp_sock *msk, unsigned int
 int mptcp_userspace_pm_get_flags_and_ifindex_by_id(struct mptcp_sock *msk,
 						   unsigned int id,
 						   u8 *flags, int *ifindex);
+int mptcp_pm_set_flags(struct net *net, struct nlattr *token,
+		       struct mptcp_pm_addr_entry *loc,
+		       struct mptcp_pm_addr_entry *rem, u8 bkup);
+int mptcp_pm_nl_set_flags(struct net *net, struct mptcp_pm_addr_entry *addr, u8 bkup);
 int mptcp_userspace_pm_set_flags(struct net *net, struct nlattr *token,
 				 struct mptcp_pm_addr_entry *loc,
 				 struct mptcp_pm_addr_entry *rem, u8 bkup);

-- 
2.40.1


