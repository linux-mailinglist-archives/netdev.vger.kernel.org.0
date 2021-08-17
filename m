Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9604B3EF562
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 00:05:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234006AbhHQWFm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 18:05:42 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54876 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229700AbhHQWFm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Aug 2021 18:05:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=CtkXoA1rFd57kuhIhdRaLrVe5CCWeDX/zzmbELf0voo=; b=4gLA6nHAz7F5X+aO2Rrv0pjNk+
        EWtHnQiL/lInfiLSXMtefkKmHItTGCkRJh/K7td5lj6TCG5jj+OP2a/a2+8JkiShTYHq0SBEZOq6f
        bM9jfqByFUPbmRD+DB/4+EDenIPbDyJgsIFY5N/z3mVRpTny4+fmY4Io1LgxRMpZ+Wp8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mG7Cj-000es2-7b; Wed, 18 Aug 2021 00:05:05 +0200
Date:   Wed, 18 Aug 2021 00:05:05 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alvin =?utf-8?Q?=C5=A0ipraga?= <ALSI@bang-olufsen.dk>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH net] net: dsa: sja1105: fix use-after-free after calling
 of_find_compatible_node, or worse
Message-ID: <YRwykZONaibo5KKe@lunn.ch>
References: <20210817145245.3555077-1-vladimir.oltean@nxp.com>
 <cd0d9c40-d07b-e2ab-b068-d0bcb4685d09@bang-olufsen.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cd0d9c40-d07b-e2ab-b068-d0bcb4685d09@bang-olufsen.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Do these integrated NXP PHYs use a specific PHY driver, or do they just 
> use the Generic PHY driver? If the former is the case, do you experience 
> that the PHY driver fails to get probed during mdiobus registration if 
> the kernel uses fw_devlink=on?

The Marvell mv88e6xxx driver registers upto two MDIO busses, and the
PHYs on those busses make use of the marvell PHY driver. I've not
tested specifically with fw_devlink=on, but in general, the Marvell
PHY driver does get bound to these devices.

    Andrew
