Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 797F46B9FD3
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 20:34:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbjCNTeG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 15:34:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbjCNTeF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 15:34:05 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D00B812BEC
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 12:34:01 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id f17-20020a9d7b51000000b00697349ab7e7so1575851oto.9
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 12:34:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112; t=1678822441;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=WOe7m4NU05+Z2u9NDEwoMmG7iBcZvQG5YsZ5QcZFJKw=;
        b=wrFtihnklo2YA7omKLVq3xWfQDQGUuqlojH+uFkKshiBDl9W0XTO2pcis+JLBiYps+
         7aw7UWFM5bIQ59dj2XBsvHKpdkGVXEqHDsYyrLkMid5dEnE8MddFWfewVb/OkyRBr6h0
         7rEA8GNRvkZv6O3j8R42o+vl5wjYs2Ns7LUT+WpqPhzbIRKtPTNBqbaJCk+ArQ6g1h1H
         jfb9uZmFumjSY4X7SBgFABOgXBp1H+1YNxzyonxmsbshlSeBUUxlDOuq1+fDsUqEo85u
         q7dEKhQ6mKGtAXWODu1vlPe2VPO+2GWQ/+R60V4SVU+pn3rYp2aHJ5aqJfkVil6uwJMs
         29Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678822441;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WOe7m4NU05+Z2u9NDEwoMmG7iBcZvQG5YsZ5QcZFJKw=;
        b=Q80I79TXwCCqN7yWmnbyJn/gyxFExP+45B/gX8n42iIa/ACsJfECF9yedXzoIxJ/vM
         6HGtwcPjcIs0m2f6dJ6P1LYWH1ZE09WcGzBjJgeCxPdKrQsIbyOCiTkgmUsmmPDB2HkY
         IvmMYd4L4YSdhSZYwo3Fnq6C49BtxXzIsLLwIMGc/icJ0TnCMBAUZmPl5GqtSyxaW8VQ
         EOEI0BziJTxhEpzjwxxcfK+ZenxJzSEq47VDOVgIZbu2k/3yGD+5NSNsWvBT4zIPrvHX
         9aHDeGRN+uB2L3pXQNpQOxQba74Y1C3zyfIgH3VYzZ+tyl5RUd3CAV3XlZSXLSPDNzXr
         RtNw==
X-Gm-Message-State: AO0yUKXfyPnYel7L47ygjThCgy5iuuSqzBO1kvO/zqp6orExEbjntqDo
        U+G93YJZvzS/KR1SwSFPeniGP8AdFownZCxTIHk=
X-Google-Smtp-Source: AK7set8H5Guy54AocLvDj7yS8tKFyNNeyd5LqSJ2W7/oVIhO31lG2A2aHHmbHHQZ/Yx4dR6XF9m5iw==
X-Received: by 2002:a9d:729c:0:b0:693:cf97:c103 with SMTP id t28-20020a9d729c000000b00693cf97c103mr18041174otj.37.1678822440952;
        Tue, 14 Mar 2023 12:34:00 -0700 (PDT)
Received: from localhost.localdomain ([2804:14d:5c5e:4698:95f9:b8d9:4b9:5297])
        by smtp.gmail.com with ESMTPSA id l10-20020a4a434a000000b00525240c6149sm1399231ooj.31.2023.03.14.12.33.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 12:34:00 -0700 (PDT)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, Pedro Tammela <pctammela@mojatatu.com>,
        Hangbin Liu <haliu@redhat.com>
Subject: [PATCH net-next] net/sched: act_api: use the correct TCA_ACT attributes in dump
Date:   Tue, 14 Mar 2023 16:33:21 -0300
Message-Id: <20230314193321.554475-1-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

3 places in the act api code are using 'TCA_' definitions where they should be using
'TCA_ACT_', which is confusing for the reader, although functionaly wise they are equivalent.

Cc: Hangbin Liu <haliu@redhat.com>
Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
---
 net/sched/act_api.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 34c508675041..612b40bf6b0f 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -453,7 +453,7 @@ static size_t tcf_action_shared_attrs_size(const struct tc_action *act)
 		+ nla_total_size_64bit(sizeof(u64))
 		/* TCA_STATS_QUEUE */
 		+ nla_total_size_64bit(sizeof(struct gnet_stats_queue))
-		+ nla_total_size(0) /* TCA_OPTIONS nested */
+		+ nla_total_size(0) /* TCA_ACT_OPTIONS nested */
 		+ nla_total_size(sizeof(struct tcf_t)); /* TCA_GACT_TM */
 }
 
@@ -480,7 +480,7 @@ tcf_action_dump_terse(struct sk_buff *skb, struct tc_action *a, bool from_act)
 	unsigned char *b = skb_tail_pointer(skb);
 	struct tc_cookie *cookie;
 
-	if (nla_put_string(skb, TCA_KIND, a->ops->kind))
+	if (nla_put_string(skb, TCA_ACT_KIND, a->ops->kind))
 		goto nla_put_failure;
 	if (tcf_action_copy_stats(skb, a, 0))
 		goto nla_put_failure;
@@ -1189,7 +1189,7 @@ tcf_action_dump_1(struct sk_buff *skb, struct tc_action *a, int bind, int ref)
 	if (nla_put_u32(skb, TCA_ACT_IN_HW_COUNT, a->in_hw_count))
 		goto nla_put_failure;
 
-	nest = nla_nest_start_noflag(skb, TCA_OPTIONS);
+	nest = nla_nest_start_noflag(skb, TCA_ACT_OPTIONS);
 	if (nest == NULL)
 		goto nla_put_failure;
 	err = tcf_action_dump_old(skb, a, bind, ref);
-- 
2.34.1

