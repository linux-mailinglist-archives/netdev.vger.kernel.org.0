Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2036E6C3DC0
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 23:34:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbjCUWeP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 18:34:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229833AbjCUWeJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 18:34:09 -0400
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 596C250988
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 15:34:08 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id w21-20020a9d6755000000b00698853a52c7so9399992otm.11
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 15:34:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112; t=1679438047;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=daKIoMGQiTu1lkiBzud3AXM1pyQLz2K4Ke5pXNqQ9pY=;
        b=Hg8dyqCFKsZdf7A4ixqTtHj0QZ/WrYu6YrizsgRRu1bC1w1CfaBIjwJMZ+Atq4dM6N
         qX12w3jrstpz2FlFoHKayUcjPgrzj86DaUQ9mOmqMNGKjAztpE4CJpXC6BQNwhyBWn7j
         /B8gTK1frDc3eu/yMwdQg8lnS3AGUWHKWYrsafgqSaWFPkgpTRHNIlGf32ENk/DArM5u
         g8MXeyYvQ36EJsXQCkar8BeL8fa6qPzA3S4e21DMoLQLvm5er/fb0LNRiFi6A0vGjc9C
         uxv3NkmbgZdHfBFbHUGlK4ec9T967ToNJ9NCNJdmIhA5l8y3HhZrvUCThEipbdq0+QOq
         SShQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679438047;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=daKIoMGQiTu1lkiBzud3AXM1pyQLz2K4Ke5pXNqQ9pY=;
        b=ZSxJ/spP8PihviM0ogKircjCtGLY9LxQI5PL7snorPrkX7jsN9lCol7Uk9o31NpFDK
         daOu16b2C1zPdcJE4nrmjJqWuarqG/l0HmczrKddx9pusRNzQSSGtUg6gzIwg7ZwrfOF
         dmPqEYXTD7XE/mTyfVt505SXqsXJ9Rwm+uU7MuIINUtPpi5K+enRUyOFjz/kjm9F83fo
         qA4II2E5kXgW+ezqKz8sZmOxHetfxgcF8fcsNFRmExcEqbLWeNPczE6bECq7xXYLzojA
         DTY5aqVvLEAHbkKQbeBIOEHIaMcC1TAmBm7LaVLo+bPp2Raq9cZkUUCPgJ5gOI2en3me
         V2Dw==
X-Gm-Message-State: AO0yUKXvnS52kooh5QE3bNAvjkzVpoyqFqldhVlUUf7M9qBpJdVZ9Hoa
        uJfzIdRDzhDYEDJWdZqF/VwjOr9gpMzKPbzpR0A=
X-Google-Smtp-Source: AK7set9EsRlDbm1HQRGKFVBqVBpcZS9Eio7ZkX0DXwomdlgOzNx4BluMZBbpK9aZiTxaTtqwSPiqmA==
X-Received: by 2002:a9d:7d96:0:b0:684:dbfd:f239 with SMTP id j22-20020a9d7d96000000b00684dbfdf239mr88025otn.9.1679438047548;
        Tue, 21 Mar 2023 15:34:07 -0700 (PDT)
Received: from localhost.localdomain ([2804:14d:5c5e:4698:6f50:e368:921d:64b8])
        by smtp.gmail.com with ESMTPSA id e21-20020a05683013d500b0069f74706056sm1614936otq.9.2023.03.21.15.34.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 15:34:07 -0700 (PDT)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, simon.horman@corigine.com,
        Pedro Tammela <pctammela@mojatatu.com>,
        Hangbin Liu <haliu@redhat.com>
Subject: [PATCH net-next v3] net/sched: act_api: use the correct TCA_ACT attributes in dump
Date:   Tue, 21 Mar 2023 19:33:45 -0300
Message-Id: <20230321223345.1369859-1-pctammela@mojatatu.com>
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

4 places in the act api code are using 'TCA_' definitions where they
should be using 'TCA_ACT_', which is confusing for the reader, although
functionally they are equivalent.

Cc: Hangbin Liu <haliu@redhat.com>
Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
---
 net/sched/act_api.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 296fc1afedd8..f7887f42d542 100644
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
@@ -598,7 +598,7 @@ static int tcf_del_walker(struct tcf_idrinfo *idrinfo, struct sk_buff *skb,
 	nest = nla_nest_start_noflag(skb, 0);
 	if (nest == NULL)
 		goto nla_put_failure;
-	if (nla_put_string(skb, TCA_KIND, ops->kind))
+	if (nla_put_string(skb, TCA_ACT_KIND, ops->kind))
 		goto nla_put_failure;
 
 	ret = 0;
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

