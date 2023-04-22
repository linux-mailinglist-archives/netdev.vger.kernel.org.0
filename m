Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 723706EBA10
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 17:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbjDVP4b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Apr 2023 11:56:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbjDVP4a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Apr 2023 11:56:30 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63D9B211C
        for <netdev@vger.kernel.org>; Sat, 22 Apr 2023 08:56:29 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id 46e09a7af769-6a5f6349ec3so1277414a34.0
        for <netdev@vger.kernel.org>; Sat, 22 Apr 2023 08:56:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1682178988; x=1684770988;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ayYzk57rDyqvIN2+5xjFydnjlJTouldiht70GPmNQTI=;
        b=X0pmgxlHW72W/p40LywXtbm0A4TXFeGBPv+Op1tDbd5xEzqR+YChz2pZnleszP9pYt
         DHLgizgE6kuKqWAdpFooLbFIPWEQhzhRRKL/wz05mwBumJoyUJgMWeDv6uAYQm49roET
         fVRuRcP86RsRrMbC70E7g3dNNmRd9IU+p+CoC+JdpEiN1NysjcHsyy5gvKU6R6TlsgVq
         5UvLatB5r2tU3k4zSDRE+OqlboP3KfLcueSA2S8XKvwvZPRj3Jw5PfwOHohXqiROu9YI
         4PcedvtwEI0jTZ47neum05nUwPGJUqA1Bbde5vFVu7AO8ZUlp2qLRbHTWhQq6K38LuoW
         CLmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682178988; x=1684770988;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ayYzk57rDyqvIN2+5xjFydnjlJTouldiht70GPmNQTI=;
        b=GhqpxXZGIsGEJDdIZu6HW2OTm/PX92Qc+OBJzoRxRKkJ5/+z/BaTTzsK5RJ0gi+D3K
         25yvlPDibfQLxLBKkE2uLTNmsDnkGbIobdufsDnvbBh64D1u2pEAIfSIDDDOta4Kcc5F
         vMBnYO4GtHMR/uLroTkO6cRHxvxEyl4dwpJhRXGqL6GBaBK5tu+98IkpsDQFNxjZLkFg
         1N5HuPninnoC4WBEc2WFOgqyICeyUxwPAEFkwZ5DGmj8Vx/WNqc6LuF7azeFO9Usy3bg
         +lK1ePGKMQfxN7DJw8rpaWVmMrPRNuRIXMHVja+ph0B32Yo+jF1mkANgTH6b5yy0IQWJ
         smkg==
X-Gm-Message-State: AAQBX9eeb6pfFUQWG5QF1+P72dliLpSPK6KTysQIHd2P8GJ56NIn6x6h
        Ot1DT/ntF6v7be2wkES6Wfb9USvsM1+AJVdcA7I=
X-Google-Smtp-Source: AKy350bY0SQ5wyVKELMrf8PWjE0O3L8diJ49yUANfaBYjib0CMb5bviR9tP1FMymChqqa70jm7UoPQ==
X-Received: by 2002:a9d:7315:0:b0:6a6:36ed:b5a7 with SMTP id e21-20020a9d7315000000b006a636edb5a7mr3302243otk.31.1682178988618;
        Sat, 22 Apr 2023 08:56:28 -0700 (PDT)
Received: from rogue-one.tail33bf8.ts.net ([2804:14d:5c5e:44fb:da55:60e0:8cc2:c48e])
        by smtp.gmail.com with ESMTPSA id v1-20020a05683018c100b006a32eb9e0dfsm2818255ote.67.2023.04.22.08.56.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Apr 2023 08:56:28 -0700 (PDT)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, simon.horman@corigine.com,
        Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next v5 2/4] net/sched: sch_qfq: use extack on errors messages
Date:   Sat, 22 Apr 2023 12:56:10 -0300
Message-Id: <20230422155612.432913-3-pctammela@mojatatu.com>
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

Some error messages are still being printed to dmesg.
Since extack is available, provide error messages there.

Reviewed-by: Simon Horman <simon.horman@corigine.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
---
 net/sched/sch_qfq.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/sched/sch_qfq.c b/net/sched/sch_qfq.c
index 02098a02943e..abcc48087831 100644
--- a/net/sched/sch_qfq.c
+++ b/net/sched/sch_qfq.c
@@ -402,8 +402,8 @@ static int qfq_change_class(struct Qdisc *sch, u32 classid, u32 parentid,
 	int err;
 	int delta_w;
 
-	if (tca[TCA_OPTIONS] == NULL) {
-		pr_notice("qfq: no options\n");
+	if (NL_REQ_ATTR_CHECK(extack, NULL, tca, TCA_OPTIONS)) {
+		NL_SET_ERR_MSG_MOD(extack, "missing options");
 		return -EINVAL;
 	}
 
@@ -442,8 +442,9 @@ static int qfq_change_class(struct Qdisc *sch, u32 classid, u32 parentid,
 	delta_w = weight - (cl ? cl->agg->class_weight : 0);
 
 	if (q->wsum + delta_w > QFQ_MAX_WSUM) {
-		pr_notice("qfq: total weight out of range (%d + %u)\n",
-			  delta_w, q->wsum);
+		NL_SET_ERR_MSG_FMT_MOD(extack,
+				       "total weight out of range (%d + %u)\n",
+				       delta_w, q->wsum);
 		return -EINVAL;
 	}
 
-- 
2.34.1

