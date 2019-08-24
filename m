Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 317A49BDE6
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 15:11:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727894AbfHXNLX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Aug 2019 09:11:23 -0400
Received: from mx.0dd.nl ([5.2.79.48]:36102 "EHLO mx.0dd.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727604AbfHXNLX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 24 Aug 2019 09:11:23 -0400
Received: from mail.vdorst.com (mail.vdorst.com [IPv6:fd01::250])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.0dd.nl (Postfix) with ESMTPS id B6DEB5FBFB;
        Sat, 24 Aug 2019 15:11:17 +0200 (CEST)
Authentication-Results: mx.0dd.nl;
        dkim=pass (2048-bit key) header.d=vdorst.com header.i=@vdorst.com header.b="jG4VBZ89";
        dkim-atps=neutral
Received: from www (www.vdorst.com [192.168.2.222])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.vdorst.com (Postfix) with ESMTPSA id 6EA041D8B489;
        Sat, 24 Aug 2019 15:11:17 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.vdorst.com 6EA041D8B489
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vdorst.com;
        s=default; t=1566652277;
        bh=hos8an279XjeBCc4UtxVqhtIw4njwg8nYgPuYhkHgyQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jG4VBZ89jUEpd88tWGtxZbtQ7SPOEXbaRuLeC88WEbeBUadPZ93K/TffltlJeN0uM
         iyb4wcxwTi7MxagLSxraAmNvg9W6zQxk9W4oeu6C7RaIZ+rgy+aeAm41H27lTWLa5U
         C94R6dklB3lMPvv/11m7wh/92ltCK4fjO7jC4cL1zFP5TTILoz/leIrPDzdmENFkeM
         m2Odg8y0eIrEX6eMhdSyvFWsQTJDtZLppCAGidiQ5eqTEsw9qQKsvv3it0TH9hGK47
         XkD03YiUhcjI8AubkxeYNgaeXdltyKScW0G9Y2i4s0TnHV1mSx7ACOkl48j4S+/we+
         KK2z+oFo1UQ+g==
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1]) by
 www.vdorst.com (Horde Framework) with HTTPS; Sat, 24 Aug 2019 13:11:17 +0000
Date:   Sat, 24 Aug 2019 13:11:17 +0000
Message-ID: <20190824131117.Horde.vSCF_CQ5jCMHcSTWkh7Woxm@www.vdorst.com>
From:   =?utf-8?b?UmVuw6k=?= van Dorst <opensource@vdorst.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Nelson Chang <nelson.chang@mediatek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-mips@vger.kernel.org,
        Frank Wunderlich <frank-w@public-files.de>,
        Stefan Roese <sr@denx.de>
Subject: Re: [PATCH net-next v3 2/3] net: ethernet: mediatek: Re-add support
 SGMII
References: <20190823134516.27559-1-opensource@vdorst.com>
 <20190823134516.27559-3-opensource@vdorst.com>
 <20190824092156.GD13294@shell.armlinux.org.uk>
In-Reply-To: <20190824092156.GD13294@shell.armlinux.org.uk>
User-Agent: Horde Application Framework 5
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

Quoting Russell King - ARM Linux admin <linux@armlinux.org.uk>:

> On Fri, Aug 23, 2019 at 03:45:15PM +0200, René van Dorst wrote:
>> +	switch (state->interface) {
>> +	case PHY_INTERFACE_MODE_SGMII:
>> +		phylink_set(mask, 10baseT_Half);
>> +		phylink_set(mask, 10baseT_Full);
>> +		phylink_set(mask, 100baseT_Half);
>> +		phylink_set(mask, 100baseT_Full);
>
> You also want 1000baseX_Full here - the connected PHY could have a fiber
> interface on it.

Ok, I shall add that mode too.

>
>> +		/* fall through */
>> +	case PHY_INTERFACE_MODE_TRGMII:
>>  		phylink_set(mask, 1000baseT_Full);
>
> I don't know enough about this interface type to comment whether it
> should support 1000baseX_Full - if this is connected to a PHY that may
> support fiber, then it ought to set it.

Mediatek calls it Turbo RGMII. It is a overclock version of RGMII mode.
It is used between first GMAC and port 6 of the mt7530 switch. Can be  
used with
an internal and an external mt7530 switch.

TRGMII speed are:
* mt7621: 1200Mbit
* mt7623: 2000Mbit and 2600Mbit.

I think that TRGMII is only used in a fixed-link situation in  
combination with a
mt7530 switch and running and maximum speed/full duplex. So reporting
1000baseT_Full seems to me the right option.

>
>> +		break;
>> +	case PHY_INTERFACE_MODE_2500BASEX:
>> +		phylink_set(mask, 2500baseX_Full);
>> +		/* fall through */
>> +	case PHY_INTERFACE_MODE_1000BASEX:
>> +		phylink_set(mask, 1000baseX_Full);
>
> Both should be set.  The reasoning here is that if you have a
> Fiberchannel 4Gbaud SFP plugged in and connected directly to the
> MAC, it can operate at either 2500Base-X or 1000Base-X.  If we
> decide to operate at 2500Base-X, then PHY_INTERFACE_MODE_2500BASEX
> will be chosen.  Otherwise, PHY_INTERFACE_MODE_1000BASEX will be
> used.
>
> The user can use ethtool to control which interface mode is used
> by adjusting the advertise mask and/or placing the interface in
> manual mode and setting the speed directly.  This will change
> the PHY_INTERFACE_MODE_xxxxBASEX (via phylink_helper_basex_speed())
> between the two settings.
>
> If we lose 2500baseX_Full when 1000Base-X is selected, the user
> will not be able to go back to 2500Base-X mode.
>
> Yes, it's a little confusing and has slightly different rules
> from the other modes - partly due to phylink_helper_basex_speed().
> These are the only interface modes that we dynamically switch
> between depending on the settings that the user configures via
> ethtool.

Thanks for this extra information.


I made a list for each mode what that mode should report back when chosen.

PHY_INTERFACE_MODE_SGMII:
	  10baseT_Half
	  10baseT_Full
	 100baseT_Half
	 100baseT_Full
	1000baseT_Full
	1000baseX_Full

PHY_INTERFACE_MODE_1000BASEX:
PHY_INTERFACE_MODE_2500BASEX:
	1000baseX_Full
	2500baseX_Full

PHY_INTERFACE_MODE_TRGMII:
	1000baseT_Full

PHY_INTERFACE_MODE_RGMII:
PHY_INTERFACE_MODE_RGMII_ID:
PHY_INTERFACE_MODE_RGMII_RXID:
PHY_INTERFACE_MODE_RGMII_TXID:
	  10baseT_Half
	  10baseT_Full
	 100baseT_Half
	 100baseT_Full
	1000baseT_Half
	1000baseT_Full
	1000baseX_Full

PHY_INTERFACE_MODE_GMII:
	  10baseT_Half
	  10baseT_Full
	 100baseT_Half
	 100baseT_Full
	1000baseT_Half
	1000baseT_Full

PHY_INTERFACE_MODE_MII:
PHY_INTERFACE_MODE_RMII:
PHY_INTERFACE_MODE_REVMII:
	 10baseT_Half
	 10baseT_Full
	100baseT_Half
	100baseT_Full

case PHY_INTERFACE_MODE_NA:
	  10baseT_Half
	  10baseT_Full
	 100baseT_Half
	 100baseT_Full
	1000baseT_Half
	1000baseT_Full
	1000baseX_Full
	2500baseX_Full

I think this is the full list.
Or do I miss something?

Greats,

René

>
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
> According to speedtest.net: 11.9Mbps down 500kbps up



