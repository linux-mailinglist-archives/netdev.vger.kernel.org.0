Return-Path: <netdev+bounces-4438-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EBC0A70CEC7
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 01:53:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 711211C2081F
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 23:53:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB5BC1773E;
	Mon, 22 May 2023 23:53:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDAA2174CD
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 23:53:50 +0000 (UTC)
Received: from mail-oo1-xc36.google.com (mail-oo1-xc36.google.com [IPv6:2607:f8b0:4864:20::c36])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 816062136;
	Mon, 22 May 2023 16:53:49 -0700 (PDT)
Received: by mail-oo1-xc36.google.com with SMTP id 006d021491bc7-55517975c5fso1530038eaf.2;
        Mon, 22 May 2023 16:53:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684799629; x=1687391629;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cka+L/EhW69q5eBXnddBNePu0LAvLr19Skc97ejFT5k=;
        b=hs6qEjLryiJCm6ldYmWxw2AlTIkJ2sUZbIaFF/7Q92s6BjF4GhM9/kciURhAEPPZRV
         Kn74+HhFeUEQ/h7Y5VbSjw8apuf4BgysdzxJo70TQ+cNMggpIJGOG7Lve6d+lOxEmdOS
         Jk1BAjiixJ4tcl82DQ9fsE9nm2E1BwzScLj5s3AS/BT3RMaNxmeY8TnkVSaeL0tstJZn
         1lr1A+w2EM5nfq3w7is1/TNaf1zp25/RaObGRPtdR/0KGXrsYMrdN891ccGOktQCPbmc
         JsdR+uqtrp5F5GQKDdsRIBKIQXZ498HV0iUAC94sE3vGmN9YFMOUrCwDHLOvHV7/fDRF
         toHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684799629; x=1687391629;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cka+L/EhW69q5eBXnddBNePu0LAvLr19Skc97ejFT5k=;
        b=e/0AmTBn1COboxlzQ6ATk35djKODnN5R0jKM95A4MztzgUDTY3AAjkBNss1PbXk1qM
         S4+XWrGy0nt81aV4H9nVOOS5eexKUBZ7wuS7RHu5xJ0Fx34715CkrebNG6JJdC9tlVVm
         j7O7CfhZLI4Ik9audqz3bU2MUJJ42beEaHZWU+7o6qZSA63DTMtvcJ7x3iiiHWm49zhu
         YXhNsBPYd9XW9648wjO7KFcLU3fguFgC8LpkkKmli2U9yurG7viT6dSrpN6PM1cevC7d
         VtMv1USqGGhoEVpIAl6zGqC7GxMUdMUY+AackoxMnbnVCNC1oUQl/XMKj1nEiQVbCkGf
         Np7g==
X-Gm-Message-State: AC+VfDxmMTUyauWlQb86buP/AhNl79FPi34rqHRSrK1F4kX0JUP6NTfy
	l//XBFQMicvMLKPBjk/F1X3qN6kO8A==
X-Google-Smtp-Source: ACHHUZ4DzvUKvWyGcLzLNdX+tTZe+1UHe1hdq209PHohRpA+pS3ny1318P9CX9FMvQsaKZ6rt/gnoQ==
X-Received: by 2002:a4a:9c50:0:b0:54f:b59c:256a with SMTP id c16-20020a4a9c50000000b0054fb59c256amr6010050ook.4.1684799628640;
        Mon, 22 May 2023 16:53:48 -0700 (PDT)
Received: from C02FL77VMD6R.bytedance.net ([208.184.112.130])
        by smtp.gmail.com with ESMTPSA id x131-20020a4a4189000000b0055210b1a91csm3201666ooa.3.2023.05.22.16.53.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 May 2023 16:53:48 -0700 (PDT)
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
Subject: [PATCH v2 net 1/6] net/sched: sch_ingress: Only create under TC_H_INGRESS
Date: Mon, 22 May 2023 16:53:33 -0700
Message-Id: <b0b07ae90beda315160bdc9a7f7f06c95a9ed47c.1684796705.git.peilin.ye@bytedance.com>
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


