Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBFA820797F
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 18:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404973AbgFXQtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 12:49:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404769AbgFXQtT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 12:49:19 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0823C061573;
        Wed, 24 Jun 2020 09:49:19 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id e9so1674260pgo.9;
        Wed, 24 Jun 2020 09:49:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=gHRU/IrrHY0pBXio7TxFoCNp0H7VG1Kl3CaRgA0TrYo=;
        b=dhJAQd7WFOLBTSj9wvXYa7qMk4O42nna4v+lzqRdheF+gw8QTlPNZL/W13ALRXi40k
         K8bj1wXi2boUKsTHKnPdEOVi7mI4MyHRt7UrPFggQA/lySzrsC8hPcBRqI6uzxMEuthJ
         i8L8N0n9k9vpTECiPgZchpfEutLppprroXLou6EGveYVnbsNo3nFaNQZA2KvvlW20V+n
         S5nsKVQY9wx50u3xuAKxJI+Ot9eBJ7g8G/XTmTHlpRrJe4Z09i3w1s6UqmAMDV25DM8j
         2iVd6PbhQeAPwqpbQp6zreWRRs9wXvxbNKktJ3Cyqf70+cf/brSHhSfkScA1iccqVR0B
         KB3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gHRU/IrrHY0pBXio7TxFoCNp0H7VG1Kl3CaRgA0TrYo=;
        b=gwiEtHxCqD0MbBPDIthfYN4PDlXggAPLe729ZerrrXvQ4y6khT7PUX8RxgGbEHbOCL
         s55wZT37edleDxpUy9Q4h+1/yDVXFcLc5dZqmKacGY6M88tq9uMuiXa8JNTDmzUEwzHv
         73aS2QNpEwGGFsEP918ahTg6RgUls/oc+AzkiAkB956ufis0xiqJwvaM4CEl+Gh6wyUy
         JY5tl0ELnusWsnoDDwRd7iFdaDxR0qOyUMExQzGZf6X0/1U9gxTJfQ6yoIj2OROMzoJ3
         1YelQO5Wfb1tPqcvkM5IXCnnJ5Q440BxvW1y3JVMbVVU/qzH8xTMeqtlgLFQmb+inNLq
         /qsg==
X-Gm-Message-State: AOAM533me2MBDAr86NwYlapaenXKzDVkSjzNXx2KupgBXpEEui6/3EuT
        RDz0HD+EO1GwyXRDKxzXec0=
X-Google-Smtp-Source: ABdhPJwgol1TteKFO9cz7C4Kl/Qs494BlgdsAFeVFVk4WKeiVJvHL0iU7ADzz8fdHrc/Yp4TdNaz5A==
X-Received: by 2002:aa7:9504:: with SMTP id b4mr7863677pfp.109.1593017359200;
        Wed, 24 Jun 2020 09:49:19 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id c139sm2096799pfb.189.2020.06.24.09.49.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Jun 2020 09:49:18 -0700 (PDT)
Subject: Re: [PATCH] fs/epoll: Enable non-blocking busypoll with epoll timeout
 of 0
To:     "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        netdev@vger.kernel.org,
        "davem@davemloft.net" <davem@davemloft.net>, eric.dumazet@gmail.com
References: <1592590409-35439-1-git-send-email-sridhar.samudrala@intel.com>
 <de6bf72d-d4fd-9a62-c082-c82179d1f4fe@intel.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <28225710-0e85-f937-396d-24ce839efe09@gmail.com>
Date:   Wed, 24 Jun 2020 09:49:17 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <de6bf72d-d4fd-9a62-c082-c82179d1f4fe@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/24/20 9:32 AM, Samudrala, Sridhar wrote:
> Adding Dave, Eric for review and see if we can get this in via net-next
> as this is mainly useful for networking workloads doing busypoll.
> 
> Thanks
> Sridhar
> 
> On 6/19/2020 11:13 AM, Sridhar Samudrala wrote:
>> This patch triggers non-blocking busy poll when busy_poll is enabled and
>> epoll is called with a timeout of 0 and is associated with a napi_id.
>> This enables an app thread to go through napi poll routine once by calling
>> epoll with a 0 timeout.
>>
>> poll/select with a 0 timeout behave in a similar manner.
>>
>> Signed-off-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
>> ---
>>   fs/eventpoll.c | 13 +++++++++++++
>>   1 file changed, 13 insertions(+)
>>
>> diff --git a/fs/eventpoll.c b/fs/eventpoll.c
>> index 12eebcdea9c8..5f55078d6381 100644
>> --- a/fs/eventpoll.c
>> +++ b/fs/eventpoll.c
>> @@ -1847,6 +1847,19 @@ static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
>>           eavail = ep_events_available(ep);
>>           write_unlock_irq(&ep->lock);
>>   +        /*
>> +         * Trigger non-blocking busy poll if timeout is 0 and there are
>> +         * no events available. Passing timed_out(1) to ep_busy_loop
>> +         * will make sure that busy polling is triggered only once and
>> +         * only if sysctl.net.core.busy_poll is set to non-zero value.
>> +         */
>> +        if (!eavail) {

Maybe avoid all this stuff for the typical case of busy poll being not used ?

            if (!evail && net_busy_loop_on)) {

>> +            ep_busy_loop(ep, timed_out);


>> +            write_lock_irq(&ep->lock);
>> +            eavail = ep_events_available(ep);
>> +            write_unlock_irq(&ep->lock);
>> +        }
>> +
>>           goto send_events;
>>       }
>>  
