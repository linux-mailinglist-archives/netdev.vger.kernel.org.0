Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0307424D69
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 08:48:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233507AbhJGGuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 02:50:24 -0400
Received: from mail-eopbgr50080.outbound.protection.outlook.com ([40.107.5.80]:39810
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231279AbhJGGuT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 02:50:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bg1zm1QGCZAyNEtQMIhCyy+1Ase+0DPnzGo6n2bBSZ7ZrYHzunHirvWpTQmIogyB0XsZlwUQFbwpQZpq+foj6b2nnaFCnFFH1T8AGLOp634rUhQLa5wJ6HWvFKoUf6CrbORn676Tlc+7jpTwxthF1Y3+6Gmdj+G9ljCJwRFaxFXUxA7JclF8tx785VWCyoGAjmYDxk1uHqMIq9CsNkhC65gSK9f68OvsYf960uq4Jw7rYnevDMiaNePlJF7foPZM3tWIYjkJ0OuWRy6qyqzq7FBQ2V21Mj4FMDjviMh50bwR1G52TCMs0EynhIHcMqlGQOL9O+4zAQZRqx7l9hft4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KCD4Y4Z5zYEds1kYyNpzZl0xZ13xfR/7+HCKVSU+zkQ=;
 b=bSgPJVb/odN2rpcevc+G+BrPXSGMFG5k0+tvY3cGV5tcrcGzj4E5rSJsqYQa2bKOHH+uaKFKEWV52voCzsAItvNxZy1WMhBTAmyC7h1BzrBbh39hcqf/QjFvxPHlQwqbMBv4yAu9Fm3NrSp6eEbdCZKMkbDBrkylNX7lyo/mT4ioL8k0TIUxfp5JhtyNkFNauRNSQvNdfEIDet9HLq2HLgWIzpZNhiGtziwYTjJY9jKlSYTxtJM/wBIrKFwatllDi/d2N2D+4I6CF/VChUtNATQyhZ97Xf3vbBP+8VUJUt9u01ly44vCqSyYGjeYRyodnpFfcu4tGBNyu/CJ1fXJ1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KCD4Y4Z5zYEds1kYyNpzZl0xZ13xfR/7+HCKVSU+zkQ=;
 b=eKtAStUPNzA6I89keEdBedsH1IxAQCy08k9KhKBgdnVoryL1JH6Xnz85OmaOLWo3DtJSTau4OPXTJi41CyVaztF4SYjaWy4beOAxvQAVF5EGkMxC/4FXbfxTw+jOg/O2ooy03C+f/tozzhEKRxExKHLytbgMrJID2lzHp0ubHqc=
Received: from AM4PR0401MB2308.eurprd04.prod.outlook.com
 (2603:10a6:200:4f::13) by AM9PR04MB8211.eurprd04.prod.outlook.com
 (2603:10a6:20b:3ea::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Thu, 7 Oct
 2021 06:48:23 +0000
Received: from AM4PR0401MB2308.eurprd04.prod.outlook.com
 ([fe80::6476:5ddb:7bf2:e726]) by AM4PR0401MB2308.eurprd04.prod.outlook.com
 ([fe80::6476:5ddb:7bf2:e726%8]) with mapi id 15.20.4566.023; Thu, 7 Oct 2021
 06:48:23 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next 2/2] net: enetc: add support for software TSO
Thread-Topic: [PATCH net-next 2/2] net: enetc: add support for software TSO
Thread-Index: AQHXuu664Nbids09pUWK+2m6R9okf6vGryiAgABpn4A=
Date:   Thu, 7 Oct 2021 06:48:23 +0000
Message-ID: <20211007064822.hjjr62enk24cp6c2@skbuf>
References: <20211006201308.2492890-1-ioana.ciornei@nxp.com>
 <20211006201308.2492890-3-ioana.ciornei@nxp.com>
 <20211006173021.1a76fee2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211006173021.1a76fee2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 32a08eb1-bf62-4d95-07c4-08d9895e753b
x-ms-traffictypediagnostic: AM9PR04MB8211:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM9PR04MB8211BC4DCBE49A31DB9C3F48E0B19@AM9PR04MB8211.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kWqYIzuweQ3XM+tXjBybNPpgdrlFQmUP+NvVtw0xegvWR6yYBqg25rr4AmNYH/UqjsBD+HPYjC3oFMnIvTth30JAlg5cIqJyB5Ak+lnC2pxjQOxHyV6fWume3YZiahAVD5Xw1Gpk0YwYY3ZpnRSnfA4PoFrI5dbavqrZIXRZobcIzPJthuGQhldbesHuFtg3q5RjB0Eiihaz+c8lgRdx7WvoAWed+N5XYArilRne3nZYfp1Mz7b34L1d9yeduM9JvMHSNiuZHZXRX6wczIGm7Ax9aCykffMbr7PAtvdzji2d3SOLcJrC7c0sFSF4vQdEshjLiP0sqMbBT3bf7Jfb6dvQU83Jtr1Ngz5P4yr+k7pPX11CzaTDcIDsd4GFOF/s1dEVJdjXLgLxK5CRxk6P9QWQuNXF4uwY3lTwgRBS1YtB5zpI7mlAL2JT/WgYIkbROhOOYdNHGrMx6jXJVgi6FBo0XefOqctwRCYWAY/dzzTT5dRX/sVj5PS4u0zxVMwRCrwODCqiasE4PyM+8XXlDYVEqw2WWKLRHQBlsVJsVQHHjVH2IuMtX9eDk2v9d3QDyd2tswuaqFVFO7if8l6XrqRPb6MEE/iJwzILqUmrVh671UHR66bjBPhChJw+sIpkjxdc5QsmNKzTRVVVjvoNoZfbF1IENSORLWK3RsguKpkDe64TPHdBI5Jetj97hiRqoWMZlRMwf/PL1o5w5xkgWQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM4PR0401MB2308.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(5660300002)(26005)(4744005)(38100700002)(71200400001)(2906002)(9686003)(6512007)(6486002)(1076003)(508600001)(91956017)(66556008)(66446008)(66476007)(316002)(38070700005)(64756008)(66946007)(8676002)(8936002)(33716001)(186003)(54906003)(76116006)(6506007)(122000001)(44832011)(4326008)(6916009)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?crsVwQ1W2tKjps/qh8bHx8x5gTgXGuciOgNm+/CUvaRAJk/YDVbkT66uJIaa?=
 =?us-ascii?Q?DbxGK5IddBZxr6OkZZpPmshMA8IZxsK0S3Ay//X32jxL7Y1ksimS6oEyWiZX?=
 =?us-ascii?Q?+YJASxTq5rLTKfydBjJCrbK8zSw7scqIORiLm1VJgs3MkwT320uNZ4kNzDGk?=
 =?us-ascii?Q?yP28/w5W4Qr6dwxpA4B+NCCWBOI6xxYmYTpg1xGUeUib2IvUKlA9et/S65hB?=
 =?us-ascii?Q?vwM12OUg/WxhybxyIwueNWuN37QMiu5BXpg96cCJIVHUBPJ62IL0NAERyPXj?=
 =?us-ascii?Q?rgagG7jToNqhlKNxEckECnCSwP4tFnn6qpVvI1+fUcVJhUr3cPv6xYg/xBVa?=
 =?us-ascii?Q?rtysx8TP2jzD2ccvfBRIPbRCXRsPQiXTYeiTvjno+EDJL637o8FdU8RZiK8h?=
 =?us-ascii?Q?PvgiYGWWjuP3CLE1xMqRmv5/uZf+tuU2bKKyGASn3cuz7aAIMAfQ0L1B8Bv9?=
 =?us-ascii?Q?d/3XdwXD6NJC7cHjiuFecNWKvhniyqylllRK3SKKNISH22J7EA9ZpLM8tMea?=
 =?us-ascii?Q?VmnDRwsQATi/GJyNrp+zlh2jQqwzgSlSQCFWFSjtePDVlTVvv6GV0Z5S5X6u?=
 =?us-ascii?Q?/omJqkfKHbstkAkk6lnNpB3cpN6RrYfiqpXTsfMvl6yJA+IqTk4NLw/FwmJ0?=
 =?us-ascii?Q?bccmhgB2GkHfkAZCosnj7vm5H6PxZjWYtD6dkQlBPcWBmIAAGtSf8tGpY+Vw?=
 =?us-ascii?Q?TmtNcvvTewsEzYh2oQMRBUC6CvXUlXwxHMWODd4b/3YnW6QJO6PDjlPvKyYz?=
 =?us-ascii?Q?QMu2OcBy4yABGOelrIujxN6oysg5SEdGQDFnh9VTeIs6Y5zQXpBl6J7QsekD?=
 =?us-ascii?Q?u3nucveFk2/bJvQeg5G2eqm12+zK2ckkGAwhNZWwtZ6tutBvTbE1mm2PdgGU?=
 =?us-ascii?Q?SpHM7YH5BNANSlbX/0fIfdbM0x4h1CVLQoLk1Br+u9N3q1RslL+xxXhxJMDG?=
 =?us-ascii?Q?uJRkaiIZt0A/JvJO8yDrMCyn1mCpfP7UylJcikIyVgt8fTRJ3IszpeU/c75S?=
 =?us-ascii?Q?AG4JLy4bSvTnxgVFIHPXmYmSGSJAxgni1yRHv/prZPPfNd3hQAS4+21QwJxs?=
 =?us-ascii?Q?FnksPaeay7rSn6CYnCazn2k5xyrLgCDzXKxghfKYNTK8VqpqvLp6eA664fbU?=
 =?us-ascii?Q?7v+loJt1pKehimhTQc35NK8sBUkjbr9BOnTbZRhIEjQdgqF1Ph0UVERtd8Eu?=
 =?us-ascii?Q?WxvvPt5xWYGdlb9I7puDYnzfuXEbGMNpUSH2ilUmVhpZK0Pkr1ieboKmrKwv?=
 =?us-ascii?Q?k0EY1g05ORxcd7oWj8o3E3dsGNkqtBYkWnvaww24sydafOHrAzxJmKDjJQQ9?=
 =?us-ascii?Q?dvah7teu8sU86WquMSTXjPeA?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <10F07B6303E5CD43AA3C7647B8FF8DC7@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM4PR0401MB2308.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32a08eb1-bf62-4d95-07c4-08d9895e753b
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Oct 2021 06:48:23.5650
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Cl3zCmnJvJnasIZCavsktgIM20pZ7JLLMxu4H9/QfuFlBhsc6qz4M5AS3qYn16hgKx3lt2X+UTvkNht1KUiyQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8211
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 06, 2021 at 05:30:21PM -0700, Jakub Kicinski wrote:
> On Wed,  6 Oct 2021 23:13:08 +0300 Ioana Ciornei wrote:
> > +__wsum enetc_tso_hdr_csum(struct tso_t *tso, struct sk_buff *skb, char=
 *hdr,
> > +			  int hdr_len, int *l4_hdr_len)
>=20
> > +void enetc_tso_complete_csum(struct enetc_bdr *tx_ring, struct tso_t *=
tso, struct sk_buff *skb,
> > +			     char *hdr, int len, __wsum sum)
>=20
> static x2

Thanks. Forgot about these.=
