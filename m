Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D5305EDE3
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 22:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727207AbfGCUvE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 16:51:04 -0400
Received: from mail-qt1-f201.google.com ([209.85.160.201]:43140 "EHLO
        mail-qt1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727093AbfGCUvE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 16:51:04 -0400
Received: by mail-qt1-f201.google.com with SMTP id z16so4562058qto.10
        for <netdev@vger.kernel.org>; Wed, 03 Jul 2019 13:51:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=EQHLSuPIc/oYvaB2vk7M21m/1+VQk4KM7GLfnO/In8U=;
        b=jne86OKJc9ev0L5z/69jJWMmW0vRt1Vj8LQYaiqrWqU1n2uGE4UUz2ml42d/yMwcTe
         Uh6quJ7A9GtIgEO+GMUTRiq4fZ2LH6+zEG7TnBH+1ypCBaqFCrAwij2mENW9SyYaheaX
         MFVKf1gN0PBI2BgbUJKsstwkQOXWOhonKcJ3EwzMrEQfAmfHLveQeQac23upkHPYYJh9
         NR13nw39IRHZTJ2rTe4aklq4C8/8CW1iCaWXGqp/lbXFeSLxLOjS7GvPF5fkVhsClsd/
         imXol9vsQRhMDEeoDszmqsvRnlqgvzXydpq/VYt+rTIinJymdIULM1hN338J1iqmg5iR
         PUKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=EQHLSuPIc/oYvaB2vk7M21m/1+VQk4KM7GLfnO/In8U=;
        b=fdDgdFZ4Syhgcvk8fywYadtIjQ3WuJMrUFgpVRbZCpot/Ff5j20Lupo9EJhVZ2KmTY
         5aUWHecT6TdvczPDoBAQpXlefNB407qoWT4RKj+Dll/ve0uGNIsDxQEJaOvnoA4MFz+V
         fOnpAF6fgokYrvqqpG2hI3X5K/Ko6Hhrg/8gvVHdOZboHxIOy+wAUfJZ0M+v3bObB6+f
         5YJwx09F2hqulOgHcMUN8CSr6ljHAgBnx//t2SXdCPQzrz6ZA0aDC3pPL+prYZ7YL1zR
         E4SldGKp3g6P19P3Q5CGVf1epjvuQR+rIgu3vdZMtnb+GbKqDdC6tJ/iGYoGMy4VUyhj
         ebZg==
X-Gm-Message-State: APjAAAUmacFXBB+RXbWsOiQ7oeDSiMsgH0+TNIC0Tdcj4dmq0QZWllFG
        VWPicigUq9eW5bYGooOkCcHPYfB57zpM+HqJS8I9Sf8B4qldUMcmLTjPhqeBvnxSwyO3ss4Ii6b
        PD++HH5KXp1WQ6keAnobUDUaG39p6QtQKBZVbrns/ZegE1Kaw+OnoHw==
X-Google-Smtp-Source: APXvYqxWHXP6E82FZJ9VF1npsQLmXvY6v2JOFrt3HrrdzjYjqH2xgqUKBg0mleRT5x/Eu21KDBOAoy4=
X-Received: by 2002:a37:9944:: with SMTP id b65mr33607864qke.105.1562187062968;
 Wed, 03 Jul 2019 13:51:02 -0700 (PDT)
Date:   Wed,  3 Jul 2019 13:51:00 -0700
Message-Id: <20190703205100.142904-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH bpf-next] selftests/bpf: make verifier loop tests arch independent
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Take the first x bytes of pt_regs for scalability tests, there is
no real reason we need x86 specific rax.

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/testing/selftests/bpf/progs/loop1.c | 3 ++-
 tools/testing/selftests/bpf/progs/loop2.c | 3 ++-
 tools/testing/selftests/bpf/progs/loop3.c | 3 ++-
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/loop1.c b/tools/testing/selftests/bpf/progs/loop1.c
index dea395af9ea9..d530c61d2517 100644
--- a/tools/testing/selftests/bpf/progs/loop1.c
+++ b/tools/testing/selftests/bpf/progs/loop1.c
@@ -14,11 +14,12 @@ SEC("raw_tracepoint/kfree_skb")
 int nested_loops(volatile struct pt_regs* ctx)
 {
 	int i, j, sum = 0, m;
+	volatile int *any_reg = (volatile int *)ctx;
 
 	for (j = 0; j < 300; j++)
 		for (i = 0; i < j; i++) {
 			if (j & 1)
-				m = ctx->rax;
+				m = *any_reg;
 			else
 				m = j;
 			sum += i * m;
diff --git a/tools/testing/selftests/bpf/progs/loop2.c b/tools/testing/selftests/bpf/progs/loop2.c
index 0637bd8e8bcf..91bb89d901e3 100644
--- a/tools/testing/selftests/bpf/progs/loop2.c
+++ b/tools/testing/selftests/bpf/progs/loop2.c
@@ -14,9 +14,10 @@ SEC("raw_tracepoint/consume_skb")
 int while_true(volatile struct pt_regs* ctx)
 {
 	int i = 0;
+	volatile int *any_reg = (volatile int *)ctx;
 
 	while (true) {
-		if (ctx->rax & 1)
+		if (*any_reg & 1)
 			i += 3;
 		else
 			i += 7;
diff --git a/tools/testing/selftests/bpf/progs/loop3.c b/tools/testing/selftests/bpf/progs/loop3.c
index 30a0f6cba080..3a7f12d7186c 100644
--- a/tools/testing/selftests/bpf/progs/loop3.c
+++ b/tools/testing/selftests/bpf/progs/loop3.c
@@ -14,9 +14,10 @@ SEC("raw_tracepoint/consume_skb")
 int while_true(volatile struct pt_regs* ctx)
 {
 	__u64 i = 0, sum = 0;
+	volatile __u64 *any_reg = (volatile __u64 *)ctx;
 	do {
 		i++;
-		sum += ctx->rax;
+		sum += *any_reg;
 	} while (i < 0x100000000ULL);
 	return sum;
 }
-- 
2.22.0.410.gd8fdbe21b5-goog

