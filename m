Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02196320C8
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 23:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbfFAVgU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Jun 2019 17:36:20 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47888 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726210AbfFAVgU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 1 Jun 2019 17:36:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=QGXnux2WNbpolyXTp8iNgupCVhUGsbikq94gTD1u7PU=; b=nSPbktMjkl+NdGQtUop1T+zRJ3
        9HwQf5BH5GhxKRxciJsrFMjWoJNMDHH9XagbNFJLNeHuNfQvf8VD64ev1P7XW7VfFtvjSOOp1/XQg
        8dSvLEafeaxgSDSkemv2xz38qTcT2yuGWzByeYAojNSyCTh6f35Nk+qHndSzdaO/jY9k=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hXBfh-0006hg-FS; Sat, 01 Jun 2019 23:36:13 +0200
Date:   Sat, 1 Jun 2019 23:36:13 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net 1/2] net: dsa: sja1105: Force a negative value for
 enum sja1105_speed_t
Message-ID: <20190601213613.GD19081@lunn.ch>
References: <20190601103735.27506-1-olteanv@gmail.com>
 <20190601103735.27506-2-olteanv@gmail.com>
 <20190601160356.GB19081@lunn.ch>
 <CA+h21hpuYeyT6vPTXHQ-oJDcFuOb_q3L+t660YayPeDXm0AGtw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hpuYeyT6vPTXHQ-oJDcFuOb_q3L+t660YayPeDXm0AGtw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 On Sat, Jun 01, 2019 at 11:30:16PM +0300, Vladimir Oltean wrote:
> On Sat, 1 Jun 2019 at 19:03, Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > On Sat, Jun 01, 2019 at 01:37:34PM +0300, Vladimir Oltean wrote:
> > > The code in sja1105_adjust_port_config relies on the fact that an
> > > invalid link speed is detected by sja1105_get_speed_cfg and returned as
> > > -EINVAL.  However storing this into an enum that only has positive
> > > members will cast it into an unsigned value, and it will miss the
> > > negative check.
> > >
> > > So make the -EINVAL value part of the enum, so that it is stored as a
> > > signed number and passes the negative check.
> > >
> > > Fixes: 8aa9ebccae87 ("net: dsa: Introduce driver for NXP SJA1105 5-port L2 switch")
> > > Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> >
> > Hi Vladimir
> >
> > It seems like just using a switch statement would be simpler, and more
> > likely to be correct. And it would avoid adding SJA1105_SPEED_INVALID
> > = -EINVAL which feels hackish.
> >
> >   Andrew
> 
> Hi Andrew,
> 
> You mean I should completely remove the sja1105_get_speed_cfg function?
> I suppose I can do that, I'm only using it in one place.

I think it is often better to use simple, obviously correct code.
This seems to be one example.

     Andrew
