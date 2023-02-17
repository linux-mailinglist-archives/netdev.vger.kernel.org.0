Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 817A069A37E
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 02:39:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230058AbjBQBjO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 20:39:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjBQBjN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 20:39:13 -0500
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 251165356C;
        Thu, 16 Feb 2023 17:39:12 -0800 (PST)
Received: by mail-oi1-x232.google.com with SMTP id bh15so3584685oib.4;
        Thu, 16 Feb 2023 17:39:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VXQ5NrgvHcnTZDrYMA7luKxwlYKnjw3ntxCLdrLg57U=;
        b=gYvzaviFtqImQ3zUrVvJmoLWnxgJkoUH+uQVlf3ZPNK+gFO9Qcg//Tb5sdXRlRP/fL
         tk1XGt/RFgKLRqV4DW5him6L2tAzFpn7HmQF6EXRwER1S1w+fBKTaMHXYzskpk/Jb2gP
         Qp79v0eejOd0i+jXCHWxaGVZUvTs4BePZ9v13MrLZKugqdsuHsEbNKte6ygjoBcnAgEt
         8DkibJueUqgu4kJUvn3atA7afhXE4uLvK7bIO7fBHuuCxb7/UjbuL65eGdIP/nz5Wpx+
         mk0xPywsi3xRi5GgUdIAVbFwB+9TkiJgXCpjwybA1KTXop6mTziZ8OHyps8NdsR/m0qR
         GZUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VXQ5NrgvHcnTZDrYMA7luKxwlYKnjw3ntxCLdrLg57U=;
        b=Vo5sANe2nKL5RUvKYL7338f/g5bHrFN889pzQU6vopWCIS9D6siwGZvxv8/LZbNaG2
         bNE0yCgatBCL6XvGecl4YKtS4RRylIUETEtuP+T1R+xSWgZ0kOIiAKLEK2JwvxXy/XXZ
         CanHg2lXQUdlqV8ojuctR6fYEXY/vzlS8JhKG4t+ZtxYslxtYBzwV8usE+9nv3G6yJYg
         eG0Mk4t4G8zGQ2QbFbtHMbuSyHi03nvZ4QC68ZB0fV7MBTFWNXxowzKPoTLCkvzamn5s
         4jL4oaY1dDzP4EQ/Ye7Qs/xZZV5tImQMIwa19Xr2ZMkKVvZGeo/1M/NS4TDneOwIkvlj
         3/qw==
X-Gm-Message-State: AO0yUKU0XAzISQc6whFgYNfQ6ttngYQWsAioXNclM9gZPAK7yMC5wqoX
        E1WYWorecXmwrnaYbFj3JGIO7G5zxxY=
X-Google-Smtp-Source: AK7set8drcacu6OsYNi6+44bXIOT2XIdpYwoXbf6odYP67GCPakNkgeQBA5IfD5qhYUu3W78NJdfPw==
X-Received: by 2002:aca:f11:0:b0:37f:b2dd:73a with SMTP id 17-20020aca0f11000000b0037fb2dd073amr102656oip.24.1676597950923;
        Thu, 16 Feb 2023 17:39:10 -0800 (PST)
Received: from localhost ([12.97.180.36])
        by smtp.gmail.com with ESMTPSA id r204-20020acac1d5000000b0037834b1a20bsm1235358oif.0.2023.02.16.17.39.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Feb 2023 17:39:10 -0800 (PST)
Date:   Thu, 16 Feb 2023 17:39:08 -0800
From:   Yury Norov <yury.norov@gmail.com>
To:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Barry Song <baohua@kernel.org>,
        Ben Segall <bsegall@google.com>,
        Bruno Goncalves <bgoncalv@redhat.com>,
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
        Kees Cook <kees@kernel.org>,
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
Cc:     linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH 3/9] sched: add sched_numa_find_nth_cpu()
Message-ID: <Y+7avK6V9SyAWsXi@yury-laptop>
References: <20230121042436.2661843-1-yury.norov@gmail.com>
 <20230121042436.2661843-4-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230121042436.2661843-4-yury.norov@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

Can you please fold-in the following patch? 

Thanks,
Yury

From: Yury Norov <yury.norov@gmail.com>
Date: Thu, 16 Feb 2023 17:03:30 -0800
Subject: [PATCH] sched/topology: fix KASAN warning in hop_cmp()

Despite that prev_hop is used conditionally on curr_hop is not the
first hop, it's initialized unconditionally.

Because initialization implies dereferencing, it might happen that
the code dereferences uninitialized memory, which has been spotted by
KASAN. Fix it by reorganizing hop_cmp() logic.

Reported-by: Bruno Goncalves <bgoncalv@redhat.com>
Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 kernel/sched/topology.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index 48838a05c008..c21b8b1f3537 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -2081,14 +2081,19 @@ struct __cmp_key {
 
 static int hop_cmp(const void *a, const void *b)
 {
-	struct cpumask **prev_hop = *((struct cpumask ***)b - 1);
-	struct cpumask **cur_hop = *(struct cpumask ***)b;
+	struct cpumask **prev_hop, **cur_hop = *(struct cpumask ***)b;
 	struct __cmp_key *k = (struct __cmp_key *)a;
 
 	if (cpumask_weight_and(k->cpus, cur_hop[k->node]) <= k->cpu)
 		return 1;
 
-	k->w = (b == k->masks) ? 0 : cpumask_weight_and(k->cpus, prev_hop[k->node]);
+	if (b == k->masks) {
+		k->w = 0;
+		return 0;
+	}
+
+	prev_hop = *((struct cpumask ***)b - 1);
+	k->w = cpumask_weight_and(k->cpus, prev_hop[k->node]);
 	if (k->w <= k->cpu)
 		return 0;
 
-- 
2.34.1

