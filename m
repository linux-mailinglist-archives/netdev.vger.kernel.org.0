Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5C8917292A
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 21:03:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730335AbgB0UC4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 15:02:56 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:44620 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729441AbgB0UC4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 15:02:56 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AE1E5121793E1;
        Thu, 27 Feb 2020 12:02:54 -0800 (PST)
Date:   Thu, 27 Feb 2020 12:02:54 -0800 (PST)
Message-Id: <20200227.120254.241641132362203475.davem@davemloft.net>
To:     linux@armlinux.org.uk
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux-doc@vger.kernel.org, thomas.petazzoni@bootlin.com,
        ioana.ciornei@nxp.com, linux-stm32@st-md-mailman.stormreply.com,
        corbet@lwn.net, michal.simek@xilinx.com, joabreu@synopsys.com,
        kuba@kernel.org, Mark-MC.Lee@mediatek.com, sean.wang@mediatek.com,
        alexandre.torgue@st.com, hauke@hauke-m.de,
        radhey.shyam.pandey@xilinx.com, linux-mediatek@lists.infradead.org,
        john@phrozen.org, matthias.bgg@gmail.com, peppe.cavallaro@st.com,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        vivien.didelot@gmail.com, mcoquelin.stm32@gmail.com,
        olteanv@gmail.com, nbd@nbd.name
Subject: Re: [PATCH net-next v2 0/8] rework phylink interface for split
 MAC/PCS support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200226102312.GX25745@shell.armlinux.org.uk>
References: <20200226102312.GX25745@shell.armlinux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 27 Feb 2020 12:02:55 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Date: Wed, 26 Feb 2020 10:23:12 +0000

> The following series changes the phylink interface to allow us to
> better support split MAC / MAC PCS setups.  The fundamental change
> required for this turns out to be quite simple.
> 
> Today, mac_config() is used for everything to do with setting the
> parameters for the MAC, and mac_link_up() is used to inform the
> MAC driver that the link is now up (and so to allow packet flow.)
> mac_config() also has had a few implementation issues, with folk
> who believe that members such as "speed" and "duplex" are always
> valid, where "link" gets used inappropriately, etc.
> 
> With the proposed patches, all this changes subtly - but in a
> backwards compatible way at this stage.
> 
> We pass the the full resolved link state (speed, duplex, pause) to
> mac_link_up(), and it is now guaranteed that these parameters to
> this function will always be valid (no more SPEED_UNKNOWN or
> DUPLEX_UNKNOWN here - unless phylink is fed with such things.)
> 
> Drivers should convert over to using the state in mac_link_up()
> rather than configuring the speed, duplex and pause in the
> mac_config() method. The patch series includes a number of MAC
> drivers which I've thought have been easy targets - I've left the
> remainder as I think they need maintainer input. However, *all*
> drivers will need conversion for future phylink development.
> 
> v2: add ocelot/felix and qca/ar9331 DSA drivers to patch 2, add
>   received tested-by so far.

In order to end the storm in a teacup, I've applied this series.

:-)

Thanks Russell.
