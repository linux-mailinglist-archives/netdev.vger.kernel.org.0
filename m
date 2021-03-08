Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5268E330D37
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 13:19:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbhCHMSl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 07:18:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229899AbhCHMSk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 07:18:40 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14DE4C06174A;
        Mon,  8 Mar 2021 04:18:40 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id a22-20020a17090aa516b02900c1215e9b33so2872044pjq.5;
        Mon, 08 Mar 2021 04:18:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=YAXKN+M7RiXauqKPlpwwPF5/+9T43D/VSBuQ/SxYg+Q=;
        b=OlZYRvLGgiZ9wASSofTwGg1/h0GFMAJGkqxbUk8fiy20a87MzdKZO0jgIQfYqjkEdg
         6DPrxap3vbe+Ez8+WttOG85amANhYao39tRdQNlHi9errZ8PBYNV06l/MCWC+XWO5DMD
         TWcqS0ATPMZEuAG1TNU0UssUj+ROwXlp3qkzfaq4Ye5wdoSGEh0KDV0ux/CTKY046msN
         JcEUlChmpRJ62PQ3URoiLs42shsUwhBNmKz4gGZw+GaoPaZnOKq7umUvm1M+dHhelT0C
         u/G2hjtxTOsQ00sLKi1eRIU/WKgshFUTdXgiYWRSZYGbBIT4+VNYHUWiUfUsesdQ7HCV
         A5WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=YAXKN+M7RiXauqKPlpwwPF5/+9T43D/VSBuQ/SxYg+Q=;
        b=KKx1+rijKk+LNbzmLXErZoV5qBHoKvpKMv87NWFHfF+ZOEKw4y+0QZKfG7pf4ImPYJ
         yBQyygzPNBJkoE/xeq1Y+M1Y57gPvNRj9b7bj2rAkyaSn7tY4awQgoCSl1+uexZQeq1l
         TWXwMHi8fr02r60semnobi8wJRRqD/kh4P+XcQKwf290BorfgCwlmeBsn2oANdg2Vuzu
         FHb2Va+p6bX5SR2t7jy/n2KIAqPc64Bgr9oyD6MeKWU+q8Zs4mTRWMbiZnXu5j8nkBsh
         sZr1p+6i3lbbovZpgNhlzcvqSsr9fJ9cfvOU3zrp5ODu3a5ay92I5A7bRAKo6PA/9S9A
         s0eg==
X-Gm-Message-State: AOAM531TWQqbfuJTlflD0My5Wd94fGAs3nn6usbqHEONAm4M5ft1dwn4
        6RLzjhcMBa2vRbCKbAepr/c=
X-Google-Smtp-Source: ABdhPJwIIi0atO+VXpmRTnuF/TsVxDXBuqZligjIdqjh8wcUTNz9rNO1cmJOV54B3x9M1ZwSrYd22Q==
X-Received: by 2002:a17:902:14e:b029:e4:9648:83e6 with SMTP id 72-20020a170902014eb02900e4964883e6mr20254700plb.68.1615205919667;
        Mon, 08 Mar 2021 04:18:39 -0800 (PST)
Received: from [10.74.0.134] ([45.135.186.99])
        by smtp.gmail.com with ESMTPSA id il6sm10398952pjb.56.2021.03.08.04.18.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Mar 2021 04:18:39 -0800 (PST)
Subject: Re: [PATCH] net: ieee802154: fix error return code of dgram_sendmsg()
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, alex.aring@gmail.com,
        davem@davemloft.net, kuba@kernel.org, stefan@datenfreihafen.org
References: <20210308093106.9748-1-baijiaju1990@gmail.com>
 <d373b42c-0057-48b3-4667-bfa53a99f040@gmail.com>
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
Message-ID: <3634b7c6-340b-3d6d-ccce-c2a95319ca9e@gmail.com>
Date:   Mon, 8 Mar 2021 20:18:35 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <d373b42c-0057-48b3-4667-bfa53a99f040@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/3/8 18:19, Heiner Kallweit wrote:
> On 08.03.2021 10:31, Jia-Ju Bai wrote:
>> When sock_alloc_send_skb() returns NULL to skb, no error return code of
>> dgram_sendmsg() is assigned.
>> To fix this bug, err is assigned with -ENOMEM in this case.
>>
> Please stop sending such nonsense. Basically all such patches you
> sent so far are false positives. You have to start thinking,
> don't blindly trust your robot.
> In the case here the err variable is populated by sock_alloc_send_skb().

Ah, sorry, it is my fault :(
I did not notice that the err variable is populated by 
sock_alloc_send_skb().
I will think more carefully before sending patches.

By the way, I wonder how to report and discuss possible bugs that I am 
not quite sure of?
Some people told me that sending patches is better than reporting bugs 
via Bugzilla, so I write the patches of these possible bugs...
Do you have any advice?

Thanks a lot!


Best wishes,
Jia-Ju Bai
>
>> Fixes: 78f821b64826 ("ieee802154: socket: put handling into one file")
>> Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
>> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
>> ---
>>   net/ieee802154/socket.c | 4 +++-
>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/net/ieee802154/socket.c b/net/ieee802154/socket.c
>> index a45a0401adc5..a750b37c7e73 100644
>> --- a/net/ieee802154/socket.c
>> +++ b/net/ieee802154/socket.c
>> @@ -642,8 +642,10 @@ static int dgram_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
>>   	skb = sock_alloc_send_skb(sk, hlen + tlen + size,
>>   				  msg->msg_flags & MSG_DONTWAIT,
>>   				  &err);
>> -	if (!skb)
>> +	if (!skb) {
>> +		err = -ENOMEM;
>>   		goto out_dev;
>> +	}
>>   
>>   	skb_reserve(skb, hlen);
>>   
>>

