Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BC843F1CD0
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 17:31:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239964AbhHSPcD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 11:32:03 -0400
Received: from mail-eopbgr140040.outbound.protection.outlook.com ([40.107.14.40]:63362
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238643AbhHSPcC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Aug 2021 11:32:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=COYY2a1lMu68OUXvfuHy/fwYdCCDlZraICQWZ3PHXN2AlktiNaQyim7NcISAZLxwQKdsJPvCCBWA0/pduvVEhKZLzKP3NQ+Vi/bxEz5fcPHjdSrifr39TVzU/063sNVRo0xfl0NBt9siAuoWHjKi00sn3q2m8H3G75ZKCmrEVaq+bSOhU/HL1dVf9EbDctUKJdUj2i/E1a/BhW5Zgch362vqikYoe637NnowXsZox035GG8UnHAbOhIfKmko/E8mDU2fY33UFQX+09QoWcY/PWYILCUsxki3wtFdGnEuAsJ374IbC9mWRCcjoLKu5M8y5kmB8ARm6FDLwJIt/QK0ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5pZlwd/oWqVS0or85IJLCRASvVdKycMrRD0ThFWGIoM=;
 b=fao/YW63TVBWWu07VKuLWHHRgPoNrE5sg3fdlhlNfnSooVbG+z2DlGZoG+8wFqpUMQ8Y2V4Qppxcfejur/Q2qqWrNtiCH5INIzZvyLuH/qDDqKYCc/TEtCyF//Sg2bBJ/a56mmvRZZKxxjCV4jroVz4k9sHcR2pyscSonESjPTxUoTmJkgCDSRzhkuc5BajZ4mKWJlyR92t67oxm0vG/CtkREIVgKKBc9gR1bkjRlsWmKW+WQOio/q3rVhuJeRT64xgB1g800gTCo6K0PIXocwofl2SvT9nh/xWpDzLmx4tqgg9VvVndMMeCSVEffMs4zQ8xB0tPf1Z9g0ugrnk/lQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5pZlwd/oWqVS0or85IJLCRASvVdKycMrRD0ThFWGIoM=;
 b=NJTo7cuMRbcuiUg0B+ba9+btr7TRnTMrtqMxgO2P3YumfOiuUL3L/8niI6+sTwupyRGtxX+6wnbm2kY956nOVvzohFdYuchOox39tCDy29czTShNl6slTU1V/XCI2nPq65ib4WjXJMKZFuBy7J+Mn+Ate5pw/R3LRyefypoabwQ=
Received: from AM4PR0401MB2308.eurprd04.prod.outlook.com
 (2603:10a6:200:4f::13) by AM9PR04MB8193.eurprd04.prod.outlook.com
 (2603:10a6:20b:3ea::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Thu, 19 Aug
 2021 15:31:24 +0000
Received: from AM4PR0401MB2308.eurprd04.prod.outlook.com
 ([fe80::99d8:bc8c:537a:2601]) by AM4PR0401MB2308.eurprd04.prod.outlook.com
 ([fe80::99d8:bc8c:537a:2601%3]) with mapi id 15.20.4415.024; Thu, 19 Aug 2021
 15:31:24 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next 1/2] net: dpaa2-switch: phylink_disconnect_phy
 needs rtnl_lock
Thread-Topic: [PATCH net-next 1/2] net: dpaa2-switch: phylink_disconnect_phy
 needs rtnl_lock
Thread-Index: AQHXlQgpvLx8/I1O7Uuo1tdxfbA31qt69HeA
Date:   Thu, 19 Aug 2021 15:31:23 +0000
Message-ID: <20210819153123.unbhiqlhyeekf42s@skbuf>
References: <20210819144019.2013052-1-vladimir.oltean@nxp.com>
 <20210819144019.2013052-2-vladimir.oltean@nxp.com>
In-Reply-To: <20210819144019.2013052-2-vladimir.oltean@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fc803632-f9a6-48e3-1dc7-08d963266734
x-ms-traffictypediagnostic: AM9PR04MB8193:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM9PR04MB8193B16FEB5460478C8FE6FEE0C09@AM9PR04MB8193.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +GvhcFTcSYTL4SpG0MRL4E7xpxbgYQ6350EeVo6pgu4ChqJliU9WVhCj4epQvNxaKco7bp9kuVd22hjC8HIU4iWGK1xrJ7kvoDIWfnvA4jFl56uqotQ3Ttw+UqI4GGPvSVAQWVGHsIcXDDfMNLRwjZXzmXtxm5yAg6DyF1WozPgK3IW+yG6fxgzKhGI7g9zMgMqq9d7bbYvzd3XOYW2Zjrm0llPA5oZcv+CFgwyITwPyJc4iuRV4xcz6PfeTWNhM3f2pFzhYKGYnVHCITXZWpflYpTufv+wg19Vz46lN8Zj03bU5Jgk7k7R/F36OBs664ceY2D6bdQPAkv5D1r7pjt3A2qDR6uibOPfJyujy2acynXEv85qX9Ha27/3b+mOssS/7ORF+rgpUprMgbl3tt1Pxf/f8m9oPP2mWZY81Tube5MjH6QkMZ6sCZZ1e1FryfgoOGL/YP1UL5a2X3cCxwM2gOurTH85bQUNbjxVpz1+qfzm286CCt7DcVVd7gjJqvRjpkFscCDgZjajaLHAG9p6F066SQmnK/UAiEuqeuax8SQVr9bTf7hORyzd2keAjvVosVPnmhw+m5p5MJWVhekOdQ4zG9RnXVztKiUI5P+VQzwq+y1PCwMtcj35261QgFFQlePW8jojmrkgC2tCTDPmQaRXr+3PVGsIZDTbCw8vE2kwvU3w/boosrz5JwBK0z2ei0KP2W37w540rXz6b8A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM4PR0401MB2308.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(396003)(346002)(136003)(366004)(39850400004)(376002)(478600001)(66556008)(66476007)(8676002)(76116006)(186003)(2906002)(26005)(66946007)(54906003)(9686003)(6506007)(6636002)(71200400001)(38070700005)(66446008)(5660300002)(33716001)(122000001)(38100700002)(6512007)(44832011)(64756008)(6486002)(316002)(1076003)(6862004)(86362001)(8936002)(4326008)(4744005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?2QIeoXhK1v11OIbeIH4bTRBuySLcj3a0SAnwmlaLhaMTn5KrMfNHgqaS29gH?=
 =?us-ascii?Q?FNCJ0VdGvfKFNpZlFTjWHxndAFLa8bJndQItPPmc3qhTPQn35V1ft3JHGWt3?=
 =?us-ascii?Q?iUco6BBDnv7cMYH1+nTgv+JIYzzOe+hjDRHpxS/THk5hazlF2rVbS8EWuyX7?=
 =?us-ascii?Q?LPDNy8Nb7mKICjdm0tzWc01v3UZJJj31VnFDibGTShazBqFva4wj2RmEUvF6?=
 =?us-ascii?Q?jAV8k8JuJPxho8RgH0xcqzNVdSawSxFOQdMBXm83TERXrDEwEEqP8NhW67nO?=
 =?us-ascii?Q?M4l6nmNEfWUBT0XfdzJMQGSWdWZcyE1APkUphzIT6npGKvSn4Bt3RXm2/Cri?=
 =?us-ascii?Q?Jx12VBlJ1aMWjg191yoj7FeS5j43oyR0Hgd1AK1oVu/Hw1uOj4Z+PDk1QINI?=
 =?us-ascii?Q?/O/orepLfYuSkfVVAIPUF9Pln4iLQP+hGrCakTWb8KlbM6Wk7pU1ZANiygD0?=
 =?us-ascii?Q?d0M4s6BJT1Zip5k1E6BuAuDdbqYFXeYSlwcfOlBAZJ4updQjiSjhsWXvJ1Uv?=
 =?us-ascii?Q?V4VrSDJ1dvAabE7QP4Mta+oFEAt7+l6fn5jtQSOjMKXA3j8baw3PHTX0vO+X?=
 =?us-ascii?Q?h8YmIP4IiEhrQLEpeBPHpuacyu6ILIdqWp3kabeGuEmbS4flP3v22xyUi82k?=
 =?us-ascii?Q?00RcNdphlo4kNvZz5u20NPiRQY4zJq6V1UXd5FFcU+zUN2VR4TWQShnpkB21?=
 =?us-ascii?Q?IbggGnddln9lLcvwCrhS7X3zb1ebIaTrUSke5DwRksYjJ9AiCgDCP+w5tgoB?=
 =?us-ascii?Q?dyrFMe+Q04AxPk1dtveAiBb5kyb8geUKVBi5JFbuk88DKhZnOimv6Nll9MpA?=
 =?us-ascii?Q?ol6XBCPeytovHNCb57lVfZgfxpngDlOHTJDPewgNmrcjXt7pEa8swNRNoqOI?=
 =?us-ascii?Q?MjRoTvezGTsObjkUy7GCWW0JDw01m/nAliEJ68asHqNqhvjFn4+Ung+N5Bw9?=
 =?us-ascii?Q?VYky/bQ7uoWb/XwJ7GEfLDuEiYhHUlrwW6F91TYyU+JIO3b+UWmj82bw5ECF?=
 =?us-ascii?Q?clKCZUI2RLmNx2J+rz03lJ2H0Q74ExnPvzjzqtiJ9+sss3MDFs6YG3rvPCuM?=
 =?us-ascii?Q?G/0XjtJjLGP7xwBIzeACWKh8hc2RNneAE0iyYbHLE0kkQ1HA++8bemRJXR64?=
 =?us-ascii?Q?YsHz7VubL7bC/vgAlGaehDm9lYDhn/b7VVZywnJ3ij0NcuH7wavZtQRhhJHU?=
 =?us-ascii?Q?0STr7fZR48WO7/fTyqyiL+xnW2Q/07OEssE1QO/e5N3twUJplI6BpUGLN5c3?=
 =?us-ascii?Q?tcqU4o2eIhYPB2/Mn7GqgdZWJTjEfHGdvJMa8Ac6uniFHbsXd8acH04jkw8F?=
 =?us-ascii?Q?M8SeTRAX1e3Gt7k80twc4IjF?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D08F8F04819C1A409AC86A3DA10DD935@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM4PR0401MB2308.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc803632-f9a6-48e3-1dc7-08d963266734
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2021 15:31:23.9912
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: K/4Gn3yPAfr42BxcKDFewMrp2DKjzl7g96WP3682H74DkU/xaBKLj41EPM6zUXOlUYgldBHO80esw+ecq7rNSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8193
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 19, 2021 at 05:40:18PM +0300, Vladimir Oltean wrote:
> There is an ASSERT_RTNL in phylink_disconnect_phy which triggers
> whenever dpaa2_switch_port_disconnect_mac is called.
>=20
> To follow the pattern established by dpaa2_eth_disconnect_mac, take the
> rtnl_mutex every time we call dpaa2_switch_port_disconnect_mac.
>=20
> Fixes: 84cba72956fd ("dpaa2-switch: integrate the MAC endpoint support")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Ioana Ciornei <ioana.ciornei@nxp.com>
