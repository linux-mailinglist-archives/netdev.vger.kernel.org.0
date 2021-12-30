Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 893AB48201E
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 21:00:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240722AbhL3UAs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 15:00:48 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:45732 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237051AbhL3UAr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Dec 2021 15:00:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=swFcll9d6or3bymI88mhsRUXi5Be1DYRqzuWOJeAxXI=; b=vTsHYxurXP+1tx6Kavv0f4k1Jz
        Bw9piQxaQLAv7i6sG25pbzFNx/GsVa2GiK2uWWxm8dfuJn3UK3qAThm/vI9rIlz4FOjX8A8Nllzme
        DW2oMxbVy0GSSVXh6LYTtZb8J2dexu2+KdPk34UCdPkAAB1/Raf5iD+adBaVv/3FXRS8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1n31bP-000BoM-Et; Thu, 30 Dec 2021 21:00:43 +0100
Date:   Thu, 30 Dec 2021 21:00:43 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Subject: Re: [PATCH net-next v2 06/13] net: dsa: realtek: use phy_read in
 ds->ops
Message-ID: <Yc4P64Ee+cwGF8PL@lunn.ch>
References: <20211216201342.25587-1-luizluca@gmail.com>
 <20211218081425.18722-1-luizluca@gmail.com>
 <20211218081425.18722-7-luizluca@gmail.com>
 <71f3fa2d-56c0-3e9b-520e-3d6cc1225f1c@gmail.com>
 <CAJq09z6_ZWvcnbO7VvGGU8ayBYGU1eVR72G7mWgZGNTNFkdZjg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJq09z6_ZWvcnbO7VvGGU8ayBYGU1eVR72G7mWgZGNTNFkdZjg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 30, 2021 at 04:44:26PM -0300, Luiz Angelo Daros de Luca wrote:
> > >   static int realtek_smi_mdio_read(struct mii_bus *bus, int addr, int regnum)
> > >   {
> > > -     struct realtek_priv *priv = bus->priv;
> > > +     struct dsa_switch *ds = ((struct realtek_priv *)bus->priv)->ds;
> >
> > No need to cast a void pointer, this applies throughout the entire patch
> > series.
> > --
> Hi Florian,
> 
> Apologize for my poor C experience but I didn't understand your
> suggestion. Simply removing the cast will not work because bus->priv
> is void*

You can do 

     struct realtek_priv *priv = bus->priv;
     struct dsa_switch *ds = priv->ds;

This is more readable than what you suggested, and avoids the cast.

     Andrew

     
