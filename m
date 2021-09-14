Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1635E40B625
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 19:45:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231423AbhINRqP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 13:46:15 -0400
Received: from mail-eopbgr10061.outbound.protection.outlook.com ([40.107.1.61]:26530
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229526AbhINRqO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Sep 2021 13:46:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O+duV7ar79r9eHk92jm2jHe5ekyu2+JR87MS6XuKHfaDj+8QU9R6fPBHmZc8nh/c+X8jUp08/d0GQiLXSm4BOd+kGMTJ7MhaCVOtUm5nog0fpOChpOK2/pwjvBzzB3DBO3qf8MsY4U35X1VJ4z5uKahkEiaEL72SxbS/xwNUpdpgS1iYT9gJ4q0b3qD1aRgwaENtNokWmY7Vf63vViDQo7Ni3bkD3kO35CFJXfAEtDrsIPJq2PNryqvTSrXMEyrWJW/KXqi5vu33W2n5ZDxtETfQxzGGimU8TDv5zKP5qrzUy7vTeLLYLrmdOdAORgHThpt7oQpIpqhs5H8mWkZn7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=dZQP6aW7KizcWZLaoXPtTX2ckJbWq6vEa9Ma6HXcFds=;
 b=HYHMnWu5iteL4bH808HBIK3WeYRUy4Jg9sQtPAq0z+Uk7jEVOeVErilMov+qwDLWMPQsH+QEmjiEKNI3Y6LihBZ/NMWmo7mzVE+S8irg7BY75mn6cyWhWf0i088aFQ5cAZuSBTfOHiYBapS631QdOcO8AnSSaFTsesnROXp5uKYj1Ta2TxDvyMHtqKuqIwfBQrdveckJES/xNPGKkbjl1t4Jg5z+3sqrCj0WGLnHukldumhBuymORK/h9e2tmMhOxlQwDfzNRFuxOUDkBr+N3P7+6sbOqJ2ZLHZnfWi7nJ5hJ6jGitNugaSLcd4L6KcHLx6bGc4BrhFvCNcwUS9iBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dZQP6aW7KizcWZLaoXPtTX2ckJbWq6vEa9Ma6HXcFds=;
 b=qK7azjSlao1RDikGeKQlT+Aw5TfO2Ml1ikZxCHIgkjkQyATOE+ypUl9NmhyUvs2nEXIqj0fKdep/lPr1U6BdVqoqKUXfDhJcT31NX5Rg9DeTqPWg3ZViDabdDWhqxvUAbYTMR66g30sn/uEGn6n+Zl5x4I6jjalobHkp0vz5nRI=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6943.eurprd04.prod.outlook.com (2603:10a6:803:13a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.16; Tue, 14 Sep
 2021 17:44:54 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4500.019; Tue, 14 Sep 2021
 17:44:54 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
CC:     Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH net] Revert "net: phy: Uniform PHY driver access"
Thread-Topic: [RFC PATCH net] Revert "net: phy: Uniform PHY driver access"
Thread-Index: AQHXqAxVhGZiRJqQ+0q4p0VsyQZ526ug3z6AgAAN1YCAAWLygIABIbqAgAApG4CAAAu8gIAAEXoAgAADV4CAAAxgAIAACJKA
Date:   Tue, 14 Sep 2021 17:44:53 +0000
Message-ID: <20210914174453.rq4iaje2ajok2fon@skbuf>
References: <20210912192805.1394305-1-vladimir.oltean@nxp.com>
 <CANr-f5wCpcPM+FbeW+x-JmZt0-WmE=b5Ys1Pa_G7p8v3nLyCcQ@mail.gmail.com>
 <20210912213855.kxoyfqdyxktax6d3@skbuf> <YT+dL1R/DTVBWQ7D@lunn.ch>
 <20210914120617.iaqaukal3riridew@skbuf> <YUCytc0+ChhcdOo+@lunn.ch>
 <20210914151525.gg2ifaqqxrmytaxm@skbuf>
 <CANr-f5zNnywpNxMAmNDv60otqXo2oGKiQpT2BL3VraOZftGc4w@mail.gmail.com>
 <YUDOA9SKfCliXlTx@lunn.ch>
 <CANr-f5yaLZnKwmsT6qpNgXCgm2wYk54f2x9ajuCzSx0as8o-Dg@mail.gmail.com>
In-Reply-To: <CANr-f5yaLZnKwmsT6qpNgXCgm2wYk54f2x9ajuCzSx0as8o-Dg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: engleder-embedded.com; dkim=none (message not signed)
 header.d=none;engleder-embedded.com; dmarc=none action=none
 header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5afa6849-9f75-42dd-e411-08d977a75c3f
x-ms-traffictypediagnostic: VI1PR04MB6943:
x-microsoft-antispam-prvs: <VI1PR04MB69435C9BAB5A4241A993B6CCE0DA9@VI1PR04MB6943.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0A85KvZ6qpYVcK2ulC9yqkfk1qXmCC/EFb3INawho0p+0WHmyBWDJZJerI4VQQueIMkbuGnRM9WE2oZ/VCkAK8iCgWixQiLlYkGWt6vceFCQ2hpOJJU//fyavLXmO/9dD2ngzgwGcQrOXx1kR3HPVpnYI5PlZDW0Zp0nAAc4M42nkMDD/8xFnWJpGxhDhqOITyjHtciv3HI5NfAsp5pTEgV6KhjUMoWBW1cg9X6RjPvon5pfRYJdJ/RWaes7mTzm/ldxl9FLX8NhgyKw34qAwd/scLfC9xTI2hTh4ivt6mIPg2qQiKdPyvCmkkwFzwZkQ+aZMSn1HpCG484AGOjtoUpS33qH1jqXB5dAzHk0tuKdQqolD0RQtaUUR7Usk/wd3NeBaiIrgRzMGZFbwMVAWlE9tkv6WK6yjxbninKL/BO73xck3thYePbpNrUkRSdA6b7fB29tr/dnCY3mqEzIZYQz4/cT1YSphT8EtrXrT4TDBwa4y9tfzHI1GqaLxZKBz6fGXf0HSK8Bh97jLbSRJ1A1vixpk30cvBJUvfrmzlJPlOzHwcavnX++MD1ecuKTnHZZcfZJE1Miv8uiGQaUp83ZhFImc+pOKqnuvg9m58xeCT4TTsswyyNQ/k8TkCKVmnpOjYjRG6ciOXN/cUGatP0i4+AECTiVQikmQtjZ1ezwC/Wv8XMnND6xV3sPuyOnrD1zmV2IyuOHgeTohWX9ug==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(346002)(136003)(366004)(376002)(39860400002)(396003)(66446008)(64756008)(76116006)(66946007)(91956017)(66476007)(66556008)(478600001)(86362001)(33716001)(6512007)(9686003)(2906002)(6486002)(71200400001)(186003)(83380400001)(38100700002)(1076003)(26005)(6506007)(54906003)(8936002)(38070700005)(316002)(6916009)(122000001)(8676002)(4326008)(5660300002)(44832011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?XdsE6CrimLxc0FreIhKR6lOSsb9WS6SJM9PCLxPkv4n1Sghm/G0M7EqZi9rD?=
 =?us-ascii?Q?C1baQG2gscpoLUwvFjfpZilAsxsfsgEwMbMsx1zUhiDM9Ho5GbI6Cok1UMmD?=
 =?us-ascii?Q?M8QbamEUSzo/zXNPkzG7/4d27Asa+6l0+49ePQE1FhyB20ZkBcMdLRy4Jq0Z?=
 =?us-ascii?Q?9tgDKSckcZzMiUIIcu71z1xm31TEKlb1m9msDKtt/PipjQFnzS5zNRReDAu+?=
 =?us-ascii?Q?CpCvaJlp3Z0yJYRRZS7q+zvCcQR0DJRo/p2GCq8RqYFERclw8wCsGI9PLZfz?=
 =?us-ascii?Q?ujksg/ep1e9F9qVhfqE7VrxvRz2cNgXsUVK02NsBQPYsueXFWxmGt6WJD8Qc?=
 =?us-ascii?Q?hargft7Jfmh5ZJuu7gU6SWOUkC4o2cgaZs2FpI+jndqRL98IE8nR6kNDWyST?=
 =?us-ascii?Q?578YdKIqtAqi6V1KptBdQiiu6SDEbbEU7Hnf6mPKcchGkfUXMc6k2kzSchbK?=
 =?us-ascii?Q?FQrm0CeUuFf6JD52Xb+L1IKcSCJsA4WHCiYEM8viM1e5CAXvFexNoz7jpMrT?=
 =?us-ascii?Q?TwMayLg3hjB5ByQTmSpgpZqOQtCLWyilXxcg2AyFboKYlbbXOcT2PJejAhGh?=
 =?us-ascii?Q?ruXGQ+z9sWxZqknWtrhP/Sc+uUKAmCWkRgkOJfh6Ncfs+TLON7OicEiv2+mW?=
 =?us-ascii?Q?Zr3+RN9bhdPtluBzFTP43r5g4/gpxY7PHLk4HsPDiYqY2qUggNJVG+lmUpqH?=
 =?us-ascii?Q?IbLd9+uwJ0KMJ1bdMzpLo0F2KxCAATLLoGS0HunILTAr+gWEMbSDxkEobq9S?=
 =?us-ascii?Q?+5FpaWQ9zNfWkQMmE2VkaqRz7iANjd++Z/PayOsOzXjZnOWoD0/unhHP2LNd?=
 =?us-ascii?Q?IT6DfgIIYguZW5oWDv3LWiAAtjs8ml1Ugl0zPCokkVXElkdwq/8q58ewBOkt?=
 =?us-ascii?Q?uEPbcPEX41BP0nyZGGfhJTusgciWH1g14pxbldJ6j4wvBImTYExmOeT0+VWp?=
 =?us-ascii?Q?RJQaj7PmwpV8gzFO8RNLPCBkzkg87hBnoRp4IPTzE99nJm6YZFn1W+Du25ZK?=
 =?us-ascii?Q?qtasUeDm+pOCBduEq0elwLtr9V4qsyF4rDAqA3JJQdbb12MP5/JWrVs+wcNU?=
 =?us-ascii?Q?36Tnz/DFXuwjF9yEdjB1udbDyhFvBeNYVj+xAv48Fa9lHHckquGK8QJO5q4g?=
 =?us-ascii?Q?pPJI+/vFRIWbKvBTLlnPqA6wJyCyS1tHBQnB6hyOzVMB0DBSi4QUs8sDZkJG?=
 =?us-ascii?Q?GPJ3zE/sJ2XRAnwh0EeiDD4tCk2tEAXnJgrh0d8tm4QY+CYEWxmQMFdVwDxA?=
 =?us-ascii?Q?uhG3kRTjquqUwkjen+mXgdIfXwzV7o6rqZZFXoih0BxABk8pmiSwkRWM/fOp?=
 =?us-ascii?Q?MoNmZfTfycBuYnqQuiWEUWIV?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <CAE23115DD1EE84FAA603DA53F6FDC85@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5afa6849-9f75-42dd-e411-08d977a75c3f
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Sep 2021 17:44:53.9531
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AQu4zEKjVwCxT/GlDq3TGXsDaZ5dOJ0tUSILAH8YQyIsfNT/5NNdLPcmmc2bAdfb20nyUWb1kpj56YrGGtlwHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6943
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 14, 2021 at 07:14:12PM +0200, Gerhard Engleder wrote:
> > > I submitted it, but Michal Simek argumented that dts files of FPGA
> > > logic shall not be part of mainline. I suggested that at least one
> > > reference platform for every FPGA based IP core should be allowed,
> > > but he said that no one is able to test it.  So it seems that you
> > > will never see any dts file which contains FPGA logic in mainline. I
> > > will try to submit it again if anyone will support me?
> >
> > My opinion: If there is a real product out in the field using this,
> > the DT for the product can be in mainline.
> >
> > Reference Design Kits for ASICs are well supported in mainline. So the
> > question is, is an FPGA sufficiently different to an ASIC that is
> > should be treated differently? Do you have an off the shelf platform
> > or something custom? How easy is it to get the platform which is used
> > as an RDK? Can you make a bitstream available for anybody to use?
>
> At least in combination with the board I can see no difference between AS=
IC
> and FPGA. Usually a FPGA bitstream targets a specific board, so the devic=
es
> within the FPGA can be treated like devices on the board.
>
> The reference platform is based on off the shelf stuff (Xilinx ZCU104 and=
 Avnet
> AES-FMC-NETW1-G). At least I had no problem buying the boards.
>
> Yes, I can provide a bitstream for everybody.

My opinion is that Linux has gotten into the position of maintaining the
central repository of device tree blobs by some sort of strange accident,
and these blobs do not really have to describe "a real product out in
the field" in order to have a place in that central repository, no
matter where that might be hosted. On some platforms it is not even
possible to change the device tree (easily) since it is provided by the
firmware, nonetheless it is still valuable to be able to look at it for ref=
erence.

So I think anyone should be able to post their toy TSN driver running on
their toy bit stream described by their toy device tree, and not be too
concerned that they are littering the kernel. I would leave it upon the
device tree maintainers to figure out the scalability concern, after all
Linux took it upon itself to manage the central reference of device trees.
But I do agree that the hardware setup needs at least to be reasonably
reproducible by somebody non-you.

I think the implication of not welcoming this kind of work is marginalizing
hardware vendors such as Xilinx, and their users ending up in a worse
place than if the device trees had a place in the mainline kernel.
I am not a Xilinx engineer nor a Xilinx customer, but I am dreading each
time I get a support request for an NXP switch attached to a Zynq SoC,
just because I am always told that the person I'm helping is trapped
with some sort of odd and old SDK kernel with modifications and it is
not possible for them to move to mainline. So I am really happy to see
people getting past that barrier and submitting drivers developed on
Xilinx SoCs, it would be even nicer if they had an unimpeded path to
make forward progress with their work.

Does this invalidate my point about the GMII2RGMII converter, where I
said that it would be better for all MAC drivers to treat it like a
satellite device, instead of stowing it inside the PHY library with all
the hacks associated with that? After all, Gerhard's TSN endpoint driver
has nothing to do with Xilinx per se, it is only by chance that it runs
on Xilinx hardware, so it may seem reasonable for his driver to not need
to explicitly manage the platform's RGMII gasket. His TSN endpoint might
be ported to a different FPGA manufacturer with no such oddity. Having
this device hidden in the PHY library makes his life easier (at least
apparently, until he hits things that don't work as they should).

So while that is a valid point, there might be other places to put that
converter, which are not in the direct path of the attached PHY's driver.
For example, phylink is the melting pot of a lot of devices, on-board
PHYs, SFP modules with and without PHYs, PCSes, it may even gain support
for retimers, this was brought up a while ago. So maybe it would happily
deal with another off-label device, a standalone RGMII gasket. It could
have a structure with generic ops such as what is in place for struct
phylink_pcs, and it ensures that this will be programmed to the right
speed, put in loopback, etc etc, automatically. MAC driver uses phylink,
the device tree has a phandle to the rgmii-gasket, and it works.
Odd, and may or may not be worth it depending on how much demand there
is, but at least it's an option worth considering.=
