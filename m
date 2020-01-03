Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C259B12FBD9
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 18:53:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728225AbgACRxe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 12:53:34 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:46780 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728110AbgACRxe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Jan 2020 12:53:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Ik53vLhmD+EUsy1sL+CsKQR1KxqBKtMb4tA7fcFpO+w=; b=QUTR2W8shqqZiTDH2jgUPvAyHw
        tZDvbAED4kSORlvuj56UaZa28Xq4KqVKnjVKFotuoyHj+QwgouApJqIQUfCTRAPXp3bFQkQFCHLM9
        JkmGINPf/mEnk1l+HdspUGPlOJhPnZ5QGYlbT0mgfT7pfSKAoUPiqVuXwLDdPm9Lan0A=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1inR8Q-0000zy-9G; Fri, 03 Jan 2020 18:53:18 +0100
Date:   Fri, 3 Jan 2020 18:53:18 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     yu kuai <yukuai3@huawei.com>, klassert@kernel.org,
        davem@davemloft.net, hkallweit1@gmail.com,
        jakub.kicinski@netronome.com, hslester96@gmail.com, mst@redhat.com,
        yang.wei9@zte.com.cn, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, yi.zhang@huawei.com,
        zhengbin13@huawei.com
Subject: Re: [PATCH] net: 3com: 3c59x: remove set but not used variable
 'mii_reg1'
Message-ID: <20200103175318.GN1397@lunn.ch>
References: <20200103121907.5769-1-yukuai3@huawei.com>
 <20200103144623.GI6788@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200103144623.GI6788@bombadil.infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 03, 2020 at 06:46:23AM -0800, Matthew Wilcox wrote:
> On Fri, Jan 03, 2020 at 08:19:07PM +0800, yu kuai wrote:
> > Fixes gcc '-Wunused-but-set-variable' warning:
> > 
> > drivers/net/ethernet/3com/3c59x.c: In function ‘vortex_up’:
> > drivers/net/ethernet/3com/3c59x.c:1551:9: warning: variable
> > ‘mii_reg1’ set but not used [-Wunused-but-set-variable]
> > 
> > It is never used, and so can be removed.
> ...
> >  	if (dev->if_port == XCVR_MII || dev->if_port == XCVR_NWAY) {
> > -		mii_reg1 = mdio_read(dev, vp->phys[0], MII_BMSR);
> >  		mii_reg5 = mdio_read(dev, vp->phys[0], MII_LPA);
> 
> I know nothing about the MII interface, but in general this is not
> a safe thing to do.

Hi Matthew

I fully agree about the general case. However, reading the MII_BMSR
should not have any side affects. It would be an odd Ethernet PHY if
it did.

But I am curious why this read is here. There is a slim change the
MDIO bus is broken, and this is a workaround. So it would be good if
somebody dug into the history and found out when this read was added
and if there are any comments about why it is there. Or if the usage
of mii_reg1 as been removed at some point, and the read was not
cleaned up.

   Andrew
