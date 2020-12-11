Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E10C32D7A94
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 17:12:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404555AbgLKQLV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 11:11:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390382AbgLKQLL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 11:11:11 -0500
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96760C0613CF
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 08:10:29 -0800 (PST)
Received: by mail-ot1-x32c.google.com with SMTP id x13so8662538oto.8
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 08:10:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=t1AamKEB8573/0gwWabz8y5LwEeV/syrC78MuWy5qpc=;
        b=CnaS7F3jdu+PwA3Ac84kNeDMu7+QyYeJ26OqiHz9bkzLyZFs/VcrgphShLA3Kc++Sw
         RjAg+Kpr1IVxgoX1UFzSMnqKvg/Vx0OqtOGV1o3TSybYwE5J3IoMOOk9kqP5Oa80H78l
         UopcvFxPdWMUq0JXab+eZTwWzPAla7e0zIYGlylgC4r8nOPL/82vSiy2f3EBTDab4yU2
         AWbCtrc8Naz79IxsjsLCViH9CZJYLM8tCiunEVicbpxQAzjPv9KBtauoue3V/I+XtRE2
         3z8ZGdKusrd1Q1lpkWJGq5kb/boWnpWyzPVWDGTtjIo873zUmSSQtO44fPFM9HAwYAEa
         0s8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=t1AamKEB8573/0gwWabz8y5LwEeV/syrC78MuWy5qpc=;
        b=mUqkUF5cshd7HJxgESfrjfSo2myPuPJNho2T6ZLZop7PNIkBkQQICpdH1uLgQQmI27
         ltW0yGSOk87VMgl4VWM21ZN7u9HTGAhnGWHyQE3Effl446TLACsyLaIQYgykvgAZHNlh
         aXSQmfzkpd1GhbuNK0xbSHZEbRW9gaFr6+G9OfuOiEDH+yGks9xnQEmF+gMHWYPZNusP
         PjmWO2uIKNlG8aasRNELU0J+gqnm6gWHc840chL7itr1l4WS/ix+kxpkrNqZJdPhsiun
         6RwGdBOkFCEaR6NlJGlS0wYMBzL90m/FVPfW0xfyZImGkT0SnxjMxiDWlNipwmH6yKa0
         sBmg==
X-Gm-Message-State: AOAM5301iRVg0S3sjcn/I/Q0CE6j+oh9BU8guhBsIj4SW5E5naOYxF6/
        67tAydVzAn+ElJqR7m62zWQ=
X-Google-Smtp-Source: ABdhPJwyTffKCOsXL3Ep9EpfYtUlt1TzVJYzZBmnXocIwhRJhOs52agbgw3k7x39eluRhPUx7oYmwA==
X-Received: by 2002:a05:6830:1bef:: with SMTP id k15mr2071525otb.303.1607703029042;
        Fri, 11 Dec 2020 08:10:29 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:6139:6f39:a803:1a61])
        by smtp.googlemail.com with ESMTPSA id i1sm999013otr.81.2020.12.11.08.10.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Dec 2020 08:10:28 -0800 (PST)
Subject: Re: Refcount mismatch when unregistering netdevice from kernel
To:     stranche@codeaurora.org
Cc:     Wei Wang <weiwan@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Mahesh Bandewar <maheshb@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
References: <ca64de092db5a2ac80d22eaa9d662520@codeaurora.org>
 <56e72b72-685f-925d-db2d-d245c1557987@gmail.com>
 <CAEA6p_D+diS7jnpoGk6cncWL8qiAGod2EAp=Vcnc-zWNPg04Jg@mail.gmail.com>
 <307c2de1a2ddbdcd0a346c57da88b394@codeaurora.org>
 <CAEA6p_ArQdNp=hQCjrsnAo-Xy22d44b=2KdLp7zO7E7XDA4Fog@mail.gmail.com>
 <f10c733a-09f8-2c72-c333-41f9d53e1498@gmail.com>
 <6a314f7da0f41c899926d9e7ba996337@codeaurora.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <839f0ad6-83c1-1df6-c34d-b844c52ba771@gmail.com>
Date:   Fri, 11 Dec 2020 09:10:26 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <6a314f7da0f41c899926d9e7ba996337@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/10/20 6:12 PM, stranche@codeaurora.org wrote:
>>> BTW, have you tried your previous proposed patch and confirmed it
>>> would fix the issue?
>>>
> 
> Yes, we shared this with the customer and the refcount mismatch still
> occurred, so this doesn't seem sufficient either.
> 
>>> Could we further distinguish between dst added to the uncached list by
>>> icmp6_dst_alloc() and xfrm6_fill_dst(), and confirm which ones are the
>>> ones leaking reference?
>>> I suspect it would be the xfrm ones, but I think it is worth verifying.
>>>
> 
> After digging into the DST allocation/destroy a bit more, it seems that
> there are some cases where the DST's refcount does not hit zero, causing
> them to never be freed and release their references.
> One case comes from here on the IPv6 packet output path (these DST
> structs would hold references to both the inet6_dev and the netdevice)
> ip6_pol_route_output+0x20/0x2c -> ip6_pol_route+0x1dc/0x34c ->
> rt6_make_pcpu_route+0x18/0xf4 -> ip6_rt_pcpu_alloc+0xb4/0x19c

This is the normal data path, and this refers to a per-cpu dst cache.
Delete the route and the cached entries get removed.

> 
> We also see two DSTs where they are stored as the xdst->rt entry on the
> XFRM path that do not get released. One is allocated by the same path as
> above, and the other like this
> xfrm6_esp_err+0x7c/0xd4 -> esp6_err+0xc8/0x100 ->
> ip6_update_pmtu+0xc8/0x100 -> __ip6_rt_update_pmtu+0x248/0x434 ->
> ip6_rt_cache_alloc+0xa0/0x1dc

This entry goes into an exception cache. I have lost track of kernel
versions and features. Try listing the route cache to see these:  ip -6
ro ls cache
