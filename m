Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 795C4283B75
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 17:42:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728182AbgJEPmY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 11:42:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728471AbgJEPlu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 11:41:50 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F65FC0613A9;
        Mon,  5 Oct 2020 08:41:50 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id n14so7175421pff.6;
        Mon, 05 Oct 2020 08:41:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3I3YPnoyymOLRxx7NqmAJMc0vgFbPicg2EYWrAW4obk=;
        b=Z86Ht0eU1yisE3oMG6SG2tlX4a24PbFvi3SRXqojVHV/MlgAqqG0opJQw8QHEBnZaq
         5NPvb35oXiXytNOMnb1khmoZIP2FBbsn25JA2Q5ns01tZU9MV0ZXV2U51j3TrU2STTs/
         cLLxUGsOiODHfwZ23G5zT/evZ00bEkR+T+Dmr/oNngbLupwUfvSj+6PnD/7RwtV0gEVl
         vBvzj9FH1FqdShEJly26maxRkRpg9sGL9xmIC4Kv4IwUv1eNaCzKvuanSV4ZRU5+GrHx
         qcoqKPHb5iPOefMga6UG9LihesonAxG0yC+hCDkk6savd06QLZCLK4KIoUY3/4Rul+mJ
         td3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3I3YPnoyymOLRxx7NqmAJMc0vgFbPicg2EYWrAW4obk=;
        b=KH6HP+5tLhAHzt4EHqmd2gl2X4+6nvwKnfUMIyUSdyx/nikpal5r9wU1LKZzT2HvKI
         CMZq+bFui4lTMZ6jux9GJpFIrqeFel5oc0hqDuBRyEF5PqwRRq0/CtwI6ppZCDnDJpKR
         Zydgi2yoXUz1WgTDyJvB0kUMwMS+fB0iyfRzrkBDNowCS569HQxTK5MSNA4dilSp7wBO
         8VRTHJvMFJrzWZUywPZ1We2J6NvE/0oCw1oUxIX5rtZcNi6uoBYuzd312nVYeVSnl+kZ
         ghVtj6vGi7t2bYjTkYYKI+2RffxpNB4uUQHkAmboDXe1W4HCTcWUb4QfXAePdIF6O2UZ
         ultA==
X-Gm-Message-State: AOAM532kjU1PwB+pHufZ5/JEGBC+F/FvM0BfuBB33OsTwrC+lssXFj0J
        ulHeskmNngtsZDGsR5Nd2DZsClVW05BV9Q==
X-Google-Smtp-Source: ABdhPJy5bSB5n+nhhY0Q243U1PqqeZp1IL7gLCsqsuIVp/Wnfbn0+HrhKZtuYQo+4oWScknvqLZzUQ==
X-Received: by 2002:a63:474b:: with SMTP id w11mr70023pgk.376.1601912509622;
        Mon, 05 Oct 2020 08:41:49 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id c3sm294407pfo.120.2020.10.05.08.41.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Oct 2020 08:41:46 -0700 (PDT)
To:     Jisheng Zhang <Jisheng.Zhang@synaptics.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200930174419.345cc9b4@xhacker.debian>
 <20200930190911.GU3996795@lunn.ch>
 <bab6c68f-8ed7-26b7-65ed-a65c7210e691@gmail.com>
 <20200930201135.GX3996795@lunn.ch>
 <379683c5-3ce5-15a6-20c4-53a698f0a3d0@gmail.com>
 <20201005165356.7b34906a@xhacker.debian>
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [RFC] net: phy: add shutdown hook to struct phy_driver
Message-ID: <95121d4a-0a03-0012-a845-3a10aa31f253@gmail.com>
Date:   Mon, 5 Oct 2020 08:41:44 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201005165356.7b34906a@xhacker.debian>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/5/2020 1:53 AM, Jisheng Zhang wrote:
> On Wed, 30 Sep 2020 13:23:29 -0700 Florian Fainelli wrote:
> 
> 
>>
>> On 9/30/2020 1:11 PM, Andrew Lunn wrote:
>>> On Wed, Sep 30, 2020 at 01:07:19PM -0700, Florian Fainelli wrote:
>>>>
>>>>
>>>> On 9/30/2020 12:09 PM, Andrew Lunn wrote:
>>>>> On Wed, Sep 30, 2020 at 05:47:43PM +0800, Jisheng Zhang wrote:
>>>>>> Hi,
>>>>>>
>>>>>> A GE phy supports pad isolation which can save power in WOL mode. But once the
>>>>>> isolation is enabled, the MAC can't send/receive pkts to/from the phy because
>>>>>> the phy is "isolated". To make the PHY work normally, I need to move the
>>>>>> enabling isolation to suspend hook, so far so good. But the isolation isn't
>>>>>> enabled in system shutdown case, to support this, I want to add shutdown hook
>>>>>> to net phy_driver, then also enable the isolation in the shutdown hook. Is
>>>>>> there any elegant solution?
>>>>>   
>>>>>> Or we can break the assumption: ethernet can still send/receive pkts after
>>>>>> enabling WoL, no?
>>>>>
>>>>> That is not an easy assumption to break. The MAC might be doing WOL,
>>>>> so it needs to be able to receive packets.
>>>>>
>>>>> What you might be able to assume is, if this PHY device has had WOL
>>>>> enabled, it can assume the MAC does not need to send/receive after
>>>>> suspend. The problem is, phy_suspend() will not call into the driver
>>>>> is WOL is enabled, so you have no idea when you can isolate the MAC
>>>>> from the PHY.
>>>>>
>>>>> So adding a shutdown in mdio_driver_register() seems reasonable.  But
>>>>> you need to watch out for ordering. Is the MDIO bus driver still
>>>>> running?
>>>>
>>>> If your Ethernet MAC controller implements a shutdown callback and that
>>>> callback takes care of unregistering the network device which should also
>>>> ensure that phy_disconnect() gets called, then your PHY's suspend function
>>>> will be called.
>>>
>>> Hi Florian
>>>
>>> I could be missing something here, but:
>>>
>>> phy_suspend does not call into the PHY driver if WOL is enabled. So
>>> Jisheng needs a way to tell the PHY it should isolate itself from the
>>> MAC, and suspend is not that.
>>
>> I missed that part, that's right if WoL is enabled at the PHY level then
>> the suspend callback is not called, how about we change that and we
>> always call the PHY's suspend callback? This would require that we audit
> 
> Hi all,
> 
> The PHY's suspend callback usually calls genphy_suspend() which will set
> BMCR_PDOWN bit, this may break WoL. I think this is one the reason why
> we ignore the phydrv->suspend() when WoL is enabled. If we goes to this
> directly, it looks like we need to change each phy's suspend implementation,
> I.E if WoL is enabled, ignore genphy_suspend() and do possible isolation;
> If WoL is disabled, keep the code path as is.
> 
> So compared with the shutdown hook, which direction is better?

I believe you will have an easier time to add an argument to the PHY 
driver suspend's function to indicate the WoL status, or to move down 
the check for WoL being enabled/supported compared to adding support for 
shutdown into the MDIO bus layer, and then PHY drivers.
-- 
Florian
