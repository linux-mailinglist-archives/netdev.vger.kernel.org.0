Return-Path: <netdev+bounces-8671-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F3254725211
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 04:23:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2FCD51C20C18
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 02:23:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD9CA7EE;
	Wed,  7 Jun 2023 02:23:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C29407C
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 02:23:30 +0000 (UTC)
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2DC51BCE;
	Tue,  6 Jun 2023 19:23:28 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id 98e67ed59e1d1-2562b1b1af0so1141495a91.0;
        Tue, 06 Jun 2023 19:23:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686104608; x=1688696608;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Djg5dlpocMxoWtp83WsoLtvscbQqzDgsckqpUkScGwU=;
        b=D+zw1JU+/0qPuADYs7VAVVNlgpPWLT6c8PfUykq/GU+ZU/d9h/iELkv2I4FpK91eLm
         kY2qvwVsdkJRq7JQVLrT/6ESn0ZHvlYhgaFKrF+pLlcQ9Z+35LtOVE25W6aWVkGcj08D
         MMcYJRdn//hf84a/MrYmCswOh5cTainUXrDNAZh9z/LVw0BYVE0x2A+mPu1M/l+JIQaJ
         1HiMQE3si9sLoTcMvA2BjjfLniXdtrzZOgP2SQi9YfmtaJ2RlGfVL2FzcgROtN3+t8OL
         sUOU/ZHPYyjU1BZJh0z3dBQT8R5DNnNHDLqxwDqeGtK+0RSEIn4fvpp9JnleAJFtTSUb
         YH0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686104608; x=1688696608;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Djg5dlpocMxoWtp83WsoLtvscbQqzDgsckqpUkScGwU=;
        b=livIKdgsCs8InJBH1TNhyGnoyN86sR2y3GPFYZCrRSDJwXcpCrf3KEJZPyz/l2mgJg
         rtk0UGHfk98drZRo84dkitR9B/QbtkShYzhZ5GX8cjS6iIZbKXYCA/ZINDlgJryy7OZR
         M/2yA5xGlXHfN0M8PXjrDjPC+CJ7Jn95OqaihmBb0yicygCWuH7MRxTqF8s+dT7Om4tk
         qAHHCoENWPNbADlTobeFa8szLicuBRONyLk95efC3pj6/CZixTdDwleTvMybK88MemNF
         a/WDZ1zy0GvlRI92+AStKBDQvDlgwQDk97kYTRaIgogJCUa4RaE4aKD0fV0akYLuVaBC
         vxwg==
X-Gm-Message-State: AC+VfDy5h8cdns5YRrhg5Zg928DxB0x381L71e5KyGMy7V1yluzVR5EE
	9pJsBsdQcd3zs554aDr6/Dg=
X-Google-Smtp-Source: ACHHUZ4EnoK10KSVAk+RomjJZXJS4eui1qsC8XgtfmyCAxEqU7kzz54IFTk6HqnHdrOLoAVZycfjUA==
X-Received: by 2002:a17:90b:33c7:b0:258:8c84:7db3 with SMTP id lk7-20020a17090b33c700b002588c847db3mr634096pjb.3.1686104608467;
        Tue, 06 Jun 2023 19:23:28 -0700 (PDT)
Received: from hbh25y.mshome.net ([103.114.158.1])
        by smtp.gmail.com with ESMTPSA id f36-20020a631f24000000b0051f14839bf3sm8050397pgf.34.2023.06.06.19.23.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jun 2023 19:23:27 -0700 (PDT)
From: Hangyu Hua <hbh25y@gmail.com>
To: jhs@mojatatu.com,
	xiyou.wangcong@gmail.com,
	jiri@resnulli.us,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	simon.horman@corigine.com,
	larysa.zaremba@intel.com
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Hangyu Hua <hbh25y@gmail.com>
Subject: [PATCH net v2] net: sched: fix possible refcount leak in tc_chain_tmplt_add()
Date: Wed,  7 Jun 2023 10:23:01 +0800
Message-Id: <20230607022301.6405-1-hbh25y@gmail.com>
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

try_module_get will be called in tcf_proto_lookup_ops. So module_put needs
to be called to drop the refcount if ops don't implement the required
function.

Fixes: 9f407f1768d3 ("net: sched: introduce chain templates")
Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
---
	
	v2: fix the patch description.

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


