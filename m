Return-Path: <netdev+bounces-4440-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CBA370CEC9
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 01:54:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2FF4928111E
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 23:54:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75A4817745;
	Mon, 22 May 2023 23:54:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69C0A17739
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 23:54:40 +0000 (UTC)
Received: from mail-oa1-x34.google.com (mail-oa1-x34.google.com [IPv6:2001:4860:4864:20::34])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 043BD213A;
	Mon, 22 May 2023 16:54:39 -0700 (PDT)
Received: by mail-oa1-x34.google.com with SMTP id 586e51a60fabf-19c8dd7c258so1579282fac.1;
        Mon, 22 May 2023 16:54:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684799678; x=1687391678;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IYDaMH2sBj0TTvJJ8lNQXKiQGR7svLdvqXQQFVpqjrk=;
        b=ZQtEtEbF+b1g4Hw7nC0Ii2VHFnrw+1rG8EjKgrtVPZEeEVQXPJjvYBFV3T+SnGiITV
         rQBN8CAob7xOG/o5BfUPuAJFztbHkhBWsplildS0v4v6mTRJYyOTYdbSOQKqMXy89HMQ
         uAPAdkdS3xMkWZ5yRk+KnyrMjV+U8FsdQ+VYOl0yZNf33Ren6fiRTYV+LM2uSLpYf4z4
         V/0NGlmF2h1zn/0c+dSW9pX6EpBsVDQdPKhP1aq1WJynr+6F16injL7EjFfQXObx6gCW
         fFOjxGQUWAV3mM0gWx4lunknLHNTrzOx498PetTk+/0VVG+mdsze6lk388CLHTaWNZXP
         aCPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684799678; x=1687391678;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IYDaMH2sBj0TTvJJ8lNQXKiQGR7svLdvqXQQFVpqjrk=;
        b=AQvEe+/YNPwj2+EQHMFgOnkoNIJCYRD9P+42rU2Vo137aHPoLzIhVXuHUNlBwsDHG7
         2YH3xJq36YcQvexi6xNr4lss2Ymvok3w/RyvEOhMtovz4bk8bT67LG54rRlXVPqN3e5X
         9jPcOIgGFnbcfxOvq2lI6ijm5+ZI4fB1gPW4O3p+6/W7DY90PThOOS2kXf4n9JfLLYd5
         4VfeDgRAbWldOtKeimnoHFDz5uh0D1tv/3lcraE4OygDaw2h01axMNBzFRZIFHM4ap3K
         yb/4Qa5r0qotEmKkQLnnJkFl4Y9Oyeob+dbzd6XIN86wYeFmwn3xooZkwOeRD4kPzTkO
         hZCg==
X-Gm-Message-State: AC+VfDwoAWINLd/m/wkde5x9a6QXG6Z9RAlr3MnEuQBRbkzqcL4zQV32
	iD04zimCtqYzs3jV7XVrJg==
X-Google-Smtp-Source: ACHHUZ5pnoZtuCuzZD95IQRxq+3LkdbdnBsqXvHBFGaXwa/8oP7GDL0zttnT1lTpD543cHk4ZG8IaA==
X-Received: by 2002:a05:6870:5a93:b0:19d:767:9da2 with SMTP id dt19-20020a0568705a9300b0019d07679da2mr2910634oab.3.1684799678293;
        Mon, 22 May 2023 16:54:38 -0700 (PDT)
Received: from C02FL77VMD6R.bytedance.net ([208.184.112.130])
        by smtp.gmail.com with ESMTPSA id j21-20020a9d7695000000b006ac98aae2d3sm2928959otl.40.2023.05.22.16.54.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 May 2023 16:54:38 -0700 (PDT)
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
Subject: [PATCH v2 net 3/6] net/sched: Reserve TC_H_INGRESS (TC_H_CLSACT) for ingress (clsact) Qdiscs
Date: Mon, 22 May 2023 16:54:22 -0700
Message-Id: <f4695699e286eebc634f212e620e1537ba350ece.1684796705.git.peilin.ye@bytedance.com>
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

Currently it is possible to add e.g. an HTB Qdisc under ffff:fff1
(TC_H_INGRESS, TC_H_CLSACT):

  $ ip link add name ifb0 type ifb
  $ tc qdisc add dev ifb0 parent ffff:fff1 htb
  $ tc qdisc add dev ifb0 clsact
  Error: Exclusivity flag on, cannot modify.
  $ drgn
  ...
  >>> ifb0 = netdev_get_by_name(prog, "ifb0")
  >>> qdisc = ifb0.ingress_queue.qdisc_sleeping
  >>> print(qdisc.ops.id.string_().decode())
  htb
  >>> qdisc.flags.value_() # TCQ_F_INGRESS
  2

Only allow ingress and clsact Qdiscs under ffff:fff1.  Return -EINVAL
for everything else.  Make TCQ_F_INGRESS a static flag of ingress and
clsact Qdiscs.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Fixes: 1f211a1b929c ("net, sched: add clsact qdisc")
Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
---
 net/sched/sch_api.c     | 7 ++++++-
 net/sched/sch_ingress.c | 4 ++--
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index fdb8f429333d..383195955b7d 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -1252,7 +1252,12 @@ static struct Qdisc *qdisc_create(struct net_device *dev,
 	sch->parent = parent;
 
 	if (handle == TC_H_INGRESS) {
-		sch->flags |= TCQ_F_INGRESS;
+		if (!(sch->flags & TCQ_F_INGRESS)) {
+			NL_SET_ERR_MSG(extack,
+				       "Specified parent ID is reserved for ingress and clsact Qdiscs");
+			err = -EINVAL;
+			goto err_out3;
+		}
 		handle = TC_H_MAKE(TC_H_INGRESS, 0);
 	} else {
 		if (handle == 0) {
diff --git a/net/sched/sch_ingress.c b/net/sched/sch_ingress.c
index 13218a1fe4a5..caea51e0d4e9 100644
--- a/net/sched/sch_ingress.c
+++ b/net/sched/sch_ingress.c
@@ -137,7 +137,7 @@ static struct Qdisc_ops ingress_qdisc_ops __read_mostly = {
 	.cl_ops			=	&ingress_class_ops,
 	.id			=	"ingress",
 	.priv_size		=	sizeof(struct ingress_sched_data),
-	.static_flags		=	TCQ_F_CPUSTATS,
+	.static_flags		=	TCQ_F_INGRESS | TCQ_F_CPUSTATS,
 	.init			=	ingress_init,
 	.destroy		=	ingress_destroy,
 	.dump			=	ingress_dump,
@@ -275,7 +275,7 @@ static struct Qdisc_ops clsact_qdisc_ops __read_mostly = {
 	.cl_ops			=	&clsact_class_ops,
 	.id			=	"clsact",
 	.priv_size		=	sizeof(struct clsact_sched_data),
-	.static_flags		=	TCQ_F_CPUSTATS,
+	.static_flags		=	TCQ_F_INGRESS | TCQ_F_CPUSTATS,
 	.init			=	clsact_init,
 	.destroy		=	clsact_destroy,
 	.dump			=	ingress_dump,
-- 
2.20.1


