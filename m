Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BB772129E9
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 18:43:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726724AbgGBQnu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 12:43:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726140AbgGBQnu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 12:43:50 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBD37C08C5C1;
        Thu,  2 Jul 2020 09:43:49 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id b6so29286436wrs.11;
        Thu, 02 Jul 2020 09:43:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mVvrzT69sPx+FSAmQUk8XmkOHty6XEaiuNJ0f0jrwM4=;
        b=IHRlxDmyjPsclh0OA124VbwKZqP9sEDMZ6Q3DB8U9cy/6EMYt8b4yFHnCEqkXvUVNy
         2x+kD8tlx7KrDqE8vnopsQhtLNaxmx6tU0x/4kBPO0zXkGbXK7vgLL0h+8KmbPKFPiEX
         H8yaJZd1o2iSirX5xQ6bpve2XGQLb+E9CBLN3JUOeCIWtxQORRzK7w+wZlJnq0KyWqlP
         dYA92Qfvxf0Z5pavWZ7SjBu36DVd/LHi5CEcuHgDCJeb3yVChG3VpwbAlDSs5JUdyix1
         AF9ZfX4R+g6evdE8qRfa3N859EBKED/NIq1JPmn2IMbEU00DwroMgh5xvFGx6a098LNE
         Xn+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mVvrzT69sPx+FSAmQUk8XmkOHty6XEaiuNJ0f0jrwM4=;
        b=azishzSsFGAK4JQdAu5AEZp5P7FExjXiKWmvO1iDhOj6X9D8iFltNf5DnoOGKmH3T4
         P/AUOW0vQnXFu0X8DKKFZ7+kxFxir1L7GOcj//zy3791BBUCAq4xsbUrnaCkoGHvQhUa
         Wzjqk3jg4RoyEqcy6H03feGQBPCW4RSCfTcrq70FD7xiw7TiWNYW+ewjb48aQooBwI5r
         0aVLm9Qo97eWZsSn1WGI8Rmi2yIwsmBH4AVOsaaLqrNzse9pXAoZqiyAyDGcDJQFYPWj
         IVN/kDUam+dQTqXM4vXcmEuHxRJH/TAymx7YS1K2ELm8xh5284vGe52Z/9rZ38deJlsB
         ezOA==
X-Gm-Message-State: AOAM53043Ctu5hehJqxspzRzY7xJLn4xp/SIQdFbV/LuYmR8i7ARK3gT
        XhK80SFHtRExT5FyLfiWfcyfIp/J
X-Google-Smtp-Source: ABdhPJwmmdwPpUiA4P0T3jwUOKiUkxW9JiBulft1eV8T6xeji3M4mr6nQOOQQmBMRC8+5GzQpSKehg==
X-Received: by 2002:adf:b312:: with SMTP id j18mr30476393wrd.195.1593708228114;
        Thu, 02 Jul 2020 09:43:48 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id d63sm11692366wmc.22.2020.07.02.09.43.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Jul 2020 09:43:47 -0700 (PDT)
Subject: Re: [PATCH net-next 0/4] net: ethtool: Untangle PHYLIB dependency
To:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>
Cc:     Michal Kubecek <mkubecek@suse.cz>, netdev@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        open list <linux-kernel@vger.kernel.org>
References: <20200702042942.76674-1-f.fainelli@gmail.com>
 <20200702155652.ivokudjptoect6ch@lion.mk-sys.cz>
 <20200702163424.GG752507@lunn.ch>
 <20200702093545.5ee3371a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <47965786-9a12-6f09-cf23-1d342334fbc0@gmail.com>
Date:   Thu, 2 Jul 2020 09:43:45 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200702093545.5ee3371a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/2/2020 9:35 AM, Jakub Kicinski wrote:
> On Thu, 2 Jul 2020 18:34:24 +0200 Andrew Lunn wrote:
>> On Thu, Jul 02, 2020 at 05:56:52PM +0200, Michal Kubecek wrote:
>>> On Wed, Jul 01, 2020 at 09:29:38PM -0700, Florian Fainelli wrote:  
>>>> Hi all,
>>>>
>>>> This patch series untangles the ethtool netlink dependency with PHYLIB
>>>> which exists because the cable test feature calls directly into PHY
>>>> library functions. The approach taken here is to utilize a new set of
>>>> net_device_ops function pointers which are automatically set to the PHY
>>>> library variants when a network device driver attaches to a PHY device.  
>>>
>>> I'm not sure about the idea of creating a copy of netdev_ops for each
>>> device using phylib. First, there would be some overhead (just checked
>>> my 5.8-rc3 kernel, struct netdev_ops is 632 bytes). Second, there is
>>> quite frequent pattern of comparing dev->netdev_ops against known
>>> constants to check if a network device is of certain type; I can't say
>>> for sure if it is also used with devices using phylib in existing code
>>> but it feels risky.  
>>
>> I agree with Michal here. I don't like this.
>>
>> I think we need phylib to register a set of ops with ethtool when it
>> loads. It would also allow us to clean up phy_ethtool_get_strings(),
>> phy_ethtool_get_sset_count(), phy_ethtool_get_stats().
> 
> +1

OK, that makes sense, I will work on that.
-- 
Florian
