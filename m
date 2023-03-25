Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6FD56C9046
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 19:56:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231940AbjCYS4C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Mar 2023 14:56:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbjCYSz4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Mar 2023 14:55:56 -0400
Received: from mail-oa1-x2f.google.com (mail-oa1-x2f.google.com [IPv6:2001:4860:4864:20::2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2CE6AD30;
        Sat, 25 Mar 2023 11:55:35 -0700 (PDT)
Received: by mail-oa1-x2f.google.com with SMTP id 586e51a60fabf-17683b570b8so5155964fac.13;
        Sat, 25 Mar 2023 11:55:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679770535;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OSjdqRXXXgYSdBLqK0Rzny0ztxBdvMaFW0s7IjJDzbk=;
        b=P0feuUUjKXAKyCstuEoHOPmhO4TyK3/vV/+voVXCmvE98E9bJn0tcyJ4lFEM41GqWl
         liyARWM0j8ao5ZXutP/8tLQKaz69ng+85A+OqBFDQ9ElMUgFxHXQn4jzbadMPnUwoDUX
         ququAYjw8kmAsrxnSFcJY7XnAjkAAPUf/aG5n8dPY4erG+XY+0421iKjllXct/gcjOjJ
         iGUoSQECFIAMYnzCgTuaA7e4a9ZmSYDrBQMgd6rNVP55ZZZQpGngFX3DPiTDdJ8u5dWb
         ibkvbTg95xydqhVH59WKkWSVhiGGVseIW+Qc0RJWm0cAaQlHtbicU8Rs5mHZzDAdfiti
         aSwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679770535;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OSjdqRXXXgYSdBLqK0Rzny0ztxBdvMaFW0s7IjJDzbk=;
        b=iW2OoeDw8MY7iBOb62SE2T4humg8W0f+nP4hktYesuCRd8/LsvsviJHZEDAvCm4oVK
         4pLVkuidqotx1SWZfFxfkdJnrFwl/I4fKDHjKyhFBE/XzwGfOX63ykIenRaTtNkmLhWt
         DNJe5R4BhBSYgd/UxwzX2PC79Lj6mRFmXQa1q89bh9BA2SpcWsEjuQcWSzHio+r7eNqc
         e/f7LC1wzLSewjSOMPJ1tM/rcOquCqgdjwUvyI1hBjpInbUJQzJ5kxnATkPJz/Hu1Oaq
         1qr9njjcU2tx1wX6XL/ZNpS5A8+sZs5hynF/0j+Z62FClHu4Qjxx8rgRoBjKUU3/7CV9
         nxYg==
X-Gm-Message-State: AAQBX9evpSwv7RrVUCPhcdV9MsRBQ7tyF0HDqDnhVJnz6hg71Im+A+Ow
        YO2++LlMzZQ7+oKd7Tk5UE4=
X-Google-Smtp-Source: AKy350Z6M853diS04Xe9me7UO7RJvAwcsEeyUiJUMN/0kO5tO5IbkBrRFlPWIEmyOYFhSTLMzz+C4g==
X-Received: by 2002:a05:6870:e255:b0:17e:9f4c:713 with SMTP id d21-20020a056870e25500b0017e9f4c0713mr5212461oac.25.1679770534976;
        Sat, 25 Mar 2023 11:55:34 -0700 (PDT)
Received: from localhost ([12.97.180.36])
        by smtp.gmail.com with ESMTPSA id ug21-20020a0568714d1500b0017af6149e61sm8418379oab.21.2023.03.25.11.55.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Mar 2023 11:55:34 -0700 (PDT)
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
Subject: [PATCH 7/8] lib: add test for for_each_numa_{cpu,hop_mask}()
Date:   Sat, 25 Mar 2023 11:55:13 -0700
Message-Id: <20230325185514.425745-8-yury.norov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230325185514.425745-1-yury.norov@gmail.com>
References: <20230325185514.425745-1-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
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

