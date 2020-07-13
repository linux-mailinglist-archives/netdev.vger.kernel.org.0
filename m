Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E53D21CF16
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 07:57:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729035AbgGMF45 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 01:56:57 -0400
Received: from mail-vi1eur05on2087.outbound.protection.outlook.com ([40.107.21.87]:6043
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725818AbgGMF45 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jul 2020 01:56:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LkbR3s1qM5MkOswn+Hf05BFs0J9xAVn+2f/wVII0Cm9SuOfqUkXLmnMN1iTZnfjHUgf/rodVo6d0ghHDVpyQaH1dFBZyWVOObb42CKqeCGquISxoP2TdE6yuQtZYdYtpitCw3Ck+oRi1GPN/PWtPxkpnAv6CQ/0qNS9M/OARV597B+FVmPgyZ5gQ4hMeEVruxIauyeKXTEg8goclp1/1MbQwc8jFS5q05U2cUFE6GQqRGzA7rDAw60qmfsS6rDHa7Y6neqxoL6LUybVrvqjT722JUL3HsZPlBMM0TLFoJGiQ0kWlFjuYNtzrpRonPdd0LDldZk4F1HuK53leuIqUgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wrKWGiSR3Zv48JtNYIxbahd5KU6IrubJq53aYf+iz+E=;
 b=g1kA2Kl0GpJTAPokJFNnY0OhIQIFfYy7VwVGgbH4+cXwJPZ/FQM2A+ZucNTn4gTQA88Lix+9ygDx7IG9HXBlFasePfY46V4K+ZduKhIv1kSytxaT3FDCurSW3Gfc4cJU/FTyaIB4Q4RNsadp34DSeULOjTGw4OCkGQt17Ki9V6rfwPD5iQLpBgGdCyMLOY79EWFRfVIMH2nw2xSTcbxs52MbY9wSWE6XRRSAisooZdjibx0nuHG9zeZg2AnzK78xiiInRm8QmXrwFlVkLZsnbBVnckD5il20ylOdwwgJebhr81AN99VA18KoYAGK5wAzvmigek1e6Tdj8+Vg5FruhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wrKWGiSR3Zv48JtNYIxbahd5KU6IrubJq53aYf+iz+E=;
 b=IiwvTyIjAIM+qeuQ4fJcCty0Ug7JzC39mS/wnNVhynpAeXo8zsGN5EvbziNNWsi/MltqQ5UVq1DArNbTxpDMs+ltLWoVPCs9+21+SZhLJIrM3JsrQAzLfsDcrIpzklY3Z9DEwB0pxTXQLJFN09zFtpi2eQyxPwlVonqcG8CsLLQ=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB4929.eurprd04.prod.outlook.com (2603:10a6:208:c8::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22; Mon, 13 Jul
 2020 05:56:52 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45%7]) with mapi id 15.20.3174.025; Mon, 13 Jul 2020
 05:56:52 +0000
Date:   Mon, 13 Jul 2020 11:26:41 +0530
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
Subject: Re: [net-next PATCH v6 2/6] net: phy: introduce
 device_mdiobus_register()
Message-ID: <20200713055641.GA2540@lsv03152.swis.in-blr01.nxp.com>
References: <20200711065600.9448-1-calvin.johnson@oss.nxp.com>
 <20200711065600.9448-3-calvin.johnson@oss.nxp.com>
 <a35e0437-0340-a676-619a-f3671b1c1f91@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a35e0437-0340-a676-619a-f3671b1c1f91@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: SGAP274CA0009.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::21)
 To AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SGAP274CA0009.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20 via Frontend Transport; Mon, 13 Jul 2020 05:56:49 +0000
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: bd091d40-487d-4ac3-22b7-08d826f18a74
X-MS-TrafficTypeDiagnostic: AM0PR04MB4929:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB4929416FDE484B18879ED6A4D2600@AM0PR04MB4929.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WjtZgLixn8gchKMNTdSECYuIB+71DbKns2SRGbiqfkr6xLxZJLYSTkW0CnJDu8M6FB0XwsCtoVTR+0kwteTbh6GPrylmTe1KzFO6D8CFxK3/hXNu6JDuciVuQVaRaDNGu4bk/caa+JI/VTwGT8y0P0tqzPKzGQrHU+VaVrm/fm/33RdRgy4kzwqZhiNc57YxVf0AkOiwjaI3imtqg3TkLmVe9UPm7DvSxQYxglNUTGdqpCGMubuhGeDke4DiUmIg9IDprPEPGhSHjuvsFom00upRBuywI2t3H4sxFLlDbMeOqq9+3Ojq+bf6mXIhqTJZd4wAhaOGwyV2fXr/X1UddTYJcr8x7QlhCyIXVZGPr1XZwvmEqRzXx1fzpyaFIqFv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(136003)(346002)(39860400002)(396003)(376002)(6666004)(44832011)(86362001)(956004)(55016002)(316002)(9686003)(186003)(8676002)(16526019)(1076003)(54906003)(33656002)(26005)(2906002)(6916009)(6506007)(478600001)(53546011)(55236004)(5660300002)(8936002)(7696005)(83380400001)(52116002)(4326008)(1006002)(66556008)(66476007)(66946007)(110426005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: r1vJOzHtStNKaLIq92R6mGsP7zc+A75OYRzdAKe22WvP35hV+6VDiT806Es9vnoZoE3+IAcH9TncQoHAQbrysHKYh2bm2rrd9ZHy6g30VxorGVBE4XnxVZ62TRpC89hGqDsTXxg2wZbk3t3nqqBvipNewlYeQgVQjojyd+3lZNRL0g25lux5li0lUh18He/Qgxht34RMTuClmQO7UaktkGmuooMZz4pQ7d4zUc1yBoDB7iiqpZLStZyvT9/Ati41BnySqX2oZMawgV0GxrW1akYlZUyGL4imHOltL/CHJ4jXv6kujODPHNbt7DpNxq0FF//WFgDG0oTTXMt14aYK5t04jhD2V5ymMcf+mPi3wKWX/Z7ApdIj+Gg+cHXln9eOWN2+S3xz9YxGJLvIsfMXL8mE64aAzeAYgAeXxoDjOztntgoTXP9svRdxpo/NJuR5Fvd4NMdNk6YA0I6KXt7nbySC3Fg3mFc9WJsGdxGGiNU=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd091d40-487d-4ac3-22b7-08d826f18a74
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2020 05:56:52.7304
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j3TbFScFDhCR67USQRamEQTTUbUbyYv4HJvxhpQo9hHM2k0LsiuLE+GRMgn0tHrI9hzMl3f2lmalgWcfC+/f/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4929
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 11, 2020 at 02:36:20PM -0700, Florian Fainelli wrote:
> 
> 
> On 7/10/2020 11:55 PM, Calvin Johnson wrote:
> > Introduce device_mdiobus_register() to register mdiobus
> > in cases of either DT or ACPI.
> > 
> > Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
> > 
> > ---
> > 
> > Changes in v6:
> > - change device_mdiobus_register() parameter position
> > - improve documentation
> > 
> > Changes in v5:
> > - add description
> > - clean up if else
> > 
> > Changes in v4: None
> > Changes in v3: None
> > Changes in v2: None
> > 
> >  drivers/net/phy/mdio_bus.c | 26 ++++++++++++++++++++++++++
> >  include/linux/mdio.h       |  1 +
> >  2 files changed, 27 insertions(+)
> > 
> > diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
> > index 46b33701ad4b..8610f938f81f 100644
> > --- a/drivers/net/phy/mdio_bus.c
> > +++ b/drivers/net/phy/mdio_bus.c
> > @@ -501,6 +501,32 @@ static int mdiobus_create_device(struct mii_bus *bus,
> >  	return ret;
> >  }
> >  
> > +/**
> > + * device_mdiobus_register - register mdiobus for either DT or ACPI
> > + * @bus: target mii_bus
> > + * @dev: given MDIO device
> > + *
> > + * Description: Given an MDIO device and target mii bus, this function
> > + * calls of_mdiobus_register() for DT node and mdiobus_register() in
> > + * case of ACPI.
> > + *
> > + * Returns 0 on success or negative error code on failure.
> > + */
> > +int device_mdiobus_register(struct device *dev,
> > +			    struct mii_bus *bus)
> > +{
> > +	struct fwnode_handle *fwnode = dev_fwnode(dev);
> > +
> > +	if (is_of_node(fwnode))
> > +		return of_mdiobus_register(bus, to_of_node(fwnode));
> > +	if (fwnode) {
> > +		bus->dev.fwnode = fwnode;
> > +		return mdiobus_register(bus);
> > +	}
> > +	return -ENODEV;
> > +}
> > +EXPORT_SYMBOL(device_mdiobus_register);
> > +
> >  /**
> >   * __mdiobus_register - bring up all the PHYs on a given bus and attach them to bus
> >   * @bus: target mii_bus
> > diff --git a/include/linux/mdio.h b/include/linux/mdio.h
> > index 898cbf00332a..f454c5435101 100644
> > --- a/include/linux/mdio.h
> > +++ b/include/linux/mdio.h
> > @@ -358,6 +358,7 @@ static inline int mdiobus_c45_read(struct mii_bus *bus, int prtad, int devad,
> >  	return mdiobus_read(bus, prtad, mdiobus_c45_addr(devad, regnum));
> >  }
> >  
> > +int device_mdiobus_register(struct device *dev, struct mii_bus *bus);
> 
> Humm, this header file does not have any of the mii_bus registration
> functions declared, and it typically pertains to mdio_device instances
> which are devices *on* the mii_bus. phy.h may be more appropriate here
> until we break it up into phy_device proper, mii_bus, etc.
> 
> >  int mdiobus_register_device(struct mdio_device *mdiodev);
> >  int mdiobus_unregister_device(struct mdio_device *mdiodev);
> >  bool mdiobus_is_registered_device(struct mii_bus *bus, int addr);

Although some mii_bus registration functions are declared in phy.h, IMO, it
doesn't seem to be the right place. If we look plainly, phy related things
would be expected in phy.h and mdio related in mdio.h. Maybe as you said
we should consider breaking into phy_device proper, mii_bus, etc. We can take it
up later.

Please let me know if you still want device_mdiobus_register() in phy.h.

Thanks
Calvin

