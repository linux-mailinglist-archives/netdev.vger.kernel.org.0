Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B82065FE1E3
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 20:46:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbiJMSqa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 14:46:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232261AbiJMSqK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 14:46:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DD6418B481
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 11:43:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665686476;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aO9uwyAWNrITIE0HcaM8sZnAKHxlA4eUnkHhusC4UKE=;
        b=HUAZBmVZdC5JKhxZJiN2OvTGJyteki3L6JkJ0BZ6KKo/i+Jnvp1EApRGP+SMMY4szhMMJb
        quwQzWDK7nnbLQ1Z+3hHi4F0yApuLJJW59Dd4w23yRwtke4AUYC3K99S5FZsTiY36PZ71r
        kDYhzkm6lCCiRg6HvYqkZf8QS8KF4+Q=
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com
 [209.85.167.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-650-CoruuQkfPY6vU8E4tHf0EQ-1; Thu, 13 Oct 2022 14:41:15 -0400
X-MC-Unique: CoruuQkfPY6vU8E4tHf0EQ-1
Received: by mail-oi1-f200.google.com with SMTP id t37-20020a05680815a500b0034fdd9124d9so1086585oiw.3
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 11:41:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aO9uwyAWNrITIE0HcaM8sZnAKHxlA4eUnkHhusC4UKE=;
        b=zZ6Nv84mq32lvStv/Uta38hFbgynIXDUWbjSRaJ3tWaPjylI/pg+YfcRAVbOHiEIBU
         5g+2KHVKijWAU2kR16GtCGww/uMMJaYTbPer/BbCLIwfX3rNMTfoodjwR7mcEnORatA2
         5q7gif3T42BFniSVRUJc213jyvdxgW/hPEUSF9Mp8p5Yjx2tUx9IxezfJ123imzXI6H2
         sxsvJz+7/RhcxCsUDYouUxNUblTZGCL5UaQ4bUpFqIelKhBwIh4DToyZlewMo0xumgy9
         k3keT8bqxU6PZIY2AjrmxOmaXQVWt22YBGiWIeTu2qunXl5EInBrJOlNqGePrkvSNON1
         I6gw==
X-Gm-Message-State: ACrzQf0jTgphKWkMxyfEP5CHgwvssICgzreXdNNZMkI4E38iJPzFUw8i
        u4IIjR2xi1zpBwAo7kPzD2ta53tKtcdC+BvIeAi6mFpyiQoKWBpVk2MOv0ZYDKA+i8/KgCKIBXc
        UZx7451w1ppMNosMl
X-Received: by 2002:a05:6870:596:b0:12d:91cd:cf36 with SMTP id m22-20020a056870059600b0012d91cdcf36mr6446062oap.84.1665686474650;
        Thu, 13 Oct 2022 11:41:14 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM52k3vKtIVGL+BfBIsY/ib9UZWiX3f2GV5v2CeLaUkMNUjAO0cLO7Cc3TLwdOlxaDtAQIvz/Q==
X-Received: by 2002:a05:6870:596:b0:12d:91cd:cf36 with SMTP id m22-20020a056870059600b0012d91cdcf36mr6446050oap.84.1665686474448;
        Thu, 13 Oct 2022 11:41:14 -0700 (PDT)
Received: from localhost.localdomain ([2804:1b3:a801:9473:d360:c737:7c9c:d52b])
        by smtp.gmail.com with ESMTPSA id v13-20020a05683024ad00b006618ad77a63sm244521ots.74.2022.10.13.11.41.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Oct 2022 11:41:14 -0700 (PDT)
From:   Leonardo Bras <leobras@redhat.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Valentin Schneider <vschneid@redhat.com>,
        Tejun Heo <tj@kernel.org>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Leonardo Bras <leobras@redhat.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Phil Auld <pauld@redhat.com>,
        Antoine Tenart <atenart@kernel.org>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Wang Yufen <wangyufen@huawei.com>, mtosatti@redhat.com
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v2 4/4] crypto/pcrypt: Do not use isolated CPUs for callback
Date:   Thu, 13 Oct 2022 15:40:29 -0300
Message-Id: <20221013184028.129486-5-leobras@redhat.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221013184028.129486-1-leobras@redhat.com>
References: <20221013184028.129486-1-leobras@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently pcrypt_aead_init_tfm() will pick callback cpus (ctx->cb_cpu)
from any online cpus. Later padata_reorder() will queue_work_on() the
chosen cb_cpu.

This is undesired if the chosen cb_cpu is listed as isolated (i.e. using
isolcpus=... or nohz_full=... kernel parameters), since the work queued
will interfere with the workload on the isolated cpu.

Make sure isolated cpus are not used for pcrypt.

Signed-off-by: Leonardo Bras <leobras@redhat.com>
---
 crypto/pcrypt.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
index 9d10b846ccf73..0162629a03957 100644
--- a/crypto/pcrypt.c
+++ b/crypto/pcrypt.c
@@ -16,6 +16,7 @@
 #include <linux/kobject.h>
 #include <linux/cpu.h>
 #include <crypto/pcrypt.h>
+#include <linux/sched/isolation.h>
 
 static struct padata_instance *pencrypt;
 static struct padata_instance *pdecrypt;
@@ -175,13 +176,15 @@ static int pcrypt_aead_init_tfm(struct crypto_aead *tfm)
 	struct pcrypt_instance_ctx *ictx = aead_instance_ctx(inst);
 	struct pcrypt_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	struct crypto_aead *cipher;
+	const cpumask_t *hk_wq = housekeeping_cpumask(HK_TYPE_WQ);
 
 	cpu_index = (unsigned int)atomic_inc_return(&ictx->tfm_count) %
-		    cpumask_weight(cpu_online_mask);
+		    cpumask_weight_and(hk_wq, cpu_online_mask);
 
-	ctx->cb_cpu = cpumask_first(cpu_online_mask);
+	ctx->cb_cpu = cpumask_first_and(hk_wq, cpu_online_mask);
 	for (cpu = 0; cpu < cpu_index; cpu++)
-		ctx->cb_cpu = cpumask_next(ctx->cb_cpu, cpu_online_mask);
+		ctx->cb_cpu = cpumask_next_and(ctx->cb_cpu, hk_wq,
+					       cpu_online_mask);
 
 	cipher = crypto_spawn_aead(&ictx->spawn);
 
-- 
2.38.0

