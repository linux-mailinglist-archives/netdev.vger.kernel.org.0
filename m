Return-Path: <netdev+bounces-6167-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8619A71500E
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 21:54:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 32C1D1C20ABE
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 19:54:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E413ED532;
	Mon, 29 May 2023 19:54:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2A897C
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 19:54:54 +0000 (UTC)
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D05EE8;
	Mon, 29 May 2023 12:54:34 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id af79cd13be357-75affb4d0f9so198229485a.2;
        Mon, 29 May 2023 12:54:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685390073; x=1687982073;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lxvQw36IJl6rfxc29dkpYIkomgzupnmi9RTlBUu4jpM=;
        b=nKqoAUuPyVq/aJ9gd0zhUb3Y9lkz9zyKMSJYH89cH0l8Y1uYpphbHorz3yX374Yhpa
         XufpTqweW4msVG6WxtYLw+3uPNdok9tCRoC4eTI/9MZTVFmomoHAHts2+cQpuTT6oSo/
         30LUb6sogPqn4BTXo7rtxYSvZIeTSHCsy2qHxQKzbr8bgZwtxTDmdcdcMwX+kwmCTLT9
         +VWatdrjpNtBF0AK6IZBcnqwZ74NBSdlLHMb3u6FulN/JaNN/I7h2D+EWVvXyApkpo/g
         Wd8fPgSM/kY4osBaF1L3PCkZWeAF2Qv5vKJRNYhbDnvVmvhPqgmJnbEwk+lfrfzFNa0o
         St9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685390073; x=1687982073;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lxvQw36IJl6rfxc29dkpYIkomgzupnmi9RTlBUu4jpM=;
        b=Las01I5NFcyLgTG5ETLh6jUXxbRTYKE2HDKe7Wb3UPhWcxmTg/8LDQC56/fOWZ1DpV
         e/6teTHf+ddiYiXC7p+LsAlyhHiMUyDr/OSn53j0pfaqZ75BAw+Dr9S/7rdU6ZTXGW5n
         mRv6J9buVrbGySBZVt1U6SEx30hkEYibco2Vj6M1+QvAwXIwkE3aSb1HII62XwvSndr4
         B4jghDzQccomh8NtfgHoEseqlaHN5uJuTKXlF2yYoDUo+/tKW21XAR14cMyAlpBPncv5
         BlL1c9vBk4nNlx0Vz290m+9so3ts9yy+MpkUgG/eMZB1+Qtt4gy14Sdxqpk/Bt4cnuAJ
         d8rA==
X-Gm-Message-State: AC+VfDxaosqdQ4JKGTBirMdItjhPoBSYK8giO2zcpqCtkaavhp81quiE
	gpR8OEpnSJlmju05eua+Aw==
X-Google-Smtp-Source: ACHHUZ7SjJlMriPBR3mjMu9jZpO7EN8HYr0LZamkEpaENZvmNmcIZNeh7cOiOFG/uGzKAHZi0k5JdQ==
X-Received: by 2002:a05:6214:1d2e:b0:626:1e95:2feb with SMTP id f14-20020a0562141d2e00b006261e952febmr6460529qvd.19.1685390073317;
        Mon, 29 May 2023 12:54:33 -0700 (PDT)
Received: from C02FL77VMD6R.bytedance.net ([2600:1700:d860:12b0:e554:e6:7140:9e6b])
        by smtp.gmail.com with ESMTPSA id f12-20020ad442cc000000b0061b5ad0290asm3933355qvr.67.2023.05.29.12.54.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 May 2023 12:54:33 -0700 (PDT)
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
Subject: [PATCH v6 net 4/4] net/sched: Prohibit regrafting ingress or clsact Qdiscs
Date: Mon, 29 May 2023 12:54:26 -0700
Message-Id: <182b2a2be81ad5ac0f58effe34e3a320de04d6c7.1685388545.git.peilin.ye@bytedance.com>
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
Tested-by: Pedro Tammela <pctammela@mojatatu.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Reviewed-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
---
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


