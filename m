Return-Path: <netdev+bounces-652-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 96FC26F8D1A
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 02:15:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B1DE11C21A71
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 00:15:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4988019A;
	Sat,  6 May 2023 00:15:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F173180
	for <netdev@vger.kernel.org>; Sat,  6 May 2023 00:15:12 +0000 (UTC)
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31D2C7298;
	Fri,  5 May 2023 17:14:59 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id 3f1490d57ef6-b9e6ec482b3so3134148276.3;
        Fri, 05 May 2023 17:14:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683332098; x=1685924098;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R5eH6bco8EBNg+RUkT1y/nbet2LbT1MKzNNIZmJJf/I=;
        b=GLdgRvgmy+lIHMs//TSSKBV1q7prEBGmiOrTpubYTUMBiNdgH1R44GroLHFsS1wJal
         StwIZaY71xUZcAHD5DwccrbpdOU8nsh1g/1vV0bGOa32rAVxpByxhgra1psurezlKn0b
         cqFgdOJS1j16lD+697pewqVJR1v4Cy3oh0B76yvGHSWlyBNsPY9NyUdjYSp2kTf0P4lX
         m6/qGqqW2gSU6Ycr7NyV+jiuZBxySHnPOZXjxLOTzyJlBDMrRoYpcn1uk7TcpZxJKuhD
         rjp5yb1CXoizWx7QPpdD/gMFRarZgQ1EL3wVMwbiS9yfdr8ruuiRrOWYELf6Gt9+rLiq
         gDxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683332098; x=1685924098;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R5eH6bco8EBNg+RUkT1y/nbet2LbT1MKzNNIZmJJf/I=;
        b=bpBh2dUeaUd56dedzry8yr5PHOjuz/DOaIGkdzUbA7KgZp0DgLrNgVxHyT83XBnYfw
         1GpwLQUTwhicQ9dISiJ7rmFUdUo457YkLAyomN51oZafMqRsDXpf7FhUlfdVbTWbPO+U
         Pxu8wZeG1lEZn+ztcObWW8iQ1ZIr7Od4HrB7NNlQi2DsoHfTaudWvW7mNy4foTW4ybOz
         hx6/zgeiSCr9BSMhCG8ok7GnT6A/jpXXaV2dphIRYPnlPKwkAba2rQNBaDqWZkNKEJWp
         W5EDuE13FkPQ6SZOS0fSoawhZ0oDTLzS1w9O2c3ctef2RqdKl82ntChELajnW2q40mUP
         HuQw==
X-Gm-Message-State: AC+VfDxbBcLErNP9+4Qcs81kzbVsza+aL80Hacizpm/NRJZnaF5VT/rq
	ja/WT3i3g8KCtWHOIt9uRA==
X-Google-Smtp-Source: ACHHUZ4AEKVqoOHJ8so6qSaqANf0O1NzAB5KrlL+HNtIP0vfd95yJnF1rWupCYyq2Gyeplb11Xipjw==
X-Received: by 2002:a25:2fd4:0:b0:b96:6c84:9288 with SMTP id v203-20020a252fd4000000b00b966c849288mr4436859ybv.9.1683332098347;
        Fri, 05 May 2023 17:14:58 -0700 (PDT)
Received: from C02FL77VMD6R.attlocal.net ([2600:1700:d860:12b0:5c3e:e69d:d939:4053])
        by smtp.gmail.com with ESMTPSA id g194-20020a25dbcb000000b00b9a65b05384sm802044ybf.15.2023.05.05.17.14.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 May 2023 17:14:58 -0700 (PDT)
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
	John Fastabend <john.r.fastabend@intel.com>,
	Vlad Buslov <vladbu@mellanox.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	Hillf Danton <hdanton@sina.com>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Cong Wang <cong.wang@bytedance.com>,
	Peilin Ye <yepeilin.cs@gmail.com>
Subject: [PATCH net 4/6] net/sched: Prohibit regrafting ingress or clsact Qdiscs
Date: Fri,  5 May 2023 17:14:40 -0700
Message-Id: <846336873bfba19914397a1656ba1eb42051ed87.1683326865.git.peilin.ye@bytedance.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <cover.1683326865.git.peilin.ye@bytedance.com>
References: <cover.1683326865.git.peilin.ye@bytedance.com>
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


