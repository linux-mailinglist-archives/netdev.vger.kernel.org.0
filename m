Return-Path: <netdev+bounces-4439-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E0B7470CEC8
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 01:54:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 71F4B2810A5
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 23:54:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFA1417740;
	Mon, 22 May 2023 23:54:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A39461773E
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 23:54:15 +0000 (UTC)
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 608252135;
	Mon, 22 May 2023 16:54:14 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id 46e09a7af769-6af7593ed5fso821351a34.0;
        Mon, 22 May 2023 16:54:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684799653; x=1687391653;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Eg7+MTtOoGginTkEuFUGcJMan5HKcjTNLO6/cJFDlM4=;
        b=hE+VlVPBniLddnIkLUExM3o1tiW7XrYfN2tezmYlTt87txsC7f9BRTYDdQiyAJhHxm
         BF17RE/+lSVmvCEg213hhwkePkJvdCWY3waFnayDGJm6vsvmRKSj0CBUvGvsjgkM2wbS
         Hlj722/CmP6utyeRySZK1l2oajoWjggphwHPgWzFyXFbcM3Q3qoTvB6OUN+gthu5deEk
         UUgobDZMccRc2G6f7Ln+TdsH/kbq1hgFAS3rlli4tM0IKzo8ZtFIDroz8xItAlaFqoL+
         P1Xs+Fg9vieaMtT1mgng2x7eqbaU7/t0NLWQeeq3u7+lXGukqrhDEifjKRMKrqMu82xg
         Msxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684799653; x=1687391653;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Eg7+MTtOoGginTkEuFUGcJMan5HKcjTNLO6/cJFDlM4=;
        b=kp2r4EefMsUnN2F16V85m0NMrKueuQblNHqcJbcH9QRU80j11fniPwepF+fZf06han
         hfEsOlPoVa8YxJrTqlMXxksgG3XtQNQZ5Rl9RS9RMKTZxRftCEyKEnd5yYEvfztGg2DY
         Y9wluuh3Lw+cganHnLcj20WJMmFHaIXYlyxUD037YFbphmrXo5Fms5GGsCa/cmCEaHNA
         zXzjxPKzmaDYYZW0EwrgaDD/hmKo/IcxIHu/SvKf4+/mt+VgVJvbemx9e+V1r7Mizmtb
         rAd/12HksXaA/IU+Lg5/GES1HvferpKYmoR7aR9Un6yMEliN524YGGNDj1UIDDwNjkJv
         9PGQ==
X-Gm-Message-State: AC+VfDxwaBnhxheApI+GdPUN+3AFxVlUx1mWa7WYDBiawAlKW0/swaoM
	hu7MvtJkQCNFQko1c69uAA==
X-Google-Smtp-Source: ACHHUZ4uUCdiFPY96wSRlMhGzY9cpAXsWfixLgugBHd+AcjTGacgnN0bQigh7sZ0ruSZ2zNRZxCkiw==
X-Received: by 2002:a9d:6e19:0:b0:6af:7856:5d55 with SMTP id e25-20020a9d6e19000000b006af78565d55mr2673148otr.22.1684799653550;
        Mon, 22 May 2023 16:54:13 -0700 (PDT)
Received: from C02FL77VMD6R.bytedance.net ([208.184.112.130])
        by smtp.gmail.com with ESMTPSA id u21-20020a056830119500b006af800065f2sm1318813otq.59.2023.05.22.16.54.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 May 2023 16:54:13 -0700 (PDT)
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
Subject: [PATCH v2 net 2/6] net/sched: sch_clsact: Only create under TC_H_CLSACT
Date: Mon, 22 May 2023 16:54:02 -0700
Message-Id: <dbb20c8c155235175087aeb480f27b28d5dd4ec7.1684796705.git.peilin.ye@bytedance.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <cover.1684796705.git.peilin.ye@bytedance.com>
References: <cover.1684796705.git.peilin.ye@bytedance.com>
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

clsact Qdiscs are only supposed to be created under TC_H_CLSACT (which
equals TC_H_INGRESS).  Return -EOPNOTSUPP if 'parent' is not
TC_H_CLSACT.

Fixes: 1f211a1b929c ("net, sched: add clsact qdisc")
Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
---
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


