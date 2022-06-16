Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E54954EDFA
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 01:44:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379398AbiFPXoH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 19:44:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379395AbiFPXoG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 19:44:06 -0400
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B21343393;
        Thu, 16 Jun 2022 16:44:04 -0700 (PDT)
Received: by mail-qv1-xf32.google.com with SMTP id o43so4362089qvo.4;
        Thu, 16 Jun 2022 16:44:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4i92zMdv42ClJHrXqyQi2anpIFEyByUeRHtQqWjKej8=;
        b=FjEPLHljpPNhGXaBR8wgmdGNidg1Alh+IKzKpZ1eIuznx1bqjubMG9KYlh6WBj7Z3I
         SqU0J1xFoeKgm3mPo8gIPvcAfpZrz3bE/DFd7wrn9uMOfuaEic1khWO85JYi2izJUe7M
         SIfOj9alS3aNhlBCui9AAkUQmC9B6usAfpy759fCkCHDD/bv+RM+mkRWOzTADmvndNyl
         mjGWdnqoOwv6JPqMlW+uZCoQU/+nVHAH8iweWZvWzHqrVm33UGU5aI7fjDFnQ9MkUqJB
         hv8sQsmuV91AvK2e/6IMqKpM9NWycAst4AAz3xP4BExBRZ2DHv1p1h26Re0TG28BoePb
         bnpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4i92zMdv42ClJHrXqyQi2anpIFEyByUeRHtQqWjKej8=;
        b=1ujilxjJWGVBIsLJilbT9q+kiLIVZwV0aolZelgYjmDB7rTAJO+4cQ0lCXjWCpzjkM
         yum11TWP2G2EURbYCBz3KAZ2hVgQYoZgzVIqMU2O4aoRX0skse0eNNMp4RbaBJrtscAS
         2numLWsqLv32iUyq3HRSYBRzTFrNFGZ1/AyKzU33ieFZfXKnL/rlQv2A5EsSB93YAxNs
         mrEpJcw++Kt97v7z04PfGTTqVKmhU9uOnDB9CL7l0ondETOtOnzq95Sc2LLzFah4bk7I
         8T1dsfkiPBnNYhv3nxpO4CeYt8JeeQk4bWzypRtz1kWJAGXQ2PLcqiGaMmhcP83TSCNo
         C7OQ==
X-Gm-Message-State: AJIora8ewHf+9VcIa58+j6QkRyEX9naRO8tAlTWyDw2GifWlhWBe9/9o
        CLF1lVOvTC2cxLGJEDZWGQ==
X-Google-Smtp-Source: AGRyM1skZCoweTL1d+HODcU9tI4jISPwPi3boEqinp9K+Hs5q+0FZCKwPOv4c1RjJAKr4CQadVfqSw==
X-Received: by 2002:a05:622a:14c7:b0:305:2464:85a2 with SMTP id u7-20020a05622a14c700b00305246485a2mr6216118qtx.401.1655423043540;
        Thu, 16 Jun 2022 16:44:03 -0700 (PDT)
Received: from bytedance.attlocal.net ([130.44.215.155])
        by smtp.gmail.com with ESMTPSA id b198-20020a3767cf000000b0069fc13ce1f3sm3021011qkc.36.2022.06.16.16.44.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 16:44:02 -0700 (PDT)
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Cc:     Peilin Ye <peilin.ye@bytedance.com>,
        Yuming Chen <chenyuming.junnan@bytedance.com>,
        Ted Lin <ted@mostlyuseful.tech>,
        Dave Taht <dave.taht@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Peilin Ye <yepeilin.cs@gmail.com>
Subject: [PATCH net] net/sched: sch_netem: Fix arithmetic in netem_dump() for 32-bit platforms
Date:   Thu, 16 Jun 2022 16:43:36 -0700
Message-Id: <20220616234336.2443-1-yepeilin.cs@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peilin Ye <peilin.ye@bytedance.com>

As reported by Yuming, currently tc always show a latency of UINT_MAX
for netem Qdisc's on 32-bit platforms:

    $ tc qdisc add dev dummy0 root netem latency 100ms
    $ tc qdisc show dev dummy0
    qdisc netem 8001: root refcnt 2 limit 1000 delay 275s  275s
                                               ^^^^^^^^^^^^^^^^

Let us take a closer look at netem_dump():

        qopt.latency = min_t(psched_tdiff_t, PSCHED_NS2TICKS(q->latency,
                             UINT_MAX);

qopt.latency is __u32, psched_tdiff_t is signed long,
(psched_tdiff_t)(UINT_MAX) is negative for 32-bit platforms, so
qopt.latency is always UINT_MAX.

Fix it by using psched_time_t (u64) instead.

Note: confusingly, users have two ways to specify 'latency':

  1. normally, via '__u32 latency' in struct tc_netem_qopt;
  2. via the TCA_NETEM_LATENCY64 attribute, which is s64.

For the second case, theoretically 'latency' could be negative.  This
patch ignores that corner case, since it is broken (i.e. assigning a
negative s64 to __u32) anyways, and should be handled separately.

Thanks Ted Lin for the analysis [1] .

[1] https://github.com/raspberrypi/linux/issues/3512

Reported-by: Yuming Chen <chenyuming.junnan@bytedance.com>
Fixes: 112f9cb65643 ("netem: convert to qdisc_watchdog_schedule_ns")
Reviewed-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
---
 net/sched/sch_netem.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sched/sch_netem.c b/net/sched/sch_netem.c
index ed4ccef5d6a8..5449ed114e40 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -1146,9 +1146,9 @@ static int netem_dump(struct Qdisc *sch, struct sk_buff *skb)
 	struct tc_netem_rate rate;
 	struct tc_netem_slot slot;
 
-	qopt.latency = min_t(psched_tdiff_t, PSCHED_NS2TICKS(q->latency),
+	qopt.latency = min_t(psched_time_t, PSCHED_NS2TICKS(q->latency),
 			     UINT_MAX);
-	qopt.jitter = min_t(psched_tdiff_t, PSCHED_NS2TICKS(q->jitter),
+	qopt.jitter = min_t(psched_time_t, PSCHED_NS2TICKS(q->jitter),
 			    UINT_MAX);
 	qopt.limit = q->limit;
 	qopt.loss = q->loss;
-- 
2.20.1

