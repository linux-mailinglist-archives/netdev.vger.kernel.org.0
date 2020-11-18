Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 086DC2B829E
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 18:07:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728028AbgKRRDq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 12:03:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:42530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727346AbgKRRDp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 12:03:45 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E12C22487D;
        Wed, 18 Nov 2020 17:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605719025;
        bh=Kx8ENv3A76WC9QIeT3nFCawA0elszPZWLAVhXFrgVuw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DAj5Ox+mIgnUemsmvEg3f/Fy2Gmgv4pA9l8ndkd3MFwP8RzUWiZMpK6M1vRwnGQef
         gwD8v4QREHCUBo5FE2ZdwpusbWDuB+2dwxdWjcStSkCxxK0ioisMLDHZgsJbUUEH0j
         1QEHsdvGQjcPQkplAVzs+GfSHM4+2a3HJBcjxrMA=
Date:   Wed, 18 Nov 2020 09:03:43 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net] enetc: Workaround for MDIO register access issue
Message-ID: <20201118090343.7bbf0047@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201118170044.57jlk42gjht3gd74@skbuf>
References: <20201112182608.26177-1-claudiu.manoil@nxp.com>
        <20201117024450.GH1752213@lunn.ch>
        <AM0PR04MB6754D77454B6DA79FB59917896E20@AM0PR04MB6754.eurprd04.prod.outlook.com>
        <20201118133856.GC1804098@lunn.ch>
        <20201118170044.57jlk42gjht3gd74@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Nov 2020 19:00:44 +0200 Vladimir Oltean wrote:
> On Wed, Nov 18, 2020 at 02:38:56PM +0100, Andrew Lunn wrote:
> > Thanks for the explanation. I don't think i've every reviewed a driver
> > using read/write locks like this. But thinking it through, it does
> > seem O.K.  
> 
> Thanks for reviewing and getting this merged. It sure is helpful to not
> have the link flap while running iperf3 or other intensive network
> activity.
> 
> Even if this use of rwlocks may seem unconventional, I think it is the
> right tool for working around the hardware bug.

Out of curiosity - did you measure the performance hit?
