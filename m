Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8E7C6E2F1C
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 07:06:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbjDOFG2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Apr 2023 01:06:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjDOFGZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Apr 2023 01:06:25 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AA105FC6;
        Fri, 14 Apr 2023 22:06:21 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id 98e67ed59e1d1-24704a7bf34so743887a91.1;
        Fri, 14 Apr 2023 22:06:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681535180; x=1684127180;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4outNeWTpKnHS1tnIqaAxG4LTg3nQXw/XvITsujeCUo=;
        b=G3X6TIMiuLMxETVVWqIC6vA5pu2tdtCdVQlQTiDn5HaEYxMnUU6R44aIC/fho04igi
         6Q5qKTveX1vx7Y6IpqNk5oKv49WanoW87ZatCx7Ch+Awyt77bcI5+t83yutT1p7pIg6t
         D4t/mxDzzCUx9SjVXEnmhHWdslPmDSBnB5V0XVedn2ObHsA+OjliUkz+8qOA+0Hk0CsA
         YWRMyzT0QO55cUrRp3jWypSLc1+OGOLdSctEmzKC2fazZIQEhYubTXR1y4fb6pu0Z2jz
         LCS1c1Jor2V0qOieqagC574Dhyi+7O+WiXMklc1FDo3DdqqCQytA/GhCmljCs2sLi+nM
         Ll5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681535180; x=1684127180;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4outNeWTpKnHS1tnIqaAxG4LTg3nQXw/XvITsujeCUo=;
        b=WeMvb2Kehkrog8q6Oq+YKw55nOt4jQdYdh942mWM3gJN6LdVaPzxPOjXuOQjFFo6+V
         HJgk/Mq9AQdHoNm8ag2Iop009o+UJvb1N2Bg0dIqzor8a20dj5zklWC+bRlW2a7ojBdB
         Bf3uEgdKAGbV+dwNHVeu7faNr4rgNtXgBS9dVpC5CB/6oz4Fo2i8NdMeR9dyVm5lmEkn
         XAC0Blw+yT17u9C+CamjkyftR9qbU0vLNnBbz/W+2uqj7VL+NZNTb+0QZn64QgFWpS+/
         kQhRMUEuLPGmAdX0YvrZUvFPlNa8qUXak1fC6uNrkEAR9gFD27nhwp27mCrPBalVjA+9
         wx7w==
X-Gm-Message-State: AAQBX9f4NeecoAuJP4ZxLTz8gV2Xd7W1Ano+fKKsmrSav2H4mnfrGDW2
        mXJuMkwexF26D0IGGzlslsA=
X-Google-Smtp-Source: AKy350ZuMT4Y/RmGzcyjt11dR3WV+dvye8DegNtm7l0swicWf4n6G0fp8+JcO/p6KMFHGhBW+QtHKA==
X-Received: by 2002:a05:6a00:1892:b0:627:fb40:7cb4 with SMTP id x18-20020a056a00189200b00627fb407cb4mr10782790pfh.30.1681535180391;
        Fri, 14 Apr 2023 22:06:20 -0700 (PDT)
Received: from localhost ([2601:646:200:6ab0:b18c:e581:87ef:6790])
        by smtp.gmail.com with ESMTPSA id x20-20020a62fb14000000b005abc0d426c4sm3824805pfm.54.2023.04.14.22.06.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Apr 2023 22:06:19 -0700 (PDT)
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
Date:   Fri, 14 Apr 2023 22:06:09 -0700
Message-Id: <20230415050617.324288-1-yury.norov@gmail.com>
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

