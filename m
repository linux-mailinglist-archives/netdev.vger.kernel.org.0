Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0981C283BB8
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 17:54:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728769AbgJEPyr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 11:54:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726567AbgJEPyq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 11:54:46 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB26AC0613CE;
        Mon,  5 Oct 2020 08:54:45 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id l17so9899731edq.12;
        Mon, 05 Oct 2020 08:54:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kJUYQg9do517Kl7d8/QwB4WfffayVPdh5PAj2PKgIkE=;
        b=i0+0frjSJ+JmX5SMN8jJ/t72l064H3Ogi5DlU6Xfgu3qJMxPSUfRzLdxShta3MD9+l
         1/I+0tcD642G6cVjj8Tn16IUUVDWLIEHXB2/VLaO9/iiUGJAtaGDwfHNzel8jM75+nza
         V4ftO1eKfrePxkmy+iTExztXxfRjZwaDpB5CLxc7Ufteopurx5m34kZgvmynRKHQcX7L
         tOn0silT4VgaUue4rEc5yUMoW0RsjOOt7PThx1ZZkntIUWRPbSohvDNNy2vUmkA93mrs
         BPojQEJ83POkx1DvmSO9DreEWxpc1d3qTEd0gsZs1hlqQdre/srWjsoXc4mflYYR0DWP
         6wAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kJUYQg9do517Kl7d8/QwB4WfffayVPdh5PAj2PKgIkE=;
        b=cLAPxAOMqu58kWeJyjzAW6yM2+KZET3F2OoKKfWj54lQOht+8JszA286uCoSIelS6Q
         UCn0y1xZAnIS1HYMnTAm+E86AQqYi/kefhFW8FgIgt8F7f936kW7FcQH/wop/46JzhE9
         /iAQgbzD1jQwt/wcT8T3c3Tt6G4RqcfjsU9gro9McxITxM9MtWQkR5qPacUyjjbfX7SO
         TN2WrT/XXmpbvHEIOf4K5Ql7ju593wKmVu95jHZDlsuMxn0BeX6gEYHL34Bij2sb6x5I
         YO6Gm8YM2QLAeB1BLtdj1gL9fyVwIcncbdUs6cytW8uqJn3TGeJMVqFYtRjv+ma/bdO+
         Rpbw==
X-Gm-Message-State: AOAM532CGh4U4sHIDF/N3q2Qvh4y7ryturYIEBtNMfUpRRfye2IfJnwg
        ooOppA4Eze80GmcBXJisqGhR/XB6DIYVhg==
X-Google-Smtp-Source: ABdhPJyzPh7AMQzgLdkdzzaYFoD/Ven8Fem1t2IcYsp/FRVvFgmTwMHjk1mFkkSEFv2d7O6X7Akbew==
X-Received: by 2002:a50:c199:: with SMTP id m25mr257706edf.207.1601913284321;
        Mon, 05 Oct 2020 08:54:44 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f00:6a00:100:28fb:418:b614? (p200300ea8f006a00010028fb0418b614.dip0.t-ipconnect.de. [2003:ea:8f00:6a00:100:28fb:418:b614])
        by smtp.googlemail.com with ESMTPSA id q1sm54511ejy.37.2020.10.05.08.54.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Oct 2020 08:54:43 -0700 (PDT)
Subject: Re: [RFC] net: phy: add shutdown hook to struct phy_driver
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Jisheng Zhang <Jisheng.Zhang@synaptics.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200930174419.345cc9b4@xhacker.debian>
 <20200930190911.GU3996795@lunn.ch>
 <bab6c68f-8ed7-26b7-65ed-a65c7210e691@gmail.com>
 <20200930201135.GX3996795@lunn.ch>
 <379683c5-3ce5-15a6-20c4-53a698f0a3d0@gmail.com>
 <20201005165356.7b34906a@xhacker.debian>
 <95121d4a-0a03-0012-a845-3a10aa31f253@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <0d565005-45ad-e85f-bc79-8e9100ceaf6c@gmail.com>
Date:   Mon, 5 Oct 2020 17:54:38 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <95121d4a-0a03-0012-a845-3a10aa31f253@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05.10.2020 17:41, Florian Fainelli wrote:
> 
> 
> On 10/5/2020 1:53 AM, Jisheng Zhang wrote:
>> On Wed, 30 Sep 2020 13:23:29 -0700 Florian Fainelli wrote:
>>
>>
>>>
>>> On 9/30/2020 1:11 PM, Andrew Lunn wrote:
>>>> On Wed, Sep 30, 2020 at 01:07:19PM -0700, Florian Fainelli wrote:
>>>>>
>>>>>
>>>>> On 9/30/2020 12:09 PM, Andrew Lunn wrote:
>>>>>> On Wed, Sep 30, 2020 at 05:47:43PM +0800, Jisheng Zhang wrote:
>>>>>>> Hi,
>>>>>>>
>>>>>>> A GE phy supports pad isolation which can save power in WOL mode. But once the
>>>>>>> isolation is enabled, the MAC can't send/receive pkts to/from the phy because
>>>>>>> the phy is "isolated". To make the PHY work normally, I need to move the
>>>>>>> enabling isolation to suspend hook, so far so good. But the isolation isn't
>>>>>>> enabled in system shutdown case, to support this, I want to add shutdown hook
>>>>>>> to net phy_driver, then also enable the isolation in the shutdown hook. Is
>>>>>>> there any elegant solution?
>>>>>>  
>>>>>>> Or we can break the assumption: ethernet can still send/receive pkts after
>>>>>>> enabling WoL, no?
>>>>>>
>>>>>> That is not an easy assumption to break. The MAC might be doing WOL,
>>>>>> so it needs to be able to receive packets.
>>>>>>
>>>>>> What you might be able to assume is, if this PHY device has had WOL
>>>>>> enabled, it can assume the MAC does not need to send/receive after
>>>>>> suspend. The problem is, phy_suspend() will not call into the driver
>>>>>> is WOL is enabled, so you have no idea when you can isolate the MAC
>>>>>> from the PHY.
>>>>>>
>>>>>> So adding a shutdown in mdio_driver_register() seems reasonable.  But
>>>>>> you need to watch out for ordering. Is the MDIO bus driver still
>>>>>> running?
>>>>>
>>>>> If your Ethernet MAC controller implements a shutdown callback and that
>>>>> callback takes care of unregistering the network device which should also
>>>>> ensure that phy_disconnect() gets called, then your PHY's suspend function
>>>>> will be called.
>>>>
>>>> Hi Florian
>>>>
>>>> I could be missing something here, but:
>>>>
>>>> phy_suspend does not call into the PHY driver if WOL is enabled. So
>>>> Jisheng needs a way to tell the PHY it should isolate itself from the
>>>> MAC, and suspend is not that.
>>>
>>> I missed that part, that's right if WoL is enabled at the PHY level then
>>> the suspend callback is not called, how about we change that and we
>>> always call the PHY's suspend callback? This would require that we audit
>>
>> Hi all,
>>
>> The PHY's suspend callback usually calls genphy_suspend() which will set
>> BMCR_PDOWN bit, this may break WoL. I think this is one the reason why
>> we ignore the phydrv->suspend() when WoL is enabled. If we goes to this
>> directly, it looks like we need to change each phy's suspend implementation,
>> I.E if WoL is enabled, ignore genphy_suspend() and do possible isolation;
>> If WoL is disabled, keep the code path as is.
>>
>> So compared with the shutdown hook, which direction is better?
> 
> I believe you will have an easier time to add an argument to the PHY driver suspend's function to indicate the WoL status, or to move down the check for WoL being enabled/supported compared to adding support for shutdown into the MDIO bus layer, and then PHY drivers.

Maybe the shutdown callback of mdio_bus_type could be implemented.
It could iterate over all PHY's on the bus, check for WoL (similar to
mdio_bus_phy_may_suspend) and do whatever is needed.
Seems to me to be the most generic way.
