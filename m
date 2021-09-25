Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2281D4182A0
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 16:21:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343497AbhIYOWy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 10:22:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237777AbhIYOWx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Sep 2021 10:22:53 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69989C061570;
        Sat, 25 Sep 2021 07:21:18 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id bx4so48144082edb.4;
        Sat, 25 Sep 2021 07:21:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=z0mum1JZyG80yxFXdZBZQxtN2hhcJoR8p5bCBGs0LNc=;
        b=J/VIHUhu8QB8vjwZZ2LZnBneypDZ+f5pOAInrhdEtQAsnbeNbmnW1/PXMhvfT3Q02L
         qyrrtUVCjR0sJ4U1SbHePQ0BS55amfCoiolGhPSKv3m/R0WaGRx3uKyNRL2BWuDJkV5V
         K+Mu++9MGSVsU+KZmenOk6HP6IVYenTk2s+oHagCLw91chvyJWdZWDtZqAQX4tO1eG+Z
         ysXDyoSlZyk/HuG76iBf47fsj14pDqFoX7548LO1sYNnMlQm+MI1EDqpU56UP7NjiCu1
         OEZO5BVloBclX2kiddqTelMssOjj3q/xw91FXRs9vHMN3lXfKp21MEM4mnAm8HsnIF3D
         k2sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=z0mum1JZyG80yxFXdZBZQxtN2hhcJoR8p5bCBGs0LNc=;
        b=mmpzh15TJSAg3oIaHwKMY4HRtYhzR3xZEHWkmMcCHD6rLqHy1EA6xkzei+HkoYuVhm
         PUDHbYBOzOUcipPCLHzORyC/Z/AsKEM17DLX7582z9Yafb6EKs/aW+D8xykoOuZXQ/xN
         QlzVGwcYDXkddMbVXdOf/Q5swJbjFSrAY8g68ccEHiDoUP3uq/BUvzwAbea6cloX6f6C
         sR6SxPAdHIMB4c+EolC1O8GAIvwbxjoVR0IIEkeTVVhRg0ZsCDkVbwkk9rEXNfBObkxh
         zRsckse2Fx7Dtk0ZsjevDeAeYjBL59nw7O6aSAIdFJKVrAKz0UfjPS8ioyr21MZOMkoq
         jk4Q==
X-Gm-Message-State: AOAM533zAk2ufa1h3ezKMi82ODfSs0rmYgVOREaadEwgE/FdNaU7GCxQ
        9kVrE+ewbf6e2RFpAjWRyFe18jXqTRUGrwfznPk=
X-Google-Smtp-Source: ABdhPJxwvm2l72YQ6y2fIdhSBGLI68xUZRQKCsGTSb7+D3v6cK7SwP/Svpq6kExpGu/btbDu/z+zug==
X-Received: by 2002:a05:6402:1808:: with SMTP id g8mr11507501edy.188.1632579677067;
        Sat, 25 Sep 2021 07:21:17 -0700 (PDT)
Received: from ?IPv6:2a04:241e:501:3800:55c:dc9d:9cc1:2c16? ([2a04:241e:501:3800:55c:dc9d:9cc1:2c16])
        by smtp.gmail.com with ESMTPSA id p8sm6341704ejo.2.2021.09.25.07.21.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Sep 2021 07:21:16 -0700 (PDT)
Subject: Re: [PATCH 00/19] tcp: Initial support for RFC5925 auth option
To:     David Ahern <dsahern@gmail.com>,
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
        netdev <netdev@vger.kernel.org>, linux-crypto@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
References: <cover.1632240523.git.cdleonard@gmail.com>
 <CA+HUmGjQWwDJSYRJPix3xBw8yMwqLcgYO7hBWxXT9eYmJttKgQ@mail.gmail.com>
 <6505b7d2-7792-429d-42a6-d41711de0dc1@gmail.com>
 <e5b191ed-881e-542c-40e1-0cefdbfb2f10@gmail.com>
From:   Leonard Crestez <cdleonard@gmail.com>
Message-ID: <b6c15f48-b6d1-e656-c796-9e7e63e646b3@gmail.com>
Date:   Sat, 25 Sep 2021 17:21:14 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <e5b191ed-881e-542c-40e1-0cefdbfb2f10@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/25/21 4:35 AM, David Ahern wrote:
> On 9/23/21 1:38 AM, Leonard Crestez wrote:
>> On 9/22/21 11:23 PM, Francesco Ruggeri wrote:
>>> On Tue, Sep 21, 2021 at 9:15 AM Leonard Crestez <cdleonard@gmail.com>
>>> wrote:
>>>> * Sequence Number Extension not implemented so connections will flap
>>>> every ~4G of traffic.
>>>
>>> Could you expand on this?
>>> What exactly do you mean by flap? Will the connection be terminated?
>>> I assume that depending on the initial sequence numbers the first flaps
>>> may occur well before 4G.
>>> Do you use a SNE of 0 in the hash computation, or do you just not include
>>> the SNE in it?
>>
>> SNE is hardcoded to zero, with the logical consequence of incorrect
>> signatures on sequence number wrapping. The SNE has to be included
>> because otherwise all signatures would be invalid.
>>
>> You are correct that this can break much sooner than 4G of traffic, but
>> still in the GB range on average. I didn't test the exact behavior (not
>> clear how) but if signatures don't validate the connection will likely
>> timeout.
>>
> 
> This is for BGP and LDP connections. What's the expected frequency of
> rollover for large FIBs? Seems like it could be fairly often.

Implementing SNE is obviously required for standard conformance, I'm not 
claiming it is not needed. I will include this in a future version.

I skipped it because it has very few interactions with the rest of the 
code so it can be implemented separately. Many tests can pass just fine 
ignoring SNE.

--
Regards,
Leonard
