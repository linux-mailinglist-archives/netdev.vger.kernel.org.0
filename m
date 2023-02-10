Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DD5369288F
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 21:45:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233127AbjBJUpD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 15:45:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233250AbjBJUov (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 15:44:51 -0500
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBA5C6FEA5
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 12:44:50 -0800 (PST)
Received: by mail-ot1-x32e.google.com with SMTP id r34-20020a05683044a200b0068d4a8a8d2dso1899620otv.12
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 12:44:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=QGiJ/2xsygP6LyvIBPxMYbRLtmzczBDIsR2v1Udf0nY=;
        b=ocuOMUCvx1eqnNBJAkxFYCoTOmKn9Mun37SJbDpWrbnM5O9Y6FcIsrPRXIs+AUIMw3
         MB/WjLIrYBnQfJyB0//Uz1YUrBhTbb5I7DR30VpKQrDor+vRYp1GnygIfayoDdLDDPT7
         uCQ748Qx3k8dL7rIqIiLN0SjZsLTfNGtcluIhwAPRCCxMBpvSFa68nmNgHDsj1xo2BF2
         KhjZtL1kSr8TCzPfst5pPtL5CsIfzZGpvK484I9d0IVi1LnKnTX8wwg6hUedyUgWbCse
         wvKX3IqfupSempg4EDR8Yof9pLQK5Z6c1bRcZv3msLbkVh2QquzS2V8UhEJEhsJYWeCt
         2p0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QGiJ/2xsygP6LyvIBPxMYbRLtmzczBDIsR2v1Udf0nY=;
        b=vZCU8LEKCnXaXmIIHTP4/BSN4TcBmPMQI8BNw8rDBqHbbm8swMvhnliuUkgGg3Biym
         aTdGgO2v5eWZRZlzSCbxCf3v5MjjJtUA3E7nf8iIw/ZEyM8K7gsGQP4P4fkbReI+kv/H
         ghDdSM7yM4qfiWRaTNGJSelxesKGdGPQHHkRHWwi6Qu4+frMKZMbyIKJytl0fbJ8xTtK
         VmWP0topjGWa1MC4PXSgRMik+wjGvmXeX7t1gVZwJGpvgDRZaiChAsN6VFHUxH7rcOx9
         mELSELm+ZO2gDsdBdrjaQ1RTFjC4Q/lIp/ElfKq5a+mdSHrk6a5C97A/u0L2wPdkj1gr
         m8rA==
X-Gm-Message-State: AO0yUKX42YSolWiXBdtTbvWKyM3NLiXatcFXphWXq86RKFPuNKdF2Q81
        8FKvstabV6yAOW4NV7LtAbfoLixBeoNKgAMZ
X-Google-Smtp-Source: AK7set/yMGLJui7UvmAKIUNH7fy0o/w2MQ7dFVul9vTPtY4usphO0mT20PNdmGcERMFm4VCVQNuDUg==
X-Received: by 2002:a9d:7d01:0:b0:68b:ce98:1f9f with SMTP id v1-20020a9d7d01000000b0068bce981f9fmr9546736otn.34.1676061890223;
        Fri, 10 Feb 2023 12:44:50 -0800 (PST)
Received: from localhost.localdomain ([2804:14d:5c5e:4698:2ce0:9122:6880:760c])
        by smtp.gmail.com with ESMTPSA id v23-20020a9d5a17000000b0068bc8968753sm2396681oth.17.2023.02.10.12.44.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Feb 2023 12:44:49 -0800 (PST)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next 0/3] net/sched: transition actions to pcpu stats and rcu
Date:   Fri, 10 Feb 2023 17:27:23 -0300
Message-Id: <20230210202725.446422-1-pctammela@mojatatu.com>
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

Following the work done for act_pedit[0], transition the remaining tc
actions to percpu stats and rcu, whenever possible.
Percpu stats make updating the action stats very cheap, while combining
it with rcu action parameters makes it possible to get rid of the per
action lock in the datapath.

For act_connmark and act_nat we run the following tests:
- tc filter add dev ens2f0 ingress matchall action connmark
- tc filter add dev ens2f0 ingress matchall action nat ingress any 10.10.10.10

Our setup consists of a 26 cores Intel CPU and a 25G NIC.
We use TRex to shoot 10mpps TCP packets and take perf measurements.
Both actions improved performance as expected since the datapath lock disappeared.

Actions act_gate and act_ctinfo are changed to use the percpu stats.
act_ctinfo already relied on rcu on the datapath but it was updating the stats wrongly,
act_gate datapath has interactions with hrtimers which might require to take the per
action lock (not sure yet, so we only convert to percpu stats).

[0] https://lore.kernel.org/all/20230131145149.3776656-1-pctammela@mojatatu.com/

Pedro Tammela (3):
  net/sched: act_nat: transition to percpu stats and rcu
  net/sched: act_connmark: transition to percpu stats and rcu
  net/sched: act_gate: use percpu stats

 include/net/tc_act/tc_connmark.h |   9 ++-
 include/net/tc_act/tc_nat.h      |  10 ++-
 net/sched/act_connmark.c         | 109 ++++++++++++++++++++-----------
 net/sched/act_gate.c             |  10 +--
 net/sched/act_nat.c              |  68 +++++++++++++------
 5 files changed, 137 insertions(+), 69 deletions(-)

-- 
2.34.1

