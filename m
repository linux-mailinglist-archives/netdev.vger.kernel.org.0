Return-Path: <netdev+bounces-4837-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DBFE70EAA5
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 03:19:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BD244280FC1
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 01:19:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04ACA1360;
	Wed, 24 May 2023 01:19:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB096ED5
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 01:19:02 +0000 (UTC)
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02C06E5;
	Tue, 23 May 2023 18:19:00 -0700 (PDT)
Received: by mail-qk1-x736.google.com with SMTP id af79cd13be357-75affb4d0f9so49323085a.2;
        Tue, 23 May 2023 18:19:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684891140; x=1687483140;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TJv/Mw0cjZxSPI53855B262nqFR1u1C+NNKjhLR5zAc=;
        b=bHh2xG4vMLwDfNkJoMtqyCOK1LyFyld0lllv/VgIUkukjyDA+3SoBce0g0B/7yUrV3
         a0NeiyWiF8xzqkzj2yCXi5XGoukztOJQjPKDJN47yZOBHkkdWZtSVIAOm3rw3dH5Bl1b
         Un1LlbsPAPrZm4FlKCbnIwLloVEKU0CDgmYXjLuVs6jI2Bef5IErYLRdZ7TFBDLAC4+h
         vn0cTwa3oOvHw+7yaYCnj/DiQiJizfg4GiPvHZ8nIPSs3b/EYMuuTor9mWI1w6NZV+Is
         Uex0+ruJrQfU9FvCu0g1Yy9+KLo6ZNpxNnlAec+Okm9RrLAh0K9izme21sMpzGlRn5qe
         gqtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684891140; x=1687483140;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TJv/Mw0cjZxSPI53855B262nqFR1u1C+NNKjhLR5zAc=;
        b=d2vUx0sQSHgujYZE12HEhxOV1wH/am9cYigjWKJNLUNBIpkR0F62kU+SDjsPO+4laN
         I04VHWtgcdL2zJzRzZiJEQHHmuJmiPeBuQJbioLNZMM1RCc3vSVlViuX4iknKaaD23kU
         Hxipj5Q9tiEsbnTyTYq/aD220mpIVpO6wSE8BQ0rtym03bK51DjvXg88fz5FO0sA8Fhl
         6g8+dSno+ScnQWI69ZxvAmrC+9Z4ihJOENb+1tX5ZE+rpBpAhnPxeoFqmcOb1zbTpLkK
         K8qysq8lumu971GYbkM03zfN5qEskPvGuSTS+PTwpcsAYhQFc85UEhdDPUblzoGohFuP
         ajCA==
X-Gm-Message-State: AC+VfDz/AmDuBxQE0rU+n6dDJJcqXfsaIv5X0/VvdHJF/ibuwcHbPt0p
	axYeNoUTVPzpGr1wog57rg==
X-Google-Smtp-Source: ACHHUZ6UUtaooFrMdnyoTupZPs4CYAYMtiEstJADWeY6Ol3H5Hm0LxbLRRZHk2/2p4+6eZMvpl4oiA==
X-Received: by 2002:a05:620a:a9b:b0:75b:23a0:e7df with SMTP id v27-20020a05620a0a9b00b0075b23a0e7dfmr6174329qkg.64.1684891139934;
        Tue, 23 May 2023 18:18:59 -0700 (PDT)
Received: from C02FL77VMD6R.bytedance.net ([2600:1700:d860:12b0:c32:b55:eaec:a556])
        by smtp.gmail.com with ESMTPSA id ow21-20020a05620a821500b0074636e35405sm2913190qkn.65.2023.05.23.18.18.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 May 2023 18:18:59 -0700 (PDT)
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
Subject: [PATCH v5 net 2/6] net/sched: sch_clsact: Only create under TC_H_CLSACT
Date: Tue, 23 May 2023 18:18:35 -0700
Message-Id: <0c07bd5b72c67a2edf126cd2c6a9daadddb3ca95.1684887977.git.peilin.ye@bytedance.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <cover.1684887977.git.peilin.ye@bytedance.com>
References: <cover.1684887977.git.peilin.ye@bytedance.com>
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
Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
---
change in v5:
  - avoid underflowing @egress_needed_key in ->destroy(), reported by
    Pedro

change in v3, v4:
  - add in-body From: tag

 net/sched/sch_ingress.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/sched/sch_ingress.c b/net/sched/sch_ingress.c
index f9ef6deb2770..35963929e117 100644
--- a/net/sched/sch_ingress.c
+++ b/net/sched/sch_ingress.c
@@ -225,6 +225,9 @@ static int clsact_init(struct Qdisc *sch, struct nlattr *opt,
 	struct net_device *dev = qdisc_dev(sch);
 	int err;
 
+	if (sch->parent != TC_H_CLSACT)
+		return -EOPNOTSUPP;
+
 	net_inc_ingress_queue();
 	net_inc_egress_queue();
 
@@ -254,6 +257,9 @@ static void clsact_destroy(struct Qdisc *sch)
 {
 	struct clsact_sched_data *q = qdisc_priv(sch);
 
+	if (sch->parent != TC_H_CLSACT)
+		return;
+
 	tcf_block_put_ext(q->egress_block, sch, &q->egress_block_info);
 	tcf_block_put_ext(q->ingress_block, sch, &q->ingress_block_info);
 
-- 
2.20.1


