Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E9472DDE18
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 06:37:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728138AbgLRFff (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 00:35:35 -0500
Received: from mail-eopbgr140053.outbound.protection.outlook.com ([40.107.14.53]:9351
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725290AbgLRFfe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Dec 2020 00:35:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EtQXalxPwVgzIQwAgd85ivsk7izi6J9pIatIL0EUEU/dbAj9+0Y1g84OMyGwYopRpLho5bHFhABg8QB3eR6PNrsJhMMA7d7PcYamiW1j3KAngw8EGDnJT7+8INvVpr+UqyXjDgXRzDKTRXQNIX39lhcLzgEuUWWqpeWPBaM7aFhfzhXU9DFUOpGj7FEjjkeJ/isUZsghIwNnye2D6t3ycbCRAP44PNdka4DYAKWmJwr3FrwQx677qJug5jmJfdTmDum0N60WN5ozhtj2OklvC8d+Gw3VEBtJA0uAsewGx94Q4J2yItxxOgQvZTWcoR/uqYysXTAK3OuL3ZC7Udnt2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dfbUzOO0nnnYLJD01N89O5SINzlaMLm3kIpFO5b2JAY=;
 b=IWtZFlBPLs2D2CUX3f5aMGmu+LJPKH0FXs8N9wquLYhCfvWp+KtLLAJFbp+RDABYUxy9PO8SBkzXXbfqqHUKr9zXmIunRHYm7y5VIbzeI9b/vYZq9MsXt/lxDO2VW7FLmu5ZSGyG7YRxBepdVwbCZd0ahMHLd+dJNQ1orXhW7tig93M/YYfSBhUtw888HHXfqnoxYu4WSp0fVaLMU34oD4TF4Ct4Xc6GeC3xEXAjXe044TZagEIWgTiW2ayRSzhCG5IwmKjWsod/s3IbyQ7bzUPwhFFnatqfyqgfDb8NBWpGEB8QKCAHgnL9WoEwZNbW555epqIV8yvVjYMXW+cgjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dfbUzOO0nnnYLJD01N89O5SINzlaMLm3kIpFO5b2JAY=;
 b=WHZONqcMJbPPXaOnHGI8zUhg1zLGNQ7wfHNAy6ijVwI6CFb2UbCR61GmSPhMIsQ+LTpaFwie+Z1uAHR4kStF/lE+Hq5j8pf2hpLsZl+kVSBD/kzgxXOhs4xng2i6aVHr5wp/hB4El1ziIKHi/N+ouwh3CZb1BHtxJ4OYPVr8BYM=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB4228.eurprd04.prod.outlook.com (2603:10a6:208:66::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.14; Fri, 18 Dec
 2020 05:34:43 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a891:518d:935c:30dd]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a891:518d:935c:30dd%6]) with mapi id 15.20.3654.020; Fri, 18 Dec 2020
 05:34:43 +0000
Date:   Fri, 18 Dec 2020 11:04:23 +0530
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Grant Likely <grant.likely@arm.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Pieter Jansen Van Vuuren <pieter.jansenvv@bamboosystems.io>,
        Jon <jon@solid-run.com>, "linux.cj" <linux.cj@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [net-next PATCH v2 06/14] net: mdiobus: Introduce
 fwnode_mdiobus_register_phy()
Message-ID: <20201218053423.GA14594@lsv03152.swis.in-blr01.nxp.com>
References: <20201215164315.3666-1-calvin.johnson@oss.nxp.com>
 <20201215164315.3666-7-calvin.johnson@oss.nxp.com>
 <CAHp75VcY2uOirAXGv5kFvHbNfHcZ6-gPsUMTB-_5AuBkHdu-0A@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75VcY2uOirAXGv5kFvHbNfHcZ6-gPsUMTB-_5AuBkHdu-0A@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR06CA0119.apcprd06.prod.outlook.com
 (2603:1096:1:1d::21) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR06CA0119.apcprd06.prod.outlook.com (2603:1096:1:1d::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Fri, 18 Dec 2020 05:34:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 94ad3b62-734d-451b-e9c2-08d8a3169fb8
X-MS-TrafficTypeDiagnostic: AM0PR04MB4228:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB4228DFE0812E70099C1620D8D2C30@AM0PR04MB4228.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /KpInvuR5+2Okb71c9BScAf8OlQx0p9lNd2VrL7DQyg4EHbO4KkkYN7Hrck3aTVxm5Gf0FXLZr2mRm8JoAFP7HrBVNEIQ+z9008OgIfkrDlmi6Z5F7YQqk/wbc9+o6SI7rd+cy4H9usOItuorrRn0OCbQeIovpc+Nfmw4pLbRElp4yIxRDgiSfp+ztP5VpUw2WHrdxF8qP+6PG0kxvg6JEO26khwJgdLwQO3a8bXOblreE/CxW5gHc8Wu8PrnMiQ0jv3T7pdSl+qGHt60yk3nK82whTSm8682z7+zEJT1Q8kAlJLMf7/m9JeTK0cx1csdwicJYmV52Hm78COeJ0UaD/Y2MlZ/CI2Xni3BJjNL58uBiPZGPw1+Ix35qJbwv7pZoSLNupmQgWPhAN6a6n2IhHXRteMNqzvsMhq/CQirufjU6P/NhMieoXUE3KY413eV4Qvkn7wa2rXB4LCRpj24A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(396003)(136003)(376002)(39860400002)(7416002)(316002)(4326008)(478600001)(66476007)(6916009)(66946007)(2906002)(6506007)(26005)(54906003)(66556008)(1076003)(53546011)(956004)(86362001)(52116002)(8676002)(6666004)(55016002)(33656002)(966005)(9686003)(44832011)(1006002)(5660300002)(186003)(55236004)(16526019)(7696005)(8936002)(110426006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?LOwW2M0jCLw/8pWrM8qCf2WxG6gwKBDXwuCJ+jUma0xax/dCjZR7Ov52LDQe?=
 =?us-ascii?Q?MgRrhvRrZ3axPgWc7f0CaAW5c/jYlVjx5GD5VGXv1PT5ibIFcqcyF+855Cn+?=
 =?us-ascii?Q?jYdJeMxj4L1hV7MYAvTQIciaTfoVRaQMgHc/NrCGZkaGhhjocOUjOtxHXcnr?=
 =?us-ascii?Q?GDX4R5ca+vk7MfmHS0eXaqfqYdmpynYXpcWLLC68Lu8sy1p/QG7VPxcNzIum?=
 =?us-ascii?Q?v0D8BD4K9Wt/7S7mCkJ7dlKmupcuHL+BIpchwdqqKycFvXVDaQC2/X8GYWGc?=
 =?us-ascii?Q?2nA5fCMKURLYFJhj3d3DPGXAhPi9oU+fPUUmALjp1Ps/7l2FV760EcQUPlYb?=
 =?us-ascii?Q?RaRXohXtN/O1omEJcYI+omAsH9p5DZzEKX2jgrIkuK5hD/rAAnX70leppESQ?=
 =?us-ascii?Q?WfOjOqSqXMPmYU0VNI9Vxrwi0h1WCQ7H3B5Nx+1hwoB5G8yhqMHa63nCPFFn?=
 =?us-ascii?Q?E1lye5xett1by9jj9YT+C8+wWzs2Bx8G0X451mgctAAVTwPJGcp5SqPHbNjF?=
 =?us-ascii?Q?wJJIYSmz0065IcFW33NDEKrFYJwnWyEfSR8a7DbINfaKTdzed4TyQeAZQPPJ?=
 =?us-ascii?Q?KIQBctm3hSCZKAlOs+wWH7RClzbFRvQhyNIvqfJl2xEfnSFOCpRKMvf+G/XW?=
 =?us-ascii?Q?T2nZXxkJHIregVzqyDi1xtTfBm3suiZtphYny21hJEzCmuoGMV9MeNRHRZqL?=
 =?us-ascii?Q?05Zb1QYSfVuhZHQocUb27cWvXMc7VN5vXczC2aHg4ADBmfEfqkA4KzngWdn7?=
 =?us-ascii?Q?FflzYE2jGG0aQJl3w1csuPBYA3Lc0j1g3zPfQwTBzvxRKp15U/j5s+Bil7p/?=
 =?us-ascii?Q?G6MlKcSW4CIM3zoOS32VG8buSIdDesij3LYc8IQdtiX3RSnPS+2ei1qXJkIa?=
 =?us-ascii?Q?0zmo6nSod5DffWwir3T4dncboEOFLI5pckjAICeJZ8xCNBDPPcuSYmBMDyRx?=
 =?us-ascii?Q?lCiDmDASeAU1mlzeVlzC63MDGwVj67Wv5Th2eVvufL679f+quDGQfwD37TGE?=
 =?us-ascii?Q?npJF?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2020 05:34:43.5489
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: 94ad3b62-734d-451b-e9c2-08d8a3169fb8
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jA8SN9zjevNtyr0hF7ka4p4ZqMJHuc5v2D5GVwSMdd7FueJHLjwEVJ81l8jCx8mHwzcDxMX6TyZaQ5jaPFr7eg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4228
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 15, 2020 at 07:33:40PM +0200, Andy Shevchenko wrote:
> On Tue, Dec 15, 2020 at 6:44 PM Calvin Johnson
> <calvin.johnson@oss.nxp.com> wrote:
> >
> > Introduce fwnode_mdiobus_register_phy() to register PHYs on the
> > mdiobus. From the compatible string, identify whether the PHY is
> > c45 and based on this create a PHY device instance which is
> > registered on the mdiobus.
> 
> ...
> 
> > +int fwnode_mdiobus_register_phy(struct mii_bus *bus,
> > +                               struct fwnode_handle *child, u32 addr)
> > +{
> > +       struct mii_timestamper *mii_ts;
> > +       struct phy_device *phy;
> > +       const char *cp;
> > +       bool is_c45;
> > +       u32 phy_id;
> > +       int rc;
> 
> > +       if (is_of_node(child)) {
> > +               mii_ts = of_find_mii_timestamper(to_of_node(child));
> > +               if (IS_ERR(mii_ts))
> > +                       return PTR_ERR(mii_ts);
> > +       }
> 
> Perhaps
> 
>                mii_ts = of_find_mii_timestamper(to_of_node(child));
> 
> > +
> > +       rc = fwnode_property_read_string(child, "compatible", &cp);
> > +       is_c45 = !(rc || strcmp(cp, "ethernet-phy-ieee802.3-c45"));
> > +
> > +       if (is_c45 || fwnode_get_phy_id(child, &phy_id))
> > +               phy = get_phy_device(bus, addr, is_c45);
> > +       else
> > +               phy = phy_device_create(bus, addr, phy_id, 0, NULL);
> > +       if (IS_ERR(phy)) {
> 
> > +               if (mii_ts && is_of_node(child))
> > +                       unregister_mii_timestamper(mii_ts);
> 
> if (!IS_ERR_OR_NULL(mii_ts))
>  ...
> 
> However it points to the question why unregister() doesn't handle the
> above cases.
> I would expect unconditional call to unregister() here.

This is following the logic defined in of_mdiobus_register_phy().
https://elixir.bootlin.com/linux/latest/source/drivers/net/mdio/of_mdio.c#L107

	mii_ts = of_find_mii_timestamper(child);
	if (IS_ERR(mii_ts))
		return PTR_ERR(mii_ts);

I think the logic above is correct because this function returns only if
of_find_mii_timestamper() returns error. On NULL return, it proceeds further.

> 
> > +               return PTR_ERR(phy);
> > +       }
> > +
> > +       if (is_acpi_node(child)) {
> > +               phy->irq = bus->irq[addr];
> > +
> > +               /* Associate the fwnode with the device structure so it
> > +                * can be looked up later.
> > +                */
> > +               phy->mdio.dev.fwnode = child;
> > +
> > +               /* All data is now stored in the phy struct, so register it */
> > +               rc = phy_device_register(phy);
> > +               if (rc) {
> > +                       phy_device_free(phy);
> > +                       fwnode_handle_put(phy->mdio.dev.fwnode);
> > +                       return rc;
> > +               }
> > +
> > +               dev_dbg(&bus->dev, "registered phy at address %i\n", addr);
> > +       } else if (is_of_node(child)) {
> > +               rc = of_mdiobus_phy_device_register(bus, phy, to_of_node(child), addr);
> > +               if (rc) {
> 
> > +                       if (mii_ts)
> > +                               unregister_mii_timestamper(mii_ts);
> 
> Ditto.
> 
> > +                       phy_device_free(phy);
> > +                       return rc;
> > +               }
> > +
> > +               /* phy->mii_ts may already be defined by the PHY driver. A
> > +                * mii_timestamper probed via the device tree will still have
> > +                * precedence.
> > +                */
> 
> > +               if (mii_ts)
> > +                       phy->mii_ts = mii_ts;
> 
> How is that defined? Do you need to do something with an old pointer?

As the comment says, I think PHY drivers which got invoked before calling
of_mdiobus_register_phy() may have defined phy->mii_ts.

> 
> > +       }
> > +       return 0;
> > +}
> 
> -- 
> With Best Regards,
> Andy Shevchenko
