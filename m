Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDEB42FFDE1
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 09:07:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbhAVIG5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 03:06:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726777AbhAVIGm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 03:06:42 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A93EC06174A
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 00:05:57 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id u14so3540274wmq.4
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 00:05:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=w8/Ey9yZ3/wVzwhQAFdThnbUgWNmn6yzJJ4qmJw/2fE=;
        b=l5E54K8nZ70VVUK5/IiICsJH0F19c1VAckv+HLMfnqjLxkvVqOpBbacJY8g0MQpVTf
         MZ//LZC+b1neVK6BiB8pN5CLW51XkfsMa4cxb2QWz3wkBR4kDEfKX3rqusmhxsYB6Wjg
         RXQ9z1IIooh7KRxg6qI92tUa3Sj1U36MtriuzHrnR1qT57ucyClSIqzr7cBeFMILflbu
         iofo4/GF0r1pWU/xd2xIlsLmSxuNnt1BX543z5aoh2WEy3ZAQcrAPEB6r6n8sZpdBqLz
         OFsSYLhbjq+9tK0ahtB/OgNP1c4t2bpJeGeva4G+lM/GmKAlzJuK/VsVDSifdW4/wjax
         OGxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=w8/Ey9yZ3/wVzwhQAFdThnbUgWNmn6yzJJ4qmJw/2fE=;
        b=tCpVy8bTdeKodNtxF5uskbLuDpdXOdB6pD9U/Qm6pg7G0fS5zhGM56VlAh93/Z47Vx
         SM8TBkoSAz/63xfia3V7Pji5FKwArk6raA2UEnoDFZPHmNju+8PXiuklMKmhbLEmDBRy
         xzz52wQmDXqGCXpKch68LiIFKGbuurRAyzyX/YIB9ZEMoXvV0Mfgvfu1SGWu2SQhhsiw
         pGgBFeF/PSR08jcrZIieGAW0Vb474KKeO32E+koxMdZh5q8aC9fzIByhO72jgvwpvhfk
         Q4wI5yIZjYkLUj+FPOeSKOvUTEE6riDh8C6h1Dwkddol0X2Au5Ec37W3AAQRxy9nX8pw
         OVKw==
X-Gm-Message-State: AOAM530MxP1KiemiWAgpFKJFSydP6Jimnb969ws3SNd4b9rr4vvj8QgD
        AJuaaTgY4aY4xOUZLGpigUIc9A==
X-Google-Smtp-Source: ABdhPJzJwDv+M2KRHTkNMPPG1a3loELuc8L3fw8dPsbNvPPrPaf82OJbai3gl5yMTPl+NnAs7giwgQ==
X-Received: by 2002:a1c:9a4d:: with SMTP id c74mr2667236wme.73.1611302756311;
        Fri, 22 Jan 2021 00:05:56 -0800 (PST)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id g132sm11225352wmg.2.2021.01.22.00.05.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jan 2021 00:05:55 -0800 (PST)
Date:   Fri, 22 Jan 2021 09:05:55 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     David Ahern <dsahern@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        netdev@vger.kernel.org, davem@davemloft.net,
        jacob.e.keller@intel.com, roopa@nvidia.com, mlxsw@nvidia.com
Subject: Re: [patch net-next RFC 00/10] introduce line card support for
 modular switch
Message-ID: <20210122080555.GI3565223@nanopsycho.orion>
References: <20210113121222.733517-1-jiri@resnulli.us>
 <X/+nVtRrC2lconET@lunn.ch>
 <20210119115610.GZ3565223@nanopsycho.orion>
 <YAbyBbEE7lbhpFkw@lunn.ch>
 <20210120083605.GB3565223@nanopsycho.orion>
 <YAg2ngUQIty8U36l@lunn.ch>
 <20210120154158.206b8752@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210121153224.GE3565223@nanopsycho.orion>
 <971e9eff-0b71-8ff9-d72c-aebe73cab599@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <971e9eff-0b71-8ff9-d72c-aebe73cab599@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jan 21, 2021 at 05:38:40PM CET, dsahern@gmail.com wrote:
>On 1/21/21 8:32 AM, Jiri Pirko wrote:
>> Thu, Jan 21, 2021 at 12:41:58AM CET, kuba@kernel.org wrote:
>>> On Wed, 20 Jan 2021 14:56:46 +0100 Andrew Lunn wrote:
>>>>> No, the FW does not know. The ASIC is not physically able to get the
>>>>> linecard type. Yes, it is odd, I agree. The linecard type is known to
>>>>> the driver which operates on i2c. This driver takes care of power
>>>>> management of the linecard, among other tasks.  
>>>>
>>>> So what does activated actually mean for your hardware? It seems to
>>>> mean something like: Some random card has been plugged in, we have no
>>>> idea what, but it has power, and we have enabled the MACs as
>>>> provisioned, which if you are lucky might match the hardware?
>>>>
>>>> The foundations of this feature seems dubious.
>>>
>>> But Jiri also says "The linecard type is known to the driver which
>>> operates on i2c." which sounds like there is some i2c driver (in user
>>> space?) which talks to the card and _does_ have the info? Maybe I'm
>>> misreading it. What's the i2c driver?
>> 
>> That is Vadim's i2c kernel driver, this is going to upstream.
>> 
>
>This pre-provisioning concept makes a fragile design to work around h/w
>shortcomings. You really need a way for the management card to know

Not really. As I replied to you in the other part of this thread, the
linecard is basically very similar to a splitter cable. In a way, it is
a splitter cable. And should be threated in a similar way. As a phy. Not
as a device. Cables are replaceble without netdevice reappearing. This
linecards are the same. Therefore, the concept of provisioning makes
sense for them, as it does for splitter cable.


>exactly what was plugged in to a slot so the control plane S/W can
>respond accordingly. Surely there is a way for processes on the LC to
>communicate with a process on the management card - even if it is inband
>packets with special headers.

If a device is capable of splitter cable/linecard hotplug, sure, that
may be implemented. But the user has to configure it as such, to be
aware that "cable change" may move netdevices around.
