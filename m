Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24BE81CD693
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 12:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729521AbgEKK3s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 06:29:48 -0400
Received: from mail-eopbgr50084.outbound.protection.outlook.com ([40.107.5.84]:12099
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728613AbgEKK3r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 May 2020 06:29:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=St385KSDRRBh724Buu6zuqmeBPNZmr25G/FuGLLwOtQ561ozKsCs7VTJZl5FOX6lp5BVSPxlLB77vZLQ4cVSYkNc7PBWDICoK+uqDdFXXah9QareaxBEwrVX7dq3zbALC3jNbZWOafsfLrQAYQViQBErdc7PYbnwd2TRlGXRvS2I9cMAdI323MxDt65lyZ7ad/L33oD2KCxlX4/yJQOVqHnSsJLOJXKof6ht94TPaO5FQjD4XJ/JvQtyZ5fvyvEv7bUsTpPiCaBQOoRYKb0rI9B8qcPd0inCctwOoJjsPLDfltQJkq2nTjtCmhoajnC2DT9ZDyZrD6P26np6RKDoTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sIESJWP9sN6pblS+ft2ZZQP9sZXjL2756IqPJXGnV34=;
 b=faD07XzMrxR5WRc5BZ4a5g+C7KhtXEvqfih1iyYXEO6QxH/GeHCJFsYnDyK4m036v3D47w3UkUeuKb6FJTYAEH0EEVK736FBtKQlUEvxF3g5eOjlXetZLmxq7ND3qqmJ+H0l4vh/BbecrxEFcsrvAa+wyovyikAKmLU8v9AICAe4vE6xLTW31jgHv7vfUmC5JmxSHkuptoqkVSvyrjwGUkbvbvjG8MvBzWDemQEVeVWYYmASathcuWSy9CR9Vr2QY/zKDq9IAKMy/b30sR4I3ZOnYTJNq02iBePDxWH6A6AzaJ/BZ5oy/gPANINBC+1BCfm4qQCyOC9miisZm7C3cQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sIESJWP9sN6pblS+ft2ZZQP9sZXjL2756IqPJXGnV34=;
 b=RpriqQqm9CUudC8lNPugC3EipiBF4hJKKI9igQGBBnsZ0CMGZCqy8vAtBRcQ3Py3r1CtuwilearPhlEBycrt1qN9eNjFlSAo/fyHyC9QUiorq1oXazhvNz6+hiH3Hh1fUksAfc1WGf7451q9GZTBLkRGQxVf/xZS3UyYSJ7Ngpg=
Authentication-Results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none
 header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB5106.eurprd04.prod.outlook.com (2603:10a6:208:ca::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26; Mon, 11 May
 2020 10:29:43 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::c4fe:d4a4:f0e1:a75b]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::c4fe:d4a4:f0e1:a75b%4]) with mapi id 15.20.2979.033; Mon, 11 May 2020
 10:29:43 +0000
Date:   Mon, 11 May 2020 15:59:30 +0530
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>, linux.cj@gmail.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Varun Sethi <V.Sethi@nxp.com>,
        "Rajesh V . Bikkina" <rajesh.bikkina@nxp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        netdev <netdev@vger.kernel.org>, Marcin Wojtas <mw@semihalf.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Makarand Pawagi <makarand.pawagi@nxp.com>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        Pankaj Bansal <pankaj.bansal@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [net-next PATCH v3 4/5] net: phy: Introduce fwnode_get_phy_id()
Message-ID: <20200511102930.GA24687@lsv03152.swis.in-blr01.nxp.com>
References: <CAHp75Vew8Fh6HEoOACk+J9KCpw+AE2t2+oFnXteK1eShopfYAA@mail.gmail.com>
 <83ab4ca4-9c34-4cdd-4413-3b4cdf96727d@arm.com>
 <20200508160755.GB10296@lsv03152.swis.in-blr01.nxp.com>
 <20200508181301.GF298574@lunn.ch>
 <1e33605e-42fd-baf8-7584-e8fcd5ca6fd3@arm.com>
 <20200508202722.GI298574@lunn.ch>
 <97a9e145-bbaa-efb8-6215-dc3109ee7290@arm.com>
 <20200508234257.GA338317@lunn.ch>
 <20200511080040.GC12725@lsv03152.swis.in-blr01.nxp.com>
 <20200511093849.GO1551@shell.armlinux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200511093849.GO1551@shell.armlinux.org.uk>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: SG2PR01CA0126.apcprd01.prod.exchangelabs.com
 (2603:1096:4:40::30) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR01CA0126.apcprd01.prod.exchangelabs.com (2603:1096:4:40::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.27 via Frontend Transport; Mon, 11 May 2020 10:29:37 +0000
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f9102ab9-d3c4-48fa-8e23-08d7f59637e1
X-MS-TrafficTypeDiagnostic: AM0PR04MB5106:|AM0PR04MB5106:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB5106B0EF926DDE946A7BE938D2A10@AM0PR04MB5106.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 04004D94E2
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mE1NnbKk4PpJ7rbbQJfqMDaILHX9YFwc/yxgu5ktw2dUpprvPDOu/P+EVO9kTMOqCDMQWjzDK1wQ5t2KoCCj8UxWdVJh93zvkBHF275GElL4396Kdr7Bphx49E1R5iJNG4P9RIFOYofiSQpTB27uAGmSFU3O5J7bk8h6EJz0Tq5k5bYTRW0fPVNeTmN992dEfrKpaWG3e6UAN8CxBm9iTx96qJtt3WQqWxGeJ86VWMHeEh58YvLKWxWmUm61aCLz3mXcbUKcqUlTqfXzR3E1aRwARaplGb6Q0Gc5phMu82po7A+1Aj6rpHKFH5tAeJdPoALFGqZ777dFcnsFgkXB+ThOl/5uPJ2V1HBJ81/cZFl7cb32h8QWR4TLMYOzyNvYuXJMQbCVb/ejSzj6sPUl9UayiuxViXJAHl4MUPUZhPQC2Z/NCJAm3rFikAk3KCrqpKVnvnIdyZPk2rrleX2LRSjI1Ull3juWwbN1LYI7iiP6alJ4bAufhJuPuKicIvtGEgDL30JSC8f6iqJWG44ctio+5NcvdI/u7fMiNx0eldjI5ruDkEHwT1VC22WaAEXZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(376002)(136003)(346002)(39860400002)(396003)(33430700001)(6916009)(2906002)(478600001)(66476007)(8676002)(33440700001)(66946007)(44832011)(7416002)(86362001)(66556008)(1006002)(6666004)(6506007)(54906003)(5660300002)(16526019)(55236004)(316002)(53546011)(186003)(26005)(8936002)(33656002)(4326008)(7696005)(956004)(52116002)(9686003)(1076003)(55016002)(110426005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: tA6OnSoTpT2ymZIZdWE7J8DVTuQskNfTak72x3xpetFUWUxgxtyyLNOTrUnB41GbcRWXA0TX/NNWDzELEim4pbE9KA9w/7113oUalVWVFMfL5nXAYILu1/IavWH3p9PSV4FFQxg3XlWeItz7B3M2fEtiHQletxtpfPr2l8jgFxjHeKUUVS4vB/BggCpoVzVBOt9FWH8VhGE0d7snFcG+CNXxzAglKj9fGeFd5HliyW4ua2N+AuF3OLmj6p3PePVDOjve+O0tzZOTRenAE3j/ofNMfRRN+VpQcu5l6SpvjYAzyUdHji0Qlt6ileD/ADfHqg71xDrn42TXrh+EPJ9CisGxiOUfau+vqGDyyvQ4/+vm0dKyqQBtc1nQlzorvihAsjAUyMWjpu/iSYyTGO8nosFO2av3z4TIVjA6DiVp3Hu97KkhHy09g6JzumC5m86qqFR5+Xb2d59vZkhYRn99+olJBLj6cTekTk4YZJ5VZSo=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9102ab9-d3c4-48fa-8e23-08d7f59637e1
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2020 10:29:43.1460
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dQH7T8twCaqPKiECZPg0d1eP0r9NldeQM+Vf9LBtDC+Xc7DgGFUxUUy4ppSunXBlSUBrm/D0eNPGWnAzS+pMpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5106
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 11, 2020 at 10:38:49AM +0100, Russell King - ARM Linux admin wrote:
> On Mon, May 11, 2020 at 01:30:40PM +0530, Calvin Johnson wrote:
> > On Sat, May 09, 2020 at 01:42:57AM +0200, Andrew Lunn wrote:
> > > On Fri, May 08, 2020 at 05:48:33PM -0500, Jeremy Linton wrote:
> > > > Hi,
> > > > 
> > > > On 5/8/20 3:27 PM, Andrew Lunn wrote:
> > > > > > > There is a very small number of devices where the vendor messed up,
> > > > > > > and did not put valid contents in the ID registers. In such cases, we
> > > > > > > can read the IDs from device tree. These are then used in exactly the
> > > > > > > same way as if they were read from the device.
> > > > > > > 
> > > > > > 
> > > > > > Is that the case here?
> > > > > 
> > > > > Sorry, I don't understand the question?
> > > > 
> > > > I was asking in general, does this machine report the ID's correctly.
> > > 
> > > Very likely, it does.
> > > 
> > > > The embedded single mac:mdio per nic case seems like the normal case, and
> > > > most of the existing ACPI described devices are setup that way.
> > > 
> > > Somebody in this thread pointed to ACPI patches for the
> > > MACCHIATOBin. If i remember the hardware correctly, it has 4 Ethernet
> > > interfaces, and two MDIO bus masters. One of the bus masters can only
> > > do C22 and the other can only do C45. It is expected that the busses
> > > are shared, not a nice one to one mapping.
> > > 
> > > > But at the same time, that shifts the c22/45 question to the nic
> > > > driver, where use of a DSD property before instantiating/probing
> > > > MDIO isn't really a problem if needed.
> > > 
> > > This in fact does not help you. The MAC driver has no idea what PHY is
> > > connected to it. The MAC does not know if it is C22 or C45. It uses
> > > the phylib abstraction which hides all this. Even if you assume 1:1,
> > > use phy_find_first(), it will not find a C45 PHY because without
> > > knowing there is a C45 PHY, we don't scan for it. And we should expect
> > > C45 PHYs to become more popular in the next few years.
> > 
> > Agree.
> > 
> > NXP's LX2160ARDB platform currently has the following MDIO-PHY connection.
> > 
> > MDIO-1 ==> one 40G PHY, two 1G PHYs(C45), two 10G PHYs(C22)
> 
> I'm not entirely sure you have that correct.  The Clause 45 register set
> as defined by IEEE 802.3 does not define registers for 1G negotiation,
> unless the PHY either supports Clause 22 accesses, or implements some
> kind of vendor extension.  For a 1G PHY, this would be wasteful, and
> likely incompatible with a lot of hardware/software.
> 
> Conversely, Clause 22 does not define registers for 10G speeds, except
> accessing Clause 45 registers indirectly through clause 22 registers,
> which would also be wasteful.
> 
Got your point.
Let me try to clarify.

MDIO-1 ==> one 40G PHY, two 1G PHYs(C45), two 10G PHYs(C22)
MDIO-2 ==> one 25G PHY
This is the physical connection of MDIO & PHYs on the platform.

For the c45 PHYs(two 10G), we use compatible "ethernet-phy-ieee802.3-c45"(not
yet upstreamed).
For c22 PHYs(two 1G), we don't mention the c45 compatible string and hence the
access also will be using c22, if I'm not wrong.

Regards
Calvin
k
