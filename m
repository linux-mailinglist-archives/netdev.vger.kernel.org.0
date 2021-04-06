Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE1D9355CAB
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 22:06:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347137AbhDFUGu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 16:06:50 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36450 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234411AbhDFUGt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 16:06:49 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lTrxn-00FB5Q-Mq; Tue, 06 Apr 2021 22:06:15 +0200
Date:   Tue, 6 Apr 2021 22:06:15 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Voon, Weifeng" <weifeng.voon@intel.com>
Cc:     "Sit, Michael Wei Hong" <michael.wei.hong.sit@intel.com>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
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
Subject: Re: [PATCH net-next v2 0/2] Enable 2.5Gbps speed for stmmac
Message-ID: <YGy/N+cRLGTifJSN@lunn.ch>
References: <20210405112953.26008-1-michael.wei.hong.sit@intel.com>
 <YGsMbBW9h4H1y/T8@lunn.ch>
 <CO1PR11MB5044B1F80C412E6F0CAFD5509D779@CO1PR11MB5044.namprd11.prod.outlook.com>
 <YGsgHWItHcLFV9Kg@lunn.ch>
 <SN6PR11MB313690E7953BF715A8F488D688769@SN6PR11MB3136.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SN6PR11MB313690E7953BF715A8F488D688769@SN6PR11MB3136.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The limitation is not on the MAC, PCS or the PHY. For Intel mgbe, the
> overclocking of 2.5 times clock rate to support 2.5G is only able to be
> configured in the BIOS during boot time. Kernel driver has no access to 
> modify the clock rate for 1Gbps/2.5G mode. The way to determined the 
> current 1G/2.5G mode is by reading a dedicated adhoc register through mdio bus.
> In short, after the system boot up, it is either in 1G mode or 2.5G mode 
> which not able to be changed on the fly. 

Right. It would of been a lot easier if this was in the commit message
from the beginning. Please ensure the next version does say this.

> Since the stmmac MAC can pair with any PCS and PHY, I still prefer that we tie
> this platform specific limitation with the of MAC. As stmmac does handle platform
> specific config/limitation. 

So yes, this needs to be somewhere in the intel specific stmmac code,
with a nice comment explaining what is going on.

What PHY are you using? The Aquantia/Marvell multi-gige phy can do
rate adaptation. So you could fix the MAC-PHY link to 2500BaseX, and
let the PHY internally handle the different line speeds.

    Andrew
