Return-Path: <netdev+bounces-6254-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D74D715630
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 09:06:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 42A942810C1
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 07:06:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D922107BD;
	Tue, 30 May 2023 07:06:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54F49944B;
	Tue, 30 May 2023 07:06:19 +0000 (UTC)
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE170E5;
	Tue, 30 May 2023 00:06:17 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id d2e1a72fcca58-64d3fbb8c1cso4569234b3a.3;
        Tue, 30 May 2023 00:06:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685430377; x=1688022377;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=edWCMAD9pTtsHzzIzkeySxWeNvmYIzF5o7ScNFDuYPM=;
        b=m6JOmwg5tTAYP/cx8te3fKUr0a/622dXJVP19hVWHdqi9iIAMG8zO+Wufmykc1yNKs
         C7XAITX+FLSxYIi3U9XRt2kwlOzxn9vl59O5M0Ey+PYMelFatUEXGERSIeu1Zfg9dftj
         wt7SZNlTYhc/gpuaequhs0c00bIi934Fv3JxXFGx6ZW+9HIbG9Rx9FpVpcum+bM0GjFM
         FaE7gBMd2b0gcg3algmfoE85fJBRBP7sQFIkX2Z7iqyWzOfRaRiCcN1aSgTfgvcFQdNC
         lPR3ID4wshVJ5NHmmNidsuq3WOP9nmrAeaPgq48BgIvwwp5R772vy17rEv8Aa2iYz7TE
         EBHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685430377; x=1688022377;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=edWCMAD9pTtsHzzIzkeySxWeNvmYIzF5o7ScNFDuYPM=;
        b=ACdMVOZXOu3z4ufClUPGVhmdUwMjGjAmGzSvRlquzm0S08eVJ74P550cohXj+fzj69
         z8a0Egs6twl+jjpuoxma8AtHaF2BRJVXluWEXluweaMDIl7DjY4ZoVuKNLIM3mr/Z3uq
         e/11Jk/QtbBxxjl+QwutNgMtUL0IfdTNa1Ybc+ROsH0erqudfaejjhcL8iPEryM0edlW
         QQVJd7tS/qDmt+Ui54EUx8xLwpn68MiQmNQafUpcWsV4A6et98xbz/F/NjCoHapgPANV
         aBPG0EF5ceb3c6IW3wBTDSOGyci8F1gKx4DPXQb+/p5QphaZVbIYTGlYrRuCNExSFw0o
         k+XA==
X-Gm-Message-State: AC+VfDzaQq1Fi2IagWuSaoRpNFrcSzWvOeyrUmNontAmtBWCLN1hm0ja
	5qtPmUizOmZauJbsmToZxGQ=
X-Google-Smtp-Source: ACHHUZ62I+E95o08ukKQ6so7Xh+n2LufO2CwOpDBIg4hjV43+LgfyUFG9Tm4/KadKjMKE4zo0+ucuw==
X-Received: by 2002:a05:6a20:12c5:b0:10f:3fa0:fd78 with SMTP id v5-20020a056a2012c500b0010f3fa0fd78mr1639223pzg.24.1685430377106;
        Tue, 30 May 2023 00:06:17 -0700 (PDT)
Received: from localhost.localdomain ([106.39.42.38])
        by smtp.gmail.com with ESMTPSA id k8-20020a635a48000000b0052cbd854927sm7929612pgm.18.2023.05.30.00.06.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 May 2023 00:06:16 -0700 (PDT)
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
Subject: [PATCH v2] kernel: bpf: syscall: fix a possible sleep-in-atomic bug in __bpf_prog_put()
Date: Tue, 30 May 2023 07:06:10 +0000
Message-Id: <20230530070610.600063-1-starmiku1207184332@gmail.com>
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
v2:
remove comments because of self explanatory of code.

Fixes: d809e134be7a ("bpf: Prepare bpf_prog_put() to be called from irq context.")
---
 kernel/bpf/syscall.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 14f39c1e573e..96658e5874be 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2099,7 +2099,7 @@ static void __bpf_prog_put(struct bpf_prog *prog)
 	struct bpf_prog_aux *aux = prog->aux;
 
 	if (atomic64_dec_and_test(&aux->refcnt)) {
-		if (in_irq() || irqs_disabled()) {
+		if (!in_interrupt()) {
 			INIT_WORK(&aux->work, bpf_prog_put_deferred);
 			schedule_work(&aux->work);
 		} else {
-- 
2.25.1


