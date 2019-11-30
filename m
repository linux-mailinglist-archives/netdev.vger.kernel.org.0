Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90B5210DBFB
	for <lists+netdev@lfdr.de>; Sat, 30 Nov 2019 02:07:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727193AbfK3BHX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Nov 2019 20:07:23 -0500
Received: from mail-pg1-f170.google.com ([209.85.215.170]:44897 "EHLO
        mail-pg1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727130AbfK3BHX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Nov 2019 20:07:23 -0500
Received: by mail-pg1-f170.google.com with SMTP id e6so15245881pgi.11;
        Fri, 29 Nov 2019 17:07:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DqHe6XHoB6ntir8k9+BBIjfzbn1qklwyIMSziLPtcEo=;
        b=p98y+HOKewbDx98DIoaSAqPC//CS3PsGGRjU4XgtPhc4Ngk+kMkYeVpQfOLFXfrmF5
         hnjgwhhgLoVIf/16BKh0fTFWPDE3qpRsKxr2RYKDPt+HWRfIwn1SOa6oM0rbyPgQ6EYL
         WZesBGxya8dX4Ioxi5iFeNvjdI3NvJBmcb9T3pDoxwroDBtWZzbPUXOElEDrdm0c2Mo/
         953f1pfF7KLdZ6df3+XVC1kjWvMZs0TBmDDXRQ7PfQ/CT0YGC+hppE0nqfRvtPILZiKW
         7KEtUfRZQvQAgfxUQQUe5nuLrmoquSptsICh6Zj5PrvwweGstJuQ24k5S+65eyuR7jE2
         rudw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DqHe6XHoB6ntir8k9+BBIjfzbn1qklwyIMSziLPtcEo=;
        b=dbJ9q6nEcesFPGFKwJliPakNlQ0jTdkFrs6DxM3xeOpnejUQQqNc7qxsMkcCkx6hib
         tvN/Q6Nq2xZWU+7tqy7yjW4IYBunK9oHgKWte+ToXEjq+CejhFbMGFMI9BgN2fFK6H3u
         myP0/3fl0jUkP/o5FBSm+FWV/LmJZxzEk9zC06A0kZUkCFR1yyVjUAIZJ3k+RgPVfF6q
         P25sD2VbBc5C7h63okc7nEEAjimSRKIZHl2Njv19sQog5IwMvgXQG+Vh8SLVq3a7UdqF
         q3UbzOC4JaQAKo+Us9V8aDJdhxIBHzfPY7nIOWMQv9oFsP1uUfVHdcNc3M6+MlYew4EW
         v1Pw==
X-Gm-Message-State: APjAAAVFAug82DSB+b9Jp8gtcJ35gNEMC8v3DMKDxozXNfxEUH+9dU4b
        t2UiakB9tWDjCHSLX9uIEbI=
X-Google-Smtp-Source: APXvYqzdfBasFtusCfaSifX9tepAzZOa8hO2xdiRTr8OLxrd+UMN97U3givgzW0KxtgmChO3JEtZJQ==
X-Received: by 2002:a62:b40b:: with SMTP id h11mr58794576pfn.57.1575076042802;
        Fri, 29 Nov 2019 17:07:22 -0800 (PST)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id y26sm26454549pfo.76.2019.11.29.17.07.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Nov 2019 17:07:21 -0800 (PST)
Subject: Re: epoll_wait() performance
To:     David Laight <David.Laight@ACULAB.COM>,
        'Paolo Abeni' <pabeni@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     'Marek Majkowski' <marek@cloudflare.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        network dev <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>
References: <bc84e68c0980466096b0d2f6aec95747@AcuMS.aculab.com>
 <CAJPywTJYDxGQtDWLferh8ObjGp3JsvOn1om1dCiTOtY6S3qyVg@mail.gmail.com>
 <5f4028c48a1a4673bd3b38728e8ade07@AcuMS.aculab.com>
 <20191127164821.1c41deff@carbon>
 <0b8d7447e129539aec559fa797c07047f5a6a1b2.camel@redhat.com>
 <2f1635d9300a4bec8a0422e9e9518751@AcuMS.aculab.com>
 <313204cf-69fd-ec28-a22c-61526f1dea8b@gmail.com>
 <1265e30d04484d08b86ba2abef5f5822@AcuMS.aculab.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <c46e43d1-ba7d-39d9-688f-0141931df1b0@gmail.com>
Date:   Fri, 29 Nov 2019 17:07:20 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <1265e30d04484d08b86ba2abef5f5822@AcuMS.aculab.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/28/19 2:17 AM, David Laight wrote:
> From: Eric Dumazet
>> Sent: 27 November 2019 17:47
> ...
>> A QUIC server handles hundred of thousands of ' UDP flows' all using only one UDP socket
>> per cpu.
>>
>> This is really the only way to scale, and does not need kernel changes to efficiently
>> organize millions of UDP sockets (huge memory footprint even if we get right how
>> we manage them)
>>
>> Given that UDP has no state, there is really no point trying to have one UDP
>> socket per flow, and having to deal with epoll()/poll() overhead.
> 
> How can you do that when all the UDP flows have different destination port numbers?
> These are message flows not idempotent requests.
> I don't really want to collect the packets before they've been processed by IP.
> 
> I could write a driver that uses kernel udp sockets to generate a single message queue
> than can be efficiently processed from userspace - but it is a faff compiling it for
> the systems kernel version.

Well if destinations ports are not under your control,
you also could use AF_PACKET sockets, no need for 'UDP sockets' to receive UDP traffic,
especially it the rate is small.

