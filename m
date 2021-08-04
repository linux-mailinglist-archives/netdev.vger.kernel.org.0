Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 804A43E01D0
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 15:19:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238108AbhHDNUE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 09:20:04 -0400
Received: from mail-eopbgr60077.outbound.protection.outlook.com ([40.107.6.77]:19182
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238061AbhHDNUD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 09:20:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fd3xKAdpvn0c8z/kalOoJ1x5TrDIZQ04Yw3rTcsP4udMnajqmSuc1oMacKHvJP0E92HbBhTajFZrQQ9Nzp9ToaOX+Xac+Gpu0wV98rJ05RwyyQYMiYVCU/ILIprYcpYB6BgtnZQ6IF2aGnL0CrgtjawkX6CWXfNQCkB52iCFzpeOHqO1zYdj37NlDEbIdsRcm/x9270YFhXLfbbIcfwbHuzQNQ7hXkhMNIV7dMkBFy5lMFAG/AV/QeZB4r8xMlZo8nEdrpXZUP3x/eCg+Ybp3Jym+rGNwI+i5oPAUqxeKPYq23gQqflvOtfo6B3IjmfgxDVylK3k4NiZ9Ms/VuH2hA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qE20vOiTDUvCSKzjpl3Ki16FTLJK5NFNkMnnRAZL6u0=;
 b=FG6ajOPSS/EgO+yxPWdo85bRuKfW7fjXK2s1OSh47sQjt8K0aAAIm9ocfUXUwsb6ieKf/lM9nuq03EiO0E5CBt6cIEZ2N6C2N7FZGIRZnT3V7By0PjM407jeemzzXx6oaVYiiPYNHik8BZ0Fh6ehaSjLad8luj7u0Subkhl/9fcO6DuC2zsPFXTr4NcJyN6h1eZXWDgWIi7aN2+W56E8Tvo45YWXFQIeYPoh24weJj2bCDKmF26bg71uaWcjs/dGmGaia+O0GDqnihBnJCgE0OFjdU+DoVlV4PxVarWeYmDaN80+pUlVZSaQCAvyq7fQMzZhvq0lVlD8hxQuP5EEHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qE20vOiTDUvCSKzjpl3Ki16FTLJK5NFNkMnnRAZL6u0=;
 b=peg1i7YKHDWZyWscNPrwWEPsXLd8ok/8dfjjJKgpv1rY3HMQjSB49jDtFViS657nXsTg/ZjCcRJr4LqUzO032o86J3dL+E7KKYAT/TNDvfGqoF/k51TKUWKaIaF/tTUuKvseDMkCjv+YEqOu6JVGDb35zrntfaCi+sD/krOcNAY=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4430.eurprd04.prod.outlook.com (2603:10a6:803:65::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21; Wed, 4 Aug
 2021 13:19:48 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4373.027; Wed, 4 Aug 2021
 13:19:48 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH v2 net-next 0/8] NXP SJA1105 driver support for "H" switch
 topologies
Thread-Topic: [PATCH v2 net-next 0/8] NXP SJA1105 driver support for "H"
 switch topologies
Thread-Index: AQHXiTL25J0k/fljzki7bQxC6Kke9KtjVGWA
Date:   Wed, 4 Aug 2021 13:19:47 +0000
Message-ID: <20210804131947.ctfwqaoohsboxeyd@skbuf>
References: <20210804131622.1695024-1-vladimir.oltean@nxp.com>
In-Reply-To: <20210804131622.1695024-1-vladimir.oltean@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b05bc8e9-9225-46e2-034b-08d9574a8894
x-ms-traffictypediagnostic: VI1PR04MB4430:
x-microsoft-antispam-prvs: <VI1PR04MB4430FC6B1A84F6A3995F172DE0F19@VI1PR04MB4430.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RnXnEWQbvyC+Yl3vgbQuNDITDc+XBjGynzEzpOO41Pl1Gq/gvVSyZ5GdpLZfGPGKBsfFQd450/HQg9lzi3uoamfx8ONIUB77GyE9kcWIPrSefsGyHafnQg5Ynjd4jYGBOKIrLicfwl+qnWd9R9K1jC4fCZ/dTNJ2dPxMX37YgHzNvuEga0kCQz8k5Zmwtwzf7Z0uFrrqSdG/ho2mVWgDdDrIJmTJZyXREuN2OpSnAMfaOiux93N+M7UcOSx5yKGMdfLZKnKgOG+Q28SyByyz50b/utKqTKlHo1DTCdTEJX124DCL03O5Mle7Bf75709uL/sgQsHtqH+HBzvtlLSGX1sco+PoB9E7CdqmQWWcrrLoKyahAPMNDIU3FWtHBrpSoyl4adybIQcfnvqL1uPvgrjcvvLpRMcurvm/I7LAglIzs92Hqc7IEU9d/C3viJNcvGk5czl5txiIdsb8w6Bd09RDbzvnABPpQYAhWXjRGRQ9aCylHlwkE0gU2/FnVuxOsmqRpMmfG8/nlJ1C62Js2nblpOYSt+TTn6vVqJ+5ZU1JpEIiiFW9UxppzofIDDSthNW/lW/xLU4DOqm4148OVEZllSyrCqrPJy+HVJHjbVfcfhFSwl4jTPwTPb3Rj/FQ3UXVunFqgjjte6YtcrvOkcBCWzlG6QCNsfRr7nXCyC0zgQHTYOPUDcNpjY0qgJq6
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(376002)(346002)(39860400002)(136003)(396003)(366004)(6486002)(8936002)(4326008)(316002)(44832011)(1076003)(558084003)(33716001)(86362001)(2906002)(122000001)(4270600006)(110136005)(91956017)(66946007)(38100700002)(5660300002)(66476007)(66556008)(6506007)(19618925003)(64756008)(66446008)(38070700005)(54906003)(71200400001)(8676002)(76116006)(9686003)(3716004)(6512007)(186003)(478600001)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?yRDKKyUoyHabeFFW1y7FHpNFXQXGX0F89zSdQArbNhvdT43weUNMkTpTzKDB?=
 =?us-ascii?Q?HZdclLBCRS0MZvOos/Xu15b+OSD75HcUkmXcQ9fB079sFsS1U9Dc0p6jQXCz?=
 =?us-ascii?Q?J3I3GX+fLyfpTNL4xaaVcS4kEGj1vfIEvQtEOtk449J19HyB/7z5wZce+xAZ?=
 =?us-ascii?Q?7PvsPNIwCzKR6g43ioKYBajp//EHtQsvMhjGB5oI57GiJtaVoWwoMAulTby+?=
 =?us-ascii?Q?h08c5LZjgEM7ybcClXkgxd9E1UifxDKVI6T0BcOcpibSQaRN+KKhUOlIXkox?=
 =?us-ascii?Q?MMxD+KihF/739lXamp0hIH/riUkiuBNunRAdcE+yqceeDaNgqp0mg5j4/X48?=
 =?us-ascii?Q?cy0PnDHm2l/jeRsmpJ6Q62DWJe1iIi/tp5c621dPYIuXSeQLeT7lBpJa1EZY?=
 =?us-ascii?Q?lxKkYUYlW6r7zB1HtCEXG62uytG1XoWqFE0HUrS7Bx4tCIKyoLga1JCRFHbv?=
 =?us-ascii?Q?MjHxpiU+i22shvsM5dN9F+IqekSnSTHVl7acu9XFXt2BBaxIgm8Z93EAffVt?=
 =?us-ascii?Q?GEw+jtZmb7nChgTpb80P0zZoZ57qGs7MO7bTcWLtiXGWdhGx/pnJ43HWzk4j?=
 =?us-ascii?Q?y80EYCIVORe2jnCLo4PsDzzaftlLX5unycV95nPxg7n126M2FKRvfVnY5ygi?=
 =?us-ascii?Q?2I6eiV8Mok2a2loZ9S7dGeXdnjEpe5a8+FrmgyiOvNhqnSz5njwaBMZPiQ9n?=
 =?us-ascii?Q?WQhF2mevulBknROYPZEad7tkc3fLvaXt36S7ldx8YTL6FYS3mc/pk3pbB/yE?=
 =?us-ascii?Q?o3vIzRpilp5DX39jG+2QrtLKgDbDpcnieqaChRBRsALqvJt7azTzfLYbbQ97?=
 =?us-ascii?Q?tTmlywjzf5/xJLpSBjZo4bNiMpgWNQ2kpnS0ORAdnLUOBKXUSZHQr1FNTxQ+?=
 =?us-ascii?Q?9tIQzD4lpwOy3LUj+ZEa2fHtxTRAa+61tERHKlupZwRqldpf837Ay6ZZAyk5?=
 =?us-ascii?Q?yYoD2kuwZm+eSHA/lG+adQEKIhwfOvBcuDUBUV9maqIJdO5Fi/ZU+NG1dZcD?=
 =?us-ascii?Q?oqg/rHZGH0tPXxG/j4dO63qFmJu6pm3iy2767C9v0lbhFdmyyoRE7HE0hn2v?=
 =?us-ascii?Q?r3WpotVB+Ui3TpcC0akicYHVa7MhXhBU0ORUuljbQPKH12C7vJ4Wv4NHGAfY?=
 =?us-ascii?Q?bkDP4k1iEBQ/jj0cuYurjgpsLRLp/b8gKeLzblfNnaZ0EvUcxDqw9bgNOZ93?=
 =?us-ascii?Q?e3PvdgwAguksFoIhwOX5TcELbEufKDgYiG12pSZSW/f3MAqzPDRGjPcwaR5A?=
 =?us-ascii?Q?FUfqwVQy+xNDDKFGTG+rEqXGzcS5mO4+DT3uyLOzpHb9BCRBqYoWrkH4zXNK?=
 =?us-ascii?Q?ILoplnR/Jr8fIqnWJPGkuQAN?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C0258C1669CD584D8E97AC48089E1657@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b05bc8e9-9225-46e2-034b-08d9574a8894
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Aug 2021 13:19:47.8804
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tRq6GHaAgvfIV41Oezc9Izy1k2KEGCBSWESAZe+DznwYpuUYtmzmIgKPipv2EQ5wVSA4mzsQrzVzuF1EqSj8dw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4430
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Oops, I sent the wrong version, please discard.=
