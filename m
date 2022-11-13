Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04655626E19
	for <lists+netdev@lfdr.de>; Sun, 13 Nov 2022 08:38:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235187AbiKMHiI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Nov 2022 02:38:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229753AbiKMHiG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Nov 2022 02:38:06 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A482613DC6;
        Sat, 12 Nov 2022 23:38:05 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id z14so11894734wrn.7;
        Sat, 12 Nov 2022 23:38:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Xz5LWSGZs7Pr5mRciViejjBBpWRscqvYm2vCmgGQa5w=;
        b=WVYRDcra48rl03/kRbdf7tXsccX4U9ciLXcNM6Uy1nnT3ga4+p7WE3P6bBy002XKf+
         RpFPVP8zmYFadFl1vklvOVmK/fBVSpi7ekkET011bHdwbxUpZZ3bDOTaQ04cpCgZmBoF
         +4q7T8/H8lpUMfowiOamOYfNFhUpOedXhoi0bMIM27zgd9vHLPA5gTSxWzIvVpVf4OrI
         tzi60ropbaI0tIBKjKr2Mg85YXWBj4o5vrTCuHSpPlQ9/xm0xDTZn4JR6ALOpuX+8RTD
         SqQzX/FM0c3uK0VL/YNAMdjd1p2SstFYOA0HtCOPUuhQjPzT7Y7ZX961fVwUIar77OAc
         cWWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Xz5LWSGZs7Pr5mRciViejjBBpWRscqvYm2vCmgGQa5w=;
        b=4inxroNMAaP2fSRecEtY0hTN92YlqfhijNwaofCQfq6d3cBc7ZrSp+cYC2G9r+wmyk
         rTtyLR5IRejMOYWmcjLHyYoPy8LzOwLe5D9taqveUcLDVep3tDi917a1NVaHk9RW49RN
         49688w4LpuDjax3h+lBWicN5fO+kg/6iEaNjXvxEpJstlJY5cfrjd7TW9T9bfhwd66M5
         TwQOLaVEzp8WaGDoCgn4840XZL0MUpsHxbDmWSXaTaf03cgPmDKkqeFAva9lhDXJOh7g
         HIVAa10JrVzgbPGApI50icc0L3QhvEueHFiIESog21pACbAB19+Ki2d8BDWU6ZY+1gtb
         s07A==
X-Gm-Message-State: ANoB5plB0DLcD/t36wzPaqQ5SngxNmRxrDGF1BpIwkRfNCDTpPklwf4a
        HF3/wzsRGTyZEQJ22xyI8x0=
X-Google-Smtp-Source: AA0mqf54m5FkZs9heZuMngNiDvjHoXHJ1enGSCsU6bs6nbOX79GghVHTWOsVizbFkkI3irpIhrgktQ==
X-Received: by 2002:a5d:58d4:0:b0:230:7452:53cb with SMTP id o20-20020a5d58d4000000b00230745253cbmr4574223wrf.120.1668325084145;
        Sat, 12 Nov 2022 23:38:04 -0800 (PST)
Received: from [192.168.0.105] ([77.126.19.155])
        by smtp.gmail.com with ESMTPSA id d16-20020a5d6450000000b0022cc0a2cbecsm6268600wrw.15.2022.11.12.23.38.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 12 Nov 2022 23:38:03 -0800 (PST)
Message-ID: <a8c52fa8-f976-92a0-2948-843476a81efb@gmail.com>
Date:   Sun, 13 Nov 2022 09:37:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH 0/4] cpumask: improve on cpumask_local_spread() locality
Content-Language: en-US
To:     Yury Norov <yury.norov@gmail.com>, Jakub Kicinski <kuba@kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
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
        linux-crypto@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        "open list:HFI1 DRIVER" <linux-rdma@vger.kernel.org>
References: <20221111040027.621646-1-yury.norov@gmail.com>
 <20221111082551.7e71fbf4@kernel.org>
 <CAAH8bW9jG5US0Ymn1wax9tNK3MgZpcWfQsYgu-Km_E+WZw3yiA@mail.gmail.com>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <CAAH8bW9jG5US0Ymn1wax9tNK3MgZpcWfQsYgu-Km_E+WZw3yiA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/11/2022 6:47 PM, Yury Norov wrote:
> 
> 
> On Fri, Nov 11, 2022, 10:25 AM Jakub Kicinski <kuba@kernel.org 
> <mailto:kuba@kernel.org>> wrote:
> 
>     On Thu, 10 Nov 2022 20:00:23 -0800 Yury Norov wrote:
>      > cpumask_local_spread() currently checks local node for presence
>     of i'th
>      > CPU, and then if it finds nothing makes a flat search among all
>     non-local
>      > CPUs. We can do it better by checking CPUs per NUMA hops.
> 
>     Nice.
> 

Thanks for your series.
This improves them all, with no changes required to the network device 
drivers.

>      > This series is inspired by Valentin Schneider's "net/mlx5e:
>     Improve remote
>      > NUMA preferences used for the IRQ affinity hints"
>      >
>      >
>     https://patchwork.kernel.org/project/netdevbpf/patch/20220728191203.4055-3-tariqt@nvidia.com/ <https://patchwork.kernel.org/project/netdevbpf/patch/20220728191203.4055-3-tariqt@nvidia.com/>


Find my very first version here, including the perf testing results:
https://patchwork.kernel.org/project/netdevbpf/list/?series=660413&state=*


>      >
>      > According to Valentin's measurements, for mlx5e:
>      >
>      >       Bottleneck in RX side is released, reached linerate (~1.8x
>     speedup).
>      >       ~30% less cpu util on TX.
>      >
>      > This patch makes cpumask_local_spread() traversing CPUs based on NUMA
>      > distance, just as well, and I expect comparabale improvement for its
>      > users, as in Valentin's case.
>      >

Right.

>      > I tested it on my VM with the following NUMA configuration:
> 
>     nit: the authorship is a bit more complicated, it'd be good to mention
>     Tariq. Both for the code and attribution of the testing / measurements.
> 
> 
> Sure. Tariq and Valentine please send your tags as appropriate.
> 

I wonder what fits best here?

As the contribution is based upon previous work that I developed, then 
probably:
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Thanks,
Tariq
