Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFB0B405E14
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 22:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345157AbhIIUit (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 16:38:49 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35280 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245195AbhIIUis (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 16:38:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=mM50TrfQqQvdPGgFlZnAt32dDbSDk7TXR1qkzbZPrRI=; b=cO
        M4N/paCpnShAZbECOOAcisClegFIIIrUT7K0atK3lxh4SBwKqpJiURyIl0yI68ennqVQC1qT7OEQm
        yeHd42Rab44gCIf2Penp6PjuTqTEJheV/QLZGugT+qK0uv0bda8XANPmj0Eg6Qf7CWBozlJO8QvjN
        V0f/GfvTXanYrY4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mOQnd-005xdu-5o; Thu, 09 Sep 2021 22:37:33 +0200
Date:   Thu, 9 Sep 2021 22:37:33 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Modi, Geet" <geet.modi@ti.com>
Cc:     "Nagalla, Hari" <hnagalla@ti.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Sharma, Vikram" <vikram.sharma@ti.com>
Subject: Re: [EXTERNAL] Re: [EXTERNAL] Re: [PATCH] net: phy: dp83tc811:
 modify list of interrupts enabled at initialization
Message-ID: <YTpwjWEUmJWo0mwr@lunn.ch>
References: <20210902190944.4963-1-hnagalla@ti.com>
 <YTFc6pyEtlRO/4r/@lunn.ch>
 <99232B33-1C2F-45AF-A259-0868AC7D3FBC@ti.com>
 <YTdxBMVeqZVyO4Tf@lunn.ch>
 <E61A9519-DBA6-4931-A2A0-78856819C362@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <E61A9519-DBA6-4931-A2A0-78856819C362@ti.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I am planning to have following commit msg;
> 
>  
> 
> “This feature is not used by our mainstream customers as they have additional

As i said, this is not your driver, for you customers. It is the Linux
kernel driver. Please drop all references to your customers. If you
need to address anybody, it should be the Linux community as a whole,
or maybe the users of this driver.

> mechanism to monitor the supply at System level as accuracy requirements are
> different for each application.  The device is designed with inbuilt monitor
> with interrupt disabled by default and let user choose if they want to exercise
> the monitor. However, the driver had this interrupt enabled, the request here
> is disable it by default in driver however not change in datasheet.  Let user
> of the driver review the accuracy offered by monitor and if meets the
> expectation, they can always enable it.”
 
I would much more prefer something like...

The over voltage interrupt is enabled, but if it every occurs, there is
no code to make use of it. So remove the pointless enabling of it. It
can re-enabled when HWMON support is added. For the same reason,
enabling of the interrupts DP83811_RX_ERR_HF_INT_EN,
DP83811_MS_TRAINING_INT_EN, DP83811_ESD_EVENT_INT_EN,
DP83811_ENERGY_DET_INT_EN, DP83811_LINK_QUAL_INT_EN,
DP83811_JABBER_DET_INT_EN, DP83811_POLARITY_INT_EN,
DP83811_SLEEP_MODE_INT_EN, DP83811_OVERTEMP_INT_EN,
DP83811_UNDERVOLTAGE_INT_EN is also removed, since there is no code
which acts on these interrupts.

And update the patch to fit.

      Andrew
