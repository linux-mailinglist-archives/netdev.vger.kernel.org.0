Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B202535F913
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 18:42:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234053AbhDNQkv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 12:40:51 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50928 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234251AbhDNQit (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 12:38:49 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lWiWr-00GisB-N9; Wed, 14 Apr 2021 18:38:13 +0200
Date:   Wed, 14 Apr 2021 18:38:13 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-omap@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: Re: [PATCH net-next 2/2] net: bridge: switchdev: include local flag
 in FDB notifications
Message-ID: <YHcadT4XhBq7g61Y@lunn.ch>
References: <20210414151540.1808871-1-olteanv@gmail.com>
 <20210414151540.1808871-2-olteanv@gmail.com>
 <YHcRNIgI9lVs6MDj@lunn.ch>
 <20210414160510.zcif6liazjltd2cz@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210414160510.zcif6liazjltd2cz@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 14, 2021 at 07:05:10PM +0300, Vladimir Oltean wrote:
> On Wed, Apr 14, 2021 at 05:58:44PM +0200, Andrew Lunn wrote:
> > > Let us now add the 'is_local' bit to bridge FDB entries, and make all
> > > drivers ignore these entries by their own choice.
> > 
> > Hi Vladimir
> > 
> > This goes to the question about the missing cover letter. Why should
> > drivers get to ignore them, rather than the core? It feels like there
> > should be another patch in the series, where a driver does not
> > actually ignore them, but does something?
> 
> Hi Andrew,
> 
> Bridge fdb entries with the is_local flag are entries which are
> terminated locally and not forwarded. Switchdev drivers might want to be
> notified of these addresses so they can trap them (otherwise, if they
> don't program these entries to hardware, there is no guarantee that they
> will do the right thing with these entries, and they won't be, let's
> say, flooded). Of course, ideally none of the switchdev drivers should
> ignore them, but having access to the is_local bit is the bare minimum
> change that should be done in the bridge layer, before this is even
> possible.
> 
> These 2 changes are actually part of a larger group of changes that
> together form the "RX filtering for DSA" series. I haven't had a lot of
> success with that, so I thought a better approach would be to take it
> step by step. DSA will need to be notified of local FDB entries. For
> now, it ignores them like everybody else. This is supposed to be a
> non-functional patch series because I don't want to spam every switchdev
> maintainer with 15+ DSA RX filtering patches.

This is the sort of information which goes into 0/2. It explains the
big picture 'Why' of the change.

    Andrew
