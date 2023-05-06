Return-Path: <netdev+bounces-649-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 90A0D6F8D10
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 02:12:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B51C928111E
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 00:12:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 998A719A;
	Sat,  6 May 2023 00:12:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A152180
	for <netdev@vger.kernel.org>; Sat,  6 May 2023 00:12:32 +0000 (UTC)
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 420A6659B;
	Fri,  5 May 2023 17:12:31 -0700 (PDT)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-55a829411b5so22455897b3.1;
        Fri, 05 May 2023 17:12:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683331950; x=1685923950;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i/2a2fmRaVPEPp2SSETeOf9kawD9M9PLZwiVrKPPSQY=;
        b=CxrOtlBiwg4s9rfgq1NtTTDlmpby0f6ol7PjTQ3rv2KCdADYKCJX6/woREeP/oxuMM
         idy8F9tgM6fXoB45VbLt/lKYUq0ofl+ecMnWMFkNOpRcNwTRdSUYzbNiUTmOmy6SUmVW
         3ss6EgBTlQNU0TUNYInGrGEvkXpyN792OyEUvYvenPLwFy0vT7yMiGjCDR6Ojbp1OPKE
         xpmz7911Saafm1DBQK9VI48gViPqLu5upXBVph5/GBNVuTlyx+egZV3Viog8/40UCNj/
         V9Qs8/8k6yo27BfQxYgghd5B72QBfMzzlgwk6lOm+X9AzOQmiiKq3bZk/7XcT7kHhYnA
         1mbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683331950; x=1685923950;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i/2a2fmRaVPEPp2SSETeOf9kawD9M9PLZwiVrKPPSQY=;
        b=aN9eYHFmAXBKFnEg1OJPOPV6GCCRFXN+bLwo/IantjHyxTf+6xZaYxhSzFy5fO88EJ
         xatI3wUe4ZXx/GsUdxk4+7p1H3TZPiEg3rnwnbvyg5H4eT5u2C42LrSJk9dp0+N0mVpR
         MPJdfMVjxhcuax92w+2kym2QoNbxCDkbN0no2qzOIivR2KZNWqz+GKeP0xDgWLT84JPH
         u3hfXRYkKaJd+T/BEJQ6CVcvqb/uwjIg7yeGvvk8bPfv3CQuVvihTmHzKD/jiPEaT4/K
         hsjv7daSRdq0vS9rUmoP0fmB5MbWCiLbkPVTCD8ORj3klkYkXMgNU2SUQlXS891h1vqZ
         l0Dg==
X-Gm-Message-State: AC+VfDxHmdMqc4A2ZCAIe+whuNcDuEW1KSKHh2d471ae9+8qxFU+UR/c
	mGxijdFcSMLp+Qn9lcVbuw==
X-Google-Smtp-Source: ACHHUZ7B/nfs5WeLCZlzBFD6U4wWOR1+wLRnmcuDVSrg/93+iZcpuBJteChPblg7H7UO+nmKt7JzOA==
X-Received: by 2002:a81:7345:0:b0:556:ea38:eb07 with SMTP id o66-20020a817345000000b00556ea38eb07mr3517093ywc.50.1683331950369;
        Fri, 05 May 2023 17:12:30 -0700 (PDT)
Received: from C02FL77VMD6R.attlocal.net ([2600:1700:d860:12b0:5c3e:e69d:d939:4053])
        by smtp.gmail.com with ESMTPSA id x185-20020a814ac2000000b00552a118d059sm793267ywa.117.2023.05.05.17.12.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 May 2023 17:12:30 -0700 (PDT)
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
Subject: [PATCH net 1/6] net/sched: sch_ingress: Only create under TC_H_INGRESS
Date: Fri,  5 May 2023 17:12:22 -0700
Message-Id: <d24b49826204dbdd1aa1a209e79bbfe384a96b67.1683326865.git.peilin.ye@bytedance.com>
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

ingress Qdiscs are only supposed to be created under TC_H_INGRESS.
Similar to mq_init(), return -EOPNOTSUPP if 'parent' is not
TC_H_INGRESS.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzbot+b53a9c0d1ea4ad62da8b@syzkaller.appspotmail.com
Link: https://lore.kernel.org/netdev/0000000000006cf87705f79acf1a@google.com
Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
---
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


