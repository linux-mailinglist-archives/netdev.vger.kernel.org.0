Return-Path: <netdev+bounces-5816-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BF721712E46
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 22:42:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2DBD11C21129
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 20:42:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BF5228C06;
	Fri, 26 May 2023 20:42:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47F362CA9
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 20:42:05 +0000 (UTC)
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21CF713A;
	Fri, 26 May 2023 13:41:59 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id 5b1f17b1804b1-3f6cbdf16d2so8150975e9.2;
        Fri, 26 May 2023 13:41:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685133717; x=1687725717;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Jaj5bts2ys56VQ+QWVF3ByEpaCAX5z4OlrYGlYiteV0=;
        b=hZMGftC8dUzxsfwVTC/wIo3MjBnXihNAhVtmlM+kvJ/1sCz7bja+HAhA6VhKwFo8AN
         5uQAv1/MpYs646lBH1hII1Yb9RAk0F/Jjl0bQFvunBeWqwZXkX6kqe4IskjXC2AYwbJ0
         d2U4XharC2SK644yyUUXU070GIhwUJA2hpLtYAPrrnAqR9iR6Ext6zkoXRUgtUGodcnd
         X5atEMi3t1QTszXMm3zEktI3XhE9UstMhc/MglrLdKI1abDkVpkGoL2ZaMEc1IMsDjDI
         9FdggY3Hr/7FQnZSUXhZ+c/scMAwbV0y03iwab1jQhb2S9nnekpDiL8kXxCTEEQphrZx
         pkdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685133717; x=1687725717;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Jaj5bts2ys56VQ+QWVF3ByEpaCAX5z4OlrYGlYiteV0=;
        b=dlHLDIa5yEeWgmKXtKTI3F25MKDyoMiz82jZfAdbKDZlLChPdxag048lgQiI0jLzwY
         Mxbug3Fz35TR7JeCfgu9FnpijIV8p4fv2oaUSpmhZdQKgiGDSVXPnaUPVBJH/jfvSUuG
         p80E76ojlp/Pr8Pn5UgpsvjArfwiNPoojXGQAmgT4IaR7P4R9furOTaBbBKPOxZl7NnA
         Y4+DYjP0fT7WjT/hrowF6fqPhElJ9I58L58wTZu+FAxuVU823cYcL6UPx0mVuE0QX5qW
         KxZawL+hit92PqAONobJ0rCCE7BV9Uc3yuo4iuOKQpEIj4rbOJX+fMZoOktUKijn10Sl
         EO0g==
X-Gm-Message-State: AC+VfDyIrX//ydXtEfUBcsjlMZc/AiOxrgT+5cqsblkv0triM06KQsuM
	12ExDzWWTMJzFUs+Y2oa/zM=
X-Google-Smtp-Source: ACHHUZ4NsK4PLy2XXEpL2R2verGyqAlkyFRs8KFHaYy+t7kilvX+AkDT61Lr/ig8Zq3Or+cNrvT/Ew==
X-Received: by 2002:a7b:cbd2:0:b0:3f4:2452:966a with SMTP id n18-20020a7bcbd2000000b003f42452966amr2220459wmi.27.1685133717251;
        Fri, 26 May 2023 13:41:57 -0700 (PDT)
Received: from localhost.localdomain (93-34-93-173.ip49.fastwebnet.it. [93.34.93.173])
        by smtp.googlemail.com with ESMTPSA id 13-20020a05600c228d00b003f60455de07sm6198427wmf.15.2023.05.26.13.41.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 May 2023 13:41:56 -0700 (PDT)
From: Christian Marangi <ansuelsmth@gmail.com>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	wireguard@lists.zx2c4.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Christian Marangi <ansuelsmth@gmail.com>,
	stable@vger.kernel.org
Subject: [net PATCH] wireguard: allowedips: fix compilation warning for stack limit exceeded
Date: Fri, 26 May 2023 22:41:34 +0200
Message-Id: <20230526204134.29058-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On some arch (for example IPQ8074) and other with
KERNEL_STACKPROTECTOR_STRONG enabled, the following compilation error is
triggered:
drivers/net/wireguard/allowedips.c: In function 'root_remove_peer_lists':
drivers/net/wireguard/allowedips.c:80:1: error: the frame size of 1040 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]
   80 | }
      | ^
drivers/net/wireguard/allowedips.c: In function 'root_free_rcu':
drivers/net/wireguard/allowedips.c:67:1: error: the frame size of 1040 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]
   67 | }
      | ^
cc1: all warnings being treated as errors

Since these are free function and returns void, using function that can
fail is not ideal since an error would result in data not freed.
Since the free are under RCU lock, we can allocate the required stack
array as static outside the function and memset when needed.
This effectively fix the stack frame warning without changing how the
function work.

Fixes: Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Cc: stable@vger.kernel.org
---
 drivers/net/wireguard/allowedips.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireguard/allowedips.c b/drivers/net/wireguard/allowedips.c
index 5bf7822c53f1..c129082f04c6 100644
--- a/drivers/net/wireguard/allowedips.c
+++ b/drivers/net/wireguard/allowedips.c
@@ -53,12 +53,16 @@ static void node_free_rcu(struct rcu_head *rcu)
 	kmem_cache_free(node_cache, container_of(rcu, struct allowedips_node, rcu));
 }
 
+static struct allowedips_node *tmpstack[MAX_ALLOWEDIPS_BITS];
+
 static void root_free_rcu(struct rcu_head *rcu)
 {
-	struct allowedips_node *node, *stack[MAX_ALLOWEDIPS_BITS] = {
-		container_of(rcu, struct allowedips_node, rcu) };
+	struct allowedips_node *node, **stack = tmpstack;
 	unsigned int len = 1;
 
+	memset(stack, 0, sizeof(*stack) * MAX_ALLOWEDIPS_BITS);
+	stack[0] = container_of(rcu, struct allowedips_node, rcu);
+
 	while (len > 0 && (node = stack[--len])) {
 		push_rcu(stack, node->bit[0], &len);
 		push_rcu(stack, node->bit[1], &len);
@@ -68,9 +72,12 @@ static void root_free_rcu(struct rcu_head *rcu)
 
 static void root_remove_peer_lists(struct allowedips_node *root)
 {
-	struct allowedips_node *node, *stack[MAX_ALLOWEDIPS_BITS] = { root };
+	struct allowedips_node *node, **stack = tmpstack;
 	unsigned int len = 1;
 
+	memset(stack, 0, sizeof(*stack) * MAX_ALLOWEDIPS_BITS);
+	stack[0] = root;
+
 	while (len > 0 && (node = stack[--len])) {
 		push_rcu(stack, node->bit[0], &len);
 		push_rcu(stack, node->bit[1], &len);
-- 
2.39.2


