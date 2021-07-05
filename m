Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 482EA3BC1BD
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 18:35:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbhGEQho (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 12:37:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbhGEQhm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Jul 2021 12:37:42 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB22CC061574;
        Mon,  5 Jul 2021 09:35:03 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id m18-20020a9d4c920000b029048b4f23a9bcso6839769otf.9;
        Mon, 05 Jul 2021 09:35:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2TAR10t0SeeOnNIpVqOCA/P0iG1nNKQebPXrjWaJtb8=;
        b=rHesvuimK2TFARWHbzpaATGZCmguf1XLopFhCTk8H0teOqcYrl44e1MoR0WPrDJo/Z
         +C1fVSdrhfunXLnR4etceGNEOxs/t9aC+7m3yg9wKrlQgilx6BGoXT6LN618mX9qAT8f
         NNXqsjZ1+/P7sXs00JmLMHkQC3XixmKhfV8PHXF6ftHAmI+4HDIal4T5f0eCM9lSomIW
         ojg8xfqc493+vgeCdpd2J8VLOGMn4xGFZCDXQVlhSiAthDI+HLz/i4ayptgYKMvpM9XI
         pB8NodwdI1FXS1JlISb48mrSVitpdYDyK0oeKEzwT/m33YV6ObsxbW2Ttz+dBVz1gmX8
         u44Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2TAR10t0SeeOnNIpVqOCA/P0iG1nNKQebPXrjWaJtb8=;
        b=De2EOFYL+e/FdemrL9fpb04K76ARVqwAJfIT2Q/KgfzUDNRuB5T06Pwy6M63OgPEx4
         eQ54cclXiOXfkrYLXA2LMS6p4jeTmKhyhGNcOsemA/MHiPOQ0ERIymFSx6bJ+vk0+pap
         5fHFgixWHHe0j0wmzo8BIHjpAOYJ+WdqqYwabiDy/dYqwG6rX3UAFW+08OvZCYkcaNoW
         BrVWywCpcG1GhrFBEfM9wJOASX+8E5IK14E8FPiz0OLT/i6bmB20gu8vT7EUfcLL8/fk
         /bWSF4pjuSsHXzLEt1sntEXP2Bem8Fpvik6c04KXLysqj/MOlxf299Z+PB8KU24g9eFA
         8JyQ==
X-Gm-Message-State: AOAM531Ragf5QtkaHsG7RTmxDt4HM7i3nzNoImFxko6FbSgGQWxEfHTc
        VtIZ2r4OLZQxfcjJmOsAhKU=
X-Google-Smtp-Source: ABdhPJwnjz4hvEqwtKjSPE7H7MmjVjGF2KI7AM+yiP4/0VF/t9dcVNqbrVzot4kwkj/23frWhct5Qw==
X-Received: by 2002:a9d:17d0:: with SMTP id j74mr11215444otj.92.1625502903254;
        Mon, 05 Jul 2021 09:35:03 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.38])
        by smtp.googlemail.com with ESMTPSA id b20sm132106ots.26.2021.07.05.09.35.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Jul 2021 09:35:02 -0700 (PDT)
Subject: Re: [PATCH] net: ipv6: don't generate link-local address in any
 addr_gen_mode
To:     Rocco Yue <rocco.yue@mediatek.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, wsd_upstream@mediatek.com,
        rocco.yue@gmail.com, chao.song@mediatek.com,
        kuohong.wang@mediatek.com, zhuoliang.zhang@mediatek.com
References: <46a9dbf2-9748-330a-963e-57e615a15440@gmail.com>
 <20210701085117.19018-1-rocco.yue@mediatek.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <62c9f5b7-84bd-d809-4e33-39fed7a9d780@gmail.com>
Date:   Mon, 5 Jul 2021 10:35:00 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210701085117.19018-1-rocco.yue@mediatek.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/1/21 2:51 AM, Rocco Yue wrote:
> On Wed, 2021-06-30 at 22:41 -0600, David Ahern wrote:
>> On 6/30/21 9:39 PM, Rocco Yue wrote:
>>>
>>> Hi David,
>>>
>>> Thanks for your review.
>>>
>>> This patch is different with IN6_ADDR_GEN_MODE_NONE.
>>>
>>> When the addr_gen_mode == IN6_ADDR_GEN_MODE_NONE, the Linux kernel
>>> doesn't automatically generate the ipv6 link-local address.
>>>
>>
>> ...
>>
>>>
>>> After this patch, when the "disable_gen_linklocal_addr" value of a device
>>> is 1, no matter in which addr_gen_mode, the Linux kernel will not automatically
>>> generate an ipv6 link-local for this device.
>>>
>>
>> those 2 sentences are saying the same thing to me.
>>
>> for your use case, why is setting addr_gen_mode == 1 for the device not
>> sufficient?
>>
> 
> For mobile operators that don't need to support RFC7217, setting
> addr_gen_mode == 1 is sufficient;
> 
> But for some other mobile operators that need to support RFC7217, such as AT&T,
> the mobile device's addr_gen_mode will be switched to the
> IN6_ADDR_GEN_MODE_STABLE_PRIVACY, instead of using IN6_ADDR_GEN_MODE_NONE.
> The purpose is: in the IN6_ADDR_GEN_MODE_STABLE_PRIVACY mode, kernel can
> gererate a stable privacy global ipv6 address after receiveing RA, and
> network processes can use this global address to communicate with the
> outside network.
> 
> Of course, mobile operators that need to support RFC7217 should also meet
> the requirement of 3GPP TS 29.061, that is, MT should use IID assigned by
> the GGSN to build its ipv6 link-local address and use this address to send RS.
> We don't want the kernel to automatically generate an ipv6 link-local address
> when addr_gen_mode == 2. Otherwise, using the stable privacy ipv6 link-local
> address automatically generated by the kernel to send RS message, GGSN will
> not be able to respond to the RS and reply a RA message.
> 
> Therefore, after this patch, kernel will not generate ipv6 link-local address
> for the corresponding device when addr_gen_mode == 1 or addr_gen_mode == 2.
> 

I think another addr_gen_mode is better than a separate sysctl. It looks
like IN6_ADDR_GEN_MODE_STABLE_PRIVACY and IN6_ADDR_GEN_MODE_RANDOM are
the ones used for RAs, so add something like:

IN6_ADDR_GEN_MODE_STABLE_PRIVACY_NO_LLA,
IN6_ADDR_GEN_MODE_RANDOM_NO_LLA,

to in6_addr_gen_mode.
