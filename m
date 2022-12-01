Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AB2463EAF1
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 09:21:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbiLAIVS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 03:21:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbiLAIVQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 03:21:16 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33DCC2B1A9;
        Thu,  1 Dec 2022 00:21:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669882872; x=1701418872;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=AlPYdQCYvkoxVbZrZSZWzW+Og4pUdKEw9Hd0l72WtTI=;
  b=fx00iyLOCFsdE3jKFuoiz7e7jksNX5aqVO1vxCEG6zyFSZ+NBYkbU/ti
   nmCioDBW+2pQT+YN3Q2oyT9ApPWo/jlWpkTCdZQ690Qp7ILwKKUth00Zf
   AGU9njbdqNAxxgbGoN7aFqi8u97Vu8H86erNnL2P3Gx08cGHxlXLGZyPi
   9+GyZ/xXV+F8EULEOaJaPjY701D7dBzGuwIxvanrCjYd2y4ab4rF6cVZ0
   C+1ZkLHfInywuy082Pczt1xVZ3iA2wRWoL5O2YJ8NXp/X911oZWRhLN/D
   l/g67V2+URhcy9pPpDscKHqrofkkl1shvzwIG3ID77y9r6Om+agzonttG
   A==;
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="189505260"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Dec 2022 01:21:08 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Thu, 1 Dec 2022 01:21:03 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2507.12 via Frontend
 Transport; Thu, 1 Dec 2022 01:21:03 -0700
Date:   Thu, 1 Dec 2022 09:26:07 +0100
From:   Horatiu Vultur - M31836 <Horatiu.Vultur@microchip.com>
To:     Divya Koppera - I30481 <Divya.Koppera@microchip.com>
CC:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        UNGLinuxDriver <UNGLinuxDriver@microchip.com>,
        Madhuri Sripada - I34878 <Madhuri.Sripada@microchip.com>
Subject: Re: [PATCH v3 net-next] net: phy: micrel: Fix warn: passing zero to
 PTR_ERR
Message-ID: <20221201082607.ap4jqool2uc6ziqk@soft-dev3-1>
References: <20221129101653.6921-1-Divya.Koppera@microchip.com>
 <20221130145034.rmput7zdhwevo2p7@soft-dev3-1>
 <CO1PR11MB4771030026F8460B5A92DC35E2149@CO1PR11MB4771.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <CO1PR11MB4771030026F8460B5A92DC35E2149@CO1PR11MB4771.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 12/01/2022 07:08, Divya Koppera - I30481 wrote:
> Hi Horatiu,
> 
> > -----Original Message-----
> > From: Horatiu Vultur <horatiu.vultur@microchip.com>
> > Sent: Wednesday, November 30, 2022 8:21 PM
> > To: Divya Koppera - I30481 <Divya.Koppera@microchip.com>
> > Cc: andrew@lunn.ch; hkallweit1@gmail.com; linux@armlinux.org.uk;
> > davem@davemloft.net; edumazet@google.com; kuba@kernel.org;
> > pabeni@redhat.com; netdev@vger.kernel.org; linux-
> > kernel@vger.kernel.org; richardcochran@gmail.com; UNGLinuxDriver
> > <UNGLinuxDriver@microchip.com>; Madhuri Sripada - I34878
> > <Madhuri.Sripada@microchip.com>
> > Subject: Re: [PATCH v3 net-next] net: phy: micrel: Fix warn: passing zero to
> > PTR_ERR
> > 
> > The 11/29/2022 15:46, Divya Koppera wrote:
> > 
> > Hi Divya,
> > 
> > > Handle the NULL pointer case
> > >
> > > Fixes New smatch warnings:
> > > drivers/net/phy/micrel.c:2613 lan8814_ptp_probe_once() warn: passing
> > zero to 'PTR_ERR'
> > >
> > > Fixes Old smatch warnings:
> > > drivers/net/phy/micrel.c:1750 ksz886x_cable_test_get_status() error:
> > > uninitialized symbol 'ret'.
> > 
> > Shouldn't you split this patch in 2 different patches, as you fix 2 issues.
> 
> I got these warnings in single mail, so thought of fixing it in one patch. Also, one patch has single line change so did this way.
> Yeah, splitting sense good, will do in next revision.
> 
> > Also any reason why you target net-next and not net? Because I can see the
> > blamed patches on net branch.
> > 
> 
> Initially I targeted for net-next and in second revision I moved to net as it is fix. But I got a comment as below. So again, targeted to net-next.
> 
> "
> > v1 -> v2:
> > - Handled NULL pointer case
> > - Changed subject line with net-next to net
> 
> This is not a genuine bug fix, and so it should target next-next."

That is fine by me.

...

> > >
> > >
> > >  static void lan8814_ptp_init(struct phy_device *phydev)  {
> > > +	struct lan8814_shared_priv *shared_priv = phydev->shared->priv;
> > >  	struct kszphy_priv *priv = phydev->priv;
> > >  	struct kszphy_ptp_priv *ptp_priv = &priv->ptp_priv;
> > >  	u32 temp;
> > >
> > > -	if (!IS_ENABLED(CONFIG_PTP_1588_CLOCK) ||
> > > -	    !IS_ENABLED(CONFIG_NETWORK_PHY_TIMESTAMPING))
> > > +	/* Check if PHC support is missing at the configuration level */
> > > +	if (!shared_priv->ptp_clock)
> > >  		return;

Sorry I forgot to mention this in the previous email.
Can you rename shared_priv to just shared. Because in all the other places
it is used shared and not shared_priv.

-- 
/Horatiu
