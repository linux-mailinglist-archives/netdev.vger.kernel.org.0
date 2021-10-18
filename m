Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D62B643162D
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 12:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230460AbhJRKfJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 06:35:09 -0400
Received: from mx1.tq-group.com ([93.104.207.81]:11056 "EHLO mx1.tq-group.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230446AbhJRKfI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 06:35:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1634553177; x=1666089177;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7TuARXSI3wTGfh7jWlkLb/D7la4yilknZ2ZdyGEzh0U=;
  b=Am09TH449mxfAIuL9ccwNYujk+9g3k4dGBbEXeFHTFGrzstqtzpzqFzB
   exPxbrgPEfpT0WUWNZwChR3dhnla7HH4MW9zOzz/ff9b93DOM4CE7SBP8
   99zTS3VgfUjWNwsImlKQJuJ6L1rdGyGev7Bd7g8BZPcAt3hg1ytfQxaIq
   jc5EPgY0LecyDvXHzlTCqLm7xyYZtCNLEvwSIZJbLMUycHGA50aziT2N1
   NEwZwrIJ82FXFQtwyiWahB6JrJD4VC0Dn2c/Rhk6mFYR/V2gevqNlpcT/
   QbDSPzAit6T+IVL8fU0gl78Ne5En9nHd75wf4/kCgC2vegsyKtpsdHTIV
   A==;
X-IronPort-AV: E=Sophos;i="5.85,381,1624312800"; 
   d="scan'208";a="20102957"
Received: from unknown (HELO tq-pgp-pr1.tq-net.de) ([192.168.6.15])
  by mx1-pgp.tq-group.com with ESMTP; 18 Oct 2021 12:32:55 +0200
Received: from mx1.tq-group.com ([192.168.6.7])
  by tq-pgp-pr1.tq-net.de (PGP Universal service);
  Mon, 18 Oct 2021 12:32:55 +0200
X-PGP-Universal: processed;
        by tq-pgp-pr1.tq-net.de on Mon, 18 Oct 2021 12:32:55 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1634553175; x=1666089175;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7TuARXSI3wTGfh7jWlkLb/D7la4yilknZ2ZdyGEzh0U=;
  b=GiApMPZuDIDbGMwkp7Ci7+Ogc6AyVpkh9DNtNt5ko7UFzVCBzjn9WeUI
   rrn4gMJaCHh7TxMJ2ouAx3aeP6pPV91sJYIrXK0O/M70Wx92VwqGdf5ns
   p+dqLk/vXLOhHpIR396zUP3L4jTm+p/sNV77dtVAfzVZKzp+H55p8sLTJ
   czrXyw9lgROdDcijCrvsqZ1yBwUB+DHkE4gWdEt/mgyOV4scGA9WQVKIs
   25gJ5wIsd12ECjn7/AmXFncoBQAkG85DynmtEHCx3KnIt+pK0SVH+SL2Q
   r+bjiIzUUDUFIiteUBgcI1bweQ/I9ngFfATBSildFv0EtBX90RhKs+ItS
   Q==;
X-IronPort-AV: E=Sophos;i="5.85,381,1624312800"; 
   d="scan'208";a="20102956"
Received: from vtuxmail01.tq-net.de ([10.115.0.20])
  by mx1.tq-group.com with ESMTP; 18 Oct 2021 12:32:55 +0200
Received: from schifferm-ubuntu4.tq-net.de (schifferm-ubuntu4.tq-net.de [10.121.48.12])
        by vtuxmail01.tq-net.de (Postfix) with ESMTPA id 9AC22280065;
        Mon, 18 Oct 2021 12:32:55 +0200 (CEST)
Message-ID: <0dd0eb96ce6509b944d1a0b3cfa78e692409edc5.camel@ew.tq-group.com>
Subject: RE: [PATCH] net: fec: defer probe if PHY on external MDIO bus is
 not available
From:   Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Date:   Mon, 18 Oct 2021 12:32:53 +0200
In-Reply-To: <DB8PR04MB679504F7E61252F3FC62FBFEE6BC9@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20211014113043.3518-1-matthias.schiffer@ew.tq-group.com>
         <DB8PR04MB679504F7E61252F3FC62FBFEE6BC9@DB8PR04MB6795.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-10-18 at 10:20 +0000, Joakim Zhang wrote:
> Hi Matthias,
> 
> > -----Original Message-----
> > From: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
> > Sent: 2021年10月14日 19:31
> > To: Joakim Zhang <qiangqing.zhang@nxp.com>; David S. Miller
> > <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>
> > Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Matthias Schiffer
> > <matthias.schiffer@ew.tq-group.com>
> > Subject: [PATCH] net: fec: defer probe if PHY on external MDIO bus is not
> > available
> > 
> > On some SoCs like i.MX6UL it is common to use the same MDIO bus for PHYs
> > on both Ethernet controllers. Currently device trees for such setups have to
> > make assumptions regarding the probe order of the controllers:
> > 
> > For example in imx6ul-14x14-evk.dtsi, the MDIO bus of fec2 is used for the
> > PHYs of both fec1 and fec2. The reason is that fec2 has a lower address than
> > fec1 and is thus loaded first, so the bus is already available when fec1 is
> > probed.
> 
> It's not correct, I think, we have board designed to use fec1(which is lower address) to controller MDIO interface, such as,
> https://source.codeaurora.org/external/imx/linux-imx/tree/arch/arm64/boot/dts/freescale/imx8qm-mek.dts?h=lf-5.10.y#n948
> that means our driver can handle these cases, not related to the order.

Yes, not all SoC have FEC2 at the lower address, but this is the case
on i.MX6UL. As far as I can tell my patch should not hurt when the
order is already correct, as the added code will never retern
EPROBE_DEFER in these cases.

Obviously all existing Device Trees in the mainline kernel are defined
in a way that already works with the existing code, by using the FEC2
MDIO on i.MX6UL-based designs, or their Ethernet would not work
correctly.


> 
> > Besides being confusing, this limitation also makes it impossible to use the
> > same device tree for variants of the i.MX6UL with one Ethernet controller
> > (which have to use the MDIO of fec1, as fec2 does not exist) and variants with
> > two controllers (which have to use fec2 because of the load order).
> 
> Generally speaking, you should only include imx6ul.dtsi for your board design to cover SoC definition,
> and imx6ul-14x14-evk.dtsi/ imx6ul-14x14-evk.dts is for our 14x14 EVK board. So do we really need this
> defer probe?

I only mentioned imx6ul-14x14-evk.dtsi as an example. The issue affects
the TQ-Systems MBa6ULx board, which I'm currently preparing for
mainline submission.

The bootloader disables the non-existing FEC2 node on MCIMX6G1, but
when the MDIO of FEC2 is used for both interfacse, this will also break
FEC1, so a separate Device Tree is currently needed for the MCIMX6G1.
We would prefer to use the same Device Tree for both variants, which is
possible by using the MDIO of FEC1 and applying this patch.


> 
> > 
> > To fix this, defer the probe of the Ethernet controller when the PHY is not on
> > our own MDIO bus and not available.
> > 
> > Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
> > ---
> >  drivers/net/ethernet/freescale/fec_main.c | 23 ++++++++++++++++++++++-
> >  1 file changed, 22 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/ethernet/freescale/fec_main.c
> > b/drivers/net/ethernet/freescale/fec_main.c
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
> > +
> > +		of_node_put(mdio_parent);
> > +		if (ret)
> > +			goto failed_phy;
> > +	} else if (of_phy_is_fixed_link(np)) {
> >  		ret = of_phy_register_fixed_link(np);
> >  		if (ret < 0) {
> >  			dev_err(&pdev->dev,
> > --
> > 2.17.1
> 
> Best Regards,
> Joakim Zhang

