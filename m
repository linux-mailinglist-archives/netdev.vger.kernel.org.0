Return-Path: <netdev+bounces-4689-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B2C5270DE70
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 16:04:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6BA38280F53
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 14:04:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5322F1F173;
	Tue, 23 May 2023 14:04:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 421986FC7
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 14:04:49 +0000 (UTC)
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48E7AE9
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 07:04:47 -0700 (PDT)
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-4f3baf04f0cso3441353e87.1
        for <netdev@vger.kernel.org>; Tue, 23 May 2023 07:04:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1684850625; x=1687442625;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vPsiQpeoZd8UCXYzsHHeRCuEWCzprLDI2K1UxMG1vNw=;
        b=x+MCP6RIfgrhP/C4vp/VF513UZfXgcHOXjt39EnZYcgmTNS9SmK6xTyRxymm3cAXhy
         /LaZFhOURjsNJOM6lIY9MwAVxzXsmMIWE8DLJaBbKJFE4kIQ0kHMc3SxPyVh6uSwrtk+
         wNU2s2zwxen1OqwemfuCkOAFnIWaN+GP7UW62vDuVvYvmriGIigLWe6Gni7csFiLWmIh
         jchR1tkEcWwy7Bb8Twqgp8qV4sQVPq4jMfbrSvauaswEagc8MJQP8ZxgMukHJvIdRfW4
         SeSUkwhQub6h3PdQEBdBn9B6wSPsBeZUjcBXyY2tNf52dtUjqpcdqhVQtWybc8ItqCU5
         4xkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684850625; x=1687442625;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vPsiQpeoZd8UCXYzsHHeRCuEWCzprLDI2K1UxMG1vNw=;
        b=dLlOH+Ys8E0IIEwlj9puqgXvDUjh9eO84mJTXq1mfBAd2prYJLnn8I0iyvWXUzRK3B
         XfHyGkdxOMsdZmeO5kMbKQny4I1dF4uDUH2kU3oRqyF1/foAJWJmSJDDUxbaaHcJ2NYc
         Hxpw3apPHV+GC0XgV0o785iIHzu9OpByHPDKNzXdmyZvGGUNmNumISoOx/DYWxGGsFsm
         o4XfHnyXO9D8ExAInEEpRhaKiVE9jiWlr7oFippbjtQ/y043urRyjTertx2r588lF0VU
         L0vXi/xXJUBYqqlVsax8OzP/h2t/8n/TR2QiTId2FN+2ynoOPaUv7peiHIznJ+Al+b0a
         6ZEw==
X-Gm-Message-State: AC+VfDyrp++lcTImWTtMzpxa9TXZ41nvJyR7Tgag4pe7zCX9jqwBnWoR
	qp0uVM/bFoj1o/fxxd4KWSJJ8Q==
X-Google-Smtp-Source: ACHHUZ4e1X4jxIZwXl+y72sLOP3yazcOb2+MopQ9WDQmhL++ViPZczhGjjS6itrmgC5AhktkZRl30w==
X-Received: by 2002:ac2:5de8:0:b0:4f1:3bd7:e53a with SMTP id z8-20020ac25de8000000b004f13bd7e53amr4566812lfq.49.1684850625594;
        Tue, 23 May 2023 07:03:45 -0700 (PDT)
Received: from Fecusia.lan (c-05d8225c.014-348-6c756e10.bbcust.telenor.se. [92.34.216.5])
        by smtp.gmail.com with ESMTPSA id w16-20020ac254b0000000b004f01ae1e63esm1338341lfk.272.2023.05.23.07.03.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 May 2023 07:03:45 -0700 (PDT)
From: Linus Walleij <linus.walleij@linaro.org>
To: Wei Liu <wei.liu@kernel.org>,
	Paul Durrant <paul@xen.org>
Cc: xen-devel@lists.xenproject.org,
	netdev@vger.kernel.org,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] xen/netback: Pass (void *) to virt_to_page()
Date: Tue, 23 May 2023 16:03:42 +0200
Message-Id: <20230523140342.2672713-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

virt_to_page() takes a virtual address as argument but
the driver passes an unsigned long, which works because
the target platform(s) uses polymorphic macros to calculate
the page.

Since many architectures implement virt_to_pfn() as
a macro, this function becomes polymorphic and accepts both a
(unsigned long) and a (void *).

Fix this up by an explicit (void *) cast.

Cc: Wei Liu <wei.liu@kernel.org>
Cc: Paul Durrant <paul@xen.org>
Cc: xen-devel@lists.xenproject.org
Cc: netdev@vger.kernel.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/net/xen-netback/netback.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index c1501f41e2d8..caf0c815436c 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -689,7 +689,7 @@ static void xenvif_fill_frags(struct xenvif_queue *queue, struct sk_buff *skb)
 		prev_pending_idx = pending_idx;
 
 		txp = &queue->pending_tx_info[pending_idx].req;
-		page = virt_to_page(idx_to_kaddr(queue, pending_idx));
+		page = virt_to_page((void *)idx_to_kaddr(queue, pending_idx));
 		__skb_fill_page_desc(skb, i, page, txp->offset, txp->size);
 		skb->len += txp->size;
 		skb->data_len += txp->size;
-- 
2.34.1


