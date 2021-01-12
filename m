Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D066A2F3430
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 16:34:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391485AbhALPc5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 10:32:57 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:24472 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391148AbhALPc4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 10:32:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1610465575; x=1642001575;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=b6443gkHqeUmG6ZxvtYlqEeXwu3RP9PfEtGflXLJ3x0=;
  b=XsbKFIos0ulLSAOt5nxOi8djMuxOjmkwNr9cJD3g0V9O3cLdvW+u3dhP
   2oMlnpxO47lkuu4cC4NVWdT5f2xzHH1tSQ6FNBSKNxsYD01R4BzrcnZ4q
   k7086CrrisvJZNpUvuPtFgQBAg6iIis9e4oaM9YoPU8ARej/CYtLz2W2T
   3LlDSbR0MXv+/UU8dbl+P6goP4f4QbpIxw/43fiwCu14FZettNP+wVCpy
   jOFIQAb2B9Bv5CqIyBE1HSsXw7UPAQQQBGZ/GrNCAWR0HRe/sCWemArQQ
   VYiy9n4/gAzCk3jPYdawRM5xZJXhH3C4jA1sLqvf4p6Un/RYx273Gntcv
   g==;
IronPort-SDR: qJOHv2FfZhql5uoaZIGOt1yIbIeWA2Kl2cGFCdGG5w2eM59TxLNnU/oAXoIQ18dRJBFDKwJRyw
 gtjJbrEUuCATCT6ATk7WgimuqjpQx9cFNMkA5GU2uM/1+OaFWwgC13RyW0jqLUmmKMcSZLccbt
 fy87kgYueyx0t80IHf9yo5Y/07n6pZyc914u35pHDFH/Z8cpp7uQtuzuVOc2YwCEqTivp0spzH
 Idi6IJBrFgBnChv4iPEYorKL0a/K97fjWS4NI1CXBf6e617tX8Q0XOKEhxwF+6/1kgV3cuBdkE
 4zs=
X-IronPort-AV: E=Sophos;i="5.79,341,1602572400"; 
   d="scan'208";a="105694136"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Jan 2021 08:31:39 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 12 Jan 2021 08:31:38 -0700
Received: from soft-dev2 (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Tue, 12 Jan 2021 08:31:37 -0700
Message-ID: <d7f934f9b4f45661e41fe7a35a044ea5e8ec1cad.camel@microchip.com>
Subject: Re: [PATCH v1 2/2] sfp: add support for 100 base-x SFPs
From:   Bjarni Jonasson <bjarni.jonasson@microchip.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        UNGLinuxDriver <UNGLinuxDriver@microchip.com>
Date:   Tue, 12 Jan 2021 16:31:36 +0100
In-Reply-To: <20210111142245.GW1551@shell.armlinux.org.uk>
References: <20210111130657.10703-1-bjarni.jonasson@microchip.com>
         <20210111130657.10703-3-bjarni.jonasson@microchip.com>
         <20210111142245.GW1551@shell.armlinux.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-01-11 at 14:22 +0000, Russell King - ARM Linux admin
wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you
> know the content is safe
> 
> On Mon, Jan 11, 2021 at 02:06:57PM +0100, Bjarni Jonasson wrote:
> > Add support for 100Base-FX, 100Base-LX, 100Base-PX and 100Base-BX10 
> > modules
> > This is needed for Sparx-5 switch.
> > 
> > Signed-off-by: Bjarni Jonasson <bjarni.jonasson@microchip.com>
> > ---
> >  drivers/net/phy/sfp-bus.c | 9 +++++++++
> >  1 file changed, 9 insertions(+)
> > 
> > diff --git a/drivers/net/phy/sfp-bus.c b/drivers/net/phy/sfp-bus.c
> > index 58014feedf6c..b2a9ee3dd28e 100644
> > --- a/drivers/net/phy/sfp-bus.c
> > +++ b/drivers/net/phy/sfp-bus.c
> > @@ -265,6 +265,12 @@ void sfp_parse_support(struct sfp_bus *bus,
> > const struct sfp_eeprom_id *id,
> >           br_min <= 1300 && br_max >= 1200)
> >               phylink_set(modes, 1000baseX_Full);
> > 
> > +     /* 100Base-FX, 100Base-LX, 100Base-PX, 100Base-BX10 */
> > +     if (id->base.e100_base_fx || id->base.e100_base_lx)
> > +             phylink_set(modes, 100baseFX_Full);
> > +     if ((id->base.e_base_px || id->base.e_base_bx10) && br_nom ==
> > 100)
> > +             phylink_set(modes, 100baseFX_Full);
> 
> Do you have any modules that identify as PX or BX10 modules? What if
> their range of speeds covers 100M - you're only checking the nominal
> speed here.

I have one module that is identified as BX10 (HP-SFP-100FX-J9054C), but
it seems that the PX should also be there according to the standard.

All 100fx modules I've tested had br_min == br_max == br_nom == 100 so
I really don't know what else to use.

> Note that this will likely conflict with changes I submitted over the
> weekend, and it really needs to be done _before_ the comment about
> "If we haven't discovered any modes", not below.

Not sure what you mean, the patch is above the comment (line 265 vs
345).  The patch is on top of 5.10, is that the issue?

> 
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

Rgds
--
Bjarni Jonasson
Microchip



