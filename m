Return-Path: <netdev+bounces-5976-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B7EB714083
	for <lists+netdev@lfdr.de>; Sun, 28 May 2023 23:13:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9D14C280E39
	for <lists+netdev@lfdr.de>; Sun, 28 May 2023 21:13:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A096A6120;
	Sun, 28 May 2023 21:13:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C5367E
	for <netdev@vger.kernel.org>; Sun, 28 May 2023 21:13:11 +0000 (UTC)
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6BD8B8;
	Sun, 28 May 2023 14:13:07 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id ffacd0b85a97d-30a1fdde3d6so2592300f8f.0;
        Sun, 28 May 2023 14:13:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685308386; x=1687900386;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=q1Cwvb/GCCh0lg/6CXrsgL4T10DW9Bo8xMEsQZBh0JU=;
        b=kdN1Z4KJ0bZPCKSFUeflr1BnPucv2axWl46oBkIb9YvXV04L03QKbdywqbJuN4iQfR
         +O0QEH7fDwq7S71LsjHYp93iOKgj3lrkDtZDqTdiWdWVjkUNjmYBNw//MLV0ESpv4uX6
         HaZyoBPe1WTPCyqOZBc5QLQm5bJs1eK5Z6dC/8M9fP44RTz8M851R+3DmPbjnoblVeZq
         JPR9ab2basB/qsxXIu1QrTyhd2IgtShcxm3vdgbG9SMTe5F2uB/md6nhDiXV9d2V/O3e
         ykjCQy7f0tT+LCzFRBKPqX1lvEVaakAyLCjkp2fo2UScG2lqRw5+rCMZr68K9sDkSmIn
         HQzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685308386; x=1687900386;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=q1Cwvb/GCCh0lg/6CXrsgL4T10DW9Bo8xMEsQZBh0JU=;
        b=SKlSQdEcY66ruOEpbd3nCUov4iElZsw+dV9VTtAq5kKrUZyrDbHPsneV4dEXGM/+mh
         +IB8MC10upbzWSkaW2obJhB64Z3jtb00umjaEFlkmtkkGRSZfO515c+KsdMJqrz0tSEH
         Q7lZYuYQoEeaM/RbOU5XFLSBRJykBt+A9BF+GpojoTRs5Fz+nmI6hn3nyuYzZnDuSEhZ
         apyflfZrF6KxJQIo+pwyFoxp7ZFGaZtORI3WV3bZCgcenqfG00JQGbftbN5h9zFIcMZj
         agAlREKmA62xk7w3ij+cYmz3WtrKB48Yuabzh8LyYJeApXz8bmTu5YIQks55OcOZ274b
         PHsQ==
X-Gm-Message-State: AC+VfDw2c80UPEjk5sbaV2bUZBJeJ1Dbbbm2tqXtKHD5dY9ZqZOaQv7e
	hHQIwBW01x3ZH5cCMuT29uY=
X-Google-Smtp-Source: ACHHUZ4Y7DqZiFFDPeZAv1uMH7j5vP9ZWQPYLvuLknBgEf1tFxlG/8GVtBEQd7uHTRoEOx0salH7cA==
X-Received: by 2002:adf:ea89:0:b0:30a:e7cb:793 with SMTP id s9-20020adfea89000000b0030ae7cb0793mr2868652wrm.15.1685308385931;
        Sun, 28 May 2023 14:13:05 -0700 (PDT)
Received: from localhost.localdomain (93-34-93-173.ip49.fastwebnet.it. [93.34.93.173])
        by smtp.googlemail.com with ESMTPSA id z16-20020adfe550000000b003063a92bbf5sm11829852wrm.70.2023.05.28.14.13.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 May 2023 14:13:05 -0700 (PDT)
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
Subject: [net-next PATCH v2] wireguard: allowedips: fix compilation warning for stack limit exceeded
Date: Sun, 28 May 2023 12:11:57 +0200
Message-Id: <20230528101157.20374-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DATE_IN_PAST_06_12,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=no autolearn_force=no version=3.4.6
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

Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Cc: stable@vger.kernel.org
---

Changes v2:
- Fix double Fixes in fixes tag

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


