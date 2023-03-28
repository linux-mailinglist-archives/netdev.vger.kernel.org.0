Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2CC66CBFC6
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 14:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230249AbjC1MvO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 08:51:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232476AbjC1Mus (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 08:50:48 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D7F7AF17;
        Tue, 28 Mar 2023 05:50:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=P6joxeZ+/Z5Je3YPeAiGPCYb1tL90ic3Y4SI8846NrA=; b=Jy2AIHdIlc2pwsIA+sGZZcSouo
        ztGdOLTaUcSujVIi6o0SDO2XpaW424polPsIHBdzQ/0u2dGMq6E6/dV7URz5bI+8+KnKyUlVSmSQC
        hteZC9RmTO2/GZSKCEBzOKnF75PblqGAOw6BhRTXK+uV9o4bfh2uYAf23xp7PaFpFyD0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ph8ly-008e1T-8m; Tue, 28 Mar 2023 14:49:58 +0200
Date:   Tue, 28 Mar 2023 14:49:58 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Wei Fang <wei.fang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Amit Cohen <amcohen@nvidia.com>, Gal Pressman <gal@nvidia.com>,
        Alexandru Tachici <alexandru.tachici@analog.com>,
        Piergiorgio Beruto <piergiorgio.beruto@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next v2 6/8] net: phy: at803x: Make SmartEEE support
 optional and configurable via ethtool
Message-ID: <9557a753-7ba5-41aa-84e2-f449c92d7d16@lunn.ch>
References: <20230327142202.3754446-1-o.rempel@pengutronix.de>
 <20230327142202.3754446-7-o.rempel@pengutronix.de>
 <20230328120514.GF15196@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230328120514.GF15196@pengutronix.de>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > @@ -302,6 +312,8 @@ struct at803x_priv {
> >  	u8 smarteee_lpi_tw_100m;
> >  	bool is_fiber;
> >  	bool is_1000basex;
> > +	bool tx_lpi_on;
> 
> @Andrew, this variable can be replace by your phydev->tx_lpi_enabled
> variable. Should I wait for your patches went mainline?

I was wondering about the overlap and the best way to address it.

My patchset is also a bit big, and getting bigger. So it might make
sense to split out some of the bits you need and get them merged
first.

You need the MAC indicating it is EEE capable. I don't store that
information explicitly, but that is a quick simple change. You also
need phydev->tx_lpi_enabled. Anything else?

     Andrew
