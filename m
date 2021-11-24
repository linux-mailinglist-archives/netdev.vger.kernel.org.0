Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C19BB45C8F2
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 16:41:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240826AbhKXPo7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 10:44:59 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:59927 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241230AbhKXPon (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 10:44:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1637768493; x=1669304493;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ML7hOylMDD0IdcJ2GN3+YM8C+2QI4EfncicRU7TxBwk=;
  b=DhKw5dL8ikTTW5O2cL0GuqGUYPjYxIG3xFMYwC7W1ynLc3VaEQT7hJGd
   p3ztfflDMyOMpYigsaDfkewgVSUhCO+4Ia03SMt15PeWjk1Kl5LHieua0
   qXDQPR5/HJDoQObwpU2eZf60trqnoBxJ+0uQbx8v+jtJK1dMd1Pk7Tp3P
   HSFuMjJnc5dhlmPRwvFmAXpArz8WBzspSduf9+v8icay6TlIRVLUfz2Yk
   zJxzlmYuF/tohTJ57SaP9RU5f4YvpsaWg+bMHTjIHb0JwN3pJlDpvLgiT
   iEqTHPh+ZpwROHx2DGD8gTkQwPmlVxKsFbWfMOP8Q7w9yTqluD5bg3qAQ
   g==;
IronPort-SDR: LPRhALNPyeBcxVcVAqU8wnDhlrHHoUIz7xMWn7oiC1BEh0hEmPjmIH62nQNBP2yJI9s1z//E1u
 m39YbqNXLADrEeBqjUNhwLv3EqNoAc8N+NJ0SKYsLjGBfaE8cOIlVaXoKy3AjIjMBb/WNAKBmo
 mFdyJrIAj1eJ/MsEatXBCnCjhaKoMMdGUNmqBYaB38Tbd69IRV8Hp6dXmndFH89fFoLHz4CQ91
 jmLyz+IFnKqacmgVuaBxXQkvMvCyjTfJQIcwTXIpfDRi6Tr8Dxct8Tyc2e9irLXmIZ4r0PSX4P
 lbuNtQg0Gym2d3AkDSinzIVe
X-IronPort-AV: E=Sophos;i="5.87,260,1631602800"; 
   d="scan'208";a="77473901"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Nov 2021 08:41:31 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Wed, 24 Nov 2021 08:41:30 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2176.14 via Frontend
 Transport; Wed, 24 Nov 2021 08:41:30 -0700
Date:   Wed, 24 Nov 2021 16:43:23 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <p.zabel@pengutronix.de>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v3 3/6] net: lan966x: add port module support
Message-ID: <20211124154323.44liimrwzthsh547@soft-dev3-1.localhost>
References: <20211124083915.2223065-1-horatiu.vultur@microchip.com>
 <20211124083915.2223065-4-horatiu.vultur@microchip.com>
 <YZ4SB/wX6UT3zrEV@shell.armlinux.org.uk>
 <20211124145800.my4niep3sifqpg55@soft-dev3-1.localhost>
 <YZ5UXdiNNf011skU@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <YZ5UXdiNNf011skU@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 11/24/2021 15:03, Russell King (Oracle) wrote:
> 
> On Wed, Nov 24, 2021 at 03:58:00PM +0100, Horatiu Vultur wrote:
> > > This doesn't look like the correct sequence to me. Shouldn't the net
> > > device be unregistered first, which will take the port down by doing
> > > so and make it unavailable to userspace to further manipulate. Then
> > > we should start tearing other stuff down such as destroying phylink
> > > and disabling interrupts (in the caller of this.)
> >
> > I can change the order as you suggested.
> > Regarding the interrupts, shouldn't they be first disable and then do
> > all the teardown?
> 
> Depends if you need them disabled before you do the teardown. However,
> what would be the effect of disabling interrupts while the user still
> has the ability to interact with the port - that is the main point.
> 
> Generally the teardown should be the reverse of setup - where it's now
> accepted that all setup should be done prior to user publication. So,
> user interfaces should be removed and then teardown should proceed.

Yes, I get your point. I will remove the interface and then I will
disable the interrupts.

> 
> > > What is the difference between "portmode" and "phy_mode"? Does it matter
> > > if port->config.phy_mode get zeroed when lan966x_port_pcs_set() is
> > > called from lan966x_pcs_config()? It looks to me like the first call
> > > will clear phy_mode, setting it to PHY_INTERFACE_MODE_NA from that point
> > > on.
> >
> > The purpose was to use portmode to configure the MAC and the phy_mode
> > to configure the serdes. There are small issues regarding this which
> > will be fix in the next series also I will add some comments just to
> > make it clear.
> >
> > Actually, port->config.phy_mode will not get zeroed. Because right after
> > the memset it follows: 'config = port->config'.
> 
> Ah, missed that, thanks. However, why should portmode and phy_mode be
> different?

Because the serdes knows only few modes(QSGMII, SGMII, GMII) and this
information will come from DT. So I would like to have one variable that
will configure the serdes ('phy_mode') and one will configure the MAC
('portmode').

> 
> > Actually, like you mentioned it needs to be link partner's advertisement
> > so that code can be simplified more:
> >
> >          if (DEV_PCS1G_ANEG_STATUS_ANEG_COMPLETE_GET(val)) {
> >                  state->an_complete = true;
> >
> >                  bmsr |= state->link ? BMSR_LSTATUS : 0;
> >                  bmsr |= BMSR_ANEGCOMPLETE;
> >
> >                  lp_adv = DEV_PCS1G_ANEG_STATUS_LP_ADV_GET(val);
> >                  phylink_mii_c22_pcs_decode_state(state, bmsr, lp_adv);
> >          }
> >
> > Because inside phylink_mii_c22_pcs_decode_state, more precisely in
> > phylink_decode_c37_work, state->advertising will have the local
> > advertising.
> 
> Correct.
> 
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

-- 
/Horatiu
