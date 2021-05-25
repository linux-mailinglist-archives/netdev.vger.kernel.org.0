Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 063D938F85A
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 04:53:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbhEYCzN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 22:55:13 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55260 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229551AbhEYCzM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 May 2021 22:55:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=ZfzeKlCyxCpPnbiMw9/yG/htYiywWc4/PMK80zEUDpw=; b=q9
        v2z1m+zPhaNXS+I5t29W+Dj5hxlSMedTc/AVLCUQlsz8vAzsTQiA5D1/QWIIBPMhDyPa+FJOGtcC9
        0WgBbpBVvBOOtAQUGr9yQYBu0pgOcM1gXZJqBl2+Vlswh+i8tlXwO5SwHwg+0o24Pi4sArne9ILMF
        w4tTEJp2EaR8gnM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1llNCN-0064nq-Q0; Tue, 25 May 2021 04:53:39 +0200
Date:   Tue, 25 May 2021 04:53:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "cao88yu@gmail.com" <cao88yu@gmail.com>
Subject: Re: [PATCH net 3/3] net: dsa: Include tagger overhead when setting
 MTU for DSA and CPU ports
Message-ID: <YKxms7kAc4sJMU/i@lunn.ch>
References: <20210524213313.1437891-1-andrew@lunn.ch>
 <20210524213313.1437891-4-andrew@lunn.ch>
 <20210524220400.gwqdwqrju7uzxtqi@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210524220400.gwqdwqrju7uzxtqi@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 24, 2021 at 10:04:01PM +0000, Vladimir Oltean wrote:
> On Mon, May 24, 2021 at 11:33:13PM +0200, Andrew Lunn wrote:
> > Same members of the Marvell Ethernet switches impose MTU restrictions
> > on ports used for connecting to the CPU or DSA. If the MTU is set too
> > low, tagged frames will be discarded. Ensure the tagger overhead is
> > included in setting the MTU for DSA and CPU ports.
> > 
> > Fixes: 1baf0fac10fb ("net: dsa: mv88e6xxx: Use chip-wide max frame size for MTU")
> > Reported by: 曹煜 <cao88yu@gmail.com>
> > Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> > ---
> 
> Some switches account for the DSA tag automatically in hardware. So far
> it has been the convention that if a switch doesn't do that, the driver
> should, not DSA.

O.K.

This is going to be a little bit interesting with Tobias's support for
changing the tag protocol. I need to look at the ordering.

	 Andrew
