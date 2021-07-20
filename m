Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53B873CF92E
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 13:52:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237497AbhGTLLI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 07:11:08 -0400
Received: from mxout70.expurgate.net ([91.198.224.70]:48984 "EHLO
        mxout70.expurgate.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236514AbhGTLKh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 07:10:37 -0400
Received: from [127.0.0.1] (helo=localhost)
        by relay.expurgate.net with smtp (Exim 4.92)
        (envelope-from <ms@dev.tdt.de>)
        id 1m5oGx-000THI-Ig; Tue, 20 Jul 2021 13:50:51 +0200
Received: from [195.243.126.94] (helo=securemail.tdt.de)
        by relay.expurgate.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ms@dev.tdt.de>)
        id 1m5oGw-000AsZ-JY; Tue, 20 Jul 2021 13:50:50 +0200
Received: from securemail.tdt.de (localhost [127.0.0.1])
        by securemail.tdt.de (Postfix) with ESMTP id E7FB2240041;
        Tue, 20 Jul 2021 13:50:49 +0200 (CEST)
Received: from mail.dev.tdt.de (unknown [10.2.4.42])
        by securemail.tdt.de (Postfix) with ESMTP id 459F8240040;
        Tue, 20 Jul 2021 13:50:49 +0200 (CEST)
Received: from mail.dev.tdt.de (localhost [IPv6:::1])
        by mail.dev.tdt.de (Postfix) with ESMTP id DDB63201A8;
        Tue, 20 Jul 2021 13:50:48 +0200 (CEST)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 20 Jul 2021 13:50:48 +0200
From:   Martin Schiller <ms@dev.tdt.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     hauke@hauke-m.de, martin.blumenstingl@googlemail.com,
        f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v6] net: phy: intel-xway: Add RGMII internal
 delay configuration
Organization: TDT AG
In-Reply-To: <YPXm9avkMoD/oat8@lunn.ch>
References: <20210719082756.15733-1-ms@dev.tdt.de>
 <YPXm9avkMoD/oat8@lunn.ch>
Message-ID: <7f427d3c93f2cbacbb7273a5af9e4b41@dev.tdt.de>
X-Sender: ms@dev.tdt.de
User-Agent: Roundcube Webmail/1.3.16
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED autolearn=ham
        autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
X-purgate-ID: 151534::1626781851-000096BA-BC353B41/0/0
X-purgate-type: clean
X-purgate: clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-07-19 22:56, Andrew Lunn wrote:
>> +	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
>> +	    phydev->interface == PHY_INTERFACE_MODE_RGMII_RXID) {
>> +		int_delay = phy_get_internal_delay(phydev, dev,
>> +						   xway_internal_delay,
>> +						   delay_size, true);
>> +
>> +		if (int_delay < 0) {
>> +			phydev_warn(phydev, "rx-internal-delay-ps is missing, use default 
>> of 2.0 ns\n");
>> +			int_delay = 4; /* 2000 ps */
> 
> The binding say:
> 
>  rx-internal-delay-ps:
>     description: |
>       RGMII Receive PHY Clock Delay defined in pico seconds.  This is 
> used for
>       PHY's that have configurable RX internal delays.  If this 
> property is
>       present then the PHY applies the RX delay.
> 
> So the property is optional. It being missing should not generate a
> warning. Please just use the default of 2ns. This makes the usage the
> same as the other drivers using phy_get_internal_delay().
> 
>      Andrew

OK, I'll remove the warnings. Thanks.
