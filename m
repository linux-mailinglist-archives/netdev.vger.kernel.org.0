Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 763F220C80
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 18:06:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728135AbfEPQFL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 12:05:11 -0400
Received: from mail-pg1-f176.google.com ([209.85.215.176]:42326 "EHLO
        mail-pg1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727770AbfEPQFJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 May 2019 12:05:09 -0400
Received: by mail-pg1-f176.google.com with SMTP id 145so1773903pgg.9
        for <netdev@vger.kernel.org>; Thu, 16 May 2019 09:05:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Zi5Hvf9OP1+J5OBt+WWHLcFNkcg5UaXEHv0wymBBeUY=;
        b=lbT/Q8jWuBwj16U1ms75giQkEhLSysFkPb58uAtJ7+MYfcnVFQ0DBtDkPZjuIAppV4
         dfMcurHtawGcGHzBHcHnGS2KkvOMiIZD5fvUco4DOmeA9oGDvUJPwT6BuQcIbm/4rWc2
         4A5nMKTkta/zKVptcHaBVSs3ezlheauik1MqEfNjqTzB82Lb1qHXVkFeDil49veNYZWU
         Ug/Rr9IdIuaQ5brr5DoxDlFMW7XyuU6mdVQVFUGdVQmrA2R0woMWNELY6pOrus+/IGKT
         TsMiIj7pqRABwEHv/4B5FmRmAQletmcfGyjHjXZYXEAhjZhd+23OjqIRyYQz1PiKUapk
         3kYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Zi5Hvf9OP1+J5OBt+WWHLcFNkcg5UaXEHv0wymBBeUY=;
        b=lmGTsimIOFFiF6HzCes72Vhk9fIyWrYvCZCj6+3eYged0WJikI0WGfYx5Ax1Lhtnbj
         hVtfqtfvOFdxzMXmjVDHPFPqXN00ubMmzthn0TDyQvoGMVdxqltJVcnPisazyT8W1/Mu
         B3Uk4P455o4AHFE6GtOlhv+rs3fxk4LVTVZfPLKOfIB19XXmscfoFW6drlHDZ5mMrA12
         u5DVo7LVkscKvcAkpSbBpYwpHUnX9w2ja/90SzxyOE9OE/ZucDWEA3gd5e5QpznvR5Rb
         gLQKhoIYM7N6uICqtli/2g+WOyqxGASBRxldJip2NKN1snKGOnsjdDRw/2Js8mtR4+Bw
         xDOw==
X-Gm-Message-State: APjAAAWEMxpDmlQYQHWCoCwSBIKeiZqpmOWa1/DXqPP3EAyml9VzUqL9
        iTT6F/lsKuXF4UFLcWVCp/Y6YnEl
X-Google-Smtp-Source: APXvYqwLOi9fJUyq96Gahy07fKaPQsBcQcYDUSbgDrhIOOZOjNNUhO1lrCSBvUr8BPvfC8Arl+ayvg==
X-Received: by 2002:a63:2b03:: with SMTP id r3mr49726453pgr.105.1558022708474;
        Thu, 16 May 2019 09:05:08 -0700 (PDT)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id s6sm7135055pfb.128.2019.05.16.09.05.06
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 May 2019 09:05:06 -0700 (PDT)
Subject: Re: Kernel UDP behavior with missing destinations
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Adam Urban <adam.urban@appleguru.org>
Cc:     Network Development <netdev@vger.kernel.org>
References: <CABUuw65R3or9HeHsMT_isVx1f-7B6eCPPdr+bNR6f6wbKPnHOQ@mail.gmail.com>
 <CAF=yD-Kdb4UrgzOJmeEhiqmeKndb9-X5WwttR-X4xd5m7DE5Dw@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <0d50023e-0a3b-b92b-59d6-39d0c02fa182@gmail.com>
Date:   Thu, 16 May 2019 09:05:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CAF=yD-Kdb4UrgzOJmeEhiqmeKndb9-X5WwttR-X4xd5m7DE5Dw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/16/19 7:47 AM, Willem de Bruijn wrote:
> On Wed, May 15, 2019 at 3:57 PM Adam Urban <adam.urban@appleguru.org> wrote:
>>
>> We have an application where we are use sendmsg() to send (lots of)
>> UDP packets to multiple destinations over a single socket, repeatedly,
>> and at a pretty constant rate using IPv4.
>>
>> In some cases, some of these destinations are no longer present on the
>> network, but we continue sending data to them anyways. The missing
>> devices are usually a temporary situation, but can last for
>> days/weeks/months.
>>
>> We are seeing an issue where packets sent even to destinations that
>> are present on the network are getting dropped while the kernel
>> performs arp updates.
>>
>> We see a -1 EAGAIN (Resource temporarily unavailable) return value
>> from the sendmsg() call when this is happening:
>>
>> sendmsg(72, {msg_name(16)={sa_family=AF_INET, sin_port=htons(1234),
>> sin_addr=inet_addr("10.1.2.3")}, msg_iov(1)=[{"\4\1"..., 96}],
>> msg_controllen=0, msg_flags=0}, MSG_NOSIGNAL) = -1 EAGAIN (Resource
>> temporarily unavailable)
>>
>> Looking at packet captures, during this time you see the kernel arping
>> for the devices that aren't on the network, timing out, arping again,
>> timing out, and then finally arping a 3rd time before setting the
>> INCOMPLETE state again (very briefly being in a FAILED state).
>>
>> "Good" packets don't start going out again until the 3rd timeout
>> happens, and then they go out for about 1s until the 3s delay from ARP
>> happens again.
>>
>> Interestingly, this isn't an all or nothing situation. With only a few
>> (2-3) devices missing, we don't run into this "blocking" situation and
>> data always goes out. But once 4 or more devices are missing, it
>> happens. Setting static ARP entries for the missing supplies, even if
>> they are bogus, resolves the issue, but of course results in packets
>> with a bogus destination going out on the wire instead of getting
>> dropped by the kernel.
>>
>> Can anyone explain why this is happening? I have tried tuning the
>> unres_qlen sysctl without effect and will next try to set the
>> MSG_DONTWAIT socket option to try and see if that helps. But I want to
>> make sure I understand what is going on.
>>
>> Are there any parameters we can tune so that UDP packets sent to
>> INCOMPLETE destinations are immediately dropped? What's the best way
>> to prevent a socket from being unavailable while arp operations are
>> happening (assuming arp is the cause)?
> 
> Sounds like hitting SO_SNDBUF limit due to datagrams being held on the
> neighbor queue. Especially since the issue occurs only as the number
> of unreachable destinations exceeds some threshold. Does
> /proc/net/stat/ndisc_cache show unresolved_discards? Increasing
> unres_qlen may make matters only worse if more datagrams can get
> queued. See also the branch on NUD_INCOMPLETE in __neigh_event_send.
> 

We probably should add a ttl on arp queues.

neigh_probe() could do that quite easily.

