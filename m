Return-Path: <netdev+bounces-4581-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0564170D49E
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 09:13:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B4A7B2812A9
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 07:13:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 718F61D2AB;
	Tue, 23 May 2023 07:13:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6538B1B8EA
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 07:13:34 +0000 (UTC)
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DEA911A;
	Tue, 23 May 2023 00:13:32 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id af79cd13be357-75b08ceddd1so223294185a.1;
        Tue, 23 May 2023 00:13:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684826011; x=1687418011;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J74j1cuX46yDfNzc3Qiq/CfJJ1yt4vs8CiBnDAgOYno=;
        b=E1ue/swpTD+/IRaBgRL5zqtirLR3tZAZ9mg9A+1dlhC7Jvyd7syhAfXp7E+2jeS20Z
         tmv0gtu8C6YVRzFZtreeUIG6UUlnetMVKfSfX8iDorSNNhvvX3hipowMBjH2zgr8Iz2K
         3oY/qO2H0BOtLFQkNDC828dmLXk0tG05QcLmG92k6PwxupNhsRsphCUezdEisyjhdRu/
         dpZ6hzYwOGBezF9/mXiCOp4wKIR7Wfk+s9fyHUlmcVYza0ca1frEBJ+6BpPqKdN430rB
         WApDLpAqlBowSp97rxxGN0mLOqCNFU0az66snKq4f7ZEeU0GpkjF1/IF1K+PeW/b9Brm
         IrvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684826011; x=1687418011;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J74j1cuX46yDfNzc3Qiq/CfJJ1yt4vs8CiBnDAgOYno=;
        b=OCkSFLOi823PfZWIev2m2rqz18JSLqrbb8PviQnSK9b9unisXGD6rZF3hneNfbxylo
         6B4qjg3Clw1x2t1n3MKS19L9jctBC0hnAYiindv/FkEkT+h2AhSTe2rEtC7UV33QZ8rS
         emKPXtovzZIy/htqWEMNrzIj5bBACxjZizZBVmVvD3UqV250C6bEfyVrbPzKM2MXSB3J
         ifbDf605gCnUs0X9J15Hfliii2C0iWhWbe7aH1qq5FlKttLPuGGAgb8ZaM9w4Q/PRal/
         pviB02MWY5PINk0f/unMtrSClNGjPT9AvRqmGCm3nR/qA017L+2SFc1bF32aZe13m0Zb
         xY4A==
X-Gm-Message-State: AC+VfDweldg3q94mrFuT8SNKduv4RA0jG8HdtpIg2Pk04Mz22NAS8B6G
	z6hcdd28q7JjfR8fQ4kZnA==
X-Google-Smtp-Source: ACHHUZ7pHWofx1U53JoLeUnDcI9QNPFsZ+RSFzdeaG2sEs0MAlVM1qkYdJ4r9Teqv93vBlVLKwq1aA==
X-Received: by 2002:a05:620a:8592:b0:75b:23a0:debc with SMTP id pf18-20020a05620a859200b0075b23a0debcmr2936365qkn.58.1684826011635;
        Tue, 23 May 2023 00:13:31 -0700 (PDT)
Received: from C02FL77VMD6R.bytedance.net ([2600:1700:d860:12b0:18c1:dc19:5e29:e9a0])
        by smtp.gmail.com with ESMTPSA id s27-20020a05620a031b00b00759300a1ef9sm2317369qkm.31.2023.05.23.00.13.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 May 2023 00:13:31 -0700 (PDT)
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
Subject: [PATCH v4 net 1/6] net/sched: sch_ingress: Only create under TC_H_INGRESS
Date: Tue, 23 May 2023 00:13:20 -0700
Message-Id: <a5b777d61a97e2de6e993208543b7436fda819ec.1684825171.git.peilin.ye@bytedance.com>
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

ingress Qdiscs are only supposed to be created under TC_H_INGRESS.
Similar to mq_init(), return -EOPNOTSUPP if 'parent' is not
TC_H_INGRESS.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzbot+b53a9c0d1ea4ad62da8b@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/r/0000000000006cf87705f79acf1a@google.com/
Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
---
change since v2:
  - add in-body From: tag

 net/sched/sch_ingress.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/sched/sch_ingress.c b/net/sched/sch_ingress.c
index 84838128b9c5..3d71f7a3b4ad 100644
--- a/net/sched/sch_ingress.c
+++ b/net/sched/sch_ingress.c
@@ -80,6 +80,9 @@ static int ingress_init(struct Qdisc *sch, struct nlattr *opt,
 	struct net_device *dev = qdisc_dev(sch);
 	int err;
 
+	if (sch->parent != TC_H_INGRESS)
+		return -EOPNOTSUPP;
+
 	net_inc_ingress_queue();
 
 	mini_qdisc_pair_init(&q->miniqp, sch, &dev->miniq_ingress);
-- 
2.20.1


