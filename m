Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1AB6679F9D
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 18:06:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233694AbjAXRGG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 12:06:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233638AbjAXRFq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 12:05:46 -0500
Received: from mail-yw1-x1132.google.com (mail-yw1-x1132.google.com [IPv6:2607:f8b0:4864:20::1132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18F00E079
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 09:05:22 -0800 (PST)
Received: by mail-yw1-x1132.google.com with SMTP id 00721157ae682-4fd37a1551cso202685037b3.13
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 09:05:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xZBqNthhbWiFR93NhjgSX75T0fHGYxAx79oLzTyQtOA=;
        b=uczZtvbBFDGlhYEUouRh4ZrCrMfOiG6ZwbylIgdsTVr4R3152KedMlBRIVdOb7ZGli
         qq0E3WBPpD3mHa/HxVmHqSgbR383267x+r1r/zGeTpj9fzbsAQ60xq+Up/mOcLduV4cd
         JTwCHlSvsXy9l2VOrFxPhC1zzqW4vTLLiuTG5l9rncUFIBCd5Y3NTaHbjenDlUQYTo+G
         zBV+7TppoJABZ8YWXKb0vmnoNhBeJ/Q2eBoYgSiplL8oGVvBpfhRSLg6FYLgjDrxbbzE
         TqoE3Gxq/8cohBnt3bxDm0NYvJDC4KbCidib4obNeQM0LT2XfLKKzY04Fl9Bu+OApCYy
         /3+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xZBqNthhbWiFR93NhjgSX75T0fHGYxAx79oLzTyQtOA=;
        b=ds/pLnr76N8YZUnoaJgQWGnmfUsx7iDLr2pmS6d1rez73iq5P4AjTtsl/2RRLtU5AW
         h+8Mo3mZamT5eYjH+NNUnzzV/Wb8XdrBAHKdjs+y3dz9DcsrbmeY3wwYzQm/7L19gxBJ
         aNzvh21CUPoesxLOAsHnyQAApo3py2msLf7rwlk7agzc+sKtACWeRMenr8dy0gS/jMO1
         rUkK8VCFAxuRRPCI/CzRSZ7GArJisxoGdnm5Tlbtwgl89gDtI6rbqgWGUev4RcAFGaA3
         6ZpYyZosR8lTn6ZyipZklouo57YceZZaFwdyJS9o25um3RqeSLOrGdkhbbxDDHbIgGIQ
         bTnA==
X-Gm-Message-State: AFqh2krTw+zdT29KHAWqZC5beV5tmHVLdnkJllKKFQJEqUpWMhOW5UNJ
        +QNWSYVA5UGKzb/qYKZzu0XPjZmXDLgWTTbA
X-Google-Smtp-Source: AMrXdXtJQLaBeajuh8RhK77ct7aQg5kb/fEdjG9/AjRDKvMN358f4o12iM0+gDm+Ep6lTlIR6XJSog==
X-Received: by 2002:a05:7500:658c:b0:f2:5513:671a with SMTP id iq12-20020a057500658c00b000f25513671amr1076126gab.77.1674579917599;
        Tue, 24 Jan 2023 09:05:17 -0800 (PST)
Received: from localhost.localdomain (bras-base-kntaon1618w-grc-10-184-145-9-64.dsl.bell.ca. [184.145.9.64])
        by smtp.gmail.com with ESMTPSA id t5-20020a05620a0b0500b007063036cb03sm1700208qkg.126.2023.01.24.09.05.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 09:05:17 -0800 (PST)
From:   Jamal Hadi Salim <jhs@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     kernel@mojatatu.com, deb.chatterjee@intel.com,
        anjali.singhai@intel.com, namrata.limaye@intel.com,
        khalidm@nvidia.com, tom@sipanda.io, pratyush@sipanda.io,
        jiri@resnulli.us, xiyou.wangcong@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        vladbu@nvidia.com, simon.horman@corigine.com
Subject: [PATCH net-next RFC 06/20] net/sched: act_api: export generic tc action searcher
Date:   Tue, 24 Jan 2023 12:04:56 -0500
Message-Id: <20230124170510.316970-6-jhs@mojatatu.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230124170510.316970-1-jhs@mojatatu.com>
References: <20230124170510.316970-1-jhs@mojatatu.com>
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

In P4TC we need to query the tc actions directly in a net namespace.
Therefore export __tcf_idr_search().

Signed-off-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
---
 include/net/act_api.h | 2 ++
 net/sched/act_api.c   | 6 +++---
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/include/net/act_api.h b/include/net/act_api.h
index 083557e51..7328183b4 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -190,6 +190,8 @@ int tcf_generic_walker(struct tc_action_net *tn, struct sk_buff *skb,
 		       const struct tc_action_ops *ops,
 		       struct netlink_ext_ack *extack);
 int tcf_idr_search(struct tc_action_net *tn, struct tc_action **a, u32 index);
+int __tcf_idr_search(struct net *net, const struct tc_action_ops *ops,
+		     struct tc_action **a, u32 index);
 int tcf_idr_create(struct tc_action_net *tn, u32 index, struct nlattr *est,
 		   struct tc_action **a, const struct tc_action_ops *ops,
 		   int bind, bool cpustats, u32 flags);
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index c5dca2085..c730078bb 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -690,9 +690,8 @@ static int __tcf_generic_walker(struct net *net, struct sk_buff *skb,
 	return tcf_generic_walker(tn, skb, cb, type, ops, extack);
 }
 
-static int __tcf_idr_search(struct net *net,
-			    const struct tc_action_ops *ops,
-			    struct tc_action **a, u32 index)
+int __tcf_idr_search(struct net *net, const struct tc_action_ops *ops,
+		     struct tc_action **a, u32 index)
 {
 	struct tc_action_net *tn = net_generic(net, ops->net_id);
 
@@ -701,6 +700,7 @@ static int __tcf_idr_search(struct net *net,
 
 	return tcf_idr_search(tn, a, index);
 }
+EXPORT_SYMBOL(__tcf_idr_search);
 
 static int tcf_idr_delete_index(struct tcf_idrinfo *idrinfo, u32 index)
 {
-- 
2.34.1

