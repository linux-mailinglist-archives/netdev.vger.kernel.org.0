Return-Path: <netdev+bounces-8443-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 33C2B724138
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 13:42:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5BED5281561
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 11:42:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DFF315AFB;
	Tue,  6 Jun 2023 11:42:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 741F215ACE
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 11:42:45 +0000 (UTC)
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E810310D5
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 04:42:35 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-bb397723627so1036440276.1
        for <netdev@vger.kernel.org>; Tue, 06 Jun 2023 04:42:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686051755; x=1688643755;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=uIatdOpJsDSo1SfdpzGEqsy6C4wmRjOxQNmYeUR8mwE=;
        b=Z/TuiCbwqYKXbqQGZtBPxCc7BIfVs+qk4Is1zJWK7ZWzqMd3qyaHvkcjOsFiOMGMwp
         gfDxHIcdC6e7QGT1w3zmIzJ1Ppo5RLu45Vit4zFsL8+dPUHPKp2KpOQ1UKssmpJUkYCo
         2iplsXuhuYWXap07umiIf735xP1kVZwqNooB5DMToF5O+RBer9EUx/zL5RqSmeQ+xAM1
         lIS9tGlEInieiXyN+p598Cln71LOcG+/ucAHtxGARs0hzPXX4yrM6Zzncc/da7Z+qEJf
         b/zMZwmefnovgNVb502v/YNgm0XMmyw2gYJWlVRthEajyUczNh3Yq7Tl6UfPss4iYLBB
         PYTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686051755; x=1688643755;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uIatdOpJsDSo1SfdpzGEqsy6C4wmRjOxQNmYeUR8mwE=;
        b=UT5d7hagVqlQDZ/Phtj2OCO2v9UKkjCr7O49ltLEGvGtmt2tDSIWCMFMd/YEMKHFsH
         iLkNlGP57Mm5VM0kUaoj0hRhEgoxsJI7Ct0iOS/OPn1FnVXetOgHR0csAP33OUpRAOCQ
         AltGZ/YiNZ7pWzmRnLWtsv1oejoZD0YlU3MFo9g661y/gqj7FXKMRSPGy58zDuMXx65r
         fGkKq1aDNntA1RJjkB5gYJsDrMdhFAWFDoz/NsVw8iyM8NIRQqIBZpFpUGnW8q7UFpJX
         DBOBxeyBf+iZzoqBm2IWlWH0MtZ2FQw7121teWIaPYKywDfgBO8ca/C+PDbDYCUB0Z4y
         pIlg==
X-Gm-Message-State: AC+VfDxRMg4NZ5gherqTG/jbs1qQz95Ey5n59yhhQjm5CCSz9vWDrQJ+
	vOS9zXES8Birih019CGC+Hmlam9iHSSPqA==
X-Google-Smtp-Source: ACHHUZ5FRSrPi2utc6I2y7lQZBRdW0RQuzFJIjaKIQSItUENSNvcZI8oLeJLY+QZf5O0e0RlYi6SdOXH0dXp9w==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a25:8d86:0:b0:ba8:b828:c8ff with SMTP id
 o6-20020a258d86000000b00ba8b828c8ffmr583414ybl.10.1686051755230; Tue, 06 Jun
 2023 04:42:35 -0700 (PDT)
Date: Tue,  6 Jun 2023 11:42:33 +0000
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230606114233.4160703-1-edumazet@google.com>
Subject: [PATCH net] net: sched: move rtm_tca_policy declaration to include file
From: Eric Dumazet <edumazet@google.com>
To: "David S . Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>, Cong Wang <xiyou.wangcong@gmail.com>, 
	Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org, eric.dumazet@gmail.com, 
	Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

rtm_tca_policy is used from net/sched/sch_api.c and net/sched/cls_api.c,
thus should be declared in an include file.

This fixes the following sparse warning:
net/sched/sch_api.c:1434:25: warning: symbol 'rtm_tca_policy' was not declared. Should it be static?

Fixes: e331473fee3d ("net/sched: cls_api: add missing validation of netlink attributes")
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/pkt_sched.h | 2 ++
 net/sched/cls_api.c     | 2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
index f436688b6efc8f20ee5ede6ee94404e22bbebf3f..5722931d83d431d8cc625d44ba2bc22d88301d5b 100644
--- a/include/net/pkt_sched.h
+++ b/include/net/pkt_sched.h
@@ -127,6 +127,8 @@ static inline void qdisc_run(struct Qdisc *q)
 	}
 }
 
+extern const struct nla_policy rtm_tca_policy[TCA_MAX + 1];
+
 /* Calculate maximal size of packet seen by hard_start_xmit
    routine of this device.
  */
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 2621550bfddc1e466b6a03b0ce6eb5de25ab7476..b2432ee04f3193f6bbcb7986fd950d470fd28e55 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -43,8 +43,6 @@
 #include <net/flow_offload.h>
 #include <net/tc_wrapper.h>
 
-extern const struct nla_policy rtm_tca_policy[TCA_MAX + 1];
-
 /* The list of all installed classifier types */
 static LIST_HEAD(tcf_proto_base);
 
-- 
2.41.0.rc0.172.g3f132b7071-goog


