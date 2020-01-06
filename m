Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3116D131025
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 11:17:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbgAFKRT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 05:17:19 -0500
Received: from mail-eopbgr80070.outbound.protection.outlook.com ([40.107.8.70]:10119
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726155AbgAFKRS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Jan 2020 05:17:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eC5G/qNoBlrzDKnKLin0xBMUuO+waDrPsy0eycZWQhPakbnNhthieEMJU/kCwcezeWC7Ftm+1UGoPfYKwneFWwH6HkhK017LV0sPJ9kJCnc6bLWrHZBWWS0sFfsE9sl1bgTl6NHdPHIe9FIzGvXrtBoEqw+kB3imhkc7HbXCINjs4xE+pNO1Bq8jl8qs2fs5n8GqE2PhhK/5s5d2s3QAtORvrPnM9DRb6mnFQ0kdlClL0EHUh7XdvWAJJOl1PeDfNLhQyxq0M1S/qEBPgR+lBiKB0vnkdtHFmeOxNZXMbheFBvZu7woaWrTkUsoNsEWIbYW/6FA7RRAQlEu8i+7Bzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9ecY+wVZkJjl5GePn4u0CFX92Mgl6vzzCXfVe0Qg2mM=;
 b=TgFNXAKGzGlF/qrAoJVb6pdyRhqK3L0T9jAifFbrfkDrPnGRPDU1KCBtD9556YKBlK44xdFzhDgDthrk+743jdSbKNwSeXcs7Nei7MHbWHJcP1cvG8yvnxYrgjhtQ6d84+PO9CG1gqIFxGg3aqlUy7e1kcmslu5ecvMRtPZb9zci6Tx8G/w7pCU38rqtvhP8tzLXReWgjQGz+zRsvKO2I877hKw7J2wfRc8VlEsIfZ4L32o00xsV+xUaWYDlpvUpWwW4kNovvGmq6EnFmapuJN9VfKpcv3UWSMJ2ygUn644js+LzLf+syx4oxaZmA1HLCWR8/yCOjOq+TFxP8nXpgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9ecY+wVZkJjl5GePn4u0CFX92Mgl6vzzCXfVe0Qg2mM=;
 b=N/4AMqsurn9gvLgPNMs9nCnJp4F2IWURepUUE8HKFxNUBR/A2Ws2hMDeZwiM2kopbYGc6STt4VOYdYskXv8xsbQ6QLUc/qmLPc//9JbRSJtm6Nls+El8Mat4mxJEG6/n6N3Iqr8AdMqScPunryUhIHn0YxkSZgDsi3e66CQeOKA=
Received: from DB8PR04MB6985.eurprd04.prod.outlook.com (52.133.243.85) by
 DB8PR04MB6601.eurprd04.prod.outlook.com (20.179.248.220) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.12; Mon, 6 Jan 2020 10:17:11 +0000
Received: from DB8PR04MB6985.eurprd04.prod.outlook.com
 ([fe80::c181:4a83:14f2:27e3]) by DB8PR04MB6985.eurprd04.prod.outlook.com
 ([fe80::c181:4a83:14f2:27e3%6]) with mapi id 15.20.2602.015; Mon, 6 Jan 2020
 10:17:11 +0000
From:   "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
CC:     "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>
Subject: RE: [PATCH 1/6] net: phy: add interface modes for XFI, SFI
Thread-Topic: [PATCH 1/6] net: phy: add interface modes for XFI, SFI
Thread-Index: AQHVtoABZZFXn6n8UUGKWfe6RtVAuKfBtnoAgAAR9oCABd2qgIAQ9D0AgAAopQCAAAQgAIAAJ5UAgAANzwCAADOTgIAAFvEAgAQ2y6A=
Date:   Mon, 6 Jan 2020 10:17:10 +0000
Message-ID: <DB8PR04MB698500B73BDA9794D242BEDAEC3C0@DB8PR04MB6985.eurprd04.prod.outlook.com>
References: <1576768881-24971-2-git-send-email-madalin.bucur@oss.nxp.com>
 <20191219172834.GC25745@shell.armlinux.org.uk>
 <VI1PR04MB5567FA3170CF45F877870E8CEC520@VI1PR04MB5567.eurprd04.prod.outlook.com>
 <20191223120730.GO25745@shell.armlinux.org.uk>
 <DB8PR04MB69858081021729EC70216BE3EC230@DB8PR04MB6985.eurprd04.prod.outlook.com>
 <20200103092718.GB25745@shell.armlinux.org.uk>
 <20200103094204.GA18808@shell.armlinux.org.uk>
 <DB8PR04MB698591AAC029ADE9F7FFF69BEC230@DB8PR04MB6985.eurprd04.prod.outlook.com>
 <20200103125310.GE25745@shell.armlinux.org.uk>
 <DB8PR04MB6985FB286A71FC6CFF04BE50EC230@DB8PR04MB6985.eurprd04.prod.outlook.com>
 <20200103171952.GH25745@shell.armlinux.org.uk>
In-Reply-To: <20200103171952.GH25745@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=madalin.bucur@oss.nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4e2fbfdc-cbd8-4091-2359-08d7929197d1
x-ms-traffictypediagnostic: DB8PR04MB6601:|DB8PR04MB6601:
x-ms-exchange-sharedmailbox-routingagent-processed: True
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB8PR04MB6601D5E4763DD45CF14147D8AD3C0@DB8PR04MB6601.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0274272F87
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(136003)(346002)(396003)(366004)(39860400002)(13464003)(199004)(189003)(5660300002)(966005)(66556008)(64756008)(66446008)(76116006)(6506007)(8936002)(30864003)(33656002)(55016002)(478600001)(110136005)(54906003)(26005)(2906002)(9686003)(86362001)(4326008)(53546011)(7696005)(52536014)(66476007)(66946007)(8676002)(81156014)(81166006)(186003)(316002)(71200400001)(6606295002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR04MB6601;H:DB8PR04MB6985.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:0;MX:1;
received-spf: None (protection.outlook.com: oss.nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wN//VBypJUQJ53tAgK77Q8OLQL742vEL3hX+1NFQvL7dOtbQAwfgljHsSM7CJ6tyT8D1xMr/8jhzYeyaJ6QYDi08JO0SzbYgJkNBOZOPa8naRRpJiQCkjngScuakyEDIQhD/agwchQ9O2dMJGuRuPmugMDZZHQzeKg+6WJ0sIUSLH0A13dDGiaU6haGrHxMcr50rwTjFG41zCaeQQqWOsvz1ZdVCN6R/Eet+JILr05J+K8V2j7scFWvLCFl1QC4SMqyXWRp++kAL++SBpLasEMoUCePuJ1+LaNq40dVQyTVlJg7ZnxwIbcKfgaCSfGCGU46zj/Hlqkgab5XtueBwwVVF808TlaSTIuFusKyhsK3p/Vpb2zrkKYFCHeB6oUXgmNX0/QRY/Sox0YbkRpGEwTy/lleUV5CTktwAU4s/y/M2kxYv7abbZN7YLOLwMkYtZJ28q5zmHXZEKEKu47moTcjx4KE/5HQfHLUUSi2DThjZ6fzLXwyYAxYyfudmm85Kmf8Z3V/Dbw3NbZmB/FL6WXqebm+7YH/8GVeG7YIdiONuokZsoIT+/XuQKUn74+ZK
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e2fbfdc-cbd8-4091-2359-08d7929197d1
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jan 2020 10:17:11.0078
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UzA9i4zGzLjuF47jrPQ9hmBl4SqZIKEdbZyfcv9APnVT8S76Cz7pIMO+ahNHxIeaah+Y0INsdq+qBTl/heCvng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6601
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
> Sent: Friday, January 3, 2020 7:20 PM
> To: Madalin Bucur (OSS) <madalin.bucur@oss.nxp.com>
> Cc: devicetree@vger.kernel.org; davem@davemloft.net;
> netdev@vger.kernel.org; andrew@lunn.ch; f.fainelli@gmail.com;
> hkallweit1@gmail.com; shawnguo@kernel.org
> Subject: Re: [PATCH 1/6] net: phy: add interface modes for XFI, SFI
>=20
> On Fri, Jan 03, 2020 at 03:57:45PM +0000, Madalin Bucur (OSS) wrote:
> > Hi, I'm aware of the parties involved in the discussion but the
> messages
> > are meant for the whole community so the details included are meant for
> > that. We're having a conversation on the mailing list, not in private
> > and the end result of this will be of use, I hope, to others that have
> the
> > same dilemmas, be them justified or not. I had the pleasure to meet
> Andrew
> > in person a couple of years ago and I'm looking forward to meet you as
> well.
>=20
> The most frustrating part of this discussion for me is this:
>=20
> It started by you stating that you wanted to use XFI as a
> phy_interface_t, and through that initial discussion you were stating
> that XFI is defined by the XFP MSA - which is quite right. XFI is the
> electrical interface used for XFP modules, as defined by the XFP MSA.
> SFI is the electrical interface used for SFP+ modules, as defined by
> the SFP+ MSA (_not_ the SFP MSA, if you want to be pedantic.)
>=20
> When I found a copy of the XFP MSA, along with its definition of what
> the XFI interface is, _all_ the points that I brought up about the
> XFI interface have been mostly ignored, such as my statement that XFI
> includes the electrical characteristics of the platform, because the
> stated specifications are valid only at the XFP mating connector.
>=20
> I also found that both XFI and SFI do not define the format of the
> electrical signals; indeed, there are several baud rates that are
> used which result in different bit periods of the signal, and even
> a case where 10GBASE-R can be carried on XFI in two different forms.
>

Glad you found these things, they are the base of our discussion here.
=20
> Rather than provide a counter-argument, you have instead switched to
> using other arguments to justify your position, such as using a
> breakdown of what 10GBASE-*R means.
>=20
> Yet again, as I see from the below, you have failed to counter any
> of the points that I have raised below.

You missed my argument about the device tree describing the HW (thus the
wires, electrical aspects too) and not configuring a certain protocol (the
device tree does not configure HW, it describes HW).
=20
> > > You seem to grasp at straws to justify your position. Initially, you
> > > were stating that XFI/SFI are defined by the MSAs and using that as
> > > a justification. Now, when I state what the MSAs say, you then go off
> > > and try to justify your position with some 3rd party description of
> > > what the various bits of 10GBASE-*R mean. Now you're trying to make
> > > out that your position is justified by the omission of the term "PCS"
> > > in the kernel's documentation.

From your wording I sense you are taking this a bit too personal, I'm tryin=
g
to state my views on this matter. The phy-connection-type parameter was
introduced to allow describing the (electrical) interface with the PHY, not
to configure a certain protocol over the same wires. It's up to the SW to d=
o
that, not the device tree. In this respect, saying that I have a XFI connec=
tion
up to a certain PHY's pins may be an excursion outside the MSA (no SFP conn=
ector)
but it's not the first "non-standard" (if it really were a standard) thing
done in the industry - see 2500 Gbps Ethernet or even USXGMII. Things move
faster than standards at times, we can wait for a clear standard or spec
(that may never appear) or try to do as good as possible of a job describin=
g
what's on the table today. I do not even insist that mixing xfi, sfi (or xa=
ui,
tbi, qsgmii) with 1000base-x, 2500base-x is a good idea, but having some an=
d
rejecting others seems arbitrary to me. Please note the protocols seem to b=
e
the ones joining late an electrical bus party here...

> > > I am well aware that DT describes the hardware; I am not a newbie to
> > > kernel development, but have been involved with it for near on 27
> > > years as ARM maintainer, getting into the details of platform
> > > support. So please stop telling me that DT describes the hardware.
> > > I totally accept that.
> > >
> > > What I don't accept is the idea that "XFI" needs to be a PHY
> interface
> > > mode when there's a hell of a lot more to it than just three letters.
> > >
> > > If it was that simple, then we could use "SATA" to support all SATA
> > > connections, but we can't. Just like "XFI" or "SFI", sata is a
> > > single channel serdes connection with electrical performance
> > > requirements defined at a certain point. In the case of eSATA, they
> > > are defined at the connector. In order to achieve those performance
> > > requirements, we need to specify the electrical parameters in DT to
> > > achieve compliance. As an example, here is what is required for the
> > > cubox-i4:
> > >
> > > &sata {
> > >         status =3D "okay";
> > >         fsl,transmit-level-mV =3D <1104>;
> > >         fsl,transmit-boost-mdB =3D <0>;
> > >         fsl,transmit-atten-16ths =3D <9>;
> > >         fsl,no-spread-spectrum;
> > > };
> > >
> > > These parameters configure the interface to produce a waveform at
> > > the serdes output that, when modified by the characteristics of the
> > > PCB layout, result in compliance with the eSATA connection at the
> > > connector - which is what is required.
> > >
> > > XFI and SFI are no different; these are electrical specifications.
> > > The correct set of electrical parameters to meet the specification
> > > is more than just three letters, and it will be board specific.
> > > Hence, on their own, they are completely meaningless.
> > >
> > > We have already ascertained that "XFI" and "SFI" do nothing to
> > > describe the format of the protocol - that protocol being one of
> > > 10GBASE-W, 10GBASE-R, fibrechannel or G.709.
> > >
> > > So, "XFI" or "SFI" as a phy_interface_t is meaningless. As a phy-
> mode,
> > > it is meaningless. As a phy-connection-type, it is meaningless.
> > >
> > > You claim that I'm looking at it from a phy_interface_t perspective.
> > > Sorry, but that is where you are mistaken. I'm looking at it from a
> > > high level, both from the software-protocol point of view and the
> > > hardware-electrical point of view.
> > >
> > > XFI and SFI are electrical specifications only. They do not come
> > > close to specifying the protocol. They don't uniquely specify the
> > > baud rate of the data on the link. They don't uniquely specify the
> > > format of that data. You can't have two "XFI" configured devices,
> > > one using XFI/10GBASE-R connected to another using XFI/10GBASE-W
> > > have a working system.
> > >
> > > What I might be willing to accept is if we were to introduce
> > > XFI_10GBASER, XFI_10GBASEW, XFI_10GFC, XFI_G709 and their SFI
> > > counterparts - but, there would remain one HUGE problem with that,
> > > which is the total lack of specification of the board characteristics
> > > required to achieve XFI electrical compliance.
> > >
> > > As I've stated many times, "XFI" and "SFI" are electrical
> > > specifications which include the platform PCB layout. The platform
> > > part of it needs to be described in DT as well, and you can't do
> > > that by just a simple three-letter "XFI" or "SFI" neumonic. Just like
> > > my SATA example above, it takes much more.
> > >
> > > --
> > > RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> > > FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down
> 622kbps
> > > up
> > > According to speedtest.net: 11.9Mbps down 500kbps up
> >
> > This conversation started a while ago, when I tried to introduce XFI
> and SFI
> > as valid compatibles describing the phy-connection-type device tree
> parameter
> > for some platforms. Alternatives are "xgmii", "usxgmii" or "10gbase-
> kr". I can
> > no longer use "xgmii" because at least one PHY is rejecting that as a
> PHY
> > "interface":
> >
> > 	WARN(phydev->interface =3D=3D PHY_INTERFACE_MODE_XGMII,...
>=20
> Hang on, so because a PHY driver now rejects XGMII, you're saying you
> can't use it. Let's have a look at what XGMII is. It is a four data
> line interface using 8b/10b encoding.
>=20
> Instead of using that, you want to use XFI instead, which is a single
> data line interface. The encoding is not defined, except by the
> underlying protocol. In the case of clause 49 Ethernet over XFI, aka
> 10GBASE-R, that is using 64b/66b encoding.
>=20
> You've gone on about DT describing the hardware - and yes it does
> that. Describing the PHY interface correctly is part of that, and
> that includes the number of data lanes and the encoding of the
> signal.
>=20
> So, if you were using "xgmii", and now wish to use "xfi" for the
> _same_ hardware, something is very very wrong with how you are
> approaching this. The two interfaces are _entirely_ different. If
> it is four data lanes, then it is not XFI. If it is a single data
> lane, then it _may_ be 10GBASE-R using something _like_ XFI
> electrical levels.

You could have saved typing that much if you read my previous statement
about xgmii being used incorrectly there. See:

https://marc.info/?l=3Dlinux-netdev&m=3D157709606631603&w=3D2
https://marc.info/?l=3Dlinux-netdev&m=3D157709607031607&w=3D2

Did you review these patches in the the patch set?

> > Thus the search for a correct value. Reading the PHY datasheet, these
> are
> > providing support on the line side for 10GBASET/5GBASE-T/2.5GBASE-T/
> > 1000BASE-T/100BASE-TX while on the system side they claim:
> >
> >  * High-Performance full KR (with autonegotiation)/
> >  * XFI/USXGMII/2500BASE-X/SGMII I/F w/ AC-JTAC
> >  * Capable of rate adapting all rates into KR/XFI via PAUSE and 100M/1G
> > into 2500BASE-X
> >
> > The SoC that connects to one such PHY can have his SERDES configured in
> XFI
> > mode, using something called a reset configuration word (it's
> hardcoded).
> > Other supported modes are SGMII, 10GBASE-KR, new devices will support
> SFI.
>=20
> Right, but, as I've stated several times already, XFI in itself is
> insufficient to describe the interface. What you are seeing in the
> various datasheets is an appropriation of a term that is actually
> meaningless.
>=20
> Let's go over what XFI as defined by the XFP MSA is again:
>=20
> - It is an electrical specification with parameters defined at the
>   XFP socket for both the XFP host system, and the XFP module. It
>   is a fact that the electrical signals reach the socket over the
>   PCB, and the PCB will modify the characteristics of those signals.
>=20
> - Electrical recommendations are given for the Serdes/ASIC inputs
>   and outputs; these are "informative" which means they are not
>   a specification.
>=20
> - XFI can carry several different protocols: 10GBASE-W, 10GBASE-R,
>   10G Fibrechannel, 10GBASE-R over G.709.
>=20
> So, a PHY or SoC datasheet claiming that it has a XFI interface is
> actually an abuse of the term:
>=20
> - There is no XFP socket involved
> - They certainly do not involve the electrical characteristics of
>   the PCB that their device will be placed upon
> - They haven't specified which of the four protocols that XFI can
>   carry is to be used

I agree with you on this, it looks like there is a HW "conspiration" here
to make thinks work together and I assume that if another vendor would
try to build from scratch something interoperable would need more than
what's available in the (public, at least) datasheets.

> The reality is, which I'm saying having spent quite a long time with
> the Marvell Armada 8040 SoC, Marvell 88x3310 PHY, and SFP+ modules
> including spending a lot of time analysing the eye pattern and
> adjusting the electrical characteristics to bring it more into
> compliance, is that this term "XFI" that is banded around so much in
> datasheets bears very little relation to the XFI as specified in the
> XFP MSA.

I'm sorry to hear that there's so much trouble with that particular HW,
we're not having such issues here but we did spend some time making the
backplane drivers work in any conditions for both 1000BASE-KX, 10GBASE-KR
or 40GBASE-KR4. HW retimers do help in some designs (and provide another
headache in mapping them in the already complicated phylib/phylink world).
=20
> This can be seen if I compare the serdes interface electrical
> specification for the Marvell 88x3310 PHY with that given in the XFP
> MSA. The two are not identical; there are some subtle differences
> between what is given for the 88x3310 PHY and the XFP MSA for the
> "Serdes/ASIC" test points A and D, but on the whole, it meets the
> "informative" "recommended" parameters given in the XFP MSA for XFI.
>=20
> That doesn't mean that it _is_ XFI. As stated above, XFI could be
> carrying 10GBASE-W or any of the other three.
>=20
> In this instance, the PHY only accepts and generates 10GBASE-R over
> its "XFI" interface.

It's the same for us but if it were to support both, selecting one versus
the other would be a SW configuration decision, the board would look exactl=
y
the same for both options thus the device tree should be the same too, not
changed according to the SW configuration scenario.
=20
> This is my point: this PHY, which uses "XFI" through out its datasheet
> is actually using XFI electrical characteristics _with_ 10GBASE-R as
> the underlying protocol (because this PHY is designed to be an
> Ethernet LAN PHY.)
>=20
> To see how silly this is, please read some XFP module specifications,
> which are, after all, what the XFI interface is there to support given
> that XFI is defined by the XFP MSA:
>=20
> https://eoptolink.com/pdf/XFP-ZR-1310-70km-optical-transceiver.pdf
>=20
> Here, we have an optical transceiver with an XFI interface which can
> carry any of 10GBASE-ZW, 10GBASE-ZR, 10G Ethernet over G.709. Each
> of these is a different baud rate, and requires the XFI to run at a
> slightly different speed.
>=20
> So, "XFI" is nothing but a mis-nomer when it comes to PHY and SoC
> datasheets; it is an incomplete specification of what they actually
> support, which is 10GBASE-R with a compliance with the XFI Serdes/
> ASIC test point *recommendations*.

Agree, but the same XFI is perfectly suited to denote the electrical
interface in the device tree.

> > You say this is not sufficient, and it may not be, but for this PHY and
> for
> > this SoC pair in particular, it's all it's needed. There are not that
> many
> > things to set up in SW but some things need to be put in place and a
> > indication that this mode is used is required.
>=20
> So, let's do a thought experiment. Let's say that we adopt your
> proposal to use "XFI" for this instance.  Great.
>=20
> How do we handle 10GBASE-W over XFI when that comes along? That's
> still XFI, but it's incompatible with _your_ version of XFI. "But
> my datasheet says it is so it must be correct".  Yes, it's as
> correct as your current usage of XFI.
>=20
> And that's my point: XFI is not 10GBASE-R. It is not 10GBASE-W. XFI
> is an electrical specification which may be one of several different
> protocols.

Indeed, I could not agree more. So we need to describe the link as XFI
in the device tree and find ways to configure the protocol used on top,
if required by that particular device. I know my "sufficient for me now"
stance is not going to help that case but as that is still hypothetical,
we may decide to deal with it when it occurs. Or build something new,
that splits the electrical bus denomination from the protocol used over it.

> To properly describe it, you need _both_ the electrical specification
> and the protocol specification - but manufacturers omit that, because
> it's implied in the datasheeet.  If you're looking at a LAN 10G PHY
> that says XFI, it is actually meaning 10GBASE-R over a link that
> complies with the XFI recommendations.
>=20
> If you're looking at a SONET OC-192 device which has an XFI interface,
> it is actually meaning 10GBASE-W over a link that complies with the
> XFI recommendations.
>=20
> I hope this finally clears up exactly the point I'm making.

So we do agree on the problem but not on the way forward. Let's work
on that.

Regards,
Madalin
