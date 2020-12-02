Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F2942CB213
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 02:08:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727868AbgLBBHn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 20:07:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726556AbgLBBHm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 20:07:42 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2571C0617A6
        for <netdev@vger.kernel.org>; Tue,  1 Dec 2020 17:06:56 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id r9so213440ioo.7
        for <netdev@vger.kernel.org>; Tue, 01 Dec 2020 17:06:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=P6V8jbbDNSQmYrf/qJazfTjML8JzYLoNl7h7cRqjJpE=;
        b=fd90HJxqLSH/WcoZcPaXybhHRO0A3NhLe+rfLIETS1zbtK8XgDSIjo291DCFwvmAI1
         pwTzRE7gJBbQoZu2EFWvXaYwX5DQi8zDnCMcPCRaMbvyuc+Qz8l1nVp+vt0vF/pem8Xf
         weh7w7q+Q6A6ec5KIt2+oThpmiLljy+3xta0ba/sibL6iqPXBiOVm0MD29auUM9yoOjM
         NHnAf1B89jRq8x1sDW+V2xU1zGg0ZWA7ev/8Sdt0uBoZrcLWoRHDE9dsH/3+HvUAf4lN
         rfPE3ZjpSbE+XhznXXHYnqlMmTs3sxkFYoy4BV9pgo1ypBGI/W1frASS9iNT8NObEa/O
         /KiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=P6V8jbbDNSQmYrf/qJazfTjML8JzYLoNl7h7cRqjJpE=;
        b=D+7RG5CLOZHVKgUHrpLyED4A0y5tYg8F5BHMH9mkcrKgXE0HapuoN17/T+wLdBIQPb
         eDXLObYtuulXJ80d+s2Aq2U/1ECnBVssaiGH2DwkX7cUBuz6w58q7u6WW/dEeGK1mEWC
         UFniHbZIFEZGPrSGOIY4ahwbV3PnmLkyLEhUUbpCM6wGGc6VKPmU4r0z+HtIJpJrrdUI
         F8HkDgWwA2TznBuA06UbLBsQUWCGdYkwFRkmh2nbBUmaPsejKOBxigtJI3cGnkgZwMx5
         WxQgv8BnKmgonYUtj6wds6RqVLEAu3Fii5SbjWvMScEDz9oR7CNJzVYOp2JRSLt9vGmO
         Ragw==
X-Gm-Message-State: AOAM533bxOqUBPHd6FN+csntLLF/1YDF5taoAawjDAOeirG5kg4h/T82
        /T3nxe7iAchVoRoFz5by2tywavHo24E=
X-Google-Smtp-Source: ABdhPJyHr0ESsVmKv4ToDlExs6/MQcGp+EhZZ51cWSRFsRsK2FdkBkIzy0ukym8ROdtZZKEGN9wF/A==
X-Received: by 2002:a6b:751a:: with SMTP id l26mr28470ioh.79.1606871215922;
        Tue, 01 Dec 2020 17:06:55 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:f4ef:fcd1:6421:a6de])
        by smtp.googlemail.com with ESMTPSA id m2sm50010ilj.24.2020.12.01.17.06.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Dec 2020 17:06:55 -0800 (PST)
Subject: Re: VRF NS for lladdr sent on the wrong interface
To:     Stephen Suryaputra <ssuryaextr@gmail.com>
Cc:     netdev@vger.kernel.org
References: <20201124002345.GA42222@ubuntu>
 <c04221cc-b407-4b30-4631-b405209853a3@gmail.com>
 <20201201190055.GA16436@ICIPI.localdomain>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <70557d4f-cf35-ddba-391c-c66aa8ca242a@gmail.com>
Date:   Tue, 1 Dec 2020 18:06:53 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201201190055.GA16436@ICIPI.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/1/20 12:00 PM, Stephen Suryaputra wrote:
> On Mon, Nov 30, 2020 at 06:15:06PM -0700, David Ahern wrote:
>> On 11/23/20 5:23 PM, Stephen Suryaputra wrote:
>>> Hi,
>>>
>>> I'm running into a problem with lladdr pinging all-host mcast all nodes
>>> addr. The ping intially works but after cycling the interface that
>>> receives the ping, the echo request packet causes a neigh solicitation
>>> being sent on a different interface.
>>>
>>> To repro, I included the attached namespace scripts. This is the
>>> topology and an output of my test.
>>>
>>> # +-------+     +----------+   +-------+
>>> # | h0    |     |    r0    |   |    h1 |
>>> # |    v00+-----+v00    v01+---+v10    |
>>> # |       |     |          |   |       |
>>> # +-------+     +----------+   +-------+
>>>
>>
>>
>>
>> after setup,
>>
>> ip netns exec h0 ping -c 1 ff02::1%h0_v00
>>
>> works, but
>>
>>  ip netns exec h1 ping -c 1 ff02::1%h1_v10
>>
>> does not. No surprise then that cycling v00 in r0 causes the reverse.
>> The problem is the route order changes:
>>
>> root@ubuntu-c-2-4gib-sfo3-01:~# diff -U3 /tmp/1 /tmp/2
>> --- /tmp/1	2020-12-01 01:07:39.795361392 +0000
>> +++ /tmp/2	2020-12-01 01:07:51.991808848 +0000
>> @@ -1,6 +1,6 @@
>>  local fe80::8466:b3ff:fecc:3a4f dev r0_v01 table 10 proto kernel metric
>> 0 pref medium
>>  local fe80::b4ec:a8ff:fec3:33d9 dev r0_v00 table 10 proto kernel metric
>> 0 pref medium
>> -fe80::/64 dev r0_v00 table 10 proto kernel metric 256 pref medium
>>  fe80::/64 dev r0_v01 table 10 proto kernel metric 256 pref medium
>> -ff00::/8 dev r0_v00 table 10 metric 256 pref medium
>> +fe80::/64 dev r0_v00 table 10 proto kernel metric 256 pref medium
>>  ff00::/8 dev r0_v01 table 10 metric 256 pref medium
>> +ff00::/8 dev r0_v00 table 10 metric 256 pref medium
>>
>> With your patch does ping from both hosts work?
> 
> Yes, it does.
> 
>> What about all of the tests in
>> tools/testing/selftests/net/fcnal-test.sh? specifically curious about
>> the 'LLA to GUA' tests (link local to global). Perhaps those tests need
>> a second interface (e.g., a dummy) that is brought up first to cause the
>> ordering to be different.
> 
> The script needs nettest to be in the path...
> 

nettest is in the same directory. Build it and then run the script -
with your patch applied. We need to see if it affects existing tests.
