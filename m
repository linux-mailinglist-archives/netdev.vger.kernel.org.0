Return-Path: <netdev+bounces-4441-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B1E2870CECA
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 01:55:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6D81F2810C5
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 23:55:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86CA617747;
	Mon, 22 May 2023 23:55:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7545B17739
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 23:55:07 +0000 (UTC)
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2071213E;
	Mon, 22 May 2023 16:55:05 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id 46e09a7af769-6af70ff2761so845475a34.0;
        Mon, 22 May 2023 16:55:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684799705; x=1687391705;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6w0tHXoycuCHPxvFjx9JgsU6uyQcbmVkIq1ehIMdFnA=;
        b=hVGimPahIRoBsZXN1TYJLbnb315fAbDFUO2XjU0SvRW3Zxg6QfJGL7M4AtaAyOh5Er
         bsLoVpz63swq20sEYL9Brng9pCOZ4qjgdvYL6REWjYXfSnMkq/aqqkwcfjXeCuNuXRJj
         CUUzfdt+uHNMC/EdMqtoTVUaTAyeIOuStZJHFRRnarJeI/hnkKQofvzxSY/7kE9HWboN
         6REcgvkRUG3cUmppdyCXo21TVPBMctXHsIwAE9P4GkUzXBlIkhqZetzWEHM42XgNL0Xy
         S+ip+clF8B40Vu3PLHNBJkF8fjmXMhTYhMn0f/PLkb4W4rRTPwZsleRK7rUd0kMaNpvf
         2xEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684799705; x=1687391705;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6w0tHXoycuCHPxvFjx9JgsU6uyQcbmVkIq1ehIMdFnA=;
        b=AzR2eyArrtH/R3mMNLmgalTjZXuM6vx+fhq6rxM1K4LzYAKfu4x0Auc+ey3ApUlH55
         tImsSKrqFEB5whgYg1mr8Ir76++hIsSvcHL4PIsYs/DSd3RxEFtmA+h8mybN9FVCqRZm
         y0QUamWDX2kx0SGkZoKwBSlvm7s9KCu8OWxOczfsKJmOa+Z2MsVXgE9SRwd7aeumgEi0
         jVBxO6gw5ddGA5H+W5vWQOd8IJj7/mq3q1rX0ZDV+rB4JONJkp1GpgVZui13wry14H9k
         ByQRwHhtyJsHEbGcm1mlH168fDBgkzgCXd4Vm24UN/kOW8Cvm0WP/uCOXSdC70CE84/B
         MFqg==
X-Gm-Message-State: AC+VfDx9qhtzpcvu4eqBVTgyKnxppyjPnroOF/rIddB2zxWpw/pNrD9n
	03wPB+PZP7vZVZ6VxgtnSw==
X-Google-Smtp-Source: ACHHUZ6o82VRDExjimiyZ59YRxP3ymwWmtjdBWhmbriezvtuzJUbc2Sq2fbWfvubyCnFt0Mkmw3JlQ==
X-Received: by 2002:a05:6830:61a:b0:6a5:f792:dbe5 with SMTP id w26-20020a056830061a00b006a5f792dbe5mr6132994oti.22.1684799704958;
        Mon, 22 May 2023 16:55:04 -0700 (PDT)
Received: from C02FL77VMD6R.bytedance.net ([208.184.112.130])
        by smtp.gmail.com with ESMTPSA id f15-20020a9d5f0f000000b006a662e9f074sm2870814oti.58.2023.05.22.16.55.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 May 2023 16:55:04 -0700 (PDT)
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
Subject: [PATCH v2 net 4/6] net/sched: Prohibit regrafting ingress or clsact Qdiscs
Date: Mon, 22 May 2023 16:55:00 -0700
Message-Id: <c93c5b4d6c938bd6a5e5120c3700b07e769a326a.1684796705.git.peilin.ye@bytedance.com>
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


