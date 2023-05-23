Return-Path: <netdev+bounces-4566-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F1AD70D3D8
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 08:19:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 193A11C20CAF
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 06:19:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A4D01C74B;
	Tue, 23 May 2023 06:19:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E1901B908
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 06:19:56 +0000 (UTC)
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D152F119;
	Mon, 22 May 2023 23:19:54 -0700 (PDT)
Received: by mail-qv1-xf2a.google.com with SMTP id 6a1803df08f44-6238386eb9cso59272966d6.1;
        Mon, 22 May 2023 23:19:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684822794; x=1687414794;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9o/AkYCvO3tV2BU0V8GNdESZ1hmHFfJ/JAYYnq2G7Ts=;
        b=ltSNDHag4sBJXgnPrLe1CebvaUqaao+DR+zTyCo5AHases8sTOQVIaeH85q1QXnnAY
         lQw9vk7fkxQB7hrKCsNxtdOX+J9HbTj13D7yi4YjM3s+ZmhpaOSygpboeXXoyboMMK9v
         DU0++lebgnMKXewdizqARwdvl5VQSujfrfDX1D/6Ka1h/IPNHjbP045rveIPdQ0xat//
         Qb9F0P3aECjUjlNGFDZ9o5MqW62U6ezv9UB4cl20RNuVouXEA7ZcyP6Fc+5fyWWHmJFb
         742h42pMC68PBgRJWiB7RLMXIcTPuENNXj4lXCCdUa0rZCXki+JwsBhCq6LewsvB8uBB
         27Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684822794; x=1687414794;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9o/AkYCvO3tV2BU0V8GNdESZ1hmHFfJ/JAYYnq2G7Ts=;
        b=HmFgx9fVRVIwmZ/BH3feVS6xSwLhp/NJkvToI/URFNlqB1gqQmmnJqRh+SX0+obN+L
         yyFDTScUbeed5t8S7vdaoD4oDHZ42e5ABWmDfT4o41y/KjrAVRk/MQL13a/JPn4ba+ra
         Da0AUksm5Iss8ppPjvRV+l+PeE+cgwIH+ADLJLIFE4joKMPLJ7YrrWso+Rwoayl/vQ5/
         /RFnNVGY7pMY8MKEDI9/OYFFSV+Ozx5h9ZrYCZUjSpe8FtAe749m8+0Mhn3zPQefYxhM
         ImBSSm3GnGmN5qyAZre/idpPeE5wnZyhyZdXU89PpPfx/V9WbRKbtSRBqVjyh+S9pRnK
         6sUA==
X-Gm-Message-State: AC+VfDwS2ml/hQ3Br7e72BoFFhgAZ4rJrPMkN1Uq8y2x2vhe9V9bRyR5
	NHxGpgbPGUdtafzI9cmiyw==
X-Google-Smtp-Source: ACHHUZ5/l+u9V0ZEoDbPOfnGgrn6JxSlQeOvcewZ/8UgiMcfjyKlE3y3IUjhKeYxNZqgrMWLcZcq6w==
X-Received: by 2002:a05:6214:29e9:b0:625:8b9a:b426 with SMTP id jv9-20020a05621429e900b006258b9ab426mr3639169qvb.46.1684822793931;
        Mon, 22 May 2023 23:19:53 -0700 (PDT)
Received: from C02FL77VMD6R.bytedance.net ([2600:1700:d860:12b0:18c1:dc19:5e29:e9a0])
        by smtp.gmail.com with ESMTPSA id ev18-20020a0562140a9200b0062363e7dac5sm2502043qvb.104.2023.05.22.23.19.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 May 2023 23:19:53 -0700 (PDT)
From: Peilin Ye <yepeilin.cs@gmail.com>
X-Google-Original-From: Peilin Ye <peilin.ye@bytedance.com>
To: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Jiri Pirko <jiri@resnulli.us>
Cc: Peilin Ye <yepeilin.cs@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>,
	Vlad Buslov <vladbu@mellanox.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	Hillf Danton <hdanton@sina.com>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Cong Wang <cong.wang@bytedance.com>,
	Peilin Ye <peilin.ye@bytedance.com>
Subject: [PATCH v3 net 1/6] net/sched: sch_ingress: Only create under TC_H_INGRESS
Date: Mon, 22 May 2023 23:19:44 -0700
Message-Id: <72c5a2b8ae1c3301175419a18da18f186818fa7c.1684821877.git.peilin.ye@bytedance.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <cover.1684821877.git.peilin.ye@bytedance.com>
References: <cover.1684821877.git.peilin.ye@bytedance.com>
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

From: Peilin Ye <yepeilin.cs@gmail.com>

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
change in v3:
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


