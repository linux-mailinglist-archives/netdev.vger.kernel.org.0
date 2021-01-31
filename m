Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0527C309A34
	for <lists+netdev@lfdr.de>; Sun, 31 Jan 2021 05:30:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbhAaEaF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 23:30:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbhAaEaD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jan 2021 23:30:03 -0500
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0634C061574
        for <netdev@vger.kernel.org>; Sat, 30 Jan 2021 20:29:22 -0800 (PST)
Received: by mail-il1-x12e.google.com with SMTP id a1so12432961ilr.5
        for <netdev@vger.kernel.org>; Sat, 30 Jan 2021 20:29:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gXawIvFETXLi83aoT08mO+Z1JKCGEIEXvFdsTFOkKvY=;
        b=Os3BfSboy+O0cTtNGMkPUvJqV5POK5d7rjHDx7aIYrjhI98QP7+mC6YiYxNwXHqKkT
         56pJLwUcaTNBG85o9zeKQPHvZTvMHZURPuq2QyPwndBnsPuGyOvGEv+YSmjBVN5IB1us
         wK8Gzjiz/P8WPX3EruHcyTjEQcOPLUrC2WPxmFFANC5Oo1DEgYM5pKl284j0W3ogrtQ2
         TjeWJr0vfo9FpnHfGsFqJn2WDl0FDfExMUs1cfab+Z+iwJ3D1tNJ0i8KfJ+OrylPhzQq
         GsP3ecMallgPkKaWOmrNwLYD9UZGd+wS0Ka4QEWPGCAt5G5ZYrkcB7mBbOw1d7peT2/c
         eJTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gXawIvFETXLi83aoT08mO+Z1JKCGEIEXvFdsTFOkKvY=;
        b=es/1Nb6+MM/FCQZlSdOr2oYW48vPPg2WPhIKhtEs25sHgiaYlIUj6p5WYM3nFPxbwH
         iTqDAFrP8En+GYN+7kRXxFfL7KrrOOxZr+Jc/6Kge+AAwUEG21IfwVb56iSkCFZzqToX
         d7rQjpDiw+LMGtQGRUZnFPKhA4QR4Ytlqd5dsgxXEYoPYGUNJVIfHiatu8NZIq3xjdMQ
         1+ZWBTV/l56SE0iVxekeqn189Tfb7H+3/8IdS7fwbFDNiy107G04lVdBKOo5uxGs5G6I
         hr9Gufzh8r27sUot/NsThnG5JNiuT8YMi3ZyOqsTVAVuwww4Jt9lmkZzdnmTo1tEoGo0
         wO8Q==
X-Gm-Message-State: AOAM530A+cgJQk9jdRjDLTISkuhoOnqgnu34GHnoThl6yqV8LL6moH01
        tWqKmSX5qTYNN682fMO+nQ072Q==
X-Google-Smtp-Source: ABdhPJxto5jnnoVH48xH16+rDgHCc4RgPNjxQQhUGmM1NVWIga2+lDnL1oPuVIjtdLHPXHRNavXVkQ==
X-Received: by 2002:a05:6e02:c9:: with SMTP id r9mr5760472ilq.304.1612067361104;
        Sat, 30 Jan 2021 20:29:21 -0800 (PST)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id i4sm6512490ios.54.2021.01.30.20.29.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 Jan 2021 20:29:20 -0800 (PST)
Subject: Re: [PATCH net-next 9/9] net: ipa: don't disable NAPI in suspend
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, elder@kernel.org,
        evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20210129202019.2099259-1-elder@linaro.org>
 <20210129202019.2099259-10-elder@linaro.org>
 <CAF=yD-L1SKzu+gsma7KN4VjGnma-_w+amXx=Y_0e78rQiUCu7Q@mail.gmail.com>
From:   Alex Elder <elder@linaro.org>
Message-ID: <e27f5c10-7b77-1f12-fe36-e9261f01bca1@linaro.org>
Date:   Sat, 30 Jan 2021 22:29:19 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <CAF=yD-L1SKzu+gsma7KN4VjGnma-_w+amXx=Y_0e78rQiUCu7Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/30/21 9:25 AM, Willem de Bruijn wrote:
> On Fri, Jan 29, 2021 at 3:29 PM Alex Elder <elder@linaro.org> wrote:
>>
>> The channel stop and suspend paths both call __gsi_channel_stop(),
>> which quiesces channel activity, disables NAPI, and (on other than
>> SDM845) stops the channel.  Similarly, the start and resume paths
>> share __gsi_channel_start(), which starts the channel and re-enables
>> NAPI again.
>>
>> Disabling NAPI should be done when stopping a channel, but this
>> should *not* be done when suspending.  It's not necessary in the
>> suspend path anyway, because the stopped channel (or suspended
>> endpoint on SDM845) will not cause interrupts to schedule NAPI,
>> and gsi_channel_trans_quiesce() won't return until there are no
>> more transactions to process in the NAPI polling loop.
> 
> But why is it incorrect to do so?

Maybe it's not; I also thought it was fine before, but...

Someone at Qualcomm asked me why I thought NAPI needed
to be disabled on suspend.  My response was basically
that it was a lightweight operation, and it shouldn't
really be a problem to do so.

Then, when I posted two patches last month, Jakub's
response told me he didn't understand why I was doing
what I was doing, and I stepped back to reconsider
the details of what was happening at suspend time.
 
https://lore.kernel.org/netdev/20210107183803.47308e23@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com/

Four things were happening to suspend a channel:
quiesce activity; disable interrupt; disable NAPI;
and stop the channel.  It occurred to me that a
stopped channel would not generate interrupts, so if
the channel was stopped earlier there would be no need
to disable the interrupt.  Similarly there would be
(essentially) no need to disable NAPI once a channel
was stopped.

Underlying all of this is that I started chasing a
hang that was occurring on suspend over a month ago.
It was hard to reproduce (hundreds or thousands of
suspend/resume cycles without hitting it), and one
of the few times I actually hit the problem it was
stuck in napi_disable(), apparently waiting for
NAPI_STATE_SCHED to get cleared by napi_complete().

My best guess about how this could occur was if there
were a race of some kind between the interrupt handler
(scheduling NAPI) and the poll function (completing
it).  I found a number of problems while looking
at this, and in the past few weeks I've posted some
fixes to improve things.  Still, even with some of
these fixes in place we have seen a hang (but now
even more rarely).

So this grand rework of suspending/stopping channels
is an attempt to resolve this hang on suspend.

The channel is now stopped early, and once stopped,
everything that completed prior to the channel being
stopped is polled before considering the suspend
function done.  A stopped channel won't interrupt,
so we don't bother disabling the completion interrupt,
with no interrupts, NAPI won't be scheduled, so there's
no need to disable NAPI either.

The net result is simpler, and seems logical, and
should preclude any possible race between the interrupt
handler and poll function.  I'm trying to solve the
hang problem analytically, because it takes *so* long
to reproduce.

I'm open to other suggestions.

					-Alex

>  From a quick look, virtio-net disables on both remove and freeze, for instance.
> 
>> Instead, enable NAPI in gsi_channel_start(), when the completion
>> interrupt is first enabled.  Disable it again in gsi_channel_stop(),
>> when finally disabling the interrupt.
>>
>> Add a call to napi_synchronize() to __gsi_channel_stop(), to ensure
>> NAPI polling is done before moving on.
>>
>> Signed-off-by: Alex Elder <elder@linaro.org>
>> ---
> =
>> @@ -894,12 +894,16 @@ int gsi_channel_start(struct gsi *gsi, u32 channel_id)
>>          struct gsi_channel *channel = &gsi->channel[channel_id];
>>          int ret;
>>
>> -       /* Enable the completion interrupt */
>> +       /* Enable NAPI and the completion interrupt */
>> +       napi_enable(&channel->napi);
>>          gsi_irq_ieob_enable_one(gsi, channel->evt_ring_id);
>>
>>          ret = __gsi_channel_start(channel, true);
>> -       if (ret)
>> -               gsi_irq_ieob_disable_one(gsi, channel->evt_ring_id);
>> +       if (!ret)
>> +               return 0;
>> +
>> +       gsi_irq_ieob_disable_one(gsi, channel->evt_ring_id);
>> +       napi_disable(&channel->napi);
>>
>>          return ret;
>>   }
> 
> subjective, but easier to parse when the normal control flow is linear
> and the error path takes a branch (or goto, if reused).
> 

