Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1E192F6278
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 14:56:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728858AbhANNyy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 08:54:54 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:40502 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726236AbhANNyy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Jan 2021 08:54:54 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l034l-000Yvz-TJ; Thu, 14 Jan 2021 14:54:11 +0100
Date:   Thu, 14 Jan 2021 14:54:11 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Lukas Wunner <lukas@wunner.de>
Subject: Re: [PATCH net-next] net: ks8851: Connect and start/stop the
 internal PHY
Message-ID: <YABNA+0aPI42lJLh@lunn.ch>
References: <20210111125337.36513-1-marex@denx.de>
 <X/xlDTUQTLgVoaUE@lunn.ch>
 <dd43881e-edff-74fd-dbcb-26c5ca5b6e72@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd43881e-edff-74fd-dbcb-26c5ca5b6e72@denx.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 12, 2021 at 11:28:00PM +0100, Marek Vasut wrote:
> On 1/11/21 3:47 PM, Andrew Lunn wrote:
> > On Mon, Jan 11, 2021 at 01:53:37PM +0100, Marek Vasut wrote:
> > > Unless the internal PHY is connected and started, the phylib will not
> > > poll the PHY for state and produce state updates. Connect the PHY and
> > > start/stop it.
> > 
> > Hi Marek
> > 
> > Please continue the conversion and remove all mii_calls.
> > 
> > ks8851_set_link_ksettings() calling mii_ethtool_set_link_ksettings()
> > is not good, phylib will not know about changes which we made to the
> > PHY etc.
> 
> Hi,
> 
> I noticed a couple of drivers implement both the mii and mdiobus options.

Which ones?

Simply getting the link status might be safe, but if
set_link_ksettings() or get_link_ksettings() is used, phylib is going
to get confused when the PHY is changed without it knowing.. So please
do remove all the mii calls as part of the patchset.

	Andrew
