Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF79910123F
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 04:48:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727385AbfKSDsg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 22:48:36 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:40264 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727112AbfKSDsf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 22:48:35 -0500
Received: by mail-pf1-f195.google.com with SMTP id r4so11435978pfl.7
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 19:48:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+nOBzxyong7CWoQotkLy/S5iy6ghyHwY9zo9seqi8rc=;
        b=MUB53AdXiWqUlP3zb6te2cG+Ti/MJeenfXv99X5ZitqBOmOIWhRTx5yWeZwSHXFbmn
         NQyvE5yjmZpHGh8TXpeWdHOT7g3GmQ2AEN0RHWJTUkclc01PiF/Y7ZT3a0q9Sdkk1536
         1YRM3OfceZf3YeXvxg8+CxnxUQSYCFxDgCasEWSdTgYLvBgsGGjWhsX6iu+/wrq/kKSZ
         0Q5L0LFmvogr4z2FHsCRZthrryD0xXFA8Ft3N82cECg/7uTCgd/Vrs9QVu2hZLRxvShU
         OCHQ8Z+EE9eAQKHgWGp/E1TWw4Pgexh8Dzczqv6uBFdzwFB97na1dKshhR0mV42GABjI
         K4rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+nOBzxyong7CWoQotkLy/S5iy6ghyHwY9zo9seqi8rc=;
        b=Eot9JtlWIZQsWwSO95yAfo7Nh+Puo7v1SFCG/fgKyCpoi+hFKObtNR1YtH4kDhLM00
         72X3r0uNAzYXeStfpE18LcRuHTQ+JxWSnaG0gcsWvRFWrHMAEIZ/RK0NXfhR9LA2I9NG
         QSE6bqcqVqqhFc12HAfkcIgutY7T6lvvv1yKiG228Qhl7wFHlTZq7lTxkzC6J/zLaEWx
         1QZ8QSGhd8BhSvoUH5RfRwljo82mNOPA4BqnlKGyMs9+/PziXjqnq0QtF2pHnx54WayD
         C8j8k1VeDB1zEiUId6AJFXHFgT3k9GevuZ2Jp7HjeNolRPkm+652KRGUtjwlZEUkjmFL
         9tWw==
X-Gm-Message-State: APjAAAWGfAvDPfrNlJR7+QLH5ZvtyMCvey6/BLzX825bmJkMdY39lmSS
        b5gpKVNFnIvkCGJMBRL5QZY=
X-Google-Smtp-Source: APXvYqx1+bSlBPHdy30hh3XN18X2rgCovyBzLYPDhJLp4HcNJnI0mM5T6agf+jVZBAuGoAyP78DeXQ==
X-Received: by 2002:a65:44ca:: with SMTP id g10mr3134133pgs.104.1574135315052;
        Mon, 18 Nov 2019 19:48:35 -0800 (PST)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id w4sm1037768pjt.21.2019.11.18.19.48.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Nov 2019 19:48:34 -0800 (PST)
Subject: Re: [PATCH net] tcp: switch snprintf to scnprintf
To:     Hangbin Liu <liuhangbin@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Jiri Benc <jbenc@redhat.com>, netdev@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>
References: <20191114102831.23753-1-liuhangbin@gmail.com>
 <557b2545-3b3c-63a9-580c-270a0a103b2e@gmail.com>
 <20191115024106.GB18865@dhcp-12-139.nay.redhat.com>
 <20191115105455.24a4dd48@redhat.com>
 <20191119015338.GD18865@dhcp-12-139.nay.redhat.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <22361732-351e-4768-0974-bd4050eb9f2e@gmail.com>
Date:   Mon, 18 Nov 2019 19:48:32 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191119015338.GD18865@dhcp-12-139.nay.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/18/19 5:53 PM, Hangbin Liu wrote:
> On Fri, Nov 15, 2019 at 10:54:55AM +0100, Jiri Benc wrote:
>> On Fri, 15 Nov 2019 10:41:06 +0800, Hangbin Liu wrote:
>>>> We need to properly size the output buffers before using them,
>>>> we can not afford truncating silently the output.
>>>
>>> Yes, I agree. Just as I said, the buffer is still enough, while scnprintf
>>> is just a safer usage compired with snprintf.
>>
>> So maybe keep snprintf but add WARN_ON and bail out of the loop if the
>> buffer size was reached?
>>
>> 	if (WARN_ON(offs >= maxlen))
>> 		break;
>>
> 
> Hi Eric,
> 
> What do you think?
> 

WARN_ON_ONCE() please...

