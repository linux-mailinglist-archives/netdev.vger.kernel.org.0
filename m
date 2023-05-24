Return-Path: <netdev+bounces-4839-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5255470EAA9
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 03:19:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0D7D12814FE
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 01:19:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C7231360;
	Wed, 24 May 2023 01:19:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10084ED5
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 01:19:46 +0000 (UTC)
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8365F127;
	Tue, 23 May 2023 18:19:43 -0700 (PDT)
Received: by mail-qk1-x72e.google.com with SMTP id af79cd13be357-75b0df81142so78112585a.2;
        Tue, 23 May 2023 18:19:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684891182; x=1687483182;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TTODVV/LQUtZuq/RjLJcuBFwBujVuHAiJuRPCFPbCjM=;
        b=BrzggDAga5Rt3a3iEX7vGPEPt9SXVvN3Cnmu+jq6buGccnno5pp2RlpBZmRBZCPww6
         OwbmSmBRlyXtf1Av66MLqOLLmZwzCBTcKxztaLXj4xreZeEUGfh2ViqVc5e5T4BhAP+X
         1ASjtc6Ee/bGG16bbymk2qaG6SBGQFNeTXsbQMpxpcbZ8V3jfOKiv0E1YeSR73mLZJga
         qb+T5v7D4dK66cfBrMLE7SD+i3CzH0HgI8e7T2C6+BgKflxzNPu2h3P1nrDPi5/bra+C
         5igsrdlal26mnn+bFgQZ9Di7wrdQW00BLddUjI6LrdcbnXYep6VTHDg5T9Q9VkRTpFY8
         7WwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684891182; x=1687483182;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TTODVV/LQUtZuq/RjLJcuBFwBujVuHAiJuRPCFPbCjM=;
        b=GBDSHsic5eRpKIZTNeWz6pvBzkc38MgnUitCmmgxHUmLaOoEOgGLnaDqAqkNykrr3U
         FnlXdWbohHqXPxzBmuiDjSU56fE8AYhrknKeSpOGfTY4aNEhat/1daZhf33l5GN/itPc
         fxGWaRQHKBKuxqGLqxHhOE/hdgFg0/H5V+gkgTfyGTCpe0j92+MWdbFGSwvEWVTIJYV3
         Ureas+xvWrtgm5NNPqmb9g9HoZwSKztqPoPRQL91VIeuOt2aYOluiFQ8/M1gTpi9I6uf
         qMcF1n4WXFGOhXiVxgE9vYWUWc9P+ofQEQ/ijWZ7T8ZW3Yx/G/GPdzIENUbgRQaw3YTz
         OelA==
X-Gm-Message-State: AC+VfDzvqiOg1mozKxBsQHNGda43mqRvOeW3BboS5TQDOP4TLYOkYPSx
	Cut4u1Tgo/j0M1Xmk9kN1g==
X-Google-Smtp-Source: ACHHUZ4y+yXQCI2e1CVL4mncxauvyL2x8kLEoVFuQARaQDMNYpMsBxXtY5x3M/vWnR8Ap11YxeYRhg==
X-Received: by 2002:a05:6214:f0a:b0:5f1:683e:9bd6 with SMTP id gw10-20020a0562140f0a00b005f1683e9bd6mr28074624qvb.9.1684891182604;
        Tue, 23 May 2023 18:19:42 -0700 (PDT)
Received: from C02FL77VMD6R.bytedance.net ([2600:1700:d860:12b0:c32:b55:eaec:a556])
        by smtp.gmail.com with ESMTPSA id t27-20020a05622a181b00b003e3921077d9sm3347317qtc.38.2023.05.23.18.19.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 May 2023 18:19:42 -0700 (PDT)
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
Subject: [PATCH v5 net 4/6] net/sched: Prohibit regrafting ingress or clsact Qdiscs
Date: Tue, 23 May 2023 18:19:28 -0700
Message-Id: <81628172b6ffe1dee6dbe4a829753e0d97f61a48.1684887977.git.peilin.ye@bytedance.com>
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

Currently, after creating an ingress (or clsact) Qdisc and grafting it
under TC_H_INGRESS (TC_H_CLSACT), it is possible to graft it again under
e.g. a TBF Qdisc:

  $ ip link add ifb0 type ifb
  $ tc qdisc add dev ifb0 handle 1: root tbf rate 20kbit buffer 1600 limit 3000
  $ tc qdisc add dev ifb0 clsact
  $ tc qdisc link dev ifb0 handle ffff: parent 1:1
  $ tc qdisc show dev ifb0
  qdisc tbf 1: root refcnt 2 rate 20Kbit burst 1600b lat 560.0ms
  qdisc clsact ffff: parent ffff:fff1 refcnt 2
                                      ^^^^^^^^

clsact's refcount has increased: it is now grafted under both
TC_H_CLSACT and 1:1.

ingress and clsact Qdiscs should only be used under TC_H_INGRESS
(TC_H_CLSACT).  Prohibit regrafting them.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Fixes: 1f211a1b929c ("net, sched: add clsact qdisc")
Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
---
change in v3, v4:
  - add in-body From: tag

 net/sched/sch_api.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index 383195955b7d..49b9c1bbfdd9 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -1596,6 +1596,11 @@ static int tc_modify_qdisc(struct sk_buff *skb, struct nlmsghdr *n,
 					NL_SET_ERR_MSG(extack, "Invalid qdisc name");
 					return -EINVAL;
 				}
+				if (q->flags & TCQ_F_INGRESS) {
+					NL_SET_ERR_MSG(extack,
+						       "Cannot regraft ingress or clsact Qdiscs");
+					return -EINVAL;
+				}
 				if (q == p ||
 				    (p && check_loop(q, p, 0))) {
 					NL_SET_ERR_MSG(extack, "Qdisc parent/child loop detected");
-- 
2.20.1


