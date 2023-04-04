Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 919066D6E22
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 22:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234428AbjDDUfH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 16:35:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231750AbjDDUfG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 16:35:06 -0400
Received: from mail-oa1-x35.google.com (mail-oa1-x35.google.com [IPv6:2001:4860:4864:20::35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 582DF19BC
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 13:35:05 -0700 (PDT)
Received: by mail-oa1-x35.google.com with SMTP id 586e51a60fabf-17ab3a48158so36094991fac.1
        for <netdev@vger.kernel.org>; Tue, 04 Apr 2023 13:35:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112; t=1680640504;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=HgUWR1khvkeRcv33JD+opg9F3r7WLIgYBsR/Eyb29wQ=;
        b=cq4SkRs2rbOV0Ova+vP+eCtQbHX1KUz2MSAYRpivU83TdfcyYZGEQ1sjvynaYH76TP
         Bf97XlfCKMklSONoYnh+MJ6bIKovlUO83qUArLjOE6i6JWJzRzyhV+a6/OWpEx2FHBxJ
         5soajNzL12gz1PIJaMMB1+Y26mdfuanKrfqKkOY8OPHIt9zVHKYR8xGirWeYk2VrEyUB
         P8Ul+MCtqZx+b4PSd0F8IV2C+Smf839par04SmtjPNpH+QLTfJsJiBvUJaL2GhYDOMsE
         uaTPl/AKM0KxxpXjmgNS5ME+UtJUszbR+6oM5Y4dLKQ23gNxQ9YSLq/SJQAqa0kXerCM
         Fp3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680640504;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HgUWR1khvkeRcv33JD+opg9F3r7WLIgYBsR/Eyb29wQ=;
        b=gEZCAeFaSn3Bi9VPZ+6zksqBFrGa2cvXVm3Acb6bJNcb8CqkrN0rHfMetlvdhlMqFE
         wNHgb43PY64+PJIvxTUp1iQ2o7xoQNk0mqCit7qLyvH8Ai+77bMwOjNjcLZnRr076uxQ
         J6hfp9bfku4AhTUiGQWAEgDL+nAHg9c3/ucXrlt5ESRMl3sl2AeaeO8dpngPPgrmkcm6
         Pc7D+9Tt6ej4liGnz7METf0aB2ISicPBrQ/KyItqBW1XWtsVsZ6YmPk5u79MsGi1kpG9
         Pfu3YYdtX/3f1U6EToARE+cyYQXyN9U+FxqVFvKW45uMRUg4cIO4l0oNP9skj+5UoOrm
         uzMQ==
X-Gm-Message-State: AAQBX9cHczaGSi0u8FBhGlV4XN9/KPMwbWqfn+0rYRIfGZt1NoBkVu5R
        RAaQWOs0KlsM5fvh/2mSyeP0n+YJ/hmTlJ08Dz0=
X-Google-Smtp-Source: AKy350Y3n9yc6fmVtpmjS45SW0oIglJA7MpHnoRfcMYQB8i1+/egEcPln798CX/9zT2lk3KJpVaCMg==
X-Received: by 2002:a05:6870:4287:b0:177:c2bd:3f70 with SMTP id y7-20020a056870428700b00177c2bd3f70mr2446893oah.54.1680640504460;
        Tue, 04 Apr 2023 13:35:04 -0700 (PDT)
Received: from localhost.localdomain ([2804:14d:5c5e:44fb:f205:bd2:e10c:668c])
        by smtp.gmail.com with ESMTPSA id ax40-20020a05687c022800b0017243edbe5bsm5066737oac.58.2023.04.04.13.35.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 13:35:04 -0700 (PDT)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next] net/sched: sch_mqprio: use netlink payload helpers
Date:   Tue,  4 Apr 2023 17:34:49 -0300
Message-Id: <20230404203449.1627033-1-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For the sake of readability, use the netlink payload helpers from
the 'nla_get_*()' family to parse the attributes.

tdc results:
1..5
ok 1 9903 - Add mqprio Qdisc to multi-queue device (8 queues)
ok 2 453a - Delete nonexistent mqprio Qdisc
ok 3 5292 - Delete mqprio Qdisc twice
ok 4 45a9 - Add mqprio Qdisc to single-queue device
ok 5 2ba9 - Show mqprio class

Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
---
 net/sched/sch_mqprio.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/sched/sch_mqprio.c b/net/sched/sch_mqprio.c
index 48ed87b91086..fdd6a6575a54 100644
--- a/net/sched/sch_mqprio.c
+++ b/net/sched/sch_mqprio.c
@@ -178,12 +178,12 @@ static int mqprio_parse_nlattr(struct Qdisc *sch, struct tc_mqprio_qopt *qopt,
 
 	if (tb[TCA_MQPRIO_MODE]) {
 		priv->flags |= TC_MQPRIO_F_MODE;
-		priv->mode = *(u16 *)nla_data(tb[TCA_MQPRIO_MODE]);
+		priv->mode = nla_get_u16(tb[TCA_MQPRIO_MODE]);
 	}
 
 	if (tb[TCA_MQPRIO_SHAPER]) {
 		priv->flags |= TC_MQPRIO_F_SHAPER;
-		priv->shaper = *(u16 *)nla_data(tb[TCA_MQPRIO_SHAPER]);
+		priv->shaper = nla_get_u16(tb[TCA_MQPRIO_SHAPER]);
 	}
 
 	if (tb[TCA_MQPRIO_MIN_RATE64]) {
@@ -196,7 +196,7 @@ static int mqprio_parse_nlattr(struct Qdisc *sch, struct tc_mqprio_qopt *qopt,
 				return -EINVAL;
 			if (i >= qopt->num_tc)
 				break;
-			priv->min_rate[i] = *(u64 *)nla_data(attr);
+			priv->min_rate[i] = nla_get_u64(attr);
 			i++;
 		}
 		priv->flags |= TC_MQPRIO_F_MIN_RATE;
@@ -212,7 +212,7 @@ static int mqprio_parse_nlattr(struct Qdisc *sch, struct tc_mqprio_qopt *qopt,
 				return -EINVAL;
 			if (i >= qopt->num_tc)
 				break;
-			priv->max_rate[i] = *(u64 *)nla_data(attr);
+			priv->max_rate[i] = nla_get_u64(attr);
 			i++;
 		}
 		priv->flags |= TC_MQPRIO_F_MAX_RATE;
-- 
2.34.1

