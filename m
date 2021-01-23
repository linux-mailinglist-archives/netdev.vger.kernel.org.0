Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0E0F30115C
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 01:06:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbhAWAF1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 19:05:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726960AbhAWACc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 19:02:32 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F870C06174A;
        Fri, 22 Jan 2021 16:01:52 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id n7so4917864pgg.2;
        Fri, 22 Jan 2021 16:01:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=r0zcK5OGmywiWXQCPpHyBJ5jwx8Q3v3tj2k5NoX1R4Q=;
        b=U737ERJNYiWCeT5giCEIOY1SeZ/4Mw/RzSJX0+E6pRRZvMwJV8V+vLwGzKo9mvQbsJ
         QkrhuxfT3OKODEe6eoyfd4FJew1ACBjtrxP/NJPtdzZvidzzVOg2UgBXM1GGmB12rvk1
         aSwWTiYyWJQMD9JP13QWxYPhePUUhp+CoT9BFtkzHk2XnwtEXgvwP15yv4FGjsSqCmRA
         WO31bLDYCWubuzApTfw4q8kRDWAAgX4T78lNMdw8aXGbRvxTyDhZSH3WaT8RVcKBZtSx
         VK2bQKct3ajsQrNSGLvY60/cA0pRv8ZSSZrpX1uTNEctIRBjhteqcI/xvvhLKQsnC18P
         GhgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=r0zcK5OGmywiWXQCPpHyBJ5jwx8Q3v3tj2k5NoX1R4Q=;
        b=OQcuG8qfDkGKzgIp6vLTKAbqD1AKtWyKdi/A/nd5WVy/1j7o9Vu8NIzXIwG2Jahy+w
         yJUYO+HVVGZ+4wPg5P6k+ibi8feUNE0CcEn8BYJ7UVDkqQsxIFJbqVc8aSgf8cGtmz9u
         EVrjnahD7mIPWkFSNl6JM+APvFX8k1+JudeX5NvdHMZEdXPblCGswRaNBnzCe3JWASDJ
         R2R5K+tYxGn0WQan7oYJPx1SlQ4XtHrzrlq9Mxh/kVn5HYme418JUJvT3b0fS9627N8B
         uS6m92d7+dtlBOwi2Dz7j68IloHpnmdKZm517ouSg0CCBv0WXhPUoRmEcKNkrc5/3nib
         f+SA==
X-Gm-Message-State: AOAM533bRfbveL3wLUoZqnwrsbSgKt0b+owkvpKN3HJx3lCFUcOR3ZiQ
        1sRuyUPeKch8azSwj5FKFyBcpHN1pig=
X-Google-Smtp-Source: ABdhPJxfA9Pq32dZsQYHANNjveL0UbSMEAjfsLAaAiTyhuv6PA+IBKth7yRvQCFWe8eSHo0cmbho6Q==
X-Received: by 2002:a63:db03:: with SMTP id e3mr7069054pgg.225.1611360111166;
        Fri, 22 Jan 2021 16:01:51 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a9sm10077912pfn.178.2021.01.22.16.01.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Jan 2021 16:01:50 -0800 (PST)
Subject: Re: [PATCH v2] lan743x: add virtual PHY for PHY-less devices
To:     Sergej Bauer <sbauer@blackbox.su>, Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Simon Horman <simon.horman@netronome.com>,
        Mark Einon <mark.einon@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Masahiro Yamada <masahiroy@kernel.org>,
        linux-kernel@vger.kernel.org
References: <20210122214247.6536-1-sbauer@blackbox.su>
 <21783568.4JFRnjC3Rk@metabook> <YAtebdG1Q0dxxkdC@lunn.ch>
 <3174210.ndmClRx9B8@metabook>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <5306ffe6-112c-83c9-826a-9bacd661691b@gmail.com>
Date:   Fri, 22 Jan 2021 16:01:47 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <3174210.ndmClRx9B8@metabook>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/22/2021 3:58 PM, Sergej Bauer wrote:
> On Saturday, January 23, 2021 2:23:25 AM MSK Andrew Lunn wrote:
>>>>> @@ -1000,8 +1005,10 @@ static void lan743x_phy_close(struct
>>>>> lan743x_adapter *adapter)>
>>>>>
>>>>>  	struct net_device *netdev = adapter->netdev;
>>>>>  	
>>>>>  	phy_stop(netdev->phydev);
>>>>>
>>>>> -	phy_disconnect(netdev->phydev);
>>>>> -	netdev->phydev = NULL;
>>>>> +	if (phy_is_pseudo_fixed_link(netdev->phydev))
>>>>> +		lan743x_virtual_phy_disconnect(netdev->phydev);
>>>>> +	else
>>>>> +		phy_disconnect(netdev->phydev);
>>>>
>>>> phy_disconnect() should work. You might want to call
>>
>> There are drivers which call phy_disconnect() on a fixed_link. e.g.
>>
>> https://elixir.bootlin.com/linux/v5.11-rc4/source/drivers/net/usb/lan78xx.c#
>> L3555.
>>
> 
>> It could be your missing call to fixed_phy_unregister() is leaving
>> behind bad state.
>>
> lan743x_virtual_phy_disconnect removes sysfs-links and calls 
> fixed_phy_unregister()
> and the reason was phydev in sysfs.
> 
>>> It was to make ethtool show full set of supported speeds and MII only in
>>> supported ports (without TP and the no any ports in the bare card).
>>
>> But fixed link does not support the full set of speed. It is fixed. It
>> supports only one speed it is configured with.
> That's why I "re-implemented the fixed PHY driver" as Florian said.
> The goal of virtual phy was to make an illusion of real device working in
> loopback mode. So I could use ethtool and ioctl's to switch speed of device.
> 
>> And by setting it
>> wrongly, you are going to allow the user to do odd things, like use
>> ethtool force the link speed to a speed which is not actually
>> supported.
> I have lan743x only and in loopback mode it allows to use speeds 
> 10/100/1000MBps
> in full-duplex mode only. But the highest speed I have achived was something 
> near
> 752Mbps...
> And I can switch speed on the fly, without reloading the module.
> 
> May by I should limit the list of acceptable devices?

It is not clear what your use case is so maybe start with explaining it
and we can help you define something that may be acceptable for upstream
inclusion.
-- 
Florian
