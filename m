Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95BCDFCB65
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 18:05:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbfKNRFA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 12:05:00 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:39932 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726786AbfKNRE7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Nov 2019 12:04:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=4so7c/a9QWDRWTpXb5ZvnilykAORriXiUPapbkq7Yc0=; b=IIUlyGY6oR9aYPkugKkYf4hmBg
        gCJn6Rt2R2IKZMpu2RiqTtK6NU4ui8hecHfk8SuUBpG8BJFwmHXr81002PV68zH1EL7IXMAr4Qwny
        4gBn2lngtN+JaKkwxSbOlGY2u7EaVVWSqHULnhdhHmwgRA1QwZqWXBdqC5oC067RGtIQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iVIYB-00056H-GF; Thu, 14 Nov 2019 18:04:55 +0100
Date:   Thu, 14 Nov 2019 18:04:55 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] net: dsa: sja1105: Print the reset reason
Message-ID: <20191114170455.GS10875@lunn.ch>
References: <20191112212200.5572-1-olteanv@gmail.com>
 <20191113035321.GC16688@lunn.ch>
 <CA+h21ho84nWHcH0R+3oUBjShW65Ks63q1N+8CeNbDEa8tXkoow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21ho84nWHcH0R+3oUBjShW65Ks63q1N+8CeNbDEa8tXkoow@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 14, 2019 at 02:53:21PM +0200, Vladimir Oltean wrote:
> Hi Andrew,
> 
> On Wed, 13 Nov 2019 at 05:53, Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > On Tue, Nov 12, 2019 at 11:22:00PM +0200, Vladimir Oltean wrote:
> > > Sometimes it can be quite opaque even for me why the driver decided to
> > > reset the switch. So instead of adding dump_stack() calls each time for
> > > debugging, just add a reset reason to sja1105_static_config_reload
> > > calls which gets printed to the console.
> >
> > > +int sja1105_static_config_reload(struct sja1105_private *priv,
> > > +                              enum sja1105_reset_reason reason)
> > >  {
> > >       struct ptp_system_timestamp ptp_sts_before;
> > >       struct ptp_system_timestamp ptp_sts_after;
> > > @@ -1405,6 +1413,10 @@ int sja1105_static_config_reload(struct sja1105_private *priv)
> > >  out_unlock_ptp:
> > >       mutex_unlock(&priv->ptp_data.lock);
> > >
> > > +     dev_info(priv->ds->dev,
> > > +              "Reset switch and programmed static config. Reason: %s\n",
> > > +              sja1105_reset_reasons[reason]);
> >
> > If this is for debugging, maybe dev_dbg() would be better?
> >
> >    Andrew
> 
> This should not be a debugging print, a reset is an important event in
> the life of the switch and I would like the user to be aware of it.
> When I said "debugging" I meant "figure out the reason why it needed
> to reset this time".

Ah, O.K.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
