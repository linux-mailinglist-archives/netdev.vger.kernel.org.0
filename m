Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D2CF95192
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 01:17:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728693AbfHSXPa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 19:15:30 -0400
Received: from mx.0dd.nl ([5.2.79.48]:48356 "EHLO mx.0dd.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728218AbfHSXPa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Aug 2019 19:15:30 -0400
Received: from mail.vdorst.com (mail.vdorst.com [IPv6:fd01::250])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.0dd.nl (Postfix) with ESMTPS id 3E1E95FA7D;
        Tue, 20 Aug 2019 01:15:27 +0200 (CEST)
Authentication-Results: mx.0dd.nl;
        dkim=pass (2048-bit key; secure) header.d=vdorst.com header.i=@vdorst.com header.b="ULjt8ge+";
        dkim-atps=neutral
Received: from www (www.vdorst.com [192.168.2.222])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.vdorst.com (Postfix) with ESMTPSA id ECEC81D7CB29;
        Tue, 20 Aug 2019 01:15:26 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.vdorst.com ECEC81D7CB29
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vdorst.com;
        s=default; t=1566256527;
        bh=C8ea6Y3384VBk/QFSJchvtn4T6yvfAqag7cXPB04Y84=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ULjt8ge+g1b0WHabO2Nvp0MO8hkns0DYw9T60kxk1Hgdvz1yxwutf9QTyiw4dxxDy
         PnLCyf+I96TCz42A8cO2+u/SzEm7GQD4/734KP1EB70BeL4wLssReF7CO+hUdOKyfo
         RBPZvFb0AHLn9dN2mIoiWkoV7AVkwO/l49Ih3EqIjMjH9Ce8+wjqGiNDzKpucTxF2p
         NrxDOqx0OGn71mTVq/8bCFXW5yQFyqIh2xZzS91n9WwC9vaAdaXeaLpbUBW8M/Cbz0
         EGGkljRvWTvaSzIgaVee0T7gCla0s/oyNemnCUuCRb507radYgJxDWgtLGCLkGOTDC
         iPGnC1B2C/q3A==
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1]) by
 www.vdorst.com (Horde Framework) with HTTPS; Mon, 19 Aug 2019 23:15:26 +0000
Date:   Mon, 19 Aug 2019 23:15:26 +0000
Message-ID: <20190819231526.Horde.8CjxfcGbCnfBNA-nXmq1PJt@www.vdorst.com>
From:   =?utf-8?b?UmVuw6k=?= van Dorst <opensource@vdorst.com>
To:     Tao Ren <taoren@fb.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Arun Parameswaran <arun.parameswaran@broadcom.com>,
        Justin Chen <justinpopo6@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, openbmc@lists.ozlabs.org
Subject: Re: [PATCH net-next v7 2/3] net: phy: add support for clause 37
 auto-negotiation
References: <20190811234010.3673592-1-taoren@fb.com>
 <3af5d897-7f97-a223-2d7b-56e09b83dcb5@fb.com>
In-Reply-To: <3af5d897-7f97-a223-2d7b-56e09b83dcb5@fb.com>
User-Agent: Horde Application Framework 5
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Tao,

Quoting Tao Ren <taoren@fb.com>:

> On 8/11/19 4:40 PM, Tao Ren wrote:
>> From: Heiner Kallweit <hkallweit1@gmail.com>
>>
>> This patch adds support for clause 37 1000Base-X auto-negotiation.
>>
>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>> Signed-off-by: Tao Ren <taoren@fb.com>
>
> A kind reminder: could someone help to review the patch when you  
> have bandwidth?
>

FWIW: I have a similar setup with my device. MAC -> PHY -> SFP cage.
PHY is a Qualcomm at8031 and is used as a RGMII-to-SerDes converter.
SerDes only support 100Base-FX and 1000Base-X in this converter mode.
PHY also supports a RJ45 port but that is not wired on my device.

I converted [0] at803x driver to make use of the PHYLINK API for SFP cage and
also of these new c37 functions.

In autoneg on and off, it detects the link and can ping a host on the network.
Tested with 1gbit BiDi optical(1000Base-X) and RJ45 module(SGMII).
Both work and both devices detects unplug and plug-in of the cable.

output of ethtool:

Autoneg on
Settings for lan5:
         Supported ports: [ TP MII ]
         Supported link modes:   100baseT/Half 100baseT/Full
                                 1000baseT/Full
                                 1000baseX/Full
         Supported pause frame use: Symmetric Receive-only
         Supports auto-negotiation: Yes
         Supported FEC modes: Not reported
         Advertised link modes:  100baseT/Half 100baseT/Full
                                 1000baseT/Full
                                 1000baseX/Full
         Advertised pause frame use: Symmetric Receive-only
         Advertised auto-negotiation: Yes
         Advertised FEC modes: Not reported
         Link partner advertised link modes:  1000baseX/Full
         Link partner advertised pause frame use: Symmetric Receive-only
         Link partner advertised auto-negotiation: Yes
         Link partner advertised FEC modes: Not reported
         Speed: 1000Mb/s
         Duplex: Full
         Port: MII
         PHYAD: 7
         Transceiver: internal
         Auto-negotiation: on
         Supports Wake-on: g
         Wake-on: d
         Link detected: yes

Autoneg off
Settings for lan5:
         Supported ports: [ TP MII ]
         Supported link modes:   100baseT/Half 100baseT/Full
                                 1000baseT/Full
                                 1000baseX/Full
         Supported pause frame use: Symmetric Receive-only
         Supports auto-negotiation: Yes
         Supported FEC modes: Not reported
         Advertised link modes:  1000baseT/Full
         Advertised pause frame use: Symmetric Receive-only
         Advertised auto-negotiation: No
         Advertised FEC modes: Not reported
         Speed: 1000Mb/s
         Duplex: Full
         Port: MII
         PHYAD: 7
         Transceiver: internal
         Auto-negotiation: off
         Supports Wake-on: g
         Wake-on: d
         Link detected: yes

Tested-by: René van Dorst <opensource@vdorst.com>

Greats,

René

[0]  
https://github.com/vDorst/linux-1/blob/1d8cb01bc8047bda94c076676e47b09d2f31069d/drivers/net/phy/at803x.c

>
> Cheers,
>
> Tao
>
>> ---
>>  Changes in v7:
>>   - Update "if (AUTONEG_ENABLE != phydev->autoneg)" to
>>     "if (phydev->autoneg != AUTONEG_ENABLE)" so checkpatch.pl is happy.
>>  Changes in v6:
>>   - add "Signed-off-by: Tao Ren <taoren@fb.com>"
>>  Changes in v1-v5:
>>   - nothing changed. It's given v5 just to align with the version of
>>     patch series.
>>
>>  drivers/net/phy/phy_device.c | 139 +++++++++++++++++++++++++++++++++++
>>  include/linux/phy.h          |   5 ++
>>  2 files changed, 144 insertions(+)
>>
>> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
>> index 252a712d1b2b..301a794b2963 100644
>> --- a/drivers/net/phy/phy_device.c
>> +++ b/drivers/net/phy/phy_device.c
>> @@ -1617,6 +1617,40 @@ static int genphy_config_advert(struct  
>> phy_device *phydev)
>>  	return changed;
>>  }
>>
>> +/**
>> + * genphy_c37_config_advert - sanitize and advertise  
>> auto-negotiation parameters
>> + * @phydev: target phy_device struct
>> + *
>> + * Description: Writes MII_ADVERTISE with the appropriate values,
>> + *   after sanitizing the values to make sure we only advertise
>> + *   what is supported.  Returns < 0 on error, 0 if the PHY's advertisement
>> + *   hasn't changed, and > 0 if it has changed. This function is intended
>> + *   for Clause 37 1000Base-X mode.
>> + */
>> +static int genphy_c37_config_advert(struct phy_device *phydev)
>> +{
>> +	u16 adv = 0;
>> +
>> +	/* Only allow advertising what this PHY supports */
>> +	linkmode_and(phydev->advertising, phydev->advertising,
>> +		     phydev->supported);
>> +
>> +	if (linkmode_test_bit(ETHTOOL_LINK_MODE_1000baseX_Full_BIT,
>> +			      phydev->advertising))
>> +		adv |= ADVERTISE_1000XFULL;
>> +	if (linkmode_test_bit(ETHTOOL_LINK_MODE_Pause_BIT,
>> +			      phydev->advertising))
>> +		adv |= ADVERTISE_1000XPAUSE;
>> +	if (linkmode_test_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
>> +			      phydev->advertising))
>> +		adv |= ADVERTISE_1000XPSE_ASYM;
>> +
>> +	return phy_modify_changed(phydev, MII_ADVERTISE,
>> +				  ADVERTISE_1000XFULL | ADVERTISE_1000XPAUSE |
>> +				  ADVERTISE_1000XHALF | ADVERTISE_1000XPSE_ASYM,
>> +				  adv);
>> +}
>> +
>>  /**
>>   * genphy_config_eee_advert - disable unwanted eee mode advertisement
>>   * @phydev: target phy_device struct
>> @@ -1726,6 +1760,54 @@ int genphy_config_aneg(struct phy_device *phydev)
>>  }
>>  EXPORT_SYMBOL(genphy_config_aneg);
>>
>> +/**
>> + * genphy_c37_config_aneg - restart auto-negotiation or write BMCR
>> + * @phydev: target phy_device struct
>> + *
>> + * Description: If auto-negotiation is enabled, we configure the
>> + *   advertising, and then restart auto-negotiation.  If it is not
>> + *   enabled, then we write the BMCR. This function is intended
>> + *   for use with Clause 37 1000Base-X mode.
>> + */
>> +int genphy_c37_config_aneg(struct phy_device *phydev)
>> +{
>> +	int err, changed;
>> +
>> +	if (phydev->autoneg != AUTONEG_ENABLE)
>> +		return genphy_setup_forced(phydev);
>> +
>> +	err = phy_modify(phydev, MII_BMCR, BMCR_SPEED1000 | BMCR_SPEED100,
>> +			 BMCR_SPEED1000);
>> +	if (err)
>> +		return err;
>> +
>> +	changed = genphy_c37_config_advert(phydev);
>> +	if (changed < 0) /* error */
>> +		return changed;
>> +
>> +	if (!changed) {
>> +		/* Advertisement hasn't changed, but maybe aneg was never on to
>> +		 * begin with?  Or maybe phy was isolated?
>> +		 */
>> +		int ctl = phy_read(phydev, MII_BMCR);
>> +
>> +		if (ctl < 0)
>> +			return ctl;
>> +
>> +		if (!(ctl & BMCR_ANENABLE) || (ctl & BMCR_ISOLATE))
>> +			changed = 1; /* do restart aneg */
>> +	}
>> +
>> +	/* Only restart aneg if we are advertising something different
>> +	 * than we were before.
>> +	 */
>> +	if (changed > 0)
>> +		return genphy_restart_aneg(phydev);
>> +
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL(genphy_c37_config_aneg);
>> +
>>  /**
>>   * genphy_aneg_done - return auto-negotiation status
>>   * @phydev: target phy_device struct
>> @@ -1864,6 +1946,63 @@ int genphy_read_status(struct phy_device *phydev)
>>  }
>>  EXPORT_SYMBOL(genphy_read_status);
>>
>> +/**
>> + * genphy_c37_read_status - check the link status and update  
>> current link state
>> + * @phydev: target phy_device struct
>> + *
>> + * Description: Check the link, then figure out the current state
>> + *   by comparing what we advertise with what the link partner
>> + *   advertises. This function is for Clause 37 1000Base-X mode.
>> + */
>> +int genphy_c37_read_status(struct phy_device *phydev)
>> +{
>> +	int lpa, err, old_link = phydev->link;
>> +
>> +	/* Update the link, but return if there was an error */
>> +	err = genphy_update_link(phydev);
>> +	if (err)
>> +		return err;
>> +
>> +	/* why bother the PHY if nothing can have changed */
>> +	if (phydev->autoneg == AUTONEG_ENABLE && old_link && phydev->link)
>> +		return 0;
>> +
>> +	phydev->duplex = DUPLEX_UNKNOWN;
>> +	phydev->pause = 0;
>> +	phydev->asym_pause = 0;
>> +
>> +	if (phydev->autoneg == AUTONEG_ENABLE && phydev->autoneg_complete) {
>> +		lpa = phy_read(phydev, MII_LPA);
>> +		if (lpa < 0)
>> +			return lpa;
>> +
>> +		linkmode_mod_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
>> +				 phydev->lp_advertising, lpa & LPA_LPACK);
>> +		linkmode_mod_bit(ETHTOOL_LINK_MODE_1000baseX_Full_BIT,
>> +				 phydev->lp_advertising, lpa & LPA_1000XFULL);
>> +		linkmode_mod_bit(ETHTOOL_LINK_MODE_Pause_BIT,
>> +				 phydev->lp_advertising, lpa & LPA_1000XPAUSE);
>> +		linkmode_mod_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
>> +				 phydev->lp_advertising,
>> +				 lpa & LPA_1000XPAUSE_ASYM);
>> +
>> +		phy_resolve_aneg_linkmode(phydev);
>> +	} else if (phydev->autoneg == AUTONEG_DISABLE) {
>> +		int bmcr = phy_read(phydev, MII_BMCR);
>> +
>> +		if (bmcr < 0)
>> +			return bmcr;
>> +
>> +		if (bmcr & BMCR_FULLDPLX)
>> +			phydev->duplex = DUPLEX_FULL;
>> +		else
>> +			phydev->duplex = DUPLEX_HALF;
>> +	}
>> +
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL(genphy_c37_read_status);
>> +
>>  /**
>>   * genphy_soft_reset - software reset the PHY via BMCR_RESET bit
>>   * @phydev: target phy_device struct
>> diff --git a/include/linux/phy.h b/include/linux/phy.h
>> index 462b90b73f93..81a2921512ee 100644
>> --- a/include/linux/phy.h
>> +++ b/include/linux/phy.h
>> @@ -1077,6 +1077,11 @@ int genphy_suspend(struct phy_device *phydev);
>>  int genphy_resume(struct phy_device *phydev);
>>  int genphy_loopback(struct phy_device *phydev, bool enable);
>>  int genphy_soft_reset(struct phy_device *phydev);
>> +
>> +/* Clause 37 */
>> +int genphy_c37_config_aneg(struct phy_device *phydev);
>> +int genphy_c37_read_status(struct phy_device *phydev);
>> +
>>  static inline int genphy_no_soft_reset(struct phy_device *phydev)
>>  {
>>  	return 0;
>>



