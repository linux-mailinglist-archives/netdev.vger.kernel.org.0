Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A82A2309D96
	for <lists+netdev@lfdr.de>; Sun, 31 Jan 2021 16:35:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232782AbhAaPeU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jan 2021 10:34:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231873AbhAaPdc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jan 2021 10:33:32 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C20E1C061573
        for <netdev@vger.kernel.org>; Sun, 31 Jan 2021 07:32:37 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id q7so721983iob.0
        for <netdev@vger.kernel.org>; Sun, 31 Jan 2021 07:32:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Moq/B8BrYp6nPC2nQpSj/M+miyOIifA1JFRE4Gpgdx0=;
        b=T3/P/ZXzNwW8xzgWibQPCEMp3wRnVNfT9KZbj2A+zXtpIHQGrq/ic++Juo+BviCrIb
         oz+LhYFch4bTw47hoi3/pZFZJO42WTqmrMqStHbaf6+GmVb/saADqNgZkD62aS9qHi6u
         iuzrc3Yl4VrNVkcWD20qtPkKyacby+Y6ZjJNnryk5FssZk2U5QyhzK59//inNGhXUKWm
         fyEOq6mnin4+temmKkHcMMypgzfjBO+/nVb4dLo4oaWvQYZq2kzqpINd/6fUTJscm2RU
         xo4hKHljFhIxq/g7IwVbNTUKlkNT2QCO9R/3VFxiYo2V7qRCVoWlmRRmSemVT0/Fu3IT
         80tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Moq/B8BrYp6nPC2nQpSj/M+miyOIifA1JFRE4Gpgdx0=;
        b=Uz/pwEQxpdPrHz6ZnQVS8UyfYj6tRNmgi5qMAhu/R3v4QEoxYJaU3jNF0OwAia93Bm
         F8R9jt4aMfrTvOPbXbACHTb9pWUWpTooJAGeKbi8IAL2/mT/N7iLqlTGEoBLoruyuLZB
         +k2dgxDBvh9FiOPSKc9hX2Sq0fGjJbTNZZhdPL8kNOrUcxY1Xd9VK+DpMDUGOZMsNWA0
         qHnLw3QvyWKyKojt+F5vhMCbcsY+4iXVYECHOH9llz9hUoGVyvYJJA8NVryCwsq3Ref6
         Iq4aaluSJOp0vdy+8IEZfpzHkoPBicjpsV9rryYSH9JLwrZ2QMhbonbtacUNDtDqhvwU
         IoQg==
X-Gm-Message-State: AOAM5322q3mWyDRlvRFNdE/e/txAydfX54sX89XF9EzBmhaJvJQLMjAH
        W7/xCjaCHWDHySoxWrhjHI0FtA==
X-Google-Smtp-Source: ABdhPJyPS/eT9DjV0Z1Dxe/6pMydowrmSeyBRtf4XZxDPbqJHggp0dzPCSZnaz9IQ0Q42bDA8RvaVA==
X-Received: by 2002:a5d:9588:: with SMTP id a8mr9630786ioo.34.1612107156816;
        Sun, 31 Jan 2021 07:32:36 -0800 (PST)
Received: from [172.22.22.26] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id b2sm7181415iot.4.2021.01.31.07.32.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 31 Jan 2021 07:32:36 -0800 (PST)
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
 <e27f5c10-7b77-1f12-fe36-e9261f01bca1@linaro.org>
 <CAF=yD-+4xNjgkWQw8tMz0uvK45ysL6vnx86ZgEud+kCW9zw9_A@mail.gmail.com>
From:   Alex Elder <elder@linaro.org>
Message-ID: <67f4aa5a-4a60-41e6-a049-0ff93fb87b66@linaro.org>
Date:   Sun, 31 Jan 2021 09:32:35 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <CAF=yD-+4xNjgkWQw8tMz0uvK45ysL6vnx86ZgEud+kCW9zw9_A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/31/21 8:52 AM, Willem de Bruijn wrote:
> On Sat, Jan 30, 2021 at 11:29 PM Alex Elder <elder@linaro.org> wrote:
>>
>> On 1/30/21 9:25 AM, Willem de Bruijn wrote:
>>> On Fri, Jan 29, 2021 at 3:29 PM Alex Elder <elder@linaro.org> wrote:
>>>>
>>>> The channel stop and suspend paths both call __gsi_channel_stop(),
>>>> which quiesces channel activity, disables NAPI, and (on other than
>>>> SDM845) stops the channel.  Similarly, the start and resume paths
>>>> share __gsi_channel_start(), which starts the channel and re-enables
>>>> NAPI again.
>>>>
>>>> Disabling NAPI should be done when stopping a channel, but this
>>>> should *not* be done when suspending.  It's not necessary in the
>>>> suspend path anyway, because the stopped channel (or suspended
>>>> endpoint on SDM845) will not cause interrupts to schedule NAPI,
>>>> and gsi_channel_trans_quiesce() won't return until there are no
>>>> more transactions to process in the NAPI polling loop.
>>>
>>> But why is it incorrect to do so?
>>
>> Maybe it's not; I also thought it was fine before, but...
>>
>> Someone at Qualcomm asked me why I thought NAPI needed
>> to be disabled on suspend.  My response was basically
>> that it was a lightweight operation, and it shouldn't
>> really be a problem to do so.
>>
>> Then, when I posted two patches last month, Jakub's
>> response told me he didn't understand why I was doing
>> what I was doing, and I stepped back to reconsider
>> the details of what was happening at suspend time.
>>
>> https://lore.kernel.org/netdev/20210107183803.47308e23@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com/
>>
>> Four things were happening to suspend a channel:
>> quiesce activity; disable interrupt; disable NAPI;
>> and stop the channel.  It occurred to me that a
>> stopped channel would not generate interrupts, so if
>> the channel was stopped earlier there would be no need
>> to disable the interrupt.  Similarly there would be
>> (essentially) no need to disable NAPI once a channel
>> was stopped.
>>
>> Underlying all of this is that I started chasing a
>> hang that was occurring on suspend over a month ago.
>> It was hard to reproduce (hundreds or thousands of
>> suspend/resume cycles without hitting it), and one
>> of the few times I actually hit the problem it was
>> stuck in napi_disable(), apparently waiting for
>> NAPI_STATE_SCHED to get cleared by napi_complete().
> 
> This is important information.
> 
> What exactly do you mean by hang?

Yes it's important!  Unfortunately I was not able to
gather details about the problem in all the cases where
it occurred.  But in at least one case I *did* confirm
it was in the situation described above.

What I mean by "hang" is that the system simply stopped
on its way down, and the IPA ->suspend callback never
completed (stuck in napi_disable).  So I expect that
the SCHED flag was never going to get cleared (because
of a race, presumably).

>> My best guess about how this could occur was if there
>> were a race of some kind between the interrupt handler
>> (scheduling NAPI) and the poll function (completing
>> it).  I found a number of problems while looking
>> at this, and in the past few weeks I've posted some
>> fixes to improve things.  Still, even with some of
>> these fixes in place we have seen a hang (but now
>> even more rarely).
>>
>> So this grand rework of suspending/stopping channels
>> is an attempt to resolve this hang on suspend.
> 
> Do you have any data that this patchset resolves the issue, or is it
> too hard to reproduce to say anything?

The data I have is that I have been running for weeks
with tens of thousands of iterations with this patch
(and the rest of them) without any hang.  Unfortunately
that doesn't guarantee anything.  I contemplated trying
to "catch" the problem and report that it *would have*
occurred had the fix not been in place, but I haven't
tried that (in part because it might not be easy).

So...  Too hard to reproduce, but I have evidence that
my testing so far has never reproduced the hang.

>> The channel is now stopped early, and once stopped,
>> everything that completed prior to the channel being
>> stopped is polled before considering the suspend
>> function done.
> 
> Does the call to gsi_channel_trans_quiesce before
> gsi_channel_stop_retry leave a race where new transactions may occur
> until state GSI_CHANNEL_STATE_STOPPED is reached? Asking without truly
> knowing the details of this device.

It should not.  For TX endpoints that have a net device, new
requests will have been stopped earlier by netif_stop_queue()
(in ipa_modem_suspend()).  For RX endpoints, receive buffers
are replenished to the hardware, but we stop that earlier
as well, in ipa_endpoint_suspend_one().  So the quiesce call
is meant to figure out what the last submitted request was
for an endpoint (channel), and then wait for that to complete.

The "hang" occurs on an RX endpoint, and in particular it
occurs on an endpoint that we *know* will be receiving a
packet as part of the suspend process (when clearing the
hardware pipeline).  I can go into that further but won't'
unless asked.

>> A stopped channel won't interrupt,
>> so we don't bother disabling the completion interrupt,
>> with no interrupts, NAPI won't be scheduled, so there's
>> no need to disable NAPI either.
> 
> That sounds plausible. But it doesn't explain why napi_disable "should
> *not* be done when suspending" as the commit states.
> 
> Arguably, leaving that won't have much effect either way, and is in
> line with other drivers.

Understood and agreed.  In fact, if the hang occurrs in
napi_disable() when waiting for NAPI_STATE_SCHED to clear,
it would occur in napi_synchronize() as well.  At this point
it's more about the whole set of rework here, and keeping
NAPI enabled during suspend seems a little cleaner.

See my followup message, about Jakub's assertion that NAPI
assumes the device will be *reset* when NAPI is disabled.
(I'm not convinced NAPI assumes that, but that doesn't matter.)
In any case, the IPA hardware does *not* reset channels when
suspended.

> Your previous patchset mentions "When stopping a channel, the IPA
> driver currently disables NAPI before disabling the interrupt." That
> would no longer be the case.

I'm not sure which patch you're referring to (and I'm in
a hurry at the moment).  But yes, with this patch we would
only disable NAPI when "really" stopping the channel, not
when suspending it.  And we'd similarly be no longer
disabling the completion interrupt on suspend either.

Thanks a lot, I appreciate the help and input on this.

					-Alex

>> The net result is simpler, and seems logical, and
>> should preclude any possible race between the interrupt
>> handler and poll function.  I'm trying to solve the
>> hang problem analytically, because it takes *so* long
>> to reproduce.
>>
>> I'm open to other suggestions.
>>
>>                                         -Alex
>>
>>>  From a quick look, virtio-net disables on both remove and freeze, for instance.
>>>
>>>> Instead, enable NAPI in gsi_channel_start(), when the completion
>>>> interrupt is first enabled.  Disable it again in gsi_channel_stop(),
>>>> when finally disabling the interrupt.
>>>>
>>>> Add a call to napi_synchronize() to __gsi_channel_stop(), to ensure
>>>> NAPI polling is done before moving on.
>>>>
>>>> Signed-off-by: Alex Elder <elder@linaro.org>
>>>> ---
>>> =
>>>> @@ -894,12 +894,16 @@ int gsi_channel_start(struct gsi *gsi, u32 channel_id)
>>>>          struct gsi_channel *channel = &gsi->channel[channel_id];
>>>>          int ret;
>>>>
>>>> -       /* Enable the completion interrupt */
>>>> +       /* Enable NAPI and the completion interrupt */
>>>> +       napi_enable(&channel->napi);
>>>>          gsi_irq_ieob_enable_one(gsi, channel->evt_ring_id);
>>>>
>>>>          ret = __gsi_channel_start(channel, true);
>>>> -       if (ret)
>>>> -               gsi_irq_ieob_disable_one(gsi, channel->evt_ring_id);
>>>> +       if (!ret)
>>>> +               return 0;
>>>> +
>>>> +       gsi_irq_ieob_disable_one(gsi, channel->evt_ring_id);
>>>> +       napi_disable(&channel->napi);
>>>>
>>>>          return ret;
>>>>   }
>>>
>>> subjective, but easier to parse when the normal control flow is linear
>>> and the error path takes a branch (or goto, if reused).
>>>
>>

