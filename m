Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BED739E003
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 17:12:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230330AbhFGPOE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 11:14:04 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:10232 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230237AbhFGPOE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 11:14:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1623078734; x=1654614734;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6EQIMxxAgf0RmSKUH5GCq+SVFHM8vHHVsc5Egi0CYL8=;
  b=Iw0jSNZbpMOCKAiyepsRloDQpLQlzx01ZZpZ7om8PqP+4nBqZuTRqvps
   B1xUeXGETrQobezuoRaUaUHAHfqUXJ1+ZCsKXMUGrzdlXreCOovaEse9X
   03Mrmib2hiv4fNvor3HEuofSP35D7DRsNkJirfG5EmhGEOxiCYtWat55h
   7Ne0LtcMD292lCcIaKianyBUdCq8XELxUAIPbjVINyf8cNxMErgAKkXL6
   +hlxwTPEMxqaqvQWrhZwIMRdOy6/MUBGr999jjWm6LfSUDlcsZpeR3GNr
   hik9WT7FfWEecw7/VLEkD/cD3IR/iBTnkP8YmSAbgkbVOpAXGuHIFnQsv
   w==;
IronPort-SDR: RuSumJAdpHnJUAoLWUkKU81lsD/piJVqPhvfWW4Ch/rxQj9ME2HFnp4xDIO8RCvlMlOOC8z2g6
 EmSXdc0AGaqTsbm4E5upOo2bhETO0gt4vyH9TwZoimICZmqoEjV4uGjRXnbWMba1bSs7hDM1e0
 ODMeZyVSq1pjGbnYE/2ALaX3WSCnADBFMzH4pcT7INNcGf2X9VJh7cbhKctoR93CDPXgoH1u3B
 rLe5S05477u6j+PMdDh6/xS0AYGpTaRwolr+YeieqhP9HylWFmXBaxqTryDqf9Kt5I+lUPN4fI
 BuU=
X-IronPort-AV: E=Sophos;i="5.83,255,1616482800"; 
   d="scan'208";a="123799151"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Jun 2021 08:12:13 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 7 Jun 2021 08:12:12 -0700
Received: from den-her-m31857h.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Mon, 7 Jun 2021 08:12:08 -0700
Message-ID: <7abe6b779c1432d9dfd2fc791d70c9443caec066.camel@microchip.com>
Subject: Re: [PATCH net-next v3 03/10] net: sparx5: add hostmode with
 phylink support
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Mark Einon <mark.einon@gmail.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        "Simon Horman" <simon.horman@netronome.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>
Date:   Mon, 7 Jun 2021 17:12:07 +0200
In-Reply-To: <20210607130924.GE22278@shell.armlinux.org.uk>
References: <20210604085600.3014532-1-steen.hegelund@microchip.com>
         <20210604085600.3014532-4-steen.hegelund@microchip.com>
         <20210607091536.GA30436@shell.armlinux.org.uk>
         <9f4fad323e17c8ba6ebde728fcc99c87dd06fc75.camel@microchip.com>
         <20210607130924.GE22278@shell.armlinux.org.uk>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

Thanks for your comments,

On Mon, 2021-06-07 at 14:09 +0100, Russell King (Oracle) wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> On Mon, Jun 07, 2021 at 02:45:01PM +0200, Steen Hegelund wrote:
> > Hi Russell,
> > 
> > Thanks for your comments.
> > 
> > On Mon, 2021-06-07 at 10:15 +0100, Russell King (Oracle) wrote:
> > > 3) I really don't get what's going on with setting the port mode to
> > >    2500base-X and 1000base-X here when state->interface is 10GBASER.
> > 
> > The high speed interfaces (> 2.5G) do not support any in-band signalling, so the only way that
> > e.g a
> > 10G interface running at 2.5G will be able to link up with its partner is if both ends configure
> > the
> > speed manually via ethtool.
> 
> We really should not have drivers hacking around in this way. If we want
> to operate in 2500base-x or 1000base-x, then that is what phylink should
> be telling the MAC driver. The MAC driver should not be making these
> decisions in its mac_config() callback. Doing so makes a joke of kernel
> programming.

I have this scenario where two Sparx5 Devices are connected via a 25G DAC cable.
Sparx5 Device A has the cable connected to one of its 25G Serdes devices, but Sparx5 Device B has
the cable connected to one of its 10G Serdes devices.

By default the Sparx5 A device will configure the link to use a speed of 25G, but the Sparx5 device
B will configure the link speed to 10G, so the link will remain down, as the two devices cannot
communicate.

So to fix this the user will have to manually change the speed of the link on Device A to be 10G
using ethtool.

I may have misunderstood the usage of the mac_config callback, but then where would the driver then
use the speed information from the user to configure the Serdes?

> 
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!


-- 
BR
Steen

-=-=-=-=-=-=-=-=-=-=-=-=-=-=
steen.hegelund@microchip.com


