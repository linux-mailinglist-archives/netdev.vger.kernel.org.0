Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FC5E6EBA12
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 17:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbjDVP4g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Apr 2023 11:56:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229721AbjDVP4d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Apr 2023 11:56:33 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B0F0213D
        for <netdev@vger.kernel.org>; Sat, 22 Apr 2023 08:56:32 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id 46e09a7af769-6a5f8e1f6d1so1146951a34.0
        for <netdev@vger.kernel.org>; Sat, 22 Apr 2023 08:56:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1682178992; x=1684770992;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9LmUoQ5b2vuw6KXLsLWGxWWma0zZZthDoge7urEQfZ8=;
        b=Fv6eKMf0hU9PDXH9209S4o6Rzi0W0m+OPoTPUBRdNaLSgmI6dbRWq3O/kXlYtm+NXX
         PsRGGuTIfGwxOFssTy+aV0gdT5QR4k+k1XSGBZjwsg1OMcko8W9MeP6phJ+UAuJQg8U4
         Siwv1DV2oauz95Shhk3MQvas114se32snMbXj5+D/RnA0yk3pemiC7LLHeHetOywsiaz
         B4HSlroPPysbAW9reSvsG6pNoyMQZEBFVLpO7b+h8XSb6UNdUq0Hwzfx/VnFlUj+dhXg
         M9br7kWOnH3SyNd5aGu1se1sabMNnGUN7y2QfdyL+k9V8ic1iD5O4Bize1i6FufxZm3y
         AnwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682178992; x=1684770992;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9LmUoQ5b2vuw6KXLsLWGxWWma0zZZthDoge7urEQfZ8=;
        b=JSl6K14/QQ5LKCBzZ40oK3dbes+K7n8PNmbs2Yk2wiFcQRj+SR1YpX92yh6aBdlxEs
         +BkHQublKPQF7rSdAy/fkwFcBg+x9KlWKegGzgYNAqHhDEhAYcIS4s2lalLykmqewdkX
         MN2oo3822Pl+lwOp3dy3gchCk2AZlWsDL3Nk/9VsRFWer5eTKpA9LiNQ0heESKLIqMqQ
         6wV2sCb0Xr8VZhhfBzo65MbqcFF+zNZRa4pg5lhmjvzBxacvNSaY5tLVLegZHkCK1B5r
         A80MSKnwVrqWDD13R0aSBBMY0eK3mAnxOaioLw10r8Xa7+WAN2GRpR4p3tlDh9gz+C+2
         Z16g==
X-Gm-Message-State: AAQBX9fbhJ+ybrcgSEldeXGSNOjl62AHaTKggh9O6+E6PmS/+SOjuCJW
        8omhfNEz8gbM36u6cuoQ2KDWz4toR8cZwxCzL0I=
X-Google-Smtp-Source: AKy350asMUkvE4OlWTOVQQpo8wWo52Ur/ioht0lHVYv0bzAZcmyXoqobaysIdz2smkED3PH/SkQamA==
X-Received: by 2002:a05:6830:184:b0:6a6:46e9:787e with SMTP id q4-20020a056830018400b006a646e9787emr1350089ota.6.1682178991820;
        Sat, 22 Apr 2023 08:56:31 -0700 (PDT)
Received: from rogue-one.tail33bf8.ts.net ([2804:14d:5c5e:44fb:da55:60e0:8cc2:c48e])
        by smtp.gmail.com with ESMTPSA id v1-20020a05683018c100b006a32eb9e0dfsm2818255ote.67.2023.04.22.08.56.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Apr 2023 08:56:31 -0700 (PDT)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, simon.horman@corigine.com,
        Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next v5 3/4] net/sched: sch_qfq: refactor parsing of netlink parameters
Date:   Sat, 22 Apr 2023 12:56:11 -0300
Message-Id: <20230422155612.432913-4-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230422155612.432913-1-pctammela@mojatatu.com>
References: <20230422155612.432913-1-pctammela@mojatatu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Two parameters can be transformed into netlink policies and
validated while parsing the netlink message.

Reviewed-by: Simon Horman <simon.horman@corigine.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
---
 net/sched/sch_qfq.c | 25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/net/sched/sch_qfq.c b/net/sched/sch_qfq.c
index abcc48087831..dfd9a99e6257 100644
--- a/net/sched/sch_qfq.c
+++ b/net/sched/sch_qfq.c
@@ -113,6 +113,7 @@
 
 #define QFQ_MTU_SHIFT		16	/* to support TSO/GSO */
 #define QFQ_MIN_LMAX		512	/* see qfq_slot_insert */
+#define QFQ_MAX_LMAX		(1UL << QFQ_MTU_SHIFT)
 
 #define QFQ_MAX_AGG_CLASSES	8 /* max num classes per aggregate allowed */
 
@@ -214,9 +215,14 @@ static struct qfq_class *qfq_find_class(struct Qdisc *sch, u32 classid)
 	return container_of(clc, struct qfq_class, common);
 }
 
+static struct netlink_range_validation lmax_range = {
+	.min = QFQ_MIN_LMAX,
+	.max = QFQ_MAX_LMAX,
+};
+
 static const struct nla_policy qfq_policy[TCA_QFQ_MAX + 1] = {
-	[TCA_QFQ_WEIGHT] = { .type = NLA_U32 },
-	[TCA_QFQ_LMAX] = { .type = NLA_U32 },
+	[TCA_QFQ_WEIGHT] = NLA_POLICY_RANGE(NLA_U32, 1, QFQ_MAX_WEIGHT),
+	[TCA_QFQ_LMAX] = NLA_POLICY_FULL_RANGE(NLA_U32, &lmax_range),
 };
 
 /*
@@ -408,17 +414,13 @@ static int qfq_change_class(struct Qdisc *sch, u32 classid, u32 parentid,
 	}
 
 	err = nla_parse_nested_deprecated(tb, TCA_QFQ_MAX, tca[TCA_OPTIONS],
-					  qfq_policy, NULL);
+					  qfq_policy, extack);
 	if (err < 0)
 		return err;
 
-	if (tb[TCA_QFQ_WEIGHT]) {
+	if (tb[TCA_QFQ_WEIGHT])
 		weight = nla_get_u32(tb[TCA_QFQ_WEIGHT]);
-		if (!weight || weight > (1UL << QFQ_MAX_WSHIFT)) {
-			pr_notice("qfq: invalid weight %u\n", weight);
-			return -EINVAL;
-		}
-	} else
+	else
 		weight = 1;
 
 	if (tb[TCA_QFQ_LMAX])
@@ -426,11 +428,6 @@ static int qfq_change_class(struct Qdisc *sch, u32 classid, u32 parentid,
 	else
 		lmax = psched_mtu(qdisc_dev(sch));
 
-	if (lmax < QFQ_MIN_LMAX || lmax > (1UL << QFQ_MTU_SHIFT)) {
-		pr_notice("qfq: invalid max length %u\n", lmax);
-		return -EINVAL;
-	}
-
 	inv_w = ONE_FP / weight;
 	weight = ONE_FP / inv_w;
 
-- 
2.34.1

