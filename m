Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5469533C5EA
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 19:42:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231837AbhCOSl3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 14:41:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231789AbhCOSlJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 14:41:09 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D548CC06174A
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 11:41:08 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id m21-20020a9d7ad50000b02901b83efc84a0so5632165otn.10
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 11:41:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Ad9rcNyANrjvggbRbE9NiSsJQFN1GPJG7obt/UEjspU=;
        b=XYElCqWK85qJC30msB2xEGZwigWRa2Avl2Q/P1sp2E840lCUR1DUGm6g6s2ZFB2iKn
         rQxCaWlYiihbuso/okwE9LC8uPVODD6ssaxjPfPQgmJG1PwQT7f1WxaOeIg1/xsdTeoZ
         SCeluyyQBpEmrQMDnMkZJCf/5htXZxmO3CosKOkMFvaRTx3dTr4Ar4F98rJRi3kHs2bW
         BeI++U2qOmeRM5k/LuFcZJHhzd/IsxV2dNILM1f4A5GqUflLhcg+nay24Ldjjbms2OjA
         kBZZGZhJw+KzjeI3rkxBAowU26xN6gI8IvYH671pK1gwk891zA6zBLrSOjlUw7OQIugt
         FsLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ad9rcNyANrjvggbRbE9NiSsJQFN1GPJG7obt/UEjspU=;
        b=q8i3RrLSYvIgbrAfDnhNAsKxNfx2BWWeBzkokKQ7jV71oiRVZrO889aytpOqugOT2D
         QrNBBqFmq2wtwQAowyzqMraq1y+tGbxOcH3Lmdj3Wzc00rmFRfZZAWcrYGjHaXmdC33f
         3GcAS/xQccUbb8a16HnSnbcHzXDpLbDFCPZia2OdgO95oLHAvLdLBmWcQhbNTsSPy78B
         ynot2sRoIY9rOG3L/sVeLMAiJbjc9EGzg5eK1i7QTowWc/EvtxEJsybx9Q+q0V3nC0Lk
         2Zs0Fcm0JR5hO48UaI46t3Nt1LmIp5Uy5XOCAmcs1HRmuTVcyAhyejO7yQlTOqWSu1u+
         9dWg==
X-Gm-Message-State: AOAM531HyVSwhS5mCMJuLD61X6M9rquD06evJV4bG4JKbCguaJgocniJ
        h5N9GVeFAl3KRfFjZfRgFdG/WyBNYsk=
X-Google-Smtp-Source: ABdhPJxvKkKeYb/HFpChnFQajjZ2MrH0Ff2Z4jj4pi356ro8YGNcx+eIUCQ0RlrY938jgDMKcknXZA==
X-Received: by 2002:a9d:68ce:: with SMTP id i14mr368082oto.151.1615833667007;
        Mon, 15 Mar 2021 11:41:07 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.56])
        by smtp.googlemail.com with ESMTPSA id z8sm6674865oih.1.2021.03.15.11.41.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Mar 2021 11:41:06 -0700 (PDT)
Subject: Re: VRF leaking doesn't work
To:     Greesha Mikhalkin <grigoriymikhalkin@gmail.com>
Cc:     netdev@vger.kernel.org
References: <CADbyt64e2cmQzZTEg3VoY6py=1pAqkLDRw+mniRdr9Rua5XtgQ@mail.gmail.com>
 <5b2595ed-bf5b-2775-405c-bb5031fd2095@gmail.com>
 <CADbyt66Ujtn5D+asPndkgBEDBWJiMScqicGVoNBVpNyR3iQ6PQ@mail.gmail.com>
 <CADbyt64HpzGf6A_=wrouL+vT73DBndww34gMPSH9jDOiGEysvQ@mail.gmail.com>
 <5f673241-9cb1-eb36-be9a-a82b0174bd9c@gmail.com>
 <CADbyt6542624xAVzWXM6KEfk=zAOmB_SHbN=nzC_oib_+eXB1Q@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <642fb4d6-4188-968f-6d43-249ca8e38d7a@gmail.com>
Date:   Mon, 15 Mar 2021 12:41:05 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <CADbyt6542624xAVzWXM6KEfk=zAOmB_SHbN=nzC_oib_+eXB1Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/15/21 11:10 AM, Greesha Mikhalkin wrote:
>> That's the way the source address selection works -- it takes the fib
>> lookup result and finds the best source address match for it.
>>
>> Try adding 'src a.b.c.d' to the leaked route. e.g.,
>>     ip ro add 172.16.1.0/24 dev red vrf blue src 172.16.2.1
>>
>> where red and blue are VRFs, 172.16.2.1 is a valid source address in VRF
>> blue and VRF red has the reverse route installed.
> 
> Tried to do that. Added reverse route to vrf red like that:
>     ip ro add vrf red 172.16.2.1/32 dev blue
> 
> 172.16.2.1 is selected as source address when i ping. But now, when i
> look at `tcpdump icmp` i only see requests:
>     172.16.2.1 > 172.16.1.3: ICMP echo request, id 9, seq 10, length 64
> 
> And no replies and anything else. If i look into tcpdump on machine
> that's pinged -- it doesn't receive anything.
> 
> So it looks like it's not using nexthops from vrf red in that case.
> Maybe it has something to do with how address is setup. In routing
> table it looks like:
>     local 172.16.2.1 dev vlanblue proto kernel scope host src 172.16.2.1
> 

VRF is implemented via policy routing. did you re-order the FIB rules?


http://schd.ws/hosted_files/ossna2017/fe/vrf-tutorial-oss.pdf
