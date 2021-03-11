Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17A3F337A3C
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 18:00:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbhCKQ7a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 11:59:30 -0500
Received: from mail-vi1eur05on2059.outbound.protection.outlook.com ([40.107.21.59]:32160
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229777AbhCKQ7G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 11:59:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lH2xR99AjdHut7RRI6fa4Z2UCrZt7l/LPEBUgHS9K7v+aUHKViJ3/5wtALXJzJp93xLRouluObktorjJO6zAmw699PXlAZg6XEnDwG2xrB1DzpGt++J9wIVDXlrWGFe15Z9tYewDbxU7y+7568Knd/zTk7SCs7mvJ3BRnOP/KVwf0BSBJVu3IVksU7ne8JkCIzKuBWQXabIRlnQEM527vLN7tsugAJRzaCl4jCmIgO08GT6Q9ortqz0ga5I++zg/TgSwB0oTfrrcAlmMwIckETG77u3kfoppcY9l/d2A8SwxHyT02P2EZuHYEolsvCMcQxkCoijKBihvOYa5rbXNhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=30owklYDPw6/B3081fpd+SyKPNneVzz3HHlLP+tXRjQ=;
 b=FDit8e2MTmEGEuY1lbuEom50WbBUTDD/fWrxoMPTzylijnCYlReBjMOlIDucKz7bZuog3BZ8o0MTUeemFNuuKV65GccQUVpiIu8GfCgj0hmkFMdq2rlgifeiwbJ9w+4MEn9ZN4nji4UqG6UCQxOkBT1b1k9CoV57VCNwAFRoTxw10QkWIs/CIIXkcnujIbbbCT1pchg3yHEmFsrY/ENtDGxBuloSxzuyWKaVA1ajItxdMCYvK+K66AceztVyvJ09oBToLiXn3lVECvzJMzMk/UXBCxq5q97u2w09Vl4sToQMhlfrNQUe79T1nOijs9Bl48A9QljIeLkdthDCjBiiPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=30owklYDPw6/B3081fpd+SyKPNneVzz3HHlLP+tXRjQ=;
 b=eAo4qMlYjkSbHVmq9qeiIaEzfWb+zyZaRbT4lzWooYEcniSxk3wWOlB3/E6nGnd6MRS4VoBeg6vWnwHLKhVejd+VYubPY2e+ia+Gs/sHWFKkhmVo9KNn95IPQhe7FIpu4y/A1fnYAUBqlL2xTpucNBVj4oyny77O6gq7NT5Rr6Q=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB6964.eurprd04.prod.outlook.com (2603:10a6:208:18a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Thu, 11 Mar
 2021 16:59:03 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::1cd:7101:5570:cd79]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::1cd:7101:5570:cd79%7]) with mapi id 15.20.3912.027; Thu, 11 Mar 2021
 16:59:03 +0000
Date:   Thu, 11 Mar 2021 22:28:42 +0530
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     Saravana Kannan <saravanak@google.com>
Cc:     Grant Likely <grant.likely@arm.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Pieter Jansen Van Vuuren <pieter.jansenvv@bamboosystems.io>,
        Jon <jon@solid-run.com>, Randy Dunlap <rdunlap@infradead.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux.cj" <linux.cj@gmail.com>, netdev <netdev@vger.kernel.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [net-next PATCH v7 02/16] net: phy: Introduce
 fwnode_mdio_find_device()
Message-ID: <20210311165842.GA5031@lsv03152.swis.in-blr01.nxp.com>
References: <20210311062011.8054-1-calvin.johnson@oss.nxp.com>
 <20210311062011.8054-3-calvin.johnson@oss.nxp.com>
 <CAGETcx87Upc701NZstiDx8Px1o9b+s4ANpbG0AP5bjC8DxMMrg@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGETcx87Upc701NZstiDx8Px1o9b+s4ANpbG0AP5bjC8DxMMrg@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: HK2PR04CA0081.apcprd04.prod.outlook.com
 (2603:1096:202:15::25) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by HK2PR04CA0081.apcprd04.prod.outlook.com (2603:1096:202:15::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Thu, 11 Mar 2021 16:58:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9c3fcf88-92e7-4c4e-3c26-08d8e4aef8c5
X-MS-TrafficTypeDiagnostic: AM0PR04MB6964:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB6964C4A5ACC4D21AE18E3126D2909@AM0PR04MB6964.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f79K+yUci+CnbiF5dLWoDngffz/27hQmVDhmCIql7+LliWej5+CCT0P5BOMN7tLB8OS9w0J5CkDFS6jMpgTO8L/aakx4FNro6tSYH46mO2LawHPb9OY4i3fMF4wwgB4iVsgeL6dGUHEbz5g6iX0pql6Ghlb8qTNo5iYZdY+blXnOcCsQLFX+hzE8Sn1Ni9Ee6u8H/6oxSj3BOpZyCqnxKOVGjvPn4I4zIgDRvofn2WLeMOv9+w9v+7NGXrCn8Z9az4X2cM89kTdm+8yucaXoaloz7fr4ZTzJFzKKxwZX9jLya/x6xrcHGozKSgdYOHCKMsGzbPGUrmeIMhnMCwWZU1Z0fwv+4UkNzTfAB+pTDoFXIrKp3noM1hTa91C5w6pcLfDYG/BpAppPXqWguIzDqzGmM9sYGLG+SEuEQm1o8FK1fCYvs90kUB5ZCZwuJ93qOuvmo+AaBvz0Ce55+XNGfhEVvRrztliy5G3p3XLwKRVfyz+szI16Ue8kjur6fcC3OtF1rkeuaLUGesqIfOIdZMY1L01sjVdfpVeBmGzsmpw6aPosCcfL61mSSKhiZIQKB/Idqk5uNad/V/3GX5FzFg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(376002)(346002)(366004)(396003)(54906003)(478600001)(316002)(8676002)(53546011)(6506007)(66476007)(66946007)(6666004)(86362001)(26005)(7696005)(33656002)(52116002)(8936002)(66556008)(4326008)(44832011)(55236004)(186003)(83380400001)(2906002)(6916009)(1076003)(7416002)(16526019)(1006002)(956004)(9686003)(55016002)(5660300002)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?AGQulN+g9iAgME6fcs/ftEg6QH6PSwBqsx3jXzVcKVF3wwHeX+j6hWIi0/yv?=
 =?us-ascii?Q?FwCDmoD9hEaPIE2Ck9pXEtXFaRBBrhj5WkGBaAHNeDwi8BdkVTp03c25CUSN?=
 =?us-ascii?Q?bVBTGdeTUFyzDbqck3CoK6/h+1ys1hUL66/FzbD1khLEhwRxV4zsBJrk1yHt?=
 =?us-ascii?Q?3wNrH1wFDdZgaLutq25d8T5YN8iGrc1zDyqZJ+LUoweOfFyUaHJW6OVQZwJt?=
 =?us-ascii?Q?azamQs1mBRO3Kiu6p/JLXHNCSu76zjJ1F+/kyZPGOZECQc6+iZb/DhBJ1mqg?=
 =?us-ascii?Q?hlkViUJ/A+KkBJ+Ht9kXCnMQCH3JrHO8JfhlhpRwyo6l/U1qilS8Hq4aPfj5?=
 =?us-ascii?Q?jiibtAu6jJNs3/1b1EekVczzXc410MhNegXHzUxIGKvVNSu0Zim5aXORltL+?=
 =?us-ascii?Q?HNG0rU1B4chjdTc6O1EozTtq6nM0HTx4g/+O96pIrN/UCqDIC8Hc6kgZh9rm?=
 =?us-ascii?Q?febhnk/CxMpSeI3b/iRpQJadlm1bPgiJt4DphLN5bFDxVmULtlokSyUUePfR?=
 =?us-ascii?Q?0sLPEHQ61scJP/HNsTBQm5W9Q67AdfpaWpzB1VNucL3oSXozUJC2H6K+zPhq?=
 =?us-ascii?Q?rd6Su1Y2uqngTDN5lQ4wGzFiYj7SDXThz6m5g+V6B1W+c+rd+WdUMMcKp1w2?=
 =?us-ascii?Q?V7pi21im+vnQg842u3iBaXGTl58AI3rIH1SBzMNaNYpryR8yS53sixI1d8xy?=
 =?us-ascii?Q?U9/tfoeY7JKgR5Z8EqeR5Rr10CTI1Cb0o3BaO4dBa73doU/bwlLv5fjLx9wG?=
 =?us-ascii?Q?OO7RkjrCCKOXICTvlxZClpdjf9BO9sm6K+mj1IjeBcWtewWZbNC7srJKA4Ib?=
 =?us-ascii?Q?i4aoLVMS2gvvBwUG+tIMjC0WdOlLCGsMYMaF9yg0Q1D6NVyzTJsrxknYczOi?=
 =?us-ascii?Q?nJ9NsJNWodHur6oBsG7On2d54hctvQfTI9n+FWAcqfEH0lZUkoYbOAiSbEk1?=
 =?us-ascii?Q?kOTVbUs9ojkSVXb/sJvt+pWSA6BhsOi27uB2onvdSDGpUcRxfYPCX7Wc7jgC?=
 =?us-ascii?Q?mo83qwUnlCLLuhTd1LA/wngGSj+g4BbGBZo6aPEcR3IOvGHRyf4TP3PT+Ofj?=
 =?us-ascii?Q?yBeJBY9P7406cadlw3UYE4mEAvti3PCm9HHxg1Cr3RbjSR2M22/qG8jrXBaG?=
 =?us-ascii?Q?CSygUISaswZR6YGNULyLcOzKIpjnt6S2wK7ch06WJCrquvmR7Y5EXybgfK8E?=
 =?us-ascii?Q?K/KQ7vXngyl0Jea1XjZVfKMnDnVRuBHW//SzUI973eHichVlVUlxhvh5Sicj?=
 =?us-ascii?Q?Ff+yFLBkvKyPzwAYzhDKp3b1l5BuVX+Bu5z3tdcNW5gy+QqA54AHPqLwQEp+?=
 =?us-ascii?Q?qg8gtqG6mWa9A4HAslUBWsKr?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c3fcf88-92e7-4c4e-3c26-08d8e4aef8c5
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2021 16:59:02.9049
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FudVrajInlxEoNbmFvgKN84mm3UJKKyskUpSrrX/gytE8Engd++Xneqj322g9HO8hwYv7IHfYQpCFW5xzJMkVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6964
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 10, 2021 at 10:50:57PM -0800, Saravana Kannan wrote:
> On Wed, Mar 10, 2021 at 10:21 PM Calvin Johnson
> <calvin.johnson@oss.nxp.com> wrote:
> >
> > Define fwnode_mdio_find_device() to get a pointer to the
> > mdio_device from fwnode passed to the function.
> >
> > Refactor of_mdio_find_device() to use fwnode_mdio_find_device().
> >
> > Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
> > ---
> >
> > Changes in v7:
> > - correct fwnode_mdio_find_device() description
> >
> > Changes in v6:
> > - fix warning for function parameter of fwnode_mdio_find_device()
> >
> > Changes in v5: None
> > Changes in v4: None
> > Changes in v3: None
> > Changes in v2: None
> >
> >  drivers/net/mdio/of_mdio.c   | 11 +----------
> >  drivers/net/phy/phy_device.c | 23 +++++++++++++++++++++++
> >  include/linux/phy.h          |  6 ++++++
> >  3 files changed, 30 insertions(+), 10 deletions(-)
> >
> > diff --git a/drivers/net/mdio/of_mdio.c b/drivers/net/mdio/of_mdio.c
> > index ea9d5855fb52..d5e0970b2561 100644
> > --- a/drivers/net/mdio/of_mdio.c
> > +++ b/drivers/net/mdio/of_mdio.c
> > @@ -347,16 +347,7 @@ EXPORT_SYMBOL(of_mdiobus_register);
> >   */
> >  struct mdio_device *of_mdio_find_device(struct device_node *np)
> >  {
> > -       struct device *d;
> > -
> > -       if (!np)
> > -               return NULL;
> > -
> > -       d = bus_find_device_by_of_node(&mdio_bus_type, np);
> > -       if (!d)
> > -               return NULL;
> > -
> > -       return to_mdio_device(d);
> > +       return fwnode_mdio_find_device(of_fwnode_handle(np));
> >  }
> >  EXPORT_SYMBOL(of_mdio_find_device);
> >
> > diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> > index cc38e326405a..daabb17bba00 100644
> > --- a/drivers/net/phy/phy_device.c
> > +++ b/drivers/net/phy/phy_device.c
> > @@ -2819,6 +2819,29 @@ static bool phy_drv_supports_irq(struct phy_driver *phydrv)
> >         return phydrv->config_intr && phydrv->handle_interrupt;
> >  }
> >
> > +/**
> > + * fwnode_mdio_find_device - Given a fwnode, find the mdio_device
> > + * @fwnode: pointer to the mdio_device's fwnode
> > + *
> > + * If successful, returns a pointer to the mdio_device with the embedded
> > + * struct device refcount incremented by one, or NULL on failure.
> > + * The caller should call put_device() on the mdio_device after its use.
> > + */
> > +struct mdio_device *fwnode_mdio_find_device(struct fwnode_handle *fwnode)
> > +{
> > +       struct device *d;
> > +
> > +       if (!fwnode)
> > +               return NULL;
> > +
> > +       d = bus_find_device_by_fwnode(&mdio_bus_type, fwnode);
> 
> Sorry about the late review, but can you look into using
> get_dev_from_fwnode()? As long as you aren't registering two devices
> for the same fwnode, it's an O(1) operation instead of having to loop
> through a list of devices in a bus. You can check the returned
> device's bus type if you aren't sure about not registering two devices
> with the same fw_node and then fall back to this looping.

I think it is better to keep it simple and clear with
bus_find_device_by_fwnode() instead of the additional code that comes
with get_dev_from_fwnode() until it has clear advantage over the former.

regards
Calvin
