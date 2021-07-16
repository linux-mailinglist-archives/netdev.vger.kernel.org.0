Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 818303CB8C8
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 16:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232988AbhGPOjg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 10:39:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233009AbhGPOjf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Jul 2021 10:39:35 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA36AC06175F
        for <netdev@vger.kernel.org>; Fri, 16 Jul 2021 07:36:40 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id i94so12359622wri.4
        for <netdev@vger.kernel.org>; Fri, 16 Jul 2021 07:36:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lSrntPs33U9KYjlOA5x/UB/5uz8HBWUx1srTQBrRRDk=;
        b=JQ6EpYV4sVXf0xU0xVttdVmimQ8XNbM7zu0d/NZv7SwDQyaYyHlqM52nbwYwAbZN1q
         jhBeOyoqw8zz+mB3I114c/h/F4cMgsWy4TVJDF7g6P3Cx2iDBz9lJSJDnvlfQGKxPYXn
         x3U5vbYVRVUqa5r0KlasfTR51vG281vqlszjwggVNd8Kv5IuwX5ydjaTPTtnvD4/3SDr
         MzsNBRNITRD9G42pw7ZYBz4yuMlg9ff0HqC9Aru1i+U97XIeFN4kNp2LVnzGNzQYQxpd
         UwCxnr9qGwn0iEpk0rfoqbMeW+qd2DpRNsykzmJrX0qjKR2YYNd3QIzczp3xgjujP3Q5
         xfZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lSrntPs33U9KYjlOA5x/UB/5uz8HBWUx1srTQBrRRDk=;
        b=SWxhrbU6Iw/IV/WauU5JMdgdhPmtTWLCd2zotz7gpVzDa29RjJODFSS1RgD5jujcq+
         ZY7MLrh0omnlWAaRSAVDkyNPAuwKWwfhjLuFJnOjfiE8MlX282XltQ/M1nfkDpt1ypK4
         2mlpH52XzFmbtIF50LXqlDGiU8jqwyoKSMln3PqQIFq3b1qGpVgZIGR5M46xOAzFxsRw
         wZ0UYDkVsC1zPHXf1vfEUc0YVBk1crqwCt0R4F5zVgI0O2biNt6A2P4j7jU2WUImpkEj
         Ni4a9xpMtLcXI22Ofqh3C2AioVGFKvNZ4n9sf8XbN84CgDNIQbWXYlXukFRBxi3HK4fX
         05fw==
X-Gm-Message-State: AOAM533fWZY1cF9ILwMXrNBtdm2Zb1kWRD/5o1lVET2dBjgaHWNfllOy
        PCi+aGVpg8/bdCY+mvvkCcgcdg==
X-Google-Smtp-Source: ABdhPJwEphdp6WbHNMv8MC2I1/d2SY2hsl0QXgkpJb4B22fS6giMmCxobUVPPqKMJlOUTSCnpmp6jw==
X-Received: by 2002:a5d:4e43:: with SMTP id r3mr12802940wrt.132.1626446199282;
        Fri, 16 Jul 2021 07:36:39 -0700 (PDT)
Received: from ?IPv6:2a02:8084:e84:2480:228:f8ff:fe6f:83a8? ([2a02:8084:e84:2480:228:f8ff:fe6f:83a8])
        by smtp.gmail.com with ESMTPSA id l39sm7283238wms.1.2021.07.16.07.36.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Jul 2021 07:36:38 -0700 (PDT)
Subject: Re: [PATCH] xfrm/compat: Fix general protection fault in
 xfrm_user_rcv_msg_compat()
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        YueHaibing <yuehaibing@huawei.com>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net, kuba@kernel.org,
        0x7f454c46@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210712134002.34048-1-yuehaibing@huawei.com>
 <20210716080119.GC3684238@gauss3.secunet.de>
From:   Dmitry Safonov <dima@arista.com>
Message-ID: <7d6604a1-02ee-d69d-0efe-d75d152f9b46@arista.com>
Date:   Fri, 16 Jul 2021 15:36:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210716080119.GC3684238@gauss3.secunet.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/16/21 9:01 AM, Steffen Klassert wrote:
> On Mon, Jul 12, 2021 at 09:40:02PM +0800, YueHaibing wrote:
>> In xfrm_user_rcv_msg_compat() if maxtype is not zero and less than
>> XFRMA_MAX, nlmsg_parse_deprecated() do not initialize attrs array fully.
>> xfrm_xlate32() will access uninit 'attrs[i]' while iterating all attrs
>> array.
>>
>> KASAN: probably user-memory-access in range [0x0000000041b58ab0-0x0000000041b58ab7]
>> CPU: 0 PID: 15799 Comm: syz-executor.2 Tainted: G        W         5.14.0-rc1-syzkaller #0
>> RIP: 0010:nla_type include/net/netlink.h:1130 [inline]
>> RIP: 0010:xfrm_xlate32_attr net/xfrm/xfrm_compat.c:410 [inline]
>> RIP: 0010:xfrm_xlate32 net/xfrm/xfrm_compat.c:532 [inline]
>> RIP: 0010:xfrm_user_rcv_msg_compat+0x5e5/0x1070 net/xfrm/xfrm_compat.c:577
>> [...]
>> Call Trace:
>>  xfrm_user_rcv_msg+0x556/0x8b0 net/xfrm/xfrm_user.c:2774
>>  netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2504
>>  xfrm_netlink_rcv+0x6b/0x90 net/xfrm/xfrm_user.c:2824
>>  netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
>>  netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
>>  netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1929
>>  sock_sendmsg_nosec net/socket.c:702 [inline]
>>
>> Fixes: 5106f4a8acff ("xfrm/compat: Add 32=>64-bit messages translator")
>> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
>> ---
>>  net/xfrm/xfrm_compat.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/net/xfrm/xfrm_compat.c b/net/xfrm/xfrm_compat.c
>> index a20aec9d7393..4738660cadea 100644
>> --- a/net/xfrm/xfrm_compat.c
>> +++ b/net/xfrm/xfrm_compat.c
>> @@ -559,8 +559,8 @@ static struct nlmsghdr *xfrm_user_rcv_msg_compat(const struct nlmsghdr *h32,
>>  	    (h32->nlmsg_flags & NLM_F_DUMP))
>>  		return NULL;
>>  
>> -	err = nlmsg_parse_deprecated(h32, compat_msg_min[type], attrs,
>> -			maxtype ? : XFRMA_MAX, policy ? : compat_policy, extack);
>> +	err = nlmsg_parse_deprecated(h32, compat_msg_min[type], attrs, XFRMA_MAX,
>> +				     policy ? : compat_policy, extack);
> 
> This removes the only usage of maxtype in that function. If we don't
> need it, we should remove maxtype from the function parameters.
> 
> But looking closer at this, it seems that xfrm_xlate32() should
> only iterate up to maxtype if set. Dimitry, any opinion on that?
> 

Thanks for Cc. Yeah, I agree, it should pass maxtype to xfrm_xlate32().
More than that, it is XFRM_MSG_NEWSPDINFO, which have different possible
attributes: XFRMA_SPD_MAX vs XFRMA_MAX, so attribute translator
xfrm_xlate32_attr() should be corrected to translate these.

Let me fix this, thanks for the report!
I'll also add a selftest for this to xfrm selftest.

Thanks,
          Dmitry
