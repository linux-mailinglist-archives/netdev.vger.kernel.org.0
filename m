Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B6BB3B5247
	for <lists+netdev@lfdr.de>; Sun, 27 Jun 2021 08:07:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230025AbhF0GJr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Jun 2021 02:09:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53471 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229526AbhF0GJq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Jun 2021 02:09:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624774042;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sIJd5VMy9/Ds1U70TV6tKgSrFpVc+z9rcGA+TMf0QYE=;
        b=F9SARvu5ua5b9ziaHzAXlYVOUFOZZtJk7eZw8V+ELvcycaZYaFEK9OOTXArZRVCtHDWY/D
        PJuqK5S/yI8Tt9s6+8MMsc+Jg+b9PpftxWuRu0VjAF7YKxajuCjmyp2tky+JRT3IAfILWn
        p5TVJ0huHiBSLqFbHRU6BFnALpRK4Zo=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-488-H5sC1D9SP5CdstixbC4KJw-1; Sun, 27 Jun 2021 02:07:21 -0400
X-MC-Unique: H5sC1D9SP5CdstixbC4KJw-1
Received: by mail-wm1-f72.google.com with SMTP id r204-20020a1c44d50000b02901e993531cf2so2790763wma.7
        for <netdev@vger.kernel.org>; Sat, 26 Jun 2021 23:07:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=sIJd5VMy9/Ds1U70TV6tKgSrFpVc+z9rcGA+TMf0QYE=;
        b=Lqp6C4ubc5szF2pr1ifPQ/vJUOpLhEyoLZ2NsGOg5vTwUqhx8pWjkHebAqVkoI0KyE
         GGLHWWtsDYiZhzPhmaN6cjE1onZMWpbWJuAUv4DSfqI4NRZd077fssoev+Lpks0KmVUu
         tw68u8v2aluk4QPpYs55kQ/dCtarCyOT32wsTvTyUwSxVtFRjIE+9jHUWUguOMvP025b
         7bLHTBHXGcOy9P9l2LGlHgKaYvmF+8xbyUAXyPgSy1l9coKMoBE98Njxw6J4GW1U7j5C
         wY3VPcltxtX1ltPsrINhc9RyZqp8A+9KEaGzC8oM2wtu9d/tlUE0r5mbyWAbwcxL6e6b
         D+eA==
X-Gm-Message-State: AOAM5325DITQvd7m+ufKYYkiv3jXJjEJ8ht+siaU4TK7wTnRiCUAEhlG
        /BWe4eWIViG6UkXEfg6m8ey5F0+6aY1qCdRO0M77B7Z5+YCkcsI0c90do1rK16OnEo6mRqFpksl
        2MDhymWYPfxYzDN97
X-Received: by 2002:adf:8b4d:: with SMTP id v13mr19682625wra.223.1624774038256;
        Sat, 26 Jun 2021 23:07:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw/aarFKpzlA2cLWzhq/E7wV049GQJbCoOAeWs7obfTXXJ+WMpW8rAxuAyC9Td6ttchxF2Kaw==
X-Received: by 2002:adf:8b4d:: with SMTP id v13mr19682608wra.223.1624774038109;
        Sat, 26 Jun 2021 23:07:18 -0700 (PDT)
Received: from redhat.com ([77.126.198.14])
        by smtp.gmail.com with ESMTPSA id e15sm10962832wrm.60.2021.06.26.23.07.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Jun 2021 23:07:16 -0700 (PDT)
Date:   Sun, 27 Jun 2021 02:07:13 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, jasowang@redhat.com,
        brouer@redhat.com, paulmck@kernel.org, peterz@infradead.org,
        will@kernel.org, shuah@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linuxarm@openeuler.org
Subject: Re: [PATCH net-next v2 2/2] ptr_ring: make __ptr_ring_empty()
 checking more reliable
Message-ID: <20210627020440-mutt-send-email-mst@kernel.org>
References: <1624591136-6647-1-git-send-email-linyunsheng@huawei.com>
 <1624591136-6647-3-git-send-email-linyunsheng@huawei.com>
 <20210625023749-mutt-send-email-mst@kernel.org>
 <77615160-6f4f-64bf-7de9-b0adaddd5f06@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <77615160-6f4f-64bf-7de9-b0adaddd5f06@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 25, 2021 at 05:20:10PM +0800, Yunsheng Lin wrote:
> On 2021/6/25 14:39, Michael S. Tsirkin wrote:
> > On Fri, Jun 25, 2021 at 11:18:56AM +0800, Yunsheng Lin wrote:
> >> Currently r->queue[] is cleared after r->consumer_head is moved
> >> forward, which makes the __ptr_ring_empty() checking called in
> >> page_pool_refill_alloc_cache() unreliable if the checking is done
> >> after the r->queue clearing and before the consumer_head moving
> >> forward.
> >>
> >> Move the r->queue[] clearing after consumer_head moving forward
> >> to make __ptr_ring_empty() checking more reliable.
> >>
> >> As a side effect of above change, a consumer_head checking is
> >> avoided for the likely case, and it has noticeable performance
> >> improvement when it is tested using the ptr_ring_test selftest
> >> added in the previous patch.
> >>
> >> Using "taskset -c 1 ./ptr_ring_test -s 1000 -m 0 -N 100000000"
> >> to test the case of single thread doing both the enqueuing and
> >> dequeuing:
> >>
> >>  arch     unpatched           patched       delta
> >> arm64      4648 ms            4464 ms       +3.9%
> >>  X86       2562 ms            2401 ms       +6.2%
> >>
> >> Using "taskset -c 1-2 ./ptr_ring_test -s 1000 -m 1 -N 100000000"
> >> to test the case of one thread doing enqueuing and another thread
> >> doing dequeuing concurrently, also known as single-producer/single-
> >> consumer:
> >>
> >>  arch      unpatched             patched         delta
> >> arm64   3624 ms + 3624 ms   3462 ms + 3462 ms    +4.4%
> >>  x86    2758 ms + 2758 ms   2547 ms + 2547 ms    +7.6%
> > 
> > Nice but it's small - could be a fluke.
> > How many tests did you run? What is the variance?
> > Did you try pinning to different CPUs to observe numa effects?
> > Please use perf or some other modern tool for this kind
> > of benchmark. Thanks!
> 
> The result is quite stable, and retest using perf stat：

How stable exactly?  Try with -r so we can find out.

> ---------------unpatched ptr_ring.c begin----------------------------------
> 
> perf stat ./ptr_ring_test -s 1000 -m 0 -N 100000000
> ptr_ring(size:1000) perf simple test for 100000000 times, took 2385198 us
> 
>  Performance counter stats for './ptr_ring_test -s 1000 -m 0 -N 100000000':
> 
>            2385.49 msec task-clock                #    1.000 CPUs utilized
>                 26      context-switches          #    0.011 K/sec
>                  0      cpu-migrations            #    0.000 K/sec
>                 57      page-faults               #    0.024 K/sec
>         6202023521      cycles                    #    2.600 GHz
>        17424187640      instructions              #    2.81  insn per cycle
>    <not supported>      branches
>            6506477      branch-misses
> 
>        2.385785170 seconds time elapsed
> 
>        2.384014000 seconds user
>        0.000000000 seconds sys
> 
> 
> root@(none):~# perf stat ./ptr_ring_test -s 1000 -m 0 -N 100000000
> ptr_ring(size:1000) perf simple test for 100000000 times, took 2383385 us
> 
>  Performance counter stats for './ptr_ring_test -s 1000 -m 0 -N 100000000':
> 
>            2383.67 msec task-clock                #    1.000 CPUs utilized
>                 26      context-switches          #    0.011 K/sec
>                  0      cpu-migrations            #    0.000 K/sec
>                 57      page-faults               #    0.024 K/sec
>         6197278066      cycles                    #    2.600 GHz
>        17424207772      instructions              #    2.81  insn per cycle
>    <not supported>      branches
>            6495766      branch-misses
> 
>        2.383941170 seconds time elapsed
> 
>        2.382215000 seconds user
>        0.000000000 seconds sys
> 
> 
> root@(none):~# perf stat ./ptr_ring_test -s 1000 -m 0 -N 100000000
> ptr_ring(size:1000) perf simple test for 100000000 times, took 2390858 us
> 
>  Performance counter stats for './ptr_ring_test -s 1000 -m 0 -N 100000000':
> 
>            2391.16 msec task-clock                #    1.000 CPUs utilized
>                 25      context-switches          #    0.010 K/sec
>                  0      cpu-migrations            #    0.000 K/sec
>                 57      page-faults               #    0.024 K/sec
>         6216704120      cycles                    #    2.600 GHz
>        17424243041      instructions              #    2.80  insn per cycle
>    <not supported>      branches
>            6483886      branch-misses
> 
>        2.391420440 seconds time elapsed
> 
>        2.389647000 seconds user
>        0.000000000 seconds sys
> 
> 
> root@(none):~# perf stat ./ptr_ring_test -s 1000 -m 0 -N 100000000
> ptr_ring(size:1000) perf simple test for 100000000 times, took 2389810 us
> 
>  Performance counter stats for './ptr_ring_test -s 1000 -m 0 -N 100000000':
> 
>            2390.10 msec task-clock                #    1.000 CPUs utilized
>                 26      context-switches          #    0.011 K/sec
>                  0      cpu-migrations            #    0.000 K/sec
>                 58      page-faults               #    0.024 K/sec
>         6213995715      cycles                    #    2.600 GHz
>        17424227499      instructions              #    2.80  insn per cycle
>    <not supported>      branches
>            6474069      branch-misses
> 
>        2.390367070 seconds time elapsed
> 
>        2.388644000 seconds user
>        0.000000000 seconds sys
> 
> ---------------unpatched ptr_ring.c end----------------------------------
> 
> 
> 
> ---------------patched ptr_ring.c begin----------------------------------
> root@(none):~# perf stat ./ptr_ring_test_opt -s 1000 -m 0 -N 100000000
> ptr_ring(size:1000) perf simple test for 100000000 times, took 2198894 us
> 
>  Performance counter stats for './ptr_ring_test_opt -s 1000 -m 0 -N 100000000':
> 
>            2199.18 msec task-clock                #    1.000 CPUs utilized
>                 23      context-switches          #    0.010 K/sec
>                  0      cpu-migrations            #    0.000 K/sec
>                 56      page-faults               #    0.025 K/sec
>         5717671859      cycles                    #    2.600 GHz
>        16124164124      instructions              #    2.82  insn per cycle
>    <not supported>      branches
>            6564829      branch-misses
> 
>        2.199445990 seconds time elapsed
> 
>        2.197859000 seconds user
>        0.000000000 seconds sys
> 
> 
> root@(none):~# perf stat ./ptr_ring_test_opt -s 1000 -m 0 -N 100000000
> ptr_ring(size:1000) perf simple test for 100000000 times, took 2222337 us
> 
>  Performance counter stats for './ptr_ring_test_opt -s 1000 -m 0 -N 100000000':
> 
>            2222.63 msec task-clock                #    1.000 CPUs utilized
>                 23      context-switches          #    0.010 K/sec
>                  0      cpu-migrations            #    0.000 K/sec
>                 57      page-faults               #    0.026 K/sec
>         5778632853      cycles                    #    2.600 GHz
>        16124210769      instructions              #    2.79  insn per cycle
>    <not supported>      branches
>            6603904      branch-misses
> 
>        2.222901020 seconds time elapsed
> 
>        2.221312000 seconds user
>        0.000000000 seconds sys
> 
> 
> root@(none):~# perf stat ./ptr_ring_test_opt -s 1000 -m 0 -N 100000000
> ptr_ring(size:1000) perf simple test for 100000000 times, took 2251980 us
> 
>  Performance counter stats for './ptr_ring_test_opt -s 1000 -m 0 -N 100000000':
> 
>            2252.28 msec task-clock                #    1.000 CPUs utilized
>                 25      context-switches          #    0.011 K/sec
>                  0      cpu-migrations            #    0.000 K/sec
>                 57      page-faults               #    0.025 K/sec
>         5855668335      cycles                    #    2.600 GHz
>        16124310588      instructions              #    2.75  insn per cycle
>    <not supported>      branches
>            6777279      branch-misses
> 
>        2.252543340 seconds time elapsed
> 
>        2.250897000 seconds user
>        0.000000000 seconds sys
> 
> 
> root@(none):~#
> root@(none):~# perf stat ./ptr_ring_test_opt -s 1000 -m 0 -N 100000000
> ptr_ring(size:1000) perf simple test for 100000000 times, took 2209415 us
> 
>  Performance counter stats for './ptr_ring_test_opt -s 1000 -m 0 -N 100000000':
> 
>            2209.70 msec task-clock                #    1.000 CPUs utilized
>                 24      context-switches          #    0.011 K/sec
>                  0      cpu-migrations            #    0.000 K/sec
>                 58      page-faults               #    0.026 K/sec
>         5745003772      cycles                    #    2.600 GHz
>        16124198886      instructions              #    2.81  insn per cycle
>    <not supported>      branches
>            6508414      branch-misses
> 
>        2.209973960 seconds time elapsed
> 
>        2.208354000 seconds user
>        0.000000000 seconds sys
> 
> 
> root@(none):~# perf stat ./ptr_ring_test_opt -s 1000 -m 0 -N 100000000
> ptr_ring(size:1000) perf simple test for 100000000 times, took 2211409 us
> 
>  Performance counter stats for './ptr_ring_test_opt -s 1000 -m 0 -N 100000000':
> 
>            2211.70 msec task-clock                #    1.000 CPUs utilized
>                 24      context-switches          #    0.011 K/sec
>                  0      cpu-migrations            #    0.000 K/sec
>                 57      page-faults               #    0.026 K/sec
>         5750136694      cycles                    #    2.600 GHz
>        16124176577      instructions              #    2.80  insn per cycle
>    <not supported>      branches
>            6553023      branch-misses
> 
>        2.211968470 seconds time elapsed
> 
>        2.210303000 seconds user
>        0.000000000 seconds sys
> 
> ---------------patched ptr_ring.c end----------------------------------
> 
> > 
> >>
> 

