Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E809A46007E
	for <lists+netdev@lfdr.de>; Sat, 27 Nov 2021 18:25:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355702AbhK0R2T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Nov 2021 12:28:19 -0500
Received: from mail-db8eur05on2088.outbound.protection.outlook.com ([40.107.20.88]:58881
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238413AbhK0R0T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 27 Nov 2021 12:26:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LdG3P123dk/mSrxGQvkpDcugeCvxB1OCqowA/kC4IjgHTgW2QpcV7Clo3PSG7M3rQhgkTC+WABEkOgBa5pSOf0D171q+MpBs4n9po12hQV1YVlb9MPMjozTdRHed9OIdGq9ZqcuWqiBRKIUHuGaE6k7XievJedsBua512iWLt5FoODM0BjGm1WyDYpM4OteEfnhPqKSluvjuFrE/Nxle4KLX38DplfGtzAFthiay6tRzkl6p2vZ0AbLiBsHr+CcKfKgD48aeLwUvTlm9+T7zTLwNjfFKYjCXNlGuLRTvZbR9myTbMeyjsEWtfrZtDvj6adV7hEkYM7uxpssbQbL84A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eDkJz8OcfFMuFbYE5rUScjvOHqQ88CWZg0hYRF/E8UU=;
 b=nCffmk2neDdsa72k7250b2lWXuZs5Aci19yV52h8cPQu5XP6abz84eHtrTLL/GY5VTu0DxP7MSAbi+qp6qCvhwJlT+TvEXw/+qEweL4vvsYWgqmSItaNkaSNB8iRFGlr8Qm4ZMni6EWAkmCC0sUAVj/Rx+OCfqwE+9C3jIAvmgKDL9wBaspBTgUF15kHS+A+RQVvEZnaHFdJj9y+TZtJPMZ+TTsmhhchsTghZO0deiBLbAleB9qNBJd6Ma7jEMJjfeKMduLhbvZNxfUR5zlyMwOSnXIZLKczQ7N/+LsgVUQJb1ygdoDSlrufb9sxTG0lX/LYMZNChz3gmKSmlk6lPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eDkJz8OcfFMuFbYE5rUScjvOHqQ88CWZg0hYRF/E8UU=;
 b=psygbgIzKDxfeAv75RxJkVr8LmiUF+f+jcZHE+y4BaJL+qNZnD+6hWn8Y1EMNjayegmEUvGlc4B8JPUSj9zP8THaGRvFjeQZ3aPUyW11eAS5ftMorgJndlOh5p53eb4lRNHNw948z4lUf2pe9EUD8sQ8gWZiRpl3gopi62+UNLE=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2687.eurprd04.prod.outlook.com (2603:10a6:800:57::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Sat, 27 Nov
 2021 17:23:02 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5%7]) with mapi id 15.20.4734.023; Sat, 27 Nov 2021
 17:23:02 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH v2 net-next 1/3] net: mdio: mscc-miim: convert to a regmap
 implementation
Thread-Topic: [PATCH v2 net-next 1/3] net: mdio: mscc-miim: convert to a
 regmap implementation
Thread-Index: AQHX4jjjqovHHY7r8ECfqDkx0DCClKwXommA
Date:   Sat, 27 Nov 2021 17:23:02 +0000
Message-ID: <20211127172301.5uf5six72smdoxax@skbuf>
References: <20211125201301.3748513-1-colin.foster@in-advantage.com>
 <20211125201301.3748513-2-colin.foster@in-advantage.com>
In-Reply-To: <20211125201301.3748513-2-colin.foster@in-advantage.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b2a6ba32-47a4-47c5-dc31-08d9b1ca9119
x-ms-traffictypediagnostic: VI1PR0401MB2687:
x-microsoft-antispam-prvs: <VI1PR0401MB26871B905BB2AC840D6B2B4EE0649@VI1PR0401MB2687.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jWDvM+22ydwkcOhUSOR1Ukksn9iHZtEg/CPzp9Afc2rWCw4c9w6BhPfc4alh/d4j++37TET06maLW5TfpytYzSYMlRQJoRDgJCX/UhYLhCzczzNfIGi0GaWhS7MlKngW6zG2QiaCd2huvWavQ9Wz19tg4LBG/UlE0JK+LDjAlnmp+62JcXP6ISPzGnd7y3VHjRxxCBreqcVoJLr46YwF/iVZyGLwcyfDrjKNKJ7+GFRM8S+VjR/7HZtbPa6egBkp8JxVxnmYKF/idgykIIVzuIgbIXrv+SuHtch94tGsupW5DD9T/5mLuf3+u/hyWDmSyrLB1hgxNv8JYg1BW6SqYhM0Fwals7S0d00gCwnQbYV4KNL7fyVJNKNXMVKrDqsWH/nF1VsN1C5V0v40qrhBnEHHBo/Gbcx4Bo0O+6DY9iLI3z1Qs5MLjUBiuPczQsVJp8YwJN507i/Vc8PbFuAQ05Y3GOwq1fs0U7QeAJHnUwXUAq8pwLJMdl5XqaVJgAWXSKQTR9jlM4StJw7z5rDFRThsf7XBl0Qc8zaHIPlk6gwTMi/pT48q659am46/RmW8kwzq6/JMNXjX3AqmEY0ejjF+iYxWfyGxfTsIe+HsR9kObUmfSC0fgBol7c+/YvGH9PGJhwbOPKfumkvB+uF7yNN/2y6BJFbfaQ9CRVAH+C3eiOoq+hStFPMU+ML+sBAhNegMCYOXflMtJN5B3MHCjg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(71200400001)(1076003)(4326008)(33716001)(8676002)(76116006)(86362001)(186003)(26005)(2906002)(38070700005)(508600001)(6512007)(316002)(8936002)(6486002)(7416002)(122000001)(54906003)(5660300002)(66946007)(66446008)(83380400001)(9686003)(66476007)(64756008)(66556008)(6916009)(6506007)(558084003)(38100700002)(91956017)(44832011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?1jlAIhnbqLRY7n4CqAm/VwLPeUEVp8kjSE/yWKAww0TKlSXcg+yLWeVSVjmH?=
 =?us-ascii?Q?n32SI6ekliSupiM6Hvn8sBBIT3nQ27ge9//Te/PgvZFdo8fI0iF6Euk3AvG3?=
 =?us-ascii?Q?iVtg+CVmAStcHfMKAmA9AuSQGBdjm/rs/oUJxc/984fFo507QKGerwiMw7v4?=
 =?us-ascii?Q?2Rq607llNpdaDa6fJMz5Ld4D0cZoxEbfdBb1pBbZZLYA22ezAS3x2oNGcjxG?=
 =?us-ascii?Q?NbCKTVKY6Hn2oeCiFlvmry+VAbMllxtQMrT5hfR6gxpFzFudYXKXUMnyJhb+?=
 =?us-ascii?Q?s0yk87/zJux9H1bc9IT8P+QICT7mt2UbRmrp5Xy0HrGs/ZLBHoMoMDG9fasy?=
 =?us-ascii?Q?gYcU7h5fKBZxkS04k7BVSBFV+JwApFoBdgp4v095TDuALF1kG14OB/S1lWeD?=
 =?us-ascii?Q?uetjtsG1ROLyQTTBMQ4xux8Aobtj780lKcAJgfqkRbUZk7237jjwdacoR05c?=
 =?us-ascii?Q?pqQIenXCQM2TaAnMLGZW5Ta/pyStN0rqB9hvu+CnZLysinubycrYv23a9v/h?=
 =?us-ascii?Q?LtOJdjRTWU+mNlQ6HxLsVHNA2jx0phIZh4hBaNRIyCVe43oZQEoUnRr42eWo?=
 =?us-ascii?Q?eTVGlYaBuj/cTAu5v+W1ABh+gwRjwfWzKy8L/X/yIe/ut2wZW/009isT1NVD?=
 =?us-ascii?Q?c/XeVC2xKSwevvUlS99RZUes02gzxudymycUWQWhu3g1KlE5yammDNF1AH3r?=
 =?us-ascii?Q?atajy2+geZwYvUmzBUm3Z6aoITtgrG5rCprtzv7G+XZHXIPAP8mHypIv+Qd6?=
 =?us-ascii?Q?/aLpfB63bsclUzjjD+hEL8EbkNvtsC4kVqTcFlwbj3TNVgDD7NHd/bZw+rAV?=
 =?us-ascii?Q?crzFp4y8Z2TiKiCsBQI9MkPo16AvmKby5dI/u4nNLIwGw6rDsEbjGcPH3suW?=
 =?us-ascii?Q?LZsFdLePG+3xw+obZhBf17cjYZTuaPRpmdtnMLGHRW8MR8bL0HYjVwmXtqiI?=
 =?us-ascii?Q?5OSSbEzriPqTFzQrcOZy5MpiI35quFEGHhS/t++zpdv86mQyY0Lq75Knt9UE?=
 =?us-ascii?Q?4IFlIq4Tqq8xBhlaWyLi+gWabFqA94xtdQgIHWlbhqIrvGRJXKF8036oPTHt?=
 =?us-ascii?Q?pXsNIdCGToEOUT3WUcv7dy7q+1R9Eca52G+rZ16bj65OK5+a8Ou+AA1d9d2i?=
 =?us-ascii?Q?f8FjxcwVg1k6nI14I3YmmjqE3M7C22w8EibjqVnWiXoS1i/UdnzXu1h/bvPk?=
 =?us-ascii?Q?f0c5XFu+Z4czZHAYGNNQcQPf6x9DYXZRJFUvc+rnCtycDGedlEBkmV1OgPZ1?=
 =?us-ascii?Q?Bol950m8d03eui5MxQQaoCcOiRT6FJTDYQJQk15bzpB+D+shOu+FrwyisBxy?=
 =?us-ascii?Q?ivaQtXziSgU62G41XyzjGlKaQRUWaLHRG3+13xYAVGvFYQEN0sGi6FRa81t7?=
 =?us-ascii?Q?Y9Kh7ctuK6wHq2Jp0qJB/eYeLjVbS7RNGpiUlh9h7BonP+RbqsjaP5406Rup?=
 =?us-ascii?Q?9mtFXBGUYkk3j3IcewFRwJpZlRLX5Jjp7BaJbUZhY06pYHJi3oNmJ92qMHPc?=
 =?us-ascii?Q?ZlkhfMsncQ0nIqoqDqbzaztRkk4V7NFhK/XHV9XSh0RJGw+dpMXRf1thB/St?=
 =?us-ascii?Q?M//aQ3g0zr+PuDQD51QEVwOdupeUxniejf3wFYmY/yEFdpF9QoYYI6QhpaYC?=
 =?us-ascii?Q?6CSadMZlxBms9DgLjbYbpfM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <40EA63CE04555141992037A30F5D999F@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2a6ba32-47a4-47c5-dc31-08d9b1ca9119
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Nov 2021 17:23:02.4447
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 13A1uYaWRvZVx0ocZudtweNK3//Jx/sQYUB3Ofwx1BDABjjQXuPou0w+G7Mh4qfd59M6iU0V4ORN20idCsOo+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2687
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 25, 2021 at 12:12:59PM -0800, Colin Foster wrote:
> Utilize regmap instead of __iomem to perform indirect mdio access. This
> will allow for custom regmaps to be used by way of the mscc_miim_setup
> function.
>=20
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---

Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>=
