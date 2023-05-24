Return-Path: <netdev+bounces-4836-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 155CF70EAA1
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 03:18:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 863341C20A93
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 01:18:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06DA41360;
	Wed, 24 May 2023 01:18:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE980ED5
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 01:18:07 +0000 (UTC)
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E945DA;
	Tue, 23 May 2023 18:18:06 -0700 (PDT)
Received: by mail-qk1-x730.google.com with SMTP id af79cd13be357-75b17b80834so70486885a.1;
        Tue, 23 May 2023 18:18:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684891086; x=1687483086;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CcHI3x4ohvXiCTNBiyxTM+9Lco9SeIQmLnH1EsUllhU=;
        b=DtQCWPCOPWS0+xDr8/swlbtrJH3RwebebAKwTSXG5R4kuTsfi71x0G5lXvhMh74ox8
         dgtHcrBAOndyoBNqZBxeK6YufsUoALMkPziyDyfAQ4OTLdq1iM3viKF+Cm10LfzTGeu9
         wTMHxvOZL/V6yit4mFGrJsEN3eLmxA3ceGnL49kT5HIZZU29wqZ8/LjBVdGdDGyLv8Qc
         Xz8Tad0q9vny+wNpxp29SHxmxOfDXXgHuqDMyRoxhBu1nKaMRtcPeszYw3tiIWMG/X1L
         QwT4ODVyrWHkBcmfRyk9eiw4DMHEsiRx47/TLNvLZEgVB85NuB8pQcsyb0dZtabOhjSO
         tX6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684891086; x=1687483086;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CcHI3x4ohvXiCTNBiyxTM+9Lco9SeIQmLnH1EsUllhU=;
        b=GVNuoUg3Rzpv6ljtobEd0LWguU5jLW1gVngzva4cy7Z6VfJKwtQFWL2BVVQWHcz9la
         /fLsyB9rG8gm6sh1Hq9YDh1V68ETBsMo13IkqlhrIiUUs/gJOHqE8iCXV5fspkadeJ/o
         4h+FiEnUmnUMuQ+giqUQOXLTuCKv0jrnl/GawO+qP3Ccabwd1kkTUhUs92pDIBEDcPW+
         mClnmkhjIaSEPHtUGmqxXvL3BWm2D/oppY2rnUQdk9GLqC6EwFcXrq8PbOcShJyFQ1Jm
         tObkAkI3J+0fyNVUxfwr7wcJN1QJumm5yplhhi3p9grgtM5R40v/r18PkmD5duhZR+oA
         2wCQ==
X-Gm-Message-State: AC+VfDwL43rP6Hc7cjCvdPDPoZgwGyGZpDsuqPigbg8ZI97sVI/+S8CE
	XOBqd6VN2uW0ADI+J5L4qZuOrtuf5g==
X-Google-Smtp-Source: ACHHUZ6IFMeCR3/s+eXDwMdei0BIDNIkp4kRGh1r9l9GP3wA2wsw8zikADCg8OFnmbecG9wEb2QgWg==
X-Received: by 2002:a37:4d6:0:b0:75b:23a1:44b with SMTP id 205-20020a3704d6000000b0075b23a1044bmr5344164qke.17.1684891085685;
        Tue, 23 May 2023 18:18:05 -0700 (PDT)
Received: from C02FL77VMD6R.bytedance.net ([2600:1700:d860:12b0:c32:b55:eaec:a556])
        by smtp.gmail.com with ESMTPSA id a19-20020a05620a103300b0075798551db7sm2920764qkk.22.2023.05.23.18.18.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 May 2023 18:18:05 -0700 (PDT)
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
Subject: [PATCH v5 net 1/6] net/sched: sch_ingress: Only create under TC_H_INGRESS
Date: Tue, 23 May 2023 18:17:39 -0700
Message-Id: <b0dcc6677248210348f08d9cb4e93013e7c95262.1684887977.git.peilin.ye@bytedance.com>
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

ingress Qdiscs are only supposed to be created under TC_H_INGRESS.
Return -EOPNOTSUPP if 'parent' is not TC_H_INGRESS, similar to
mq_init().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzbot+b53a9c0d1ea4ad62da8b@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/r/0000000000006cf87705f79acf1a@google.com/
Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
---
change in v5:
  - avoid underflowing @ingress_needed_key in ->destroy(), reported by
    Pedro

change in v3, v4:
  - add in-body From: tag

 net/sched/sch_ingress.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/sched/sch_ingress.c b/net/sched/sch_ingress.c
index 84838128b9c5..f9ef6deb2770 100644
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
@@ -101,6 +104,9 @@ static void ingress_destroy(struct Qdisc *sch)
 {
 	struct ingress_sched_data *q = qdisc_priv(sch);
 
+	if (sch->parent != TC_H_INGRESS)
+		return;
+
 	tcf_block_put_ext(q->block, sch, &q->block_info);
 	net_dec_ingress_queue();
 }
-- 
2.20.1


