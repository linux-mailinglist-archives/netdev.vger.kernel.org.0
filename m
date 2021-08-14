Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B38013EBFC8
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 04:32:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236725AbhHNCdA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 22:33:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236466AbhHNCc7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 22:32:59 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB188C061756
        for <netdev@vger.kernel.org>; Fri, 13 Aug 2021 19:32:31 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id a13so15709873iol.5
        for <netdev@vger.kernel.org>; Fri, 13 Aug 2021 19:32:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PU2ldgkvXDgGX6HP14m612YtpPPuLizt585RKwAdEhM=;
        b=UOPvdnsIe89kQQTVGUFkmBkWKiXvoGuV2j2U+CzJEH8HtnUesVCvpOnRVv7YVGfnGu
         GFKi5FGJKj26MbVjp4715QjO5iFMV+tqAoLEThdHrpmmLAC+TOTheTigKi2MIqA8eV+f
         geeuif3GnheJn6P4iOfw5xu0VmUIhS1ksdP2ihtd3jHJ/Acs09v9kmyaPUgDLj/GjFfc
         9/C5NrHQIoItmV0jdkovGeR9NwTGBcEE1XImeS9FjNG4wXq7ECR/eq6glku3qSmyfZBs
         NWftk4GBMlXPWJ9EqXGWRRgNeLB9OgJfCrQ6c/TAbeK7GA+Vt5fI7hB5QOoBe7phr5cc
         Az8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PU2ldgkvXDgGX6HP14m612YtpPPuLizt585RKwAdEhM=;
        b=CEk5whXIc3GJeNnecLa+pDJFF+4lbsOQbGnoiYzeFOhoQJcG3yGUJYE/Ig0JMkx81b
         jPFVfYQnud/Q4GPwt8MZxoGezNVYU+fCnzf87xBSYz2UPyS55XJaQFgp22CXO+1k56iq
         noPpstEBvMIfZKeGe6kSHLpp+Wr+FdX5VE5gubUZNhhpetihNKMB9DmIAg6byUGHpc3/
         MuBaa/YCqmWA+7QX7BBIdGAuG8AkCR1biD8gyh3oYMKw5vumKMO4qR8zHschEcRTAh0D
         /7elXiiwJhp0oPGIQh48LUlSnJIN+WU4NPaK/sNk/6CawXppBDHLlcHCXxLGg9It0XCQ
         46ng==
X-Gm-Message-State: AOAM530hWYZ3tWhi7e6ct66juzFQdrEwNlVEEo+AqflYScFHWaITmJtW
        p/0CWY8cP03RaWGW+pnvcGmN8w==
X-Google-Smtp-Source: ABdhPJwiKZ8W5F9y8TagqdAJJ0L8T+DU5npLwiTHPNpP2Ka2BC4ZXzHk3R9cyj0YI5AznqszAYwQgQ==
X-Received: by 2002:a6b:7209:: with SMTP id n9mr4373858ioc.67.1628908351375;
        Fri, 13 Aug 2021 19:32:31 -0700 (PDT)
Received: from [172.22.22.26] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id j20sm1941644ile.17.2021.08.13.19.32.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Aug 2021 19:32:31 -0700 (PDT)
Subject: Re: [PATCH net-next 3/6] net: ipa: re-enable transmit in PM WQ
 context
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, elder@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210812195035.2816276-1-elder@linaro.org>
 <20210812195035.2816276-4-elder@linaro.org>
 <20210813174406.5e7fc350@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Alex Elder <elder@linaro.org>
Message-ID: <1e17b9a9-4f04-bae7-b113-26c1944abbfc@linaro.org>
Date:   Fri, 13 Aug 2021 21:32:30 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210813174406.5e7fc350@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/13/21 7:44 PM, Jakub Kicinski wrote:
> On Thu, 12 Aug 2021 14:50:32 -0500 Alex Elder wrote:
>> +/**
>> + * ipa_modem_wake_queue_work() - enable modem netdev queue
>> + * @work:	Work structure
>> + *
>> + * Re-enable transmit on the modem network device.  This is called
>> + * in (power management) work queue context, scheduled when resuming
>> + * the modem.
>> + */
>> +static void ipa_modem_wake_queue_work(struct work_struct *work)
>> +{
>> +	struct ipa_priv *priv = container_of(work, struct ipa_priv, work);
>> +
>> +	netif_wake_queue(priv->ipa->modem_netdev);
>> +}
>> +
>>  /** ipa_modem_resume() - resume callback for runtime_pm
>>   * @dev: pointer to device
>>   *
>> @@ -205,7 +226,8 @@ void ipa_modem_resume(struct net_device *netdev)
>>  	ipa_endpoint_resume_one(ipa->name_map[IPA_ENDPOINT_AP_MODEM_TX]);
>>  	ipa_endpoint_resume_one(ipa->name_map[IPA_ENDPOINT_AP_MODEM_RX]);
>>  
>> -	netif_wake_queue(netdev);
>> +	/* Arrange for the TX queue to be restarted */
>> +	(void)queue_pm_work(&priv->work);
>>  }
> 
> Why move the wake call to a work queue, tho? It's okay to call it 
> from any context.

The issue isn't about the context in which is run (well, not
really, not in the sense you're talking about).

The issue has to do with the PM ->runtime_resume function
running concurrent with the network ->start_xmit function.

We need the hardware powered in ipa_start_xmit().  So we
call pm_runtime_get(), which will not block and which will
indicate in its return value whether power:  is active
(return is 1); will be active once the resume underway
completes (return is -EINPROGRESS); will be active once
suspend underway and a delayed resume completes (return
is 0); or will be active once the newly-scheduled resume
completes (return is 0, scheduled on PM work queue).
We don't expect any other error, but if we get one we
drop the packet.

If the return value is 1, power is active and we transmit
the packet.  If the return value indicates power is not
active, but will be, we stop the TX queue.  No other packets
should be passed to ->start_xmit until TX is started again.

We wish to restart the TX queue when the ipa_runtime_resume()
completes. Here is the call path:

    ipa_runtime_resume()	This is the ->runtime_resume PM op

      ipa_endpoint_resume()

        ipa_modem_resume()

          netif_wake_queue()	Without this patch


The instant netif_wake_queue() is called, we start getting
calls to ipa_start_xmit(), which again attempts to transmit
the SKB that caused the queue to be stopped.  And there is a
good chance that when that is called, the ipa_runtime_resume()
PM callback is still executing, and not complete.  In that case,
we'll *again* get an -EINPROGRESS back from pm_runtime_get() in
ipa_start_xmit(), and we stop the TX queue again.  Basically,
we're stuck.

All we need is for the TX queue to be started *after* the
PM ->runtime_resume callback completes and marks the the
PM runtime status ACTIVE.  Scheduling this on the PM
workqueue ensures this will happen then, if we happen
to be running ipa_runtime_resume() via that workqueue.
If not, there's a bit of a race but it should resolve
(but I think here lies the specific race you mentioned
in the other message).

I'm open to other suggestions, but my hope was to at least
explain why I did it this way.  I'll think about it over
the weekend and will send a new version of the series when
I come up with a solution.

Thank you very much for the review.

					-Alex
