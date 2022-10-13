Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 089B35FE1D4
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 20:45:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229965AbiJMSo7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 14:44:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232341AbiJMSn4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 14:43:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A5C1248F7
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 11:42:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665686465;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6JjDK3twE+pSMUDp2i+4iId8FgNp8eHanR+PXksbbJA=;
        b=ExJHFJ0P2+QE50xAukY4ioxclZZoO+aZtR5kGi0TDMeT8lNeQkF2Wrf7EWlJ7SPtwQ64ME
        3OI0C1a++FuZXOnTzMBIvNiLMGJPrQJAs4GF0t/DuK4TjYyCPgOb/nDzkEY+jP4L8kpvrJ
        x5y+/aFuurx8PBC/fpDWUKzsxE+byz0=
Received: from mail-oa1-f71.google.com (mail-oa1-f71.google.com
 [209.85.160.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-331-T0VVofNjP_OGv7xBOZZv7A-1; Thu, 13 Oct 2022 14:41:03 -0400
X-MC-Unique: T0VVofNjP_OGv7xBOZZv7A-1
Received: by mail-oa1-f71.google.com with SMTP id 586e51a60fabf-131d9821d9cso1491699fac.6
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 11:41:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6JjDK3twE+pSMUDp2i+4iId8FgNp8eHanR+PXksbbJA=;
        b=QRlW1zWo3ePz3JD25F2mr2m9W7WA2/vsY2XWvfTpjxODBL6oV6ymi2/h/pBlXCMDOL
         C+KiMn5Rb1kPI6rlN75e1/W51ivONzjYxt4efqDyR3csKGFs8JMbttMvCf4jHlzUZ2iW
         85jMSseTuS9vds1fI3WsW4QUHjGq0WbB5JhSj1aFsJUoealxrH/trgUdKHoTJ7mEPWcK
         +NNldHynE7V63aUPJBY19+BA2H++0r7VIEaMBwtxGLJ8pntBySO4lNBqwNNxKA4BPDLR
         PX0wBxxviMx2yK108StXoqLYknepAlskRiDW3ob9DeC+tk8EnCjNsXlgWTFdpDnnwxwo
         jw7Q==
X-Gm-Message-State: ACrzQf1RlUeNUkgoNX+VB9IB1rcP6YHodhUJ8qr7RM+KGHgEEJuB64Hl
        epfBS1rFHSjU8tQFYfQEwTES0J3eQ5Su6IL3PvZvB1yrkwYBUkWb6ca79NA4MxC+ybowUm1q7tI
        PdACgj/Lt+BDTr+gr
X-Received: by 2002:a9d:2d81:0:b0:658:accf:2adf with SMTP id g1-20020a9d2d81000000b00658accf2adfmr688449otb.334.1665686462119;
        Thu, 13 Oct 2022 11:41:02 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7TiIyrwXPFplLjLvX4+bEb60ttonBBZ0lr/zrMURi69WbZIZ4juK0apaIljHzLOixeLkyFDw==
X-Received: by 2002:a9d:2d81:0:b0:658:accf:2adf with SMTP id g1-20020a9d2d81000000b00658accf2adfmr688432otb.334.1665686461891;
        Thu, 13 Oct 2022 11:41:01 -0700 (PDT)
Received: from localhost.localdomain ([2804:1b3:a801:9473:d360:c737:7c9c:d52b])
        by smtp.gmail.com with ESMTPSA id v13-20020a05683024ad00b006618ad77a63sm244521ots.74.2022.10.13.11.40.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Oct 2022 11:41:01 -0700 (PDT)
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
Subject: [PATCH v2 2/4] sched/isolation: Improve documentation
Date:   Thu, 13 Oct 2022 15:40:27 -0300
Message-Id: <20221013184028.129486-3-leobras@redhat.com>
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

Improve documentation on housekeeping types and what to expect from
housekeeping functions.

Signed-off-by: Leonardo Bras <leobras@redhat.com>
---
 include/linux/sched/isolation.h | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/include/linux/sched/isolation.h b/include/linux/sched/isolation.h
index 762701f295d1c..9333c28153a7a 100644
--- a/include/linux/sched/isolation.h
+++ b/include/linux/sched/isolation.h
@@ -7,18 +7,25 @@
 #include <linux/tick.h>
 
 enum hk_type {
-	HK_TYPE_TIMER,
-	HK_TYPE_RCU,
-	HK_TYPE_MISC,
-	HK_TYPE_SCHED,
-	HK_TYPE_TICK,
-	HK_TYPE_DOMAIN,
-	HK_TYPE_WQ,
-	HK_TYPE_MANAGED_IRQ,
-	HK_TYPE_KTHREAD,
+	HK_TYPE_TIMER,		/* Timer interrupt, watchdogs */
+	HK_TYPE_RCU,		/* RCU callbacks */
+	HK_TYPE_MISC,		/* Minor housekeeping categories */
+	HK_TYPE_SCHED,		/* Scheduling and idle load balancing */
+	HK_TYPE_TICK,		/* See isolcpus=nohz boot parameter */
+	HK_TYPE_DOMAIN,		/* See isolcpus=domain boot parameter*/
+	HK_TYPE_WQ,		/* Work Queues*/
+	HK_TYPE_MANAGED_IRQ,	/* See isolcpus=managed_irq boot parameter */
+	HK_TYPE_KTHREAD,	/* kernel threads */
 	HK_TYPE_MAX
 };
 
+/* Kernel parameters like nohz_full and isolcpus allow passing cpu numbers
+ * for disabling housekeeping types.
+ *
+ * The functions bellow work the opposite way, by referencing which cpus
+ * are able to perform the housekeeping type in parameter.
+ */
+
 #ifdef CONFIG_CPU_ISOLATION
 DECLARE_STATIC_KEY_FALSE(housekeeping_overridden);
 int housekeeping_any_cpu(enum hk_type type);
-- 
2.38.0

