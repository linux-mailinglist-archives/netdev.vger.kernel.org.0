Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABED630DAE
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 13:59:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbfEaL7b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 07:59:31 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44372 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726442AbfEaL7a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 07:59:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=N+YQAv+JDAfDBNAmFyjywDkye+Ulq8gkff+04qV3ZBo=; b=kmFKQgn4IzJN7DrfpYJbKY/HOY
        J3NcU7rn35RjmwZEi6fOXoFhNr/JOnClM3KWnTreTTPUgrIdxIqsx7EeT/HjK+jz8Bc2MZh3vuMVr
        RKfQtv+JwHhtwq75gqYb9p0W/Ypn9+0LlWqJ3xWFbiZreH6m9/rR6z1WmNqjDLTDArN8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hWgC0-0004uh-Dc; Fri, 31 May 2019 13:59:28 +0200
Date:   Fri, 31 May 2019 13:59:28 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, linville@redhat.com
Subject: Re: [PATCH 2/2] ethtool: Add 100BaseT1 and 1000BaseT1 link modes
Message-ID: <20190531115928.GA18608@lunn.ch>
References: <20190530180616.1418-1-andrew@lunn.ch>
 <20190530180616.1418-3-andrew@lunn.ch>
 <20190531093029.GD15954@unicorn.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190531093029.GD15954@unicorn.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > @@ -634,10 +636,14 @@ static void dump_link_caps(const char *prefix, const char *an_prefix,
> >  		  "100baseT/Half" },
> >  		{ 1, ETHTOOL_LINK_MODE_100baseT_Full_BIT,
> >  		  "100baseT/Full" },
> > +		{ 1, ETHTOOL_LINK_MODE_100baseT1_Full_BIT,
> > +		  "100baseT1/Full" },
> >  		{ 0, ETHTOOL_LINK_MODE_1000baseT_Half_BIT,
> >  		  "1000baseT/Half" },
> >  		{ 1, ETHTOOL_LINK_MODE_1000baseT_Full_BIT,
> >  		  "1000baseT/Full" },
> > +		{ 1, ETHTOOL_LINK_MODE_1000baseT1_Full_BIT,
> > +		  "1000baseT1/Full" },
> >  		{ 0, ETHTOOL_LINK_MODE_1000baseKX_Full_BIT,
> >  		  "1000baseKX/Full" },
> >  		{ 0, ETHTOOL_LINK_MODE_2500baseX_Full_BIT,
> 
> Does it mean that we could end up with lines like
> 
>                                 100baseT/Half 100baseT/Full 100baseT1/Full
>                                 1000baseT/Full 1000baseT1/Full
> 
> if there is a NIC supporting both T and T1?

Hi Michal

In theory, it is possible for a PHY to support both plain T and
T1. And a 1000BaseT could also implement 1000BaseT2 and 1000BaseT1.
I've not yet seen an actual PHY which does this though.

> It would
> be probably confusing for users as modes on the same line always were
> half/full duplex variants of the same.

I can clear the same_line flag.
 
> You should also add the new modes to ethtool.8.in.

Yes, will do.

     Andrew
