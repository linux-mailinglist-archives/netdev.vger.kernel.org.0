Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA7DB64E48B
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 00:12:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbiLOXL6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 18:11:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229807AbiLOXLq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 18:11:46 -0500
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F3433E0BE;
        Thu, 15 Dec 2022 15:11:45 -0800 (PST)
Received: by mail-ot1-x335.google.com with SMTP id i26-20020a9d68da000000b00672301a1664so416466oto.6;
        Thu, 15 Dec 2022 15:11:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8DKcMUsVohq1zP2BP4+TD9a9jOkzZ1udLWR6UFI0elg=;
        b=jQNpm7q53MiBge8cfZpMiioLYSIs1TjfR4UT1bxm8/le/hkbq8Nc06hQAmkpY5kqKt
         mzdIkkdb8VUMtbXnsBuG0eLFoVVBeYxblUh/yRavCSwmUapTuDLOxHCOcWDa5dYlM5E+
         SDt3f4IZUjjlc6bVhJDr/Zj9skuAjrLc8O0kYvEc71rIS7hGLW0nHZPjfsXeFA+inZeC
         jZ6ACE1t+lmjJwpsilyb+VxuXzpLfjOEh09Qf9pQyFoQSnt5Yx5JbTD4DV+paRdujoli
         Htd3bq6I4msBDBpipaLv6yfqwol+AnXDjOINi1JoLvXcNGhw2OgapQHdAvw/IsoQa152
         w9BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8DKcMUsVohq1zP2BP4+TD9a9jOkzZ1udLWR6UFI0elg=;
        b=c/oZm8HDZGj4/aEeCIuJWrsTNdipr5xY4TjIYnT/ygKEczC+i6bmsyv2Vl90Qhd/Rt
         ZG2hdasfhqdiA23VrQnBn2jIjzWtsf94PO4tWzQy+0sjWkp/7WOmVCL5FfuCnDVwAFqi
         RSdUF7YiPXrlVLYeSkn/94aX7hLdSr8DA8nUwesRpSWrk0BEbFktDEK6nfkUyO6VQezn
         VE1cJpLV/+FNh7TQtvJ/fFyTXOL8nDMBqGYAdgvp+8JitQmR5Q2fSZhd3kVFvFmYFc9b
         WsiSXbyApjpRBY+PUOVAcHuxB+7ivNlEA29KG2zeBpdnQyVikNCHwSRTSf7DDJZ7soha
         vRNA==
X-Gm-Message-State: ANoB5pnVdibtlahzY0vEOBDYoR/npJOw2GfjOVv7GvK/7rt7JznSqvCV
        RIZ3O1sDOrLthhmrO4YIwEM=
X-Google-Smtp-Source: AA0mqf6r03rxLOA1XWPcc9XnbgjLq3kYNxoATlIVXvJIiQuffQiFz7QhxjraD8tejb7wLZK0hufRnQ==
X-Received: by 2002:a9d:6006:0:b0:670:6246:8106 with SMTP id h6-20020a9d6006000000b0067062468106mr14896488otj.4.1671145904650;
        Thu, 15 Dec 2022 15:11:44 -0800 (PST)
Received: from localhost ([12.97.180.36])
        by smtp.gmail.com with ESMTPSA id a21-20020a056830101500b00670763270fcsm114511otp.71.2022.12.15.15.11.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Dec 2022 15:11:44 -0800 (PST)
Date:   Thu, 15 Dec 2022 15:11:42 -0800
From:   Yury Norov <yury.norov@gmail.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc:     Yury Norov <yury.norov@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Tariq Toukan <tariqt@nvidia.com>,
        Valentin Schneider <vschneid@redhat.com>,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org
Subject: [GIT PULL] bitmap changes for v6.2-rc1
Message-ID: <Y5uprmSmSfYechX2@yury-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following changes since commit 76dcd734eca23168cb008912c0f69ff408905235:

  Linux 6.1-rc8 (2022-12-04 14:48:12 -0800)

are available in the Git repository at:

  git@github.com:/norov/linux.git tags/bitmap-6.2-rc1

for you to fetch changes up to 2386459394d2a46964829a00c48a08a23ead94ed:

  lib/cpumask: update comment for cpumask_local_spread() (2022-12-15 14:44:43 -0800)

----------------------------------------------------------------
Hi Linus,

Please pull bitmap patches for v6.2. They spent in -next for more than
a week without any issues. The branch consists of:

- optimize small_const path for find_next_bit() and friends (me);

  Introduces small_const_nbits_off() and uses it in find_next_bit()-like
  functions to allow static optimization when all bits to search are
  withing a word boundary, even if not a 1st word.

- cpumask: improve on cpumask_local_spread() locality (me):

  The series makes cpumask_local_spread() picking Nth CPU based on NUMA
  hop distances, which is better than picking CPUs from a given node and
  if there's no N cpus - from a random node (how it works now).

- sched, net: NUMA-aware CPU spreading interface (Valentin Schneider,
  Tariq Toukan):

  Iterators for NUMA-aware CPUs traversing. Better alternative for
  cpumask_local_spread(), when it's needed to enumerate all CPUs.

Thanks,
Yury

----------------------------------------------------------------
Tariq Toukan (1):
      net/mlx5e: Improve remote NUMA preferences used for the IRQ affinity hints

Valentin Schneider (2):
      sched/topology: Introduce sched_numa_hop_mask()
      sched/topology: Introduce for_each_numa_hop_mask()

Yury Norov (9):
      bitmap: switch from inline to __always_inline
      bitmap: improve small_const case for find_next() functions
      bitmap: add tests for find_next_bit()
      lib/find: introduce find_nth_and_andnot_bit
      cpumask: introduce cpumask_nth_and_andnot
      sched: add sched_numa_find_nth_cpu()
      cpumask: improve on cpumask_local_spread() locality
      lib/cpumask: reorganize cpumask_local_spread() logic
      lib/cpumask: update comment for cpumask_local_spread()

 drivers/net/ethernet/mellanox/mlx5/core/eq.c |  18 ++-
 include/asm-generic/bitsperlong.h            |  12 ++
 include/linux/bitmap.h                       |  46 ++++----
 include/linux/cpumask.h                      | 164 +++++++++++++++------------
 include/linux/find.h                         | 118 +++++++++++--------
 include/linux/nodemask.h                     |  86 +++++++-------
 include/linux/topology.h                     |  33 ++++++
 kernel/sched/topology.c                      |  90 +++++++++++++++
 lib/cpumask.c                                |  52 +++++----
 lib/find_bit.c                               |   9 ++
 lib/test_bitmap.c                            |  23 +++-
 11 files changed, 438 insertions(+), 213 deletions(-)
