Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D77359550
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 09:46:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbfF1Hqt convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 28 Jun 2019 03:46:49 -0400
Received: from mail-ed1-f41.google.com ([209.85.208.41]:44621 "EHLO
        mail-ed1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726385AbfF1Hqt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 03:46:49 -0400
Received: by mail-ed1-f41.google.com with SMTP id k8so9718061edr.11
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 00:46:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=Fx0aoekomLPfXwegGKbKYCfNB6aJDuEsFzjF+8UIrDc=;
        b=HwpOBCLw1poMe/u8dKXPv1kMzSqlth69EoCHIjXR9L6IndojF6pyBIS/U7Mvr57aGO
         6/wT+bH5ge7LtYoAgyKixkniN65ZZOrhVhqa0k8GKbrtaR6xsHhpIMKWqp0DpACtHonF
         M9rM7gXzNM2vBNKROKxsoMlfWzGXqKN5uj0NJDUdfyyfzjnQ8TWbxyIGEjLbpZvm61yC
         3QiVvfOfbJOUBUbwy9fPc7a7dTrMJJXz7e2xxmZNn5I9grtvVr1uri7NtuQvINd/WoOS
         CkEds6LWoonzwmgMKBluzVF5vpE40S8PV8j8ZbmBStsqKIekEakHMN+9DNCdRR3K4+ni
         sWWQ==
X-Gm-Message-State: APjAAAX47F5dh6wMtJ8dcwVqihSmIMv5HEzQxYLwrtWvEHgAVKFu+3so
        nTU9OqJfJ4tkP9bVMEFm+SAeWw==
X-Google-Smtp-Source: APXvYqzEvwfiRAjd35BPUS+G7uY3YeoE80PFW58ZLt8W09hiUPONkcmPASbwFdHICbA7t52eI5aydA==
X-Received: by 2002:a05:6402:652:: with SMTP id u18mr9526515edx.85.1561708006836;
        Fri, 28 Jun 2019 00:46:46 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id h10sm442316ede.93.2019.06.28.00.46.45
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 00:46:45 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 48E22181CA7; Fri, 28 Jun 2019 09:46:45 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Eelco Chaudron <echaudro@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     "Machulsky\, Zorik" <zorik@amazon.com>,
        "Jubran\, Samih" <sameehj@amazon.com>, davem@davemloft.net,
        netdev@vger.kernel.org, "Woodhouse\, David" <dwmw@amazon.co.uk>,
        "Matushevsky\, Alexander" <matua@amazon.com>,
        "Bshara\, Saeed" <saeedb@amazon.com>,
        "Wilson\, Matt" <msw@amazon.com>,
        "Liguori\, Anthony" <aliguori@amazon.com>,
        "Bshara\, Nafea" <nafea@amazon.com>,
        "Tzalik\, Guy" <gtzalik@amazon.com>,
        "Belgazal\, Netanel" <netanel@amazon.com>,
        "Saidi\, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt\, Benjamin" <benh@amazon.com>,
        "Kiyanovski\, Arthur" <akiyano@amazon.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        xdp-newbies@vger.kernel.org
Subject: Re: XDP multi-buffer incl. jumbo-frames (Was: [RFC V1 net-next 1/1] net: ena: implement XDP drop support)
In-Reply-To: <CC99D6DE-5B6B-42F3-8D68-7F9AFF1712FF@redhat.com>
References: <20190623070649.18447-1-sameehj@amazon.com> <20190623070649.18447-2-sameehj@amazon.com> <20190623162133.6b7f24e1@carbon> <A658E65E-93D2-4F10-823D-CC25B081C1B7@amazon.com> <20190626103829.5360ef2d@carbon> <CC99D6DE-5B6B-42F3-8D68-7F9AFF1712FF@redhat.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 28 Jun 2019 09:46:45 +0200
Message-ID: <87y31m884a.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Eelco Chaudron" <echaudro@redhat.com> writes:

> On 26 Jun 2019, at 10:38, Jesper Dangaard Brouer wrote:
>
>> On Tue, 25 Jun 2019 03:19:22 +0000
>> "Machulsky, Zorik" <zorik@amazon.com> wrote:
>>
>>> ﻿On 6/23/19, 7:21 AM, "Jesper Dangaard Brouer" <brouer@redhat.com> 
>>> wrote:
>>>
>>>     On Sun, 23 Jun 2019 10:06:49 +0300 <sameehj@amazon.com> wrote:
>>>
>>>     > This commit implements the basic functionality of drop/pass 
>>> logic in the
>>>     > ena driver.
>>>
>>>     Usually we require a driver to implement all the XDP return 
>>> codes,
>>>     before we accept it.  But as Daniel and I discussed with Zorik 
>>> during
>>>     NetConf[1], we are going to make an exception and accept the 
>>> driver
>>>     if you also implement XDP_TX.
>>>
>>>     As we trust that Zorik/Amazon will follow and implement 
>>> XDP_REDIRECT
>>>     later, given he/you wants AF_XDP support which requires 
>>> XDP_REDIRECT.
>>>
>>> Jesper, thanks for your comments and very helpful discussion during
>>> NetConf! That's the plan, as we agreed. From our side I would like to
>>> reiterate again the importance of multi-buffer support by xdp frame.
>>> We would really prefer not to see our MTU shrinking because of xdp
>>> support.
>>
>> Okay we really need to make a serious attempt to find a way to support
>> multi-buffer packets with XDP. With the important criteria of not
>> hurting performance of the single-buffer per packet design.
>>
>> I've created a design document[2], that I will update based on our
>> discussions: [2] 
>> https://github.com/xdp-project/xdp-project/blob/master/areas/core/xdp-multi-buffer01-design.org
>>
>> The use-case that really convinced me was Eric's packet header-split.
>>
>>
>> Lets refresh: Why XDP don't have multi-buffer support:
>>
>> XDP is designed for maximum performance, which is why certain 
>> driver-level
>> use-cases were not supported, like multi-buffer packets (like 
>> jumbo-frames).
>> As it e.g. complicated the driver RX-loop and memory model handling.
>>
>> The single buffer per packet design, is also tied into eBPF 
>> Direct-Access
>> (DA) to packet data, which can only be allowed if the packet memory is 
>> in
>> contiguous memory.  This DA feature is essential for XDP performance.
>>
>>
>> One way forward is to define that XDP only get access to the first
>> packet buffer, and it cannot see subsequent buffers.  For XDP_TX and
>> XDP_REDIRECT to work then XDP still need to carry pointers (plus
>> len+offset) to the other buffers, which is 16 bytes per extra buffer.
>
>
> I’ve seen various network processor HW designs, and they normally get 
> the first x bytes (128 - 512) which they can manipulate 
> (append/prepend/insert/modify/delete).
>
> There are designs where they can “page in” the additional fragments 
> but it’s expensive as it requires additional memory transfers. But the 
> majority do not care (cannot change) the remaining fragments. Can also 
> not think of a reason why you might want to remove something at the end 
> of the frame (thinking about routing/forwarding needs here).
>
> If we do want XDP to access other fragments we could do this through a 
> helper which swaps the packet context?

Yeah, I was also going to suggest a helper for that. It doesn't
necessarily need to swap the packet context, it could just return a new
pointer?

-Toke
