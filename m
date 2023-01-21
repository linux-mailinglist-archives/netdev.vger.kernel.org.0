Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4672E6763AD
	for <lists+netdev@lfdr.de>; Sat, 21 Jan 2023 05:24:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbjAUEYn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 23:24:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjAUEYl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 23:24:41 -0500
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BECE74FCF3;
        Fri, 20 Jan 2023 20:24:40 -0800 (PST)
Received: by mail-qt1-x82c.google.com with SMTP id e8so5844985qts.1;
        Fri, 20 Jan 2023 20:24:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=91fcZuIyY4pZHLtPybZ4iBZso0SxeeXvMXKXY9svhwg=;
        b=TYn7FhgOP8D6RAWzli28TBrMktadRuInALWG/3EHlqI+hrhC9AqsCTaUMdDDfO/geM
         ugems9KHeLAfzCfaAED1KeA0/4EYtvW4nsvg/ISYjXJle/zX5Z8iPLBVtiE1eE5SuP7Q
         1YfL4aQ2Rz3S0e8uQiN2mnY3bn9VlgQX7HzrRpsF2ddcr0HEwo9Fsn9bUSoQlwwtvC2A
         XJJhPEqHGjAZtNz4mWv50MpIf/l647nJ+5dsfVl9wkudBkF/+HwCJoOIMH7OPiQOxBwG
         ji+K56I9UNN7YAGFuSaRajutULSV4Nwn8RwxDkRJPbs+SgvF4eys7Qv5jY4qqJEcvAI6
         UCxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=91fcZuIyY4pZHLtPybZ4iBZso0SxeeXvMXKXY9svhwg=;
        b=Lu2ng4NRtCVFvwY7gizsk4mhG2Jcf4Rza2OWAIFdtqMCEI0PgF2kUg09JoRLoudhLw
         85Ox49UajhLjm4W8ar8ImZd4l1TBhDSw9DzRK2R9vXRSul58BNVSnFfhL8lqxT0qvG2L
         SG0+EMiCKxg78OnxxQu7Xii2XHRI/2Yfpahxl97I80uM1zmnJ7xZ686kgJjxTuhd74kz
         dS6z0JN1n3rbprXhHYhRWlAbpqjh0Qm+X7BCb7OcJwRVYrkj+29FbOJJBMmVG1YmuI9F
         5HwQL/ldWF/kjkoqk+XXzVc0BiJ2ERZ6J+9H3JCkEaT5oKkAPyGbwcMwDViptYbDOa3W
         ACuQ==
X-Gm-Message-State: AFqh2kollBtbtQCU1wuGZOsd4weK/kVGYIjCBZsNUjjHCc2puhivOLrq
        sXGuGGRDR3UrbY8DX0A8FMYJu4MpqQQ=
X-Google-Smtp-Source: AMrXdXtHV93SXALMJdUy74F85umEqgiaVe3MJYMSm4sAzp0VOQsSkypwtmZcuWd2QyrlP8eCoDqd6Q==
X-Received: by 2002:ac8:44ac:0:b0:3ae:4e47:52d7 with SMTP id a12-20020ac844ac000000b003ae4e4752d7mr22718279qto.38.1674275079012;
        Fri, 20 Jan 2023 20:24:39 -0800 (PST)
Received: from localhost (50-242-44-45-static.hfc.comcastbusiness.net. [50.242.44.45])
        by smtp.gmail.com with ESMTPSA id v7-20020a05620a440700b006fb112f512csm27622452qkp.74.2023.01.20.20.24.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Jan 2023 20:24:38 -0800 (PST)
From:   Yury Norov <yury.norov@gmail.com>
To:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Barry Song <baohua@kernel.org>,
        Ben Segall <bsegall@google.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Gal Pressman <gal@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Haniel Bristot de Oliveira <bristot@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>,
        Peter Lafreniere <peter@n8pjl.ca>,
        Peter Zijlstra <peterz@infradead.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Tariq Toukan <ttoukan.linux@gmail.com>,
        Tony Luck <tony.luck@intel.com>,
        Valentin Schneider <vschneid@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>
Cc:     Yury Norov <yury.norov@gmail.com>, linux-crypto@vger.kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [PATCH RESEND 0/9] sched: cpumask: improve on cpumask_local_spread() locality
Date:   Fri, 20 Jan 2023 20:24:27 -0800
Message-Id: <20230121042436.2661843-1-yury.norov@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

cpumask_local_spread() currently checks local node for presence of i'th
CPU, and then if it finds nothing makes a flat search among all non-local
CPUs. We can do it better by checking CPUs per NUMA hops.

This has significant performance implications on NUMA machines, for example
when using NUMA-aware allocated memory together with NUMA-aware IRQ
affinity hints.

Performance tests from patch 8 of this series for mellanox network
driver show:

  TCP multi-stream, using 16 iperf3 instances pinned to 16 cores (with aRFS on).
  Active cores: 64,65,72,73,80,81,88,89,96,97,104,105,112,113,120,121
  
  +-------------------------+-----------+------------------+------------------+
  |                         | BW (Gbps) | TX side CPU util | RX side CPU util |
  +-------------------------+-----------+------------------+------------------+
  | Baseline                | 52.3      | 6.4 %            | 17.9 %           |
  +-------------------------+-----------+------------------+------------------+
  | Applied on TX side only | 52.6      | 5.2 %            | 18.5 %           |
  +-------------------------+-----------+------------------+------------------+
  | Applied on RX side only | 94.9      | 11.9 %           | 27.2 %           |
  +-------------------------+-----------+------------------+------------------+
  | Applied on both sides   | 95.1      | 8.4 %            | 27.3 %           |
  +-------------------------+-----------+------------------+------------------+
  
  Bottleneck in RX side is released, reached linerate (~1.8x speedup).
  ~30% less cpu util on TX.

This series was supposed to be included in v6.2, but that didn't happen. It
spent enough in -next without any issues, so I hope we'll finally see it
in v6.3.

I believe, the best way would be moving it with scheduler patches, but I'm
OK to try again with bitmap branch as well.

Tariq Toukan (1):
  net/mlx5e: Improve remote NUMA preferences used for the IRQ affinity
    hints

Valentin Schneider (2):
  sched/topology: Introduce sched_numa_hop_mask()
  sched/topology: Introduce for_each_numa_hop_mask()

Yury Norov (6):
  lib/find: introduce find_nth_and_andnot_bit
  cpumask: introduce cpumask_nth_and_andnot
  sched: add sched_numa_find_nth_cpu()
  cpumask: improve on cpumask_local_spread() locality
  lib/cpumask: reorganize cpumask_local_spread() logic
  lib/cpumask: update comment for cpumask_local_spread()

 drivers/net/ethernet/mellanox/mlx5/core/eq.c | 18 +++-
 include/linux/cpumask.h                      | 20 +++++
 include/linux/find.h                         | 33 +++++++
 include/linux/topology.h                     | 33 +++++++
 kernel/sched/topology.c                      | 90 ++++++++++++++++++++
 lib/cpumask.c                                | 52 ++++++-----
 lib/find_bit.c                               |  9 ++
 7 files changed, 230 insertions(+), 25 deletions(-)

-- 
2.34.1

