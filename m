Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 394386E99E8
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 18:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbjDTQuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 12:50:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229707AbjDTQuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 12:50:15 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 587E5421F
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 09:50:07 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id 46e09a7af769-6a5dd070aa1so456951a34.3
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 09:50:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1682009406; x=1684601406;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6oCjMzDCo666o0o05nA5ZEezvfE07tQGy7QyCkzH2Wo=;
        b=bhuF95tFnR5BSNbNOU0zibs//tjGPELumgfmxNTyHqKxvPGI3RCHaqGvOdXCJRxgWU
         izPz8HUJRrI8JaDkYg0IZl7yYGRkbR63iaSV1IQUuWke7xq//3vSQMwsyPXgPpFeliD5
         i9Kj2V1osRrq6tgLBMcMcGje2Z82z+OiU29+0n5VEVHmrYpp8RVcGfPhyXHyPzS5MWag
         GW3Ui5H00HzozUDsYIZ4J3R/E36nKN6teBxe+jRPvniLe0fTBCdXSm6Fql5ewigvxg2l
         3iuoWECEAv6XgJidTqwfKThAI9cLSVW5iNwK/IcTYQwVvFMoln3vN2b0htzs6Xqa6NnX
         ivLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682009406; x=1684601406;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6oCjMzDCo666o0o05nA5ZEezvfE07tQGy7QyCkzH2Wo=;
        b=aL1gJ0Ru0myjuNOqW8bK4htwU2xjLaOHva16I6XI1g75eBmwuDMgzEaCIXJvEhxM/c
         361b69tyU0nZxUwVU7KADoRrJk0MPIuZ//lcqXU+QB64EZsjl5V4AMwWHI1AWDpbJifR
         Z5WZ7D0EIw4lNFbSQ1PWuQCoxq3H+8Stt/C5P+QQSNjzF4q/C4jjQliKCwWiNi1qodAq
         L9fqh10NDGxM7xTzoYznAC6UaYGIZ1R74IRd0SPOmzW/3v4Q5dF0/FKYc3qsav9CN+f3
         ASjIt2lX+ouZ+feQpPJ5CSSzv21DfQZr6lWRWTah7vTPOBEXp6cPyJw7NBzV9koghvB4
         4vTg==
X-Gm-Message-State: AAQBX9fm/KC4t5TH6MYIzcS3yD4vDb7JUU7gzcQ9cg6zLtPPhBS2+U0d
        m/VvFEhMzL+x877up6xKTrCKqs0Kd9CialRMU2g=
X-Google-Smtp-Source: AKy350aNK2fXWVjT3fB6jMMYG82atp+zAIsHab3GI433oKZjmI1Z0moNzNQ9NXhps14DnWc/ESMM9g==
X-Received: by 2002:a9d:6c86:0:b0:6a5:d450:1c30 with SMTP id c6-20020a9d6c86000000b006a5d4501c30mr1167207otr.33.1682009406329;
        Thu, 20 Apr 2023 09:50:06 -0700 (PDT)
Received: from localhost.localdomain ([2804:14d:5c5e:44fb:7668:3bb3:e9e3:6d75])
        by smtp.gmail.com with ESMTPSA id p26-20020a9d695a000000b006a13dd5c8a2sm894542oto.5.2023.04.20.09.50.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 09:50:05 -0700 (PDT)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, simon.horman@corigine.com,
        Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next v3 3/5] net/sched: sch_qfq: refactor parsing of netlink parameters
Date:   Thu, 20 Apr 2023 13:49:26 -0300
Message-Id: <20230420164928.237235-4-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230420164928.237235-1-pctammela@mojatatu.com>
References: <20230420164928.237235-1-pctammela@mojatatu.com>
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
 net/sched/sch_qfq.c | 28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/net/sched/sch_qfq.c b/net/sched/sch_qfq.c
index 323609cfbc67..dfd9a99e6257 100644
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
@@ -408,26 +414,18 @@ static int qfq_change_class(struct Qdisc *sch, u32 classid, u32 parentid,
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
 
-	if (tb[TCA_QFQ_LMAX]) {
+	if (tb[TCA_QFQ_LMAX])
 		lmax = nla_get_u32(tb[TCA_QFQ_LMAX]);
-		if (lmax < QFQ_MIN_LMAX || lmax > (1UL << QFQ_MTU_SHIFT)) {
-			pr_notice("qfq: invalid max length %u\n", lmax);
-			return -EINVAL;
-		}
-	} else
+	else
 		lmax = psched_mtu(qdisc_dev(sch));
 
 	inv_w = ONE_FP / weight;
-- 
2.34.1

