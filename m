Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA5AD2D85BC
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 11:11:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406868AbgLLJyA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 04:54:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388959AbgLLJxQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Dec 2020 04:53:16 -0500
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92A94C0617A7
        for <netdev@vger.kernel.org>; Sat, 12 Dec 2020 01:00:26 -0800 (PST)
Received: by mail-ed1-x542.google.com with SMTP id c7so11911020edv.6
        for <netdev@vger.kernel.org>; Sat, 12 Dec 2020 01:00:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QSRI2dCufYoDv+I9jUiw7JSQWCFKwcIDuGQgXDasqNg=;
        b=i6HnRjwM1uQ5u5TbbT5zY3i2Ba6KSp9ObSIrv4tmU9qhIQ+p3tXKMCgK1KAJsFxIpx
         g5HP3pe18z4k2C2GgtAEbAz8hr4+uixN6r3ExgP7AEFWiZcry6MAE3JzkwUAXirc04yA
         0QZ7EAODI6DPsU2UEa6tPdHTWBYI8RqkjGTHdn+zuvpcZLCM3FiTLCHfttu1szp29+0x
         CfOOiEZPvoiN2KOKDUGFal4zugmBEUYT+0G5kZ7zASZ9T/KfESx8yB9IVoOqhnifht4X
         QIBE8+wOKUxi9Kd04B39xq7YHxne+COQ56Vw2m+WXNcxmWhlMV6fgR2cQoYucDiW4qeT
         YSpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QSRI2dCufYoDv+I9jUiw7JSQWCFKwcIDuGQgXDasqNg=;
        b=f2nI9SaHfD/qKf+/lwhiH/UZAFCv/2ai7n4z0cqwxBFh1z9Ii0GFB0WPGmJNr7MqRc
         gLX3l15mHmFGWaNb72dd/Lz9ZMw3eNqn0B9jR8HNliv6apYnT7bVGApnxN6bZRqG9pzn
         G2zJk4dxfUtKT3RCXbyD0sOGfb3cimIgnvQuISJCDuOMiLy+PqMawHBJpGhfKWfSXGec
         xsXVq0RS7o+tNL8IOzVJvGHQl7YOY5Y+p91v+m53enH22ksrakZ/0ObjVNt4/ncNb16t
         VkPwb5e8E0AdjE8mVu9L1zwczEutOPVIHImml/wBKjmIkcRq9z+mPzUcIvv37DJXeRD8
         PRKQ==
X-Gm-Message-State: AOAM533x3nRFhN+9Dtrmf+Cc7USnAB4Luv4nLap4hMZT5H9Ptot+LOuV
        vXIiqKMTTDtxqU5EQWf6DDz97gNjrMlO+A==
X-Google-Smtp-Source: ABdhPJxMvhY9HmQXTG1t9smetCQyEyX1ylj1An9D+16Ck+39cSAVkj5oKx7Kiy7S640ixxXOOAkUaA==
X-Received: by 2002:a05:6512:786:: with SMTP id x6mr5516405lfr.643.1607759447987;
        Fri, 11 Dec 2020 23:50:47 -0800 (PST)
Received: from [192.168.1.157] (h-137-65.A159.priv.bahnhof.se. [81.170.137.65])
        by smtp.gmail.com with ESMTPSA id j20sm1315512ljc.47.2020.12.11.23.50.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Dec 2020 23:50:47 -0800 (PST)
Subject: Re: [PATCH net-next v2 08/12] gtp: set dev features to enable GSO
To:     Pravin Shelar <pravin.ovn@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>, laforge@gnumonks.org
References: <20201211122612.869225-1-jonas@norrbonn.se>
 <20201211122612.869225-9-jonas@norrbonn.se>
 <CAOrHB_BC3847Oi--N84=tT5nrdpmL6a5Csvah19qJ0Czyng1JQ@mail.gmail.com>
From:   Jonas Bonn <jonas@norrbonn.se>
Message-ID: <a4fa00b1-5e9c-eaf2-2017-93416e7532f0@norrbonn.se>
Date:   Sat, 12 Dec 2020 08:50:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <CAOrHB_BC3847Oi--N84=tT5nrdpmL6a5Csvah19qJ0Czyng1JQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/12/2020 06:31, Pravin Shelar wrote:
> On Fri, Dec 11, 2020 at 4:28 AM Jonas Bonn <jonas@norrbonn.se> wrote:
>>
>> Signed-off-by: Jonas Bonn <jonas@norrbonn.se>
>> ---
>>   drivers/net/gtp.c | 8 +++++++-
>>   1 file changed, 7 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
>> index 236ebbcb37bf..7bbeec173113 100644
>> --- a/drivers/net/gtp.c
>> +++ b/drivers/net/gtp.c
>> @@ -536,7 +536,11 @@ static int gtp_xmit_ip4(struct sk_buff *skb, struct net_device *dev)
>>          if (unlikely(r))
>>                  goto err_rt;
>>
>> -       skb_reset_inner_headers(skb);
>> +       r = udp_tunnel_handle_offloads(skb, true);
>> +       if (unlikely(r))
>> +               goto err_rt;
>> +
>> +       skb_set_inner_protocol(skb, skb->protocol);
>>
> This should be skb_set_inner_ipproto(), since GTP is L3 protocol.

I think you're right, but I barely see the point of this.  It all ends 
up in the same place, as far as I can tell.  Is this supposed to be some 
sort of safeguard against trying to offload tunnels-in-tunnels?

/Jonas
