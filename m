Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7562ECE66
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 12:05:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbhAGLFN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 06:05:13 -0500
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:54357 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726110AbhAGLFN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 06:05:13 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id C40E0581F37;
        Thu,  7 Jan 2021 06:04:06 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 07 Jan 2021 06:04:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=IOYMbI
        iY6GwhvEYuu1uczjmO/kNdKT7fWRsSiZerlj0=; b=Bb+ydZ5n5xsbCKGbNWt/B+
        U4FTqjLELKQsdmL7S66eND/BHjDVYU6JFhwCxKjDgax1QiznPe/G/MJuPcHr7aUY
        C4+pMmXjhHorH/gMmt20Im4xlNk6+xzdufodpQ6XjuGuI0p1ABslRSEy6usP36Yu
        UrPugvJBljY+4Y87sJN+ftURw4d5i/i25kbIVTRJWmPY8eg970w5wZVtgbPrS+Gx
        29cqnp0TFYCeEwPWTuJVkWYETbiQLf8GjFhM1Jrs3sqgUPr53iAXCSuN627ahjut
        Yoti63OhT83tUi3LvQjpglAybh/pq7vkgh19t7gN85JzW95AxlLVptZklrCQDoRw
        ==
X-ME-Sender: <xms:o-r2X0SuYKlhdoXg6RVzSfa4P8K-CDjNqKAD6wtDK7Bm_hE9nsYTyA>
    <xme:o-r2XxxnYeFOku_Zaz8z0CDhgQCb6DZ2FkOLMmcsgqaGWb0AF85DFPCqJ3QdHUcxS
    5VzQrKehWQeWcQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdegvddgvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucfkphepkeegrddvvdelrdduheefrdeggeenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:o-r2Xx1nTMbt0d2wD0rsg6xqbAOVU14Oo78BdSa0osHLPkju5U4Nsg>
    <xmx:o-r2X4Bhy4yRHZHvVqzdvTFnKuUNjzaOKV9eMR0HemqiiBdvzQgUgg>
    <xmx:o-r2X9hHdcp2MaXVl-h5kahRrFctDiXNMjskcjv79MwdaJSeq2nA_A>
    <xmx:pur2XwiACobfg9Ow2fgPzL_VVK12DF_Si6wMedE919NttWIL_FZ_3w>
Received: from localhost (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id CE90F108005B;
        Thu,  7 Jan 2021 06:04:02 -0500 (EST)
Date:   Thu, 7 Jan 2021 13:04:00 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Vladimir Oltean <olteanv@gmail.com>, petrm@nvidia.com
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>
Subject: Re: [PATCH v3 net-next 03/11] net: switchdev: remove the transaction
 structure from port object notifiers
Message-ID: <20210107110400.GA1110674@shredder.lan>
References: <20210106231728.1363126-1-olteanv@gmail.com>
 <20210106231728.1363126-4-olteanv@gmail.com>
 <20210107103835.GA1102653@shredder.lan>
 <20210107104048.GB1102653@shredder.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210107104048.GB1102653@shredder.lan>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 07, 2021 at 12:40:51PM +0200, Ido Schimmel wrote:
> Forgot to actually add Petr
> 
> On Thu, Jan 07, 2021 at 12:38:39PM +0200, Ido Schimmel wrote:
> > +Petr
> > 
> > On Thu, Jan 07, 2021 at 01:17:20AM +0200, Vladimir Oltean wrote:
> > >  static int mlxsw_sp_port_obj_add(struct net_device *dev,
> > >  				 const struct switchdev_obj *obj,
> > > -				 struct switchdev_trans *trans,
> > >  				 struct netlink_ext_ack *extack)
> > >  {
> > >  	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(dev);
> > >  	const struct switchdev_obj_port_vlan *vlan;
> > > +	struct switchdev_trans trans;
> > >  	int err = 0;
> > >  
> > >  	switch (obj->id) {
> > >  	case SWITCHDEV_OBJ_ID_PORT_VLAN:
> > >  		vlan = SWITCHDEV_OBJ_PORT_VLAN(obj);
> > > -		err = mlxsw_sp_port_vlans_add(mlxsw_sp_port, vlan, trans,
> > > +
> > 
> > Got the regression results. The call to mlxsw_sp_span_respin() should be
> > placed here because it needs to be triggered regardless of the return
> > value of mlxsw_sp_port_vlans_add().
> > 
> > I'm looking into another failure, which might not be related to these
> > patches. I will also have results with a debug kernel tomorrow (takes
> > almost a day to complete). Will let you know.

Please ignore the comment about the additional failure. Not related to
these patches.

Thanks

> > 
> > > +		trans.ph_prepare = true;
> > > +		err = mlxsw_sp_port_vlans_add(mlxsw_sp_port, vlan, &trans,
> > >  					      extack);
> > > +		if (err)
> > > +			break;
> > >  
> > > -		if (switchdev_trans_ph_prepare(trans)) {
> > > -			/* The event is emitted before the changes are actually
> > > -			 * applied to the bridge. Therefore schedule the respin
> > > -			 * call for later, so that the respin logic sees the
> > > -			 * updated bridge state.
> > > -			 */
> > > -			mlxsw_sp_span_respin(mlxsw_sp_port->mlxsw_sp);
> > > -		}
> > > +		/* The event is emitted before the changes are actually
> > > +		 * applied to the bridge. Therefore schedule the respin
> > > +		 * call for later, so that the respin logic sees the
> > > +		 * updated bridge state.
> > > +		 */
> > > +		mlxsw_sp_span_respin(mlxsw_sp_port->mlxsw_sp);
> > > +
> > > +		trans.ph_prepare = false;
> > > +		err = mlxsw_sp_port_vlans_add(mlxsw_sp_port, vlan, &trans,
> > > +					      extack);
> > >  		break;
> > >  	case SWITCHDEV_OBJ_ID_PORT_MDB:
> > >  		err = mlxsw_sp_port_mdb_add(mlxsw_sp_port,
> > > -					    SWITCHDEV_OBJ_PORT_MDB(obj),
> > > -					    trans);
> > > +					    SWITCHDEV_OBJ_PORT_MDB(obj));
> > >  		break;
> > >  	default:
> > >  		err = -EOPNOTSUPP;
