Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21E793C1BF4
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 01:22:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbhGHXYv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 19:24:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbhGHXYv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 19:24:51 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92DBDC061574;
        Thu,  8 Jul 2021 16:22:08 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id x21-20020a17090aa395b029016e25313bfcso5027423pjp.2;
        Thu, 08 Jul 2021 16:22:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1F9dKEEJP5rMuVUz8hE/v38l0ggRQbQaXsZHB7Gt43A=;
        b=QR+A/5b5j6EJa6bKuInDO3GhKDoEsSTDTrdSSN1t8SvnPtZXAuSWHKNhV4q5CGmPmH
         Y0bOYL0YWUjEKRRPxQ0F1FINpEXluOtsVShQlQ3kau1ECjhjGybbefut6aKQ9mkLOS/G
         vtqooQNf1y6VBa1O/iNDcZecHaIX/dprjwdQFgTdTYDxjMm3vfFzWwwkqJeEpRPYOwL1
         8/cxe2viy7bb4znbwn7rdO4VDH3Z/Dt40IB0IMfrGSTHtfa4ec9aMdm6xTvuFDbk3cDP
         P70XWlZKStia0oWrsf8QDqYppHCeBaffTw9yxBJBAqR8Ljnf5p4n4M03JOwXNhlkatsd
         vKsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1F9dKEEJP5rMuVUz8hE/v38l0ggRQbQaXsZHB7Gt43A=;
        b=mq6Fra4dQad1cvipHc03dNv8plZOfPNrwUz3eWh5MJh7iPvxXkmYFVUisT1IpYd7kG
         bRZ73fvDTLI4tUFf5ij4A3kT+aYhFejDC8iCKdfDTQtgP+GTA4SslN5PKqYPWRosenPJ
         zFMYGXCFi0YPrs0m3B0KWJHn3Gj/uC5uGQWT9deQYzkQZHPzfDv0xPA2LEtb6gPdnGKv
         WgZa73pdRR7XjTklWqpVZsGwMsynDFIVM//S1h7A6dcdmpyUqS7b91OKHjcOkmHEsqPF
         DgJwFMoq8d5v4b6tALU3gyx+/nKOR3xdDMTdXmmFuoVybtFr+JliKeb9+FSOOX3YV07g
         YmJQ==
X-Gm-Message-State: AOAM532lwNNur+sY2VhBlqzHTtQuDbpBQIIJ4iznGdJ7GrcVNT77i+wZ
        8+BiowW/VzTya27WRdUzFKmrYUMfd2x52A==
X-Google-Smtp-Source: ABdhPJyjESjFMCPgWKYtRqMbUx//a1oD0Jh7tFwr0IzCJXpnAg/lKtNz7EviGNzKI38GfjJY3q3+zA==
X-Received: by 2002:a17:902:a986:b029:129:dcf5:b585 with SMTP id bh6-20020a170902a986b0290129dcf5b585mr4705917plb.30.1625786527768;
        Thu, 08 Jul 2021 16:22:07 -0700 (PDT)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id y32sm3901121pfa.208.2021.07.08.16.22.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Jul 2021 16:22:07 -0700 (PDT)
Subject: Re: [PATCH net] net: phy: reconfigure PHY WOL in resume if WOL option
 still enabled
To:     "Ismail, Mohammad Athari" <mohammad.athari.ismail@intel.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20210708004253.6863-1-mohammad.athari.ismail@intel.com>
 <YOZTmfvVTj9eo+to@lunn.ch> <4e159b98-ec02-33b7-862a-0e35832c3a5f@gmail.com>
 <CO1PR11MB477144A2A055B390825A9FF4D5199@CO1PR11MB4771.namprd11.prod.outlook.com>
 <9871a015-bcfb-0bdb-c481-5e8f2356e5ba@gmail.com>
 <CO1PR11MB47719C284F178753C916519FD5199@CO1PR11MB4771.namprd11.prod.outlook.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <f167de1d-94cc-7465-2e6f-e1e71b66b009@gmail.com>
Date:   Thu, 8 Jul 2021 16:22:00 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CO1PR11MB47719C284F178753C916519FD5199@CO1PR11MB4771.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/8/21 4:20 PM, Ismail, Mohammad Athari wrote:
> 
> 
>> -----Original Message-----
>> From: Florian Fainelli <f.fainelli@gmail.com>
>> Sent: Friday, July 9, 2021 12:42 AM
>> To: Ismail, Mohammad Athari <mohammad.athari.ismail@intel.com>;
>> Andrew Lunn <andrew@lunn.ch>
>> Cc: Heiner Kallweit <hkallweit1@gmail.com>; David S . Miller
>> <davem@davemloft.net>; Russell King <linux@armlinux.org.uk>; Jakub
>> Kicinski <kuba@kernel.org>; netdev@vger.kernel.org; linux-
>> kernel@vger.kernel.org
>> Subject: Re: [PATCH net] net: phy: reconfigure PHY WOL in resume if WOL
>> option still enabled
>>
>> On 7/8/21 3:10 AM, Ismail, Mohammad Athari wrote:
>>>
>>>
>>>> -----Original Message-----
>>>> From: Florian Fainelli <f.fainelli@gmail.com>
>>>> Sent: Thursday, July 8, 2021 10:49 AM
>>>> To: Andrew Lunn <andrew@lunn.ch>; Ismail, Mohammad Athari
>>>> <mohammad.athari.ismail@intel.com>
>>>> Cc: Heiner Kallweit <hkallweit1@gmail.com>; David S . Miller
>>>> <davem@davemloft.net>; Russell King <linux@armlinux.org.uk>; Jakub
>>>> Kicinski <kuba@kernel.org>; netdev@vger.kernel.org;
>>>> linux-kernel@vger.kernel.org
>>>> Subject: Re: [PATCH net] net: phy: reconfigure PHY WOL in resume if
>>>> WOL option still enabled
>>>>
>>>>
>>>>
>>>> On 7/7/2021 6:23 PM, Andrew Lunn wrote:
>>>>> On Thu, Jul 08, 2021 at 08:42:53AM +0800,
>>>> mohammad.athari.ismail@intel.com wrote:
>>>>>> From: Mohammad Athari Bin Ismail
>> <mohammad.athari.ismail@intel.com>
>>>>>>
>>>>>> When the PHY wakes up from suspend through WOL event, there is a
>>>>>> need to reconfigure the WOL if the WOL option still enabled. The
>>>>>> main operation is to clear the WOL event status. So that,
>>>>>> subsequent WOL event can be triggered properly.
>>>>>>
>>>>>> This fix is needed especially for the PHY that operates in PHY_POLL
>>>>>> mode where there is no handler (such as interrupt handler)
>>>>>> available to clear the WOL event status.
>>>>>
>>>>> I still think this architecture is wrong.
>>>>>
>>>>> The interrupt pin is wired to the PMIC. Can the PMIC be modelled as
>>>>> an interrupt controller? That would allow the interrupt to be
>>>>> handled as normal, and would mean you don't need polling, and you
>>>>> don't need this hack.
>>>>
>>>> I have to agree with Andrew here, and if the answer is that you
>>>> cannot model this PMIC as an interrupt controller, cannot the
>>>> config_init() callback of the driver acknowledge then disable the
>>>> interrupts as it normally would if you were cold booting the system?
>>>> This would also allow you to properly account for the PHY having woken-
>> up the system.
>>>
>>> Hi Florian,
>>>
>>> Thank you for the suggestion.
>>> If I understand correctly, you are suggesting to acknowledge and clear the
>> WOL status in config_init() callback function. Am I correct?
>>> If yes, I did try to add a code to clear WOL status in marvell_config_init()
>> function (we are using Marvell Alaska 88E1512). But, I found that, if the
>> platform wake up from S3(mem) or S4(disk), the config_init() callback
>> function is not called. As the result, WOL status not able to be cleared in
>> config_init().
>>>
>>> Please advice if you any suggestion.
>>
>> This is presumably that you are seeing with stmmac along with phylink?
>>
>> During S3 resume you should be going back to the kernel provided re-entry
>> point and resume where we left (warm boot) so
>> mdio_bus_phy_resume() should call phy_init_hw() which calls config_init(),
>> have you traced if that is somehow not happening?
>>
>> During S4 resume (disk), I suppose that you have to involve the boot loader
>> to restore the DRAM image from the storage disk, and so that does
>> effectively look like a quasi cold boot from the kernel? If so, that should still
>> lead to config_init() being called when the PHY is attached, no?
> 
> Hi Florian,
> 
> This what I understand from the code flow.
> 
> With WOL enabled through ethtool, when the system is put into S3 or S4,
> this flag netdev->wol_enabled is set true and cause  mdio_bus_phy_may_suspend()
> to return false. So, the  phydev->suspended_by_mdio_bus remain as 0 when
> exiting from mdio_bus_phy_suspend().
> 
> During wake up from S3 or S4, as phydev->suspended_by_mdio_bus remain as 0/false
> when mdio_bus_phy_resume() is called, it will jump to no_resume skipping
> phy_init_hw() as well as phy_resume().

Ah yes you are right, we just skip resume in that case. OK let me think
about it some more.
-- 
Florian
