Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 526DF42FE58
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 00:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243388AbhJOWuy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 18:50:54 -0400
Received: from mail-eopbgr30044.outbound.protection.outlook.com ([40.107.3.44]:13708
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233190AbhJOWux (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Oct 2021 18:50:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D5YIMcq2RksnPXC/yiUVgLpvk4G3Rhh9cMw9bCrwcYYGK0sHUczFXsW//TXtMZqHuB5gLTwtm8/1zHYxQvK79Dci5P7OlW0E8g4OMpoUIHDrqVcbtqhNDKZr9p+aVx+HSQHUj60WY56niW8EcD2AuKylhLSrfeXmRtbxSjQXdhW7a2xrBSYNrf5F2WPltoP727HWCL55vwewVwjUrf4ifUNLFwbjrNB6rct2Dbv0ogDVeiaBnyj4n8NoNPKIaTq1eVbLKmRGODHjUZeZ+M1SWMrOfrejcWgu5XJia2HetR3S3iyxPnbF+GCb/kE5DnXbGvxTzVGxjVrvK60XszHT+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i/UJNMR80R7jBNdueKP3oeOJvcCOXUS/92AB97P7A40=;
 b=gzXnTy2MWspxMwcbWgLB+A2GqHpalfsLKmU+p8YKe5KrCG2JBRJYbvHwBNLzIizUltXUKAd/YEzPeZ75YObE5giLRCMYphiXk3ZA6/BXhe8/Xx1ccP63YEdPqcR/6DVyxinMnaWQ+V9JeinJCmunlbtB5jIbn3JulWOZGotAkyKD1q4BNwPnXGpqhmcqdhGD08fpXiKZuWZau25zaqFPFPezG8wUdVe9Adh1Ika4g8UvgFePN/ZqDR9GikMJ1XiI0gkDHLHIww2bY03dc9v19wfnqmVvU5kFTIsST0PwlTJF6tQZmjMXhzBq4uQD2+mESvooFQusk5svWfqule6MpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i/UJNMR80R7jBNdueKP3oeOJvcCOXUS/92AB97P7A40=;
 b=DOLqyTJn1kfGOMAev3ymxPb0SQBXbCmcjY98WBAlwCkrUIeM9xp9fM93qzT4YOFB1HJRFGnOZqnJGAhPKIjOCfYDd3Hs0GmdICt4zhoESMXq3nGN0ekbphkvhapd9kxefBnZlEN5/e8ue5nviIn1p2pnJy+YUTq28UwazFRp+fk=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4431.eurprd04.prod.outlook.com (2603:10a6:803:6f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Fri, 15 Oct
 2021 22:48:26 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4587.031; Fri, 15 Oct 2021
 22:48:26 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Rob Herring <robh@kernel.org>,
        Prasanna Vengateshan <prasanna.vengateshan@microchip.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Shawn Guo <shawnguo@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        =?Windows-1252?Q?Alvin_=8Aipraga?= <alsi@bang-olufsen.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 5/6] dt-bindings: net: dsa: sja1105: add
 {rx,tx}-internal-delay-ps
Thread-Topic: [PATCH net-next 5/6] dt-bindings: net: dsa: sja1105: add
 {rx,tx}-internal-delay-ps
Thread-Index: AQHXwIEUbe1x80B4iES4O+HBUM7BYqvSjzoAgAHs9oCAADBUgA==
Date:   Fri, 15 Oct 2021 22:48:26 +0000
Message-ID: <20211015224825.wyjg63uzyuaguewx@skbuf>
References: <20211013222313.3767605-1-vladimir.oltean@nxp.com>
 <20211013222313.3767605-6-vladimir.oltean@nxp.com>
 <1634221864.138006.3295871.nullmailer@robh.at.kernel.org>
 <20211015125527.28445238@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211015125527.28445238@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 254eca45-61c4-4098-b451-08d9902de698
x-ms-traffictypediagnostic: VI1PR04MB4431:
x-microsoft-antispam-prvs: <VI1PR04MB443117EDE61B9377E337DC88E0B99@VI1PR04MB4431.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JQ5Xg5APGHuGg/7EMNokPDhHao+IPnw7/LB8JrnDfuNGsPqhPhGVVytLsDmju75wq3mCju5tlIJ4VJRQDLuxV33dZBXtAPHuw1DmWnhuVqn2YNgFiKQoR82GHZ5MBE9uIQmFEhMxgD0RCa0XCVy/nkTo3Z7cW6EDKotK+9a/IsyplBtmxa0MWuJzZ8gxSHz4yMqUfgYb3TSl0Kyl3jb1s4ijVL1GMtBrPbi5FMSnTKeqrsrITbUOYhgN8SNnIn+WwrxPL+UdT/uny+G7DUmBqpYDKSPFD1EAKm2vhuE+i7um1tKpWMnbQ84/TtJQt2HIXmYhMpWJVLq6d92LnsMKtwOpMUXj62bL1hTzfCGUe+Vk+myx7N/rG4phXD6g7GgozhIRVbvtEgLoTYTLwlJa2xX2clRLRH614Dak6QUxyDchxu6d/eLhIgexXRdQn9gcngoW6vJNNbQ6stdhDJfeg+vRAvF8Hn7hP+MsK1f5BBE88sxeE6JZWNwDHnlW4YY9wkQIqLRvNSR2+iTl0YxyJhS8Npk3g0RW8k1HLHG9/7uksm5ykeMbAxEItHOOiQHR0FKUlAaMYGAMtNiQRG4NF0+B79Sym8sMB31LzpYgOZTKcWtqNcAPQ8G0fk28heYrDvHh2XqvSZZKfY97+gBA1Bt31YMIx7YXc9cSrkemZQRvBSpcsDEGzlBdKSrlhyWY8tnzoHcMDhsp1TGXw0p7cw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(76116006)(86362001)(91956017)(186003)(26005)(66556008)(64756008)(8936002)(8676002)(83380400001)(9686003)(122000001)(6506007)(66946007)(66446008)(38070700005)(6512007)(2906002)(54906003)(71200400001)(66476007)(316002)(1076003)(5660300002)(38100700002)(7416002)(508600001)(6916009)(4326008)(44832011)(33716001)(6486002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?Windows-1252?Q?DDNAVy55TOo8+JSm+oC6TZtYUCTXOoSM98vSPjZjLJxUfHrfRYG4BgO1?=
 =?Windows-1252?Q?DsPM6dj+UlZzUIzdCdnp59FmfZaGUlGRlgS9/0alpHWfyidLnA57I5xM?=
 =?Windows-1252?Q?rz9JpY9yipIW31jjMnUl/2nHjIoD7DuIRD6c091y5sSeEt8eJOeVwZFi?=
 =?Windows-1252?Q?witn6AraBsY1IphlUxITqvIIyxN3/J4obk4iBs3AJqyByFHHXk4VVVzp?=
 =?Windows-1252?Q?yzy9yMUhUFebXwLVXzFodR3DSocSMyCfC0iS7WCj6Am+T8UVOaxV02xK?=
 =?Windows-1252?Q?7ttfeLDbwQHahxfOltZZWl5mikkAT6+1hzkmb70OjEPy+wWIWhACoirm?=
 =?Windows-1252?Q?iu/fAmJVW1IWkS7/ICwOnxuXYbNqS6vGbh25eLkNSU7ZB1IqwxgR8Odg?=
 =?Windows-1252?Q?yR65jPJUuOwkkvFfnQ5LDj9bB6FjTUPObIdvWNnvjT4kyfLIzyY2ckaz?=
 =?Windows-1252?Q?YefNaFkBMun0hFaSDoTRtg630/yTiG8Bd+idYxPOzAWbTJXUriqC13HZ?=
 =?Windows-1252?Q?zjUIDh8nEjrwHrO3iSDQ/jEmviN1OBPtQGT6XMK18fTY5+vO4oTAEFUk?=
 =?Windows-1252?Q?gQWaIQDO2k+O0mbvn5DEshv0iPuwqMD4wgy6Ze/dW0PsYh0xVLIUmLJe?=
 =?Windows-1252?Q?yE3DS38rpHj/2qQtboQzekJVXFW6NiljmRryKTsX3O8fR4VO/mMB2fYx?=
 =?Windows-1252?Q?IRRTmObvb8MZRS1OO8q4tqc5IISyuTu1f+baT9uwjMgJJsdoSBU2hLGv?=
 =?Windows-1252?Q?WVlH/aOb7XhdmOeWQ0eJ309TE8F9GNQbqhnA1JMiGK/VGNNFbUtwEe/w?=
 =?Windows-1252?Q?BYAG6MJZUK06V07pU3qlmRHHt5V+oRUlV9GhieGAs5zcqxHjxP3o0inf?=
 =?Windows-1252?Q?vtcB+sniS5TGekZMnO6KpysG+oBcYFqlmst6bCGszY/zIwJ0ZDJzJX8B?=
 =?Windows-1252?Q?ybsaYE8VZgcGQbbXL9MUMwHLTATHhaxAbHt5dklMOSnDETFLHClF5tnU?=
 =?Windows-1252?Q?ydo9Z1zscb+7Rgj7ju7GCrI8p148t2/GPaKLxrca4RbjR3stywPch0ub?=
 =?Windows-1252?Q?Ntg6+H0U93ngv2AngjxF0J3hrcUagluGIsRUlLSHiqvZ9V5+kg/0VAfd?=
 =?Windows-1252?Q?+NOCLtNlve++T5dJYuinuRg0iRmHHPxz4ysuPka71FxUoD7SCykYtdRM?=
 =?Windows-1252?Q?BiJ018lJMTHofQKFvkry6IBCO0xQLWWUuw/Neju9LLWzR+7Xc8WkIfYO?=
 =?Windows-1252?Q?mU0PmB0EBtGy3MoTgyjRv80IXk8VZBf448jCYx076H1+YkFQPEDO0Uhh?=
 =?Windows-1252?Q?viI783ultjfHvB3mWgo5UYoPntuWX9hWxrJNnlW2Gw5AFoo3a2CopLt6?=
 =?Windows-1252?Q?F+1WEbQGyYbhoPPvHPBGwE/SXRw+q1QLPPqEaM8TY2r37xwMrHvNLbN4?=
 =?Windows-1252?Q?0yN4v9B/AVT2oX/S+7kX7w=3D=3D?=
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <305B9E4A454DDA45A4F132EDE7FC4D24@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 254eca45-61c4-4098-b451-08d9902de698
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Oct 2021 22:48:26.4532
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aA3KdoL6iLYdFZqbl2jXNqpBE8tU65nu+8fjiU+C2ojmU8g+FbhsFj6vXdmaNLIRYFvE7htFlLEBEnzfsMoMgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4431
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 15, 2021 at 12:55:27PM -0700, Jakub Kicinski wrote:
> On Thu, 14 Oct 2021 09:31:04 -0500 Rob Herring wrote:
> > On Thu, 14 Oct 2021 01:23:12 +0300, Vladimir Oltean wrote:
> > > Add a schema validator to nxp,sja1105.yaml and to dsa.yaml for explic=
it
> > > MAC-level RGMII delays. These properties must be per port and must be
> > > present only for a phy-mode that represents RGMII.
> > >
> > > We tell dsa.yaml that these port properties might be present, we also
> > > define their valid values for SJA1105. We create a common definition =
for
> > > the RX and TX valid range, since it's quite a mouthful.
> > >
> > > We also modify the example to include the explicit RGMII delay proper=
ties.
> > > On the fixed-link ports (in the example, port 4), having these explic=
it
> > > delays is actually mandatory, since with the new behavior, the driver
> > > shouts that it is interpreting what delays to apply based on phy-mode=
.
> > >
> > > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> >
> > My bot found errors running 'make DT_CHECKER_FLAGS=3D-m dt_binding_chec=
k'
> > on your patch (DT_CHECKER_FLAGS is new in v5.13):
>
> FWIW I dropped the set from pw based on Rob's report, I see a mention
> of possible issues with fsl-lx2160a-bluebox3.dts, but it's not clear
> to me which DT is disagreeing with the schema.. or is the schema itself
> not 100?

I am only saying that I am introducing a new DT binding scheme and
warning all users of the old one. That's also why I am updating the
device trees, to silence the newly introduced warnings. I would like
this series to go through net-next, but fsl-lx2160a-bluebox3.dts isn't
in net-next.=
