Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 799B06E898F
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 07:20:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233803AbjDTFUu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 01:20:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233806AbjDTFUe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 01:20:34 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79D1959E5;
        Wed, 19 Apr 2023 22:20:03 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id d2e1a72fcca58-63d2ba63dddso546881b3a.2;
        Wed, 19 Apr 2023 22:20:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681968002; x=1684560002;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5usMpMDqVoc+ecsOtKE0Gtse+UU2DDnssjHsHE2rpV0=;
        b=EnspSQAPrQqvWP+FClFMlSsz4VeavJqTqfuNfrU+p2/isyACrtZ764pJLdjUFPzs5q
         UvF3NfeCiJDVsO5DlCEpMzHtuVnGBsOUFvM3TSWzDcJG3RoCMSu3mscfmG8pgNiwknSR
         KwludEpAlxzeEyNH332D4kslC3vmd1m3vOlhS1WFXmnJvy4oq27/VZ8NkvK9UIgodzvc
         vNW0Iu/hLrvQY43etyy/Vdb+8Ci7Advv7qfjpaiNxdSeiTdQWgOzAHJWNVg+s9ipU6SX
         KL5BcnTB7cFk9pO5HTzzUNYwx2YeBsZz0YO3k1rixwFp1S26i3/Za4AQacktEllyzGJH
         1isg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681968002; x=1684560002;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5usMpMDqVoc+ecsOtKE0Gtse+UU2DDnssjHsHE2rpV0=;
        b=LkyB3dJ+gj9yx+K78aMVzF2gmjoX9OOrT67a1/lf5rgkRXwOWXyTt6WfRKs5buS6KR
         6iOB3sG1mQYjyk+8vjhSFmPTNOGyw2O06zi1gJT1il340kGNlSG/eph/wnPqrlBG6v+W
         tL53n9Fr3z9lFTHi1rcj1vJKCDL8cimQGMDGCa4L4Qg+Dm1dPALjm+hedD4MKJrA1UBB
         8BzScgre2Xs5Yx97iNbIwUa3kSp0AdpWH0DaB3bcsUG0MlIlijAEpnu3vBipdgGg4/Sf
         baJcGcQXuZ2XfyqP48Z2ZTek+nruaeEz5yV1snQUXGK42nMQ/NaWGAXFLV46qO90oZnR
         1Utw==
X-Gm-Message-State: AAQBX9cbWBaBTuHdIt0gzckPS8wWBRABryNLaJzUuo99l0zDvAyjADLr
        8sswotkyW2RZXsrYf1PHp8I=
X-Google-Smtp-Source: AKy350ZLX/cyqSBWzXE4XimpTZQpxiv+d9PhS6FwmYV5K0k7VFzQCqizXvgPPsjRknrgkYMSCpMY5Q==
X-Received: by 2002:a05:6a20:8e13:b0:f1:bea6:a319 with SMTP id y19-20020a056a208e1300b000f1bea6a319mr548168pzj.25.1681968002080;
        Wed, 19 Apr 2023 22:20:02 -0700 (PDT)
Received: from localhost ([2603:3024:e02:8500:653b:861d:e1ca:16ac])
        by smtp.gmail.com with ESMTPSA id m11-20020a63580b000000b0051322a5aa64sm295875pgb.3.2023.04.19.22.20.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 22:20:01 -0700 (PDT)
From:   Yury Norov <yury.norov@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Yury Norov <yury.norov@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Pawel Chmielewski <pawel.chmielewski@intel.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Valentin Schneider <vschneid@redhat.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Barry Song <baohua@kernel.org>
Subject: [PATCH v2 6/8] sched/topology: export sched_domains_numa_levels
Date:   Wed, 19 Apr 2023 22:19:44 -0700
Message-Id: <20230420051946.7463-7-yury.norov@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230420051946.7463-1-yury.norov@gmail.com>
References: <20230420051946.7463-1-yury.norov@gmail.com>
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

The following patch adds a test for NUMA-aware CPU enumerators, and it
requires an access to sched_domains_numa_levels.

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 include/linux/topology.h |  7 +++++++
 kernel/sched/topology.c  | 10 ++++++----
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/include/linux/topology.h b/include/linux/topology.h
index 01fb3a55d7ce..7ebcc886dc76 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -43,6 +43,13 @@
 	for_each_online_node(node)			\
 		if (nr_cpus_node(node))
 
+#ifdef CONFIG_NUMA
+extern int __sched_domains_numa_levels;
+#define sched_domains_numa_levels ((const int)__sched_domains_numa_levels)
+#else
+#define sched_domains_numa_levels (1)
+#endif
+
 int arch_update_cpu_topology(void);
 
 /* Conform to ACPI 2.0 SLIT distance definitions */
diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index fc163e4181e6..56daa279c411 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -1508,7 +1508,9 @@ static void claim_allocations(int cpu, struct sched_domain *sd)
 #ifdef CONFIG_NUMA
 enum numa_topology_type sched_numa_topology_type;
 
-static int			sched_domains_numa_levels;
+int				__sched_domains_numa_levels;
+EXPORT_SYMBOL_GPL(__sched_domains_numa_levels);
+
 static int			sched_domains_curr_level;
 
 int				sched_max_numa_distance;
@@ -1872,7 +1874,7 @@ void sched_init_numa(int offline_node)
 	 *
 	 * We reset it to 'nr_levels' at the end of this function.
 	 */
-	sched_domains_numa_levels = 0;
+	__sched_domains_numa_levels = 0;
 
 	masks = kzalloc(sizeof(void *) * nr_levels, GFP_KERNEL);
 	if (!masks)
@@ -1948,7 +1950,7 @@ void sched_init_numa(int offline_node)
 	sched_domain_topology_saved = sched_domain_topology;
 	sched_domain_topology = tl;
 
-	sched_domains_numa_levels = nr_levels;
+	__sched_domains_numa_levels = nr_levels;
 	WRITE_ONCE(sched_max_numa_distance, sched_domains_numa_distance[nr_levels - 1]);
 
 	init_numa_topology_type(offline_node);
@@ -1961,7 +1963,7 @@ static void sched_reset_numa(void)
 	struct cpumask ***masks;
 
 	nr_levels = sched_domains_numa_levels;
-	sched_domains_numa_levels = 0;
+	__sched_domains_numa_levels = 0;
 	sched_max_numa_distance = 0;
 	sched_numa_topology_type = NUMA_DIRECT;
 	distances = sched_domains_numa_distance;
-- 
2.34.1

