Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25C176EB13B
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 19:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233455AbjDURyR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 13:54:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233241AbjDURyL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 13:54:11 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 487111736
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 10:54:10 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id 46e09a7af769-6a606135408so2125064a34.0
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 10:54:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1682099649; x=1684691649;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tgTuNzspbyApr+G6Zp0R1bfTdKEOJFb43e3NBF/vvss=;
        b=Jt8ImvbAP7idaoHevr2O8eHLGhhqU3XSMSSmG0lZotMeQ3n0+aZA67Gdn7owlBZddN
         qH0HKn2TIVmo8TI4/+IKyDn7NAdkDIjdEtIdMzRMX4Lscpkc4hzy7TQTJFFFpJnfOb/g
         HZCmysfI3Xlj4BgIKKaBiq0adEPvoeK+rkmt1B/KsiE+zb75r5eMsNSTYpI9wo8+WhaU
         aejSogGlgR/0WqVLEYrwDM+LZKgws2m/wTF0uWP7uo/9XDNxZcN8jNTtkF7/P7o3VbPe
         cknshYFfQKLxxTRhDe3f0/qNhBgzEfT1HBI9SyeExFPWGdTgfvr7Ja8qAhuEvNOc12RO
         SzBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682099649; x=1684691649;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tgTuNzspbyApr+G6Zp0R1bfTdKEOJFb43e3NBF/vvss=;
        b=EkNxFRIfrGvt3eOXntzUBLDtnfxzjvGe6Zu02y2UQbzAv77UMTyMmofenICj4jKsBE
         f2aP67FYwbpcSuoQzqzExAv61AYPV/oVoZ0BNYjTOM2j9Ug5wllYduZL3bH3Tw/9+CBJ
         5JESxWOwbA0vkU5ydCx3xUD/Lp3xYS/UAC6T60t04ucrwZC3jsVM/ChiFN6VJQlGxWrJ
         oFpQ4UMh4oYAJdW5gQRAIQdkd6EeE3Ik51Yq8Tf8+fXUJFlxlTU/riKvUsOy2rLq72Sq
         0ZbgDHLC4Nck6FWS02iDZeDg2fAS8dz3sXEngZuLcZOUSvM1N0YlHNAxkvORGee/Ibm5
         bpcg==
X-Gm-Message-State: AAQBX9c2cM8+MwnIBSZjLig1TOuYsjcYr1mm/TxC1/b9kpap4G5V1gNH
        MoVywEgRa5FI9KCqZ+5np7W4ibEoIZHJjAlTf6k=
X-Google-Smtp-Source: AKy350bPc4fx0iCckesT6yIY7yga0wD7eeAUWx6y6jnNNhd4lLiOxEfnl+gcn4xS4CXKC1pIUob1LA==
X-Received: by 2002:a9d:6c0c:0:b0:6a6:191b:c7d0 with SMTP id f12-20020a9d6c0c000000b006a6191bc7d0mr3387571otq.9.1682099649539;
        Fri, 21 Apr 2023 10:54:09 -0700 (PDT)
Received: from localhost.localdomain ([2804:14d:5c5e:44fb:7380:c348:a30c:7e82])
        by smtp.gmail.com with ESMTPSA id e3-20020a9d5603000000b006a633d75310sm850426oti.16.2023.04.21.10.54.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Apr 2023 10:54:09 -0700 (PDT)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, simon.horman@corigine.com,
        Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next v4 1/4] net/sched: sch_htb: use extack on errors messages
Date:   Fri, 21 Apr 2023 14:53:41 -0300
Message-Id: <20230421175344.299496-2-pctammela@mojatatu.com>
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
 net/sched/sch_htb.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index 92f2975b6a82..8aef7dd9fb88 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -1786,7 +1786,7 @@ static int htb_change_class(struct Qdisc *sch, u32 classid,
 		goto failure;
 
 	err = nla_parse_nested_deprecated(tb, TCA_HTB_MAX, opt, htb_policy,
-					  NULL);
+					  extack);
 	if (err < 0)
 		goto failure;
 
@@ -1858,7 +1858,7 @@ static int htb_change_class(struct Qdisc *sch, u32 classid,
 
 		/* check maximal depth */
 		if (parent && parent->parent && parent->parent->level < 2) {
-			pr_err("htb: tree is too deep\n");
+			NL_SET_ERR_MSG_MOD(extack, "tree is too deep");
 			goto failure;
 		}
 		err = -ENOBUFS;
@@ -1917,8 +1917,8 @@ static int htb_change_class(struct Qdisc *sch, u32 classid,
 			};
 			err = htb_offload(dev, &offload_opt);
 			if (err) {
-				pr_err("htb: TC_HTB_LEAF_ALLOC_QUEUE failed with err = %d\n",
-				       err);
+				NL_SET_ERR_MSG_WEAK(extack,
+						    "Failed to offload TC_HTB_LEAF_ALLOC_QUEUE");
 				goto err_kill_estimator;
 			}
 			dev_queue = netdev_get_tx_queue(dev, offload_opt.qid);
@@ -1937,8 +1937,8 @@ static int htb_change_class(struct Qdisc *sch, u32 classid,
 			};
 			err = htb_offload(dev, &offload_opt);
 			if (err) {
-				pr_err("htb: TC_HTB_LEAF_TO_INNER failed with err = %d\n",
-				       err);
+				NL_SET_ERR_MSG_WEAK(extack,
+						    "Failed to offload TC_HTB_LEAF_TO_INNER");
 				htb_graft_helper(dev_queue, old_q);
 				goto err_kill_estimator;
 			}
@@ -2067,8 +2067,9 @@ static int htb_change_class(struct Qdisc *sch, u32 classid,
 	qdisc_put(parent_qdisc);
 
 	if (warn)
-		pr_warn("HTB: quantum of class %X is %s. Consider r2q change.\n",
-			    cl->common.classid, (warn == -1 ? "small" : "big"));
+		NL_SET_ERR_MSG_FMT_MOD(extack,
+				       "quantum of class %X is %s. Consider r2q change.",
+				       cl->common.classid, (warn == -1 ? "small" : "big"));
 
 	qdisc_class_hash_grow(sch, &q->clhash);
 
-- 
2.34.1

