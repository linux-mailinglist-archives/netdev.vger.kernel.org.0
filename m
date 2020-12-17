Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 889862DCCFF
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 08:33:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726601AbgLQHdi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 02:33:38 -0500
Received: from mail-am6eur05on2081.outbound.protection.outlook.com ([40.107.22.81]:59872
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726160AbgLQHdg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Dec 2020 02:33:36 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DB8eMc5GytVXw+D7U7ik/hs6cYaimtVxFpZ+OUdqbMrWm6zLbPLVULPLGN1Oyd5xBfJS0BkIbg9qYTudI02/AjtLc3nRLfOWhBekWOuZAY8Uz/mlAPYdEFIA1YAX019bwlq16o5ZbmIBmi7TfD4qiU+aZUuEpKLCWs1p5eFEB/ANiGh2zDr4PkMz3C25NgYdiJgRxKslrsJpv4w0lOrBp3bRAfHhp3XkwM3J1rATFyoaywmZDWNRrOxXSuvc12lWaJ4Jk9NTp9+eUEpztftnxZ5M/8+V13MLgeRCozFOFBxUI++2PtrYIqboNIUwSUTIoKXKRJA9OA+vdOZJ+mo9vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mWpAU/+WXNlz/jrvbt/ZnViJTvSzHmSrq8Bdojbsahw=;
 b=CsG5t0cixuhBhdDwh8cUXy6GAoRCuJ6CCl0mrSf6SktFBtO3A2lqPU6Xfghbr2lqp4+wz6SDBgO1RBi6+dct7HC5d7vE9RE7dkCB66pu3bJvgYRDeZJ0j0kpQe2KS17VFygxa2JADeYqvTmhYgrKbSj/Orcx1JxelZfgptEPmwfMUyLvBF2NhkwwSlZHuNF75+cOUBwWiDidlfqEGKQB7zJkvntb+h4yvn4bS+Q/Cn8d4bI12GWZ4U5/vMcNwnXfylfnIS06cwi7keOz7S7b7ic56/O1g8zeHw1LUkfODLWoSBOTOZYsvINXd0I9QWebiVjdBbPtrB1CCfIVIz//4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mWpAU/+WXNlz/jrvbt/ZnViJTvSzHmSrq8Bdojbsahw=;
 b=eRBs2Mtdohz3ywnRR9guhR2ztY5V8hwOaWB4L8tJPX9CuCTM+ERwcXMMa5m3cjoWdpuQ3OjxPo8dKS16s3POjg0+R9NZu0kISefCAjH0M+Nh9LbS5ysKw7aQhCoSfYDYPrC2d/3Ft1yPEd5fTBEUF0uVzezfoOBrljw5+MYGjIk=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB5025.eurprd04.prod.outlook.com (2603:10a6:208:cd::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Thu, 17 Dec
 2020 07:32:45 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a891:518d:935c:30dd]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a891:518d:935c:30dd%6]) with mapi id 15.20.3654.020; Thu, 17 Dec 2020
 07:32:44 +0000
Date:   Thu, 17 Dec 2020 13:02:24 +0530
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
Subject: Re: [net-next PATCH v2 02/14] net: phy: Introduce phy related fwnode
 functions
Message-ID: <20201217073224.GA19657@lsv03152.swis.in-blr01.nxp.com>
References: <20201215164315.3666-1-calvin.johnson@oss.nxp.com>
 <20201215164315.3666-3-calvin.johnson@oss.nxp.com>
 <CAHp75VeJc6jXAi9LV84+-paH+8Xx7+-6vtfSe+G5eoFn2VRErg@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75VeJc6jXAi9LV84+-paH+8Xx7+-6vtfSe+G5eoFn2VRErg@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR01CA0127.apcprd01.prod.exchangelabs.com
 (2603:1096:4:40::31) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR01CA0127.apcprd01.prod.exchangelabs.com (2603:1096:4:40::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Thu, 17 Dec 2020 07:32:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 983117a0-4539-4800-4c3f-08d8a25df213
X-MS-TrafficTypeDiagnostic: AM0PR04MB5025:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB50257D8118AF89A6FEA18F05D2C40@AM0PR04MB5025.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YRCMp5hC2vEJGKns4zAbquf2THBTcG/B9kbpkoTEft4P/myz8HRwEbDRBmKOe1WPJ8XzvTHpVthaZSjCyGqxlWOAYhaXFaEpDWiVx88ZMrMX55DrGvHQHBuSx5PZA9j+5nwbjHofXJJNFQ+BlYo2mpwxKyMzNdITw+ZU6GYvOgTcr/TMDNxhaGsH3SR3LzCsL8HpXWELbD5RJHELR6A0F8RbQVKqTlhAb8KZEW6FDYBt3tdSLeMBHbV7+qJstHnLNFeo8b09uleAg5FR0yjDxJDBWjFqekC3kkxvup0K/wbr0XgON7NIGPcZCEdLjlmiZ5M4zpXUmQTMQ7bbVRIVnK3Ea631Fr0i+hrzOflYnpmcKCQw+6yJpC+kNTTrH0MAJuKThKvzmWHWoRqwjkpxi3o9XzEowELEKwxjidghzuLtiVHQ3ev0vCuMpM6zzbQCP+44NxzxOYMwweJtTNliBQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(136003)(346002)(366004)(39860400002)(1076003)(55016002)(2906002)(6666004)(16526019)(956004)(66946007)(66476007)(86362001)(7416002)(8676002)(316002)(66556008)(44832011)(6916009)(9686003)(1006002)(83380400001)(7696005)(54906003)(4326008)(966005)(52116002)(5660300002)(26005)(55236004)(8936002)(186003)(6506007)(53546011)(33656002)(478600001)(110426006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?8unNBxUfshPeY1K0TqHF0MQrDUx1T8CTbumMvrLA9XU7vAjgy6Tg5YHnryjb?=
 =?us-ascii?Q?ZJPFlxAeCGlJ+I3vEjP59UeNC7QlKJaI8/OkNF4lX781SiWlzxEd88dVjYC/?=
 =?us-ascii?Q?lHjnewsTQJgUToY45+GMXhTYazTTi64LS1WGn/2+CDG1plLFaXE9uMtbd5vX?=
 =?us-ascii?Q?3ur+uekv9BSri64adai7Jh+cf7yiUkoE3y5sPtt3Fy5J0Yh9MCcujB5lSGoG?=
 =?us-ascii?Q?BOyUiAWiguMOXBGvXifC9Ys6vC/600UGk+uFjfIytnb5Okeb8WLGBtzDIntd?=
 =?us-ascii?Q?sF6twH6s1LFloKu42oOayF9k4qgUpAVzVnrYmSlxkoIm3FoCk06ZYw1OcZUk?=
 =?us-ascii?Q?M7lDn4LySBfZ7JB+uDJlh0e+gdTSlO2rRRG8dEgXWS6ME4HIA25qsZ4Pkqo4?=
 =?us-ascii?Q?/csJ70u+22H7MzOEAkCK7upQYgMTROrPFg8Nr+I2mV1sFsh4jtQyVH8Xphda?=
 =?us-ascii?Q?6PkS1vST2I4rKZGziEfYFBrNmba56oHggNCGh7UPvzDtsXcFEGqtS7GOBJEx?=
 =?us-ascii?Q?i6wS0DNMy+RvqL5G2n0ZyQqIYQsRUBeiLEJi/q2Vcz2CQWWqQkchxEYLzlym?=
 =?us-ascii?Q?UdFuLXgHpyYgPVKv/KwKHjt7gdoEKthNi/B+xU+LGQLtRQM8ctrbQAvIfOwa?=
 =?us-ascii?Q?RQ0aMAwVxfEfBgVk9XcUbzYsPSo9hEHou5C89DatZwCkvABR7Merpw1wp3Ii?=
 =?us-ascii?Q?TYHS//qp/ozplK7GAXjjPtLy5/MegqWjhds3N6/FP4TrlmGZWFeki9suDERY?=
 =?us-ascii?Q?b4NuyRpYzabUKjmuqTuGruFtTQocSIghX3SVD7Z3rWkd145joROPiaiZYzgF?=
 =?us-ascii?Q?hLABKSpHqCmyMDdtt0T6iXlUdzIRI6IHxgviVGFJJ5FcMLTOgwIubs1pa7/m?=
 =?us-ascii?Q?oMsEmFp1OVSALnRc6xxp3PfE3lv/9KVm4oKjL6kGJDDm1d+9FBIWaEXmgC0h?=
 =?us-ascii?Q?V8r58vcEHMbWUQnb2SFworwu2go9jIIgOPeI44RoN3KsSD4Ce5NbIZMWyH3T?=
 =?us-ascii?Q?nFGe?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2020 07:32:44.8345
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: 983117a0-4539-4800-4c3f-08d8a25df213
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QoGg5PquZATkEfP6dgii4+x+9u9h4ZlRGA1tcLpWFwm+oMM6SbsaDXlOh6qkdJO97VygVFSnY8111xG6nAiBJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5025
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 15, 2020 at 07:23:26PM +0200, Andy Shevchenko wrote:
> On Tue, Dec 15, 2020 at 6:44 PM Calvin Johnson
> <calvin.johnson@oss.nxp.com> wrote:
> >
> > Define fwnode_phy_find_device() to iterate an mdiobus and find the
> > phy device of the provided phy fwnode. Additionally define
> > device_phy_find_device() to find phy device of provided device.
> >
> > Define fwnode_get_phy_node() to get phy_node using named reference.
> 
> ...
> 
> > +#include <linux/acpi.h>
> 
> Not sure we need this. See below.

This is required to use is_acpi_node().
> 
> ...
> 
> > +/**
> > + * fwnode_phy_find_device - Find phy_device on the mdiobus for the provided
> > + * phy_fwnode.
> 
> Can we keep a summary on one line?

Ok
> 
> > + * @phy_fwnode: Pointer to the phy's fwnode.
> > + *
> > + * If successful, returns a pointer to the phy_device with the embedded
> > + * struct device refcount incremented by one, or NULL on failure.
> > + */
> > +struct phy_device *fwnode_phy_find_device(struct fwnode_handle *phy_fwnode)
> > +{
> > +       struct mdio_device *mdiodev;
> > +       struct device *d;
> 
> > +       if (!phy_fwnode)
> > +               return NULL;
> 
> Why is this needed?
> Perhaps a comment to the function description explains a case when
> @phy_fwnode == NULL.

I think this function should be modified to follow of_phy_find_device() which
has NULL check. I'll add fwnode_mdio_find_device() also.
Here is a case where of_phy_find_device() is called without checking phy_np.
https://elixir.bootlin.com/linux/latest/source/drivers/net/ethernet/qualcomm/emac/emac-phy.c#L145
> 
> > +       d = bus_find_device_by_fwnode(&mdio_bus_type, phy_fwnode);
> > +       if (d) {
> > +               mdiodev = to_mdio_device(d);
> > +               if (mdiodev->flags & MDIO_DEVICE_FLAG_PHY)
> > +                       return to_phy_device(d);
> > +               put_device(d);
> > +       }
> > +
> > +       return NULL;
> > +}
> 
> ...
> 
> > + * For ACPI, only "phy-handle" is supported. DT supports all the three
> > + * named references to the phy node.
> 
> ...
> 
> > +       /* Only phy-handle is used for ACPI */
> > +       phy_node = fwnode_find_reference(fwnode, "phy-handle", 0);
> > +       if (is_acpi_node(fwnode) || !IS_ERR(phy_node))
> > +               return phy_node;
> 
> So, what is the problem with going through the rest on ACPI?
> Usually we describe the restrictions in the documentation.

Others are legacy DT properties which are not intended to be supported
in ACPI. I can add this info in the document.

Thanks for the review, Andy!

Regards
Calvin
