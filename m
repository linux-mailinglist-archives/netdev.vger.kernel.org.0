Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45647647783
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 21:51:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbiLHUvu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 15:51:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiLHUvt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 15:51:49 -0500
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64EDA2A0;
        Thu,  8 Dec 2022 12:51:48 -0800 (PST)
Received: by mail-ot1-x333.google.com with SMTP id t19-20020a9d7753000000b0066d77a3d474so1586318otl.10;
        Thu, 08 Dec 2022 12:51:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GihlQcK9cYAm1zf1IIYdLzFrOYYpv+dPmFF2jtn2Pws=;
        b=EZK+2otC2iqILdnHZbj+g1By8Y6vEnXt0GXdj2YlZ3P09tQP8QlXgRMgqfp9fALytB
         7Ehs1e52eEdghndn6xfrkGDhdX3VAfha0ij15rYiwGVhylTV/hvy5WjUl/ODYy6NeF/n
         UZtbHLnvCwyf/+AYQeJqv0lfYv/hRGo8YJcxnSs1tfo4NYTWJaBQFrU7fUaLi6PUgDsP
         WpCh6iFUkbItA9kcadRvbJLtksow2/Mht5fX67hp0Ku+ev215c1OjK/OHsxccU4YaUYk
         2+nHPTk9vYdHfoEhIHf5wRaQDU3xVR3teYnfv7gXu6u5i6r4vSWMRvdCBqx8fTOidCnp
         hbrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GihlQcK9cYAm1zf1IIYdLzFrOYYpv+dPmFF2jtn2Pws=;
        b=Ouyfu55zn7Zk//2UQRB53/KR8RSXkBJJh7EVBKKoloG7iTXcioZXCrHxVBO2ue1eaU
         qXtSs6uX+fMy5vRXx5sqG2mrEZllyJxLyq5CFpmHYXZhMHgqnWAB/68/QOXSnTABEx/E
         cnXI92vJbmsWNjSIVFH1SG+RrrMERL4M7ZyKdo2tty2rxKV6f7hKKyMlTGQG07YdBuFT
         Ksr2va1LP2iRSOBfK0fY2+NOegHro7VmWCw/vEuTYm36w80RFeqFIg2U/M3BmYW3zP66
         vi/y2r+hS0zGVYc/tMunrmZYepZpay47r/u3U4eyjISTZCeaW5deqefmFPpUtKhBc0U5
         INuQ==
X-Gm-Message-State: ANoB5pnRI1IHXonqLcVM7AZHkOdPQZo9vaL9f+IdsxfgQ47rfs6B8r22
        ys4OVi8GaqyyTrQ97G36Ogw=
X-Google-Smtp-Source: AA0mqf5jO/3SHxozsQwCiP3NUl+OBNFKX//G16s+v+bK99YpbQLz3olHSxPOFekszajQVg168KW9Lw==
X-Received: by 2002:a9d:7699:0:b0:661:dfe6:9732 with SMTP id j25-20020a9d7699000000b00661dfe69732mr1338993otl.1.1670532707597;
        Thu, 08 Dec 2022 12:51:47 -0800 (PST)
Received: from localhost ([12.97.180.36])
        by smtp.gmail.com with ESMTPSA id h5-20020a056830164500b00667ff6b7e9esm12285612otr.40.2022.12.08.12.51.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 12:51:47 -0800 (PST)
Date:   Thu, 8 Dec 2022 12:51:45 -0800
From:   Yury Norov <yury.norov@gmail.com>
To:     Tariq Toukan <ttoukan.linux@gmail.com>
Cc:     linux-kernel@vger.kernel.org,
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
        Tony Luck <tony.luck@intel.com>,
        Valentin Schneider <vschneid@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH v3 0/5] cpumask: improve on cpumask_local_spread()
 locality
Message-ID: <Y5JOYVlXvTDMQxOq@yury-laptop>
References: <20221208183101.1162006-1-yury.norov@gmail.com>
 <1efd1d75-9c5d-4827-3d28-bef044801859@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1efd1d75-9c5d-4827-3d28-bef044801859@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 08, 2022 at 10:22:22PM +0200, Tariq Toukan wrote:
> 
> 
> On 12/8/2022 8:30 PM, Yury Norov wrote:
> > cpumask_local_spread() currently checks local node for presence of i'th
> > CPU, and then if it finds nothing makes a flat search among all non-local
> > CPUs. We can do it better by checking CPUs per NUMA hops.
> > 
> > This series is inspired by Tariq Toukan and Valentin Schneider's
> > "net/mlx5e: Improve remote NUMA preferences used for the IRQ affinity
> > hints"
> > 
> > https://patchwork.kernel.org/project/netdevbpf/patch/20220728191203.4055-3-tariqt@nvidia.com/
> > 
> > According to their measurements, for mlx5e:
> > 
> >          Bottleneck in RX side is released, reached linerate (~1.8x speedup).
> >          ~30% less cpu util on TX.
> > 
> > This patch makes cpumask_local_spread() traversing CPUs based on NUMA
> > distance, just as well, and I expect comparable improvement for its
> > users, as in case of mlx5e.
> > 
> > I tested new behavior on my VM with the following NUMA configuration:
> > 
> > root@debian:~# numactl -H
> > available: 4 nodes (0-3)
> > node 0 cpus: 0 1 2 3
> > node 0 size: 3869 MB
> > node 0 free: 3740 MB
> > node 1 cpus: 4 5
> > node 1 size: 1969 MB
> > node 1 free: 1937 MB
> > node 2 cpus: 6 7
> > node 2 size: 1967 MB
> > node 2 free: 1873 MB
> > node 3 cpus: 8 9 10 11 12 13 14 15
> > node 3 size: 7842 MB
> > node 3 free: 7723 MB
> > node distances:
> > node   0   1   2   3
> >    0:  10  50  30  70
> >    1:  50  10  70  30
> >    2:  30  70  10  50
> >    3:  70  30  50  10
> > 
> > And the cpumask_local_spread() for each node and offset traversing looks
> > like this:
> > 
> > node 0:   0   1   2   3   6   7   4   5   8   9  10  11  12  13  14  15
> > node 1:   4   5   8   9  10  11  12  13  14  15   0   1   2   3   6   7
> > node 2:   6   7   0   1   2   3   8   9  10  11  12  13  14  15   4   5
> > node 3:   8   9  10  11  12  13  14  15   4   5   6   7   0   1   2   3
> > 
> > v1: https://lore.kernel.org/lkml/20221111040027.621646-5-yury.norov@gmail.com/T/
> > v2: https://lore.kernel.org/all/20221112190946.728270-3-yury.norov@gmail.com/T/
> > v3:
> >   - fix typo in find_nth_and_andnot_bit();
> >   - add 5th patch that simplifies cpumask_local_spread();
> >   - address various coding style nits.
> > 
> > Yury Norov (5):
> >    lib/find: introduce find_nth_and_andnot_bit
> >    cpumask: introduce cpumask_nth_and_andnot
> >    sched: add sched_numa_find_nth_cpu()
> >    cpumask: improve on cpumask_local_spread() locality
> >    lib/cpumask: reorganize cpumask_local_spread() logic
> > 
> >   include/linux/cpumask.h  | 20 ++++++++++++++
> >   include/linux/find.h     | 33 +++++++++++++++++++++++
> >   include/linux/topology.h |  8 ++++++
> >   kernel/sched/topology.c  | 57 ++++++++++++++++++++++++++++++++++++++++
> >   lib/cpumask.c            | 26 +++++-------------
> >   lib/find_bit.c           |  9 +++++++
> >   6 files changed, 134 insertions(+), 19 deletions(-)
> > 
> 
> Acked-by: Tariq Toukan <tariqt@nvidia.com>

Thanks Tariq, Jacob and Peter for review. I'll add the series in
bitmap-for-next for testing. Still, I think that sched/numa branches
would be more suitable.

Thanks,
Yury
