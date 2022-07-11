Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9165A570438
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 15:25:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbiGKNZn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 09:25:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiGKNZm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 09:25:42 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2050.outbound.protection.outlook.com [40.107.22.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3420130555;
        Mon, 11 Jul 2022 06:25:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DGCxHXrxd6iPwl+L+RdrYBXSPmTNIFlO/XxU1/QVj/ZSckXH+rgVSMjxuklUmGewc6RAdF+9KaLdqRt6hElJ75RRX7WkCdxYg4GpV0q5NhhrmYtsQvhduvnoVRLPgku9Fo4jQWKwN13VwJW7HxX57nNREVopJSDIaKkdXYty5G840+/l5lpKR7URqwbkciYgUKgKBrs8W8i1OmjxmbxgLuW+cy5Yx+GguDa7qIQjwnvd61J6CoDXIX5Woe6CjfFWS6QrmrIT2gRsG+0BDbFZ/JbxokrjduAdnGpHEp5J3C9ei+i4LYPj4isaxu+ttLB275rzlQvyvMVjdKmRclbfWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tj/GZ1czHmFFyHcYYL9cudlD6IFFOaBoZVhYa5yUnqs=;
 b=DxjYCLM4XTwYLSEzkavAQnim4eKYJNhNTwkEJV7jYmq6IbBu8cO6fDIRQ5cZT/jPicCEDoGoX3Hn61RBxjIXlw8zPAc8oIvK9F9kopD/51l1OEWc4joHS6tVjOqj4eQko8eZSNmglklR1Yj923cnYcMNfxIjGvgqPz7tKHyCvChgTkq4A3zN8lI3UiUdiyU9MQoQo+TTl8OL7EO8JOHf03yWW5HEI8ZI30H9ZfNfovzAF7j8lYi7zXRH5CDcvHBBmKT4WolA4lv5WwJsQKu8vn+pVezJvdtEZRXd++hPQmkUh7+xzTsP38saVvTh8T1vBJfaVuJeVDB2dZHJA7I4lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tj/GZ1czHmFFyHcYYL9cudlD6IFFOaBoZVhYa5yUnqs=;
 b=ZGMRHpKB8r5RQK7RCndQNpNf3cRW4WguZKKeJoi/nYBbbNTNCiBwtrB884Snw2tJP78cmf/2lgao7TXhiEV7A9qIBR50pnDhvwjvtN6MyuT1q9WNlZxIN7tptQstg0u0/0OjffpbOIf4dwbefBcy3UAsQgfE8FZqz01ORgvmj8s=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PA4PR04MB7742.eurprd04.prod.outlook.com (2603:10a6:102:b9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.26; Mon, 11 Jul
 2022 13:25:38 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5417.026; Mon, 11 Jul 2022
 13:25:38 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
CC:     "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        "katie.morris@in-advantage.com" <katie.morris@in-advantage.com>,
        Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v13 net-next 8/9] dt-bindings: mfd: ocelot: add bindings
 for VSC7512
Thread-Topic: [PATCH v13 net-next 8/9] dt-bindings: mfd: ocelot: add bindings
 for VSC7512
Thread-Index: AQHYkLCPeESRsf6drk24j9JaN1oWIq15MgiA
Date:   Mon, 11 Jul 2022 13:25:38 +0000
Message-ID: <20220711132537.gtpf3qunkrzisb65@skbuf>
References: <20220705204743.3224692-1-colin.foster@in-advantage.com>
 <20220705204743.3224692-9-colin.foster@in-advantage.com>
In-Reply-To: <20220705204743.3224692-9-colin.foster@in-advantage.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a722461d-7163-432a-3138-08da6340d821
x-ms-traffictypediagnostic: PA4PR04MB7742:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OWIMaMPf3ueMwZk1N8slChwgtsa0yvUjHOww1al7Zx3peO9k7SPhMBVvrd3RDtpvOuFLjHXoAvgTyXqJS+3mfH7l4dxfORJyqXbhmSFbDCf2kMlCs3130mYUbeFbbvvnAeLmPrz/jKOuyL6yaRsbe0gIeuYbOaAltP1h+cIEe2TMsDhG3gFvMtnIZkxSCBky4rNYocmavfH/958ekVb0FwMNRcD5zVaQsLR+gMgZd3Siz8oEtAJdkfnTbezvRYyz0wwl1As4VPtpJCXXWnFfUyXNt3MFOCcy/RBesN/PZ5n7K/Lb05h7sZ5NVSNpIM6NGMQzj2SVTeYdBMpy3M95hxN8edSE9BXFmER0UCaQva2qAcwFwz15UYDnOHHAL2yGpZovD/FVI7fJQOKDY6Fa/HZPCGz8Pb26R6T/SzpNGG+UptrIA4GBOMbTzKVCOvqjQ7VnU/PrB36AEtxy858PX4lKJTqAoklnsnV6RonwM0UBFlcI1aCGKRv5+W30KU6h/AyKlnjqBLFKxrz/uA0Y9bzHxvfdnQojIjsNDsSgFR9p55JJB9rSa5ZGY6LSn5vhb98YOiPmfjMwZDAJnZhDpBc/L1Z7URrAnDcWy43bcpJl66XtvFwxrcTV25SyGFxbJsb7zc696Fndnu/vVsjfJ5X6mMKqI4XvmULnnqjDiAU7ablJQpXaXLcmTmXqluwOB7i2C3reNp6ZI7jJe9AkV7ZnVzT9bq2ovTzmQSPQ3284gqS5ef/CclmU0fpzu3/XYBqteH1pLEMhrhmQigm+WkDHDm7xBwMSDbydxvNncMuxNmaBgEEwOZ3Nwv57iWvg
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(136003)(39860400002)(376002)(396003)(346002)(366004)(186003)(122000001)(33716001)(38100700002)(5660300002)(66556008)(66476007)(66446008)(64756008)(6916009)(76116006)(4326008)(66946007)(54906003)(316002)(86362001)(6506007)(8676002)(71200400001)(8936002)(2906002)(6486002)(478600001)(41300700001)(9686003)(6512007)(38070700005)(7416002)(1076003)(44832011)(558084003)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?/hlCYldME/XVEzTZU3Yz+CELznZX2xdm9UkhJsUiN8lHAWAddYtd+hEhUdXi?=
 =?us-ascii?Q?XEZB9ryeXgZT+A018ao4V6gNRG/9LuaKlsZmxnUIAkFfOQ5d8fEeQIrhrDTa?=
 =?us-ascii?Q?OZ/TW8mblTh5TDBFR3XUeTYzJWmWSJujnE/fHWax36CsMz9iOSKKl3Bc3bdq?=
 =?us-ascii?Q?TOfkP7jXR2IMrCGPERhccI0sKeYHh84/o2rkv8zIqXBW0LO7SbxZZo9CmiIS?=
 =?us-ascii?Q?ATiLXpYQvZXpIzrTpGygbR0AmAlSvzHsjnUjceE2bJbQSD2KcIkvP2uBoGdI?=
 =?us-ascii?Q?FJyRX5aKhNAbXLdYyROnRmW8W7nKt6xpGLAjti7Jz9ivh/rHxcDK/3DiegSS?=
 =?us-ascii?Q?zX7Hp87pMwXOtUaa4+gpZy0YiMDVUkf8IR5e1fsboOGGy3gKjs8pNHGVQI58?=
 =?us-ascii?Q?r9YN1mz44P5jQIb+vtCeiSZCKIRqQrkbNG7UWcRUIFSD5xKCYxMefBRqdkfB?=
 =?us-ascii?Q?PSU83bRHpE5B5EbLtZPz1CfTSP6NIgg8htr/xl+uCVPODKQpKx/0XsscTaCX?=
 =?us-ascii?Q?s1ur31YGZ4YMNULkRzZH/eH7bURAWXsB6+JshUnIIzSjpNHCVe/GQMxynjTd?=
 =?us-ascii?Q?AchbQEFajsEfV/gU7PN05ip42iB2Is0lRtD5fLTdqyckKkW+E18SRPBwhGM8?=
 =?us-ascii?Q?SQkQ3MDJDibIAilr838k2VSxrsm9d+PBmtu85sJI2D7tD9AbKYPGnmS69A4y?=
 =?us-ascii?Q?djnszzNzRIj6sU9fzOHT069ttKIOAm+ytoPFG0amvrslcdXCGVj+z7Sr2itO?=
 =?us-ascii?Q?05z5WxLKk1w3XhjF/wnjuJ6GpiUwDtDjSMNOhV/IatfLlaZz7FpBcZWxlkRk?=
 =?us-ascii?Q?9fluBr/a+xdSQJxvhtofVeSkP4YCPNBEQCimEuULAHU5URpod3cXjkKGQ9Mg?=
 =?us-ascii?Q?SIaDOVzX1tpaP+NEs/zH07l2L/3LcLg7VbEIN6aip44rQyZ60tDR6IBN0sQ6?=
 =?us-ascii?Q?V3GZs72QbepaUoRTb9Gu28j3aHv9Ys2XkiP9q4Rja2kUgiGh8hkas8kkOKGh?=
 =?us-ascii?Q?MFDU2lc0/mgPzkbcysDKxF0uv4aYjh1AtxJe82O818Hh39wHxOryX040JHt+?=
 =?us-ascii?Q?TVTROERSjtLJCo4S3k+9+iI/h3py8EB1b3uMTkXoUwbNW/XQswJHYQnI9jJj?=
 =?us-ascii?Q?0+bBbJLikLcHSgBCsELk7NQh8/qkmcEx9PoSm0sffgTa8ckJokIsxWs652Um?=
 =?us-ascii?Q?S/+Y4YrnMKyKETrLIrTittAr0OTYtCw4bQZlcYg14b2bx/cRQ1RujYJM/zg4?=
 =?us-ascii?Q?StFzH6AQoaKD3XAHkC/1yysVx5wxBqv2IL4rLXBNs/nlaOUl5/8v0G8dscSB?=
 =?us-ascii?Q?N5dTASuHUWOZlNdW4Qf//sFxGYIMgfxYQ612fZ6OvZLZf0hHSKGTKcA/3FjU?=
 =?us-ascii?Q?YIUPPBGUr4zUlCbyJHRlnEQ63oMidaXp9uH1WRlsQ5digOlgJMORmjS+MZvP?=
 =?us-ascii?Q?z8QArfTpifEsAJgXp1JNaGf/IGM24iC6wl1XZZsfzh52bS9Knp2Kmplum08g?=
 =?us-ascii?Q?ib3lK4coowANhDIOFY4wCTT1b3vGyWjLGlGkHAp4uPdnaSQSn/NMUW3rWGVD?=
 =?us-ascii?Q?6qJJc5gFJ8dSQD9WXb7keub21z1i3Q20kGdghujWbzcncSPEGU/kyqMNXLRa?=
 =?us-ascii?Q?mw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <01627683CD75414A8C08D9F3F8EA4FEC@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a722461d-7163-432a-3138-08da6340d821
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jul 2022 13:25:38.1300
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Pf3ueIZSm0U2+YZbzutOK3CFV8BpUAPCbPpsL1jCEJeWSzHhIJ7OThk9nABenwAOFb5ZIgRIW442Id/CBpgRvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7742
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 05, 2022 at 01:47:42PM -0700, Colin Foster wrote:
> Add devicetree bindings for SPI-controlled Ocelot chips, specifically the
> VSC7512.
>=20
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> Reviewed-by: Rob Herring <robh@kernel.org>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>=
