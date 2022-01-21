Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48D5A496850
	for <lists+netdev@lfdr.de>; Sat, 22 Jan 2022 00:52:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbiAUXtD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 18:49:03 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:48360 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229595AbiAUXtC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Jan 2022 18:49:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Bz08U7YM5wKSmfgNhobN84FFMr9NRaKp1I5qVK+TaxM=; b=EYU0kRIawpdwEgdQbeLP3Oxe8x
        aWr1mo/herCCB+u0CsGOJzQcSqFIQyoQq7tQKy50uypUfFXsXGJI8FqVHSLt5niO1t3nwPboAFNZD
        7jWFEgUbsduh+Y6U1UhSoDZgl2briUEAxK+dwCGerXK/E9aj0BISKZpJaV+PjcLooT2A=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nB3eN-002BLL-Cf; Sat, 22 Jan 2022 00:48:59 +0100
Date:   Sat, 22 Jan 2022 00:48:59 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        Frank Wunderlich <frank-w@public-files.de>
Subject: Re: [PATCH net-next v4 05/11] net: dsa: realtek: use phy_read in
 ds->ops
Message-ID: <YetGa0hVM4J/DnxV@lunn.ch>
References: <20220105031515.29276-1-luizluca@gmail.com>
 <20220105031515.29276-6-luizluca@gmail.com>
 <79a9c7c2-9bd0-d5d1-6d5a-d505cdc564be@gmail.com>
 <CAJq09z4U5qmBuPUqBnGpT+qcG-vmtFwNMg5Uau3q3F53W-0YDA@mail.gmail.com>
 <Yea9oR0AteAMwjW2@lunn.ch>
 <CAJq09z59qhs71Vn79Zty4krpoCn_capam03yE4-kP=5E1K4bYQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJq09z59qhs71Vn79Zty4krpoCn_capam03yE4-kP=5E1K4bYQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Should I submit a patch to make dsa work like this then?
> 
> dsa_switch_setup() {
>         ....
>         ds->ops->setup()
>         ....
>         if (ds->ops->phy_read) {
>               if (ds->slave_mii_bus)
>                     error("ds->ops->phy_read is set, I should be the
> one allocating ds->slave_mii_bus!")
>               ...allocate and register ds->slave_mii_bus...
>         }
> }

You could add a WARN_ON(ds->ops->phy_read && ds->ops->phy_read);

    Andrew
