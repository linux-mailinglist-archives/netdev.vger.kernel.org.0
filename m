Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E951C48B90F
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 21:58:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236224AbiAKU6U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 15:58:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233024AbiAKU6T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 15:58:19 -0500
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC6CFC06173F
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 12:58:18 -0800 (PST)
Received: by mail-il1-x12a.google.com with SMTP id o20so369907ill.0
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 12:58:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=2ahL35IHg4dlOtunupJ1fxmYljQSk3/XbWgiVkXrlmE=;
        b=N4vS5CS8ixDl8/0fNwwcktNYhkEtFyc/8sMh8Cq2rT9QgkxShpADpmvBaExjxOBKJi
         xowxh6/L+x1Zx3w+kjH0KVk/IKH66JcFc6R9Ejp8+vpVorvzZd1Ugz+RKow5iqaC+uUt
         VC35K/brHYm8PsyZxQBEVHY28Xl6jU7/8qEntpeO4i7lzW708YjLyNpmA/+Xdbrmk80G
         QFCNS1tZcK38BfWKRFMa0xitepV2loD9mIk+Ukdd8w+EGF6KCejdWMq3blDEgVsCppxK
         e7yZJpWEtFICRKYAIqSPSEk//RZ5NExbr4nbeinxZs1bMpqfuixWtISHfyzXeepWNlVk
         t+1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=2ahL35IHg4dlOtunupJ1fxmYljQSk3/XbWgiVkXrlmE=;
        b=MzLROGK0njAtMO+UIE3pqsTVI6GkGecWiitJ5yVibD3Ns4sAEViQD5hhTTmOWYK5t9
         CGCVnmZdjs7c6et7Wj7do77OEttAJLKlsiqFSvFLmKZSXZ/+NPsVqIAx59t8BzDXnH6G
         0SI7uIRj48f+7kbiPIrFYE5IkKKWkCnx3kgthh+uUKYZEKwicb3/2RMs4gdV0isXzpLq
         jpXjsZmTMpK/LxOBaKJWa7R5TRocPH4O3ytDlU1Xqw81W94iM/Zz90CjyQHWThaEKLql
         TU0t2wQjjuFR1G5MoVv1B5m77+qos0U25yrZ+nYvDbwfu6NcctSPloDT5GwwWz9P6w8v
         tgZw==
X-Gm-Message-State: AOAM532vJ9kkRJdka5us8lL0/dVv2ZM9K7b/NdHWLcJ8nu/ynt2JHfzL
        Dij7sBHo0cDZHjvgVhkozHTHzPg/cpk2Iw==
X-Google-Smtp-Source: ABdhPJx3vgWaeNGH1OUkN3n0xRSrikREwz/P4b5PvMZTs52hZUMLeLUa7D2Q5BtANMLmFQ//5iA+gw==
X-Received: by 2002:a05:6e02:1748:: with SMTP id y8mr1729519ill.305.1641934698241;
        Tue, 11 Jan 2022 12:58:18 -0800 (PST)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id f12sm267143ioh.50.2022.01.11.12.58.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Jan 2022 12:58:17 -0800 (PST)
Message-ID: <7a145d96-9c33-b91d-b0cd-ed2fb8ef6cb4@linaro.org>
Date:   Tue, 11 Jan 2022 14:58:16 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH net 2/2] net: ipa: prevent concurrent replenish
Content-Language: en-US
To:     Matthias Kaehlcke <mka@chromium.org>, Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, jponduru@codeaurora.org,
        avuyyuru@codeaurora.org, bjorn.andersson@linaro.org,
        agross@kernel.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, evgreen@chromium.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220111192150.379274-1-elder@linaro.org>
 <20220111192150.379274-3-elder@linaro.org> <Yd3miKw2AIY8Rr0F@google.com>
From:   Alex Elder <elder@linaro.org>
In-Reply-To: <Yd3miKw2AIY8Rr0F@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/11/22 2:20 PM, Matthias Kaehlcke wrote:
> On Tue, Jan 11, 2022 at 01:21:50PM -0600, Alex Elder wrote:
>> We have seen cases where an endpoint RX completion interrupt arrives
>> while replenishing for the endpoint is underway.  This causes another
>> instance of replenishing to begin as part of completing the receive
>> transaction.  If this occurs it can lead to transaction corruption.
>>
>> Use a new atomic variable to ensure only replenish instance for an
>> endpoint executes at a time.
>>
>> Fixes: 84f9bd12d46db ("soc: qcom: ipa: IPA endpoints")
>> Signed-off-by: Alex Elder <elder@linaro.org>
>> ---
>>   drivers/net/ipa/ipa_endpoint.c | 13 +++++++++++++
>>   drivers/net/ipa/ipa_endpoint.h |  2 ++
>>   2 files changed, 15 insertions(+)
>>
>> diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
>> index 8b055885cf3cf..a1019f5fe1748 100644
>> --- a/drivers/net/ipa/ipa_endpoint.c
>> +++ b/drivers/net/ipa/ipa_endpoint.c
>> @@ -1088,15 +1088,27 @@ static void ipa_endpoint_replenish(struct ipa_endpoint *endpoint, bool add_one)
>>   		return;
>>   	}
>>   
>> +	/* If already active, just update the backlog */
>> +	if (atomic_xchg(&endpoint->replenish_active, 1)) {
>> +		if (add_one)
>> +			atomic_inc(&endpoint->replenish_backlog);
>> +		return;
>> +	}
>> +
>>   	while (atomic_dec_not_zero(&endpoint->replenish_backlog))
>>   		if (ipa_endpoint_replenish_one(endpoint))
>>   			goto try_again_later;
> 
> I think there is a race here, not sure whether it's a problem: If the first
> interrupt is here just when a 2nd interrupt evaluates 'replenish_active' the
> latter will return, since it looks like replenishing is still active, when it
> actually just finished. Would replenishing be kicked off anyway shortly after
> or could the transaction be stalled until another endpoint RX completion
> interrupt arrives?

I acknowledge the race you point out.  You're saying another
thread could test the flag after the while loop exits, but
before the flag gets reset to 0.  And that means that other
thread would skip the replenishing it would otherwise do.

To be honest, that is a different scenario than the one I
was trying to prevent, because it involves two threads, rather
than one thread entering this function a second time (via an
interrupt).  But regardless, I think it's OK.

The replenishing loop is intentionally tolerant of errors.
It will send as many receive buffers to the hardware as there
is room for, but will stop and "try again later" if an
error occurs.   Even if the specific case you mention
occurred it wouldn't be a problem because we'd get another
shot at it.  I'll explain.


The replenish_backlog is the number of "open slots" the hardware
has to hold a receive buffer.  When the backlog reaches 0, the
hardware is "full."

When a receive operation completes (in ipa_endpoint_rx_complete())
it calls ipa_endpoint_replenish(), requesting that we add one to
the backlog (to account for the buffer just consumed).  What this
means is that if the hardware has *any* receive buffers, a
replenish will eventually be requested (when one completes).

The logic in ipa_endpoint_replenish() tolerates an error
attempting to send a new receive buffer to the hardware.
If that happens, we just try again later--knowing that
the next RX completion will trigger that retry.

The only case where we aren't guaranteed a subsequent call
to ipa_endpoint_replenish() is when the hardware has *zero*
receive buffers, or the backlog is the maximum.  In that
case we explicitly schedule a new replenish via delayed
work.

Now, two more points.
- If the while loop exits without an error replenishing,
   the hardware is "full", so there are buffers that will
   complete, and trigger a replenish call.  So if the race
   occurred, it would be harmless.
- If the while loop exits because of an error replenishing
   one buffer, it jumps to try_again_later.  In that case,
   either the hardware has at least one receive buffer (so
   we'll get another replenish), or it has none and we will
   schedule delayed work to to schedule another replenish.

So I think that even if the race you point out occurs, the
replenish logic will eventually get another try.

I don't claim my logic is flawless; if it's wrong I can
find another solution.

Thanks.

					-Alex

PS  I will be implementing some improvements to this logic
     soon, but this is a simple bug fix for back-port.


>> +
>> +	atomic_set(&endpoint->replenish_active, 0);
>> +
>>   	if (add_one)
>>   		atomic_inc(&endpoint->replenish_backlog);
>>   
>>   	return;
>>   
>>   try_again_later:
>> +	atomic_set(&endpoint->replenish_active, 0);
>> +
>>   	/* The last one didn't succeed, so fix the backlog */
>>   	delta = add_one ? 2 : 1;
>>   	backlog = atomic_add_return(delta, &endpoint->replenish_backlog);
>> @@ -1691,6 +1703,7 @@ static void ipa_endpoint_setup_one(struct ipa_endpoint *endpoint)
>>   		 * backlog is the same as the maximum outstanding TREs.
>>   		 */
>>   		endpoint->replenish_enabled = false;
>> +		atomic_set(&endpoint->replenish_active, 0);
>>   		atomic_set(&endpoint->replenish_saved,
>>   			   gsi_channel_tre_max(gsi, endpoint->channel_id));
>>   		atomic_set(&endpoint->replenish_backlog, 0);
>> diff --git a/drivers/net/ipa/ipa_endpoint.h b/drivers/net/ipa/ipa_endpoint.h
>> index 0a859d10312dc..200f093214997 100644
>> --- a/drivers/net/ipa/ipa_endpoint.h
>> +++ b/drivers/net/ipa/ipa_endpoint.h
>> @@ -53,6 +53,7 @@ enum ipa_endpoint_name {
>>    * @netdev:		Network device pointer, if endpoint uses one
>>    * @replenish_enabled:	Whether receive buffer replenishing is enabled
>>    * @replenish_ready:	Number of replenish transactions without doorbell
>> + * @replenish_active:	1 when replenishing is active, 0 otherwise
>>    * @replenish_saved:	Replenish requests held while disabled
>>    * @replenish_backlog:	Number of buffers needed to fill hardware queue
>>    * @replenish_work:	Work item used for repeated replenish failures
>> @@ -74,6 +75,7 @@ struct ipa_endpoint {
>>   	/* Receive buffer replenishing for RX endpoints */
>>   	bool replenish_enabled;
>>   	u32 replenish_ready;
>> +	atomic_t replenish_active;
>>   	atomic_t replenish_saved;
>>   	atomic_t replenish_backlog;
>>   	struct delayed_work replenish_work;		/* global wq */
>> -- 
>> 2.32.0
>>

