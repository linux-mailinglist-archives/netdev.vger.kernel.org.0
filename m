Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D2906E898C
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 07:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233840AbjDTFUq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 01:20:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233218AbjDTFUd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 01:20:33 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AADAA5FC2;
        Wed, 19 Apr 2023 22:20:01 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id 41be03b00d2f7-517c840f181so347451a12.3;
        Wed, 19 Apr 2023 22:20:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681968000; x=1684560000;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Nw654FlL6BUkwfjkIWsvpLLmEwiZB7gH0V0i7mwVLn0=;
        b=caaMCMxW9410Xn3lK3IxjlDtVt0D+8dKey3tlzaenQSmAdpDYe+tGHnk2N6G3E4hSG
         K0bM8/EQycWefdD8JSBRDuzm1L9PF8GILiLpUQK4DYmEwjouKc/kC6ZU1fmaiRfaosyC
         41YaUEBWy83LIiEvpkuzG4JVu8J+q3zIf7Rh5l7SNcAnTQ2deX97DOuJX081V7F/BUHk
         cLgDfvSRNcnBXczVvDlbpXtQusjBiergqrq5KbKUf+TOAK/E0249AFh7BJywCZWu21ko
         F53i6I4y+M9n9erQbFGlvxdttMZWwqXqQs1vkHc6Mgc+ZzFtngsk4ePBeSmSBfzVGhC/
         Ielw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681968000; x=1684560000;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Nw654FlL6BUkwfjkIWsvpLLmEwiZB7gH0V0i7mwVLn0=;
        b=fNNOA67fnNsuqfd8Osero470TICy7sJ1NKh398JPO5LjfTw6hLvAXi1OoVjNvfVFYl
         m8t4b8vNkQfRcH1to/6sjkN6Y2k/l6y1Lc4eNep/5+KKbtVs/M4yqtHolr3UJyNrCiuB
         lMgsOa36VUgqAE7yCeJ2s1eT2eqCEAQcevbRdyCutBbyKc43MsmrVS4ht2es3rpdprdU
         d7+KqWQLRPhNeVglFB3wlw0kV7qit5Zip3qwt0bj6HNRhwz3W4A7NNTMDseMuBurSHIh
         Bq5zU9Jhl+TIhwMZxTu54KXaSAJBgQ7EO0rlKovsvvjtEkJQVS5WtDjN8c7XUwDIqgWV
         CP5Q==
X-Gm-Message-State: AAQBX9clS9CAXwzE5VW4mig09HD3eR8OpSiGXseUv7AuXtbKBHAkkRQb
        PageeyvZ5yTMw4q1cWArXOQ=
X-Google-Smtp-Source: AKy350YobFSql6y5w6aBkEfFAhUb73JVMETAlJE/nTM985uHF9JUmaTDpo3tkrptRNRJu+kg0DYWlQ==
X-Received: by 2002:a17:90a:f484:b0:249:6fc1:cd76 with SMTP id bx4-20020a17090af48400b002496fc1cd76mr451011pjb.43.1681968000378;
        Wed, 19 Apr 2023 22:20:00 -0700 (PDT)
Received: from localhost ([2603:3024:e02:8500:653b:861d:e1ca:16ac])
        by smtp.gmail.com with ESMTPSA id u10-20020a63234a000000b0050be8e0b94csm264166pgm.90.2023.04.19.22.19.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 22:19:59 -0700 (PDT)
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
Subject: [PATCH v2 5/8] lib/cpumask: update comment to cpumask_local_spread()
Date:   Wed, 19 Apr 2023 22:19:43 -0700
Message-Id: <20230420051946.7463-6-yury.norov@gmail.com>
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

Now that we have a for_each_numa_cpu(), which is a more straightforward
replacement to the cpumask_local_spread() when it comes to enumeration
of CPUs with respect to NUMA topology, it's worth to update the comment.

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 lib/cpumask.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/lib/cpumask.c b/lib/cpumask.c
index e7258836b60b..151d1dc5c593 100644
--- a/lib/cpumask.c
+++ b/lib/cpumask.c
@@ -127,11 +127,8 @@ void __init free_bootmem_cpumask_var(cpumask_var_t mask)
  *
  * There's a better alternative based on for_each()-like iterators:
  *
- *	for_each_numa_hop_mask(mask, node) {
- *		for_each_cpu_andnot(cpu, mask, prev)
- *			do_something(cpu);
- *		prev = mask;
- *	}
+ *	for_each_numa_cpu(cpu, hop, node, cpu_online_mask)
+ *		do_something(cpu);
  *
  * It's simpler and more verbose than above. Complexity of iterator-based
  * enumeration is O(sched_domains_numa_levels * nr_cpu_ids), while
-- 
2.34.1

