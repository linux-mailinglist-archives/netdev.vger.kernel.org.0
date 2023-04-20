Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FA6C6E9F3B
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 00:45:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231520AbjDTWp4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 18:45:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbjDTWpy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 18:45:54 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B503B2108;
        Thu, 20 Apr 2023 15:45:53 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id 46e09a7af769-6a5ebf9f432so1182647a34.3;
        Thu, 20 Apr 2023 15:45:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682030753; x=1684622753;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ms8WTRrTIiZDn9EMilCFm14ULPFWlrgqpalZ3v8kKro=;
        b=lcaHjXnFK1gH4Lht3tokfR/hYsnt3eLEGiU/nhXTd1/aB+O/ZPM+0C2qnLPxic3UL5
         aU4WeiiYpvVznDZzT6XmNOI0FAxhIpv3lSvhEJnnQmEck0PRBXtTXFZQSXuEPF31vl1g
         We6ivA+T06unmpc1Mp2vQsdSRiuYsZ7dIpkGywIYbGHq4NbIswCmWZJaBNxNZl+sRv+q
         jKB2/Jk4Vj8B+AJ8JfUZ+AY/tyYHRUAjc87MyNw3RpH0bVvIWO8xNqGFRBVtIJHe54BJ
         Fn+ndsHBbmE2/8MSHxDELR2+mDQea71NaqUL/3NMWVsbHaa06PA5RD+Ce17GTd4+1a+q
         +Tkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682030753; x=1684622753;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ms8WTRrTIiZDn9EMilCFm14ULPFWlrgqpalZ3v8kKro=;
        b=h13aJMBpjLkB7/MaCwZLTmhN0m+QRWFPwO4x/Er+87px3EZprQMnUD+coDTX4NbI4o
         Q9cdTDOX+rVGpEGUoFus+pYGFJc32Am8hrIwvYf+RU4+ALL85+ey+wX6O4YvIZy7rB41
         nl8nZ9sfZN6QFnICfXAMBUdjtPtoet0v2228dlGOrcCPOTcABbVsmDvfhDHW93IbGYA6
         ULAIS5gEHHGbU0xjBSHQ6+rwrKuE8WK9Hu0gwOADc2UIrlO6cL7cvs3GVF8Gc4hTnilR
         l5pchsyXgX9O05VqtmH7KLCJ6mu/Jm3PV15b514TgcYNV6govxRzWatlv9pAOkugeBB/
         vdEg==
X-Gm-Message-State: AAQBX9cUkaplPE4xIsAvupZflVv0qmlarFma2f4jYwm5UbffjGoyhflA
        OytB2E7igI6h0ihj9p1vRWY=
X-Google-Smtp-Source: AKy350b+d0WOX8mZcpTg3/D5U3ttg+iCDc383Oefl7kYog0+MxydJj3EjdyjXMQAxQW/EgLQnJ7zhQ==
X-Received: by 2002:a05:6870:b601:b0:187:8dc4:9c03 with SMTP id cm1-20020a056870b60100b001878dc49c03mr2311529oab.56.1682030752927;
        Thu, 20 Apr 2023 15:45:52 -0700 (PDT)
Received: from localhost ([216.228.117.191])
        by smtp.gmail.com with ESMTPSA id q1-20020a056870e88100b001727d67f2dbsm1223442oan.40.2023.04.20.15.45.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 15:45:52 -0700 (PDT)
Date:   Thu, 20 Apr 2023 15:45:49 -0700
From:   Yury Norov <yury.norov@gmail.com>
To:     Tariq Toukan <ttoukan.linux@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
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
        Gal Pressman <gal@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Barry Song <baohua@kernel.org>
Subject: Re: [PATCH v2 4/8] net: mlx5: switch comp_irqs_request() to using
 for_each_numa_cpu
Message-ID: <ZEHAkGEP/k9m7lKW@yury-ThinkPad>
References: <20230420051946.7463-1-yury.norov@gmail.com>
 <20230420051946.7463-5-yury.norov@gmail.com>
 <6b3f92e7-e54c-bb7d-2d72-1a0875989d4a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6b3f92e7-e54c-bb7d-2d72-1a0875989d4a@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 20, 2023 at 11:27:26AM +0300, Tariq Toukan wrote:
> I like this clean API.

Thanks :)
 
> nit:
> Previously cpu_online_mask was used here. Is this change intentional?
> We can fix it in a followup patch if this is the only comment on the series.
> 
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

The only CPUs listed in the sched_domains_numa_masks are 'available',
i.e. online CPUs. The for_each_numa_cpu() ANDs user-provided cpumask
with a map associate to the hop, and that means that if we AND with
possible mask, we'll eventually walk online CPUs only.

To make sure, I experimented with the modified test:

diff --git a/lib/test_bitmap.c b/lib/test_bitmap.c
index 6becb044a66f..c8d557731080 100644
--- a/lib/test_bitmap.c
+++ b/lib/test_bitmap.c
@@ -760,8 +760,13 @@ static void __init test_for_each_numa(void)
                unsigned int hop, c = 0;

                rcu_read_lock();
-               for_each_numa_cpu(cpu, hop, node, cpu_online_mask)
+               pr_err("Node %d:\t", node);
+               for_each_numa_cpu(cpu, hop, node, cpu_possible_mask) {
                        expect_eq_uint(cpumask_local_spread(c++, node), cpu);
+                       pr_cont("%3d", cpu);
+
+               }
+               pr_err("\n");
                rcu_read_unlock();
        }
 }

This is the NUMA topology of my test machine after the boot:

    root@debian:~# numactl -H
    available: 4 nodes (0-3)
    node 0 cpus: 0 1 2 3
    node 0 size: 1861 MB
    node 0 free: 1792 MB
    node 1 cpus: 4 5
    node 1 size: 1914 MB
    node 1 free: 1823 MB
    node 2 cpus: 6 7
    node 2 size: 1967 MB
    node 2 free: 1915 MB
    node 3 cpus: 8 9 10 11 12 13 14 15
    node 3 size: 7862 MB
    node 3 free: 7259 MB
    node distances:
    node   0   1   2   3
      0:  10  50  30  70
      1:  50  10  70  30
      2:  30  70  10  50
      3:  70  30  50  10

And this is what test prints:

     root@debian:~# insmod test_bitmap.ko
     test_bitmap: loaded.
     test_bitmap: parselist: 14: input is '0-2047:128/256' OK, Time: 472
     test_bitmap: bitmap_print_to_pagebuf: input is '0-32767
     ', Time: 2665
     test_bitmap: Node 0:	  0  1  2  3  6  7  4  5  8  9 10 11 12 13 14 15
     test_bitmap:
     test_bitmap: Node 1:	  4  5  8  9 10 11 12 13 14 15  0  1  2  3  6  7
     test_bitmap:
     test_bitmap: Node 2:	  6  7  0  1  2  3  8  9 10 11 12 13 14 15  4  5
     test_bitmap:
     test_bitmap: Node 3:	  8  9 10 11 12 13 14 15  4  5  6  7  0  1  2  3
     test_bitmap:
     test_bitmap: all 6614 tests passed

Now, disable a couple of CPUs:

     root@debian:~# chcpu -d 1-2
     smpboot: CPU 1 is now offline
     CPU 1 disabled
     smpboot: CPU 2 is now offline
     CPU 2 disabled

And try again:

     root@debian:~# rmmod test_bitmap
     rmmod: ERROR: ../libkmod/libkmod[  320.275904] test_bitmap: unloaded.
     root@debian:~# numactl -H
     available: 4 nodes (0-3)
     node 0 cpus: 0 3
     node 0 size: 1861 MB
     node 0 free: 1792 MB
     node 1 cpus: 4 5
     node 1 size: 1914 MB
     node 1 free: 1823 MB
     node 2 cpus: 6 7
     node 2 size: 1967 MB
     node 2 free: 1915 MB
     node 3 cpus: 8 9 10 11 12 13 14 15
     node 3 size: 7862 MB
     node 3 free: 7259 MB
     node distances:
     node   0   1   2   3
       0:  10  50  30  70
       1:  50  10  70  30
       2:  30  70  10  50
       3:  70  30  50  10
     root@debian:~# insmod test_bitmap.ko
     test_bitmap: loaded.
     test_bitmap: parselist: 14: input is '0-2047:128/256' OK, Time: 491
     test_bitmap: bitmap_print_to_pagebuf: input is '0-32767
     ', Time: 2174
     test_bitmap: Node 0:	  0  3  6  7  4  5  8  9 10 11 12 13 14 15
     test_bitmap:
     test_bitmap: Node 1:	  4  5  8  9 10 11 12 13 14 15  0  3  6  7
     test_bitmap:
     test_bitmap: Node 2:	  6  7  0  3  8  9 10 11 12 13 14 15  4  5
     test_bitmap:
     test_bitmap: Node 3:	  8  9 10 11 12 13 14 15  4  5  6  7  0  3
     test_bitmap:
     test_bitmap: all 6606 tests passed

I used cpu_possible_mask because I wanted to keep the patch
consistent: before we traversed NUMA hop masks, now we traverse the
same hop masks AND user-provided mask, so the latter should include
all possible CPUs.

If you think it's better to have cpu_online_mask in the driver, let's
make it in a separate patch?

Thanks,
Yury
