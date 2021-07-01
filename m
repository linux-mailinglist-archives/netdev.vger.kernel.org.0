Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90E693B8D37
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 06:44:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232295AbhGAEoD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 00:44:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbhGAEoC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 00:44:02 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76482C061756;
        Wed, 30 Jun 2021 21:41:31 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id a133so5805590oib.13;
        Wed, 30 Jun 2021 21:41:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ULZfPJnXFZifSjfdbhwtJxBX08db8bBGWvZTGfYyVog=;
        b=SaUIeMwU9ZfcVbwMg1gCvQSr9O8/iAVHlTuuGaSO23aqy5hzsIpWLtN9F0ZkLl7S8h
         sXERkfOYm8aBpV/ZfOZFc9JrYuY2sQSVAIwihOBOjv4ZTAoj1IiGg+qS6qku3J8OzxpK
         mODvlNIjvRof/wfmfHMuxB3Bpha3pPkf4SSEx8DfS9QK+5TFFP9VhIvGLc3upnL4GNzl
         +78ody4y+olE1VotFvRvn94uAfKFuHZEt9UjLZc3H/P0JzrQH1GinVYExBKOywz0n9Po
         H6JzDptcIervypalzZBGedV7J16U9T9NmtBzWLyCkrz1Tc6II05qiBE3tGvd31Qa9USS
         3kQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ULZfPJnXFZifSjfdbhwtJxBX08db8bBGWvZTGfYyVog=;
        b=VaVeZ1VqADWP2CTZO3JwJajQJ+SqRouHr03zsd3KvcgJ0nqIsE0CfUxnfz4A98N2o+
         mgsaPOJGlribUqJtXm6Q8/FupCmQbf34yNB8qziAkr4MClHgue2yR0rquSfAGBd7iC8b
         OjmLysaD86y/dSFkYcHGnbfW5VS4hwGwg7D7Aso5XOuie4bZhyEGf3NKDnoAnx0HpTRA
         uDQYyC5OM1tC7Z5ZH8OZm/mkp90eexfhEWnj6vsvbCmEBMnkjdc51HwWe7ulzWO+RT8M
         JHgYDKB5WXbLCd0nAc+uqTc1QHhTVLLaT7SiSu1/vjSF8K6fJ827tZqU7YLPiS9r2AEY
         J+2Q==
X-Gm-Message-State: AOAM5308Xkp1OYYmvJygvZ8dsPVpzzrbk4qKWS4nZbKB7QW+HVZtRYk3
        OYJjmhQrjzing+aNLQfShtA=
X-Google-Smtp-Source: ABdhPJwng88MdmilLbYrvSx4xD7nBARB1R0iz1j9OQ+rXTBXgSdeicMT0lKSXKhcnPxjODOd9EOq0g==
X-Received: by 2002:a05:6808:301:: with SMTP id i1mr27556536oie.144.1625114490758;
        Wed, 30 Jun 2021 21:41:30 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.38])
        by smtp.googlemail.com with ESMTPSA id o24sm5326459otp.13.2021.06.30.21.41.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Jun 2021 21:41:30 -0700 (PDT)
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
References: <3c0e5c52-4204-ae1e-526a-5f3a5c9738c2@gmail.com>
 <20210701033920.5167-1-rocco.yue@mediatek.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <46a9dbf2-9748-330a-963e-57e615a15440@gmail.com>
Date:   Wed, 30 Jun 2021 22:41:26 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210701033920.5167-1-rocco.yue@mediatek.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/30/21 9:39 PM, Rocco Yue wrote:
> On Wed, 2021-06-30 at 21:03 -0600, David Ahern wrote:
> On 6/30/21 7:59 PM, Rocco Yue wrote:
>>> This patch provides an ipv6 proc file named
>>> "disable_gen_linklocal_addr", its absolute path is as follows:
>>> "/proc/sys/net/ipv6/conf/<iface>/disable_gen_linklocal_addr".
>>>
>>> When the "disable_gen_linklocal_addr" value of a device is 1,
>>> it means that this device does not need the Linux kernel to
>>> automatically generate the ipv6 link-local address no matter
>>> which IN6_ADDR_GEN_MODE is used.
>>>
>>
>> doesn't this duplicate addr_gen_mode == 1 == IN6_ADDR_GEN_MODE_NONE?
>>
> 
> Hi David,
> 
> Thanks for your review.
> 
> This patch is different with IN6_ADDR_GEN_MODE_NONE.
> 
> When the addr_gen_mode == IN6_ADDR_GEN_MODE_NONE, the Linux kernel
> doesn't automatically generate the ipv6 link-local address.
> 

...

> 
> After this patch, when the "disable_gen_linklocal_addr" value of a device
> is 1, no matter in which addr_gen_mode, the Linux kernel will not automatically
> generate an ipv6 link-local for this device.
> 

those 2 sentences are saying the same thing to me.

for your use case, why is setting addr_gen_mode == 1 for the device not
sufficient?

