Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A54D56C9034
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 19:55:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbjCYSz0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Mar 2023 14:55:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjCYSzY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Mar 2023 14:55:24 -0400
Received: from mail-oo1-xc33.google.com (mail-oo1-xc33.google.com [IPv6:2607:f8b0:4864:20::c33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BFB18A6B;
        Sat, 25 Mar 2023 11:55:23 -0700 (PDT)
Received: by mail-oo1-xc33.google.com with SMTP id m6-20020a4ae846000000b0053b9059edd5so769751oom.3;
        Sat, 25 Mar 2023 11:55:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679770522;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XxsSLWsZvE4szM1gEt4f7Si5Kl8ROd3jLoMcKM80+58=;
        b=ACIVRz7GnOs5oqbTqChVW3js3iaTUMeheAjffOsvQQT+TiZxhdiDJvLOdXt/Wtf+hL
         X/Bdz8hXYA9M1pprtPNkKdcylg+fuJbmTEon5FMYeEGe+AY+ejQg+7T1dx5vt13qpI9C
         wa6Xj9ZInQzBW5d8RdpJq1nZrDrkG8tArPs+YC2oYQw/Y3fRtdlMJ3RoqZAfLoTI7UPo
         lK63d26Sz16K1e2eVeCQY7UBC44djm0OP3+o0FDNwohLwc8JSF2Wx/5GdBV8nS+X2WPR
         QCGSJHPlzkU3YDsgGJlbzk4frhRMkzhbwGRWfoqRpBtWvR6O+dE06n/i9TgL4TkhBu2T
         WQaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679770522;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XxsSLWsZvE4szM1gEt4f7Si5Kl8ROd3jLoMcKM80+58=;
        b=piCSuk3ZIpuhUYcxtWLNi8r3tx6yru/qCyC10Rkbo6ErJoskPZ/pX6ojZNjceBX4p/
         D5Obx3wtGiRH2gU7yiRPG+pPDN3E4uDxOTwgQefCaHaJlfK31aOO/XsOzx1ZIDqJLpLV
         RQEXo3knNhgN41ZAu5HcLRzeLD2YSfhMjcvIIMLvQvr8Ub3B28KayNdImbsVJUjF7CKL
         DojwDpW5NSPjPy+w+j6Xs0oSa2h3cCnbdKH8CY82pJDY3APyynYPbL8Ikb1yLGoV4rse
         TiU3RUIfneQnxz4zjrAayM8P9NXnAao7D5lv2DET6dcAkw0TC+dNI2PGTaWvWgMERFHu
         WO1g==
X-Gm-Message-State: AO0yUKUOr/zBq3rO73cEvuZxO7n/Jjs88fO1aK3/Vig1kLsNnYXiVu62
        WxMTyjWYHrMNZy7K4uqQvSk=
X-Google-Smtp-Source: AK7set+cb4Ku/IGSZgPqrYUrD0OTrQhX+nWmO6TmeK9Q4sOdCEFg9T1Hgh5qs74QwEPGqxBpSEpYXw==
X-Received: by 2002:a4a:4111:0:b0:517:4020:60b6 with SMTP id x17-20020a4a4111000000b00517402060b6mr3596459ooa.8.1679770522550;
        Sat, 25 Mar 2023 11:55:22 -0700 (PDT)
Received: from localhost ([12.97.180.36])
        by smtp.gmail.com with ESMTPSA id e20-20020a4a8f14000000b0053dfd96fa61sm1760679ool.39.2023.03.25.11.55.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Mar 2023 11:55:22 -0700 (PDT)
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
Subject: [PATCH 0/8] sched/topology: add for_each_numa_cpu() macro
Date:   Sat, 25 Mar 2023 11:55:06 -0700
Message-Id: <20230325185514.425745-1-yury.norov@gmail.com>
X-Mailer: git-send-email 2.34.1
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

for_each_cpu() is widely used in kernel, and it's beneficial to create
a NUMA-aware version of the macro.

Recently added for_each_numa_hop_mask() works, but switching existing
codebase to it is not an easy process.

This series adds for_each_numa_cpu(), which is designed to be similar to
the for_each_cpu(). It allows to convert existing code to NUMA-aware as
simple as adding a hop iterator variable and passing it inside new macro.
for_each_numa_cpu() takes care of the rest.

At the moment, we have 2 users of NUMA-aware enumerators. One is
Melanox's in-tree driver, and another is Intel's in-review driver:

https://lore.kernel.org/lkml/20230216145455.661709-1-pawel.chmielewski@intel.com/

Both real-life examples follow the same pattern:

	for_each_numa_hop_mask(cpus, prev, node) {
 		for_each_cpu_andnot(cpu, cpus, prev) {
 			if (cnt++ == max_num)
 				goto out;
 			do_something(cpu);
 		}
		prev = cpus;
 	}

With the new macro, it has a more standard look, like this:

	for_each_numa_cpu(cpu, hop, node, cpu_possible_mask) {
		if (cnt++ == max_num)
			break;
		do_something(cpu);
 	}

Straight conversion of existing for_each_cpu() codebase to NUMA-aware
version with for_each_numa_hop_mask() is difficult because it doesn't
take a user-provided cpu mask, and eventually ends up with open-coded
double loop. With for_each_numa_cpu() it shouldn't be a brainteaser.
Consider the NUMA-ignorant example:

	cpumask_t cpus = get_mask();
	int cnt = 0, cpu;

	for_each_cpu(cpu, cpus) {
		if (cnt++ == max_num)
			break;
		do_something(cpu);
 	}

Converting it to NUMA-aware version would be as simple as:

	cpumask_t cpus = get_mask();
	int node = get_node();
	int cnt = 0, hop, cpu;

	for_each_numa_cpu(cpu, hop, node, cpus) {
		if (cnt++ == max_num)
			break;
		do_something(cpu);
 	}

The latter looks more verbose and avoids from open-coding that annoying
double loop. Another advantage is that it works with a 'hop' parameter with
the clear meaning of NUMA distance, and doesn't make people not familiar
to enumerator internals bothering with current and previous masks machinery.

Yury Norov (8):
  lib/find: add find_next_and_andnot_bit()
  sched/topology: introduce sched_numa_find_next_cpu()
  sched/topology: add for_each_numa_cpu() macro
  net: mlx5: switch comp_irqs_request() to using for_each_numa_cpu
  lib/cpumask: update comment to cpumask_local_spread()
  sched/topology: export sched_domains_numa_levels
  lib: add test for for_each_numa_{cpu,hop_mask}()
  sched: drop for_each_numa_hop_mask()

 drivers/net/ethernet/mellanox/mlx5/core/eq.c | 16 ++----
 include/linux/find.h                         | 43 ++++++++++++++
 include/linux/topology.h                     | 39 ++++++++-----
 kernel/sched/topology.c                      | 59 +++++++++++---------
 lib/cpumask.c                                |  7 +--
 lib/find_bit.c                               | 12 ++++
 lib/test_bitmap.c                            | 16 ++++++
 7 files changed, 136 insertions(+), 56 deletions(-)

-- 
2.34.1

