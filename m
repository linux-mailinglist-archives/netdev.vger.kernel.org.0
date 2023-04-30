Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7D076F29DE
	for <lists+netdev@lfdr.de>; Sun, 30 Apr 2023 19:18:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230516AbjD3RSP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Apr 2023 13:18:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjD3RSN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Apr 2023 13:18:13 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91CF32706;
        Sun, 30 Apr 2023 10:18:12 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id d2e1a72fcca58-63b5465fb99so1384404b3a.1;
        Sun, 30 Apr 2023 10:18:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682875092; x=1685467092;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ISrATsmvvsI3ENm0Fz7FtfUMQfm0RxH5he0WkIT7gCc=;
        b=nZ7ewqw0Tu2rc4AgwkxP4Zdz20XibpyKqCgf1O3ShuqZVptqZOwdqbogtTz2Yh6OMQ
         Pnlu0uWIzkDmHPHp+fpo8P9VpP3DIaEfGAUQohc+FrYFNLTZNktQQjRdrRr752fJ2pgx
         P0smcRSMW+yQUOPQ2nPizjBPN+IqIbRo9qzjUuWlO3uusZtM0sCHLoBGsA3X/GWSUx2z
         e+7QtL4+PkltkS06xAG9gXE8m0dcUJCk4Pl3398MCrbmourXrxl9nvi6a/RXaOgIBMV8
         lMa9jNbK+sgUE8JY7NWxGdAag1OGJdzGz3VkDrq8hcnUvGFvViiorJk1TpuwGBwSvirH
         L8WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682875092; x=1685467092;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ISrATsmvvsI3ENm0Fz7FtfUMQfm0RxH5he0WkIT7gCc=;
        b=lUI/CwxpjxB0t7/IMPkQ9NlF9F/+tnPQUUdLmd3RduhOT/8djxUFkKeCf+UH9I6L9w
         uokcKTib76zu1ydT6axg8qvrxh4eLY/w+KjIsvpCmNwzFieFLhGTKCKArDjEWcMel59r
         z9/G1QOaU9JbGGo7IdkKgD1XRFTsNj/gxsxIce0grdBdfWVpIg8tC1AIGpQjih3jwN+T
         v1XjT/cj3lAoILRRsnwokioE4J5/CFf1k/UmBad0h7TjPdfKet/hUAcx/oFjN5s/DDl8
         R1ZC9wnLwXbDA1EuWeUooaBmcsiva3MVBCtd1SYcA/TNu3QX0+dBI5eoPpGx9cXVk/k0
         LI0A==
X-Gm-Message-State: AC+VfDx56OHU2813g4lalCq/p5laoqO0X1h+f/ad0hL5A563woryfjbC
        p82Vq14vnLXD2wrJ2sMYJ/o=
X-Google-Smtp-Source: ACHHUZ6za45Ner9fti6NewhJl6YCUe5nndq14uhC1VwFjXtEM6ix0p79dmyBbNtwZ64oIHLumai6ow==
X-Received: by 2002:a05:6a21:2d8d:b0:de:247e:d1fe with SMTP id ty13-20020a056a212d8d00b000de247ed1femr12012219pzb.1.1682875091774;
        Sun, 30 Apr 2023 10:18:11 -0700 (PDT)
Received: from localhost ([4.1.102.3])
        by smtp.gmail.com with ESMTPSA id u10-20020a62d44a000000b00637ca3eada8sm18518432pfl.6.2023.04.30.10.18.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Apr 2023 10:18:11 -0700 (PDT)
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
Subject: [PATCH v2 0/8] sched/topology: add for_each_numa_cpu() macro
Date:   Sun, 30 Apr 2023 10:18:01 -0700
Message-Id: <20230430171809.124686-1-yury.norov@gmail.com>
X-Mailer: git-send-email 2.37.2
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

v2: https://lore.kernel.org/netdev/ZD3l6FBnUh9vTIGc@yury-ThinkPad/T/
v3:
 - fix sched_numa_find_{next,nth}_cpu() when CONFIG_NUMA is off to
   only traverse online CPUs;
 - don't export sched_domains_numa_levels for testing purposes. In
   the test, use for_each_node() macro;
 - extend the test for for_each_node();
 - in comments, mention that only online CPUs are traversed;
 - rebase on top of 6.3. 

Yury Norov (8):
  sched: fix sched_numa_find_nth_cpu() in non-NUMA case
  lib/find: add find_next_and_andnot_bit()
  sched/topology: introduce sched_numa_find_next_cpu()
  sched/topology: add for_each_numa_{,online}_cpu() macro
  net: mlx5: switch comp_irqs_request() to using for_each_numa_cpu
  lib/cpumask: update comment to cpumask_local_spread()
  sched: drop for_each_numa_hop_mask()
  lib: test for_each_numa_cpus()

 drivers/net/ethernet/mellanox/mlx5/core/eq.c | 16 ++---
 include/linux/find.h                         | 43 ++++++++++++
 include/linux/topology.h                     | 40 ++++++-----
 kernel/sched/topology.c                      | 53 ++++++++-------
 lib/cpumask.c                                |  7 +-
 lib/find_bit.c                               | 12 ++++
 lib/test_bitmap.c                            | 70 +++++++++++++++++++-
 7 files changed, 183 insertions(+), 58 deletions(-)

-- 
2.37.2

