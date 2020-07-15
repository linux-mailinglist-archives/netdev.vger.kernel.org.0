Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D176922164A
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 22:33:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726996AbgGOUd1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 16:33:27 -0400
Received: from ssl.serverraum.org ([176.9.125.105]:54041 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726491AbgGOUd0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 16:33:26 -0400
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 374A322F2E;
        Wed, 15 Jul 2020 22:33:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1594845203;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1R6jeG7FT+QCwR3qccYGaQElhDE6JyZhVCS4fYcS7Ks=;
        b=AaOqyHiujL9F9adYBvyLPusadO/aXLJC1EC4nuSiP1OJS0fJVWBEjZ2o0jOc+JGO7VjEaP
        sraX8ttjpR2SkCoYubNuyXXdNIiTMFztRS0v9ArSIohDJh4/w9fiAr9ev2wIzUejVavbow
        nJB4mVS4hbf2e34qBF1WlY+A0eSOeAw=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 15 Jul 2020 22:33:23 +0200
From:   Michael Walle <michael@walle.cc>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Heiko Thiery <heiko.thiery@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net-next v6 1/4] net: phy: add USXGMII link partner
 ability constants
In-Reply-To: <546718f3f76862d285aeb82cb02767c4@walle.cc>
References: <20200709213526.21972-1-michael@walle.cc>
 <20200709213526.21972-2-michael@walle.cc>
 <20200713182314.GW1551@shell.armlinux.org.uk>
 <546718f3f76862d285aeb82cb02767c4@walle.cc>
User-Agent: Roundcube Webmail/1.4.7
Message-ID: <b6c24b8f698245549056c975042d9b51@walle.cc>
X-Sender: michael@walle.cc
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2020-07-13 20:37, schrieb Michael Walle:
> Am 2020-07-13 20:23, schrieb Russell King - ARM Linux admin:
>> On Thu, Jul 09, 2020 at 11:35:23PM +0200, Michael Walle wrote:
>>> The constants are taken from the USXGMII Singleport Copper Interface
>>> specification. The naming are based on the SGMII ones, but with an 
>>> MDIO_
>>> prefix.
>>> 
>>> Signed-off-by: Michael Walle <michael@walle.cc>
>>> ---
>>>  include/uapi/linux/mdio.h | 26 ++++++++++++++++++++++++++
>>>  1 file changed, 26 insertions(+)
>>> 
>>> diff --git a/include/uapi/linux/mdio.h b/include/uapi/linux/mdio.h
>>> index 4bcb41c71b8c..784723072578 100644
>>> --- a/include/uapi/linux/mdio.h
>>> +++ b/include/uapi/linux/mdio.h
>>> @@ -324,4 +324,30 @@ static inline __u16 mdio_phy_id_c45(int prtad, 
>>> int devad)
>>>  	return MDIO_PHY_ID_C45 | (prtad << 5) | devad;
>>>  }
>>> 
>>> +/* UsxgmiiChannelInfo[15:0] for USXGMII in-band auto-negotiation.*/
>>> +#define MDIO_LPA_USXGMII_EEE_CLK_STP	0x0080	/* EEE clock stop 
>>> supported */
>>> +#define MDIO_LPA_USXGMII_EEE		0x0100	/* EEE supported */
>>> +#define MDIO_LPA_USXGMII_SPD_MASK	0x0e00	/* USXGMII speed mask */
>>> +#define MDIO_LPA_USXGMII_FULL_DUPLEX	0x1000	/* USXGMII full duplex 
>>> */
>>> +#define MDIO_LPA_USXGMII_DPX_SPD_MASK	0x1e00	/* USXGMII duplex and 
>>> speed bits */
>>> +#define MDIO_LPA_USXGMII_10		0x0000	/* 10Mbps */
>>> +#define MDIO_LPA_USXGMII_10HALF		0x0000	/* 10Mbps half-duplex */
>>> +#define MDIO_LPA_USXGMII_10FULL		0x1000	/* 10Mbps full-duplex */
>>> +#define MDIO_LPA_USXGMII_100		0x0200	/* 100Mbps */
>>> +#define MDIO_LPA_USXGMII_100HALF	0x0200	/* 100Mbps half-duplex */
>>> +#define MDIO_LPA_USXGMII_100FULL	0x1200	/* 100Mbps full-duplex */
>>> +#define MDIO_LPA_USXGMII_1000		0x0400	/* 1000Mbps */
>>> +#define MDIO_LPA_USXGMII_1000HALF	0x0400	/* 1000Mbps half-duplex */
>>> +#define MDIO_LPA_USXGMII_1000FULL	0x1400	/* 1000Mbps full-duplex */
>>> +#define MDIO_LPA_USXGMII_10G		0x0600	/* 10Gbps */
>>> +#define MDIO_LPA_USXGMII_10GHALF	0x0600	/* 10Gbps half-duplex */
>>> +#define MDIO_LPA_USXGMII_10GFULL	0x1600	/* 10Gbps full-duplex */
>>> +#define MDIO_LPA_USXGMII_2500		0x0800	/* 2500Mbps */
>>> +#define MDIO_LPA_USXGMII_2500HALF	0x0800	/* 2500Mbps half-duplex */
>>> +#define MDIO_LPA_USXGMII_2500FULL	0x1800	/* 2500Mbps full-duplex */
>>> +#define MDIO_LPA_USXGMII_5000		0x0a00	/* 5000Mbps */
>>> +#define MDIO_LPA_USXGMII_5000HALF	0x0a00	/* 5000Mbps half-duplex */
>>> +#define MDIO_LPA_USXGMII_5000FULL	0x1a00	/* 5000Mbps full-duplex */
>>> +#define MDIO_LPA_USXGMII_LINK		0x8000	/* PHY link with copper-side 
>>> partner */
>> 
>> btw, the only thing which is missing from this is bit 0.
> 
> TBH, I didn't know how to name it. Any suggestions?

NXP calls it ABIL0, in xilinx docs its called USXGMII [1]. In the 
USXGMII
spec, its "set to 1 (0 is SGMII)" which I don't understand because its
also 1 for SGMII, right? At least as described in the tx_configReg[15:0] 
in
the SGMII spec.

#define MDIO_USXGMII_USXGMII 0x0001 ?

-michael

[1] 
https://www.xilinx.com/support/documentation/ip_documentation/usxgmii/v1_0/pg251-usxgmii.pdf
