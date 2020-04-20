Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 116161B0D75
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 15:54:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728984AbgDTNyN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 09:54:13 -0400
Received: from mail-eopbgr80044.outbound.protection.outlook.com ([40.107.8.44]:34693
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726984AbgDTNyM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 09:54:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G1Dn8xgYqdTW/OLEbZqLqjwT0rceKLPJbbaq+7PfBG8kz5n1swlBG4D+A+IP696WkkenO9DJqP9JiCbQR46/E7K6T/ZgIHQNTXsj+bHfHeDu5V1spZdm+sneMW7pbp8QBH50Dogm5BziPA3VuRNH/9+UY2amwNeBzsZrGeD2j3dXYpwBdJLmu0t3e81+Za33igkEQ15JNcLq8sziGwaWQoGaoSPt3FxdVPdVXRvuC4hZfbwvgA+98YKlH0cadBEUjJLGs1B/U7AG10xMsOzVDpeJEFbQxb+W56u9u4D00UNDeWkPmGy5Y/fUIdCbTGrMZ+ACI9ailAxYs2f4iM4YnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OehBPDhkGQqIBbjEL3P7tyXk+gWrn/kvN4vqs4K+dqw=;
 b=QUAoaM1eiU8d7bsm1F0BOZERKsmO23z6Fr0TdHXC2OpQMN51BGeF7Xi+V51vDxURuHAkZ6CaNb96Gnxln//Rpybnjq7Edak1RN2WggOzYIj5F4/WaPPwns7LmU1Mha29a2eoIJUs7t7usCtbwS5wCl4oineviMlzDVycUg4WKftaJ7RUrc1o8TyXFCShM3cITclEqNZ9Lsc1vOboWoIpIfBPXWxJhwMjvdlpfUVGaNzs6Ldk3Cu/0sp4NRnbj3fFlA6WqpNJZQkXlp1cka6JlPzvef9OLVp3BLkV72/R+U09CLEhXSQfMYFYG4Zgkboehtx8KbYVOt40gHjB+NRhpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OehBPDhkGQqIBbjEL3P7tyXk+gWrn/kvN4vqs4K+dqw=;
 b=CW22pZEkJIIHBy7iGb4H1Vk6kPH90brmYe7hXc6+JSP/1+Z6dYRBMjPNtS2wzDqYB9hKkAW7fY3WQLkFqtjxCkOHwayD9Vul8MFcucyP/dyRtlqcYgYnEGbwbntT3bX7DZmleHVheiKGSo1hS594IARrh+OvRZZg8v0ApuRQzDQ=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=calvin.johnson@oss.nxp.com; 
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB5938.eurprd04.prod.outlook.com (2603:10a6:208:10f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.26; Mon, 20 Apr
 2020 13:54:07 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::c4fe:d4a4:f0e1:a75b]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::c4fe:d4a4:f0e1:a75b%4]) with mapi id 15.20.2921.027; Mon, 20 Apr 2020
 13:54:07 +0000
Date:   Mon, 20 Apr 2020 19:23:54 +0530
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     linux.cj@gmail.com, Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        netdev@vger.kernel.org, Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-kernel@vger.kernel.org, Varun Sethi <V.Sethi@nxp.com>,
        Marcin Wojtas <mw@semihalf.com>,
        "Rajesh V . Bikkina" <rajesh.bikkina@nxp.com>,
        Pankaj Bansal <pankaj.bansal@nxp.com>,
        Makarand Pawagi <makarand.pawagi@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>
Subject: Re: [RFC net-next PATCH v2 2/2] net: dpaa2-mac: Add ACPI support for
 DPAA2 MAC driver
Message-ID: <20200420135354.GA27078@lsv03152.swis.in-blr01.nxp.com>
References: <20200418105432.11233-1-calvin.johnson@oss.nxp.com>
 <20200418105432.11233-3-calvin.johnson@oss.nxp.com>
 <20200418113813.GT25745@shell.armlinux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200418113813.GT25745@shell.armlinux.org.uk>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: SG2PR01CA0158.apcprd01.prod.exchangelabs.com
 (2603:1096:4:28::14) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR01CA0158.apcprd01.prod.exchangelabs.com (2603:1096:4:28::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.25 via Frontend Transport; Mon, 20 Apr 2020 13:54:01 +0000
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: fc0edaf5-1373-4185-c081-08d7e5324b20
X-MS-TrafficTypeDiagnostic: AM0PR04MB5938:|AM0PR04MB5938:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB59388CA4E878BA67379858AED2D40@AM0PR04MB5938.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 03793408BA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(396003)(136003)(376002)(39860400002)(346002)(366004)(6916009)(55016002)(66556008)(66476007)(9686003)(6506007)(86362001)(1076003)(316002)(66946007)(55236004)(7696005)(52116002)(7416002)(26005)(54906003)(966005)(956004)(4326008)(44832011)(6666004)(1006002)(5660300002)(33656002)(2906002)(8676002)(186003)(16526019)(81156014)(478600001)(8936002)(110426005);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: oss.nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e/rx6VPrQO6gR2mT08ttmp5HbGlshmeCHxEd/lTUtmC78WhJbmsWDTCmhhXVCGBqplvYaghuapjsGrDQH+pjpWKJjFWhK1kNAC3zgj7/bJu9Xn9dMcAsawDiMmEb+fMc8oFIDiFCH+FZZeZLBIhtOFl7g4yyUwodT9ybn2qkaM2gyJG9Yr0bZBJ4HJWF6+/sM2qcuKfdV50DkuxH2XCBoqcnuOJVJgkSZhtm4Kc3ncYoWcqoiJE6PF0BhoC57KkSnsZ2T+yk3WM3iQOYGUmEt/PyzBlnHMuZ5u+sjbw8zvk1j2DlCaaAKqI00Jse4P6qpFhASKblxXhcCBBi3Rx0AKb2qflXdQbGzTk8ytXrIL8/sudWZHh8w7JIdTvI9/AXEkaPCmltkXdQ3E7VKIt1f1DSotWG55kwRLeJUiu03VyO8nW/DFSzc8yqXAT7AO+/XBvIB+VcezxzEllmA+vC3J21bZml2xS4aKRW2rPMsTiaa072v41LcjxkAsw7H1KpiDyREQMUtKQeIP9YdmCxbB+AFk4loBjyzsKlFFxP9PHypM1C4MFNlplYtG6ANqvvAkmcjl7xAAcLB/j3UHE0lQ==
X-MS-Exchange-AntiSpam-MessageData: JDuie+Bo5ILJct6C9WdFoVNwnIgOdwKXRtsuScTjGqzvoB2iEAwlj9eVMs7c+PQhF35oMtbbsWd42IAf5LYgV7mAsNkF1HED7QFui2K66mXOGmGxKs6wFCkZmKiZcvP/gEA+lG18sYEuTN7jUojbQA==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc0edaf5-1373-4185-c081-08d7e5324b20
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2020 13:54:07.1725
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b3uAFPiL9WDk6eIDf6QvMGJCDU4HNPdbZ1XciV98c6XdwVkFnJNnNW9RwlBV2JpK3pTP+/nLNw+E0lvBDXAfbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5938
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 18, 2020 at 12:38:13PM +0100, Russell King - ARM Linux admin wrote:
> On Sat, Apr 18, 2020 at 04:24:32PM +0530, Calvin Johnson wrote:
> > Modify dpaa2_mac_connect() to support ACPI along with DT.
> > Modify dpaa2_mac_get_node() to get the dpmac fwnode from either
> > DT or ACPI.
> > Replace of_get_phy_mode with fwnode_get_phy_mode to get
> > phy-mode for a dpmac_node.
> > Define and use helper functions fwnode_phy_match() and
> > fwnode_phy_find_device() to find phy_dev that is later
> > connected to mac->phylink.
> > 
> > Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
> > ---
> > 
> > Changes in v2:
> > - Major change following other network drivers supporting ACPI
> > - dropped v1 patches 1, 2, 4, 5 and 6 as they are no longer valid
> > - incorporated other v1 review comments
> > 
> >  .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  | 122 ++++++++++++++----
> >  1 file changed, 94 insertions(+), 28 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
> > index 3ee236c5fc37..5a03da54a67f 100644
> > --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
> > +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
> > @@ -3,6 +3,9 @@
> >  
> >  #include "dpaa2-eth.h"
> >  #include "dpaa2-mac.h"
> > +#include <linux/acpi.h>
> > +#include <linux/phy.h>
> > +#include <linux/phylink.h>
> 
> Why do you need linux/phy.h and linux/phylink.h here?  Please try
> building the driver without; you'll find they are already included
> via dpaa2-mac.h.

You are right. I'll remove them in v3

> > +static int fwnode_phy_match(struct device *dev, const void *phy_fwnode)
> > +{
> > +	return dev->fwnode == phy_fwnode;
> > +}
> > +
> > +static struct phy_device *fwnode_phy_find_device(struct fwnode_handle *phy_fwnode)
> > +{
> > +	struct device *d;
> > +	struct mdio_device *mdiodev;
> > +
> > +	if (!phy_fwnode)
> > +		return NULL;
> > +
> > +	d = bus_find_device(&mdio_bus_type, NULL, phy_fwnode, fwnode_phy_match);
> > +	if (d) {
> > +		mdiodev = to_mdio_device(d);
> > +		if (mdiodev->flags & MDIO_DEVICE_FLAG_PHY)
> > +			return to_phy_device(d);
> > +		put_device(d);
> > +	}
> > +
> > +	return NULL;
> > +}
> 
> This is groping around in the mdio bus implementation details; drivers
> must not do this layering violation.  Please propose an interface in
> the mdio code to do what you need.

I'll study and propose a solution.

> 
> > +
> >  int dpaa2_mac_connect(struct dpaa2_mac *mac)
> >  {
> >  	struct fsl_mc_device *dpmac_dev = mac->mc_dev;
> >  	struct net_device *net_dev = mac->net_dev;
> > -	struct device_node *dpmac_node;
> > +	struct fwnode_handle *dpmac_node = NULL;
> > +	struct fwnode_reference_args args;
> > +	struct phy_device *phy_dev;
> >  	struct phylink *phylink;
> >  	struct dpmac_attr attr;
> > +	int status;
> >  	int err;
> >  
> >  	err = dpmac_open(mac->mc_io, 0, dpmac_dev->obj_desc.id,
> > @@ -251,7 +299,7 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
> >  
> >  	mac->if_link_type = attr.link_type;
> >  
> > -	dpmac_node = dpaa2_mac_get_node(attr.id);
> > +	dpmac_node = dpaa2_mac_get_node(&mac->mc_dev->dev, attr.id);
> >  	if (!dpmac_node) {
> >  		netdev_err(net_dev, "No dpmac@%d node found.\n", attr.id);
> >  		err = -ENODEV;
> > @@ -269,7 +317,7 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
> >  	 * error out if the interface mode requests them and there is no PHY
> >  	 * to act upon them
> >  	 */
> > -	if (of_phy_is_fixed_link(dpmac_node) &&
> > +	if (of_phy_is_fixed_link(to_of_node(dpmac_node)) &&
> >  	    (mac->if_mode == PHY_INTERFACE_MODE_RGMII_ID ||
> >  	     mac->if_mode == PHY_INTERFACE_MODE_RGMII_RXID ||
> >  	     mac->if_mode == PHY_INTERFACE_MODE_RGMII_TXID)) {
> > @@ -282,7 +330,7 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
> >  	mac->phylink_config.type = PHYLINK_NETDEV;
> >  
> >  	phylink = phylink_create(&mac->phylink_config,
> > -				 of_fwnode_handle(dpmac_node), mac->if_mode,
> > +				 dpmac_node, mac->if_mode,
> >  				 &dpaa2_mac_phylink_ops);
> >  	if (IS_ERR(phylink)) {
> >  		err = PTR_ERR(phylink);
> > @@ -290,20 +338,38 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
> >  	}
> >  	mac->phylink = phylink;
> >  
> > -	err = phylink_of_phy_connect(mac->phylink, dpmac_node, 0);
> > +	if (is_of_node(dpmac_node))
> > +		err = phylink_of_phy_connect(mac->phylink,
> > +					     to_of_node(dpmac_node), 0);
> > +	else if (is_acpi_node(dpmac_node)) {
> > +		status = acpi_node_get_property_reference(dpmac_node,
> > +							  "phy-handle",
> > +							  0, &args);
> > +		if (ACPI_FAILURE(status))
> > +			goto err_phylink_destroy;
> > +		phy_dev = fwnode_phy_find_device(args.fwnode);
> > +		if (!phy_dev)
> > +			goto err_phylink_destroy;
> > +
> > +		err = phylink_connect_phy(mac->phylink, phy_dev);
> > +		if (err)
> > +			phy_detach(phy_dev);
> 
> phy_detach() reverses the effect of phy_attach_direct().  This is not
> the correct cleanup function in this case, because the PHY hasn't been
> attached (and phylink_connect_phy() will clean up any effects it has
> on error.)  You only need to reverse the effect of your
> fwnode_phy_find_device(), which phy_detach() is inappropriate for.

Got it. I'll repair this part.

> 
> In any case, if this method of getting a PHY is accepted by ACPI folk,
> it could be moved into a helper in phylink_fwnode_phy_connect() - and
> that really needs to happen before a patch adding this functionality is
> acceptable.

There is already similar code in upstream kernel:
https://elixir.bootlin.com/linux/v5.7-rc2/source/drivers/net/ethernet/apm/xgene/xgene_enet_hw.c#L825
It makes sense to have a generic helper. Will create one.
Hope I can introduce it in the v3 patchset, ofcourse phylink_fwnode_phy_connect will be
defined in a patch before it is called. Let me know if it is not okay.

> 
> > +	}
> >  	if (err) {
> > -		netdev_err(net_dev, "phylink_of_phy_connect() = %d\n", err);
> > +		netdev_err(net_dev, "phylink_fwnode_phy_connect() = %d\n", err);
> 
> That's a very misleading change - there is no function named as per your
> new name.
My bad. Sorry. Will correct it.

Thanks
Calvin
