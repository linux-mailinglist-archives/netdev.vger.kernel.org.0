Return-Path: <netdev+bounces-6108-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E7873714D5B
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 17:49:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8D7621C20A53
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 15:49:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 345D08F68;
	Mon, 29 May 2023 15:49:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 222628C1F;
	Mon, 29 May 2023 15:49:21 +0000 (UTC)
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6376CC7;
	Mon, 29 May 2023 08:49:16 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id 98e67ed59e1d1-2566ed9328eso1283177a91.2;
        Mon, 29 May 2023 08:49:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685375356; x=1687967356;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9Tvy4LC5km0zgmb9Tfu+uBN8Z3LNjnPdumUgMICLrwQ=;
        b=JnC7FAf0AvDM8j4e+SvZ5JIRqbKo7QY2mR4jSdUXyvsY0mWPCDASHyYk5OfQFl+P5r
         Qxmbde5rj7t+bqEQJehC2ZZAoau7TyFZfugqUjiiPYDJh4WSC87d/ceqThG3cMI4VFQo
         JLOpXAvOWBEvEv7JGF4j2ZzAIAwQ3kl4UGAmXoO8BODUTor1br1CdpYBVkf9CPJrMhWW
         sMSgJmrAZib2GqhVOdHgiVNrKO+MPbSWllhzHqrId2I40k1+msTmoTmVM3zK/VhNmYQa
         rq9jXcmswS/UlqzgXH93dZQXahZ+pteEkZgHig2hAjDrloELoF+8qjPrCA6YFO+jL7nB
         Ycig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685375356; x=1687967356;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9Tvy4LC5km0zgmb9Tfu+uBN8Z3LNjnPdumUgMICLrwQ=;
        b=i/TB6F4xhXg0KfN9ww8xwjG6TbNVN9JkNLM/6AE9dXrPHL8wwCt1Gv+CfIGDbSZNPL
         VrZEG7Q5i0scpYzj7D/D+1043fyaj/wQJddLbMITNDFrUvmy0QP98hkf/9JdrJkDCG4M
         +w0KL4gZOWB5WiE7c5wyjJug9eYevc57a+mbO2ffjlaYFqILLZDhgMy4IjamOkW8zVX/
         Y1fO6LXGg74uJDZ7FamlT9zD4zAnkSn1goJnBjUqGiKtqHTQN+CN6/cFgz8uUp/B5VaG
         8QVFMCt6nPIqUj1vUQEEWh2kXIAytVXxxftvAyLsSVAitf1ld1mYnJzQS1sByWEb/pGO
         QQqw==
X-Gm-Message-State: AC+VfDwjzoKYhKLv68x9ZpBwFrteTksjHIk2VwvxuqbhIrE2j0iwFWoe
	Z+xLCTETXBJgjdHxENTuU5A=
X-Google-Smtp-Source: ACHHUZ6hlI/duiNqbAFJIBc+TMmkxccm5bn4NseHDohtfYHgalx3c5p9DPkJbi3hT/9HCnTCeouXVw==
X-Received: by 2002:a17:903:22c2:b0:1b0:5304:5b4e with SMTP id y2-20020a17090322c200b001b053045b4emr692277plg.43.1685375355748;
        Mon, 29 May 2023 08:49:15 -0700 (PDT)
Received: from localhost.localdomain ([106.39.42.38])
        by smtp.gmail.com with ESMTPSA id w12-20020a170902a70c00b001ac381f1ce9sm8425499plq.185.2023.05.29.08.49.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 May 2023 08:49:15 -0700 (PDT)
From: starmiku1207184332@gmail.com
To: ast@kernel.org,
	daniel@iogearbox.net,
	john.fastabend@gmail.com,
	andrii@kernel.org,
	martin.lau@linux.dev,
	song@kernel.org,
	yhs@fb.com,
	kpsingh@kernel.org,
	sdf@google.com,
	haoluo@google.com,
	jolsa@kernel.org,
	davem@davemloft.net,
	kuba@kernel.org,
	hawk@kernel.org
Cc: bpf@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org,
	Teng Qi <starmiku1207184332@gmail.com>
Subject: [PATCH] kernel: bpf: syscall: fix a possible sleep-in-atomic bug in __bpf_prog_put()
Date: Mon, 29 May 2023 15:48:52 +0000
Message-Id: <20230529154852.584377-1-starmiku1207184332@gmail.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Teng Qi <starmiku1207184332@gmail.com>

Although we haven`t found a proper way to identify the rcu read lock region,
we have noticed that vfree() calls vfree_atomic() with the
condition 'in_interrupt()' to ensure safety.

To make __bpf_prog_put() safe in practice, we propose calling
bpf_prog_put_deferred() with the condition 'in_interrupt()' and
using the work queue for any other context.

We also added a comment to indicate that the safety of  __bpf_prog_put()
relies implicitly on the implementation of vfree().

Signed-off-by: Teng Qi <starmiku1207184332@gmail.com>
---
 kernel/bpf/syscall.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 14f39c1e573e..48ff5d2e163a 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2099,10 +2099,12 @@ static void __bpf_prog_put(struct bpf_prog *prog)
 	struct bpf_prog_aux *aux = prog->aux;
 
 	if (atomic64_dec_and_test(&aux->refcnt)) {
-		if (in_irq() || irqs_disabled()) {
+		if (!in_interrupt()) {
+			// safely calling vfree() under any context
 			INIT_WORK(&aux->work, bpf_prog_put_deferred);
 			schedule_work(&aux->work);
 		} else {
+			// depending on the vfree_atomic() branch in vfree()
 			bpf_prog_put_deferred(&aux->work);
 		}
 	}
-- 
2.25.1


