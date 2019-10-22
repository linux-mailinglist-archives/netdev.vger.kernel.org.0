Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92222DFD02
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 07:12:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731154AbfJVFM1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 01:12:27 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:60991 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730890AbfJVFMY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 01:12:24 -0400
Received: from soja.hi.pengutronix.de ([2001:67c:670:100:3ad5:47ff:feaf:13da])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <o.rempel@pengutronix.de>)
        id 1iMmT0-00060g-Df; Tue, 22 Oct 2019 07:12:22 +0200
Subject: Re: [PATCH v3 1/5] net: ag71xx: port to phylink
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Mark Rutland <mark.rutland@arm.com>, Andrew Lunn <andrew@lunn.ch>,
        Jay Cliburn <jcliburn@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        devicetree@vger.kernel.org, James Hogan <jhogan@kernel.org>,
        linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Burton <paul.burton@mips.com>,
        Rob Herring <robh+dt@kernel.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Chris Snook <chris.snook@gmail.com>, netdev@vger.kernel.org,
        linux-mips@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>
References: <20191021053811.19818-1-o.rempel@pengutronix.de>
 <20191021053811.19818-2-o.rempel@pengutronix.de>
 <20191021222122.GM25745@shell.armlinux.org.uk>
From:   Oleksij Rempel <o.rempel@pengutronix.de>
Message-ID: <bf684928-0800-69df-f5cd-5d1db6958804@pengutronix.de>
Date:   Tue, 22 Oct 2019 07:12:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191021222122.GM25745@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:3ad5:47ff:feaf:13da
X-SA-Exim-Mail-From: o.rempel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 22.10.19 00:21, Russell King - ARM Linux admin wrote:
> On Mon, Oct 21, 2019 at 07:38:07AM +0200, Oleksij Rempel wrote:
>> +static void ag71xx_mac_validate(struct phylink_config *config,
>> +			    unsigned long *supported,
>> +			    struct phylink_link_state *state)
>>   {
>> -	struct ag71xx *ag = netdev_priv(ndev);
>> +	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
>> +
>> +	if (state->interface != PHY_INTERFACE_MODE_NA &&
>> +	    state->interface != PHY_INTERFACE_MODE_GMII &&
>> +	    state->interface != PHY_INTERFACE_MODE_MII) {
>> +		bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
>> +		return;
>> +	}
>> +
>> +	phylink_set(mask, MII);
>> +
>> +	/* flow control is not supported */
>> +
>> +	phylink_set(mask, 10baseT_Half);
>> +	phylink_set(mask, 10baseT_Full);
>> +	phylink_set(mask, 100baseT_Half);
>> +	phylink_set(mask, 100baseT_Full);
>>   
>> -	ag71xx_link_adjust(ag, true);
>> +	if (state->interface == PHY_INTERFACE_MODE_NA &&
>> +	    state->interface == PHY_INTERFACE_MODE_GMII) {
> 
> This is always false.

... I shame to myself :(

> Apart from that, from just reading the patch I have no further concerns.

ok. thx!

Kind regards,
Oleksij Rempel

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
