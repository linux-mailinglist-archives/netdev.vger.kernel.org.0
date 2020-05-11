Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DAB21CD93E
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 14:03:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729674AbgEKMC6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 08:02:58 -0400
Received: from mail-eopbgr80057.outbound.protection.outlook.com ([40.107.8.57]:44041
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727019AbgEKMC6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 May 2020 08:02:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jpmEiFENieCRhmYD5j9mUVp6VjDUbpWU38F5qy1SG6xEE/F+5S3K5+OV3fQk7NnOrHEoguR9tlGcmmM3GfYqhGt5PMYFjNMf7Zfk5+ju1QC4ZUf2nGJNuI1D+FpMgkAZJ8SWmujx3yzDCzm3N4b7Tg140N2/90K8ktdZNwbZg+FSf7wahnEkpf993I4NDrUK6qR0ZbUmseuX3DmasErpI1ILsSfoEV2gCzuOxAxmgQXj6L9uw8HIJ15FYng3tbxeS2iTRFeSaaDmlXlcwp7/xRPMW6wIbqLBvaWwHAIgxhQ0MH5gEVukmbeqtMWuVGK0KtomN2iahxvbg1hISWxTrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZXMdiPKDxnFCzIenhg4GhDRc9p07Y0/snfjZ2uTNtkM=;
 b=k2v2HndHLunIrezjDph7L/CW1AGDm6PV61Fd1IZEyxwAECZskRa6tAstexECJaP0Y4vjPQ7UQguvf6aSmJ+BRU43W0jbkjvmigWZyICvxEZqOTNhW5JbXSEpjJxMFbbL6078vztzgu9AQgyuZTL1Ex35ZjFxG36dVcqbuReDS2jbJDfMo2Nl60DdPrnWPth4LVjdjd1n3z6avWJ++GwNcFD1tjx44EJ26aepcpnLBjzcjHiPTtGmVjjdldpkYzthqOMj2I2V3KoB43QGn2gScVBf4hJtZv3DzE6jwG8bkqVFDLOYtNpFV1a6xMLhAI1o9MLofBIrzVLqCcnHK0kQXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZXMdiPKDxnFCzIenhg4GhDRc9p07Y0/snfjZ2uTNtkM=;
 b=cA7bnpKm5aLo8lTqd7R0066h0JgMx+b30unfXNJvu70IsMD/fK4QU7qh1wGXvc18JOaEJGyr52q1K42vDNdixfYC2slLhiUcepTIqVdMxlhGPErIIWD2SBf3qRftJRmDwmzTAYxuTLRevsOpzLWYRjmGlaIMbObI8QqzAO3+AyU=
Authentication-Results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none
 header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB6194.eurprd04.prod.outlook.com (2603:10a6:208:13a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.33; Mon, 11 May
 2020 12:02:52 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::c4fe:d4a4:f0e1:a75b]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::c4fe:d4a4:f0e1:a75b%4]) with mapi id 15.20.2979.033; Mon, 11 May 2020
 12:02:52 +0000
Date:   Mon, 11 May 2020 17:32:39 +0530
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
Message-ID: <20200511120239.GB24687@lsv03152.swis.in-blr01.nxp.com>
References: <20200508160755.GB10296@lsv03152.swis.in-blr01.nxp.com>
 <20200508181301.GF298574@lunn.ch>
 <1e33605e-42fd-baf8-7584-e8fcd5ca6fd3@arm.com>
 <20200508202722.GI298574@lunn.ch>
 <97a9e145-bbaa-efb8-6215-dc3109ee7290@arm.com>
 <20200508234257.GA338317@lunn.ch>
 <20200511080040.GC12725@lsv03152.swis.in-blr01.nxp.com>
 <20200511093849.GO1551@shell.armlinux.org.uk>
 <20200511102930.GA24687@lsv03152.swis.in-blr01.nxp.com>
 <20200511104817.GP1551@shell.armlinux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200511104817.GP1551@shell.armlinux.org.uk>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: SG2PR06CA0115.apcprd06.prod.outlook.com
 (2603:1096:1:1d::17) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR06CA0115.apcprd06.prod.outlook.com (2603:1096:1:1d::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26 via Frontend Transport; Mon, 11 May 2020 12:02:45 +0000
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ddaf083b-1be5-4151-1a8e-08d7f5a33b0b
X-MS-TrafficTypeDiagnostic: AM0PR04MB6194:|AM0PR04MB6194:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB6194218C93CDC8AB2D0163AAD2A10@AM0PR04MB6194.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 04004D94E2
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zKCHo8Ml56hRVg1N/bNVDuLiRUgNZAs7Ok54EB0SzDIr+yTh5/1VsiewDBcIYHa3Y9mf5aKJkuJSiAcI9zx/MHlB0Wgkq4DpfF78sTReDEbZADKw5Kz4+9dPy7hNaYkJS+Jtdn82ZeB7NmjK+bazy2d+RkTEJ/bJ28VXT/o4gA3cslEPH8gbZhQyCE2gkZZg3TbDOXrvKqSW72uA4rioFvDYD7WqIRB80p6pw0TjKcZKOR8unAp1pw32NglQmXGXIc8uQ2fDmprX++GEOHGqSu+knRrNpbhxJiZb+1s7z5gl/hhF23vNduzk8U66JWR9xac2zDGgXM7EMRCBz6QBGR3Cre+SCGUfOoeLDerrjKGYhwVqDf9Y6TpJu5hzWbW+6olUKUbBkwtKm2KG1eQp/FK3YQWBVtzEfyB3BWrtkYPfMFlazAyBOQ7DIZfKhtgkU/rCuRXAEZfXR2NDDl7WqJOoBqAMZbXjufXJEIP/iPPhA3FICPKoHHBY5MCfD05UqnQ4K63g+b3R/+w3H6/4L2G/Nl/1EenB7yVMqP0SJz2HgvEWB4SiUQTsBy1bZm/uwoFeeOLUZPS5feah4C1cLQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(346002)(136003)(376002)(396003)(39860400002)(33430700001)(66476007)(66946007)(66556008)(86362001)(55016002)(9686003)(44832011)(33656002)(54906003)(7696005)(6506007)(186003)(16526019)(53546011)(956004)(26005)(55236004)(4326008)(52116002)(5660300002)(478600001)(1076003)(8676002)(6916009)(2906002)(316002)(7416002)(33440700001)(8936002)(6666004)(1006002)(110426005)(341764005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: v97epENEW0LJO6OhYB9HicAT4SiHj5znO7iKeT2RSY+5OzVttY11tN/xVHw1plPzx5IzQUysLLWx8aaORGDyT2EG1itC576avg93L1CuhJbJfpqgG0s0o8xZfLkTz+l650Rdmk7YYInYNBP4jPupj/ynTT/486Is3+/RiGrhDHmZUt1kB4rlg63WsEdtrAuf8Q7BOtgF0vswetnwCNd+3PL0a6K+wj6TaNJDFGWqhTsogWqVrK7tTUwTcOw2jj7flQcNSCjccvJuXwTT4cK1adU7oyUCrWP2uJ8TCTGbHOp3VZaMYtNRfrAJkiKf6/rPv8V+NVQrQfzIGw0S8yAwyKcMXAUgbvH/+9UPIpbfuyOfmksLUPR0Lk1+onUvt/l55sBLXEzcCOOVFUjGbPNuUBvlOd4Z7MH4ltiQN+oLVAwoa+Wv+OZnL9v9ud4ZeZoRzaCMlILvStb+gUrUYBJmF17UrmoyJtOVybeJAh5VZdE=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ddaf083b-1be5-4151-1a8e-08d7f5a33b0b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2020 12:02:51.8940
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MsojDizzzx2ZZuX/Tu0n9MwKvo5flkSki0jKggOeruFQRO1ebn2eOBuZhfZdtLje93ZDE84QcFHrs0vlwtUUYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6194
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 11, 2020 at 11:48:17AM +0100, Russell King - ARM Linux admin wrote:
> On Mon, May 11, 2020 at 03:59:30PM +0530, Calvin Johnson wrote:
> > On Mon, May 11, 2020 at 10:38:49AM +0100, Russell King - ARM Linux admin wrote:
> > > On Mon, May 11, 2020 at 01:30:40PM +0530, Calvin Johnson wrote:
> > > > On Sat, May 09, 2020 at 01:42:57AM +0200, Andrew Lunn wrote:
> > > > > On Fri, May 08, 2020 at 05:48:33PM -0500, Jeremy Linton wrote:
> > > > > > Hi,
> > > > > > 
> > > > > > On 5/8/20 3:27 PM, Andrew Lunn wrote:
> > > > > > > > > There is a very small number of devices where the vendor messed up,
> > > > > > > > > and did not put valid contents in the ID registers. In such cases, we
> > > > > > > > > can read the IDs from device tree. These are then used in exactly the
> > > > > > > > > same way as if they were read from the device.
> > > > > > > > > 
> > > > > > > > 
> > > > > > > > Is that the case here?
> > > > > > > 
> > > > > > > Sorry, I don't understand the question?
> > > > > > 
> > > > > > I was asking in general, does this machine report the ID's correctly.
> > > > > 
> > > > > Very likely, it does.
> > > > > 
> > > > > > The embedded single mac:mdio per nic case seems like the normal case, and
> > > > > > most of the existing ACPI described devices are setup that way.
> > > > > 
> > > > > Somebody in this thread pointed to ACPI patches for the
> > > > > MACCHIATOBin. If i remember the hardware correctly, it has 4 Ethernet
> > > > > interfaces, and two MDIO bus masters. One of the bus masters can only
> > > > > do C22 and the other can only do C45. It is expected that the busses
> > > > > are shared, not a nice one to one mapping.
> > > > > 
> > > > > > But at the same time, that shifts the c22/45 question to the nic
> > > > > > driver, where use of a DSD property before instantiating/probing
> > > > > > MDIO isn't really a problem if needed.
> > > > > 
> > > > > This in fact does not help you. The MAC driver has no idea what PHY is
> > > > > connected to it. The MAC does not know if it is C22 or C45. It uses
> > > > > the phylib abstraction which hides all this. Even if you assume 1:1,
> > > > > use phy_find_first(), it will not find a C45 PHY because without
> > > > > knowing there is a C45 PHY, we don't scan for it. And we should expect
> > > > > C45 PHYs to become more popular in the next few years.
> > > > 
> > > > Agree.
> > > > 
> > > > NXP's LX2160ARDB platform currently has the following MDIO-PHY connection.
> > > > 
> > > > MDIO-1 ==> one 40G PHY, two 1G PHYs(C45), two 10G PHYs(C22)
> > > 
> > > I'm not entirely sure you have that correct.  The Clause 45 register set
> > > as defined by IEEE 802.3 does not define registers for 1G negotiation,
> > > unless the PHY either supports Clause 22 accesses, or implements some
> > > kind of vendor extension.  For a 1G PHY, this would be wasteful, and
> > > likely incompatible with a lot of hardware/software.
> > > 
> > > Conversely, Clause 22 does not define registers for 10G speeds, except
> > > accessing Clause 45 registers indirectly through clause 22 registers,
> > > which would also be wasteful.
> > > 
> > Got your point.
> > Let me try to clarify.
> > 
> > MDIO-1 ==> one 40G PHY, two 1G PHYs(C45), two 10G PHYs(C22)
> > MDIO-2 ==> one 25G PHY
> > This is the physical connection of MDIO & PHYs on the platform.
> > 
> > For the c45 PHYs(two 10G), we use compatible "ethernet-phy-ieee802.3-c45"(not
> > yet upstreamed).
> > For c22 PHYs(two 1G), we don't mention the c45 compatible string and hence the
> > access also will be using c22, if I'm not wrong.
> 
> You seem to have just repeated the same mistake (it seems to be a direct
> copy-n-paste of what you sent in the email I replied to) - and then gone
> on to say something different.  Either you're confused or you're not
> writing in your email what you intend to.
> 
> You first say "MDIO-1 ==> two 1G PHYs(C45)".  You then say lower down
> "For C22 PHYs (two 1G)".  Both these statements can't be true.
> 
> Similarly, you first say "MDIO-1 ==> two 10G PHYs(C22)".  You then say
> lower down "For the c45 PHYs(two 10G)".  Again, both these statements
> can't be true.
> 
> Given that this discussion in this thread has been about C22 vs C45, I
> would have thought accuracy in regard to this point would have been of
> the up-most importance.
> 
It was my mistake. Sorry about that. 1G PHYs are C22 and 10G PHYs are C45.
I didn't notice the mistake, hence copied.
Correcting:
MDIO-1 ==> one 40G PHY, two 1G PHYs(C22), two 10G PHYs(C45)

Thanks
Calvin
