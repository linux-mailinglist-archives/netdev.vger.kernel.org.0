Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF0FC46A1A7
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 17:45:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233084AbhLFQsa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 11:48:30 -0500
Received: from mail-eopbgr80111.outbound.protection.outlook.com ([40.107.8.111]:64838
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232437AbhLFQs3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Dec 2021 11:48:29 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gTW1MNLUrTXM/YmtT/pz6yIA2OTQCcshbCqWM/TVry+oYao/pyOf6xWA1DyOH5vLM4PDeik7qfW5YoAXNoIC5fLPpQa26KbQ6Lovf2onKjkrWAoz1gFfje7tzNDeHCTWVjGU6TxTHGFp1dKKF8cXyr5Up0UJn9BQ/dXF4u05XpEop7jMErg7x686gaHdNj3EHixsAqsbqzmBdWjw2K0L0OWqdaP3x2yfEIKGIQzHbLYgV17PF5hSUfccBKfjhWqn9XmBphIkc/iV9t6zC+7jUhdzxGHMgaw9UYuC7TRzGKe4U8vcy/luETvHViYmfBaPvCA39SamwlRp527X4BgovA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EWPmmFaU/X24mJtKamQprmKF1Z94xY7lNukYCFV4TLU=;
 b=HRVz3fcGW/4U9ZUp++RU+/AaiUUOiQEzHBERRTCKUoqWQCc3mvWoZ0+nrNKBHpZX87zf0cjtL03g9TuPjVxAWEOpKMWoRZR8YM6e3aZDAWgn0QHGZnSeqDJw1ZABIKvzefrGVNcNDGQybmdMtY5DnGBeVGcF1HTDr8iVEZiKfB8CPuDlknmvtKZH1d0Yr9FGbqF80J5Z1T7eLq5RDV5m0zC2jH0f4aaeY01II9zKs7zxQbW9MPQZ8RL8k9bFs0NEfbLeDqely0R4WRQWT0p1IvJzgy0vP3wL6wbj4B9W6qUb5fL14uXenAd7NH4a0hWIKV/3odY5iCY/Ra7kO7lNng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hitachienergy.com; dmarc=pass action=none
 header.from=hitachienergy.com; dkim=pass header.d=hitachienergy.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hitachienergy.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EWPmmFaU/X24mJtKamQprmKF1Z94xY7lNukYCFV4TLU=;
 b=kAK0vvlAnI+MBnZgLQiC94uWbfWu6t7ORGShhTr70xNqFB5QjpfC9bC7hAvwS1JbiBX1n/h2m2kvjMZ7RqqX+sQ94xx51zunkKCmuEXmNZaqPpWx3Yrrx/N9jLjYwBCuwH943uSCTAM/bCd7Oj5q9xSJxpCORP7GCOalLD+TYpOUPl3saPdwnmZRzs9Z5n7rCE9zZ/laBUZ6Dkyh4w/MSlJG8zFNa48YBR5G2bUyiCQHLPD9NBaEYeSu41BuE7GdDGYZ3znkbBmywqWM3x0ejx5KCIFihq0tgsQwryjc5xUCpqt5EI/KcaQv39qdFMuLJqHxJNXf+p9+fJ3Ty7gwZw==
Received: from AM0PR0602MB3666.eurprd06.prod.outlook.com (2603:10a6:208:2::19)
 by AM0PR06MB4515.eurprd06.prod.outlook.com (2603:10a6:208:f7::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.16; Mon, 6 Dec
 2021 16:44:59 +0000
Received: from AM0PR0602MB3666.eurprd06.prod.outlook.com
 ([fe80::845d:9ff2:f8d4:779]) by AM0PR0602MB3666.eurprd06.prod.outlook.com
 ([fe80::845d:9ff2:f8d4:779%6]) with mapi id 15.20.4734.030; Mon, 6 Dec 2021
 16:44:59 +0000
From:   Holger Brunck <holger.brunck@hitachienergy.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        =?iso-8859-1?Q?Marek_Beh=FAn?= <kabel@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: RE: [v2 1/2] Docs/devicetree: add serdes-output-amplitude-mv to
 marvell.txt
Thread-Topic: [v2 1/2] Docs/devicetree: add serdes-output-amplitude-mv to
 marvell.txt
Thread-Index: AQHX51NpWgvnRXtEgEqODDKYaFSAv6we7n+AgABrsQCABlfdYA==
Date:   Mon, 6 Dec 2021 16:44:58 +0000
Message-ID: <AM0PR0602MB3666E770AA7F096AFD71CB4FF76D9@AM0PR0602MB3666.eurprd06.prod.outlook.com>
References: <20211202080527.18520-1-holger.brunck@hitachienergy.com>
 <20211202102541.06b4e361@thinkpad> <YajrbIDZVvQNVWiJ@lunn.ch>
In-Reply-To: <YajrbIDZVvQNVWiJ@lunn.ch>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-processedbytemplafy: true
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=hitachienergy.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7d8b59f8-40e7-4b54-6105-08d9b8d7bdcb
x-ms-traffictypediagnostic: AM0PR06MB4515:EE_
x-microsoft-antispam-prvs: <AM0PR06MB45154B574C6CFCAA4F8A3DF9F76D9@AM0PR06MB4515.eurprd06.prod.outlook.com>
x-he-o365-outbound: HEO365Out
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /5pfflarfUQBchW0mf2LjuZj+dgFyXLGm3FM0HPMQkYdzi8IWdd0ZUKTj1hGGBJTQlz6T6WjLlYM6UTepgLuZ0fCxIRQrs3KG+EF+Qrt12/r87L2Gqpxl+MioeCohhxS2SRJA93LsDq/L0IzKkjzqj1X+Ty5oT6im30vsEobeqIl71bsBp2dII4IqF0EcHhYe23Q+nO39qLaSqktyF4fmJPc/KonFKpFTEthHuFO14/nhxJtFGV5yzsD/z48jhFunkhfN0sEIRecaBReBMow5Bm5GSoV/UbjrTS77RfjGYjshL130xcnLsQLmyYKQQbeQ65xapCobgiyc+S2El4ziJ+BsC+39ANo9neoi8B3LfxgI1E8hYZ5IX7oSK0s8A6gAxehza4HigyyVrffGhaOjTkf7kK9O/tydO29qmvgtTfP7zn51P2iZtpYdxwzQK9GPlXPOLIeybGDujBW/4FF2oD+3NatqhS21UwU8qOliVDXiRfgLb8sSIk22VRAmYHBrfyvLynKLJFqJPRBb0I4qAd+XeEg9VU0nQUM7XNNNVnjup7XShgVBgsTnNJ8PlKdoC3KgJtxVUQv3jGMxeODwxP9H7KUaRDnygsEcQldZeIHfo8pYsHyYvvfphRVeZe0H1hgcxmX5LYM2NZz6rnLobDjx9m3TjIG/0sPSgosfRf5l9PXs25/Clp6IZ+DXK5yWBjY8xfWCRlXu/1xJvYVDA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR0602MB3666.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(110136005)(316002)(5660300002)(508600001)(7696005)(4326008)(54906003)(38070700005)(55016003)(52536014)(8936002)(9686003)(82960400001)(38100700002)(122000001)(66946007)(76116006)(66556008)(71200400001)(86362001)(64756008)(66476007)(66446008)(33656002)(186003)(8676002)(6506007)(44832011)(2906002)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?6UuUHhAE/2y1GwCOlquLZz9JesbRWI0/4K1HF8w5sBMqd6sgy8SELzKetI?=
 =?iso-8859-1?Q?jAlqnlC07uvBxRGZj8DlG8h/iw1vyxj7lURpLmgZQbuFdOBAJywCs5tW9F?=
 =?iso-8859-1?Q?4z49Bdb8SU0WNkccQNYq1o+OY9Nv6jJ7FqSMHBsd5MPXFPANJQoD395w54?=
 =?iso-8859-1?Q?rNohUTcTqWJlxcY+dNhlmAict14y1a4ZIasRoQmjqMfQNru+fbDDgKE+54?=
 =?iso-8859-1?Q?VkcQBu35oV20ck7gviZDuB3YuXhy65U4QeeJOwuHTY/VjYKvA0ogg7IDQT?=
 =?iso-8859-1?Q?+SeiRdilLgC8eKXm5X9aEGnr06Its0tE5+B0kM4jl5DyxFVrZylgPe7XNN?=
 =?iso-8859-1?Q?GB8/JsLG/f7EPi/MknjIeO5tln0gL23ow6TqbuLAKQT8bBBUp5IOm+cr+p?=
 =?iso-8859-1?Q?3FsGH8kzzKrT7x9AuiPE57dQjaCJTtC7sHVhPAtfc6LldqUmTV7xhMEB1Q?=
 =?iso-8859-1?Q?/gmxMeqAoD7+bpKsa+KW1yQpT9MmFGbU77Oq4IqAXJCDu5ocb0Y6qaLq9x?=
 =?iso-8859-1?Q?EupHMABWQYEKVnx7yHvo8mPq/P7INq5zMHNg75Oaz6xSlhfjfaG7eoRdg7?=
 =?iso-8859-1?Q?UJhzJH+y5aHHOcNi+PoqhDAhA3nK7qyIjFeMyIRQShOav4PhSvYVsDqOEP?=
 =?iso-8859-1?Q?6Ud+SRZkpKq5fOSh5TgbMKlOQqJn5OY4upnmZlMVprz92ezpysnzQ4oXzN?=
 =?iso-8859-1?Q?1sbxdjDCCJ5cIOH8rCjQYNrLgHdlQ2zw+H3yU9wLLUW1gM6plX98EfcBpu?=
 =?iso-8859-1?Q?qLbdzSwgIp3dfo3eaL9rZZNn7d1ueGyT3i2NF924bbtqXxJCgjH/QbaBLu?=
 =?iso-8859-1?Q?yHhY3ZUDDXBHw0ymiGmVP2vZ29meYDThj0HqY7YFl4/nBJzm6wC2lxdw2B?=
 =?iso-8859-1?Q?8vfxnutj7mxilJDXeD/xCcQUDr3o+ZQrD74gcoa5xIif3Yl+tz5+T06q/r?=
 =?iso-8859-1?Q?f2djB35B1Ear1S9NIoz86zQ/aARZyB5q/zkndan0h+kbp2bbSPdZr8/JWN?=
 =?iso-8859-1?Q?IwswAgtJas9ENejE6uUlP4WVHvuFy3yaRZmhSW7HnvM9fYjNJ/dInXPnXd?=
 =?iso-8859-1?Q?+RzK6sxT0qXUKQGsDkj/OFGOIuK1jl/Vnwq+1PnD5zLj8xdr/VwF2vVwmt?=
 =?iso-8859-1?Q?3IHQLX69gL6DptDgaitUy+5ncFd9u2Xr0kj4Pg/eVvTRvUav8a/i1oQ3hA?=
 =?iso-8859-1?Q?oc60EG1mUZ3madORO1HWyEUCd8sqBA3cXGZZL1dLlOTkHBvNTuwrxKXiC6?=
 =?iso-8859-1?Q?Yiq2pJEdNm8KL6Z+4hQv17U+UrlamiCMw3yKQmx+6I+ZRbKsMtBqdZKqCl?=
 =?iso-8859-1?Q?oGQ7YQIuvJ6m0yyKdRAGPZvlri6Bz6GLRDko71e18CMnWt36U9rRzcEwri?=
 =?iso-8859-1?Q?RpJKWd8+mSwUGObTYGHV/bGKGz2wBLN/rscNxqlle0glorZVea7v0wat0w?=
 =?iso-8859-1?Q?ATfP6knLwRhtptqO+5QGg7r0Ip4Qx1CCSlwrA9RUX1bEay91eisslAjNyq?=
 =?iso-8859-1?Q?zuR08lzckrMqC+IX5Q+Oy1Ci5lsMeKptqW0fUT/+rcFtwmqi9Gha9WZS2e?=
 =?iso-8859-1?Q?NJCPVzTPRjZ3syStGSCNNuYJe6/mBfs/yWjIFjIe3dUH/NkTNtn9COanMv?=
 =?iso-8859-1?Q?5X3l90VBQaFA/nKa4qvyBz8y+gyBf16FDbzppZfHR16Zif4dojByh7bZ6f?=
 =?iso-8859-1?Q?UpBMC3ERXq3pGaQH+1MLtbjNOQkNRX/8eRml+zJmvCJIIRBlra4N5D/fhO?=
 =?iso-8859-1?Q?zywA=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: hitachienergy.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR0602MB3666.eurprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d8b59f8-40e7-4b54-6105-08d9b8d7bdcb
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Dec 2021 16:44:59.0468
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7831e6d9-dc6c-4cd1-9ec6-1dc2b4133195
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /ZXRLpng+2uombZ0Il4vLBgSaKyNCOA84IE7rs9MBUgOzkVDisXoca4I87NrTEI1pPtXOqGXml0VnhKDolxzBRvTL5JDR56an9YrpEihZWU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR06MB4515
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > diff --git a/Documentation/devicetree/bindings/net/dsa/marvell.txt
> > > b/Documentation/devicetree/bindings/net/dsa/marvell.txt
> > > index 2363b412410c..9292b6f960df 100644
> > > --- a/Documentation/devicetree/bindings/net/dsa/marvell.txt
> > > +++ b/Documentation/devicetree/bindings/net/dsa/marvell.txt
> > > @@ -46,6 +46,11 @@ Optional properties:
> > >  - mdio?            : Container of PHYs and devices on the external M=
DIO
> > >                       bus. The node must contains a compatible string=
 of
> > >                       "marvell,mv88e6xxx-mdio-external"
> > > +- serdes-output-amplitude-mv: Configure the output amplitude of the
> serdes
> > > +                         interface in millivolts. This option can be
> > > +                              set in the ports node as it is a prope=
rty of
> > > +                              the port.
> > > +    serdes-output-amplitude-mv =3D <210>;
> >
> > The suffix should be millivolt, as can be seen in other bindings.
>=20
> My bad. I recommended that. It does seem like both are used, but millivol=
t is
> more popular.
>=20
> > Also I think maybe use "tx" instead of "output"? It is more common to
> > refere to serdes pairs as rx/tx instead of input/output:
> >
> >   serdes-tx-amplitude-millivolt
> >
> > I will probably want to add this property also either to mvneta, or to
> > A3720 common PHY binding. Andrew, do you think it should be put
> > somewhere more generic?
>=20
> Not sure what the common location would be. I assume for mvneta and
> A3720 it is part of the generic phy comphy driver? Does generic phy have =
any
> properties like this already?
>=20
> Here we are using it in DSA. And it could also be used in a Marvell phy d=
river
> node.
>=20
> So maybe something like serdes.yaml?
> bindings/phy/microchip,sparx5-serdes.yaml actually mentions
>=20
>   * Tx output amplitude control
>=20
> but does not define a property for it, but that looks like another use ca=
se for it.
>=20

so what is the conclusion here? Should I add it to marvell.txt for now or i=
s there
a better place?

Best regards
Holger

