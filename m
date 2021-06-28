Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A20C3B57D6
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 05:29:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232042AbhF1Dbt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Jun 2021 23:31:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231678AbhF1Dbt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Jun 2021 23:31:49 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5998AC061574
        for <netdev@vger.kernel.org>; Sun, 27 Jun 2021 20:29:24 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id d12so5256391pfj.2
        for <netdev@vger.kernel.org>; Sun, 27 Jun 2021 20:29:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=934vcY9hbIVSaHD+0ugO70/hPHjLe40xLmd0lmTxwZk=;
        b=s6YtIcWZUYoyqq7N8lLbitHjyXtyEiz8cN0sEmKtSNS3VLV+C+3PtOZLFf71WevXbz
         wnzjm+1a3xAGuizk+mo7ro3MHcq2xw9DL+8bBejQBWTuR/x24/kSKRHUMkqZOTgMF33T
         1cinQGSD7F580qh/5Oxmbidb46CSWAjI8/yEjvgZqOT5/HLYnYW04T3oiHOXmj8PaNGW
         Ssbjnl2ToiZ7QVEVXEI16CPlEfzGJKfFCVn24humgLT4E7TODEzlxInbTHvuRlOdDpAk
         VRoAEi3JkKalE0/KihwxRA64xhwG03y4uX8QFfC9MpVC0BApRc1poGEFmPJ1T11k0RTt
         tGaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=934vcY9hbIVSaHD+0ugO70/hPHjLe40xLmd0lmTxwZk=;
        b=joIoFU+2n9DPzR9COJ5v9wGwTR6wqhe8grSZIZyR76iBJ6TSroprkbYayeLazTHNJw
         VvGzVvKYQu6jLDPbUCHSoqSQ55WADTTaKFvpIpVnmFNwD/jztEzRVt9fq29VeWonUKbD
         TDvZIQjrWghaGirhPsH5y+EggSYE5AuksFC5lbMkwCV4O5G8PXK4pIlZGChLk1JeVr1t
         H3ziA4IJ1Kb/z9SRDGW7rJA+ibm4K+Af+wuNghXLfvr3XzF/OmkAw3eyjiK+BYXaJWvr
         g7J0w38pCBfQbVTtWS0GlpyiKgTRFwQJYd+zXrilEjJyJISuyA6DamWa4bWFa/bUeE8V
         a+fA==
X-Gm-Message-State: AOAM530tDN4ANw08l+BGE8NNeRq0KRXAffCvDz99bEDNuh5pa261bbSL
        64gBzS4Zc/r6iwP4hbKYi7U=
X-Google-Smtp-Source: ABdhPJywidgeRTHO3f2be4yMbZFtPovfzR+XuHY1xL1x0k1CHmKIwpJgXsyMMq4jnJE+4mqr97VT7A==
X-Received: by 2002:a62:e90f:0:b029:307:8154:9ff7 with SMTP id j15-20020a62e90f0000b029030781549ff7mr22589524pfh.79.1624850963742;
        Sun, 27 Jun 2021 20:29:23 -0700 (PDT)
Received: from [192.168.1.121] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id y7sm18538233pja.8.2021.06.27.20.29.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 27 Jun 2021 20:29:22 -0700 (PDT)
Subject: Re: PHY vs. MAC ethtool Wake-on-LAN selection
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Linux Netdev List <netdev@vger.kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        Heiner Kallweit <hkallweit1@gmail.com>
References: <554fea3f-ba7c-b2fc-5ee6-755015f6dfba@gmail.com>
 <YNiwJTgEZjRG7bha@lunn.ch> <20210627190913.GA22278@shell.armlinux.org.uk>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <b6e99d7b-2cb7-c892-3bd2-fa545ae9056b@gmail.com>
Date:   Sun, 27 Jun 2021 20:29:20 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210627190913.GA22278@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/27/2021 12:09 PM, Russell King (Oracle) wrote:
> On Sun, Jun 27, 2021 at 07:06:45PM +0200, Andrew Lunn wrote:
>>> - Ethernet MAC (bcmgenet) is capable of doing Wake-on-LAN using Magic
>>> Packets (g) with password (s) or network filters (f) and is powered on in
>>> the "standby" (as written in /sys/power/state) suspend state, and completely
>>> powered off (by hardware) in the "mem" state
>>>
>>> - Ethernet PHY (broadcom.c, no code there to support WoL yet) is capable of
>>> doing Wake-on-LAN using Magic Packets (g) with password (s) or a 48-bit MAC
>>> destination address (f) match allowing us to match on say, Broadcom and
>>> Multicast. That PHY is on during both the "standby" and "mem" suspend states
>>
>> Marvell systems are similar. The mvneta hardware has support for WOL,
>> and has quite a capable filter. But there is no driver support. WOL is
>> simply forwarded to the PHY.
>>
>>> What I envision we could do is add a ETHTOOL_A_WOL_DEVICE u8 field and have
>>> it take the values: 0 (default), 1 (MAC), 2 (PHY), 3 (both) and you would do
>>> the following on the command line:
>>>
>>> ethtool -s eth0 wol g # default/existing mode, leave it to the driver
>>> ethtool -s eth0 wol g target mac # target the MAC only
>>> ethtool -s eth0 wol g target phy # target the PHY only
>>> ethtool -s eth0 wol g target mac+phy # target both MAC and PHY
>>
>> This API seems like a start, but is it going to be limiting? It does
>> not appear you can say:
>>
>> ethtool -s eth0 wol g target phy wol f target mac
>>
>> So make use of magic packet in the PHY and filtering in the MAC.
>> ETHTOOL_A_WOL_DEVICE u8 appears to apply to all WoL options, not one
>> u8 per option.
>>
>> And does mac+phy mean both will generate an interrupt? I'm assuming
>> the default of 0 means do whatever undefined behaviour we have now. Do
>> we need another value, 4 (auto) and the MAC driver will first try to
>> offload to the PHY, and if that fails, it does it at the MAC, with the
>> potential for some options to be in the MAC and some in the PHY?
> 
> Another question concerns the capabilities of the MAC and PHY in each
> low power mode. Consider that userspace wishes to program the system
> to wakeup when a certain packet is received. How does it know whether
> it needs to program that into the MAC or the PHY or both?

There is no way right now to know other than just having user-space be 
customized to the desired platform which is something that works 
reasonably well for Android, not so much for other distros.

> 
> Should that level of detail be available to userspace, or kept within
> the driver?
> 
> For example, if userspace requests destination MAC address wakeup, then
> shouldn't the driver be making the decision about which of the MAC or
> PHY gets programmed to cause the wakeup depending on which mode the
> system will be switching to and whether the appropriate blocks can be
> left powered?
> 
> Another question would be - if the PHY can only do magic packet and
> remains powered, and the MAC can only do destination MAC but is powered
> down in the "mem" state, what do we advertise to the user. If the user
> selects destination MAC and then requests the system enter "mem" state,
> then what? Should we try to do the best we can?

This is the part where it may be reasonable to lean on to user-space to 
program either the MAC or the PHY in a way that makes sense to support a 
Wake-on-LAN scheme, whether that means that ethtool should also report 
which modes are supported depending on the target system suspend such 
that user-space has information to make an appropriate decision may just 
be the next step.

> 
> Should we at the very least be advertising which WOL modes are
> supported in each power state?

It would make sense to do that, I do wonder if the reporting may be more 
complicated in case there are device-specific power domains that we need 
to be aware of, instead of just a report per PM_SUSPEND_* mode defined 
in include/linux/suspend.h.
-- 
Florian
