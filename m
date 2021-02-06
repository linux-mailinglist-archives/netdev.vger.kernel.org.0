Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6298311F14
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 18:16:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbhBFRQG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 12:16:06 -0500
Received: from mail-eopbgr60088.outbound.protection.outlook.com ([40.107.6.88]:39494
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229506AbhBFRQD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Feb 2021 12:16:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YhHrnfa7xENeym8Xa81lRA0fwWFVNITVMn7xaW7QHELlE0PqgwHzKvefr7z9u8OJhGjI1QX6Xb/SL6zvLLhPNOizFTgS+JhovD9pMcB3AiciwF4ADRDAX1+YcaipWXaONJMKVrcto0bqcAS1hAPZHExHJcpA6/+5yycgXLmILmXMbV+r97MwvuqMl/mw4oZOhZZ+etnKW0TKADm7zcwyHJ7QsP4rmlv5+eV2dhEwRZ6O2CmqQL+Q8q95OUQwN4lBb6yyPqFUcPMnXJrn49D50L9tfKidz1nHr8Rntgog+GhY8Tc4DCMulfVUrdBkdRDZ9NmtF+I1C1Elm+c8WIH5qA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kPlT7soqoN4nAImNEpec1VfzwHurAkc6rhE2oGSjYmo=;
 b=eY5uWqwj0itg8b69bD/HKeKbnNXgN6uCzJR255iuqWutrpkLVZnmDduWDfpXJjYsBj3qKhrFG/4S2UiqCKsCuxlm1tfnIoqU5i9pWbSaA5nOS54KYdz+t/43KgwpC3G+a5Q3wpgzdSvIgvsvi03u7sv8FwrZU+n3/2+8gMPi8XXRmJk39ILFACFeu+cS+vY3I6auLx3RvCk8L8cTp0AYGP9+oppjVJ3MgsXgsUNarKs//Sakrjf6dIz/oUh5ikY0osYgEzhpd3Hqi0Ligj+PxDolDLjLg3C28qdbUcNviF6tUo8ejJ9c0ACR3LEX2ui6cwl+oBGpBfMXXEdqZkQ5Lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kPlT7soqoN4nAImNEpec1VfzwHurAkc6rhE2oGSjYmo=;
 b=IZLshWTyd87/ffXEd+BSYGxyyTO2yWXxIs43LtFfML63tA+6l6NQ/roSFV4mXX18hlTABy2/+wopX8XX8qJ5d3CiUr3y3sulyfZVhV93UYaGNDcZknZ+c6aKG03DrJmKFfkzFbpOiD3QeBet659MCk2t/p2gXwFxT+6CwLan99Q=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB6899.eurprd04.prod.outlook.com (2603:10a6:208:183::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.20; Sat, 6 Feb
 2021 17:15:14 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42%6]) with mapi id 15.20.3825.028; Sat, 6 Feb 2021
 17:15:14 +0000
Date:   Sat, 6 Feb 2021 22:44:35 +0530
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
        "linux.cj" <linux.cj@gmail.com>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Frank Rowand <frowand.list@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        devicetree <devicetree@vger.kernel.org>
Subject: Re: [net-next PATCH v4 07/15] net: mdiobus: Introduce
 fwnode_mdiobus_register_phy()
Message-ID: <20210206171435.GA25451@lsv03152.swis.in-blr01.nxp.com>
References: <20210122154300.7628-1-calvin.johnson@oss.nxp.com>
 <20210122154300.7628-8-calvin.johnson@oss.nxp.com>
 <20210205172518.GA18214@lsv03152.swis.in-blr01.nxp.com>
 <CAHp75VdX2gZbt-eYp31wg0r+yih8omGxcTf6cMyhxjMZZYzFuQ@mail.gmail.com>
 <CAHp75VdEjNhj5oQTqnnOhnibBAa2CoHf1PAvJi57X0d-6LC3NQ@mail.gmail.com>
 <CAHp75VcVPfgA-WS+gAH6ugrzaU9_nhRcg0pC07x7XcBha55bPg@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75VcVPfgA-WS+gAH6ugrzaU9_nhRcg0pC07x7XcBha55bPg@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR01CA0110.apcprd01.prod.exchangelabs.com
 (2603:1096:4:40::14) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR01CA0110.apcprd01.prod.exchangelabs.com (2603:1096:4:40::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17 via Frontend Transport; Sat, 6 Feb 2021 17:15:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 49c4db1a-3056-41f9-9bdd-08d8cac2c3cb
X-MS-TrafficTypeDiagnostic: AM0PR04MB6899:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB689930A1553AC042C1342542D2B19@AM0PR04MB6899.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aas+jgtl+d77N4daY19u+JJvb5i0d2lGOgFuKx8SgT0gh7oP3BvR7rJSkw3uiXy4jTFO8iuWHYsE3pSAGMvRbP3F8LJSaIFSqIaFXELyO4eNl9/gCmqU4dXcjrr0pKZT7p/mahQMdEkBN/XSnY2QrhKRDpacqUuVHhVeMY1ftsQ51U/9RiUbkOeY6gk7jxFssTkjBmpzl4FtnXyr+4iv66UKTz7ZT+rcJ60GRdOJElUnR5slDaR9DRAMI7xGAJIGk7UsiHgNZYsJKPuRNhPtrZeT/k9rMvsKcC8rKR2Vrliw99k9avCir5YvTlRAkyCguT2Jjr8Dfeh3RYKgwa54UJl2eIt5gkMLmc40u0zwt9KDm6AETuNWGbKNyIUCsljOM19fdsZIhha9coAt9nQT4qwMtovrgFAxTKALl+CuvG+yt3vBg4LKLvjMQmDQDJp+nsHUDvu7ACEE778bc7xd3NYaP8E96x6lxqluGJ7lDIDRTdQ7KezAgr8sZ0a1ERXmj4tLliKMNdCkFn+zTmmB//YPxoTJxZ6I45lYe2XOUWTLZP2FnHQMxH2QgCQw6y1gM86N0VaeSwftqVFZnQwOsQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39850400004)(396003)(346002)(136003)(366004)(1006002)(6916009)(83380400001)(1076003)(66556008)(316002)(478600001)(44832011)(5660300002)(54906003)(6666004)(956004)(8936002)(2906002)(66946007)(66476007)(33656002)(16526019)(4326008)(55016002)(52116002)(9686003)(186003)(26005)(86362001)(6506007)(55236004)(53546011)(7416002)(8676002)(7696005)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?R93C3xXcHjARSm7cUPz4ua0wl0jm2FjGfN7U6+Sc9Ig406fx4DsLHMWY7nIX?=
 =?us-ascii?Q?kCwcnxYPxj6TWliiaZCTHH4LYQxOA8cwO5u23v/cWfTt4W5Uc4KHTc7Ghh4s?=
 =?us-ascii?Q?g4zqc9a59ZiLWr7bMk19v1ysSIw6+2f9qnTHv5b7l7JEuxfnHf9NPJOWAois?=
 =?us-ascii?Q?BU5tYggLV8htkzfUD3UVcqfN4J6d7nGjoO0qhVi5NRchdrzSQa7YYJGqucK3?=
 =?us-ascii?Q?3DuL4eeQCsjDnh7WhpGEJ+y4xSrRHzNbioOGp5iFyM9zQeNLEuhI+i0uNLX/?=
 =?us-ascii?Q?cuDyue3x1rde/QNxITeKiqj07RR8oylO86xPkkM/EnBzTYqWJtWQ4lsjpgWz?=
 =?us-ascii?Q?0YQhj5S9zHiNVmc7uXLf8gvj/QdQX+XvPNBFL1Z5Z4EX8uDUdhCzy8P/8//R?=
 =?us-ascii?Q?R+vdMyNHRkTP65gOphL3coO5iynbbRoxkwKRtbs9NSoRl9yxnCF8dk2lKAM2?=
 =?us-ascii?Q?g7o/azAZu0v++ZjdWHP8Q2MYm+M0G8D5As6RD9eNEwZQs5jzYV7PGu4sALVd?=
 =?us-ascii?Q?U3XEwl45YtB/XY5Hfv2UoqK2da1QKKSrZHTihpKIz1V8xbaQT2RA1dVkO1GK?=
 =?us-ascii?Q?X95d2RjsXWTRzH8PZnERwMFMAViTgOpNw/+JubBkqnrlopVcVzPpFJKNyH2k?=
 =?us-ascii?Q?R1aJ4DO2mkzOihto4dmz8V6+VfiFe0+9G1uHRdRx3LUFklEDWzIEqq7EmKFY?=
 =?us-ascii?Q?IdPxV1lPn0ITvbJa/bqnTeKzmjthIMPfbQue8jA80usmdVnW4D6wvV2Rsf+r?=
 =?us-ascii?Q?RD/jMA7gc36LrAvtqdLVWK61k4e99/6+2SUI9pFxWW4SVgy+dkdruI8Ldjmy?=
 =?us-ascii?Q?OM3fBb03NPIsIEbz6vMUDgysVBvLLMxclvah4jxLN6Jo66pOAyDhCgsts0od?=
 =?us-ascii?Q?TDpEG/jIm0apKQhI/hKgHkQWIQ0hzJZY97i2g5aWUG+jTq1LevYLYmzCrd4N?=
 =?us-ascii?Q?/9ZKCil81tKsOhwDYYSO4PlAXMS2jkQr3+7MapeXO3pJcDLZ8a7k4XzE2Bum?=
 =?us-ascii?Q?MGaaEB4ppzNJIVs+SRMskJGUnvkx0y87VGXungCWxSMrj5dUVYdDu28IYYHi?=
 =?us-ascii?Q?SQO+yHjosqrRSUIYq6YpkKS2ELUrmSddYTISGfsdig/wWSaAaP1mt9asAEPe?=
 =?us-ascii?Q?RJYaGLDXH53pX/CcRh2viILwGME3ZI9VNCEcQ4UeRGBt8dXbwL6JArvZr67O?=
 =?us-ascii?Q?M5VStAJXMck+wtrky8ZMKYYV9EHrB+aanLO8nk3bL0FEeNaYU8Q2uAdqZQ79?=
 =?us-ascii?Q?L/uhJ69PoYiAgglQeLX9HiVsL8jc3r6wG49pCAsrw8hUl1XR8nBiPgqJR4qo?=
 =?us-ascii?Q?dQhMrih+7JU7GmOtH6KvyRYTfMPDeeiQZ+xpC4g1vE4PIw=3D=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49c4db1a-3056-41f9-9bdd-08d8cac2c3cb
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2021 17:15:14.1475
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wNYUVl9Ho9OIuPj/wsS8NOZf1qn5pa/l3bsxeqUaSBjbib6hzUq82JofzNzcwf++7r2UvHBMU1WFX/LXZZqDYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6899
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 05, 2021 at 08:58:06PM +0200, Andy Shevchenko wrote:
> On Fri, Feb 5, 2021 at 8:41 PM Andy Shevchenko
> <andy.shevchenko@gmail.com> wrote:
> > On Fri, Feb 5, 2021 at 8:25 PM Andy Shevchenko
> > <andy.shevchenko@gmail.com> wrote:
> > > On Fri, Feb 5, 2021 at 7:25 PM Calvin Johnson
> > > <calvin.johnson@oss.nxp.com> wrote:
> > > > On Fri, Jan 22, 2021 at 09:12:52PM +0530, Calvin Johnson wrote:
> > >
> > > ...
> > >
> > > > > +     rc = fwnode_property_match_string(child, "compatible", "ethernet-phy-ieee802.3-c45");
> > > > With ACPI, I'm facing some problem with fwnode_property_match_string(). It is
> > > > unable to detect the compatible string and returns -EPROTO.
> > > >
> > > > ACPI node for PHY4 is as below:
> > > >
> > > >  Device(PHY4) {
> > > >     Name (_ADR, 0x4)
> > > >     Name(_CRS, ResourceTemplate() {
> > > >     Interrupt(ResourceConsumer, Level, ActiveHigh, Shared)
> > > >     {
> > > >       AQR_PHY4_IT
> > > >     }
> > > >     }) // end of _CRS for PHY4
> > > >     Name (_DSD, Package () {
> > > >       ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
> > > >         Package () {
> >
> > > >           Package () {"compatible", "ethernet-phy-ieee802.3-c45"}
> >
> > I guess converting this to
> >            Package () {"compatible", Package() {"ethernet-phy-ieee802.3-c45"}}
> > will solve it.

Thanks a lot Andy! This helped. But is this the correct way to define compatible
string value, i.e as a sub package. 
> 
> For the record, it doesn't mean there is no bug in the code. DT treats
> a single string as an array, but ACPI doesn't.
> And this is specific to _match_string() because it has two passes. And
> the first one fails.
> While reading a single string as an array of 1 element will work I believe.
> 
> > > >        }
> >
> > > >     })
> > > >   } // end of PHY4
> > > >
> > > >  What is see is that in acpi_data_get_property(),
> > > > propvalue->type = 0x2(ACPI_TYPE_STRING) and type = 0x4(ACPI_TYPE_PACKAGE).
> > > >
> > > > Any help please?
> > > >
> > > > fwnode_property_match_string() works fine for DT.
> > >
> > > Can you show the DT node which works and also input for the
> > > )match_string() (i.o.w what exactly you are trying to match with)?
> 
> 
> -- 
> With Best Regards,
> Andy Shevchenko
