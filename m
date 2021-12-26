Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54A2D47F685
	for <lists+netdev@lfdr.de>; Sun, 26 Dec 2021 12:16:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233228AbhLZLQA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Dec 2021 06:16:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233212AbhLZLP7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Dec 2021 06:15:59 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05F95C06173E;
        Sun, 26 Dec 2021 03:15:58 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id e5so26472316wrc.5;
        Sun, 26 Dec 2021 03:15:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=TNUa90driadOsbaz0gnSXvAWA8gkmxx+yuNQyfbjQpc=;
        b=ZF1T89SExleYrJ7k2bQ9JQU6dHQx3IL+mXjcKWBpFx7fiTzfqx7DwjnmTE9KGm7pq8
         eMnjackQYUveZ92mzP2+Yv/KDvOxEhEom6EQhDs12upUxM8lzx1Iz5Wx0ALEC8Cg4t1V
         2+LhmX869jiVeGPVCGRTTa8aEoN6O1iIwHzrUv+eLWEEo/4hF4RbD6LiRS1Q7oVH/R0T
         rLXHZuQ9MLD/8AIzOfFOSWBqhAGTbKWDzqdHsc73DMcKdlqoNEggI0kc1KkHVumqEZlq
         7SEv0y/tEiashZWxYjFBmx/knFL2uZhm79iOysEWcsLekJmsc/sRwv2rc5H5tcQaDfBI
         12Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=TNUa90driadOsbaz0gnSXvAWA8gkmxx+yuNQyfbjQpc=;
        b=PSdlzM0/8KTvtPeUOiD9YKwanQ9g2KnRFxHoPzk2Id7ULoXZaneDsHt9FBvEo9S5MB
         yEFQVGeqfWInkF15POFYW6lTxNefvHLXaqy8XDoUhvPWmXuA80U0hbMKtGRO5CHcso6N
         1fbprLbE/PzR9icgzv1oQTdN5jVhIAfwj+GpSZua5Gsu9ddcLWHbMOSko5zhewf/vHrD
         pH9j9pdb4myoloe755hOxCOAJLBCUOwqYSm+AslUbXGeohU18vtq8GsQmiPiJA8WxQvR
         9pl0urKiBNy3Wu+k82m1Jo2yythUTIUgKttEywiMvRZpn7JRpKyePX3Ct0HE/Gc3mwKv
         2wiQ==
X-Gm-Message-State: AOAM531JqtYumKK3W7tDLrxlXl4L4WZKPfG1vo7p05/7h+YlBXDPFpP3
        TzwD/E9re8mzZsSdIT46WMkpGj93ja8=
X-Google-Smtp-Source: ABdhPJyvJHGbdwPW9MoRZu7idPNdBbjVRlVA7U7+uLCqdVwZ8O9IbICgLYhJ7RzBLX+7W1Xh+NilCw==
X-Received: by 2002:a5d:4343:: with SMTP id u3mr9628466wrr.450.1640517357435;
        Sun, 26 Dec 2021 03:15:57 -0800 (PST)
Received: from ?IPV6:2003:ea:8f24:fd00:c9a7:2d21:f9c0:60ee? (p200300ea8f24fd00c9a72d21f9c060ee.dip0.t-ipconnect.de. [2003:ea:8f24:fd00:c9a7:2d21:f9c0:60ee])
        by smtp.googlemail.com with ESMTPSA id w21sm9052706wmi.19.2021.12.26.03.15.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Dec 2021 03:15:56 -0800 (PST)
Message-ID: <bb5a43e5-6036-3788-71ca-c411611e0ad9@gmail.com>
Date:   Sun, 26 Dec 2021 12:14:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH 2/8] net: pxa168_eth: Use platform_get_irq() to get the
 interrupt
Content-Language: en-US
To:     "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20211224192626.15843-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <20211224192626.15843-3-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <CAHp75VcurBNEcMFnAHTg8PTbJOhO7QA4iv1t4W=siC=D-AkHAw@mail.gmail.com>
 <CA+V-a8tuD-WKyRL_kwitqOyxJDMu1J14AtZ12LbSF9+8mj+=FQ@mail.gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
In-Reply-To: <CA+V-a8tuD-WKyRL_kwitqOyxJDMu1J14AtZ12LbSF9+8mj+=FQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25.12.2021 13:19, Lad, Prabhakar wrote:
> Hi Andy,
> 
> Thank you for the review.
> 
> On Sat, Dec 25, 2021 at 11:24 AM Andy Shevchenko
> <andy.shevchenko@gmail.com> wrote:
>>
>>
>>
>> On Friday, December 24, 2021, Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com> wrote:
>>>
>>> platform_get_resource(pdev, IORESOURCE_IRQ, ..) relies on static
>>> allocation of IRQ resources in DT core code, this causes an issue
>>> when using hierarchical interrupt domains using "interrupts" property
>>> in the node as this bypasses the hierarchical setup and messes up the
>>> irq chaining.
>>>
>>> In preparation for removal of static setup of IRQ resource from DT core
>>> code use platform_get_irq().
>>>
>>> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
>>> ---
>>>  drivers/net/ethernet/marvell/pxa168_eth.c | 9 +++++----
>>>  1 file changed, 5 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/drivers/net/ethernet/marvell/pxa168_eth.c b/drivers/net/ethernet/marvell/pxa168_eth.c
>>> index 1d607bc6b59e..52bef50f5a0d 100644
>>> --- a/drivers/net/ethernet/marvell/pxa168_eth.c
>>> +++ b/drivers/net/ethernet/marvell/pxa168_eth.c
>>> @@ -1388,7 +1388,6 @@ static int pxa168_eth_probe(struct platform_device *pdev)
>>>  {
>>>         struct pxa168_eth_private *pep = NULL;
>>>         struct net_device *dev = NULL;
>>> -       struct resource *res;
>>>         struct clk *clk;
>>>         struct device_node *np;
>>>         int err;
>>> @@ -1419,9 +1418,11 @@ static int pxa168_eth_probe(struct platform_device *pdev)
>>>                 goto err_netdev;
>>>         }
>>>
>>> -       res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
>>> -       BUG_ON(!res);
>>> -       dev->irq = res->start;
>>> +       err = platform_get_irq(pdev, 0);
>>> +       if (err == -EPROBE_DEFER)
>>
>>
>>  What about other errors?
>>
> Ouch I missed it...
>>
>>>
>>> +               goto err_netdev;
>>> +       BUG_ON(dev->irq < 0);
>>
>>
>> ??? What is this and how it supposed to work?
>>
> 
.. should have been BUG_ON(dev->irq < 0);

Usage of BUG_ON() is discouraged. Better handle the error w/o stopping
the whole system.

> 
> Cheers,
> Prabhakar
>>>
>>> +       dev->irq = err;
>>>         dev->netdev_ops = &pxa168_eth_netdev_ops;
>>>         dev->watchdog_timeo = 2 * HZ;
>>>         dev->base_addr = 0;
>>> --
>>> 2.17.1
>>>
>>
>>
>> --
>> With Best Regards,
>> Andy Shevchenko
>>
>>

