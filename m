Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 970DD6A0FFB
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 20:00:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbjBWTAv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 14:00:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbjBWTAu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 14:00:50 -0500
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E12383773A
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 11:00:49 -0800 (PST)
Received: by mail-il1-x12a.google.com with SMTP id r4so3046499ila.2
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 11:00:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google; t=1677178849;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3FH+mZDW/QOoOgNYLudSSgUaanZuMZX/8Q2EA3JXTgs=;
        b=hKqu3nX8H5dReF/ZQVh4dCMoJeOhYiu+7OCUf017U5pmc8ivh0jEDEvqS6BZSb28zD
         g8/8mjt0MuTRivBph7WP9ARKlD+t5OudVeF8h2I0nFA6qgdzPLsUY1jVQ5r+ysVHLN9j
         G7PlVVMP1vB4EV3XjEvpKFo5PjTSLe7+IhFZs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677178849;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3FH+mZDW/QOoOgNYLudSSgUaanZuMZX/8Q2EA3JXTgs=;
        b=f4Q/4r6MXnuELkScNsvSH0/uD2CIUhudq8qH75qMcys1PfKlLYW7VrNA03/6dKhD/H
         gcqq2r7XcJF4vPo0z7k+lWNPWwd1AszsR3LeaTt6WyMeEDEn2WlRLWbkCL6oeZT9RWWr
         q9x6Pa8HoyKD2IiyNksFeVkyo4FXoKYOxgivoNY2U0ds2Sw+aFVzVdqj3CeVfwsK26eL
         kQ6x/ruu5vo2RScCuPuf/EUYbmbNiLadDIZmlzOGnwgztZZM389pRbe2QWWrmm5cd/w0
         broVol5sakFYTHYr8DlLUVOuqiEK9+ueR/xClKXi5epJ0tbiFC73RYjJVvf/iwWcyY5W
         oRfA==
X-Gm-Message-State: AO0yUKXw6Ama7g23L9iIpotQdEU2uyqEmMKzIHIRKvr/jdIHK+JuWNN3
        cB+XDi31jrf4WI0W2k6IWe702Q==
X-Google-Smtp-Source: AK7set/e6j3aKHJxlNZx86/UZvN6ZeB2LDswhEsFz1XHMYT6E4bFReMBaFnyiHmbYym2RoLg7LNDQw==
X-Received: by 2002:a05:6e02:1a04:b0:315:3fe4:1d0a with SMTP id s4-20020a056e021a0400b003153fe41d0amr8947579ild.0.1677178849238;
        Thu, 23 Feb 2023 11:00:49 -0800 (PST)
Received: from [192.168.0.41] ([70.57.89.124])
        by smtp.gmail.com with ESMTPSA id 11-20020a92c64b000000b003141da56c78sm3225063ill.0.2023.02.23.11.00.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Feb 2023 11:00:48 -0800 (PST)
Message-ID: <c264614a-ec6b-8793-0513-d0ad8c58f745@cloudflare.com>
Date:   Thu, 23 Feb 2023 13:00:47 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: BUG: using __this_cpu_add() in preemptible in tcp_make_synack()
To:     Frank Hofmann <fhofmann@cloudflare.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, pabeni@redhat.com
References: <2d2ad1e5-8b03-0c59-4cf1-6a5cc85bbd94@cloudflare.com>
 <CANn89iJvOPH9rJ4YjRP-i99beY3g+moLnRQH2ED-CQX7QnDYpA@mail.gmail.com>
 <fd9d9040-1721-b882-885f-71a4aeef9454@cloudflare.com>
 <CANn89iLMUP8_HnmmstGHxh7iR+EqPdEAUNM7OfyDdHJFNdBu3g@mail.gmail.com>
 <CABEBQimj8Jk659Xb+gNgW_dVub+euLwM6XGrPvkrPaEb=9GH+A@mail.gmail.com>
 <CANn89iJvoqq=X=9Kr7GYf=YtBFBOrOkGboKsd7FLdMqYV0PE=A@mail.gmail.com>
 <CABEBQi=UQn11f7SzeXFSgorQCvj=CU43eNQX_UKcXR4HF-eM-w@mail.gmail.com>
Content-Language: en-US
From:   Frederick Lawler <fred@cloudflare.com>
In-Reply-To: <CABEBQi=UQn11f7SzeXFSgorQCvj=CU43eNQX_UKcXR4HF-eM-w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/15/23 2:25 AM, Frank Hofmann wrote:
> Hi Eric,
> 
> On Tue, Feb 14, 2023 at 7:59 PM Eric Dumazet <edumazet@google.com> wrote:
>>
>> On Tue, Feb 14, 2023 at 6:14 PM Frank Hofmann <fhofmann@cloudflare.com> wrote:
>>>
>>> Hi Eric,
>>>
> [ ... ]
>> Thanks for the report.
>>
>> I think the following patch should help, please let me know if any
>> more issues are detected.
> [ ... ]
> 
> We'll give this a shot and let you know if we see anything else.
> Thank you!
> 
> FrankH.

Hi Eric,

We began rolling out the update on the 14th and haven't seen any more 
messages crop up in our logs. We'd like to check again after another 
week or so, but so far the two patches are promising.

Fred
