Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E95A92037B5
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 15:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728890AbgFVNRG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 09:17:06 -0400
Received: from mail-eopbgr00044.outbound.protection.outlook.com ([40.107.0.44]:27118
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728243AbgFVNRG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 09:17:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T44AXyl7aEzHTA/Ow/lVE0eG8iIdIliY9Nj016QWqu+ozovB+UTRFq4sX6LPAkTD3DRiWl7S0BshXDSicssgY0SX55451EX6PlSNuzvH8gaZJyIHJPDtJ1nMxkLbl/3uRMZPgnPnEkyP7mRMMCYwavyXDQF1ZrM04FHbQtiI/2VBrHDLLmiSbTddJIRcfv3GdSmOR4zW6TTrE0/1pxTnp2oPxMJOeLE75H+iDEDFWSVdl65z6KMMw65yLG1eDAhao9lhc99h/D7pD1rUF/JJArVg60RvJRP31QNrSSRR6tXLDABrH9nAkbAboxW4nGDxUMdQiAk8wighXVPoSL5MuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=quW9MXs0K7TUp0snrohqKY1sHmBmuCFdhHMFI9xU2mM=;
 b=P6JBD8drHadTYlQ1cXICKZ1npGFBMs+kQo3KsO7ZIN3gQ12aFUcO9SS/ZatFpuBmHc+0Hrr25Fcum87J2RGuZST91DeG1J8akSPiMvXsM9hmq9tW1vGzEgQS3casuw9JY3WjzP9SJuBKmr0V+xxR9YlzY+I9QRyvLZwGnxQsT+1YTR+eJCdJtI6IFXbCsy0d1PSBEPtHrZSr028kWcn7L5tVj1wrbkHF913vAXnQh26I8xjz8IzxPu/7PbjrM5mjlRwIOME93hNOqG8XFNdtUARFxVEd9dIb6eq6WknLqP5NYrr/OuMN7aTOiKn5HLIA2ReCFSSYEm5Jo5TM0GLkEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=quW9MXs0K7TUp0snrohqKY1sHmBmuCFdhHMFI9xU2mM=;
 b=eVa4yWdXNUJAWKZ95hAIYBLYONzBIYsjUnjMX7opTvN6b9Sloy621YFQY6bnyJzLWKi7UdRnYlmIYIlDV9c+JaHf+uL9Zx+ahAJlWDba6ShntF8w7mqGXlfWLmvZjSpapn4JyzdojCTvtbnAxc0YwaotHoqf6H1Et5Uo8JB4fYQ=
Authentication-Results: oss.nxp.com; dkim=none (message not signed)
 header.d=none;oss.nxp.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB5331.eurprd04.prod.outlook.com (2603:10a6:208:65::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Mon, 22 Jun
 2020 13:17:02 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45%7]) with mapi id 15.20.3109.027; Mon, 22 Jun 2020
 13:17:01 +0000
Date:   Mon, 22 Jun 2020 18:46:52 +0530
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
Cc:     Jeremy Linton <jeremy.linton@arm.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "linux.cj@gmail.com" <linux.cj@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [net-next PATCH v2 1/3] net: phy: Allow mdio buses to auto-probe
 c45 devices
Message-ID: <20200622131652.GA5822@lsv03152.swis.in-blr01.nxp.com>
References: <20200622081914.2807-1-calvin.johnson@oss.nxp.com>
 <20200622081914.2807-2-calvin.johnson@oss.nxp.com>
 <AM6PR04MB3976D2F9DFD9EE940356D31CEC970@AM6PR04MB3976.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM6PR04MB3976D2F9DFD9EE940356D31CEC970@AM6PR04MB3976.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: SG2PR01CA0153.apcprd01.prod.exchangelabs.com
 (2603:1096:4:8f::33) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR01CA0153.apcprd01.prod.exchangelabs.com (2603:1096:4:8f::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22 via Frontend Transport; Mon, 22 Jun 2020 13:16:58 +0000
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f5f10179-567d-4262-e369-08d816ae8c82
X-MS-TrafficTypeDiagnostic: AM0PR04MB5331:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB5331EFEC429E5D66E38E0433D2970@AM0PR04MB5331.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0442E569BC
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oVqedJH9y3UgI/zlQPGIjtIKqg1lwjn5cYGUPyZINFfPeLhmdTwGg+Otcb4TSZTe7V1Skh2L9d0OnxyudJb0uCscMZLwvaCvGJMZ3eLSx8QFQgUmCKm24BoMOmq1hgCGm0qz2l2JOU4p8fXO237IkC/sJd3DRAJ60qzrOyTvHB3iRGdmNZHvlu1RqaMGeg9GaAiNfDrKdLJRd+AmbMGWjloTPQqeBngpZ6mN6bavGr5dX2Tp3RzYmtILunSBsNGb99SeNMOA2fVNSfTxLx6iTh5tQF1xjlnfTMoFNgJIl2QbZmwvzaJdy0Cp0u7yOxddmCCDzb6HC+FFjNNbCPrk4cxIhB+wF/NwWIGAQLiLAWeDypVkhnhHPgFbd+aH0q2q
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(136003)(376002)(39860400002)(346002)(366004)(1006002)(6666004)(956004)(53546011)(6636002)(6506007)(1076003)(16526019)(186003)(44832011)(83380400001)(86362001)(55236004)(5660300002)(26005)(66946007)(66556008)(66476007)(478600001)(2906002)(33656002)(7696005)(4326008)(52116002)(55016002)(6862004)(8936002)(9686003)(316002)(8676002)(54906003)(110426005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 5EKX0980Y1IkwP0K9AULTUDqndA0L6rXTLZzxVpAuHBZ0wKEsB1Nc9xFTj9QKqlSwv8XKCHfCMmX0kse9gqWSDZd6Nf4WbWi32eHBpfR7zVZvCraJy9jXTGRp7eCotbhg2r9P64j6lbg/y5VcBZXL1crFizORt7LnLzoCbLPOYjMD227Uheuj+9ggX7ls1hkfODehgIltQ4Tx9v2Dkkq5mxvkQNxSzwnYQvRczsJg7gqxKmRI9ZhutpM0Yf6qAu8gVEEL8xb/LoPfwqgufwkVWJaxv/B179txTYxqinc6U3LyALHD9E2iTxkmIqNbesozpDTavDKi2/a9rpPKdaZslEySuD7P3/3dP1hUQ5DHROXgtvjHfI0Fg0rGh3zhcFDbQpRqhMmRhN5C11Qk6FCYIZUrdEX0J6I3As97SNlR4y2WHmD1rqpTfSWNVDZck6gXUxJoU+ngal737npY89nAvi0PVoAfl5LZp/gufIh/czbmH/I7FZQvERdGVCdiVoy
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5f10179-567d-4262-e369-08d816ae8c82
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2020 13:17:01.5221
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mBDbACyc7C5kdHePSvBYzp10NUhsCnGt0rI6k3Y1SQgz7DE3KSnSmKbqKbPvBJEihXy1eCUZw4IjKh99Rk3T3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5331
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 22, 2020 at 09:29:17AM +0000, Madalin Bucur (OSS) wrote:
> > -----Original Message-----
> > From: Calvin Johnson (OSS) <calvin.johnson@oss.nxp.com>
> > Sent: Monday, June 22, 2020 11:19 AM
> > To: Jeremy Linton <jeremy.linton@arm.com>; Russell King - ARM Linux admin
> > <linux@armlinux.org.uk>; Jon <jon@solid-run.com>; Cristi Sovaiala
> > <cristian.sovaiala@nxp.com>; Ioana Ciornei <ioana.ciornei@nxp.com>; Andrew
> > Lunn <andrew@lunn.ch>; Andy Shevchenko <andy.shevchenko@gmail.com>;
> > Florian Fainelli <f.fainelli@gmail.com>; Madalin Bucur (OSS)
> > <madalin.bucur@oss.nxp.com>
> > Cc: linux.cj@gmail.com; netdev@vger.kernel.org; Calvin Johnson (OSS)
> > <calvin.johnson@oss.nxp.com>
> > Subject: [net-next PATCH v2 1/3] net: phy: Allow mdio buses to auto-probe
> > c45 devices
> > 
> > From: Jeremy Linton <jeremy.linton@arm.com>
> > 
> > The mdiobus_scan logic is currently hardcoded to only
> > work with c22 devices. This works fairly well in most
> > cases, but its possible that a c45 device doesn't respond
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
> 
> How is this default working for existing users, the code below does not seem
> to do anything for a zeroed struct, as there is no default in the switch?

Looking further into this, I think MDIOBUS_C22 = 0, was correct. Prior to
this patch, get_phy_device() was executed for C22 in this path. I'll discuss
with Russell and Andrew on this and get back.

> 
> > 
> > Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
> > Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
> > 
> > ---
> > 
> > Changes in v2:
> > - Reserve "0" to mean that no mdiobus capabilities have been declared.
> > 
> >  drivers/net/phy/mdio_bus.c | 17 +++++++++++++++--
> >  include/linux/phy.h        |  8 ++++++++
> >  2 files changed, 23 insertions(+), 2 deletions(-)
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
> > index 9248dd2ce4ca..7860d56c6bf5 100644
> > --- a/include/linux/phy.h
> > +++ b/include/linux/phy.h
> > @@ -298,6 +298,14 @@ struct mii_bus {
> >  	/* RESET GPIO descriptor pointer */
> >  	struct gpio_desc *reset_gpiod;
> > 
> > +	/* bus capabilities, used for probing */
> > +	enum {
> > +		MDIOBUS_NO_CAP = 0,
> > +		MDIOBUS_C22,
> > +		MDIOBUS_C45,
> > +		MDIOBUS_C22_C45,
> > +	} probe_capabilities;
> > +
> >  	/* protect access to the shared element */
> >  	struct mutex shared_lock;
> > 
> > --
> > 2.17.1
> 
