Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2CB16076C3
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 14:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbiJUMTq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 08:19:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbiJUMTm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 08:19:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47D1626556
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 05:19:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666354779;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=z4zs9DcE+EGj5FW34Ff1HzR3Ff8P/pBL+yrwgJmUEeQ=;
        b=DyxA9kVggiJdM9FkE76Gw7nTaxAJe6wCbJVjia/k9trA9QrLgYT22jx+FGdOUqMtZH43ar
        ILs7D0SvVr7t7X7iN98Q17D7pW9qEvKVOD49wZtnYOJ28qoLJB1QIuWZ5a749BUHmuktfT
        kPuIhYHw/L8mMf3K44rQhSmM47701M4=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-577-bpfsMg3BPMmGpMmkA32Rdg-1; Fri, 21 Oct 2022 08:19:38 -0400
X-MC-Unique: bpfsMg3BPMmGpMmkA32Rdg-1
Received: by mail-qk1-f197.google.com with SMTP id q14-20020a05620a0d8e00b006ef0350dae1so3374538qkl.12
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 05:19:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=z4zs9DcE+EGj5FW34Ff1HzR3Ff8P/pBL+yrwgJmUEeQ=;
        b=i/mraNPjAvvadeas8fIRK5wtyYnfOWQ3hixwmWcaVIL2+YECGAFWpiw1HppauqBfMV
         au17JYRQD3SaxRspktn5G/mKFmfaYG21s/z6g0Q8/8L9mYjdPhC/F/pp/ce3jN/s4gbS
         ahMnj/sYpQ9RRYiP/aibw8Jg5x0e+/VW2QsfDVyh6aKl4goLdJ3/PU9lVppEvVpSh/nr
         Je6OoZu/WJq4lL8PGbXG7oDNP94kRdNk9GPSEQmSS05Ll2udunmYE4wVmbH7N+0h1FsU
         gXGbrmgP4z2nqVX8aW2xziROdyW06Q1FH3iqVW+kXTeLFUgbWsSEyWJweqHzPEdMi6sz
         OOXA==
X-Gm-Message-State: ACrzQf3alUJCxqL+JRqPpqG4W9KcfV+Mt7/XOzc5vnRDt9H2i+g4BpwG
        PnnMMNfjMuWUgE6DSOOTGnQZlFWVNONj331CTxjg2zRz/64Q30EMAdHk7tAXwRM3fh7HLiosw7I
        dyi6Ryg6Qw7c3O34giebWe9tnSjabqISPcBHjjnXrqLMjRVVFhweEsnriL8xoJoMB73tC
X-Received: by 2002:a05:6214:629:b0:4b1:bfde:b8f3 with SMTP id a9-20020a056214062900b004b1bfdeb8f3mr15577338qvx.116.1666354777802;
        Fri, 21 Oct 2022 05:19:37 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5JNLV8Cp8NzGabj6XA2TTqc02X6MRbq/KQTzRjlRnPGjQGyBoE7y8s7EiRYDxspFq0SMBMkg==
X-Received: by 2002:a05:6214:629:b0:4b1:bfde:b8f3 with SMTP id a9-20020a056214062900b004b1bfdeb8f3mr15577292qvx.116.1666354777512;
        Fri, 21 Oct 2022 05:19:37 -0700 (PDT)
Received: from vschneid.remote.csb ([149.71.65.94])
        by smtp.gmail.com with ESMTPSA id i9-20020ac85c09000000b0039a610a04b1sm8043410qti.37.2022.10.21.05.19.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Oct 2022 05:19:36 -0700 (PDT)
From:   Valentin Schneider <vschneid@redhat.com>
To:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Yury Norov <yury.norov@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mel Gorman <mgorman@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Tony Luck <tony.luck@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Gal Pressman <gal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [PATCH v5 0/3] sched, net: NUMA-aware CPU spreading interface
Date:   Fri, 21 Oct 2022 13:19:24 +0100
Message-Id: <20221021121927.2893692-1-vschneid@redhat.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi folks,

Tariq pointed out in [1] that drivers allocating IRQ vectors would benefit
from having smarter NUMA-awareness (cpumask_local_spread() doesn't quite cut
it).

The proposed interface involved an array of CPUs and a temporary cpumask, and
being my difficult self what I'm proposing here is an interface that doesn't
require any temporary storage other than some stack variables (at the cost of
one wild macro).

[1]: https://lore.kernel.org/all/20220728191203.4055-1-tariqt@nvidia.com/

Revisions
=========

v4 -> v5
++++++++
o Rebased onto 6.1-rc1
o Ditched the CPU iterator, moved to a cpumask iterator (Yury)

v3 -> v4
++++++++

o Rebased on top of Yury's bitmap-for-next
o Added Tariq's mlx5e patch
o Made sched_numa_hop_mask() return cpu_online_mask for the NUMA_NO_NODE &&
  hops=0 case

v2 -> v3
++++++++

o Added for_each_cpu_and() and for_each_cpu_andnot() tests (Yury)
o New patches to fix issues raised by running the above

o New patch to use for_each_cpu_andnot() in sched/core.c (Yury)

v1 -> v2
++++++++

o Split _find_next_bit() @invert into @invert1 and @invert2 (Yury)
o Rebase onto v6.0-rc1

Cheers,
Valentin

Tariq Toukan (1):
  net/mlx5e: Improve remote NUMA preferences used for the IRQ affinity
    hints

Valentin Schneider (2):
  sched/topology: Introduce sched_numa_hop_mask()
  sched/topology: Introduce for_each_numa_hop_mask()

 drivers/net/ethernet/mellanox/mlx5/core/eq.c | 18 +++++++++--
 include/linux/topology.h                     | 32 ++++++++++++++++++++
 kernel/sched/topology.c                      | 31 +++++++++++++++++++
 3 files changed, 79 insertions(+), 2 deletions(-)

--
2.31.1

