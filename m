Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 353C34A7327
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 15:31:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238857AbiBBObt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 09:31:49 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44824 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345011AbiBBObr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 09:31:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643812306;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UEv10nAkQ//1KDJ0Efo18Nsdi9wgtpf0l44uT8UYDm8=;
        b=WW8hfyCXLm0OS1DvKnPLcsXBGpF24xozCnwLQexh/C2zBXSZ2oUcD28ixDiA+CInkq803V
        f3smTsMZetxqEhEAkAx0TqjaEIXnR6dg4PrxjguLGHpAp7NJpkiGVJ5fUA9ii/lfhoAZXt
        dNchHORmSDy0T3CtBztdYd3tZtAdvsg=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-442-36CCuJNFO628g1I98TzvHA-1; Wed, 02 Feb 2022 09:31:44 -0500
X-MC-Unique: 36CCuJNFO628g1I98TzvHA-1
Received: by mail-ed1-f69.google.com with SMTP id l14-20020aa7cace000000b003f7f8e1cbbdso10475416edt.20
        for <netdev@vger.kernel.org>; Wed, 02 Feb 2022 06:31:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:message-id:date:mime-version:user-agent:cc
         :subject:content-language:to:references:in-reply-to
         :content-transfer-encoding;
        bh=UEv10nAkQ//1KDJ0Efo18Nsdi9wgtpf0l44uT8UYDm8=;
        b=yODziMoEr1aufckxNPF7mAtN3ykdiqr8NBu5NXAXGQrgJLMj4fmeQbvh+thLEvXOwY
         02TNTLqt8gQa1vFuISUySAscvXnEoQ1OzTyL/jpkb+yvx7Xct0Y56f4KrtbgV/wfI8L9
         3tDK4cPBO3sujTyM7Yb5KxoKxhUy8ONhS11zB5DazXh+GrHoSvLOgl3itPK1C6k4Pr9Z
         JF0QEywcjAhhfm9TXJFuIZgs0Y8+kriMcjg6CN4miCaOVYo4+n8UibX/9hSr/bBmYB3V
         /S1FXvRnsVe3pnZ1AhD0BxCRS0wEdkq0GrmaVXwQonIl04xTmlZki8jopFBeGJ1sazBy
         Yo1A==
X-Gm-Message-State: AOAM531HldAkmfmsfMy1l1SBl20u3I5FF0R7emppeZrwt+/asBf3GYEN
        yzSrjAypJK+EzJChamI/BEE86e5v6hhVdQ2fHPJWAz9x6sWjeEamkcBWkKc7nCGr0TfLHsCnmX2
        L625UOpTDVhrIoiwr
X-Received: by 2002:a17:907:a412:: with SMTP id sg18mr25871171ejc.68.1643812302482;
        Wed, 02 Feb 2022 06:31:42 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwLLzCCkLGJ9rGc2I9DfJlmiLofrp+9MCNN6QYlbt3IhIKSL5kDDdyN6X/tOoF3Q62vxSxLdw==
X-Received: by 2002:a17:907:a412:: with SMTP id sg18mr25871156ejc.68.1643812302220;
        Wed, 02 Feb 2022 06:31:42 -0800 (PST)
Received: from [192.168.0.50] (87-59-106-155-cable.dk.customer.tdc.net. [87.59.106.155])
        by smtp.gmail.com with ESMTPSA id cz6sm15791340edb.4.2022.02.02.06.31.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Feb 2022 06:31:41 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <bb50fffb-afa8-b258-5382-fe56294cd7b0@redhat.com>
Date:   Wed, 2 Feb 2022 15:31:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Cc:     brouer@redhat.com
Subject: Re: [net-next v3 00/10] page_pool: Add page_pool stat counters
Content-Language: en-US
To:     Joe Damato <jdamato@fastly.com>, netdev@vger.kernel.org,
        kuba@kernel.org, ilias.apalodimas@linaro.org, davem@davemloft.net,
        hawk@kernel.org, Tariq Toukan <ttoukan.linux@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>
References: <1643764336-63864-1-git-send-email-jdamato@fastly.com>
In-Reply-To: <1643764336-63864-1-git-send-email-jdamato@fastly.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Adding Cc. Tariq and Saeed, as they wanted page_pool stats in the past.

On 02/02/2022 02.12, Joe Damato wrote:
> Greetings:
> 
> Sending a v3 as I noted some issues with the procfs code in patch 10 I
> submit in v2 (thanks, kernel test robot) and fixing the placement of the
> refill stat increment in patch 8.

Could you explain why a single global stats (/proc/net/page_pool_stat) 
for all page_pool instances for all RX-queues makes sense?

I think this argument/explanation belongs in the cover letter.

What are you using this for?

And do Tariq and Saeeds agree with this single global stats approach?


> I only modified the placement of the refill stat, but decided to re-run the
> benchmarks used in the v2 [1], and the results are:

I appreciate that you are running the benchmarks.

> Test system:
> 	- 2x Intel(R) Xeon(R) Gold 6140 CPU @ 2.30GHz
> 	- 2 NUMA zones, with 18 cores per zone and 2 threads per core
> 
> bench_page_pool_simple results:
> test name			stats enabled		stats disabled
> 				cycles	nanosec		cycles	nanosec
> 
> for_loop			0	0.335		0	0.334

I think you can drop the 'for_loop' results, we can see that the 
overhead is insignificant.

> atomic_inc 			13	6.028		13	6.035
> lock				32	14.017		31	13.552
> 
> no-softirq-page_pool01		45	19.832		46	20.193
> no-softirq-page_pool02		44	19.478		46	20.083
> no-softirq-page_pool03		110	48.365		109	47.699
> 
> tasklet_page_pool01_fast_path	14	6.204		13	6.021
> tasklet_page_pool02_ptr_ring	41	18.115		42	18.699
> tasklet_page_pool03_slow	110	48.085		108	47.395
> 
> bench_page_pool_cross_cpu results:
> test name			stats enabled		stats disabled
> 				cycles	nanosec		cycles	nanosec
> 
> page_pool_cross_cpu CPU(0)	2216	966.179		2101	915.692
> page_pool_cross_cpu CPU(1)	2211	963.914		2159	941.087
> page_pool_cross_cpu CPU(2)	1108	483.097		1079	470.573
> 
> page_pool_cross_cpu average	1845	-		1779	-
> 
> v2 -> v3:
> 	- patch 8/10 ("Add stat tracking cache refill") fixed placement of
> 	  counter increment.
> 	- patch 10/10 ("net-procfs: Show page pool stats in proc") updated:
> 		- fix unused label warning from kernel test robot,
> 		- fixed page_pool_seq_show to only display the refill stat
> 		  once,
> 		- added a remove_proc_entry for page_pool_stat to
> 		  dev_proc_net_exit.
> 
> v1 -> v2:
> 	- A new kernel config option has been added, which defaults to N,
> 	   preventing this code from being compiled in by default
> 	- The stats structure has been converted to a per-cpu structure
> 	- The stats are now exported via proc (/proc/net/page_pool_stat)
> 
> Thanks.
> 
> [1]:
> https://lore.kernel.org/all/1643499540-8351-1-git-send-email-jdamato@fastly.com/T/#md82c6d5233e35bb518bc40c8fd7dff7a7a17e199
> 
> Joe Damato (10):
>    page_pool: kconfig: Add flag for page pool stats
>    page_pool: Add per-cpu page_pool_stats struct
>    page_pool: Add a macro for incrementing stats
>    page_pool: Add stat tracking fast path allocations
>    page_pool: Add slow path order 0 allocation stat
>    page_pool: Add slow path high order allocation stat
>    page_pool: Add stat tracking empty ring
>    page_pool: Add stat tracking cache refill
>    page_pool: Add a stat tracking waived pages
>    net-procfs: Show page pool stats in proc
> 
>   include/net/page_pool.h | 20 +++++++++++++++
>   net/Kconfig             | 12 +++++++++
>   net/core/net-procfs.c   | 67 +++++++++++++++++++++++++++++++++++++++++++++++++
>   net/core/page_pool.c    | 28 ++++++++++++++++++---
>   4 files changed, 124 insertions(+), 3 deletions(-)
> 

