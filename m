Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 886FA468494
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 12:54:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384829AbhLDL5d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 06:57:33 -0500
Received: from mail-vi1eur05on2057.outbound.protection.outlook.com ([40.107.21.57]:60000
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229551AbhLDL5c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 Dec 2021 06:57:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n8yRIr2H7lnw579MdavYlaOm18tS6rSs6I3XwBLq4q51HHFslDFds5410sSvMAYqJP8oUYCsTUh4CaiKT3QQdKvDMU4pZy6JyBm/xCy5HXS1pehwTV5l4am6unW7rwAv7vwjKwT+sbZddMUVfONHE0L+2VTjWLaecxPLn9A03LUBS6C9zruHa8zEoiI+c+d8jguu+j1gknd0k8mJR0jHzIs1eGWRay9I70K9wmzXL2P1/KMostpA32kJkMCZq3ujJl8wDJJaDRIJkTM7yaWa27i4D7adLcOgpieFu8NlSPVpQMEEo3BVgSQs4ernx0UjxKNscXE7D5FWVb6qXcT6kA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bp7fM6ZVdVTFeeJRk+ym1EpkBpagtAU86pyGPPUVLVk=;
 b=kVcuD4E+VqUASpNerKjXQgJEfH7x+6aMi4sg62k6HIU5BAsjPSqvC4N2l5ijL8hAnB2lXJAPL1IDMx/Uim3hmcklBiheVO/B2cqOltm72cRlBdGlG1zQI/GBlnIClQJC1f5lDJLy7qWf4IfJ7nDVgRCIslPqTAi4kyjg+tWiy6fjgW3f1aKO/9MZlCp56dRgvOXXyp3wmLPvCecSFJQT7w0zleihrfnhmJvTHtfcbi2NLq3nQBaawUlAfooeGti8zePLlT8MGEY+gVVJhdqq+LZwGzz7glajuwRtk3qVhXte+oFHJcIREjarvKmTCptJgX/L17Y6rlTnsmb3rzNZVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bp7fM6ZVdVTFeeJRk+ym1EpkBpagtAU86pyGPPUVLVk=;
 b=cIQf7wvi3ABd6iWShiEs7MrU0DDgYRPNdmI9Loy2TzIUlPo5OGOLkWcsoLcfyEXps59L6cx3o3gHk6IYNqQfCmdTmcseD+mysu1h0GVHTg9gmEAd6tRni6W4BUzWzGufWp7Eqjs8CD/QfPFW8Qljt2pM9y/OXPIgNGUmgUQiY1U=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2864.eurprd04.prod.outlook.com (2603:10a6:800:b7::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11; Sat, 4 Dec
 2021 11:54:05 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802%3]) with mapi id 15.20.4755.020; Sat, 4 Dec 2021
 11:54:05 +0000
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
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH v2 net-next 3/5] net: dsa: ocelot: felix: add interface
 for custom regmaps
Thread-Topic: [PATCH v2 net-next 3/5] net: dsa: ocelot: felix: add interface
 for custom regmaps
Thread-Index: AQHX6KptRgdw4V63I0WufJCfp5xaz6wiOfAA
Date:   Sat, 4 Dec 2021 11:54:04 +0000
Message-ID: <20211204115404.kp4ofxzynbukoni7@skbuf>
References: <20211204010050.1013718-1-colin.foster@in-advantage.com>
 <20211204010050.1013718-4-colin.foster@in-advantage.com>
In-Reply-To: <20211204010050.1013718-4-colin.foster@in-advantage.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e5f8e757-7e88-40c6-d066-08d9b71cc584
x-ms-traffictypediagnostic: VI1PR0402MB2864:
x-microsoft-antispam-prvs: <VI1PR0402MB28641269BB38D845786BE7CBE06B9@VI1PR0402MB2864.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2803;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kMW79ERfHMSstXshfSTEh3fLpUYGxjTnL2Iq8VZYDm4Wt9THG+cbjTSd2virxlyfI/ZFECLDocjyiEgiJveZ0ceVvYClg7HvjEc1PlKgIbu2wyNHU8FOhwPdb+4qMg2TPK2xVJVhbQVE0psN7x+BdQaKn06aBCIPr9KTWVo1mLIhDpbwkvLDq0BMT0p+cZCN8KL3H+JZAsfnsc8au11D2+20s7giC0BiJ+1Ti1mFkcbiRwVQEiLvCGGZQqmGRuyvcqYCg1BnG3Rcl9TH8xgw479Jcd/ARpzxZstRatGrg+9H6SQVUdKc3hIkZ1dqgBa0NVVHYD1Qtl2v+w0tz3b4muylPIbkYgRR5R7AGclDpfKcBvH66gJ3RKCWkAtH2bSdRyPoLTHhm7xPtCnW0VCa1mnxw3JQn1gUfYbDsnjmzHjeTd6AtFI9Gr9Dhr3fUdqwR+RsiOcr7wM/YaWiNDea6QsJnscyc68CPyTL5plV3yRVlLZKkeVrBRkeZP3yLilk3axsDVzahrxW3mgQo/Z5fbMBbObD7FN/bDXDSxVKo9jRQFPUzomqdSuLDQHn1z//hkwQ6AnZOx73VBez08lnzmtGQrZCLSC+VrRSWxuBeSZPDveGuOch/ba3+SahJ8uNRsSXtGCH+jNv7Ls4FnKD1m5eaG8zVGmrV2lDDdV+AnlxGBhwXYf8kyVrVnU2hcsNvfK/ivQLWl78WG/PmgLNnA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(33716001)(76116006)(66946007)(316002)(91956017)(9686003)(66476007)(66446008)(64756008)(66556008)(26005)(6506007)(6512007)(44832011)(186003)(8936002)(8676002)(6486002)(508600001)(54906003)(1076003)(6916009)(5660300002)(71200400001)(2906002)(4326008)(122000001)(86362001)(7416002)(558084003)(38100700002)(38070700005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Wd81Pb1chu5kIyFL99Po7HV4uFQCnluOfDgKPy5Or78k7Vc5w1fis4f/nZ+8?=
 =?us-ascii?Q?5h063d/zmHFYzXlMNZc3bu/D5LSBF1hqK3bvAt9Zne2EYYeeqvUP3Zgu/HpD?=
 =?us-ascii?Q?kF1UhWqtP4nEGNwL5FshQEpnZjGr1ae1wH7sihXM+URvVhPoQaTmrPUSYqHo?=
 =?us-ascii?Q?4nOsX79fpU4iJlH97IVQEBMqzXZ91hCuLRHp+4NuRv8H6HgQRWEN81zKlmOT?=
 =?us-ascii?Q?JuWKgpTYNGM7rUxDVaePOp617g3QwlvJKK2AXP+0Tal4pwsDnotHegR1FoQl?=
 =?us-ascii?Q?gUYJcVnohsk2mjUMwkb8jVanAnoil1rdDO5/AE9HZByzQsBXGmb19stSIu8X?=
 =?us-ascii?Q?KShqUN2i5onMOm1k3FrMwIRi5O9DD5n6zZx1x1g3LodB3K3Jceb2CoijYqiJ?=
 =?us-ascii?Q?J+IqGYn4rIMHMI6sMwzl/1ULM9iwA6GrqHVW4dZDGhnLyB5euc8SE5VmNeLu?=
 =?us-ascii?Q?Jr8h9tDWDlCgW76Kj/5p8xrE54rxgrhbnYLDPpdHyFlYS7NDhu9h5f9pl1gH?=
 =?us-ascii?Q?1iF6M83SfWVnb4Pv5lajsYSpHQOxhPb/B1zGECeDUA2bIHu5AN21NSMSBcY2?=
 =?us-ascii?Q?oNkfGvZeTQ6TcBPriIbzJLRAgbcHokRvOwCNwi/wZgfoJajCoPcNwf6AMnjD?=
 =?us-ascii?Q?zQMzPcfBCJJbYO1DEr+pYoR2TXR7SnfY0QSNRXN7pN7eZgKUN/6HvzZNqy1A?=
 =?us-ascii?Q?Lu03ku2aCOW5UgGYkdW+AzyRk8qkXf9cWqa442FIHxaB+frXM/Y+XlN+YlSQ?=
 =?us-ascii?Q?dQxX5Z4zSwpmGxQzvDk21oBtQy2jYoVyqMYtifr80fV6NOF5cIYWKeHMnL97?=
 =?us-ascii?Q?vR1BgZZFrE9ucA/fbc5Dx2QCg9et8DktgjZCyYUVU8WqvHL4DGN6UJBh0vFn?=
 =?us-ascii?Q?4Z9PQjierMCWudhHhVxPcjU1IrrAYffD7KL0e7GWwNUwRqav3rqptzaGwHZ3?=
 =?us-ascii?Q?JVvasdoqjN/e2NvpSpM+k4H4VCPd4IwB2YC5mS/EhaRUsfA4dO0AkEIZyrBu?=
 =?us-ascii?Q?ox9owQysEwe7BzfzRF5FzsUcpL4S5FKZgP69oIPhuHUs/hAYTX9eIJsTkdKP?=
 =?us-ascii?Q?bMvWI3R/7UjfoB4OGebUdRRovp4qgVeqdBoTiGcNoAGbgfZaltCanmW7Zo1r?=
 =?us-ascii?Q?GmMAsVvGBim052a6WJQyzWYvV/mVgpIEAyyccKbm51Iv502FoWNsoSdAN3K7?=
 =?us-ascii?Q?CRLTVSuXIzyVHFe4apdAe/vsCofUeiR/ysEDSsku5V1OJCM7jnJwEOL5L+cW?=
 =?us-ascii?Q?Qv77WTVMJJ8S7yfnZj5NFf5TgHWp5wczTHtHPjeTlHvraX/ZAk7h8gtSuPOv?=
 =?us-ascii?Q?rQ1k4A55an12hY35EiNkN2LMjDFkog0d7yPifzFI8LZmcZgdg68wa8S2jTC6?=
 =?us-ascii?Q?IzI/1n0FcAIblwQpqp8O4ZsiefD4b07JuHh/F5ENaQEUtzgJZCqpMTMBWjb2?=
 =?us-ascii?Q?w8hCSBP+yEcpxSJnKhZsMiu2Oyz3HBVryvC23At4EbgudNmrdSWHim1FGV/0?=
 =?us-ascii?Q?ylmVonVQzVou1qR9gfhcatNKSpaHSAC+OqnBjhBt9JQpXoC8lcg1g7wcqbrV?=
 =?us-ascii?Q?aPHeSJjuLKK4JvW/dFHGjoV3k+ftmzj3FKukgzcS8E31EnewNS6kFZTGYkec?=
 =?us-ascii?Q?tHdu8PtLbFp252kxPdj8b5E=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <76F3FBFC5D30F04DB75114AEDC21F659@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5f8e757-7e88-40c6-d066-08d9b71cc584
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2021 11:54:04.8856
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h26gm8PQjlmyfeVbrwQMcQnPDJEXiWSyQ/HqKgRtaqU0LlEOZ9XUbDa+BGDJbNMv9iEYhBZmx6aylGN47mJp0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2864
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 03, 2021 at 05:00:48PM -0800, Colin Foster wrote:
> Add an interface so that non-mmio regmaps can be used
>=20
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>=
