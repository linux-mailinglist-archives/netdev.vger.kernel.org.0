Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 666C8231C37
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 11:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726353AbgG2Jjg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 05:39:36 -0400
Received: from mail-db8eur05on2077.outbound.protection.outlook.com ([40.107.20.77]:47713
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725851AbgG2Jjg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jul 2020 05:39:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZCqdvKt7Lyi556dp8bz+GNJyWcOtxDB7zrfeMcMTHRaXY5TG92POxeVDtV9jdRLMtH/5OH+yt3znYjAJIdV+HcrUbU0uBrd033mxC2r/c/U+h7uKfbifvqiYuCBx75Qd69dUT0kYvHlmsn+tZvaSg5epbX2Oe5uDgcVSCpbFehV3MGtFHfgVnP48tG6ZSBbMyyOZZ1hN70bZHzEeEpgY72pgiOIICLLdjBb1Ds5TNQXFpVfKGy5/G9aKEEf+AuCTcgu9b7LsjzLHb/dZyTmUSWriw9Dc4nCKVUm94is5126mtSA28mCV/U00Gl99SbkA0n9kJDtMuscTu5z/jieUEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vcoVr3ce6IsnJX0tQmBzIGuFEGBCrE+fRGdWqLGcAOI=;
 b=EPBzX/jO8kNRswZ2g0BieMeCvGxk7a7h/EpzhNABq1Bu3jObAgTC1c6z3Prrs4AD8UUl4mp7cZOX1PjsURC/n3KSluk8EdOQuTEWc+vPQQhUe+geIS9FkpStVGyOA9xvxFg1rjL8E1Le+qsW/kAh5URLVHXd1dImFhpI3WZ6Y9tfFWglNjU/i1pLXWfyBn+u0+qXsvULzPdXmXcu8qqjZEcXwQOw0UC/061pLwsr3m6x3QIKOMfpoMHrdp45gcD7ZTK/+QrkSAF1SPzyYuNR6kTLB7QHz/rBAthIoBdeQDZ3P++z3IEXzmY3ah6l8YN52Fxag+lW5cbKHlgfwPuGqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vcoVr3ce6IsnJX0tQmBzIGuFEGBCrE+fRGdWqLGcAOI=;
 b=Mma5/gaVXw8PBshKT+FZSA4dtT9jnyUXNUzkro8HJqLaTCI3Y9yc+2c2B3G3nJaBmZA+7ig0fatSqYR0ZH0OEKzF2QKDUqeZgwV2owMW93EejSCo8PmdOuv5VIkuopOQPco+ALe1QSJOD1hpY3u7KXmksay/J4lJCoKeB6Sue1o=
Authentication-Results: solid-run.com; dkim=none (message not signed)
 header.d=none;solid-run.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB6209.eurprd04.prod.outlook.com (2603:10a6:208:13a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.16; Wed, 29 Jul
 2020 09:39:31 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::b1ae:d2cd:6170:bf76]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::b1ae:d2cd:6170:bf76%7]) with mapi id 15.20.3216.033; Wed, 29 Jul 2020
 09:39:31 +0000
Date:   Wed, 29 Jul 2020 15:09:17 +0530
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     Jon Nettleton <jon@solid-run.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Hanjun Guo <guohanjun@huawei.com>,
        Sudeep Holla <sudeep.holla@arm.com>, Al Stone <ahs3@redhat.com>
Cc:     Jeremy Linton <jeremy.linton@arm.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Dan Callaghan <dan.callaghan@opengear.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        netdev <netdev@vger.kernel.org>, "linux.cj" <linux.cj@gmail.com>,
        linux-acpi <linux-acpi@vger.kernel.org>,
        Paul Yang <Paul.Yang@arm.com>,
        Samer El-Haj-Mahmoud <Samer.El-Haj-Mahmoud@arm.com>,
        Augustine Philips <Augustine.Philips@arm.com>,
        Varun Sethi <V.Sethi@nxp.com>,
        "Rajesh V. Bikkina" <rajesh.bikkina@nxp.com>,
        Bogdan Florin Vlad <bogdan.vlad@nxp.com>
Subject: Re: [net-next PATCH v7 1/6] Documentation: ACPI: DSD: Document MDIO
 PHY
Message-ID: <20200729093917.GA29520@lsv03152.swis.in-blr01.nxp.com>
References: <20200715090400.4733-2-calvin.johnson@oss.nxp.com>
 <1a031e62-1e87-fdc1-b672-e3ccf3530fda@arm.com>
 <20200724133931.GF1472201@lunn.ch>
 <97973095-5458-8ac2-890c-667f4ea6cd0e@arm.com>
 <20200724191436.GH1594328@lunn.ch>
 <1595922651-sup-5323@galangal.danc.bne.opengear.com>
 <9e63aabf-8993-9ce0-1274-c29d7a5fc267@arm.com>
 <1e4301bf-cbf2-a96b-0b76-611ed08aa39a@gmail.com>
 <f046fa8b-6bac-22c3-0d9f-9afb20877fc9@arm.com>
 <CABdtJHvcaR_J86at-eMYPmNXEno8_CwUkSpLmF4HHba_AQ4A2Q@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABdtJHvcaR_J86at-eMYPmNXEno8_CwUkSpLmF4HHba_AQ4A2Q@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: SG2PR01CA0105.apcprd01.prod.exchangelabs.com
 (2603:1096:3:15::31) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR01CA0105.apcprd01.prod.exchangelabs.com (2603:1096:3:15::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.17 via Frontend Transport; Wed, 29 Jul 2020 09:39:25 +0000
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 38eb8f76-710a-4184-4f8f-08d833a34b0e
X-MS-TrafficTypeDiagnostic: AM0PR04MB6209:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB6209698EA72BE3328367CEFCD2700@AM0PR04MB6209.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u4RHCWx8eEtS7omRaeMBapkCqPbryyh2/bgcbRWnNhRqwQZdnh4D9e0Nzqg9JXHqQWX+mBiF5SPfDl+h7Di1QWeTegaU0wxWz7472t+z5V05i0Acn2fCJN4CTeyMcdLklFxbBrpvfbnM3E6tDnO0G10vQhf2t58mfmchRdrF9YF49++UKD6mF0gqAsZzM8iqPmoBzu39YEwg8QeuV92nYPHYp96V9Ga+ec/tviYGh5BLHdBuU7ZkX3jO4oInpEqDWgu03AoS0thP9Re5HV2x9r6N9PIgKgbOf1yYM6mjcy6j3XH44P/m988LvbaYA0eoHGKjc+YzOUcmlSjpSe2HzdVFf5kOtKSezLpCIzS48iiIdMabneOPfR309ApLRnyJvvUH09DQ8sDa479q1iAhIsHcuKvV4xBszl25nDHnuDyHEAPSfdn7vGTtgfjP4GONtZntZQKWr4ogXuktpx9O3g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(366004)(376002)(346002)(396003)(4326008)(966005)(86362001)(66556008)(8936002)(16526019)(66476007)(5660300002)(45080400002)(66946007)(186003)(1006002)(54906003)(110136005)(6666004)(26005)(7696005)(478600001)(2906002)(52116002)(316002)(7416002)(55236004)(6506007)(83380400001)(44832011)(8676002)(956004)(1076003)(33656002)(55016002)(9686003)(53546011)(110426005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: +O9UcRtjUUSaRKFqyjg2H4CGL7dNe3l2xhpTva5nXmAbX6FSa7VV+3oh5ZgnVp2VgWQodqNXeihU6UD9cXhGLYe/ZcGAs+mgvPBJDni2WvkrLqUpcJ6NLb2mWEZgdx3rXUNpzyIbGpoMiKH+q1ZQSjUqzuZsqMdGeNPfQqeSF+QXFYVV4/3/0eO1osyUFcqNp3wROYXZ1Y4CMctRJ4bjJNQk336Kb3RuuGwFUN92ADPjTcHUZBNbckp2jhR59ebzufwlny8C5udJnOMPsB5ZAeUVzUEOB26vzPhgI1P1mD2mcPJ/lTqLdZpcUnHIyspm42WZ1BZNXQhdAKXtXyU/4IYRoR07ksocBWrB6a9kKVR+Sjx+NyF8sn5qjUPufwa/wa9hKTyryK9YEAXDhYYeC2bZmFAxMBguwq0Yq1ZPTRb9Z6nmW1EPJ4pnQuC1RUserxj0F4DwltdzlVCAYP5REp7asAXBSmERlh2hs/L4LDHxdUwKlgvvP+T12Gdzy2RyBsfEN3tdJUqvOpQQgt4r6yZb9uuJ7pt+zr8ZW0u3lwX9tfrh3xtKXfT7RBM1W7OzTKtktfjWnpF57vMGp6qvoROyogZkwqnnMsrAT9cenAGkKHU5NQ23BIb71cG88AGaN8h5pWVRHdEFwbx+9zLJiA==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38eb8f76-710a-4184-4f8f-08d833a34b0e
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2020 09:39:31.3125
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C4sE8N6vzDZnIizuaXNcJsd7mmM8SoV1p+Bji6nv1TDOmO0VSjPo/wfgRDl7Bzsjdi04ZYe1iwDZoTv4ebnAkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6209
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 29, 2020 at 10:43:34AM +0200, Jon Nettleton wrote:
> On Wed, Jul 29, 2020 at 4:53 AM Jeremy Linton <jeremy.linton@arm.com> wrote:
> >
> > Hi,
> >
> > On 7/28/20 7:39 PM, Florian Fainelli wrote:
> > > On 7/28/2020 3:30 PM, Jeremy Linton wrote:
> > >> Hi,
> > >>
> > >> On 7/28/20 3:06 AM, Dan Callaghan wrote:
> > >>> Excerpts from Andrew Lunn's message of 2020-07-24 21:14:36 +02:00:
> > >>>> Now i could be wrong, but are Ethernet switches something you expect
> > >>>> to see on ACPI/SBSA platforms? Or is this a legitimate use of the
> > >>>> escape hatch?
> > >>>
> > >>> As an extra data point: right now I am working on an x86 embedded
> > >>> appliance (ACPI not Device Tree) with 3x integrated Marvell switches.
> > >>> I have been watching this patch series with great interest, because
> > >>> right now there is no way for me to configure a complex switch topology
> > >>> in DSA without Device Tree.
> > >>
> > >> DSA though, the switch is hung off a normal MAC/MDIO, right? (ignoring
> > >> whether that NIC/MAC is actually hug off PCIe for the moment).
> > >
> > > There is no specific bus, we have memory mapped, MDIO, SPI, I2C swiches
> > > all supported within the driver framework right now.
> > >
> > >>
> > >> It just has a bunch of phy devices strung out on that single MAC/MDIO.
> > >
> > > It has a number of built-in PHYs that typically appear on a MDIO bus,
> > > whether that bus is the switch's internal MDIO bus, or another MDIO bus
> > > (which could be provided with just two GPIOs) depends on how the switch
> > > is connected to its management host.
> > >
> > > When the switch is interfaced via MDIO the switch also typically has a
> > > MDIO interface called the pseudo-PHY which is how you can actually tap
> > > into the control interface of the switch, as opposed to reading its
> > > internal PHYs from the MDIO bus.
> > >
> > >> So in ACPI land it would still have a relationship similar to the one
> > >> Andrew pointed out with his DT example where the eth0->mdio->phy are all
> > >> contained in their physical parent. The phy in that case associated with
> > >> the parent adapter would be the first direct decedent of the mdio, the
> > >> switch itself could then be represented with another device, with a
> > >> further string of device/phys representing the devices. (I dislike
> > >> drawing acsii art, but if this isn't clear I will, its also worthwhile
> > >> to look at the dpaa2 docs for how the mac/phys work on this device for
> > >> contrast.).
> > >
> > > The eth0->mdio->phy relationship you describe is the simple case that
> > > you are well aware of which is say what we have on the Raspberry Pi 4
> > > with GENET and the external Broadcom PHY.
> > >
> > > For an Ethernet switch connected to an Ethernet MAC, we have 4 different
> > > types of objects:
> > >
> > > - the Ethernet MAC which sits on its specific bus
> > >
> > > - the Ethernet switch which also sits on its specific bus
> > >
> > > - the built-in PHYs of the Ethernet switch which sit on whatever
> > > bus/interface the switch provides to make them accessible
> > >
> > > - the specific bus controller that provides access to the Ethernet switch
> > >
> > > and this is a simplification that does not take into account Physical
> > > Coding Sublayer devices, pure MDIO devices (with no foot in the Ethernet
> > > land such as PCIe, USB3 or SATA PHYs), SFP, SFF and other pluggable modules.
> >
> > Which is why I've stayed away from much of the switch discussion. There
> > are a lot of edge cases to fall into, because for whatever reason
> > networking seems to be unique in all this non-enumerable customization
> > vs many other areas of the system. Storage, being an example i'm more
> > familiar with which has very similar problems yet, somehow has managed
> > to avoid much of this, despite having run on fabrics significantly more
> > complex than basic ethernet (including running on a wide range of hot
> > pluggable GBIC/SFP/QSFP/etc media layers).
> >
> > ACPI's "problem" here is that its strongly influenced by the "Plug and
> > Play" revolution of the 1990's where the industry went from having
> > humans describing hardware using machine readable languages, to hardware
> > which was enumerable using standard protocols. ACPI's device
> > descriptions are there as a crutch for the remaining non plug an play
> > hardware in the system.
> >
> > So at a basic level, if your describing hardware in ACPI rather than
> > abstracting it, that is a problem.
> >
> This is also my first run with ACPI and this discussion needs to be
> brought back to the powers that be regarding sorting this out.  This
> is where I see it from an Armada and Layerscape perspective.  This
> isn't a silver bullet fix but the small things I think that need to be
> done to move this forward.
> 
> From Microsoft's documentation.
> 
> Device dependencies
> 
> Typically, there are hardware dependencies between devices on a
> particular platform. Windows requires that all such dependencies be
> described so that it can ensure that all devices function correctly as
> things change dynamically in the system (device power is removed,
> drivers are stopped and started, and so on). In ACPI, dependencies
> between devices are described in the following ways:
> 
> 1) Namespace hierarchy. Any device that is a child device (listed as a
> device within the namespace of another device) is dependent on the
> parent device. For example, a USB HSIC device is dependent on the port
> (parent) and controller (grandparent) it is connected to. Similarly, a
> GPU device listed within the namespace of a system memory-management
> unit (MMU) device is dependent on the MMU device.
> 
> 2) Resource connections. Devices connected to GPIO or SPB controllers
> are dependent on those controllers. This type of dependency is
> described by the inclusion of Connection Resources in the device's
> _CRS.
> 
> 3) OpRegion dependencies. For ASL control methods that use OpRegions
> to perform I/O, dependencies are not implicitly known by the operating
> system because they are only determined during control method
> evaluation. This issue is particularly applicable to GeneralPurposeIO
> and GenericSerialBus OpRegions in which Plug and Play drivers provide
> access to the region. To mitigate this issue, ACPI defines the
> OpRegion Dependency (_DEP) object. _DEP should be used in any device
> namespace in which an OpRegion (HW resource) is referenced by a
> control method, and neither 1 nor 2 above already applies for the
> referenced OpRegion's connection resource. For more information, see
> section 6.5.8, "_DEP (Operation Region Dependencies)", of the ACPI 5.0
> specification.
> 
> We can forget about 3 because even though _DEP would solve many of our
> problems, and Intel has kind of used it for some of their
> architectures, according to the ACPI spec it should not be used this
> way.
> 
> 1) can be achievable on some platforms like the LX2160a.  We have the
> mcbin firmware which is the bus (the ACPI spec does allow you to
> define a platform defined bus), which has MACs as the children, which
> then can have phy's or SFP modules as their children.  This works okay
> for enumeration and parenting but how do they talk?
> 
> This is where 2) comes into play.  The big problem is that MDIO isn't
> designated as a SPB
> (https://docs.microsoft.com/en-us/windows-hardware/drivers/bringup/simple-peripheral-bus--spb-)
> We have GPIO, I2C, SPI, UART, MIPI and a couple of others.  While not
> a silver bullet I think getting MDIO added to the spec would be the
> next step forward to being able to implement this in Linux with
> phylink / phylib in a sane manner.  Currently SFP definitions are
> using the SPB to designate the various GPIO and I2C interfaces that
> are needed to probe devices and handle interrupts.
> 
> The other alternatives is the ACPI maintainers agree on the _DSD
> method (would be quickest and should be easy to migrate to SBP if MDIO
> were adopter), or nothing is done at all (which I know seems to be a
> popular opinion).
> 

Before other ACPI experts miss any further discussion let me add them to the
loop.

Hi ACPI maintainers,  please have a look at the discussion and some conclusions
in this thread:
https://lore.kernel.org/linux-acpi/20200715090400.4733-1-calvin.johnson@oss.nxp.com/T/#t

Discussion is around adding ACPI support into the PHY subsystem.

Thanks
Calvin
