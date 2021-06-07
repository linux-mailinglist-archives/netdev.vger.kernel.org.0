Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B557539D612
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 09:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbhFGHgR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 03:36:17 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:25183 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbhFGHgQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 03:36:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1623051265; x=1654587265;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rOUraZ4miGFonwbmtDBoybUSd5NfVjz185H9UOStUOY=;
  b=HsswG3hExC+FuI6/UiVrBPPRzCAUjBMd+zpq+sz7UnAEJv3KsDyvgoQF
   qXyw92JINkIc1xHcEaQTGsg9kbG3EMDbB3MoTVV4h/ExAAFys9Im7L/44
   GUm/UV8povJ4PfMmAZr+lN9g4LuIUB83jQ2yj/wBBs1CR5b6+gmmZyqlO
   n5fdBHrlGl8Li3WMvRdRhBJiLM44kudfHe9cRxR+vC95fF/OtuLitU+Pt
   JHMq66AvhwJJbbc89PJh2ijQeG2g+cRhlSOleWJEG67k8MiSNiJiqV3fQ
   yco3wB3oAG8Q9Pt4IqVVTAe48KffJc7GvUQpS6nvINq3Yp2cvmh7+Fzm9
   g==;
IronPort-SDR: Bi8UACmM/jTaB0+5EJgKekHNFR2q5yg6HIUWtidUYZhvxfzhfHhzEzK/quVAU83sF5ftLJ1Syb
 8T+eZXHqbtB3fQjBO43ycJGyy9PgM6vnEfqq6SnVw6Jr7pkvVYu0ViMWwufItu81Zc17hGH6G7
 Q+dtb9rHatPpDTmIYhLFo27bYh/GTYAY27AItH4AtHkakjqjgrXr7ekL7FWYjTRdb+wuBNHjDs
 p93vNg5xa6qSs8O7WQJX1ukWwDxZkJP7qGDAk9JBWGBYIqt0VG9wG57kcwCqICH9sysmJgfvdL
 aCw=
X-IronPort-AV: E=Sophos;i="5.83,254,1616482800"; 
   d="scan'208";a="58052269"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Jun 2021 00:34:25 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 7 Jun 2021 00:34:24 -0700
Received: from den-her-m31857h.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Mon, 7 Jun 2021 00:34:21 -0700
Message-ID: <b215ecea90794688906fb0a6d34636e1e8c1fc3e.camel@microchip.com>
Subject: Re: [PATCH net-next v3 02/10] net: sparx5: add the basic sparx5
 driver
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Philipp Zabel <p.zabel@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Andrew Lunn <andrew@lunn.ch>, Russell King <linux@armlinux.org.uk>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "Alexandre Belloni" <alexandre.belloni@bootlin.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Mark Einon <mark.einon@gmail.com>,
        "Masahiro Yamada" <masahiroy@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Simon Horman <simon.horman@netronome.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>
Date:   Mon, 7 Jun 2021 09:34:20 +0200
In-Reply-To: <6a1500fb623e6513e39a468ac53d1caf6a2cf7c5.camel@pengutronix.de>
References: <20210604085600.3014532-1-steen.hegelund@microchip.com>
         <20210604085600.3014532-3-steen.hegelund@microchip.com>
         <6a1500fb623e6513e39a468ac53d1caf6a2cf7c5.camel@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Philipp,

Thanks for your comments.

On Fri, 2021-06-04 at 11:28 +0200, Philipp Zabel wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> Hi Steen,
> 
> On Fri, 2021-06-04 at 10:55 +0200, Steen Hegelund wrote:
> > This adds the Sparx5 basic SwitchDev driver framework with IO range
> > mapping, switch device detection and core clock configuration.
> > 
> > Support for ports, phylink, netdev, mactable etc. are in the following
> > patches.
> > 
> > Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
> > Signed-off-by: Bjarni Jonasson <bjarni.jonasson@microchip.com>
> > Signed-off-by: Lars Povlsen <lars.povlsen@microchip.com>
> > ---
> >  drivers/net/ethernet/microchip/Kconfig        |    2 +
> >  drivers/net/ethernet/microchip/Makefile       |    2 +
> >  drivers/net/ethernet/microchip/sparx5/Kconfig |    9 +
> >  .../net/ethernet/microchip/sparx5/Makefile    |    8 +
> >  .../ethernet/microchip/sparx5/sparx5_main.c   |  746 +++
> >  .../ethernet/microchip/sparx5/sparx5_main.h   |  273 +
> >  .../microchip/sparx5/sparx5_main_regs.h       | 4642 +++++++++++++++++
> >  7 files changed, 5682 insertions(+)
> >  create mode 100644 drivers/net/ethernet/microchip/sparx5/Kconfig
> >  create mode 100644 drivers/net/ethernet/microchip/sparx5/Makefile
> >  create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_main.c
> >  create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_main.h
> >  create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_main_regs.h
> > 
> [...]
> > diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
> > b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
> > new file mode 100644
> > index 000000000000..73beb85bc52d
> > --- /dev/null
> > +++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
> > @@ -0,0 +1,746 @@
> [...]
> > +static int mchp_sparx5_probe(struct platform_device *pdev)
> > +{
> [...]
> > +
> > +     sparx5->reset = devm_reset_control_get_shared(&pdev->dev, "switch");
> > +     if (IS_ERR(sparx5->reset)) {
> 
> Could you use devm_reset_control_get_optional_shared() instead of
> ignoring this error? That would just return NULL if there's no "switch"
> reset specified in the device tree.

Yes.  That sounds like a good idea.  I assume that the devm_reset_control_get_optional_shared()
would also return null if another driver has already performed the reset?

> 
> > +             dev_warn(sparx5->dev, "Could not obtain reset control: %ld\n",
> > +                      PTR_ERR(sparx5->reset));
> > +             sparx5->reset = NULL;
> > +     } else {
> > +             reset_control_reset(sparx5->reset);
> > +     }
> 
> If this is the only place the reset is used, I'd remove it from struct
> sparx5 and use a local variable instead.

Yes.  I will do that.

> 
> regards
> Philipp


Best 

-- 
BR
Steen

-=-=-=-=-=-=-=-=-=-=-=-=-=-=
steen.hegelund@microchip.com


