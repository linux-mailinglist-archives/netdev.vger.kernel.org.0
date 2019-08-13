Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70FA98BA97
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 15:42:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729171AbfHMNmk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 09:42:40 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56866 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728694AbfHMNmj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 09:42:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=aC5DjB9JrWLaqeGUMB9+kLYWj8059kFgsRkjVUGdZJE=; b=1L/E6kkI812qjNP8ir57sZwGqo
        6/Gm66yw6HQEzM4luk5Vvh8EKLhR0s71BGSEYaJ5cbFJ1qIizvMkbYQEikmXsQfK1JO/EBCZNvxVM
        2QuPuYVPX84Jznxy24tP1AF1aDwlckcRtWxfKxypLccnabL5RUrL2pRjFvgvWZ06dOW4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hxX4O-0001b8-Ks; Tue, 13 Aug 2019 15:42:36 +0200
Date:   Tue, 13 Aug 2019 15:42:36 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Y.b. Lu" <yangbo.lu@nxp.com>
Cc:     "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH 3/3] ocelot_ace: fix action of trap
Message-ID: <20190813134236.GG15047@lunn.ch>
References: <20190812104827.5935-1-yangbo.lu@nxp.com>
 <20190812104827.5935-4-yangbo.lu@nxp.com>
 <20190812123147.6jjd3kocityxbvcg@lx-anielsen.microsemi.net>
 <VI1PR0401MB223773EB5884D65890BD68C0F8D20@VI1PR0401MB2237.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR0401MB223773EB5884D65890BD68C0F8D20@VI1PR0401MB2237.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 13, 2019 at 02:12:47AM +0000, Y.b. Lu wrote:
> Hi Allan,
> 
> > -----Original Message-----
> > From: Allan W. Nielsen <allan.nielsen@microchip.com>
> > Sent: Monday, August 12, 2019 8:32 PM
> > To: Y.b. Lu <yangbo.lu@nxp.com>
> > Cc: netdev@vger.kernel.org; David S . Miller <davem@davemloft.net>;
> > Alexandre Belloni <alexandre.belloni@bootlin.com>; Microchip Linux Driver
> > Support <UNGLinuxDriver@microchip.com>
> > Subject: Re: [PATCH 3/3] ocelot_ace: fix action of trap
> > 
> > The 08/12/2019 18:48, Yangbo Lu wrote:
> > > The trap action should be copying the frame to CPU and dropping it for
> > > forwarding, but current setting was just copying frame to CPU.
> > 
> > Are there any actions which do a "copy-to-cpu" and still forward the frame in
> > HW?
> 
> [Y.b. Lu] We're using Felix switch whose code hadn't been accepted by upstream.
> https://patchwork.ozlabs.org/project/netdev/list/?series=115399&state=*
> 
> I'd like to trap all IEEE 1588 PTP Ethernet frames to CPU through etype 0x88f7.

Is this the correct way to handle PTP for this switch? For other
switches we don't need such traps. The switch itself identifies PTP
frames and forwards them to the CPU so it can process them.

I'm just wondering if your general approach is wrong?

    Andrew
