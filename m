Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3C0948DFD7
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 22:47:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234970AbiAMVra (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 16:47:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233007AbiAMVra (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 16:47:30 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 078BDC061574
        for <netdev@vger.kernel.org>; Thu, 13 Jan 2022 13:47:30 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id n11so9587259plf.4
        for <netdev@vger.kernel.org>; Thu, 13 Jan 2022 13:47:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=HDYpnlJUFuh1Xb6RBo/I4dPqx04d7z0N4jFRSqr8hwo=;
        b=kKSif9A3x+7zl0vvtV/ZCz0zqRui9d6+BbeI1PHmUG5yy/GeN1EJcyKapOB0sfipn4
         3wsiCOKqILlpe60mbMs0W9oR4AydTu43TwtlORP4MED7VIF/tEgeHdU3bk4u0QSeHtpT
         q5LYMwGeQrs0rAFSvgkvmCGNUa0RhszYhTvnCBugPwu/2bGx07A4BS7OmcivYuglDYVL
         0UqMzPgJd4bmFdy6JduiRFiIJSN2MoJG6bFQJRDL36XuTGZ3kQjwy1xeoMJ9LH1RJW6e
         +YwA2lcyyaWfHWs7hi7Tw/cnbkxAQZqbZs+z1wSXTCG8b9phUvocW5zceTBAPsllVuI3
         fk1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=HDYpnlJUFuh1Xb6RBo/I4dPqx04d7z0N4jFRSqr8hwo=;
        b=WRuzHIFqU7Y0NBAeMSTTDNjm/rCL8NbRaIaz8FMIrm22mC1APFv8UbnKfp584nAehk
         jKKBf3m/5dYdZfCQFx0IbqKboXVLr11mPJrsKcXWGuK+gNkkSoktFx2x00SKdXdCBDHO
         43VIOKebPmxFltzCQOPIv2KSyihnAHPJHqnEZJKXC7tV94F8RHMxx4dFwjUQK6T8W7v3
         c/bV1lS+rprAV3iGJI3RihXdS9Mp6NXwWsuRSnZqOyMjvvl0YU/ZUSFq8lt4wx8KL9GV
         o/6dFMheFutP6OIOyjrsGqdzWlQwq62jrTuTCtYabkVbfaxyacfz8S4iWhZGdeswEkmm
         FPIA==
X-Gm-Message-State: AOAM533DvIrQNA43ubXi+e4LGP1/5yIhibIgLkhdP9Et4sxB0QLEoOAZ
        YNqdjNLuoPLrlGUyfev5Q0Y=
X-Google-Smtp-Source: ABdhPJwh7UsfFI3R5y2fNtzLs2whJk73DBLF2TH4TYAfBLB1Wpndy2h+8/8Rf5oe83QU5FjgqyvUyA==
X-Received: by 2002:a17:90b:38c1:: with SMTP id nn1mr7296941pjb.65.1642110449498;
        Thu, 13 Jan 2022 13:47:29 -0800 (PST)
Received: from ?IPV6:2600:8802:b00:4a48:c1d3:c1c0:b78e:9e36? ([2600:8802:b00:4a48:c1d3:c1c0:b78e:9e36])
        by smtp.gmail.com with ESMTPSA id t25sm3044305pgv.9.2022.01.13.13.47.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Jan 2022 13:47:28 -0800 (PST)
Message-ID: <3314e6cf-0ef5-1684-12a8-52410ce897f2@gmail.com>
Date:   Thu, 13 Jan 2022 13:47:27 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH] bcmgenet: add WOL IRQ check
Content-Language: en-US
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>, Sergey Shtylyov <s.shtylyov@omp.ru>
Cc:     Doug Berger <opendmb@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com
References: <2b49e965-850c-9f71-cd54-6ca9b7571cc3@omp.ru>
 <YeCS6Ld93zCK6aWh@lunn.ch> <184f55fb-c73b-989b-973e-e9562f511116@gmail.com>
In-Reply-To: <184f55fb-c73b-989b-973e-e9562f511116@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/13/2022 1:37 PM, Florian Fainelli wrote:
> 
> 
> On 1/13/2022 1:00 PM, Andrew Lunn wrote:
>> On Thu, Jan 13, 2022 at 10:46:07PM +0300, Sergey Shtylyov wrote:
>>> The driver neglects to check the result of platform_get_irq_optional()'s
>>> call and blithely passes the negative error codes to devm_request_irq()
>>> (which takes *unsigned* IRQ #), causing it to fail with -EINVAL.
>>> Stop calling devm_request_irq() with the invalid IRQ #s.
>>>
>>> Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
>>>
>>> ---
>>> This patch is against DaveM's 'net.git' repo.
>>
>> Since this is for net, it needs a Fixes: tag.
>>
>> Fixes: 8562056f267d ("net: bcmgenet: request Wake-on-LAN interrupt")
> 
> I don't have strong objections whether we want to consider this a bug 
> fix or not, but since the code only acts upon devm_request_irq() 
> returning 0 meaning success, this seems more like an improvement rather 
> than fixing an actual issue.

If you do repost, please subject your patch with "net: bcmgenet" for 
consistency with previous commits done to that file, and feel free to add:

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
