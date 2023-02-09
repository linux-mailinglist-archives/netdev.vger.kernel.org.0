Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1F36690C0B
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 15:39:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbjBIOjy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 09:39:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231222AbjBIOjv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 09:39:51 -0500
Received: from mail-oa1-x32.google.com (mail-oa1-x32.google.com [IPv6:2001:4860:4864:20::32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A071AC648
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 06:39:27 -0800 (PST)
Received: by mail-oa1-x32.google.com with SMTP id 586e51a60fabf-142b72a728fso2743001fac.9
        for <netdev@vger.kernel.org>; Thu, 09 Feb 2023 06:39:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Fod+gg7ORfb4xr12jgn8eXg4E0lqVNSEHMVgIheRKmU=;
        b=I7lMqEBRKlM6sBdyHhSDwNj0xnF86KJX1M/m+Y5Kjynl6yci2PbN1r1yvfogQJ+11x
         QMzSuqobqRLiUZeji663xhJfBvBISGn/UnTKBZuvEtfHRpk4zLqtpOmWt8REvs4+ixoc
         zu+F8yDDNEoSlinAdiHLZ9ubjlJWu5+ualWP1SB6c42Sl4a/Z+rd+AP+jDO4f6Jorrag
         9J9j1KHSsKc3le93brQEI/CJsothgVxMtMVy5oY/KFFWgdluOLT9CuWy8xyWV+bKsXI4
         cy/BknBVBINRmpPAKYtleeCkIChE3ntyIiARhWDyvlVQO3zRZO3VtgqNGbrRUeIa46+I
         w0Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Fod+gg7ORfb4xr12jgn8eXg4E0lqVNSEHMVgIheRKmU=;
        b=V+pNeVx8+hOzmh5wHICMptnw6/9PdHWePCyAB/yqeTSPDRkaeE67U9nKwrtFngtk42
         QO7CJOnNXcDWiKW70XI3i6zRX4zq5V/ckVyETtBN5NxL7t1RtGHF/TYcUmxCMG0Kz4wO
         CNTITjuKsg0JRLnLuotziRMZPrsYTEqgC09vZKzRXSZvPscjTKH1Uq7bAyjE5lJIVKjo
         eMJSrI+EzYujMcxeR3VeGwiNKaByYf26kFlH7BY056/OJTX3z/wgQqCf+2QgEsgVP2OX
         4kaLEuuFFtlr5jga76xDMRY2H+LZ6GGo5dqILhJRcthEY43dDY5+gfIjWa/D4Jtz8jbh
         LirQ==
X-Gm-Message-State: AO0yUKWcH0AIQN5JFFPgpW5GbjWmh//kGCizcq/1NJSD31xPfy7ZgU5f
        dtC6exuvDo+xb4rdyPGQvR0NgJcLk5cJdhgD
X-Google-Smtp-Source: AK7set/VMRkdpMhtS10JNANPj8mnU0gFxGXTU/upG4WMynADBAanz21zh0Jw0SqdtUToUM9O/GG7+g==
X-Received: by 2002:a05:6870:a99c:b0:163:2357:6a35 with SMTP id ep28-20020a056870a99c00b0016323576a35mr5542413oab.8.1675953566849;
        Thu, 09 Feb 2023 06:39:26 -0800 (PST)
Received: from localhost.localdomain ([2804:14d:5c5e:4698:de83:303f:bdc2:98dc])
        by smtp.gmail.com with ESMTPSA id q6-20020a9d6646000000b0068bce2c3e9esm745941otm.14.2023.02.09.06.39.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 06:39:26 -0800 (PST)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, Pedro Tammela <pctammela@mojatatu.com>,
        valis <sec@valis.email>
Subject: [PATCH net] net/sched: tcindex: update imperfect hash filters respecting rcu
Date:   Thu,  9 Feb 2023 11:37:39 -0300
Message-Id: <20230209143739.279867-1-pctammela@mojatatu.com>
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

The imperfect hash area can be updated while packets are traversing,
which will cause a use-after-free when 'tcf_exts_exec()' is called
with the destroyed tcf_ext.

CPU 0:               CPU 1:
tcindex_set_parms    tcindex_classify
tcindex_lookup
                     tcindex_lookup
tcf_exts_change
                     tcf_exts_exec [UAF]

Stop operating on the shared area directly, by using a local copy,
and update the filter with 'rcu_replace_pointer()'. Delete the old
filter version only after a rcu grace period elapsed.

Fixes: 9b0d4446b569 ("net: sched: avoid atomic swap in tcf_exts_change")
Reported-by: valis <sec@valis.email>
Suggested-by: valis <sec@valis.email>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
---
 net/sched/cls_tcindex.c | 34 ++++++++++++++++++++++++++++++----
 1 file changed, 30 insertions(+), 4 deletions(-)

diff --git a/net/sched/cls_tcindex.c b/net/sched/cls_tcindex.c
index ee2a050c8..ba7f22a49 100644
--- a/net/sched/cls_tcindex.c
+++ b/net/sched/cls_tcindex.c
@@ -12,6 +12,7 @@
 #include <linux/errno.h>
 #include <linux/slab.h>
 #include <linux/refcount.h>
+#include <linux/rcupdate.h>
 #include <net/act_api.h>
 #include <net/netlink.h>
 #include <net/pkt_cls.h>
@@ -339,6 +340,7 @@ tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
 	struct tcf_result cr = {};
 	int err, balloc = 0;
 	struct tcf_exts e;
+	bool update_h = false;
 
 	err = tcf_exts_init(&e, net, TCA_TCINDEX_ACT, TCA_TCINDEX_POLICE);
 	if (err < 0)
@@ -456,10 +458,13 @@ tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
 		}
 	}
 
-	if (cp->perfect)
+	if (cp->perfect) {
 		r = cp->perfect + handle;
-	else
-		r = tcindex_lookup(cp, handle) ? : &new_filter_result;
+	} else {
+		/* imperfect area is updated in-place using rcu */
+		update_h = !!tcindex_lookup(cp, handle);
+		r = &new_filter_result;
+	}
 
 	if (r == &new_filter_result) {
 		f = kzalloc(sizeof(*f), GFP_KERNEL);
@@ -485,7 +490,28 @@ tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
 
 	rcu_assign_pointer(tp->root, cp);
 
-	if (r == &new_filter_result) {
+	if (update_h) {
+		struct tcindex_filter __rcu **fp;
+		struct tcindex_filter *cf;
+
+		f->result.res = r->res;
+		tcf_exts_change(&f->result.exts, &r->exts);
+
+		/* imperfect area bucket */
+		fp = cp->h + (handle % cp->hash);
+
+		/* lookup the filter, guaranteed to exist */
+		for (cf = rcu_dereference_bh_rtnl(*fp); cf;
+		     fp = &cf->next, cf = rcu_dereference_bh_rtnl(*fp))
+			if (cf->key == handle)
+				break;
+
+		f->next = cf->next;
+
+		cf = rcu_replace_pointer(*fp, f, 1);
+		tcf_exts_get_net(&cf->result.exts);
+		tcf_queue_work(&cf->rwork, tcindex_destroy_fexts_work);
+	} else if (r == &new_filter_result) {
 		struct tcindex_filter *nfp;
 		struct tcindex_filter __rcu **fp;
 
-- 
2.34.1

