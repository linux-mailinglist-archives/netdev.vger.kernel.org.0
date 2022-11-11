Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B210D625202
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 05:00:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232434AbiKKEAe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 23:00:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230232AbiKKEAc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 23:00:32 -0500
Received: from mail-oa1-x34.google.com (mail-oa1-x34.google.com [IPv6:2001:4860:4864:20::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60E265D6B5;
        Thu, 10 Nov 2022 20:00:31 -0800 (PST)
Received: by mail-oa1-x34.google.com with SMTP id 586e51a60fabf-13c2cfd1126so4294987fac.10;
        Thu, 10 Nov 2022 20:00:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=noz15JaTCdLus5U4sOLPjqv3bwt+1uKmzScfAp4rWSg=;
        b=M0y8f58B89emx7VDfpcYz+luBmYMcBkXpsDjBQBWN8fAEF4DAF7j4W1sFdpbX3iQH3
         DBsGdDm4Oa4aN6PyT3kbjpsuVjtjbT8ZLepChc5PMbK9s9WkctqOIJS6pZserU2J5dsn
         5M7nFYVmqb5eqGbQnXTomg53hBR0Rhu+E8hTFS5iKMQSqGy1YVMSXp6ypQ2aHeju2lcf
         K/KefFPwhaRjA6pFURKb6ue2eVNP5pFHQAhMqNS12UKeF9p2W/3GMaS2Mm0ImfIJ2l6h
         Qw9la74vCT7jNI2Inp5q/vTAju59gEXE1b5q4s+8nd65hMIGxkqz6FDNtipOY77gm2iS
         JMdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=noz15JaTCdLus5U4sOLPjqv3bwt+1uKmzScfAp4rWSg=;
        b=70FAskbuSoDTtSFfsYYwAd4BCGJi4n1bAmW8Gbwv7Ro/Fyp+Pwdh0eDlZ1/2JTDk+F
         UsRqeAiadCWpsC3zmZO41YhPtHEiOTCAQzE2/teVrvyo1P95JxRyUD/Bk5TvQJKw42lx
         11rYtUudiSLKGPiqHjEK4pXXW9tLFFtPTuGP0Sqm/MQgdayEAFBNq2zb2myKplohfaqT
         SBP6Vtob+NOarmlz0VjrVnRyivIsTibMjJqHHcWWpKsfNAR1LInMpqu+Wvbnk1xVRJhA
         YCqZvqhWTZk3P3WoM3+LvaRI0G0G8VSBBc24vMymYgE0e6chuBHkV/xxfwBV60Jh8QQI
         onlQ==
X-Gm-Message-State: ACrzQf3QYF3mi+zVpXfHtOzFxqrI4SRUrp6tnG4sDORO6edprJ57giGH
        DSa45iv1T0tpU1sP/GCPpPmqVYdrYbE=
X-Google-Smtp-Source: AMsMyM7Y+meRC0ZMa270dUWGCP446I8C7TgwP4cnDdySGTCzW91kJ3zC+4m1SZSD4Mt+yL08Yqm91A==
X-Received: by 2002:a05:6870:d99a:b0:13d:3935:9b25 with SMTP id gn26-20020a056870d99a00b0013d39359b25mr2782959oab.259.1668139230476;
        Thu, 10 Nov 2022 20:00:30 -0800 (PST)
Received: from localhost ([12.97.180.36])
        by smtp.gmail.com with ESMTPSA id n35-20020a4a9566000000b0049f08b7e8a5sm427591ooi.46.2022.11.10.20.00.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 20:00:30 -0800 (PST)
From:   Yury Norov <yury.norov@gmail.com>
To:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Barry Song <baohua@kernel.org>,
        Ben Segall <bsegall@google.com>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
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
Subject: [PATCH 0/4] cpumask: improve on cpumask_local_spread() locality
Date:   Thu, 10 Nov 2022 20:00:23 -0800
Message-Id: <20221111040027.621646-1-yury.norov@gmail.com>
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

This series is inspired by Valentin Schneider's "net/mlx5e: Improve remote
NUMA preferences used for the IRQ affinity hints"

https://patchwork.kernel.org/project/netdevbpf/patch/20220728191203.4055-3-tariqt@nvidia.com/

According to Valentin's measurements, for mlx5e:

	Bottleneck in RX side is released, reached linerate (~1.8x speedup).
	~30% less cpu util on TX.

This patch makes cpumask_local_spread() traversing CPUs based on NUMA
distance, just as well, and I expect comparabale improvement for its
users, as in Valentin's case.

I tested it on my VM with the following NUMA configuration:

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

Yury Norov (4):
  lib/find: introduce find_nth_and_andnot_bit
  cpumask: introduce cpumask_nth_and_andnot
  sched: add sched_numa_find_nth_cpu()
  cpumask: improve on cpumask_local_spread() locality

 include/linux/cpumask.h  | 20 +++++++++++++++++++
 include/linux/find.h     | 33 +++++++++++++++++++++++++++++++
 include/linux/topology.h |  8 ++++++++
 kernel/sched/topology.c  | 42 ++++++++++++++++++++++++++++++++++++++++
 lib/cpumask.c            | 12 ++----------
 lib/find_bit.c           |  9 +++++++++
 6 files changed, 114 insertions(+), 10 deletions(-)

-- 
2.34.1

