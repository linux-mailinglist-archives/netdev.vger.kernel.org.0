Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 427B6337B95
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 19:01:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230156AbhCKSAz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 13:00:55 -0500
Received: from mail-eopbgr80050.outbound.protection.outlook.com ([40.107.8.50]:35654
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229784AbhCKSAe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 13:00:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jBic6skNyWHNtghSqTUum09k2OxGRNlf3aV3WUJaFZ+3GTkkNOMzmzJ6zh67osyWsXGMVaHoGJ3MjW14tANq5tC430BnLaU1vrduAcPSh5CrsPoznmTJ3A8WBKn9rPfqFSDpQA1Hci/DF2ZDpFDacFbBgTCPepPKw1igPk21Hg+jnUA4rToU/5F3Sk9b16FgoQ1i19irV88uAkXI3NvQBVv59heTmYxl7z83xcu44pDB//GnQo0RToHrHIo5wMhJCqV6k67PwIrTXcBfhDyHfKC2GgMf5yC4XsxKT6ZMRqQJ+P1n0Oxm7tD7cOM0O7WZLGT07jV3lJypCrJFLo1Wew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ze50xbDM6B7YKcPfHVDEQJs+eSCCpNhGzjLqLFpvxsc=;
 b=Q54qQ4EDuuTSwJ6VUv2ZCNLWFdjPJWpd34YUFSmEyyv5Mil9bB7lIFcVdmxOTemec4uoj29zVmEkO4A34XCY42UJf9n88q47fyOobU0XwUp2ytLbU+M/+dYsaUIjAAp9RusPcW1L8k0d3KfBwKOvNPii6qdfZtcPFWx4jIMHP1AVORVlArcQ6GoOWinG/XpSwxeGGVIKPjpKhpBg7BrWpMRt6fL3S8YsYYpjtQiYjJUKaLai/dkqwdugunUp4vg4HYVgdhUU/QN/5kz3kPpzP0WfRL8dJKDziwfnXv9+GMQ2+QChqjrXfi1fkoba1yiWU4vuiKvZ4LuJug+7gFjHYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ze50xbDM6B7YKcPfHVDEQJs+eSCCpNhGzjLqLFpvxsc=;
 b=CFwf9sIyKAipIp5/Dht4J3mhDWyfj37pq2JF2aZvpmz7HbfwTIKMy4rtlaCgCZsGUwFr5b2aNh24uYM7sV/Ne2pYI17PVW9UPAE36G0V1OfMK1AZeIax6CmmljzukFxy3eapLGgr+cyFx1fuBwkuZGTly78QRsc9N0amhLk0qRc=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB6898.eurprd04.prod.outlook.com (2603:10a6:208:185::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Thu, 11 Mar
 2021 18:00:28 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::1cd:7101:5570:cd79]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::1cd:7101:5570:cd79%7]) with mapi id 15.20.3912.027; Thu, 11 Mar 2021
 18:00:28 +0000
Date:   Thu, 11 Mar 2021 23:30:10 +0530
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
        Jon <jon@solid-run.com>, Saravana Kannan <saravanak@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux.cj" <linux.cj@gmail.com>, netdev <netdev@vger.kernel.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Frank Rowand <frowand.list@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        devicetree <devicetree@vger.kernel.org>
Subject: Re: [net-next PATCH v7 08/16] net: mdiobus: Introduce
 fwnode_mdiobus_register_phy()
Message-ID: <20210311180010.GC5031@lsv03152.swis.in-blr01.nxp.com>
References: <20210311062011.8054-1-calvin.johnson@oss.nxp.com>
 <20210311062011.8054-9-calvin.johnson@oss.nxp.com>
 <CAHp75VfKoNvBxbj5tKb9NqGGbn36s=uZznm9QDBzkVWYNa=LCA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75VfKoNvBxbj5tKb9NqGGbn36s=uZznm9QDBzkVWYNa=LCA@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: HK2P15301CA0021.APCP153.PROD.OUTLOOK.COM
 (2603:1096:202:1::31) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by HK2P15301CA0021.APCP153.PROD.OUTLOOK.COM (2603:1096:202:1::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.3 via Frontend Transport; Thu, 11 Mar 2021 18:00:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 764fdaba-bea8-435c-cdb0-08d8e4b78d69
X-MS-TrafficTypeDiagnostic: AM0PR04MB6898:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB68989BF8E3C961BD1E2DC54DD2909@AM0PR04MB6898.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ds3hzcK1yQLXAh7jdNjX97T3ARM5wtvvcxHpKRflB2bGj2MwsGrh6u2h41kjiqVjevr/a0TwFWZuApn5z5tx5Q4GxbzubutQumv+2Ckea2GtzLdUTcZpQuZtWVrDkwdSH5jQj7OyzcJ/c4RLTieJ542iKCFbOrjfvaQL+rwMitz1+zpKF8kiDEMs20sm1hiIL08J/UFZIXDwShtnoMITkeRTwfxR8XVNJq9DgkutpFmgIHjQ2L3EHXN3CLkkiQ6Ge1bz0Zs3KwgifGeGfTm3Q6xYaH/RlTOFdWGg921opaS2JA0LDdXT/n2iSusEZDjyINWtKcqTdcV4UW+Yf+IW8GHLwfPiSYVVZbPE0N1MQ4M96eM63oqbTlASLI+8XbtbZCdmPAiJH2ZOuC1eOndsEa/oKkIb71KFszRUSxo5hcAWDhmci6okDsV0P4VIPkI+ux7aKYBCVEiwXvmPNzxkMTY+MiVl+bolmQYTy63VworIElcZubHjqH/hwPD4mjysZ2eAdVaPwza1hM/gbzyJvDoYZvYSdDf/9ZLYUO3L8DFbWzLrmLKo2S5XDzYHynJEpdnu+/2VWStMAfw6tS96PQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(136003)(346002)(396003)(39860400002)(33656002)(5660300002)(7416002)(52116002)(66946007)(6916009)(8676002)(66476007)(66556008)(55236004)(54906003)(26005)(956004)(6666004)(44832011)(16526019)(9686003)(8936002)(4326008)(6506007)(1006002)(55016002)(1076003)(53546011)(7696005)(86362001)(316002)(83380400001)(2906002)(478600001)(186003)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?xVhhu7yFkvVOrssPtkPvpDCTTwiyO0FcMcDU0UXpRxvVxU/XBY6jKonFUNat?=
 =?us-ascii?Q?A5KMDh6RtUmrdthR0Z7MtR/Y9sY98d4c68t+4VyRA/g9ZrDFqpTVzMVtiKge?=
 =?us-ascii?Q?53a69E3LUZX9dexL/OwpnUvoudsK7A3KDJaEHqi8Y3nA3l0Rhqv/iKNZ3ytS?=
 =?us-ascii?Q?QLFYRG2n34qylYpq+nSJpbWGGoMxvXjUKxqfmRqjsIaZEFAkEanYIk+4SDsZ?=
 =?us-ascii?Q?m9GvDiqdk1Bz5KDUsSjrffzN+qp96XVBnWOD/h0fdwH0sNkGOueyul8iu9Uy?=
 =?us-ascii?Q?CQfsiYPCb+TvMb7HiXhKLEh1QNNnZ+ICe/SMeUP2+xwCRBLEVXHaO8Lg2opr?=
 =?us-ascii?Q?KP/jtJabHvl4InHIiuYsTFoX//YKHD/wgixu+9ph5ijfgTGAzkHVldBVK+CH?=
 =?us-ascii?Q?toGpxUwXFDWIbHulpyxRH0IH8/h4gAtzIzikiiVg/YSbLGAZMwRGSSn1Jm9s?=
 =?us-ascii?Q?PYDMUXwUrmF8UfuUPtGNmMoiJjKXsYYEUnDmpZ+vq30boPpopJhxWBaA5/db?=
 =?us-ascii?Q?mZ9p1fxGko0vlf0WRrPvPQamcvqxIRvCtXNojPq/Kv2i8uTqcMRzCGjbS+N/?=
 =?us-ascii?Q?MVtdZOlFgnCiKwpCNMmjhS1zy4PCWAuiJGjzPFS7O5rxxAFOvI5UT42ilZ6j?=
 =?us-ascii?Q?Ox6Xqrezc0j+Cs43UcPuCzbv5FfQkP3A8JDIvHuxQiZGyqR7GoHvSdgN1cLJ?=
 =?us-ascii?Q?8SZxr7fgEBtgoJmGlhIc1IwpdQTINruYR6gOLyJ2b1XxOYQKMLssGRdBoBRw?=
 =?us-ascii?Q?SbUKDSQkkCDhXUj2uGKibwmx8EdyaZiicTWLis6lZGdMQ3uw8RuTqS1eoDFi?=
 =?us-ascii?Q?rQZaRfyt0OSlsoPe1Q1IMmJwixpWdCqyVcBPILOU3n5twmGYzdL3zGr8Aqpg?=
 =?us-ascii?Q?ZCibNMihXr1S/E3yZhwdD7WpBHvNbXFvynahz4Xer1dRNgQQXl15+UByho48?=
 =?us-ascii?Q?5zmy+SuyVhzYLe2FzSlwtH9vdfpDmSg2awwL6L5HLx2BJqfrbEZB5bm3MzL4?=
 =?us-ascii?Q?h4s0Cr2MMOoXaMZQzNvchnfl4g5r8VJrtKkeG9PliDfwuaIDmSW+I4zTSYpb?=
 =?us-ascii?Q?YzfvBwT6DuC7HojHS/3kjRGt7w7PKu9e7BNIjySrCaeqtq4lr6YwbgStMl3Z?=
 =?us-ascii?Q?1q/seKDskqk140LG8gLJSTEDZEzTEBNvcTIOffVcyk1ImqmN8AfyMUW1hrjM?=
 =?us-ascii?Q?0QTEVxTNrzW58M0OfSzn7p+2bQdD4Mr2+abqmUf9Xlw6wf92WlbwCRuZeDg2?=
 =?us-ascii?Q?yLMCLV2MoyEjjFzHR0G3pgteeuS+sUOfqistrpMdv9mdrp3QkJeoIebLqTnV?=
 =?us-ascii?Q?O3QQLwmsxiy8jLXWUchIIAXY?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 764fdaba-bea8-435c-cdb0-08d8e4b78d69
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2021 18:00:28.0681
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RGHCEMCjOayRJN0B8nsnmXEpdhUTqxBJIy6ejmeDfCJKrv0gk2eJ4sw8g8pDLv0lsh4x4HMdCZgjhVew2GvwQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6898
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 11, 2021 at 02:09:37PM +0200, Andy Shevchenko wrote:
> On Thu, Mar 11, 2021 at 8:21 AM Calvin Johnson
> <calvin.johnson@oss.nxp.com> wrote:
> >
> > Introduce fwnode_mdiobus_register_phy() to register PHYs on the
> > mdiobus. From the compatible string, identify whether the PHY is
> > c45 and based on this create a PHY device instance which is
> > registered on the mdiobus.
> 
> > uninitialized symbol 'mii_ts'
> > Reported-by: kernel test robot <lkp@intel.com>
> > Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> I don't think it's important to have it in a history of Git. I would
> move this after the cutter '---' line below.

Sorry. I thought I had removed it. Will definitely take care next time.

> 
> > Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
> > ---
> >
> > Changes in v7:
> > - Call unregister_mii_timestamper() without NULL check
> > - Create fwnode_mdio.c and move fwnode_mdiobus_register_phy()
> >
> > Changes in v6:
> > - Initialize mii_ts to NULL
> >
> > Changes in v5: None
> > Changes in v4: None
> > Changes in v3: None
> > Changes in v2: None
> >
> >  MAINTAINERS                    |  1 +
> >  drivers/net/mdio/Kconfig       |  9 ++++
> >  drivers/net/mdio/Makefile      |  3 +-
> >  drivers/net/mdio/fwnode_mdio.c | 77 ++++++++++++++++++++++++++++++++++
> >  drivers/net/mdio/of_mdio.c     |  3 +-
> >  include/linux/fwnode_mdio.h    | 24 +++++++++++
> >  include/linux/of_mdio.h        |  6 ++-
> >  7 files changed, 120 insertions(+), 3 deletions(-)
> >  create mode 100644 drivers/net/mdio/fwnode_mdio.c
> >  create mode 100644 include/linux/fwnode_mdio.h
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index e1fa5ad9bb30..146de41d2656 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -6680,6 +6680,7 @@ F:        Documentation/devicetree/bindings/net/mdio*
> >  F:     Documentation/devicetree/bindings/net/qca,ar803x.yaml
> >  F:     Documentation/networking/phy.rst
> >  F:     drivers/net/mdio/
> > +F:     drivers/net/mdio/fwnode_mdio.c
> >  F:     drivers/net/mdio/of_mdio.c
> >  F:     drivers/net/pcs/
> >  F:     drivers/net/phy/
> > diff --git a/drivers/net/mdio/Kconfig b/drivers/net/mdio/Kconfig
> > index a10cc460d7cf..2d5bf5ccffb5 100644
> > --- a/drivers/net/mdio/Kconfig
> > +++ b/drivers/net/mdio/Kconfig
> > @@ -19,6 +19,15 @@ config MDIO_BUS
> >           reflects whether the mdio_bus/mdio_device code is built as a
> >           loadable module or built-in.
> >
> > +config FWNODE_MDIO
> > +       def_tristate PHYLIB
> 
> (Seems "selectable only" item)

What do you mean by "selectable only" item here? Can you please point to some
other example?

> 
> > +       depends on ACPI
> > +       depends on OF
> 
> Wouldn't be better to have
>   depends on (ACPI || OF) || COMPILE_TEST
> 
> And honestly I don't understand it in either (AND or OR) variant. Why
> do you need a dependency like this for fwnode API?

Here, fwnode_mdiobus_register_phy() uses objects from both ACPI and OF.

> 
> Moreover dependencies don't work for "selectable only" items.
> 
> > +       depends on PHYLIB
> > +       select FIXED_PHY
> > +       help
> > +         FWNODE MDIO bus (Ethernet PHY) accessors
> > +
> >  config OF_MDIO
> >         def_tristate PHYLIB
> >         depends on OF
> > diff --git a/drivers/net/mdio/Makefile b/drivers/net/mdio/Makefile
> > index 5c498dde463f..ea5390e2ef84 100644
> > --- a/drivers/net/mdio/Makefile
> > +++ b/drivers/net/mdio/Makefile
> > @@ -1,7 +1,8 @@
> >  # SPDX-License-Identifier: GPL-2.0
> >  # Makefile for Linux MDIO bus drivers
> >
> > -obj-$(CONFIG_OF_MDIO)  += of_mdio.o
> > +obj-$(CONFIG_FWNODE_MDIO)      += fwnode_mdio.o
> > +obj-$(CONFIG_OF_MDIO)          += of_mdio.o
> >
> >  obj-$(CONFIG_MDIO_ASPEED)              += mdio-aspeed.o
> >  obj-$(CONFIG_MDIO_BCM_IPROC)           += mdio-bcm-iproc.o
> > diff --git a/drivers/net/mdio/fwnode_mdio.c b/drivers/net/mdio/fwnode_mdio.c
> > new file mode 100644
> > index 000000000000..0982e816a6fb
> > --- /dev/null
> > +++ b/drivers/net/mdio/fwnode_mdio.c
> > @@ -0,0 +1,77 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +/*
> > + * fwnode helpers for the MDIO (Ethernet PHY) API
> > + *
> > + * This file provides helper functions for extracting PHY device information
> > + * out of the fwnode and using it to populate an mii_bus.
> > + */
> > +
> > +#include <linux/acpi.h>
> > +#include <linux/of.h>
> > +#include <linux/of_mdio.h>
> > +#include <linux/phy.h>
> > +
> > +MODULE_AUTHOR("Calvin Johnson <calvin.johnson@oss.nxp.com>");
> > +MODULE_LICENSE("GPL");
> > +
> > +int fwnode_mdiobus_register_phy(struct mii_bus *bus,
> > +                               struct fwnode_handle *child, u32 addr)
> > +{
> > +       struct mii_timestamper *mii_ts = NULL;
> > +       struct phy_device *phy;
> > +       bool is_c45 = false;
> > +       u32 phy_id;
> > +       int rc;
> > +
> > +       if (is_of_node(child)) {
> > +               mii_ts = of_find_mii_timestamper(to_of_node(child));
> > +               if (IS_ERR(mii_ts))
> > +                       return PTR_ERR(mii_ts);
> > +       }
> > +
> > +       rc = fwnode_property_match_string(child, "compatible", "ethernet-phy-ieee802.3-c45");
> > +       if (rc >= 0)
> > +               is_c45 = true;
> > +
> > +       if (is_c45 || fwnode_get_phy_id(child, &phy_id))
> > +               phy = get_phy_device(bus, addr, is_c45);
> > +       else
> > +               phy = phy_device_create(bus, addr, phy_id, 0, NULL);
> > +       if (IS_ERR(phy)) {
> > +               unregister_mii_timestamper(mii_ts);
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
> > +       } else if (is_of_node(child)) {
> > +               rc = of_mdiobus_phy_device_register(bus, phy, to_of_node(child), addr);
> > +               if (rc) {
> > +                       unregister_mii_timestamper(mii_ts);
> > +                       phy_device_free(phy);
> > +                       return rc;
> > +               }
> > +       }
> > +
> > +       /* phy->mii_ts may already be defined by the PHY driver. A
> > +        * mii_timestamper probed via the device tree will still have
> > +        * precedence.
> > +        */
> > +       if (mii_ts)
> > +               phy->mii_ts = mii_ts;
> > +       return 0;
> > +}
> > +EXPORT_SYMBOL(fwnode_mdiobus_register_phy);
> > diff --git a/drivers/net/mdio/of_mdio.c b/drivers/net/mdio/of_mdio.c
> > index 48b6b8458c17..db293e0b8249 100644
> > --- a/drivers/net/mdio/of_mdio.c
> > +++ b/drivers/net/mdio/of_mdio.c
> > @@ -32,7 +32,7 @@ static int of_get_phy_id(struct device_node *device, u32 *phy_id)
> >         return fwnode_get_phy_id(of_fwnode_handle(device), phy_id);
> >  }
> >
> > -static struct mii_timestamper *of_find_mii_timestamper(struct device_node *node)
> > +struct mii_timestamper *of_find_mii_timestamper(struct device_node *node)
> >  {
> >         struct of_phandle_args arg;
> >         int err;
> > @@ -49,6 +49,7 @@ static struct mii_timestamper *of_find_mii_timestamper(struct device_node *node)
> >
> >         return register_mii_timestamper(arg.np, arg.args[0]);
> >  }
> > +EXPORT_SYMBOL(of_find_mii_timestamper);
> >
> >  int of_mdiobus_phy_device_register(struct mii_bus *mdio, struct phy_device *phy,
> >                               struct device_node *child, u32 addr)
> > diff --git a/include/linux/fwnode_mdio.h b/include/linux/fwnode_mdio.h
> > new file mode 100644
> > index 000000000000..8c0392845916
> > --- /dev/null
> > +++ b/include/linux/fwnode_mdio.h
> > @@ -0,0 +1,24 @@
> > +/* SPDX-License-Identifier: GPL-2.0-only */
> > +/*
> > + * FWNODE helper for the MDIO (Ethernet PHY) API
> > + */
> > +
> > +#ifndef __LINUX_FWNODE_MDIO_H
> > +#define __LINUX_FWNODE_MDIO_H
> > +
> > +#include <linux/phy.h>
> > +
> > +#if IS_ENABLED(CONFIG_FWNODE_MDIO)
> > +int fwnode_mdiobus_register_phy(struct mii_bus *bus,
> > +                               struct fwnode_handle *child, u32 addr);
> > +
> > +#else /* CONFIG_FWNODE_MDIO */
> > +static inline int fwnode_mdiobus_register_phy(struct mii_bus *bus,
> > +                                             struct fwnode_handle *child,
> > +                                             u32 addr)
> > +{
> > +       return -EINVAL;
> > +}
> > +#endif
> > +
> > +#endif /* __LINUX_FWNODE_MDIO_H */
> > diff --git a/include/linux/of_mdio.h b/include/linux/of_mdio.h
> > index 2b05e7f7c238..e4ee6c4d9431 100644
> > --- a/include/linux/of_mdio.h
> > +++ b/include/linux/of_mdio.h
> > @@ -31,6 +31,7 @@ struct mii_bus *of_mdio_find_bus(struct device_node *mdio_np);
> >  int of_phy_register_fixed_link(struct device_node *np);
> >  void of_phy_deregister_fixed_link(struct device_node *np);
> >  bool of_phy_is_fixed_link(struct device_node *np);
> > +struct mii_timestamper *of_find_mii_timestamper(struct device_node *np);
> >  int of_mdiobus_phy_device_register(struct mii_bus *mdio, struct phy_device *phy,
> >                                    struct device_node *child, u32 addr);
> >
> > @@ -118,7 +119,10 @@ static inline bool of_phy_is_fixed_link(struct device_node *np)
> >  {
> >         return false;
> >  }
> > -
> > +static inline struct mii_timestamper *of_find_mii_timestamper(struct device_node *np)
> > +{
> > +       return NULL;
> > +}
> >  static inline int of_mdiobus_phy_device_register(struct mii_bus *mdio,
> >                                             struct phy_device *phy,
> >                                             struct device_node *child, u32 addr)
> > --
> > 2.17.1
> >
> 
> 
Regards
Calvin

