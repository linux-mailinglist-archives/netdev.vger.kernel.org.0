Return-Path: <netdev+bounces-4840-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5AA1A70EAAF
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 03:20:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E34ED1C20ADA
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 01:20:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D44A1360;
	Wed, 24 May 2023 01:20:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BB77ED5
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 01:20:24 +0000 (UTC)
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDBB4129;
	Tue, 23 May 2023 18:20:10 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id d75a77b69052e-3f6bb5e8ed2so3665891cf.0;
        Tue, 23 May 2023 18:20:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684891210; x=1687483210;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=84jCH5csYFlMMdBF7z2xCF1DPFHya9qG/1Sk/ks2VEQ=;
        b=hOcUcInMs4JnVjQj2ZGvkpXlgz5dC1ExyBx89pSGavh3uY3f/mXgkaIXKa/ttgPc4a
         tG52vcl5hWvhNvGdfeDx5/3CuBgpEImIEFa5n9oZUpcVslaKy9/Uo+9o0grj2HIRnSWE
         0aoImLF8dqdzIyO1EePCTTfboXa4mEb4v1fm3dkTIH4TrrPk0+7d9Gs7ZatiZfl2O1fm
         2I+xYJwIEWYFkIjjEg36HQuXEqxNnhWU6V0v60Qgt+H1462O6vMV/zkciG/1TZT5QHU9
         4BizBXXqmRkORlq3hMLjV2zVGWnVNq7UPZ3Qb/cDqgp+0KW596oAR/OfAamUy3RM/YKT
         qZSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684891210; x=1687483210;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=84jCH5csYFlMMdBF7z2xCF1DPFHya9qG/1Sk/ks2VEQ=;
        b=gp5/pi2kv3u3AUXeCGHYrUypqebQFEg52O8ZE7AzoqKujZFK53Jn7tTANfQy6OPZZe
         fs0Ip/0uQjLOlwHAbJ2jCtiuycw3KHa+PtA6IVM5zgkgQRhKdFgSUDo1J4dgS1KvcRt1
         9+DMynS5nVwfy9c6VI5Fe9mwurcTHTrRZ+xZmHFm5urmWx69my06iDIuLaavHa+Bzug+
         iMvctWo2T6WQ5pZNgR712lJ60/ClF8/YmrCqqI2MDdB4Qd629olKhZVWCCVSF+++yDHi
         +0kfkmJwOeqQUF8hm6Znnd4KdjrgF3XYD4hpUxfeEZ7rNq8umT9iRXXsrk/kF0ARgcbX
         kJpQ==
X-Gm-Message-State: AC+VfDxX8IUd4eQ20JjNc3V9kViCUW7w6Lq+ThYfd5RODI37tYT3Kp1m
	lsvzeKYT+RSC746E1i37MSNcV3vNKg==
X-Google-Smtp-Source: ACHHUZ5bYkz7+O+Xl2QE+UD1IG8ASoya5T+BcH4RQ+gA43wAG22aGImQhzpnvX1IcQKPs1f/VDH7iw==
X-Received: by 2002:a05:622a:652:b0:3e6:3851:b945 with SMTP id a18-20020a05622a065200b003e63851b945mr24754439qtb.67.1684891210003;
        Tue, 23 May 2023 18:20:10 -0700 (PDT)
Received: from C02FL77VMD6R.bytedance.net ([2600:1700:d860:12b0:c32:b55:eaec:a556])
        by smtp.gmail.com with ESMTPSA id g14-20020ac8774e000000b003e38c9a2a22sm3298930qtu.92.2023.05.23.18.20.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 May 2023 18:20:09 -0700 (PDT)
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
Subject: [PATCH v5 net 5/6] net/sched: Refactor qdisc_graft() for ingress and clsact Qdiscs
Date: Tue, 23 May 2023 18:20:02 -0700
Message-Id: <304dfaef69e0212b98c355a45daf85316d7ce47d.1684887977.git.peilin.ye@bytedance.com>
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

Grafting ingress and clsact Qdiscs does not need a for-loop in
qdisc_graft().  Refactor it.  No functional changes intended.

Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Tested-by: Pedro Tammela <pctammela@mojatatu.com>
Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
---
change in v3, v4:
  - add in-body From: tag

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


