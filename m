Return-Path: <netdev+bounces-653-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E54E56F8D1C
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 02:15:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 38BA21C21A54
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 00:15:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A8EF19A;
	Sat,  6 May 2023 00:15:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F8FE180
	for <netdev@vger.kernel.org>; Sat,  6 May 2023 00:15:43 +0000 (UTC)
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F8196E8C;
	Fri,  5 May 2023 17:15:38 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id 3f1490d57ef6-b9a6f17f2b6so16608074276.1;
        Fri, 05 May 2023 17:15:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683332137; x=1685924137;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+Uvnsen7YTJ+/XuD5tR1o/JBOwU+HqDAI5vfYihveLM=;
        b=FG/7OyvTnAQI17bZUseuqc3tFLR32GBm+HmmQnz/R7ESFNBaq0RaHWmcrWUCXyaX0H
         +LCzkQWwChzvo+zFbg61dq23hJn/vlefYt5k4g7R62VnAU9W/GsRGyAgh2rjkylU76AL
         rW0YckgHTWJaKoO9Wa4w2YVUdchsKfy7X9svgrPBQuWAHQPzMUV4e9Axt9QsYxe16e5/
         fl9Qu648SF7Lvmfc0r2ZcPQ/XwuwfVljhj58NCQMpjWZUnMh7u1QryP5txNEXvB8wmma
         um7PoF0LVlIPWI2/NAFXyKgLJP0+vQfOepvfw7kKDkl6+Yvo6+sSev2FWUP9s57PYLk/
         lntw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683332137; x=1685924137;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+Uvnsen7YTJ+/XuD5tR1o/JBOwU+HqDAI5vfYihveLM=;
        b=AyH2I5LXjz88MWjvjNavQPaoVGw4XC4qPaiyIc1kcvSspto741GNk4taMwJUjF4MHm
         dklbpXP3JGU7FNQjRXzLKUIizQPUPLyMLowve0uNH2IJPwG3SHpa5dq4zezUGuewoaf8
         lR0R10wp05G3anVOUSLzT5pp0qMsdcFTR+kUCIXHtvP+ibzfSngP+KSPhEseAshKW/ua
         8SqcVNleyAkWsS2z+l9lDBkr9mRlX7rfur6V0h4JkOoJjYCDLQA2Ji4ngzlUneYHQfBA
         t7285IJLc1r5SNxjoIKc1TBS/I1P3eWLWLoZTPeUMGBSK6GHlPmce2Ft1MYaPGF50k91
         MoCw==
X-Gm-Message-State: AC+VfDzyS04JqG3FIxcJFKJPbF8mFw7iI10JRh6aDYx/HKUNxyD+sVPX
	WIn8fR3Gx/n1Nr2vjNecbg==
X-Google-Smtp-Source: ACHHUZ6xzZoo/Rjzf8Hlf29/w58dedF/UG0oM1UZf7VVeDnAMtPGB1WbXjCLByslfDFBWGAideXgdw==
X-Received: by 2002:a25:6d09:0:b0:b9e:64b7:3e75 with SMTP id i9-20020a256d09000000b00b9e64b73e75mr5746289ybc.0.1683332137546;
        Fri, 05 May 2023 17:15:37 -0700 (PDT)
Received: from C02FL77VMD6R.attlocal.net ([2600:1700:d860:12b0:5c3e:e69d:d939:4053])
        by smtp.gmail.com with ESMTPSA id g4-20020a056902134400b00b7d2204cd4bsm771554ybu.21.2023.05.05.17.15.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 May 2023 17:15:37 -0700 (PDT)
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
	John Fastabend <john.r.fastabend@intel.com>,
	Vlad Buslov <vladbu@mellanox.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	Hillf Danton <hdanton@sina.com>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Cong Wang <cong.wang@bytedance.com>,
	Peilin Ye <yepeilin.cs@gmail.com>
Subject: [PATCH net 5/6] net/sched: Refactor qdisc_graft() for ingress and clsact Qdiscs
Date: Fri,  5 May 2023 17:15:29 -0700
Message-Id: <1cd15c879d51e38f6b189d41553e67a8a1de0250.1683326865.git.peilin.ye@bytedance.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <cover.1683326865.git.peilin.ye@bytedance.com>
References: <cover.1683326865.git.peilin.ye@bytedance.com>
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


