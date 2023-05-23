Return-Path: <netdev+bounces-4584-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 38CEC70D4AA
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 09:16:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E450C2812E5
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 07:16:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D44F1D2BF;
	Tue, 23 May 2023 07:16:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 007771D2B1
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 07:16:42 +0000 (UTC)
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E57FD1B1;
	Tue, 23 May 2023 00:16:25 -0700 (PDT)
Received: by mail-qv1-xf2a.google.com with SMTP id 6a1803df08f44-6238daae378so24488276d6.1;
        Tue, 23 May 2023 00:16:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684826185; x=1687418185;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=57NopkrR4E6uJZDbhMvgsyr4j6E6ncv0YksYcMdLyVw=;
        b=rQl6JMojzazjCyTMuW/TrsUF7fJ1YCMeODyUxDa1qUbUcJyeDTSwtxfljWJtGfog7K
         fSYY110KA1aZInKmPmNjb+1Yqfusp3yR4/g5x8kdLik2qc2h2bKsMvXmMyzrasp52cA7
         5yx+VL9c2B1BvyfKg7MfPBjK0roIs4ljxv9x8bmiLSUtDQ+zq+BXBcz2jvmVChJNYcNU
         Da8gn5lgX8QVPosepqm7EnPr6JePmp4GaagegjnLGJusO2ZIx4N8UPEOJB9gPzu/IDkP
         xnNqp5LQ0pQ/2WTBxGfyr7YU2FIo6cKYDE4GJ0SrBnG+a1vV9+01fEvsi5ce1+FeGYu3
         BdfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684826185; x=1687418185;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=57NopkrR4E6uJZDbhMvgsyr4j6E6ncv0YksYcMdLyVw=;
        b=acO3LJedAhi4EFj7wCvf9VZleJpCZo4YFraCXCSsUXuCM0DtRVVy/BTfgSEcOVZicB
         mXku/eH8ELOgKWFnnyUMuj8AdPOqUjUaumc6kVFrVRYgO3qU8MtaAaItFWIsVF1nnERl
         k5EZMLssjhjLnv4k+C73ssvy8il/oieNpYlpGK8kuY4SQHvXd3dXAE3+OQzNNrYVo9IK
         PXMF+nPGM6RZtiysFiAOxGMu8Dt/nCo3N8o22yaPNf0Uj/hxYP//YtzsrufDruMv0zro
         D/bAsvbIRShzK/+PhyCYh56mCAbmi83nrhylYBzeBBecLAe9k8ayo83qp8VdcJL7r919
         AlyQ==
X-Gm-Message-State: AC+VfDzHu9F6tP7aFVlLVd0LN9ln+EJxLVsvs6BBmMYNGDavYHaFwcee
	EFjIAWhAx6Dkp1vtI8nE7Q==
X-Google-Smtp-Source: ACHHUZ7KKo7njr3EmK4QVv/fuKhtYgXhltOz97vxh+IR3xbh8Jr5bTE5isoW9Vcm6V8bFfppsRj/qg==
X-Received: by 2002:a05:6214:d8d:b0:621:363c:ea93 with SMTP id e13-20020a0562140d8d00b00621363cea93mr18128510qve.15.1684826184972;
        Tue, 23 May 2023 00:16:24 -0700 (PDT)
Received: from C02FL77VMD6R.bytedance.net ([2600:1700:d860:12b0:18c1:dc19:5e29:e9a0])
        by smtp.gmail.com with ESMTPSA id e11-20020ad4442b000000b0061c7431810esm2519139qvt.141.2023.05.23.00.16.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 May 2023 00:16:24 -0700 (PDT)
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
Subject: [PATCH v4 net 4/6] net/sched: Prohibit regrafting ingress or clsact Qdiscs
Date: Tue, 23 May 2023 00:16:16 -0700
Message-Id: <4bc54b82ffc3816058de543f383623a022a36d18.1684825171.git.peilin.ye@bytedance.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <cover.1684825171.git.peilin.ye@bytedance.com>
References: <cover.1684825171.git.peilin.ye@bytedance.com>
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
change since v2:
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


