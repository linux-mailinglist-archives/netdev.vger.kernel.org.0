Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 791EE7DACB
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 14:00:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731121AbfHAMAl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 08:00:41 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:36783 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727455AbfHAMAl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 08:00:41 -0400
X-Originating-IP: 86.250.200.211
Received: from localhost (lfbn-1-17395-211.w86-250.abo.wanadoo.fr [86.250.200.211])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id C464960006;
        Thu,  1 Aug 2019 12:00:38 +0000 (UTC)
Date:   Thu, 1 Aug 2019 14:00:38 +0200
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Matteo Croce <mcroce@redhat.com>
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        netdev <netdev@vger.kernel.org>,
        Miquel Raynal <miquel.raynal@free-electrons.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net] mvpp2: fix panic on module removal
Message-ID: <20190801120038.GA14470@kwain>
References: <20190731183116.4791-1-mcroce@redhat.com>
 <20190801071801.GF3579@kwain>
 <CAGnkfhyx7MHaG=YNhS7VrzsBqhVCPw5VeHPM7SFpiLeq3cb5Gw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGnkfhyx7MHaG=YNhS7VrzsBqhVCPw5VeHPM7SFpiLeq3cb5Gw@mail.gmail.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 01, 2019 at 01:46:39PM +0200, Matteo Croce wrote:
> On Thu, Aug 1, 2019 at 9:18 AM Antoine Tenart
> <antoine.tenart@bootlin.com> wrote:
> > On Wed, Jul 31, 2019 at 08:31:16PM +0200, Matteo Croce wrote:
> > >
> > > diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > > index c51f1d5b550b..5002d51fc9d6 100644
> > > --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > > +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > > @@ -5760,7 +5760,6 @@ static int mvpp2_remove(struct platform_device *pdev)
> > >       mvpp2_dbgfs_cleanup(priv);
> > >
> > >       flush_workqueue(priv->stats_queue);
> > > -     destroy_workqueue(priv->stats_queue);
> > >
> > >       fwnode_for_each_available_child_node(fwnode, port_fwnode) {
> > >               if (priv->port_list[i]) {
> > > @@ -5770,6 +5769,8 @@ static int mvpp2_remove(struct platform_device *pdev)
> > >               i++;
> > >       }
> >
> > Shouldn't you also move flush_workqueue() here?
> 
> I think that that flush it's unneeded at all, as all port remove calls
> cancel_delayed_work_sync().
> 
> I tried removing it and it doesn't crash on rmmod.

I was wondering this, and looking at the documentation it seems to me
removing flush_workqueue() should be fine.

Thanks!
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
