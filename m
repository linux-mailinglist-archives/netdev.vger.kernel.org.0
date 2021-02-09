Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E3FE315256
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 16:06:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232317AbhBIPFo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 10:05:44 -0500
Received: from mail-am6eur05on2078.outbound.protection.outlook.com ([40.107.22.78]:55009
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231576AbhBIPFj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Feb 2021 10:05:39 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fvMBKH6BFYD/ZDjg5B7m1x/bly3UiXwubMC/yEIvwYI24f4W0KnjLMiBqkCz4YOw8/ZYUfDV980vbPlf8S3m+M7coUyv+364uFL/zd3hfd/Al+Ze61Szpqnrq+OSGVgy55iNNbQNpPEy7EBO59btXWhuG4hbgNNcey5VyORZL/KwCdVabnRLxKQO7ytvR59CS9j7wXoS7FYAs3o7lkPtCWTWrbdfLvPa1m6Il3vj9Dks5Xk3aO2XgEl8n88ebIuAWr7gAonDp6KSRYT7BWQYV2ZhuwQstd1qMZ47r2dDx3ynAQpDHtCWQTbSe9Sm9DAELmxXGI0RovGPYq4gFd/WXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oLCvER8KAnvVaWbklgE+2NdSIiHSqUWsJc7oAFN1LO4=;
 b=LmAprO4GRapqTfgkbibfwSySLBd/kqWdPXZY9knZHDO2BikhGZaUiOxRzZWXpOv+rD0x1keqpE3NhKzoRteCFB0HqLQwB+aqcSOCXQxDlvpvcyoX0/NRIZm6Mo9WRoqxOC5l31jvhMFPJkN+wo6CcyMvTvuCJiyPP/SFdXB3xIabEjpEyeHdv4G6yjFDz40Zy28fCO+xC6L0tdOsY9IC9Y+wmzIgjW5DSOKNpWSATOcyK8IvP7Z8lp2pBRVurEAi8bCvyFA5F2UvhUBls2u++KAG7MFFpYbnN77go6kvyTbziLm+2dLy/SPmXYdAk4r5hXZrQ59G50Bbia279zzEJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oLCvER8KAnvVaWbklgE+2NdSIiHSqUWsJc7oAFN1LO4=;
 b=V4XrOX9SYZhiQZiLToj8OXQU5QFaWp9o1yel/jolLreik4Uk0FfBbE5jiWCwAGe91ujMDwGrgOiPGeWbI85cY5dadrWkcJ3w1WpAyNW+0ISx477dHJwH//ry2xi+R2iy97ZQCEkcgDpNyFZ6I077JVuSn4wmMupLVA+5Ao+RE/I=
Authentication-Results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none
 header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB6898.eurprd04.prod.outlook.com (2603:10a6:208:185::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17; Tue, 9 Feb
 2021 15:04:49 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42%6]) with mapi id 15.20.3825.030; Tue, 9 Feb 2021
 15:04:49 +0000
Date:   Tue, 9 Feb 2021 20:34:33 +0530
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Grant Likely <grant.likely@arm.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Pieter Jansen Van Vuuren <pieter.jansenvv@bamboosystems.io>,
        Jon <jon@solid-run.com>, Saravana Kannan <saravanak@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-acpi@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux.cj@gmail.com, Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Frank Rowand <frowand.list@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>
Subject: Re: [net-next PATCH v5 07/15] net: mdiobus: Introduce
 fwnode_mdiobus_register_phy()
Message-ID: <20210209150433.GB3248@lsv03152.swis.in-blr01.nxp.com>
References: <20210208151244.16338-1-calvin.johnson@oss.nxp.com>
 <20210208151244.16338-8-calvin.johnson@oss.nxp.com>
 <20210208174013.GN1463@shell.armlinux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210208174013.GN1463@shell.armlinux.org.uk>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SGXP274CA0021.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b8::33)
 To AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SGXP274CA0021.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b8::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Tue, 9 Feb 2021 15:04:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: fa66bcac-b617-42e8-91a3-08d8cd0c0a7c
X-MS-TrafficTypeDiagnostic: AM0PR04MB6898:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB6898374675F28A32F54F046DD28E9@AM0PR04MB6898.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aRbu5jcMQBGNtG6fa7Gdn7dds57Sj4w4qCI3fcf2yaZg3YTJOLIZuPUNafj/KVuzOcGWeIOFqzYpl1ySwCGenKGABcxUMFpdXNWzjrM3CQjVeUaYEZ7XnwqTUVHs+2Ekd3DU0nNhUbl2zHMp0wjA145Mky39YOaYklyKPZ9D/0WTyMQ1xM3r1qhsz3Q6qstYOfSvU7RmgC57MzvwNwZUCm0Zu7B7GqQvGOihMGc0/q82o0YpFXU0M/Z/x0Fl3qQAyTGYX8P3PJ7LfhRFEbVn46H+LmrLOQ6lslXkGOdFjL+KQWnLx5PYHYdCJGaCf1tndIWbZ6BqWBoPjLw4zOx+nutehzNDMGKX2UoTbfHNDrAAnQAOLngeTvVcUdOsgkPKAJ/lwnvzyN88q+ce2DVL3/9akBqHrVoiuoYKwT9rzOs3eQDbJt5IyyCGmqX9AZ4QEsN+Th8SDXoDX1FHfqG08dsnKAOhVOvtjwS7AtV27qPJKp25fhSSdaIJaeiHdBRtZQ+MVYQGKcRZfp8m7uqo9AKMlKZLANggu+BJflgluUqgAV/6Y1q8wPPO426quLAQ90+h0wfi7KH7mbfLM+LZlw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(136003)(396003)(346002)(366004)(6916009)(86362001)(316002)(8936002)(4326008)(66946007)(66556008)(26005)(66476007)(7416002)(6506007)(55236004)(8676002)(956004)(9686003)(5660300002)(186003)(16526019)(6666004)(1006002)(478600001)(1076003)(33656002)(83380400001)(54906003)(55016002)(44832011)(7696005)(52116002)(2906002)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?qUPDiunlRsZDxETHAACI25GVAJO0hss3DIBrbvbs60s2Lsh7uYw2Ifb9TTlx?=
 =?us-ascii?Q?/f2DC0ecTUmOALJTy1CW0xOFDmaWclntnAllOeEnfvsHg5q/MkyuiVmlhWOx?=
 =?us-ascii?Q?SuoEH5fysW6ft/oGpN16zIRGMiGocdLso9MFYoxsBDNBQfrsRw5pg8XcZqF0?=
 =?us-ascii?Q?4p40LNO3oQLKCCcuBwe08h7+zM1WIeSwL2z4oDcHx6bbqD56DnZSkWJy0olj?=
 =?us-ascii?Q?Zl5foqBHA5FeGaY5r3CN3bOZdJm9e+XyxL2CEHrFIsUOxxFXo2Q9mkPFuYg9?=
 =?us-ascii?Q?hdDly2yDwhQd2MtdfABT4EexazgInc8KhbMzIQj/GjRR5JKNoWzFqA7174Jr?=
 =?us-ascii?Q?H1crRsaHadbGJpzT29Pv/k52bl38/5eVxa0nwj4TurJh0hEVIgyN7FVardQ5?=
 =?us-ascii?Q?tzdzT8vsPCjmeJdddHNW1gpKCCckvZixt9S4aI3odukEcSMhcM4FeyxHh9ZZ?=
 =?us-ascii?Q?zezikDgLg1fd7+UADRnAx1ilRkMJw7eiOyrT0FrETM78CMhv5e4hvbUvPqir?=
 =?us-ascii?Q?KKUFg9gy8+zjpjLDByZ5QNbuoo95pYLXDl8DkOgCXhAu/sSMiYXbvLxnwBSu?=
 =?us-ascii?Q?JE9vDlD0Bqfq7FsK0jbMW1zMZ/yqb04fcMD+OIGAPlpO3d7nwmNRHfOXBkjp?=
 =?us-ascii?Q?wAW2kRC9G9A7NxRwNQVncXvKTUT0GUuFbLBJ+anDyIqwJp8g9pV0YkldHdoT?=
 =?us-ascii?Q?LTcO8Q09Lhh2wJB3gpkMCV3CmyVlBbyt7jVS6Yz70iCNaVH25HS/S9mBgomT?=
 =?us-ascii?Q?B+2Y+ech5Xndz9Ubm2jDBDdIxl3kZdNVCnI3qHQhYFs05tp7mMYL6l7BAn21?=
 =?us-ascii?Q?HQ73sBF/gbTwzpscF8dwc/yQIHoX6w5K3f1oU+JReftmSUndiKatrLczP/h1?=
 =?us-ascii?Q?q9lTUpbwrLP5YXF8JqDFI0toVs+imP3KXkLL3Z9UDDr3fZPEHbWo14nWwfsK?=
 =?us-ascii?Q?7VQOj+mIZUzBS64ldX8JjcCoP2DM14Hrv+7gCqo02QoNn4DpmaVG65nZgNDx?=
 =?us-ascii?Q?6NS7KMbV4sTqm/hQoJAqV/aUuaGxivEgDjMijDP2zFZAIgk4WPrQOwn0kl7J?=
 =?us-ascii?Q?nUG1iPRZhm4O5sX5rsLrVdIkfTo4T2iYLwSjghG+XjK7RwSeluWOIewakXDV?=
 =?us-ascii?Q?M8xGVlC1F53uiy7ohoLRZ9sHko9DtIq70rGOwEnZTBpgcdFFptw4Fy2MYcSx?=
 =?us-ascii?Q?qKLn5/aMtTlfnj6U7BzF+SUXkzA5MhIWlIrOIwKhiTo4sHwq09agh+nRZO0I?=
 =?us-ascii?Q?MKmuDELOkB2DdBLebViTqhZYSdnINgVtds5An/CkoKErJ9Gd5gkdt55FH0gY?=
 =?us-ascii?Q?c3jj7F1QV5wqK+Vwv3DhULNqZ/RDdRqKEH6zvUEQ6EJSJw=3D=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa66bcac-b617-42e8-91a3-08d8cd0c0a7c
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2021 15:04:49.3340
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9WvZmIIkYe3XAWyWXVbOaiJ2E6g4Zs1xlc0908BrrgiVazAnlbV03/SyECqoSBWO43tpaOUna3H9WoAlP6dogA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6898
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 08, 2021 at 05:40:13PM +0000, Russell King - ARM Linux admin wrote:
> On Mon, Feb 08, 2021 at 08:42:36PM +0530, Calvin Johnson wrote:
> > +int fwnode_mdiobus_register_phy(struct mii_bus *bus,
> > +				struct fwnode_handle *child, u32 addr)
> > +{
> > +	struct mii_timestamper *mii_ts;
> 
> If you initialise this to NULL...
> 
> > +	struct phy_device *phy;
> > +	bool is_c45 = false;
> > +	u32 phy_id;
> > +	int rc;
> > +
> > +	if (is_of_node(child)) {
> > +		mii_ts = of_find_mii_timestamper(to_of_node(child));
> > +		if (IS_ERR(mii_ts))
> > +			return PTR_ERR(mii_ts);
> > +	}
> > +
> > +	rc = fwnode_property_match_string(child, "compatible", "ethernet-phy-ieee802.3-c45");
> > +	if (rc >= 0)
> > +		is_c45 = true;
> > +
> > +	if (is_c45 || fwnode_get_phy_id(child, &phy_id))
> > +		phy = get_phy_device(bus, addr, is_c45);
> > +	else
> > +		phy = phy_device_create(bus, addr, phy_id, 0, NULL);
> > +	if (IS_ERR(phy)) {
> > +		if (mii_ts && is_of_node(child))
> 
> Then you don't need is_of_node() here.
> 
> > +		/* phy->mii_ts may already be defined by the PHY driver. A
> > +		 * mii_timestamper probed via the device tree will still have
> > +		 * precedence.
> > +		 */
> > +		if (mii_ts)
> > +			phy->mii_ts = mii_ts;
> 
> Should this be moved out of the if() case?
> 
> I'm thinking of the future where we may end up adding mii timestamper
> support for ACPI.

Right. I'll take case of these in next version.

Thanks
Calvin
