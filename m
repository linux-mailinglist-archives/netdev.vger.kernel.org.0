Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A2584252C6
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 14:12:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241193AbhJGMOo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 08:14:44 -0400
Received: from mail-eopbgr40060.outbound.protection.outlook.com ([40.107.4.60]:27873
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241186AbhJGMOn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 08:14:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j8hTFFQudMytx61r4rHTwM3VdCiaADrZz6c8bfot4ieoczULcJ91kREu4dPaT6xZ8OoKfutHMw3ZbQNLhCjx3mse1UXixepmcGdOoArRv1hhB5STl4VQjG/CaXyQ7gaje6U06KRO9fMXFPJHS9nn/GJY2dBg8i7LBWO0xJ1cf4QzOoRxVGQZpKuiPYdnAZShlomcTtV06ACPMDoAg0JZSvIlYfjSVyOInvFxdu2bFeJFtenBLhPatkQKlZkyn7niQZjgiBDS5g/zmMtsBeHjLb/MjdfqTJMWBgKAD5eD4sS/zcoNlvqBcspBXvf1/3Z9oGnQtOBT4ULcyNI2+dLCrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e+4WgdQlkg8igUAqBPFxEMC1BZCZQvMdk7sQ1V0pbK0=;
 b=GzQWARPFjz7bi98J+RhOFVv+GyYuy4/oojOv/ykDPctGgG0XN6K8pL81tnP0CeRhtd7okA6XnLrr8eWAQC6lOcI8QkubqVla95i9j7EjXFb4N38z6V4JGuSr2kqaGXbSlPg7nJR6hrHEVggFNb+XlZYY83PLt55QM3zlBiDBTX09d2hVxIZf9//Aiwitkt1PBHKQB35EwvGt3dZ5nqBpBabYbJ+rQTDmNr9yzH5Jq2gNxVVePa3G3b+OhhiIGzLz7F1S3LACz4ww0BHEqF04OIQF45ZVIsmY2IUlCqcqkuUQ/tCyspRPkWRb4zb5ywlPtRqTes+mQNjlQ9xlBeMZdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e+4WgdQlkg8igUAqBPFxEMC1BZCZQvMdk7sQ1V0pbK0=;
 b=dx7F++Uq9Yj8KK9GIZGrQrfA2HIq4RLBZ3rHP3Btf4V3rswvPGt6z7xHxZsxxkisD7pWHIltBdSCrgJVQYRhtEdqNLlJp3bhhtSw1D+Xhg+JH34qPkgzpyly80QNzmrpp+SvGws5s8eAhd91b8NSRC3kM/w2g/QTvreljSfUFlU=
Received: from AM4PR0401MB2308.eurprd04.prod.outlook.com
 (2603:10a6:200:4f::13) by AM9PR04MB8209.eurprd04.prod.outlook.com
 (2603:10a6:20b:3e4::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15; Thu, 7 Oct
 2021 12:12:47 +0000
Received: from AM4PR0401MB2308.eurprd04.prod.outlook.com
 ([fe80::6476:5ddb:7bf2:e726]) by AM4PR0401MB2308.eurprd04.prod.outlook.com
 ([fe80::6476:5ddb:7bf2:e726%8]) with mapi id 15.20.4566.023; Thu, 7 Oct 2021
 12:12:47 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next 1/2] net: enetc: declare NETIF_F_IP_CSUM and do
 it in software
Thread-Topic: [PATCH net-next 1/2] net: enetc: declare NETIF_F_IP_CSUM and do
 it in software
Thread-Index: AQHXuu663/E+UlNFGk+PhpftRTMd8KvGrXcAgABrBQCAAFrtAA==
Date:   Thu, 7 Oct 2021 12:12:46 +0000
Message-ID: <20211007121246.pscw27lc4agpcgpj@skbuf>
References: <20211006201308.2492890-1-ioana.ciornei@nxp.com>
 <20211006201308.2492890-2-ioana.ciornei@nxp.com>
 <20211006172418.0293de02@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20211007064720.envusypxkazx6gz2@skbuf>
In-Reply-To: <20211007064720.envusypxkazx6gz2@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7f7cead5-adff-40d0-a5a7-08d9898bc65a
x-ms-traffictypediagnostic: AM9PR04MB8209:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM9PR04MB8209C433A7C3E4003FB190DAE0B19@AM9PR04MB8209.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: d/pKKtRzRjqegUyfpIE+TaH6upPsNNRb3+2C0GTHLa5j9h4UZw+ETcv4u7eY64YtpH9zuDMbGJhAcz8QvR9OK06T3fR2vUH9/1tRFQf5GqvQqzcQMLZbey/0FKeCzXHyC9M0QeIrdNcuHmBAtqtCEfUO5QW8Nv+TkqkN0wYDGo2Wx69XQWAL/+B3O4LL8TRlZP7iI7FcB4Av593Vhfet5Z3LFUPYVxu5RnoMwP+POTPpwSVTc1ZJA58pSqYrvz+p/MfcdHcA7ha0JCEBiFOc6g/rMaHFOyOMr4fREPEjdglB5Pv1Oi+Eacqc+UiETq+Siksp+MifpOjq0eLAJlrUQhm9OeIgyTBior7lgBEV9ZYyCj241HSlTOmJI2nognnSVEmx8w2OQbNZdyhqvAk5+VgphjG0mPMTj+OVfku62GB84X2zKhLgomsf8QGgL8I3fpX4l5ZJtTQKI/AW3n4kxVLfXOTD0cbdYcP9sybCHRhy2oVFO0TTW0DgOSg6QOEFOLCWDkQ6XpClUMahm8e3t9IOCMNxIHkkq9r3l5yHGrB3FBzxio1+sAFzOl1wGfYcJF8IhsSwokaI8j+gEQQlrRuVXrQbyKr8ZeB42U5mXEOJIyJA30h4JNbwyBur9ONePPjbPS4KK9G8qSWLsGJdDj+1Fp1oXMj+X/WKlcp4vy6U+34wz7cZOFeAuuEn31bKRYh6VFxZ/LLDsM15VOYW7w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM4PR0401MB2308.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(6916009)(71200400001)(6506007)(54906003)(9686003)(186003)(6486002)(6512007)(83380400001)(8936002)(8676002)(86362001)(5660300002)(33716001)(26005)(66446008)(38070700005)(508600001)(91956017)(38100700002)(66946007)(64756008)(66476007)(76116006)(44832011)(66556008)(316002)(4326008)(2906002)(122000001)(1076003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?HI/U6WWQrHri43qoOMx0igt7Umt1ASYZuM4X2t81sUvA75w+wS0uWVqmEB1P?=
 =?us-ascii?Q?bVI9So4RwGWlkyLQQWOt6XYDIrEgVhAYJnqem5j/dgQQpxo1PlP3fiZxvHvM?=
 =?us-ascii?Q?8D/JnwPLihlh2hj9P54Zjz63tBdt3btoceFcR1EfQ7WDSV7Xrg5ZvkUY95+0?=
 =?us-ascii?Q?4hDbmbdYTa0beB46raPDRZJFb626asgxF6NIP6sVP9q0JyPYuNm6edYGOP+7?=
 =?us-ascii?Q?bR3LcPxL57Wq88C5Orn6Ww6JRt9V6IVcf3YNb3SCfYgOg2IgkljGUCTkz2Sk?=
 =?us-ascii?Q?ZWULHfsBlhUbtNqTcHD60HYL2fZSefMiRC2ccNK95JOn6QbTW3hlw39NRZba?=
 =?us-ascii?Q?CX2ym60X78EcVzA7XOv4WNMyNIea+7NJtWna83K5BXinJB3e8kEtmrA+b6s4?=
 =?us-ascii?Q?8yCuFpYzOF+BjLDLAtxUr/YTod2IU6MS/L2fYIGolleRnS30PZIZCYS0jLiW?=
 =?us-ascii?Q?aUto5Mmr6b6icxcP7WFEE/PiQytzIUDmKrfL9iBkb4s3YWEMLMFlJIBBmnAm?=
 =?us-ascii?Q?8WyAWucTN4xf63ISscAMb/trSm0l4v8tNcAwjdnYggjiFb6bH25bPNH1eDB5?=
 =?us-ascii?Q?oO3gs5jUTm+hTVdqcOVHcisbxnzh4TPFyvyzpgCzJ88ClJFNCg3PiW3JH++b?=
 =?us-ascii?Q?ZjAX86005ngCQ8aBFiB+Ip36KNi5r0zDouHZyQtTbCcXmJIwXZV96ihmvCpW?=
 =?us-ascii?Q?vG8N/JHKhyeLhbUcwk9IRk0nGTU1KrH/XIjWyhaLrNzdCRt2vxRxnHtWkXcN?=
 =?us-ascii?Q?9F0YUjY+/siRpKD4A3FUlmI/oBPBO+kb7YuURcgHAJyHcYRIYX4DXNA2P+Qv?=
 =?us-ascii?Q?pUB7tk2ZyWqCB05e9RoRZ7uqdS+B0Zm3Phi7EsOAmAc8ZnR9imytDgJLKi1a?=
 =?us-ascii?Q?8MvZs5UUu7Rq/8g049JNiEZUEIpGzdpsg7jm2bU0aC/9DFbKeOuE1IJRbT38?=
 =?us-ascii?Q?7dNcqDu+wrWR9ISUNFB6RMvCuf7RCuKwcTpXkuj6tXecmuTMUd/pLgy+Lvr4?=
 =?us-ascii?Q?01jJPqkRa6LfS9+jbY/lGQNG3Sl5VM1es0N6HIMwaM3347kSacmK+0ve+zEf?=
 =?us-ascii?Q?IkrbCc+i+Ikh98BeOgER6jgwYfW1x/hf5hV02Nu0R1WGsSkQNfxh7fXZLbYN?=
 =?us-ascii?Q?LE91elRywUqGucV6/GfNGzGOq7pYQywBkQ+xdEceZudG1RAb6y/ERfqmdYkD?=
 =?us-ascii?Q?h94OmTbWbFxudZEW48M4KdJMUlZWBaLJnNoQZ3RC9dimLYia75QzKmVMjJzU?=
 =?us-ascii?Q?KV59IOOMQmbEP00B4AB3Tgn8AKn/trBmAIjR+0gZTY+yBzVB5xen6hHZzSKq?=
 =?us-ascii?Q?i1wfWlSY8QHQjBElBh1HSbPAaN3IQc81g4e7uj2yRSf2PA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <52EE2AFA2115CA45B179C4EFCDCB3A77@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM4PR0401MB2308.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f7cead5-adff-40d0-a5a7-08d9898bc65a
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Oct 2021 12:12:46.9405
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h8VvNVv4NrWiOSA815NLHtiopf7AnuORHXhIOPYxRD8UYu/hPAn8jSVZu8LRd2E+IzMI1u/2t+sRUmttcNoDCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8209
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 07, 2021 at 09:47:20AM +0300, Ioana Ciornei wrote:
> On Wed, Oct 06, 2021 at 05:24:18PM -0700, Jakub Kicinski wrote:
> > On Wed,  6 Oct 2021 23:13:07 +0300 Ioana Ciornei wrote:
> > > This is just a preparation patch for software TSO in the enetc driver=
.
> > > Unfortunately, ENETC does not support Tx checksum offload which would
> > > normally render TSO, even software, impossible.
> > >=20
> > > Declare NETIF_F_IP_CSUM as part of the feature set and do it at drive=
r
> > > level using skb_csum_hwoffload_help() so that we can move forward and
> > > also add support for TSO in the next patch.
> > >=20
> > > Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> >=20
> > Did you choose NETIF_F_IP_CSUM intentionally?
> > It'll only support IPv4, and since you always fall back to SW
> > I'd think NETIF_F_HW_CSUM makes more sense.
>=20
> Somewhat intentionally, yes.
>=20
> If I would use NETIF_F_HW_CSUM, as I understand it, the GSO path, added
> in the next patch, would have to compute the checksum not only for IPv6
> but also for any other protocols other than UDP and TCP (which currently
> it supports).
> I just didn't look into that at the moment.
>=20

Now that I think of it, you have a point with declaring NETIF_F_HW_CSUM.

In the non-GSO case, skb_checksum_help() will be able to handle anything
that we throw at it.

On the GSO case, only skbs with TCP over IPv4 or IPv6 (depending on what
we declare in the features - TSO/TSO6) will be received - which the csum
code can handle.

Anyhow, I'll change this to use NETIF_F_HW_CSUM instead of
NETIF_F_IP_CSUM and I'll also look into IPv6 for the TSO part.

Thanks,
Ioana=
