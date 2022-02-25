Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA8A4C4BE0
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 18:17:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243548AbiBYRRf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 12:17:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243547AbiBYRRe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 12:17:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E49C21DF0C
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 09:17:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D74C7B832CD
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 17:17:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2073FC340F0;
        Fri, 25 Feb 2022 17:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645809419;
        bh=RreXA7Bmc/8VakrqfoJQ1wIYxg3wtjQYYacft2GxCCk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bqAgH5sluJchauddxOusKfTJi83h2L7pbN6gWGvUdM0rzhjAmIUYS3PDUu9Qba1Zy
         xA0U+7OdGJ8WyK4AXwqK/61bNBYPSw55UerDEgTFIQ9WaosyNjyDbNM9RvYhskTdOi
         k4341Lrmg/KZ7Xvvpi2U5pFVcbfu2vj3jK035gqEi7wCcVjhMGU8ScAOuOBuIfeNVS
         1jfSX8ebXyvgSZqzq0hXbr9hsLsdvzJq8BX+6ucFyRyfADNRKffNWdWlO9ONJOjyoc
         IqFTB1GYzCtNf5qw9JX/3T1y272cahpSA23IXuVjmpCoZ7N9eZ39SeSoFxx0CXgy/5
         jY39wm+22m27Q==
Date:   Fri, 25 Feb 2022 18:16:53 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 1/4] net: dsa: ocelot: populate
 supported_interfaces
Message-ID: <20220225181653.00708f13@thinkpad>
In-Reply-To: <YhkEeENNuIXRkCD7@shell.armlinux.org.uk>
References: <YhkBfuRJkOG9gVZR@shell.armlinux.org.uk>
        <E1nNdJV-00AsoS-Qi@rmk-PC.armlinux.org.uk>
        <20220225162530.cnt4da7zpo6gxl4z@skbuf>
        <YhkEeENNuIXRkCD7@shell.armlinux.org.uk>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 25 Feb 2022 16:31:52 +0000
"Russell King (Oracle)" <linux@armlinux.org.uk> wrote:

> On Fri, Feb 25, 2022 at 04:25:30PM +0000, Vladimir Oltean wrote:
> > On Fri, Feb 25, 2022 at 04:19:25PM +0000, Russell King (Oracle) wrote: =
=20
> > > Populate the supported interfaces bitmap for the Ocelot DSA switches.
> > >=20
> > > Since all sub-drivers only support a single interface mode, defined by
> > > ocelot_port->phy_mode, we can handle this in the main driver code
> > > without reference to the sub-driver.
> > >=20
> > > Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> > > --- =20
> >=20
> > Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com> =20
>=20
> Brilliant, thanks.
>=20
> This is the final driver in net-next that was making use of
> phylink_set_pcs(), so once this series is merged, that function will
> only be used by phylink internally. The next patch I have in the queue
> is to remove that function.
>=20
> Marek Beh=C3=BAn will be very happy to see phylink_set_pcs() gone.

Yes, finally we can convert mv88e6xxx fully :)
