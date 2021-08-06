Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FE753E29DB
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 13:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245578AbhHFLkH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 07:40:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245584AbhHFLkE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 07:40:04 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1843BC061799
        for <netdev@vger.kernel.org>; Fri,  6 Aug 2021 04:39:48 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id f11so10850636ioj.3
        for <netdev@vger.kernel.org>; Fri, 06 Aug 2021 04:39:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xGnaeWiZTs5fNQR2qA95KLEQMbyD+we6yJVFMP2FLC4=;
        b=nBmOWHMXBB2v1kM+XTASXE939Pqft9mRyJjKVm3taVZEKZHzRrWoHkvwppnc1sMm14
         UAjTX6HsouJ1O1XkrAUDBwdnoEp1SjbSXejkBxo+Gk0Az6FvLxOyDhuiOoVVU//xGosN
         koVDPTMvexPQk00728yWQBsuI3WclJ/9CcLUkyEjg4Amnl+LvFTeRDblvbViA15ZLV4p
         vW50q88DqI8MrCKbLct52+En2nXy7EQdB0DCKqop5bHmOkiQ1WFDY3ikf8LW/HQXDxap
         5v9GI9YcUvAZgOHnX8iROS2k8GUAlPeumvhiHC3eGo4K8EMwtvqU8DbGoM9tJlyL1rcl
         YGKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xGnaeWiZTs5fNQR2qA95KLEQMbyD+we6yJVFMP2FLC4=;
        b=qT7uBR1RVt6bs4xj3JIVySrBePcjbzsP4n6fFt2+mX6Kog+WVWUMIJ4pmUHwM4Px4/
         69HpCeYJo/ByMF4AuI5z2lwlYP2ALFLnOmRf0X8P1jiAlSO6tVH3StVc7inx3FkADe2/
         HKKzwrkzZuVt3iQzjMgtfVJ51YBy7j4lPChPCnIm5Inpjr7QhgYbRB+H4i6aUvqq+DbX
         Xpr3lnUueZGpFCECjfLWYe+brQs9SwRdnlEACvc3c8n4aSmm0hpx47/2exlJCL+im49t
         8pgkoFPD4TCfQmXoERIMeDPANyYbMH5hKBofwaryyeRiK9yDr6OT76aMggTSpqftRjtp
         Vc3w==
X-Gm-Message-State: AOAM533FdK46RBtJeWHYFk69phehTjxfkSHjCI6R6ooyMOT51FiCgLks
        PT6dLzByh1vAbVkD2tG7McWDIg==
X-Google-Smtp-Source: ABdhPJxfeJgxxm/Pl9KF+4WKK/a14yaoWV8BpRUQ0OOeSvzRhhmCHkwQ0Gf5OqqWchpG+vCqX5IoJQ==
X-Received: by 2002:a05:6638:34aa:: with SMTP id t42mr9263870jal.128.1628249987453;
        Fri, 06 Aug 2021 04:39:47 -0700 (PDT)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id a4sm5345165ioe.19.2021.08.06.04.39.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Aug 2021 04:39:47 -0700 (PDT)
Subject: Re: [PATCH net-next 1/6] net: ipa: don't suspend/resume modem if not
 up
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, elder@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210804153626.1549001-1-elder@linaro.org>
 <20210804153626.1549001-2-elder@linaro.org>
 <20210805182628.02ebf355@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Alex Elder <elder@linaro.org>
Message-ID: <9aedc291-c424-9a9b-eac2-052d404ba0ad@linaro.org>
Date:   Fri, 6 Aug 2021 06:39:46 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210805182628.02ebf355@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/5/21 8:26 PM, Jakub Kicinski wrote:
> On Wed,  4 Aug 2021 10:36:21 -0500 Alex Elder wrote:
>> The modem network device is set up by ipa_modem_start().  But its
>> TX queue is not actually started and endpoints enabled until it is
>> opened.
>>
>> So avoid stopping the modem network device TX queue and disabling
>> endpoints on suspend or stop unless the netdev is marked UP.  And
>> skip attempting to resume unless it is UP.
>>
>> Signed-off-by: Alex Elder <elder@linaro.org>
> 
> You said in the cover letter that in practice this fix doesn't matter.

I don't think we've seen this problem with system suspend, but
with runtime suspend we could get a forced suspend request at
any time (and frequently), so if there is a problem, it will be
much more likely to occur.

For suspend, I don't think it's actually a "problem".  Disabling
the TX queue if it wasn't open is harmless--it just sets the
DRV_XOFF bit in the TX queue state field.  And we have a
separate "enabled endpoints" mask that prevents stopping or
suspending the endpoint if it wasn't opened.

But for resume, waking the queue schedules it.  I'm not sure
what exactly ensues in that case, but it's not correct if the
network device hasn't been opened.  For endpoints, again, they
won't be resumed if they weren't enabled, so that part's OK.

> It seems trivial to test so perhaps it doesn't and we should leave the
> code be? Looking at dev->flags without holding rtnl_lock() seems
> suspicious, drivers commonly put the relevant portion of suspend/resume
> routines under rtnl_lock()/rtnl_unlock() (although to be completely

I don't use rtnl_lock()/rtnl_unlock() *anywhere* in the driver.
It has no netlink interface (yet), and therefore I didn't even
think about using rtnl_lock().  Do I need it?

> frank IDK if it's actually possible for concurrent suspend +
> open/close to happen).

I think it isn't possible, but I'm less than 100% sure.  I've
been thinking a lot about exactly this sort of question lately...

> Are there any callers of ipa_modem_stop() which don't hold rtnl_lock()?

None of them take that lock.  It is called in the driver ->remove
callback, and is called during cleanup if the modem crashes.

I think this fix is good, but as I said in the cover letter I'm
not aware of ever having hit it to date.

Thank you very much for your review and comments.

					-Alex

>> diff --git a/drivers/net/ipa/ipa_modem.c b/drivers/net/ipa/ipa_modem.c
>> index 4ea8287e9d237..663a610979e70 100644
>> --- a/drivers/net/ipa/ipa_modem.c
>> +++ b/drivers/net/ipa/ipa_modem.c
>> @@ -178,6 +178,9 @@ void ipa_modem_suspend(struct net_device *netdev)
>>   	struct ipa_priv *priv = netdev_priv(netdev);
>>   	struct ipa *ipa = priv->ipa;
>>   
>> +	if (!(netdev->flags & IFF_UP))
>> +		return;
>> +
>>   	netif_stop_queue(netdev);
>>   
>>   	ipa_endpoint_suspend_one(ipa->name_map[IPA_ENDPOINT_AP_MODEM_RX]);
>> @@ -194,6 +197,9 @@ void ipa_modem_resume(struct net_device *netdev)
>>   	struct ipa_priv *priv = netdev_priv(netdev);
>>   	struct ipa *ipa = priv->ipa;
>>   
>> +	if (!(netdev->flags & IFF_UP))
>> +		return;
>> +
>>   	ipa_endpoint_resume_one(ipa->name_map[IPA_ENDPOINT_AP_MODEM_TX]);
>>   	ipa_endpoint_resume_one(ipa->name_map[IPA_ENDPOINT_AP_MODEM_RX]);
>>   
>> @@ -265,9 +271,11 @@ int ipa_modem_stop(struct ipa *ipa)
>>   	/* Prevent the modem from triggering a call to ipa_setup() */
>>   	ipa_smp2p_disable(ipa);
>>   
>> -	/* Stop the queue and disable the endpoints if it's open */
>> +	/* Clean up the netdev and endpoints if it was started */
>>   	if (netdev) {
>> -		(void)ipa_stop(netdev);
>> +		/* If it was opened, stop it first */
>> +		if (netdev->flags & IFF_UP)
>> +			(void)ipa_stop(netdev);
>>   		ipa->name_map[IPA_ENDPOINT_AP_MODEM_RX]->netdev = NULL;
>>   		ipa->name_map[IPA_ENDPOINT_AP_MODEM_TX]->netdev = NULL;
>>   		ipa->modem_netdev = NULL;
> 

