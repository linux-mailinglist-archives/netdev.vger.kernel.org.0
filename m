Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D8665EF53B
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 14:22:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235166AbiI2MWk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 08:22:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235310AbiI2MWW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 08:22:22 -0400
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2109.outbound.protection.outlook.com [40.107.114.109])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3020D149D2F;
        Thu, 29 Sep 2022 05:22:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N6aQ0jpw431iJLjj2qT/whgRILsi8PwkSn3jOfBfjV4ipDP9pSggqrActWoUxvaTWIvetysBFFqhC7KTZw6FUO8sQ5FBBrLZlThjSzAVThsKrP/fO2wlnT5nUjzko2lc1TQkcjLQO/KQjJlwtntDbfJH1r+4wE/No1vGEsEvro30neDW4HpH9aTdocZfXPjL0nuYxeVlOmveXwVPF08fmQwxBRNHhT68GcX/S9M+yjpdnPoxbLFf+L27dGUT7n/4ipYlIC0vrq4AEGqP99dJAt+/PiKbaXpnQun/dUt5Bt8VN4TAx7Gd3zXUq8nVhi3UCQObNeRxA3oiOMCkIIIaWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aVvoB4+p99z+ZyyN/0CrLuhLEnQQi9Bezoie2Yhrs9w=;
 b=SzJs1PktT4oqYIGPHYY6xYvmVhoE6PRrq/QI2MTvnA5oXcgLo0UMghwDET1FjMOYTGIvi7XJFhyrAW8JADqGMwmdjtVmmXRxah6W4am6p4n1PuMa7DsVWHxlBOwdXyhn7wkrvvP+tFT4CHVUH3goTsKR7vTjhAd9bNPqP4rBvPojXSuu0m7vDGnps3TEb6gvac3F8jkM0/jaIyzgDTvCOuba9XtkwKXjgBWrkMpN6ucfhLqBq/A4VQrfNA+zPMmF4S1WDF3KsJ7XjU8c9i/f6l+RA2401GZU8Lpc6vYlUy7OHoUBF9ffHjqYP0nPyKBNCEAWIXXMQS7MSaPZWd0CDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aVvoB4+p99z+ZyyN/0CrLuhLEnQQi9Bezoie2Yhrs9w=;
 b=T2zzcL90Hy2qIHQZ9BL27PrVXiZrjw+qlpWv0CCqKhYBS9hgEVjkkrJ8+oE/7r6k7yAIAM6SWaN651ViE6PxCSqrPUKKTeKYwvjNZb7ATvsliSnD7IUrlA20K0DpURCkYkVC+2FKr/jFw198EIokrz/SwIYskhBAoUs7hRcTwrc=
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 (2603:1096:404:8028::13) by OS3PR01MB6227.jpnprd01.prod.outlook.com
 (2603:1096:604:e2::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.20; Thu, 29 Sep
 2022 12:22:15 +0000
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::2991:1e2d:e62c:37d0]) by TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::2991:1e2d:e62c:37d0%3]) with mapi id 15.20.5676.022; Thu, 29 Sep 2022
 12:22:15 +0000
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH v3 2/3] net: ethernet: renesas: Add Ethernet Switch driver
Thread-Topic: [PATCH v3 2/3] net: ethernet: renesas: Add Ethernet Switch
 driver
Thread-Index: AQHYzkQbCGZNTw1MNUuaNx/SR8stKK3s/34AgARIsfCAANSngIAAruVQgAB4MACAAQobwIAAeWqAgAGUAQA=
Date:   Thu, 29 Sep 2022 12:22:15 +0000
Message-ID: <TYBPR01MB53415F3D11FEBFFC8BF09FE0D8579@TYBPR01MB5341.jpnprd01.prod.outlook.com>
References: <20220922052803.3442561-1-yoshihiro.shimoda.uh@renesas.com>
 <20220922052803.3442561-3-yoshihiro.shimoda.uh@renesas.com>
 <Yy2wivbzUA2zroqy@lunn.ch>
 <TYBPR01MB5341ACAD30E913D01C94FE08D8529@TYBPR01MB5341.jpnprd01.prod.outlook.com>
 <YzH65W3r1IV+rHFW@lunn.ch>
 <TYBPR01MB534189F384D8A0F5E5E00666D8559@TYBPR01MB5341.jpnprd01.prod.outlook.com>
 <YzLybsJBIHtbQOwE@lunn.ch>
 <TYBPR01MB53419D2076953EB3480BC301D8549@TYBPR01MB5341.jpnprd01.prod.outlook.com>
 <YzQ3gdO/a+jygIDa@lunn.ch>
In-Reply-To: <YzQ3gdO/a+jygIDa@lunn.ch>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYBPR01MB5341:EE_|OS3PR01MB6227:EE_
x-ms-office365-filtering-correlation-id: 9da0e72a-07b4-4147-2973-08daa2153ead
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LUEHUxqc7rexQ5r0MOYiKwlVoMCDZqFlrWmZEOGrGZZIm+EYwRSlxuKbFvJIpE87hNpvZ1/R8oslD/Re0SdXxmU+gK3r7m1BrKEHBjvzYcLwFzv5TyNjEtZjhtFaE7hEguzA0zKObr8IvIbVyGgbzwfI1toeLK4gcf+gfj3FtvgI4bd/IyIOUj0Wuod7fMsxVPz6jetnxARtd3lJ4OEGnM7H9XsBd7+ChbNEFhR/ZQ0tEXH7NbsA0xva/tzWKrWo9urli336FRWkswCLowwQHBa0Vk7GfdaVuHxxrzMCEZCFE8gHuxhk+ryyOK/0N1nAWFohw/IWZK3mMi6aSa3bMi8ukCxnzuLXlsE/EU3ufXMxYG1nhRgL0lWiHw2jOCJpvS249b4Paud+cA7qmXGkCOXViroo+98Ng8y7lI+o04ZwFheqHhEMF73XdVRfaRq3RXYU/35hImfTJF/IjaC19oiI87OGdbDbFjXinYx9ZZi2gogvG+1sVZxYh1vrc5K1dBnVTbdcml3hgBiu8Ol/0Hwm+4kZa/wSxJsKnD7pcm6fcVYbUe996/IaSXX6zqD1EH0GoI+7mlVks5OFfqgYi5HjDQnQjVhXNvGGCFTcCwV93QFsRDwuHxrmNUlFqhz3dkPu7J9wcz1ZXGKmW4XfnEMhkEA4L98wYatdMSnNRd1kxHqMfDkuKzaNzhyg3SKXeB/ZAbqvAk0yrSChwuclNXlobhSqVsKb5rIxP2V8A1iIS6bfFPDHAZFacnG66am3u0V+VLpgyeehJFQV4x6yNY+mMaIqYJ2LvkyWUEGJdakNo8Z0s+dxu89G53YexarL
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYBPR01MB5341.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39860400002)(396003)(136003)(346002)(376002)(451199015)(83380400001)(2906002)(38100700002)(41300700001)(316002)(7696005)(6506007)(55016003)(38070700005)(86362001)(54906003)(6916009)(76116006)(66946007)(66556008)(186003)(478600001)(66476007)(66446008)(64756008)(8676002)(4326008)(26005)(9686003)(33656002)(71200400001)(7416002)(5660300002)(52536014)(122000001)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Nnn3uLGjBo8+S/MX9wxbThVcyRG3xby0PmkYYe9uw/SNlivx7cGFGfoA61hL?=
 =?us-ascii?Q?h64mR72sAxL/YVkMDjbYbnVSte4fhxxgqlIfS99uM/wRqyaoKoRQ4hYnDInJ?=
 =?us-ascii?Q?LO3w4h8LlnhMPRqEumIX52vJwdltMett1aYLjohVyMAmYk5EUfzeDuTWPXOr?=
 =?us-ascii?Q?rptLDF5SSZmdC+7FoqibsXxVYHAefcVQ7duHe5BP/Hml+hGqm5zLxfiPhbo4?=
 =?us-ascii?Q?zi6HBpz64/mhVOop2D0kMpKGDvHYaQTx0DA/KLSWMSc/XSg0kaREcPaTRL/w?=
 =?us-ascii?Q?Bg1TIXyL5Bo48wsbe3NC7C24gZOEJ6pDhPdOvjoOm6Zzmj50sFa+VFquFaJY?=
 =?us-ascii?Q?p6dE+21GXqpB9SaiUmskzA9K1sWXONIGG0vFg/6IyNjMw+zzmZ5UubxKqYJk?=
 =?us-ascii?Q?4JDegbisl1IR4VNAskIzolbsuDYI1ePw9qu3fGqQIXWH7ypNFoz5QBoGxVsC?=
 =?us-ascii?Q?SzhodnroS4NYwaD4wRtMm3pbEOqIBE7dpGdxjJO8w2zd8IbpoViadQphEzV7?=
 =?us-ascii?Q?V5OYP8tLbEmAuLrvDaLt1Li0SF3HNrdmiMUqML3SiFBIzcQ6cn/Rtwdo4PDZ?=
 =?us-ascii?Q?Ib6LqDipiFY2PunmTu5bonLMcmGWfIMoNXSd4rAJtEiSAPquGT59iV4+VMAA?=
 =?us-ascii?Q?qM0VHvE7kuNs2dtQPDk3CtycCobbST5D+mVoWI3QPRRbCamlesKy94Kv84+I?=
 =?us-ascii?Q?naKukv9uC0aHLqsIlN6PkEmNIL8d/D7Pt9QeQ0yEsszqqbDpbygRG0RD4gdE?=
 =?us-ascii?Q?75WtOSeRugMEGGZHoNJ3ZgacR1O2+R3B+n3qw5fvtzKJMDdw4fSSFtxBK08E?=
 =?us-ascii?Q?zlHx3lz07v43Gw6kykLwiBjEGaJlZn6SIrGsAaFm1u514vl3TKNdiYCwYXRE?=
 =?us-ascii?Q?yHBhCiMut0PkuFGFqSbizeUP+HtXbIqqIwgvgH4bJlIqhp5M2X8sUsJ1f5sX?=
 =?us-ascii?Q?YJrxSZQc2BZNGlp0zustzmvQngHUi1SDKK0liLhICY2ubtCBRtrXy3DIvhTH?=
 =?us-ascii?Q?LlLHIjNyfbIyMnVMvzGE3ha034srDtF+Q+u4uuFz0I5nBh3jdQYS89N83vxc?=
 =?us-ascii?Q?sPANnjE8EAt39OzTj1hSoD0dPxFkTW+T5p4bfrHVvQ4LPJQhu61XNHlgxz76?=
 =?us-ascii?Q?hf+yaZOmi3XyYCRNQKof7+B18eC5B7Xg90t1MbzmYY8JdbLihUyH6Da02IyY?=
 =?us-ascii?Q?BwmJ8XqRcjQc7gGHNsPX8bQSC0dPjhlCjb6O2I3QzzvzuKGdA06AItlmXde6?=
 =?us-ascii?Q?12tGGyQkbPbxSnxbCYRhAs7yzZgB/PBDG3CNN0UNHr3CkMPast5CVg+JinvR?=
 =?us-ascii?Q?IrW4GVFmyIkmyhgl1lKKsHY/raPr1UYRj9DVSqQtFvQHkpKzpD3z86uzo9jV?=
 =?us-ascii?Q?ffzjj/B7bUWwr+eTXQXMiIjPuf4Tb0RXqISTDGCB+GXM+WhrWEJqo+hP22R1?=
 =?us-ascii?Q?d5TQmm9PhsxCxC45h9cBvkjcC80EMKu/PeFamT26tTECFn7u0l+KA4RozLnb?=
 =?us-ascii?Q?ZsKCzOIVUb2xbvz9Ndhfp6STG6bFx1OcULQxEtAST7K+6DeH7umjQYVulVrJ?=
 =?us-ascii?Q?CagCetdSrEbIH/1IHcM70eSfuAPPC/T/QhDypgiVV5v9pviyomdh1znnpqyx?=
 =?us-ascii?Q?nA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYBPR01MB5341.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9da0e72a-07b4-4147-2973-08daa2153ead
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Sep 2022 12:22:15.5582
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vvG7ZJQGIJKLw/RamVMhkcdAp4nCM1IzvbEZBPJ+e5ROVKbDv8KgWipR2XUas2c/5DCPwCi1oFN3bPiv7pOdhQAR2ckpKGIEEdhKj+NIm7/FvvwI4g2D+nsoXysr62Ru
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB6227
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

> From: Andrew Lunn, Sent: Wednesday, September 28, 2022 9:01 PM
>=20
> > > How do you direct a frame from the
> > > CPU out a specific user port? Via the DMA ring you place it into, or
> > > do you need a tag on the frame to indicate its egress port?
> >
> > Via the DMA ring.
>=20
> Are there bits in the ring descriptor which indicate the user port?
> Can you set these bits to some other value which causes the switch to
> use its MAC table to determine the egress interface?

I'm sorry, I misunderstood the hardware behaviors.

1) From CPU to user port: CPU sends a frame to all user ports.
2) From user port to CPU: each user port sends a frame to each DMA ring.

About the 1) above, the switch can have MAC tables and sends a frame to
a specific user port. However, the driver doesn't support it.

> > > > The PHY is 88E2110 on my environment, so Linux has a driver in
> > > > drivers/net/phy/marvell10g.c. However, I guess this is related to
> > > > configuration of the PHY chip on the board, it needs to change
> > > > the host 7interface mode, but the driver doesn't support it for now=
.
> > >
> > > Please give us more details. The marvell10g driver will change its
> > > host side depending on the result of the line side negotiation. It
> > > changes the value of phydev->interface to indicate what is it doing o=
n
> > > its host side, and you have some control over what modes it will use
> > > on the host side. You can probably define its initial host side mode
> > > via phy-mode in DT.
> >
> > I'm sorry, my explanation was completely wrong.
> > My environment needs to change default MAC speed from 2.5G/5G to 1000M.
> > The register of 88E2110 is 31.F000.7:6. And sets the register to "10" (=
1000 Mbps).
> > (Default value of the register is "11" (Speed controlled by other regis=
ter).)
>=20
> Is this the host side speed? The speed of the SERDES between the
> switch and the PHY?

Yes.

> Normally, the PHY determines this from the line
> side. If the line side is using 2.5G, it will set the host side to
> 2500BaseX. If the line side is 1G, the host side is likely to be
> SGMII.
>=20
> You have already removed speeds you don't support. So the PHY will not
> negotiate 2.5G or 5G. It is limited to 1G. So it should always have
> the host side as SGMII. This should be enough to make it work.

I see.
However, if I dropped specific registers setting, it doesn't work correctly=
.
I'll investigate why removing speeds of PHY didn't work.

Best regards,
Yoshihiro Shimoda

>     Andrew
