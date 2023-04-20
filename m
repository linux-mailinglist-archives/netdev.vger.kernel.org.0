Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23A856E8992
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 07:21:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233887AbjDTFVJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 01:21:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233819AbjDTFUh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 01:20:37 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 051AC61AB;
        Wed, 19 Apr 2023 22:20:04 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id d9443c01a7336-1a6c5acf6ccso5829165ad.3;
        Wed, 19 Apr 2023 22:20:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681968004; x=1684560004;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OSjdqRXXXgYSdBLqK0Rzny0ztxBdvMaFW0s7IjJDzbk=;
        b=Ybxwe0Yed6TDQbZt4P4jJnwzwNYoazEymPMwfm7y2iWBuo10gwWPCtJXLWAI2jp88R
         7G/ZrXA4ugRV40R+HD8eK6Uqf+RCesq67q/t+Fgb94vuYbz193xfsE9pcylZrhvDYkyO
         4+r+C0yP0GYVslLqpFnHTmKKReOrIkrmSY9ZT/0/4F6Np20g+kPjTVTbGC9/OMCQ/7gc
         +kZllz8/kI893xCtYA+nPmryHa1BfbJTqxI0b+jkyUlgRvFVLDmRYztiohR6fCgWqXii
         ZsnoBGWw9v+EgD0Ae5WNtPCYiQahOybJSXPdCl4kazJ1X4mZqTHy3wLcH3n9ofx5Rn21
         KqVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681968004; x=1684560004;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OSjdqRXXXgYSdBLqK0Rzny0ztxBdvMaFW0s7IjJDzbk=;
        b=HauaI6ZWqKCYXs68jAM9390TmX3LB3RkbKdara/+suRee709/qHalqaZsb11/25cmb
         zQaHgJf8HfbxfWa8enSHYzDTyY7Ts/IfeI4kcgl6RrKTKQLUMZ50dw/X4e9Ql2+/JRBa
         EKouCmLYO5FqUFQvLcwaOoSiNeDkeI3zBiB+LZyaNQCgAU3ynbBgiifxVesdStLJyI/k
         cwSI+V6DZhvTr4Arb0Le6pi/2leGDi0KG8gA/Cdx2kV1LjdipjXhkU+CXKaw5mo95OnK
         /HpH0LnVqcF5IvETfMuolxgjVdqub7IzpXXwlg0EQqJNH0Wb9UloElvknWjYjtcBt43g
         B82g==
X-Gm-Message-State: AAQBX9ei5KB6/pCS54HvPbEiWBVZRWDT1+wa101sbpbjfzRUvKbsWq35
        wJdnfP20xDOcwf/5R70GpFw=
X-Google-Smtp-Source: AKy350b9F8rpx7c4FugyLgTAE7jTlFSaz/LBmY7KHzcDVTxRnpAbBd/hzTt8vapTV+lrjWJcstWGQw==
X-Received: by 2002:a17:902:ce88:b0:19d:1834:92b9 with SMTP id f8-20020a170902ce8800b0019d183492b9mr316932plg.56.1681968004129;
        Wed, 19 Apr 2023 22:20:04 -0700 (PDT)
Received: from localhost ([2603:3024:e02:8500:653b:861d:e1ca:16ac])
        by smtp.gmail.com with ESMTPSA id gq3-20020a17090b104300b0024b4a06a4fesm167781pjb.5.2023.04.19.22.20.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 22:20:03 -0700 (PDT)
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
Subject: [PATCH v2 7/8] lib: add test for for_each_numa_{cpu,hop_mask}()
Date:   Wed, 19 Apr 2023 22:19:45 -0700
Message-Id: <20230420051946.7463-8-yury.norov@gmail.com>
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

The test ensures that enumerators' output is consistent with
cpumask_local_spread().

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 lib/test_bitmap.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/lib/test_bitmap.c b/lib/test_bitmap.c
index a8005ad3bd58..1b5f805f6879 100644
--- a/lib/test_bitmap.c
+++ b/lib/test_bitmap.c
@@ -12,6 +12,7 @@
 #include <linux/printk.h>
 #include <linux/slab.h>
 #include <linux/string.h>
+#include <linux/topology.h>
 #include <linux/uaccess.h>
 
 #include "../tools/testing/selftests/kselftest_module.h"
@@ -751,6 +752,33 @@ static void __init test_for_each_set_bit_wrap(void)
 	}
 }
 
+static void __init test_for_each_numa(void)
+{
+	unsigned int cpu, node;
+
+	for (node = 0; node < sched_domains_numa_levels; node++) {
+		const struct cpumask *m, *p = cpu_none_mask;
+		unsigned int c = 0;
+
+		rcu_read_lock();
+		for_each_numa_hop_mask(m, node) {
+			for_each_cpu_andnot(cpu, m, p)
+				expect_eq_uint(cpumask_local_spread(c++, node), cpu);
+			p = m;
+		}
+		rcu_read_unlock();
+	}
+
+	for (node = 0; node < sched_domains_numa_levels; node++) {
+		unsigned int hop, c = 0;
+
+		rcu_read_lock();
+		for_each_numa_cpu(cpu, hop, node, cpu_online_mask)
+			expect_eq_uint(cpumask_local_spread(c++, node), cpu);
+		rcu_read_unlock();
+	}
+}
+
 static void __init test_for_each_set_bit(void)
 {
 	DECLARE_BITMAP(orig, 500);
@@ -1237,6 +1265,7 @@ static void __init selftest(void)
 	test_for_each_clear_bitrange_from();
 	test_for_each_set_clump8();
 	test_for_each_set_bit_wrap();
+	test_for_each_numa();
 }
 
 KSTM_MODULE_LOADERS(test_bitmap);
-- 
2.34.1

