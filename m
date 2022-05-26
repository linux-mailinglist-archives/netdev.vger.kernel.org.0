Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E71AE5355D0
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 23:46:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346690AbiEZVq3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 17:46:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345621AbiEZVq2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 17:46:28 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2FE35FFD;
        Thu, 26 May 2022 14:46:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=sfRMVadM5DFvb9UkztUPJSueAUQ271E9by4MUwweJIo=; b=grlE4T31u4JkQQZ4JcZrTN7AfI
        X7vawcJ+xqbIzLvHhQ6G/2VB+nkK1jfwl8c/PGI4ZCIdAD6ZsvbTXkxDsd15G6ys1NuFn7nfMQeVS
        wKlxNnjNrodkPlzw4l3wiRj51HHnEcu2nrxasnjZLiLAdJdNvM35TJYAOPeoYfijWxuQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nuLJD-004ORC-W8; Thu, 26 May 2022 23:46:19 +0200
Date:   Thu, 26 May 2022 23:46:19 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Piyush Malgujar <pmalgujar@marvell.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chandrakala Chavva <cchavva@marvell.com>,
        Damian Eppel <deppel@marvell.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH] Marvell MDIO clock related changes.
Message-ID: <Yo/1K5KYivuJM6CA@lunn.ch>
References: <CH0PR18MB4193CF9786F80101D08A2431A3FC9@CH0PR18MB4193.namprd18.prod.outlook.com>
 <Ymv1NU6hvCpAo5+F@lunn.ch>
 <20220526105720.GA4922@Dell2s-9>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220526105720.GA4922@Dell2s-9>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 26, 2022 at 03:57:20AM -0700, Piyush Malgujar wrote:
> On Fri, Apr 29, 2022 at 04:24:53PM +0200, Andrew Lunn wrote:
> > > > > 2) Marvell MDIO clock frequency attribute change:
> > > > > This MDIO change provides an option for user to have the bus speed set
> > > > > to their needs which is otherwise set to default(3.125 MHz).
> > > > 
> > > > Please read 802.3 Clause 22. The default should be 2.5MHz.
> > > > 
> > > 
> > > These changes are only specific to Marvell Octeon family.
> > 
> > Are you saying the Marvell Octeon family decide to ignore 802.3?  Have
> > you tested every possible PHY that could be connected to this MDIO bus
> > and they all work for 3.125MHz, even though 802.3 says they only need
> > to support up to 2.5Mhz?
> > 
> >      Andrew
> 
> Hi Andrew,
> 
> Yes, but as for Marvell Octeon family it defaults to 3.125 MHz and this
> driver is already existing in the kernel.
> This patch is not changing that, only adding support to configure
> clock-freq from DTS.
> Also, following PHYs have been verified with it:
> PHY_MARVELL_88E1548,
> PHY_MARVELL_5123,
> PHY_MARVELL_5113,
> PHY_MARVELL_6141,
> PHY_MARVELL_88E1514,
> PHY_MARVELL_3310,
> PHY_VITESSE_8574

So if you want to ignore 802.3, please make it very clear in the DT
binding that the default is 3.125MHz, not 2.5Mhz which the standard
requires.

As you say, 3.125Mhz will work for some PHYs. And it will fail for
other PHYs.

	Andrew

