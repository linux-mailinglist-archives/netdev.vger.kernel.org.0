Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5347264759F
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 19:32:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbiLHScA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 13:32:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbiLHSbS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 13:31:18 -0500
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0279AE4FD;
        Thu,  8 Dec 2022 10:31:14 -0800 (PST)
Received: by mail-ot1-x329.google.com with SMTP id l8-20020a056830054800b006705fd35eceso1362463otb.12;
        Thu, 08 Dec 2022 10:31:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k44aAa8w+g09OTVc3BtKD/GeVUZOQmCH52b2zgD7vNE=;
        b=kJnn8W88eYCSTCdaionDWs5lanPHeksZRwOquRqQpTBf+8LE/3uQ6Kb7qIiD+I2JFB
         NXC1hNgGIMNa4RtjALbAPIj6NPXaAplZSYXFpEgFkCE4Kuvr62KzE9Db6q3E1uaCKomN
         EIMjj/zqnYLqPfVe+aWersTJ5haEMRKBNYkkM/2+XbFQAQ4YHH1RxjnPmpxvHaUnjvU2
         ZRhNYhUEHZFxgLz1LFrWWFbSfevTzqa0HvdTj1q3AuGflLvTvBTsVo/X2HEusft2UGsW
         Q7Ih9kt50RqgUeUUITRHBrHUwXI7bvDSkpH02dZ/dQN5XFutYGi6lP5X4TUXs6MCZIRn
         fFTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k44aAa8w+g09OTVc3BtKD/GeVUZOQmCH52b2zgD7vNE=;
        b=AS8kMgIt5wpLTCjPlxvwekueIeibvqTLzAiC78348nVkbvNKMVPaVf/BuvXISj8gIL
         n52qWIaJqzpSMTeW7w/ekN7bmfTuuknKFGHKcY5hGxl2cYv8aQaVL3zqLr1YSzFy4WWt
         pjhBiYSSfRhBjMx4YLDsPZMU3Kbx3dOp/GaVkHrBNE20uieS3bsalN8Ihuzh7V/z5cEO
         D5m7xqaXG5EyZeyMGbU5H3R6SXdipq4xRcN5gz/Ee+4EPXotrSuWq6wNhR7BsABCJpUa
         lbwg6zTWwLlwp3f8VYtCidQHUrxf+vxhO2rVKJQKbJdTyxTNHKYoD/q7wbRiDwYL/FdL
         0iLA==
X-Gm-Message-State: ANoB5pm12qik4BhbF3BA73eNYRQcFcAWtjIWX7mKVdMPpojd2Mm+/pke
        TLxhxkJN2FeiA9ZAGNMy4cg9xmPzPG8=
X-Google-Smtp-Source: AA0mqf5qkVMTNLwYrHEwSHnT1jBNeG/TVLvAyXhtP9eQdTstA6d6OIfcNnz3oSL3kXGPlxhIOl1IdQ==
X-Received: by 2002:a9d:5f02:0:b0:66d:a5fa:5c54 with SMTP id f2-20020a9d5f02000000b0066da5fa5c54mr1449103oti.1.1670524273395;
        Thu, 08 Dec 2022 10:31:13 -0800 (PST)
Received: from localhost ([12.97.180.36])
        by smtp.gmail.com with ESMTPSA id x26-20020a9d629a000000b006705e35c4e2sm3077138otk.35.2022.12.08.10.31.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 10:31:13 -0800 (PST)
From:   Yury Norov <yury.norov@gmail.com>
To:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Barry Song <baohua@kernel.org>,
        Ben Segall <bsegall@google.com>,
        haniel Bristot de Oliveira <bristot@redhat.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Gal Pressman <gal@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Mel Gorman <mgorman@suse.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Tariq Toukan <ttoukan.linux@gmail.com>,
        Tony Luck <tony.luck@intel.com>,
        Valentin Schneider <vschneid@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>
Cc:     Yury Norov <yury.norov@gmail.com>, linux-crypto@vger.kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [PATCH v3 5/5] lib/cpumask: reorganize cpumask_local_spread() logic
Date:   Thu,  8 Dec 2022 10:31:01 -0800
Message-Id: <20221208183101.1162006-6-yury.norov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221208183101.1162006-1-yury.norov@gmail.com>
References: <20221208183101.1162006-1-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now after moving all NUMA logic into sched_numa_find_nth_cpu(),
else-branch of cpumask_local_spread() is just a function call, and
we can simplify logic by using ternary operator.

While here, replace BUG() with WARN().

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 lib/cpumask.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/lib/cpumask.c b/lib/cpumask.c
index 255974cd6734..c7029fb3c372 100644
--- a/lib/cpumask.c
+++ b/lib/cpumask.c
@@ -127,16 +127,12 @@ unsigned int cpumask_local_spread(unsigned int i, int node)
 	/* Wrap: we always want a cpu. */
 	i %= num_online_cpus();
 
-	if (node == NUMA_NO_NODE) {
-		cpu = cpumask_nth(i, cpu_online_mask);
-		if (cpu < nr_cpu_ids)
-			return cpu;
-	} else {
-		cpu = sched_numa_find_nth_cpu(cpu_online_mask, i, node);
-		if (cpu < nr_cpu_ids)
-			return cpu;
-	}
-	BUG();
+	cpu = node == NUMA_NO_NODE ?
+		cpumask_nth(i, cpu_online_mask) :
+		sched_numa_find_nth_cpu(cpu_online_mask, i, node);
+
+	WARN_ON(cpu >= nr_cpu_ids);
+	return cpu;
 }
 EXPORT_SYMBOL(cpumask_local_spread);
 
-- 
2.34.1

