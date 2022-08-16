Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FE53596215
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 20:12:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236926AbiHPSL6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 14:11:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236924AbiHPSL1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 14:11:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B802285F9D
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 11:11:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660673473;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=5Cxl1yMNjN1JWkJUDea+B9kQSTSEbSpFhOYq99gTDk4=;
        b=BA40kXVv6LKCnZaaHza3igmnlUgkzc3tsex+etF/doHa/nB6xjJYsbcWo0qgllSpM6NAiU
        44zm+jUaVa8WetjL2NqLH3fhegBC6+W3ig2aRg4hICTwSnHoJH7bxDr04Esru0cfdznfKO
        90hEODknYoDyDMro3BzjkSm1lHJtmNs=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-240-gaBlu0SmOzqjiR4L9L7zCw-1; Tue, 16 Aug 2022 14:07:38 -0400
X-MC-Unique: gaBlu0SmOzqjiR4L9L7zCw-1
Received: by mail-wm1-f71.google.com with SMTP id c189-20020a1c35c6000000b003a4bfb16d86so5227017wma.3
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 11:07:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=5Cxl1yMNjN1JWkJUDea+B9kQSTSEbSpFhOYq99gTDk4=;
        b=bUUb3lsv5GxUHKYiOTJoDygPLOaDdVOcdeuPs1bWeDTKw12Jrwa1kRsCP6k+ZxW/sq
         qerISLcqe+5iPS2R+MiVw2BFfZcL1rSi/sfkuiFSR6shC0+3tG4YKPipJiI/lOPC3UP7
         yk1eJYXcgveQLO2uR1Anm+H3M5dccPAkyOmXyXOXvFo2tJrhGVQ8d5BpD8FttiACmc/F
         PayVtkCTJyMzDODBDOLsk2oTsR190MgXkGCrXotgblvLwcpJSRXPPv3NARxAcjbB1uoM
         G1wPoTzL3WXZNASrWMR38qID4xqpUdprR4Zboo3b1+rsxOo/NLXjw+FINvTsc/5iDlFB
         I4Rw==
X-Gm-Message-State: ACgBeo35NITDT8sSmePNThwXVD0aeiM/21pA6VrX5EtN+bYI6TU+uF5S
        2Gm/Xb2y+MhfoV9iugEc2j9f8WE11SuYq3wsuzV4/R15qcnw1IWQ3Zf3CBkI0ST6JC2lq7ja7ya
        2yacBf+IPvWJHu1FwBAdxyKByoWXqe/0X0nqmEQAnMea7ArYc1jVRr66V4Fh9HuibME9m
X-Received: by 2002:a5d:4912:0:b0:220:6633:104f with SMTP id x18-20020a5d4912000000b002206633104fmr12446523wrq.625.1660673256791;
        Tue, 16 Aug 2022 11:07:36 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6uR8z5D5D8T/gAXNcIujuyju0f7+AmovqCm4Vq6ys0+45zUiErhIRXXQQ3OhAWcNPgXMOXnw==
X-Received: by 2002:a5d:4912:0:b0:220:6633:104f with SMTP id x18-20020a5d4912000000b002206633104fmr12446491wrq.625.1660673256534;
        Tue, 16 Aug 2022 11:07:36 -0700 (PDT)
Received: from vschneid.remote.csb ([185.11.37.247])
        by smtp.gmail.com with ESMTPSA id o8-20020a05600c4fc800b003a319bd3278sm14694961wmq.40.2022.08.16.11.07.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 11:07:36 -0700 (PDT)
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
        Barry Song <song.bao.hua@hisilicon.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Tony Luck <tony.luck@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Gal Pressman <gal@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH 0/5] cpumask, sched/topology: NUMA-aware CPU spreading interface
Date:   Tue, 16 Aug 2022 19:07:22 +0100
Message-Id: <20220816180727.387807-1-vschneid@redhat.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
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

Patch 5/5 is just there to showcase how the thing would be used. If this doesn't
get hated on, I'll let Tariq pick this up and push it with his networking driver
changes (with actual changelogs).

[1]: https://lore.kernel.org/all/20220728191203.4055-1-tariqt@nvidia.com/

Cheers,
Valentin

Valentin Schneider (5):
  bitops: Introduce find_next_andnot_bit()
  cpumask: Introduce for_each_cpu_andnot()
  sched/topology: Introduce sched_numa_hop_mask()
  sched/topology: Introduce for_each_numa_hop_cpu()
  SHOWCASE: net/mlx5e: Leverage for_each_numa_hop_cpu()

 drivers/net/ethernet/mellanox/mlx5/core/eq.c | 12 ++++-
 include/linux/cpumask.h                      | 32 ++++++++++++++
 include/linux/find.h                         | 44 ++++++++++++++++---
 include/linux/topology.h                     | 46 ++++++++++++++++++++
 kernel/sched/topology.c                      | 28 ++++++++++++
 lib/cpumask.c                                | 19 ++++++++
 lib/find_bit.c                               | 16 ++++---
 7 files changed, 184 insertions(+), 13 deletions(-)

--
2.31.1

