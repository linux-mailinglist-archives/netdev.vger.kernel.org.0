Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 299FF4F819C
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 16:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241904AbiDGObv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 10:31:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343922AbiDGObs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 10:31:48 -0400
Received: from mail-oa1-x2f.google.com (mail-oa1-x2f.google.com [IPv6:2001:4860:4864:20::2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9056F19322D
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 07:29:47 -0700 (PDT)
Received: by mail-oa1-x2f.google.com with SMTP id 586e51a60fabf-e2442907a1so6150880fac.8
        for <netdev@vger.kernel.org>; Thu, 07 Apr 2022 07:29:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5Ku/NHdjv0/2UZj+nUHnZTDwMUDUg4jtiaBV+rBKfL0=;
        b=YymYYUFrq4br34YLRdyaOA2I3kl5JRofggJWlg6SsQrm0I6BG/mU9SjoGuNSmomCHe
         VjKlSTkLizm7JBo304fv0Ek8ywlnzgDzGCvg2Aa0qtbwdZOSqjhSLmrIQKDBk6dPItaU
         xxdxtp3Vf9LAEevo4k3ucr0Ol1Ir0XMEWeA2xeFNBBJh8EyL5RMQK+hGRJoM5WgTe1ud
         c80Nc/aobihhSVHba27kpXmqD++VV5zIDQtpMkFhCx9A4gty1BNHG1FA34NNmPnBbuC+
         zpH01WEfk2Sm5S79UXAZVGyH6pPBbi1yxC0m3HAF/ZR+NqwQZepRtdshGDhCzo8NOMbl
         r8lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5Ku/NHdjv0/2UZj+nUHnZTDwMUDUg4jtiaBV+rBKfL0=;
        b=bGgNKD2ue1v6sC01cTgLYlSmYMBgr+E8km/cn1+PnrmNZM4XJkwmmV46P37gCEaYhc
         qGEuZURUDdBGvDKA4AvaX0Kd1NyzdgIRwuIbfZIQizS2czM8G3nn1uT1aMdb/BwhJHrT
         2MEUXEYkVtYw7x64XYO1+TjFO3MoD6n69uuWOLY+rbtZXbEBXteEBkKH4G07JUTyXQbi
         SzvIA2pmtsYLc81TQSNVT/ZCXxMbAeqbl8/cyRrqQHDqiTaNAWPINNK2k93MkMnglXnR
         X2R+kgR5kFYgbuWdKDvergKdrvV/XGojVkDtStXFjek4abpddEBsqj8RKvPG1TgLafGE
         N2LQ==
X-Gm-Message-State: AOAM532RhvRJukaKFmIl3pzjPRK4aagDpDYtP7CCyfVsqpppNYtIfcJM
        k1yV4yqXOetP+iuKgweOHVAovcJEQoQ=
X-Google-Smtp-Source: ABdhPJx88hdpS45xpZelIzOymU1+7X9hZa8leen/GOoqhvBlCN3Fz7Kvo45tK5wRds8ZheXyh5epnw==
X-Received: by 2002:a05:6870:b023:b0:db:78e:7197 with SMTP id y35-20020a056870b02300b000db078e7197mr6451161oae.36.1649341786859;
        Thu, 07 Apr 2022 07:29:46 -0700 (PDT)
Received: from t14s.localdomain ([177.220.172.117])
        by smtp.gmail.com with ESMTPSA id mj27-20020a0568700d9b00b000de29e1d6adsm5921269oab.16.2022.04.07.07.29.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 07:29:46 -0700 (PDT)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id 444691DF885; Thu,  7 Apr 2022 11:29:44 -0300 (-03)
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        vladbu@nvidia.com, dcaratti@redhat.com,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, lariel@nvidia.com
Subject: [PATCH net] net/sched: fix initialization order when updating chain 0 head
Date:   Thu,  7 Apr 2022 11:29:23 -0300
Message-Id: <b97d5f4eaffeeb9d058155bcab63347527261abf.1649341369.git.marcelo.leitner@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, when inserting a new filter that needs to sit at the head
of chain 0, it will first update the heads pointer on all devices using
the (shared) block, and only then complete the initialization of the new
element so that it has a "next" element.

This can lead to a situation that the chain 0 head is propagated to
another CPU before the "next" initialization is done. When this race
condition is triggered, packets being matched on that CPU will simply
miss all other filters, and will flow through the stack as if there were
no other filters installed. If the system is using OVS + TC, such
packets will get handled by vswitchd via upcall, which results in much
higher latency and reordering. For other applications it may result in
packet drops.

This is reproducible with a tc only setup, but it varies from system to
system. It could be reproduced with a shared block amongst 10 veth
tunnels, and an ingress filter mirroring packets to another veth.
That's because using the last added veth tunnel to the shared block to
do the actual traffic, it makes the race window bigger and easier to
trigger.

The fix is rather simple, to just initialize the next pointer of the new
filter instance (tp) before propagating the head change.

The fixes tag is pointing to the original code though this issue should
only be observed when using it unlocked.

Fixes: 2190d1d0944f ("net: sched: introduce helpers to work with filter chains")
Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Davide Caratti <dcaratti@redhat.com>
---
 net/sched/cls_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 2957f8f5cea759315463d5e61fa1db745746e6f7..f0699f39afdb082067e581a5ff1ce217351c4a19 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -1672,10 +1672,10 @@ static int tcf_chain_tp_insert(struct tcf_chain *chain,
 	if (chain->flushing)
 		return -EAGAIN;
 
+	RCU_INIT_POINTER(tp->next, tcf_chain_tp_prev(chain, chain_info));
 	if (*chain_info->pprev == chain->filter_chain)
 		tcf_chain0_head_change(chain, tp);
 	tcf_proto_get(tp);
-	RCU_INIT_POINTER(tp->next, tcf_chain_tp_prev(chain, chain_info));
 	rcu_assign_pointer(*chain_info->pprev, tp);
 
 	return 0;
-- 
2.35.1

