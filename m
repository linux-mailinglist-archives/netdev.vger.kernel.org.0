Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D9B0FA42D
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 03:16:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729815AbfKMCOr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 21:14:47 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:37164 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727020AbfKMCOn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 21:14:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=WyIrAktJq/IIqELhpAvtRtNGn8eLOOamZYRtbyKaiEc=; b=1kkyrsk+9S6/UIgFHb/jph1RFv
        DUndOy3nXT3No9+4QMOMcMqiWN7lM5ZCVhrB7cZ59QLJub1M3vDS7jxHosgY4U2litkoZ/5SZQ32k
        q5a+Pykk9pJ6e5DigZofT5aOVLHEKHKcx9GOMsxLveZECTgOLFLagJieKTQcMKPoAxTw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iUiB2-0004bt-0P; Wed, 13 Nov 2019 03:14:36 +0100
Date:   Wed, 13 Nov 2019 03:14:36 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     jakub.kicinski@netronome.com, davem@davemloft.net,
        alexandre.belloni@bootlin.com, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, joergen.andreasen@microchip.com,
        allan.nielsen@microchip.com, horatiu.vultur@microchip.com,
        claudiu.manoil@nxp.com, netdev@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next 12/12] net: dsa: vitesse: add tagger for
 Ocelot/Felix switches
Message-ID: <20191113021436.GB16688@lunn.ch>
References: <20191112124420.6225-1-olteanv@gmail.com>
 <20191112124420.6225-13-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191112124420.6225-13-olteanv@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> --- a/drivers/net/dsa/vitesse/felix.c
> +++ b/drivers/net/dsa/vitesse/felix.c
> @@ -12,7 +12,7 @@
>  static enum dsa_tag_protocol felix_get_tag_protocol(struct dsa_switch *ds,
>  						    int port)
>  {
> -	return DSA_TAG_PROTO_NONE;
> +	return DSA_TAG_PROTO_OCELOT;
>  }

I would swap the order of these and the previous patch so you can
avoid this.

> --- a/net/dsa/Kconfig
> +++ b/net/dsa/Kconfig
> @@ -67,6 +67,13 @@ config NET_DSA_TAG_EDSA
>  	  Say Y or M if you want to enable support for tagging frames for the
>  	  Marvell switches which use EtherType DSA headers.
>  
> +config NET_DSA_TAG_OCELOT
> +	tristate "Tag driver for Vitesse Ocelot/Felix switch"
> +	select PACKING
> +	help
> +	  Say Y or M if you want to enable support for tagging frames with the
> +	  Vitesse Ocelot (VSC7514) and Felix (VSC9959) switching cores.
> +
>  config NET_DSA_TAG_MTK
>  	tristate "Tag driver for Mediatek switches"
>  	help

This file is sorted so that the tristate strings appear in alphabetic
order when you do make menuconfig. This mean this entry to too early, and
NXP SJA1105 so too late. :-(

    Andrew
