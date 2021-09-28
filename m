Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22DA841B25D
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 16:51:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241413AbhI1Ox3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 10:53:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241294AbhI1OxZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 10:53:25 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28C4EC061745
        for <netdev@vger.kernel.org>; Tue, 28 Sep 2021 07:51:44 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id r83-20020a1c4456000000b0030cfc00ca5fso2528660wma.2
        for <netdev@vger.kernel.org>; Tue, 28 Sep 2021 07:51:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8k4vzjTEvvF0RcP+mluO0fPYoFQpr61i483WOpfKr1k=;
        b=TpeYbEuJJ4BseQvOvsvFWNckRy2BTd89M8cj9jh37927UcZldckqMJlKOP/SF4KkEy
         CQPdqeyZbTIxb2pF0lgUpKUsXhXVEptfWKthyBYpNh+pPjkN5Dg+olzMgwSoRNV7QloU
         LCtYS+3x50jkmVUMP6mR8Ci5d16ZUIN7/WE5kvjc1EAuMKc17IrCPEYtlpOLNAq9PI5E
         s/yeti1LAQlHBI8WhQzlOwD7Efhby2VXhPz+7tfA38omrJDQxjzjBu0IL8unvJ0RObNJ
         jOYXqz0QVbZW7uv2HbaVJS8BYkjwQzj6noZiofXvlQiZ3V2YZtY1yASn77l6YQki/mEQ
         nPpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=8k4vzjTEvvF0RcP+mluO0fPYoFQpr61i483WOpfKr1k=;
        b=Aivn5VxuWdS2jG9M6hFHCj2VeX7zLKXKrocuRGOhQjt1OAgPuDBDg+Aux2KJ84Kf/c
         d4np1XhgBBhDGJHs/stbvNSKjL/NJs9Xrwd9JO/5S5yPffIcm2VEY6iZUQa/O8ZJ4Jaw
         bBgfUD4jBgxWmWwXaKN7g+qBUFNV/hq7kcCX0kwPacfFJ5k4GpwwnyAve96hfB4bEe6j
         VQDxPZQ336JIz5A8bJBlNDdAIW50I66T3XOoFFotBmUQjcc0+HSGfXYKQEE8/9rL1ndY
         hwzy+iGkd9wjAOIUe5P3AaA10GYRBeq8elsyZGZCAcnGUQ4dOuBFJiRAKmS9wfbuy1Nk
         U/GA==
X-Gm-Message-State: AOAM533Wawa2N61HtwvVZbrgb5WcESs0AAEKtmjXDDFaofh0HsdwxNvU
        CvRrciNrlD3BUTSBmenVJMz62A==
X-Google-Smtp-Source: ABdhPJz2gMZyojYjj1eiZ6lXVK/hCRlmBB7ziEb6GpJ1kWQycNGC02kKJC0JGDUgmWJgxIeqecc3qA==
X-Received: by 2002:a05:600c:22d6:: with SMTP id 22mr5266861wmg.17.1632840702114;
        Tue, 28 Sep 2021 07:51:42 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:410:bb00:e0fd:c68f:ea32:2084? ([2a01:e0a:410:bb00:e0fd:c68f:ea32:2084])
        by smtp.gmail.com with ESMTPSA id j19sm19877425wra.92.2021.09.28.07.51.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Sep 2021 07:51:41 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH net-next v5] net: openvswitch: IPv6: Add IPv6 extension
 header support
To:     Cpp Code <cpp.code.lv@gmail.com>
Cc:     netdev@vger.kernel.org, pshelar@ovn.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        ovs dev <dev@openvswitch.org>, linux-kernel@vger.kernel.org
References: <20210920182038.1510501-1-cpp.code.lv@gmail.com>
 <0d70b112-dc7a-7083-db8d-183782b8ef8f@6wind.com>
 <CAASuNyUWoZ1wToEUYbdehux=yVnWQ=suKDyRkQfRD-72DOLziw@mail.gmail.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <e4bb09d1-8c8f-bfdf-1582-9dd8c560411b@6wind.com>
Date:   Tue, 28 Sep 2021 16:51:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <CAASuNyUWoZ1wToEUYbdehux=yVnWQ=suKDyRkQfRD-72DOLziw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 27/09/2021 à 21:12, Cpp Code a écrit :
> To use this code there is a part of code in the userspace. We want to
> keep compatibility when we only update userspace part code or only
> kernel part code. This means we should have same values for constants
> and we can only add new ones at the end of list.
All attributes after OVS_KEY_ATTR_CT_STATE (ie 7 attributes) were added before
OVS_KEY_ATTR_TUNNEL_INFO.
Why is it not possible anymore?


Regards,
Nicolas

> 
> Best,
> Tom
> 
> On Wed, Sep 22, 2021 at 11:02 PM Nicolas Dichtel
> <nicolas.dichtel@6wind.com> wrote:
>>
>> Le 20/09/2021 à 20:20, Toms Atteka a écrit :
>>> This change adds a new OpenFlow field OFPXMT_OFB_IPV6_EXTHDR and
>>> packets can be filtered using ipv6_ext flag.
>>>
>>> Signed-off-by: Toms Atteka <cpp.code.lv@gmail.com>
>>> ---
>>>  include/uapi/linux/openvswitch.h |  12 +++
>>>  net/openvswitch/flow.c           | 140 +++++++++++++++++++++++++++++++
>>>  net/openvswitch/flow.h           |  14 ++++
>>>  net/openvswitch/flow_netlink.c   |  24 +++++-
>>>  4 files changed, 189 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/openvswitch.h
>>> index a87b44cd5590..dc6eb5f6399f 100644
>>> --- a/include/uapi/linux/openvswitch.h
>>> +++ b/include/uapi/linux/openvswitch.h
>>> @@ -346,6 +346,13 @@ enum ovs_key_attr {
>>>  #ifdef __KERNEL__
>>>       OVS_KEY_ATTR_TUNNEL_INFO,  /* struct ip_tunnel_info */
>>>  #endif
>>> +
>>> +#ifndef __KERNEL__
>>> +     PADDING,  /* Padding so kernel and non kernel field count would match */
>>> +#endif
>>> +
>>> +     OVS_KEY_ATTR_IPV6_EXTHDRS,  /* struct ovs_key_ipv6_exthdr */
>> Naive question, why not moving OVS_KEY_ATTR_IPV6_EXTHDRS above
>> OVS_KEY_ATTR_TUNNEL_INFO?
>>
>>
>>
>> Regards,
>> Nicolas
