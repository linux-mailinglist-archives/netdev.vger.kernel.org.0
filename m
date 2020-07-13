Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B214521CF21
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 08:04:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728945AbgGMGEd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 02:04:33 -0400
Received: from mail-eopbgr130041.outbound.protection.outlook.com ([40.107.13.41]:28389
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726380AbgGMGEc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jul 2020 02:04:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lBURrvCb463kVdOqbpUE+9uh6G7qp0Cnbu4iCQ1BvTKRVoKBtMGWiCWrpfPjyRrh7GyWeKYV8SMpiUI5mGzvNpkezTcv29mGQoMoq8vViTZrUMDRe3IzMbXFXC059LdNnLDwPG3lqMztbiE8Q+wMWCHIX2yAnxRejI3fkaH8w76b6FkInqsdNwJmz5nZ2jQez85YhAlkM4Dyk+23uLpbT9xuPXuLMpdDFYjqBeqEJgSoNDm4GIC7VNdkOwVHaIhAXA1M3EQa2yOeBq7R9/TQMHwm4yJ4jKEUZ9qpjT3Cxol1PmTXGiEId4IiJJ5KZateI1xwcs15o7fqouL7aWumLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GdUKU5BfOm+YOTTOGhGwkBXhDhlc11mu+NPdAyYsMEE=;
 b=Lu+hWISQfB9v6GryhDKXSTKePLyzkwqB0rlhyTd3XNATAX2Fg9X1Mha5inqTGp2GA4f2znGiAAroAefidWO3kFPcQZDX6j+1jEs7NXM3iVObkaJ5GkUFs/jNefkxrkFv4bg0rrIVAuDp3P9G80PN32F/vMbAh/Gi18PHSAUEoGHmjiaMGiiaSHVNprtqZZf47yp0ja4J38cNq5fWl28n2mJqE+c7gQSsDLhxZhyTBZyOdMUIKyehu6OSq8iYe7s3bu4vKJ0DwlQs2Sm8AzSBh5imMaenqM8sxCB90arWxePEtGloP7K2oSwcnvX9ZgqX9c3Pd97unWBVardVcPfB9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GdUKU5BfOm+YOTTOGhGwkBXhDhlc11mu+NPdAyYsMEE=;
 b=JCUpCBrBc5njvzC+mNNfj/bb45kYFIONqYeacBRqn2Ud2j5GfEj9A+vO+gODKhYn+hYrD74BS3mQEKB3vsKg7zZKO0zbzt+v7nSuVyC5MehKjG1i7tvZJaeXs/FAENIM6t8U1Gf80ZTVWaJT9bJyLok4O4Mlt5PX1PdrGN9r2CE=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB3954.eurprd04.prod.outlook.com (2603:10a6:208:63::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22; Mon, 13 Jul
 2020 06:04:27 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45%7]) with mapi id 15.20.3174.025; Mon, 13 Jul 2020
 06:04:27 +0000
Date:   Mon, 13 Jul 2020 11:34:16 +0530
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Jeremy Linton <jeremy.linton@arm.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        netdev@vger.kernel.org, linux.cj@gmail.com,
        linux-acpi@vger.kernel.org
Subject: Re: [net-next PATCH v6 4/6] net: phy: introduce
 phy_find_by_mdio_handle()
Message-ID: <20200713060416.GB2540@lsv03152.swis.in-blr01.nxp.com>
References: <20200711065600.9448-1-calvin.johnson@oss.nxp.com>
 <20200711065600.9448-5-calvin.johnson@oss.nxp.com>
 <931b7557-fefb-52c5-61dd-6ab13f7b5396@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <931b7557-fefb-52c5-61dd-6ab13f7b5396@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: SG2PR0401CA0014.apcprd04.prod.outlook.com
 (2603:1096:3:1::24) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR0401CA0014.apcprd04.prod.outlook.com (2603:1096:3:1::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20 via Frontend Transport; Mon, 13 Jul 2020 06:04:23 +0000
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 723e9926-2dc3-476b-b1df-08d826f29922
X-MS-TrafficTypeDiagnostic: AM0PR04MB3954:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB3954380675E4474AB82ED1B9D2600@AM0PR04MB3954.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PvolySeHe+drU1GOACfQmOXFypyKffq6YjsLfN1NHfCzubyJ4GvGWzg1sVxUHEJuLOPqLKw2LfMEQSSzaTB66oKKil3oJdfrBDHLyXnlIyaBhM7pzplCIQ/3ycXlD4aWHF6xLk5q1TgtLzRRggL4mA7finsykKDXrpyBoudZ7EVBT/nm/PyKn1JpIr3ZYTglY26Nl6cuRKVKSbNEzuiQYRUafsbc4tfq5sQsAXuOjbNuaXOCVcejjYY/j30puHCdk7R+ZK7rvQbNyMJI+ka1YpaIEECkAVoHlqqhTwsWe/pbOPKWdaMxsVZTsKrYTIg9RGuAgyJEAuUs3GF5PHqbSygDLgQEpuSyAZBmvneqdF5Y9OjFvM0q39prVWbRWAn3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(376002)(39860400002)(346002)(136003)(396003)(9686003)(6506007)(55016002)(1076003)(5660300002)(316002)(66946007)(66556008)(52116002)(55236004)(66476007)(8936002)(86362001)(44832011)(7696005)(2906002)(8676002)(33656002)(956004)(53546011)(6916009)(478600001)(16526019)(26005)(1006002)(186003)(54906003)(4326008)(6666004)(110426005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: C36lfb+NWLUTTV2pOP21C7rbCA+G2ZClKxhYB9aR1S9BYYSnbZuQIKcHtHWKvT6bvhBnhuh2QobEJUhvmYumpqHzJAyInG51SMtXllKtuzM4SkM2HExbSMduDEahXn624nuG3glRNXS6u6qcOyRSbxLEZth0HafirfRxB140Ke3Jb9PPyUh8cLtiO6tAHhdU8ZqlQe9jyCXGIWDAre8J+YIdJ06if7S98KtJ2/iBaOZGSglfXJhjXyom3ts4e3CV7ald8c3N23Prs2ch4lVkDKLobdZql98E+19u2WqJ4bHIT4TC9c9SyiL7m0W21wYN8iwio6g413FztTKKQFZFQGGkrFoZiodvNiKogs8+4b9cX3wMlM6+MpUb/U5k6IaLgvWQgTNT9U0dg6JmCl9tfvJtixW+C4sjPtwYRg7tzkYv8nWnCu1c/kiALJCZaRVwQ4sZZfwEgbh0/hTxcbu2SbYa9r60TSj2CjUqbFP166/zkQCmx7lKOTyBUAWmttDt
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 723e9926-2dc3-476b-b1df-08d826f29922
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2020 06:04:26.9642
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5hgMRy3zRycHc5vu+jS3MRXXgqrpyr7rQcVtp4zQv0se59aEN1dtxtD1KcaOLW6FBhsgaJF6SYwD9v2ZDXJH9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB3954
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 11, 2020 at 02:41:12PM -0700, Florian Fainelli wrote:
> 
> 
> On 7/10/2020 11:55 PM, Calvin Johnson wrote:
> > The PHYs on an mdiobus are probed and registered using mdiobus_register().
> > Later, for connecting these PHYs to MAC, the PHYs registered on the
> > mdiobus have to be referenced.
> > 
> > For each MAC node, a property "mdio-handle" is used to reference the
> > MDIO bus on which the PHYs are registered. On getting hold of the MDIO
> > bus, use phy_find_by_fwnode() to get the PHY connected to the MAC.
> > 
> > Introduce fwnode_mdio_find_bus() to find the mii_bus that corresponds
> > to given mii_bus fwnode.
> > 
> > Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
> > 
> > ---
> > 
> > Changes in v6: None
> > Changes in v5:
> > - rename phy_find_by_fwnode() to phy_find_by_mdio_handle()
> > - add docment for phy_find_by_mdio_handle()
> > - error out DT in phy_find_by_mdio_handle()
> > - clean up err return
> > 
> > Changes in v4:
> > - release fwnode_mdio after use
> > - return ERR_PTR instead of NULL
> > 
> > Changes in v3:
> > - introduce fwnode_mdio_find_bus()
> > - renamed and improved phy_find_by_fwnode()
> > 
> > Changes in v2: None
> > 
> >  drivers/net/phy/mdio_bus.c   | 25 ++++++++++++++++++++++
> >  drivers/net/phy/phy_device.c | 40 ++++++++++++++++++++++++++++++++++++
> >  include/linux/phy.h          |  2 ++
> >  3 files changed, 67 insertions(+)
> > 
> > diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
> > index 8610f938f81f..d9597c5b55ae 100644
> > --- a/drivers/net/phy/mdio_bus.c
> > +++ b/drivers/net/phy/mdio_bus.c
> > @@ -435,6 +435,31 @@ struct mii_bus *of_mdio_find_bus(struct device_node *mdio_bus_np)
> >  }
> >  EXPORT_SYMBOL(of_mdio_find_bus);
> >  
> > +/**
> > + * fwnode_mdio_find_bus - Given an mii_bus fwnode, find the mii_bus.
> > + * @mdio_bus_fwnode: fwnode of the mii_bus.
> > + *
> > + * Returns a reference to the mii_bus, or NULL if none found.  The
> > + * embedded struct device will have its reference count incremented,
> > + * and this must be put once the bus is finished with.
> > + *
> > + * Because the association of a fwnode and mii_bus is made via
> > + * mdiobus_register(), the mii_bus cannot be found before it is
> > + * registered with mdiobus_register().
> > + *
> > + */
> > +struct mii_bus *fwnode_mdio_find_bus(struct fwnode_handle *mdio_bus_fwnode)
> > +{
> > +	struct device *d;
> > +
> > +	if (!mdio_bus_fwnode)
> > +		return NULL;
> > +
> > +	d = class_find_device_by_fwnode(&mdio_bus_class, mdio_bus_fwnode);
> > +	return d ? to_mii_bus(d) : NULL;
> > +}
> > +EXPORT_SYMBOL(fwnode_mdio_find_bus);
> > +
> >  /* Walk the list of subnodes of a mdio bus and look for a node that
> >   * matches the mdio device's address with its 'reg' property. If
> >   * found, set the of_node pointer for the mdio device. This allows
> > diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> > index 7cda95330aea..00b2ade9714f 100644
> > --- a/drivers/net/phy/phy_device.c
> > +++ b/drivers/net/phy/phy_device.c
> > @@ -23,8 +23,10 @@
> >  #include <linux/mm.h>
> >  #include <linux/module.h>
> >  #include <linux/netdevice.h>
> > +#include <linux/of.h>
> >  #include <linux/phy.h>
> >  #include <linux/phy_led_triggers.h>
> > +#include <linux/platform_device.h>
> >  #include <linux/property.h>
> >  #include <linux/sfp.h>
> >  #include <linux/skbuff.h>
> > @@ -964,6 +966,44 @@ struct phy_device *phy_find_first(struct mii_bus *bus)
> >  }
> >  EXPORT_SYMBOL(phy_find_first);
> >  
> > +/**
> > + * phy_find_by_mdio_handle - get phy device from mdio-handle and phy-channel
> > + * @fwnode: a pointer to a &struct fwnode_handle  to get mdio-handle and
> > + * phy-channel
> > + *
> > + * Find fwnode_mdio using mdio-handle reference. Using fwnode_mdio get the
> > + * mdio bus. Property phy-channel provides the phy address on the mdio bus.
> > + * Pass mdio bus and phy address to mdiobus_get_phy() and get corresponding
> > + * phy_device. This method is used for ACPI and not for DT.
> > + *
> > + * Returns pointer to the phy device on success, else ERR_PTR.
> > + */
> > +struct phy_device *phy_find_by_mdio_handle(struct fwnode_handle *fwnode)
> > +{
> > +	struct fwnode_handle *fwnode_mdio;
> > +	struct mii_bus *mdio;
> > +	int addr;
> > +	int err;
> > +
> > +	if (is_of_node(fwnode))
> > +		return ERR_PTR(-EINVAL);
> > +
> > +	fwnode_mdio = fwnode_find_reference(fwnode, "mdio-handle", 0);
> 
> I would export the positional argument here to phy_find_by_mdio_handle()
> but have no strong opinion if this is not done right now and punted to
> when another users comes in.

Sorry, I didn't get you. Can you please elaborate?

> 
> > +	mdio = fwnode_mdio_find_bus(fwnode_mdio);
> > +	fwnode_handle_put(fwnode_mdio);
> > +	if (!mdio)
> > +		return ERR_PTR(-ENODEV);
> > +
> > +	err = fwnode_property_read_u32(fwnode, "phy-channel", &addr);
> > +	if (err)
> > +		return ERR_PTR(err);
> > +	if (addr < 0 || addr >= PHY_MAX_ADDR)
> 
> Can an u32 ever be < 0?

Will remove it.

Thanks
Calvin
