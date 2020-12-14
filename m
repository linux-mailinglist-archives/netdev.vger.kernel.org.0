Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3F622D942E
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 09:31:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439199AbgLNIaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 03:30:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726652AbgLNIaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 03:30:17 -0500
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2C22C0613CF
        for <netdev@vger.kernel.org>; Mon, 14 Dec 2020 00:29:36 -0800 (PST)
Received: by mail-lf1-x141.google.com with SMTP id o19so2364791lfo.1
        for <netdev@vger.kernel.org>; Mon, 14 Dec 2020 00:29:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rkVru4slCm22qmeWR/P51aOIqc9lkXmVomunihX92pw=;
        b=ra3oo0JYs3l6j+wYl6Bx4+w/WB0rTkR5v5T3G+7dmZRvqISbERxAk7UewH6zvdRUDU
         PFiF3lL+FQ53qaQeEIPTesuNHjNyR/Art9brTiiWYnXJqXXImrYZiUfUNaNB9SyH/doS
         nLpiY9QkFsdq0KMcwIHWuLOsGH83XZfE+4L5ibrxCydnIf6W7k4FpqcW+mMiQ3L+ZrnE
         wpiX/E6EajCAkT2MDU0nlkuknalapX4c6BWM6SSgEqniSyEEhg6glTp4qg9us421T5Af
         AxjfTYqRh5eIgVsR/OEXhiB2nJh/pjjd1lpe048JpQLhn3eR5nh6Wb9+m+oycyGG8/qM
         Uoyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rkVru4slCm22qmeWR/P51aOIqc9lkXmVomunihX92pw=;
        b=Y2vN/ZqhQgkdcz3sRKEi0pyCY8klpLbliHv6InXAFaLJej9tXRaNsiUoG6qFdN0LEJ
         1jTnQT2LAEdWcOYMcvwhwC++vBWJlgj2qF3pQqYyH2gp8Tt5eptRGpCVtZxBNz/53VlR
         yrrjrTjtZoU+ohnw/AGnyZGswj2f9u1C+CmkW6f7ZFCqBT2t0GJGt0O3yY58XtNqoC0W
         zbmyH65kD0pzlDN+t77y5qrb22/NXkr15wH3GF3BASOeRu4/lG3zhhJLZKTLzzjj8u6Y
         bY2+MIkgbQLWe9OUz5o4ki+iRPXi2/9JVlRCTzCw5rlRucocKpfHK98st/QfEHXm2b5Y
         i02Q==
X-Gm-Message-State: AOAM530lWVf4rZxqc/6lfUkF3o+LIfhQg6gp3zZXwJDyRcqGxDK4NOW7
        lThga/ydf4riu4sJhTbgEIT0PA==
X-Google-Smtp-Source: ABdhPJxI1VDx96KMyZBaHMqKxtFQlZKDrFuVLPTAYXXELhJ7idpZyvxju+d2QfzUIT1PLV1S6ionrg==
X-Received: by 2002:a05:6512:3048:: with SMTP id b8mr9530859lfb.421.1607934575187;
        Mon, 14 Dec 2020 00:29:35 -0800 (PST)
Received: from [192.168.1.157] (h-137-65.A159.priv.bahnhof.se. [81.170.137.65])
        by smtp.gmail.com with ESMTPSA id c5sm2039839lfg.220.2020.12.14.00.29.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Dec 2020 00:29:34 -0800 (PST)
Subject: Re: [PATCH net-next v2] GTP: add support for flow based tunneling API
To:     Pravin Shelar <pravin.ovn@gmail.com>
Cc:     Pravin B Shelar <pbshelar@fb.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>, laforge@gnumonks.org
References: <20201212044017.55865-1-pbshelar@fb.com>
 <67f7c207-a537-dd22-acd8-dcce42755d1a@norrbonn.se>
 <CAOrHB_Dpq+ZnUxQ3PWSxPv_a7N+WPqdczuD=iG_YDpC-r8Q82Q@mail.gmail.com>
From:   Jonas Bonn <jonas@norrbonn.se>
Message-ID: <d739b613-0d8f-9339-4bc4-3c4270e58c67@norrbonn.se>
Date:   Mon, 14 Dec 2020 09:29:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <CAOrHB_Dpq+ZnUxQ3PWSxPv_a7N+WPqdczuD=iG_YDpC-r8Q82Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Pravin,

On 13/12/2020 20:32, Pravin Shelar wrote:
> On Sat, Dec 12, 2020 at 11:56 PM Jonas Bonn <jonas@norrbonn.se> wrote:
>>
>> Hi Pravin,
>>
>> I've been thinking a bit about this and find it more and more
>> interesting.  Could you post a bit of information about the ip-route
>> changes you'll make in order to support GTP LWT encapsulation?  Could
>> you provide an example command line?
>>
> This is done as part of the magma core project
> (https://www.magmacore.org/) that needs OVS GTP support.
> I have started with OVS integration first, there are unit tests that
> validate the GTP support. This is datapath related test, that has the
> setup commands:
> https://github.com/pshelar/ovs/blob/6ec6a2a86adc56c7c9dcab7b3a7b70bb6dad35c9/tests/system-layer3-tunnels.at#L158

That link just shows the classic setup using gtp-link and gtp-tunnel 
from libgtpnl.  It doesn't exercise LWT at all.

> Once OVS patches are upstream I can post patches for ip-route command.

No, you should do it the other way around, please.  Post the ip-route 
changes along with this so we can see where this is going.

>>> +#include <net/dst_metadata.h>
>>>    #include <net/net_namespace.h>
>>>    #include <net/protocol.h>
>>>    #include <net/ip.h>
>>> @@ -73,6 +74,9 @@ struct gtp_dev {
>>>        unsigned int            hash_size;
>>>        struct hlist_head       *tid_hash;
>>>        struct hlist_head       *addr_hash;
>>> +     /* Used by flow based tunnel. */
>>> +     bool                    collect_md;
>>> +     struct socket           *collect_md_sock;
>>
>> I'm not convinced that you need to special-case LWT in this way.  It
>> should be possible to just use the regular sk1u socket.  I know that the
>> sk1u socket is created in userspace and might be set up to listen on the
>> wrong address, but that's a user error if they try to use that device
>> with LWT.  You could easily make the sk1u socket an optional parameter
>> and create it (as you do in your patch) if it's not provided.  Then
>> ip_tunnel_collect_metadata() would tell you whether to get the
>> encapsulaton details from the tunnel itself or whether to look up a PDP
>> context.  That should suffice, right?
>>
> Sounds good. I have added it as part of v3.
> Just to be clear, I still need collect_md_sock to keep reference to
> the socket that is created as part of the newlink in kernel space.

Why?  I don't see that there's anything special enough about that socket 
that you can't just use it as sk1u.  You might need to massage the types 
a bit, but that doesn't seem like a big problem.  What am I missing?

/Jonas

> 
> Thanks,
> Pravin.
> 
