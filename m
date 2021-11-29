Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8817A4613B8
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 12:16:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237081AbhK2LT2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 06:19:28 -0500
Received: from mail-vi1eur05on2130.outbound.protection.outlook.com ([40.107.21.130]:12672
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234260AbhK2LRW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Nov 2021 06:17:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oUDxpyAKJAWm/yvX047wk72EE3CK1Yn680+LdxkArnrlCO561eUxKpfTvAjKR/nUIvyS4PAE78x4Gin09289AKurS4bVUtgQnGq3GeuhqnbNeldy9TfDlRP3+s1SPR5a6S2mV0XGN7yZuQv+EIsmwFId21ZRHhtj6yMqfeagMthz8eQ0JUV+S3QuzWmyV2teq60iQ06pkGRahWa8l5SEhEsJq9h7JKUlpfgOs9Tbnc9NwaN0tb8YN0W4/I30ZA+A2Rp9R20BkxDdADN7hi2nCwcoBKxY94DaZYZqSlF3Nq0hVweFJTpLG+iiJuAxQwrx8ocEzE50Mx1cXChd+z6LXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s+j8bXnD9jI7MoCEvfr/CHYlneFyOZmOse3JcPQNXrI=;
 b=nteHt+nP50j6b9gATji7cWd32b5GsGP2ScAEDoLyoRgZKfPGVuMuYh3O3BP7OThTw+dtjyG3Dh9Wl/KLU29g7pYk1B4xVAaxV7KxBPDSNBAeUOjIf1OM23/pLbq0dQab3Lrtbk88wBrfkRoBeApxQARzEKqcBDbrG+gPUMoqKhkiQ7pGevg35WY96870ZnWgWwPnOkPDI49OeBS07BoryCaxMKAqqMhKs8cPUmeg2i6suTPvm2lyIGfrp8j454wNE4a/p6+jIHH4QRyYhx5fX8sZB8A7jO8ZLiDm9ywfia0zhi2qM7S4qapRhYh4VCSVf4yELIZ17ol/Spvup6DJPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hitachienergy.com; dmarc=pass action=none
 header.from=hitachienergy.com; dkim=pass header.d=hitachienergy.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hitachienergy.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s+j8bXnD9jI7MoCEvfr/CHYlneFyOZmOse3JcPQNXrI=;
 b=zGny9eIUSBhsOQsH1og43kGa71oA7p2y/iI5FmmJBry3gWRXu7IlsS0M0Az0ROT7+1MnRRPu74lHvhHo3xOEFmKNPYBXMSEtcldNxGTPcGa0AKEIK3IxtNWMNpaYQYOAU1t1wc+S/XKZ1BfXUq3MV9lOtqZPxcShtDdZhElH3LpWq2hOebJ5zJO6Sa5ADCSNCSpFEoUsJQVju4aYcvbLzHzfcqpWopCCLj1YkHEbV6Xau+kgnJM/CRjw6wM36lchP5SvH+dSKlDKz4udjhx4rvdT1kaLsepdOrDayf3L7yohnnadVBzwjVw0nR/ynHDss4FO6hfnob+CfcJAiHC54w==
Received: from AM0PR0602MB3666.eurprd06.prod.outlook.com (2603:10a6:208:2::19)
 by AM0PR06MB4657.eurprd06.prod.outlook.com (2603:10a6:208:f4::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Mon, 29 Nov
 2021 11:14:02 +0000
Received: from AM0PR0602MB3666.eurprd06.prod.outlook.com
 ([fe80::845d:9ff2:f8d4:779]) by AM0PR0602MB3666.eurprd06.prod.outlook.com
 ([fe80::845d:9ff2:f8d4:779%6]) with mapi id 15.20.4734.024; Mon, 29 Nov 2021
 11:14:02 +0000
From:   Holger Brunck <holger.brunck@hitachienergy.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        =?iso-8859-1?Q?Marek_Beh=FAn?= <kabel@kernel.org>
Subject: RE: [PATCH 1/2] Docs/devicetree: add serdes-output-amplitude to
 marvell.txt
Thread-Topic: [PATCH 1/2] Docs/devicetree: add serdes-output-amplitude to
 marvell.txt
Thread-Index: AQHX4txSwM81RW540k+M+AG9/TKpIKwV+yYAgARaK0A=
Date:   Mon, 29 Nov 2021 11:14:02 +0000
Message-ID: <AM0PR0602MB366691E7FAB1C546B3E8F832F7669@AM0PR0602MB3666.eurprd06.prod.outlook.com>
References: <20211126154249.2958-1-holger.brunck@hitachienergy.com>
 <YaEHePSipJPoC9yW@lunn.ch>
In-Reply-To: <YaEHePSipJPoC9yW@lunn.ch>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-processedbytemplafy: true
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=hitachienergy.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1e48de15-b085-49f8-acd5-08d9b3295991
x-ms-traffictypediagnostic: AM0PR06MB4657:
x-microsoft-antispam-prvs: <AM0PR06MB46574550D9C87C03E7B35BF5F7669@AM0PR06MB4657.eurprd06.prod.outlook.com>
x-he-o365-outbound: HEO365Out
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FNWw+1a1UrDej7SKsPWvOei+5PqSQwkuHRsjekGTfZrRigYIDJp+DB6ZAxSDQRc7ZSYs8/0D4Rp2V8siWDbOc5wSdBmMW4ThP/Hhf8TmBijzeMN59d4xHIdT+yU68n5SaP4ReCud369nqFtz1RQNDad6XAvXVqPgHFfG3xI7q3v01YpOWS9CTr7ZOhHfAmqSCWmT/IRax3mdRstDAAJ/UiKuweakyKdwoYPluijF+dU0Mn2M+Dk4o8TxD5C3a0gS+B8gBUsCBhjS8x9Fdtaj8WRiEg2DIxUAgXyE9HEZ+ICMBY5rzN2DI5vs4beW3QA+E1/fjyC4qPTOhH3OC1D7Pzw3XhZJ0LL5Fa0LJ77H2ui4ANELU7DL5qLZfHtAYhWyse1JLJk40eiyfGZP8d8dkv56r3Xelrp4d+37eaf6HdR1CU19R7vjaT0Iswqgxle26nzYXuraJk1sUJQoiOWOU4yS8V6r1nYeWCe8Agc8K2Nnw5BjcrZlnRYTQlk8bd4EAJos8rorA5CIv5H39QMft5CPpqlpea27WGPryfqvd7cQliYFVKgAFlWjQADjNrG6X5nAS6DfVhcytLImiSSmtQtdhDQoLKO7GGpcVJBqP93iHgcP1hVM46mKOJZbenX0F4Nbm1aE4pRYbRkJ7+dOrMK4GBRlO6QDH/u6ZY+2GmCzXSP6ysToNny1UslWBUGU/kJqM9Auy0G8rKFSjHSmWg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR0602MB3666.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(76116006)(26005)(66476007)(4744005)(508600001)(6506007)(66556008)(64756008)(7696005)(33656002)(316002)(66446008)(71200400001)(86362001)(38070700005)(52536014)(2906002)(66946007)(122000001)(6916009)(5660300002)(9686003)(4326008)(83380400001)(82960400001)(55016003)(186003)(8676002)(38100700002)(8936002)(54906003)(44832011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?oxExCOcTguCCUFmXplyclBL9hhTw28ARJZRUIMKFxaaUStOCg33KF7LDti?=
 =?iso-8859-1?Q?Zba74pvw2IwF5AB/K1kw1IWU5HbLtFKyhDV/vO4y5utvi8uT1POK2n4fTF?=
 =?iso-8859-1?Q?bY+AaSWDIflr0ThfiponYaJeLwnuftjC4hewUxqEMh54+IWN6QEUyL6bgI?=
 =?iso-8859-1?Q?fKpkxO/lpQU0R047zBvEZPn+5MPXperzS65ck/kOHmM2/KShjX2PudIkH5?=
 =?iso-8859-1?Q?AWXR3Yi+gYonqqy6/YNx6fsbFpb7LdUIoy00rGZLmyqZk5s5T8DfDZAg8j?=
 =?iso-8859-1?Q?r/bFoGpMi9DK7n1D8ffmFKmhrhqOMB0Vqljst8gFbXTTbgbDJaRyx8KswX?=
 =?iso-8859-1?Q?+WCAyCTOwHoidsiDbl+PrYeBhJfySktlsYwZhwFzQ7trV6bMnCNGodRv4f?=
 =?iso-8859-1?Q?unhtH0ejIA09KcpO5oIGJ5yM4HQpa/pkYQDaZ6nwUDj+FBCS4QAjgBhRSC?=
 =?iso-8859-1?Q?PCkcrNDxs5kJCIgnXsfv+kvlzzUP++Y2uwyL6wcyqQSFDcKvCOB9WG4u5R?=
 =?iso-8859-1?Q?a7pBp/08mqUbVLGThpzbmzMGy7F7PYgJxQ0/LhVqvPnQGk8a1nhkC5H6Kl?=
 =?iso-8859-1?Q?bU7rUCJ9ca8R/WMySZC86p1cVU5qXMaFXTKTzjrfAJBjs7HrnoURRiZhTB?=
 =?iso-8859-1?Q?euokiEU0f8ewl4BZB3/q5qlRRkkn74Q6tQZMdZgkHb+uqohrlTElZdWrNE?=
 =?iso-8859-1?Q?Fskrusigl/O3z5/S+QWi3jmZ1nfy3+GwI51KSPzGsMRlGT19JLrCyT8Dp1?=
 =?iso-8859-1?Q?MQI4LKihIhwJP9z5hxFU5w4J6Zb8ZLAdryE92JcxVesjHr3e15BV92G2yq?=
 =?iso-8859-1?Q?QT898atgHv/oM6pU7GYS1P1vZzTQQY47U0yXBqg93Nx4J6RRgwegaAxk+b?=
 =?iso-8859-1?Q?lsZf68iOqMBbWexkHrFu/rhfqy/Ppv4sYbBB9uFWrLUKfo63hfLCpEsdJ+?=
 =?iso-8859-1?Q?hznvvSAZ6Y2bZGKwqK4Z+lihSs8rnW6LDISiosNs2tBEQD1Dm6YvoiERZy?=
 =?iso-8859-1?Q?711kIo0tiBmja1uKDoqX6TAxyILsjXSuWJ6VJrxTZ2n+CQgE7Q7AoNL86h?=
 =?iso-8859-1?Q?UGg0ZH1levfOg1P8fYVfGSK7/dWEPNfhoQuRlItK3ty6ng/C9bAnI+MVVo?=
 =?iso-8859-1?Q?yBEXdxC4i6dSCauX5kKaIqr3fZGeNl9pKhwMouHTBALZCNzBkW0SXJGGkr?=
 =?iso-8859-1?Q?SnUDj+34Z5BGvA+Ai/HAW76eonpUfhFL9zwnQ5AFG9pZpuxzfoXmO9bfor?=
 =?iso-8859-1?Q?DrlCAbKY94OeAlmnHggqWHMmKLVHxrC/rm5zMEWWbX5ztxOwEiDNqcXmjO?=
 =?iso-8859-1?Q?NBZU6+Dk6RnGihPxNHg/hifyxIGfzCqH0J+xCv9JWIs99h3kdugm/hoGBk?=
 =?iso-8859-1?Q?gLHWPM5yt9B++gxb6lIOGlB5ntxRP2myyZ8i4YteXwKCa+ReyprWQT/fXW?=
 =?iso-8859-1?Q?6F3zGCxEW6+K4oUTRR27CIAkkHi7Se7P28zN3sU0ucc9FUABLTXgDbeN25?=
 =?iso-8859-1?Q?/rfFZjp2tXaNIQ0fV/zyOnmC+LcviapjJq79Vw98omsq4+zpMr9C0HzWWR?=
 =?iso-8859-1?Q?/s3ROb9IQ/OWDsuUFiQdlA5rht5StkokYAAR2RjpFZfDM2AfYLHz3ViggQ?=
 =?iso-8859-1?Q?2EDBk1rLbheE/9eXysVxQM6L+imYWUSoX1b5AFphaMhQALlIvWVjWe8uat?=
 =?iso-8859-1?Q?F1m+q/0x+SJRzNrbdTI2XwLBcN7FZqVrR/q6rOMgNFglhDYtBWeSPN/OmD?=
 =?iso-8859-1?Q?l6Xw=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: hitachienergy.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR0602MB3666.eurprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e48de15-b085-49f8-acd5-08d9b3295991
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Nov 2021 11:14:02.6596
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7831e6d9-dc6c-4cd1-9ec6-1dc2b4133195
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hQ/b+FgFZxUIyNTDSdh2mX4pO0tgSwXty1a8bkzfBf+SNAlkJghbuVkHR5d2PjKreM6wbvFv/ixBFAudD7IWxJdXerl55sTtm3Jf5aTaW6o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR06MB4657
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>=20
> On Fri, Nov 26, 2021 at 04:42:48PM +0100, Holger Brunck wrote:
> > This can be configured from the device tree. Add this property to the
> > documentation accordingly.
> > The eight different values added in the dt-bindings file correspond to
> > the values we can configure on 88E6352, 88E6240 and 88E6176 switches
> > according to the datasheet.
>=20
> This should probably be a port property, not a switch property. It applie=
s to the
> SERDES, and the SERDES belongs to a port. What you have now only works
> because there is a single SERDES for this switch family, but other switch=
 families
> have multiple SERDESes.
>=20

yes you are right it is more a port property. So I will try to parse the DT=
 node for
the port and add the property there. But in this case I need to double chec=
k that
the specific port is the one supporting this feature. Not sure yet how to d=
o that,=20
I need to check. Also I will move the parsing out of mv88e6xxx_setup to
mv88e6xxx_setup_port then.

Best regards
Holger

