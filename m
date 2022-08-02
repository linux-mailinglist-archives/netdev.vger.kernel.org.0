Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8558587726
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 08:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234754AbiHBGk4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 02:40:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233010AbiHBGky (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 02:40:54 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2D549FDD;
        Mon,  1 Aug 2022 23:40:53 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id z17so11912710wrq.4;
        Mon, 01 Aug 2022 23:40:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=IBE6oYJZEYEN3t94Kkqip3PQk025mzEaqe0abRjhYPo=;
        b=bUiR7Imm0ZElpLBSf6cH/ivmOClW2r/W6fzyOuhmKgMiz/VIPS5+z3UOTuh6W9cqB7
         Xzh37Cpj6jioElqOOmiF2tvTMdF49j51u4GAQ8C7LJV9GCWEQZ9P3x/dBd3b9dPygrOM
         uce6m7fmEnU656oaFsf8sG7/Uj5iUwxXKyorXvVWqsFOfAL6gCTWiE7VBL1Y3aa+u+gF
         3ZlLHwXrBJyHRadzrZZNFZ6q38Q8jEUek+5GruFa2vBRkAXYwMqLPa5cLVNqP9bTd/lm
         SOcsCI1AUJOfTEc7qQEq+HlHHXmhy+8Y665F2N7yx3IBlvWMPIYXNSg4Kdicc+aiAgt7
         Dg5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=IBE6oYJZEYEN3t94Kkqip3PQk025mzEaqe0abRjhYPo=;
        b=J/HQ6lU3WtYjkyZ1s3GsjYbsfgI8C6rj+jqEFaSHuVtIxcK3UyOwsRJD5tIrLSj//j
         2BVHHPC76H9MhYhPjrjM/bYL34Ansv+U30OpvLfLITbcBh3jWw/jRAHWepY6b85zx3Uw
         w9b74IRlTzd/nZ/lax++E97upabHkid4LiziRx2fLEmjeFtgmhMpLWKg9aQqxaRdOt6+
         7+y+KccrNMNy3QBowpBokD0KDA2XxrPSSFmAfrDghk6VpmoFeMWqtPaLnLh0d6ai9aYM
         2vWflAmaym4NowbogewMYXAxC2vmGF2grK4N69HGuKnqORKGiA+WtLL7SsAlr3I5S5lG
         2kLQ==
X-Gm-Message-State: ACgBeo1yOWxaQ1J2g+Ww7xFvEitH9ikrXPDehyeM14Ka3BSJ1CHqLwaL
        zp8pb0RXuslUVcp67GPawrw=
X-Google-Smtp-Source: AA6agR6mDz+qPv0z5ckA8n/R3OqrI9vVZ+MTU18cVPhlC+wZC7KwkgiK6oM93nlqqkMO82cSCoPPfg==
X-Received: by 2002:a05:6000:1789:b0:220:626a:b69a with SMTP id e9-20020a056000178900b00220626ab69amr5651076wrg.579.1659422452467;
        Mon, 01 Aug 2022 23:40:52 -0700 (PDT)
Received: from [192.168.0.104] ([77.126.166.31])
        by smtp.gmail.com with ESMTPSA id k41-20020a05600c1ca900b003a2e5f536b3sm23451555wms.24.2022.08.01.23.40.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Aug 2022 23:40:52 -0700 (PDT)
Message-ID: <9401f754-d4d6-9fbd-7354-3103ececddda@gmail.com>
Date:   Tue, 2 Aug 2022 09:40:49 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next V4 1/3] sched/topology: Add NUMA-based CPUs
 spread API
Content-Language: en-US
To:     Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Valentin Schneider <vschneid@redhat.com>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Ben Segall <bsegall@google.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Gal Pressman <gal@nvidia.com>, linux-kernel@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>
References: <20220728191203.4055-1-tariqt@nvidia.com>
 <20220728191203.4055-2-tariqt@nvidia.com>
 <7f1ab968-cc10-f0a7-cac8-63dd60021493@gmail.com>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <7f1ab968-cc10-f0a7-cac8-63dd60021493@gmail.com>
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



On 7/30/2022 8:29 PM, Tariq Toukan wrote:
> 
> 
> On 7/28/2022 10:12 PM, Tariq Toukan wrote:
>> Implement and expose API that sets the spread of CPUs based on distance,
>> given a NUMA node.  Fallback to legacy logic that uses
>> cpumask_local_spread.
>>
>> This logic can be used by device drivers to prefer some remote cpus over
>> others.
>>
>> Reviewed-by: Gal Pressman <gal@nvidia.com>
>> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
>> ---
>>   include/linux/sched/topology.h |  5 ++++
>>   kernel/sched/topology.c        | 49 ++++++++++++++++++++++++++++++++++
>>   2 files changed, 54 insertions(+)
>>
> 
> ++
> 
> Dear SCHEDULER maintainers,
> 
> V3 of my series was submitted ~12 days ago and had significant changes.
> I'd appreciate your review to this patch, so we could make it to the 
> upcoming kernel.
> 
> Regards,
> Tariq

Hi,
Another reminder.
Do you have any comments on this patch?
If not, please provide your Ack.
