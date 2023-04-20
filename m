Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECB2D6E897D
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 07:19:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232005AbjDTFTy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 01:19:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjDTFTv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 01:19:51 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9B5B1FE4;
        Wed, 19 Apr 2023 22:19:50 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id d2e1a72fcca58-63b5c830d5eso528681b3a.2;
        Wed, 19 Apr 2023 22:19:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681967990; x=1684559990;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4outNeWTpKnHS1tnIqaAxG4LTg3nQXw/XvITsujeCUo=;
        b=BBGZ4OO6kAYZLEPRYetBAAwTCCkt7alcHeEVMYp55BnX8kTmU203tAwI7LElcjn3gI
         2lMdEPsboI+7nkgyss/IP5wqXS+Ife3tm6OAeVBlq71cwidlhwN0CwYwqFeKJVC6Z329
         FgZlxWYNgzmiHMjn7jSJ8Z52QMvtWOe6lJO+bsbWR1vIDG0nZ9VPnf5ReHFF621aAD1B
         /O46YZGI/W1ycNahgzkdpCiO65eABeJZFidseZ4bo+TaaZwArfi6Ya9DbmzuBSkq+AcR
         rGHO8UzhW42Jlconb4WvvGTWgZwP66iStlzwhPHLIuCaWJmy2kAlVbAOloLdknGb8827
         YkKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681967990; x=1684559990;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4outNeWTpKnHS1tnIqaAxG4LTg3nQXw/XvITsujeCUo=;
        b=a3T25CNtt2IGz9De11TtveaafkheN+SDfX3roJipTzcNvVyEIRtfczMNbjtqws22oy
         5d8T8rnurIyoU8sotPOXIopVIUhkZPYOXK4krlmqT8iYdLE7u1N+gJZvwV7Bh2xXfjLV
         qcXwdtnOvVAsczpAT2nMJ568A0Z+/+3BGFfK+v8RZskof4khGxiFd7nG6zpHfMASfe3u
         XtLXOf7NyIPxyr3OtSEzeO5pgnYw0vKF2fCacLzR4AlgCW9FvOz2JboufH1W4ho68v08
         +P3HXZLVSM9Q4DjSiS90352LmnPUh80GKyw1Y3TOrFZ16Kd+lORDOGYcCnb9V54Db9+A
         0ADw==
X-Gm-Message-State: AAQBX9fpIoa93QlYy8CFlP91TnteUPdHiLHY5iJOJmqhdV+47ZvJwbVz
        +XAQfzH8Hf3SwJD8tZI6AxQ=
X-Google-Smtp-Source: AKy350YauRH4aUzxKkYhAVMol5EgAE+vHwfe3mTSyfimswNnRssMrJ/+0om9/Rson9lPp25PrTQRGA==
X-Received: by 2002:a05:6a00:248f:b0:63d:23a7:ca62 with SMTP id c15-20020a056a00248f00b0063d23a7ca62mr7338060pfv.19.1681967990158;
        Wed, 19 Apr 2023 22:19:50 -0700 (PDT)
Received: from localhost ([2603:3024:e02:8500:653b:861d:e1ca:16ac])
        by smtp.gmail.com with ESMTPSA id h11-20020a056a00218b00b0063b8ada8777sm302948pfi.112.2023.04.19.22.19.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 22:19:48 -0700 (PDT)
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
Date:   Wed, 19 Apr 2023 22:19:38 -0700
Message-Id: <20230420051946.7463-1-yury.norov@gmail.com>
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

v2:
 - repase on top of master;
 - cleanup comments and tweak them to comply with kernel-doc;
 - remove RFC from patch #8 as there's no objections.

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
 include/linux/topology.h                     | 37 ++++++------
 kernel/sched/topology.c                      | 59 +++++++++++---------
 lib/cpumask.c                                |  7 +--
 lib/find_bit.c                               | 12 ++++
 lib/test_bitmap.c                            | 16 ++++++
 7 files changed, 133 insertions(+), 57 deletions(-)

-- 
2.34.1

