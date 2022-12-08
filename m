Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EF4F64758B
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 19:31:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbiLHSbH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 13:31:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbiLHSbG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 13:31:06 -0500
Received: from mail-oa1-x33.google.com (mail-oa1-x33.google.com [IPv6:2001:4860:4864:20::33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AD7D85D22;
        Thu,  8 Dec 2022 10:31:05 -0800 (PST)
Received: by mail-oa1-x33.google.com with SMTP id 586e51a60fabf-144bd860fdbso2851355fac.0;
        Thu, 08 Dec 2022 10:31:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XF7XmsI3z9Pewm9QLWRYHW1AFn4kiQyrTYitGbyYOV0=;
        b=X7yZQIpnNAhUiqJmYPIzNNFCNYaxiM7TSwgUizzX6q5+3xdIGn8EDYfOM5mh9JvgZm
         jau4dmjTy/lJ3MtqBD78OTglbxR7hkmpdWvHLaGkPZf4n/Ra9wxwDTKJKra0Ruc24HU+
         IcPOPf2abIOtNRv74pFNGsNE7wCIo5Cz6RljxYJA4Kegwr4zv6g1IAHnAwT0PBPMM1ri
         7wjhtnF58lTf/WfnpS5YiG2xCB9WE6SzLRkJrpn0rn+dMEAVZuyxb+TnWJRsfaI9CIWf
         9s98bhjevgrcvTinBLHRrMx1w0x5nkTm5mez6BQLOvvcYkGetKouGqqHwd5U8CyAi/Dp
         1nEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XF7XmsI3z9Pewm9QLWRYHW1AFn4kiQyrTYitGbyYOV0=;
        b=v6s2c2qwyazigahKn8SX9LpK737o65HOIzejwt+49GbZK4+LP45vQdsGl6sdjjn2Z3
         KcP8OYaeEdCBHe8zVGmGFSm8UpCfe3DFgO1lfStO949BZdZZoHpUyjcWDhTWsoZjIy6U
         aCtysKDDUMLWxtJP3zB2L0qks/srJswcHSVSrt4NGsChGinC9DYj4cdn6kuZ+sJTl2ZH
         lQYDperSKjF/Qt6hlj9rzB5r48uiy+JsS2T5PFRC0Ae/IEchx7OTZvKPZYfzUnjpFuQJ
         KwNfnniRvSVdFsqGpdlMAK7C7x56QqVOOWYx3jyAvQta9ohI+SAn5JHsWqNwaYUHOwTu
         Leiw==
X-Gm-Message-State: ANoB5pmrcHCUdieyN1tv+DmGHKCe1BeRPQt1D1VaT4RS/6Solt7qYeuF
        dsvzAsqyFOCE/E8qSBgiT0eqmN/ph9s=
X-Google-Smtp-Source: AA0mqf6IgUrN864xAfLN0JG81zylBxprTCpDGfMjzGswc9Ykw20KFVxsaXlw/9FyrZMqbfHUTsJ8TA==
X-Received: by 2002:a05:6870:b9ca:b0:13b:d910:5001 with SMTP id iv10-20020a056870b9ca00b0013bd9105001mr1391780oab.1.1670524264577;
        Thu, 08 Dec 2022 10:31:04 -0800 (PST)
Received: from localhost ([12.97.180.36])
        by smtp.gmail.com with ESMTPSA id k14-20020a0568080e8e00b0034d8abf42f1sm10910446oil.23.2022.12.08.10.31.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 10:31:03 -0800 (PST)
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
Subject: [PATCH v3 0/5] cpumask: improve on cpumask_local_spread() locality
Date:   Thu,  8 Dec 2022 10:30:56 -0800
Message-Id: <20221208183101.1162006-1-yury.norov@gmail.com>
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

This series is inspired by Tariq Toukan and Valentin Schneider's
"net/mlx5e: Improve remote NUMA preferences used for the IRQ affinity
hints"

https://patchwork.kernel.org/project/netdevbpf/patch/20220728191203.4055-3-tariqt@nvidia.com/

According to their measurements, for mlx5e:

        Bottleneck in RX side is released, reached linerate (~1.8x speedup).
        ~30% less cpu util on TX.

This patch makes cpumask_local_spread() traversing CPUs based on NUMA
distance, just as well, and I expect comparable improvement for its
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
v2: https://lore.kernel.org/all/20221112190946.728270-3-yury.norov@gmail.com/T/
v3:
 - fix typo in find_nth_and_andnot_bit();
 - add 5th patch that simplifies cpumask_local_spread();
 - address various coding style nits.

Yury Norov (5):
  lib/find: introduce find_nth_and_andnot_bit
  cpumask: introduce cpumask_nth_and_andnot
  sched: add sched_numa_find_nth_cpu()
  cpumask: improve on cpumask_local_spread() locality
  lib/cpumask: reorganize cpumask_local_spread() logic

 include/linux/cpumask.h  | 20 ++++++++++++++
 include/linux/find.h     | 33 +++++++++++++++++++++++
 include/linux/topology.h |  8 ++++++
 kernel/sched/topology.c  | 57 ++++++++++++++++++++++++++++++++++++++++
 lib/cpumask.c            | 26 +++++-------------
 lib/find_bit.c           |  9 +++++++
 6 files changed, 134 insertions(+), 19 deletions(-)

-- 
2.34.1

