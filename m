Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91D971359F8
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 14:21:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729623AbgAINVc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 08:21:32 -0500
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:58571 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725839AbgAINVc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 08:21:32 -0500
X-Originating-IP: 90.76.143.236
Received: from localhost (lfbn-tou-1-1075-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id 5C8EE40004;
        Thu,  9 Jan 2020 13:21:27 +0000 (UTC)
Date:   Thu, 9 Jan 2020 14:21:26 +0100
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Igor Russkikh <irusskikh@marvell.com>
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "sd@queasysnail.net" <sd@queasysnail.net>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>,
        "camelia.groza@nxp.com" <camelia.groza@nxp.com>,
        "Simon.Edelhaus@aquantia.com" <Simon.Edelhaus@aquantia.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        Dmitry Bogdanov <dbogdanov@marvell.com>,
        Mark Starovoytov <mstarovoitov@marvell.com>
Subject: Re: [EXT] [PATCH net-next v4 15/15] net: macsec: add support for
 offloading to the MAC
Message-ID: <20200109132126.GD5472@kwain>
References: <20191219105515.78400-1-antoine.tenart@bootlin.com>
 <20191219105515.78400-16-antoine.tenart@bootlin.com>
 <MN2PR18MB26387BD6B59565D21F936FE5B72E0@MN2PR18MB2638.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <MN2PR18MB26387BD6B59565D21F936FE5B72E0@MN2PR18MB2638.namprd18.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Igor,

On Mon, Dec 23, 2019 at 11:36:48AM +0000, Igor Russkikh wrote:
> 
> > diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
> > index 024af2d1d0af..771371d5b996 100644
> > --- a/include/uapi/linux/if_link.h
> > +++ b/include/uapi/linux/if_link.h
> > @@ -489,6 +489,7 @@ enum macsec_validation_type {
> >  enum macsec_offload {
> >  	MACSEC_OFFLOAD_OFF = 0,
> >  	MACSEC_OFFLOAD_PHY = 1,
> > +	MACSEC_OFFLOAD_MAC = 2,
> >  	__MACSEC_OFFLOAD_END,
> >  	MACSEC_OFFLOAD_MAX = __MACSEC_OFFLOAD_END - 1,
> 
> So from uapi perspective user have to explicitly specify "offload mac"
> or "offload phy"? And from non experienced user perspective he always
> have to try these two before rolling back to "offload none" ?
> 
> I'm not saying this is wrong, just trying to understand if there any
> more streamlined way to do this..

That is the idea, the commands will be:
# ip macsec offload macsec0 off
# ip macsec offload macsec0 phy
# ip macsec offload macsec0 mac

We should be able to report what's supported for a given interface, for
a more user friendly experience though. (We could include the
information in `ip macsec show` for example). Would that improve things?

Thanks!
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
