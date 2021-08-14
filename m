Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2DE83EC606
	for <lists+netdev@lfdr.de>; Sun, 15 Aug 2021 01:42:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234489AbhHNXmh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 19:42:37 -0400
Received: from mail-bn8nam12on2091.outbound.protection.outlook.com ([40.107.237.91]:25825
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233223AbhHNXmf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Aug 2021 19:42:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dD0bxW5XGUP8popQBm6KQqsSbLBFoWl2D3HXvRnwB1mCz40qiVAolF6OUAZUVl1xV3kPMO1N/eNiQTztEFav70vA0uty52k2N8xk9QWJlDr1VaURRIbra7arR19qwbDYOKUsszT+oo4mbxPcyGnduybEoYfoGEdmshBsU8R04bVl5ElCqzUP0QeLJrKmWoisc8nsK1jYrxz4QFGTxomfFgmbQgYU+rPcFDD6eJ6MaN3GcNDW7kUsqiU8RV5hPgqLW+q5uZt1eHuf5yASIR8nB2qZZhEEdB4Nl8dmcHzWlGSbBbAIroTQL91CHrDhY7gr4GyHTIbSWcNns8+KJv3pCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lj5/D1djIfYw/u9WncfstPwYBAh8vos5QtfhNgUHk48=;
 b=kXwyvVz5Y0V52kvqoAd88elNeVB6TyF3cETopFRErbPweYAQH1WQ4Yk+4eMoJS3cQa5PlE5fT5Zjib6MV4qRDN5fqenpVDDxRnOmsY/PXT5yeXzl4PqFNKCNui9rN+cqQG2az2myzxwCVf4t/Ii6NQa/+aLYOqMDgki9wUHvDgoZj9qZqGXvN+uI4zM+3A1gOui+dqBwUBLegkNE8yhfPpmd+N4pErkO0YiB01jsFJsczK0KkSlbnX2bVoiGypNWtbce568v0ZMiDRr+dO6P5ogZEW/y3ksLsOP3cTA/j4uhhPX3lgquJyQ12C+u0I4DTQjJ6k8z5TxcWUUgdlzmiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lj5/D1djIfYw/u9WncfstPwYBAh8vos5QtfhNgUHk48=;
 b=OajNFyynceSaIenM80a8EBB63xrDPFIxYpqNZATxqLRudORY3mcHo0QI6+F5FFEiVT3ACmDzb7Po/VySYzkALb1kadj5cXm9d3l3Fboz8BqIEo+SEISowrTiOTDvYGP7PtiD30osBh2fgHz4u4l274HI7QUDL6a5pl2jsPMQstM=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR1001MB2350.namprd10.prod.outlook.com
 (2603:10b6:301:2f::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14; Sat, 14 Aug
 2021 23:42:03 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::e81f:cf8e:6ad6:d24d]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::e81f:cf8e:6ad6:d24d%3]) with mapi id 15.20.4415.019; Sat, 14 Aug 2021
 23:42:03 +0000
Date:   Sat, 14 Aug 2021 16:41:58 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3 net-next 10/10] docs: devicetree: add
 documentation for the VSC7512 SPI device
Message-ID: <20210814234158.GE3244288@euler>
References: <20210814025003.2449143-1-colin.foster@in-advantage.com>
 <20210814025003.2449143-11-colin.foster@in-advantage.com>
 <20210814114721.ncxi6xwykdi4bfqy@skbuf>
 <20210814184040.GD3244288@euler>
 <20210814190854.z6b33nfjd4wmlow3@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20210814190854.z6b33nfjd4wmlow3@skbuf>
X-ClientProxiedBy: BYAPR01CA0057.prod.exchangelabs.com (2603:10b6:a03:94::34)
 To MWHPR1001MB2351.namprd10.prod.outlook.com (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from euler (67.185.175.147) by BYAPR01CA0057.prod.exchangelabs.com (2603:10b6:a03:94::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14 via Frontend Transport; Sat, 14 Aug 2021 23:42:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b384e20f-45dd-45f1-abe5-08d95f7d1dcf
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2350:
X-Microsoft-Antispam-PRVS: <MWHPR1001MB2350D0375707102724F41420A4FB9@MWHPR1001MB2350.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eidcnCEsuhDM62ywFp/u+iUps6/ps2K69s2HVWVc/Vid4+Thtu1IrUZKIdQyNgQ6b8jiblSrD1gYK3kLD3ysQmTs4j2O+l4Vz4cAZQuqaGG2UV/yz6bxixwBW/g6Qt9HAl976RODbz2BoJTbQ0BElLh5uD92J9gcoaFm3HcxmZzyG9qkzLboGlvgxGXxOehTIG6XmjFWchm71IVSnaCUwnIZTXZW+P4X7zkfVbJAgR4eet/Ldw5WiWX8pPZcHYv3bAd0Wu4Sf+7l82ahPdCZdCBdws3483TAd+Hcx3Xbq6UqWx7fuv2L7aDcDFVq/bme6ra/WrmEeFJi/jBV2GsaaMcHIslG7aQQhG9Lm9+9yYAxRBtQTwl4wRrJIktXnlLWD7Q/jGs6JAesk5XC6hjV8DFeoWkIx0NbvS1ZAePn48nI/EvHua8fzyTv5yNxD4yXiUzSDDm6hSw591XdQk036MtcN1euprnC2cGIhUI3IwqCo0e6Lfz8EPH9q39BbEE6SwYpliICkK4sayCSK+jK0HHSI/sZTEPcz1xLt4Yr9alAl6aerAFICgLq0L3WuS03vRn9qIIjbJmjd4OaucvPcc3C9R2vwQSoUxKWi7Ejtv9KfdaN4LFqo7e/sChfOy3hM81fjsY3ChUzycczQFixpKwEhB/eY4GN/A83AHJOY+DcG29QhV/vxB/I4NE3TMIQ4wmVJYzCz3ML1swjMZ9dsg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(376002)(346002)(39830400003)(136003)(478600001)(7416002)(33656002)(52116002)(186003)(8676002)(6496006)(956004)(9576002)(8936002)(4326008)(316002)(2906002)(26005)(44832011)(6666004)(6916009)(38350700002)(38100700002)(83380400001)(86362001)(33716001)(1076003)(5660300002)(66946007)(66556008)(66476007)(55016002)(9686003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gz3u5V97acKx7ncmWeVAXJr/I4S7PcZ9kiQ1JrrC4d9XuFqdUo9/JvxmvycB?=
 =?us-ascii?Q?XGGbVMdhMZGvmDnHeQaobWsaamRWmiEpKz1PX2AwYMV56y/3tf15VbJ7jnBD?=
 =?us-ascii?Q?hxv8rpDunBptxOnVWwahc5IcWqyv1XzGGOfgn8BXTCjzSAmwB3ykKXXzPpTK?=
 =?us-ascii?Q?ZVNklAg2Q1LR2Ckvd2R4p/98SncDxbxGkglZUW8tO40jIKfIeZ78629Nabg8?=
 =?us-ascii?Q?YM+btx6BE7l3mOwZLaq0E30Sx9N61eHpmRRAd7R+GaY0Q2em9GFGRxaQeHpQ?=
 =?us-ascii?Q?dD98BNSku2X8f0PcXQJWe055Bj6SnyCCKF4h9jBAHTdE5x+KllP/aY0Ie7az?=
 =?us-ascii?Q?xriBiMj+yUjJ8fQrbvyccHj71tSpu2dv4cbBjGIGewYglLFwRLQrqmqITtPe?=
 =?us-ascii?Q?MY6ASXqXGsL553Th8RZClBMdcvhYfQNiQA2jCdH+i6p4CFzBgiaip94sYSS+?=
 =?us-ascii?Q?mFzs8+yccK2n9OMclnlOMofVNUjpvdeCgO6lokd8zHaka9DEwceqGFBmPog0?=
 =?us-ascii?Q?nvc7z2m301DryzZm8fmQSRVW4dL+L9WPS8fPPkMnb92xcS8595tRugmwYjjg?=
 =?us-ascii?Q?C0OzVkHDkt/Mrd6z5fJ/D33SRQ/T1IZcnQDww00OrosMXPGPMeQurYyhVx6L?=
 =?us-ascii?Q?VVL761N3/wMFtMQ/bzaGWj/whlTPHOjYZHfI3Me0eVGYA+Xq0qFCNcrL9NBn?=
 =?us-ascii?Q?/SP8u7pw7Tj2RR+xPPTLD8NrIm08iLHxPUSmh2SbFepXMvggaaEAlLnllxWV?=
 =?us-ascii?Q?6fanB9cQCyeukOqxuBrorrANwomvZTb45j4UOdDkJQb3gaTsgxxORlD5Fj64?=
 =?us-ascii?Q?RSaV1iH1eGxOH/fCFb75kBqEBocRb1aL6KiZwGZZezqkhfzEJm1aqJRxEu6G?=
 =?us-ascii?Q?Q03F0GqqSp108UfBZJgnCM6a/0Fvai8mBdYGk+puobNfmkt6nDHwVQmsszKm?=
 =?us-ascii?Q?UKX+5RCR6L+T9eELxyVRyESvJVBgrlxemBKQI9vv12wp1vVW0UL9UzKCKgSu?=
 =?us-ascii?Q?zhNdNax0xfN860zZ5MtiLJuG7xBsA+MTHWYCV6uQh5tz4OrgCEUmvfnXZoAC?=
 =?us-ascii?Q?ZUu0oq4OLZiAEWIKhLSEMk3fPdSYfESxmPUYjqYWpb+sLIQe/fj3fNo14+VA?=
 =?us-ascii?Q?eGoIjXXs+ZSVV8CbiPPSif36cu4A5y/WEJpQGhsKiZXF2XewQ81cccySVaOj?=
 =?us-ascii?Q?SOIfA/Jg1RaqIuFvAB6ZaDbFZNaXEVE6Dbu6w8bmyWadVBrAAKl2OPLLlziK?=
 =?us-ascii?Q?xfI1t5DBFdt1Wk1HcNkzAHsc0gDGiH8HJgNXeKhNmyvBu5HCwGHRzttiKzsA?=
 =?us-ascii?Q?iAP6nnf9Vw3C1VVLYmntkJbT?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b384e20f-45dd-45f1-abe5-08d95f7d1dcf
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2021 23:42:02.9373
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CxgbmmzEHx50bhBRM5WupS5NSygq2062XNqE6fHii/MWOygEIRVw71m32Q8Bl9zqxQIZGFA40+Gkold5o9eDbGFsbanf6RuBBzCrgJ02kLo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2350
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 14, 2021 at 10:08:54PM +0300, Vladimir Oltean wrote:
> On Sat, Aug 14, 2021 at 11:40:40AM -0700, Colin Foster wrote:
> > On Sat, Aug 14, 2021 at 02:47:21PM +0300, Vladimir Oltean wrote:
> > > On Fri, Aug 13, 2021 at 07:50:03PM -0700, Colin Foster wrote:
> > > > +* phy_mode =3D "sgmii": on ports 0, 1, 2, 3
> > >=20
> > > > +			port@0 {
> > > > +				reg =3D <0>;
> > > > +				ethernet =3D <&mac>;
> > > > +				phy-mode =3D "sgmii";
> > > > +
> > > > +				fixed-link {
> > > > +					speed =3D <100>;
> > > > +					full-duplex;
> > > > +				};
> > > > +			};
> > >=20
> > > Your driver is unconditionally setting up the NPI port at gigabit and
> > > you claim it works, yet the device tree sees a 100Mbps fixed-link? Wh=
ich
> > > one is right, what speed does the port operate at?
> >=20
> > Good catch!
> >=20
> > I made the change to ocelot_spi_vsc7512 yesterday to set it up as
> > gigabit, tested it, and it still works. Previously for my testing I'd
> > had it hard-coded to 100, because the Beaglebone I'm using only support=
s
> > 100Mbps on eth0.
> >=20
> > # phytool print swp1/0
>=20
> Why are you showing the PHY registers of swp1? Why are these relevant at =
all?

Some sleight of hand. I'm not sure there's a different way to do it, but
running print on swp1/0 gives phy address 0 on the bus that contains
swp1. So in this setup, swp1/0 is the same as swp2/0, swp3/0 and swp4/0,
all of which point to the registers associated with "swp0" from what I
understand.

>=20
> >=20
> > ieee-phy: id:0x00070540
> >=20
> >    ieee-phy: reg:BMCR(0x00) val:0x1040
> >       flags:          -reset -loopback =1B[1m+aneg-enable=1B[0m -power-=
down -isolate -aneg-restart -collision-test
> >       speed:          1000-half
>=20
> Also, 1000/half sounds like an odd speed to end negotiation at.

Agreed. Possibly a misunderstanding by me during
vsc7512_enable_npi_port? I'll look into this.

>=20
> >=20
> >    ieee-phy: reg:BMSR(0x01) val:0x796d
> >       capabilities:   -100-b4 =1B[1m+100-f=1B[0m =1B[1m+100-h=1B[0m =1B=
[1m+10-f=1B[0m =1B[1m+10-h=1B[0m -100-t2-f -100-t2-h
> >       flags:          =1B[1m+ext-status=1B[0m =1B[1m+aneg-complete=1B[0=
m -remote-fault =1B[1m+aneg-capable=1B[0m =1B[1m+link=1B[0m -jabber =1B[1m+=
ext-register=1B[0m
> >=20
> >=20
> > Of course I understand that "it works" is not the same as "it's correct=
"
> >=20
> > What I wanted to accomplish was to use the speed parameter and set up
> > the link based on that. I looked through all the DSA drivers and
> > couldn't find anything that seems to do that. The closest thing I saw
> > was in mt7531_cpu_port_config where they set the speed to either 2500 o=
r
> > 1000 based on the interface. But nothing that I saw would explicitly se=
t
> > the speed based on this parameter.
>=20
> As I mentioned in the other email, .phylink_mac_link_up is the function
> you are looking for. Phylink parses the fixed-link and calls that
> function for fixed-link ports with the speed and duplex specified. Check
> and see if felix_phylink_mac_link_up is not in fact called with
> link_an_mode =3D=3D MLO_AN_FIXED, speed =3D=3D SPEED_100 and duplex =3D=
=3D DUPLEX_FULL,
> then what you are doing with that and if it makes sense for what you are
> trying to do.

I'll reply there once I've absorbed everything.

>=20
> >=20
> > So I think there's something I'm missing. The fixed-link speed should a=
pply to=20
> > the CPU port on the switch (port@0)?
>=20
> Is this a question? It is under port@0, the port with the 'ethernet'
> property i.e. the CPU port, so why should it not?
>=20
> > Then eth0 can be manually set to a specific speed, but if it doesn't
> > match the fixed-link speed I'd be out of luck? Or should an ip link or
> > ethtool command to eth0 modify the speeds of both sides of the
> > connection? It feels like setting port@0 to the fastest speed and
> > letting it negotiate down to eth0 makes sense...
> >=20
> > To ask the same question a different way:
> >=20
> > I can currently run "ethtool -s eth0 speed 10 duplex full autoneg on"=20
> > and the link at eth0 drops to 10Mbps. Pinging my desktop jumps from=20
> > about 400us to about 600us when I do that.
>=20
> If eth0 is also a fixed-link, you should not be able to do that, no.
> But the fact that you are able to do that means it's not a fixed-link,
> you have a pair of PHYs that freely auto-negotiate the speed between the
> BeagleBone and the switch.

Yes, that is my setup. Addressed below.

>=20
> >=20
> > Should I not be able to do that? It should be fixed at 100Mbps without
> > autoneg, end of story? Because in the current configuration it feels
> > like the fixed-link settings are more a suggestion than a rule...
> >=20
>=20
> It should describe the hardware configuration, of course. It is
> incorrect to describe one side of a copper PHY connection as fixed-link
> and the other as having a phy-handle, and it sounds like this is what
> you're doing. We need to see the device tree binding for eth0, and
> maybe a picture of your setup if that is possible. How do you connect
> the switch board to the BeagleBone? Is it an RJ45 cable or some sort of
> PCIe-style connector with fingers for an SGMII SERDES lane, in which the
> board is plugged?
>=20
> The device tree says SGMII, the behavior says RJ45.

I'm using the standard BeagleBone devicetree, so &mac is defined in
arch/arm/boot/dts/am335x-bone-common.dtsi. For this stage of development
I'm using an ethernet cable plugged from the BeagleBone to port 0 of the
VSC7512 dev board. I haven't done anything more to the
am335x-boneblack.dts other than add the spi and switch configurations.
The connections between the beaglebone and dev board are limited to the
4 SPI lines, a ground, and an ethernet cable.

So DSA requires a fixed-link property. And that makes sense... who in
their right mind would connect switches on a board using an RJ45
connection :) Then the only reason any of this is working is because I
have eth0 set up as an RJ45 connection, and because of that I need the
hack to enable the phy on the switch port 0...

Maybe that's a question:
Is my devicetree incorrect for claiming the connection is SGMII when it
should be RJ45? Or is my setup incorrect for using RJ45 and there's no
way to configure it that way, so the fact that it functions is an
anomaly?
