Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00B7D25E8F7
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 18:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727875AbgIEQGy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 12:06:54 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44912 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726261AbgIEQGw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Sep 2020 12:06:52 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kEaiF-00DMu5-MF; Sat, 05 Sep 2020 18:06:47 +0200
Date:   Sat, 5 Sep 2020 18:06:47 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Paul Barker <pbarker@konsulko.com>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH 3/4] net: dsa: microchip: Disable RGMII in-band status on
 KSZ9893
Message-ID: <20200905160647.GJ3164319@lunn.ch>
References: <20200905140325.108846-1-pbarker@konsulko.com>
 <20200905140325.108846-4-pbarker@konsulko.com>
 <20200905153238.GE3164319@lunn.ch>
 <CAM9ZRVs8e7hcS4T=Nt6M4iyDWA8uT42m=iRnYzQFg0ajL6rwTw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM9ZRVs8e7hcS4T=Nt6M4iyDWA8uT42m=iRnYzQFg0ajL6rwTw@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 05, 2020 at 04:53:20PM +0100, Paul Barker wrote:
> On Sat, 5 Sep 2020 at 16:32, Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > On Sat, Sep 05, 2020 at 03:03:24PM +0100, Paul Barker wrote:
> > > We can't assume that the link partner supports the in-band status
> > > reporting which is enabled by default on the KSZ9893 when using RGMII
> > > for the upstream port.
> >
> > What do you mean by RGMII inband status reporting? SGMII/1000BaseX has
> > in band signalling, but RGMII?
> >
> >    Andrew
> 
> I'm referencing page 56 of the KSZ9893 datasheet
> (http://ww1.microchip.com/downloads/en/DeviceDoc/KSZ9893R-Data-Sheet-DS00002420D.pdf).
> The datasheet says "The RGMII port will not function properly if IBS
> is enabled in the switch, but it is not receiving in-band status from
> a connected PHY." Since we can't guarantee all possible link partners
> will support this it should be disabled. In particular, the IMX6 SoC
> we're using with this switch doesn't support this on its Ethernet
> port.
> 
> I don't really know much about how this is implemented or how widely
> it's supported.

I never knew RGMII had this. What i did find was:

http://web.archive.org/web/20160303171328/http://www.hp.com/rnd/pdfs/RGMIIv2_0_final_hp.pdf

which does talk about it, section 3.4.1. It is clearly optional, and
since this is the first time i've heard of it, i suspect not many
systems actually implement it. So turning it off seems wise.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
