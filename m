Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A40D6EB13E
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 19:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233379AbjDURyP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 13:54:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233439AbjDURyO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 13:54:14 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35AA51738
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 10:54:13 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id 46e09a7af769-6a5ec0d8d8aso1692383a34.2
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 10:54:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1682099652; x=1684691652;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XWV7EHFDukvZMAhe+Tm4Xz36bsKeCMT2Vv3MRpmyjsE=;
        b=JEUYJRsmwBtJN3rd+wqOpq6nrfSNPemLJS8HKBDwRODiIir8AD0SeHfPiVaA0y6MOt
         mgfTfNdk16W5E+miL5/f8zUszNgVoZNrLvSY7yndg1MpFodfRrr5Ct1Qk7ooQR2XZdBH
         L4pl7UPnJ0V0egVhHQWfemjB+hK2dSTlYYq9QxGkR9gnuYFkNeVUEpU7P31sCEJQvPrK
         cC1cQWl2UvNujp/fTCuVILUp3jWW1SSKpVJwS7i3fn+/6Y3EkEgaNIUjNuP8VVj2rB+r
         lP3A0fbsW27H3T0dLHnPfb9bMTzlTnMs+ZvpuZd2R57d9QvvntTyiWIGieL0RnSZHtnf
         iOJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682099652; x=1684691652;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XWV7EHFDukvZMAhe+Tm4Xz36bsKeCMT2Vv3MRpmyjsE=;
        b=gcwfeI/Pse8zWDCP9TUE+jYJPz7/2kzr7FJGw3VwNbIT+P3Y9izRKdr2RKK6EdYdxd
         RrGHBvceOL6gZmfyhM/b4dVnkdllHbspBTM6rSMxmTOrwCf6CIIPZTIH7Y/DmfXUXkFB
         2c31227Pf4JxaZTOkzsI0SDc6RkPYoEMOnzLOJ9Cexf7GXLTH39MFoGTFozJPC/D7IE1
         KPkOzW/6st5QhXNIuba2y4MEkpRkV+dSvmoXXTfiWWu/0pY28PZT1/8DKFuo8553qxBu
         JM3wAcmn05rC+rW445POC2/A56DiXTLRxmRPV64F7pyqpjXUxaBZS/qSArcdAAbtzbVM
         4rJg==
X-Gm-Message-State: AAQBX9eGMRtoQ2oiDz5impOENAtot4B6MmGI37taWcmldNCKZILXCwHb
        drTOgTjIxf2rVLfb+G3vQIhRqN4MWKcapFqMjyU=
X-Google-Smtp-Source: AKy350a+jgXwf1vufNAilkmKy/5EEBPsWeeM76Qui/QMOo4BYgxM1MKkGt9pP3UrPP2zzcQwnF4Zqg==
X-Received: by 2002:a9d:5f04:0:b0:6a5:f3ee:f7ba with SMTP id f4-20020a9d5f04000000b006a5f3eef7bamr2815242oti.38.1682099652444;
        Fri, 21 Apr 2023 10:54:12 -0700 (PDT)
Received: from localhost.localdomain ([2804:14d:5c5e:44fb:7380:c348:a30c:7e82])
        by smtp.gmail.com with ESMTPSA id e3-20020a9d5603000000b006a633d75310sm850426oti.16.2023.04.21.10.54.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Apr 2023 10:54:12 -0700 (PDT)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, simon.horman@corigine.com,
        Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next v4 2/4] net/sched: sch_qfq: use extack on errors messages
Date:   Fri, 21 Apr 2023 14:53:42 -0300
Message-Id: <20230421175344.299496-3-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230421175344.299496-1-pctammela@mojatatu.com>
References: <20230421175344.299496-1-pctammela@mojatatu.com>
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
index cf5ebe43b3b4..323609cfbc67 100644
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
 
@@ -441,8 +441,9 @@ static int qfq_change_class(struct Qdisc *sch, u32 classid, u32 parentid,
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

