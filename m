Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE1246927A7
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 21:09:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233524AbjBJUJA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 15:09:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232057AbjBJUI7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 15:08:59 -0500
Received: from mail-oa1-x36.google.com (mail-oa1-x36.google.com [IPv6:2001:4860:4864:20::36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8CBD749AD
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 12:08:57 -0800 (PST)
Received: by mail-oa1-x36.google.com with SMTP id 586e51a60fabf-169ba826189so8145069fac.2
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 12:08:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=y8v/EUCW+dksyKYo8ivMxXaJl3DgyFAJPcPB5bXT+sw=;
        b=XoZJjGW/YeLyrFYYA+zFPiSCL3ihi6GpjSvNv/MwPjn3kZXge2o77t++t7pRbn7Siy
         PPrQbnpjcAeXUHg5pJn/bMT0XYWD1k3M9y+8oyeY/bIywuZiFvPrevL+nZYkkjNEx4x8
         Oh3FBoWcpsGRCt/23ZDkHRfZGQ3OHZ52GG+qi58dWNAwW0mWrpFBeUM4vryuRe+RlZRO
         bvSk4f/OQdGe6I+QbAZMg6iumLWDwy8/uRoPHXon2M+fq8IbxgTN0N6v5wMOOpEMtjoe
         R8RGzgCTT2O3LSW7MTMINbdCTnsnyUEiJrqRZP1UY3Ez4NEm5+kGqeSsLFrgVEEySkyP
         S7Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=y8v/EUCW+dksyKYo8ivMxXaJl3DgyFAJPcPB5bXT+sw=;
        b=RnUMXuNGJXiQRNoh0fpN+i5KumXNZVshLFvJ584OlzHyoNZ4+51+TGpM87UUnVU9d1
         uVO9WZ4gi04WhVeRrNaXW946+71EdCj1sbfTFeIiRp+hphDWImhvHE+6FNrWb/JyiO9u
         +EUNzEOdtUReQuhcSCrsLvhDzwbNwy1iqEx4IYubSb7qnIVZiYpMZP6k3G9Ww+Ou6zce
         bQWAl9Ad8dSrBPhBfy8uczOZljooKz5wF/7ejgaTdIZxiby27X4lJPMmloi68AXQglGe
         4d517il6/jf77KXzdg8OLQ1P67Dsx2tfFtk0CFVQPnUljlSHWP01bsTqDMbZJp1BQ8Qw
         jbkA==
X-Gm-Message-State: AO0yUKVes7tEn/mCBgT6IMBkUlo4P+CoL6rT2ASwwjG3o2av8108t8oA
        gJnpMnTdtJ4+/afNyHrxf4cdSPGcrNcwOd6X
X-Google-Smtp-Source: AK7set9lDromSIon8nWZ9kUHDwPJvHTzyQdFMFnyScA4ZqoXRGZOoYFDaZC/FcGi6ENHxCDpcKx5fA==
X-Received: by 2002:a05:6870:a553:b0:16a:ab9f:688b with SMTP id p19-20020a056870a55300b0016aab9f688bmr5333563oal.15.1676059737122;
        Fri, 10 Feb 2023 12:08:57 -0800 (PST)
Received: from localhost.localdomain ([2804:14d:5c5e:4698:2ce0:9122:6880:760c])
        by smtp.gmail.com with ESMTPSA id e6-20020a056870944600b0016ac9cbec6bsm1744127oal.6.2023.02.10.12.08.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Feb 2023 12:08:56 -0800 (PST)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, ldir@darbyshire-bryant.me.uk, toke@redhat.com,
        Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net] net/sched: act_ctinfo: use percpu stats
Date:   Fri, 10 Feb 2023 17:08:25 -0300
Message-Id: <20230210200824.444856-1-pctammela@mojatatu.com>
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

The tc action act_ctinfo was using shared stats, fix it to use percpu stats
since bstats_update() must be called with locks or with a percpu pointer argument.

tdc results:
1..12
ok 1 c826 - Add ctinfo action with default setting
ok 2 0286 - Add ctinfo action with dscp
ok 3 4938 - Add ctinfo action with valid cpmark and zone
ok 4 7593 - Add ctinfo action with drop control
ok 5 2961 - Replace ctinfo action zone and action control
ok 6 e567 - Delete ctinfo action with valid index
ok 7 6a91 - Delete ctinfo action with invalid index
ok 8 5232 - List ctinfo actions
ok 9 7702 - Flush ctinfo actions
ok 10 3201 - Add ctinfo action with duplicate index
ok 11 8295 - Add ctinfo action with invalid index
ok 12 3964 - Replace ctinfo action with invalid goto_chain control

Fixes: 24ec483cec98 ("net: sched: Introduce act_ctinfo action")
Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
---
 net/sched/act_ctinfo.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/sched/act_ctinfo.c b/net/sched/act_ctinfo.c
index 4b1b59da5..4d15b6a61 100644
--- a/net/sched/act_ctinfo.c
+++ b/net/sched/act_ctinfo.c
@@ -93,7 +93,7 @@ TC_INDIRECT_SCOPE int tcf_ctinfo_act(struct sk_buff *skb,
 	cp = rcu_dereference_bh(ca->params);
 
 	tcf_lastuse_update(&ca->tcf_tm);
-	bstats_update(&ca->tcf_bstats, skb);
+	tcf_action_update_bstats(&ca->common, skb);
 	action = READ_ONCE(ca->tcf_action);
 
 	wlen = skb_network_offset(skb);
@@ -212,8 +212,8 @@ static int tcf_ctinfo_init(struct net *net, struct nlattr *nla,
 	index = actparm->index;
 	err = tcf_idr_check_alloc(tn, &index, a, bind);
 	if (!err) {
-		ret = tcf_idr_create(tn, index, est, a,
-				     &act_ctinfo_ops, bind, false, flags);
+		ret = tcf_idr_create_from_flags(tn, index, est, a,
+						&act_ctinfo_ops, bind, flags);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			return ret;
-- 
2.34.1

