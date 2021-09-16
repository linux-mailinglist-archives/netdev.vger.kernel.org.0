Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C07D640D8EF
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 13:39:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237898AbhIPLkk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 07:40:40 -0400
Received: from mail-eopbgr80051.outbound.protection.outlook.com ([40.107.8.51]:48966
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237526AbhIPLki (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Sep 2021 07:40:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PDBTfgANy+5NU0I7rerYGhNsoKoo+oQ5ARv4ljeLrx+dhB/hhS4rHh61qjomb1jK3PrD1Gqcmoj3Q3LWIPKB3fc0Ms3MgG74war42BwxYvFvlwi8YNmqeZDOFsUzAprNS12BDKCvtWeYLHf1hg65U5xF5FG+Ede3TkdXCRzu9p1hs7LvzmdiFaB0PwpFFvQAB88ULGix40zI/CI5j3ln1wzXJgY9qW0ZyWUAfbEXR+rzNDyexNjVgYoCMDAJZ+Oi/OYUMHlWDcHIMNBFGd7ZZ/AHwFa+Pch3zdCQKPjH85WmwSsD7dQ/VV/aiMlmFm/zpp4erVm1Y5URfkyR2BDtCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=UWFZtDPVNj8juU6TIgvp7roroPOrWVPxUv+RP6EU8JE=;
 b=nfDepyOPxF0lfc/AhGvE11GyFnhs04oIQxEwFlKTV/c1GSSNrBS3gRthzqVwEqKbU7JFza1SUgSni5Uyl6iIUea4UMw6ZcM0us9FitBKKbBFwJGd8mkdOZ7g3CL20U+zP3q5R9cczJIqNWQjleJ2gHBUrpIYgNX4TNQ0lNEGEO27V8+4cBz7x1JLvMkzgPhO8uJt+oP3Ll2rNgrUzwjLOoudA0TofijhxU8lfAqi+kNb8kwIHCzkqp+y82MDAC71BIe7p1QSkb13pkIQLo8ZWHtIC0pkE9DUZ1GSJaPHAXPXaOJ3SNfXnDxw05e3rRFXC3VFs7intx6GvqRu2MzgEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UWFZtDPVNj8juU6TIgvp7roroPOrWVPxUv+RP6EU8JE=;
 b=Zy+diYD1PAfu7A1TyKJoL5+fRIuqjTwFljBM+yg9SI7MD6jT64nFhVM23xtSoOwak+B9hUo9Lgg4NS/8TtbcR8Vu/vqDmD0g9/J26ENGYXFAtg77jGDURwaVaKZ6uttcIvalBWBcZ0gY7K1THrDO0MVG9KjdR6Wwgh9giPGGhfY=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5344.eurprd04.prod.outlook.com (2603:10a6:803:4b::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.18; Thu, 16 Sep
 2021 11:39:15 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4500.019; Thu, 16 Sep 2021
 11:39:15 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
CC:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 net] net: mscc: ocelot: remove buggy duplicate write to
 DEV_CLOCK_CFG
Thread-Topic: [PATCH v1 net] net: mscc: ocelot: remove buggy duplicate write
 to DEV_CLOCK_CFG
Thread-Index: AQHXqpmLU5hIUf81/UamU4A4Gp46daumib8A
Date:   Thu, 16 Sep 2021 11:39:15 +0000
Message-ID: <20210916113914.3mgy3jkwsfiqyg5f@skbuf>
References: <20210916012341.518512-1-colin.foster@in-advantage.com>
In-Reply-To: <20210916012341.518512-1-colin.foster@in-advantage.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: in-advantage.com; dkim=none (message not signed)
 header.d=none;in-advantage.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1818ba5a-fca9-42b1-8248-08d979069c76
x-ms-traffictypediagnostic: VI1PR04MB5344:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB5344EDDA1EC67757C043AE76E0DC9@VI1PR04MB5344.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dtcn9jsjDtUdRY0AqRCTL38TU6S36wDx7J2ge1nRCZNxUnExb2EfKoaxg7hG4+8L/1BuNujYsQ+Z63RKI4gs9e7AsCDD9swaT4J/u8t8hYmraZOE/MIw2iw7ugyWtCqHNjXwxAo9aUdnBxg8FYCebsQL4QvKhpwPEOKAMeqrFnaXaJ1BNC1CuF6xTNb+yEafD+8rsdiCN+1TJYZ/i8xJ/unutQxllTFsrxdtHzPqxxbR8J0jLtdcOVdpTZyxdxLtxnb4LQZwX7btGYtQXTsOOf+7EYJtnEBZDF3rTDk/8my9i0blHbx1CbkvulJlDwhdkStFKCUQnd36vFFvyzRL+2nY2HMLL03tQF44uWI4MnsAKGaDx5muvAjyo9S8PuAqAs53zABVP/3UQvn6KzZYN9xq1SwkqSGgpzdcWurxg2hjqMcrb53ejYZzx3kZ/bYuVwQngsV1gzI1bQTHleMQ/4RMGK1vCT9k65vbGxIW3yyfq+XNpr7j5xy+BFxdyn/RRgfLsXY6u0AnaySCXoFN1nEEH0KEFoqTvTEK+EQyG1o4EbmJD7CeJr5kNrCEO/aEiDa8QfDX33n3XMFE6VCu4NCeNB0b7qpDFO0fdr2yqhbL7ix4nxs+9pxVIioyeQjENFwjlBkqaGv3Xg1Y4ONzuI6AzwhB5IOnmWkD0PpeeMkmT/Rl0tXNZV7MtQErdv/PifgHiCS2kwn5DiKwzNg6DQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(346002)(39860400002)(366004)(136003)(396003)(376002)(2906002)(54906003)(26005)(4326008)(4744005)(6486002)(66446008)(38070700005)(91956017)(478600001)(6916009)(76116006)(71200400001)(44832011)(1076003)(316002)(83380400001)(38100700002)(8676002)(122000001)(186003)(6506007)(66476007)(64756008)(66556008)(5660300002)(66946007)(8936002)(33716001)(6512007)(86362001)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?J0sHPq1Os8wbt1H8U3AoXKQwfpGoZCnSFAN95qGCUrmU6IdE/9hHEqCwmlaT?=
 =?us-ascii?Q?D+itWDAiY0nRiHyb+MNJa6A36Ush3Kmo2ib+OFU1IROGFiEKpKxN8pvI5YAt?=
 =?us-ascii?Q?xLC91nLrYWG3C6RMxAl3D7B9NFEFhcC3dBtdRm9sUmIjgOcO5cjD+2Ldp4Fg?=
 =?us-ascii?Q?jVvLgOa3v42xURMR0FMrpymAu34KFKxn21IOibOU6CAoJ2h460/whG7aCHNN?=
 =?us-ascii?Q?qsP3da+Dg80MUS9eXP+zqn03lD6mpGR65gmXgwcZGUINQK8qOrfbz8tL3b3f?=
 =?us-ascii?Q?MSc00ZXlPJwMJemSDsgNa76adYONg+8mspX92JA3IE6dG9TxV7K4boWMT1Js?=
 =?us-ascii?Q?Pk8ah4mRwrkfOXT/Jz1JXwrR0GdjMXmobpyUFiMdU/co/oJXXqIswoS9JIuG?=
 =?us-ascii?Q?p8uQ7/H3w3vWC9BDPj4LbuCPxrmdrzzMhbCN/QUOfLrbJLhlnAhSfoiBATWX?=
 =?us-ascii?Q?q3CGa8TAlG4PbaIr0exbuSWcxk197QzfwDalfXmNptxdkCPOlH5d4Ke/fKRN?=
 =?us-ascii?Q?J+jV+XcKY+S7nYd4vnTpFenXBopVr0LZQuZuFdTcpX1NxoV56CbA0Bs3wEBn?=
 =?us-ascii?Q?SspRuKhSThgulNn1GzRw0hlRdV7Z2T6+K6DrC9U/kS0Mvk3doFsFkdP8DAcc?=
 =?us-ascii?Q?hYCOf7jCyABf/tjbKjfBuy68eTrRApyHgnPPuq4tDPsoD5NaMNGN5Lg11P9w?=
 =?us-ascii?Q?IUy5aPWXox6/0RwLiOFwujaKSUpgfHnALEXh/D3iCrN2tCPCCR0mIX/G+Man?=
 =?us-ascii?Q?ayAswQVGp9xrRKwElF26fzCvL2EqEe7GLTufq0ILoA4XhYAiphM3YAtpR8Ha?=
 =?us-ascii?Q?4puubZDvTwb5uLk9seA5cXkWXSI+/iXaTe/U+66dEE8nXMQ5EektkcvY/L67?=
 =?us-ascii?Q?HbZoNsO0jtAHTfcMMjL3fh/kX2G1lKbYPPlIiKKkYhEE5GWQu1HfKkrM/E/J?=
 =?us-ascii?Q?Ca+hCHv3ypROy8+5n8iOMBVAe2zozE71bgfugTciTT5wSynOj7YzbnZxW63M?=
 =?us-ascii?Q?bUJDT/QRUB9So0PxOKpXnshHHhkpEabS9/Fa7Cna4pT7wf2Na641ckKTHneu?=
 =?us-ascii?Q?WlXxAHe9FNIyXOZWqvL6kgLzDosKn1WtTFweVoiIg71Lm64Ez9AM5oP4WV2p?=
 =?us-ascii?Q?tTK3cbAvWfm+o4RXqrKYcuKOzmh74YH3Mdf+0VdVeYQtz6MHO7eA/Qsg2JUX?=
 =?us-ascii?Q?N8kgOv/9bwfdwMVSHscaLNi9ifunU1eblqx8xI+knYDJ/lOAZG1ypoktEwi4?=
 =?us-ascii?Q?HybT24HedA4MXwBy2V3VWJHncG6YFINvgvL+M83PCF2M7+Etnaat48E5Nw0R?=
 =?us-ascii?Q?I5C01TEfH2x0i1l5KAPqcO/S?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <CD85596B90984A4289A448A6A2A8CFBD@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1818ba5a-fca9-42b1-8248-08d979069c76
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Sep 2021 11:39:15.0313
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uLCbkA6ogmeuBJAyWqbus/fGl0t5SFR/p0RVOyrtJHdMOR4ygIJKEQ5mgXzCAq10iPqyC+O38fm5bOcXixsAWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5344
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 15, 2021 at 06:23:40PM -0700, Colin Foster wrote:
> When updating ocelot to use phylink, a second write to DEV_CLOCK_CFG was
> mistakenly left in. It used the variable "speed" which, previously, would
> would have been assigned a value of OCELOT_SPEED_1000. In phylink the
> variable is be SPEED_1000, which is invalid for the
> DEV_CLOCK_LINK_SPEED macro. Removing it as unnecessary and buggy.
>=20
> Fixes: e6e12df625f2 ("net: mscc: ocelot: convert to phylink")
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>=
