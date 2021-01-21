Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58AEF2FF0BF
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 17:45:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731936AbhAUQot (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 11:44:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733194AbhAUQj0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 11:39:26 -0500
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0970C061756
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 08:38:43 -0800 (PST)
Received: by mail-oi1-x235.google.com with SMTP id q205so2713769oig.13
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 08:38:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vgJVNcBk/J2Fk5eOL9Xgg6j8k4zlRMwcU+kChAqOVec=;
        b=CqmRrTUd1Yfr2hf7RTFpKP0/fuWiO4yDOaBFuNdz/AVpQcG78QSXI6TCJ0P/36FoO/
         AKMC/FSBYQH+HCR30tI6JdMdqfuedcUaFVyOujDomQ6HoMukpuh0X1rYVzQTEL6nzYSh
         GkAnuExWVIRy30WK+0Pi2YJb0HMyDkdMf27A5Lv/VIeCODGfXAEjOKavsPti5t0QbEu3
         Vau1ygrqlKrfptANJwE9PekrtazQVlwN0xV4xjsFEFX1VPBk3AGQfm1yDRR6hY9PpdAQ
         kwAMjkFtbNOonVpgywVc56RY7qiLrjsiHsdOsaE+je2IxOf3pPIzkyN228AgbLFN5KOb
         v0ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vgJVNcBk/J2Fk5eOL9Xgg6j8k4zlRMwcU+kChAqOVec=;
        b=GRD9WpYBXh6KzHKASCnrgqWLZVLwYqahxJkohvpr7qe1bBtpW6NOJ2J3E9LGamZiVx
         bpCGSLvlT3KX10nOv+y+EeaKPcp05e0nsYDxXEGDP5HeLhye25GI/DLdjNr7FQ9zv/w8
         jzlkqR6X8iabBLMnxpEJn2jqsyaIyRoJfpmQKnRg5K1jaTYLgMENniIy4p8BwiszcbvQ
         /kSRSLWdk0V4fCvVhORp8KMn4fZ8CgPOX9RBHefTiJmMyvhYzn5Hprw7+FRFdVfJzRws
         lNHrhjJ7bQLRd929o5kdCH2pBLw9S8mn6x5Iw+N76ayJa+qiAKp/bjvBhKvFoMVYvSR5
         lmlQ==
X-Gm-Message-State: AOAM533Wh+RXIQx39YR6uLHn6UOew+I32lFYnBrluadgGll4riOpxvFw
        K9YZb4ueryaRcYELxQnPfTo=
X-Google-Smtp-Source: ABdhPJyH2VGRtIp//DNPTAyzDHXeKdsAp24fg8H82wWDbEDvDEQup2f2eTICBNYCRj1HvtglFjcZOg==
X-Received: by 2002:a05:6808:69a:: with SMTP id k26mr265418oig.115.1611247123140;
        Thu, 21 Jan 2021 08:38:43 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.50])
        by smtp.googlemail.com with ESMTPSA id e205sm1130564oia.16.2021.01.21.08.38.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Jan 2021 08:38:42 -0800 (PST)
Subject: Re: [patch net-next RFC 00/10] introduce line card support for
 modular switch
To:     Jiri Pirko <jiri@resnulli.us>, Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        davem@davemloft.net, jacob.e.keller@intel.com, roopa@nvidia.com,
        mlxsw@nvidia.com
References: <20210113121222.733517-1-jiri@resnulli.us>
 <X/+nVtRrC2lconET@lunn.ch> <20210119115610.GZ3565223@nanopsycho.orion>
 <YAbyBbEE7lbhpFkw@lunn.ch> <20210120083605.GB3565223@nanopsycho.orion>
 <YAg2ngUQIty8U36l@lunn.ch>
 <20210120154158.206b8752@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210121153224.GE3565223@nanopsycho.orion>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <971e9eff-0b71-8ff9-d72c-aebe73cab599@gmail.com>
Date:   Thu, 21 Jan 2021 09:38:40 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210121153224.GE3565223@nanopsycho.orion>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/21/21 8:32 AM, Jiri Pirko wrote:
> Thu, Jan 21, 2021 at 12:41:58AM CET, kuba@kernel.org wrote:
>> On Wed, 20 Jan 2021 14:56:46 +0100 Andrew Lunn wrote:
>>>> No, the FW does not know. The ASIC is not physically able to get the
>>>> linecard type. Yes, it is odd, I agree. The linecard type is known to
>>>> the driver which operates on i2c. This driver takes care of power
>>>> management of the linecard, among other tasks.  
>>>
>>> So what does activated actually mean for your hardware? It seems to
>>> mean something like: Some random card has been plugged in, we have no
>>> idea what, but it has power, and we have enabled the MACs as
>>> provisioned, which if you are lucky might match the hardware?
>>>
>>> The foundations of this feature seems dubious.
>>
>> But Jiri also says "The linecard type is known to the driver which
>> operates on i2c." which sounds like there is some i2c driver (in user
>> space?) which talks to the card and _does_ have the info? Maybe I'm
>> misreading it. What's the i2c driver?
> 
> That is Vadim's i2c kernel driver, this is going to upstream.
> 

This pre-provisioning concept makes a fragile design to work around h/w
shortcomings. You really need a way for the management card to know
exactly what was plugged in to a slot so the control plane S/W can
respond accordingly. Surely there is a way for processes on the LC to
communicate with a process on the management card - even if it is inband
packets with special headers.
