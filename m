Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A02E3BE9E3
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 16:39:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232067AbhGGOmW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 10:42:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231737AbhGGOmV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 10:42:21 -0400
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2EC5C061574;
        Wed,  7 Jul 2021 07:39:41 -0700 (PDT)
Received: by mail-oi1-x22c.google.com with SMTP id h9so3619979oih.4;
        Wed, 07 Jul 2021 07:39:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7gNQ41svyZKSD+ZfD8X+CqWoSx+Yg2oHnylVZwRWNDo=;
        b=L/ODocFurzt1NRPzGA5lgvAU0Xmmy6nYMfX0rEkugKDENAYJ69ezTbt8anW8TZ+T+u
         OzeGilDz9B/JAI2WE2AsyQ0R/RiYlZcGxRjh2Qv1GWl2GbjuhDCttSmjDvgJQQWGoojE
         Lhntd2uV1C9hC6WSHTM90CyXMeChw+jTvKV2gpw+vYF/5xBfckF7ru6KFnUaIi5owd0p
         hTUSjX0gYLF+OpN3LbIl6OCtL4cpOw5SryYqFwCBEAa+6lBf/I+j9INxwAky9TuUSZAs
         cbnLBtzF+U8ZYA30fYne+K+igNpQ9qw7tsuG1RChPgxPDa/kxT9ddftNe0TQARiDR2Lh
         2Q/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7gNQ41svyZKSD+ZfD8X+CqWoSx+Yg2oHnylVZwRWNDo=;
        b=lhoAOl6B1X7sbrRyaRsiooeBr12RYEODjI2ZtrP87FL7wt496ondPos6NFZf6rzhc4
         PyIj6B3V3QZLhWlQP+mnAedDAxpNLIZB7OT4/ArWWd8V1QM6hKcSwTkiM/lP2RQw+RvH
         QiiNnV+kXYyO5Rgv0bhQgqHeOacBRpnpWJ5/OzrLq/CmX9AcEyzENFa11soNR4HLaHfo
         i7DI9Wlsq9qyQPT3TyYmGBIrRniIWAdH7S7eeFxrtKcDjoRlC90u+kcxWXikydhQnpJd
         7Fm7sXI8yyMypIxnxnwJSH0Bv0K0I/96K5I4Vzjue+Nu9OESLe4IwylP/1czXJz6sA9I
         5seA==
X-Gm-Message-State: AOAM533Aj+QcKMC8bbB6jzfHB2RVjX1xfW/q9SQWolfKDWaqZ+bKutYZ
        wLItgmgoDh7Qq7MRM1omODI=
X-Google-Smtp-Source: ABdhPJzZM+I+Wr1D4VNlEvutVIoJ2NobSdnA50lqeXIa+sMuqMrBynrLi64o20n/N+Pb4v6xX7/w4g==
X-Received: by 2002:a05:6808:d54:: with SMTP id w20mr5167481oik.175.1625668781164;
        Wed, 07 Jul 2021 07:39:41 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.38])
        by smtp.googlemail.com with ESMTPSA id v2sm901050ots.8.2021.07.07.07.39.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jul 2021 07:39:40 -0700 (PDT)
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
References: <62c9f5b7-84bd-d809-4e33-39fed7a9d780@gmail.com>
 <20210706123702.29375-1-rocco.yue@mediatek.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <40951584-8f53-4e95-4a6b-14ae1cf7f011@gmail.com>
Date:   Wed, 7 Jul 2021 08:39:36 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210706123702.29375-1-rocco.yue@mediatek.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/6/21 6:37 AM, Rocco Yue wrote:
> On Mon, 2021-07-05 at 10:35 -0600, David Ahern wrote:
>> On 7/1/21 2:51 AM, Rocco Yue wrote:
>>> On Wed, 2021-06-30 at 22:41 -0600, David Ahern wrote:
>>>
>>> For mobile operators that don't need to support RFC7217, setting
>>> addr_gen_mode == 1 is sufficient;
>>>
>>> But for some other mobile operators that need to support RFC7217, such as AT&T,
>>> the mobile device's addr_gen_mode will be switched to the
>>> IN6_ADDR_GEN_MODE_STABLE_PRIVACY, instead of using IN6_ADDR_GEN_MODE_NONE.
>>> The purpose is: in the IN6_ADDR_GEN_MODE_STABLE_PRIVACY mode, kernel can
>>> gererate a stable privacy global ipv6 address after receiveing RA, and
>>> network processes can use this global address to communicate with the
>>> outside network.
>>>
>>> Of course, mobile operators that need to support RFC7217 should also meet
>>> the requirement of 3GPP TS 29.061, that is, MT should use IID assigned by
>>> the GGSN to build its ipv6 link-local address and use this address to send RS.
>>> We don't want the kernel to automatically generate an ipv6 link-local address
>>> when addr_gen_mode == 2. Otherwise, using the stable privacy ipv6 link-local
>>> address automatically generated by the kernel to send RS message, GGSN will
>>> not be able to respond to the RS and reply a RA message.
>>>
>>> Therefore, after this patch, kernel will not generate ipv6 link-local address
>>> for the corresponding device when addr_gen_mode == 1 or addr_gen_mode == 2.
>>>
>>
>> I think another addr_gen_mode is better than a separate sysctl. It looks
>> like IN6_ADDR_GEN_MODE_STABLE_PRIVACY and IN6_ADDR_GEN_MODE_RANDOM are
>> the ones used for RAs, so add something like:
>>
>> IN6_ADDR_GEN_MODE_STABLE_PRIVACY_NO_LLA,
>> IN6_ADDR_GEN_MODE_RANDOM_NO_LLA,
>>
>> to in6_addr_gen_mode.
>>
> 
> Hi David,
> 
> Thanks for your reply.
> 
> According to your suggestion, I checked the ipv6 code again. In my
> opinion, adding another addr_gen_mode may not be suitable.
> 
> (1)
> In the user space, the process enable the ipv6 stable privacy mode by
> setting the "/proc/sys/net/ipv6/conf/<iface>/stable_secret".
> 
> In the kernel, the addr_gen_mode of a networking device is switched to
> IN6_ADDR_GEN_MODE_STABLE_PRIVACY by judging the bool value of
> "cnf.stable_secret.initialized".

and that can be updated. If the default (inherited) setting is
IN6_ADDR_GEN_MODE_STABLE_PRIVACY_NO_LLA, then do not change to
IN6_ADDR_GEN_MODE_STABLE_PRIVACY.

> 
> So, although adding an additional IN6_ADDR_GEN_MODE_STABLE_PRIVACY_NO_LLA,
> user space process has some trouble to let kernel switch the iface's
> addr_gen_mode to the IN6_ADDR_GEN_MODE_STABLE_PRIVACY_NO_LLA.
> 
> This is not as flexible as adding a separate sysctl.
> 
> (2)
> After adding "proc/sys/net/ipv6/<iface>/disable_gen_linklocal_addr",
> so that kernel can keep the original code logic of the stable_secret
> proc file, and expand when the subsequent kernel adds a new add_gen_mode
> more flexibility and applicability.
> 
> And we only need to care about the networking device that do not
> generate an ipv6 link-local address, and not the addr_gen_mode that
> this device is using.
> 
> Maybe adding a separate sysctl is a better choice.
> Looking forward to your professional reply again.

per device sysctl's are not free. I do not see a valid reason for a
separate disable knob.
