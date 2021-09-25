Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2C09417F0D
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 03:35:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346306AbhIYBgn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 21:36:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232003AbhIYBgm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 21:36:42 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B59BCC061571;
        Fri, 24 Sep 2021 18:35:08 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id 24so17097722oix.0;
        Fri, 24 Sep 2021 18:35:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Cpa/Eb47JNf6PfSYR9n7chIq/QRBhzZP64CmCksOOpI=;
        b=iuwqA6XagR8MHbJ89FJZMHClU+dLE7ihVnJy7DyXFeeP6nEWcsIGThrz5GEhRqgpJ8
         8UUIXlU1w/TNr7arCG0N+qhW2fqd0Rq1bvwL4fwAwJjXxqOWrJAGmXyj4l8QJReHKfUc
         9hFQehZuNGQT1/pl3z16PJk6zZs1PedqqxfEtqOeKM7ZRrXQP4zxLEYtNQ32n1eLMsJF
         VWhSo7vXluT+RSaQ2UnQnuU9sgpchriwPjZaC8bSugH8kDcmCKfpYgUz4rI/qozuw3+e
         O2PMLQ03B76QxANqjVBeG63J+ZDmYfmjxe04c1pZ0NdjwFxb+XMbHPAfuvKYDZbnagr3
         2/sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Cpa/Eb47JNf6PfSYR9n7chIq/QRBhzZP64CmCksOOpI=;
        b=MaLoiBRZDmdIRVtN/gP0+uUBZqNNNZk7+lUZKHy+9KyV0KgyiXuR84auXQcGTMTg0R
         Y7rc3rflVrnUjKwRaV40aDxEGRBD+pIq9YF5y+r1Yeb4IavNdQxWMds+Dp6bOoCRfsCG
         /TCINMY0KpYG7NNgzr03+KyNjZWkkvWzkoq8sGOKeL2bVQBClWjAbKs2UKu83UJyXwxG
         n/8qXoy5GZe3PKxYnJ3q+GVmHrNhbM7GECMBbSPzV+2NP/yLY4hQ5NfybdZMwQvfFr/R
         nd+pBb9/ZsXxhxkSonWPGHBFB6kimCITP0WnFTOnFKhGKRKJ+U+R95n9rwoDOEyYu7iL
         JQow==
X-Gm-Message-State: AOAM533Apy8qQuE9aKidxoo5LwKzWGO8g0vr55Ts5Ct/VJP+PNsHWdvz
        +3ToQcjAf2QLEjOReA1N9saguoZwxsF90g==
X-Google-Smtp-Source: ABdhPJwto/am7Wj0+Bci031aCjr5vhhlEKD9KCTvSqWFXx3yQEnNNoLsNvfxEQ0hvZx/iDY8/OPphw==
X-Received: by 2002:aca:d686:: with SMTP id n128mr3837577oig.144.1632533707735;
        Fri, 24 Sep 2021 18:35:07 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.50])
        by smtp.googlemail.com with ESMTPSA id r20sm2592363oot.16.2021.09.24.18.35.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Sep 2021 18:35:06 -0700 (PDT)
Subject: Re: [PATCH 00/19] tcp: Initial support for RFC5925 auth option
To:     Leonard Crestez <cdleonard@gmail.com>,
        Francesco Ruggeri <fruggeri@arista.com>
Cc:     Dmitry Safonov <0x7f454c46@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>,
        Menglong Dong <dong.menglong@zte.com.cn>,
        netdev <netdev@vger.kernel.org>, linux-crypto@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
References: <cover.1632240523.git.cdleonard@gmail.com>
 <CA+HUmGjQWwDJSYRJPix3xBw8yMwqLcgYO7hBWxXT9eYmJttKgQ@mail.gmail.com>
 <6505b7d2-7792-429d-42a6-d41711de0dc1@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <e5b191ed-881e-542c-40e1-0cefdbfb2f10@gmail.com>
Date:   Fri, 24 Sep 2021 19:35:04 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <6505b7d2-7792-429d-42a6-d41711de0dc1@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/23/21 1:38 AM, Leonard Crestez wrote:
> On 9/22/21 11:23 PM, Francesco Ruggeri wrote:
>> On Tue, Sep 21, 2021 at 9:15 AM Leonard Crestez <cdleonard@gmail.com>
>> wrote:
>>> * Sequence Number Extension not implemented so connections will flap
>>> every ~4G of traffic.
>>
>> Could you expand on this?
>> What exactly do you mean by flap? Will the connection be terminated?
>> I assume that depending on the initial sequence numbers the first flaps
>> may occur well before 4G.
>> Do you use a SNE of 0 in the hash computation, or do you just not include
>> the SNE in it?
> 
> SNE is hardcoded to zero, with the logical consequence of incorrect
> signatures on sequence number wrapping. The SNE has to be included
> because otherwise all signatures would be invalid.
> 
> You are correct that this can break much sooner than 4G of traffic, but
> still in the GB range on average. I didn't test the exact behavior (not
> clear how) but if signatures don't validate the connection will likely
> timeout.
> 

This is for BGP and LDP connections. What's the expected frequency of
rollover for large FIBs? Seems like it could be fairly often.
