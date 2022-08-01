Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0158A586CA3
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 16:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232283AbiHAOLb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 10:11:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232452AbiHAOL3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 10:11:29 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2072.outbound.protection.outlook.com [40.107.22.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E80851F2C5
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 07:11:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AW2NQLyqDPfhkZFPvwxcM9nnMlCOj4qF7KqZ2bAJeSaiFxrBJKfTyEpmypP3Zfgu7PYSLryJM/DmOOgZuhVSbhgndA1k/VfOQqKFIR3CyfBICis/zTlkndNHB54tN3sG9UhIhU2srQ1SHGgsBwDh5NX393uK781+cLcKshttMb6Ki3OVicOP492TdkkF1TilsdvVPNrMgNNQ0+ydZp8yxAsK1B0z+HabhVrIKsj9sUays+a3rsR6VZRS6ReU96nurHsBYe+RPWXrpB4Unqyi/ufqJ740p3r8SssCXOh7N7AiwN01IAgmEYglJsB0CuoagRgARkBrfGoQJ5maQUAI+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QwFDZc/g1/bGJO94nFd4IZ91ZHolvX3v8+kiSQvF1lc=;
 b=I/6Y9ffOWlKsBBQcArK0EhpYRYnSuQNCQgCLayBpCZgKVtNZvaM5828H9nhMkpstSMeHQxLTrN9s+zT7a9v8JEO4T++I2GldjG181A4tczXVmAhNEqJJhzbClwUQwmRxm53T83qWTGWhF4fJ/ombbwZ4p6mXadV27dk76+aQIEbr5wc4zKMdvZGq60sAPhk+7lqgDR7ztquyY/6Fntvngyrfvnrqn+L3jNWd1R6xGMWd4+JHmKp7NZSl82IlQ2leC4MZR4bR8aU5ItPFbmwxJBMu8Mp+yO854RJWKvnitziA3u8WkjpF4EAAcf//LJQKPxbAXQzxiHt6C0ARWPHOZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QwFDZc/g1/bGJO94nFd4IZ91ZHolvX3v8+kiSQvF1lc=;
 b=OrrXUX7kZXy43i/OaR/EZkZ61Zm3T8USH3blRJNBbi2H3w4+khnxgOs0xaPp2CwqreUhq6gUhsOsiEWTUciFr6X3kx6dT5tsH7gS9g8NfS95STGPDNn4leLllZgEg6XSUG1JMrqQGyMqyNo1cWidmxsnGCMh7zuZXR0fSqFJRdI=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU2PR04MB8550.eurprd04.prod.outlook.com (2603:10a6:10:2d5::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.16; Mon, 1 Aug
 2022 14:11:25 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5482.016; Mon, 1 Aug 2022
 14:11:25 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Rob Herring <robh+dt@kernel.org>
CC:     netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Christian Marangi <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Mans Rullgard <mans@mansr.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Aleksander Jan Bajkowski <olek2@wp.pl>,
        =?Windows-1252?Q?Alvin_=8Aipraga?= <alsi@bang-olufsen.dk>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Pawel Dembicki <paweldembicki@gmail.com>,
        =?Windows-1252?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        =?Windows-1252?Q?Marek_Beh=FAn?= <kabel@kernel.org>,
        Marcin Wojtas <mw@semihalf.com>,
        Frank Rowand <frowand.list@gmail.com>
Subject: Re: [PATCH v2 net-next 4/4] net: dsa: validate that DT nodes of
 shared ports have the properties they need
Thread-Topic: [PATCH v2 net-next 4/4] net: dsa: validate that DT nodes of
 shared ports have the properties they need
Thread-Index: AQHYo04nl4JHZbxuek2HktTJEcy9Ma2ViEaAgAAKtICAABtgAIABbIuAgAL9SwCAAAJdAA==
Date:   Mon, 1 Aug 2022 14:11:25 +0000
Message-ID: <20220801141124.2bhkzqtp36hdkq5u@skbuf>
References: <20220729132119.1191227-1-vladimir.oltean@nxp.com>
 <20220729132119.1191227-5-vladimir.oltean@nxp.com>
 <CAL_JsqJJBDC9_RbJwUSs5Q-OjWJDSA=8GTXyfZ4LdYijB-AqqA@mail.gmail.com>
 <20220729170107.h4ariyl5rvhcrhq3@skbuf>
 <CAL_JsqL7AcAbtqwjYmhbtwZBXyRNsquuM8LqEFGYgha-xpuE+Q@mail.gmail.com>
 <20220730162351.rwfzpma5uvsg3kax@skbuf>
 <CAL_JsqLyCJE2c4ORx-kK1iUMR08iMUMDi0FMb9WeTyfyzO3GKw@mail.gmail.com>
In-Reply-To: <CAL_JsqLyCJE2c4ORx-kK1iUMR08iMUMDi0FMb9WeTyfyzO3GKw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c6d47ed4-597d-4173-5237-08da73c7b836
x-ms-traffictypediagnostic: DU2PR04MB8550:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UyW258mnNSFPFzyyBP6SMChOm2oSXxAnN5c+44CEIIUdy0lEY20ooKkfh7gHlsiusM6l46/l0toMWIdKC2O1q9ymOnX2vWRR+UtY/o1nY47OgP/TNKC3cgTlDoZsYs94U0Zx4GPxBZloC+Wwv2KBHz3H1X+cGHrOtxvkM0PcxuBJ14YZQN78YMd0DU7HL8T2jTXv/hF5eumhmZ4vjRl8o4LPBqom60LO+tA1xY0MvLCF+R8XuUhqom8Mz31AVRBP89w2k2/GZYfXXBMVR9WoFNmd4NdqEqKoFcCarT0txsIWLBluYrTvaaopLVTHyZGfHdVg/mkrpRuWKE5PobAj55jNAwhhV0y/XUE2OnqCJMF07Di0FQY9d65FAQQ7PSNYpdvz3Q+qdDfKA67jRnyl//xsckge4uQZgzVdhZHDZKdOppqagXJ7ivrb0PrMu/xaeZcGwNnkE2BSjomxNqyA8ZmYOEakII/IktlV/TssXOviRBwtJx+eDYdPjXmMKOpHPr7kXz+9mJXzwTNFmfs/FTw0kM0oG6QolaVXogDd6MV6VgJVqsGa9nYkppEz0KR1dG98fSdGeAvq8RXNHFEGEvvIbOm7O8xIMITlxsPZWtk6DJvWANF6Ov+nfqIOKEA1ZMqWt0fFt4XaIikZjIjCmku4mfCfdr7UVtSSWcXGtS+PbTt2zSE5aDPHlSkv4v+Gz3mCF/ZSsJga03FgULOqfnFwdExJUeb8O2Xa35CpBQT7+2fjWT5KGNixijs2xm+dhUCgCSTn7z/UYrm0/8g7gatIL5OTDzASJZeyfsa8xp0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(39860400002)(136003)(376002)(346002)(366004)(396003)(7416002)(44832011)(83380400001)(8936002)(7406005)(86362001)(5660300002)(478600001)(6486002)(9686003)(26005)(6506007)(6512007)(15650500001)(71200400001)(2906002)(4326008)(76116006)(66946007)(41300700001)(1076003)(186003)(8676002)(66446008)(66476007)(64756008)(122000001)(316002)(54906003)(91956017)(38100700002)(33716001)(38070700005)(66556008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?Windows-1252?Q?g59dtru65i3CXPExhihxCtNXUAmqNhyZO15kHk8LG5kcdgUaJDlEnqpV?=
 =?Windows-1252?Q?x4P4J1f3VaMtttTN9X1xN4GrMUhqH59bztgfpBKW6D4fkFn/4GsJmVTy?=
 =?Windows-1252?Q?r2QZ3bjkw9h2fdLvI8Ssu1axvntQ/anJ0zaQQexZGJNSzbqOI80LWiWa?=
 =?Windows-1252?Q?GLLiTT+JjQ2BLYhb9NOWW+SPXthN+WwJUVngOlSqT7KsJ0JsmcvzRW7W?=
 =?Windows-1252?Q?IFibrCVuNrcJecs+v52EuAn7AQ/CzstxAdmxtlVj4/W5i6ZBskUvZDHp?=
 =?Windows-1252?Q?MCq2oj8vIGl30qm1J1ijAHHc2I5FXRpVoLUCDcxH3CZtrV4PZhBgXtkt?=
 =?Windows-1252?Q?Cm35psbP3e0I9p5PnbceYLsn8mNIMim3NzVoAxcemKJt3ntL7KCF67lt?=
 =?Windows-1252?Q?VrwpK+c6Xxv0TGje9cg30ujAVKnGHB8f19L/9UzB0qQm9ZZyYn6pOISe?=
 =?Windows-1252?Q?3W51yHp10yEaiIJzXwCREgvoTDnTQjs8WHF0f5s3J74QIFx0/Z5nBKhH?=
 =?Windows-1252?Q?oA89dKzCevuY6k8qZjNuxkGDMclW6woaoEmaMIyL8dFNk8aXx/+Rgpzu?=
 =?Windows-1252?Q?7gs18Eyx5t0kBtiIHObhSgaF7XGw1r08UQdREQWMNwgBZr17Io0ydMIC?=
 =?Windows-1252?Q?k7MfPcUbl6GWJUbEq+qHnirvVyubwvzK1voA2xkOsDnxE8kzV64X/hMm?=
 =?Windows-1252?Q?C2mIcCnvZyOoHDvDr/blmubDAGUkdC50spfdvZTPZAouuhHrQGcgupVa?=
 =?Windows-1252?Q?DbWsUyIBSYdAXoz2ave2/lSlSRVXzyCZ/46Wm02B93lB8XujdsOWZ9C8?=
 =?Windows-1252?Q?P0OWlvKPcCEEmrB7ENre7cTjdLpK9B5M9B2uLs+ffkaK5T6jxtl8dr9w?=
 =?Windows-1252?Q?q06pPdCxAlWMElAzoAtTbcpM+LJscZgMRW0JFlP/4akuMBEijdjOuy7P?=
 =?Windows-1252?Q?picmzi0yKDwupBe9aIIHSJshMfzGYYEtTrztD4aJB4MVK9NEEo4GZjDU?=
 =?Windows-1252?Q?DIIKsz8MKVRtDUckQDz6+3C63eEuhsrlZi8kyv/5ZwP5tEJGF+aQ0Jrw?=
 =?Windows-1252?Q?1b2O2CLTz92fRU21dcT8lO8RzfZP/rpKgI9346grdvRJUQgvuaA15651?=
 =?Windows-1252?Q?lD9fa2K5wy+Uqyai+76A4LHe/UIee6IssxO7Rk21GZswp9cDynaT0/4+?=
 =?Windows-1252?Q?jkgwJPnutJJAJF9AlC0MTLQIKdEWZ/pvrcN98N0Txp0ppyWDc0OJtVY/?=
 =?Windows-1252?Q?JMkUNeWZrdLPnGwDuUDsGtPokYSNPOjesJY2O1GIpnDJ8ntTYHEdnscb?=
 =?Windows-1252?Q?2TcvpuC2b+S2UiRMAXnO2ceTOSCGiIJjN4bLEAiHAUAAZXzdFaqeEmKL?=
 =?Windows-1252?Q?wyYf61jrVhg/HcZZpAgDUlZRw3hEYFiL7KgtcPFZhwbq7NOWwlFDsbXo?=
 =?Windows-1252?Q?HflKTj1OHToeDhcfLpXNbRSJKoawWCzxqEsj3kIl1PJKfb0hcDSJ9lVI?=
 =?Windows-1252?Q?PHfM311nXBE4mZu1bELOkbrZyDmxzRmjZCp0G7VeChI4+C4ebvvm5XpX?=
 =?Windows-1252?Q?1VHtMQqHsb9NqzdrVLqBviFzwgFTiDrbfwrhGzlukqn5FZS0lNDGuJYK?=
 =?Windows-1252?Q?4erT6M6P/ZqDdFNS4aT5nOZOkiif8hD0nwEybqZ9t2zK9gXfwFQJXZ31?=
 =?Windows-1252?Q?2IIdPNrhsxc3C+A7k0ddS7Knagjx+c2V/YMXDFeGigxWLEG6Nje/1A?=
 =?Windows-1252?Q?=3D=3D?=
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <9D8BCA3ACB06184A8A9EC960DB9E2BBD@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6d47ed4-597d-4173-5237-08da73c7b836
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Aug 2022 14:11:25.1975
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: i53aESs43R6XTk9Jf9mp9oKuWZ1yf8l7x7U/dM47LDsqY4OsN1y660oOwSHjd7jBoBFNOMmg1c9ruCg34R0NTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8550
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 01, 2022 at 08:02:56AM -0600, Rob Herring wrote:
> > +if:
> > +  oneOf:
> > +    - properties:
> > +        ethernet:
> > +          items:
> > +            $ref: /schemas/types.yaml#/definitions/phandle
> > +    - properties:
> > +        link:
> > +          items:
> > +            $ref: /schemas/types.yaml#/definitions/phandle-array
>=20
> 'items' here is wrong. 'required' is needed because the property not
> present will be true otherwise.
>=20
> Checking the type is redundant given the top-level schema already does th=
at.

Excuse me, but I don't understand. I verified this and it works as
expected - if the property is present, the 'items' evaluates to true,
otherwise to false.

Could you suggest an alternative way of checking whether the 'ethernet'
or 'link' properties are present, as part of a conditional?

> > I have deliberately made this part of dsa-port.yaml and not depend on
> > any compatible string. The reason is the code - we'll warn about missin=
g
> > properties regardless of whether we have fallback logic for some older
> > switches. Essentially the fact that some switches have the fallback to
> > not use phylink will remain an undocumented easter egg as far as the
> > dt-schema is concerned.
>=20
> dsa-port.yaml is only applied when some other schema references it
> which is probably based on some compatible. If you want to apply this
> under some other condition, then you need a custom 'select' schema to
> define when.

No, this is good, I think. I got a "build warning" from your bot which
found the DSA examples which had missing required properties, so I think
it works the way I indended it.=
