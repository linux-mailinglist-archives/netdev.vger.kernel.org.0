Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ED3467FD82
	for <lists+netdev@lfdr.de>; Sun, 29 Jan 2023 09:08:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230138AbjA2III (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Jan 2023 03:08:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbjA2IIH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Jan 2023 03:08:07 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1BBC12F24;
        Sun, 29 Jan 2023 00:08:03 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id d14so8456001wrr.9;
        Sun, 29 Jan 2023 00:08:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lfLvX+h7dXHOBDCZOU5BYDr/d44mVPnFEAIaaBtTNZ4=;
        b=HyVwwWfU8Ll50zyC1wvl0OKDx170Y7xZxKQwMToKvkqboqnQ1W6ZLDXgwPiqp7YuUK
         fmAKg8T/D/3ROlqGy7SA61kapillDEmpYVPt8OybaXp/OSOsLsQezTyUrHiyN1fDoM3e
         EMu4YUTn6ocUnXjDTVd9Slb1N4HDb2nAbr7oGL4vli+BNST04RTir/tVHVSPvoOQl6mf
         ONf2EzdLP6wg5bcoCK04bOJKFOXoA0vEYIbK3/AC3Spm9JEkYei8fBFDXUrIUcMowBqd
         +Z/CbiLYoXxa7kfz53T6FqSwixqEmh5k8G9EvkEaKg++O+ksyX5MZEnr60jxkayadloN
         SkeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lfLvX+h7dXHOBDCZOU5BYDr/d44mVPnFEAIaaBtTNZ4=;
        b=xEGBeoHRG4SNgS0gQDoDOJh8+FwpuQKpv25jFJj7TQVqHd5Yxbgk3d1UeYzGrP+46v
         17qRKhO092GdFuZKrSeT0oqXDJTAS6qnyKE6Ujo4dD27tJCWJTFtX6ScVYmq0Uwv7K7N
         rJDZma8pSNZLBxXxQ553/rnHju6jMPSZ6YGVCslns8QMM5OC/pnQfrTREd7qedzKxshI
         Hb4z+bGWVf4EVRsc3/Q0Z8i11CyQ/MP7KIhxR+2g7AkXiyxjYbKY/oI4If3QRreYHthJ
         +efSjg4kB/gCOoq0H3ry1Q1pZ40CJOcobz8B73EF+dHC0Qvt27Sr96GW7K2CwyIEMsdP
         pijQ==
X-Gm-Message-State: AFqh2kpR6arAdD61FkWDX0HLN74M9Am+IGt3Nf/RuZ/+ziEQnaaQCFTF
        6b0Lj3Wwlm0u7g71ukuVPTI=
X-Google-Smtp-Source: AMrXdXuQ2DLZwgyUgnmklx1KxRouHizUxMiWIQHG9FtBZ8QWbiK7lW5/sM2Q0SGTw4fZIdPaUSZbOQ==
X-Received: by 2002:a05:6000:1708:b0:2bd:db1c:8dfe with SMTP id n8-20020a056000170800b002bddb1c8dfemr45534383wrc.48.1674979682420;
        Sun, 29 Jan 2023 00:08:02 -0800 (PST)
Received: from [192.168.0.106] ([77.126.163.156])
        by smtp.gmail.com with ESMTPSA id q4-20020adff944000000b002bfae3f6802sm8469044wrr.58.2023.01.29.00.07.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 Jan 2023 00:08:01 -0800 (PST)
Message-ID: <4fa5d53d-d614-33b6-2d33-156281420507@gmail.com>
Date:   Sun, 29 Jan 2023 10:07:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH RESEND 0/9] sched: cpumask: improve on
 cpumask_local_spread() locality
Content-Language: en-US
To:     Valentin Schneider <vschneid@redhat.com>,
        Yury Norov <yury.norov@gmail.com>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Barry Song <baohua@kernel.org>,
        Ben Segall <bsegall@google.com>,
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
        Leon Romanovsky <leonro@nvidia.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>,
        Peter Lafreniere <peter@n8pjl.ca>,
        Peter Zijlstra <peterz@infradead.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Tony Luck <tony.luck@intel.com>,
        Vincent Guittot <vincent.guittot@linaro.org>
Cc:     linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
References: <20230121042436.2661843-1-yury.norov@gmail.com>
 <4dc2a367-d3b1-e73e-5f42-166e9cf84bac@gmail.com>
 <xhsmhv8kxh8tk.mognet@vschneid.remote.csb>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <xhsmhv8kxh8tk.mognet@vschneid.remote.csb>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 23/01/2023 11:57, Valentin Schneider wrote:
> On 22/01/23 14:57, Tariq Toukan wrote:
>> On 21/01/2023 6:24, Yury Norov wrote:
>>>
>>> This series was supposed to be included in v6.2, but that didn't happen. It
>>> spent enough in -next without any issues, so I hope we'll finally see it
>>> in v6.3.
>>>
>>> I believe, the best way would be moving it with scheduler patches, but I'm
>>> OK to try again with bitmap branch as well.
>>
>> Now that Yury dropped several controversial bitmap patches form the PR,
>> the rest are mostly in sched, or new API that's used by sched.
>>
>> Valentin, what do you think? Can you take it to your sched branch?
>>
> 
> I would if I had one :-)
> 

Oh I see :)

> Peter/Ingo, any objections to stashing this in tip/sched/core?
> 

Hi Peter and Ingo,

Can you please look into it? So we'll have enough time to act (in 
case...) during this kernel.

We already missed one kernel...

Thanks,
Tariq
