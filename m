Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B103417E04A
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 13:31:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbgCIMbV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 08:31:21 -0400
Received: from mail-lf1-f47.google.com ([209.85.167.47]:45689 "EHLO
        mail-lf1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726391AbgCIMbV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 08:31:21 -0400
Received: by mail-lf1-f47.google.com with SMTP id b13so7488865lfb.12
        for <netdev@vger.kernel.org>; Mon, 09 Mar 2020 05:31:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/lFYVJT4gqJ6u/i7/hdHKXlGHHkVBhkISacAITNGhhE=;
        b=uFkezAn7QPqgHPyTcfm5UfY44XnM70lOO+dmyWUTFui9Ylz+9N+/OHIh09h8SYmuws
         mnzvCwwgHI1vhCpjuAqB4YXV4MdJxM9alAyEDxAaHNXip+5nAYe+WYgKgNwF80BFfhoj
         Ze9Cwni65gOBJ7p8zOBYgHnXAABOkT0BpR+YMzNJIjbEKPaObnpoEdu3SacJ5wo22m+y
         ebVjn6qvUPxWJwKbbH9yDwwePRZ9gOuoQhxiDlzK8/FYfDyAu0oKoD7R7e3laMGsuXRF
         JEWbg3K0y3QRc1lkPyX3UCArWT4DCeErDQkXOf22cnBzkn4HkXps5klqdtfp9L/WKurD
         0W3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/lFYVJT4gqJ6u/i7/hdHKXlGHHkVBhkISacAITNGhhE=;
        b=GRRDDC1zvpCsz1RO0lDrdufw34fXurJP4Iijg1Id8bS4iBlQtHXbgW2Do2cC/86IFm
         QUe+x9Fz8Vw1RDGFhOrgpet626xPlu2VdjMnQsg1IbUB3I2YuKBVKkI8b2LlmFQG4Ae7
         +eFdDCxpKKa7GIZeRAyaUzDVb0Lr5wVgjB1mUSzVj9z0u2FbZjV8Y+aVzmaBOjdh2gpb
         T4wvYagSjBn80wiluvw4CNNSqOiT+9tGSW4stm3CPm/wYILHRhTCWDcqVz7FH021poSp
         95lGL8v2L1CLuMtG3AQqaDK216AtWLtUjakkm3n4TKsulFgu/hdUgI4xo7gQlkVKOBOH
         sVfA==
X-Gm-Message-State: ANhLgQ1qsjuPzewX9PKmmX8lXmFQunqBcZDgDGLXHmxmDyeJbP/Hq0pp
        ZBMpMAiBFq002xSwJ97BzCs=
X-Google-Smtp-Source: ADFU+vsP8LcV/DOH61gdbr537CboadgXX/XWK0l09vO5uNRtAERPL6C6xODxuLMva62WZrXaL2fYJw==
X-Received: by 2002:a05:6512:50f:: with SMTP id o15mr9348790lfb.216.1583757078448;
        Mon, 09 Mar 2020 05:31:18 -0700 (PDT)
Received: from elitebook.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.googlemail.com with ESMTPSA id f26sm21448687ljn.104.2020.03.09.05.31.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Mar 2020 05:31:17 -0700 (PDT)
Subject: Re: Regression: net/ipv6/mld running system out of memory (not a
 leak)
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Jo-Philipp Wich <jo@mein.io>
References: <CACna6rwD_tnYagOPs2i=1jOJhnzS5ueiQSpMf23TdTycFtwOYQ@mail.gmail.com>
 <b9d30209-7cc2-4515-f58a-f0dfe92fa0b6@gmail.com>
 <20200303090035.GV2159@dhcp-12-139.nay.redhat.com>
 <20200303091105.GW2159@dhcp-12-139.nay.redhat.com>
 <bed8542b-3dc0-50e0-4607-59bd2aed25dd@gmail.com>
 <20200304064504.GY2159@dhcp-12-139.nay.redhat.com>
 <d34a35e0-2dbe-fab8-5cf8-5c80cb5ec645@gmail.com>
 <20200304090710.GZ2159@dhcp-12-139.nay.redhat.com>
 <63892fca-4da6-0beb-73d3-b163977ed2fb@gmail.com>
 <20200309083341.GB2159@dhcp-12-139.nay.redhat.com>
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <37e56e0b-3bde-2667-2a9c-f2304d42d008@gmail.com>
Date:   Mon, 9 Mar 2020 13:31:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200309083341.GB2159@dhcp-12-139.nay.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09.03.2020 09:33, Hangbin Liu wrote:
> I'm very appreciate for your analyze. This makes me know why this issue
> happens and why I couldn't reproduce it.
> 
> Yes, with ARPHRD_IEEE80211_RADIOTAP, we called mld_add_delrec() every time
> when ipv6_mc_down(), but we never called mld_del_delrec() as ipv6_mc_up() was
> not called. This makes the idev->mc_tomb bigger and bigger.

Thanks, I'm happy to hear that was helpful.


>> *****************
>>   WITH YOUR PATCH
>> *****************
>>
>> Things work OK - with your changes all calls like:
>> ipv6_dev_mc_inc(ff01::1)
>> ipv6_dev_mc_inc(ff02::1)
>> ipv6_dev_mc_inc(ff02::2)
>> are now part of ipv6_mc_up() which gets never called for the
>> ARPHRD_IEEE80211_RADIOTAP.
>>
>> I got one more question though:
>>
>> Should we really call ipv6_mc_down() for ARPHRD_IEEE80211_RADIOTAP?
>>
>> We don't call ipv6_mc_up() so maybe ipv6_mc_down() should be avoided
>> too? It seems like asking for more problems in the future. Even now
> 
> 
> Yes, for me there are actually two questions.
> 
> 1. Should we avoid call ipv6_mc_down() as we don't call ipv6_mc_up() for
> non-Ethernen dev. I think the answer is yes, we could. But on the
> other hand, it seems IPv4 doesn't check the dev type and calls ip_mc_up()
> directly in inetdev_event() NETDEV_UP.
> 
> 2. Should we move ipv6_dev_mc_inc() from ipv6_add_dev() to ipv6_mc_up()?
> I don't know yet, this dependents on whether we could add multicast address
> on non-Ethernen dev.

I'm not the one to answer them surely with my limited net subsystem
understanding :( Any idea how to proceed with this? I assume your patch
is still the right step, do you think you can send it officially now?


>> we call ipv6_mc_leave_localaddr() without ipv6_mc_join_localaddr()
>> called first which seems unintuitive.
> 
> This doesn't matter much yet. As we will check if we have the address
> in __ipv6_dev_mc_dec(), if not, we just return. But yes, form logic, this
> looks asymmetric.

Right, just slightly unintuitive asymmetric code.
