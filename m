Return-Path: <netdev+bounces-6165-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D55D715007
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 21:53:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CAC311C20A51
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 19:53:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AD4AD50B;
	Mon, 29 May 2023 19:53:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E7467C
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 19:53:48 +0000 (UTC)
Received: from mail-qv1-xf31.google.com (mail-qv1-xf31.google.com [IPv6:2607:f8b0:4864:20::f31])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AE6EDC;
	Mon, 29 May 2023 12:53:40 -0700 (PDT)
Received: by mail-qv1-xf31.google.com with SMTP id 6a1803df08f44-6261367d2f1so9251346d6.3;
        Mon, 29 May 2023 12:53:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685390019; x=1687982019;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UcEdDdXCSlEJHLE21T8eIPNeaLZDuAJRCHh3+SO0w/s=;
        b=rX/CyrnU5xB9CWMptTZ1HHdd3qB2l0CWh6sO7e+pCFJvhr6i0dbnjK3wrAu0AW2JHF
         hnqzGFk+VVKdzFemrFTX3CA7UPM5XOi9+P0nlhD8IylSPLXo5ldEZ8XeocCn2rQZphuc
         0T85dS6nab93Z0wD9qNrcuPacVmCgNk0SJKim2ZgqVi+DtMblcy7FB1kGlKbx3HRk/9T
         XLcvOu7wgX9PTDLDjf0ozVnuFJTlqpqeZKXEzret6aiZnHwLIjZvFgQZ0slvwU70qVAA
         11V6NwmcC5GE2DI5XMcvPkPKOfncI6Jh0PFkFF6lSXJZnHO/ClOZqV/NRO144ImMJfGK
         do0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685390019; x=1687982019;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UcEdDdXCSlEJHLE21T8eIPNeaLZDuAJRCHh3+SO0w/s=;
        b=h6hPZYBrm3RWGHZPP/+4YM69FVa4gkSGl4ggnsdfE3xSnre3WLNRL/AzziU75IvxBb
         9xdiVSqJ6jOXAlFS9YgBH1ChLBeY+v+uHXGZeXHFHba4YKtrC7k+D4bM5vJnxSwyDQmZ
         NmkvamFlYz+SpZ+u3ksqmoDzCfAzMZyxlG6au5uCw70EyPyl0aWYPZAjiGwBRaxvbehJ
         xdomBbZ4AMnFqz8P/5HbrQKFAkdXNLGgVbk0Yq3B8VejRg19fpX/Q+WnsXMbPFtdkv8s
         hmV+oce2+4BhxnIXlhR13Kp6LgD6fZYxjsVGYpIEtX5cKlVegRTlz5h2VhrwGL/U6g1b
         DSIg==
X-Gm-Message-State: AC+VfDwSw0ueT0SSQhuCRPm7jQ2cXyIHhJ9QzDi4fFIH1Iz5Mvw3zU/G
	5TgHO/uoMX2mN3K8zZ/OR735rqTljA==
X-Google-Smtp-Source: ACHHUZ6Oc5xTMoMWV12Nf8SHjQBRLhJIGz5H87mupiGMAvma+KO5alSLWL4i72eDPgESb3oCG4XCig==
X-Received: by 2002:ad4:5cc1:0:b0:625:aa48:fb6f with SMTP id iu1-20020ad45cc1000000b00625aa48fb6fmr15746577qvb.57.1685390019537;
        Mon, 29 May 2023 12:53:39 -0700 (PDT)
Received: from C02FL77VMD6R.bytedance.net ([2600:1700:d860:12b0:e554:e6:7140:9e6b])
        by smtp.gmail.com with ESMTPSA id c11-20020ac853cb000000b003f72236e150sm4103258qtq.33.2023.05.29.12.53.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 May 2023 12:53:39 -0700 (PDT)
From: Peilin Ye <yepeilin.cs@gmail.com>
X-Google-Original-From: Peilin Ye <peilin.ye@bytedance.com>
To: Jamal Hadi Salim <jhs@mojatatu.com>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Jiri Pirko <jiri@resnulli.us>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: Peilin Ye <peilin.ye@bytedance.com>,
	John Fastabend <john.fastabend@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Vlad Buslov <vladbu@mellanox.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	Hillf Danton <hdanton@sina.com>,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Cong Wang <cong.wang@bytedance.com>,
	Peilin Ye <yepeilin.cs@gmail.com>
Subject: [PATCH v6 net 2/4] net/sched: sch_clsact: Only create under TC_H_CLSACT
Date: Mon, 29 May 2023 12:53:21 -0700
Message-Id: <2b012b76ec2315729d3e993a69b36753e8d9d29f.1685388545.git.peilin.ye@bytedance.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <cover.1685388545.git.peilin.ye@bytedance.com>
References: <cover.1685388545.git.peilin.ye@bytedance.com>
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
Tested-by: Pedro Tammela <pctammela@mojatatu.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Reviewed-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
---
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


