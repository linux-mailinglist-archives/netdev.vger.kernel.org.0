Return-Path: <netdev+bounces-6164-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D2FCF715003
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 21:53:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0BD9F1C20A8A
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 19:53:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E502D30B;
	Mon, 29 May 2023 19:53:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 917477C
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 19:53:16 +0000 (UTC)
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63303DC;
	Mon, 29 May 2023 12:53:15 -0700 (PDT)
Received: by mail-qt1-x82c.google.com with SMTP id d75a77b69052e-3f6b2f1a04bso39074221cf.3;
        Mon, 29 May 2023 12:53:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685389994; x=1687981994;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JUCdRb74xoe7yRH9kQhcOtOldKM1uZPQc2vGUcKFPtI=;
        b=XntEwv4lKMMJjiz9XCSIijRLHaUfoA/szXy43Ko776o7MPGsfrYK1CBErZEeVog32B
         PZJ/NFvJ/bTyKb4L/0nwBhG3TrCdODOlAyQD0AdyaxEfYEbgUhP5cqPcp+Hd30wSPKoU
         4HgcxmgBWDdpjLcDVQiulOxLZFIrvuzBtDnx1kMn4RhV8YoOTTjcnPV8orMpPHFqmcnP
         Uujyb2nLAsKOS0wyTLc2PugG/pDZ6E0u27yuMg2Y3Ol2JC86tbyXuO9FNR9o6I0M7IVq
         eoa/T49JUImlCEYQhA/Or5vEC0GpRTm1koghovh0qgttmDIiDfOp+zyot6c+L+ayPaLr
         Jdtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685389994; x=1687981994;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JUCdRb74xoe7yRH9kQhcOtOldKM1uZPQc2vGUcKFPtI=;
        b=mFfP/VOOjtk3kXaZgyyoLNN5YXpj6CCLzza2OKQBSkGck5sl6IvI04XvcV+00ZEwoP
         zuqlnfVQwZNhC/1VDRnDwwQcdvvl1SoHSfRj5C7XyTBqSX+jKeJwxt/hayr9pAJ3BohA
         NFAzzX5YdPF4+AW+kHpQFHHQYfZpuXsuk4bCp3FcQMLvkp7/DOa+dQoDI3RFiEVbbX0b
         OLrjJKHhVw2fsvt4BHIf8jfJlsg2QRNciOaHcNQGJbswAc53g82yL+WNXCN/RyDR1D1B
         /V8BDGjyNB3sxcWo0LuYYy2z0/fEgnLUBHncgdPHkftq1aesofVNDjgdES1Wlm41B3RE
         1vAQ==
X-Gm-Message-State: AC+VfDwi4bCHpUT5QT47ikNKpSKChqaN3BKAxWb/FLgYuePc5NVqReRv
	te9t2FRrzn37cNJbCZ9jnA==
X-Google-Smtp-Source: ACHHUZ4FvcGnSsv/YjpVVO5sp1ySAlTFv53RqUHcqwnlsIDb1/9kFFU4pnn+9V4QUSoFSvABIsoyQA==
X-Received: by 2002:a05:622a:1882:b0:3f4:cfed:96bd with SMTP id v2-20020a05622a188200b003f4cfed96bdmr11092382qtc.21.1685389994426;
        Mon, 29 May 2023 12:53:14 -0700 (PDT)
Received: from C02FL77VMD6R.bytedance.net ([2600:1700:d860:12b0:e554:e6:7140:9e6b])
        by smtp.gmail.com with ESMTPSA id 14-20020ac8570e000000b003f4f6ac0052sm4057129qtw.95.2023.05.29.12.53.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 May 2023 12:53:14 -0700 (PDT)
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
Subject: [PATCH v6 net 1/4] net/sched: sch_ingress: Only create under TC_H_INGRESS
Date: Mon, 29 May 2023 12:52:55 -0700
Message-Id: <096ec83977215f799362c36f747fe33515b19d2e.1685388545.git.peilin.ye@bytedance.com>
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

ingress Qdiscs are only supposed to be created under TC_H_INGRESS.
Return -EOPNOTSUPP if 'parent' is not TC_H_INGRESS, similar to
mq_init().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzbot+b53a9c0d1ea4ad62da8b@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/r/0000000000006cf87705f79acf1a@google.com/
Tested-by: Pedro Tammela <pctammela@mojatatu.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Reviewed-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
---
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


