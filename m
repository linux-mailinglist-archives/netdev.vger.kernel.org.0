Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13104679FA1
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 18:06:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233726AbjAXRGM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 12:06:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233973AbjAXRGD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 12:06:03 -0500
Received: from mail-oa1-x32.google.com (mail-oa1-x32.google.com [IPv6:2001:4860:4864:20::32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B256DBC9
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 09:05:24 -0800 (PST)
Received: by mail-oa1-x32.google.com with SMTP id 586e51a60fabf-15085b8a2f7so18397612fac.2
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 09:05:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7m7GrIwjqFN40QJvlmkCIYYmIgC5lw0bbO6H0pTDWT0=;
        b=p/F2aIHuzZj7hYJmAPvzMWx7WdfLBLNRB/PVRsrGyILqhBIxDsesEt+QAG5cbYMVEH
         9IEYlJDT/zDqgKW6vdEnpUT5mdjPYjfEqnXYEZt3vpvQnOIf0mOXTlROXqVmZDMbz+aa
         J6PLyJVDcb/6ZuYzBwsNLehndfDcjfIbR+BlaaB5ECNzsAEGj2gyxLgOSnp0gSXnzNuk
         O/YkZDGNC3BOnB6KOSl4UQs7O8Bt1h2G8QlMays8q1Gd9d5r4Qz2NpX0VADRSfyJ++ci
         p4RtU+p4pwtCDfe/t+dS3IpvXep8rGviEQE5YuVCl8jbAcSdimYtZSrMXVeiBXT+QYUO
         gg1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7m7GrIwjqFN40QJvlmkCIYYmIgC5lw0bbO6H0pTDWT0=;
        b=8NPxsfhY5KNknLZENQ0UFUePTQgMPjxcuEyOXZA7VZntyvJOeLHfRt2JN4Kzc3Z1jt
         mjyZxj7mcUkm5FMGNxxtwLHtI2K/qakyXbb5V2mc688rqxNWLWsIgtbwGUSworXS8rek
         Dvnaw2EKjNg5D0tnWx7pAiZmTgPybfOiWjslK/Zcovzg6tcB4ePYdy86kQLSkpyA1q5L
         zkFxL4qYawUBjpFsK60C7+/Sf8ZskzaFdOy96njjNN8hM8tO0OfQO3H7mekIopeya4X8
         YaNojOBIwVHq+M3HwcTXuuD2YSCjHtrsPrW4q3UMw8N8sTf5FKL5JMj4Tr5uJnBXF69n
         Z4JQ==
X-Gm-Message-State: AFqh2kp4dv9221YALrdLijHASKU5KL/s5hQprYZKA19wAdm36XEWxE3s
        9veEDWkgirukvz/DZeKBW+BQj/KtWC3aJ3SY
X-Google-Smtp-Source: AMrXdXua2pcGe6ADM0kwkGaBz5IYWCjVt7jtWmam78xq8VE7HE9x72nlJpKxFnhPZK1J/NxqSUIrug==
X-Received: by 2002:a05:6358:2245:b0:ed:2de1:6420 with SMTP id i5-20020a056358224500b000ed2de16420mr562292rwc.18.1674579920550;
        Tue, 24 Jan 2023 09:05:20 -0800 (PST)
Received: from localhost.localdomain (bras-base-kntaon1618w-grc-10-184-145-9-64.dsl.bell.ca. [184.145.9.64])
        by smtp.gmail.com with ESMTPSA id t5-20020a05620a0b0500b007063036cb03sm1700208qkg.126.2023.01.24.09.05.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 09:05:19 -0800 (PST)
From:   Jamal Hadi Salim <jhs@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     kernel@mojatatu.com, deb.chatterjee@intel.com,
        anjali.singhai@intel.com, namrata.limaye@intel.com,
        khalidm@nvidia.com, tom@sipanda.io, pratyush@sipanda.io,
        jiri@resnulli.us, xiyou.wangcong@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        vladbu@nvidia.com, simon.horman@corigine.com
Subject: [PATCH net-next RFC 08/20] net/sched: act_api: add struct p4tc_action_ops as a parameter to lookup callback
Date:   Tue, 24 Jan 2023 12:04:58 -0500
Message-Id: <20230124170510.316970-8-jhs@mojatatu.com>
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

For P4TC dynamic actions, we require information from struct tc_action_ops,
specifically the action kind, to find and locate the dynamic action
information for the lookup operation.

Signed-off-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
---
 include/net/act_api.h | 3 ++-
 net/sched/act_api.c   | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/net/act_api.h b/include/net/act_api.h
index 26d8d33f9..fd012270d 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -115,7 +115,8 @@ struct tc_action_ops {
 		       struct tcf_result *); /* called under RCU BH lock*/
 	int     (*dump)(struct sk_buff *, struct tc_action *, int, int);
 	void	(*cleanup)(struct tc_action *);
-	int     (*lookup)(struct net *net, struct tc_action **a, u32 index);
+	int     (*lookup)(struct net *net, const struct tc_action_ops *ops,
+			  struct tc_action **a, u32 index);
 	int     (*init)(struct net *net, struct nlattr *nla,
 			struct nlattr *est, struct tc_action **act,
 			struct tcf_proto *tp,
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 628447669..e33b0c248 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -696,7 +696,7 @@ int __tcf_idr_search(struct net *net, const struct tc_action_ops *ops,
 	struct tc_action_net *tn = net_generic(net, ops->net_id);
 
 	if (unlikely(ops->lookup))
-		return ops->lookup(net, a, index);
+		return ops->lookup(net, ops, a, index);
 
 	return tcf_idr_search(tn, a, index);
 }
-- 
2.34.1

