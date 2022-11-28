Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9238E63A15B
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 07:39:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbiK1Gjd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 01:39:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbiK1Gjc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 01:39:32 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10C60765A;
        Sun, 27 Nov 2022 22:39:31 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id v7so7740591wmn.0;
        Sun, 27 Nov 2022 22:39:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6ZP1ylYuB931He9kk8GqfGKGVdTe0/xxKDzeNsx5WHg=;
        b=Q/0zk6OrJTK2ohpu3j6XjbFlf56MyfSIa4Z1tm0DKAGmqkFWRvjqh/pogN33JUh6+d
         KcbID+lSrRK4GNRottCJzP7EBO+sU6WddqLplEqaSHC4sjo8wSbcRtHW5USoXjTbFgJU
         qYSsqLujMUh7qw/GKeoohEqFqcwtI90SZwICoIra9rDvQjhcn29W8IYJyd+CPbncPCVy
         tNu0nactn1Oduszo2rLGpfUGXdaxgrkyXJmGPVOrOVRQkIGzL6FQfRxocNwvnTyJWcdK
         fj+buJi5gqe+3XsiJGQNNgBzoOEhs2WEq5hzaUPKOcfhx26NG9EqzHQ8VbiO06LQmVMI
         2yZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6ZP1ylYuB931He9kk8GqfGKGVdTe0/xxKDzeNsx5WHg=;
        b=nT3py2LOvjfLkXWJZQMvnCapCS+3T1QnkdY7SHETNCHYHO5g2KvFtlMGqEI1B9NzeZ
         vcq+OD42PwNyJqd8uEGgrmJaQ1iaARxmbniDCJJbWERSaMuQBq7nHiy1PnbD4pVZb2c8
         H9uw7V9dd5cxWs+ctVyxkug+OuSU17VteRiLkYXRL6lsPAhL7fGr2OPregWTOeoStb3R
         ikQrpnOdTJqBuWXxk6RR5vG99oYDR65jJsazC0iFn7V20Slv08B/KGdQTe4RuNTbuQIU
         7GSwVuiDXa17zBOCDe64oh1oQ5pCGw/PV8kydzvDVrx8u/kxuKfEvZ17NpmYEuXtj6OE
         s9gw==
X-Gm-Message-State: ANoB5plApdCmdvvQRW5KQTCOnmrJmgX0kQG7LyBLNdJ4T9mTxK6i9Wr6
        2mGntbPf4F/xTXJisYqscaE=
X-Google-Smtp-Source: AA0mqf5XTQo0xaTTj5q8Jf6pcNIjrZpz56YG4bKZ069nB2tce5CRwaDJZSBu5wGRkmmSkR+aTuXGqQ==
X-Received: by 2002:a05:600c:19d1:b0:3cf:cf89:90f with SMTP id u17-20020a05600c19d100b003cfcf89090fmr26492753wmq.186.1669617569525;
        Sun, 27 Nov 2022 22:39:29 -0800 (PST)
Received: from [192.168.0.105] ([77.126.19.155])
        by smtp.gmail.com with ESMTPSA id u2-20020a056000038200b00241cfe6e286sm9757300wrf.98.2022.11.27.22.39.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 27 Nov 2022 22:39:28 -0800 (PST)
Message-ID: <665b6081-be55-de9a-1f7f-70a143df329d@gmail.com>
Date:   Mon, 28 Nov 2022 08:39:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v2 0/4] cpumask: improve on cpumask_local_spread()
 locality
Content-Language: en-US
To:     Valentin Schneider <vschneid@redhat.com>,
        Yury Norov <yury.norov@gmail.com>
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
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
References: <20221112190946.728270-1-yury.norov@gmail.com>
 <xhsmh7czwyvtj.mognet@vschneid.remote.csb> <Y3PXw8Hqn+RCMg2J@yury-laptop>
 <xhsmho7t5ydke.mognet@vschneid.remote.csb>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <xhsmho7t5ydke.mognet@vschneid.remote.csb>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/17/2022 2:23 PM, Valentin Schneider wrote:
> On 15/11/22 10:32, Yury Norov wrote:
>> On Tue, Nov 15, 2022 at 05:24:56PM +0000, Valentin Schneider wrote:
>>>
>>> Is this meant as a replacement for [1]?
>>
>> No. Your series adds an iterator, and in my experience the code that
>> uses iterators of that sort is almost always better and easier to
>> understand than cpumask_nth() or cpumask_next()-like users.
>>
>> My series has the only advantage that it allows keep existing codebase
>> untouched.
>>
> 
> Right
> 
>>> I like that this is changing an existing interface so that all current
>>> users directly benefit from the change. Now, about half of the users of
>>> cpumask_local_spread() use it in a loop with incremental @i parameter,
>>> which makes the repeated bsearch a bit of a shame, but then I'm tempted to
>>> say the first point makes it worth it.
>>>
>>> [1]: https://lore.kernel.org/all/20221028164959.1367250-1-vschneid@redhat.com/
>>
>> In terms of very common case of sequential invocation of local_spread()
>> for cpus from 0 to nr_cpu_ids, the complexity of my approach is n * log n,
>> and your approach is amortized O(n), which is better. Not a big deal _now_,
>> as you mentioned in the other email. But we never know how things will
>> evolve, right?
>>
>> So, I would take both and maybe in comment to cpumask_local_spread()
>> mention that there's a better alternative for those who call the
>> function for all CPUs incrementally.
>>
> 
> Ack, sounds good.
> 

Good.
Is a respin needed, to add the comment mentioned above?
