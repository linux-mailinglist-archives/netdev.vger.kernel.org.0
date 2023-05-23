Return-Path: <netdev+bounces-4582-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 26F9270D49F
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 09:14:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 946461C20C20
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 07:14:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C63591D2B1;
	Tue, 23 May 2023 07:14:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B54611D2AB
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 07:14:53 +0000 (UTC)
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58A60109;
	Tue, 23 May 2023 00:14:52 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id d75a77b69052e-3f392680773so34347771cf.0;
        Tue, 23 May 2023 00:14:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684826091; x=1687418091;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k4RT8KtH61VT5UBgWC5UXkvWjA8gZ1S4WED/F36PazM=;
        b=APMod9rDv+JDt7Mke9LgtZqH3l4ccae3EMMMsQ8gqTojNI/LELDTXIsWVPQmHDkDtL
         h2UPoEEQsXZNS8uu2R4OkkqfJ3jLfGsees8LUcwP9BNiRVCjPwzxkukGtekCMjd/nRB6
         OYPfZZGdS/Gjh1tHb5f8ZHRhVmOHDAEtMc3raW4QnyPWysPHYwoyitkxx68NXIbk3g6w
         tz+aGKzd8++nVVaShvpkGFQOCqDJDBfWV1nhQ4sHYKWfzU/oYpbgT9lLCLjdktGvG36+
         6QJJsBVxDuNGbUEwmccZ9yiAlBBCq5k3VpazaB37jyiUiiNJZt/Y/DwmV3Hq8bVpjxWY
         mNnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684826091; x=1687418091;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k4RT8KtH61VT5UBgWC5UXkvWjA8gZ1S4WED/F36PazM=;
        b=CF9ES4w3+Q0RPwZrNOxO1YGFb1jsQzMYDT67v2KjQzJZXVIqjAZWluVR/QcNY6X6pB
         Go/Mkor3+fgVQfNe2ioShOViKAoxn9oN0KMncJ6ItVVLV1NPLzluePmWnunNOkzYjoI1
         UJwQ4B98PDxt9ms8hwi4xk5LnUU6M/A3QjmVtIqpQu+wu5l+O4xdHDNSVqejycyVSbqu
         PL/JH0RptZgXvuppxjR8ty1ZrxhbiBzmt9WAi914lCxOm8XXZD/Sakm512WdWQvD/jcQ
         xSj/YavVKqT34LqMhG+Mc3qY90wvvRRwoa5tAU4aFhsHzcNL+evh0JLiMjGh01emXCS7
         Mvow==
X-Gm-Message-State: AC+VfDx4F7m7xUDnGLMbpidFF9YBNfgL9uxZRWZMjopS3bhEHAcngAeI
	TJF+C1vBKywMX9orz42GfQ==
X-Google-Smtp-Source: ACHHUZ6AmvngE4qPcfmWUdZXrLcNLGv/fnQpza+GgGkWOO/EJg8+ZAicGF4SDorJu1XOyjkaJuKXNQ==
X-Received: by 2002:ac8:7d0c:0:b0:3f5:3982:fa26 with SMTP id g12-20020ac87d0c000000b003f53982fa26mr24549341qtb.14.1684826091444;
        Tue, 23 May 2023 00:14:51 -0700 (PDT)
Received: from C02FL77VMD6R.bytedance.net ([2600:1700:d860:12b0:18c1:dc19:5e29:e9a0])
        by smtp.gmail.com with ESMTPSA id b13-20020ac8754d000000b003f364778b2bsm1867381qtr.4.2023.05.23.00.14.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 May 2023 00:14:51 -0700 (PDT)
From: Peilin Ye <yepeilin.cs@gmail.com>
X-Google-Original-From: Peilin Ye <peilin.ye@bytedance.com>
To: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Jiri Pirko <jiri@resnulli.us>
Cc: Peilin Ye <peilin.ye@bytedance.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>,
	Vlad Buslov <vladbu@mellanox.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	Hillf Danton <hdanton@sina.com>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Cong Wang <cong.wang@bytedance.com>,
	Peilin Ye <yepeilin.cs@gmail.com>
Subject: [PATCH v4 net 2/6] net/sched: sch_clsact: Only create under TC_H_CLSACT
Date: Tue, 23 May 2023 00:14:41 -0700
Message-Id: <042ff4af742ef0ed76fd5bb55b914403954b9d9f.1684825171.git.peilin.ye@bytedance.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <cover.1684825171.git.peilin.ye@bytedance.com>
References: <cover.1684825171.git.peilin.ye@bytedance.com>
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

From: Peilin Ye <peilin.ye@bytedance.com>

clsact Qdiscs are only supposed to be created under TC_H_CLSACT (which
equals TC_H_INGRESS).  Return -EOPNOTSUPP if 'parent' is not
TC_H_CLSACT.

Fixes: 1f211a1b929c ("net, sched: add clsact qdisc")
Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
---
change since v2:
  - add in-body From: tag

 net/sched/sch_ingress.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/sched/sch_ingress.c b/net/sched/sch_ingress.c
index 3d71f7a3b4ad..13218a1fe4a5 100644
--- a/net/sched/sch_ingress.c
+++ b/net/sched/sch_ingress.c
@@ -222,6 +222,9 @@ static int clsact_init(struct Qdisc *sch, struct nlattr *opt,
 	struct net_device *dev = qdisc_dev(sch);
 	int err;
 
+	if (sch->parent != TC_H_CLSACT)
+		return -EOPNOTSUPP;
+
 	net_inc_ingress_queue();
 	net_inc_egress_queue();
 
-- 
2.20.1


