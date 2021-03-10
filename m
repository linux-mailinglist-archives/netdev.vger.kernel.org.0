Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5202B334BF1
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 23:51:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbhCJWvG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 17:51:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230499AbhCJWux (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 17:50:53 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4824FC061574;
        Wed, 10 Mar 2021 14:50:53 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id t37so1583888pga.11;
        Wed, 10 Mar 2021 14:50:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1ODlB+wNAjJfOqOwgdUqm3qy/TaXtDcdVcL1QIyUcxw=;
        b=L1NB2n+s2nV0b/NkmKm3lGAQTJruIQVn0bGrmwxfpZZlWgrYm1PofJ5Ma99HXP9wfn
         hRiYyge7WWvk6rT2ZHDjidzXetOszj9Hm99Bu1WJDCo/CuUwjS85dhUizp8L4221GHo0
         5fPo8cHY0F27HrwH63UDVY0HchmFGGTUsPtuYazP+CPE7G8078JQlybQas4hj7NoBfxa
         AENw6h3Y5fQgngI93+hZadxZtEwRCgweUks44nPumeRW1QI/Lg1A69LUISdeXGKOPOJ4
         BikE/4L0dUHr7IOocLF70YhhrHk95Rc/Ik2tAbODGCtmQEkiEFtb9MzzE/051BToqqdZ
         t1Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1ODlB+wNAjJfOqOwgdUqm3qy/TaXtDcdVcL1QIyUcxw=;
        b=igxJQ6hvBTDDTFHss38XRq1XCmvVYeF8sEFoanyrmA9N/CWtEBt6NV2E/Z1NmqXMz4
         vLNa3qlq5dm1KzZVp15l2C9pVuMgZYixJe+hEnTCMN9Jq6paqpHsaDSTqen4D7E/3EZd
         s1mH+Aiimdqpx4BGlYApWqMexUHLI/xJMLKHrIsP0aWnKmDZTSQtvGlLJ1cQyZfNNY1/
         nWsAV7cl2nRM3/SGbNPQRe8NwvtFMxd9Xqxi1LP7PE+0ZHQYsGbC9avIaUIIfAEbJb++
         rxw4/jfp/PA/WzOyTk+ht9lQBp3q+OIq0gt/QojItoH9iNSTEnksLt+X+NcxaRUed8cJ
         KRNQ==
X-Gm-Message-State: AOAM531GA0e37aHxf6k1XLwDtTNc6MsG7KhnzZ8CBozuOh1+ouIIga1x
        XUG0aP+lANofkkUmUA79zjX90X7qJCI=
X-Google-Smtp-Source: ABdhPJxnd3LSSyf97w+mWaV2VLRCEK98LA0F//Khv28j0B+eeZ/FQoWk2r2+EodGgDIjSSqrfGNKNg==
X-Received: by 2002:aa7:8a19:0:b029:1f6:6839:7211 with SMTP id m25-20020aa78a190000b02901f668397211mr4666246pfa.40.1615416652204;
        Wed, 10 Mar 2021 14:50:52 -0800 (PST)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id a22sm476947pgw.52.2021.03.10.14.50.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Mar 2021 14:50:51 -0800 (PST)
Subject: Re: [PATCH net-next] net: phy: Expose phydev::dev_flags through sysfs
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        open list <linux-kernel@vger.kernel.org>
References: <20210310221244.2968469-1-f.fainelli@gmail.com>
 <20210310144848.53ffbbd9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <ca946873-3872-dbc2-3331-d388782bd17e@gmail.com>
Date:   Wed, 10 Mar 2021 14:50:50 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210310144848.53ffbbd9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/10/21 2:48 PM, Jakub Kicinski wrote:
> On Wed, 10 Mar 2021 14:12:43 -0800 Florian Fainelli wrote:
>> phydev::dev_flags contains a bitmask of configuration bits requested by
>> the consumer of a PHY device (Ethernet MAC or switch) towards the PHY
>> driver. Since these flags are often used for requesting LED or other
>> type of configuration being able to quickly audit them without
>> instrumenting the kernel is useful.
>>
>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>> ---
>>  Documentation/ABI/testing/sysfs-class-net-phydev | 12 ++++++++++++
>>  drivers/net/phy/phy_device.c                     | 11 +++++++++++
>>  2 files changed, 23 insertions(+)
>>
>> diff --git a/Documentation/ABI/testing/sysfs-class-net-phydev b/Documentation/ABI/testing/sysfs-class-net-phydev
>> index 40ced0ea4316..ac722dd5e694 100644
>> --- a/Documentation/ABI/testing/sysfs-class-net-phydev
>> +++ b/Documentation/ABI/testing/sysfs-class-net-phydev
>> @@ -51,3 +51,15 @@ Description:
>>  		Boolean value indicating whether the PHY device is used in
>>  		standalone mode, without a net_device associated, by PHYLINK.
>>  		Attribute created only when this is the case.
>> +
>> +What:		/sys/class/mdio_bus/<bus>/<device>/phy_dev_flags
>> +Date:		March 2021
>> +KernelVersion:	5.13
>> +Contact:	netdev@vger.kernel.org
>> +Description:
>> +		32-bit hexadecimal number representing a bit mask of the
>> +		configuration bits passed from the consumer of the PHY
>> +		(Ethernet MAC, switch, etc.) to the PHY driver. The flags are
>> +		only used internally by the kernel and their placement are
>> +		not meant to be stable across kernel versions. This is intended
>> +		for facilitating the debugging of PHY drivers.
> 
> Why not debugfs, then?
> 

Mostly for consistency with what we already have exposed, I suppose that
could be moved to debugfs.

-- 
Florian
