Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6F3B405D31
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 21:12:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237728AbhIITNu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 15:13:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231425AbhIITNt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Sep 2021 15:13:49 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3A22C061574;
        Thu,  9 Sep 2021 12:12:39 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id y128so3899765oie.4;
        Thu, 09 Sep 2021 12:12:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qPQHwAFiSYdLyleAbELrQZ2a09NIC4IXr92lC8k0Z2o=;
        b=iP93NZjLCWK7wrqXWEzIuyPF1eZNfnZ3JjpCM3RA+qd12seWfFmLUQQbh+/RrxpGmj
         ENQ8gOluBLG8GHQBb+a97ETd6UUMNun19AFQwNotAQqAdX27mfavG+nw0dNPuLCBqUnj
         Slj6zu9FeZDMvZgcz51saRw1LklQCwZSjgoemHLLI6hM4s7/i75qfYjqhS+kY/kdG65l
         a/EUPjXbQjZYFgENdYljH7VsPsAPkSdnX/JDpdMEO9TxVkMY1EDW12ESbmKouOuC4BG1
         xwWKt8CWA5ypzZ8KgPSxKgDua/+uNGDAhtQsXwO9G5+SjqVMkgRPBCMsyS1PlTQHU7iE
         m97A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qPQHwAFiSYdLyleAbELrQZ2a09NIC4IXr92lC8k0Z2o=;
        b=bUdSW1MsJpiTanugR1uY2Q73ijjrGtB3e1u5zWLh9DO+GkT4X86ZykKGNC6vGBZ8ze
         njYVcTVM2ygdwP6Dp9IUUA0F/oaVwDb4td7i7k6OJn39jxj/Es7MEDm4YMlfVxt0qaWC
         1zHcuXgPyn9dR4/1FmtStWDj7Np8MSBKYfdr02IL7+N57Ndp0P0fGqBs2YpJ4dK8GG6B
         8yRDwVSv2gEKitXwDVfD9TT9zXDAOX4N4sNNtYNvWMzpxX+/iLyWU+eeJOcx3QXref5u
         hMfHzgXawnDfOI1LhDtOZEbu56jGuv80uGsCboVEjC6M1NYLJkRzjYy9FCDNv4VB8E6+
         7vbg==
X-Gm-Message-State: AOAM531bai/98D8crKhr5cF/Nq3717AJ1BTHrTNbxFpnVCOrzWDDxCuM
        /qvAZyaXELpOr3asIIsYI0o=
X-Google-Smtp-Source: ABdhPJy+SBSctEcaaYBPlw3qORiGmzGEDUEjUOC7t0uGsaCXWESlSTjxPpHMdXVn+rNqPxve9DMoqQ==
X-Received: by 2002:a05:6808:1481:: with SMTP id e1mr1037664oiw.5.1631214759289;
        Thu, 09 Sep 2021 12:12:39 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:395a:c:3f8e:f434])
        by smtp.googlemail.com with ESMTPSA id w1sm651917ott.21.2021.09.09.12.12.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Sep 2021 12:12:38 -0700 (PDT)
Subject: Re: [PATCH] net: ipv6: don't generate link-local address in any
 addr_gen_mode
To:     Lorenzo Colitti <lorenzo@google.com>
Cc:     Rocco Yue <rocco.yue@mediatek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Linux NetDev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, wsd_upstream@mediatek.com,
        rocco.yue@gmail.com, chao.song@mediatek.com,
        =?UTF-8?B?S3VvaG9uZyBXYW5nICjnjovlnIvptLsp?= 
        <kuohong.wang@mediatek.com>,
        =?UTF-8?B?Wmh1b2xpYW5nIFpoYW5nICjlvKDljZPkuq4p?= 
        <zhuoliang.zhang@mediatek.com>
References: <46a9dbf2-9748-330a-963e-57e615a15440@gmail.com>
 <20210701085117.19018-1-rocco.yue@mediatek.com>
 <62c9f5b7-84bd-d809-4e33-39fed7a9d780@gmail.com>
 <CAKD1Yr2aijPe_aq+SRm-xv0ZPoz_gKjYrEX97R1NJyYpSnv4zg@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <6a8f0e91-225a-e2a8-3745-12ff1710a8df@gmail.com>
Date:   Thu, 9 Sep 2021 13:12:37 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <CAKD1Yr2aijPe_aq+SRm-xv0ZPoz_gKjYrEX97R1NJyYpSnv4zg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/9/21 12:20 AM, Lorenzo Colitti wrote:
>> I think another addr_gen_mode is better than a separate sysctl. It looks
>> like IN6_ADDR_GEN_MODE_STABLE_PRIVACY and IN6_ADDR_GEN_MODE_RANDOM are
>> the ones used for RAs, so add something like:
>>
>> IN6_ADDR_GEN_MODE_STABLE_PRIVACY_NO_LLA,
>> IN6_ADDR_GEN_MODE_RANDOM_NO_LLA,
> 
> I think the real requirement here (which wasn't clear in this thread)
> is that the network needs to control the interface ID (i.e., the
> bottom 64 bits) of the link-local address, but the device is free to
> use whatever interface IDs to form global addresses. See:
> https://www.etsi.org/deliver/etsi_ts/129000_129099/129061/15.03.00_60/ts_129061v150300p.pdf
> 
> How do you think that would best be implemented?

There is an established paradigm for configuring how an IPv6 address is
created or whether it is created at all - the IFLA_INET6_ADDR_GEN_MODE
attribute.

> 
> 1. The actual interface ID could be passed in using IFLA_INET6_TOKEN,
> but there is only one token, so that would cause all future addresses
> to use the token, disabling things like privacy addresses (bad).
> 2. We could add new IN6_ADDR_GEN_MODE_STABLE_PRIVACY_LL_TOKEN,
> IN6_ADDR_GEN_MODE_RANDOM_LL_TOKEN, etc., but we'd need to add one such
> mode for every new mode we add.
> 3. We could add a separate sysctl for the link-local address, but you
> said that per-device sysctls aren't free.

per-device sysctl's are one of primary causes of per netdev memory usage.

Besides that there is no reason to add complexity by having a link
attribute and a sysctl for this feature.

> 4. We could change the behaviour so that if the user configures a
> token and then sets IN6_ADDR_GEN_MODE_*, then we use the token only
> for the link-local address. But that would impact backwards
> compatibility.
> 
> Thoughts?

We can have up to 255 ADDR_GEN_MODEs (GEN_MODE is a u8). There is
established code for handling the attribute and changes to it. Let's
reuse it.
