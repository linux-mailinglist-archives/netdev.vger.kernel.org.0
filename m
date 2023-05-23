Return-Path: <netdev+bounces-4583-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3144570D4A4
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 09:15:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F36EE1C20906
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 07:15:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CBCB1D2B9;
	Tue, 23 May 2023 07:15:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D6E1D2B2
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 07:15:36 +0000 (UTC)
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 370EA120;
	Tue, 23 May 2023 00:15:34 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id af79cd13be357-75b08ceddd1so223432385a.1;
        Tue, 23 May 2023 00:15:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684826133; x=1687418133;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=563KIW1CbzbOZG9uSI1EL/wqRfnJk9ZwfZaE6UMFES0=;
        b=mn4z2tVM//02hqXXjrXG9gO1+9fntZx7Pztl6I3viEgASGZw9b/LDeZrBjwRpDH+y0
         vydlCZlOECuydOBQ0EF2Hnvqua1k3BcF5B0vkgkleDs6iiJjHJtqcYXZK1N0io/1CxO1
         7rtnufvF3wKI4o2xk5m3KnFnWpGK8MqDVJwt1CAGCEPHzoOCP999/P7VUpB35kLyuZZa
         jkMtpzQTJFLqmKiqv8EfbSwI1oYn5nLUkR3zaCkT/lj4ZwXIpS1ejlGHI/53v3LkCumB
         eXYaygFCQV7wBWOvDCSUKVwGC8xAj+WZeVLaQaLz57U9bah0Ee0s7O/mIDIx4XuPklPh
         ZPrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684826133; x=1687418133;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=563KIW1CbzbOZG9uSI1EL/wqRfnJk9ZwfZaE6UMFES0=;
        b=baje/lPfisOUOiXTFdcqC8av6XtElSTf+0ytywAboOe2Ijgd38+J+qlJ9LDfEMv+WE
         /D9kJT4DubiqyU6cub5yFX3MxiF6JFS+IoN9mEQOfmAJRbmQsxIwSHH+QV2G8k2aIXmH
         3TgXuFRph8d2DPl6gA2HK0Zykw13wSphxbjHE7XTYYUEBieNsyOqrscz5NP52pVbyumk
         yUUzuGVO+4HBfCKMJolHW8iMkM9/J4A38N1xby8CnFLjO7nEUeulNu6+zvTiRBnjs2U6
         cvsHN1HVbd7c6u/nH+xn2LArvZZriaFkbyC/qmbLWx7RA/wNzyuQGxjMjNrEVUNKvrCz
         tg/w==
X-Gm-Message-State: AC+VfDyNgDFyt6FrmeJdJkXPpotRu3KPApmqLAEJmjx23cnoSmtUjAbH
	BJFwV5fMy1+NA9e8uKFLQw==
X-Google-Smtp-Source: ACHHUZ57PlqNkIBg85I+Sz/x/Ym+ca7ecOqk9IsCNzBwFQm4mwaufmd0cF2A3WFGzaRq+SqdgbuK/g==
X-Received: by 2002:a05:620a:8a05:b0:75b:23a0:de84 with SMTP id qt5-20020a05620a8a0500b0075b23a0de84mr2969184qkn.2.1684826133352;
        Tue, 23 May 2023 00:15:33 -0700 (PDT)
Received: from C02FL77VMD6R.bytedance.net ([2600:1700:d860:12b0:18c1:dc19:5e29:e9a0])
        by smtp.gmail.com with ESMTPSA id m9-20020ae9e709000000b0074e21136a77sm2292040qka.127.2023.05.23.00.15.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 May 2023 00:15:33 -0700 (PDT)
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
Subject: [PATCH v4 net 3/6] net/sched: Reserve TC_H_INGRESS (TC_H_CLSACT) for ingress (clsact) Qdiscs
Date: Tue, 23 May 2023 00:14:57 -0700
Message-Id: <5e55909fafc7afcde9b7795d39dac0d10f5f45da.1684825171.git.peilin.ye@bytedance.com>
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
change since v2:
  - add in-body From: tag

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


