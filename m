Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD09A6A45FD
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 16:24:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbjB0PYV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 10:24:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbjB0PYT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 10:24:19 -0500
Received: from mail-oa1-x2a.google.com (mail-oa1-x2a.google.com [IPv6:2001:4860:4864:20::2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F22ACA26F
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 07:24:18 -0800 (PST)
Received: by mail-oa1-x2a.google.com with SMTP id 586e51a60fabf-17213c961dfso7812137fac.0
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 07:24:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=aGI/XfojXr1Xspiz86MI7eLV43eyRswKIpPphy6yYjg=;
        b=Oll1pHB/eikjXrtphNIBDY3Vh1Z6vB4/qSGCjNtO9pSFAT0vPhGZBJfSLixDdv1tae
         ZtSMf3an+2w4fL4F6FAA7Px491otjtXw71BQfaWy0pRbCQd3jvoXhMGxw7B5FIHuZf9j
         OGskKNLYvpLOWRSWxXi6dMjE9SZY8rtaRpU7Wx5qDfvP5xC0sLKHcUq2nZyco7U66DLq
         jvWDYdq2QGfDyj+U1qkk4KfwuT9Vb7VG4XXshEMb+CvL+UiWz8nJhksdgG82/V7e/Kbs
         cMisKu5p2ZZMEaZUzCwX6+PWgyDdL5HuA7iCMlqsD2adarweZwLngfjWELLCfozdVa7O
         JOXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aGI/XfojXr1Xspiz86MI7eLV43eyRswKIpPphy6yYjg=;
        b=oUusrQv5G3ZeoJ7VJlU+Q9Y4lwnnVrf1aTLpHF0+pmOMBt5M43hw5Vkbl9Ob3fijz9
         BSw9VTOH5V2cFrvKtCu8J5z+YrMYYxVFSMOGsvA41rpRGzWb9fE4VCDmxPjFSdX1Oyay
         QKj9cMc2yiDONh0MqCf5oib+2EtaGS4JeckwQFawGoSysPAK8+mNpjV5SZS/Kr+hyWXO
         zjYO40/WjC6M89YgQarTOaxPsNq6AHuo+rAaJMeWhgdkIUscLOWEfFse+reCbUnIatYQ
         gfaUCdVkQ907k41voNfortsb0/acunGxPrq2HvBcAs/9mkx8ilT+QV92QvOtphM4jY+G
         xwcg==
X-Gm-Message-State: AO0yUKVVY+B9xlt9Uyzx/gwNRgIShQBJkMmExmT9HXvBtJonh8tkwxFb
        PYmj7/waVy7jlZEmpyVlQLeWYg/hNsHXQ3tw
X-Google-Smtp-Source: AK7set+YsRU1GR1oQSkV7PLvXa9NNNF0LpxxirjkNdTF04nKja8rNZAiah2EB/KcDlW/twJrS1tXVw==
X-Received: by 2002:a05:6870:e0c8:b0:172:55cf:f6cc with SMTP id a8-20020a056870e0c800b0017255cff6ccmr11432945oab.51.1677511458030;
        Mon, 27 Feb 2023 07:24:18 -0800 (PST)
Received: from localhost.localdomain ([2804:14d:5c5e:4698:4174:ef7a:c9ab:ab62])
        by smtp.gmail.com with ESMTPSA id k27-20020a4a2a1b000000b004c60069d1fbsm2752774oof.11.2023.02.27.07.24.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Feb 2023 07:24:17 -0800 (PST)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, error27@gmail.com, simon.horman@corigine.com,
        Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net v2] net/sched: act_connmark: handle errno on tcf_idr_check_alloc
Date:   Mon, 27 Feb 2023 12:23:52 -0300
Message-Id: <20230227152352.266109-1-pctammela@mojatatu.com>
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

Smatch reports that 'ci' can be used uninitialized.
The current code ignores errno coming from tcf_idr_check_alloc, which
will lead to the incorrect usage of 'ci'. Handle the errno as it should.

Fixes: 288864effe33 ("net/sched: act_connmark: transition to percpu stats and rcu")
Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
---
 net/sched/act_connmark.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/sched/act_connmark.c b/net/sched/act_connmark.c
index 8dabfb52ea3d..0d7aee8933c5 100644
--- a/net/sched/act_connmark.c
+++ b/net/sched/act_connmark.c
@@ -158,6 +158,9 @@ static int tcf_connmark_init(struct net *net, struct nlattr *nla,
 		nparms->zone = parm->zone;
 
 		ret = 0;
+	} else {
+		err = ret;
+		goto out_free;
 	}
 
 	err = tcf_action_check_ctrlact(parm->action, tp, &goto_ch, extack);
-- 
2.34.1

