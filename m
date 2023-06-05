Return-Path: <netdev+bounces-7878-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7288A721EC7
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 09:02:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2C09D2811B9
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 07:02:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F0F86105;
	Mon,  5 Jun 2023 07:02:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51E24194
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 07:02:42 +0000 (UTC)
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14D9FD3;
	Mon,  5 Jun 2023 00:02:12 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id 41be03b00d2f7-52c84543902so279391a12.0;
        Mon, 05 Jun 2023 00:02:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685948530; x=1688540530;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=dJT/sRF5KYka/O8wMeQ1HTIrVd4xnv3bYNT/8zFnrPA=;
        b=qYWmyp7ksT4pI/yXswqnzosuyVhYy6HFFYgDQLcsACELE49rnNkCn88df8p0KR7ck0
         2YptChW2qB3FhvPO2b7Ox81ZE0XQXH5W0y7ei2GHouls1kW1LpOBBlUIUYqhVTK8x9b6
         FYixgWUPnMLj6lsibNkgZbHj+bhSgfUbFjSXqc1Igf6ve+f2s9w/UB3E0JCGAXNhoCXV
         01JnuBAT8dzQpPAUnYLc26CuOmD2MKqYy2FYoOPvbhwbc6YbQ+aKj72PkZZeMUcoIRCG
         S98VuOULel93hNXJSbp+Qp2n8l3pqzkq55QXGvmbAW7RMeRAEOj341V8kEH7aX+Crmsw
         Kx/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685948530; x=1688540530;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dJT/sRF5KYka/O8wMeQ1HTIrVd4xnv3bYNT/8zFnrPA=;
        b=D5+ib7K2e6wboPVG6uY2SXnMZRIfWsDQ+D/s0yN9e2Tt90q5bQ4M5/Ok4cjjgkOncM
         9XgyffntOaqtk2OuaKAVyFeRXHRByX/2eTm0gZLAZ6i2rhNNTefoI1OP4JwZshal2ctV
         CcSwbh7q2XIA1s6lELjcvgNl8EOk/VBL7N+IxizwglvF3bFQTMhTWROnMnmrK+IFaZWD
         /3NmmbNdOUnNCmLJUZ0H/LDzP4+vEwbOFeFKdZrnEzGOKwI3MLOO8lebi6Ph3CaP1yPa
         GC2+FrX4fQsxYnTsV2Vr6Liqb8PvCdpRQaGIADL32RTjEQEgsVzusSemPzfyEcST+r2D
         IISg==
X-Gm-Message-State: AC+VfDzxz4g5Ed1L64xMogJg8jr3oGoUNsTnH0vmLVgKg4aiBWqOELrw
	8/JUSSCCdCXAMmiGeCB9ch8=
X-Google-Smtp-Source: ACHHUZ7F9duUYHB7l3iguA5l8Lfnr33TruG8kWXVcSbz+pgdJ4ZmpzwgX+33T0nZKcCuzbYlb80Qgg==
X-Received: by 2002:a17:90b:4f47:b0:255:c3a3:43a with SMTP id pj7-20020a17090b4f4700b00255c3a3043amr17351826pjb.4.1685948529855;
        Mon, 05 Jun 2023 00:02:09 -0700 (PDT)
Received: from hbh25y.mshome.net ([103.114.158.1])
        by smtp.gmail.com with ESMTPSA id hg12-20020a17090b300c00b002562cfb81dfsm7004534pjb.28.2023.06.05.00.02.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jun 2023 00:02:09 -0700 (PDT)
From: Hangyu Hua <hbh25y@gmail.com>
To: jhs@mojatatu.com,
	xiyou.wangcong@gmail.com,
	jiri@resnulli.us,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Hangyu Hua <hbh25y@gmail.com>
Subject: [PATCH net] net: sched: fix possible refcount leak in tc_chain_tmplt_add()
Date: Mon,  5 Jun 2023 15:01:58 +0800
Message-Id: <20230605070158.48403-1-hbh25y@gmail.com>
X-Mailer: git-send-email 2.34.1
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

try_module_get can be called in tcf_proto_lookup_ops. So if ops don't
implement the corresponding function we should call module_put to drop
the refcount.

Fixes: 9f407f1768d3 ("net: sched: introduce chain templates")
Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
---
 net/sched/cls_api.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 2621550bfddc..92bfb892e638 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -2952,6 +2952,7 @@ static int tc_chain_tmplt_add(struct tcf_chain *chain, struct net *net,
 		return PTR_ERR(ops);
 	if (!ops->tmplt_create || !ops->tmplt_destroy || !ops->tmplt_dump) {
 		NL_SET_ERR_MSG(extack, "Chain templates are not supported with specified classifier");
+		module_put(ops->owner);
 		return -EOPNOTSUPP;
 	}
 
-- 
2.34.1


