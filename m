Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F4B92A4C42
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 18:05:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727923AbgKCRFa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 12:05:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:34502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725993AbgKCRFa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 12:05:30 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1387F2080D;
        Tue,  3 Nov 2020 17:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604423129;
        bh=KTpb5zU6OK1EgniNhpmc/HgdTlbZOQmnNyp8JZhZBkc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=f7NFWkiVG3T/cwVABT+AMzBMu3SoNvN0v/iXZgkSCVw3n3+8yJlrHnhv3EzMk9AT8
         FL/d1ruA415oZJ06IfNrbhG+uG9Kl6BmWbCNgqo2NmZHi2sTDiEOfAcfq9Z4/9IvUe
         naxJUDMHMLqjPDFNWXelyGaL/SN2DgXZKu3iJmK8=
Date:   Tue, 3 Nov 2020 09:05:27 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Subject: Re: [PATCH net-next 0/5] net: add and use dev_get_tstats64
Message-ID: <20201103090527.52543b8c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <eb4122bb-4bcd-0c32-14e9-30aca76d4365@gmail.com>
References: <25c7e008-c3fb-9fcd-f518-5d36e181c0cb@gmail.com>
        <4ca1f21d5f8a119fe6483df370b64af6a33e565e.camel@kernel.org>
        <eb4122bb-4bcd-0c32-14e9-30aca76d4365@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 3 Nov 2020 15:46:27 +0100 Heiner Kallweit wrote:
> On 02.11.2020 23:36, Saeed Mahameed wrote:
> > On Sun, 2020-11-01 at 13:33 +0100, Heiner Kallweit wrote:  
> >> It's a frequent pattern to use netdev->stats for the less frequently
> >> accessed counters and per-cpu counters for the frequently accessed
> >> counters (rx/tx bytes/packets). Add a default ndo_get_stats64()
> >> implementation for this use case. Subsequently switch more drivers
> >> to use this pattern.
> >>
> >> Heiner Kallweit (5):
> >>   net: core: add dev_get_tstats64 as a ndo_get_stats64 implementation
> >>   net: make ip_tunnel_get_stats64 an alias for dev_get_tstats64
> >>   ip6_tunnel: use ip_tunnel_get_stats64 as ndo_get_stats64 callback
> >>   net: dsa: use net core stats64 handling
> >>   tun: switch to net core provided statistics counters
> >>  
> > 
> > not many left,
> > 
> > $ git grep dev_fetch_sw_netstats drivers/
> > 
> > drivers/infiniband/hw/hfi1/ipoib_main.c:        dev_fetch_sw_netstats(s
> > torage, priv->netstats);
> > drivers/net/macsec.c:   dev_fetch_sw_netstats(s, dev->tstats);
> > drivers/net/usb/qmi_wwan.c:     dev_fetch_sw_netstats(stats, priv-  
> >> stats64);  
> > drivers/net/usb/usbnet.c:       dev_fetch_sw_netstats(stats, dev-  
> >> stats64);  
> > drivers/net/wireless/quantenna/qtnfmac/core.c:  dev_fetch_sw_netstats(s
> > tats, vif->stats64);
> > 
> > Why not convert them as well ?
> > macsec has a different implementation, but all others can be converted.
> >   
> OK, I can do this. Then the series becomes somewhat bigger.
> @Jakub: Would it be ok to apply the current series and I provide the
> additionally requested migrations as follow-up series?

Fine by me.
