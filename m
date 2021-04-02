Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02928352AAF
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 14:36:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235296AbhDBMfT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 08:35:19 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60154 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229599AbhDBMfS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Apr 2021 08:35:18 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lSJ0t-00EUtn-9j; Fri, 02 Apr 2021 14:34:59 +0200
Date:   Fri, 2 Apr 2021 14:34:59 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Voon, Weifeng" <weifeng.voon@intel.com>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        "Sit, Michael Wei Hong" <michael.wei.hong.sit@intel.com>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "qiangqing.zhang@nxp.com" <qiangqing.zhang@nxp.com>,
        "Wong, Vee Khee" <vee.khee.wong@intel.com>,
        "fugang.duan@nxp.com" <fugang.duan@nxp.com>,
        "Chuah, Kim Tatt" <kim.tatt.chuah@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next 1/2] net: stmmac: enable 2.5Gbps link speed
Message-ID: <YGcPc3dan0ocRSG2@lunn.ch>
References: <20210401150152.22444-1-michael.wei.hong.sit@intel.com>
 <20210401150152.22444-2-michael.wei.hong.sit@intel.com>
 <20210401151044.GZ1463@shell.armlinux.org.uk>
 <SN6PR11MB3136F7A7ACA1A5C324031607887A9@SN6PR11MB3136.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SN6PR11MB3136F7A7ACA1A5C324031607887A9@SN6PR11MB3136.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 02, 2021 at 07:45:04AM +0000, Voon, Weifeng wrote:
> > > +	/* 2.5G mode only support 2500baseT full duplex only */
> > > +	if (priv->plat->has_gmac4 && priv->plat->speed_2500_en) {
> > > +		phylink_set(mac_supported, 2500baseT_Full);
> > > +		phylink_set(mask, 10baseT_Half);
> > > +		phylink_set(mask, 10baseT_Full);
> > > +		phylink_set(mask, 100baseT_Half);
> > > +		phylink_set(mask, 100baseT_Full);
> > > +		phylink_set(mask, 1000baseT_Half);
> > > +		phylink_set(mask, 1000baseT_Full);
> > > +		phylink_set(mask, 1000baseKX_Full);
> > 
> > Why? This seems at odds to the comment above?
> 
> > What about 2500baseX_Full ?
> 
> The comments explain that the PCS<->PHY link is in 2500BASE-X
> and why 10/100/1000 link speed is mutually exclusive with 2500.
> But the connected external PHY are twisted pair cable which only
> supports 2500baseT_full.

The PHY should indicate what modes its supports. The PHY drivers
get_features() call should set supported to only 2500baseT_Full, if
that is all it supports.

What modes are actually used should then be the intersect of what both
the MAC and the PHY indicate they can do.

     Andrew
