Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC3DB1D9519
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 13:18:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728626AbgESLSp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 07:18:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:55720 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726157AbgESLSp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 May 2020 07:18:45 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 54856AE63;
        Tue, 19 May 2020 11:18:46 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 6CC1860302; Tue, 19 May 2020 13:18:42 +0200 (CEST)
Date:   Tue, 19 May 2020 13:18:42 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        David Jander <david@protonic.nl>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        mkl@pengutronix.de, Marek Vasut <marex@denx.de>,
        Christian Herber <christian.herber@nxp.com>
Subject: Re: [PATCH net-next v1 1/2] ethtool: provide UAPI for PHY Signal
 Quality Index (SQI)
Message-ID: <20200519111842.GC9046@lion.mk-sys.cz>
References: <20200519075200.24631-1-o.rempel@pengutronix.de>
 <20200519085520.GB9046@lion.mk-sys.cz>
 <20200519105855.p7nqklhwotueloko@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200519105855.p7nqklhwotueloko@pengutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 19, 2020 at 12:58:55PM +0200, Oleksij Rempel wrote:
> On Tue, May 19, 2020 at 10:55:20AM +0200, Michal Kubecek wrote:
> > I'm also a bit worried about hardcoding the 0-7 value range. While I
> > understand that it's defined by standard for 100base-T1, we my want to
> > provide such information for other devices in the future. I tried to
> > search if there is something like that for 1000base-T1 and found this:
> > 
> >   http://www.sigent.cn/wp-content/uploads/2019/12/TE-1400_User-Manual_1000BASE-T1-EMC-Converter_v3.3.pdf
> > 
> > The screenshot on page 10 shows "SQI Value: 00015".
> 
> Nice, screenshot based reverse engineering :)
> 
> > It's probably not
> > standardized (yet?) but it seems to indicate we may expect other devices
> > providing SQI information with different value range.
> 
> what maximal range do we wont to export? u8, u16 or u32?

As the userspace API is "cast in stone" and there no actual space saved
by using u8 or u16 due to padding (attributes are always padded to
a multiple of 32 bits), I would suggest to go with u32 in uapi.
Internally, we can use a smaller type for now if it is more convenient.

Michal
