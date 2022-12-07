Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4099D645A35
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 13:54:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbiLGMyP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 07:54:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229753AbiLGMyI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 07:54:08 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 938BE5217D;
        Wed,  7 Dec 2022 04:54:07 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id fc4so13684006ejc.12;
        Wed, 07 Dec 2022 04:54:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3wHEueCe02/dFo7mDV34CjEc4Hqty62444bWhBRSbJ4=;
        b=VzNNWJf1AddOafMP3bB5Jbnh04AX1NzHjVhFQA7rKO7lzu+Y9HTI9wgx2Xl9ojcDzK
         s+D3GU5oT6JD3rhB7arH48dXPoYnxgzLx4GlXrIqnVwsg6sgG/A8DHkkwgdgYZygW7LJ
         WYdrR6JS3jYsPycNHsP0LFCt5DDkSeO7BcCrLeaW8H8/QasiZR0aC3uGtSzkLkPWWXIg
         m9w3hTuF188F9NDur0WwC+CpYuj3ubkJQ0N7GqsYEnrg80OFVwex3ofZlMf014sOi5ja
         VZ5QHiSsXgaOLa0vqbc8QZMlNd52akbeeHaaH7OQVMOb8VrFpw7h0ouL06vw6ZPVJxLy
         4Bjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3wHEueCe02/dFo7mDV34CjEc4Hqty62444bWhBRSbJ4=;
        b=opo9NHeulkFpvm8P4XUVFI6U7CLROf0GLJUps7yE1+MGFml3ixNEwKU3HlVT0dpbVg
         jB9A0keTD6MrocBUd1P299ixlkd4VKhRPOqRyz0cPwhuB9VVVkUsQusiLxENc5OkTsdJ
         pH8c90Y3/9hzKcy1bF6f4T7Am+uBbd8WFD7hqTLjM5bJzCXnhg45srCyi+4QdFe6nm7W
         xcDCJR86i5aVnPRcYoBnHq6tRbUGEHiZWuzhMANl+f6Ok7N5QYrPgrSsMLtqRul6IURc
         zBReUMHYx+4OsQteqH4teawOyMM2vftFbl/u1Ky5ef4wiVpv5nbKiL7zLSHV48FG0uQ7
         imnQ==
X-Gm-Message-State: ANoB5pmcZ5d522NBfXGVcqhZg8YRfYLT20uBGtFtDpumQLWiL93dpp7U
        c9rlo5h/MwtZWR8GvsrFnC8=
X-Google-Smtp-Source: AA0mqf5rJ8Y2G5K8J77Da+1fY6fh0SokcCUuw7mN1S5LXHOpp/KJnxOL0OG+9lxX8aLNgrMq9yk9mA==
X-Received: by 2002:a17:906:258d:b0:7c0:aea3:a9a8 with SMTP id m13-20020a170906258d00b007c0aea3a9a8mr23156206ejb.718.1670417645965;
        Wed, 07 Dec 2022 04:54:05 -0800 (PST)
Received: from [192.168.0.105] ([77.126.19.155])
        by smtp.gmail.com with ESMTPSA id j16-20020a170906535000b007c0f2c4cdffsm3671712ejo.44.2022.12.07.04.54.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Dec 2022 04:54:05 -0800 (PST)
Message-ID: <19cbfb5e-22b1-d9c1-8d50-38714e3eaf7d@gmail.com>
Date:   Wed, 7 Dec 2022 14:53:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v2 0/4] cpumask: improve on cpumask_local_spread()
 locality
Content-Language: en-US
To:     Yury Norov <yury.norov@gmail.com>
Cc:     Valentin Schneider <vschneid@redhat.com>,
        linux-kernel@vger.kernel.org,
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
 <665b6081-be55-de9a-1f7f-70a143df329d@gmail.com>
 <Y4a2MBVEYEY+alO8@yury-laptop>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <Y4a2MBVEYEY+alO8@yury-laptop>
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



On 11/30/2022 3:47 AM, Yury Norov wrote:
> On Mon, Nov 28, 2022 at 08:39:24AM +0200, Tariq Toukan wrote:
>>
>>
>> On 11/17/2022 2:23 PM, Valentin Schneider wrote:
>>> On 15/11/22 10:32, Yury Norov wrote:
>>>> On Tue, Nov 15, 2022 at 05:24:56PM +0000, Valentin Schneider wrote:
>>>>>
>>>>> Is this meant as a replacement for [1]?
>>>>
>>>> No. Your series adds an iterator, and in my experience the code that
>>>> uses iterators of that sort is almost always better and easier to
>>>> understand than cpumask_nth() or cpumask_next()-like users.
>>>>
>>>> My series has the only advantage that it allows keep existing codebase
>>>> untouched.
>>>>
>>>
>>> Right
>>>
>>>>> I like that this is changing an existing interface so that all current
>>>>> users directly benefit from the change. Now, about half of the users of
>>>>> cpumask_local_spread() use it in a loop with incremental @i parameter,
>>>>> which makes the repeated bsearch a bit of a shame, but then I'm tempted to
>>>>> say the first point makes it worth it.
>>>>>
>>>>> [1]: https://lore.kernel.org/all/20221028164959.1367250-1-vschneid@redhat.com/
>>>>
>>>> In terms of very common case of sequential invocation of local_spread()
>>>> for cpus from 0 to nr_cpu_ids, the complexity of my approach is n * log n,
>>>> and your approach is amortized O(n), which is better. Not a big deal _now_,
>>>> as you mentioned in the other email. But we never know how things will
>>>> evolve, right?
>>>>
>>>> So, I would take both and maybe in comment to cpumask_local_spread()
>>>> mention that there's a better alternative for those who call the
>>>> function for all CPUs incrementally.
>>>>
>>>
>>> Ack, sounds good.
>>>
>>
>> Good.
>> Is a respin needed, to add the comment mentioned above?
> 
> If you think it's worth the effort.

No, not sure it is...

I asked because this mail thread was inactive for a while, with the 
patches not accepted to the kernel yet.

If everyone is happy with it, let's make it to this kernel while possible.

To which tree should it go?

Thanks,
Tariq
