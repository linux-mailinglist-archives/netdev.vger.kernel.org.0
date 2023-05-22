Return-Path: <netdev+bounces-4442-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9118D70CECB
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 01:55:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4B224280C70
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 23:55:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2B6517749;
	Mon, 22 May 2023 23:55:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9475DEEA8
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 23:55:30 +0000 (UTC)
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 200EE2681;
	Mon, 22 May 2023 16:55:29 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id 46e09a7af769-6af8aac7a2eso429808a34.3;
        Mon, 22 May 2023 16:55:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684799728; x=1687391728;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sQLIv+3hRLznwnCm51oPj668Ns602ev+EO/wUc0CPh0=;
        b=n2xXPRGtvFpsGn52kRAG2uUGq4CN71U4+H75dmjZzCC3htNX+NrfJTZRi4yS2+hIIP
         2HfJLbkolRJxawQkDwl4FptyOQv4iVzHKlu6uSMavJ0fbsH28EbR6KdGwRa/j42hT/vo
         /dWuiRCueLVD/s7DhY3X1KIFyIHIbbqUOWiuK3V7mPwfvOnwcEQ2SefZunO68pI6mbmT
         L0595pR826hRAXr7ofHCYd0WjT5LwbzvvGIFWgVQ/ah3aCBkbWXwuXbAbR4mcLchUYiF
         SB+dyayit4P5VhAJi8j0EsBgDTsZa0CP5BZSZ4uE7q4ax0sr+HPfiagMuNUYEWYsD2P3
         SUKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684799728; x=1687391728;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sQLIv+3hRLznwnCm51oPj668Ns602ev+EO/wUc0CPh0=;
        b=MUq9wH5K6o2s1O44nDwrP7iX53Li8RtaT7ZtXIqnvBh9H9xpn/0Kjct8yRvTaGl6K3
         LX6bqkuo0nQQ1XaurxZnCWgV8R5vil/28/DE6TIMmpPqPE2Xly0vPO3tXAWIBIvtprUK
         i+YAnwNXv2xCuuWcFDwpphifR3Sk6plcgZwtPfbAIuuEE5fqmdkxGeP//NSAAJZP10Lc
         G8DyQfLBtTzzjrc5xm159vUDuVCLrBv7HFRv/6orBdn1bwDqRCULZEQ9rGLNh1EJfc5O
         AvMU7jtQcwZ5EwkQN1JQ4BcvGKvjpqvmPp1XGgoCRWlcLX9rvhyCNAOkALWPFwr7XZQV
         cT3g==
X-Gm-Message-State: AC+VfDzYbZ3jUoZEXNC05F9o0y+e9XUAfXynmKzRBJOZIAIvIbk5izQ2
	hq/37MAhVQ9jprn9EasVLQ==
X-Google-Smtp-Source: ACHHUZ4qEETLMn8eJd8NRsyDnoow7HpW0Yg5sjbrxZG6nm/1/c55PU22tWYVoiF+SVIYDQC8nFj0iQ==
X-Received: by 2002:a9d:67d4:0:b0:6ab:360b:840 with SMTP id c20-20020a9d67d4000000b006ab360b0840mr6709235otn.35.1684799728387;
        Mon, 22 May 2023 16:55:28 -0700 (PDT)
Received: from C02FL77VMD6R.bytedance.net ([208.184.112.130])
        by smtp.gmail.com with ESMTPSA id d21-20020a056830139500b006ab32e46485sm2848224otq.79.2023.05.22.16.55.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 May 2023 16:55:28 -0700 (PDT)
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
Subject: [PATCH v2 net 5/6] net/sched: Refactor qdisc_graft() for ingress and clsact Qdiscs
Date: Mon, 22 May 2023 16:55:15 -0700
Message-Id: <9a7a44e532874f68c03a0028ad0a7a6b16620121.1684796705.git.peilin.ye@bytedance.com>
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

Grafting ingress and clsact Qdiscs does not need a for-loop in
qdisc_graft().  Refactor it.  No functional changes intended.

Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Tested-by: Pedro Tammela <pctammela@mojatatu.com>
Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
---
 net/sched/sch_api.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index 49b9c1bbfdd9..f72a581666a2 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -1073,12 +1073,12 @@ static int qdisc_graft(struct net_device *dev, struct Qdisc *parent,
 
 	if (parent == NULL) {
 		unsigned int i, num_q, ingress;
+		struct netdev_queue *dev_queue;
 
 		ingress = 0;
 		num_q = dev->num_tx_queues;
 		if ((q && q->flags & TCQ_F_INGRESS) ||
 		    (new && new->flags & TCQ_F_INGRESS)) {
-			num_q = 1;
 			ingress = 1;
 			if (!dev_ingress_queue(dev)) {
 				NL_SET_ERR_MSG(extack, "Device does not have an ingress queue");
@@ -1094,18 +1094,18 @@ static int qdisc_graft(struct net_device *dev, struct Qdisc *parent,
 		if (new && new->ops->attach && !ingress)
 			goto skip;
 
-		for (i = 0; i < num_q; i++) {
-			struct netdev_queue *dev_queue = dev_ingress_queue(dev);
-
-			if (!ingress)
+		if (!ingress) {
+			for (i = 0; i < num_q; i++) {
 				dev_queue = netdev_get_tx_queue(dev, i);
+				old = dev_graft_qdisc(dev_queue, new);
 
-			old = dev_graft_qdisc(dev_queue, new);
-			if (new && i > 0)
-				qdisc_refcount_inc(new);
-
-			if (!ingress)
+				if (new && i > 0)
+					qdisc_refcount_inc(new);
 				qdisc_put(old);
+			}
+		} else {
+			dev_queue = dev_ingress_queue(dev);
+			old = dev_graft_qdisc(dev_queue, new);
 		}
 
 skip:
-- 
2.20.1


