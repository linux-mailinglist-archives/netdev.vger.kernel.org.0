Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED6392DDE20
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 06:42:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727196AbgLRFls (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 00:41:48 -0500
Received: from mail-eopbgr10073.outbound.protection.outlook.com ([40.107.1.73]:14542
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725290AbgLRFls (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Dec 2020 00:41:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GvGziMdIm79vcEOlNDtUyUewi/JiP+5UQHOz07wB8+rjyfd59MaDu7IlutJONVfIJkD5aDnkC7PhXigiU9GQkZNSSFtRLKf8Q4q3t0PYPJNIFSDb0XCa/ZH0xy0yJhWsC8yHlPGSqeU0SzHZcKXf3hDu6OpOBSY+19wi7+Vv/0juHDf7dBCdEb3JoVP5Cq3gWMvoGzVWkZTdFQO14/KTOvugRzM8kB8mNTCbptiqfgzhv0wIYZLP6Z2+e/sfq6QsDBxP/qQAq5GOceSauDfUeXWwzkWiRw8csAUQuRrOk6AJYxJzTHWR4PjihXaVYpG5iLtni4WIioZBo8LJMb+fyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+inXbZbZfl3IyyKicFW207m7Z1Pe1lfqTYdg6xeyBc0=;
 b=HLYHvjqCG//XRGfTFyK/I+8GKBMe8K0Ye9XqR00SPpwicgUuHMizonjKnEUgM5uQ4F1z6KyOiDG8LvOdYnt7b41FNKTcuxTbJLz+uJlNoC2ICzJRi2nRL4DqnBRgYI5/iY550SWn3bUwuJVXXK1nyHaFPTIcRYMljfkxMyWkX8D6vvUDX37ushmRLxSxZf0sKfbC5RXczHAH2HTqrOok2KjBmgotV/RYKKK5dkOnu/VaV4qDsefwyGlImSWBlfhGzk1dMqCJ2zmZKTGjw532kbTH/M10Ooa0IUmEoRbAgoy2Hy5HsccydTdeEbwLHXlQGeOcr3zlDCjyfWb9zDTUWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+inXbZbZfl3IyyKicFW207m7Z1Pe1lfqTYdg6xeyBc0=;
 b=Zl3ZTcB9RMvYSShlQ3+7diuPa9r1k6iJYN9k1JvJUmmFl/+XEU95BBzgL/t47V7YwI95a25itS/Ljwh4uDCOQommOFBV+rd6dzj9ldTi9MDLOf6gyqR7sJwtwexgAMY2e01Jr1iCi7c1Tpa4bnkijUltRp4andc4DhXGE2oMjJY=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB7108.eurprd04.prod.outlook.com (2603:10a6:208:19e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.25; Fri, 18 Dec
 2020 05:40:57 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a891:518d:935c:30dd]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a891:518d:935c:30dd%6]) with mapi id 15.20.3654.020; Fri, 18 Dec 2020
 05:40:57 +0000
Date:   Fri, 18 Dec 2020 11:10:44 +0530
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
Subject: Re: [net-next PATCH v2 08/14] net: mdiobus: Introduce
 fwnode_mdiobus_register()
Message-ID: <20201218054044.GB14594@lsv03152.swis.in-blr01.nxp.com>
References: <20201215164315.3666-1-calvin.johnson@oss.nxp.com>
 <20201215164315.3666-9-calvin.johnson@oss.nxp.com>
 <CAHp75Vf69NuxqcJntQi+CT1QN4cpdr2LYNzo6=t-pBWcWgufPA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75Vf69NuxqcJntQi+CT1QN4cpdr2LYNzo6=t-pBWcWgufPA@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR01CA0124.apcprd01.prod.exchangelabs.com
 (2603:1096:4:40::28) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR01CA0124.apcprd01.prod.exchangelabs.com (2603:1096:4:40::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Fri, 18 Dec 2020 05:40:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9570226d-a23e-4b08-72ca-08d8a3177e75
X-MS-TrafficTypeDiagnostic: AM0PR04MB7108:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB71089D2DB16C8D8A7F53EE5AD2C30@AM0PR04MB7108.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /BFeHM80Z1RsJOfiY9Du2sYs0ZBxeo8nNOsCAfxTmLnOwtuFdrx3zSPwtaGnxkdbBRjhamDLUorsRk4Ea6p6BmT5BNyP86RvhM5+4CN/fzDgOUzOyF6R04uF98TRMj2S5PpcakAfOj+bFZss+6E+TdPXat6iS/eiRpTRR0VBU+dNchatPFEz5CQilKujdhik4/1UgLdUDCEFDrU6JvazYmSxv2AHrQDRJdMTPvLW6XlYQ4C+yn0Q8hQEqxB2eglDUG6m897PAZnY/HqHbSDKnieJFBw/AqYgkWn9XfoRM4PEG0eSRNA4o//oIMCskbzOXh6QG3FWLg22+hNOmIH1GNNsH1Ht8aDW4Eswlp2XnhXdZRq/HkK1ZdifaXN8hYGIRj35FwCuk2ATziMR8xyHkoZWNX8jICp7um+rdB85QnJCub91ywr0Dsh2U+WggGSr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(376002)(366004)(346002)(396003)(26005)(186003)(956004)(6916009)(7696005)(33656002)(6506007)(5660300002)(55236004)(16526019)(52116002)(53546011)(1076003)(7416002)(66556008)(2906002)(8676002)(66946007)(4326008)(66476007)(86362001)(44832011)(54906003)(6666004)(55016002)(478600001)(316002)(9686003)(83380400001)(1006002)(8936002)(110426006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?kk99CjF4LzCUdiAKfpz32B+Uzfbwb31A52FzaLwh1hb8mS6cuFQ9CpTwIjtZ?=
 =?us-ascii?Q?axAbc3/xJ+WkX/TGGcKMoSC8BFMVzOBkrfhrVBxXrgXwKoh/mdtweGTDLVfP?=
 =?us-ascii?Q?kviyOOsgyZratazB2RUzHnJ0uZUmjf9yMR3u0Nayz9Snmk6INyo0YD+DmB68?=
 =?us-ascii?Q?JK3fcEeuKKJICjRlSK1AjQfGMr/urz/pDkkAU3t6IWMDBBHaRYr5mstpKsV7?=
 =?us-ascii?Q?c0eK6DOPdEBLH9gl5fiUzKTuJT51Ki1VeXFoBRvHFoR0vEjtY8owyNryDe4l?=
 =?us-ascii?Q?gqA9LOYl7gmzVSFFk/7HbpI6rwBxGKZu5QUOBVFEJAbBvD8V4RDbZZ8zyPpE?=
 =?us-ascii?Q?8Iy46/KjBZCkJTNhW55HE4SH3irT8BgXs+wf/5WGtrK6q8lqzhXrWFRu8jDh?=
 =?us-ascii?Q?JLet5qsVqIHRwPJzqCnSUBnuqFdq9kIyscPjen0TbAF2dVD4rMTeawAQOnGN?=
 =?us-ascii?Q?acsae6XR7JCgid0TjJcclCa0jwI023cq7G5t0XCGDm8xnvjTZU7Xf8v6X1tA?=
 =?us-ascii?Q?QHltgxwpE65PQVhBVKRX0AqDhGP36wnP9A2iyOEpnAfoVAX4lkbe93g187Dt?=
 =?us-ascii?Q?NIObejkWasN2dEioOW1QXUzq/JZ36pfalk749wi1QuBZFI1e3jN+9EPtbjtg?=
 =?us-ascii?Q?CETajZbEV+1JrFNnr4Abg/B1aR9WsCSPcJ2C+n18BrGMl6YOIijyFVyRXfVn?=
 =?us-ascii?Q?AKLXa/g0TfTDXjt+Pa552RNXEiKJ4+qvSioTDxw0ZBO5XpjZmo7DIwwrOkBS?=
 =?us-ascii?Q?1VxdTLTHc8KqHQObB/QDW0sa0arTpBGgJsn2kQsLQZn9XgbbTPI4RRy2Cvv2?=
 =?us-ascii?Q?ZMxqP7sJPIxOnFZQT/GKyJbD2cbM0EoPyeFpWQgO+aJci5KFaSVVqN0styK9?=
 =?us-ascii?Q?wjuR9nzreaG4AJpWO8EKRpfrkraH46J/hAVWYOO0NtvU96Qms5m2UsnKXJ1y?=
 =?us-ascii?Q?LWAYYscaxAuHq/UA70bRCOk7PQX7BHposDMHvZPsX4C0z7sew9O/vOd7kGwI?=
 =?us-ascii?Q?NIx8?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2020 05:40:57.2917
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: 9570226d-a23e-4b08-72ca-08d8a3177e75
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0/MUxcAC+43oW0o8v6XnWu9wfK1Ff0MhLGVLdQQQX1Lz196R1YkqR/Q9o0iyioKUyEIi+BTkkkUcAr4ZDOyNgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB7108
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 15, 2020 at 07:53:26PM +0200, Andy Shevchenko wrote:
> On Tue, Dec 15, 2020 at 6:44 PM Calvin Johnson
> <calvin.johnson@oss.nxp.com> wrote:
> >
> > Introduce fwnode_mdiobus_register() to register PHYs on the  mdiobus.
> > If the fwnode is DT node, then call of_mdiobus_register().
> > If it is an ACPI node, then:
> >         - disable auto probing of mdiobus
> >         - register mdiobus
> >         - save fwnode to mdio structure
> >         - loop over child nodes & register a phy_device for each PHY
> 
> ...
> 
> > +/**
> > + * fwnode_mdiobus_register - Register mii_bus and create PHYs from fwnode
> > + * @mdio: pointer to mii_bus structure
> > + * @fwnode: pointer to fwnode of MDIO bus.
> > + *
> > + * This function registers the mii_bus structure and registers a phy_device
> > + * for each child node of @fwnode.
> > + */
> > +int fwnode_mdiobus_register(struct mii_bus *mdio, struct fwnode_handle *fwnode)
> > +{
> > +       struct fwnode_handle *child;
> > +       unsigned long long addr;
> > +       acpi_status status;
> > +       int ret;
> > +
> > +       if (is_of_node(fwnode)) {
> > +               return of_mdiobus_register(mdio, to_of_node(fwnode));
> > +       } else if (is_acpi_node(fwnode)) {
> 
> I would rather see this as simple as
> 
>      if (is_of_node(fwnode))
>                return of_mdiobus_register(mdio, to_of_node(fwnode));
>      if (is_acpi_node(fwnode))
>                return acpi_mdiobus_register(mdio, fwnode);
> 
> where the latter one is defined somewhere in drivers/acpi/.
Makes sense. I'll do it. But I think it will be better to place
acpi_mdiobus_register() here itself in the network subsystem, maybe
/drivers/net/mdio/acpi_mdio.c.
> 
> > +               /* Mask out all PHYs from auto probing. */
> > +               mdio->phy_mask = ~0;
> > +               ret = mdiobus_register(mdio);
> > +               if (ret)
> > +                       return ret;
> > +
> > +               mdio->dev.fwnode = fwnode;
> > +       /* Loop over the child nodes and register a phy_device for each PHY */
> > +               fwnode_for_each_child_node(fwnode, child) {
> 
> > +                       status = acpi_evaluate_integer(ACPI_HANDLE_FWNODE(child),
> > +                                                      "_ADR", NULL, &addr);
> > +                       if (ACPI_FAILURE(status)) {
> 
> Isn't it fwnode_get_id() now?
Yes. Will change it.
> 
> > +                               pr_debug("_ADR returned %d\n", status);
> > +                               continue;
> > +                       }
> 
> > +                       if (addr < 0 || addr >= PHY_MAX_ADDR)
> > +                               continue;
> 
> addr can't be less than 0.
Yes. will update in v3.
> 
> > +                       ret = fwnode_mdiobus_register_phy(mdio, child, addr);
> > +                       if (ret == -ENODEV)
> > +                               dev_err(&mdio->dev,
> > +                                       "MDIO device at address %lld is missing.\n",
> > +                                       addr);
> > +               }
> > +               return 0;
> > +       }
> > +       return -EINVAL;
> > +}
> 
> -- 
> With Best Regards,
> Andy Shevchenko
