Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4BB32DDE32
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 06:49:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727153AbgLRFtP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 00:49:15 -0500
Received: from mail-eopbgr20041.outbound.protection.outlook.com ([40.107.2.41]:25533
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725894AbgLRFtO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Dec 2020 00:49:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gm4dMyC0YKdJckmbwmkvyTKQP+GZ4/10HUmakVjr39o6p6YuC//bl9FZ6nfsnPi+ZAeRMsp5ccFECCXwqjsMl+3pTm2x1dnKa3m/5Y8MxWwGZhIePtPTaDNMU4FMK1RTwL25Da5IeYMJn0KB9em/PAPg4dF2wMG/YjcN5qJZ7M4oVRxn4QNS3NiCJuiDds1eu+HyGP24K+nNyaFc8nZLgNJDEqovuJGjyGi5p8/Ot6Fxk7TUkcSafNBgef7sd4wZV7UP8Mbk8BjVxAbUajnvxYSN7/yZ2Q5paN8ZE0Kn1bN4qp5Blj7eFDZfCLmQUNFc+QLBIj/cCgP3dH1W+AledA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uL8j7/fMIXv3TSDVk2+xAJ5C5c8KKJcdDUYXEXSITzw=;
 b=n86L57QkV/zxfzHcI8gIwMQytdh6bVEej/Pt0TtSUHH1NkeBio8gqwsGSCqLGIAYmJ95n9qLfMqAdcbMZkylpyx1WkTCrlPBBza/zYbQlQbza8ZgbyMR3d4KlzhXkipdVa0oQP9GeYYmtVb1SlArn/xawkDskepmShHOuc5NS/Nmirmx4YK2GrkBUdt9yE/t3r2igLmApFXPHQP3J/iGaNsHqqsoru3VYZ1OqqVx6OXQAQH2zak8UXyYhN/5VKK+YkECSX3QmXKVF5//N1PIW/M9TLJ97yTfC56BEOFRYhXDWXbZ4eY2/x+eZ6MNyCicoqPbO0y/fTNyPsc/Jp0Lkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uL8j7/fMIXv3TSDVk2+xAJ5C5c8KKJcdDUYXEXSITzw=;
 b=GR8qXlj5Ykzv9ShvYn8fmFDHd1C7nV91b9DIOeeRNVjXY13OqO5e0WMP1IKCyWt/A3voY75c9xqT5q4BvqPfQXfnKfgXFwP15XD9nFj7zr8NLkCGvmG+9F4+k7etzaSCzpQ1LZx3i3/uOlD0EEk/pZhawrSW2Xw9jwJ/jLnqpTc=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB6065.eurprd04.prod.outlook.com (2603:10a6:208:139::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.21; Fri, 18 Dec
 2020 05:48:23 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a891:518d:935c:30dd]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a891:518d:935c:30dd%6]) with mapi id 15.20.3654.020; Fri, 18 Dec 2020
 05:48:23 +0000
Date:   Fri, 18 Dec 2020 11:18:10 +0530
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
        Jakub Kicinski <kuba@kernel.org>,
        Jamie Iles <jamie@nuviainc.com>
Subject: Re: [net-next PATCH v2 09/14] net/fsl: Use fwnode_mdiobus_register()
Message-ID: <20201218054810.GC14594@lsv03152.swis.in-blr01.nxp.com>
References: <20201215164315.3666-1-calvin.johnson@oss.nxp.com>
 <20201215164315.3666-10-calvin.johnson@oss.nxp.com>
 <CAHp75Vc19QCqYpp12Q3ofzXCVsujc0qVuhtQo5LhDJqiy+JNpw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75Vc19QCqYpp12Q3ofzXCVsujc0qVuhtQo5LhDJqiy+JNpw@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR02CA0093.apcprd02.prod.outlook.com
 (2603:1096:4:90::33) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR02CA0093.apcprd02.prod.outlook.com (2603:1096:4:90::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Fri, 18 Dec 2020 05:48:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f9180948-91e4-44dc-c8cb-08d8a3188887
X-MS-TrafficTypeDiagnostic: AM0PR04MB6065:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB6065E541D8BF99B28D39DAD1D2C30@AM0PR04MB6065.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4GQOSBLTKf0Y8JP0RxU+uTHErq/kOeI33X7Ry1qwhZZx6WwZSzAK9vywLOdga/N7L1D7TisOHm/4LS4N5Hs77EC2HFGYOG/GUEQs37d5f7Fkj/NuKd0hO3HbIcL7GoTZaGCLW5BfL8h9AWSRIYsqKzlmJOwafl5Pv9vKz6CPA90DAR+3nyb/pY0puqTmyankv8vDlc/GrKxKDcRj2ecSQaDYQm2jADGmck9yDVt564345KNtwU2kHJlk+ZxUpTZF4DoxdS/DcMPAWWvjxJmaHpXFRE9R4yNpVR02G9DWO81zQrgTpRV4wnl60sK0NHHlwwjzO+k7xaIGRN7eJK3QRwU+m2zMXIdPAUk8UqFQ1aQDKSuC+uaYwTnjrMLn4F3N
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(346002)(396003)(39860400002)(366004)(956004)(55236004)(44832011)(316002)(54906003)(186003)(16526019)(26005)(53546011)(6506007)(478600001)(86362001)(52116002)(7696005)(6916009)(8936002)(1006002)(6666004)(7416002)(1076003)(4326008)(9686003)(33656002)(55016002)(8676002)(2906002)(66476007)(66556008)(66946007)(5660300002)(110426006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?bSHnDDmHDti7FhAJvyc8ebOt2wXTTQX8V2yLgnsvF1TvVwe0qoV240u7J88i?=
 =?us-ascii?Q?snGiQ3Z+iAdVhKHLTFubVvyvfffIPuOE8zGr0HoRi8MH1pWSUNvO0v2acx2Y?=
 =?us-ascii?Q?G+yEsx/yDNp/snzyOPYIseoiJNjMKgXjK4BRnfvo66IA2fcJAq+DiWdX1ppj?=
 =?us-ascii?Q?T7Li6jmdxenoq32r2pYi3+B6a8kwhKPLJSM63oHrAtbaxLSYF98jCH9i0Ywq?=
 =?us-ascii?Q?JwGvKEVoBZ0EfHQgvUU/A9468GegFwJPMnqH+iFp66mqRGfDGTuThEr/KoMt?=
 =?us-ascii?Q?84rmuK9pxHLaOnrCHSogfWrgWXw6mVIbvho7dyemG0QKsqKhcQmZZOSrnZ87?=
 =?us-ascii?Q?JPXLupU3QvCL9enq99vyZ6V4+ygM5fBPDzSwdiRbxufqCeK0O3ymvwgsOj4b?=
 =?us-ascii?Q?4cBn9fhasn2AvcxzVYUKlNf4Inh8BDeiWCb4sQ4zsiy6DYtmKo5GWWGiuN51?=
 =?us-ascii?Q?p0gIYElLO0dOHGAXmwtU1dPpJah03h2Bw2I9JG2AuEMcCuwdpkN8BdPEun5c?=
 =?us-ascii?Q?ycK2lGvUfpgEVUXffJ09hgGDeSz7lgENWJwEw0D2R0cFZaUjiBnN68+ZQAAq?=
 =?us-ascii?Q?7stGBjpFOmRfafNEscc4Co/N0/cxnYQtVivO97YhVDpRK4FFyuUKnDe7erWl?=
 =?us-ascii?Q?LizZt21i0ocKLe6ibl+TfOaIdnNdz8LfqGFSsL+bQsDI1iyej93+zNXZfgcY?=
 =?us-ascii?Q?Wi3uROMUQkVYOYjfilPmHzEk6KxkKqe3pOnjd1XtaljfOnPgjwNyt/IEWlHz?=
 =?us-ascii?Q?rYsb/LU+kAqURmH/lgaXm/L5ac7eJCLzzOnbj1xEhWv1TkDGTmod+xLj6onz?=
 =?us-ascii?Q?2YaJw/l/iuIPRYPwIFG3D8hKe+dEdQZ0Nz8pK0PRAdnO02VdxgmC+GanuUQ1?=
 =?us-ascii?Q?keM/1prMqf3HeqQ4RFrRZnZ93eVE/DnTxoBgeAA/8D9RQ9lujkxSoBLuSiQl?=
 =?us-ascii?Q?0YBqIF7wOp0s4+VZLxOXG9d8Zh2zRapfxduHDs/UOaYpKpvgg24pPWaRG5/E?=
 =?us-ascii?Q?ARza?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2020 05:48:23.6858
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: f9180948-91e4-44dc-c8cb-08d8a3188887
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JWS6V3o6Co/ZpkSW80N9L644lg3gFxLWl4Se/T3rFRD4Wiuq+82rMUnfJ1za7SmrcyOIf4Ll62xLiVlV/GnQVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6065
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 15, 2020 at 07:55:01PM +0200, Andy Shevchenko wrote:
> On Tue, Dec 15, 2020 at 6:44 PM Calvin Johnson
> <calvin.johnson@oss.nxp.com> wrote:
> >
> > fwnode_mdiobus_register() internally takes care of both DT
> > and ACPI cases to register mdiobus. Replace existing
> > of_mdiobus_register() with fwnode_mdiobus_register().
> >
> > Note: For both ACPI and DT cases, endianness of MDIO controller
> > need to be specified using "little-endian" property.
> 
> ...
> 
> > @@ -2,6 +2,7 @@
> >   * QorIQ 10G MDIO Controller
> >   *
> >   * Copyright 2012 Freescale Semiconductor, Inc.
> > + * Copyright 2020 NXP
> >   *
> >   * Authors: Andy Fleming <afleming@freescale.com>
> >   *          Timur Tabi <timur@freescale.com>
> > @@ -11,6 +12,7 @@
> 
> I guess this...
> 
> >         priv->is_little_endian = device_property_read_bool(&pdev->dev,
> >                                                            "little-endian");
> > -
> >         priv->has_a011043 = device_property_read_bool(&pdev->dev,
> >                                                       "fsl,erratum-a011043");
> 
> ...this...
> 
> > -
> 
> ...and this changes can go to a separate patch.

I think I'll remove the unnecessary cleanup.

Regards
Calvin

