Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E32F11FF415
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 16:01:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730458AbgFROAv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 10:00:51 -0400
Received: from mail-db8eur05on2063.outbound.protection.outlook.com ([40.107.20.63]:6080
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726001AbgFROAo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jun 2020 10:00:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Us5GBH1dpZMF6qIppcvtU9MYGX/eXfa1hVHDyRxro+S4Ko3MJpegWaXZacT5eCsqhCLWRhiu7ldiFEQBefx1MRA7XLkwuvyj6OIPnoRylGOHnAwVG/nuu2Q2BUqnW8d1IDZQ8p2Z2adabX271ecT64Ev4SCw9QL5WRz2x2M0gELBNspcdOROGUrtpQt0xDFuTMi5S7e1czu4nIh3eiu7y+SrzEamjuI5+jaBGFCJVvZbhnaLWQjFEMqOk4uiIePmhObbpln4w9CiyqhrflpG6RZnWH3vssIacbUIFBPaoJ/AivhacT4DLVN5k5VK4gKgBQLRpulnA1z56cuztQ4U6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wpbfa3nMfakXgxhsh04piFmvvsYyAcIQVw4KJCXV/ro=;
 b=CPG1W57AO4MOLYqeC+NxqDMByfZ5T3MIPl4P8tn4U7RtnHIEveFkJ23ybH2IQ1h6V8CX0x2L3jJhHKgfckO/VXJfLzwYFqiKXAJpYaf/82IQ2o0nxUfx+6ui5j1cOVHKkEqpDwfcjEgJ5pqOPFzoNulpdDZrmGT/dIcH3XQpq0kSmRzCURKRwthC5Ll+mMGJwOyqRnELplVqB2D51YGeuEl92IzipQfPSPjgZhWKt4lASbKpuY03CX6JTjpGLKtL0gPnF/rpT0+2KKkug7UjJfZ2EQ4L13D7RW60hvB2c+duGlXcZnGVFOQPdXUBrrbNIXg555B6DjGNYzK5MuAaJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wpbfa3nMfakXgxhsh04piFmvvsYyAcIQVw4KJCXV/ro=;
 b=gBXED52W2IHs5HlZ6RMdPSTTA47GkCKie+Kbs33GnKwEpbGlfJhyjLP4CGWrT+2o/xZup7fzX+LZAznA3rQB3c6+xNDbhjiNyHpMZm4/JqAUH6MupHJFbVH08PrwP4VFBGE0fMWKWeoWBvdYdLtv1j2ERRSucxoI89DmqvRZirY=
Authentication-Results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none
 header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB5057.eurprd04.prod.outlook.com (2603:10a6:208:c7::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.22; Thu, 18 Jun
 2020 14:00:40 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45%7]) with mapi id 15.20.3088.028; Thu, 18 Jun 2020
 14:00:40 +0000
Date:   Thu, 18 Jun 2020 19:30:30 +0530
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Jeremy Linton <jeremy.linton@arm.com>, Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        netdev@vger.kernel.org, linux.cj@gmail.com
Subject: Re: [PATCH v1 1/3] net: phy: Allow mdio buses to auto-probe c45
 devices
Message-ID: <20200618140030.GA31155@lsv03152.swis.in-blr01.nxp.com>
References: <20200617171536.12014-1-calvin.johnson@oss.nxp.com>
 <20200617171536.12014-2-calvin.johnson@oss.nxp.com>
 <20200617174451.GT1551@shell.armlinux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200617174451.GT1551@shell.armlinux.org.uk>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: SG2PR06CA0162.apcprd06.prod.outlook.com
 (2603:1096:1:1e::16) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR06CA0162.apcprd06.prod.outlook.com (2603:1096:1:1e::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.21 via Frontend Transport; Thu, 18 Jun 2020 14:00:36 +0000
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 50152b5a-e0b0-4be1-8941-08d8138ffb85
X-MS-TrafficTypeDiagnostic: AM0PR04MB5057:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB50570AD73D21251CF48C2C7BD29B0@AM0PR04MB5057.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0438F90F17
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PbEE77w8sdV+bpncmoiQ4AB0+tsOODsXOh7hI6VBDB8BJc79JqTF7rrKA/hFuJot6RLRIEukDwruUbASIWHiAnZfgvDdtgpODG3uzXJ1etj+OqPjspwciUHvAdjQcuVF/zgTswPeZp0mhZauWdS+tVteMX+NDzGIlFaOZiYvoF23NDskk5rFzFPDKiv7Af83Zd9IZGudzuJQXbY+dQjDmiDkhALNbaUReYm6lqEKu4/V/7EmgIUk/eDvuURu3cNrsMg+Gib0uwPnTdcoij4PrcWn4VXr6mbH2+AHKnPjxkUK5JzKpjaYvSMAhHqvsSvLgzffzO1oQPH7tN8nCExJ2VmLiFz116SMP3I4mIcnx2deNxV7M1hJ1uL77PyX7ub1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(376002)(136003)(346002)(396003)(478600001)(956004)(55236004)(26005)(66476007)(186003)(55016002)(54906003)(9686003)(66946007)(66556008)(16526019)(5660300002)(33656002)(7696005)(6666004)(6916009)(6506007)(1006002)(8936002)(8676002)(1076003)(316002)(4326008)(44832011)(86362001)(2906002)(52116002)(83380400001)(110426005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: W77yibBJNGVxHRLUNmHyPvDS5bH1M++xxgX78hjCPH1Uf1a7pImCx6cW6WO1oyBXxUitlFkG65z6xL25yJUxDxMGLSEIi50ymBdTzzKcy4ybbTJfSvDhC+3Jyyp014tNxqfcziYDNmte6FiKnHqOCQTw5BHcB6+m2BbGvTfE2R2PzVB7oesQD810foHLfDL0fXS+z03c8PSIuRRFjoSnr6YPGLvgC74tkImDpdSvxjmum4FrGCLKL1XU++2ZnKkqOmGCSGalL6hspdiyVUXT05zWXyQLGS9gvgxpT/D/B6Ng0MeKvLiytrwZToPIDpdRJhJdzOHV7EfBV8ZkKGlBmgXZCLPM259YuEfG4ziAhPHomC6qJR3xbvukeNw70jqYCOxy+JjGceVudtuZkSF6z41jWsy/vBcLgo3YbY2d+sxaeCHYtAnMV862izU3TOmpEtRwJk07RUAPtUHvGouHiYPW61QsKGz88kbl1RPsLuqhUz2i+OjlRagCn0ARsiMH
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50152b5a-e0b0-4be1-8941-08d8138ffb85
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2020 14:00:39.9455
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SxXOO3ix9hgIdBuBqYCPs+RiW6PRytGhkPztRMFbLn4v8tMNpHtGuut0LSt3HT41C6iA6Njn64a8CFnIY4LpGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5057
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 17, 2020 at 06:44:51PM +0100, Russell King - ARM Linux admin wrote:
> On Wed, Jun 17, 2020 at 10:45:33PM +0530, Calvin Johnson wrote:
> > From: Jeremy Linton <jeremy.linton@arm.com>
> > 
> > The mdiobus_scan logic is currently hardcoded to only
> > work with c22 devices. This works fairly well in most
> > cases, but its possible a c45 device doesn't respond
> > despite being a standard phy. If the parent hardware
> > is capable, it makes sense to scan for c22 devices before
> > falling back to c45.
> > 
> > As we want this to reflect the capabilities of the STA,
> > lets add a field to the mii_bus structure to represent
> > the capability. That way devices can opt into the extended
> > scanning. Existing users should continue to default to c22
> > only scanning as long as they are zero'ing the structure
> > before use.
> > 
> > Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
> > Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
> 
> I know that we've hashed this out quite a bit already, but I would like
> to point out that include/linux/mdio.h contains:
> 
>  * struct mdio_if_info - Ethernet controller MDIO interface
>  * @mode_support: MDIO modes supported.  If %MDIO_SUPPORTS_C22 is set then
>  *      MII register access will be passed through with @devad =
>  *      %MDIO_DEVAD_NONE.  If %MDIO_EMULATE_C22 is set then access to
>  *      commonly used clause 22 registers will be translated into
>  *      clause 45 registers.
> 
> #define MDIO_SUPPORTS_C22               1
> #define MDIO_SUPPORTS_C45               2
> #define MDIO_EMULATE_C22                4
> 
> While this structure is not applicable to phylib or mii_bus, it may be
> worth considering that there already exist definitions for identifying
> the properties of the underlying bus.

Can we reuse these or go ahead with the new MDIOBUS_C22?

> 
> > ---
> > 
> >  drivers/net/phy/mdio_bus.c | 17 +++++++++++++++--
> >  include/linux/phy.h        |  7 +++++++
> >  2 files changed, 22 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
> > index 6ceee82b2839..e6c179b89907 100644
> > --- a/drivers/net/phy/mdio_bus.c
> > +++ b/drivers/net/phy/mdio_bus.c
> > @@ -739,10 +739,23 @@ EXPORT_SYMBOL(mdiobus_free);
> >   */
> >  struct phy_device *mdiobus_scan(struct mii_bus *bus, int addr)
> >  {
> > -	struct phy_device *phydev;
> > +	struct phy_device *phydev = ERR_PTR(-ENODEV);
> >  	int err;
> >  
> > -	phydev = get_phy_device(bus, addr, false);
> > +	switch (bus->probe_capabilities) {
> > +	case MDIOBUS_C22:
> > +		phydev = get_phy_device(bus, addr, false);
> > +		break;
> > +	case MDIOBUS_C45:
> > +		phydev = get_phy_device(bus, addr, true);
> > +		break;
> > +	case MDIOBUS_C22_C45:
> > +		phydev = get_phy_device(bus, addr, false);
> > +		if (IS_ERR(phydev))
> > +			phydev = get_phy_device(bus, addr, true);
> > +		break;
> > +	}
> > +
> >  	if (IS_ERR(phydev))
> >  		return phydev;
> >  
> > diff --git a/include/linux/phy.h b/include/linux/phy.h
> > index 9248dd2ce4ca..50e5312b2304 100644
> > --- a/include/linux/phy.h
> > +++ b/include/linux/phy.h
> > @@ -298,6 +298,13 @@ struct mii_bus {
> >  	/* RESET GPIO descriptor pointer */
> >  	struct gpio_desc *reset_gpiod;
> >  
> > +	/* bus capabilities, used for probing */
> > +	enum {
> > +		MDIOBUS_C22 = 0,
> > +		MDIOBUS_C45,
> > +		MDIOBUS_C22_C45,
> > +	} probe_capabilities;
> 
> I think it would be better to reserve "0" to mean that no capabilities
> have been declared.  We hae the situation where we have mii_bus that
> exist which do support C45, but as they stand, probe_capabilities will
> be zero, and with your definitions above, that means MDIOBUS_C22.
> 
> It seems this could lock in some potential issues later down the line
> if we want to use this elsewhere.

I'll change it to :

enum {
	MDIOBUS_C22 = 1,
	MDIOBUS_C45,
	MDIOBUS_C22_C45,
} probe_capabilities;

Thanks
Calvin
