Return-Path: <netdev+bounces-6133-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E8BAE714DB8
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 18:02:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8FCB11C20A88
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 16:02:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7B8EA939;
	Mon, 29 May 2023 15:53:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B5508C0A;
	Mon, 29 May 2023 15:53:38 +0000 (UTC)
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 399F8E3;
	Mon, 29 May 2023 08:53:34 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id 41be03b00d2f7-51b33c72686so2083145a12.1;
        Mon, 29 May 2023 08:53:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685375613; x=1687967613;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=U8VEFwDtQU82btVgiD97z0QaW4mks5wNV7R/9ROe3xg=;
        b=Ilf3JtvBOcaMTx3ALyYXeD3ZaP+rFn00xE21zth3J8qIu5N0qH/SyrqgWCmyLsvUXO
         uY29vo4FIgYu7lIZvUwf0AldZqBcjaLuYNDERewC5YfRPqRCImFAXKheryjf4fqtFajz
         2fOkGMBKQIKof8LrHx7ZSYb6b+hAC0K2GIEtZmYG5e9oc9w3Xmx2mHwZts/2WPuC0NaQ
         6KoK4d3Zkw0+2+ctt0LSZpHUZ1wFTyug52DMRakdtVGufI8qWAkliOIXqgCPX/b+iu7i
         h403y0y639q+UhSkmV9M+oDZQvXN93V5j4NGBC2YWk7yloEEfq++GPTNm+Jeql+24qgN
         KNyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685375613; x=1687967613;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=U8VEFwDtQU82btVgiD97z0QaW4mks5wNV7R/9ROe3xg=;
        b=Y6UsY7M92leOHKOJDSFRQViD+kk0MZb85WMYC74i4VdkKHdQG7HjxUc7IzxTpG400Z
         Im6lIq3hZTXxl+NDVlc+ESeEuWEunyN4U681ITehLLSKjyxwf3QkKVyaS32UU/sdQ7sn
         Pyd4B+OaOeK9WheJYb6nnZp0N9o38ho0E0TQsrhEYiRx4wYhZBCDMbhG9/Psf2Uo1ET3
         XU4T6ppMzWzqWKUSNf4RAumYq6hfXZ8aldw/obUYtFwVHd8QwSUlCihpHR816yJqgxG7
         BM7m1hGUV7tuip2WS+6HFg5FcNHG2nl72+snwyohVUUXtEE0xqp4Lt+y4No9haWqRXXM
         OG1w==
X-Gm-Message-State: AC+VfDx6cDtWzIzL6IakySSQ6/D4BwUqXeZJAbvFdQil7lBKVIQesLId
	Tn4+GhoD0PNwMH8Kupykkps=
X-Google-Smtp-Source: ACHHUZ425HDF1Fkt8Mb/897HW29FEIqk9THo4pO73YQ128h/h2QHkHH+2IZfZBAaOD71/V52jmWLBg==
X-Received: by 2002:a17:903:2285:b0:1af:ccc3:25d1 with SMTP id b5-20020a170903228500b001afccc325d1mr14158246plh.62.1685375613601;
        Mon, 29 May 2023 08:53:33 -0700 (PDT)
Received: from localhost.localdomain ([106.39.42.38])
        by smtp.gmail.com with ESMTPSA id q12-20020a170902a3cc00b001a64851087bsm6565807plb.272.2023.05.29.08.53.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 May 2023 08:53:33 -0700 (PDT)
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
Date: Mon, 29 May 2023 15:53:27 +0000
Message-Id: <20230529155327.585056-1-starmiku1207184332@gmail.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Teng Qi <starmiku1207184332@gmail.com>

__bpf_prog_put() indirectly calls kvfree() through bpf_prog_put_deferred()
which is unsafe under atomic context. The current
condition ‘in_irq() || irqs_disabled()’ in __bpf_prog_put() to ensure safety
does not cover cases involving the spin lock region and rcu read lock region.
Since __bpf_prog_put() is called by various callers in kernel/, net/ and
drivers/, and potentially more in future, it is necessary to handle those
cases as well.

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


