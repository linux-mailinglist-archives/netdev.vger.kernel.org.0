Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B71283076E1
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 14:17:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232186AbhA1NNg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 08:13:36 -0500
Received: from mail-eopbgr60089.outbound.protection.outlook.com ([40.107.6.89]:19470
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229684AbhA1NNR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 08:13:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fZFk8ghWYyNlrUwABfxH8Tqe8160Nd/5RPE6vHA+WtFsTpU8ZJdmbHXYEwqco1JnYMmra8FdJAtrsFmQRNQMR7e2iSB4DAnw47yauDqIkUw1/9ydJ6NgS+9TF23/QYbif8KrpWcdw+/A/SQDOBq91zx8Gbi4chKtQy1PVx5dDAKWAbWvHih6KSNqrWgHcLtsDZ3ss5M6cQTIlEWr/Y/LSVryEjitEWcfh7c4KHXKP6QOSRYFdKzLCBNNNVNKtCs4s2W2kPoEmuzxdZLgOUH25ViVtqRZf7XH1zgQs0EMWn/U5pz5dMIViH6JkR1z8qwnXZRDOf8R3B1uFkWqneNu7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FFL9xMbTnUYlgO3InFoT8PXuCaRRCzZp56bA96+//hM=;
 b=nHulS5ic9WK73A6WvoCOhs+2YdzzttCP6eYUKIcafG4tRbE7p+la7Wr2EmZbcCGX+9GrYKRDrJxe2dTnMDyAfQEXCiT6NmyWqfE/bT8LWFmbX6sw6kwy4R6x0/Ki6WNev3C2B6y+UZ/zaUWtEX0UFKoM/RvNV0aEplsLwsJ9GbZrT+yE0J4h+Hm2b6UOEa3U9D2eS1wUxPDO4YTFESO5+gOLwxfdtQ/MahjA7/DzLY6XN93YlK1wf4asewodqVwd3see9Ru3jw72ytuGy08MOT4UGIyo0AqavvNqkd9FolflbtbBOXuEVuJiMQtgSiA3so6kgc2ljBxl1/Aq0sLdHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FFL9xMbTnUYlgO3InFoT8PXuCaRRCzZp56bA96+//hM=;
 b=OkjMWGa9bWuQiGFsEj3NCyZITbvr2shtjZ/kiypjhRSrkmCMzRhziroW1DMt+/EPTida7nrwaHj4rfDRZUt5lKX5gwd+RuMW753nDCO+v0FTj2P6EMfCc/ZzM5FrRX/XQzUNVRFtHpMoKas9fnY6tLVPiI+V58vvv60gP5QmWhg=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB6436.eurprd04.prod.outlook.com (2603:10a6:208:16b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16; Thu, 28 Jan
 2021 13:12:24 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42%5]) with mapi id 15.20.3784.015; Thu, 28 Jan 2021
 13:12:24 +0000
Date:   Thu, 28 Jan 2021 18:42:05 +0530
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     Grant Likely <grant.likely@arm.com>,
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
        Jon <jon@solid-run.com>, Saravana Kannan <saravanak@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        "linux.cj" <linux.cj@gmail.com>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [net-next PATCH v4 01/15] Documentation: ACPI: DSD: Document
 MDIO PHY
Message-ID: <20210128131205.GA7882@lsv03152.swis.in-blr01.nxp.com>
References: <20210122154300.7628-1-calvin.johnson@oss.nxp.com>
 <20210122154300.7628-2-calvin.johnson@oss.nxp.com>
 <CAJZ5v0iX3uU36448ALA20hiVk968VKTsvgwLrp8ur96MQo3Acw@mail.gmail.com>
 <20210128112729.GA28413@lsv03152.swis.in-blr01.nxp.com>
 <CAJZ5v0id1i57K_=7eiK0cpOE6UtsKNfR7L7UEBcN1=G+WS+1TA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJZ5v0id1i57K_=7eiK0cpOE6UtsKNfR7L7UEBcN1=G+WS+1TA@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR04CA0170.apcprd04.prod.outlook.com (2603:1096:4::32)
 To AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR04CA0170.apcprd04.prod.outlook.com (2603:1096:4::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16 via Frontend Transport; Thu, 28 Jan 2021 13:12:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2075884f-b82a-4448-e08a-08d8c38e5a45
X-MS-TrafficTypeDiagnostic: AM0PR04MB6436:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB643687ED1A0D0C3910BE1E0ED2BA9@AM0PR04MB6436.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eZ+5AhTR8773GS8VY28cgtuJeccbHjuEZEa8qhdBpgeozmUUwAEE90CHnQxr8jCEoSm5viDzdm7EGXiob69f9KTxK30l2IFF6tmK59+Qh2MkB+ePKESjGQlEZ/nmE2Dj6Jym5UVLTesurbclsmcJ+1G1BslvmXdWxO/j3EBL4JI+BYSbNJLlYEvoJjMp8CjIFR4Yv5HR+Fu3x8nNzaurPyLBHDP+WsrKN6slRfiMafmsvIKS525yCBypDqix1ZtzFMsHNoxHyT1O2QVZlLWJ0gplmEAQzDy1J3zpyZXxvJSCbWwU7ov5zdU5J0sWk9vCMxuQO/tj9kajMuizB0TWVgRRl19ZA9A/5lzKvRhxcxswPX6mSG3ldfnpTPjh8oXorY3/1LDoFn0tEMiUAvKL9wUHk8DaiMMdv2OIhmlaAwx/RVU4+jVAq7OgMdJQxmYYopFF0ApzZZ3JsZVDp2mUS+Mn7oLzhUeDUxYQsU8uUkufdE/7yfoexj9weVd/rQ0ia6IoD50V90M+U5pxLNSvfP7WqRtGpHh7xxeihg3nc8ItBFzKJMhGgBDgiS57gIHrfptb+g9pjo8/q/vR3ZODQtGJ8gHBgrKxzL/D8/av86Ye72UT/KL6teHb/u8QdPWfE2IgRVW0YW5FtpUP/7M4AA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(366004)(39860400002)(396003)(376002)(55016002)(966005)(478600001)(6916009)(2906002)(9686003)(6666004)(8936002)(4326008)(8676002)(86362001)(1006002)(33656002)(55236004)(66946007)(1076003)(66556008)(956004)(66476007)(26005)(16526019)(186003)(83380400001)(6506007)(7696005)(5660300002)(7416002)(54906003)(52116002)(44832011)(316002)(53546011)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?4M3zupXTS8FHhGiRNVOp/ygcjr8n0ipH/sCa2cWKRDec7y1018d0uKHFtFL2?=
 =?us-ascii?Q?2NOxoyHMnHP+BycF7Dwx98Z3nViYdP5RFB+xO2b5X7kR8l+kXYp26i8wxmxr?=
 =?us-ascii?Q?WaztXJBVL4EljS+CNYKF+AuShoIrbfDFwQtBCD9ijmuj5mgwZse9QJ6iVJvv?=
 =?us-ascii?Q?W9PuzpSeiufiTbxtbWYubEEKOW5ZBjbHTVThGEtnf4vkcmu0MMZv/g5p/uIm?=
 =?us-ascii?Q?ddlaPu+xXNkkV/tGv8of9p8+NeZ5twKw45cr74Lo2yikPjQKL4MLPZawYAU1?=
 =?us-ascii?Q?N3npNnUcFX6hXiQD3KbsB03trIlg482yWUQbMUPgVwi2/J93rUQv9v4ECazT?=
 =?us-ascii?Q?MrxdGKPRB5We9rJPg3QeABXO+sHQEygAZYvEEIFavsSzq8vNe0OGM1Zz7zQQ?=
 =?us-ascii?Q?TDAVSz+gFgRtCYqMh/gF5+3gzPgVSN7nywnFUsOe13FOeznLY6WsuTB5qejV?=
 =?us-ascii?Q?94UN5qvd56rwqkHGaG4teLEqsRxDgnQALKD+QzvsG8PEBry3v535PajQ58Vg?=
 =?us-ascii?Q?oQXhm/MgD1O4u7yYTjF9WiRP2OJMYVDOgf29e+dZmoQNE8wMbsGTuApBtpB4?=
 =?us-ascii?Q?uVJyn6J2vnlSkDNYOHz/sEXlPeBm1sVpVE4RHJ0nu+AsmK3zRqtiVxv3a2Nj?=
 =?us-ascii?Q?AJgCeA3y/GntPGWLnqDu482TV3VVvAqX5GbkMCDWvZVO7h7tMoQwch9EcS73?=
 =?us-ascii?Q?6B+8REUdZlMra4K9aMOVD7ww2FjbE/m86AfScx4tMvlyr0bU/jRinwvFQXGi?=
 =?us-ascii?Q?fLsuaW5Tj7o9FIAMhaq7Bxsc0rF0MOax6ZdGCKfkIYT8CxuBa1zBy7NxGl5j?=
 =?us-ascii?Q?cUkX5jSoqhHt9Czjyx61eWI87j41d+AxC1ZeS4auzSovMcyG7RmueROazKDd?=
 =?us-ascii?Q?uHzykMhDBBBwsEWANFUivYHInLuVQbjZ6t2RC+R0FP4CSgqm9BG1FfuzOixO?=
 =?us-ascii?Q?1rts6Y72rS+HhmHCDgNTSQe3vUR4h1cVf7XkMi0K04HFUPwPjqIuIMawyf00?=
 =?us-ascii?Q?J4R7mKrw+Aue2QofJGn8RiXwfBfeLjUaZ0yKo0S7qDhKdrteaFml5U7ZfvDw?=
 =?us-ascii?Q?Pe0h9ibx?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2075884f-b82a-4448-e08a-08d8c38e5a45
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2021 13:12:24.5853
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I+3WG14I+5FX3oNkOIOMTjliwISLP9ohEZdVYTG9H2cR2mJpHYAU/KaxcDSVZ74YmOr0nupnnlOGcjm2RMQ1zw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6436
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 28, 2021 at 01:00:40PM +0100, Rafael J. Wysocki wrote:
> On Thu, Jan 28, 2021 at 12:27 PM Calvin Johnson
> <calvin.johnson@oss.nxp.com> wrote:
> >
> > Hi Rafael,
> >
> > Thanks for the review. I'll work on all the comments.
> >
> > On Fri, Jan 22, 2021 at 08:22:21PM +0100, Rafael J. Wysocki wrote:
> > > On Fri, Jan 22, 2021 at 4:43 PM Calvin Johnson
> > > <calvin.johnson@oss.nxp.com> wrote:
> > > >
> > > > Introduce ACPI mechanism to get PHYs registered on a MDIO bus and
> > > > provide them to be connected to MAC.
> > > >
> > > > Describe properties "phy-handle" and "phy-mode".
> > > >
> > > > Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
> > > > ---
> > > >
> > > > Changes in v4:
> > > > - More cleanup
> > >
> > > This looks much better that the previous versions IMV, some nits below.
> > >
> > > > Changes in v3: None
> > > > Changes in v2:
> > > > - Updated with more description in document
> > > >
> > > >  Documentation/firmware-guide/acpi/dsd/phy.rst | 129 ++++++++++++++++++
> > > >  1 file changed, 129 insertions(+)
> > > >  create mode 100644 Documentation/firmware-guide/acpi/dsd/phy.rst
> > > >
> > > > diff --git a/Documentation/firmware-guide/acpi/dsd/phy.rst b/Documentation/firmware-guide/acpi/dsd/phy.rst
> > > > new file mode 100644
> > > > index 000000000000..76fca994bc99
> > > > --- /dev/null
> > > > +++ b/Documentation/firmware-guide/acpi/dsd/phy.rst
> > > > @@ -0,0 +1,129 @@
> > > > +.. SPDX-License-Identifier: GPL-2.0
> > > > +
> > > > +=========================
> > > > +MDIO bus and PHYs in ACPI
> > > > +=========================
> > > > +
> > > > +The PHYs on an MDIO bus [1] are probed and registered using
> > > > +fwnode_mdiobus_register_phy().
> > >
> > > Empty line here, please.
> > >
> > > > +Later, for connecting these PHYs to MAC, the PHYs registered on the
> > > > +MDIO bus have to be referenced.
> > > > +
> > > > +The UUID given below should be used as mentioned in the "Device Properties
> > > > +UUID For _DSD" [2] document.
> > > > +   - UUID: daffd814-6eba-4d8c-8a91-bc9bbf4aa301
> > >
> > > I would drop the above paragraph.
> > >
> > > > +
> > > > +This document introduces two _DSD properties that are to be used
> > > > +for PHYs on the MDIO bus.[3]
> > >
> > > I'd say "for connecting PHYs on the MDIO bus [3] to the MAC layer."
> > > above and add the following here:
> > >
> > > "These properties are defined in accordance with the "Device
> > > Properties UUID For _DSD" [2] document and the
> > > daffd814-6eba-4d8c-8a91-bc9bbf4aa301 UUID must be used in the Device
> > > Data Descriptors containing them."
> > >
> > > > +
> > > > +phy-handle
> > > > +----------
> > > > +For each MAC node, a device property "phy-handle" is used to reference
> > > > +the PHY that is registered on an MDIO bus. This is mandatory for
> > > > +network interfaces that have PHYs connected to MAC via MDIO bus.
> > > > +
> > > > +During the MDIO bus driver initialization, PHYs on this bus are probed
> > > > +using the _ADR object as shown below and are registered on the MDIO bus.
> > >
> > > Do you want to mention the "reg" property here?  I think it would be
> > > useful to do that.
> >
> > No. I think we should adhere to _ADR in MDIO case. The "reg" property for ACPI
> > may be useful for other use cases that Andy is aware of.
> 
> The code should reflect this, then.  I mean it sounds like you want to
> check the "reg" property only if this is a non-ACPI node.

Right. For MDIO case, that is what is required.
"reg" for DT and "_ADR" for ACPI.

However, Andy pointed out [1] that ACPI nodes can also hold reg property and
therefore, fwnode_get_id() need to be capable to handling that situation as
well.

Andy, any suggestion?

[1] https://lore.kernel.org/netdev/CAHp75Vef7Ln2hwx8BYao3SFxB8U2QTsfxPpxA_jxmujAMFpboA@mail.gmail.com/

Thanks
Calvin
