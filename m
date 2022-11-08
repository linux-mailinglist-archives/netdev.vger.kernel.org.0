Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2565620F04
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 12:26:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234099AbiKHLZ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 06:25:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234151AbiKHLZd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 06:25:33 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D255F4D5DB;
        Tue,  8 Nov 2022 03:25:31 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id y16so20412786wrt.12;
        Tue, 08 Nov 2022 03:25:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JnjUyk4orA11aKk4ZfXfB066xwU2JxSgzP0UrUCR36I=;
        b=eXFFGndn5T1sviflNGr++RU3ahBMhVuCp04eodh3oW8pHaz61C1zaOZMPxvpsbkWyU
         g4QLHTcy9H7z+h+8Qnib96W57U1hPW6zPNjNHKJ74w47BSqhX9QA1tGf1qAZxGw3F+jf
         Xx1UvW5wbQuCF786qvuShtDw5KOP9Vv4BRXbI3XvSg39zEAy6vcvB8GjnfDAuDG5QJsX
         Yp60KJVmES0k434SLd8h9rlR3tcOZS6xpqOdwH+Yq28LMOuSLOq4Dg3juy0cKVTkTYlP
         wQB8nrYJlsN3/Ts5L+nf5DW4H4KGJh8QqfNxihTnV9gxtFxjQ2zR4lSwqdzrk2CqHVp2
         qsqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JnjUyk4orA11aKk4ZfXfB066xwU2JxSgzP0UrUCR36I=;
        b=ku2ikuo3Z0Z6q5S2UwVnFHhw+VkvwmF6Hm5u42P+XL7f6TE4ORhJ7e8I7cD0Ddgnn2
         3GOIQ9aRQYbFws6qlZYttm9tJsBe7jKNk4dN9bVEO6nIDWjdTvgaCDQc5OZb1OpkT2sK
         rtPc5XFx1Azp8vwc4SumIVxstdfYftiOYlKJ2K9cXZSwck+flUM/yJ9a5xWL00c5a1zE
         IB7VxG8gAPdN5g4jWjU6d8RpXwZ5y3iataeLMS5Ab+fAwPPKw60gaj0d1byB3pWfvk9E
         GB9KXIV3WB3u5DxfYdLw6IuRbySdxfHDzZq4GnzeKQST+60gUVdFM1ineQ38I7762f5E
         DHpA==
X-Gm-Message-State: ACrzQf1fouh14zNt+EKTZJ58eUcsClkUmAzTzm/nr6Cbi3R2zu8WpDcw
        IXiya8NRwtT+jkXQ4QoxFhs=
X-Google-Smtp-Source: AMsMyM6FFhVpSk/IvvwtgsSDSXsKetnEtWhkjwpHVK4lNJsHKej3dDnQbotGOn0svhPuoAWzePHHjg==
X-Received: by 2002:a05:6000:2c1:b0:236:d474:f053 with SMTP id o1-20020a05600002c100b00236d474f053mr28449679wry.517.1667906730344;
        Tue, 08 Nov 2022 03:25:30 -0800 (PST)
Received: from [10.158.37.55] ([193.47.165.251])
        by smtp.gmail.com with ESMTPSA id bn23-20020a056000061700b002305cfb9f3dsm10077457wrb.89.2022.11.08.03.25.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Nov 2022 03:25:29 -0800 (PST)
Message-ID: <ca6a5aee-19c8-e0a9-60af-00e2e5abaed0@gmail.com>
Date:   Tue, 8 Nov 2022 13:25:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.2
Subject: Re: [PATCH v6 0/3] sched, net: NUMA-aware CPU spreading interface
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Valentin Schneider <vschneid@redhat.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
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
        Heiko Carstens <hca@linux.ibm.com>,
        Tony Luck <tony.luck@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Gal Pressman <gal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
References: <20221028164959.1367250-1-vschneid@redhat.com>
 <20221102195616.6f55c894@kernel.org>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <20221102195616.6f55c894@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/3/2022 4:56 AM, Jakub Kicinski wrote:
> On Fri, 28 Oct 2022 17:49:56 +0100 Valentin Schneider wrote:
>> Tariq pointed out in [1] that drivers allocating IRQ vectors would benefit
>> from having smarter NUMA-awareness (cpumask_local_spread() doesn't quite cut
>> it).
>>
>> The proposed interface involved an array of CPUs and a temporary cpumask, and
>> being my difficult self what I'm proposing here is an interface that doesn't
>> require any temporary storage other than some stack variables (at the cost of
>> one wild macro).
>>
>> [1]: https://lore.kernel.org/all/20220728191203.4055-1-tariqt@nvidia.com/
> 
> Not sure who's expected to take these, no preference here so:
> 
> Acked-by: Jakub Kicinski <kuba@kernel.org>
> 
> Thanks for ironing it out!

Thanks Jakub.

Valentin, what do you think?
Shouldn't it go through the sched branch?
