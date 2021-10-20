Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCC31434AB1
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 14:03:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230162AbhJTMGK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 08:06:10 -0400
Received: from mx1.tq-group.com ([93.104.207.81]:16927 "EHLO mx1.tq-group.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229702AbhJTMGJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 08:06:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1634731435; x=1666267435;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tJIhNGjamjphj7O59/7TRWCK3nfTGWmxe5ZyDBjSkEM=;
  b=E5d2Fr5/HCOF9jf/1Rv97TszS5Trb1DukaqlBnJv/GcyeuUtCbbW6VA4
   mnz72vhYi77HbA+xz8+lDErm7l4vSeijwMWoObMvb7CKS12uCuRak3oh2
   c/H3ANKlk0DR4zftc7FefLkuUIEEn6X1hnonfUfIan2zwFvLbb7t649Sl
   965DIwFjjxLNaZuPvgn+vp/s67XXhpXvDZVPXmRxFCMibkNUEttaOYpw+
   uOwl7esVyoonaOrphtUlgc+SzdkHjEYBDtfMrN5yf2ThfL7k+9VWmcJTi
   dnaN5k4vg/BP0AZQWefVhwf1xTK7z+hgpr7GWFq0ML9dQGpIx3EsjEX3b
   Q==;
X-IronPort-AV: E=Sophos;i="5.87,166,1631570400"; 
   d="scan'208";a="20155759"
Received: from unknown (HELO tq-pgp-pr1.tq-net.de) ([192.168.6.15])
  by mx1-pgp.tq-group.com with ESMTP; 20 Oct 2021 14:03:52 +0200
Received: from mx1.tq-group.com ([192.168.6.7])
  by tq-pgp-pr1.tq-net.de (PGP Universal service);
  Wed, 20 Oct 2021 14:03:53 +0200
X-PGP-Universal: processed;
        by tq-pgp-pr1.tq-net.de on Wed, 20 Oct 2021 14:03:53 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1634731433; x=1666267433;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tJIhNGjamjphj7O59/7TRWCK3nfTGWmxe5ZyDBjSkEM=;
  b=jy1xSZt8f2lEbCA7OqFVCfaJDu49DcmknN2/ZmRU8k+CZaaa2LVDrlVU
   ocFrY12VKE+3ZKpIKq/yA7g6KBPPYIW0n4ZTPxa58H2CsFVUQEzXNwYgr
   +OQ70g68+N0jItYLn6IFWL5+T3xB/jaw32INMtm+Y4+x102VxL3eFKv1k
   vmQsgJmfFELMM2ekHgdJb2iKsBg1vPh3sylftU9pntZZbBVyqiN9qpXJY
   eowc2AnMVDgOLybZ/zTHMICaLkWHtvtIUq7eRan6dydTZ8gbrayqTBV3J
   Px8VCXsIqw3yoIqPSmkmOUsB2zQpUM8I73zxlpUqjl2xidYNi6iywkP+w
   Q==;
X-IronPort-AV: E=Sophos;i="5.87,166,1631570400"; 
   d="scan'208";a="20155756"
Received: from vtuxmail01.tq-net.de ([10.115.0.20])
  by mx1.tq-group.com with ESMTP; 20 Oct 2021 14:03:52 +0200
Received: from schifferm-ubuntu4.tq-net.de (schifferm-ubuntu4.tq-net.de [10.121.48.12])
        by vtuxmail01.tq-net.de (Postfix) with ESMTPA id D4A42280065;
        Wed, 20 Oct 2021 14:03:51 +0200 (CEST)
Message-ID: <aae9573f89560a32da0786dc90cb7be0331acad4.camel@ew.tq-group.com>
Subject: Re: [PATCH] net: fec: defer probe if PHY on external MDIO bus is
 not available
From:   Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 20 Oct 2021 14:03:49 +0200
In-Reply-To: <YW7SWKiUy8LfvSkl@lunn.ch>
References: <20211014113043.3518-1-matthias.schiffer@ew.tq-group.com>
         <YW7SWKiUy8LfvSkl@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-10-19 at 16:12 +0200, Andrew Lunn wrote:
> On Thu, Oct 14, 2021 at 01:30:43PM +0200, Matthias Schiffer wrote:
> > On some SoCs like i.MX6UL it is common to use the same MDIO bus for PHYs
> > on both Ethernet controllers. Currently device trees for such setups
> > have to make assumptions regarding the probe order of the controllers:
> > 
> > For example in imx6ul-14x14-evk.dtsi, the MDIO bus of fec2 is used for
> > the PHYs of both fec1 and fec2. The reason is that fec2 has a lower
> > address than fec1 and is thus loaded first, so the bus is already
> > available when fec1 is probed.
> > 
> > Besides being confusing, this limitation also makes it impossible to use
> > the same device tree for variants of the i.MX6UL with one Ethernet
> > controller (which have to use the MDIO of fec1, as fec2 does not exist)
> > and variants with two controllers (which have to use fec2 because of the
> > load order).
> > 
> > To fix this, defer the probe of the Ethernet controller when the PHY is
> > not on our own MDIO bus and not available.
> > 
> > Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
> > ---
> >  drivers/net/ethernet/freescale/fec_main.c | 23 ++++++++++++++++++++++-
> >  1 file changed, 22 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
> > index 47a6fc702ac7..dc070dd216e8 100644
> > --- a/drivers/net/ethernet/freescale/fec_main.c
> > +++ b/drivers/net/ethernet/freescale/fec_main.c
> > @@ -3820,7 +3820,28 @@ fec_probe(struct platform_device *pdev)
> >  		goto failed_stop_mode;
> >  
> >  	phy_node = of_parse_phandle(np, "phy-handle", 0);
> > -	if (!phy_node && of_phy_is_fixed_link(np)) {
> > +	if (phy_node) {
> > +		struct device_node *mdio_parent =
> > +			of_get_next_parent(of_get_parent(phy_node));
> > +
> > +		ret = 0;
> > +
> > +		/* Skip PHY availability check for our own MDIO bus to avoid
> > +		 * cyclic dependency
> > +		 */
> > +		if (mdio_parent != np) {
> > +			struct phy_device *phy = of_phy_find_device(phy_node);
> > +
> > +			if (phy)
> > +				put_device(&phy->mdio.dev);
> > +			else
> > +				ret = -EPROBE_DEFER;
> > +		}
> 
> I've not looked at the details yet, just back from vacation. But this
> seems wrong. I would of expected phylib to of returned -EPRODE_DEFER
> at some point, when asked for a PHY which does not exist yet. All the
> driver should need to do is make sure it returns the
> -EPRODE_DEFER.

This is what I expected as well, however there are a few complications:

- At the moment the first time the driver does anything with the PHY is
  in fec_enet_open(), not in fec_probe() - way too late to defer
  anything

- phylib doesn't know about EPROBE_DEFER, or error returns in general,
  everything just returns NULL. There is a fairly long chain of
  functions that just return NULL here (which might be okay, as they
  don't have a way to distinguish different errors anyways AFAICT):
  of_phy_find_device() -> fwnode_phy_find_device() ->
  fwnode_phy_find_device() -> fwnode_mdio_find_device() ->
  bus_find_device_by_fwnode() -> bus_find_device()

- Even if we implement the EPROBE_DEFER return somewhere in phylib,
  there needs to be special handling for the internal MDIO case, where
  the MDIO device is provided by the same driver that uses it. We can't
  wait with the check until we registered the MDIO bus, as it is not
  allowed to return EPROBE_DEFER after any devices have been
  registered. Splitting out the MDIO bus to be probed separately does
  not seem feasible, but I might be wrong?


So I have a few ideas, but I'm not sure which approach to pursue:

1. Make of_phy_find_device() return -EPROBE_DEFER (with or without
   touching more of the call chain). Doesn't seem too convincing to me,
   as it will just replace every case where of_phy_find_device()
   return NULL with -EPROBE_DEFER, making it more complicated to use
   for no gain.

2. Create a helper in phylib ("of_phy_device_available()") or something
   that encapsulates some of the code of this patch in a reuseable way,
   returning 0 or -EPROBE_DEFER.

 2a. Move just the code in "if (mdio_parent != np) {"
 2b. Also include the check for the MDIO parent for special handling of
     the internal MDIO. Not sure if this is approach is too specific
     to the node structure for a generic helper, or if the structure is
     common enough across different drivers.

3. Create a wrapper for of_parse_phandle() in phylib that does
   everything from 2b. 
  - Change the driver to hold a reference to a phy_device instead of
    its device_node
  - Might require further work for the fixed-link case
  - Will allow for an API similar to regulator_get[_optional]()
  - I have no idea how to solve the internal MDIO case with this
    approach nicely, as we don't be able to get a phy_device before the
    MDIO bus is registered


Matthias



> 
>        Andrew

