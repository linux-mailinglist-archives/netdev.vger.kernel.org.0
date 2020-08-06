Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8F0523DEC4
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 19:32:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730431AbgHFR3g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 13:29:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729920AbgHFRAI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 13:00:08 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E586BC0A54D8
        for <netdev@vger.kernel.org>; Thu,  6 Aug 2020 07:03:30 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id d14so44974874qke.13
        for <netdev@vger.kernel.org>; Thu, 06 Aug 2020 07:03:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zFDwDBzVOvC/lxRFjXpwovm8YIXyFJtKM1I6qJj3qug=;
        b=f2h0koFrG7/UlwbP9AO7/RpyOr+Ur3pezD046bN6ldCGDaxwXJhkJXw9oOdUwbTzQ7
         G+uvRIpA4nbsNJEXc46qgH/KTDQJQjfDha5mmguNxQOkSMXn36wqLkdlxySot/v+NIgx
         oE65l+nOpNEvT8DnHCowdbAHd+BFVLzsRMUfnvKNoyotIDjuaQxHp6zHFOqZM3i7vO/B
         oTXF/QxNBDbEXetfCXulL5cG+uhcS0AznCWAdiI+AyP2V1gkV15CRXdIpHN6rFYYqkfH
         weCb22YaIrVERRdne0HAgvTGU24toN22nqet3kBZDVHtudl9UMksDKlhtqyQ0wZwO4AI
         WCnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zFDwDBzVOvC/lxRFjXpwovm8YIXyFJtKM1I6qJj3qug=;
        b=mUx7uoIRUoLkXnGw1OG4qeHBovHzAyiknw+o48iVzL8AH9JX7DmOiY08Ibk7ldRVxp
         kXA2Ec8awi2fSSSvdHT0OmThZljgE1eSNiUYdm01yDe1HYl5I82w/QNC+JdIi5RGoWi7
         WEOn8TVzq+cdrLisJxCHzdjbxeIhgrf9Q6h2IX7z0ZN6HAmvqBJo5OQKDa+Yv4MAne0C
         GooItQeu3dCD9rYyurnqyX0P6BuLcrEMAtqTO+azN1k8FhfKhgENC7liUUbD0AgKrGcb
         8t0KQhdwTUpxUT/1P032hE3Fo8Gr2/uG8xAvsXCt2PfAmj4nqYS8IEz10l1q3DAKkRp3
         tQBw==
X-Gm-Message-State: AOAM532+zoWQFYdHed/aVIGgbmxmxTSW2Zre6uBy0+/DHMzYBh1rm93u
        OW1PPlGOa9CeCQQkMNMww9A=
X-Google-Smtp-Source: ABdhPJwtJLxSyqNPTdzADA0S/orOLTcuhxnkxfKui+/rZVX4fYSSCXzXoSq9zr6lr5OMPD0OCJOwVg==
X-Received: by 2002:a05:620a:22c5:: with SMTP id o5mr8424138qki.72.1596722603700;
        Thu, 06 Aug 2020 07:03:23 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:342a:71d2:a3e6:c7be? ([2601:282:803:7700:342a:71d2:a3e6:c7be])
        by smtp.googlemail.com with ESMTPSA id e4sm5046978qts.57.2020.08.06.07.03.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Aug 2020 07:03:22 -0700 (PDT)
Subject: Re: [PATCH net 1/2] ipv6: add ipv6_dev_find()
To:     Xin Long <lucien.xin@gmail.com>,
        Hideaki Yoshifuji <hideaki.yoshifuji@miraclelinux.com>
Cc:     network dev <netdev@vger.kernel.org>, davem <davem@davemloft.net>,
        Jon Maloy <jon.maloy@ericsson.com>,
        Ying Xue <ying.xue@windriver.com>,
        tipc-discussion@lists.sourceforge.net,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
References: <cover.1596468610.git.lucien.xin@gmail.com>
 <7ba2ca17347249b980731e7a76ba3e24a9e37720.1596468610.git.lucien.xin@gmail.com>
 <CAPA1RqCz=h-RBu-md1rJ5WLWsr9LLqO8bK9D=q6_vzYMz7564A@mail.gmail.com>
 <CADvbK_dSnrBkw_hJV8LVCEs9D-WB+h2QC3JghLCxVwV5PW9YYA@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <1f510387-b612-6cb4-8ee6-ff52f6ff6796@gmail.com>
Date:   Thu, 6 Aug 2020 08:03:20 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <CADvbK_dSnrBkw_hJV8LVCEs9D-WB+h2QC3JghLCxVwV5PW9YYA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/6/20 2:55 AM, Xin Long wrote:
> On Thu, Aug 6, 2020 at 10:50 AM Hideaki Yoshifuji
> <hideaki.yoshifuji@miraclelinux.com> wrote:
>>
>> Hi,
>>
>> 2020年8月4日(火) 0:35 Xin Long <lucien.xin@gmail.com>:
>>>
>>> This is to add an ip_dev_find like function for ipv6, used to find
>>> the dev by saddr.
>>>
>>> It will be used by TIPC protocol. So also export it.
>>>
>>> Signed-off-by: Xin Long <lucien.xin@gmail.com>
>>> ---
>>>  include/net/addrconf.h |  2 ++
>>>  net/ipv6/addrconf.c    | 39 +++++++++++++++++++++++++++++++++++++++
>>>  2 files changed, 41 insertions(+)
>>>
>>> diff --git a/include/net/addrconf.h b/include/net/addrconf.h
>>> index 8418b7d..ba3f6c15 100644
>>> --- a/include/net/addrconf.h
>>> +++ b/include/net/addrconf.h
>>> @@ -97,6 +97,8 @@ bool ipv6_chk_custom_prefix(const struct in6_addr *addr,
>>>
>>>  int ipv6_chk_prefix(const struct in6_addr *addr, struct net_device *dev);
>>>
>>> +struct net_device *ipv6_dev_find(struct net *net, const struct in6_addr *addr);
>>> +
>>
>> How do we handle link-local addresses?
> This is what "if (!result)" branch meant to do:
> 
> +       if (!result) {
> +               struct rt6_info *rt;
> +
> +               rt = rt6_lookup(net, addr, NULL, 0, NULL, 0);
> +               if (rt) {
> +                       dev = rt->dst.dev;
> +                       ip6_rt_put(rt);
> +               }
> +       } else {
> +               dev = result->idev->dev;
> +       }
> 

the stated purpose of this function is to find the netdevice to which an
address is attached. A route lookup should not be needed. Walking the
address hash list finds the address and hence the netdev or it does not.


