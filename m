Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F166626B21
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 20:09:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234974AbiKLTJx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Nov 2022 14:09:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230170AbiKLTJv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Nov 2022 14:09:51 -0500
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDB7517E30;
        Sat, 12 Nov 2022 11:09:50 -0800 (PST)
Received: by mail-qk1-x729.google.com with SMTP id p18so5223721qkg.2;
        Sat, 12 Nov 2022 11:09:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7d2DeMwIv7xGzs3K0k3aDYoBbKn47/eVccZLRTDD5k0=;
        b=grKF04adVSoE91BbUQqXZn6Fw8cfovF/AFby+zoJaMHGv5a0lvyPNcEQKLXAUnB1cr
         W213E5tFCb6VM3rdX/j5i8Udx3xM/sJhxPOX5RZ9eGYPmFGunuYYSLfZJuRMhclE7Jif
         MzS4+6v8tmVfcZDNGgZjOh/uREOsa6G5iqDxUHN2Hm9BJdQyhbKhuuVLPncvdWyYfGLY
         5OR4LakMlUxolRikG1JJVAM1cIA5ybM/1pehwL9h0D0mMEAI7g1TYWHUC6Rl4LBPw/J3
         cAnzJZiLccPKwFti7znTuNp8rTjq4THH4DOx/KggDKYzwWVb/lXKTJIiB+SMUCmlyYN8
         B0wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7d2DeMwIv7xGzs3K0k3aDYoBbKn47/eVccZLRTDD5k0=;
        b=ANkSqf2yY1IY8XPz5C4kqibKkxw1LrQuDpvwqdZQNZc/IFpqMV556XjiOJbY8S7hk5
         w+EIEMFbEC8xLguuznbB7mGFDB+BS+7TnJ2orNzpneHJ0Bep7XgBX3hnmC7oyzA5xnjV
         l/P6jIB0FH+P6JygaGIkCKc0uv7gG5jhQZINTmY+bQ4ocQyc6N0v8Ab43tijQw1hMdHA
         Ux72qwQAx1Y7+AylSH5mDEtOW2w/tD82Hu9Ohzug5IA4uDUKd2GhRc/Px4SFm3jY8LWU
         ncpWHx6cRooId4xVx6X4LyFYgwngj1P1yGVoFh9MRRtvg1ljHpjw3k3F8hcttM0jJZE3
         EaZg==
X-Gm-Message-State: ANoB5pnmk0OJ4lp4EgpK7Rg7R/1milCJqGhu2fkc0O3SS4Bl7rzQ6P/C
        7ztu6z0qrViSGJqNlldUY7nbgoktnDk=
X-Google-Smtp-Source: AA0mqf416Qa+kUiFb8TUpoMAQuikXcCFQuqeJxlh33Gl9IJjr+BJ/ihDOkSYdW1iqb9/1t6Rw/l1iw==
X-Received: by 2002:a05:620a:d84:b0:6fa:937f:61d4 with SMTP id q4-20020a05620a0d8400b006fa937f61d4mr5652984qkl.280.1668280189645;
        Sat, 12 Nov 2022 11:09:49 -0800 (PST)
Received: from localhost (user-24-236-74-177.knology.net. [24.236.74.177])
        by smtp.gmail.com with ESMTPSA id f7-20020ac84707000000b003995f6513b9sm3111019qtp.95.2022.11.12.11.09.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Nov 2022 11:09:49 -0800 (PST)
From:   Yury Norov <yury.norov@gmail.com>
To:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Barry Song <baohua@kernel.org>,
        Ben Segall <bsegall@google.com>,
        haniel Bristot de Oliveira <bristot@redhat.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Gal Pressman <gal@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Mel Gorman <mgorman@suse.de>,
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
Subject: [PATCH v2 0/4] cpumask: improve on cpumask_local_spread() locality
Date:   Sat, 12 Nov 2022 11:09:42 -0800
Message-Id: <20221112190946.728270-1-yury.norov@gmail.com>
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

This series is inspired by Tariq Toukan and Valentin Schneider's "net/mlx5e:
Improve remote NUMA preferences used for the IRQ affinity hints"

https://patchwork.kernel.org/project/netdevbpf/patch/20220728191203.4055-3-tariqt@nvidia.com/

According to their measurements, for mlx5e:

        Bottleneck in RX side is released, reached linerate (~1.8x speedup).
        ~30% less cpu util on TX.

This patch makes cpumask_local_spread() traversing CPUs based on NUMA
distance, just as well, and I expect comparabale improvement for its
users, as in case of mlx5e.

I tested new behavior on my VM with the following NUMA configuration:

root@debian:~# numactl -H
available: 4 nodes (0-3)
node 0 cpus: 0 1 2 3
node 0 size: 3869 MB
node 0 free: 3740 MB
node 1 cpus: 4 5
node 1 size: 1969 MB
node 1 free: 1937 MB
node 2 cpus: 6 7
node 2 size: 1967 MB
node 2 free: 1873 MB
node 3 cpus: 8 9 10 11 12 13 14 15
node 3 size: 7842 MB
node 3 free: 7723 MB
node distances:
node   0   1   2   3
  0:  10  50  30  70
  1:  50  10  70  30
  2:  30  70  10  50
  3:  70  30  50  10

And the cpumask_local_spread() for each node and offset traversing looks
like this:

node 0:   0   1   2   3   6   7   4   5   8   9  10  11  12  13  14  15
node 1:   4   5   8   9  10  11  12  13  14  15   0   1   2   3   6   7
node 2:   6   7   0   1   2   3   8   9  10  11  12  13  14  15   4   5
node 3:   8   9  10  11  12  13  14  15   4   5   6   7   0   1   2   3

v1: https://lore.kernel.org/lkml/20221111040027.621646-5-yury.norov@gmail.com/T/
v2: 
 - use bsearch() in sched_numa_find_nth_cpu();
 - fix missing 'static inline' in 3rd patch.

Yury Norov (4):
  lib/find: introduce find_nth_and_andnot_bit
  cpumask: introduce cpumask_nth_and_andnot
  sched: add sched_numa_find_nth_cpu()
  cpumask: improve on cpumask_local_spread() locality

 include/linux/cpumask.h  | 20 +++++++++++++++
 include/linux/find.h     | 33 ++++++++++++++++++++++++
 include/linux/topology.h |  8 ++++++
 kernel/sched/topology.c  | 55 ++++++++++++++++++++++++++++++++++++++++
 lib/cpumask.c            | 12 ++-------
 lib/find_bit.c           |  9 +++++++
 6 files changed, 127 insertions(+), 10 deletions(-)

-- 
2.34.1

