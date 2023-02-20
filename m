Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C00E69D0AF
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 16:32:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231799AbjBTPcp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 10:32:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231806AbjBTPco (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 10:32:44 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E16041C319;
        Mon, 20 Feb 2023 07:32:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=YqY0AAw8riSSMT1MSAND09XlddiVrmneE8nDMUZY0rE=; b=5nz5/xbNNa4t2G2oW0YiFmTsPo
        JfJYP3M2rfJpRkixl89OKKASzTSJtJ6nVqTEvc1MeCtodmoCWRW6oX9fZmuXffSfhrP3v+IUX6z7d
        41Lz+oPOEuIB/9r1FKuHMtLcvC/Hf3vYYj656HGRb0hxLkaXIfFepGTNX2RDv5S1Ja9Q=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pU89U-005WEG-AB; Mon, 20 Feb 2023 16:32:28 +0100
Date:   Mon, 20 Feb 2023 16:32:28 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1 3/4] net: phy: do not force EEE support
Message-ID: <Y/OSjLGWRihONXX4@lunn.ch>
References: <20230220135605.1136137-1-o.rempel@pengutronix.de>
 <20230220135605.1136137-4-o.rempel@pengutronix.de>
 <Y/OBPZRGM+viGp+8@shell.armlinux.org.uk>
 <20230220150840.GB19238@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230220150840.GB19238@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > >  		if (data->advertised)
> > > -			adv[0] = data->advertised;
> > > -		else
> > > -			linkmode_copy(adv, phydev->supported_eee);
> > > +			phydev->advertising_eee[0] = data->advertised;
> > 
> > Is there a reason not to use ethtool_convert_legacy_u32_to_link_mode()?
> > I'm guessing this will be more efficient.
> 
> Or at leas more readable. I'll update it.

I read that and had a similar reaction to Russell. Please do use the
helper.

	Andrew
