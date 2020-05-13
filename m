Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A30C01D0592
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 05:45:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728341AbgEMDph (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 23:45:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726550AbgEMDph (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 23:45:37 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B067C061A0C;
        Tue, 12 May 2020 20:45:35 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id t16so6283362plo.7;
        Tue, 12 May 2020 20:45:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WzZ9PimUcVd5nGTFpvtQ2vT2+fHIwsD6fys2CBMtqq4=;
        b=ZgKEGRwYyPAM8YMf9ajyjrw7aVOG5BqyaVVgGJls6WOuP1ecDTzZz1wKY1UQkFXJ25
         E2JUp4t9a3DDJo9R/o/dqV+X+RkBta3H1Iy7KgmMh6R8hw1Pn8bp9NogQ+yGlb032Jz1
         +iAfAc1LuC8LtE7V3sTUc+op6hrBpFbM20qyW19f0iTNoGAVry34Mks3PqJhIt4EkOh/
         Vyep7czy2BucDM9VQZLc/rtE28T9S7CQ5hpM8fyJVWJApHauPRs5Z6ZX6f9OPV3Fo4T2
         KpD/qwI3ui24CNlrHi/LfncFKO5CEodfx0Vzv7dX8ZFV8HdNvvouHhC+qIVxq3XuKsz2
         5yWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WzZ9PimUcVd5nGTFpvtQ2vT2+fHIwsD6fys2CBMtqq4=;
        b=RYZWl/7EQmG3FwnQuxv+oIhrcFARMxVYODARD6KcZHbsaMQHfOMTMnbsDjmXtGKo4Z
         9nLz+/s/I7Dp+xJo10YYlHGYd996lv6mvqKazP2jDdIlA4BD9HBixhu/BZjVHqClM4uk
         rk1wkZrShlz4e9IgHPmu/7JG/5IXPmtoIQ7UE/BhW7MToIzB6wTZfvCqFJklPTPUmxgR
         A8gza6c6oqiuv5d2wStCXMGwfThJxjQwiVWRvKIRlnVS+XGF7EOIjS2uUPAIuR4pGsnf
         EUFyfcU8lTb8d4YS7VMbx2FTg/f5/EoApiDP3DdZSzwJxxnegv+Yxs/uyrKLEfz1An5Q
         4ipw==
X-Gm-Message-State: AOAM531xY2uYv5Oowh2bNGTlCojp+Xx8gG4Kw/UeLPYZPMJaH0Pmu8A+
        ge9k81ag6sm0IiTuZWhRhEbigbcF
X-Google-Smtp-Source: ABdhPJwxouNOdx/sBkWjAxaxUal/IA3gjfZKyj/T1PfcebnsGNwhDFUzAjVD2f7m2GD2drQWDGwOxA==
X-Received: by 2002:a17:90a:4d4a:: with SMTP id l10mr6664088pjh.0.1589341534480;
        Tue, 12 May 2020 20:45:34 -0700 (PDT)
Received: from [10.230.191.242] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id w73sm490933pfd.113.2020.05.12.20.45.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 May 2020 20:45:33 -0700 (PDT)
Subject: Re: [PATCH net-next 1/4] net: ethernet: validate pause autoneg
 setting
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1589243050-18217-1-git-send-email-opendmb@gmail.com>
 <1589243050-18217-2-git-send-email-opendmb@gmail.com>
 <20200512004714.GD409897@lunn.ch>
 <ae63b295-b6e3-6c34-c69d-9e3e33bf7119@gmail.com>
 <20200512185503.GD1551@shell.armlinux.org.uk>
From:   Doug Berger <opendmb@gmail.com>
Message-ID: <0cf740ed-bd13-89d5-0f36-1e5305210e97@gmail.com>
Date:   Tue, 12 May 2020 20:48:22 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200512185503.GD1551@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/12/2020 11:55 AM, Russell King - ARM Linux admin wrote:
> On Tue, May 12, 2020 at 11:31:39AM -0700, Doug Berger wrote:
>> This was intended as a fix, but I thought it would be better to keep it
>> as part of this set for context and since net-next is currently open.
>>
>> The context is trying to improve the phylib support for offloading
>> ethtool pause configuration and this is something that could be checked
>> in a single location rather than by individual drivers.
>>
>> I included it here to get feedback about its appropriateness as a common
>> behavior. I should have been more explicit about that.
>>
>> Personally, I'm actually not that fond of this change since it can
>> easily be a source of confusion with the ethtool interface because the
>> link autonegotiation and the pause autonegotiation are controlled by
>> different commands.
>>
>> Since the ethtool -A command performs a read/modify/write of pause
>> parameters, you can get strange results like these:
>> # ethtool -s eth0 speed 100 duplex full autoneg off
>> # ethtool -A eth0 tx off
>> Cannot set device pause parameters: Invalid argument
>> #
>> Because, the get read pause autoneg as enabled and only the tx_pause
>> member of the structure was updated.
> 
> This looks like the same argument I've been having with Heiner over
> the EEE interface, except there's a difference here.
> 
> # ethtool -A eth0 autoneg on
> # ethtool -s eth0 autoneg off speed 100 duplex full
> 
> After those two commands, what is the state of pause mode?  The answer
> is, it's disabled.
> 
> # ethtool -A eth0 autoneg off rx on tx on
> 
> is perfectly acceptable, as we are forcing pause modes at the local
> end of the link.
> 
> # ethtool -A eth0 autoneg on
> 
> Now, the question is whether that should be allowed or not - but this
> is merely restoring the "pause" settings that were in effect prior
> to the previous command.  It does not enable pause negotiation,
> because autoneg as a whole is disabled, but it _allows_ pause
> negotiation to occur when autoneg is enabled at some point in the
> future.
> 
> Also, allowing "ethtool -A eth0 autoneg on" when "ethtool -s eth0
> autoneg off" means you can configure the negotiation parameters
> _before_ triggering a negotiation cycle on the link.  In other words,
> it would avoid:
> 
> # ethtool -s eth0 autoneg on
> # # Link renegotiates
> # ethtool -A eth0 autoneg on
> # # Link renegotiates a second time
> 
> and it also means that if stuff has already been scripted to avoid
> this, nothing breaks.
> 
> If we start rejecting ethtool -A because autoneg is disabled, then
> things get difficult to configure - we would need ethtool documentation
> to state that autoneg must be enabled before configuration of pause
> and EEE can be done.  IMHO, that hurts usability, and adds confusion.
> 
Thanks for your input and I agree with what you have said here. I will
remove this commit from the set when I resubmit and I assume that, like
Michal, you would like to see the comment in ethtool.h revised.

I think the crux of the matter is that the meaning of the autoneg pause
parameter is not well specified, and that is fundamentally what I am
trying to clarify in a common implementation that might help unify a
consistent behavior across network drivers.

My interpretation is that the link autonegotiation and the pause
autonegotiation can be meaningfully set independently from each other
and that the interplay between the two has easily overlooked subtleties.

My opinion (which is at least in part drawn from my interpretation of
your opinion) is as follows with regard to pause behaviors:

The link autonegotiation parameter concerns itself with whether the
Pause capabilities are advertised as part of autonegotiation of link
parameters.

The pause autonegotiation parameter concerns itself with whether the
local node is willing to accept the advertised capabilities of its peer
as input into its pause configuration.

The Tx_Pause and Rx_Pause parameters indicate in which directions pause
frames should be supported.

If the pause autonegotiation is off, the MAC is allowed to act
exclusively according to the Tx_Pause and Rx_Pause parameters. If
Tx_Pause is on the MAC should send pause control frames whenever it
needs to assert back pressure to ease the load on its receiver. If
Tx_Pause is off the MAC should not transmit any pause control frames. If
Rx_Pause is on the MAC should delay its transmissions in response to any
pause control frames it receives. If Rx_Pause is off received pause
control frames should be ignored. If link autonegotiation is on the
Tx_Pause and Rx_Pause values should be advertised in the PHY Pause and
AsymPause bits for informational purposes according to the following
mapping:
    tx rx  Pause AsymPause
    0  0   0     0
    0  1   1     1
    1  0   0     1
    1  1   1     0

If the pause autonegotiation is on, and the link autonegotiation is also
on then the Tx_Pause and Rx_Pause values should be advertised in the PHY
Pause and AsymPause bits according to the IEEE 802.3 spec according to
the following mapping:
    tx rx  Pause AsymPause
    0  0   0     0
    0  1   1     1
    1  0   0     1
    1  1   1     1
If link autonegotiation succeeds the peer's advertised Pause and
AsymPause bits should be used in combination with the local Pause and
Pause Asym bits to determine in which directions pause frames are
supported. However, regardless of the negotiated result, if the Tx_Pause
is off no pause frames should be sent and if the Rx_Pause is off
received pause frames should be ignored. If Tx_Pause is on and the
negotiated result allows pause frames to be sent then pause frames may
be sent by the local node to apply back pressure to reduce the load on
its receive path. If Rx_Pause is on and the negotiated result allows
pause frames to be received then the local node should delay its
transmission in response to received pause frames. In this way the local
settings can only override the negotiated settings to disable the use of
pause frames.

If the pause autonegotiation is on, and the link autonegotiation is off
then the values of the peer's Pause and AsymPause bits are forced to 0
(because they can't be exchanged without link autonegotiation) which
always produces the negotiated result of pause frame use being disabled
in both directions. Since the local Tx_Pause and Rx_Pause parameters can
only override the negotiation when they are off, pause frames should not
be sent or received.

This is the behavior I have attempted to implement by this patch set for
the bcmgenet driver, but I see now that I made an error in this last
case since I made the negotiation also dependent on the link
autonegotiation being enabled. I will correct that in a re-submission.

I would appreciate if you can confirm that you agree that this is a good
general behavior for all network devices before I resubmit, or please
help me understand what could be done better.

Many thanks,
    Doug
