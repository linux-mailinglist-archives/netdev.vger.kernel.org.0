Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD0DD6EBA11
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 17:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbjDVP43 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Apr 2023 11:56:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbjDVP41 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Apr 2023 11:56:27 -0400
Received: from mail-oa1-x2a.google.com (mail-oa1-x2a.google.com [IPv6:2001:4860:4864:20::2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ADB1171C
        for <netdev@vger.kernel.org>; Sat, 22 Apr 2023 08:56:26 -0700 (PDT)
Received: by mail-oa1-x2a.google.com with SMTP id 586e51a60fabf-1879fc89f5eso1243720fac.0
        for <netdev@vger.kernel.org>; Sat, 22 Apr 2023 08:56:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1682178985; x=1684770985;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tgTuNzspbyApr+G6Zp0R1bfTdKEOJFb43e3NBF/vvss=;
        b=x+q0AgFphvfqCLesF90eoz4LFEfXln18/pdzho0hp7AWbuei+Au4AwJvG/rlGh3ND9
         e7v1IezA59ke7dyl+c0Xz7fTRmonahMqvCtLBnLKQdVWNeOWPkeYRrubmZPj9DBohRzl
         fb3mJQR1El9AIO4pa/OWL+MPfDl2O4TyhCdMJZdtgcoobHMWUGmkuMnj+ZKPRMbaXU4i
         J3Ftys3utk9vqkLuMnQ8eivb4d7ewB11/TByvpy0eWax1TsYvt54qnrfcwStOZk6Hw2n
         u+BKEMGYxvvz9L+DtvLKDmPiDCivMVWw4CmRkcqCXbB2aPUAJFHyPphs5Jw7OdJ+3kRo
         x7vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682178985; x=1684770985;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tgTuNzspbyApr+G6Zp0R1bfTdKEOJFb43e3NBF/vvss=;
        b=NgfocYnJoPOGTfsQ/cM+9R8xaQdbfQOffO883VRnOn4B5h/GEmtztKe3KsDKKldsb8
         972TvaQ0f+27hLaSpy2uUT2rya7kk4z2PYszEMGU46hJrtOyDaM3sFyCKk4l62OeWjKY
         kJ8s+n/HAyeOiU5zWHXn/MZQyl406c0avIk9eI0BDLjFcU3oJmzhx07Yv95VqG4jwaFg
         7c0KgrvK55pC0x7UFbxw7pALYT+Mz52LSR6L2ljyuJ19CuLaRugbtvjl/XeEDDZNLBBR
         xcG2OZ6IgWQ5AdJ3TAbc2mTULs4MuFAlKzFouEBnc++7HYvpsJCztFFzqpcXGS9CDv9t
         x4HQ==
X-Gm-Message-State: AAQBX9eZ7q6sLMbT9MaRbg7MJT0EC39g7CxaQY4OVeWOe+FVBv/eI3TB
        hiDAS2HFQhiVG4SSKQP3Jiiu6iGW7PMaUwSbMHw=
X-Google-Smtp-Source: AKy350a0ZSM9r1ru91ONK283bOYujMxkaB/6t9XEdods5JALTbRPOyEcHKOU26hItE3ZGqxSeokylw==
X-Received: by 2002:a05:6870:12d4:b0:188:10c1:555e with SMTP id 20-20020a05687012d400b0018810c1555emr4390329oam.24.1682178985669;
        Sat, 22 Apr 2023 08:56:25 -0700 (PDT)
Received: from rogue-one.tail33bf8.ts.net ([2804:14d:5c5e:44fb:da55:60e0:8cc2:c48e])
        by smtp.gmail.com with ESMTPSA id v1-20020a05683018c100b006a32eb9e0dfsm2818255ote.67.2023.04.22.08.56.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Apr 2023 08:56:25 -0700 (PDT)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, simon.horman@corigine.com,
        Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next v5 1/4] net/sched: sch_htb: use extack on errors messages
Date:   Sat, 22 Apr 2023 12:56:09 -0300
Message-Id: <20230422155612.432913-2-pctammela@mojatatu.com>
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

