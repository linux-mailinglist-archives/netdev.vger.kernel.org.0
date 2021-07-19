Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92F593CD00D
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 11:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235807AbhGSI0Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 04:26:25 -0400
Received: from mxout70.expurgate.net ([194.37.255.70]:33291 "EHLO
        mxout70.expurgate.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234992AbhGSI0Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 04:26:24 -0400
Received: from [127.0.0.1] (helo=localhost)
        by relay.expurgate.net with smtp (Exim 4.92)
        (envelope-from <ms@dev.tdt.de>)
        id 1m5OPm-0006CO-Ap; Mon, 19 Jul 2021 10:14:14 +0200
Received: from [195.243.126.94] (helo=securemail.tdt.de)
        by relay.expurgate.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ms@dev.tdt.de>)
        id 1m5OPj-0001dO-Ty; Mon, 19 Jul 2021 10:14:11 +0200
Received: from securemail.tdt.de (localhost [127.0.0.1])
        by securemail.tdt.de (Postfix) with ESMTP id 35A24240041;
        Mon, 19 Jul 2021 10:14:11 +0200 (CEST)
Received: from mail.dev.tdt.de (unknown [10.2.4.42])
        by securemail.tdt.de (Postfix) with ESMTP id 873DA240040;
        Mon, 19 Jul 2021 10:14:10 +0200 (CEST)
Received: from mail.dev.tdt.de (localhost [IPv6:::1])
        by mail.dev.tdt.de (Postfix) with ESMTP id D566F20176;
        Mon, 19 Jul 2021 10:14:09 +0200 (CEST)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 19 Jul 2021 10:14:09 +0200
From:   Martin Schiller <ms@dev.tdt.de>
To:     Hauke Mehrtens <hauke@hauke-m.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3] net: phy: intel-xway: Add RGMII internal
 delay configuration
Organization: TDT AG
In-Reply-To: <9fa0ce38-d3b5-a60e-cfc4-7799b832065f@hauke-m.de>
References: <20210709164216.18561-1-ms@dev.tdt.de>
 <CAFBinCCw9+oCV==1DrNFU6Lu02h3OyZu9wM=78RKGMCZU6ObEA@mail.gmail.com>
 <fcb3203ea82d1180a6e471f22e39e817@dev.tdt.de> <YO2P8J4Ln+RwxkfO@lunn.ch>
 <9fa0ce38-d3b5-a60e-cfc4-7799b832065f@hauke-m.de>
Message-ID: <42d639692238c4c89fdbca1e0b2b27cd@dev.tdt.de>
X-Sender: ms@dev.tdt.de
User-Agent: Roundcube Webmail/1.3.16
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED autolearn=ham
        autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
X-purgate-ID: 151534::1626682452-000007D5-24CB71FF/0/0
X-purgate: clean
X-purgate-type: clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-07-17 18:38, Hauke Mehrtens wrote:
> On 7/13/21 3:06 PM, Andrew Lunn wrote:
>>>> [...]
>>>>> +#if IS_ENABLED(CONFIG_OF_MDIO)
>>>> is there any particular reason why we need to guard this with
>>>> CONFIG_OF_MDIO?
>>>> The dp83822 driver does not use this #if either (as far as I
>>>> understand at least)
>>>> 
>>> 
>>> It makes no sense to retrieve properties from the device tree if we 
>>> are
>>> compiling for a target that does not support a device tree.
>>> At least that is my understanding of this condition.
>> 
>> There should be stubs for all these functions, so if OF is not part of
>> the configured kernel, stub functions take their place. That has the
>> advantage of at least compiling the code, so checking parameter types
>> etc. We try to avoid #ifdef where possible, so we get better compiler
>> build test coverage. The more #ifef there are, the more different
>> configurations that need compiling in order to get build coverage.
>> 
>> 	       Andrew
>> 
> 
> The phy_get_internal_delay() function does not have a stub function
> directly, but it calls phy_get_int_delay_property() which has a stub,
> if CONFIG_OF_MDIO is not set, see:
> https://elixir.bootlin.com/linux/v5.14-rc1/source/drivers/net/phy/phy_device.c#L2797
> 
> The extra ifdef in the PHY driver only saves some code in the HY
> driver, but it should still work as before on systems without
> CONFIG_OF_MDIO.
> 
> I would also prefer to remove the ifdef from the intel-xway phy driver.
> 
> Hauke

OK, so I'll remove the ifdef from the driver.

