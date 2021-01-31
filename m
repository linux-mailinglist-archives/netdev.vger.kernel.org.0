Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FFA4309C9B
	for <lists+netdev@lfdr.de>; Sun, 31 Jan 2021 15:14:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231459AbhAaOOU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jan 2021 09:14:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231879AbhAaN3I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jan 2021 08:29:08 -0500
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED66CC06174A
        for <netdev@vger.kernel.org>; Sun, 31 Jan 2021 05:11:56 -0800 (PST)
Received: by mail-il1-x136.google.com with SMTP id g7so11911705iln.2
        for <netdev@vger.kernel.org>; Sun, 31 Jan 2021 05:11:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ot6vWHnfPIpcpEIXnX1FR6G/0Gh4xATqpaqCaCqtjpo=;
        b=oxoTGE0uwxn3yJRPJSVn0kxvT/nDLqRwZ5QvfdJJr4H/zOUch+MHHxITm6Rj4eCdWG
         fC+C3HN8deQQP+vMVZvjLWc9iSzSImYi0IjIMGU7mICF6N9Dza1cPGmlUhtg59jSHS3G
         /GqFz6JjLJT/8M1J2PddTW4ua0GMrIsUqbpegRDN+Igob/HbQAKXK81JiVlVGK6vA1eB
         jCygXTWD9qwOFVQd0qEgby55OMRWG+X8Tw2cYxaGlaXH1Pm03a7ibUQ3YSNL7NSHeMoZ
         8XSjTfqZDSBw6Uty/Il9H7qJ0UHFTxSSvENc4Nv6TjDXLCLPR1Nm1KcMDKWHeUWKl3hn
         EeXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ot6vWHnfPIpcpEIXnX1FR6G/0Gh4xATqpaqCaCqtjpo=;
        b=fxYDORT0R12iFkU66C73hE/zuhMND7flkM31Do8dLcYwESjuGV7H5Qbj+Bg+jEQJkS
         udOmifG3QJVWJBtn6obM6MmjZbrixT7on38lJk8KJi2d/e9U9nM4dQkaeKGUh/viO8x2
         LDpVzuPLFg6ROcv4KDQoK663o2NqWlQHT9LFNTc01VaxeqicFyKOuWwxbM2sU5MWr4vE
         TE1hO/J0veVfOmY89J4SeI31JMR53MOTSTqJaoNKlUVfcThIVx/gRJJXqym68oPIuszB
         fM+Gszw36N2cVqD96zkfGfiNsyyCYiPxexd1BdVUFPrIhZvfDTo5aN05AapVDQ5V17ix
         vxsw==
X-Gm-Message-State: AOAM533ffzQah7m15Rkeo9esDERGNzLCxZkQpNECaOcnZ73IG+tRwklQ
        5+yMNW8zIkPwW4JeM23rZSuHuA==
X-Google-Smtp-Source: ABdhPJyHXBRh3MAL4W8QH8UMHsKZBBg/6pH5WvtfRcNfPYOBlqOaRQ2gqahIklV2ka7G5NEWFIg60Q==
X-Received: by 2002:a92:ca81:: with SMTP id t1mr10124757ilo.139.1612098716231;
        Sun, 31 Jan 2021 05:11:56 -0800 (PST)
Received: from [172.22.22.26] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id u3sm7758797ilg.48.2021.01.31.05.11.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 31 Jan 2021 05:11:55 -0800 (PST)
Subject: Re: [PATCH net-next 9/9] net: ipa: don't disable NAPI in suspend
From:   Alex Elder <elder@linaro.org>
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
Message-ID: <b135f936-e51c-a6a8-511a-ccc316f2dab6@linaro.org>
Date:   Sun, 31 Jan 2021 07:11:54 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <e27f5c10-7b77-1f12-fe36-e9261f01bca1@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/30/21 10:29 PM, Alex Elder wrote:
> On 1/30/21 9:25 AM, Willem de Bruijn wrote:
>> On Fri, Jan 29, 2021 at 3:29 PM Alex Elder <elder@linaro.org> wrote:
>>>
>>> The channel stop and suspend paths both call __gsi_channel_stop(),
>>> which quiesces channel activity, disables NAPI, and (on other than
>>> SDM845) stops the channel.  Similarly, the start and resume paths
>>> share __gsi_channel_start(), which starts the channel and re-enables
>>> NAPI again.
>>>
>>> Disabling NAPI should be done when stopping a channel, but this
>>> should *not* be done when suspending.  It's not necessary in the
>>> suspend path anyway, because the stopped channel (or suspended
>>> endpoint on SDM845) will not cause interrupts to schedule NAPI,
>>> and gsi_channel_trans_quiesce() won't return until there are no
>>> more transactions to process in the NAPI polling loop.
>>
>> But why is it incorrect to do so?
> 
> Maybe it's not; I also thought it was fine before, but...
> 
> Someone at Qualcomm asked me why I thought NAPI needed
> to be disabled on suspend.  My response was basically
> that it was a lightweight operation, and it shouldn't
> really be a problem to do so.
> 
> Then, when I posted two patches last month, Jakub's
> response told me he didn't understand why I was doing
> what I was doing, and I stepped back to reconsider
> the details of what was happening at suspend time.
> 
> https://lore.kernel.org/netdev/20210107183803.47308e23@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com/

I should have mentioned that *this* response from Jakub
to a question I had also led to my conclusion that NAPI
should not be disabled on suspend--at least for IPA.
  https://lore.kernel.org/netdev/20210105122328.3e5569a4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com/

The channel is *not* reset on suspend for IPA.

					-Alex

> Four things were happening to suspend a channel:
> quiesce activity; disable interrupt; disable NAPI;
> and stop the channel.  It occurred to me that a
> stopped channel would not generate interrupts, so if
> the channel was stopped earlier there would be no need
> to disable the interrupt.  Similarly there would be
> (essentially) no need to disable NAPI once a channel
> was stopped.
> 
> Underlying all of this is that I started chasing a
> hang that was occurring on suspend over a month ago.
> It was hard to reproduce (hundreds or thousands of
> suspend/resume cycles without hitting it), and one
> of the few times I actually hit the problem it was
> stuck in napi_disable(), apparently waiting for
> NAPI_STATE_SCHED to get cleared by napi_complete().
> 
> My best guess about how this could occur was if there
> were a race of some kind between the interrupt handler
> (scheduling NAPI) and the poll function (completing
> it).  I found a number of problems while looking
> at this, and in the past few weeks I've posted some
> fixes to improve things.  Still, even with some of
> these fixes in place we have seen a hang (but now
> even more rarely).
> 
> So this grand rework of suspending/stopping channels
> is an attempt to resolve this hang on suspend.
> 
> The channel is now stopped early, and once stopped,
> everything that completed prior to the channel being
> stopped is polled before considering the suspend
> function done.  A stopped channel won't interrupt,
> so we don't bother disabling the completion interrupt,
> with no interrupts, NAPI won't be scheduled, so there's
> no need to disable NAPI either.
> 
> The net result is simpler, and seems logical, and
> should preclude any possible race between the interrupt
> handler and poll function.  I'm trying to solve the
> hang problem analytically, because it takes *so* long
> to reproduce.
> 
> I'm open to other suggestions.
> 
>                     -Alex
> 
>>  From a quick look, virtio-net disables on both remove and freeze, for instance.
>>
>>> Instead, enable NAPI in gsi_channel_start(), when the completion
>>> interrupt is first enabled.  Disable it again in gsi_channel_stop(),
>>> when finally disabling the interrupt.
>>>
>>> Add a call to napi_synchronize() to __gsi_channel_stop(), to ensure
>>> NAPI polling is done before moving on.
>>>
>>> Signed-off-by: Alex Elder <elder@linaro.org>
>>> ---
>> =
>>> @@ -894,12 +894,16 @@ int gsi_channel_start(struct gsi *gsi, u32 channel_id)
>>>          struct gsi_channel *channel = &gsi->channel[channel_id];
>>>          int ret;
>>>
>>> -       /* Enable the completion interrupt */
>>> +       /* Enable NAPI and the completion interrupt */
>>> +       napi_enable(&channel->napi);
>>>          gsi_irq_ieob_enable_one(gsi, channel->evt_ring_id);
>>>
>>>          ret = __gsi_channel_start(channel, true);
>>> -       if (ret)
>>> -               gsi_irq_ieob_disable_one(gsi, channel->evt_ring_id);
>>> +       if (!ret)
>>> +               return 0;
>>> +
>>> +       gsi_irq_ieob_disable_one(gsi, channel->evt_ring_id);
>>> +       napi_disable(&channel->napi);
>>>
>>>          return ret;
>>>   }
>>
>> subjective, but easier to parse when the normal control flow is linear
>> and the error path takes a branch (or goto, if reused).
>>
> 

